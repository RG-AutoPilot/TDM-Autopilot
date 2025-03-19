-- Flyway AutoPilot FastTrack Database Setup Script --

-- Drop AutoPilotDev database if it exists to ensure fresh setup
IF DB_ID('AutoPilotDev') IS NOT NULL
BEGIN
	USE MASTER
    ALTER DATABASE AutoPilotDev SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AutoPilotDev;
	PRINT 'AutoPilotDev Database Dropped'
END;

-- Ensure each database exists, creating them if needed
IF DB_ID('AutoPilotDev') IS NULL CREATE DATABASE AutoPilotDev PRINT 'AutoPilotDev Database Created';
GO

USE AutoPilotDev;
GO

ALTER DATABASE AutoPilotDev
SET MULTI_USER;
GO

-- Creating Schemas
CREATE SCHEMA Sales;
GO
CREATE SCHEMA Operation;
GO
CREATE SCHEMA Customers;
GO
CREATE SCHEMA Logistics;
GO


CREATE ROLE CustomerService;
CREATE ROLE Admin;


CREATE TABLE Sales.LoyaltyProgram (
    ProgramID INT PRIMARY KEY IDENTITY,
    ProgramName NVARCHAR(50) NOT NULL,
    PointsMultiplier DECIMAL(3, 2) DEFAULT 1.0
);

