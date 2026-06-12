# 🎬 OTT Streaming Platform — SQL Analytics Project

A relational database project that simulates a Netflix-style OTT (Over-The-Top) streaming platform. The dataset covers user accounts, content catalogues, subscription billing, watch behaviour, and content ratings — and includes a structured set of SQL queries progressing from basic aggregations to advanced window functions.

---

## 📁 Project Structure

```
ott-streaming-analytics/
│
├── ott_content_dataset_creation.sql   # DDL — creates all tables & ENUM types
├── sqlqueries.sql                     # Analytical queries (Basic → Intermediate → Advanced)
│
├── data/
│   ├── users.csv           (100 records)
│   ├── content.csv         ( 50 records)
│   ├── subscriptions.csv   (100 records)
│   ├── watch_history.csv   (200 records)
│   └── ratings.csv         (150 records)
│
└── README.md
```

---

## 🗃️ Database Schema

### Entity Relationship Overview

```
USERS
 ├──< SUBSCRIPTIONS
 ├──< WATCH_HISTORY >──< CONTENTS
 └──< RATINGS       >──┘
```

---

### `USERS`
Stores registered platform users.

| Column            | Type         | Description                             |
|-------------------|--------------|-----------------------------------------|
| user_id           | INT PK       | Unique user identifier                  |
| name_             | VARCHAR(100) | Full name                               |
| email             | VARCHAR(100) | Email address                           |
| age               | INT          | Age of the user                         |
| country           | VARCHAR(50)  | Country of residence                    |
| join_date         | DATE         | Account registration date               |
| subscription_plan | VARCHAR(20)  | Plan tier: Basic, Standard, Premium     |
| is_active         | BOOLEAN      | Whether the account is active           |

---

### `CONTENTS`
Catalogue of all movies and series on the platform.

| Column       | Type          | Description                               |
|--------------|---------------|-------------------------------------------|
| content_id   | INT PK        | Unique content identifier                 |
| title        | VARCHAR(255)  | Title of the content                      |
| type_        | content_type  | ENUM: Movie or Series                     |
| genre        | VARCHAR(50)   | Genre: Action, Comedy, Drama, Thriller …  |
| language_    | VARCHAR(30)   | Original language                         |
| release_year | INT           | Year of release                           |
| duration_min | INT           | Runtime in minutes                        |
| age_rating   | VARCHAR(10)   | Certification (U, U/A 7+, U/A 16+)       |
| country      | VARCHAR(50)   | Country of production                     |

**Genres available:** Action, Animation, Comedy, Crime, Documentary, Drama, Horror, Romance, Sci-Fi, Thriller

---

### `SUBSCRIPTIONS`
Billing records linking users to subscription plans.

| Column         | Type                | Description                                    |
|----------------|---------------------|------------------------------------------------|
| sub_id         | INT PK              | Unique subscription identifier                 |
| user_id        | INT FK              | References USERS(user_id)                      |
| plan_type      | VARCHAR(20)         | Plan name: Basic, Standard, Premium            |
| start_date     | DATE                | Subscription start date                        |
| end_date       | DATE                | Subscription expiry / renewal date             |
| monthly_fee    | DECIMAL(6,2)        | Fee charged per month                          |
| payment_method | VARCHAR(30)         | UPI, Credit Card, Debit Card, PayPal, Wallet … |
| status         | subscription_status | ENUM: active, expired, cancelled               |

---

### `WATCH_HISTORY`
Every streaming session recorded on the platform.

| Column         | Type         | Description                                    |
|----------------|--------------|------------------------------------------------|
| watch_id       | INT PK       | Unique session identifier                      |
| user_id        | INT FK       | References USERS(user_id)                      |
| content_id     | INT FK       | References CONTENTS(content_id)                |
| watch_date     | DATE         | Date of the viewing session                    |
| watch_duration | INT          | Minutes watched in the session                 |
| device         | VARCHAR(30)  | Device used: TV, Mobile, Laptop, Tablet        |
| completion_pct | DECIMAL(5,2) | Percentage of the content completed (0–100)    |

---

### `RATINGS`
User-submitted star ratings and written reviews.

