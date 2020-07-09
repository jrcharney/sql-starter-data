/* Chapter 16 */
CREATE DATABASE IF NOT EXISTS storage;
USE storage;

/* 16.2.1.1. */
CREATE TABLE writing_supply (
   supply_id INTEGER PRIMARY KEY AUTO_INCREMENT,
   utensil_type ENUM ("Pencil", "Pen"),
   num_drawers INTEGER
);

/* 16.2.1.2. */
CREATE TABLE pencil_drawer (
	drawer_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    pencil_type ENUM("Wood", "Mechanical"),
    quantity INTEGER,
    refill BOOLEAN,
    supply_id INTEGER,
    FOREIGN KEY (supply_id) REFERENCES writing_supply(supply_id)
);

/* 16.2.1.3. */
CREATE TABLE pen_drawer (
	drawer_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    color ENUM("Black", "Blue", "Red", "Green", "Purple"),
    quantity INTEGER,
    refill BOOLEAN,
    supply_id INTEGER,
    FOREIGN KEY (supply_id) REFERENCES writing_supply(supply_id)
);

/* "Error Code: 1290. The MySQL server is running with the --secure-file-priv option so it cannot execute this statement */
/* SHOW VARIABLES LIKE "secure_file_priv"; */
/* Because of how MySQL Workbench is set up I can't use these LOAD DATA INFILE commands. */
LOAD DATA INFILE '../lesson-15-reading-data/writing_supply.csv' INTO TABLE storage.writing_supply (supply_id, utensil_type, num_drawers);
SELECT * FROM writing_supply;
LOAD DATA INFILE '../lesson-15-reading-data/pencil_drawer.csv' INTO TABLE storage.pencil_drawer (drawer_id, pencil_type, quantity, refill, supply_id);
SELECT * FROM pencil_drawer;
LOAD DATA INFILE '../lesson-15-reading-data/pen_drawer.csv' INTO TABLE storage.pen_drawer (drawer_id, color, quantity, refill, supply_id);
SELECT * FROM pen_drawer;

/* Let's review joins */
/* 16.3.1.1. Inner Join */
/* Use an INNER JOIN to return a result set that contains
 * information that appearns in both tables.
 */
/* Example: The result set containing all of the records 
 *          from the writing_supply and pencil_drawer tables 
 *          that have matching supply_id values.
 */
SELECT * FROM writing_supply
INNER JOIN pencil_drawer ON writing_supply.supply_id = pencil_drawer.supply_id;

/* Example */
/* NOTE: adding the pencil_drawer to the column names is option, I guess. (Personally, I would use them.) */
SELECT writing_supply.supply_id, pencil_type, drawer_id, quantity
FROM writing_supply
INNER JOIN pencil_drawer ON writing_supply.supply_id = pencil_drawer.supply_id
WHERE refill = true AND pencil_type = "Mechanical";

/* 16.3.1.2. Left/Right Join */
/* LEFT and RIGHT joins are used to retain all of the records from one table
 * and pull in overlapping data from another.
 */
/* Example */
SELECT writing_supply.supply_id, utensil_type, drawer_id, color
FROM writing_supply
LEFT JOIN pen_drawer ON writing_supply.supply_id = pen_drawer.supply_id;

/* Example */
SELECT writing_supply.supply_id, utensil_type, drawer_id, color, quantity
FROM writing_supply
LEFT JOIN pen_drawer ON writing_supply.supply_id = pen_drawer.supply_id
WHERE refill = true;

/* 16.3.1.3. Multiple Joins */
/* The UNION keyword allows us to combine the results of separate SELECT commands. 
 * Run each of the following queries individually and example the two result sets.
 * Next, run the quieres with UNION */
 
 SELECT writing_supply.supply_id, utensil_type, drawer_id, quantity
 FROM writing_supply
 LEFT JOIN pencil_drawer ON writing_supply.supply_id = pencil_drawer.supply_id
 WHERE refill = true
 
 UNION
 
 SELECT writing_supply.supply_id, utensil_type, drawer_id, quantity
 FROM writing_supply
 RIGHT JOIN pen_drawer ON writing_supply.supply_id = pen_drawer.supply_id
 WHERE refill = true
 ORDER BY supply_id;
 
 /* 16.3.2. Subqueries */
 /* Example */
SELECT supply_id FROM writing_supply WHERE utensil_type = "Pen";
/* First result set contains the supply_id values 1, 2, and 5. */
SELECT drawer_id, color FROM pen_drawer WHERE quantity >= 60 AND supply_id = 5;

/* Example */
SELECT drawer_id, color FROM pen_drawer
WHERE supply_id IN (SELECT supply_id FROM writing_supply WHERE utensil_type = "Pen");

/* Example */
SELECT drawer_id, color FROM pen_drawer
WHERE supply_id IN (SELECT supply_id FROM writing_supply WHERE utensil_type = "Pen")
AND quantity >= 60;

/* Example */
SELECT drawer_id, color FROM pen_drawer
WHERE supply_id = (SELECT MAX(supply_id) FROM writing_supply WHERE utensil_type = "Pen")
AND quantity >= 60;
