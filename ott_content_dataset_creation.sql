DROP TABLE IF EXISTS SUBSCRIPTIONS CASCADE;
DROP TABLE IF EXISTS RATINGS CASCADE;
DROP TABLE IF EXISTS WATCH_HISTORY CASCADE;
DROP TABLE IF EXISTS CONTENTS CASCADE;
DROP TABLE IF EXISTS USERS CASCADE;
DROP TYPE IF EXISTS content_type CASCADE;
DROP TYPE IF EXISTS subscription_status CASCADE;
 
CREATE TYPE content_type AS ENUM('Movie', 'Series');
CREATE TYPE subscription_status AS ENUM('active', 'expired', 'cancelled');
 
CREATE TABLE USERS (
    user_id           INT PRIMARY KEY,
    name_             VARCHAR(100),
    email             VARCHAR(100),
    age               INT,
    country           VARCHAR(50),
    join_date         DATE,
    subscription_plan VARCHAR(20),
    is_active         BOOLEAN
);
 
CREATE TABLE CONTENTS (
    content_id   INT PRIMARY KEY,
    title        VARCHAR(255),
    type_        content_type,
    genre        VARCHAR(50),
    language_    VARCHAR(30),
    release_year INT,
    duration_min INT,
    age_rating   VARCHAR(10),
    country      VARCHAR(50)
);
 
CREATE TABLE WATCH_HISTORY (
    watch_id        INT PRIMARY KEY,
    user_id         INT,
    content_id      INT,
    watch_date      DATE,
    watch_duration  INT,
    device          VARCHAR(30),
    completion_pct  DECIMAL(5,2),
    FOREIGN KEY (user_id)    REFERENCES USERS(user_id),
    FOREIGN KEY (content_id) REFERENCES CONTENTS(content_id)
);
 
CREATE TABLE RATINGS (
    rating_id  INT PRIMARY KEY,
    user_id    INT,
    content_id INT,
    stars      INT CHECK(stars BETWEEN 1 AND 5),
    review     TEXT,
    rated_on   DATE,
    FOREIGN KEY (user_id)    REFERENCES USERS(user_id),
    FOREIGN KEY (content_id) REFERENCES CONTENTS(content_id)
);
 
CREATE TABLE SUBSCRIPTIONS (
    sub_id         INT PRIMARY KEY,
    user_id        INT,
    plan_type      VARCHAR(20),
    start_date     DATE,
    end_date       DATE,
    monthly_fee    DECIMAL(6,2),
    payment_method VARCHAR(30),
    status         subscription_status,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);
SELECT * FROM USERS;
SELECT * FROM CONTENTS;
SELECT * FROM WATCH_HISTORY;
SELECT * FROM RATINGS;
SELECT * FROM SUBSCRIPTIONS; 
