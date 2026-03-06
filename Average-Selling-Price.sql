-- 1251. Average Selling Price
-- https://leetcode.com/problems/average-selling-price/

Table: Prices

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.

Table: UnitsSold

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
This table may contain duplicate rows.
Each row of this table indicates the date, units, and product_id of each product sold. 
 

Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. If a product does not have any sold units, its average selling price is assumed to be 0.

Return the result table in any order.

The result format is in the following example.

Example 1:

Input: 
Prices table:
+------------+------------+------------+--------+
| product_id | start_date | end_date   | price  |
+------------+------------+------------+--------+
| 1          | 2019-02-17 | 2019-02-28 | 5      |
| 1          | 2019-03-01 | 2019-03-22 | 20     |
| 2          | 2019-02-01 | 2019-02-20 | 15     |
| 2          | 2019-02-21 | 2019-03-31 | 30     |
+------------+------------+------------+--------+
UnitsSold table:
+------------+---------------+-------+
| product_id | purchase_date | units |
+------------+---------------+-------+
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |
+------------+---------------+-------+
Output: 
+------------+---------------+
| product_id | average_price |
+------------+---------------+
| 1          | 6.96          |
| 2          | 16.96         |
+------------+---------------+

-- Schema:

-- Create Prices table
CREATE TABLE Prices (
    product_id  INT,
    start_date  DATE,
    end_date    DATE,
    price       INT,
    PRIMARY KEY (product_id, start_date, end_date)
);

-- Create UnitsSold table
CREATE TABLE UnitsSold (
    product_id    INT,
    purchase_date DATE,
    units         INT
);

-- Insert sample data into Prices
INSERT INTO Prices VALUES
(1, '2019-02-17', '2019-02-28', 5),
(1, '2019-03-01', '2019-03-22', 20),
(2, '2019-02-01', '2019-02-20', 15),
(2, '2019-02-21', '2019-03-31', 30);

-- Insert sample data into UnitsSold
INSERT INTO UnitsSold VALUES
(1, '2019-02-25', 100),
(1, '2019-03-01', 15),
(2, '2019-02-10', 200),
(2, '2019-03-22', 30);



-- Solution:

WITH avg AS (
    SELECT DISTINCT 
    p.product_id,
    SUM(p.price * u.units) OVER(PARTITION BY p.product_id) as total_price,
    SUM(u.units) OVER(PARTITION BY p.product_id) as total_units,
    SUM(p.price * u.units) OVER(PARTITION BY p.product_id)/NULLIF(SUM(u.units) OVER(PARTITION BY p.product_id), 0) as average_price
FROM Prices p
LEFT JOIN UnitsSold u
ON p.product_id = u.product_id
AND u.purchase_date BETWEEN p.start_date AND p.end_date
)

SELECT
    product_id,
    ROUND(COALESCE(average_price, 0), 2) AS average_price
FROM avg
ORDER BY product_id;


-- COALESCE(..., 0) — returns 0 if a product has no sales at all.
-- NULLIF(SUM(units), 0) — prevents division by zero.
-- ROUND(..., 2) — rounds to 2 decimal places as required.