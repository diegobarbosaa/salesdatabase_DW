--CREATE DATABASE SalesDatabase_DW

--USE SalesDatabase_DW

--CREATE SCHEMA dim

--CREATE SCHEMA fato

-- Criar dimensão dim.CreditCard

CREATE TABLE dim.CreditCard
(
	SK_CreditCardID INT IDENTITY PRIMARY KEY,
	NK_CreditCardID INT NOT NULL,
	CardType VARCHAR(100) NOT NULL,
	CardNumber VARCHAR(50) NOT NULL,
	ExpMonth tinyint NOT NULL,
	ExpYear smallint NOT NULL
)

-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Sales.CreditCard

INSERT INTO 
	dim.CreditCard
SELECT
	CC.CreditCardID,
	CC.CardType,
	CC.CardNumber,
	CC.ExpMonth,
	CC.ExpYear
FROM 
	SalesDatabase.Sales.CreditCard CC
ORDER BY
	CC.CreditCardID

-- Consultar dados

SELECT * FROM dim.CreditCard

SELECT DISTINCT
	CC.*
FROM
	SalesDatabase.Sales.CreditCard AS CC

-- // --

-- Criar dimensão dim.Store

CREATE TABLE dim.Store
(
	SK_BusinessEntityID INT IDENTITY PRIMARY KEY,
	NK_BusinessEntityID INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	NK_SalesPersonID INT NOT NULL,
	Demographics XML NOT NULL
)

-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Sales.Store

INSERT INTO 
	dim.Store
SELECT
	S.BusinessEntityID,
	S.Name,
	S.SalesPersonID,
	S.Demographics
FROM 
	SalesDatabase.Sales.Store S
ORDER BY
	S.BusinessEntityID

-- Consultar dados

SELECT * FROM dim.Store

SELECT
	S.*
FROM
	SalesDatabase.Sales.Store S

-- // --

-- Criar dimensão dim.ProductCategory

CREATE TABLE dim.ProductCategory
(
	SK_ProductCategoryID INT IDENTITY PRIMARY KEY,
	NK_ProductCategoryID INT NOT NULL,
	Name VARCHAR(100) NOT NULL
)

-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Production.ProductCategory

INSERT INTO 
	dim.ProductCategory
SELECT
	PC.ProductCategoryID,
	PC.Name
FROM 
	SalesDatabase.Production.ProductCategory PC
ORDER BY
	PC.ProductCategoryID

-- Consultar dados

SELECT * FROM dim.ProductCategory

SELECT
	PC.*
FROM
	SalesDatabase.Production.ProductCategory PC

-- // --

-- Criar dimensão dim.Color

CREATE TABLE dim.Color
(
	SK_ColorID INT IDENTITY PRIMARY KEY,
	NK_Color VARCHAR(30),
	Color VARCHAR(30)
)

-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Production.Product P

INSERT INTO 
	dim.Color
SELECT DISTINCT
	P.Color,
	P.Color
FROM 
	SalesDatabase.Production.Product P
ORDER BY
	P.Color

-- Consultar dados

SELECT * FROM dim.Color

SELECT DISTINCT
	P.Color,
	P.Color
FROM
	SalesDatabase.Production.Product P

-- // --

-- Criar dimensão dim.ProductModel

CREATE TABLE dim.ProductModel
(
	SK_ProductModelID INT IDENTITY PRIMARY KEY,
	NK_ProductModelID INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	CatalogDescription XML,
	Instructions XML
)

-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Production.ProductModel

INSERT INTO 
	dim.ProductModel
SELECT
	PM.ProductModelID,
	PM.Name,
	PM.CatalogDescription,
	PM.Instructions
FROM 
	SalesDatabase.Production.ProductModel PM
ORDER BY
	PM.ProductModelID

-- Consultar dados

SELECT * FROM dim.ProductModel

SELECT
	PM.*
FROM
	SalesDatabase.Production.ProductModel PM

-- // --

-- Criar dimensão dim.SalesTerritory

CREATE TABLE dim.SalesTerritory
(
	SK_TerritoryID INT IDENTITY PRIMARY KEY,
	NK_TerritoryID INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	CountryRegionCode VARCHAR(6) NOT NULL,
	[Group] VARCHAR(100) NOT NULL,
	SalesYTD MONEY NOT NULL,
	SalesLastYear MONEY NOT NULL,
	CostYTD MONEY NOT NULL,
	CostLastYear MONEY NOT NULL
)

-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Sales.SalesTerritory

INSERT INTO 
	dim.SalesTerritory
SELECT
	ST.TerritoryID,
	ST.Name,
	ST.CountryRegionCode,
	ST.[Group],
	ST.SalesYTD,
	ST.SalesLastYear,
	ST.CostYTD,
	ST.CostLastYear
FROM 
	SalesDatabase.Sales.SalesTerritory ST
ORDER BY
	ST.TerritoryID

-- Consultar dados

SELECT * FROM dim.SalesTerritory

SELECT
	ST.*
FROM
	SalesDatabase.Sales.SalesTerritory ST