CREATE TABLE [Sales].[Customers]
(
[CustomerID] [nchar] (5) COLLATE Latin1_General_CI_AS NOT NULL,
[CompanyName] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ContactName] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ContactTitle] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Address] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[City] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[Region] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[PostalCode] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Country] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[Phone] [nvarchar] (24) COLLATE Latin1_General_CI_AS NULL,
[Fax] [nvarchar] (24) COLLATE Latin1_General_CI_AS NULL,
[LinkedIn] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RegionCode] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[CityCode] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Customers] on [Sales].[Customers]'
GO
ALTER TABLE [Sales].[Customers] ADD CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [City] on [Sales].[Customers]'
GO
CREATE NONCLUSTERED INDEX [City] ON [Sales].[Customers] ([City])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [CompanyName] on [Sales].[Customers]'
GO
CREATE NONCLUSTERED INDEX [CompanyName] ON [Sales].[Customers] ([CompanyName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [PostalCode] on [Sales].[Customers]'
GO
CREATE NONCLUSTERED INDEX [PostalCode] ON [Sales].[Customers] ([PostalCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [Region] on [Sales].[Customers]'
GO
CREATE NONCLUSTERED INDEX [Region] ON [Sales].[Customers] ([Region])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

CREATE TABLE Sales.CustomersFeedback (
    FeedbackID INT PRIMARY KEY IDENTITY,
    CustomerID nchar(5) FOREIGN KEY REFERENCES Sales.Customers(CustomerID),
    FeedbackDate DATETIME DEFAULT GETDATE(),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments NVARCHAR(500)
);
GO

-- Tables in Logistics Schema
CREATE TABLE Logistics.Flight (
    FlightID INT PRIMARY KEY IDENTITY,
    Airline NVARCHAR(50) NOT NULL,
    DepartureCity NVARCHAR(50) NOT NULL,
    ArrivalCity NVARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    AvailableSeats INT NOT NULL
);

CREATE TABLE Logistics.FlightRoute (
    RouteID INT PRIMARY KEY IDENTITY,
    DepartureCity NVARCHAR(50) NOT NULL,
    ArrivalCity NVARCHAR(50) NOT NULL,
    Distance INT NOT NULL
);

CREATE TABLE Logistics.MaintenanceLog (
    LogID INT PRIMARY KEY IDENTITY,
    FlightID INT FOREIGN KEY REFERENCES Logistics.Flight(FlightID),
    MaintenanceDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(500),
    MaintenanceStatus NVARCHAR(20) DEFAULT 'Pending'
);
GO

CREATE TABLE Sales.DiscountCode (
    DiscountID INT PRIMARY KEY IDENTITY,
    Code NVARCHAR(20) UNIQUE NOT NULL,
    DiscountPercentage DECIMAL(4, 2) CHECK (DiscountPercentage BETWEEN 0 AND 100),
    ExpiryDate DATETIME
);


PRINT N'Creating [Operation].[Employees]'
GO
CREATE TABLE [Operation].[Employees]
(
[EmployeeID] [int] NOT NULL IDENTITY(1, 1),
[LastName] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[FirstName] [nvarchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[Title] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[TitleOfCourtesy] [nvarchar] (25) COLLATE Latin1_General_CI_AS NULL,
[BirthDate] [datetime] NULL,
[HireDate] [datetime] NULL,
[Address] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[City] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[Region] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[PostalCode] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Country] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[HomePhone] [nvarchar] (24) COLLATE Latin1_General_CI_AS NULL,
[Extension] [nvarchar] (4) COLLATE Latin1_General_CI_AS NULL,
[Photo] [image] NULL,
[Notes] [ntext] COLLATE Latin1_General_CI_AS NULL,
[ReportsTo] [int] NULL,
[PhotoPath] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Employees] on [Operation].[Employees]'
GO
ALTER TABLE [Operation].[Employees] ADD CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED ([EmployeeID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [LastName] on [Operation].[Employees]'
GO
CREATE NONCLUSTERED INDEX [LastName] ON [Operation].[Employees] ([LastName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [PostalCode] on [Operation].[Employees]'
GO
CREATE NONCLUSTERED INDEX [PostalCode] ON [Operation].[Employees] ([PostalCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Logistics].[EmployeeTerritories]'
GO
CREATE TABLE [Logistics].[EmployeeTerritories]
(
[EmployeeID] [int] NOT NULL,
[TerritoryID] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_EmployeeTerritories] on [Logistics].[EmployeeTerritories]'
GO
ALTER TABLE [Logistics].[EmployeeTerritories] ADD CONSTRAINT [PK_EmployeeTerritories] PRIMARY KEY NONCLUSTERED ([EmployeeID], [TerritoryID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[Territories]'
GO
CREATE TABLE [Sales].[Territories]
(
[TerritoryID] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[TerritoryDescription] [nchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RegionID] [int] NOT NULL,
[RegionName] [nchar] (10) COLLATE Latin1_General_CI_AS NULL,
[RegionCode] [nchar] (10) COLLATE Latin1_General_CI_AS NULL,
[RegionOwner] [nchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Nationality] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[NationalityCode] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Territories] on [Sales].[Territories]'
GO
ALTER TABLE [Sales].[Territories] ADD CONSTRAINT [PK_Territories] PRIMARY KEY NONCLUSTERED ([TerritoryID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[Orders]'
GO
CREATE TABLE [Sales].[Orders]
(
[OrderID] [int] NOT NULL IDENTITY(1, 1),
[CustomerID] [nchar] (5) COLLATE Latin1_General_CI_AS NULL,
[EmployeeID] [int] NULL,
[OrderDate] [datetime] NULL,
[RequiredDate] [datetime] NULL,
[ShippedDate] [datetime] NULL,
[ShipVia] [int] NULL,
[Freight] [money] NULL CONSTRAINT [DF_Orders_Freight] DEFAULT ((0)),
[ShipName] [nvarchar] (40) COLLATE Latin1_General_CI_AS NULL,
[ShipAddress] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[ShipCity] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[ShipRegion] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[ShipPostalCode] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ShipCountry] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[ShipCountryCode] [int] NULL,
[FlightID] [int] NULL,
[Status] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[TotalAmount] [money] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Orders] on [Sales].[Orders]'
GO
ALTER TABLE [Sales].[Orders] ADD CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [CustomerID] on [Sales].[Orders]'
GO
CREATE NONCLUSTERED INDEX [CustomerID] ON [Sales].[Orders] ([CustomerID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [CustomersOrders] on [Sales].[Orders]'
GO
CREATE NONCLUSTERED INDEX [CustomersOrders] ON [Sales].[Orders] ([CustomerID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [EmployeeID] on [Sales].[Orders]'
GO
CREATE NONCLUSTERED INDEX [EmployeeID] ON [Sales].[Orders] ([EmployeeID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [EmployeesOrders] on [Sales].[Orders]'
GO
CREATE NONCLUSTERED INDEX [EmployeesOrders] ON [Sales].[Orders] ([EmployeeID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [OrderDate] on [Sales].[Orders]'
GO
CREATE NONCLUSTERED INDEX [OrderDate] ON [Sales].[Orders] ([OrderDate])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [ShippedDate] on [Sales].[Orders]'
GO
CREATE NONCLUSTERED INDEX [ShippedDate] ON [Sales].[Orders] ([ShippedDate])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [ShipPostalCode] on [Sales].[Orders]'
GO
CREATE NONCLUSTERED INDEX [ShipPostalCode] ON [Sales].[Orders] ([ShipPostalCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [ShippersOrders] on [Sales].[Orders]'
GO
CREATE NONCLUSTERED INDEX [ShippersOrders] ON [Sales].[Orders] ([ShipVia])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO

CREATE TABLE Sales.OrderAuditLog (
    AuditID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    ChangeDate DATETIME DEFAULT GETDATE(),
    ChangeDescription NVARCHAR(500),
    FOREIGN KEY (OrderID) REFERENCES Sales.Orders(OrderID)
);
GO

PRINT N'Creating [Sales].[Order Details]'
GO
CREATE TABLE [Sales].[Order Details]
(
[OrderID] [int] NOT NULL,
[ProductID] [int] NOT NULL,
[UnitPrice] [money] NOT NULL CONSTRAINT [DF_Order_Details_UnitPrice] DEFAULT ((0)),
[Quantity] [smallint] NOT NULL CONSTRAINT [DF_Order_Details_Quantity] DEFAULT ((1)),
[Discount] [real] NOT NULL CONSTRAINT [DF_Order_Details_Discount] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Order_Details] on [Sales].[Order Details]'
GO
ALTER TABLE [Sales].[Order Details] ADD CONSTRAINT [PK_Order_Details] PRIMARY KEY CLUSTERED ([OrderID], [ProductID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [OrderID] on [Sales].[Order Details]'
GO
CREATE NONCLUSTERED INDEX [OrderID] ON [Sales].[Order Details] ([OrderID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [OrdersOrder_Details] on [Sales].[Order Details]'
GO
CREATE NONCLUSTERED INDEX [OrdersOrder_Details] ON [Sales].[Order Details] ([OrderID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [ProductID] on [Sales].[Order Details]'
GO
CREATE NONCLUSTERED INDEX [ProductID] ON [Sales].[Order Details] ([ProductID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [ProductsOrder_Details] on [Sales].[Order Details]'
GO
CREATE NONCLUSTERED INDEX [ProductsOrder_Details] ON [Sales].[Order Details] ([ProductID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Operation].[Products]'
GO
CREATE TABLE [Operation].[Products]
(
[ProductID] [int] NOT NULL IDENTITY(1, 1),
[ProductName] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[SupplierID] [int] NULL,
[CategoryID] [int] NULL,
[QuantityPerUnit] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[UnitPrice] [money] NULL CONSTRAINT [DF_Products_UnitPrice] DEFAULT ((0)),
[UnitsInStock] [smallint] NULL CONSTRAINT [DF_Products_UnitsInStock] DEFAULT ((0)),
[UnitsOnOrder] [smallint] NULL CONSTRAINT [DF_Products_UnitsOnOrder] DEFAULT ((0)),
[ReorderLevel] [smallint] NULL CONSTRAINT [DF_Products_ReorderLevel] DEFAULT ((0)),
[Discontinued] [bit] NOT NULL CONSTRAINT [DF_Products_Discontinued] DEFAULT ((0)),
[Colour] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Colour2] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Colour3] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Products] on [Operation].[Products]'
GO
ALTER TABLE [Operation].[Products] ADD CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [CategoriesProducts] on [Operation].[Products]'
GO
CREATE NONCLUSTERED INDEX [CategoriesProducts] ON [Operation].[Products] ([CategoryID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [CategoryID] on [Operation].[Products]'
GO
CREATE NONCLUSTERED INDEX [CategoryID] ON [Operation].[Products] ([CategoryID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [ProductName] on [Operation].[Products]'
GO
CREATE NONCLUSTERED INDEX [ProductName] ON [Operation].[Products] ([ProductName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [SupplierID] on [Operation].[Products]'
GO
CREATE NONCLUSTERED INDEX [SupplierID] ON [Operation].[Products] ([SupplierID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [SuppliersProducts] on [Operation].[Products]'
GO
CREATE NONCLUSTERED INDEX [SuppliersProducts] ON [Operation].[Products] ([SupplierID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Logistics].[Shippers]'
GO
CREATE TABLE [Logistics].[Shippers]
(
[ShipperID] [int] NOT NULL IDENTITY(1, 1),
[CompanyName] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[Phone] [nvarchar] (24) COLLATE Latin1_General_CI_AS NULL,
[id] [int] NULL,
[ShipId] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Shippers] on [Logistics].[Shippers]'
GO
ALTER TABLE [Logistics].[Shippers] ADD CONSTRAINT [PK_Shippers] PRIMARY KEY CLUSTERED ([ShipperID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Operation].[Categories]'
GO
CREATE TABLE [Operation].[Categories]
(
[CategoryID] [int] NOT NULL IDENTITY(1, 1),
[CategoryName] [nvarchar] (15) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [ntext] COLLATE Latin1_General_CI_AS NULL,
[Picture] [image] NULL,
[date] [date] NULL,
[foo] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Categories] on [Operation].[Categories]'
GO
ALTER TABLE [Operation].[Categories] ADD CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [CategoryName] on [Operation].[Categories]'
GO
CREATE NONCLUSTERED INDEX [CategoryName] ON [Operation].[Categories] ([CategoryName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Logistics].[Suppliers]'
GO
CREATE TABLE [Logistics].[Suppliers]
(
[SupplierID] [int] NOT NULL IDENTITY(1, 1),
[CompanyName] [nvarchar] (40) COLLATE Latin1_General_CI_AS NOT NULL,
[ContactName] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ContactTitle] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Address] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[City] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[Region] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[PostalCode] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Country] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[Phone] [nvarchar] (24) COLLATE Latin1_General_CI_AS NULL,
[Fax] [nvarchar] (24) COLLATE Latin1_General_CI_AS NULL,
[HomePage] [ntext] COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Suppliers] on [Logistics].[Suppliers]'
GO
ALTER TABLE [Logistics].[Suppliers] ADD CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED ([SupplierID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [CompanyName] on [Logistics].[Suppliers]'
GO
CREATE NONCLUSTERED INDEX [CompanyName] ON [Logistics].[Suppliers] ([CompanyName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [PostalCode] on [Logistics].[Suppliers]'
GO
CREATE NONCLUSTERED INDEX [PostalCode] ON [Logistics].[Suppliers] ([PostalCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Logistics].[Region]'
GO
CREATE TABLE [Logistics].[Region]
(
[RegionID] [int] NOT NULL,
[RegionDescription] [nchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RegionName] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[foo] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[foo2] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Region] on [Logistics].[Region]'
GO
ALTER TABLE [Logistics].[Region] ADD CONSTRAINT [PK_Region] PRIMARY KEY NONCLUSTERED ([RegionID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- Views

GO
CREATE VIEW Sales.CustomerOrdersView AS
SELECT 
    c.CustomerID,
    c.CompanyName,
    c.ContactName,
    c.Address,
    c.City,
    c.Region,
    c.Phone
FROM Sales.Customers c
JOIN Sales.Orders o ON c.CustomerID = o.CustomerID;
GO
CREATE VIEW Sales.CustomersFeedbackSummary AS
SELECT 
    c.CustomerID,
    c.CompanyName,
    c.ContactName,
    AVG(f.Rating) AS AverageRating,
    COUNT(f.FeedbackID) AS FeedbackCount
FROM Sales.Customers c
LEFT JOIN Sales.CustomersFeedback f ON c.CustomerID = f.CustomerID
GROUP BY c.CustomerID, c.CompanyName, c.ContactName;
GO

CREATE VIEW Logistics.FlightMaintenanceStatus AS
SELECT 
    f.FlightID,
    f.Airline,
    f.DepartureCity,
    f.ArrivalCity,
    COUNT(m.LogID) AS MaintenanceCount,
    SUM(CASE WHEN m.MaintenanceStatus = 'Completed' THEN 1 ELSE 0 END) AS CompletedMaintenance
FROM Logistics.Flight f
LEFT JOIN Logistics.MaintenanceLog m ON f.FlightID = m.FlightID
GROUP BY f.FlightID, f.Airline, f.DepartureCity, f.ArrivalCity;
GO

-- Stored Procedures

CREATE PROCEDURE Sales.GetCustomerFlightHistory @CustomerID INT
AS
BEGIN
    SELECT 
        o.OrderID,
        f.Airline,
        f.DepartureCity,
        f.ArrivalCity,
        o.OrderDate,
        o.Status,
        o.TotalAmount,
        c.CompanyName,
        c.ContactName,
        c.ContactTitle,
        c.Address,
        c.City,
        c.Region,
        c.PostalCode,
        c.Country,
        c.Phone,
        c.Fax
    FROM Sales.Orders o
    JOIN Logistics.Flight f ON o.FlightID = f.FlightID
    JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate;
END;
GO

CREATE PROCEDURE Sales.UpdateOrderStatus
    @OrderID INT,
    @NewStatus NVARCHAR(20)
AS
BEGIN
    BEGIN TRY
        UPDATE Sales.Orders
        SET Status = @NewStatus
        WHERE OrderID = @OrderID;
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while updating order status.';
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE Logistics.UpdateAvailableSeats
    @FlightID INT,
    @SeatChange INT
AS
BEGIN
    UPDATE Logistics.Flight
    SET AvailableSeats = AvailableSeats + @SeatChange
    WHERE FlightID = @FlightID;
END;
GO

CREATE PROCEDURE Logistics.AddMaintenanceLog
    @FlightID INT,
    @Description NVARCHAR(500)
AS
BEGIN
    INSERT INTO Logistics.MaintenanceLog (FlightID, Description, MaintenanceStatus)
    VALUES (@FlightID, @Description, 'Pending');

    PRINT 'Maintenance log entry created.';
END;
GO

CREATE PROCEDURE Customers.RecordFeedback
    @CustomerID INT,
    @Rating INT,
    @Comments NVARCHAR(500)
AS
BEGIN
    INSERT INTO Sales.CustomersFeedback (CustomerID, Rating, Comments)
    VALUES (@CustomerID, @Rating, @Comments);

    PRINT 'Customer feedback recorded successfully.';
END;
GO

PRINT N'Creating [Customer].[CustomerDemographics]'
GO
CREATE TABLE [Sales].[CustomerDemographics]
(
[CustomerTypeID] [nchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[CustomerDesc] [ntext] COLLATE Latin1_General_CI_AS NULL,
[nationality] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CustomerDemographics] on [Sales].[CustomerDemographics]'
GO
ALTER TABLE [Sales].[CustomerDemographics] ADD CONSTRAINT [PK_CustomerDemographics] PRIMARY KEY NONCLUSTERED ([CustomerTypeID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[Customers]'
GO

PRINT N'Creating [Sales].[Order Details Extended]'
GO

create view [Sales].[Order Details Extended] AS
SELECT od.OrderID, od.ProductID, p.ProductName, 
    od.UnitPrice, od.Quantity, od.Discount, 
    (CONVERT(money,(od.UnitPrice*od.Quantity*(1-od.Discount)/100))*100) AS ExtendedPrice
FROM Operation.Products p INNER JOIN "Order Details" od ON p.ProductID = od.ProductID
--ORDER BY od.OrderID
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[Order Subtotals]'
GO

create view [Sales].[Order Subtotals] AS
SELECT "Order Details".OrderID, Sum(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS Subtotal
FROM "Order Details"
GROUP BY "Order Details".OrderID
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[Sales by Category]'
GO
create view [Sales].[Sales by Category] AS
SELECT Operation.Categories.CategoryID, Operation.Categories.CategoryName, Operation.Products.ProductName, 
    Sum("Order Details Extended".ExtendedPrice) AS ProductSales
FROM 	Operation.Categories INNER JOIN 
        (Operation.Products INNER JOIN 
            (Orders INNER JOIN "Order Details Extended" ON Orders.OrderID = "Order Details Extended".OrderID) 
        ON Operation.Products.ProductID = "Order Details Extended".ProductID) 
    ON Operation.Categories.CategoryID = Operation.Products.CategoryID
WHERE Orders.OrderDate BETWEEN '19970101' And '19971231'
GROUP BY Operation.Categories.CategoryID, Operation.Categories.CategoryName, Operation.Products.ProductName
--ORDER BY Operation.Products.ProductName
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[Sales Totals by Amount]'
GO

create view [Sales].[Sales Totals by Amount] AS
SELECT "Order Subtotals".Subtotal AS SaleAmount, Orders.OrderID, Customers.CompanyName, Orders.ShippedDate
FROM 	Customers INNER JOIN 
        (Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID) 
    ON Customers.CustomerID = Orders.CustomerID
WHERE ("Order Subtotals".Subtotal >2500) AND (Orders.ShippedDate BETWEEN '19970101' And '19971231')
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[Summary of Sales by Quarter]'
GO

create view [Sales].[Summary of Sales by Quarter] AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShippedDate IS NOT NULL
--ORDER BY Orders.ShippedDate
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[Sales by Year]'
GO

create procedure [Sales].[Sales by Year] 
	@Beginning_Date DateTime, @Ending_Date DateTime AS
SELECT Orders.ShippedDate, Orders.OrderID, "Order Subtotals".Subtotal, DATENAME(yy,ShippedDate) AS Year
FROM Orders INNER JOIN "Order Subtotals" ON Orders.OrderID = "Order Subtotals".OrderID
WHERE Orders.ShippedDate Between @Beginning_Date And @Ending_Date
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Sales].[SalesByCategory]'
GO
CREATE PROCEDURE [Sales].[SalesByCategory]
    @CategoryName nvarchar(15), @OrdYear nvarchar(4) = '1998'
AS
IF @OrdYear != '1996' AND @OrdYear != '1997' AND @OrdYear != '1998' 
BEGIN
	SELECT @OrdYear = '1998'
END
SELECT ProductName,
	TotalPurchase=ROUND(SUM(CONVERT(decimal(14,2), OD.Quantity * (1-OD.Discount) * OD.UnitPrice)), 0)
FROM [Order Details] OD, [Sales].Orders O, [Operation].Products P, [Operation].Categories C
WHERE OD.OrderID = O.OrderID 
	AND OD.ProductID = P.ProductID 
	AND P.CategoryID = C.CategoryID
	AND C.CategoryName = @CategoryName
	AND SUBSTRING(CONVERT(nvarchar(22), O.OrderDate, 111), 1, 4) = @OrdYear
GROUP BY ProductName
ORDER BY ProductName
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [Operation].[Employees]'
GO
ALTER TABLE [Operation].[Employees] WITH NOCHECK ADD CONSTRAINT [CK_Birthdate] CHECK (([BirthDate]<getdate()))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [Sales].[Order Details]'
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK ADD CONSTRAINT [CK_UnitPrice] CHECK (([UnitPrice]>=(0)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK ADD CONSTRAINT [CK_Quantity] CHECK (([Quantity]>(0)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK ADD CONSTRAINT [CK_Discount] CHECK (([Discount]>=(0) AND [Discount]<=(1)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [Operation].[Products]'
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK ADD CONSTRAINT [CK_Products_UnitPrice] CHECK (([UnitPrice]>=(0)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK ADD CONSTRAINT [CK_UnitsInStock] CHECK (([UnitsInStock]>=(0)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK ADD CONSTRAINT [CK_UnitsOnOrder] CHECK (([UnitsOnOrder]>=(0)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK ADD CONSTRAINT [CK_ReorderLevel] CHECK (([ReorderLevel]>=(0)))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [Operation].[Products]'
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK  ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY ([CategoryID]) REFERENCES [Operation].[Categories] ([CategoryID])
GO
ALTER TABLE [Operation].[Products] WITH NOCHECK  ADD CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY ([SupplierID]) REFERENCES [Logistics].[Suppliers] ([SupplierID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [Sales].[Orders]'
GO
ALTER TABLE [Sales].[Orders] WITH NOCHECK  ADD CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [Sales].[Customers] ([CustomerID])
GO
ALTER TABLE [Sales].[Orders] WITH NOCHECK  ADD CONSTRAINT [FK_Orders_Employees] FOREIGN KEY ([EmployeeID]) REFERENCES [Operation].[Employees] ([EmployeeID])
GO
ALTER TABLE [Sales].[Orders] WITH NOCHECK  ADD CONSTRAINT [FK_Orders_Shippers] FOREIGN KEY ([ShipVia]) REFERENCES [Logistics].[Shippers] ([ShipperID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [Operation].[Employees]'
GO
ALTER TABLE [Operation].[Employees] WITH NOCHECK  ADD CONSTRAINT [FK_Employees_Employees] FOREIGN KEY ([ReportsTo]) REFERENCES [Operation].[Employees] ([EmployeeID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [Sales].[Order Details]'
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK  ADD CONSTRAINT [FK_Order_Details_Orders] FOREIGN KEY ([OrderID]) REFERENCES [Sales].[Orders] ([OrderID])
GO
ALTER TABLE [Sales].[Order Details] WITH NOCHECK  ADD CONSTRAINT [FK_Order_Details_Products] FOREIGN KEY ([ProductID]) REFERENCES [Operation].[Products] ([ProductID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [Logistics].[EmployeeTerritories]'
GO
ALTER TABLE [Logistics].[EmployeeTerritories] ADD CONSTRAINT [FK_EmployeeTerritories_Employees] FOREIGN KEY ([EmployeeID]) REFERENCES [Operation].[Employees] ([EmployeeID])
GO
ALTER TABLE [Logistics].[EmployeeTerritories] ADD CONSTRAINT [FK_EmployeeTerritories_Territories] FOREIGN KEY ([TerritoryID]) REFERENCES [Sales].[Territories] ([TerritoryID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [Sales].[Territories]'
GO
ALTER TABLE [Sales].[Territories] ADD CONSTRAINT [FK_Territories_Region] FOREIGN KEY ([RegionID]) REFERENCES [Logistics].[Region] ([RegionID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO


-- Insert data into tables --

