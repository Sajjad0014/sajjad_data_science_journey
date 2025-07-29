-- Session on SQL Datetime Case Study on Flights Dataset

-- Creating and Populating Temporal Tables
-- Uber rides table
-- with cols ride_id, user_id, cab_id, start_time, end_time
USE campusx;

CREATE TABLE uber_rides(
	ride_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INTEGER,
    cab_id INTEGER,
    start_time DATETIME,
    end_time DATETIME
);

SELECT * FROM uber_rides;

INSERT INTO uber_rides (user_id, cab_id, start_time, end_time) VALUES
(1, 1, '2023-03-09 08:00:00', "2023-03-09 09:30:00");

INSERT INTO uber_rides (user_id, cab_id, start_time, end_time) VALUES
(1, 7, '2023-03-10 00:30:21', '2023-03-10 01:45:59'),
(2, 2, '2023-03-11 23:00:01','2023-03-12 01:15:34');

INSERT INTO uber_rides (user_id, cab_id, start_time, end_time) VALUES
(1, 7, '2024-04-11', '2024-04-11 01:46:45');

-- Datetime functions

SELECT CURRENT_DATE();

SELECT CURRENT_TIME();

SELECT NOW();

INSERT INTO uber_rides (user_id, cab_id, start_time, end_time) VALUES
(1, 7, '2025-02-23', NOW());0

SELECT * FROM uber_rides;

-- Extraction Function
SELECT start_time, DATE(start_time), TIME(start_time), YEAR(start_time), MONTH(start_time), MONTHNAME(start_time), 
DAY(start_time), DAYOFMONTH(start_time),  DAYOFYEAR(start_time), DAYOFWEEK(start_time), DAYNAME(start_time), 
QUARTER(start_time),
HOUR(start_time), MINUTE(start_time), SECOND(start_time), 
WEEKOFYEAR(start_time), LAST_DAY(start_time)
FROM uber_rides;

-- Datetime Formatting
-- https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format

SELECT start_time, DATE_FORMAT(start_time, '%d %b, %y'), DATE_FORMAT(start_time, '%d Hello %b, %y') 
FROM uber_rides;

SELECT start_time, DATE_FORMAT(start_time, '%l:%i %p')
FROM uber_rides;

-- Use TIME_FORMAT() when you don't have date col and time only
SELECT TIME(start_time), TIME_FORMAT(TIME(start_time), '%l:%i %p')
FROM uber_rides;

-- Type Conversion (Implicit)
SELECT '2023-03-11' > '2023-03-14', '2023:03:11' > '2023-03-09';

-- When we don't have dates or times in proper format
SELECT '2023-03-11' > '9 Mar 2023';
SELECT MONTHNAME('9 Mar 2023');
-- It gave 0, which is false. As it is doing string comparison and not the date comparison
-- Implicit type conversion failed
-- Explicit Type conversion
SELECT '2023-03-11' > STR_TO_DATE('9 Mar 2023', '%e %b %Y');

SELECT MONTHNAME(STR_TO_DATE('9 Mar 2023', "%e %b %Y"));

SELECT MONTHNAME(STR_TO_DATE('9-Mar hello 24', '%e-%b hello %y'));

-- DATETIME Arithmetic
-- How much time has passed from some date
-- DATEDIFF()
SELECT DATEDIFF(CURRENT_DATE(), '2022-11-07');

SELECT DATEDIFF(end_time, start_time)
FROM uber_rides;

-- TIMEDIFF()
SELECT TIMEDIFF(CURRENT_TIME(), '20:00:00');

SELECT TIMEDIFF(end_time, start_time)
FROM uber_rides;

-- DATE_ADD()
-- Current + interval
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 10 YEAR), DATE_SUB(NOW(), INTERVAL 10 MINUTE);

SELECT start_time, DATE_ADD(start_time, INTERVAL 10 MONTH)
FROM uber_rides;

SELECT ADDTIME(TIME(start_time), TIME(end_time))
FROM uber_rides;

-- DATETIME Vs TIMESTAMP
-- application data
-- Cols = content - description
-- created at - Timestamp when uploaded
-- updated at - Timestamp when update is made
USE campusx;

CREATE TABLE posts(
	post_id INTEGER PRIMARY KEY AUTO_INCREMENT,
	user_id INTEGER,
    content text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM posts;

INSERT INTO posts (user_id, content) VALUES (1, 'Hello work\ld');





