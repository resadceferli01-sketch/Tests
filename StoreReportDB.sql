--1. Hər filialdakı işçi sayını tapın
-- 2. Hər filialda mövcud olan məhsul sayını tapın
 --3. Hər işçinin cari ayda satdığı məhsulların yekun qiymətini tapın
 --4. Satılan hər məhsuldan 1% qazanc əldə etdiyini nəzərə alaraq car ayda 
--hər bir satıcının maaşını hesablayın (rəsmi maaş : 350 AZN)
 --5. Hər filial üzrə cari aydakı qazancı hesablayın.
 --6. Cari ay üzrə aylıq hesabatı çıxaran sorğu yazın

 CREATE DATABASE StoreReportDB;
GO
USE StoreReportDB;

CREATE TABLE Branches (
    Id INT primary key identity(1,1),
    Name NVARCHAR(50),
    Address NVARCHAR(100)
);



CREATE TABLE Employees (
    Id INT  PRIMARY KEY Identity(1,1),
    Name NVARCHAR(50),
    Surname NVARCHAR(50),
    Salary DECIMAL(10,2) DEFAULT 350,
   BranchId INT  FOREIGN KEY  REFERENCES Branches(Id)
);

CREATE TABLE Products (
    Id INT  PRIMARY KEY Identity(1,1),
    Name NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    Id INT  PRIMARY KEY Identity(1,1),
    Quantity INT,
    SaleDate DATE,
    ProductId INT  FOREIGN KEY REFERENCES Products(Id),
    EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
    BranchId INT FOREIGN KEY  REFERENCES Branches(Id)
);


INSERT INTO Branches (Name, Address) VALUES
('Nizami', 'Nizami 45'),
('Yasamal', 'M.Elizade 12'),
('Xetai', 'Xetai 78'),
('Sebail','E.Nezerov 45');

INSERT INTO Employees (Name, Surname, BranchId) VALUES
('Murad', 'Huseynov', 1),
('Aysel', 'Quliyeva', 1),
('Kamal', 'Əliyev', 4),
('Elvin', 'Memmedov', 2),
('Nigar', 'Səmədova', 3),
('Nigar', 'Aliyeva', 3),
('Nergiz', 'Ehmedovadova', 4);


INSERT INTO Products (Name, Price) VALUES
('Lenovo IdeaPad', 1200),
('HP Pavilion', 1400),
('Samsung Monitor', 350),
('Logitech Mouse', 45),
('Xiaomi Poco', 475),
('Iphone 18', 4445),
('Redmi 18', 2045),
('Samsung Galaxy S27 ', 3045),
('Nokia', 145),
('PS5', 1045);

INSERT INTO Sales (ProductId, EmployeeId, BranchId, Quantity, SaleDate)
VALUES
(1, 1, 1, 7, '2025-12-02'),
(2, 2, 1, 6, '2025-12-03'),
(3, 3, 2, 5, '2025-12-04'),
(4, 4, 2, 8, '2025-12-05'),
(5, 5, 3, 5, '2025-12-06'),
(6, 6, 4, 4, '2025-12-07'),
(7, 7, 1, 6, '2025-12-08'),
(8, 4, 2, 8, '2025-12-09'),
(9, 5, 3, 5, '2025-12-10'),
(10, 2, 3, 11, '2025-12-11'),
(1, 2, 4, 12, '2025-12-12'),
(5, 4, 2, 13, '2025-12-13'),
(7, 6, 1, 15, '2025-12-14');

--1) Hər filialdakı işçi sayını tapın

SELECT 
    b.Name AS Branch,
    COUNT(e.Id) AS EmployeeCount
FROM Branches b
LEFT JOIN Employees e ON b.Id = e.BranchId
GROUP BY b.Name;

--2) Hər filialda mövcud olan məhsul sayını tapın

SELECT 
    b.Name AS Branch,
    COUNT(s.ProductId) AS ProductCount
FROM Branches b
LEFT JOIN Sales s ON b.Id = s.BranchId
GROUP BY b.Name;

--3) Hər işçinin cari ayda satdığı məhsulların yekun qiymətini tapın

SELECT 
    e.Name,
    e.Surname,
    SUM(s.Quantity * p.Price) AS TotalAmount
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(s.SaleDate) =12 and YEAR(s.SaleDate)=2025
GROUP BY e.Name, e.Surname;

--4)Satılan hər məhsuldan 1% qazanc əldə etdiyini nəzərə alaraq car ayda 
--hər bir satıcının maaşını hesablayın

SELECT
    e.Name,
    e.Surname,
    e.Salary AS OfficialSalary,
    SUM(s.Quantity * p.Price) * 0.01 AS Bonus,
    e.Salary + (SUM(s.Quantity * p.Price) * 0.01) AS FinalSalary
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(s.SaleDate) =12 and YEAR(s.SaleDate)=2025
Group by e.Name,e.Surname,e.salary
--5)  Hər filial üzrə cari aydakı qazancı hesablayın.
SELECT 
    b.Name AS Branch,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Branches b ON s.BranchId = b.Id
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(s.SaleDate) =12 and YEAR(s.SaleDate)=2025

GROUP BY b.Name;

--6) Cari ay üzrə aylıq hesabatı çıxaran sorğu yazın
SELECT 
    b.Name AS Branch,
    e.Name + ' ' + e.Surname AS Employee,
    p.Name AS Product,
    s.Quantity,
    p.Price,
    (s.Quantity * p.Price) AS TotalAmount,
    (s.Quantity * p.Price) * 0.01 AS ProfitPercent
FROM Sales s
JOIN Employees e ON s.EmployeeId = e.Id
JOIN Branches b ON s.BranchId = b.Id
JOIN Products p ON s.ProductId = p.Id
WHERE MONTH(s.SaleDate) =12 and YEAR(s.SaleDate)=2025






















