
--DBMSLAB6 - NESTED AND CORRELATED QUERIES
--SMART HOSTEL MANAGEMENT SYSTEM - A CASE STUDY
--Name: Mohammadnoor Sirasgi
--  Section: K
-- SRN: PES2UG25CS812
--  FILE: PES2UG25CS812_NestedCorrelated_Lab06.sql

USE smart_hostel;

-- TASK 1 : NESTED (NON-CORRELATED) QUERIES
-- Task 1.1
SELECT Hostel_ID, Hostel_Name, Capacity
FROM HOSTEL
WHERE Capacity > (SELECT AVG(Capacity) FROM HOSTEL);

-- Task 1.2
SELECT Student_ID, First_Name, Last_Name
FROM STUDENT
WHERE Student_ID IN (
    SELECT Student_ID
    FROM PAYMENT
    WHERE Amount = (SELECT MAX(Amount) FROM PAYMENT)
);


-- Task 1.3
SELECT DISTINCT Student_ID, First_Name, Last_Name
FROM STUDENT
WHERE Student_ID IN (
    SELECT Student_ID
    FROM PAYMENT
    WHERE Amount > (SELECT AVG(Amount) FROM PAYMENT)
);


-- Task 1.4
SELECT Staff_ID, Name, Designation, Salary
FROM STAFF
WHERE Salary > (SELECT AVG(Salary) FROM STAFF);


-- Task 1.5
SELECT Student_ID, First_Name, Last_Name
FROM STUDENT
WHERE Student_ID IN (
    SELECT Student_ID
    FROM ALLOCATE
    WHERE Hostel_ID IN (
        SELECT Hostel_ID
        FROM HOSTEL
        WHERE Capacity = (SELECT MAX(Capacity) FROM HOSTEL)
    )
);


-- Task 1.6
SELECT Student_ID, First_Name, Last_Name
FROM STUDENT
WHERE Student_ID NOT IN (
    SELECT Student_ID
    FROM PAYMENT
);


-- Task 1.7
SELECT Staff_ID, Name, Salary, Hostel_ID
FROM STAFF
WHERE Salary > ALL (
    SELECT Salary
    FROM STAFF
    WHERE Hostel_ID = 'H003'
);


-- Task 1.8
SELECT Staff_ID, Name, Salary, Hostel_ID
FROM STAFF
WHERE Salary > ANY (
    SELECT Salary
    FROM STAFF
    WHERE Hostel_ID = 'H004'
);


-- Task 1.9
SELECT Student_ID, First_Name, Last_Name
FROM STUDENT
WHERE Student_ID IN (
    SELECT Student_ID
    FROM PAYMENT
    WHERE Amount = (SELECT MIN(Amount) FROM PAYMENT)
);


-- Task 1.10
SELECT Student_ID, First_Name, Last_Name, Total_Paid
FROM (
    SELECT S.Student_ID, S.First_Name, S.Last_Name,
           SUM(P.Amount) AS Total_Paid
    FROM STUDENT S
    JOIN PAYMENT P ON S.Student_ID = P.Student_ID
    GROUP BY S.Student_ID, S.First_Name, S.Last_Name
) AS Student_Totals
WHERE Total_Paid > (
    SELECT AVG(Total_Paid)
    FROM (
        SELECT SUM(Amount) AS Total_Paid
        FROM PAYMENT
        GROUP BY Student_ID
    ) AS Per_Student_Totals
);


-- Task 1.11
SELECT DISTINCT Student_ID, First_Name, Last_Name
FROM STUDENT
WHERE Student_ID IN (
    SELECT Student_ID
    FROM PAYMENT
    WHERE Amount > (
        SELECT AVG(P.Amount)
        FROM PAYMENT P
        JOIN ALLOCATE A ON P.Student_ID = A.Student_ID
        WHERE A.Hostel_ID = 'H002'
    )
);


-- ==========================================================
-- TASK 2 : CORRELATED QUERIES
-- ==========================================================

-- Task 2.1
SELECT S1.Staff_ID, S1.Name, S1.Salary, S1.Hostel_ID
FROM STAFF S1
WHERE S1.Salary > (
    SELECT AVG(S2.Salary)
    FROM STAFF S2
    WHERE S2.Hostel_ID = S1.Hostel_ID
);


