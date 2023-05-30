use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct GptTitle {
    title: String,
}

#[derive(Serialize, Deserialize)]
pub struct GptSummary {
    summary: String,
}
