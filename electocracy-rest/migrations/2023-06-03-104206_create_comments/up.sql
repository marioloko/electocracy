-- Your SQL goes here
CREATE TABLE comments (
    id BIGSERIAL PRIMARY KEY,
    poll_id UUID NOT NULL,
    parent_id BIGINT,
    message TEXT NOT NULL,
    FOREIGN KEY (poll_id) REFERENCES polls (id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES comments (id) ON DELETE CASCADE
);
