#3. CTAS (Create Table As Select)
#________________________________________________________________________________________________
#Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results -
# each book and total book_issued_cnt**
SELECT issued_book_name , count(issued_id) from issued_status
group by issued_status.issued_book_name ;
#or 
select books.isbn, books.book_title, count(issued_status.issued_id) as issue_count
from issued_status
join books 
on issued_status.issued_book_isbn=books.isbn
group by books.isbn, books.book_title;
------------------------------------------------------------------------------------------------- 
#4. Data Analysis & Findings
#The following SQL queries were used to address specific questions:
#_______________________________________________________________________________________________
#Task 7. Retrieve All Books in a Specific Category:

select * from books 
where category='classic';

-------------------------------------------------------------------------------------------------
# Task 8: Find Total Rental Income by Category:
select books.category,sum(books.rental_price) from books 
group by books.category;
#or ************************************************
select count(*) from issued_status;
#or  ***********************************************
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY category;
---------------------------------------------------------------------------------------------
# Task 9: List Members Who Registered in the Last 180 Days:
SELECT *
FROM members
WHERE reg_date >= CURDATE() - INTERVAL 180 DAY;

INSERT INTO members(member_id,member_name,member_address,reg_date) 
values
('C120','sammy','146 Main ST','2025-06-01'),
('C121','johnny','135 Main ST','2025-05-01');
----------------------------------------------------------------------------------------------
# Task 10: List Employees with Their Branch Manager's Name and their branch details:
select * from branch 
join employees
on branch.branch_id=employees.branch_id;
#or *****************************************************************************************
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;
---------------------------------------------------------------------------------------------
# Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_books as 
select * from books 
where rental_price>7.00;
# Task 12: Retrieve the List of Books Not Yet Returned

select * from issued_status as ist
left join return_status as rst 
on rst.issued_id=ist.issued_id
where rst.return_id IS NULL;
