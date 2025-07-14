-- 175. Combine Two Tables

Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| personId    | int     |
| lastName    | varchar |
| firstName   | varchar |
+-------------+---------+
personId is the primary key (column with unique values) for this table.
This table contains information about the ID of some persons and their first and last names.
 

Table: Address

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| addressId   | int     |
| personId    | int     |
| city        | varchar |
| state       | varchar |
+-------------+---------+
addressId is the primary key (column with unique values) for this table.
Each row of this table contains information about the city and state of one person with ID = PersonId.
 

-- Write a solution to report the first name, last name, city, and state of each person in the Person table. If the address of a personId is not present in the Address table, report null instead.

-- Return the result table in any order. The result format is in the following example.

Example 1:

Input: 
Person table:
+----------+----------+-----------+
| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
+----------+----------+-----------+
Address table:
+-----------+----------+---------------+------------+
| addressId | personId | city          | state      |
+-----------+----------+---------------+------------+
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |
+-----------+----------+---------------+------------+
Output: 
+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+

--SCHEMA:

-- Create Person table
CREATE TABLE Person (
    personId INT PRIMARY KEY,
    lastName VARCHAR(50),
    firstName VARCHAR(50)
);

-- Create Address table
CREATE TABLE Address (
    addressId INT PRIMARY KEY,
    personId INT,
    city VARCHAR(100),
    state VARCHAR(100),
    FOREIGN KEY (personId) REFERENCES Person(personId)
);

-- Insert sample data into Person table
INSERT INTO Person (personId, lastName, firstName) VALUES
(1, 'Wang', 'Allen'),
(2, 'Alice', 'Bob');

-- Insert sample data into Address table
INSERT INTO Address (addressId, personId, city, state) VALUES
(1, 2, 'New York City', 'New York'),
(2, 3, 'Leetcode', 'California');

-- SOLUTION:

SELECT 
    p.firstName, 
    p.lastName, 
    a.city, 
    a.state
FROM Person p
LEFT JOIN Address a
ON p.personId = a.personId;