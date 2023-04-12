USE [2022DBFall_Group_1_DB]
GO

/* 
Business View 1 - Revenue Analysis
*/
GRANT SELECT ON [dbo].[REVENUE_ANALYSIS_VW] TO MANAGER
GRANT SELECT ON [dbo].[REVENUE_ANALYSIS_AVG_VW] TO MANAGER

CREATE OR ALTER VIEW [dbo].[REVENUE_ANALYSIS_AVG_SALES_VW] WITH SCHEMABINDING 
AS
	SELECT *
	FROM [dbo].[REVENUE_ANALYSIS_AVG_VW]
	WHERE [REGION] IN ('Americas')
GO

GRANT EXECUTE ON OBJECT::dbo.usp_revenue_analysis
    TO [DEPARTMENT];  
GO

GRANT SELECT ON [dbo].[REVENUE_ANALYSIS_AVG_SALES_VW] TO SALES


/*
Business View 2 -List top 10 popular products
*/
GRANT SELECT ON [dbo].[PROPULAR_PRODUCTS_VW] TO MANAGER, SALES


/* 
Business View 3 - List maximum number of days to ship each product
*/
GRANT SELECT ON [dbo].[PRODUCTS_SHIPDAYS_VW] TO MANAGER, SALES, MARKETTING


/* 
Business View 4 - List promotions resulted in highest sale
*/
GRANT SELECT ON [dbo].[SALES_PROMOTIONS_VW] TO MANAGER, MARKETTING

/* 
Business View 5 - Analyze customer trend 
*/
GRANT SELECT ON [dbo].[CUSTOMER_TREND_VW] TO MANAGER, SALES, MARKETTING
GRANT SELECT ON [dbo].[CUSTOMER_TREND_IN_VW] TO MANAGER, SALES, MARKETTING
GRANT EXECUTE ON OBJECT::dbo.usp_customer_trends
    TO [DEPARTMENT];  
GO