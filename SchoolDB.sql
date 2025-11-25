Create Database SchoolDB;

Create Table Students
(
Id int Primary key IDENTITY(1,1),
FullName nvarchar(100) Not Null,
Age int Check(Age>6 and Age <20),
Email varchar(30) UNIQUE,
Score int Default(0) Check(Score>=0 and Score <=100)
)
--1.Students cədvəlinə 5 tələbə əlavə edin

INSERT INTO Students 
Values
('Paulo Dybala', 19, 'dybala@gmail.com', 95),
('Alvaro Morata', 17, 'morata@gmail.com', 84),
('Dusan Vlahovic', 15, 'vlahovic@gmail.com', 77),
('Kenan Yildiz', 16, 'kenan@gmail.com', 68),
('Federico Chiesa', 14, 'chiesa@gmail.com', 57)

Select * from Students

--2.Students cədvəlinə yeni sütun əlavə edin

ALTER TABLE Students
ADD [Phone Number] nvarchar(40)

--3.Score-u 90-dan yuxarı olan tələbələrin Email-lərini yeniləyin

UPDATE Students Set Email = 'yeniemail@gmail.com' Where Score > 90

--4. Yaş 15-den kiçik olan tələbələri silin
DELETE FROM Students where Age<15 


--5.Score üçün yeni şərt əlavə edin(score yalniz 5 e bolunen edeler olmalidir)
ALTER TABLE Students
ADD CONSTRAINT NewScore CHECK (Score % 5 = 0)

--6.“TopStudents” adlı cədvəl yaradin ID,FullName, Score olsun 
--(Students cədvəlindən Score > 80 olanları TopStudents-ə insert edin)
CREATE TABLE TopStudents(
Id int Primary key IDENTITY(1,1),
FullName nvarchar(100) Not Null,
Score int Default(0) Check(Score>=0 and Score <=100)
)
INSERT INTO TopStudents (FullName, Score)
SELECT FullName, Score 
FROM Students
WHERE Score > 80;

Select * from TopStudents

