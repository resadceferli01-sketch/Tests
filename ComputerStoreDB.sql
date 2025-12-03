Create database ComputerStoreDB;

Create Table Categories(
Id int primary key identity(1,1),
[Name] nvarchar(50) not null
)

Create Table Products(
Id int primary key identity(1,1),
Brand nvarchar(50) not null,
[Model] nvarchar(50) not null,
Price decimal(10,2),
CategoryID int Foreign key  references Categories(Id)
)

Create Table Employees(
Id int primary key identity(1,1),
[Name] nvarchar(50) not null,
Surname nvarchar(50) not null,
Age int CHECK(Age>0)
)

Create Table Branches(
Id int primary key identity(1,1),
[Name] nvarchar(50) not null,
[Address] nvarchar (100)
)

Create Table Sales(
Id int primary key identity(1,1),
Quantity int not null,
SaleDate Date not null,

ProductID int Foreign key references Products(Id),
EmployeeID int Foreign key references Employees(id),
BranchId int Foreign key references Branches(Id),
)


INSERT INTO Categories (Name)
VALUES 
('Notebook'),
('Desktop'),
('Monitor'),
('Accessories'),
('Printer');


INSERT INTO Products (CategoryId, Brand, Model, Price)
VALUES
(1, 'Lenovo', 'IdeaPad 3', 1250),
(1, 'HP', 'Pavilion 15', 1450),
(1, 'Asus', 'VivoBook X515', 1100),


(2, 'Dell', 'OptiPlex 7090', 1800),
(2, 'HP', 'ProDesk 400', 1600),
(3, 'Samsung', 'S24F350', 320),
(3, 'LG', 'UltraGear 27', 780),
(4, 'Logitech', 'MK270 Combo', 60),
(4, 'Razer', 'DeathAdder V2', 120),
(5, 'Canon', 'i-SENSYS LBP223', 650);


INSERT INTO Employees (Name, Surname, Age)
VALUES
('Murad', 'Huseynov',24),
('Aysel', 'Quliyeva', 28),
('Kamal', 'Eliyev',  30),
('Elvin', 'Məmmədov', 22),
('Nigar', 'Semedova', 26),
('Murad', 'Memmedov',30);

INSERT INTO Branches (Name, Address)
VALUES
('Nizami', 'Nizami kücesi 45'),
('Yasamal', 'Yasamal rayonu, M.Elizadə 12'),
('Xetai', 'Xetai prospekti 78');

INSERT INTO Sales (ProductId, EmployeeId, BranchId, Quantity, SaleDate)
VALUES
-- Yanvar Satışları
(1, 1, 1, 5, '2025-01-05'),
(2, 2, 1, 3, '2025-01-06'),
(3, 3, 2, 4, '2025-01-07'),
(6, 4, 3, 10, '2025-01-10'),
(7, 5, 2, 6, '2025-01-11');

--1)  Bütün məhsulların siyahısına baxmaq üçün sorğu yazın
SELECT * FROM Products;
--2)  Bütün işçilərin siyahısına baxmaq üçün sorğu yazın
SELECT * FROM Employees;
--3)Məhsullara kateqoriyaları ilə birgə baxmaq üçün sorğu yazın
SELECT 
    p.Id,
    p.Brand,
    p.Model,
    p.Price,
    c.Name AS CategoryName
FROM Products p
JOIN Categories c ON p.CategoryId = c.Id;

--4) Adı Murad olan işçinin məlumatlarına baxmaq üçün sorğu yazın
SELECT * FROM Employees
WHERE Name = 'Murad';
-- 5) Yaşı 25-dən kiçik olan işçilərin siyahısına baxmaq üçün sorğu
SELECT * FROM Employees
WHERE Age<25
--6) Hər modeldən neçə məhsulun olduğunu tapın
SELECT Model,
    COUNT(*) AS ProductCount
FROM Products
GROUP BY Model;
--7)Hər markada hər modelin neçə məhsulu olduğunu tapın
SELECT Brand,[Model],
    COUNT(*) AS TotalCount
