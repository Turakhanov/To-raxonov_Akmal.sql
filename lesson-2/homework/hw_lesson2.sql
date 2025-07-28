--- HOMEWORK ---

create table Students_info (
StudentID int primary key, 
Full_name varchar(250) not null,
Email varchar(250) unique not null,
birthdate date,
status_ varchar(50) default('active')
)
--drop table Students_info

create table Courses (
CourseID int primary key,
Course_name varchar(250) not null unique,
Credits int check(Credits<6),
Capacity int default(30) check(Capacity>=5)
)
--drop table Courses

create table Registration (
reg_id int primary key,
student_id int foreign key references Students_info(StudentID),
course_id int foreign key references Courses(CourseID),
reg_date date default(getdate()),
grade int default(null) check(grade<100)
)
--drop table Registration

select * from Students_info
select * from Courses
select * from Registration

bulk insert Students_info
from 'C:\Users\torax\OneDrive\Desktop\Students_info.txt'

with 
(
	fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2
)


bulk insert Courses
from 'C:\Users\torax\OneDrive\Desktop\Courses.txt'

with 
(
	fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2
)

bulk insert Registration
from 'C:\Users\torax\OneDrive\Desktop\registration.txt'

with 
(
	fieldterminator = ',',
	rowterminator = '\n',
	firstrow = 2
)

--------------------------------------------------------



---TESTING---

-- insert into Registration(reg_id, student_id, course_id) values (999, 999, 999) WRONG
--insert into Students_info(StudentID, Full_name, Email, birthdate) values (999, 'Akmal', 'akmal@gmail.com', '03/30/2008')

--delete from Students_info
--where StudentID = 999

--select * from Students_info


------------------------------------------------------------------------------------------


--- HOMEWORK ---

create table Employees_info (EmpID int, Name varchar(50), Salary decimal(10,2))
insert into Employees_info values (1, 'Alex', 1200), (2, 'Anna', 1300), (3, 'Harry', 1500)

update Employees_info
set salary = 7000 where EmpID = 1

delete Employees_info
where EmpID = 2

-- DELETE = removes specific row from table, it can be filtered and rolled back
---TRANCATE = removes all rows from table, often impossible to roll back
--- DROP = completely removes table from database, it can't be rolled back

alter table Employees_info
alter column Name varchar(100);

alter table Employees_info
add Department varchar(100)

alter table Employees_info
alter column Salary float


select * from Employees_info


create table Departments (DepartmentID int primary key, DepartmentName varchar(50))

truncate table Employees_info

insert into Departments values (1, 'Management'), (2, 'HR'), (3, 'Marketing'), (4, 'Sales'), (5, 'Investors')

update Employees_info
set Department = 'Management'
where salary > 5000	

truncate table Employees_info

drop table Employees_info
drop column Department;

exec sp_rename 'Employees_info', 'StaffMember'

select * from StaffMember

drop table Departments



create table Products (ProductID int primary key, ProductName varchar(100), Category varchar(100), Price decimal(10,2) check(Price>0))

alter table Products
add StockQuantity int default(50)

EXEC sp_rename 'Products.Category', 'CategoryName', 'COLUMN';

insert into Products values (1, 'Ipad', 'Technology', 1200, 100), (2, 'Water Bottle', 'Home', 7.99, 75), (3, 'Pen', 'Stationery', 6.25, 200), (4, 'Bread', 'Home', 4.75, 50), (5, 'Laptop', 'Technology', 2000, null)

select *
into Products_Backup
from Products

select * from Products

exec sp_rename 'Products', 'Inventory'

select * from Inventory

ALTER TABLE Inventory
DROP CONSTRAINT CK__Products__Price__3B75D760;

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;


ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);

select * from Inventory
