USE AdventureWorks2019
GO

--1. How many products can you find in the Production.Product table?
SELECT COUNT(DISTINCT p.ProductID) as CountedProducts
FROM Production.Product as p

--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
-- The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(p.ProductID) as CountedProducts
FROM Production.Product p INNER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID=ps.ProductSubcategoryID

--3.  How many Products reside in each SubCategory? Write a query to display the results with the following titles.
-- ProductSubcategoryID CountedProducts

SELECT ps.ProductSubcategoryID, COUNT(p.ProductID) as CountedProducts
FROM Production.Product p INNER JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID=ps.ProductSubcategoryID
GROUP BY ps.ProductSubcategoryID

-- 4. How many products that do not have a product subcategory.
SELECT count(p.ProductID) as NoneProductSubcategory
FROM Production.Product p LEFT JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID=ps.ProductSubcategoryID
WHERE p.ProductSubcategoryID is null

-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT piv.ProductID,sum(piv.Quantity) as TheSum
FROM Production.ProductInventory as piv
GROUP BY piv.ProductID

-- 6.   Write a query to list the sum of products in the Production. ProductInventory table
--  and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
-- ProductID    TheSum
SELECT piv.ProductID, SUM(piv.Quantity) as TheSum
FROM Production.ProductInventory as piv
WHERE piv.LocationID=40
GROUP BY piv.ProductID
HAVING SUM(piv.Quantity)<100

-- 7.    Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and 
-- LocationID set to 40 and limit the result to include just summarized quantities less than 100
-- Shelf      ProductID    TheSum
SELECT piv.Shelf,piv.ProductID, SUM(piv.Quantity) as TheSum
FROM Production.ProductInventory as piv
WHERE piv.LocationID=40
GROUP BY piv.ProductID,piv.Shelf
HAVING SUM(piv.Quantity)<100

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from 
-- the table Production.ProductInventory table.
SELECT piv.ProductID,AVG(Quantity) as TheAvg
FROM Production.ProductInventory as piv
WHERE piv.LocationID=10
GROUP BY piv.ProductID

-- 9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
-- ProductID   Shelf      TheAvg
SELECT piv.ProductID,piv.Shelf,AVG(Quantity) as TheAvg
FROM Production.ProductInventory as piv
GROUP BY piv.ProductID,piv.Shelf


-- 10. Write query  to see the average quantity  of  products by shelf excluding rows that 
-- has the value of N/A in the column Shelf from the table Production.ProductInventory
-- ProductID   Shelf      TheAvg
SELECT piv.ProductID,piv.Shelf,AVG(Quantity) as TheAvg
FROM Production.ProductInventory as piv
WHERE piv.Shelf NOT LIKE '%N/A%'
GROUP BY piv.ProductID,piv.Shelf

-- 11.  List the members (rows) and average list price in the Production.Product table. 
-- This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
-- Color                        Class              TheCount          AvgPrice
SELECT Color,Class,COUNT(ProductID) as TheCount, AVG(ListPrice) as AvgPrice
FROM Production.Product
WHERE Color is not null and Class is not null
GROUP BY Color,Class

-- 12.   Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. 
-- Join them and produce a result set similar to the following.
-- Country                        Province
SELECT pcr.Name AS Country, psp.Name AS Province
FROM Person.CountryRegion pcr INNER JOIN Person.StateProvince psp on pcr.CountryRegionCode=psp.CountryRegionCode

--13. Write a query that lists the country and province names from person. 
-- CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. 
-- Join them and produce a result set similar to the following.
-- Country                        Province
SELECT pcr.Name AS Country, psp.Name AS Province
FROM Person.CountryRegion pcr INNER JOIN Person.StateProvince psp on pcr.CountryRegionCode=psp.CountryRegionCode
WHERE pcr.Name='Germany' or pcr.Name='Canada'

USE Northwind
GO
--14.  List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT p.ProductID,p.ProductName
FROM Orders o INNER JOIN [Order Details] od on od.OrderID=o.OrderID INNER JOIN Products p ON p.ProductID=od.ProductID
WHERE DATEDIFF(YEAR,OrderDate,GETDATE())<=25

