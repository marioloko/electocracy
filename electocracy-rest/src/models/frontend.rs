use serde::Deserialize;

#[derive(Deserialize)]
pub struct CreatePollRequest {
    pub title: String,
    pub summary: String,
    pub content: String,
}

#[derive(Deserialize)]
pub struct SummarizeRequest {
    pub content: String,
}

#[derive(Deserialize)]
pub struct TitleRequest {
    pub content: String,
}

#[derive(Deserialize)]
pub struct CreateCommentRequest {
    pub parent_id: Option<i64>,
    pub message: String,
}

#[derive(Deserialize)]
pub struct ListCommentsQuery {
    pub parent_id: Option<i64>,
}
