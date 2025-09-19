SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

--- Library Management Project

--- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

--- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101'

--- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status

DELETE FROM issued_status
WHERE issued_id = 'IS121'

--- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

--- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
	issued_emp_id,
	COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1

--- CTAS
--- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt.

CREATE TABLE book_counts
AS
SELECT 
	b.isbn,
	b.book_title,
	COUNT(isst.issued_id) as no_issued
FROM books as b
JOIN
issued_status as isst
ON isst.issued_book_isbn = b.isbn
GROUP BY 1, 2

--- Task 7: Retrieve All Books in a Specific Category:
--- For example: Classic

SELECT * FROM books
WHERE category = 'Classic'

--- For example: History

SELECT * FROM books
WHERE category = 'History'

--- Task 8: Find Total Rental Income by Category:

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

--- Task 9: List of Employees with Their Branch Manager's Name and their branch details:

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



--- EXTRA QUESTIONS (MYSELF)

--- 1 HOW MANY BOOKS IN EVERY SINGLE CATEGORY?

SELECT category, COUNT(*) AS book_count
FROM books
GROUP BY category
ORDER BY book_count DESC;

--- 2 WHAT IS THE MOST EXPENSIVE RENTAL PRICE AMONG ALL BOOKS?

SELECT MAX(rental_price) AS most_expensive_rental
FROM books;

--- 2B WHAT IS THE MOST EXPENSIVE RENTAL PRICE AMONG ALL BOKS (TITLE)?

SELECT book_title, category, rental_price
FROM books
WHERE rental_price = (SELECT MAX(rental_price) FROM books);

--- 3 WHAT IS THE AVERAGE RENTAL PRICE PER CATEGORY?

SELECT 
    category, 
    ROUND(AVG(rental_price)::numeric, 2) AS avg_rental_price
FROM books
GROUP BY category
ORDER BY avg_rental_price DESC;

--- 4 WHICH MEMBER HAS BORROWED THE MOST BOOKS?

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

-- 5 IDENTIFY BOOKS THAT HAS NEVER BEEN BORROWED (0 ISSUED)

SELECT
b.isbn,
b.book_title,
b.category
FROM books b
LEFT JOIN issued_status i
ON b.isbn = i.issued_book_isbn
WHERE i.issued_id IS NULL
