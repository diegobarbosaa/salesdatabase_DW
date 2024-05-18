-- Colocar banco de dados em uso

USE SalesDatabase_DW

-- Criar dimensão dim.StateProvince

-- TRUNCATE TABLE dim.StateProvince

CREATE TABLE dim.StateProvince
(
	SK_StateProvinceID INT IDENTITY PRIMARY KEY,
	NK_StateProvinceID INT NOT NULL,
	SK_TerritoryID INT NOT NULL,
	StateProvinceCode CHAR(6) NOT NULL,
	CountryRegionCode VARCHAR(6) NOT NULL,
	IsOnlyStateProvinceFlag TINYINT NOT NULL,
	Name VARCHAR(100) NOT NULL
)

ALTER TABLE dim.StateProvince
ADD CONSTRAINT FK_StateProvince_SalesTerritory
FOREIGN KEY (SK_TerritoryID)
REFERENCES dim.SalesTerritory (SK_TerritoryID)

-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Person.StateProvince

INSERT INTO 
	dim.StateProvince
SELECT
	SP.StateProvinceID,
	ST.SK_TerritoryID,
	SP.StateProvinceCode,
	SP.CountryRegionCode,
	SP.IsOnlyStateProvinceFlag,
	SP.Name
FROM
	SalesDatabase.Person.StateProvince SP
LEFT JOIN
	dim.SalesTerritory ST ON ST.NK_TerritoryID = SP.TerritoryID

-- Consultar dados

SELECT * FROM dim.StateProvince

SELECT TOP 50
	SP.*,
	ST.SK_TerritoryID
FROM
	SalesDatabase.Person.StateProvince SP
LEFT JOIN
	dim.SalesTerritory ST ON ST.SK_TerritoryID = SP.TerritoryID

SELECT TOP 50
	SP.*
FROM
	dim.StateProvince SP
LEFT JOIN
	dim.SalesTerritory ST ON ST.SK_TerritoryID = SP.SK_StateProvinceID

-- // --

-- Criar dimensão dim.Address

-- TRUNCATE TABLE dim.Address

CREATE TABLE dim.Address
(
	SK_AddressID INT IDENTITY PRIMARY KEY,
	NK_AddressID INT NOT NULL,
	SK_StateProvinceID INT NOT NULL,
	AddressLine1 VARCHAR(120) NOT NULL,
	AddressLine2 VARCHAR(120),
	City VARCHAR(60) NOT NULL,
	PostalCode VARCHAR(30) NOT NULL,
	SpatialLocation GEOGRAPHY
)

ALTER TABLE dim.Address
ADD CONSTRAINT FK_Address_StateProvince
FOREIGN KEY (SK_StateProvinceID)
REFERENCES dim.StateProvince (SK_StateProvinceID)


-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Person.Address

INSERT INTO 
	dim.Address
SELECT
	A.AddressID,
	ST.SK_StateProvinceID,
	A.AddressLine1,
	A.AddressLine2,
	A.City,
	A.PostalCode,
	A.SpatialLocation
FROM
	SalesDatabase.Person.Address A
LEFT JOIN
	dim.StateProvince ST ON ST.NK_StateProvinceID = A.StateProvinceID

-- Consultar dados

SELECT * FROM dim.Address

SELECT TOP 50
	ST.SK_StateProvinceID,
	A.StateProvinceID,
	ST.NK_StateProvinceID,
	A.*
FROM
	SalesDatabase.Person.Address A
LEFT JOIN
	dim.StateProvince ST ON ST.NK_StateProvinceID = A.StateProvinceID

SELECT
	ST.SK_StateProvinceID,
	ST.NK_StateProvinceID,
	A.SK_StateProvinceID,
	A.NK_AddressID,
	A.*
FROM
	dim.Address A
LEFT JOIN
	dim.StateProvince ST ON ST.SK_StateProvinceID = A.SK_StateProvinceID

-- // --

-- Criar dimensão dim.ProductSubcategory

-- TRUNCATE TABLE dim.ProductSubcategory

CREATE TABLE dim.ProductSubcategory
(
	SK_ProductSubcategoryID INT IDENTITY PRIMARY KEY,
	NK_ProductSubcategoryID INT NOT NULL,
	SK_ProductCategoryID INT NOT NULL,
	Name VARCHAR(100) NOT NULL
)

ALTER TABLE dim.ProductSubcategory
ADD CONSTRAINT FK_ProductSubcategory_ProductCategory
FOREIGN KEY (SK_ProductCategoryID)
REFERENCES dim.ProductCategory (SK_ProductCategoryID)


-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Production.ProductSubcategory

INSERT INTO 
	dim.ProductSubcategory
SELECT
	PSC.ProductSubcategoryID,
	PC.SK_ProductCategoryID,
	PSC.Name
