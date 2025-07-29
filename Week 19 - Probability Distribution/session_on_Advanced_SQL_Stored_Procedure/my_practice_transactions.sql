USE campusx;

CREATE TABLE person (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    dob DATE,
    gender ENUM('Male', 'Female', 'Other'),
    married BOOLEAN,
    balance DECIMAL(10,2)
);

INSERT INTO person (id, name, dob, gender, married, balance) VALUES
(1, 'Alice Johnson', '1990-05-14', 'Female', TRUE, 1500.50),
(2, 'Bob Smith', '1985-08-22', 'Male', FALSE, 3200.75),
(3, 'Charlie Brown', '1992-11-30', 'Male', TRUE, 500.00),
(4, 'Diana Prince', '1988-07-19', 'Female', FALSE, 7800.25),
(5, 'Eve Adams', '1995-02-10', 'Other', TRUE, 2300.90);

SELECT * FROM person;

UPDATE person SET balance = 2000.23
WHERE id = 1;

-- Click on Reconnect to DBMS and run the below query
SELECT * FROM campusx.person;


-- disavling autocommit
SET autocommit = 0;

INSERT INTO person (id, name) VALUES (6, 'rishab');

SELECT * FROM person;
-- Now refresh the Reconnect to DBMS and run the above query

INSERT INTO person (id, name) VALUES (6, 'rishab');
COMMIT;
-- now check by reconnecting, it will be committed
SELECT * FROM person;

DELETE FROM person
WHERE id = 6;

-- Transaction
SELECT * FROM person;

-- remove 1000 from Alice and transfer to Charlie
-- START TRANSACTION -> without commit
START TRANSACTION;

UPDATE person SET balance = 1000.23 WHERE id = 1;

UPDATE person SET balance = 2500 WHERE id = 3;

-- with commit
COMMIT;

-- remove 1000 from Alice and transfer to Charlie
-- BUT we have syntax error in the second update
-- START TRANSACTION -> all or none with commit
SELECT * FROM person;

START TRANSACTION;

UPDATE person SET balance = 500.23 WHERE id = 1;

UPDATE person SET balance = 3000 WHERE id2 = 3;

COMMIT;

-- rollback
START TRANSACTION;

UPDATE person SET balance = 500.23 WHERE id = 1;

UPDATE person SET balance = 3000 WHERE id = 3;

ROLLBACK;


-- rollback with savepoint
START TRANSACTION;

SAVEPOINT A;
UPDATE person SET balance = 500.23 WHERE id = 1;

SAVEPOINT B;
UPDATE person SET balance = 3000 WHERE id = 3;

ROLLBACK TO B;

SELECT * FROM person;

ROLLBACK TO A;

SELECT * FROM person;

-- rollback and commit together

START TRANSACTION;

UPDATE person SET balance = 500.23 WHERE id = 1;

COMMIT;

UPDATE person SET balance = 3000 WHERE id = 3;

-- this rollback will only go till commit statement.
ROLLBACK;


SELECT * FROM person; 




























