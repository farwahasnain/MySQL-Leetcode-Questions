-- 569. Median Employee Salary
-- https://leetcode.com/problems/median-employee-salary/

Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| company      | varchar |
| salary       | int     |
+--------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the company and the salary of one employee.
 

Write a solution to find the rows that contain the median salary of each company. 
While calculating the median, when you sort the salaries of the company, break the ties by id.
Return the result table in any order.
The result format is in the following example.


Example 1:

Input: 
Employee table:
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 1  | A       | 2341   |
| 2  | A       | 341    |
| 3  | A       | 15     |
| 4  | A       | 15314  |
| 5  | A       | 451    |
| 6  | A       | 513    |
| 7  | B       | 15     |
| 8  | B       | 13     |
| 9  | B       | 1154   |
| 10 | B       | 1345   |
| 11 | B       | 1221   |
| 12 | B       | 234    |
| 13 | C       | 2345   |
| 14 | C       | 2645   |
| 15 | C       | 2645   |
| 16 | C       | 2652   |
| 17 | C       | 65     |
+----+---------+--------+
Output: 
+----+---------+--------+
| id | company | salary |
+----+---------+--------+
| 5  | A       | 451    |
| 6  | A       | 513    |
| 12 | B       | 234    |
| 9  | B       | 1154   |
| 14 | C       | 2645   |


-- Schema:

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    company VARCHAR(50),
    salary INT
);

INSERT INTO Employee (id, company, salary) VALUES
(1, 'A', 2341),
(2, 'A', 341),
(3, 'A', 15),
(4, 'A', 15314),
(5, 'A', 451),
(6, 'A', 513),
(7, 'B', 15),
(8, 'B', 13),
(9, 'B', 1154),
(10, 'B', 1345),
(11, 'B', 1221),
(12, 'B', 234),
(13, 'C', 2345),
(14, 'C', 2645),
(15, 'C', 2645),
(16, 'C', 2652),
(17, 'C', 65);


-- Solution:

WITH Half AS (
    SELECT *,
           NTILE(2) OVER(PARTITION BY company ORDER BY salary, id) AS half_asc,
           NTILE(2) OVER(PARTITION BY company ORDER BY salary DESC, id DESC) AS half_desc
    FROM Employee
)
SELECT id, company, salary
FROM Half
WHERE half_asc = 1 AND half_desc = 1;