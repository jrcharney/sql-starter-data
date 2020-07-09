/* Chapter 16 Studio */
CREATE SCHEMA IF NOT EXISTS library;
USE library;

/* 16.5.1. */
/* 15.5.1.1. */
CREATE TABLE book (
	book_id INT AUTO_INCREMENT PRIMARY KEY,
    author_id INT,
    title VARCHAR(255),
    isbn INT,
    available BOOL,
    genre_id INT
);
LOAD DATA INFILE '../lesson-15-studio/books.csv' INTO TABLE book (title, author_id, isbn, available, genre_id);
SELECT * FROM book;

/* 15.5.1.2. */
CREATE TABLE author (
	author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    birthday DATE,
    deathday DATE
);
LOAD DATA INFILE '../lesson-15-studio/authors.csv' INTO TABLE author (first_name, last_name, birthday, deathday);
SELECT * FROM author;

/* 15.5.1.3. */
CREATE TABLE patron (
	patron_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    loan_id INT
);
LOAD DATA INFILE '../lesson-15-studio/patrons.csv' INTO TABLE patron (first_name, last_name, loan_id);
SELECT * FROM patron;

/* 15.5.1.4. */
CREATE TABLE reference_books (
	reference_id INT AUTO_INCREMENT PRIMARY KEY,
    edition INT,
    book_id INT,
    FOREIGN KEY (book_id) REFERENCES book(book_id)
		ON UPDATE SET NULL
        ON DELETE SET NULL
);
INSERT INTO reference_books(edition, book_id) VALUE (5, 32);
SELECT * FROM reference_books;

/* 15.5.1.5. */
CREATE TABLE genre (
	genre_id INT PRIMARY KEY,
    genres VARCHAR(100)
);
LOAD DATA INFILE '../lesson-15-studio/genres.csv' INTO TABLE genre (genre_id,genre_type);
SELECT * FROM genre;

/* 15.5.1.6. */
CREATE TABLE loan (
	loan_id INT AUTO_INCREMENT PRIMARY KEY,
    patron_id INT,
    date_out DATE,
    date_in DATE,
    book_id INT,
    FOREIGN KEY (book_id) REFERENCES book(book_id)
		ON UPDATE SET NULL
        ON DELETE SET NULL
);
SELECT * FROM loan; 	/* Empty for now. */

/* 16.5.2. Warm-up Queries */
/* Write the following queries to get warmed up. */
/* 1. Return the mystery book titles and their ISBNs. */
SELECT title AS "Title", isbn AS "ISBN" 
FROM book
WHERE book.genre_id = (SELECT genre_id FROM genre WHERE genres = "Mystery");
/* 2. Return all of the titles and author’s first and last names for books written by authors who are currently living. */
/* NB: As an added bonus, I've concatentated first_name and last name and sorted by author. */
SELECT book.title AS "Title", CONCAT(author.first_name," ",author.last_name) AS "Author"
FROM book
INNER JOIN author ON book.author_id = author.author_id
WHERE author.deathday IS NULL
ORDER BY author.last_name ASC;

/* 16.5.3. Loan Out a Book */
/* A big function that you need to implement for the library is a script that updates the database when a book is loaned out.
 * The script needs to perform the following functions:
 * 1. Change `available` to `FALSE` for the appropriate book.
 * 2. Add a new row to the `loan` table with today’s date as 
 *    the `date_out` and the ids in the row matching the 
 *    appropriate `patron_id` and `book_id`.
 * 3. Update the appropriate `patron` with the `loan_id` for the 
 *    new row created in the `loan` table.
 * You can use any patron and book that strikes your fancy to create this script!
 */
 /* I think I may have bitten off more than I can chew here. */
 CREATE FUNCTION book_search(book_title VARCHAR(255)) RETURNS INT DETERMINISTIC
 RETURN (SELECT book_id FROM book WHERE title = book_title);
 
 CREATE FUNCTION patron_search(patron_first VARCHAR(255), patron_last VARCHAR(255)) RETURNS INT DETERMINISTIC
 RETURN (SELECT patron_id FROM patron WHERE first_name = patron_first AND last_name = patron_last);
 
 CREATE PROCEDURE check_out (IN bid INT, IN pid INT)
 BEGIN
    INSERT INTO loan (book_id, patron_id, date_out) VALUES (bid, pid, NOW());	/* 2 */
	UPDATE book SET available = false WHERE book_id = bid;	/* 1 */ 
    UPDATE patron SET loan_id = (SELECT loan_id FROM loan WHERE patron_id = pid); /* 3 */
 END;
 
 /* checkout a book with a specifc title as well as who is checking it out.
  * In real life, it is not done this way.
  */
/* check_out(book_search("A Book about Something"),patron_search("Some","Guy")); */

/* 16.5.4. Check a book back in */
/* Working with the same patron and book, create the new script!
 * The other key function that we need to implement is checking a book back in. 
 * To do so, the script needs to:
 * 1. Change `available` to `TRUE` for the appropriate book.
 * 2. Update the appropriate row in the `loan` table with today’s date as the `date_in`.
 * 3. Update the appropriate `patron` changing `loan_id` back to `null`.
 * Once you have created these scripts, loan out 5 new books to 5 different patrons.
 */
 CREATE PROCEDURE check_in (INT lid)
 BEGIN
	UPDATE book SET available = true WHERE book_id = (SELECT loan_id FROM loan WHERE loan_id = lid); /* 1 */
    UPDATE loan SET date_in = NOW() where loan_id = lid;
    UPDATE patron SET loan_id = null;
 END;
 
/*  check_in(patron_search("Some","Guy")) */

/* 16.5.5. Wrap-up Query */
/* Write a query to wrap up the studio. 
 * This query should return the names of the patrons with the genre of every book they currently have checked out.
 */
 /* TODO: Finish this! */
 CREATE PROCEDURE list_checkouts()
 BEGIN
	/*
	SELECT CONCAT(patron.first_name," ",patron.last_name) AS "Patron", genre.genres AS ("Genre")
    FROM patron
    WHERE patron_id
    UNION
    SELECT book
    */
 END;
 
 CALL list_checkouts();

/* 16.5.6. Bonus Mission */
/* 1. Return the counts of the books of each genre using the `COUNT()` function.  
 *    Check out the documentation to see how this could be done!
 *    https://dev.mysql.com/doc/refman/8.0/en/counting-rows.html
 *    https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_count
 */

/* 2. A reference book cannot leave the library. 
 *    How would you modify either the `reference_book` table or the `book` table 
 *    to make sure that doesn’t happen? Try to apply your modifications.
 */