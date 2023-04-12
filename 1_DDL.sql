USE [2022DBFall_Group_1_DB]
GO

/*
CREATE TABLE CHANNELS and add constraint
*/
CREATE TABLE dbo.CHANNELS (
	CHANNEL_ID INT NOT NULL,
	CHANNEL_DESC VARCHAR (20) NOT NULL,
	CHANNEL_CLASS VARCHAR (20) NOT NULL
)
GO

ALTER TABLE CHANNELS Add CONSTRAINT PK_CHANNEL_ID PRIMARY KEY (CHANNEL_ID)
GO

/*
CREATE TABLE CUSTOMERS and add constraint
*/
CREATE TABLE dbo.CUSTOMERS (
	CUST_ID INT NOT NULL,
	CUST_FIRST_NAME Varchar(20) NOT NULL,
	CUST_LAST_NAME Varchar(20) NOT NULL,
	CUST_GENDER 	Char(1) NOT NULL,
	CUST_YEAR_OF_BIRTH 	INT NULL,
	CUST_MARITAL_STATUS 	Varchar(20)	NOT NULL,
	CUST_MAIN_PHONE_NUMBER	Varchar(20)	NULL,
	CUST_EMAIL	Varchar(30)	NULL,
	CUST_STREET_ADDRESS	Varchar(40)	NOT NULL,
	CUST_POSTAL_CODE	Varchar(10)	NOT NULL,
	CUST_CITY	Varchar(30)	NOT NULL,
	CUST_STATE_PROVINCE	Varchar(40)	NULL,
	CUST_INCOME_CATEGORY	Char	NOT NULL,
	CUST_CREDIT_LIMIT 	INT	NOT NULL,
	COUNTRY_ID	INT	NOT NULL,
)
GO

/*
CREATE TABLE CUSTOMERS_COUNTRY
*/
CREATE TABLE dbo.CUSTOMERS_COUNTRY (
	COUNTRY_ID	INT	NOT NULL,
	COUNTRY_NAME	Varchar(50)	NOT NULL,
	COUNTRY_REGION	Varchar(20)	NOT NULL,
	COUNTRY_SUBREGION	Varchar(30)	NOT NULL,
)
GO

/*
CREATE TABLE CUSTOMERS_INCOME_LEVEL
*/
CREATE TABLE dbo.CUSTOMERS_INCOME_LEVEL(
	CUST_INCOME_CATEGORY	Char	NOT NULL,
	CUST_INCOME_LOWER_LIMIT	Decimal(22,0)	NOT NULL,
	CUST_INCOME_UPPER_LIMIT	Decimal(22,0)	NULL
)
GO

/*
Add additional constraints on CUSTOMERS_COUNTRY, CUSTOMERS_INCOME_LEVEL and CUSTOMERS table
*/
ALTER TABLE dbo.CUSTOMERS_COUNTRY ADD CONSTRAINT PK_COUNTRY_ID PRIMARY KEY (COUNTRY_ID) 
GO

ALTER TABLE dbo.CUSTOMERS_COUNTRY ADD CONSTRAINT CK_COUNTRY_REGION CHECK (COUNTRY_REGION IN ('Oceania', 'Europe', 'Americas', 'Africa', 'Asia')) 
GO

ALTER TABLE CUSTOMERS_COUNTRY ADD CONSTRAINT CK_COUNTRY_SUBREGION CHECK (COUNTRY_SUBREGION IN ('East Asia', 'West Africa', 'North Asia', 'Southern America', 'SouthWestern Europe', 'NorthWestern Europe', 'South Asia', 'Southern Africa', 'Northern America', 'Australia')) 
GO

ALTER TABLE dbo.CUSTOMERS_INCOME_LEVEL ADD CONSTRAINT PK_CUST_INCOME_CATEGORY PRIMARY KEY (CUST_INCOME_CATEGORY)
GO

ALTER TABLE dbo.CUSTOMERS ADD CONSTRAINT PK_CUST_ID PRIMARY KEY (CUST_ID) 
GO

ALTER TABLE dbo.CUSTOMERS ADD CONSTRAINT FK_COUNTRY_ID FOREIGN KEY (COUNTRY_ID) REFERENCES CUSTOMERS_COUNTRY (COUNTRY_ID) 
GO

ALTER TABLE dbo.CUSTOMERS ADD CONSTRAINT FK_CUST_INCOME_CATEGORY FOREIGN KEY (CUST_INCOME_CATEGORY) REFERENCES CUSTOMERS_INCOME_LEVEL (CUST_INCOME_CATEGORY) 
GO

ALTER TABLE dbo.CUSTOMERS ADD CONSTRAINT CK_CUST_GENDER CHECK (CUST_GENDER IN ('F','M') OR CUST_GENDER IS NULL) 
GO

ALTER TABLE dbo.CUSTOMERS ADD CONSTRAINT CK_CUST_MARITAL_STATUS CHECK (CUST_MARITAL_STATUS IN ('Single' , 'Married' , 'Divorced', 'Widowed','Never married' ,'Prefer not to say'))
GO

/*
CREATE TABLE PRODUCTS
*/
CREATE TABLE dbo.PRODUCTS (
	PROD_ID INT	NOT NULL,
	PROD_NAME	Varchar(50) NOT NULL,
	PROD_DESC	Varchar(1000) NOT NULL,
	PROD_LIST_PRICE	Decimal(22, 0)	NOT NULL,
	PROD_MIN_PRICE	Decimal(22, 0)	NOT NULL,
	PROD_SUBCATEGORY	Varchar(50)	NOT NULL 
)
GO

