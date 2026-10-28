-- =======================================================
-- DBMS WEEK 5
-- DML AND JOIN SQL QUERIES
-- SMART HOSTEL MANAGEMENT SYSTEM
-- ====================================================
--
-- Student Name :Mohammadnoor Sirasgi
-- SRN  : PES2UG25CS812
-- ============================================================


-- ============================================================
-- PROMPT
-- Run this separately in MySQL terminal after replacing SRN:
-- PROMPT (SRN@\u) [\d]>


-- ============================================================
-- DATABASE PREPARATION
-- SCHEMA / TABLE CREATION

-- If using a database, select/create your database here.
-- Example:
-- CREATE DATABASE SmartHostel;
-- USE SmartHostel;


-- ============================================================
-- 1. HOSTEL TABLE
-- ============================================================

CREATE TABLE Hostel (
    Hostel_ID INT PRIMARY KEY,
    Hostel_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL DEFAULT 0,
    CHECK (Capacity >= 0)
);


-- ============================================================
-- 2. STAFF TABLE
-- ============================================================

CREATE TABLE Staff (
    Staff_ID INT PRIMARY KEY,
    Staff_Name VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    Designation VARCHAR(50) NOT NULL DEFAULT 'Support Staff',
    Hostel_ID INT NOT NULL,
    Supervisor_ID INT NULL,

    CHECK (Salary > 0),

    FOREIGN KEY (Hostel_ID)
        REFERENCES Hostel(Hostel_ID),

    FOREIGN KEY (Supervisor_ID)
        REFERENCES Staff(Staff_ID)
        ON DELETE SET NULL
);


-- ============================================================
-- 3. ROOM TABLE
-- ============================================================

