--! Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**


CREATE TABLE book_issued_cnt AS
SELECT 
b.isbn ,b.book_title,COUNT(i.issued_id)
FROM books AS b
INNER JOIN issued_status AS i ON b.isbn = i.issued_book_isbn
GROUP BY b.isbn , b.book_title ;

SELECT * FROM book_issued_cnt;
