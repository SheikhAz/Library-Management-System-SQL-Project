--! Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.


SELECT
m.member_id,m.member_name,i.issued_book_name , i.issued_date ,
CURRENT_DATE - i.issued_date as overdue_days
FROM issued_status AS i 
LEFT JOIN return_status AS r ON i.issued_id = r.issued_id
LEFT JOIN members AS m ON i.issued_member_id = m.member_id
WHERE r.return_date IS NULL
AND (CURRENT_DATE - i.issued_date) > 30
ORDER BY overdue_days DESC;


--! Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

CREATE OR REPLACE PROCEDURE book_return_record(p_return_id VARCHAR(10),p_issued_id VARCHAR(10))
LANGUAGE plpgsql
AS $$
DECLARE
    v_name VARCHAR(100);
    v_isbn VARCHAR(20);
BEGIN

    SELECT
    issued_book_name,
    issued_book_isbn
    INTO
    v_name,
    v_isbn
    FROM issued_status
    WHERE issued_id = p_issued_id;


    INSERT INTO return_status(return_id , issued_id ,return_book_name ,return_date ,return_book_isbn)
    VALUES
    (p_return_id , p_issued_id ,v_name ,CURRENT_DATE,v_isbn );

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank You for Returning the Book : %',v_name;

END;
$$

SELECT b.isbn , i.issued_id
FROM books AS b
INNER JOIN issued_status AS i
 ON b.isbn = i.issued_book_isbn
WHERE status = 'no';

SELECT * FROM return_status

CALL book_return_record('RS134','IS134');
CALL book_return_record('RS135','IS135');
CALL book_return_record('RS136','IS136');


--! Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.


CREATE TABLE branch_report AS
SELECT 
b.branch_id,b.branch_address,
COUNT(DISTINCT i.issued_id) as "Total Issued Books",
COUNT(DISTINCT r.return_id) as "Total Returned Books",
SUM(bo.rental_price) as "Total Revenue"
FROM branch AS b
INNER JOIN employees AS e 
 ON b.branch_id = e.branch_id
INNER JOIN issued_status AS i
 ON e.emp_id = i.issued_emp_id
LEFT JOIN return_status AS r
 ON i.issued_id = r.issued_id
INNER JOIN books AS bo
 ON i.issued_book_isbn = bo.isbn
GROUP BY b.branch_id , b.branch_address
ORDER BY "Total Revenue" DESC ;

SELECT * FROM branch_report;


--! Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

CREATE TABLE active_members AS
SELECT
*
FROM members AS m
WHERE EXISTS(
    SELECT 1
    FROM issued_status AS i
    WHERE m.member_id = i.issued_member_id AND
    i.issued_date >= CURRENT_DATE - INTERVAL '3 years' AND
    i.issued_date <= CURRENT_DATE
);

SELECT * FROM active_members;


--! Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.


SELECT
e.emp_name,COUNT(i.issued_id) as "Number of Books" ,e.branch_id,DENSE_RANK() OVER(ORDER BY COUNT(i.issued_id) DESC) as "Rank"
FROM employees AS e
INNER JOIN issued_status AS i
 ON e.emp_id = i.issued_emp_id
GROUP BY e.emp_name,e.branch_id;


-- With CTE

WITH employee_rank AS(
    SELECT
    e.emp_name,COUNT(i.issued_id) as "Number of Books" ,e.branch_id,DENSE_RANK() OVER(ORDER BY COUNT(i.issued_id) DESC) as "Rank"
    FROM employees AS e
    INNER JOIN issued_status AS i
    ON e.emp_id = i.issued_emp_id
    GROUP BY e.emp_name,e.branch_id
)
SELECT * FROM employee_rank 
WHERE "Rank" <= 3
ORDER BY "Rank";