USE campusx;

SELECT *, AVG(marks) OVER(PARTITION BY branch) FROM campusx.marks;

SELECT * FROM marks;

-- Who has the least and who has the highest marks
SELECT *,
MIN(marks) OVER(),
MAX(marks) OVER()
FROM marks
ORDER BY student_id;

SELECT *,
AVG(marks) OVER() AS 'Overall_avg',
MIN(marks) OVER(),
MAX(marks) OVER(),
MIN(marks) OVER(PARTITION BY branch),
MAX(marks) OVER(PARTITION BY branch)
FROM marks
ORDER BY student_id;

SELECT * FROM (SELECT *,
			   AVG(marks) OVER(PARTITION BY branch) AS 'branch_avg'
			   FROM marks) t
WHERE t.marks > t.branch_avg;

SELECT *,
RANK() OVER(ORDER BY marks DESC) 
FROM marks;

SELECT *,
RANK() OVER(PARTITION BY branch ORDER BY marks DESC) 
FROM marks;

SELECT *,
RANK() OVER(PARTITION BY branch ORDER BY marks DESC),
DENSE_RANK() OVER(PARTITION BY branch ORDER BY marks DESC)
FROM marks;

SELECT *,
ROW_NUMBER() OVER()
FROM marks;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY branch)
FROM marks;

SELECT *,
CONCAT(branch, '-', ROW_NUMBER() OVER(PARTITION BY branch))
FROM marks;


SELECT * FROM (SELECT MONTHNAME(date) AS 'month_name', user_id, SUM(amount) AS 'total',
				RANK() OVER(PARTITION BY MONTHNAME(date) ORDER BY SUM(amount) DESC) AS 'month_rank'
				FROM session_35.orders
				GROUP BY MONTHNAME(date), user_id
				ORDER BY MONTHNAME(date)) t
                WHERE t.month_rank < 3
                ORDER BY month_name DESC, month_rank ASC;

SELECT *,
FIRST_VALUE(name) OVER(ORDER BY marks DESC) 
FROM marks;


SELECT *,
LAST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC)
FROM marks;

SELECT *,
LAST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks;

-- Q. Find the 2nd topper of each branch

SELECT *,
NTH_VALUE(name, 2) OVER(PARTITION BY branch
					ORDER BY marks DESC
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks;

-- If we give 5 which is not there, it will give NULL values
SELECT *,
NTH_VALUE(name, 5) OVER(PARTITION BY branch
					ORDER BY marks DESC
                    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM marks;

-- 1.	Find the branch toppers
SELECT name, marks, branch FROM (SELECT *,
				FIRST_VALUE(name) OVER(PARTITION BY branch ORDER BY marks DESC) AS 'topper_name',
				FIRST_VALUE(marks) OVER(PARTITION BY branch ORDER BY marks DESC) AS 'topper_marks'
				FROM marks) t
WHERE t.name = t.topper_name AND t.marks = t.topper_marks;

SELECT name, marks, branch FROM (SELECT *,
FIRST_VALUE(name) OVER w AS 'topper_name',
FIRST_VALUE(marks) OVER w AS 'topper_marks'
FROM marks
WINDOW w AS (PARTITION BY branch ORDER BY marks DESC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) t
WHERE t.name = t.topper_name AND t.marks = t.topper_marks;

SELECT name, marks, branch FROM (SELECT *,
	LAST_VALUE(name) OVER w AS 'last_marks_name',
	LAST_VALUE(marks) OVER w AS 'least_marks'
	FROM marks
	WINDOW w AS (PARTITION BY branch ORDER BY marks DESC
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) t
WHERE t.name = t.last_marks_name AND t.marks = t.least_marks;
-- FRAME Clause


-- 2.	 Find the last guy of each branch

-- 3.	Alternate way of writing Window functions


-- 4.	Find the 2nd last guy of each branch, 5th topper of each branch

-- LEAD & LAG
SELECT *,
LAG(marks) OVER(PARTITION BY branch ORDER BY student_id),
LEAD(marks) OVER(PARTITION BY branch ORDER BY student_id)  
FROM marks;
 

-- 	Find the MoM revenue growth of Zomato
USE session_35;

SELECT MONTHNAME(date), SUM(amount) 
FROM orders
GROUP BY MONTHNAME(date)
ORDER BY MONTHNAME(date) DESC;

-- This right now results in this 
 

-- What we need to do is subtracts June’s sum with previous and divide it with that only to get growth %

SELECT MONTHNAME(date), SUM(amount),
LAG(SUM(amount)) OVER(ORDER BY MONTHNAME(date) DESC)
FROM orders
GROUP BY MONTHNAME(date)
ORDER BY MONTHNAME(date) DESC;

 

SELECT MONTHNAME(date), SUM(amount),
((SUM(amount) - LAG(SUM(amount)) OVER(ORDER BY MONTHNAME(date) DESC)) / LAG(SUM(amount)) OVER(ORDER BY MONTHNAME(date) DESC)) * 100
FROM orders
GROUP BY MONTHNAME(date)
ORDER BY MONTHNAME(date) DESC;
 



