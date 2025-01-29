USE campusx;

SELECT * FROM smartphones;

-- sort karne ke liye ORDER BY use karte
SELECT model, screen_size FROM smartphones
WHERE brand_name = 'samsung'
ORDER BY screen_size DESC LIMIT 5;

SELECT model, num_rear_cameras + num_front_cameras AS 'total_cameras'
FROM smartphones
ORDER BY total_cameras DESC;

SELECT model, 
ROUND(SQRT(resolution_width * resolution_width + resolution_height * resolution_height) / screen_size) AS 'ppi_values'
FROM smartphones
ORDER BY ppi_values DESC;

SELECT model, battery_capacity
FROM smartphones
ORDER BY battery_capacity DESC LIMIT 2, 3;

SELECT model, rating/10 AS 'Rating'
FROM smartphones
WHERE brand_name = 'apple'
ORDER BY Rating ASC LIMIT 1;

SELECT model, rating FROM smartphones
ORDER BY brand_name ASC, rating DESC;

SELECT model, price FROM smartphones
ORDER BY price DESC LIMIT 1;

SELECT brand_name, COUNT(*) AS 'num_phones',
ROUND(AVG(price)) AS 'avg_price',
MAX(rating) AS 'max_rating',
ROUND(AVG(screen_size), 2) AS 'avg_screen_size',
ROUND(AVG(battery_capacity)) AS 'avg_battery_capacity' 
FROM smartphones
GROUP BY brand_name
ORDER BY num_phones DESC LIMIT 15;

SELECT has_nfc, ROUND(AVG(price), 2) AS 'avg_price', ROUND(AVG(rating)) AS 'avg_rating'
FROM smartphones
GROUP BY has_nfc;

SELECT fast_charging_available, AVG(price) AS 'avg_price', AVG(rating) AS 'avg_ratings'
FROM smartphones
GROUP BY fast_charging_available;

SELECT extended_memory_available, AVG(price) FROM smartphones
GROUP BY extended_memory_available;

SELECT brand_name, processor_brand, COUNT(*) AS 'num_phones', ROUND(AVG(primary_camera_rear), 2) AS 'avg_camera_resolution' 
FROM smartphones
GROUP BY brand_name, processor_brand;

SELECT brand_name, ROUND(AVG(price)) AS 'avg_price'
FROM smartphones
GROUP BY brand_name
ORDER BY avg_price DESC LIMIT 5;

SELECT brand_name, ROUND(AVG(screen_size)) AS 'avg_screen_size'
FROM smartphones
GROUP BY brand_name
ORDER BY avg_screen_size ASC LIMIT 5;

SELECT has_5g, AVG(price) AS 'avg_price',
ROUND(AVG(rating)) AS 'rating'
FROM smartphones
GROUP BY has_5g;

SELECT brand_name, COUNT(*) AS 'count' 
FROM smartphones
WHERE has_nfc = 'True' AND has_ir_blaster = 'True'
GROUP BY brand_name
ORDER BY count DESC LIMIT 1;

-- 9.	Find all Samsung 5g enabled smartphones and find out the avg price for NFC and Non-NFC phones
SELECT has_nfc, AVG(price) AS 'avg_price'
FROM smartphones
WHERE brand_name = 'samsung' AND has_5g = 'True'
GROUP BY has_nfc;

SELECT brand_name, COUNT(*) AS 'count', AVG(price) AS 'avg_price'
FROM smartphones
GROUP BY brand_name
HAVING count > 20
ORDER BY count DESC;

SELECT brand_name, COUNT(*) AS 'count', ROUND(AVG(rating), 2) AS 'avg_rating'
FROM smartphones
GROUP BY brand_name
HAVING count > 20
ORDER BY avg_rating DESC;

-- Top 3 brand_name count > 10, where refresh rate >= 90 and fast_charging = 1  
SELECT * FROM smartphones;

SELECT brand_name, COUNT(*) AS 'count', ROUND(AVG(ram_capacity), 2) AS 'avg_ram'
FROM smartphones
WHERE refresh_rate > 90 AND fast_charging_available = 1
GROUP BY brand_name
HAVING count > 10
ORDER BY avg_ram DESC LIMIT 3;

-- 3.	Find the avg price of all the phone brands with avg rating > 70 and num_phones more than 10 
-- among all 5g enabled phones
-- avg_price, avg_rating > 70, brand_name group, 5g 1
SELECT brand_name, ROUND(AVG(price), 2) AS 'avg_price', ROUND(AVG(rating)) AS 'avg_rating'
FROM smartphones
WHERE has_5g = 'True'
GROUP BY brand_name
HAVING COUNT(*) > 10 AND avg_rating > 70;


-- -	Find the top 5 batsman in IPL
SELECT * FROM ipl;

-- group by batter, batsman_run SUM, DESC LIMIT 5,
SELECT batter, SUM(batsman_run) AS 'total_batsman_runs'
FROM ipl
GROUP BY batter
ORDER BY total_batsman_runs DESC LIMIT 5;

-- 	Find the 2nd Highest 6 hitter in IPL
SELECT batter, COUNT(*) AS 'num_of_6s'
FROM ipl
WHERE batsman_run = 6
GROUP BY batter
ORDER BY num_of_6s DESC LIMIT 1, 1;

-- Find all batsmen with centuries in IPL
-- Having count > 100
SELECT batter, SUM(batsman_run) AS 'runs'
FROM ipl
GROUP BY batter, ID
HAVING runs >= 100
ORDER BY batter DESC;

-- GROUP BY ID, batter HAVING balls > 1000 COUNT(*) balls, SUM(batsman_runs) total_runs / balls ORDER BY 

-- 	Find the top 5 batsman with highest strike rate who played a min of 1000 balls
SELECT batter, COUNT(*) AS 'balls', SUM(batsman_run) AS 'total_runs', (SUM(batsman_run) / COUNT(*) * 100) AS 'strike_rate'
FROM ipl
GROUP BY batter
HAVING balls >= 1000
ORDER BY strike_rate DESC LIMIT 5;

SELECT batter, SUM(batsman_run), COUNT(batsman_run), 
ROUND((SUM(batsman_run)/COUNT(batsman_run)) * 100, 2) AS 'strike_rate'
FROM campusx.ipl
GROUP BY batter
HAVING COUNT(batsman_run) > 1000
ORDER BY strike_rate DESC LIMIT 5;
