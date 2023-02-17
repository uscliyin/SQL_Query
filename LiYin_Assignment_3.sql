USE Northwind
GO
-- 1. List all cities that have both Employees and Customers.
SELECT DISTINCT City
FROM Employees
WHERE City IN (
SELECT DISTINCT City
FROM Customers
)
-- 2. List all cities that have Customers but no Employee.
--a.      Use sub-query
SELECT DISTINCT City
FROM Customers
WHERE City not IN (
SELECT DISTINCT City
FROM Employees
)
--b.      Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c
EXCEPT
SELECT DISTINCT e.City
FROM Employees e

--3. List all products and their total order quantities throughout all orders.

SELECT p.ProductName,SUM(od.Quantity) as TotalQuantities
FROM Products p INNER JOIN [Order Details] od on od.ProductID=p.ProductID INNER JOIN Orders o ON o.OrderID=od.OrderID
GROUP BY p.ProductName

--4. List all Customer Cities and total products ordered by that city.
SELECT c.City, COUNT(DISTINCT p.ProductID) as TotalProducts
FROM Products p INNER JOIN [Order Details] od on od.ProductID=p.ProductID INNER JOIN Orders o ON o.OrderID=od.OrderID INNER JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.City

--5. List all Customer Cities that have at least two customers.
--a.      Use union
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(DISTINCT ContactName)>=2
Union
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(DISTINCT ContactName)>=2
--b.      Use sub-query and no union
SELECT DISTINCT City
FROM Customers
WHERE City IN (
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(DISTINCT ContactName)>=2
)

--6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City
FROM Products p INNER JOIN [Order Details] od on od.ProductID=p.ProductID INNER JOIN Orders o ON o.OrderID=od.OrderID INNER JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.City
HAVING COUNT(DISTINCT p.ProductID)>=2

--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT  DISTINCT c.ContactName
FROM Orders o INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.ShipCity != c.City

--8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

SELECT T_3.ProductName,T_3.AVGPrice,T_4.City
FROM
(SELECT TOP 5 p.ProductName,AVG(od.UnitPrice) as AVGPrice
FROM Products p INNER JOIN [Order Details] od on od.ProductID=p.ProductID INNER JOIN Orders o ON o.OrderID=od.OrderID INNER JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY p.ProductName
ORDER BY SUM(od.Quantity) DESC) AS T_3
LEFT JOIN 
(
SELECT *
FROM 
(
SELECT T_1.ProductName, T_1.City, RANK() OVER (PARTITION BY T_1.ProductName ORDER BY T_1.TotalQuantity DESC) as RNK
FROM
(
SELECT p.ProductName, c.City,SUM(od.Quantity) as TotalQuantity
FROM Products p INNER JOIN [Order Details] od on od.ProductID=p.ProductID INNER JOIN Orders o ON o.OrderID=od.OrderID INNER JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE p.ProductName IN 
(
SELECT TOP 5 p.ProductName
FROM Products p INNER JOIN [Order Details] od on od.ProductID=p.ProductID INNER JOIN Orders o ON o.OrderID=od.OrderID INNER JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY p.ProductName
ORDER BY SUM(od.Quantity) DESC
)
GROUP BY p.ProductName, c.City) AS T_1
) AS T_2
WHERE RNK=1) AS T_4 ON T_3.ProductName=T_4.ProductName

--9.      List all cities that have never ordered something but we have employees there.
--a.      Use sub-query
SELECT e.City
FROM Employees e
WHERE City not in 
(
SELECT c.City
FROM Customers c INNER JOIN Orders o On o.CustomerID=c.CustomerID
)

--b.      Do not use sub-query
SELECT e.City
FROM Employees e LEFT JOIN Customers c ON c.City=e.City
WHERE c.CustomerID is null

--10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
-- and also the city of most total quantity of products ordered from. (tip: join  sub-query)

SELECT T_1.City
FROM 
(SELECT TOP 1 e.City,COUNT(O.OrderID) AS NumOfOrders
FROM Employees e INNER JOIN Orders o ON e.EmployeeID=o.EmployeeID
GROUP BY e.City
ORDER BY NumOfOrders DESC) AS T_1
INNER JOIN
(
SELECT TOP 1 c.City, SUM(od.Quantity) as TotalQuantity
FROM Customers c INNER JOIN Orders o ON o.CustomerID=c.CustomerID INNER JOIN [Order Details] od ON od.OrderID=o.OrderID
GROUP BY c.City
ORDER BY TotalQuantity DESC) AS T_2
ON T_1.City=T_2.City
--11. How do you remove the duplicates record of a table?
-- Use DISTINCT

-- DELETE FROM TABLENAME
-- WHERE TABLENAME.ID NOT IN (SELECT MIN(TABLENAME.ID) FROM TABLENAME GROUP BY ALL_Columns)