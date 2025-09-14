CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

------------------------------------------------------------

declare @x int = 50000
select id, name, salary from employees
where salary=@x

------------------------------------------------------------

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

------------------------------------------------------------

select product_name, price from products
where price > (select avg(price) from products)

------------------------------------------------------------

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees2 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees2 (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

------------------------------------------------------------

select name from departments d
join employees2 e2 on e2.id=d.id
where department_name = 'Sales'

------------------------------------------------------------

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);

------------------------------------------------------------

select name from customers c
left join orders o on o.customer_id=c.customer_id
where o.customer_id is null

------------------------------------------------------------

CREATE TABLE products2 (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products2 (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);

--------------------------------------------------------

select product_name,max(price) from products2
group by category_id, product_name

--------------------------------------------------------

CREATE TABLE departments2 (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees3 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments2 (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees3 (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);

-------------------------------------------------------------

select d2.department_name,avg(salary) as AVG_salary from employees3 e3
join departments2 d2 on d2.id=e3.department_id
group by d2.department_name
order by avg(salary) desc

-------------------------------------------------------------

CREATE TABLE employees4 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees4 (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

-------------------------------------------------------------

select name, salary from employees4 a
where salary>(select avg(salary) from employees4 b
				where a.department_id=b.department_id)

-------------------------------------------------------------

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);

-------------------------------------------------------------

select s.name, g.course_id,g.grade from students s
join grades g on g.student_id=s.student_id
group by g.course_id, s.name, g.grade
order by g.grade desc

-------------------------------------------------------------

CREATE TABLE products3 (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products3 (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);

-------------------------------------------------------------

select category_id, price from products3
order by price desc
offset 2 rows fetch next 1 row only 

-------------------------------------------------------------

CREATE TABLE employees5 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees5 (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

-------------------------------------------------------------

select a.* 
from employees5 a
where a.salary >(
		select avg(salary) from employees5 )
and a.salary<= ( 
		select max(salary) from employees5 b
		where b.department_id=a.department_id)

--------------------------------------------------------------



