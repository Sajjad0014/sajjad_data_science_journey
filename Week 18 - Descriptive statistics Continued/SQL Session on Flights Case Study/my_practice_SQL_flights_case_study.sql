USE campusx;

SELECT * FROM flights;

-- 1. Find the month with most number of flights
SELECT MONTHNAME(Date_of_Journey) AS `month`, COUNT(*) FROM flights
GROUP BY `month`
ORDER BY COUNT(*) DESC LIMIT 1;

-- 2. Which week day has most costly flights
SELECT DAYNAME(Date_of_Journey) AS day_name, AVG(Price) AS avg_price FROM flights
GROUP BY day_name
ORDER BY avg_price DESC LIMIT 1;

-- 3. Find number of indigo flights every month
SELECT MONTHNAME(Date_of_Journey), COUNT(*) FROM flights
WHERE airline = 'Indigo'
GROUP BY MONTHNAME(Date_of_journey)
ORDER BY MONTHNAME(Date_of_Journey) ASC;

-- 4. Find list of all flights that depart between 10AM and 2PM from Banglore to Delhi.
SELECT * FROM flights
WHERE Destination = 'Delhi' 
AND Source = 'Banglore' 
AND Dep_Time > '10:00:00' AND Dep_Time < '14:00:00';

-- 5. Find the number of flights departing on weekends from Bangalore
SELECT COUNT(*) FROM flights
WHERE Source = 'Banglore' AND DAYNAME(date_of_journey) IN ('saturday', 'sunday');

-- 6. Calculate the arrival time for all flights by adding the duration to the departure time.
SELECT * FROM flights;

-- Creating a col named Departure in Standard Date time format
ALTER TABLE flights
ADD COLUMN Departure DATETIME;

SELECT date_of_journey, Dep_Time, STR_TO_DATE(CONCAT(date_of_journey, ' ', Dep_Time), '%Y-%m-%d %H:%i')
FROM flights;

UPDATE flights
SET Departure = STR_TO_DATE(CONCAT(date_of_journey, ' ', Dep_Time), '%Y-%m-%d %H:%i');

-- creating 2 cols.
-- 1st col 'Duration_in_minutes'
-- 2nd col 'Arrival', which will be in standard DateTime format
ALTER TABLE flights
ADD COLUMN Duration_in_minutes INTEGER,
ADD COLUMN Arrival DATETIME;

SELECT Duration,
SUBSTRING_INDEX(duration, ' ', 1), 
SUBSTRING_INDEX(duration, ' ', -1),
REPLACE(SUBSTRING_INDEX(duration, ' ', 1),'h', ''),
REPLACE(SUBSTRING_INDEX(duration, ' ', 1),'h', '') * 60 +
CASE
	WHEN SUBSTRING_INDEX(duration, ' ', -1) = SUBSTRING_INDEX(duration, ' ', 1) THEN 0
	ELSE REPLACE(SUBSTRING_INDEX(duration, ' ', -1), 'm', '')
END AS 'mins',
CASE 
	WHEN duration LIKE '%h %m' THEN
		SUBSTRING_INDEX(duration, 'h', 1) * 60 + SUBSTRING_INDEX(SUBSTRING_INDEX(duration, ' ', -1), 'm', 1)
    WHEN duration LIKE '%h' THEN
		SUBSTRING_INDEX(duration, 'h', 1) * 60
	WHEN duration LIKE '%m' THEN
		SUBSTRING_INDEX(duration, 'm', 1)
END AS 'new_mins'
FROM flights;

-- UPDATE flights
-- SET duration_in_minutes = REPLACE(SUBSTRING_INDEX(duration, ' ', 1), 'h', '') * 60 +
-- CASE
-- 	WHEN SUBSTRING_INDEX(duration, ' ', -1) = SUBSTRING_INDEX(duration, ' ', 1) THEN 0
-- 	ELSE CAST(REPLACE(SUBSTRING_INDEX(duration, ' ', -1), 'm', '') AS UNSIGNED)
-- END;

-- Above query did not work
-- Use this query instead
UPDATE flights
SET duration_in_minutes = 
CASE 
	WHEN duration LIKE '%h %m' THEN
		SUBSTRING_INDEX(duration, 'h', 1) * 60 + SUBSTRING_INDEX(SUBSTRING_INDEX(duration, ' ', -1), 'm', 1)
    WHEN duration LIKE '%h' THEN
		SUBSTRING_INDEX(duration, 'h', 1) * 60
	WHEN duration LIKE '%m' THEN
		SUBSTRING_INDEX(duration, 'm', 1)
END;

SELECT * FROM flights;

-- Adding Duration in Departure
SELECT departure, duration_in_minutes, DATE_ADD(departure, INTERVAL duration_in_minutes MINUTE)
FROM flights;

UPDATE flights
SET Arrival = DATE_ADD(departure, INTERVAL duration_in_minutes MINUTE);

SELECT TIME(arrival) FROM flights;

-- 7. Calculate the arrival date for all the flights
SELECT DATE(arrival) FROM flights;

-- 8. Find the number of flights which travel on multiple dates.
SELECT * FROM flights;

SELECT COUNT(*)
FROM flights
WHERE DATE(departure) != DATE(arrival);

