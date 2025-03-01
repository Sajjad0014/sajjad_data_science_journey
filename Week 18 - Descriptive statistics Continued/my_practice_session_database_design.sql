USE campusx;

DROP TABLE IF EXISTS dt_demo;

-- INT Datatypes (TINYINT, FLOAT, DECIMAL)
CREATE TABLE dt_demo(
	user_id TINYINT,
    course_id TINYINT UNSIGNED
);

SELECT * FROM dt_demo;

INSERT INTO dt_demo VALUES (127, 200);

ALTER TABLE dt_demo ADD COLUMN price DECIMAL(5, 2);

UPDATE dt_demo
SET price = 45.639;

ALTER TABLE dt_demo ADD COLUMN height FLOAT;

ALTER TABLE dt_demo ADD COLUMN weight DOUBLE;

UPDATE dt_demo
SET height = 190.1234, weight = 90.3456;

INSERT INTO dt_demo (height, weight) VALUES (172.3456999922222999, 60.4561111111117222222);

-- STRING Datatype (ENUM AND SET)
ALTER TABLE dt_demo ADD COLUMN gender ENUM('male', 'female');

UPDATE dt_demo
SET gender = 'male';

-- error
-- UPDATE dt_demo
-- SET gender = 'delhi';

ALTER TABLE dt_demo ADD COLUMN hobby SET('gaming', 'sports', 'travel');

SELECT * FROM dt_demo;

INSERT INTO dt_demo (hobby) VALUES ('sports'), ('travel,gaming');

-- TEXT
-- BLOB
ALTER TABLE dt_demo ADD COLUMN dp MEDIUMBLOB;

INSERT INTO dt_demo (dp) VALUES (LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Xalora.jpg'));

SHOW VARIABLES LIKE 'secure_file_priv';

SHOW VARIABLES LIKE 'max_allowed_packet';

SELECT LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Xalora.jpg');

-- GEOMETRY
ALTER TABLE dt_demo ADD COLUMN latlong GEOMETRY;

SELECT * FROM dt_demo;

INSERT INTO dt_demo (latlong) VALUES (POINT(67.3452, 89.9234));

SELECT ST_ASTEXT(latlong), ST_X(latlong), ST_Y(latlong) FROM dt_demo;


-- JSON
ALTER TABLE dt_demo ADD COLUMN descr JSON;

SELECT * FROM dt_demo;

INSERT INTO dt_demo (descr) VALUES ('{"os":"android", "type":"smartphone"}');

SELECT descr, JSON_EXTRACT(descr, '$.os'), JSON_EXTRACT(descr, '$.type') FROM dt_demo;