-- Task 2.2
SELECT DISTINCT P1.Student_ID, S.First_Name, S.Last_Name
FROM PAYMENT P1
JOIN STUDENT S ON S.Student_ID = P1.Student_ID
WHERE P1.Amount > (
    SELECT AVG(P2.Amount)
    FROM PAYMENT P2
    WHERE P2.Student_ID = P1.Student_ID
);


-- Task 2.3
SELECT Student_ID, First_Name, Last_Name
FROM STUDENT S
WHERE EXISTS (
    SELECT 1
    FROM PAYMENT P
    WHERE P.Student_ID = S.Student_ID
      AND P.Amount > 30000
);


-- Task 2.4
SELECT Student_ID, First_Name, Last_Name
FROM STUDENT S
WHERE NOT EXISTS (
    SELECT 1
    FROM PAYMENT P
    WHERE P.Student_ID = S.Student_ID
);


-- Task 2.5
SELECT Student_ID, First_Name, Last_Name
FROM STUDENT S
WHERE EXISTS (
    SELECT 1
    FROM USES U
    WHERE U.Student_ID = S.Student_ID
);


-- Task 2.6
SELECT St1.Staff_ID, St1.Name, St1.Salary, St1.Hostel_ID
FROM STAFF St1
WHERE St1.Salary = (
    SELECT MAX(St2.Salary)
    FROM STAFF St2
    WHERE St2.Hostel_ID = St1.Hostel_ID
);


-- Task 2.7
SELECT A1.Hostel_ID, A1.Room_Number, A1.Student_ID
FROM ALLOCATE A1
WHERE (
    SELECT COUNT(*)
    FROM ALLOCATE A2
    WHERE A2.Hostel_ID = A1.Hostel_ID
      AND A2.Room_Number = A1.Room_Number
) > 1;


-- Task 2.8
SELECT S.Student_ID, S.First_Name, S.Last_Name,
       (SELECT COUNT(*) FROM PAYMENT P WHERE P.Student_ID = S.Student_ID) AS Num_Payments
FROM STUDENT S
WHERE (
    SELECT COUNT(*)
    FROM PAYMENT P
    WHERE P.Student_ID = S.Student_ID
) > (
    SELECT AVG(Payment_Count)
    FROM (
        SELECT COUNT(*) AS Payment_Count
        FROM PAYMENT
        GROUP BY Student_ID
    ) AS Per_Student_Counts
)
AND EXISTS (SELECT 1 FROM PAYMENT P WHERE P.Student_ID = S.Student_ID);


-- Task 2.9
SELECT St1.Staff_ID, St1.Name, St1.Salary
FROM STAFF St1
WHERE (
    SELECT COUNT(*)
    FROM STAFF St2
    WHERE St2.Salary = St1.Salary
) = 1
ORDER BY St1.Salary DESC;


-- Task 2.10
SELECT Student_ID, First_Name, Last_Name
FROM STUDENT S
WHERE NOT EXISTS (
    SELECT F.Facility_ID
    FROM USES F
    WHERE F.Student_ID = 'S001'
    AND NOT EXISTS (
        SELECT 1
        FROM USES U
        WHERE U.Student_ID = S.Student_ID
          AND U.Facility_ID = F.Facility_ID
    )
);


-- Task 2.11
SELECT S.Student_ID, S.First_Name, S.Last_Name,
       (SELECT COUNT(*)
        FROM RECEIPT R
        JOIN PAYMENT P ON R.Payment_ID = P.Payment_ID
        WHERE P.Student_ID = S.Student_ID) AS Num_Receipts
FROM STUDENT S
WHERE (
    SELECT COUNT(*)
    FROM RECEIPT R
    JOIN PAYMENT P ON R.Payment_ID = P.Payment_ID
    WHERE P.Student_ID = S.Student_ID
) > 1;

-- ==========================================================
-- END OF FILE - 22 QUERIES (TASK 1: 1.1-1.11, TASK 2: 2.1-2.11)
-- ==========================================================
