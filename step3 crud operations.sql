#Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 
#'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books (isbn,book_title,category,rental_price,status,author,publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM library.books;

--------------------------------------------------------------------------------------------- 
# Task 2: Update an Existing Member's Address
update members 
set member_address = '125 Main st'
where member_id='c101';
---------------------------------------------------------------------------------------------
#Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record 
#with issued_id = 'IS121' from the issued_status table.
delete from issued_status
where issued_id = 'IS121';
SELECT * FROM library.issued_status;

----------------------------------------------------------------------------------------------
#Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued
# by the employee with emp_id = 'E101'.
select issued_book_name from issued_status
join employees 
on issued_status.issued_emp_id=employees.emp_id
where emp_id = 'E101';
----------------------------------------------------------------------------------------------
#Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find 
#members who have issued more than one book.
select issued_status.issued_emp_id , count(issued_status.issued_id) as total
from issued_status 
group by issued_status.issued_emp_id
having total>1 ;
---------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
