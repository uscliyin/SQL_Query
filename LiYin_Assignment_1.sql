USE AdventureWorks2019
GO

--1. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, with no filter. 
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product

--2. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, excludes the rows that ListPrice is 0.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice !=0

--3. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color is null

--4. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color is not null

--5. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color is not null and ListPrice>0

--6. Write a query that concatenates the columns Name and Color from the Production.Product table by excluding the rows that are null for color.
SELECT Name + ' ' + Color as NewName
FROM Production.Product
WHERE Color is not null

--7. Write a query that generates the following result set  from Production.Product:
SELECT TOP 6 Name, Color
FROM Production.Product
WHERE Color = 'Black' or Color = 'Silver' -- Only 6 rows show in question, so I used TOP 6. However, if you asked me to get all information of data, and just delete TOP 6

--8. Write a query to retrieve the to the columns ProductID and Name from the Production.Product table filtered by ProductID from 400 to 500
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID BETWEEN 400 and 500

--9. Write a query to retrieve the to the columns  ProductID, Name and color from the Production.Product table restricted to the colors black and blue
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color='Black' OR Color='Blue'

--10. Write a query to get a result set on products that begins with the letter S. 
SELECT *
FROM Production.Product
WHERE Name LIKE 'S%' -- I'm not sure whether name of products begin with the letter S or other columns

-- 11. Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following. Order the result set by the Name column. 
SELECT Top 6 Name, ListPrice
FROM Production.Product
WHERE NAME LIKE 'S%'
ORDER BY 1

-- 12.  Write a query that retrieves the columns Name and ListPrice from the Production.Product table. 
-- Your result set should look something like the following. Order the result set by the Name column. The products name should start with either 'A' or 'S'
SELECT Top 5 Name, ListPrice
FROM Production.Product
WHERE NAME LIKE 'S%' or NAME LIKE 'A%'
ORDER BY 1

--13. Write a query so you retrieve rows that have a Name that begins with the letters SPO, but is then not followed by the letter K. 
-- After this zero or more letters can exists. Order the result set by the Name column.
SELECT Name, ListPrice
FROM Production.Product
WHERE NAME LIKE 'SPO[^K]%'
ORDER BY 1

--14. Write a query that retrieves unique colors from the table Production.Product. Order the results  in descending  manner
SELECT DISTINCT Color
FROM Production.Product
WHERE Color is not null
ORDER BY 1 DESC

-- 15. Write a query that retrieves the unique combination of columns ProductSubcategoryID and Color from the Production.
-- Product table. Format and sort so the result set accordingly to the following. 
-- We do not want any rows that are NULL.in any of the two columns in the result.
SELECT DISTINCT T_1.ProductSubcategoryID, T_2.Color
FROM
(SELECT ProductSubcategoryID
FROM Production.Product
WHERE ProductSubcategoryID is not null) AS T_1
CROSS JOIN
(SELECT Color
FROM Production.Product
WHERE Color is not null) as T_2
ORDER BY 1,2



