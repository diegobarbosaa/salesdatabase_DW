-- Colocar banco de dados em uso

USE SalesDatabase_DW

-- Criando a tabela FATO Pedidos

-- DROP TABLE fato.OrderCustomers

CREATE TABLE fato.OrderCustomers
(
	SK_Customer INT,
	SK_Product INT,
	SK_CreditCard INT,
	SK_Territory INT,
	OrderQty INT,
	Amount_Total DECIMAL(38,6),
	Order_Year INT,
	Order_Month INT
)

-- Gravando dados na tabela Fato

INSERT INTO fato.OrderCustomers
SELECT
	C.SK_CustomerID,
	C.SK_ProductID,
	C.SK_CreditCardID,
	C.SK_TerritoryID,
	SUM(C.OrderQty) AS OrderQty,
	SUM(C.LineTotal) AS Amount_total,
	YEAR(C.OrderDate) AS Order_Year,
	MONTH(C.OrderDate) AS Order_Mounth
FROM
	dim.Customer C
GROUP BY
	C.SK_CustomerID,
	C.SK_ProductID,
	C.SK_CreditCardID,
	C.SK_TerritoryID,
	C.OrderDate
	
-- Consultando dados da tabela Fato

SELECT
	OC.*
FROM
	fato.OrderCustomers OC

/*
Relatório 1: 

Gere um relatório que retorne todas as vendas agrupado pela Categoria dos produtos e ano. Esse
relatório precisa retornar informações desconsiderando as cores de produtos Black, Blue e Silver.
*/

SELECT
	PC.Name AS CategoryName,
	OC.Order_Year,
	SUM(OC.Amount_Total) AS Amount_Total, 
	SUM(OC.OrderQty) AS OrderQty
FROM
	fato.OrderCustomers OC
LEFT JOIN 
	dim.Product P ON P.SK_ProductID = OC.SK_Product
	LEFT JOIN 
		dim.ProductSubcategory PSC ON PSC.SK_ProductCategoryID = P.SK_ProductSubcategoryID
		LEFT JOIN 
			dim.ProductCategory PC ON PC.SK_ProductCategoryID = PSC.SK_ProductCategoryID
WHERE
	P.Color NOT IN ('Black','Blue','Silver')
GROUP BY
	PC.Name,
	OC.Order_Year
ORDER BY
	PC.Name, OC.Order_Year

/*
Relatório 2: 

Gere um relatório que retorne todas as vendas agrupado por países e ano.
*/

SELECT
	ST.Name,
	OC.Order_Year,
	SUM(OC.Amount_Total) AS Amount_Total, 
	SUM(OC.OrderQty) AS OrderQty
FROM
	fato.OrderCustomers OC
LEFT JOIN 
	dim.SalesTerritory ST ON ST.SK_TerritoryID = OC.SK_Territory
GROUP BY
	ST.Name,
	OC.Order_Year
ORDER BY
	ST.Name, OC.Order_Year

/*
Relatório 3: 

Gere um relatório que retorne todas as vendas agrupado por cidades e ano. Esse relatório precisa
retornar informações apenas dos meses de janeiro, abril, maio e setembro.
*/

SELECT
	SP.Name,
	OC.Order_Year,
	SUM(OC.Amount_Total) AS Amount_Total, 
	SUM(OC.OrderQty) AS OrderQty
FROM
	fato.OrderCustomers OC
LEFT JOIN 
	dim.SalesTerritory ST ON ST.SK_TerritoryID = OC.SK_Territory
	LEFT JOIN 
		dim.StateProvince SP ON SP.SK_TerritoryID = ST.SK_TerritoryID
WHERE
	OC.Order_Month IN (1,4,9)
GROUP BY
	SP.Name,
	OC.Order_Year
ORDER BY
	SP.Name, OC.Order_Year