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

--! Task 18: Identify Members Issuing High-Risk Books
-- Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.


SELECT 
m.member_name,COUNT(DISTINCT i.issued_id) as "Damaged issued count"
FROM members AS m
INNER JOIN issued_status AS i
 ON m.member_id = i.issued_member_id
INNER JOIN return_status AS r
 ON i.issued_id = r.issued_id
WHERE r.book_quality = 'Damaged'
GROUP BY m.member_name
HAVING COUNT(DISTINCT i.issued_id) > 0  
ORDER BY "Damaged issued count" DESC;

--! Task 19: Stored Procedure Objective: 
-- Create a stored procedure to manage the status of books in a library system. Description: Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(20),p_isbn VARCHAR(20),p_issued_member_id VARCHAR(20) ,p_issued_emp_id VARCHAR(20))
LANGUAGE plpgsql AS
$$
DECLARE
    v_title VARCHAR(100);
    v_status VARCHAR(10);
BEGIN
    SELECT 
        book_title,status 
        INTO
        v_title , v_status
        FROM books
        WHERE isbn = p_isbn;
        
    IF v_status = 'yes' THEN
        INSERT INTO issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id) 
        VALUES
        (p_issued_id , p_issued_member_id ,v_title,CURRENT_DATE,p_isbn,p_issued_emp_id);

        UPDATE books
        SET status = 'no'
        WHERE isbn = p_isbn;

        RAISE NOTICE 'Book records added successfully for book isbn : %',v_title;
    ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %',v_title;
    END IF;
END;
$$


CALL issue_book('IS141','978-0-14-044930-3','C118','E103')
CALL issue_book('IS141','978-0-375-41398-8','C118','E103')

SELECT * FROM members
SELECT * FROM books;
SELECT * FROM Employees;
SELECT * FROM issued_status
WHERE issued_id = 'IS141';

--! Task 20: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

-- Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines


CREATE TABLE book_fines AS
SELECT 
m.member_id , m.member_name,
COUNT(
    DISTINCT CASE
    WHEN r.return_id IS NULL AND
    CURRENT_DATE > i.issued_date + INTERVAL '30 days'
    THEN i.issued_id
    END
) AS overdue_books,
SUM(
    CASE
    WHEN r.return_id IS NULL AND
    CURRENT_DATE > i.issued_date + INTERVAL '30 days'
    THEN (CURRENT_DATE - (i.issued_date + 30)) *0.50
    ELSE 0
    END
) AS total_fines

FROM members AS m
INNER JOIN issued_status AS i
 ON m.member_id = i.issued_member_id
LEFT JOIN return_status AS r
 ON i.issued_id = r.issued_id
WHERE r.return_id IS NULL
GROUP BY m.member_id , m.member_name;


SELECT * FROM book_fines;

