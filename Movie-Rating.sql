-- 1341. Movie Rating
-- https://leetcode.com/problems/movie-rating/

Table: Movies

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key (column with unique values) for this table.
title is the name of the movie.
Each movie has a unique title.
Table: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key (column with unique values) for this table.
The column 'name' has unique values.
Table: MovieRating

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key (column with unique values) for this table.
This table contains the rating of a movie by a user in their review.
created_at is the users review date. 
 
Write a solution to:

Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.
The result format is in the following example.

Example 1:

Input: 
Movies table:
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+
Users table:
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+
MovieRating table:
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  | 
| 2           | 2            | 2            | 2020-02-01  | 
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  | 
| 3           | 2            | 4            | 2020-02-25  | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+

-- Schema:

-- Table: Users
-- ----------------------------
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name    VARCHAR(255) NOT NULL
);

-- ----------------------------
-- Table: Movies
-- ----------------------------
DROP TABLE IF EXISTS Movies;

CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title    VARCHAR(255) NOT NULL
);

-- ----------------------------
-- Table: MovieRating
-- ----------------------------
DROP TABLE IF EXISTS MovieRating;

CREATE TABLE MovieRating (
    movie_id   INT NOT NULL,
    user_id    INT NOT NULL,
    rating     INT NOT NULL,
    created_at DATE NOT NULL,
    PRIMARY KEY (movie_id, user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (user_id)  REFERENCES Users(user_id)
);

-- ----------------------------
-- INSERT: Users
-- ----------------------------
INSERT INTO Users (user_id, name) VALUES
(1, 'Daniel'),
(2, 'Monica'),
(3, 'Maria'),
(4, 'James');

-- ----------------------------
-- INSERT: Movies
-- ----------------------------
INSERT INTO Movies (movie_id, title) VALUES
(1, 'Avengers'),
(2, 'Frozen 2'),
(3, 'Joker');

-- ----------------------------
-- INSERT: MovieRating
-- ----------------------------
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES
(1, 1, 3, '2020-01-12'),
(1, 2, 4, '2020-02-11'),
(1, 3, 2, '2020-02-12'),
(1, 4, 1, '2020-01-01'),
(2, 1, 5, '2020-02-17'),
(2, 2, 2, '2020-02-01'),
(2, 3, 2, '2020-03-01'),
(3, 1, 3, '2020-02-22'),
(3, 2, 4, '2020-02-25');



-- Solution1: (Union All + Joins)

(
    SELECT u.name AS results
    FROM MovieRating mr
    JOIN Users u ON mr.user_id = u.user_id
    GROUP BY u.name
    ORDER BY COUNT(mr.rating) DESC, u.name   -- most ratings, then alpha tiebreak
    LIMIT 1
)

UNION ALL  
(
    SELECT m.title AS results
    FROM Movies m
    JOIN MovieRating mr ON m.movie_id = mr.movie_id
    WHERE MONTH(created_at) = 2
    AND YEAR(created_at) = 2020
    GROUP BY m.title
    ORDER BY AVG(mr.rating) DESC, m.title  -- highest avg rating, then alpha tiebreak
    LIMIT 1
);


-- Solution 2: (Using CTE + Window Functions)

WITH UserRanked AS (
    SELECT u.name AS results, 
           RANK() OVER (ORDER BY COUNT(*) DESC, u.name) AS rnk
    FROM MovieRating mr
    JOIN Users u ON mr.user_id = u.user_id
    GROUP BY u.name
),
MovieRanked AS (
    SELECT m.title AS results,
           RANK() OVER (ORDER BY AVG(mr.rating) DESC, m.title) AS rnk
    FROM Movies m
    JOIN MovieRating mr ON m.movie_id = mr.movie_id
    WHERE MONTH(created_at) = 2 AND YEAR(created_at) = 2020
    GROUP BY m.title
)

SELECT results FROM UserRanked  WHERE rnk = 1
UNION ALL
SELECT results FROM MovieRanked WHERE rnk = 1;
