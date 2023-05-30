// @generated automatically by Diesel CLI.

diesel::table! {
    polls (id) {
        id -> Uuid,
        #[max_length = 255]
        title -> Varchar,
        summary -> Text,
        content -> Text,
        creation_date -> Timestamp,
    }
}
