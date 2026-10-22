----! Project Task ------

--! Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(
    isbn,book_title ,category ,rental_price ,status ,author ,publisher
)VALUES
(
    '978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes','Harper Lee' ,'J.B. Lippincott & Co.'
);

SELECT * FROM books 
WHERE isbn = '978-1-60129-456-2';

--! Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = 'Nehru Nagar Korba'
WHERE member_id = 'C103';

SELECT * FROM members
WHERE member_id = 'C103';


--! Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS121';

SELECT * FROM issued_status
WHERE issued_id = 'IS121';


--! Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT
b.book_title ,e.emp_name ,i.issued_date
FROM employees AS e
INNER JOIN issued_status as i ON e.emp_id = i.issued_emp_id
INNER JOIN books AS b ON i.issued_book_isbn = b.isbn
WHERE e.emp_id = 'E101';


--! Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT m.member_name , COUNT(i.issued_book_name) as "Issued Books"
FROM members AS m
INNER JOIN issued_status AS i ON m.member_id = i.issued_member_id
GROUP BY m.member_name
HAVING COUNT(i.issued_book_name) > 1;