| Column     | Type     | Description                            |
|------------|----------|----------------------------------------|
| rating_id  | INT PK   | Unique rating identifier               |
| user_id    | INT FK   | References USERS(user_id)              |
| content_id | INT FK   | References CONTENTS(content_id)        |
| stars      | INT      | Score from 1 to 5                      |
| review     | TEXT     | Optional written review                |
| rated_on   | DATE     | Date the rating was submitted          |

---

### Custom ENUM Types

```sql
CREATE TYPE content_type        AS ENUM('Movie', 'Series');
CREATE TYPE subscription_status AS ENUM('active', 'expired', 'cancelled');
```

---

## 🔍 SQL Queries Overview

All queries are in `sqlqueries.sql`, organised into three difficulty tiers.

### 🟢 Basic Queries

| # | Query Description |
|---|-------------------|
| 1 | Total number of watch sessions recorded |
| 2 | Total revenue generated from all subscriptions |
| 3 | Highest-priced subscription plan |
| 4 | Most-used device for streaming |
| 5 | Top 5 most-watched content titles by total watch duration |

### 🟡 Intermediate Queries

| # | Query Description |
|---|-------------------|
| 1 | Total watch duration (in hours) for each content genre |
| 2 | Distribution of watch sessions by hour of the day |
| 3 | Type-wise content count — Movies vs Series |
| 4 | Average number of watch sessions per day |
| 5 | Top 3 highest revenue-generating subscription plans |

### 🔴 Advanced Queries

| # | Query Description |
|---|-------------------|
| 1 | Percentage contribution of each genre to total watch duration |
| 2 | Cumulative subscription revenue over time (window function) |
| 3 | Top 3 most-watched titles per genre using RANK() OVER (PARTITION BY …) |

---

## 🚀 Getting Started

### Prerequisites
- PostgreSQL 13 or higher

### Setup Steps

```sql
-- 1. Create a new database
CREATE DATABASE ott_streaming;

-- 2. Connect to the database
\c ott_streaming

-- 3. Run the schema creation script
\i ott_content_dataset_creation.sql

-- 4. Import the CSV data files
\copy USERS         FROM 'data/users.csv'         CSV HEADER;
\copy CONTENTS      FROM 'data/content.csv'        CSV HEADER;
\copy SUBSCRIPTIONS FROM 'data/subscriptions.csv'  CSV HEADER;
\copy WATCH_HISTORY FROM 'data/watch_history.csv'  CSV HEADER;
\copy RATINGS       FROM 'data/ratings.csv'        CSV HEADER;

-- 5. Run the analytical queries
\i sqlqueries.sql
```

> **Tip:** Run the imports in the order shown above to respect foreign key constraints —
> USERS and CONTENTS must be loaded before SUBSCRIPTIONS, WATCH_HISTORY, and RATINGS.

---

## 💡 SQL Concepts Demonstrated

| Concept | Where Used |
|---------|------------|
| INNER JOIN | Watch duration per genre, top titles, type counts |
| GROUP BY + Aggregates (SUM, COUNT, AVG, ROUND) | Most queries |
| Subqueries & Derived Tables | Avg sessions/day, genre contribution % |
| EXTRACT(HOUR FROM …) | Sessions by hour of day |
| Window Function — SUM() OVER | Cumulative revenue over time |
| Window Function — RANK() OVER (PARTITION BY …) | Top 3 titles per genre |
| ENUM Types | content_type, subscription_status |
| CHECK Constraints | Stars (1–5) |
| Cascading Foreign Keys | All child tables reference USERS and CONTENTS |

---

## 📊 Dataset Summary

| Table         | Records |
|---------------|---------|
| USERS         | 100     |
| CONTENTS      | 50      |
| SUBSCRIPTIONS | 100     |
| WATCH_HISTORY | 200     |
| RATINGS       | 150     |

**Subscription plans:** Basic · Standard · Premium  
**Devices tracked:** TV · Mobile · Laptop · Tablet  
**Genres:** Action · Animation · Comedy · Crime · Documentary · Drama · Horror · Romance · Sci-Fi · Thriller  
**Payment methods:** UPI · Credit Card · Debit Card · PayPal · Net Banking · Wallet

---

## 🧑‍💻 Author

> Add your name, institution / course name, and submission date here.

---

## 📄 License

This project is for educational and portfolio purposes.
