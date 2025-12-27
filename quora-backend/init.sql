-- Design a db for a quora like app
-- 	•	User should be able to post a question
-- 	•	User should be able to answer a question
-- 	•	User should be able to comment on an answer
-- 	•	User should be able to comment on a comment
-- 	•	User should be able to like a comment or a question or an answer
-- 	•	User should be able to follow another user
-- 	•	Every question can belong to multiple topics
-- 	•	User can follow a topic also
-- 	•	You should be able to filter out questions based on topic

create table if not EXISTS users(
id SERIAL PRIMARY KEY,
username VARCHAR(20) UNIQUE,
email VARCHAR(20) UNIQUE,
created_at TIMESTAMP
);

create table if not exists questions(
id SERIAL PRIMARY KEY,
title TEXT,
description TEXT,
user_id INT NOT NULL references users(id),
created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP
);

create table if not exists answers(
id SERIAL PRIMARY KEY,
content TEXT,
user_id INT not null references users(id),
question_id INT not null references questions(id),
created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP
);

create table if not exists comments(
id serial PRIMARY KEY,
user_id INT NOT NULL references users(id),
answer_id INT references answers(id),
parent_comment_id INT references comments(id),
body TEXT,
created_at TIMESTAMP default current_timestamp,
check (
(answer_id is NOT NULL AND parent_comment_id is NULL) 
OR
(answer_id is null and parent_comment_id is not NULL)
)
);

create table if not exists likes(
id SERIAL PRIMARY KEY,
user_id INT NOT NULL references users(id),
entity_type varchar(100) NOT NULL CHECK ( entity_type IN ('COMMENT','ANSWER','QUESTION') ),
entity_id INT NOT NULL,
UNIQUE(user_id,entity_type,entity_id)
);

create table if not exists topic(
id SERIAL PRIMARY KEY,
name varchar(100) not null unique
);

create table if not exists question_topic(
id SERIAL PRIMARY KEY,
question_id INT NOT NULL REFERENCES questions(id),
topic_id INT NOT NULL REFERENCES topic(id),
unique(question_id,topic_id)
);

create table if not exists follow_user(
id SERIAL PRIMARY KEY,
follower_id INT NOT NULL references users(id),
followee_id INT NOT NULL references users(id),
created_at TIMESTAMP default CURRENT_TIMESTAMP,
check (follower_id != followee_id )
);

create table if not exists follow_topic(
id SERIAL PRIMARY KEY,
topic_id INT NOT NULL REFERENCES topic(id),
user_id INT NOT NULL references users(id),
created_at TIMESTAMP default current_timestamp,
unique(topic_id,user_id)
);