-- 9. Calculate the average duration of flights between all city pairs. 
-- The answer should be in 'xh ym' format
SELECT Source, Destination, 
TIME_FORMAT(SEC_TO_TIME(AVG(Duration_in_minutes) * 60), '%kh %im') AS avg_duration
FROM flights
GROUP BY Source, Destination;

-- 10. Find all flights which departed before midnight but arrived at their destination 
-- after midnight having only 0 stops.
SELECT * FROM flights
WHERE Total_Stops = 'non-stop' AND DATE(departure) < DATE(arrival);

-- 11. Find quarter wise number of flights for each airline
SELECT airline, QUARTER(departure), COUNT(*) 
FROM flights
GROUP BY Airline, QUARTER(departure)
ORDER BY COUNT(*) DESC;

-- 12. Find the longest flight distance(between cities in terms of time) in India
SELECT Source, Destination, AVG(Duration)
FROM flights
GROUP BY Source, Destination
ORDER BY AVG(Duration) DESC;

-- 13. Average time duration for flights that have 1 stop vs more than 1 stops
-- and on price col
SELECT * FROM flights;

WITH temp_table AS (SELECT *,
CASE
	WHEN Total_stops = 'non-stop' THEN 'non-stop'
    ELSE 'with stop'
END AS temp
FROM flights)

SELECT temp, 
AVG(duration_in_minutes),
TIME_FORMAT(SEC_TO_TIME(AVG(duration_in_minutes) * 60), '%kh %im') AS 'avg_duration',
AVG(price) AS 'avg_price'
FROM temp_table
GROUP BY temp;

-- 14. Find all Air India flights in a given date range originating from Delhi
-- Date range -> 1st Jan 2019 to 10th Mar 2019
SELECT * FROM flights
WHERE Source = 'Delhi'
AND DATE(departure) BETWEEN '2019-01-01' AND '2019-03-10';

-- 15. Find the longest flight of each airline
SELECT Airline, 
TIME_FORMAT(SEC_TO_TIME(MAX(Duration_in_minutes) * 60), '%kh %im') AS 'max_duration'
FROM flights
GROUP BY Airline
ORDER BY MAX(Duration_in_minutes) DESC;

-- 16. Find all the pair of cities having average time duration > 3 hours
SELECT Source, Destination, 
TIME_FORMAT(SEC_TO_TIME(AVG(duration_in_minutes) * 60), '%kh %im') AS 'avg_duration'
FROM flights
GROUP BY Source, Destination
HAVING AVG(duration_in_minutes) > 180;

-- 17. Make a weekday vs time grid showing frequency of flights from Banglore and Delhi
SELECT * FROM flights;

SELECT @@sql_mode;

SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

SELECT DAYNAME(Departure),
SUM(CASE WHEN HOUR(Departure) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS '12AM - 6AM',
SUM(CASE WHEN HOUR(Departure) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS '6AM - 12PM',
SUM(CASE WHEN HOUR(Departure) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS '12PM - 6PM',
SUM(CASE WHEN HOUR(Departure) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS '6PM - 12PM',
SUM(CASE WHEN HOUR(Departure) BETWEEN 0 AND 23 THEN 1 ELSE 0 END) AS 'Total Flights in 24 Hour'
FROM flights
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY DAYNAME(Departure)
ORDER BY DAYOFWEEK(Departure) ASC;


-- 18. Make a weekday vs time grid showing avg flight price from Banglore and Delhi
SELECT DAYNAME(Departure),
AVG(CASE WHEN HOUR(Departure) BETWEEN 0 AND 5 THEN price ELSE 0 END) AS '12AM - 6AM',
AVG(CASE WHEN HOUR(Departure) BETWEEN 6 AND 11 THEN price ELSE 0 END) AS '6AM - 12PM',
AVG(CASE WHEN HOUR(Departure) BETWEEN 12 AND 17 THEN price ELSE 0 END) AS '12PM - 6PM',
AVG(CASE WHEN HOUR(Departure) BETWEEN 18 AND 23 THEN price ELSE 0 END) AS '6PM - 12PM',
AVG(CASE WHEN HOUR(Departure) BETWEEN 0 AND 23 THEN price ELSE 0 END) AS 'Total Flights in 24 Hour'
FROM flights
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY DAYNAME(Departure)
ORDER BY DAYOFWEEK(Departure) ASC;

-- This above query is wrong because when the CASE (IF over here) 
-- is becoming False we are not considering it
SELECT DAYNAME(Departure),
AVG(CASE WHEN HOUR(Departure) BETWEEN 0 AND 5 THEN price ELSE NULL END) AS '12AM - 6AM',
AVG(CASE WHEN HOUR(Departure) BETWEEN 6 AND 11 THEN price ELSE NULL END) AS '6AM - 12PM',
AVG(CASE WHEN HOUR(Departure) BETWEEN 12 AND 17 THEN price ELSE NULL END) AS '12PM - 6PM',
AVG(CASE WHEN HOUR(Departure) BETWEEN 18 AND 23 THEN price ELSE NULL END) AS '6PM - 12PM',
AVG(CASE WHEN HOUR(Departure) BETWEEN 0 AND 23 THEN price ELSE NULL END) AS 'Total Flights in 24 Hour'
FROM flights
WHERE Source = 'Banglore' AND Destination = 'Delhi'
GROUP BY DAYNAME(Departure)
ORDER BY DAYOFWEEK(Departure) ASC;