FROM
	SalesDatabase.Production.ProductSubcategory PSC
LEFT JOIN
	dim.ProductCategory PC ON PC.NK_ProductCategoryID = PSC.ProductCategoryID

-- Consultar dados

SELECT * FROM dim.ProductSubcategory

SELECT TOP 50
	PSC.*,
	PC.SK_ProductCategoryID
FROM
	SalesDatabase.Production.ProductSubcategory PSC
LEFT JOIN
	dim.ProductCategory PC ON PC.SK_ProductCategoryID = PSC.ProductCategoryID

SELECT TOP 50
	PSC.*,
	PC.*
FROM
	dim.ProductSubcategory PSC
LEFT JOIN
	dim.ProductCategory PC ON PC.SK_ProductCategoryID = PSC.SK_ProductCategoryID

-- // --

-- Criar dimensão dim.Product

-- TRUNCATE TABLE dim.Product

CREATE TABLE dim.Product
(
	SK_ProductID INT IDENTITY PRIMARY KEY,
	NK_ProductID INT NOT NULL,
	SK_ProductModelID INT,
	SK_ProductSubcategoryID INT,
	SK_Color INT,
	Name VARCHAR(100) NOT NULL,
	ProductNumber VARCHAR(50) NOT NULL,
	MakeFlag TINYINT NOT NULL,
	FinishedGoodsFlag TINYINT NOT NULL,
	Color VARCHAR(100),
	SafetyStockLevel SMALLINT NOT NULL,
	ReorderPoint SMALLINT NOT NULL,
	StandardCost MONEY NOT NULL,
	ListPrice MONEY NOT NULL,
	Size VARCHAR(10),
	SizeUnitMeasureCode CHAR(6),
	WeightUnitMeasureCode CHAR(6),
	Weight DECIMAL,
	DaysToManufacture INT NOT NULL,
	ProductLine CHAR(4),
	Class CHAR(4),
	Style CHAR(4),
	SellStartDate DATETIME NOT NULL,
	SellEndDate DATETIME,
	DiscontinuedDate DATETIME
)

ALTER TABLE dim.Product
ADD CONSTRAINT FK_Product_ProductModel
FOREIGN KEY (SK_ProductModelID)
REFERENCES dim.ProductModel (SK_ProductModelID)

ALTER TABLE dim.Product
ADD CONSTRAINT FK_Product_ProductSubcategory
FOREIGN KEY (SK_ProductSubcategoryID)
REFERENCES dim.ProductSubcategory (SK_ProductSubcategoryID)

ALTER TABLE dim.Product
ADD CONSTRAINT FK_Product_Color
FOREIGN KEY (SK_Color)
REFERENCES dim.Color (SK_ColorID)


-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Production.Product

INSERT INTO 
	dim.Product
SELECT
	P.ProductID,
	PM.SK_ProductModelID,
	PSC.SK_ProductSubcategoryID,
	C.SK_ColorID,
	P.Name,
	P.ProductNumber,
	P.MakeFlag,
	P.FinishedGoodsFlag,
	C.Color,
	P.SafetyStockLevel,
	P.ReorderPoint,
	P.StandardCost,
	P.ListPrice,
	P.Size,
	P.SizeUnitMeasureCode,
	P.WeightUnitMeasureCode,
	P.Weight,
	P.DaysToManufacture,
	P.ProductLine,
	P.Class,
	P.Style,
	P.SellStartDate,
	P.SellEndDate,
	P.DiscontinuedDate
FROM
	SalesDatabase.Production.Product P
LEFT JOIN
	dim.ProductModel PM ON PM.NK_ProductModelID = P.ProductModelID
LEFT JOIN
	dim.ProductSubcategory PSC ON PSC.NK_ProductSubcategoryID = P.ProductSubcategoryID
LEFT JOIN
	dim.Color C ON C.NK_Color = P.Color COLLATE SQL_Latin1_General_CP1_CI_AS

-- Consultar dados

SELECT * FROM dim.Product

SELECT TOP 50
	P.*,
	PSC.SK_ProductSubcategoryID,
	PM.SK_ProductModelID,
	C.SK_ColorID,
	C.Color
FROM
	SalesDatabase.Production.Product P
LEFT JOIN
	dim.ProductModel PM ON PM.SK_ProductModelID = P.ProductModelID
LEFT JOIN
	dim.ProductSubcategory PSC ON PSC.SK_ProductSubcategoryID = P.ProductSubcategoryID
LEFT JOIN
	dim.Color C ON C.NK_Color = P.Color COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE
	P.ProductModelID IS NOT NULL

SELECT
	P.*
FROM
	dim.Product P
LEFT JOIN
	dim.ProductModel PM ON PM.SK_ProductModelID = P.SK_ProductID
