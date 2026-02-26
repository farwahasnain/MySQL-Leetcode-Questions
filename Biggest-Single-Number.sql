-- 619. Biggest Single Number
-- https://leetcode.com/problems/biggest-single-number/

Table: MyNumbers

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
This table may contain duplicates (In other words, there is no primary key for this table in SQL).
Each row of this table contains an integer.
 
A single number is a number that appeared only once in the MyNumbers table.
Find the largest single number. If there is no single number, report null.
The result format is in the following example.

Example 1:

Input: 
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 3   |
| 3   |
| 1   |
| 4   |
| 5   |
| 6   |
+-----+
Output: 
+-----+
| num |
+-----+
| 6   |
+-----+

-- Schema:

CREATE TABLE MyNumbers (
    num INT
);

INSERT INTO MyNumbers (num) VALUES
(8),
(8),
(3),
(3),
(1),
(4),
(5),
(6);

-- Solution:

WITH biggest_number AS (
    SELECT  num
FROM MyNumbers
GROUP BY num
HAVING count(num) = 1
)


SELECT max(num) AS num
from biggest_number;
