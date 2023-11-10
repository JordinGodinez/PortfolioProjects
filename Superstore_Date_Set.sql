-- Our Data Set

SELECT *
FROM SQL_Project_1..Store_Data_Set;  

--------------------------------------------------

--Adding a Total_sales_per_Order column

ALTER TABLE SQL_Project_1..Store_Data_Set
Add Total_Sales_Per_Product float;

Update SQL_Project_1..Store_Data_Set
SET Total_Sales_Per_Product = Sales*Quantity;


--------------------------------------------------

--Total_Sales by Year and Month

SELECT YEAR(Order_Date) as Year, MONTH(Order_Date) as Month, ROUND(SUM(Sales),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);

--------------------------------------------------

--Total Sales by Year

SELECT YEAR(Order_Date) as Year, ROUND(SUM(Sales),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY YEAR(Order_Date) 
ORDER BY Year;

--------------------------------------------------

--Which categories or products generate the most revenue?

--Top 3 Categories
SELECT Category, ROUND(SUM(Total_Sales_Per_Product),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY Category
ORDER BY Total_Sales DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--Top 3 Products
SELECT Product_Name, ROUND(SUM(Total_Sales_Per_Product),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY Product_Name
ORDER BY Total_Sales DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--------------------------------------------------
 --Max and Min Sales

 SELECT ROUND(MAX(Sales),0) as Max_Sale, MIN(Sales) as Min_Sale
 FROM SQL_Project_1..Store_Data_Set

--------------------------------------------------
--Which regions or locations are the strongest and weakest in terms of sales?

--Top 3 states with most sales
SELECT State, ROUND(SUM(Total_Sales_Per_Product),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY State
ORDER BY Total_Sales DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--Top 3 States with least sales
SELECT State, ROUND(SUM(Total_Sales_Per_Product),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY State
ORDER BY Total_Sales
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--Top 3 Cities with most sales
SELECT City, ROUND(SUM(sales),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY City
ORDER BY Total_Sales DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--Top 3 Cities with least sales
SELECT City, ROUND(SUM(sales),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY City
ORDER BY Total_Sales
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--------------------------------------------------

--What is the seasonality of sales?

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
FROM SQL_Project_1..Store_Data_Set)

SELECT Quarter, Period, ROUND(SUM(Sales),0) as Total_Sales
FROM Quarter_period
GROUP BY Quarter, Period
ORDER BY Total_Sales DESC;


--------------------------------------------------

--What is the average amount customers spend per order?

SELECT Customer_Name, ROUND(AVG(Total_Sales_Per_Product),0) as Avg_Spent_Per_Order
FROM SQL_Project_1..Store_Data_Set
GROUP BY Customer_Name;

--------------------------------------------------

--Customer Purchase Frequency per Year

SELECT Customer_Name, COUNT(*) as Customer_Purchase_Frequency
FROM SQL_Project_1..Store_Data_Set
GROUP BY Customer_Name
ORDER BY Customer_Purchase_Frequency DESC;

--------------------------------------------------

--Sales per Customer

SELECT Customer_Name, ROUND(SUM(Sales),0) as Total_Sales
FROM SQL_Project_1..Store_Data_Set
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

