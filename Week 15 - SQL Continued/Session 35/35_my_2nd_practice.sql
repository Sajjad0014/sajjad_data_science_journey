-- Independent Subquery - Scalar Subquery
USE session_35;

SELECT * FROM movies;

SELECT MAX(gross - budget) FROM movies;

SELECT * FROM movies
WHERE (gross - budget) = (SELECT MAX(gross - budget) FROM movies);

SELECT COUNT(*) FROM movies
WHERE score > (SELECT AVG(score) FROM movies);

SELECT *
FROM movies
WHERE year = 2000 AND score = (SELECT MAX(score) FROM movies WHERE year = 2000);

SELECT * FROM movies;

SELECT *
FROM movies
WHERE score = (SELECT MAX(score)
FROM movies
WHERE votes > (SELECT AVG(votes) FROM movies));

-- Independent Subquery - Row Subqury (One Col Multi Rows)
SELECT DISTINCT(user_id) FROM orders;

SELECT * FROM users
WHERE user_id NOT IN (SELECT DISTINCT(user_id) FROM orders);

SELECT * FROM movies;

WITH top_directors  AS (SELECT director FROM movies GROUP BY director ORDER BY SUM(gross) DESC LIMIT 3)

SELECT * FROM movies WHERE director IN (SELECT * FROM top_directors);

SELECT * FROM movies
WHERE star IN (SELECT star FROM movies
WHERE votes > 25000
GROUP BY star
HAVING AVG(score) > 8.5)
AND votes > 25000;

-- Independent Subquery - Table Subquery (Multi Col Multi Row)
SELECT * FROM movies;

SELECT *
FROM movies
WHERE (year, gross - budget) IN (SELECT year, MAX(gross - budget) 
								FROM movies 
								GROUP BY year);

SELECT * FROM movies
WHERE (genre, score) IN (SELECT genre, MAX(score)
FROM movies
WHERE votes > 25000
GROUP BY genre) AND votes > 25000;

WITH top_duos AS (SELECT star, director, MAX(gross)
FROM movies
GROUP BY star, director
ORDER BY SUM(gross) LIMIT 5)

SELECT * FROM movies
WHERE (star, director, gross) IN (SELECT * FROM top_duos);

SELECT * FROM movies;

SELECT *
FROM movies m1
WHERE score > (SELECT AVG(score) FROM movies m2
			   WHERE m2.genre = m1.genre);
               

SELECT name, f_name, COUNT(*) FROM users t1
JOIN orders t2
ON t1.user_id = t2.user_id
JOIN order_details t3
ON t2.order_id = t3.order_id
JOIN food t4
ON t3.f_id = t4.f_id
GROUP BY t2.user_id, t3.f_id;

WITH fav_food AS (
SELECT t2.user_id, name, f_name, COUNT(*) AS 'frequency' FROM users t1
JOIN orders t2 ON t1.user_id = t2.user_id
JOIN order_details t3 ON t2.order_id = t3.order_id
JOIN food t4 ON t3.f_id = t4.f_id
GROUP BY t2.user_id,t3.f_id
)

SELECT * FROM fav_food f1
WHERE frequency = (SELECT MAX(frequency) 
				   FROM fav_food f2
                   WHERE f2.user_id = f1.user_id);


-- usage with SELECT
SELECT * FROM movies;

SELECT name, ROUND((votes / (SELECT SUM(votes) FROM movies)) * 100, 2)
FROM movies;

SELECT name, genre, score, (SELECT AVG(score) FROM movies m2 WHERE m2.genre = m1.genre) FROM movies m1;

SELECT * FROM restaurants;

SELECT r_name, avg_rating
FROM (SELECT r_id, AVG(restaurant_rating) AS 'avg_rating'
	  FROM orders 
	  GROUP BY r_id) t1 JOIN restaurants t2
      ON t1.r_id = t2.r_id;
      
SELECT * FROM movies;

SELECT genre, AVG(score)
FROM movies
GROUP BY genre
HAVING AVG(score) > (SELECT AVG(score) FROM movies);

