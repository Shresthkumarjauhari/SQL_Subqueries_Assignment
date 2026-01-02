
-- ======================================================
-- SQL SUBQUERIES ASSIGNMENT
-- Tool: MySQL Workbench
-- ======================================================

CREATE DATABASE IF NOT EXISTS sql_subqueries_db;
USE sql_subqueries_db;

-- ===============================
-- TABLE CREATION
-- ===============================

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id VARCHAR(5),
    salary INT
);

CREATE TABLE Departments (
    department_id VARCHAR(5) PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount INT,
    sale_date DATE
);

-- ===============================
-- DATA INSERTION
-- ===============================

INSERT INTO Employees VALUES
(101,'Abhishek','D01',62000),
(102,'Shubham','D01',58000),
(103,'Priya','D02',67000),
(104,'Rohit','D02',64000),
(105,'Neha','D03',72000),
(106,'Aman','D03',55000),
(107,'Ravi','D04',60000),
(108,'Sneha','D04',75000),
(109,'Kiran','D05',70000),
(110,'Tanuja','D05',65000);

INSERT INTO Departments VALUES
('D01','Sales','Mumbai'),
('D02','Marketing','Delhi'),
('D03','Finance','Pune'),
('D04','HR','Bengaluru'),
('D05','IT','Hyderabad');

INSERT INTO Sales VALUES
(201,101,4500,'2025-01-05'),
(202,102,7800,'2025-01-10'),
(203,103,6700,'2025-01-14'),
(204,104,12000,'2025-01-20'),
(205,105,9800,'2025-02-02'),
(206,106,10500,'2025-02-05'),
(207,107,3200,'2025-02-09'),
(208,108,5100,'2025-02-15'),
(209,109,3900,'2025-02-20'),
(210,110,7200,'2025-03-01');

-- ======================================================
-- BASIC LEVEL SUBQUERIES
-- ======================================================

-- Q1. Find the names of employees who earn more than the average salary of all employees.
SELECT name
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- Q2. Find the employees who work in the department having the highest average salary.
SELECT name
FROM Employees
WHERE department_id = (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);

-- Q3. Find the names of employees who have made at least one sale.
SELECT name
FROM Employees
WHERE emp_id IN (SELECT emp_id FROM Sales);

-- Q4. Find the name of the employee who made the highest sale.
SELECT name
FROM Employees
WHERE emp_id = (
    SELECT emp_id
    FROM Sales
    ORDER BY sale_amount DESC
    LIMIT 1
);

-- Q5. Find the names of employees who earn more than Shubham.
SELECT name
FROM Employees
WHERE salary > (
    SELECT salary FROM Employees WHERE name = 'Shubham'
);

-- ======================================================
-- INTERMEDIATE LEVEL SUBQUERIES
-- ======================================================

-- Q6. Find the names of employees who work in the same department as Abhishek.
SELECT name
FROM Employees
WHERE department_id = (
    SELECT department_id FROM Employees WHERE name = 'Abhishek'
);

-- Q7. Find the names of departments that have at least one employee earning more than 60,000.
SELECT department_name
FROM Departments
WHERE department_id IN (
    SELECT department_id
    FROM Employees
    WHERE salary > 60000
);

-- Q8. Find the department name of the employee who made the highest sale.
SELECT department_name
FROM Departments
WHERE department_id = (
    SELECT department_id
    FROM Employees
    WHERE emp_id = (
        SELECT emp_id
        FROM Sales
        ORDER BY sale_amount DESC
        LIMIT 1
    )
);

-- Q9. Find the names of employees whose sale amount is greater than the average sale amount.
SELECT name
FROM Employees
WHERE emp_id IN (
    SELECT emp_id
    FROM Sales
    WHERE sale_amount > (SELECT AVG(sale_amount) FROM Sales)
);

-- Q10. Find the total sales made by employees earning more than the average salary.
SELECT SUM(sale_amount) AS TotalSales
FROM Sales
WHERE emp_id IN (
    SELECT emp_id
    FROM Employees
    WHERE salary > (SELECT AVG(salary) FROM Employees)
);

-- ======================================================
-- ADVANCED LEVEL SUBQUERIES
-- ======================================================

-- Q11. Find the names of employees who have not made any sales.
SELECT name
FROM Employees
WHERE emp_id NOT IN (SELECT emp_id FROM Sales);

-- Q12. Find the names of departments whose average employee salary is greater than 55,000.
SELECT department_name
FROM Departments
WHERE department_id IN (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    HAVING AVG(salary) > 55000
);

-- Q13. Find the names of departments where total sales exceed 10,000.
SELECT department_name
FROM Departments
WHERE department_id IN (
    SELECT department_id
    FROM Employees
    WHERE emp_id IN (
        SELECT emp_id
        FROM Sales
        GROUP BY emp_id
        HAVING SUM(sale_amount) > 10000
    )
);

-- Q14. Find the name of the employee who made the second highest sale.
SELECT name
FROM Employees
WHERE emp_id = (
    SELECT emp_id
    FROM Sales
    ORDER BY sale_amount DESC
    LIMIT 1 OFFSET 1
);

-- Q15. Find the names of employees whose salary is greater than the highest sale amount.
SELECT name
FROM Employees
WHERE salary > (SELECT MAX(sale_amount) FROM Sales);
