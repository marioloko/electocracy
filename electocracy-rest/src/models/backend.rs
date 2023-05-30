use chrono::NaiveDateTime;
use diesel::{Insertable, Queryable, Selectable};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::schema::polls;

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
