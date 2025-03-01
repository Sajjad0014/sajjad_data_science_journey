-- VIEWS

USE campusx;

SELECT * FROM flights;

SELECT * FROM flights
WHERE Airline = 'IndiGo';

CREATE VIEW indigo AS
SELECT * FROM flights
WHERE Airline = 'IndiGo';

SELECT * FROM indigo;

-- indigo, which is a view, can be seen by running the below query
SHOW TABLES;

-- making a view using zomato_case_study db
-- so that when we have to solve any future problems like below and other queries
-- which user has ordered the most.
USE zomato_case_study;

SELECT order_id, amount, r_name, name, date, delivery_time, delivery_rating, restaurant_rating 
FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id
JOIN restaurants t3
ON t1.r_id = t3.r_id;

CREATE VIEW joined_order_data AS
SELECT order_id, amount, r_name, name, date, delivery_time, delivery_rating, restaurant_rating 
FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id
JOIN restaurants t3
ON t1.r_id = t3.r_id;

SELECT r_name, MONTH(date), SUM(amount) FROM joined_order_data
GROUP BY r_name, MONTH(date);

-- Read only view
USE campusx;
SELECT * FROM campusx.indigo;

-- Changes in Table reflects the VIEW
UPDATE campusx.flights
SET Airline = 'IndiGo Airline'
WHERE Airline = 'Indigo';
 
SELECT * FROM campusx.flights;

-- Updated here
SELECT * FROM campusx.indigo;

-- another example

ALTER VIEW indigo AS
SELECT * FROM flights
WHERE Airline = 'Indigo Airline';

UPDATE campusx.flights
SET Source = 'Bengaluru'
WHERE Source = 'Banglore';

-- We can see it has affected the indigo_new
SELECT * FROM campusx.indigo;


-- We can also drop the view
-- DROP VIEW indigo;

-- Reverse is also true, WHEN view is UPDATABLE
UPDATE indigo
SET Destination = 'Delhi'
WHERE Destination = 'New Delhi';
-- If the above has executed, it proves that the view is UPDATABLE

SELECT * FROM flights
WHERE Airline = 'IndiGo Airline';

-- joined_order_data is READ ONLY VIEW
-- indigo is UPDATABLE VIEW

-- DELETE FROM zomato_case_study.joined_order_data
-- WHERE order_id = 1001;


-- USER DEFINED FUNCTIONS
SET GLOBAL log_bin_trust_function_creators = 1;

SELECT hello_world();

SELECT hello_world() AS 'Message';

-- this function will run for as many rows in 'marks' rows
SELECT hello_world() FROM marks;

SELECT UPPER('Hello');

-- this upper function will run on all the rows
SELECT UPPER(name) FROM marks;

-- parameterized Vs Non-parameterized functions

-- 
-- Create a function which takes date of birth and returns the age in years
-- Calculate age in years (in cols)
SELECT calculate_age('2000-02-24');

SELECT distinct(calculate_age(Date_of_journey)) FROM flights;

UPDATE marks
SET name = LOWER(name);

SELECT * FROM marks;


CREATE TABLE Persons (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    dob DATE,
    gender CHAR(1),
    married CHAR(1)
);

INSERT INTO Persons (id, name, dob, gender, married) VALUES
(1, 'Alice Johnson', '1990-05-14', 'F', 'Y'),
(2, 'Bob Smith', '1985-09-23', 'M', 'N'),
(3, 'Charlie Brown', '1992-02-11', 'M', 'Y'),
(4, 'Diana Prince', '1988-07-19', 'F', 'N'),
(5, 'Ethan Hunt', '1995-03-05', 'M', 'Y'),
(6, 'Fiona Gallagher', '1993-06-25', 'F', 'N'),
(7, 'George Miller', '1987-12-30', 'M', 'Y'),
(8, 'Hannah Baker', '1999-04-22', 'F', 'N'),
(9, 'Ian Curtis', '1984-08-09', 'M', 'Y'),
(10, 'Jessica Pearson', '1991-11-15', 'F', 'Y'),
(11, 'Kevin Malone', '1990-01-07', 'M', 'N'),
(12, 'Laura Palmer', '1998-10-12', 'F', 'N'),
(13, 'Michael Scott', '1975-06-25', 'M', 'Y'),
(14, 'Nancy Wheeler', '1994-09-30', 'F', 'Y'),
(15, 'Oscar Martinez', '1986-03-18', 'M', 'N'),
(16, 'Pam Beesly', '1989-12-05', 'F', 'Y'),
(17, 'Quentin Tarantino', '1963-03-27', 'M', 'Y'),
(18, 'Rachel Green', '1992-07-10', 'F', 'N'),
(19, 'Steve Rogers', '1918-07-04', 'M', 'N'),
(20, 'Tina Fey', '1970-05-18', 'F', 'Y');

-- A function that properly displays the name like nitish => Mr Nitish, ankita => Mrs/Ms Ankita

UPDATE Persons
SET name = LOWER(name);

SELECT * FROM Persons;

SELECT proper_name('Nitish', 'M', 'Y');
SELECT proper_name('Sadiqa', 'F', 'Y');
SELECT proper_name('Ankita', 'F', 'N');

SELECT *, proper_name(name, gender, married)
FROM Persons;

-- Q. Date formatting in flights table (deterministic Vs Non-Deterministic)
-- deterministic means, we know the output of below query is '24th Feb, 91'
-- Same input same output
SELECT format_date('1991-02-24');

SELECT *, format_date(Date_of_journey)
FROM flights;

-- debugging
SELECT DATE_FORMAT(Date_of_Journey, '%D %b, %y')
FROM flights;

-- same function on Person table
-- Reusability
SELECT *, format_date(dob)
FROM Persons;

-- Non-diterministic
-- same input different output (at different times)
-- Ex No. of flights between 2 cities
-- we don't know how many, hence non deterministic functions.
-- By default we have non-deterministic
-- Q. No. of flights between 2 cities
SELECT fligths_between('Bengaluru', 'New Delhi') AS num_flights;

SELECT * FROM flights;