-- Q1 Find out the average sleep duration of top 15 male candidates who's sleep duration are equal to 7.5 or greater than 7.5.
USE task_33;

SELECT * FROM sleep_efficiency;
-- avg_sleep_duration, male, top 15, 
SELECT AVG(`Sleep duration`) AS 'avg_sleep_duration'
FROM sleep_efficiency
WHERE gender = 'Male' AND `Sleep duration` >= 7.5
ORDER BY `Sleep duration` DESC LIMIT 15;

-- 2: Show avg deep sleep time for both gender. Round result at 2 decimal places.
-- Note: sleep time and deep sleep percentage will give you, deep sleep time.
SELECT gender, ROUND(AVG((`Deep sleep percentage` / 100) * `Sleep duration`), 2) AS 'avg_deep_sleep_time'
FROM sleep_efficiency
GROUP BY gender;

-- 3 Find out the lowest 10th to 30th light sleep percentage records 
-- where deep sleep percentage values are between 25 to 45. 
-- Display age, light sleep percentage and deep sleep percentage columns only.
SELECT Age, `Light sleep percentage` AS 'light_sleep_percentage', `Deep sleep percentage` AS `deep_sleep_percentage`
FROM sleep_efficiency
WHERE `Deep sleep percentage` BETWEEN 25 AND 45
ORDER BY light_sleep_percentage ASC LIMIT 10, 20;

-- 4 Group by on exercise frequency and smoking status and show average deep sleep time, 
-- average light sleep time and avg rem sleep time.
-- * Note the differences in deep sleep time for smoking and non smoking status
SELECT `Exercise frequency`, `Smoking status`, ROUND(AVG((`Deep sleep percentage` / 100) * `Sleep duration`), 2) AS 'avg_deep_sleep_time',
ROUND(AVG((`Light sleep percentage` / 100) * `Sleep duration`), 2) AS 'avg_light_sleep_time',
ROUND(AVG((`REM sleep percentage` / 100) * `Sleep duration`), 2) AS 'avg_rem_sleep_time'
FROM sleep_efficiency
GROUP BY `Exercise frequency`, `Smoking status`;

-- 5:` Group By on Awekning and show AVG Caffeine consumption, 
-- AVG Deep sleep time and AVG Alcohol consumption only 
-- for people who do exercise atleast 3 days a week. 
-- Show result in descending order awekenings
SELECT Awakenings, ROUND(AVG(`Caffeine consumption`), 2) AS 'avg_caffeine_consumption',
ROUND(AVG((`Deep sleep percentage`/100)*`Sleep duration`), 2) AS 'avg_deep_sleep_time',
ROUND(AVG(`Alcohol consumption`), 2) AS 'avg_alcohol_consumption'
FROM sleep_efficiency
WHERE `Exercise frequency` >= 3
GROUP BY Awakenings
ORDER BY Awakenings DESC;


-- power generation 
-- 6. Display those power stations which have average 'Monitored Cap.(MW)' (display the values) 
-- between 1000 and 2000 and the number of occurance of the power stations 
-- (also display these values) are greater than 200. Also sort the result in ascending order.
SELECT * FROM powergeneration;
-- count > 200 and avg_monitor between 1000 and 2000. power stations ASC
SELECT `Power station`, ROUND(AVG(`Monitored Cap.(MW)`), 2) AS 'avg_monitored_cap', COUNT(`Power Station`) AS 'num_of_power_stations'
FROM powergeneration
GROUP BY `Power Station`
HAVING (avg_monitored_cap BETWEEN 1000 AND 2000) AND COUNT(*) > 200
ORDER BY `Power Station` ASC;

-- Avg Cost of Undergrad College by State(USA) Dataset
-- 7. Display top 10 lowest "value" State names of which the Year either belong to 
-- 2013 or 2017 or 2021 and type is 'Public In-State'. 
-- Also the number of occurance should be between 6 to 10. 
-- Display the average value upto 2 decimal places, state names and the occurance of the states.
SELECT * FROM nces330_20;
-- year 2013, 17, 21 -> public in state
-- occurance 6 - 10
SELECT State, 
ROUND(AVG(Value), 2) AS 'avg_value',  
COUNT(*) AS 'occurance'
FROM nces330_20
WHERE Year IN (2013, 2017, 2021) AND Type = 'Public In-State'
GROUP BY State
HAVING occurance BETWEEN 6 AND 10
ORDER BY avg_value ASC LIMIT 10;

-- 8: Best state in terms of low education cost (Tution Fees) in 'Public' type university.
SELECT State, 
AVG(Value) AS 'avg_value'
FROM nces330_20
WHERE Type LIKE '%Public%' AND Expense LIKE '%Tuition%'
GROUP BY State
ORDER BY avg_value LIMIT 1;

-- 9. 2nd Costliest state for Private education in year 2021. Consider, Tution and Room fee both.
SELECT State, AVG(Value) AS 'avg_value'
FROM nces330_20
WHERE Type LIKE "%Private%" AND Year = 2021
GROUP BY State
ORDER BY avg_value DESC LIMIT 1, 1;

-- nces330_20
-- 10. Display total and average values of Discount_offered for all the combinations of 
-- 'Mode_of_Shipment' (display this feature) and 'Warehouse_block' (display this feature also) 
-- for all male ('M') and 'High' Product_importance. 
-- Also sort the values in descending order of Mode_of_Shipment 
-- and ascending order of Warehouse_block.
SELECT * FROM powergeneration;