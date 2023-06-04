use chrono::NaiveDateTime;
use diesel::{Insertable, Queryable, Selectable};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::schema::{comments, polls};

#[derive(Serialize, Deserialize, Queryable, Selectable, Insertable)]
#[diesel(table_name = polls)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Poll {
    pub id: Uuid,
    pub title: String,
    pub summary: String,
    pub content: String,
    pub creation_date: NaiveDateTime,
}

#[derive(Serialize, Deserialize, Queryable, Selectable)]
#[diesel(table_name = comments)]
#[diesel(belongs_to(Post))]
#[diesel(belongs_to(Comment, foreign_key = parent_id))]
pub struct Comment {
    pub id: i64,
    pub poll_id: Uuid,
    pub parent_id: Option<i64>,
    pub message: String,
}

#[derive(Serialize, Insertable)]
#[diesel(table_name = comments)]
pub struct InsertComment {
    pub poll_id: Uuid,
    pub parent_id: Option<i64>,
    pub message: String,
}
