-- Practice session

CREATE DATABASE campusx_delete;

USE campusx_delete;

CREATE TABLE users(
user_id INTEGER AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL UNIQUE,
password VARCHAR(255) NOT NULL,

CONSTRAINT campusx_users_pk PRIMARY KEY(user_id)
);

INSERT INTO users(name, email, password) VALUE ('BATMAN', 'batsy@gmail.com', 'bruce');

INSERT INTO users VALUE (NULL, 'BATMAN2', 'batsy2@gmail.com', 'bruce2');


INSERT INTO campusx_delete.users VALUES
(NULL, 'Albert', 'al@gmail.com', '5456'),
(NULL, 'Tanmay', 'Tanmay15@gmail.com', '356465'),
(NULL, 'Rohan Joshi', 'rohan@gmail.com', '098');


SELECT * FROM campusx_delete.users;

SELECT os AS 'Operating Systems', model, battery_capacity 
FROM campusx.smartphones;


SELECT model, 'smartphone' AS 'type' FROM campusx.smartphones;

SELECT DISTINCT(brand_name) AS 'All Brands', model
FROM campusx.smartphones;

SELECT DISTINCT(os) AS 'All OS'
FROM campusx.smartphones;

SELECT DISTINCT brand_name, processor_brand
FROM campusx.smartphones;

SELECT * FROM campusx.smartphones
WHERE brand_name = 'samsung';

SELECT * FROM campusx.smartphones
WHERE price > 50000;

SELECT * FROM campusx.smartphones
WHERE price BETWEEN 10000 AND 20000;

SELECT * FROM campusx.smartphones
WHERE price < 25000 AND rating > 80;

SELECT * FROM campusx.smartphones
WHERE brand_name = 'samsung' AND ram_capacity > 8;

SELECT * FROM campusx.smartphones
WHERE processor_brand IN ('snapdragon', 'exynos', 'bionic');

SELECT * FROM campusx.smartphones
WHERE processor_brand NOT IN ('snapdragon', 'bionic', 'exynos');

CREATE TABLE campusx.smartphones_backup AS
SELECT * FROM campusx.smartphones;

SELECT * FROM campusx.smartphones_backup
WHERE processor_brand = 'snapdragon';

UPDATE campusx.smartphones_backup
SET processor_brand = 'snapdragon2.0'
WHERE processor_brand = 'snapdragon';


UPDATE campusx.smartphones_backup
SET processor_brand = 'bioniq'
WHERE processor_brand = 'bionic';


SELECT * FROM campusx.smartphones_backup
WHERE processor_brand IN ('snapdragon2.0', 'bioniq');


DROP DATABASE campusx_delete;

SELECT * FROM campusx.smartphones;

SELECT MAX(price) FROM campusx.smartphones;

USE campusx;

SELECT MIN(price) FROM smartphones;

SELECT MIN(ram_capacity) FROM smartphones;

SELECT * FROM smartphones 
WHERE price = (SELECT MAX(price) FROM smartphones
WHERE brand_name = 'samsung');

SELECT * FROM smartphones
WHERE price = (SELECT MIN(price) FROM smartphones
WHERE brand_name = 'samsung');

SELECT AVG(rating) FROM smartphones;

SELECT AVG(rating) FROM smartphones
WHERE brand_name = 'apple';

SELECT SUM(price)
FROM smartphones;

SELECT COUNT(*) FROM smartphones
WHERE brand_name = 'oneplus';

SELECT COUNT(DISTINCT(brand_name)) FROM smartphones;

SELECT COUNT(DISTINCT(processor_brand)) FROM smartphones;

SELECT STD(screen_size) FROM smartphones;

SELECT VARIANCE(screen_size) FROM smartphones;

SELECT ABS(price - 1000000) AS 'temp' FROM smartphones;

SELECT * FROM smartphones;

-- Find the average battery capacity and the average primary rear camera resolution for all smartphones 
-- with a price greater than or equal to 100000
SELECT AVG(battery_capacity), AVG(primary_camera_rear) 
FROM smartphones
WHERE price >= 100000;

-- Find the average internal memory capacity of smartphones that have a refresh rate of 120 Hz or higher 
-- and a front-facing camera resolution greater than or equal to 20 megapixels.
SELECT AVG(internal_memory) FROM smartphones
WHERE refresh_rate >= 120 AND primary_camera_front >= 20;

-- Find the number of smartphones with 5G capabilities
SELECT COUNT(has_5g) FROM smartphones;