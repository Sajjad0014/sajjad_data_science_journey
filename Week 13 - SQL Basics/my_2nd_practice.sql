-- Practice Session
CREATE DATABASE campusx1_delete;

DROP DATABASE campusx1_delete;

CREATE DATABASE IF NOT EXISTS campusx1_delete;

DROP DATABASE IF EXISTS campusx1_delete;

CREATE DATABASE campusx_delete;

CREATE TABLE campusx_delete.users2(
user_id INTEGER NOT NULL,
name VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL,
password VARCHAR(255) NOT NULL,

CONSTRAINT users_email_unique UNIQUE(name, email),
CONSTRAINT user_pk PRIMARY KEY (user_id)
);


USE campusx_delete;

CREATE TABLE students(
student_id INTEGER PRIMARY KEy AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
age INTEGER,

CONSTRAINT age_check CHECK(age > 8 AND age < 16)
);

CREATE TABLE ticket(
ticket_id INTEGER PRIMARY KEY,
name VARCHAR(255) NOT NULL,
travel_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- constraints
CREATE TABLE customers(
cid INTEGER,

CONSTRAINT campusx_customer_pk PRIMARY KEY (cid)
);

CREATE TABLE orders(
order_id INTEGER,
cid INTEGER NOT NULL,
order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT campusx_orders_pk PRIMARY KEY (order_id),
CONSTRAINT campusx_orders_fk FOREIGN KEY (cid) REFERENCES customers (cid)
);

DROP TABLE customers;  
-- Error Because we have added one of its col as pk in orders table. Hence, it is in RESTRICT mode

DROP TABLE orders;

CREATE TABLE orders(
order_id INTEGER PRIMARY KEY,
cid INTEGER NOT NULL,
order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT orders_fk FOREIGN KEY (cid) REFERENCES customers (cid)
ON DELETE CASCADE
ON UPDATE CASCADE
);

ALTER TABLE customers ADD COLUMN password VARCHAR(255) NOT NULL;

ALTER TABLE customers ADD COLUMN surname VARCHAR(255) NOT NULL AFTER cid;
ALTER TABLE customers ADD COLUMN last_name VARCHAR(255) NOT NULL BEFORE surname;

DESCRIBE customers;

ALTER TABLE customers DROP COLUMN surname;

ALTER TABLE customers MODIFY COLUMN password INTEGER;

ALTER TABLE customers ADD COLUMN age INTEGER NOT NULL;

ALTER TABLE customers ADD CONSTRAINT customer_age_check CHECK (age > 13);

ALTER TABLE customers DROP CONSTRAINT customer_age_check;







