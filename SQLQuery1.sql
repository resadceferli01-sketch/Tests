Create Database Homework


Create Table Regions(
REGION_ID INT,
REGION_NAME nvarchar(25),
)

Create Table Countries(
COUNTRY_ID CHAR(2),
COUNTRY_NAME nvarchar(40)
)

Create Table Locations(
LOCATION_ID int,
STREET_ADDRESS nvarchar(25),
POSTAL_CODE nvarchar(12),
CITY nvarchar(30),
STATE_PROVINCE nvarchar(12)
)

Create Table Departments(
DEPARMENT_ID int,
DEPARMENT_NAME nvarchar(30),
MANAGER_ID int,
LOCATION_ID int
)

Create Table job_history(
[START_DATE] DATETIME,
[END-DATE] DATETIME,
)

Create Table employees
(
EMPLOYEE_ID int,
FIRST_NAME nvarchar(20),
LAST_NAME nvarchar(25),
EMAIL nvarchar(25),
PHONE_NUMBER nvarchar(20),
HIRE_DATE datetime,
SALARY int,
COMMISSION_PCT int,
MANAGER_ID int,
DEPARTMENT_ID int,
)

Create Table jobs
(
JOB_ID nvarchar(10),
JOB_TITLE nvarchar(35),
MIN_SALARY int,
MAX_SALARY INT,
)

Create Table job_grades(
GRADE_LEVEL nvarchar(2),
LOWEST_SAL int,
HIGHEST_SAL int,
)


