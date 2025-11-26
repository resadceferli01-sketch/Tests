Create Database EcommerceDB;


-- 1)Customers (Id,Name,Email,Phone)

Create Table Customers(
Id INT IDENTITY PRIMARY KEY,
[Name] NVARCHAR(100),
Email NVARCHAR(100),
Phone NVARCHAR(30)
);

--2)Products(Id,Name,Description,Price)
--Products ----- Categories → Many-to-one


Create Table Products(
Id INT IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(100),
    [Description] NVARCHAR(255),
    Price DECIMAL(10,2)  CHECK(Price>=0),

    CategoryId INT 
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
);
--Drop Table Products

--3)Categories(Id,Name,Description)

CREATE TABLE Categories(
    Id INT IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(100) ,
    [Description] NVARCHAR(255)
);

--4)Orders(Id,OrderDate,Status)
--Customers ---- Orders → One-to-many

CREATE TABLE Orders(
    Id INT IDENTITY PRIMARY KEY,
    OrderDate DATETIME,
   [Status] NVARCHAR(50),


   CustomerId INT ,
    FOREIGN KEY(CustomerId) REFERENCES Customers(Id)
    )
    --Drop table Orders
    
    
    --5)OrderItems(Id,Quantity,UnitPrice)

    CREATE TABLE OrderItems(
    Id INT IDENTITY PRIMARY KEY,
    Quantity INT  CHECK(Quantity > 0),
    UnitPrice DECIMAL(10,2) CHECK(UnitPrice >= 0),
    
   
    OrderId INT,
    ProductId INT,

    FOREIGN KEY(OrderId) REFERENCES Orders(Id),
    FOREIGN KEY(ProductId) REFERENCES Products(Id)
    );
    --Drop table OrderItems 

--6)Suppliers(Id,Name,ContactInfo)

CREATE TABLE Suppliers(
    Id INT IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(100),
    ContactInfo NVARCHAR(255)
);


--7)ProductSuppliers(Id)
--Products ------ Suppliers → Many-to-many
CREATE TABLE ProductSuppliers(
    Id INT IDENTITY PRIMARY KEY,
    ProductId INT,
    SupplierId INT,

        FOREIGN KEY(ProductId) REFERENCES Products(Id),
        FOREIGN KEY(SupplierId) REFERENCES Suppliers(Id)
    );
    --drop table ProductSuppliers