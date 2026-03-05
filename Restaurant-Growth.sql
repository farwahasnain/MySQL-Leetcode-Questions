-- 1321. Restaurant Growth
-- https://leetcode.com/problems/restaurant-growth/

Table: Customer

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
In SQL,(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
amount is the total paid by a customer.
 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
Return the result table ordered by visited_on in ascending order.
The result format is in the following example.

Example 1:

Input: 
Customer table:
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         | 
| 6           | Elvis        | 2019-01-06   | 140         | 
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         | 
| 1           | Jhon         | 2019-01-10   | 130         | 
| 3           | Jade         | 2019-01-10   | 150         | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+


-- Schema:

-- ----------------------------
-- Table: Customer
-- ----------------------------
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    customer_id INT          NOT NULL,
    name        VARCHAR(255) NOT NULL,
    visited_on  DATE         NOT NULL,
    amount      INT          NOT NULL,
    PRIMARY KEY (customer_id, visited_on)
);


-- ----------------------------
-- INSERT: Customer
-- ----------------------------
INSERT INTO Customer (customer_id, name, visited_on, amount) VALUES
(1,  'Jhon',    '2019-01-01', 100),
(2,  'Daniel',  '2019-01-02', 110),
(3,  'Jade',    '2019-01-03', 120),
(4,  'Khaled',  '2019-01-04', 130),
(5,  'Winston', '2019-01-05', 110),
(6,  'Elvis',   '2019-01-06', 140),
(7,  'Anna',    '2019-01-07', 150),
(8,  'Maria',   '2019-01-08',  80),
(9,  'Jaze',    '2019-01-09', 110),
(1,  'Jhon',    '2019-01-10', 130),
(3,  'Jade',    '2019-01-10', 150);

-- Solution:

# Write your MySQL query statement below

WITH customer_cte AS (
    SELECT visited_on, 
SUM(SUM(amount)) OVER(							-- multiple customers can visit on the same day
    ORDER BY visited_on
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
ROUND(AVG(SUM(amount)) OVER(					-- multiple customers can visit on the same day
    ORDER BY visited_on
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ),2)
    as average_amount,
ROW_NUMBER() OVER(ORDER BY visited_on) as rn
FROM Customer
GROUP BY visited_on
)

SELECT visited_on, amount, average_amount
from customer_cte
where rn >= 7
ORDER BY visited_on;
