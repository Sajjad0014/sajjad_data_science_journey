USE laptop_data;


-- Categorical Numerical Bivariate Analysis
SELECT * FROM laptop;

-- We are considering Company and Price cols
SELECT Company, MIN(price) AS min_price, MAX(price), AVG(price), STD(price) FROM laptop
GROUP BY Company
ORDER BY min_price ASC;

-- Dealing with missing values
SELECT * FROM laptop;

-- making 5 rows or price col as NULL
UPDATE laptop
SET Price = NULL
WHERE RAND() < 0.01;

SELECT Price FROM laptop
ORDER BY Price;

-- 1st way - Replace missing values with mean price
SELECT AVG(Price) FROM laptop;

UPDATE laptop
SET Price = (SELECT AVG(Price) FROM laptop)
WHERE price IS NULL;

-- 2. Replace missing values with mean price of corresponding company
SELECT * FROM laptop
WHERE Price is NULL;

UPDATE laptop l1
SET Price = (SELECT AVG(Price) FROM laptop l2 WHERE l2.Company = l1.Company)
WHERE Price IS NULL;

-- corresponding company + processor
UPDATE laptop l1
SET Price = (SELECT AVG(Price) FROM laptop l2
			 WHERE l2.Company = l1.Company 
             AND
             l2.Cpu_name = l1.Cpu_name)
WHERE Price IS NULL;

-- The query above did not work
UPDATE laptop l1
JOIN (
	SELECT Company, Cpu_name, AVG(Price) AS avg_price
    FROM laptop
    WHERE Price IS NOT NULL
    GROUP BY Company, Cpu_name
) AS derived
ON l1.Company = derived.Company AND l1.Cpu_name = derived.Cpu_name
SET l1.Price = derived.avg_price
WHERE l1.Price IS NULL;

SELECT * FROM laptop
WHERE Price IS NULL;

-- Feature Engineering
SELECT * FROM laptop;

-- new feature ppi
ALTER TABLE laptop ADD COLUMN ppi INTEGER;

UPDATE laptop
SET ppi = ROUND(SQRT((resolution_width * resolution_width) + (resolution_height * resolution_height))/Inches, 2);

-- new feature screen size bracket
ALTER TABLE laptop ADD COLUMN screen_size VARCHAR(255) AFTER Inches;

SELECT *,
CASE
	WHEN NTILE(3) OVER(ORDER BY Inches) = 1 THEN 'small'
	WHEN NTILE(3) OVER(ORDER BY Inches) = 2 THEN 'medium'
	ELSE 'large'
END AS `type`
FROM laptop;

UPDATE laptop
SET screen_size = 
CASE
	WHEN Inches < 14 THEN 'small'
	WHEN Inches >= 14 AND Inches < 17 THEN 'medium'
	ELSE 'large'
END;

SELECT screen_size, AVG(price) FROM laptop
GROUP BY screen_size;

-- One hot encoding
SELECT * FROM laptop;

SELECT DISTINCT(gpu_brand) FROM laptop;

SELECT gpu_brand,
CASE WHEN gpu_brand = 'Intel' THEN 1 ELSE 0 END AS 'intel',
CASE WHEN gpu_brand = 'AMD' THEN 1 ELSE 0 END AS 'amd',
CASE WHEN gpu_brand = 'Nvidia' THEN 1 ELSE 0 END AS 'nvidia',
CASE WHEN gpu_brand = 'ARM' THEN 1 ELSE 0 END AS 'arm'
FROM laptop;

