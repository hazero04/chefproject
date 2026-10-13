DROP TABLE IF EXISTS my_refri;

CREATE TABLE my_refri (
    refri_id       INT AUTO_INCREMENT,              
    f_foodname     VARCHAR(50) NOT NULL,    
    f_description  TEXT,                    
    f_price        INT DEFAULT 0,          
    f_date         DATE,                    
    f_place        VARCHAR(50),             
    f_count        INT DEFAULT 1,          
    f_filename     VARCHAR(50),             
    PRIMARY KEY (refri_id)
);