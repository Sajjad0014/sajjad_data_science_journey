USE session34;

SELECT * FROM users1 t1
CROSS JOIN `groups` t2;

SELECT * FROM membership t1
INNER JOIN users1 t2
ON t1.user_id = t2.user_id;

SELECT * FROM membership t1
LEFT JOIN users1 t2
ON t1.user_id = t2.user_id;

SELECT *
FROM membership t1
RIGHT JOIN users1 t2
ON t1.user_id = t2.user_id;

SELECT * FROM membership t1
LEFT JOIN users1 t2
ON t1.user_id = t2.user_id

UNION

SELECT * FROM membership t1
RIGHT JOIN users1 t2
ON t1.user_id = t2.user_id;

SELECT * FROM person1
UNION
SELECT * FROM person2;

SELECT * FROM person1
UNION ALL
SELECT * FROM person2;

SELECT * FROM person1
INTERSECT
SELECT * FROM person2;

SELECT * FROM person1
EXCEPT
SELECT * FROM person2;

SELECT * FROM users1 t1
JOIN users1 t2
ON t1.emergency_contact = t2.user_id;

SELECT * FROM students t1
JOIN class t2
ON t1.class_id = t2.class_id AND t1.enrollment_year = t2.class_year;

SELECT *
FROM order_details t1
JOIN orders t2
ON t1.order_id = t2.order_id
JOIN users t3
ON t2.user_id = t3.user_id;

SELECT t1.order_id, t1.amount, t1.profit, t3.name
FROM order_details t1
JOIN orders t2
ON t1.order_id = t2.order_id
JOIN users t3
ON t2.user_id = t3.user_id;

SELECT t2.order_id, t1.name, t1.city
FROM users t1
JOIN orders t2
ON t1.user_id = t2.user_id;

SELECT t1.order_id, t2.category
FROM order_details t1
JOIN category t2
ON t1.category_id = t2.category_id;

SELECT *
FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id
WHERE t2.city = 'pune';

SELECT *
FROM order_details t1
JOIN category t2
ON t1.category_id = t2.category_id
WHERE t2.category = 'chairs';

SELECT t1.order_id, SUM(t2.profit) AS 'sum_profit'
FROM orders t1
JOIN order_details t2
ON t1.order_id = t2.order_id
GROUP BY t1.order_id
HAVING sum_profit > 0
ORDER BY sum_profit DESC;

SELECT name, COUNT(*) AS 'num_orders'
FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id
GROUP BY t2.name
ORDER BY num_orders DESC LIMIT 1;

SELECT t2.category, SUM(profit) AS 'num_profit'
FROM order_details t1
JOIN category t2
ON t1.category_id = t2.category_id
GROUP BY t2.category
ORDER BY num_profit DESC;

SELECT t3.state, SUM(profit) AS 'total_profit'
FROM order_details t1
JOIN orders t2
ON t1.order_id = t2.order_id
JOIN users t3
ON t2.user_id = t3.user_id
GROUP BY t3.state
ORDER BY total_profit DESC LIMIT 5;

-- 5)	Find all categories with profit higher than 5000
SELECT t2.category, SUM(profit) AS 'total_profit'
FROM order_details t1
JOIN category t2
ON t1.category_id = t2.category_id
GROUP BY t2.category
HAVING total_profit > 5000;

SELECT t2.category, SUM(profit) AS 'sum_profit' FROM session34.order_details t1
JOIN session34.category t2
ON t1.category_id = t2.category_id
GROUP BY t2.category
HAVING sum_profit > 5000