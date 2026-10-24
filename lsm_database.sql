CREATE TABLE books(
    isbn INT PRIMARY KEY,
    book_title VARCHAR(100),
    category VARCHAR(20),
    rental_price NUMERIC(10,2),
    status VARCHAR(20),
    author VARCHAR(50),
    publisher VARCHAR(100)
);

CREATE TABLE employees(
    emp_id VARCHAR(20) PRIMARY KEY,
    emp_name VARCHAR(50),
    position VARCHAR(20),
    salary NUMERIC(10,2),
    branch_id VARCHAR(20) REFERENCES branch(branch_id) 
);


CREATE TABLE branch(
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(200),
    contact_no VARCHAR(15)
);

CREATE TABLE members(
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(100),
    member_address VARCHAR(200),
    reg_date DATE 
);

ALTER TABLE books
ALTER COLUMN isbn TYPE VARCHAR(20);


CREATE TABLE issued_status(
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10) REFERENCES members(member_id),
    issued_book_name VARCHAR(100),
    issued_date DATE,
    issued_book_isbn VARCHAR(10) REFERENCES books(isbn) ,
    issued_emp_id VARCHAR(20) REFERENCES employees(emp_id)
);

ALTER TABLE issued_status
ALTER COLUMN issued_book_isbn TYPE VARCHAR(20);

ALTER TABLE issued_status
ADD CONSTRAINT ;

CREATE TABLE return_status(
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10) REFERENCES issued_status(issued_id),
    return_book_name VARCHAR(100),
    return_date DATE,
    return_book_isbn VARCHAR(20)
)

ALTER TABLE return_status
DROP CONSTRAINT return_status_issued_id_fkey;

ALTER TABLE return_status
ADD CONSTRAINT fk_return_issued
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id)
ON DELETE CASCADE;


ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(100);

SELECT * FROM return_status;

UPDATE return_status
SET book_quality = CASE
    WHEN return_id = 'RS102' THEN 'Good'
    WHEN return_id = 'RS103' THEN 'Damaged'
    WHEN return_id = 'RS104' THEN 'Good'
    WHEN return_id = 'RS105' THEN 'Good'
    WHEN return_id = 'RS106' THEN 'Damaged'
    WHEN return_id = 'RS107' THEN 'Good'
    WHEN return_id = 'RS108' THEN 'Good'
    WHEN return_id = 'RS109' THEN 'Damaged'
    WHEN return_id = 'RS110' THEN 'Good'
    WHEN return_id = 'RS111' THEN 'Good'
    WHEN return_id = 'RS112' THEN 'Damaged'
    WHEN return_id = 'RS113' THEN 'Good'
    WHEN return_id = 'RS114' THEN 'Good'
    WHEN return_id = 'RS115' THEN 'Damaged'
    WHEN return_id = 'RS116' THEN 'Good'
    WHEN return_id = 'RS117' THEN 'Good'
    WHEN return_id = 'RS118' THEN 'Damaged'
    WHEN return_id = 'RS134' THEN 'Good'
    WHEN return_id = 'RS135' THEN 'Good'
    WHEN return_id = 'RS136' THEN 'Good'
    ELSE book_quality
END;