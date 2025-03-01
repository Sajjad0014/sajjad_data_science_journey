USE campusx;

CREATE TABLE Employees(
emp_id INT PRIMARY KEY,
emp_name VARCHAR(100),
emp_department VARCHAR(50),
emp_salary DECIMAL(10, 2),
emp_duration_in_days INT
);


INSERT INTO Employees (emp_id, emp_name, emp_department, emp_salary, emp_duration_in_days)
VALUES
(1, 'John Doe', 'IT', 60000, 365),
(2, 'Jane Smith', 'HR', 50000, 730),
(3, 'Bob Brown', 'Sales', 55000, 180),
(4, 'Alice White', 'IT', 70000, 540),
(5, 'Charlie Black', 'HR', 45000, 120),
(6, 'David Green', 'Marketing', 48000, 300),
(7, 'Eva Blue', 'Sales', 52000, 250),
(8, 'Frank Gray', 'IT', 62000, 400),
(9, 'Grace Yellow', 'Finance', 58000, 600),
(10, 'Henry Pink', 'Marketing', 47000, 365),
(11, 'Isla Purple', 'HR', 46000, 220),
(12, 'Jack Red', 'Sales', 51000, 540),
(13, 'Karen Orange', 'Finance', 61000, 730),
(14, 'Liam Cyan', 'IT', 64000, 365),
(15, 'Mia Violet', 'Marketing', 49000, 180),
(16, 'Noah Indigo', 'Sales', 53000, 450),
(17, 'Olivia Silver', 'HR', 47000, 500),
(18, 'Paul Bronze', 'IT', 69000, 600),
(19, 'Quincy Gold', 'Finance', 66000, 720),
(20, 'Rachel Platinum', 'Marketing', 46000, 365);

SELECT * FROM Employees;

-- What is CTE
-- Common Table Expression
-- we use WITH clause 
-- hence it is aka Query with "With Clause"
-- aka Query Sub-folding
-- CTE life is only till the execution (together) of the query
-- It is a temporary named subquery
-- Advantage - using a subquery multiple times
-- used to readability
-- reduce complexity
-- enhance performance

-- Use case
-- Find the employees whose salary is in the range between +-2000 of average salary where dept is sales and emp_duration is greater than 200
-- Logic Below 
-- 1. We need to find average salary on the basis of given condition
SELECT AVG(emp_salary) AS avg
FROM Employees
WHERE emp_department = 'Sales' AND emp_duration_in_days > 200;

-- 2. From the table, find the employees who lie in the range of the given average
SELECT * FROM Employees
WHERE emp_salary > (SELECT AVG(emp_salary) AS avg
FROM Employees
WHERE emp_department = 'Sales' AND emp_duration_in_days > 200) - 2000
AND
emp_salary < (SELECT AVG(emp_salary) AS avg
FROM Employees
WHERE emp_department = 'Sales' AND emp_duration_in_days > 200) + 2000;

-- WHat are the issues here?
-- It decreases the readability
-- Complexity increased
-- Decreases Performance

-- How to solve this? CTE... Yay...
WITH t AS (
SELECT AVG(emp_salary) as avg_salary
FROM Employees
WHERE emp_department = 'Sales' AND emp_duration_in_days > 200
)

SELECT * FROM Employees
WHERE emp_salary > (SELECT * FROM t) - 2000 AND emp_salary < (SELECT avg_salary FROM t)  + 2000;

-- Select the department from employees table 
-- whose average salary is more than average salary across all departments
-- Logic
-- Step 1 - Average salary of each department (dep_avg)
SELECT emp_department, AVG(emp_salary) AS dep_avg
FROM Employees
GROUP BY emp_department;

-- Step 2 - Find average salary with respect to all the department (entire_avg)
SELECT ROUND(AVG(dep_avg), 2) AS entire_avg
FROM (SELECT emp_department, avg(emp_salary) AS dep_avg
	  FROM Employees
      GROUP BY emp_department) t;

-- Step 3 - Find the department where dep_avg > entire_avg
SELECT * FROM (
	SELECT emp_department, ROUND(AVG(emp_salary), 2) AS dep_avg
    FROM Employees
    GROUP BY emp_department
) k
JOIN
(
SELECT ROUND(AVG(dep_avg), 2) AS entire_avg
FROM (
	SELECT emp_department, AVG(emp_salary) AS dep_avg
    FROM Employees
    GROUP BY emp_department
) t
) m
ON dep_avg > entire_avg;

-- With CTE

WITH cte AS (
	SELECT emp_department, ROUND(AVG(emp_salary), 2) AS dep_avg
	FROM Employees
    GROUP BY emp_department
)
SELECT * FROM cte WHERE dep_avg > (SELECT AVG(dep_avg) FROM cte);


-- Multiple CTEs
-- Client wants average salary and count of employees of each department
WITH cte AS (
	SELECT emp_department, ROUND(AVG(emp_salary), 2) AS dep_avg
    FROM Employees
    GROUP BY emp_department
),
t AS (
	SELECT emp_department, COUNT(emp_id) AS cnt
    FROM employees
    GROUP BY emp_department
)

SELECT * FROM cte 
JOIN t
ON cte.emp_department = t.emp_department;



