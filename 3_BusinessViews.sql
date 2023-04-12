USE [2022DBFall_Group_1_DB]
GO


/* 
Business View 1 - Revenue Analysis
*/
CREATE OR ALTER VIEW [dbo].[REVENUE_ANALYSIS_VW] WITH SCHEMABINDING 
AS
	SELECT s.PROD_ID as [PRODUCT ID], 
		YEAR(s.SALE_DATE) AS [YEAR], 
		MONTH(s.SALE_DATE) AS [MONTH],
		SUM(s.AMOUNT_SOLD) AS [Total Amount Sold],
		SUM(s.QUANTITY_SOLD) AS [Total Quantity Sold],
		cc.COUNTRY_REGION AS REGION,
		COUNT_BIG(*) AS [Count] 
	FROM dbo.SALES as s
		JOIN dbo.CUSTOMERS as cust
			ON cust.CUST_ID = s.CUST_ID
		JOIN dbo.CUSTOMERS_COUNTRY as cc
			ON cust.COUNTRY_ID = cc.COUNTRY_ID
	GROUP BY s.PROD_ID, YEAR(s.SALE_DATE), MONTH(s.SALE_DATE), cc.COUNTRY_REGION
GO

CREATE UNIQUE CLUSTERED INDEX IDX_REVENUE_ANALYSIS ON [dbo].[REVENUE_ANALYSIS_VW] ([PRODUCT ID], [YEAR], [MONTH], [REGION])
GO

CREATE OR ALTER VIEW [dbo].[REVENUE_ANALYSIS_AVG_VW] WITH SCHEMABINDING 
AS
	SELECT 
		[Product ID], 
		[Year], 
		[Month], 
		[Region],
		[Total Amount Sold], 
		[Total Quantity Sold],
		CAST([Total Amount Sold]/[Total Quantity Sold] AS DECIMAL (10,2)) AS [Average Sale Price]
	FROM [dbo].[REVENUE_ANALYSIS_VW]
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_revenue_analysis]
	@Year INT,
	@Month INT = 0,
	@Region varchar(20) = NULL
AS
BEGIN
	SET NOCOUNT ON
	IF @Month = 0 AND @Region IS NULL
		BEGIN
			SELECT [Product ID], [Year], [Month], [Region], [Total Amount Sold], [Total Quantity Sold], [Average Sale Price] FROM [dbo].[REVENUE_ANALYSIS_AVG_VW] WHERE [Year]=@Year
		END
	ELSE IF @Month = 0 AND @Region IS NOT NULL
		BEGIN
			SELECT [Product ID], [Year], [Month], [Region], [Total Amount Sold], [Total Quantity Sold], [Average Sale Price] FROM [dbo].[REVENUE_ANALYSIS_AVG_VW]WHERE [Year]=@Year AND [Region]=@Region
		END
	ELSE IF @Month > 0 AND @Region IS NULL
		BEGIN
			SELECT [Product ID], [Year], [Month], [Region], [Total Amount Sold], [Total Quantity Sold], [Average Sale Price] FROM [dbo].[REVENUE_ANALYSIS_AVG_VW] WHERE [Year]=@Year AND [Month]=@Month
		END
	ELSE
		BEGIN
			SELECT [Product ID], [Year], [Month], [Region], [Total Amount Sold], [Total Quantity Sold], [Average Sale Price] FROM [dbo].[REVENUE_ANALYSIS_AVG_VW] WHERE [Year]=@Year AND [Month]=@Month AND [Region]=@Region
		END
END
GO


/*
Business View 2 -List top 10 popular products
*/
CREATE OR ALTER VIEW [dbo].[PROPULAR_PRODUCTS_VW] WITH SCHEMABINDING AS
	SELECT TOP 10 s.PROD_ID, p.PROD_NAME, YEAR(s.SALE_DATE) AS SALES_YEAR,
		SUM(s.QUANTITY_SOLD) AS TOTAL_QUANTITY_SOLD,
		cc.COUNTRY_REGION AS REGION
		FROM dbo.SALES as s
			JOIN dbo.CUSTOMERS as cust
				ON cust.CUST_ID = s.CUST_ID
			JOIN dbo.CUSTOMERS_COUNTRY as cc
				ON cust.COUNTRY_ID = cc.COUNTRY_ID
			JOIN dbo.PRODUCTS as p
				ON s.PROD_ID = p.PROD_ID
	GROUP BY s.PROD_ID, p.PROD_NAME, YEAR(s.SALE_DATE), cc.COUNTRY_REGION
	ORDER BY TOTAL_QUANTITY_SOLD DESC
