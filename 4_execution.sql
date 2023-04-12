USE [2022DBFall_Group_1_DB]
GO


/*
Business View 1
*/
EXEC [dbo].[usp_revenue_analysis] 2015,2,'Europe'

EXEC [dbo].[usp_revenue_analysis] @Year=2012,@Region='Asia'

EXEC [dbo].[usp_revenue_analysis] 2013,6

EXEC [dbo].[usp_revenue_analysis] 2014


/*
Business View 2
*/
SELECT * FROM [dbo].[PROPULAR_PRODUCTS_VW]


/*
Business View 3
*/
SELECT * FROM [dbo].[SALES_PROMOTIONS_VW]


/*
Business View 4
*/
SELECT * FROM [dbo].[PRODUCTS_SHIPDAYS_VW] ORDER BY PROD_ID


/*
Business View 5
*/
EXEC [dbo].[usp_customer_trends] 'F','Divorced', 'Americas'

EXEC [dbo].[usp_customer_trends] 'M','Widowed', 'Oceania'

EXEC [dbo].[usp_customer_trends] 'F','Married', 'Asia'