/*
CREATE TABLE PRODUCTS_CATEGORIES
*/
CREATE TABLE dbo.PRODUCTS_CATEGORIES (
	PROD_SUBCATEGORY	Varchar(50)	NOT NULL,
	PROD_CATEGORY	Varchar(50)	NOT NULL
)
GO

/*
Add constraints on PRODUCTS and PRODUCTS_CATEGORIES table
*/

ALTER TABLE dbo.PRODUCTS ADD CONSTRAINT PK_PROD_ID PRIMARY KEY (PROD_ID) 
GO

ALTER TABLE dbo.PRODUCTS ADD CONSTRAINT UQ_PROD_NAME UNIQUE (PROD_NAME) 
GO

ALTER TABLE dbo.PRODUCTS_CATEGORIES ADD CONSTRAINT PK_PROD_SUBCATEGORY PRIMARY KEY (PROD_SUBCATEGORY)
GO

ALTER TABLE dbo.PRODUCTS ADD CONSTRAINT FK_PROD_SUBCATEGORY FOREIGN KEY (PROD_SUBCATEGORY) REFERENCES PRODUCTS_CATEGORIES (PROD_SUBCATEGORY) 
GO

ALTER TABLE dbo.PRODUCTS ADD CONSTRAINT CK_MIN_PRICE CHECK (PROD_MIN_PRICE IS NULL OR PROD_MIN_PRICE <= PROD_LIST_PRICE)
GO

/*
CREATE TABLE PROMOTIONS
*/
CREATE TABLE dbo.PROMOTIONS (
	PROMO_ID	INT	NOT NULL,
	PROMO_NAME 	Varchar(30) 	NOT NULL,
	PROMO_SUBCATEGORY 	Varchar(30) 	NOT NULL,
	PROMO_COST 	Decimal(22, 0) 	NOT NULL,
	PROMO_BEGIN_DATE 	Date 	NOT NULL,
	PROMO_END_DATE 	Date 	NOT NULL
)
GO

/*
CREATE TABLE PROMOTIONS_CATEGORIES
*/
CREATE TABLE dbo.PROMOTIONS_CATEGORIES (
	PROMO_SUBCATEGORY	 Varchar(30)	NOT NULL,
	PROMO_CATEGORY	Varchar(30)	NOT NULL
)
GO

/*
Add constraints on PROMOTIONS and PROMOTIONS_CATEGORIES tables
*/
ALTER TABLE dbo.PROMOTIONS ADD CONSTRAINT PK_PROMO_ID PRIMARY KEY (PROMO_ID) 
GO

ALTER TABLE dbo.PROMOTIONS_CATEGORIES ADD CONSTRAINT PK_PROMO_SUBCATEGORY PRIMARY KEY (PROMO_SUBCATEGORY) 
GO

ALTER TABLE dbo.PROMOTIONS ADD CONSTRAINT FK_PROMO_SUBCATEGORY_ID FOREIGN KEY (PROMO_SUBCATEGORY) REFERENCES PROMOTIONS_CATEGORIES (PROMO_SUBCATEGORY) 
GO

ALTER TABLE dbo.PROMOTIONS ADD CONSTRAINT CK_PROMO_END_DATE CHECK (PROMO_END_DATE IS NOT NULL OR PROMO_END_DATE>=PROMO_BEGIN_DATE)
GO

/*
CREATE TABLE SALES
*/
CREATE TABLE dbo.SALES (
	SALESTRANS_ID	 INT	NOT NULL,
	PROD_ID 	INT	NOT NULL,
	PROMO_ID 	INT	NOT NULL,
	CUST_ID 	INT	NOT NULL,
	CHANNEL_ID 	INT	NOT NULL,
	SALE_DATE Date	NOT NULL,
	SHIPPING_DATE Date	NOT NULL,
	PAYMENT_DATE Date	NOT NULL,
	QUANTITY_SOLD INT NOT NULL,
	AMOUNT_SOLD Decimal(22, 2)	NOT NULL,
	UNIT_PRICE 	Decimal(22, 2)	NOT NULL
)
GO

/*
Add constraints on SALES tables
*/
ALTER TABLE dbo.SALES ADD CONSTRAINT PK_SALESTRANS_ID PRIMARY KEY (SALESTRANS_ID) 
GO

ALTER TABLE dbo.SALES ADD CONSTRAINT FK_PROD_ID FOREIGN KEY (PROD_ID) REFERENCES PRODUCTS (PROD_ID) 
GO

ALTER TABLE dbo.SALES ADD CONSTRAINT FK_CUST_ID FOREIGN KEY (CUST_ID) REFERENCES CUSTOMERS (CUST_ID) 
GO

ALTER TABLE dbo.SALES ADD CONSTRAINT FK_CHANNEL_ID FOREIGN KEY (CHANNEL_ID) REFERENCES CHANNELS (CHANNEL_ID) 
GO

ALTER TABLE dbo.SALES ADD CONSTRAINT FK_PROMO_ID FOREIGN KEY (PROMO_ID) REFERENCES PROMOTIONS (PROMO_ID) 
GO

ALTER TABLE dbo.SALES ADD CONSTRAINT CK_SHIPPING_DATE CHECK (SHIPPING_DATE >= SALE_DATE OR SHIPPING_DATE IS NULL) 
GO

ALTER TABLE dbo.SALES ADD CONSTRAINT CK_PAYMENT_DATE CHECK (PAYMENT_DATE >= SALE_DATE OR PAYMENT_DATE IS NULL) 
GO

ALTER TABLE dbo.SALES ADD CONSTRAINT CK_QUANTITY_SOLD CHECK (QUANTITY_SOLD > 0) 
GO

ALTER TABLE dbo.SALES ADD CONSTRAINT CK_UNIT_PRICE CHECK (UNIT_PRICE > 0)
GO