use actix_web::{error, web, Result};
use anyhow::anyhow;
use diesel::{QueryDsl, RunQueryDsl, SelectableHelper, ExpressionMethods};
use uuid::Uuid;

use crate::models::backend as back;
use crate::models::frontend as front;
use crate::models::gpt::{GptSummary, GptTitle};
use crate::schema::{comments, polls};
use crate::state::AppState;
use crate::helpers::filter_eq_nullable;

pub async fn summarize(
    app_state: web::Data<AppState>,
    item: web::Json<front::SummarizeRequest>,
) -> Result<web::Json<GptSummary>> {
    let content = &item.content;

    let summary = app_state
        .gpt_client()
        .summarize(content)
        .await
        .map_err(|err| {
            log::error!("Error summarizing content: {err}");
            error::ErrorInternalServerError(err)
        })?;

    Ok(web::Json(summary)) // return the summarized content
}

pub async fn generate_title(
    app_state: web::Data<AppState>,
    item: web::Json<front::TitleRequest>,
) -> Result<web::Json<GptTitle>> {
    let content = &item.content;

    let title = app_state
        .gpt_client()
        .generate_title(content)
        .await
        .map_err(|err| {
            log::error!("Error generating title: {err}");
            error::ErrorInternalServerError(err)
        })?;

    Ok(web::Json(title)) // return the summarized content
}

pub async fn create_poll(
    app_state: web::Data<AppState>,
    poll: web::Json<front::CreatePollRequest>,
) -> Result<web::Json<back::Poll>> {
    let poll = poll.into_inner();
    let title = poll.title;
    let summary = poll.summary;
    let content = poll.content;

    let new_poll = back::Poll {
        id: Uuid::new_v4(),
        title,
        summary,
        content,
        creation_date: chrono::Utc::now().naive_utc(),
    };

    let poll = web::block(move || {
        let mut conn = app_state.get_connection().map_err(|err| {
            log::error!("Error getting connection to store poll: {err}");
            err
        })?;

        diesel::insert_into(polls::table)
            .values(&[new_poll])
            .returning(back::Poll::as_returning())
            .get_result(&mut conn)
            .map_err(|err| {
                log::error!("Error inserting poll into database: {err}");
                anyhow!("Error inserting poll into database: {err}")
            })
    })
    .await?
    .map_err(|err| error::ErrorInternalServerError(err))?;

    Ok(web::Json(poll))
}

pub async fn list_polls(
    app_state: web::Data<AppState>,
) -> Result<web::Json<Vec<back::Poll>>> {
    use crate::schema::polls::dsl;

    let results = web::block(move || {
        let mut conn = app_state.get_connection().map_err(|err| {
            log::error!("Error getting connection to list polls: {err}");
            err
        })?;

        dsl::polls
            .select(back::Poll::as_returning())
            .order_by(dsl::creation_date.desc())
            .load(&mut conn)
            .map_err(|err| {
                log::error!("Error listing polls from database: {err}");
                anyhow!("Error listing polls from database: {err}")
            })
    })
    .await?
    .map_err(|err| error::ErrorInternalServerError(err))?;

    Ok(web::Json(results))
}

pub async fn get_poll(
    app_state: web::Data<AppState>,
    poll_id: web::Path<Uuid>,
) -> Result<web::Json<back::Poll>> {
    use crate::schema::polls::dsl::*;

    let poll_id = poll_id.into_inner();

    let poll = web::block(move || {
        let mut conn = app_state.get_connection().map_err(|err| {
            log::error!("Error getting connection to get poll: {err}");
            err
        })?;

        polls.find(poll_id).first(&mut conn).map_err(|err| {
            log::error!("Error getting poll from database: {err}");
            anyhow!("Error getting poll from database: {err}")
        })
    })
    .await?
    .map_err(|err| error::ErrorInternalServerError(err))?;

    Ok(web::Json(poll))
}

pub async fn create_comment(
    app_state: web::Data<AppState>,
    comment: web::Json<front::CreateCommentRequest>,
    poll_id: web::Path<Uuid>,
) -> Result<web::Json<back::Comment>> {
    let poll_id = poll_id.into_inner();

    let comment = comment.into_inner();
    let parent_id = comment.parent_id;
    let message = comment.message;

    let new_comment = back::InsertComment {
        poll_id,
        parent_id,
        message,
    };

    let comment = web::block(move || {
        let mut conn = app_state.get_connection().map_err(|err| {
            log::error!("Error getting connection to create comment: {err}");
            err
        })?;

        diesel::insert_into(comments::table)
            .values(&[new_comment])
            .get_result::<back::Comment>(&mut conn)
            .map_err(|err| {
                log::error!("Error inserting comment into database: {err}");
                anyhow!("Error inserting comment into database: {err}")
            })
    })
    .await?
    .map_err(|err| error::ErrorInternalServerError(err))?;

    Ok(web::Json(comment))
}

pub async fn list_comments(
    app_state: web::Data<AppState>,
    poll_id: web::Path<Uuid>,
    query: web::Query<front::ListCommentsQuery>,
) -> Result<web::Json<Vec<back::Comment>>> {
    use crate::schema::comments::dsl;

    let poll_id = poll_id.into_inner();

    let query = query.into_inner();
    let parent_id = query.parent_id;

    let results = web::block(move || {
        let mut conn = app_state.get_connection().map_err(|err| {
            log::error!("Error getting connection to list polls: {err}");
            err
        })?;

        let query = dsl::comments
            .filter(dsl::poll_id.eq(poll_id));

        filter_eq_nullable!(query, dsl::parent_id, parent_id)
            .select(back::Comment::as_returning())
            .load(&mut conn)
            .map_err(|err| {
                log::error!("Error listing polls from database: {err}");
                anyhow!("Error listing polls from database: {err}")
            })
    })
    .await?
    .map_err(|err| error::ErrorInternalServerError(err))?;

    Ok(web::Json(results))
}
