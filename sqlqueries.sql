--  BASIC QUERIES

-- 1. Retrieve the total number of watch sessions recorded.
SELECT
    COUNT(*) AS total_watch_sessions
FROM watch_history;


-- 2. Calculate the total revenue generated from all subscriptions.
SELECT
    ROUND(SUM(monthly_fee), 2) AS total_revenue
FROM subscriptions;


-- 3. Identify the highest-priced subscription plan.
SELECT
    plan_type,
    monthly_fee
FROM subscriptions
ORDER BY monthly_fee DESC
LIMIT 1;


-- 4. Identify the most used device for streaming.
SELECT
    device,
    COUNT(*) AS total_sessions
FROM watch_history
GROUP BY device
ORDER BY total_sessions DESC;


 
-- 5. List the top 5 most watched content titles along with their watch counts.
SELECT
    c.title,
    SUM(w.watch_duration) AS total_watch_duration
FROM watch_history w
    JOIN contents c ON w.content_id = c.content_id
GROUP BY c.title
ORDER BY total_watch_duration DESC
LIMIT 5;

--  INTERMEDIATE QUERIES


-- 1. Join the necessary tables to find the total watch duration (in hours) for each content genre.
SELECT
    c.genre,
    ROUND(SUM(w.watch_duration) / 60.0, 2) AS total_hours_watched
FROM watch_history w
    JOIN contents c ON w.content_id = c.content_id
GROUP BY c.genre
ORDER BY total_hours_watched DESC;


-- 2. Determine the distribution of watch sessions by hour of the day.
SELECT
    EXTRACT(HOUR FROM watch_date::TIMESTAMP) AS hour_of_day,
    COUNT(watch_id) AS total_sessions
FROM watch_history
GROUP BY hour_of_day
ORDER BY hour_of_day;


 
-- 3. Join relevant tables to find the type-wise count of content (Movies vs Series).
SELECT
    type_,
    COUNT(content_id) AS total_titles
FROM contents
GROUP BY type_;


 
-- 4. Group the watch sessions by date and calculate the average number of content watched per day.
SELECT
    ROUND(AVG(sessions_per_day), 0) AS avg_sessions_per_day
FROM (
    SELECT
        watch_date,
        COUNT(watch_id) AS sessions_per_day
    FROM watch_history
    GROUP BY watch_date
    ORDER BY watch_date
) AS daily_sessions;


-- 5. Determine the top 3 highest revenue-generating subscription plans.
SELECT
    plan_type,
    ROUND(SUM(monthly_fee), 2) AS total_revenue
FROM subscriptions
GROUP BY plan_type
ORDER BY total_revenue DESC
LIMIT 3;


--  ADVANCED QUERIES

-- 1. Calculate the percentage contribution of each genre to total watch duration.
SELECT
    c.genre,
    ROUND(
        (SUM(w.watch_duration) /
            (SELECT SUM(watch_duration) FROM watch_history)
        ) * 100, 2
    ) AS contribution_pct
FROM watch_history w
    JOIN contents c ON w.content_id = c.content_id
GROUP BY c.genre
ORDER BY contribution_pct DESC;



-- 2. Analyze the cumulative revenue generated from subscriptions over time.
SELECT
    start_date,
    ROUND(SUM(monthly_fee) OVER (ORDER BY start_date), 2) AS cumulative_revenue
FROM (
    SELECT
        start_date,
        SUM(monthly_fee) AS monthly_fee
    FROM subscriptions
    GROUP BY start_date
) AS daily_revenue
ORDER BY start_date;


-- 3. Determine the top 3 most watched content titles based on total watch duration for each genre.
SELECT
    genre,
    title,
    ROUND(total_hours, 2) AS total_hours,
    rn
FROM (
    SELECT
        genre,
        title,
        total_hours,
        RANK() OVER (
            PARTITION BY genre
            ORDER BY total_hours DESC
        ) AS rn
    FROM (
        SELECT
            c.genre,
            c.title,
            SUM(w.watch_duration) / 60.0 AS total_hours
        FROM content c
            JOIN watch_history w ON c.content_id = w.content_id
        GROUP BY c.genre, c.title
    ) AS genre_watch
) AS ranked
WHERE rn <= 3
ORDER BY genre, rn;