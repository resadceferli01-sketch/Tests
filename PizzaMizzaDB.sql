CREATE DATABASE PizzaMizzaDB;


---------------------------
-- 1. Pizza Types
---------------------------
CREATE TABLE PizzaTypes(
    Id INT  PRIMARY KEY IDENTITY (1,1),
    TypeName NVARCHAR(50) NOT NULL
);

INSERT INTO PizzaTypes(TypeName)
VALUES ('Classic'), ('Premium'), ('Vegetarian'), ('Special');


---------------------------
-- 2. Ingredients
---------------------------
CREATE TABLE Ingredients(
  Id INT  PRIMARY KEY IDENTITY (1,1),
    Name NVARCHAR(100) NOT NULL
);

INSERT INTO Ingredients(Name)
VALUES
('Pendir'),
('Mozzarella'),
('Soğan'),
('Göbələk'),
('Vetçina'),
('Mərci sousu'),
('BBQ sous'),
('Zeytun'),
('Pomidor'),
('Kolbasa'),
('Toyuq')
;



---------------------------
-- 3. Pizza Sizes
---------------------------
CREATE TABLE Sizes(
  Id INT  PRIMARY KEY IDENTITY (1,1),
    SizeName NVARCHAR(20) NOT NULL
);

INSERT INTO Sizes(SizeName)
VALUES ('Kicik'), ('Normal'), ('Boyuk');


---------------------------
-- 4. Pizzas
---------------------------
CREATE TABLE Pizzas(
  Id INT  PRIMARY KEY IDENTITY (1,1),
    Name NVARCHAR(100) NOT NULL,
    TypeId INT NOT NULL REFERENCES PizzaTypes(Id)
);

-- Nümunə pizzalar
INSERT INTO Pizzas(Name, TypeId)
VALUES 
('Margherita', 1),
('Havay', 1),
('Mista', 3),
('Vegetarian Mix', 3);



---------------------------
-- 5. PizzaIngredients (N:M)
---------------------------
CREATE TABLE PizzaIngredients(
  Id INT  PRIMARY KEY IDENTITY (1,1),
    PizzaId INT NOT NULL REFERENCES Pizzas(Id),
    IngredientId INT NOT NULL REFERENCES Ingredients(Id)
);

-- Nümunə
INSERT INTO PizzaIngredients(PizzaId, IngredientId)
VALUES
(1,1),(1,2),(1,6),
(2,1),(2,7),(2,6),
(3,8),(3,11),(3,6),
(4,4),(4,5),(4,6),(4,11);



---------------------------
-- 6. PizzaPrices (Her ölçü üçün qiymət)
---------------------------
CREATE TABLE PizzaPrices(
    Id INT IDENTITY PRIMARY KEY,
    PizzaId INT NOT NULL REFERENCES Pizzas(Id),
    SizeId INT NOT NULL REFERENCES Sizes(Id),
    Price DECIMAL(10,2) NOT NULL
);

-- Nümunə qiymətlər
INSERT INTO PizzaPrices(PizzaId, SizeId, Price)
VALUES
-- Margherita
(1,1,6),(1,2,10),(1,3,14.50),
-- Havay
(2,1,7.50),(2,2,10.50),(2,3,13.50),
-- Mista
(3,1,8.00),(3,2,11.00),(3,3,14.00),
-- Vegetarian Mix
(4,1,7.00),(4,2,10.00),(4,3,13.00);
GO
