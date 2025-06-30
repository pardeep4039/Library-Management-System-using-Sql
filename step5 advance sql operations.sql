#Task 13: Identify Members with Overdue Books
#Write a query to identify members who have overdue books (assume a 30-day return period). 
#Display the member's_id, member's name, book title, issue date, and days overdue.
select members.member_id , members.member_name, books.book_title,issued_status.issued_date, current_date()-issued_status.issued_date as days_overdue from members 
join issued_status
on issued_status.issued_member_id=members.member_id
join books 
on issued_status.issued_book_isbn=books.isbn
left join return_status
on issued_status.issued_id=return_status.issued_id
where return_status.return_id is null 
and current_date()-issued_status.issued_date >30
order by members.member_id desc;  


SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;

#MOST ACCURATE ONE************************************************************************************************************************************************************
SELECT 
    m.member_id,
    m.member_name,
    i.issued_book_name AS book_title,
    i.issued_date,
    DATEDIFF(CURRENT_DATE, i.issued_date) - 30 AS days_overdue
FROM 
    issued_status i
JOIN 
    members m ON i.issued_member_id = m.member_id
LEFT JOIN 
    return_status r ON i.issued_id = r.issued_id
WHERE 
    r.issued_id IS NULL  -- book not returned
    AND DATEDIFF(CURRENT_DATE, i.issued_date) > 30;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/*Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are 
returned (based on entries in the return_status table)*/
select * from issued_status
where issued_book_isbn='978-0-451-52994-2';

select * from books
where isbn='978-0-451-52994-2';

update books 
set status ='no'
where isbn= '978-0-451-52994-2';

select*from return_status
where issued_id ='IS130';

SELECT * FROM issued_status WHERE issued_id = 'IS130';
INSERT INTO return_status(return_id, issued_id, return_date, book_quality) 
VALUES ('RS125', 'IS130', CURRENT_DATE, 'Good');
select*from return_status
where issued_id ='IS130';

update books 
set status ='YES'
where isbn= '978-0-451-52994-2';
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals.*/
create table branch_wise_report as
SELECT branch.branch_id, count(issued_status.issued_id) as ist, count(return_status.return_id) as rst, sum(books.rental_price) as total_revenue 
from  issued_status
join employees
on issued_status.issued_emp_id=employees.emp_id
join branch
on employees.branch_id=branch.branch_id
left join return_status 
on issued_status.issued_id=return_status.issued_id
join books
on books.isbn=issued_status.issued_book_isbn
group by branch.branch_id;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.*/
create table active_member as 
select * from members  join 
issued_status
on issued_status.issued_member_id=members.member_id
where issued_date >= current_date()- interval 60 day ;
select*from active_member;
# or more accurate ************************************************************************************************************************************************************
CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL 2 month
                    )
;
SELECT * FROM active_members;
drop table active_members;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.*/
select employees.emp_name , branch.branch_id ,count(issued_status.issued_id) as no_of_booksp
from issued_status
join employees
on issued_status.issued_emp_id=employees.emp_id
join branch 
on employees.branch_id=branch.branch_id
group by employees.emp_name , branch.branch_id ;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. 
Display the member name, book title, and the number of times they've issued damaged books in doubt */
SELECT 
    m.member_name,
    b.book_title AS book_title,
    COUNT(r.book_quality) AS damaged_issue_count
FROM 
    members AS m
JOIN 
    issued_status AS i ON m.member_id = i.issued_member_id
JOIN 
    return_status AS r ON i.issued_id = r.issued_id
JOIN 
    books AS b ON i.issued_book_isbn = b.isbn
WHERE 
    r.book_quality = 'damaged'
GROUP BY 
    m.member_id, b.book_title
HAVING 
    COUNT(r.book_quality) > 2;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*   Task 20: Create Table As Select (CTAS) Objective: 
Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
Description: Write a CTAS query to create a new table that lists each member 
and the books they have issued but not returned within 30 days. The table should include:
The number of overdue books. The total fines, with each day's fine calculated at $0.50. 
The number of books issued by each member. 
The resulting table should show: Member ID Number of overdue books Total fines */

 select member_id,
    member_name,
	book_title,
    issued_date, days_overdue, days_overdue*0.50 as fine from   (SELECT 
    members.member_id,
    members.member_name,
    issued_status.issued_book_name AS book_title,
    issued_status.issued_date,
    DATEDIFF(CURRENT_DATE, issued_status.issued_date) - 30 AS days_overdue
FROM 
    issued_status 
JOIN 
    members  ON issued_status.issued_member_id = members.member_id
LEFT JOIN 
    return_status  ON issued_status.issued_id = return_status.issued_id
WHERE 
    return_status.issued_id IS NULL  -- book not returned
    AND DATEDIFF(CURRENT_DATE, issued_status.issued_date) > 30)  as xyz ;

# or this *********************************************************************************************************************************************************************

    
    SELECT 
    xyz.member_id,
    xyz.member_name,
    xyz.book_title,
    xyz.issued_date,
    xyz.days_overdue,
    xyz.days_overdue * 0.50 AS fine
FROM (
    SELECT  
        m.member_id,
        m.member_name,
        i.issued_book_name AS book_title,
        i.issued_date,
        DATEDIFF(CURRENT_DATE, i.issued_date) - 30 AS days_overdue
    FROM  
        issued_status AS i
    JOIN  
        members AS m ON i.issued_member_id = m.member_id
    LEFT JOIN  
        return_status AS r ON i.issued_id = r.issued_id
    WHERE  
        r.issued_id IS NULL  -- Book not returned
        AND DATEDIFF(CURRENT_DATE, i.issued_date) > 30
) AS xyz
LIMIT 0, 50000;


