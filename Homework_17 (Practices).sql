create database hw17

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

---------------------------------------------------------------

select d.Distributor, r.Region, coalesce(SUM(s.Sales),0) as Total_sales from (select distinct Distributor from #RegionSales) d
cross join (select distinct Region from #RegionSales) r
left join #RegionSales s
	on s.Distributor=d.Distributor
	and s.Region=r.Region
group by d.Distributor,r.Region
order by d.Distributor,r.Region

------------------------------------------------------

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);

INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

------------------------------------------------------

select m.name from Employee e
left join Employee m on m.id=e.managerId
group by m.id, m.name
having COUNT(e.id)>=5

------------------------------------------------------

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

------------------------------------------------------

select p.product_name,sum(o.unit) from Products p
join Orders o on o.product_id=p.product_id
where YEAR(o.order_date)=2020
group by p.product_name
having sum(o.unit)>=100 

------------------------------------------------------

CREATE TABLE Orders2 (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders2 VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

-------------------------------------------------------

with vendorcounts as(
select 
	CustomerID,
	Vendor,
	Count(*) as ordercount,
	ROW_NUMBER() over(
		partition by customerid
		order by count(*) desc
		) as rn
from Orders2
group by CustomerID,Vendor
)

select CustomerID, vendor from vendorcounts
where rn=1

-------------------------------------------------

DECLARE @Check_Prime INT = 29;
DECLARE @i INT = 2;
DECLARE @isPrime BIT = 1;

IF @Check_Prime < 2 SET @isPrime = 0;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @isPrime = 0;
        BREAK;
    END
    SET @i += 1;
END;

SELECT CASE WHEN @isPrime = 1
            THEN 'This number is prime'
            ELSE 'This number is not prime' END AS Result;

---------------------------------------------------------

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

---------------------------------------------------------

with signalcounts as(

select 
	Device_id,
	Locations,
	COUNT(*) as signalcount
from Device	
group by Device_id, Locations
),
ranked as(
select 
	Device_id,
	Locations,
	signalcount,
	COUNT(Locations) over (partition by device_id) as no_of_locations,
	ROW_NUMBER() over(
		partition by device_id
		order by signalcount desc
		) as rn
from signalcounts
)

select Device_id, no_of_locations,Locations as max_signal_location, signalcount as no_of_signals from ranked
where rn=1

------------------------------------------------------------

CREATE TABLE Employee2 (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee2 VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

------------------------------------------------------------

select EmpID, EmpName, Salary from Employee2 e
where Salary> (
	select AVG(salary) from Employee2
	where DeptID=e.DeptID )

------------------------------------------------------------



CREATE TABLE Numbers (
    Number INT
);


INSERT INTO Numbers (Number)
VALUES
(25),
(45),
(78);


CREATE TABLE Tickets (
    TicketID VARCHAR(10),
    Number INT
);


INSERT INTO Tickets (TicketID, Number)
VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

--------------------------------------------------------

with wincount as (
select COUNT(*) as total_wins from Numbers n
),

ticketmatches as (
select t.TicketID, COUNT(*) as matched from Tickets t
join Numbers n on t.Number=n.Number
group by t.TicketID
)

select 
	tm.TicketID, 
	case 
		when tm.matched=wc.total_wins then 100
		when tm.matched>0 then 10
		else 0
	end as prize_money
from ticketmatches tm
cross join wincount wc

----------------------------------------------------

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

----------------------------------------------------

with userplatform as(
select 
	User_id,
	Spend_date,
	Platform, 
	SUM(amount) as amount
from Spending
group by User_id, Spend_date, Platform
),

userflags as(
select 
	User_id,
	Spend_date,
	max(case when platform = 'Mobile' then 1 else 0 end ) as has_mobile,
	max(case when platform = 'Desktop' then 1 else 0 end ) as has_desktop,
	SUM(amount) as total_amount
from userplatform
group by User_id, Spend_date
),

classified as (
select 
	Spend_date,
		case
			when has_mobile=1 and has_desktop=0 then 'Mobile'
			when has_mobile=0 and has_desktop=1 then 'Desktop'
			when has_mobile=1 and has_desktop=1 then 'Both'
			end as platform,
	user_id,
	total_amount
from userflags
)

select 
	Spend_date,
	platform,
	SUM(total_amount) as total_amount,
	COUNT(distinct User_id) as total_users
from classified
group by Spend_date, platform
order by Spend_date, platform

---------------------------------------------------------------


CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

----------------------------------------------------------------

with numbers as (
select 1 as n
union all
select n+1 from numbers where n<100
)

select g.Product, 1 as Quantity from Grouped g
join numbers n on n.n<=g.Quantity
order by Product