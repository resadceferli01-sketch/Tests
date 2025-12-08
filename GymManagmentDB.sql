Create Database GymManagmentDB;

---1. Üzvlər (Members)
CREATE TABLE Members (
    Member_id INT PRIMARY KEY IDENTITY(1,1),
    First_name NVARCHAR(100) NOT NULL,
    Last_name NVARCHAR(100) NOT NULL,
    Date_of_birth DATE,
    Gender NVARCHAR(10),
    Phone_number NVARCHAR(20) UNIQUE,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Join_date DATE ,
    status NVARCHAR(20) DEFAULT 'Aktiv'
);

---2. Üzvlük Planları (Membership Plans)
CREATE TABLE MembershipPlans (
    Plan_id INT PRIMARY KEY IDENTITY(1,1),
    Plan_name NVARCHAR(100) UNIQUE NOT NULL,
    Duration_months INT,
    Price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    [Description] NVARCHAR(500)
);

---3)Məşqçilər (Trainers) cədvəlinin yaradılması
CREATE TABLE Trainers (
    Trainer_id INT PRIMARY KEY IDENTITY(1,1),
    First_name NVARCHAR(100) NOT NULL,
    Last_name NVARCHAR(100) NOT NULL,
    Specialization NVARCHAR(100),
    Phone_number NVARCHAR(20) UNIQUE,
    Email NVARCHAR(100) UNIQUE NOT NULL
);

---4)Siniflər / Dərslər (Classes) cədvəlinin yaradılması

CREATE TABLE Classes (
    Class_id INT PRIMARY KEY IDENTITY(1,1), 
    Class_name NVARCHAR(100) ,
    [description] NVARCHAR(500),
    Trainer_id INT Foreign key References  Trainers(Trainer_id),
    Duration_minutes INT ,
);

---5)Sinif Cədvəli (Class Schedule) cədvəlinin yaradılması
CREATE TABLE ClassSchedule (
    Schedule_id INT PRIMARY KEY IDENTITY(1,1), 
    Class_id INT foreign key references Classes(Class_id), 
    Day_of_week NVARCHAR(20) ,
    Start_time TIME NOT NULL,
    End_time TIME NOT NULL,
    Room NVARCHAR(50),
);

---6)Üzvlük Satışları (Memberships) cədvəlinin yaradılması

CREATE TABLE Memberships (
    membership_id INT PRIMARY KEY IDENTITY(1,1), 
    member_id INT Foreign key references Members(Member_id),
    plan_id INT Foreign key references MembershipPlans(Plan_id),
    start_date DATE ,
    end_date DATE ,
    is_active BIT DEFAULT 1, 
);

---7)Ödənişlər (Payments) cədvəlinin yaradılması

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    member_id INT Foreign key references Members (Member_id),
    amount DECIMAL(10, 2), 
    payment_date DATETIME ,
    payment_method NVARCHAR(50),
    description NVARCHAR(200),
    
);

---8)Sinif Qeydiyyatı (Class Registrations) cədvəlinin yaradılması

CREATE TABLE ClassRegistrations (
    registration_id INT PRIMARY KEY IDENTITY(1,1),
    member_id INT Foreign key references Members(Member_id),
    schedule_id INT Foreign key references ClassSchedule(Schedule_id), 
    registration_date DATETIME,
);