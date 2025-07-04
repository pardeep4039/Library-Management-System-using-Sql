create database library;
use library ;
create table branch 
(branch_id varchar(10) primary key ,
	manager_id varchar(10) ,
	branch_address varchar(50),
	contact_no varchar(10)
);
create table employees (emp_id varchar(10) primary key ,
	emp_name varchar(50),
	position varchar(20),
	salary int ,
    branch_id varchar(10) -- FK 
);
create table books (
isbn	varchar(20) primary key ,
book_title	varchar(75),
category	varchar(20),
rental_price	float,
status	varchar(15),
author	varchar(40),
publisher varchar(55)
);

create table members (
member_id varchar(10) primary key,
member_name	varchar(25),
member_address	varchar(75),
reg_date date 
);
 create table issued_status (
 issued_id	varchar(10) primary key,
 issued_member_id	varchar(10), -- FK 
 issued_book_name	varchar(75),
 issued_date	date ,
 issued_book_isbn	varchar(30) , -- FK
 issued_emp_id varchar(10) -- FK 
 );

create table return_status (
return_id	varchar(10) primary key,
issued_id	varchar(10),
return_book_name	varchar(75),
return_date	date,
return_book_isbn varchar(20)
);

#FOREGIN KEY
ALTER table issued_status
add constraint fk_members foreign key (issued_member_id)
references members(member_id);

ALTER table issued_status
add constraint fk_books foreign key (issued_book_name)
references books (isbn);

ALTER table issued_status
add constraint fk_employees foreign key (issued_emp_id)
references employees (emp_id);

ALTER table employees
add constraint fk_branch foreign key (branch_id)
references branch (branch_id);

ALTER table return_status
add constraint fk_issued_status foreign key (issued_id)
references issued_status (issued_id);

 