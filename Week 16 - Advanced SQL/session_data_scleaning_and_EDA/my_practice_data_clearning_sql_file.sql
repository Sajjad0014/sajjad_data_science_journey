USE laptop_data;

SELECT * FROM laptop_data.laptop;

-- 1. Create backup
-- create empty table 
CREATE TABLE laptops_backup LIKE laptop;

INSERT INTO laptops_backup
SELECT * FROM laptop;

SELECT * FROM laptops_backup;

-- 2. Number of rows - 1272 rows
-- 3. check memory consumption for reference
SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptop_data'
AND TABLE_NAME = 'laptop';
-- 256 kb
-- Updating after going till the end. it has now become 224 kb

SELECT * FROM laptop;

-- 4. Drop Unnamed 
ALTER TABLE laptop DROP COLUMN `Unnamed: 0`;

SELECT * FROM laptop;

-- 5. dropping null values
DELETE FROM laptop
WHERE `index` IN
(SELECT * FROM laptop
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL 
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL 
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL 
AND WEIGHT IS NULL AND Price IS NULL);

SELECT * FROM laptop;

-- 6. Drop Duplicates (Don't Run)
SELECT * FROM zomato.duplicates;

DELETE FROM zomato.duplicates
WHERE id NOT IN (SELECT MIN(id)
FROM zomato.duplicates
GROUP BY name, gender, age);


-- adding index column
ALTER TABLE laptop
ADD COLUMN `index` INT;

SET @row_number = -1;

UPDATE laptop 
SET `index` = (@row_number := @row_number + 1);

ALTER TABLE laptop
MODIFY COLUMN `index` INT FIRST;

SELECT * FROM laptop;

-- 7. Clean RAM -> change col data type
-- if we use DISTINCT on categorical column we can identify 2 things 
-- 1. Whether we have any missing values
-- 2. What are the differnt kinds of values that are present 
SELECT DISTINCT Company FROM laptop;

SELECT DISTINCT Typename FROM laptop;

-- converting Inches from DOUBLE to DECIMAL
ALTER TABLE laptop MODIFY COLUMN Inches DECIMAL(10, 1);
SELECT DISTINCT Inches FROM laptop;

-- Converting Ram from str to INT
-- step 1 - remove GB 
UPDATE laptop l1
JOIN (SELECT `index`, REPLACE(Ram, "GB", '') AS 'new_ram' FROM laptop) l2
ON l1.`index` = l2.`index`
SET l1.Ram = l2.new_ram;
-- convert it to INT
ALTER TABLE laptop MODIFY COLUMN Ram INTEGER;

-- 8. Converting Weight to INT and removing kg from it
-- removing kg
UPDATE laptop l1
JOIN (SELECT `index`, REPLACE(Weight, 'kg', '') AS 'new_weight' FROM laptop) l2
ON l1.`index` = l2.`index`
SET l1.Weight = l2.new_weight;
-- Now converting str to INT
ALTER TABLE laptop MODIFY COLUMN Weight FLOAT;
-- debugging the ? in one row
SELECT * FROM laptop
WHERE Weight REGEXP '[^0-9.]';
UPDATE laptop 
SET Weight = NULL
WHERE Weight REGEXP '[^0-9.]';
-- Rerunning
ALTER TABLE laptop MODIFY COLUMN Weight FLOAT;

-- 9. ROUNDing Price and then changing its datatype to INTEGER
UPDATE laptop l1
JOIN (SELECT `index`, ROUND(Price) AS 'new_price' FROM laptop) l2
ON l1.`index` = l2.`index`
SET l1.Price = l2.new_price;

ALTER TABLE laptop MODIFY COLUMN Price INTEGER;

-- 10. Combining categories of Operating systems
SELECT DISTINCT OpSys FROM laptop;
-- we are going to combine and sort them in these groups
-- mac
-- windows
-- linux
-- no os
-- Android chrome(others)
SELECT OpSys,
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END AS 'os_brand'
FROM laptop;
-- Now converting
UPDATE laptop
SET OpSys = CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END;

-- 11. For Gpu, we will make 2 new columns 'gpu_brand' and 'gpu_name'
ALTER TABLE laptop
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFtER gpu_brand;

SELECT * FROM laptop;

SELECT Gpu, SUBSTRING_INDEX(Gpu, ' ', 1) AS 'new_gpu_brand' FROM laptop;

UPDATE laptop l1
JOIN (SELECT `index`, SUBSTRING_INDEX(Gpu, ' ', 1) AS 'new_gpu_brand' FROM laptop) l2 
ON l2.index = l1.index
SET l1.gpu_brand = l2.new_gpu_brand;

SELECT Gpu, REPLACE(Gpu, Gpu_brand, ' ') AS 'new_gpu_names' FROM laptop;

UPDATE laptop l1
JOIN (SELECT `index`, REPLACE(Gpu, Gpu_brand, ' ') AS 'new_gpu_name' FROM laptop) l2 
ON l2.index = l1.index
SET l1.gpu_name = l2.new_gpu_name;

-- dropping Gpu
ALTER TABLE laptop DROP COLUMN Gpu;

-- 12. For CPU, we are going to create 3 columns

ALTER TABLE laptop
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10, 1) AFTER cpu_name;
 