-- 15.  List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 ShipPostalCode, COUNT(OrderID) as TheCount
FROM Orders 
WHERE ShipPostalCode is not null
GROUP BY ShipPostalCode
ORDER BY TheCount DESC

-- 16. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 ShipPostalCode, COUNT(OrderID) as TheCount
FROM Orders 
WHERE ShipPostalCode is not null and DATEDIFF(YEAR,OrderDate,GETDATE())<=25
GROUP BY ShipPostalCode
ORDER BY TheCount DESC

-- 17. List all city names and number of customers in that city.  
SELECT City,COUNT(CustomerID) as TheCount
FROM Customers
WHERE City IN (
SELECT TOP 5 ShipCity
FROM Orders 
WHERE ShipPostalCode is not null and DATEDIFF(YEAR,OrderDate,GETDATE())<=25
GROUP BY ShipCity
ORDER BY COUNT(OrderID) DESC
)
GROUP BY City

-- 18. List city names which have more than 2 customers, and number of customers in that city
SELECT City,COUNT(CustomerID) as TheCount
FROM Customers
WHERE City IN (
SELECT TOP 5 ShipCity
FROM Orders 
WHERE ShipPostalCode is not null and DATEDIFF(YEAR,OrderDate,GETDATE())<=25
GROUP BY ShipCity
ORDER BY COUNT(OrderID) DESC
)
GROUP BY City
HAVING COUNT(CustomerID)>2

--19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT c.ContactName
FROM Orders o INNER JOIN Customers c ON o.CustomerID=c.CustomerID
WHERE DATEDIFF(DAY,'1998-1-1',OrderDate)>0

-- 20.  List the names of all customers with most recent order dates
SELECT T1.ContactName
FROM
(
SELECT c.ContactName, RANK() OVER (ORDER BY o.OrderDate DESC) RNK
FROM Orders o INNER JOIN Customers c ON o.CustomerID=c.CustomerID
) T1
WHERE RNK=1

-- 21.  Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, COUNT(p.ProductID) as TheCount
FROM Customers c INNER JOIN Orders o ON o.CustomerID=c.CustomerID INNER JOIN [Order Details] od on o.OrderID=od.OrderID 
INNER JOIN Products p on od.ProductID=p.ProductID
GROUP BY c.ContactName

--22. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID
FROM Customers c INNER JOIN Orders o ON o.CustomerID=c.CustomerID INNER JOIN [Order Details] od on o.OrderID=od.OrderID 
INNER JOIN Products p on od.ProductID=p.ProductID
GROUP BY c.CustomerID
HAVING COUNT(p.ProductID)>100

--23.List all of the possible ways that suppliers can ship their products. Display the results as below
-- Supplier Company Name                Shipping Company Name
SELECT DISTINCT s.CompanyName,sh.CompanyName
FROM Suppliers s INNER JOIN Products p on p.SupplierID=s.SupplierID INNER JOIN [Order Details] od on od.ProductID=p.ProductID
INNER JOIN Orders o ON od.OrderID=o.OrderID INNER JOIN Shippers sh on sh.ShipperID=o.ShipVia

--24. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate,p.ProductName
FROM Orders o INNER JOIN [Order Details] od on od.OrderID=o.OrderID INNER JOIN Products p on p.ProductID=od.ProductID
ORDER BY 1

--25. Displays pairs of employees who have the same job title.
SELECT e1.FirstName, e2.FirstName, e1.Title
FROM Employees e1, Employees e2
WHERE e1.Title = e2.Title AND e1.EmployeeID < e2.EmployeeID

--26. Display all the Managers who have more than 2 employees reporting to them.
SELECT e2.FirstName, e2.LastName
FROM Employees e2
WHERE e2.EmployeeID IN
(SELECT e1.ReportsTo
FROM Employees e1
GROUP BY ReportsTo
HAVING COUNT(e1.EmployeeID)>2)

--27.Display the customers and suppliers by city. The results should have the following columns
-- City Name, Contact Name, Type (Customer or Supplier)
SELECT City AS [City Name], ContactName AS [Contract Name], 'Customer' AS Type
FROM Customers
UNION
SELECT City AS [City Name], ContactName AS [Contract Name], 'Supplier' AS Type
FROM Suppliers