GO


/* 
Business View 3 - List maximum number of days to ship each product
*/
CREATE OR ALTER VIEW [dbo].[PRODUCTS_SHIPDAYS_VW] WITH SCHEMABINDING AS
	SELECT s.PROD_ID, p.PROD_NAME, 
		MAX(DATEDIFF(day,SALE_DATE,SHIPPING_DATE))  AS MAX_DAYS_TO_SHIP
	FROM dbo.SALES as s
		JOIN dbo.PRODUCTS AS p
			ON s.PROD_ID = p.PROD_ID
	GROUP BY s.PROD_ID , p.PROD_NAME
GO


/* 
Business View 4 - List promotions resulted in highest sale
*/
CREATE OR ALTER VIEW [dbo].[SALES_PROMOTIONS_VW] WITH SCHEMABINDING AS
	SELECT p.PROMO_NAME,YEAR(s.SALE_DATE) AS SALES_YEAR,
		SUM (s.QUANTITY_SOLD) AS TOTAL_QUANTITY_SOLD,
		cc.COUNTRY_REGION AS REGION
	FROM dbo.SALES as s
		JOIN dbo.CUSTOMERS as cust
			ON cust.CUST_ID = s.CUST_ID
		JOIN dbo.CUSTOMERS_COUNTRY as cc
			ON cust.COUNTRY_ID = cc.COUNTRY_ID
		JOIN dbo.PROMOTIONS as p
			ON s.PROMO_ID = p.PROMO_ID
	WHERE p.PROMO_NAME NOT IN ('NO PROMOTION #')
	GROUP BY p.PROMO_NAME,YEAR(s.SALE_DATE),cc.COUNTRY_REGION  
GO


/* 
Business View 5 - Analyze customer trend 
*/
CREATE OR ALTER VIEW [dbo].[CUSTOMER_TREND_VW] WITH SCHEMABINDING AS
	SELECT p.PROD_NAME AS [PRODUCT NAME], 
		SUM (s.QUANTITY_SOLD) AS [TOTAL QUANTITY SOLD],
		c.CUST_GENDER AS [GENDER], 
		c.CUST_MARITAL_STATUS AS [MARITAL STATUS],
		cc.COUNTRY_REGION AS REGION,
		COUNT_BIG(*) AS [COUNT]
	FROM dbo.CUSTOMERS as c
		JOIN dbo.SALES AS s
			ON c.CUST_ID = s.CUST_ID
		JOIN dbo.CUSTOMERS_COUNTRY as cc
			ON c.COUNTRY_ID = cc.COUNTRY_ID
		JOIN dbo.PRODUCTS as p
			ON p.PROD_ID = s.PROD_ID
	GROUP BY p.PROD_NAME , c.CUST_GENDER , c.CUST_MARITAL_STATUS, cc.COUNTRY_REGION
GO

CREATE UNIQUE CLUSTERED INDEX IDX_CUSTOMER_TREND ON [dbo].[CUSTOMER_TREND_VW] ([PRODUCT NAME], [GENDER], [MARITAL STATUS], [REGION])
GO

CREATE OR ALTER VIEW [dbo].[CUSTOMER_TREND_IN_VW] WITH SCHEMABINDING AS
	SELECT [PRODUCT NAME],
		[TOTAL QUANTITY SOLD],
		[GENDER],
		[MARITAL STATUS],
		[REGION]
	FROM [dbo].[CUSTOMER_TREND_VW]
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_customer_trends]
@Gender Char (1),
@MaritalStatus varchar(20),
@Region varchar(20)
AS
BEGIN
	SELECT [PRODUCT NAME],
		[TOTAL QUANTITY SOLD]
	FROM [dbo].[CUSTOMER_TREND_VW]
	WHERE [GENDER] = @Gender AND
		[MARITAL STATUS] = @MaritalStatus AND
		[REGION] = @Region
	ORDER BY [PRODUCT NAME]
END
GO

