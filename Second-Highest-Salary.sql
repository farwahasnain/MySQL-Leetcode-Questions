-- Second Highest Salary
-- https://leetcode.com/problems/second-highest-salary/

-- Create table
CREATE TABLE Employee (
    Id INT PRIMARY KEY,
    Salary INT
);

-- Insert sample data
INSERT INTO Employee (Id, Salary) VALUES
(1, 100),
(2, 200),
(3, 300);

-- Query to get the second highest salary

SELECT 
    IFNULL(a.salary, 0) AS SecondHighestSalary
FROM
    employees a
WHERE
    a.salary < (SELECT 
            MAX(b.salary)
        FROM
            employees b)
ORDER BY 1 DESC
LIMIT 1;