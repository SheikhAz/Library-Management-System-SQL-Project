--! Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books
WHERE category = 'History';

--! Task 8: Find Total Rental Income by Category:

SELECT
category , SUM(rental_price) AS "Total Rental Income"
FROM books
GROUP BY category;


--!Task 9: List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


--! Task 10 : List Employees with Their Branch Manager's Name and their branch details:

SELECT
e.emp_name ,e.position , e.salary ,em.emp_name
FROM Employees AS e
INNER JOIN branch AS b ON e.branch_id = b.branch_id
INNER JOIN Employees as em ON b.manager_id = em.emp_id
;


--! Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:


CREATE TABLE expensive_books AS
SELECT * FROM books 
WHERE rental_price > 6;


--! Task 12: Retrieve the List of Books Not Yet Returned
