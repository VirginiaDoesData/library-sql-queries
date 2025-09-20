# Library Management System - SQL Analysis

This project contains SQL queries for analyzing a Library Management System database.  

The project started as a tutorial by [najirh](https://github.com/najirh/Library-System-Management---P2), and I have added additional queries of my own to explore the dataset further. 
It is designed to practice and showcase SQL skills for my portfolio, including joins, aggregation, grouping, and filtering.

## Project Overview
The database includes tables such as:
- `books` – information about each book (title, category, rental price, etc.)
- `members` – library members
- `employees` – employees managing book issues
- `issued_status` – records of book issues
- `return_status` – records of returned books
- `branch` – library branches

## How to Use
1. Clone or download this repository.
2. Use your preferred SQL environment (PostgreSQL recommended) to run the queries.
3. Modify the queries as needed to explore the dataset further.


## Tutorial Queries

### Select All Tables
-- Questions based on @najirh's tutorial:
```sql


SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

```

Task 1: Create a New Book Record

```sql

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

```
Task 2: Update an Existing Member's Address
```sql

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
```

Task 3: Delete a Record from Issued Status
```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

Task 4: Retrieve All Books Issued by a Specific Employee
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';
```

Task 5: List Members Who Have Issued More Than One Book
```sql

SELECT issued_emp_id, COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;
```

Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
```sql
CREATE TABLE book_counts AS
SELECT b.isbn, b.book_title, COUNT(isst.issued_id) AS no_issued
FROM books AS b
JOIN issued_status AS isst
  ON isst.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```

Task 7: Retrieve All Books in a Specific Category:
```sql
--- For example: Classic
SELECT * FROM books
WHERE category = 'Classic'

--- For example: History

SELECT * FROM books
WHERE category = 'History'
```
Task 8: Find Total Rental Income by Category:
```sql
SELECT * FROM books
SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as isst
ON isst.issued_book_isbn = b.isbn
GROUP BY 1
```
Task 9: List of Employees with Their Branch Manager's Name and their branch details:
```sql
SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employees as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON b.manager_id = e2.emp_id
```

EXTRA QUESTIONS (MYSELF)

1) HOW MANY BOOKS IN EVERY SINGLE CATEGORY?
```sql
SELECT category, COUNT(*) AS book_count
FROM books
GROUP BY category
ORDER BY book_count DESC;
```
2) WHAT IS THE MOST EXPENSIVE RENTAL PRICE AMONG ALL BOOKS?
```sql
SELECT MAX(rental_price) AS most_expensive_rental
FROM books;
```
2B) WHAT IS THE MOST EXPENSIVE RENTAL PRICE AMONG ALL BOOKS (TITLE)?
```sql
SELECT book_title, category, rental_price
FROM books
WHERE rental_price = (SELECT MAX(rental_price) FROM books);
```
3) WHAT IS THE AVERAGE RENTAL PRICE PER CATEGORY?
```sql
SELECT 
    category, 
    ROUND(AVG(rental_price)::numeric, 2) AS avg_rental_price
FROM books
GROUP BY category
ORDER BY avg_rental_price DESC;
```
4) WHICH MEMBER HAS BORROWED THE MOST BOOKS?
```sql
SELECT
m.member_id,
m.member_name,
COUNT(*) AS total_books_borrowed
FROM issued_status i
JOIN members m
	On i.issued_member_id = m.member_id
GROUP BY m.member_id, m.member_name
ORDER BY total_books_borrowed DESC
LIMIT 1
```
5) IDENTIFY BOOKS THAT HAS NEVER BEEN BORROWED (0 ISSUED)
```sql
SELECT
b.isbn,
b.book_title,
b.category
FROM books b
LEFT JOIN issued_status i
ON b.isbn = i.issued_book_isbn
WHERE i.issued_id IS NULL
```
