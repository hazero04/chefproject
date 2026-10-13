DROP TABLE IF EXISTS food;

USE ChefDB;
SHOW TABLES;

CREATE TABLE food (
    f_foodname      VARCHAR(50) NOT NULL,         
    f_description   TEXT,                         
    f_price         INT DEFAULT 0,                
    f_date          VARCHAR(30),                 
    f_place         VARCHAR(50),                 
    f_unitsInStock  LONG,              
    f_filename      VARCHAR(50),
    PRIMARY KEY (f_foodname)
);