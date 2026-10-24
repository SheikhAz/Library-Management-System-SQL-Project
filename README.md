# Library Management System --- PostgreSQL

A relational database project built with **PostgreSQL** to manage books,
library members, employees, branches, book issuance, and returns. The
project demonstrates SQL fundamentals and intermediate database
concepts, including joins, aggregation, subqueries, Common Table
Expressions (CTEs), window functions, stored procedures, and
`CREATE TABLE AS SELECT` (CTAS).

## Database ER Diagram

The diagram below illustrates the main tables and relationships in the
library database.

![Library Management System ER
Diagram](images/library-database-er-diagram.png)

## Database Schema

The project uses the following tables:

  -----------------------------------------------------------------------
  Table                               Purpose
  ----------------------------------- -----------------------------------
  `books`                             Stores book ISBN, title, category,
                                      rental price, availability status,
                                      author, and publisher.

  `members`                           Stores member IDs, names,
                                      addresses, and registration dates.

  `employees`                         Stores employee details, job
                                      positions, salaries, and assigned
                                      branches.

  `branch`                            Stores branch IDs, manager IDs,
                                      addresses, and contact numbers.

  `issued_status`                     Records which member issued a book,
                                      the issue date, the book ISBN, and
                                      the employee who processed the
                                      issue.

  `return_status`                     Records returned books, return
                                      dates, book details, and book
                                      quality.
  -----------------------------------------------------------------------

### Relationships

-   Each member can have multiple book-issue records.
-   Each book can appear in multiple issue records over time.
-   Employees are associated with branches and process book issues.
-   Each issue can have a related return record.
-   `return_status.issued_id` references `issued_status.issued_id`; the
    supplied SQL configures this relationship with `ON DELETE CASCADE`.

## Features and SQL Tasks

The SQL script covers these operations and analyses:

1.  Insert a new book record.
2.  Update a member's address.
3.  Delete an issue record.
4.  Retrieve books issued by a specific employee.
5.  Find members who have issued more than one book.
6.  Create a book-issue summary table with CTAS.
7.  Filter books by category.
8.  Calculate rental-price totals by category.
9.  Find members registered in the last 180 days.
10. List employees with their branch manager and branch details.
11. Create a table of books above a rental-price threshold.
12. Find issued books with no return record.
13. Identify unreturned books overdue by more than 30 days.
14. Create a stored procedure to record a book return and update
    availability.
15. Generate a branch performance report with issued books, returned
    books, and rental revenue.
16. Create an active-member table from recent issue activity.
17. Rank employees by the number of issues processed.
18. Identify members with damaged-book returns.
19. Create a stored procedure to issue a book only when it is available.
20. Create a fine summary table for overdue, unreturned books using a
    daily fine of **\$0.50**.

## SQL Concepts Demonstrated

-   `CREATE TABLE`, `ALTER TABLE`, and constraints
-   `INSERT`, `UPDATE`, and `DELETE`
-   `INNER JOIN` and `LEFT JOIN`
-   `GROUP BY`, aggregate functions, and `HAVING`
-   `CASE` expressions and conditional aggregation
-   `CURRENT_DATE` and date intervals
-   Subqueries and `EXISTS`
-   CTEs and window functions such as `DENSE_RANK()`
-   Stored procedures with PL/pgSQL
-   CTAS summary tables

## Requirements

-   PostgreSQL
-   A SQL client such as pgAdmin or `psql`

## How to Run

1.  Create or select a PostgreSQL database for the project.
2.  Run the table-creation statements in dependency order. Create
    `branch` before `employees`, because `employees.branch_id`
    references `branch.branch_id`.
3.  Load the source data into the base tables.
4.  Run the `ALTER TABLE` statements and constraints that apply to your
    schema.
5.  Execute the task queries individually and inspect the results.
6.  Run stored-procedure definitions before calling them.
7.  Run CTAS statements only when their target tables do not already
    exist, or drop/rename the existing tables first.

## Important Notes

-   The supplied SQL is the project script as provided; review it before
    running it from a fresh database.
-   `books.isbn` is changed from `INT` to `VARCHAR` because ISBN values
    can contain hyphens and leading zeros. Ensure the referenced
    `issued_status.issued_book_isbn` column uses a compatible type
    before creating the foreign key.
-   The supplied script contains an unfinished statement,
    `ALTER TABLE issued_status ADD CONSTRAINT ;`. Complete or remove it
    before execution.
-   The `active_members` task description says "last 2 months," while
    the supplied query uses a three-year interval. Adjust the interval
    if the intended requirement is two months.
-   The `book_fines` query calculates fines for unreturned books overdue
    by more than 30 days. The current version does not include
    `total_books_issued`, although that field appears in the task
    description. Add `COUNT(DISTINCT i.issued_id) AS total_books_issued`
    if that output is required.
-   In the branch report, joining each issue to a book and summing
    `rental_price` calculates the sum of rental prices for issue
    records; confirm that this matches the intended revenue definition.
-   The sample `book_quality` values are assigned by `return_id`; ensure
    they reflect actual book inspections.

## Project Goal

The goal is to practice designing and querying a relational database for
common library workflows, from catalog management and circulation to
overdue tracking and reporting.
