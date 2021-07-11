--Q1: By Order Quantity, what were the five most popular products sold in 2014?
--Include these data points in the output:
--Order Date Year
--Product ID
--Product Name
--Product Number
--Product Color
--Sales Order Count
--Order Quantity
--Sales Order Line total

--A:
--2014	870	WB-H098	Water Bottle - 30 oz.	NULL	2273	2902	12900.317660
--2014	712	CA-1098	AWC Logo Cap	Multi	1267	1950	14430.970952
--2014	711	HL-U509-B	Sport-100 Helmet, Blue	Blue	1221	1776	52353.591556
--2014	873	PK-7098	Patch Kit/8 Patches	NULL	1608	1761	3850.406000
--2014	707	HL-U509-R	Sport-100 Helmet, Red	Red	1231	1717	51697.665517

SELECT TOP 5 year(soh.orderdate) AS OrderDateYear
, p.ProductID, p.ProductNumber
, p.Name AS ProductName
, p.Color AS ProductColor
, Count(sod.SalesOrderID) AS SalesOrderIDCount
, sum(sod.OrderQty) AS OrderQtySum
, sum(sod.LineTotal) AS SalesOrderLineTotalSum
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
INNER JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE year(soh.OrderDate) = 2014
GROUP BY year(soh.OrderDate), p.ProductID, p.Name, p.ProductNumber, p.Color
ORDER BY 7 DESC;


--Q2: How long are the 7 longest Person names and to whom do they belong? Rank by Full Name length, Last Name Length, First Name Length
--Include these data points in the output:
--Business Entity ID
--Full Name
--Full Name Length
--First Name
--First Name Length
--Middle Name
--Last Name
--Last Name Length

--A:
--4388	Osarumwense Uwaifiokun Agbonile	31	Osarumwense	11	Uwaifiokun	Agbonile	8
--565	Janaina Barreiro Gambaro  Bueno	31	Janaina Barreiro Gambaro	24	NULL	Bueno	5
--775	Alvaro  De Matos Miranda Filho	30	Alvaro	6	NULL	De Matos Miranda Filho	22
--1979	Ranjit Rudra Varkey Chudukatil	30	Ranjit	6	Rudra	Varkey Chudukatil	17
--272	Janaina Barreiro Gambaro Bueno	30	Janaina	7	Barreiro Gambaro	Bueno	5
--2348	Janaina Barreiro Gambaro Bueno	30	Janaina	7	Barreiro Gambaro	Bueno	5
--12799	Francisco  Javier Castrejón	27	Francisco	9	NULL	Javier Castrejón	16

SELECT TOP 7 p.BusinessEntityID
, replace(coalesce(p.FirstName, '') + ' ' + coalesce(p.MiddleName, '') + ' ' + coalesce(p.LastName, ''), ' ', ' ') AS FullName
, len(replace(coalesce(p.FirstName, '') + ' ' + coalesce(p.MiddleName, '') + ' ' + coalesce(p.LastName, ''), ' ', ' ')) AS FullNameLength
, p.FirstName
, len(p.FirstName) AS FirstNameLength
, p.MiddleName
, p.LastName
, len(p.LastName) AS LastNameLength
from Person.Person AS p
ORDER BY 3 DESC, 8 DESC, 5 DESC;


--Q3: Which Department pays its female workers on average the most per year?
--Include these fields:
--Department ID
--Department Name
--Gender
--Total Yearly Pay
--Business Entity ID Count
--Average Yearly Pay

--A:
--2	Tool Design	F	52000.00	1	52000.00
--16	Executive	F	147713.90	3	49237.9666
--1	Engineering	F	128846.10	3	42948.70
--10	Finance	F	335985.40	8	41998.175
--6	Research and Development	F	81730.80	2	40865.40
--11	Information Services	F	144951.90	4	36237.975
--9	Human Resources	F	61639.32	2	30819.66
--7	Production	F	1322464.00	46	28749.2173
--5	Purchasing	F	164879.872	6	27479.9786
--3	Sales	F	186562.40	7	26651.7714


WITH s1
as
(SELECT d.DepartmentID, d.Name AS DepartmentName
, e.Gender
, eph.Rate, eph.PayFrequency
, e.SalariedFlag
, CASE WHEN e.SalariedFlag = 1 
THEN rate * 1000
WHEN e.SalariedFlag = 0 
THEN rate * 2080
ELSE 0 
END AS YearlyPay
, count(e.BusinessEntityID) AS BusinessEntityIDCount
, CASE WHEN e.SalariedFlag = 1 
THEN rate * 1000
WHEN e.SalariedFlag = 0 
THEN rate * 2080
ELSE 0 
END * count(e.BusinessEntityID) AS TotalYearlyPay

from HumanResources.Employee as e
INNER JOIN HumanResources.EmployeeDepartmentHistory as edh ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory as eph ON edh.BusinessEntityID = eph.BusinessEntityID
INNER JOIN HumanResources.Department as d ON edh.DepartmentID = d.DepartmentID
WHERE e.Gender = 'F'
GROUP BY d.DepartmentID
, d.Name
, e.Gender
, eph.Rate
, eph.PayFrequency
, e.SalariedFlag
, CASE WHEN e.SalariedFlag = 1 
THEN rate * 1000
WHEN e.SalariedFlag = 0 
THEN rate * 2080
ELSE 0 
END)
SELECT TOP 10 s1.DepartmentID
, s1.DepartmentName
, s1.Gender
, sum(s1.TotalYearlyPay) AS TotalYearlyPay
, sum(s1.BusinessEntityIDCount) AS BusinessEntityIDCount
, sum(s1.TotalYearlyPay) / sum(s1.BusinessEntityIDCount) AS AverageYearlyPay
FROM s1 
GROUP BY s1.DepartmentID
, s1. DepartmentName
, s1. Gender
ORDER BY 6 DESC