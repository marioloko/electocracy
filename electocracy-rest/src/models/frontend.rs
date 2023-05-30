use serde::Deserialize;

pub const DEFAULT_LIST_POLL_QUERY_LIMIT: i64 = 10;

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
pub struct ListPollsQuery {
    pub limit: Option<i64>,
}
