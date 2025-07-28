--- HOMEWORK QUERY---




#1
Data - Raw facts or figures that have no meaning on their own.
       Example: "France", 67.39, 1789-07-14

Database - An organized collection of data stored and accessed electronically. 
           In SQL Server, it’s a structured environment to store multiple related tables, views, procedures, etc.

Relational Database - A type of database that stores data in tables (relations) with rows and columns,
                      and allows relationships between tables using keys (like ID, foreign key).

Table - A structure inside a database that stores data in rows (records) and columns (fields). 
        Each table represents one entity, like Countries or Students.

#2
Data storage and management for large datasets

Support for Transact-SQL (T-SQL) — Microsoft’s SQL extension

Security features like authentication, encryption, and roles

Backup and recovery tools to protect data

Integration with tools like SSMS, Power BI, and Visual Studio

#3
Windows Authentication

SQL Server Authentication

#4


#5


#6
SQL Server - A relational database management system (RDBMS) developed by Microsoft. 
             It stores and manages the databases. Think of it as the engine.
SSMS - SQL Server Management Studio — the tool/interface used to connect to SQL Server,
       write queries, and manage the database.
SQL - Structured Query Language — the language you use to interact with the database
      (e.g., to insert, update, delete, query data).

#7
DQL - Data Query Language - Retrive data -	(Select * from Countries)
DML - Data Manipulation Language - Insert, update, delete - insert into countries values(...)
DDL - Data Definition Language - Define or modify tables - create table, alter table
DCL - Data Control Language - Permission & Access - grant select on countries to user1
TCL - Transaction Control Language - Manage Transaction - begin transaction, commit

#9
 1. Downloaded the AdventureWorks2022.bak file from the provided link.

 2. Opened SQL Server Management Studio (SSMS) and connected to the local server.

 3. In Object Explorer, right-clicked on the Databases folder and selected Restore Database…

 4. In the Source section, chose Device and clicked the three-dot (…) button.

 5. Clicked Add, then selected the AdventureWorks2022.bak file from my computer.

 6. Clicked OK, and the backup set appeared in the restore list.

 7. Proceeded with the restore process by confirming all options and clicking OK.

 8. After successful restoration, the AdventureWorks2022 database appeared under Databases in Object Explorer.



create database SchoolDB
create table Student_info (
StudentID int,
Name varchar (50),
Age int,
)

select * from Student_info

insert into Student_info values (1, 'Alex', 20)
insert into Student_info values (2, 'John', 18)
insert into Student_info values (3, 'Lewis', 17)

create database lesson_1 