-- cpu_brand
SELECT Cpu, SUBSTRING_INDEX(Cpu, " ", 1) FROM laptop;

UPDATE laptop l1
JOIN(SELECT `index`, SUBSTRING_INDEX(Cpu, " ", 1) AS 'new_cpu_brand' FROM laptop) l2
ON l1.`index` = l2.`index`
SET l1.cpu_brand = l2.new_cpu_brand;
 
-- cpu_speed
SELECT Cpu, CAST(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1), 'GHz', '') AS DECIMAL(10, 2)) AS 'new_cpu_speed' FROM laptop;
 
UPDATE laptop l1
JOIN(SELECT `index`, CAST(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1), 'GHz', '') AS DECIMAL(10, 2)) AS 'new_cpu_speed' 
	 FROM laptop) l2
ON l1.`index` = l2.`index`
SET l1.cpu_speed = l2.new_cpu_speed;

-- cpu_name
SELECT Cpu,
REPLACE(REPLACE(Cpu, cpu_brand, ''), SUBSTRING_INDEX(REPLACE(Cpu, cpu_brand, ''), ' ', -1), '')
FROM laptop;

UPDATE laptop l1
JOIN(SELECT `index`, 
	 REPLACE(REPLACE(Cpu, cpu_brand, ''), SUBSTRING_INDEX(REPLACE(Cpu, cpu_brand, ''), ' ', -1), '') AS 'new_cpu_name' 
	 FROM laptop) l2
ON l1.`index` = l2.`index`
SET l1.cpu_name = l2.new_cpu_name;

-- dropping CPU
ALTER TABLE laptop DROP COLUMN Cpu;

USE laptop_data;
SELECT * FROM laptop;

-- 13. Splitting Resolution column
SELECT ScreenResolution, 
SUBSTRING_INDEX(ScreenResolution, ' ', -1),
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', 1),
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', -1)  
FROM laptop;

ALTER TABLE laptop
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width;

UPDATE laptop
SET resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', 1),
resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, ' ', -1), 'x', -1);

ALTER TABLE laptop
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

SELECT ScreenResolution, ScreenResolution LIKE '%Touch%' 
FROM laptop;

UPDATE laptop
SET touchscreen = ScreenResolution LIKE '%Touch%'; 

ALTER TABLE laptop
DROP COLUMN ScreenResolution;

SELECT * FROM laptop;

-- From 12 we have got cpu_name, we will work on it and categories them
SELECT cpu_name FROM laptop;

SELECT cpu_name,
SUBSTRING_INDEX(TRIM(cpu_name), ' ', 2)
FROM laptop;

UPDATE laptop
SET cpu_name = SUBSTRING_INDEX(TRIM(cpu_name), ' ', 2);

-- 14 Memory - ROM
-- Breaking into 3 columns 
-- 1. type
-- 2. Primary storage
-- 3. Secondary storage
SELECT Memory FROM laptop;

ALTER TABLE laptop
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

SELECT DISTINCT Memory From laptop;

SELECT Memory,
CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
	WHEN Memory LIKE '%SSD%' THEN 'SSD'
	WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash storage'
	WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
	WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END AS 'memory_type'
FROM laptop;

UPDATE laptop
SET memory_type = CASE
	WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
	WHEN Memory LIKE '%SSD%' THEN 'SSD'
	WHEN Memory LIKE '%HDD%' THEN 'HDD'
    WHEN Memory LIKE '%Flash Storage%' THEN 'Flash storage'
	WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
	WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
    ELSE NULL
END;

-- splitting on + 
SELECT Memory,
REGEXP_SUBSTR(SUBSTRING_INDEX(Memory, '+', 1), '[-0-9]+'),
REGEXP_SUBSTR(TRIM(CASE WHEN Memory LIKE '%+%' THEN SUBSTRING_INDEX(Memory, '+', -1) ELSE 0 END), '[0-9]+')
FROM laptop;


UPDATE laptop
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory, '+', 1), '[-0-9]+'),
secondary_storage = REGEXP_SUBSTR(TRIM(CASE WHEN Memory LIKE '%+%' THEN SUBSTRING_INDEX(Memory, '+', -1) ELSE 0 END), '[0-9]+');

SELECT * FROM laptop;


-- in secondary_storage and primary_storage we need to convert 1 and 2 to GB by multiplying by 1024
SELECT primary_storage,
CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage,
CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END
FROM laptop;


UPDATE laptop
SET primary_storage = CASE WHEN primary_storage <= 2 THEN primary_storage*1024 ELSE primary_storage END,
secondary_storage = CASE WHEN secondary_storage <= 2 THEN secondary_storage*1024 ELSE secondary_storage END;

ALTER TABLE laptop 
DROP COLUMN Memory;

-- dropping gpu_name because they are too much variety
ALTER TABLE laptop
DROP COLUMN gpu_name;

SELECT * FROM laptop;