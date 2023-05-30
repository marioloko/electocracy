-- Your SQL goes here
CREATE TABLE polls (
    id UUID PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    summary TEXT NOT NULL,
    content TEXT NOT NULL,
    creation_date TIMESTAMP NOT NULL
)