FROM Products
GROUP BY Brand, Model;

--8)Hər filial üzrə aylıq satış məbləğinin hesablanması

SELECT 
    b.Name AS BranchName,
    MONTH(s.SaleDate) AS Month,
    SUM(s.Quantity * p.Price) AS MonthlyRevenue
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
JOIN Branches b ON s.BranchId = b.Id
GROUP BY 
    b.Name,
    MONTH(s.SaleDate);

    ---9) Ay ərzində ən çox satış olunan model
    SELECT TOP 1
    p.Model,
    SUM(s.Quantity) AS TotalSold
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
 WHERE MONTH(s.SaleDate) = 1 AND YEAR(s.SaleDate) = 2025
GROUP BY 
    p.Model
ORDER BY TotalSold DESC;
---10)Ay ərzində ən az satış edən işçi
SELECT TOP 1 
    e.Id,
    e.Name,
    e.Surname,
    SUM(s.Quantity) AS TotalSold
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
WHERE MONTH(s.SaleDate) = 1 AND YEAR(s.SaleDate) = 2025
GROUP BY e.Id, e.Name, e.Surname
ORDER BY TotalSold ASC;





--11) Ay ərzində 10-dan çox satış edən işçilərin siyahısı

SELECT 
    e.Id,
    e.Name,
    e.Surname,
    SUM(s.Quantity) AS TotalSold
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
WHERE MONTH(s.SaleDate) = 1 AND YEAR(s.SaleDate) = 2025

GROUP BY e.Id, e.Name, e.Surname
HAVING SUM(s.Quantity) > 10;


--12) İşcilərin ad ve soyad  eyni xanada göstərən sorğu yazın
SELECT 
    Name + ' ' + Surname  AS FullName
FROM Employees;


---13)Məhsulun ad və qarşısında adın uzunluğunu göstərən sorğu yazın.
SELECT 
    Brand + ' ' + Model AS ProductName,
    LEN(Brand + ' ' + Model) AS NameLength
FROM Products;
--14) Ən bahalı Məhsulu göstərən sorğu yazın
SELECT TOP 1 *
FROM Products
ORDER BY Price DESC;
--15)Ən bahalı və ən ucuz məhsulu eyni sorğuda göstərin

SELECT 'En bahali mehsul' AS Type, * 
FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products)

UNION ALL

SELECT 'En ucuz mehsul' AS Type, *
FROM Products
WHERE Price = (SELECT MIN(Price) FROM Products);

--16)Məhsulları qiymətinə görə kateqoriyalara bölün. 
SELECT 
    Brand,
    Model,
    Price,
    CASE 
        WHEN Price < 1000 THEN 'Munasib'
        WHEN Price BETWEEN 1000 AND 2500 THEN 'Orta qiymetli'
        WHEN Price > 2500 THEN 'Baha'
    END AS PriceCategory
FROM Products;

--17) Cari ayda olan bütün satışların cəmini tapın
 

SELECT 
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(s.SaleDate) = 1 AND YEAR(s.SaleDate) = 2025
;

--18)Cari ayda ən çox satış edən işçinin məlumatlarını çıxaran sorğu yazın \

SELECT TOP 1
    e.Id,
    e.Name,
    e.Surname,
    SUM(s.Quantity) AS TotalSold
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
WHERE MONTH(s.SaleDate) = 1 AND YEAR(s.SaleDate) = 2025

GROUP BY e.Id, e.Name, e.Surname
ORDER BY TotalSold DESC;

--19) Cari ayda ən çox qazanc gətirən işçinin məlumatlarını çıxaran sorğu yazın
SELECT TOP 1
    e.Id,
    e.Name,
    e.Surname,
    SUM(s.Quantity * p.Price) AS TotalProfit
FROM Sales s
JOIN Products p ON s.ProductId = p.Id
JOIN Employees e ON s.EmployeeId = e.Id
WHERE MONTH(s.SaleDate) = 1 AND YEAR(s.SaleDate) = 2025
GROUP BY e.Id, e.Name, e.Surname
ORDER BY TotalProfit DESC;












