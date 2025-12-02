Create Database LibraryDB;

CREATE TABLE Authors
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL,
    Surname NVARCHAR(50) NOT NULL
);

CREATE TABLE Books
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    AuthorId INT NOT NULL,
    Name NVARCHAR(100) NOT NULL CHECK (LEN(Name) >= 2),
    PageCount INT NOT NULL CHECK (PageCount >= 10),
    FOREIGN KEY (AuthorId) REFERENCES Authors(Id)
);

CREATE TABLE DeletedBooks
(
    Id INT,
    AuthorId INT,
    Name NVARCHAR(100),
    PageCount INT
);

CREATE VIEW vw_BookAuthors
AS
SELECT 
    b.Id,
    b.Name,
    b.PageCount,
    a.Name + ' ' + a.Surname AS AuthorFullName
FROM Books b
JOIN Authors a ON b.AuthorId = a.Id;


CREATE PROCEDURE sp_SearchBooks
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SELECT 
        b.Id,
        b.Name,
        b.PageCount,
        a.Name + ' ' + a.Surname AS AuthorFullName
    FROM Books b
    JOIN Authors a ON b.AuthorId = a.Id
    WHERE b.Name LIKE '%' + @SearchTerm + '%'
       OR a.Name LIKE '%' + @SearchTerm + '%';
END


CREATE FUNCTION ufn_CountBooks
(
    @MinPageCount INT = 10
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    SELECT @Result = COUNT(*)
    FROM Books
    WHERE PageCount > @MinPageCount;

    RETURN @Result;
END;

CREATE TRIGGER trg_BookDelete
ON Books
AFTER DELETE
AS
BEGIN
    INSERT INTO DeletedBooks(Id, AuthorId, Name, PageCount)
    SELECT Id, AuthorId, Name, PageCount
    FROM DELETED;
END


INSERT INTO Authors (Name, Surname)
VALUES
('Chingiz', 'Abdullayev'),
('Elchin', 'Efendiyev'),
('Anar', 'Rzayev'),
('Agatha', 'Christie'),
('Jules', 'Verne');

Select * from Authors


INSERT INTO Books (AuthorId, Name, PageCount)
VALUES
(1, 'Qatilin izi ile', 320),
(1, 'Mavi Mələklər', 280),
(2, 'Mahmud və Meryem', 210),
(3, 'Ag qoç, qara qoç', 150),
(4, 'On zenci', 190),
(4, 'Serq ekspresində qətl', 256),
(5, 'Deniz altında 20 min liqa', 400);

Select * from Books


--Delete
DELETE FROM Books WHERE Id = 3;   -- "Mahmud və Məryəm" silinsin
SELECT * FROM DeletedBooks;

--View
SELECT * FROM vw_BookAuthors;

--Axtaris
EXEC sp_SearchBooks 'Ag'; 

--Select
SELECT dbo.ufn_CountBooks(200);  















