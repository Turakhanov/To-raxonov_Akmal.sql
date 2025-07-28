---GITHUB_3---

--#1

--BULK INSERT is a T-SQL command used in SQL Server to import a large volume of data from a file (typically a .txt, .csv, etc.) into a table efficiently and quickly. 
--It's especially useful when dealing with large datasets, allowing data to be imported with minimal overhead.

--#2 

--- CSV, TXT, XLSX, XLM

--- #3

create table Products (ProductID int primary key, ProductName varchar(50) unique, Price decimal(10,2))
INSERT INTO Products (ProductID, ProductName, Price)
VALUES
(1, 'Laptop', 899.99),
(2, 'Smartphone', 499.50),
(3, 'Headphones', 79.95);

--- null allows the record to be null unlike not null
--- comments help us to understand query

alter table products
add CategoryID int

select * from Products

create table Categories (CategoryID int primary key, ProductName varchar(50) unique)

insert into Categories(CategoryID,ProductName) values (1000,'Apple'),(1000,'Banana'),(1001,'Cucumber'),(1002,'Pepsi'),(1001,'Potato'),(1002,'Cola'),(1000,'Pear'),(1001,'Carrot')

--- IDENTITY help us to manage ids

truncate table products
bulk insert products
from 'C:\Users\torax\OneDrive\Desktop\Products.txt'

with (
fieldterminator = ',',
rowterminator = '\n',
firstrow = 2
);
drop table Categories

--add constraint FK_Products_Categories 
--foreign key (CategoryID) 
--references Categories(CategoryID)
