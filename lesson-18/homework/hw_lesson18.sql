CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

-----------------------------------------------------------------

create table #monthlysales ( product varchar(500), Total_quantity int, Total_revenue decimal (10,2));
go

insert into #monthlysales (product, Total_quantity, Total_revenue)
select
		p.ProductName,
		sum(s.Quantity),
		sum(s.Quantity*p.Price)
from Sales s
join Products p on p.ProductID=s.ProductID
where MONTH(s.SaleDate) = MONTH(GETDATE())
and YEAR(s.SaleDate)=YEAR(GETDATE())
group by p.ProductName

select * from #monthlysales

----------------------------------------------------------

create view vw_ProductSalesSummary as
	select p.ProductID, p.ProductName, p.Category, sum(s.Quantity) as total_quantity_sold from Products p
	join Sales s on s.ProductID=p.ProductID
	group by p.ProductID, p.ProductName, p.Category

select * from vw_ProductSalesSummary

----------------------------------------------------------


create function fn_GetTotalRevenueForProduct (@productID int)
returns decimal(10,2)
as
begin
	declare @revenue decimal(10,2) 
	select @revenue = sum(p.price*s.quantity) from products p
	join Sales s on s.ProductID=p.ProductID
	where p.productid = @productID

	return isnull(@revenue,0.00)
	
end;

select dbo.fn_GetTotalRevenueForProduct(12)

------------------------------------------------------------

create function fn_GetSalesByCategory(@category varchar(50))
returns table
as
return(
	select p.ProductName, sum(s.Quantity) quantity, SUM(s.Quantity*p.Price) as revenue from Products p
	join Sales s on s.ProductID=p.ProductID
	where p.Category=@category
	group by p.ProductName
);
go

select * from dbo.fn_GetSalesByCategory('Toys')

---------------------------------------------------------

CREATE FUNCTION fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    -- handle numbers < 2
    IF @Number < 2 
        RETURN 'No';

    DECLARE @i INT = 2;

    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0
            RETURN 'No';   -- divisible by i → not prime

        SET @i += 1;
    END;

    RETURN 'Yes';  -- no divisors found → prime
END;
GO

SELECT dbo.fn_IsPrime(7) AS Result;  -- returns 'Yes'
SELECT dbo.fn_IsPrime(8) AS Result;  -- returns 'No'

---------------------------------------------------

create function fn_GetNumbersBetween(@start int, @end int)
returns @numbers table (Number int)
as
begin
	declare @i int = @start
	while @i<=@end 
	begin 
		insert into @numbers(Number) values (@i)
		set @i+=1
	end
	return
end

select * from dbo.fn_GetNumbersBetween(1,10)

---------------------------------------------

create table employee (id int, salary int);
insert into employee values (1,100),(2,200),(3,300);




CREATE FUNCTION fn_GetNthHighestSalary (@N INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Salary DECIMAL(18,2);

    SELECT @Salary = MAX(Salary)   -- MAX makes it return NULL if no row
    FROM (
        SELECT 
            Salary,
            DENSE_RANK() OVER (ORDER BY Salary DESC) AS rnk
        FROM Employee
    ) AS t
    WHERE rnk = @N;

    RETURN @Salary;
END;
GO

select dbo.fn_GetNthHighestSalary(1);

------------------------------------------------

CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id  INT,
    accept_date  DATE
);
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');

------------------------------------------------

with all_friends as( 
	select requester_id as userid, accepter_id as friendid from RequestAccepted
	union all
	select requester_id as friendid, accepter_id as userid from RequestAccepted
	)

select top 1 userid as id, COUNT(distinct friendid) as num from all_friends
group by userid
order by COUNT(distinct friendid) desc

--------------------------------------------

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);

--------------------------------------------

create view	vw_CustomerOrderSummary as
	select  
			c.customer_id,
			c.name,
			SUM(o.order_id) as total_orders,
			sum(o.amount) as total_amount,
			MAX(o.order_date) as last_order_date
	from Customers c
	join Orders o on o.customer_id=c.customer_id
	group by c.customer_id, c.name

select * from vw_CustomerOrderSummary

-------------------------------------------------

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,NULL),(8,NULL),(9,NULL),(10,'Charlie'), (11, NULL), (12, NULL)

-------------------------------------------------

SELECT 
    RowNumber,
    MAX(TestCase) OVER (ORDER BY RowNumber ROWS UNBOUNDED PRECEDING) AS Workflow
FROM gaps
ORDER BY RowNumber;









