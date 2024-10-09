USE laptop_data;

SELECT * FROM laptop;

-- 1. head -> tail -> sample
SELECT * FROM laptop
ORDER BY `index` LIMIT 5;

SELECT * FROM laptop
ORDER BY `index` DESC LIMIT 5;

SELECT * FROM laptop
ORDER BY rand() LIMIT 5;

-- Univariate analysis
-- 2. numerical_col -> price

-- quartiles (Q1, Median, Q3) are not used because there is a syntax error
SELECT 
    COUNT(Price) AS total_count,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price,
    AVG(Price) AS avg_price,
    STD(Price) AS std_dev
FROM laptop;

-- just to show you what the ordered_laptops look like
WITH ordered_laptops AS (
    SELECT Price, 
	ROW_NUMBER() OVER (ORDER BY Price) AS row_num,
    COUNT(*) OVER() AS total_count
    FROM laptop
)
SELECT * FROM ordered_laptops;


WITH ordered_laptops AS (
    SELECT Price, 
	ROW_NUMBER() OVER (ORDER BY Price) AS row_num,
    COUNT(*) OVER() AS total_count
    FROM laptop
)
SELECT 
    COUNT(Price) AS total_count,
    MIN(Price) AS min_price,
    MAX(Price) AS max_price,
    AVG(Price) AS avg_price,
    STD(Price) AS std_dev,

    -- Q1 (25th Percentile)
    (SELECT Price FROM ordered_laptops 
     WHERE row_num = FLOOR(0.25 * total_count)) AS Q1,

    -- Median (50th Percentile)
    (SELECT Price FROM ordered_laptops 
     WHERE row_num = FLOOR(0.5 * total_count)) AS Median,

    -- Q3 (75th Percentile)
    (SELECT Price FROM ordered_laptops 
     WHERE row_num = FLOOR(0.75 * total_count)) AS Q3

FROM laptop;

-- missing value
SELECT COUNT(Price)
FROM laptop
WHERE Price IS NULL;

-- outliers
WITH ordered_laptops AS (
	SELECT Price,
    ROW_NUMBER() OVER (ORDER BY Price) as row_num,
    COUNT(*) OVER() AS total_count
    FROM laptop
)

SELECT * 
FROM 
(SELECT *,
(SELECT Price FROM ordered_laptops
 WHERE row_num = FLOOR(0.25 * total_count)) AS Q1,
 
(SELECT Price FROM ordered_laptops
 WHERE row_num = FLOOR(0.75 * total_count)) AS Q3

FROM laptop) t
WHERE t.Price < t.Q1 - (1.5 * (t.Q3 - t.Q1)) OR
	  t.Price > t.Q3 + (1.5 * (t.Q3 - t.Q1));
      
-- horizontal/vertical Histogram
-- we have data in range 9k to 343k
-- Bucket size of 25k. 
-- 0 - 25, 26 - 50, 51 - 75, 76 - 100, 101 - 350.......

SELECT Price,
	CASE WHEN Price BETWEEN 0 and 25000 THEN '*' ELSE 0 END AS '0-25k',
	CASE WHEN Price BETWEEN 25001 and 50000 THEN '*' ELSE 0 END AS '25k-50k',
	CASE WHEN Price BETWEEN 50001 and 75000 THEN '*' ELSE 0 END AS '50k-75k',
	CASE WHEN Price BETWEEN 75001 and 100000 THEN '*' ELSE 0 END AS '75k-100k',
	CASE WHEN Price > 100001 THEN '*' ELSE 0 END AS '>100k'
FROM laptop;

SELECT t.buckets, REPEAT('*', COUNT(*)/5)
FROM
(SELECT Price,
CASE 
	WHEN Price BETWEEN 0 AND 25000 THEN '0-25k'
	WHEN Price BETWEEN 25001 AND 50000 THEN '25k-50k'
	WHEN Price BETWEEN 50001 AND 75000 THEN '50k-75k'
	WHEN Price BETWEEN 75001 AND 100000 THEN '75k-100k'
	WHEN Price > 100001 THEN '>100k'
	ELSE '<100k'
END AS 'buckets'
FROM laptop) t
GROUP BY t.buckets;


-- 3. Categorical cols
-- value count = Frequency count
-- Company 
SELECT Company, COUNT(Company) 
FROM laptop
GROUP BY Company;


-- Bivariate Analysis
-- 4. numerical - numerical
WITH ordered_laptops AS (
    SELECT Price, 
        ROW_NUMBER() OVER (ORDER BY Price) AS row_num,
        COUNT(*) OVER() AS total_count
    FROM laptop
),
laptop_stats AS (
    SELECT 
        COUNT(Price) AS total_count,
        MIN(Price) AS min_value,
        MAX(Price) AS max_value,
        AVG(Price) AS avg_value,
        STDDEV(Price) AS std_dev,
        (SELECT Price FROM ordered_laptops 
         WHERE row_num = FLOOR(0.25 * total_count)) AS Q1,
        (SELECT Price FROM ordered_laptops 
         WHERE row_num = FLOOR(0.5 * total_count)) AS Median,
        (SELECT Price FROM ordered_laptops 
         WHERE row_num = FLOOR(0.75 * total_count)) AS Q3
    FROM laptop
),
ordered_inches AS (
    SELECT Inches, 
        ROW_NUMBER() OVER (ORDER BY Inches) AS row_num,
        COUNT(*) OVER() AS total_count
    FROM laptop
),
inches_stats AS (
    SELECT 
        COUNT(Inches) AS total_count,
        MIN(Inches) AS min_value,
        MAX(Inches) AS max_value,
        AVG(Inches) AS avg_value,
        STDDEV(Inches) AS std_dev,
        (SELECT Inches FROM ordered_inches 
         WHERE row_num = FLOOR(0.25 * total_count)) AS Q1,
        (SELECT Inches FROM ordered_inches 
         WHERE row_num = FLOOR(0.5 * total_count)) AS Median,
        (SELECT Inches FROM ordered_inches
         WHERE row_num = FLOOR(0.75 * total_count)) AS Q3
    FROM laptop
)
SELECT total_count, min_value, max_value, avg_value, std_dev, Q1, Median, Q3
FROM laptop_stats

UNION ALL

SELECT total_count, min_value, max_value, avg_value, std_dev, Q1, Median, Q3
FROM inches_stats;

-- scatter plot
-- Price and cpu_speed
SELECT cpu_speed, Price
FROM laptop;

-- correlation - Sorry I don't think it exists
SELECT CORR(cpu_speed, Price)
FROM laptop;

-- 5. Categorical - Categorical
-- contingency table
SELECT * FROM laptop;

-- let's assume these numbers
-- Brand      0  		1
-- Apple      37		43
-- Dell 	  110 		28
-- HP 		  67   		90

SELECT Company,
SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) AS 'Touchscreen_yes',
SUM(CASE WHEN Touchscreen = 0 THEN 1 ELSE 0 END) AS 'Touchscreen_no'
FROM laptop
GROUP BY Company;

-- between cpu_brand and Company
SELECT DISTINCT cpu_brand FROM laptop;

SELECT Company,
SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'Intel',
SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'Samsung',
SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'AMD'
FROM laptop
GROUP BY Company;