CREATE TABLE Room (
    Hostel_ID INT,
    Room_Number INT,
    Floor INT NOT NULL DEFAULT 0,

    PRIMARY KEY (Hostel_ID, Room_Number),

    FOREIGN KEY (Hostel_ID)
        REFERENCES Hostel(Hostel_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 4. BED TABLE
-- ============================================================

CREATE TABLE Bed (
    Hostel_ID INT,
    Room_Number INT,
    Bed_Number INT,
    Status VARCHAR(20) NOT NULL DEFAULT 'Vacant',

    PRIMARY KEY (Hostel_ID, Room_Number, Bed_Number),

    CHECK (Status IN ('Occupied', 'Vacant')),

    FOREIGN KEY (Hostel_ID, Room_Number)
        REFERENCES Room(Hostel_ID, Room_Number)
        ON DELETE CASCADE
);


-- ============================================================
-- 5. STUDENT TABLE
-- ============================================================

CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Middle_Name VARCHAR(50),
    Last_Name VARCHAR(50) NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    DOB DATE NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);


-- ============================================================
-- 6. STUDENT_PHONE TABLE
-- ============================================================

CREATE TABLE Student_Phone (
    Student_ID INT,
    Phone_Number VARCHAR(20),

    PRIMARY KEY (Student_ID, Phone_Number),

    FOREIGN KEY (Student_ID)
        REFERENCES Student(Student_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 7. FACILITY TABLE
-- ============================================================

CREATE TABLE Facility (
    Facility_ID INT PRIMARY KEY,
    Facility_Name VARCHAR(100) NOT NULL,
    Operating_Hours VARCHAR(50) DEFAULT '24x7',
    Hostel_ID INT NOT NULL,

    FOREIGN KEY (Hostel_ID)
        REFERENCES Hostel(Hostel_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 8. USES TABLE
-- ============================================================

CREATE TABLE Uses (
    Student_ID INT,
    Facility_ID INT,
    Usage_Date DATE,

    PRIMARY KEY (Student_ID, Facility_ID, Usage_Date),

    FOREIGN KEY (Student_ID)
        REFERENCES Student(Student_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Facility_ID)
        REFERENCES Facility(Facility_ID)
        ON DELETE CASCADE
);


-- ============================================================
-- 9. ALLOCATION TABLE
-- ============================================================

CREATE TABLE Allocation (
    Allocation_ID INT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Hostel_ID INT NOT NULL,
    Room_Number INT NOT NULL,
    Allocation_Date DATE NOT NULL,
    Check_in_Date DATE NOT NULL,
    Check_out_Date DATE NULL,

    FOREIGN KEY (Student_ID)
        REFERENCES Student(Student_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Hostel_ID, Room_Number)
        REFERENCES Room(Hostel_ID, Room_Number)
        ON DELETE CASCADE
);


-- ============================================================
-- 10. PAYMENT TABLE
-- ============================================================

CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY,
    Student_ID INT NOT NULL,
    Payment_Date DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Payment_Type VARCHAR(50) NOT NULL,

    CHECK (Amount > 0),

    FOREIGN KEY (Student_ID)
        REFERENCES Student(Student_ID)
);


-- ============================================================
-- 11. RECEIPT TABLE
-- ============================================================

CREATE TABLE Receipt (
    Receipt_ID INT PRIMARY KEY,
    Payment_ID INT NOT NULL UNIQUE,
    Receipt_Date DATE NOT NULL,

    FOREIGN KEY (Payment_ID)
        REFERENCES Payment(Payment_ID)
);


-- ============================================================
-- SAMPLE DATA INSERTION
-- ============================================================


-- ============================================================
-- HOSTEL DATA
-- ============================================================

INSERT INTO Hostel
(Hostel_ID, Hostel_Name, Location, Capacity)
VALUES
(1, 'Sunrise Hostel', 'North Campus', 120),
(2, 'Blue Ridge Hostel', 'South Campus', 90),
(3, 'Lake View Hostel', 'East Campus', 60);


-- ============================================================
-- STAFF DATA
-- ============================================================

INSERT INTO Staff
(Staff_ID, Staff_Name, Designation, Salary, Hostel_ID, Supervisor_ID)
VALUES
(1, 'Ramesh Iyer', 'Warden', 45000, 1, NULL),
(2, 'Sunil Kumar', 'Security', 22000, 1, 1),
(3, 'Geeta Rao', 'Cleaner', 18000, 1, 1),
(4, 'Anita Sharma', 'Warden', 46000, 2, NULL),
(5, 'Mohan Das', 'Security', 21000, 2, 4),
(6, 'Priya Menon', 'Maintenance', 25000, 2, 4),
(7, 'Kiran Bose', 'Warden', 44000, 3, NULL),
(8, 'Farhan Sheikh', 'Cleaner', 17500, 3, 7);


-- ============================================================
-- ROOM DATA
-- ============================================================

INSERT INTO Room
(Hostel_ID, Room_Number, Floor)
VALUES
(1, 101, 1),
(1, 102, 1),
(1, 201, 2),
(2, 101, 1),
(2, 102, 1),
(3, 101, 1);


-- ============================================================
-- BED DATA
-- ============================================================

INSERT INTO Bed
(Hostel_ID, Room_Number, Bed_Number, Status)
VALUES
(1, 101, 1, 'Occupied'),
(1, 101, 2, 'Occupied'),
(1, 102, 1, 'Occupied'),
(1, 102, 2, 'Vacant'),
(1, 201, 1, 'Occupied'),
(1, 201, 2, 'Vacant'),
(2, 101, 1, 'Occupied'),
(2, 101, 2, 'Vacant'),
(2, 102, 1, 'Occupied'),
(2, 102, 2, 'Occupied'),
(3, 101, 1, 'Occupied'),
(3, 101, 2, 'Vacant');


-- ============================================================
-- STUDENT DATA
-- ============================================================

INSERT INTO Student
(Student_ID, First_Name, Middle_Name, Last_Name, Gender, DOB, Email)
VALUES
(1, 'Aditya', NULL, 'Verma', 'M', '2005-03-14',
 'aditya.verma@pes.edu'),

(2, 'Neha', 'R', 'Kulkarni', 'F', '2005-07-22',
 'neha.kulkarni@pes.edu'),

(3, 'Rohan', NULL, 'Shetty', 'M', '2004-11-05',
 'rohan.shetty@pes.edu'),

(4, 'Sanya', 'K', 'Malhotra', 'F', '2005-01-30',
 'sanya.malhotra@pes.edu'),

(5, 'Vikram', NULL, 'Nair', 'M', '2004-09-18',
 'vikram.nair@pes.edu'),

(6, 'Ishita', 'P', 'Bansal', 'F', '2005-05-09',
 'ishita.bansal@pes.edu'),

(7, 'Arjun', NULL, 'Reddy', 'M', '2005-02-27',
 'arjun.reddy@pes.edu'),

(8, 'Meera', 'S', 'Pillai', 'F', '2004-12-12',
 'meera.pillai@pes.edu');


-- ============================================================
-- STUDENT PHONE DATA
-- ============================================================

INSERT INTO Student_Phone
(Student_ID, Phone_Number)
VALUES
(1, '9876500001'),
(1, '9876500011'),
(2, '9876500002'),
(3, '9876500003'),
(4, '9876500004'),
(4, '9876500014'),
(5, '9876500005'),
(6, '9876500006'),
(7, '9876500007'),
(8, '9876500008');


-- ============================================================
-- FACILITY DATA
-- ============================================================

INSERT INTO Facility
(Facility_ID, Facility_Name, Operating_Hours, Hostel_ID)
VALUES
(1, 'WiFi Lounge', '24 Hours', 1),
(2, 'Laundry Room', '06:00-20:00', 1),
(3, 'Gym', '05:00-22:00', 2),
(4, 'Study Room', '24 Hours', 2),
(5, 'Common Room', '08:00-23:00', 3);


-- ============================================================
-- USES DATA
-- ============================================================

INSERT INTO Uses
(Student_ID, Facility_ID, Usage_Date)
VALUES
(1, 1, '2026-01-20'),
(2, 1, '2026-01-20'),
(3, 1, '2026-01-22'),
(1, 2, '2026-01-21'),
(4, 3, '2026-01-20'),
(5, 3, '2026-01-21'),
(4, 4, '2026-01-25'),
(6, 4, '2026-01-22'),
(7, 5, '2026-01-23');


-- ============================================================
-- ALLOCATION DATA
-- ============================================================

INSERT INTO Allocation
(Allocation_ID, Student_ID, Hostel_ID, Room_Number,
 Allocation_Date, Check_in_Date, Check_out_Date)
VALUES
(1, 1, 1, 101, '2026-01-05', '2026-01-06', NULL),
(2, 2, 1, 101, '2026-01-05', '2026-01-06', NULL),
(3, 3, 1, 102, '2026-01-06', '2026-01-07', NULL),
(4, 4, 2, 101, '2026-01-05', '2026-01-06', NULL),
(5, 5, 2, 102, '2026-01-06', '2026-01-07', NULL),
(6, 6, 2, 102, '2026-01-06', '2026-01-07', NULL),
(7, 7, 3, 101, '2026-01-07', '2026-01-08', NULL),
(8, 3, 1, 201, '2025-06-01', '2025-06-02',
 '2025-12-20');


-- ============================================================
-- PAYMENT DATA
-- ============================================================

INSERT INTO Payment
(Payment_ID, Student_ID, Payment_Date, Amount, Payment_Type)
VALUES
(1, 1, '2026-01-10', 45000, 'Online'),
(2, 2, '2026-01-11', 45000, 'Cash'),
(3, 3, '2026-01-12', 42000, 'Card'),
(4, 4, '2026-01-10', 48000, 'Online'),
(5, 5, '2026-01-13', 48000, 'Cheque'),
(6, 6, '2026-01-14', 48000, 'Online'),
(7, 7, '2026-01-15', 40000, 'Cash'),
(8, 1, '2026-06-01', 45000, 'Online');


-- ============================================================
-- RECEIPT DATA
-- ============================================================

INSERT INTO Receipt
(Receipt_ID, Payment_ID, Receipt_Date)
VALUES
(1, 1, '2026-01-10'),
(2, 2, '2026-01-11'),
(3, 3, '2026-01-12'),
(4, 4, '2026-01-10'),
(5, 5, '2026-01-13'),
(6, 6, '2026-01-14'),
(7, 7, '2026-01-15');


-- ============================================================
-- VERIFY SAMPLE DATA
-- ============================================================

SELECT * FROM Hostel;
SELECT * FROM Staff;
SELECT * FROM Room;
SELECT * FROM Bed;
SELECT * FROM Student;
SELECT * FROM Student_Phone;
SELECT * FROM Facility;
SELECT * FROM Uses;
SELECT * FROM Allocation;
SELECT * FROM Payment;
SELECT * FROM Receipt;


-- ============================================================
-- ============================================================
-- PART A - DML AND SET OPERATIONS
-- QUESTIONS 1 TO 10
-- ============================================================
-- ============================================================


-- ============================================================
-- PART A - Q1
-- Insert new student Kabir S. Oberoi
-- ============================================================

INSERT INTO Student
(Student_ID, First_Name, Middle_Name, Last_Name, Gender, DOB, Email)
VALUES
(9, 'Kabir', 'S', 'Oberoi', 'Male', '2005-08-19',
 'kabir.oberoi@pes.edu');


-- ============================================================
-- PART A - Q2
-- Insert both phone numbers for Kabir in a single INSERT
-- ============================================================

INSERT INTO Student_Phone
(Student_ID, Phone_Number)
VALUES
(9, '9876500009'),
(9, '9876500019');


-- ============================================================
-- PART A - Q3
-- Insert three facility usage events in a single INSERT
-- ============================================================

INSERT INTO Uses
(Student_ID, Facility_ID, Usage_Date)
VALUES
(9, 1, '2026-08-22'),
(9, 5, '2026-08-23'),
(5, 3, '2026-08-22');


-- ============================================================
-- PART A - Q4
-- Increase salary of every Warden by 10%
-- ============================================================

UPDATE Staff
SET Salary = Salary * 1.10
WHERE Designation = 'Warden';


-- ============================================================
-- PART A - Q5
-- Rohan checks out of Room 102, Hostel 1.
-- Close current allocation and free Bed 1.
-- ============================================================

UPDATE Allocation
SET Check_out_Date = '2026-08-20'
WHERE Student_ID = 3
  AND Hostel_ID = 1
  AND Room_Number = 102
  AND Check_out_Date IS NULL;


UPDATE Bed
SET Status = 'Vacant'
WHERE Hostel_ID = 1
  AND Room_Number = 102
  AND Bed_Number = 1;


-- ============================================================
-- PART A - Q6
-- Add Kabir's payment and corresponding receipt
-- ============================================================

INSERT INTO Payment
(Payment_ID, Student_ID, Payment_Date, Amount, Payment_Type)
VALUES
(9, 9, '2026-08-22', 45000, 'Online');


INSERT INTO Receipt
(Receipt_ID, Payment_ID, Receipt_Date)
VALUES
(8, 9, '2026-08-22');


-- ============================================================
-- PART A - Q7
-- Delete every payment without a matching receipt
-- Use a subquery; do not hard-code Payment_ID
-- ============================================================

DELETE FROM Payment
WHERE Payment_ID NOT IN
(
    SELECT Payment_ID
    FROM Receipt
);


-- ============================================================
-- PART A - Q8
-- UNION ALL:
-- Staff working in Hostel 1
-- + students currently allocated to Hostel 1
-- ============================================================

SELECT
    Staff_Name AS Name,
    'Staff' AS Role
FROM Staff
WHERE Hostel_ID = 1

UNION ALL

SELECT
    CONCAT(First_Name, ' ', Last_Name) AS Name,
    'Student' AS Role
FROM Student
JOIN Allocation
    ON Student.Student_ID = Allocation.Student_ID
WHERE Allocation.Hostel_ID = 1
  AND Allocation.Check_out_Date IS NULL;


-- ============================================================
-- PART A - Q9
-- INTERSECT:
-- Students who have both made a payment
-- and used at least one facility
-- ============================================================

SELECT Student_ID
FROM Payment

INTERSECT

SELECT Student_ID
FROM Uses;


-- ============================================================
-- PART A - Q10
-- EXCEPT:
-- Students who have never made a payment
-- ============================================================

SELECT Student_ID
FROM Student

EXCEPT

SELECT Student_ID
FROM Payment;


-- ============================================================
-- ============================================================
-- PART B - JOIN QUERIES
-- QUESTIONS 1 TO 12
-- ============================================================
-- ============================================================


-- ============================================================
-- PART B - Q1
-- List students with active allocation,
-- hostel name and room number
-- ============================================================

SELECT
    s.Student_ID,
    s.First_Name,
    s.Middle_Name,
    s.Last_Name,
    h.Hostel_Name,
    a.Room_Number
FROM Student s
INNER JOIN Allocation a
    ON s.Student_ID = a.Student_ID
INNER JOIN Hostel h
    ON a.Hostel_ID = h.Hostel_ID
WHERE a.Check_out_Date IS NULL;


-- ============================================================
-- PART B - Q2
-- Self JOIN:
-- List staff members and their supervisors
-- ============================================================

SELECT
    s.Staff_ID,
    s.Staff_Name AS Staff_Name,
    sup.Staff_Name AS Supervisor_Name
FROM Staff s
LEFT JOIN Staff sup
    ON s.Supervisor_ID = sup.Staff_ID
ORDER BY s.Staff_ID;


-- ============================================================
-- PART B - Q3
-- List every payment with student name
-- and corresponding receipt number, if available
-- ============================================================

SELECT
    p.Payment_ID,
    CONCAT(s.First_Name, ' ', s.Last_Name) AS Student_Name,
    p.Payment_Date,
    p.Amount,
    p.Payment_Type,
    r.Receipt_ID
FROM Payment p
INNER JOIN Student s
    ON p.Student_ID = s.Student_ID
LEFT JOIN Receipt r
    ON p.Payment_ID = r.Payment_ID
ORDER BY p.Payment_ID;


-- ============================================================
-- PART B - Q4
-- Find students who have never used any facility
-- ============================================================

SELECT
    s.Student_ID,
    s.First_Name,
    s.Middle_Name,
    s.Last_Name,
    s.Email
FROM Student s
LEFT JOIN Uses u
    ON s.Student_ID = u.Student_ID
WHERE u.Student_ID IS NULL
ORDER BY s.Student_ID;


-- ============================================================
-- PART B - Q5
-- Count current residents for every hostel
-- Include hostels with zero residents
-- ============================================================

SELECT
    h.Hostel_ID,
    h.Hostel_Name,
    COUNT(a.Student_ID) AS Current_Residents
FROM Hostel h
LEFT JOIN Allocation a
    ON h.Hostel_ID = a.Hostel_ID
    AND a.Check_out_Date IS NULL
GROUP BY
    h.Hostel_ID,
    h.Hostel_Name
ORDER BY h.Hostel_ID;


-- ============================================================
-- PART B - Q6
-- List every facility usage record:
-- Facility name, student name, usage date
-- Ordered by facility and date
-- ============================================================

SELECT
    f.Facility_Name,
    CONCAT(s.First_Name, ' ', s.Last_Name) AS Student_Name,
    u.Usage_Date
FROM Uses u
INNER JOIN Facility f
    ON u.Facility_ID = f.Facility_ID
INNER JOIN Student s
    ON u.Student_ID = s.Student_ID
ORDER BY
    f.Facility_Name,
    u.Usage_Date;


-- ============================================================
-- PART B - Q7
-- For every room, count currently vacant beds
-- ============================================================

SELECT
    r.Hostel_ID,
    r.Room_Number,
    COUNT(
        CASE
            WHEN b.Status = 'Vacant' THEN 1
        END
    ) AS Vacant_Beds
FROM Room r
LEFT JOIN Bed b
    ON r.Hostel_ID = b.Hostel_ID
    AND r.Room_Number = b.Room_Number
GROUP BY
    r.Hostel_ID,
    r.Room_Number
ORDER BY
    r.Hostel_ID,
    r.Room_Number;


-- ============================================================
-- PART B - Q8
-- List every staff member with hostel name and location
-- ============================================================

SELECT
    s.Staff_ID,
    s.Staff_Name,
    h.Hostel_Name,
    h.Location
FROM Staff s
INNER JOIN Hostel h
    ON s.Hostel_ID = h.Hostel_ID
ORDER BY s.Staff_ID;


-- ============================================================
-- PART B - Q9
-- Total fee revenue collected from
-- currently-residing students of each hostel
-- ============================================================

SELECT
    h.Hostel_ID,
    h.Hostel_Name,
    COALESCE(SUM(p.Amount), 0) AS Total_Fee_Revenue
FROM Hostel h
LEFT JOIN Allocation a
    ON h.Hostel_ID = a.Hostel_ID
    AND a.Check_out_Date IS NULL
LEFT JOIN Payment p
    ON a.Student_ID = p.Student_ID
GROUP BY
    h.Hostel_ID,
    h.Hostel_Name
ORDER BY h.Hostel_ID;


-- ========================================
-- PART B - Q10
-- Count how many times each facility has been used
-- Include facilities with zero usage

SELECT
    f.Facility_ID,
    f.Facility_Name,
    COUNT(u.Student_ID) AS Usage_Count
FROM Facility f
LEFT JOIN Uses u
    ON f.Facility_ID = u.Facility_ID
GROUP BY
    f.Facility_ID,
    f.Facility_Name
ORDER BY f.Facility_ID;


-- ============================================================
-- PART B - Q11
-- RIGHT JOIN:
-- List all facilities with their hostel name
-- ============================================================

SELECT
    f.Facility_ID,
    f.Facility_Name,
    h.Hostel_Name
FROM Hostel h
RIGHT JOIN Facility f
    ON h.Hostel_ID = f.Hostel_ID
ORDER BY f.Facility_ID;


-- =====================================================
-- PART B - Q12
-- LEFT JOIN:
-- List all students with their current room number
-- Include students without a current allocation

SELECT
    s.First_Name,
    s.Last_Name,
    s.Email,
    a.Room_Number
FROM Student s
LEFT JOIN Allocation a
    ON s.Student_ID = a.Student_ID
    AND a.Check_out_Date IS NULL
ORDER BY s.Student_ID;


-- END OF DBMS WEEK 5 LAB