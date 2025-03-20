PRINT N'Creating schemas';
GO
CREATE SCHEMA [Customers] AUTHORIZATION [dbo];
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
CREATE SCHEMA [Logistics] AUTHORIZATION [dbo];
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
CREATE SCHEMA [Operation] AUTHORIZATION [dbo];
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
CREATE SCHEMA [Sales] AUTHORIZATION [dbo];
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Customers]';
GO
CREATE TABLE [Sales].[Customers] ([CustomerID] [NCHAR](5) COLLATE Latin1_General_CI_AS NOT NULL,
[CompanyName] [NVARCHAR](40) COLLATE Latin1_General_CI_AS NOT NULL,
[ContactName] [NVARCHAR](30) COLLATE Latin1_General_CI_AS NULL,
[ContactTitle] [NVARCHAR](30) COLLATE Latin1_General_CI_AS NULL,
[Address] [NVARCHAR](60) COLLATE Latin1_General_CI_AS NULL,
[City] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[Region] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[PostalCode] [NVARCHAR](10) COLLATE Latin1_General_CI_AS NULL,
[Country] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[Phone] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
[Fax] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
[LinkedIn] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NULL,
[RegionCode] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NULL,
[CityCode] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Customers] on [Sales].[Customers]';
GO
ALTER TABLE [Sales].[Customers]
ADD CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED([CustomerID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [City] on [Sales].[Customers]';
GO
CREATE NONCLUSTERED INDEX [City] ON [Sales].[Customers]([City]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [CompanyName] on [Sales].[Customers]';
GO
CREATE NONCLUSTERED INDEX [CompanyName]
ON [Sales].[Customers]([CompanyName]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [PostalCode] on [Sales].[Customers]';
GO
CREATE NONCLUSTERED INDEX [PostalCode]
ON [Sales].[Customers]([PostalCode]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [Region] on [Sales].[Customers]';
GO
CREATE NONCLUSTERED INDEX [Region] ON [Sales].[Customers]([Region]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[CustomersFeedback]';
GO
CREATE TABLE [Sales].[CustomersFeedback] ([FeedbackID] [INT] NOT NULL IDENTITY(1, 1),
[CustomerID] [NCHAR](5) COLLATE Latin1_General_CI_AS NULL,
[FeedbackDate] [DATETIME] NULL CONSTRAINT [DF__Customers__Feedb__29572725] DEFAULT(GETDATE()),
[Rating] [INT] NULL,
[Comments] [NVARCHAR](500) COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK__Customer__6A4BEDF61A949274] on [Sales].[CustomersFeedback]';
GO
ALTER TABLE [Sales].[CustomersFeedback]
ADD CONSTRAINT [PK__Customer__6A4BEDF61A949274] PRIMARY KEY CLUSTERED([FeedbackID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[Flight]';
GO
CREATE TABLE [Logistics].[Flight] ([FlightID] [INT] NOT NULL IDENTITY(1, 1),
[Airline] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NOT NULL,
[DepartureCity] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArrivalCity] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NOT NULL,
[DepartureTime] [DATETIME] NOT NULL,
[ArrivalTime] [DATETIME] NOT NULL,
[Price] [DECIMAL](10, 2) NOT NULL,
[AvailableSeats] [INT] NOT NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK__Flight__8A9E148E9A8ED149] on [Logistics].[Flight]';
GO
ALTER TABLE [Logistics].[Flight]
ADD CONSTRAINT [PK__Flight__8A9E148E9A8ED149] PRIMARY KEY CLUSTERED([FlightID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[MaintenanceLog]';
GO
CREATE TABLE [Logistics].[MaintenanceLog] ([LogID] [INT] NOT NULL IDENTITY(1, 1),
[FlightID] [INT] NULL,
[MaintenanceDate] [DATETIME] NULL CONSTRAINT [DF__Maintenan__Maint__31EC6D26] DEFAULT(GETDATE()),
[Description] [NVARCHAR](500) COLLATE Latin1_General_CI_AS NULL,
[MaintenanceStatus] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF__Maintenan__Maint__32E0915F] DEFAULT('Pending'));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK__Maintena__5E5499A8A7E7CD24] on [Logistics].[MaintenanceLog]';
GO
ALTER TABLE [Logistics].[MaintenanceLog]
ADD CONSTRAINT [PK__Maintena__5E5499A8A7E7CD24] PRIMARY KEY CLUSTERED([LogID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Orders]';
GO
CREATE TABLE [Sales].[Orders] ([OrderID] [INT] NOT NULL IDENTITY(1, 1),
[CustomerID] [NCHAR](5) COLLATE Latin1_General_CI_AS NULL,
[EmployeeID] [INT] NULL,
[OrderDate] [DATETIME] NULL,
[RequiredDate] [DATETIME] NULL,
[ShippedDate] [DATETIME] NULL,
[ShipVia] [INT] NULL,
[Freight] [MONEY] NULL CONSTRAINT [DF_Orders_Freight] DEFAULT((0)),
[ShipName] [NVARCHAR](40) COLLATE Latin1_General_CI_AS NULL,
[ShipAddress] [NVARCHAR](60) COLLATE Latin1_General_CI_AS NULL,
[ShipCity] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[ShipRegion] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[ShipPostalCode] [NVARCHAR](10) COLLATE Latin1_General_CI_AS NULL,
[ShipCountry] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[ShipCountryCode] [INT] NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Orders] on [Sales].[Orders]';
GO
ALTER TABLE [Sales].[Orders]
ADD CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED([OrderID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [CustomerID] on [Sales].[Orders]';
GO
CREATE NONCLUSTERED INDEX [CustomerID] ON [Sales].[Orders]([CustomerID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [CustomersOrders] on [Sales].[Orders]';
GO
CREATE NONCLUSTERED INDEX [CustomersOrders]
ON [Sales].[Orders]([CustomerID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [EmployeeID] on [Sales].[Orders]';
GO
CREATE NONCLUSTERED INDEX [EmployeeID] ON [Sales].[Orders]([EmployeeID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [EmployeesOrders] on [Sales].[Orders]';
GO
CREATE NONCLUSTERED INDEX [EmployeesOrders]
ON [Sales].[Orders]([EmployeeID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [OrderDate] on [Sales].[Orders]';
GO
CREATE NONCLUSTERED INDEX [OrderDate] ON [Sales].[Orders]([OrderDate]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [ShippedDate] on [Sales].[Orders]';
GO
CREATE NONCLUSTERED INDEX [ShippedDate]
ON [Sales].[Orders]([ShippedDate]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [ShipPostalCode] on [Sales].[Orders]';
GO
CREATE NONCLUSTERED INDEX [ShipPostalCode]
ON [Sales].[Orders]([ShipPostalCode]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [ShippersOrders] on [Sales].[Orders]';
GO
CREATE NONCLUSTERED INDEX [ShippersOrders] ON [Sales].[Orders]([ShipVia]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[OrderAuditLog]';
GO
CREATE TABLE [Sales].[OrderAuditLog] ([AuditID] [INT] NOT NULL IDENTITY(1, 1),
[OrderID] [INT] NULL,
[ChangeDate] [DATETIME] NULL CONSTRAINT [DF__OrderAudi__Chang__4222D4EF] DEFAULT(GETDATE()),
[ChangeDescription] [NVARCHAR](500) COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK__OrderAud__A17F23B8298306B2] on [Sales].[OrderAuditLog]';
GO
ALTER TABLE [Sales].[OrderAuditLog]
ADD CONSTRAINT [PK__OrderAud__A17F23B8298306B2] PRIMARY KEY CLUSTERED([AuditID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Operation].[Employees]';
GO
CREATE TABLE [Operation].[Employees] ([EmployeeID] [INT] NOT NULL IDENTITY(1, 1),
[LastName] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NOT NULL,
[FirstName] [NVARCHAR](10) COLLATE Latin1_General_CI_AS NOT NULL,
[Title] [NVARCHAR](30) COLLATE Latin1_General_CI_AS NULL,
[TitleOfCourtesy] [NVARCHAR](25) COLLATE Latin1_General_CI_AS NULL,
[BirthDate] [DATETIME] NULL,
[HireDate] [DATETIME] NULL,
[Address] [NVARCHAR](60) COLLATE Latin1_General_CI_AS NULL,
[City] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[Region] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[PostalCode] [NVARCHAR](10) COLLATE Latin1_General_CI_AS NULL,
[Country] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[HomePhone] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
[Extension] [NVARCHAR](4) COLLATE Latin1_General_CI_AS NULL,
[Photo] [IMAGE] NULL,
[Notes] [NTEXT] COLLATE Latin1_General_CI_AS NULL,
[ReportsTo] [INT] NULL,
[PhotoPath] [NVARCHAR](255) COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Employees] on [Operation].[Employees]';
GO
ALTER TABLE [Operation].[Employees]
ADD CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED([EmployeeID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [LastName] on [Operation].[Employees]';
GO
CREATE NONCLUSTERED INDEX [LastName]
ON [Operation].[Employees]([LastName]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [PostalCode] on [Operation].[Employees]';
GO
CREATE NONCLUSTERED INDEX [PostalCode]
ON [Operation].[Employees]([PostalCode]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[EmployeeTerritories]';
GO
CREATE TABLE [Logistics].[EmployeeTerritories] ([EmployeeID] [INT] NOT NULL,
[TerritoryID] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NOT NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_EmployeeTerritories] on [Logistics].[EmployeeTerritories]';
GO
ALTER TABLE [Logistics].[EmployeeTerritories]
ADD CONSTRAINT [PK_EmployeeTerritories] PRIMARY KEY NONCLUSTERED([EmployeeID], [TerritoryID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Territories]';
GO
CREATE TABLE [Sales].[Territories] ([TerritoryID] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NOT NULL,
[TerritoryDescription] [NCHAR](50) COLLATE Latin1_General_CI_AS NOT NULL,
[RegionID] [INT] NOT NULL,
[RegionName] [NCHAR](10) COLLATE Latin1_General_CI_AS NULL,
[RegionCode] [NCHAR](10) COLLATE Latin1_General_CI_AS NULL,
[RegionOwner] [NCHAR](10) COLLATE Latin1_General_CI_AS NULL,
[Nationality] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NULL,
[NationalityCode] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Territories] on [Sales].[Territories]';
GO
ALTER TABLE [Sales].[Territories]
ADD CONSTRAINT [PK_Territories] PRIMARY KEY NONCLUSTERED([TerritoryID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Order Details]';
GO
CREATE TABLE [Sales].[Order Details] ([OrderID] [INT] NOT NULL,
[ProductID] [INT] NOT NULL,
[UnitPrice] [MONEY] NOT NULL CONSTRAINT [DF_Order_Details_UnitPrice] DEFAULT((0)),
[Quantity] [SMALLINT] NOT NULL CONSTRAINT [DF_Order_Details_Quantity] DEFAULT((1)),
[Discount] [REAL] NOT NULL CONSTRAINT [DF_Order_Details_Discount] DEFAULT((0)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Order_Details] on [Sales].[Order Details]';
GO
ALTER TABLE [Sales].[Order Details]
ADD CONSTRAINT [PK_Order_Details] PRIMARY KEY CLUSTERED([OrderID], [ProductID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [OrderID] on [Sales].[Order Details]';
GO
CREATE NONCLUSTERED INDEX [OrderID] ON [Sales].[Order Details]([OrderID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [OrdersOrder_Details] on [Sales].[Order Details]';
GO
CREATE NONCLUSTERED INDEX [OrdersOrder_Details]
ON [Sales].[Order Details]([OrderID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [ProductID] on [Sales].[Order Details]';
GO
CREATE NONCLUSTERED INDEX [ProductID]
ON [Sales].[Order Details]([ProductID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [ProductsOrder_Details] on [Sales].[Order Details]';
GO
CREATE NONCLUSTERED INDEX [ProductsOrder_Details]
ON [Sales].[Order Details]([ProductID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Operation].[Products]';
GO
CREATE TABLE [Operation].[Products] ([ProductID] [INT] NOT NULL IDENTITY(1, 1),
[ProductName] [NVARCHAR](40) COLLATE Latin1_General_CI_AS NOT NULL,
[SupplierID] [INT] NULL,
[CategoryID] [INT] NULL,
[QuantityPerUnit] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NULL,
[UnitPrice] [MONEY] NULL CONSTRAINT [DF_Products_UnitPrice] DEFAULT((0)),
[UnitsInStock] [SMALLINT] NULL CONSTRAINT [DF_Products_UnitsInStock] DEFAULT((0)),
[UnitsOnOrder] [SMALLINT] NULL CONSTRAINT [DF_Products_UnitsOnOrder] DEFAULT((0)),
[ReorderLevel] [SMALLINT] NULL CONSTRAINT [DF_Products_ReorderLevel] DEFAULT((0)),
[Discontinued] [BIT] NOT NULL CONSTRAINT [DF_Products_Discontinued] DEFAULT((0)),
[Colour] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NULL,
[Colour2] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NULL,
[Colour3] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Products] on [Operation].[Products]';
GO
ALTER TABLE [Operation].[Products]
ADD CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED([ProductID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [CategoriesProducts] on [Operation].[Products]';
GO
CREATE NONCLUSTERED INDEX [CategoriesProducts]
ON [Operation].[Products]([CategoryID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [CategoryID] on [Operation].[Products]';
GO
CREATE NONCLUSTERED INDEX [CategoryID]
ON [Operation].[Products]([CategoryID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [ProductName] on [Operation].[Products]';
GO
CREATE NONCLUSTERED INDEX [ProductName]
ON [Operation].[Products]([ProductName]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [SupplierID] on [Operation].[Products]';
GO
CREATE NONCLUSTERED INDEX [SupplierID]
ON [Operation].[Products]([SupplierID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [SuppliersProducts] on [Operation].[Products]';
GO
CREATE NONCLUSTERED INDEX [SuppliersProducts]
ON [Operation].[Products]([SupplierID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[Shippers]';
GO
CREATE TABLE [Logistics].[Shippers] ([ShipperID] [INT] NOT NULL IDENTITY(1, 1),
[CompanyName] [NVARCHAR](40) COLLATE Latin1_General_CI_AS NOT NULL,
[Phone] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
[id] [INT] NULL,
[ShipId] [INT] NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Shippers] on [Logistics].[Shippers]';
GO
ALTER TABLE [Logistics].[Shippers]
ADD CONSTRAINT [PK_Shippers] PRIMARY KEY CLUSTERED([ShipperID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Operation].[Categories]';
GO
CREATE TABLE [Operation].[Categories] ([CategoryID] [INT] NOT NULL IDENTITY(1, 1),
[CategoryName] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [NTEXT] COLLATE Latin1_General_CI_AS NULL,
[Picture] [IMAGE] NULL,
[date] [DATE] NULL,
[foo] [INT] NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Categories] on [Operation].[Categories]';
GO
ALTER TABLE [Operation].[Categories]
ADD CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED([CategoryID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [CategoryName] on [Operation].[Categories]';
GO
CREATE NONCLUSTERED INDEX [CategoryName]
ON [Operation].[Categories]([CategoryName]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[Suppliers]';
GO
CREATE TABLE [Logistics].[Suppliers] ([SupplierID] [INT] NOT NULL IDENTITY(1, 1),
[CompanyName] [NVARCHAR](40) COLLATE Latin1_General_CI_AS NOT NULL,
[ContactName] [NVARCHAR](30) COLLATE Latin1_General_CI_AS NULL,
[ContactTitle] [NVARCHAR](30) COLLATE Latin1_General_CI_AS NULL,
[Address] [NVARCHAR](60) COLLATE Latin1_General_CI_AS NULL,
[City] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[Region] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[PostalCode] [NVARCHAR](10) COLLATE Latin1_General_CI_AS NULL,
[Country] [NVARCHAR](15) COLLATE Latin1_General_CI_AS NULL,
[Phone] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
[Fax] [NVARCHAR](24) COLLATE Latin1_General_CI_AS NULL,
[HomePage] [NTEXT] COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Suppliers] on [Logistics].[Suppliers]';
GO
ALTER TABLE [Logistics].[Suppliers]
ADD CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED([SupplierID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [CompanyName] on [Logistics].[Suppliers]';
GO
CREATE NONCLUSTERED INDEX [CompanyName]
ON [Logistics].[Suppliers]([CompanyName]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating index [PostalCode] on [Logistics].[Suppliers]';
GO
CREATE NONCLUSTERED INDEX [PostalCode]
ON [Logistics].[Suppliers]([PostalCode]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[Region]';
GO
CREATE TABLE [Logistics].[Region] ([RegionID] [INT] NOT NULL,
[RegionDescription] [NCHAR](50) COLLATE Latin1_General_CI_AS NOT NULL,
[RegionName] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_Region] on [Logistics].[Region]';
GO
ALTER TABLE [Logistics].[Region]
ADD CONSTRAINT [PK_Region] PRIMARY KEY NONCLUSTERED([RegionID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[DiscountCode]';
GO
CREATE TABLE [Sales].[DiscountCode] ([DiscountID] [INT] NOT NULL IDENTITY(1, 1),
[Code] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NOT NULL,
[DiscountPercentage] [DECIMAL](4, 2) NULL,
[ExpiryDate] [DATETIME] NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK__Discount__E43F6DF6CA2BF14E] on [Sales].[DiscountCode]';
GO
ALTER TABLE [Sales].[DiscountCode]
ADD CONSTRAINT [PK__Discount__E43F6DF6CA2BF14E] PRIMARY KEY CLUSTERED([DiscountID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding constraints to [Sales].[DiscountCode]';
GO
ALTER TABLE [Sales].[DiscountCode]
ADD CONSTRAINT [UQ__Discount__A25C5AA70A86FB88] UNIQUE NONCLUSTERED([Code]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[CustomerOrdersView]';
GO
CREATE VIEW [Sales].[CustomerOrdersView]
AS
SELECT c.CustomerID, c.CompanyName, c.ContactName, c.Address, c.City, c.Region, c.Phone
FROM Sales.Customers c
     JOIN Sales.Orders o ON c.CustomerID=o.CustomerID;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[CustomersFeedbackSummary]';
GO
CREATE VIEW [Sales].[CustomersFeedbackSummary]
AS
SELECT c.CustomerID, c.CompanyName, c.ContactName, AVG(f.Rating) AS AverageRating, COUNT(f.FeedbackID) AS FeedbackCount
FROM Sales.Customers c
     LEFT JOIN Sales.CustomersFeedback f ON c.CustomerID=f.CustomerID
GROUP BY c.CustomerID, c.CompanyName, c.ContactName;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[FlightMaintenanceStatus]';
GO
CREATE VIEW [Logistics].[FlightMaintenanceStatus]
AS
SELECT f.FlightID, f.Airline, f.DepartureCity, f.ArrivalCity, COUNT(m.LogID) AS MaintenanceCount, SUM(CASE WHEN m.MaintenanceStatus='Completed' THEN 1 ELSE 0 END) AS CompletedMaintenance
FROM Logistics.Flight f
     LEFT JOIN Logistics.MaintenanceLog m ON f.FlightID=m.FlightID
GROUP BY f.FlightID, f.Airline, f.DepartureCity, f.ArrivalCity;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[UpdateAvailableSeats]';
GO
CREATE PROCEDURE [Logistics].[UpdateAvailableSeats] @FlightID INT, @SeatChange INT
AS BEGIN
    UPDATE Logistics.Flight
    SET AvailableSeats=AvailableSeats+@SeatChange
    WHERE FlightID=@FlightID;
END;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[AddMaintenanceLog]';
GO
CREATE PROCEDURE [Logistics].[AddMaintenanceLog] @FlightID INT, @Description NVARCHAR(500)
AS BEGIN
    INSERT INTO Logistics.MaintenanceLog(FlightID, Description, MaintenanceStatus)
    VALUES(@FlightID, @Description, 'Pending');
    PRINT 'Maintenance log entry created.';
END;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Customers].[RecordFeedback]';
GO
CREATE PROCEDURE [Customers].[RecordFeedback] @CustomerID INT, @Rating INT, @Comments NVARCHAR(500)
AS BEGIN
    INSERT INTO Sales.CustomersFeedback(CustomerID, Rating, Comments)
    VALUES(@CustomerID, @Rating, @Comments);
    PRINT 'Customer feedback recorded successfully.';
END;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Order Details Extended]';
GO
CREATE VIEW [Sales].[Order Details Extended]
AS
SELECT od.OrderID, od.ProductID, p.ProductName, od.UnitPrice, od.Quantity, od.Discount, (CONVERT(MONEY, (od.UnitPrice * od.Quantity *(1-od.Discount)/ 100))* 100) AS ExtendedPrice
FROM Operation.Products p
     INNER JOIN "Order Details" od ON p.ProductID=od.ProductID;
--ORDER BY od.OrderID
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Order Subtotals]';
GO
CREATE VIEW [Sales].[Order Subtotals]
AS
SELECT "Order Details".OrderID, SUM(CONVERT(MONEY, ("Order Details".UnitPrice * Quantity *(1-Discount)/ 100))* 100) AS Subtotal
FROM "Order Details"
GROUP BY "Order Details".OrderID;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Sales by Category]';
GO
CREATE VIEW [Sales].[Sales by Category]
AS
SELECT Operation.Categories.CategoryID, Operation.Categories.CategoryName, Operation.Products.ProductName, SUM("Order Details Extended".ExtendedPrice) AS ProductSales
FROM Operation.Categories
     INNER JOIN(Operation.Products
                INNER JOIN(Orders
                           INNER JOIN "Order Details Extended" ON Orders.OrderID="Order Details Extended".OrderID)ON Operation.Products.ProductID="Order Details Extended".ProductID)ON Operation.Categories.CategoryID=Operation.Products.CategoryID
WHERE Orders.OrderDate BETWEEN '19970101' AND '19971231'
GROUP BY Operation.Categories.CategoryID, Operation.Categories.CategoryName, Operation.Products.ProductName;
--ORDER BY Operation.Products.ProductName
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Sales Totals by Amount]';
GO
CREATE VIEW [Sales].[Sales Totals by Amount]
AS
SELECT "Order Subtotals".Subtotal AS SaleAmount, Orders.OrderID, Customers.CompanyName, Orders.ShippedDate
FROM Customers
     INNER JOIN(Orders
                INNER JOIN "Order Subtotals" ON Orders.OrderID="Order Subtotals".OrderID)ON Customers.CustomerID=Orders.CustomerID
WHERE("Order Subtotals".Subtotal>2500)AND(Orders.ShippedDate BETWEEN '19970101' AND '19971231');
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Summary of Sales by Quarter]';
GO
CREATE VIEW [Sales].[Summary of Sales by Quarter]
AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal
FROM Orders
     INNER JOIN "Order Subtotals" ON Orders.OrderID="Order Subtotals".OrderID
WHERE Orders.ShippedDate IS NOT NULL;
--ORDER BY Orders.ShippedDate
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[Sales by Year]';
GO
CREATE PROCEDURE [Sales].[Sales by Year] @Beginning_Date DATETIME, @Ending_Date DATETIME
AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal, DATENAME(yy, ShippedDate) AS Year
FROM Orders
     INNER JOIN "Order Subtotals" ON Orders.OrderID="Order Subtotals".OrderID
WHERE Orders.ShippedDate BETWEEN @Beginning_Date AND @Ending_Date;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[SalesByCategory]';
GO
CREATE PROCEDURE [Sales].[SalesByCategory] @CategoryName NVARCHAR(15), @OrdYear NVARCHAR(4) ='1998'
AS
IF @OrdYear !='1996' AND @OrdYear !='1997' AND @OrdYear !='1998' BEGIN
    SELECT @OrdYear='1998';
END;
SELECT ProductName, TotalPurchase=ROUND(SUM(CONVERT(DECIMAL(14, 2), OD.Quantity *(1-OD.Discount)* OD.UnitPrice)), 0)
FROM [Order Details] OD, [Sales].Orders O, [Operation].Products P, [Operation].Categories C
WHERE OD.OrderID=O.OrderID AND OD.ProductID=P.ProductID AND P.CategoryID=C.CategoryID AND C.CategoryName=@CategoryName AND SUBSTRING(CONVERT(NVARCHAR(22), O.OrderDate, 111), 1, 4)=@OrdYear
GROUP BY ProductName
ORDER BY ProductName;
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Logistics].[FlightRoute]';
GO
CREATE TABLE [Logistics].[FlightRoute] ([RouteID] [INT] NOT NULL IDENTITY(1, 1),
[DepartureCity] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArrivalCity] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NOT NULL,
[Distance] [INT] NOT NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK__FlightRo__80979AADC83FDFDB] on [Logistics].[FlightRoute]';
GO
ALTER TABLE [Logistics].[FlightRoute]
ADD CONSTRAINT [PK__FlightRo__80979AADC83FDFDB] PRIMARY KEY CLUSTERED([RouteID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[CustomerDemographics]';
GO
CREATE TABLE [Sales].[CustomerDemographics] ([CustomerTypeID] [NCHAR](10) COLLATE Latin1_General_CI_AS NOT NULL,
[CustomerDesc] [NTEXT] COLLATE Latin1_General_CI_AS NULL,
[nationality] [NVARCHAR](20) COLLATE Latin1_General_CI_AS NULL);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK_CustomerDemographics] on [Sales].[CustomerDemographics]';
GO
ALTER TABLE [Sales].[CustomerDemographics]
ADD CONSTRAINT [PK_CustomerDemographics] PRIMARY KEY NONCLUSTERED([CustomerTypeID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating [Sales].[LoyaltyProgram]';
GO
CREATE TABLE [Sales].[LoyaltyProgram] ([ProgramID] [INT] NOT NULL IDENTITY(1, 1),
[ProgramName] [NVARCHAR](50) COLLATE Latin1_General_CI_AS NOT NULL,
[PointsMultiplier] [DECIMAL](3, 2) NULL CONSTRAINT [DF__LoyaltyPr__Point__239E4DCF] DEFAULT((1.0)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Creating primary key [PK__LoyaltyP__7525603848DEBC46] on [Sales].[LoyaltyProgram]';
GO
ALTER TABLE [Sales].[LoyaltyProgram]
ADD CONSTRAINT [PK__LoyaltyP__7525603848DEBC46] PRIMARY KEY CLUSTERED([ProgramID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding constraints to [Operation].[Employees]';
GO
ALTER TABLE [Operation].[Employees] WITH NOCHECK
ADD CONSTRAINT [CK_Birthdate] CHECK(([BirthDate]<GETDATE()));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding constraints to [Operation].[Products]';
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK
ADD CONSTRAINT [CK_Products_UnitPrice] CHECK(([UnitPrice]>=(0)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK
ADD CONSTRAINT [CK_UnitsInStock] CHECK(([UnitsInStock]>=(0)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK
ADD CONSTRAINT [CK_UnitsOnOrder] CHECK(([UnitsOnOrder]>=(0)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK
ADD CONSTRAINT [CK_ReorderLevel] CHECK(([ReorderLevel]>=(0)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding constraints to [Sales].[Order Details]';
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK
ADD CONSTRAINT [CK_UnitPrice] CHECK(([UnitPrice]>=(0)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK
ADD CONSTRAINT [CK_Quantity] CHECK(([Quantity]>(0)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK
ADD CONSTRAINT [CK_Discount] CHECK(([Discount]>=(0)AND [Discount]<=(1)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding constraints to [Sales].[CustomersFeedback]';
GO
ALTER TABLE [Sales].[CustomersFeedback]
ADD CONSTRAINT [CK__Customers__Ratin__2A4B4B5E] CHECK(([Rating]>=(1)AND [Rating]<=(5)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding constraints to [Sales].[DiscountCode]';
GO
ALTER TABLE [Sales].[DiscountCode]
ADD CONSTRAINT [CK__DiscountC__Disco__36B12243] CHECK(([DiscountPercentage]>=(0)AND [DiscountPercentage]<=(100)));
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Operation].[Employees]';
GO
ALTER TABLE [Operation].[Employees] WITH NOCHECK
ADD CONSTRAINT [FK_Employees_Employees] FOREIGN KEY([ReportsTo])REFERENCES [Operation].[Employees]([EmployeeID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Operation].[Products]';
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK
ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY([CategoryID])REFERENCES [Operation].[Categories]([CategoryID]);
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK
ADD CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([SupplierID])REFERENCES [Logistics].[Suppliers]([SupplierID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Sales].[Order Details]';
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK
ADD CONSTRAINT [FK_Order_Details_Orders] FOREIGN KEY([OrderID])REFERENCES [Sales].[Orders]([OrderID]);
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK
ADD CONSTRAINT [FK_Order_Details_Products] FOREIGN KEY([ProductID])REFERENCES [Operation].[Products]([ProductID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Sales].[Orders]';
GO
ALTER TABLE [Sales].[Orders] WITH NOCHECK
ADD CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerID])REFERENCES [Sales].[Customers]([CustomerID]);
GO
ALTER TABLE [Sales].[Orders] WITH NOCHECK
ADD CONSTRAINT [FK_Orders_Employees] FOREIGN KEY([EmployeeID])REFERENCES [Operation].[Employees]([EmployeeID]);
GO
ALTER TABLE [Sales].[Orders] WITH NOCHECK
ADD CONSTRAINT [FK_Orders_Shippers] FOREIGN KEY([ShipVia])REFERENCES [Logistics].[Shippers]([ShipperID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Logistics].[EmployeeTerritories]';
GO
ALTER TABLE [Logistics].[EmployeeTerritories]
ADD CONSTRAINT [FK_EmployeeTerritories_Employees] FOREIGN KEY([EmployeeID])REFERENCES [Operation].[Employees]([EmployeeID]);
GO
ALTER TABLE [Logistics].[EmployeeTerritories]
ADD CONSTRAINT [FK_EmployeeTerritories_Territories] FOREIGN KEY([TerritoryID])REFERENCES [Sales].[Territories]([TerritoryID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Logistics].[MaintenanceLog]';
GO
ALTER TABLE [Logistics].[MaintenanceLog]
ADD CONSTRAINT [FK__Maintenan__Fligh__30F848ED] FOREIGN KEY([FlightID])REFERENCES [Logistics].[Flight]([FlightID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Sales].[CustomersFeedback]';
GO
ALTER TABLE [Sales].[CustomersFeedback]
ADD CONSTRAINT [FK__Customers__Custo__286302EC] FOREIGN KEY([CustomerID])REFERENCES [Sales].[Customers]([CustomerID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Sales].[OrderAuditLog]';
GO
ALTER TABLE [Sales].[OrderAuditLog]
ADD CONSTRAINT [FK__OrderAudi__Order__4316F928] FOREIGN KEY([OrderID])REFERENCES [Sales].[Orders]([OrderID]);
GO
IF @@ERROR<>0 SET NOEXEC ON;
GO
PRINT N'Adding foreign keys to [Sales].[Territories]';
GO
ALTER TABLE [Sales].[Territories]
ADD CONSTRAINT [FK_Territories_Region] FOREIGN KEY([RegionID])REFERENCES [Logistics].[Region]([RegionID]);
GO