// @generated automatically by Diesel CLI.

diesel::table! {
    comments (id) {
        id -> Int8,
        poll_id -> Uuid,
        parent_id -> Nullable<Int8>,
        message -> Text,
    }
}

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

diesel::joinable!(comments -> polls (poll_id));

diesel::allow_tables_to_appear_in_same_query!(comments, polls,);