LEFT JOIN
	dim.ProductSubcategory PSC ON PSC.SK_ProductSubcategoryID = P.SK_ProductModelID
LEFT JOIN
	dim.Color C ON C.SK_ColorID = P.SK_Color
WHERE
	P.SK_ProductModelID IS NOT NULL

-- // --

-- Criar dimensão dim.Customer

CREATE TABLE dim.Customer
(
	SK_SalesOrderDetailID INT IDENTITY PRIMARY KEY,
	NK_SalesOrderDetailID INT NOT NULL,
	SK_CustomerID INT NOT NULL,
	SK_ProductID INT NOT NULL,
	SK_CreditCardID INT,
	SK_TerritoryID INT NOT NULL,
	SK_BusinessEntityID INT,
	SK_AddressID_BILL INT NOT NULL,
	SK_AddressID_SHIP INT NOT NULL,
	OrderQty SMALLINT,
	LineTotal NUMERIC,
	OrderDate DATETIME
)

ALTER TABLE dim.Customer
ADD CONSTRAINT FK_Customer_Product
FOREIGN KEY (SK_ProductID)
REFERENCES dim.Product (SK_ProductID)

ALTER TABLE dim.Customer
ADD CONSTRAINT FK_Customer_CreditCard
FOREIGN KEY (SK_CreditCardID)
REFERENCES dim.CreditCard (SK_CreditCardID)

ALTER TABLE dim.Customer
ADD CONSTRAINT FK_Customer_Store
FOREIGN KEY (SK_BusinessEntityID)
REFERENCES dim.Store (SK_BusinessEntityID)

ALTER TABLE dim.Customer
ADD CONSTRAINT FK_Customer_Address_Bill
FOREIGN KEY (SK_AddressID_BILL)
REFERENCES dim.Address (SK_AddressID)

ALTER TABLE dim.Customer
ADD CONSTRAINT FK_Customer_Address_Ship
FOREIGN KEY (SK_AddressID_SHIP)
REFERENCES dim.Address (SK_AddressID)


-- Gravar os dados na dimensão criada baseado na tabela SalesDatabase.Sales.SalesOrderDetail / SalesOrderHeader / Customer

INSERT INTO 
	dim.Customer
SELECT
	SOD.SalesOrderDetailID,
	C.CustomerID,
	P.SK_ProductID,
	CC.SK_CreditCardID,
	ST.SK_TerritoryID,
	S.SK_BusinessEntityID,
	A_bill.SK_AddressID,
	A_ship.SK_AddressID,
	SOD.OrderQty,
	SOD.LineTotal,
	SOH.OrderDate
FROM
	SalesDatabase.Sales.SalesOrderDetail SOD
LEFT JOIN
	dim.Product P ON P.NK_ProductID = SOD.ProductID
LEFT JOIN
	SalesDatabase.Sales.SalesOrderHeader SOH ON SOH.SalesOrderID = SOD.SalesOrderID
	LEFT JOIN
		SalesDatabase.Sales.Customer C ON C.CustomerID = SOH.CustomerID
		LEFT JOIN
			dim.Store S ON S.NK_BusinessEntityID = C.StoreID
	LEFT JOIN
		dim.Address A_bill ON A_bill.NK_AddressID = SOH.BillToAddressID
	LEFT JOIN
		dim.Address A_ship ON A_ship.NK_AddressID = SOH.ShipToAddressID
	LEFT JOIN
		dim.CreditCard CC ON CC.NK_CreditCardID = SOH.CreditCardID
	LEFT JOIN
		dim.SalesTerritory ST ON ST.NK_TerritoryID = SOH.TerritoryID

-- Consultar dados

SELECT * FROM dim.Customer

SELECT	
	SOD.*
FROM
	SalesDatabase.Sales.SalesOrderDetail SOD
LEFT JOIN
	dim.Product P ON P.NK_ProductID = SOD.ProductID
LEFT JOIN
	SalesDatabase.Sales.SalesOrderHeader SOH ON SOH.SalesOrderID = SOD.SalesOrderID
	LEFT JOIN
		SalesDatabase.Sales.Customer C ON C.CustomerID = SOH.CustomerID
		LEFT JOIN
			dim.Store S ON S.NK_BusinessEntityID = C.StoreID
	LEFT JOIN
		dim.Address A_bill ON A_bill.NK_AddressID = SOH.BillToAddressID
	LEFT JOIN
		dim.Address A_ship ON A_ship.NK_AddressID = SOH.ShipToAddressID
	LEFT JOIN
		dim.CreditCard CC ON CC.NK_CreditCardID = SOH.CreditCardID
	LEFT JOIN
		dim.SalesTerritory ST ON ST.NK_TerritoryID = SOH.TerritoryID
WHERE
	 A_bill.NK_AddressID = 25446

-- // --