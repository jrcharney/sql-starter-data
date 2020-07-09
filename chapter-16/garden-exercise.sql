/* Chapter 16 Exercise */
CREATE DATABASE IF NOT EXISTS garden;
USE garden;

/* 16.4.2.1 */
CREATE TABLE plant (
	plant_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    plant_name VARCHAR(255),
    zone INTEGER,
    season VARCHAR(255)
);

/* 16.4.2.2 */
CREATE TABLE seeds (
	seed_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    expiration_date DATE,
    quantity INT,
    reorder BOOL,
    plant_id INT,
    FOREIGN KEY (plant_id) REFERENCES plant(plant_id)
);

/* 16.4.2.3. */
CREATE TABLE garden_bed (
	space_number INTEGER PRIMARY KEY AUTO_INCREMENT,
    date_planted DATE,
    doing_well BOOL,
    plant_id INT,
    FOREIGN KEY (plant_id) REFERENCES plant(plant_id)
);


/* Because of how MySQL Workbench is set up I can't use these LOAD DATA INFILE commands. */
LOAD DATA INFILE '../lesson-15-exercises/plants.csv' INTO TABLE garden.plant (plant_name, zone, season);
SELECT * FROM plant;
LOAD DATA INFILE '../lesson-15-exercises/seeds.csv' INTO TABLE garden.seeds (expiration_date, quantity, reorder, plant_id);
SELECT * FROM seeds;
LOAD DATA INFILE '../lesson-15-exercies/garden.csv' INTO TABLE garden.garden_bed (date_planted, doing_well, plant_id);
SELECT * FROM garden_bed;

/*
16.4.3.1. Inner Join
Use an inner join on seeds and garden_bed to see which plants we have seeds for and are in our garden bed.
*/
SELECT seeds.plant_id, seed_id, expiration_date, quantity, reorder, space_number, date_planted, doing_well  
FROM seeds
INNER JOIN garden_bed ON seeds.plant_id = garden_bed.plant_id;

/*
16.4.3.2. Left Join
Write a query that joins seeds and garden_bed with a left join to see all of the seeds we have and any matching plants in the garden bed.
*/
SELECT seeds.plant_id, seed_id, expiration_date, quantity, reorder, space_number, date_planted, doing_well  
FROM seeds
LEFT JOIN garden_bed ON seeds.plant_id = garden_bed.plant_id;

/*
16.4.3.3. Right Join
Write a query that joins seeds and garden_bed with a right join to see all the plants in the garden bed and any matching seeds we have.
*/
SELECT seeds.plant_id, seed_id, expiration_date, quantity, reorder, space_number, date_planted, doing_well  
FROM seeds
RIGHT JOIN garden_bed ON seeds.plant_id = garden_bed.plant_id;

/*
16.4.3.4. Full Join
Write a query that joins seeds and garden_bed with a full join.
*/
SELECT seeds.plant_id, seed_id, expiration_date, quantity, reorder, space_number, date_planted, doing_well  
FROM seeds
LEFT JOIN garden_bed ON seeds.plant_id = garden_bed.plant_id
UNION
SELECT seeds.plant_id, seed_id, expiration_date, quantity, reorder, space_number, date_planted, doing_well  
FROM seeds
RIGHT JOIN garden_bed ON seeds.plant_id = garden_bed.plant_id;

/* TODO: Do these later! */
/* 16.4.4. Sub-Queries and Complex Queries.
/*
1. When we were writing our joins, you may have noticed that the information that 
   was most helpful to you (the plant_name) was missing from the result set! 
   Write a query that gets the name of the plant by joining the plant table on 
   the result set of the inner join query above. 
   Hint: Open the query tab with the inner join query and copy it into a new 
   query tab to start. Once you have your inner join setup in a new query tab, 
   it will be easier to write your subquery.
*/
/*
2. Let’s say our plant table is so large that we have no idea what the plant_id 
   for a hosta is. All we know is that there is definitely a row for hostas in 
   the plant table. 
   Write a query that will insert a new row into our seeds table. 
   This new row needs to show that we received 100 hosta seeds that will 
   expire on 08/05/2020 (so no need to reorder!) and for the plant_id, 
   use a query inside the INSERT statement to get the appropriate ID for hostas. 
   Hint: In order to get the plant_id of a hosta, you can use the following 
   query in one line 
   `SELECT plant_id FROM plant WHERE (plant_name LIKE 'Hosta')`
   inside the VALUES of the INSERT statement.
 */

/* 16.4.5. Bonus Misson */
/* 1. Revisit your query with a full join and try using UNION ALL 
	  as opposed to UNION. How does the result set differ? 
 */
/* 2. Now that we can get the plant_name of plants that we have seeds for 
      and are in the garden bed, try using COUNT() to see how many plants 
      are in both places. 
 */
 