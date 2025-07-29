-- Stored Procedure

USE campusx;

-- Whenever this is called, it will print "hello world"
CALL hello_world;
-- OR (prefer below)
CALL hello_world();

-- Create stored procedure to create a new user
-- constraint - user only entered when his email does not exist before, unique email
-- constraint - pop success/fail message
-- fail message - Email already exists
USE zomato_case_study;

SELECT * FROM users;

-- before adding the OUT
CALL add_user('Ankit', 'ankit@gmail.com');
CALL add_user('Anki', 'ankit1234@gmail.com');

-- Show Error Message
-- after making changes
SET @message = '';
CALL add_user('Ankit', 'ankit@gmail.com', @message);

SELECT @message;

-- this code can be written in python
CALL add_user('Vinesh', 'vinesh@gmail.com', @message);

SELECT @message;

-- Create stored procedure to show orders placed by 1 single user
CALL user_orders('vartika@gmail.com');

-- Create a stored procedure to place an order
-- 1. user id, 2. restaurant id, 3. food id 
-- are given

-- first we need to make changes in the orders table (one insert)
-- then in order details, for items ordered (another insert)
-- (other thing we could also do over here is UPDATE the restaurant table, by reducing the quantity)
-- we also need to calculate the amount of the order
SELECT SUBSTRING_INDEX('3, 4', ',', 1);

SELECT SUM(price) FROM menu
WHERE r_id = 1 AND f_id IN (1, 2);

SELECT @total = 0;

CALL place_order(3, 3, '6, 7', @total);

SELECT @total;

-- complexity not included in above question are
-- in '6, 7', there are only 2 food items, there could be more
-- 2nd complexity Quantities manage karna in restaurant quanitity