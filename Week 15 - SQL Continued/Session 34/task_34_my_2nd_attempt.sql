-- 1 Find out top 10 countries' which have maximum A and D values.
USE task_34_freedom_ranking;

SELECT * FROM country_ab;

SELECT A.Country, A, D
FROM (SELECT Country, A FROM country_ab
ORDER BY A DESC LIMIT 10) A
LEFT JOIN
(SELECT Country, D FROM country_cd
ORDER BY D DESC LIMIT 10) B
ON A.Country = B.Country

UNION

SELECT B.Country, A, D
FROM (SELECT Country, A FROM country_ab
ORDER BY A DESC LIMIT 10) A
RIGHT JOIN
(SELECT Country, D FROM country_cd
ORDER BY D DESC LIMIT 10) B
ON A.Country = B.Country

ORDER BY Country;


-- 2 Find out highest CL value for 2020 for every region. Also sort the result in descending order. 
-- Also display the CL values in descending order.
SELECT Region, MAX(CL)
FROM country_cl t1
JOIN country_ab t2
ON t1.Country = t2.Country
WHERE t1.Edition = 2020
GROUP BY Region
ORDER BY MAX(CL) DESC;

-- 3` Find top-5 most sold products.
USE task_34_sales_db;

SELECT * FROM products;

SELECT Name,SUM(Quantity) AS 'total_quantity' FROM sales1 t1
JOIN products t2
ON t1.ProductID = t2.ProductID
GROUP BY Name
ORDER BY total_quantity DESC LIMIT 5;

### `Q-4:` Find sales man who sold most no of products.
SELECT t1.FirstName, t1.LastName, SUM(Quantity)
FROM employees t1
JOIN sales1 t2
ON t1.EmployeeID = t2.SalesPersonID
GROUP BY t1.FirstName, t1.LastName
ORDER BY SUM(Quantity) DESC LIMIT 5;

### `Q-5:` Sales man name who has most no of unique customer.
SELECT t2.EmployeeID, t2.FirstName, t2.LastName, COUNT(DISTINCT CustomerID) AS 'unique_customers'
FROM sales1 t1
JOIN employees t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t2.EmployeeID, t2.FirstName, t2.LastName
ORDER BY unique_customers DESC LIMIT 5;

###`Q-6:` Sales man who has generated most revenue. Show top 5.
SELECT t1.SalesPersonID, SUM(t1.Quantity * t2.Price) AS 'revenue'
FROM sales1 t1
JOIN products t2
ON t1.ProductID = t2.ProductID
GROUP BY t1.SalesPersonID
ORDER BY revenue DESC LIMIT 5;

###`Q-7:` List all customers who have made more than 10 purchases.
SELECT t1.CustomerID, t1.FirstName, t1.LastName, COUNT(*) AS 'purchases'
FROM customers t1
JOIN sales1 t2
ON t1.CustomerID = t2.CustomerID
GROUP BY t1.CustomerID, t1.FirstName, t1.LastName
HAVING purchases > 10;


### `Q-8` : List all salespeople who have made sales to more than 5 customers.
SELECT t2.EmployeeID, t2.FirstName, t2.LastName, COUNT(DISTINCT CustomerID) AS 'num_of_customers'
FROM sales1 t1
JOIN employees t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t2.EmployeeID, t2.FirstName, t2.LastName
HAVING num_of_customers > 5;

### `Q-9:` List all pairs of customers who have made purchases with the same salesperson.
SELECT *
FROM (SELECT DISTINCT t1.CustomerID AS 'first_customer',
t2.CustomerID AS 'second_customer',
t1.SalesPersonID
FROM sales1 t1
JOIN sales1 t2
ON t1.SalesPersonID = t2.SalesPersonID
AND t1.CustomerID != t2.CustomerID) A
JOIN customers B
ON A.first_customer = B.customerID
LEFT JOIN customers C
ON A.second_customer = C.CustomerID
LEFT JOIN employees D
ON A.SalesPersonID = D.EmployeeID;
