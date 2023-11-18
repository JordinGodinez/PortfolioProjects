
--Our data set

SELECT *
FROM Project_1..Orders

--------------------------------------------------------------
--Data Cleaning

--Convert Order Date and Ship Date to regular date without timestamp

SELECT 
	YEAR([Order Date]), MONTH([Order Date]), DAY([Order Date]), [Order Date]
FROM Project_1..Orders

SELECT
	CONCAT(YEAR([Order Date]),'-', MONTH([Order Date]), '-', DAY([Order Date])) as Order_Date
FROM Project_1..Orders

ALTER TABLE Project_1..Orders
Add Order_date date;

ALTER TABLE Project_1..Orders
Add Ship_date date;

Update Project_1..Orders
SET Order_date = CONCAT(YEAR([Order Date]),'-', MONTH([Order Date]), '-', DAY([Order Date]));

Update Project_1..Orders
SET Ship_date = CONCAT(YEAR([Ship Date]),'-', MONTH([Ship Date]), '-', DAY([Ship Date]));

--------------------------------------------------------------
--Generate price per item column

ALTER TABLE Project_1..Orders
Add Priceperproduct float;

UPDATE Project_1..Orders
SET Priceperproduct = Sales/Quantity;

--------------------------------------------------------------
--Overall Sales per year

SELECT YEAR(Order_date) as Year,
	ROUND(SUM(Sales),0) as Total_Sales
FROM Project_1..Orders
GROUP BY YEAR(Order_date) 
ORDER BY Year;

--------------------------------------------------------------
--Sales performance by Quarter and Month out of the year

WITH Quarter_period as(SELECT Sales,
	DATEPART(quarter, Order_date) as Quarter,
	CASE
		WHEN MONTH(Order_date) = 1 THEN 'P1'
		WHEN MONTH(Order_date) = 2 THEN 'P2'
		WHEN MONTH(Order_date) = 3 THEN 'P3'
		WHEN MONTH(Order_date) = 4 THEN 'P4'
		WHEN MONTH(Order_date) = 5 THEN 'P5'
		WHEN MONTH(Order_date) = 6 THEN 'P6'
		WHEN MONTH(Order_date) = 7 THEN 'P7'
		WHEN MONTH(Order_date) = 8 THEN 'P8'
		WHEN MONTH(Order_date) = 9 THEN 'P9'
		WHEN MONTH(Order_date) = 10 THEN 'P10'
		WHEN MONTH(Order_date) = 11 THEN 'P11'
		WHEN MONTH(Order_date) = 12 THEN 'P12'
	END as Period
FROM Project_1..Orders)

SELECT Quarter, Period, ROUND(SUM(Sales),0) as Total_Sales
FROM Quarter_period
GROUP BY Quarter, Period
ORDER BY Total_Sales DESC;

--------------------------------------------------------------
--Sales performance across different product categories and subcategories

SELECT 
	Category,
	ROUND(SUM(Sales),0) as Total_Sales
FROM Project_1..Orders
GROUP BY Category;

SELECT 
	[Sub-Category],
	ROUND(SUM(Sales),0) as Total_Sales
FROM Project_1..Orders
GROUP BY [Sub-Category];

--------------------------------------------------------------
--What are the top 3 products with the most sales?

SELECT 
	[Product Name],
	ROUND(SUM(Sales),0) as Total_Sales
FROM Project_1..Orders
GROUP BY [Product Name]
ORDER BY Total_Sales DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--------------------------------------------------------------
-- What are the most purchased Products?

SELECT 
	[Product Name],
	SUM(Quantity) as Total_Sold
FROM Project_1..Orders
GROUP BY [Product Name]
ORDER BY Total_Sold DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--------------------------------------------------------------
--What are the top 3 products with the least sales?

SELECT 
	[Product Name],
	ROUND(SUM(Sales),0) as Total_Sales
FROM Project_1..Orders
GROUP BY [Product Name]
ORDER BY Total_Sales
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--------------------------------------------------------------
--What are the least purchased products?

SELECT 
	[Product Name],
	SUM(Quantity) as Total_Sold
FROM Project_1..Orders
GROUP BY [Product Name]
ORDER BY Total_Sold
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;
--------------------------------------------------------------
--What is the average order value?

WITH average as(SELECT 
	[Order ID],
	SUM(Sales) as Total_Sales
FROM Project_1..Orders
GROUP BY [Order ID])

SELECT 
	ROUND(AVG(Total_Sales),0) as Avg_Order_Value
FROM average
--------------------------------------------------------------
--Sales by Region

SELECT 
	Region,
	ROUND(SUM(Sales),0) as Total_Sales
FROM Project_1..Orders
GROUP BY Region
ORDER BY Total_Sales DESC

--------------------------------------------------------------
--Top 3 sates with the most sales

SELECT 
	State,
	ROUND(SUM(Sales),0) as Total_Sales
FROM Project_1..Orders
GROUP BY State
ORDER BY Total_Sales DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--------------------------------------------------------------
--AVG Profit per order

WITH profit_per_order as(SELECT 
	[Order ID],
	SUM(Profit) as Total_Profit
FROM Project_1..Orders
GROUP BY [Order ID])

SELECT 
	ROUND(AVG(Total_Profit),0) as Avg_Profit_Per_Order
FROM profit_per_order
	
--------------------------------------------------------------
--Drop unecessary columns

SELECT [Order Date] 
FROM Project_1..Orders

ALTER TABLE Project_1..Orders
DROP COLUMN [Order Date];

ALTER TABLE Project_1..Orders
DROP COLUMN [Ship Date];

SELECT *
FROM Project_1..Orders
