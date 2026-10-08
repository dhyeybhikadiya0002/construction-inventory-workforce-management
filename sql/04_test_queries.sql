--Test
SELECT TRIGGER_NAME, TABLE_NAME, TRIGGERING_EVENT, TRIGGER_TYPE, STATUS
FROM USER_TRIGGERS
ORDER BY TABLE_NAME, TRIGGER_NAME;

--Material_View
SELECT * FROM Material_View;

--Insert
INSERT INTO Material_View (
    MaterialID, Name, Description, Type, Unit, WarehouseID, Quantity
) VALUES (
    1, 'Cement', 'Grey cement', 'Construction', 'kg', 1, 300
);

--Update
UPDATE Material_View
SET Quantity = 450
WHERE MaterialID = 1;

--Delete
DELETE FROM Material_View
WHERE MaterialID = 1;


--Check History Table
SELECT * FROM MaterialQuantityHistory
WHERE MaterialID = 1
ORDER BY StartDate;


--WorkerType_view
SELECT * FROM WorkerType_View;

--Insert
INSERT INTO WorkerType_View (
    EmployeeID, EmployeeName, EmploymentType
) VALUES (
    1, 'Amit Singh', 'Full-Time'
);

--Update
UPDATE WorkerType_View
SET EmploymentType = 'Contractor'
WHERE EmployeeID = 1;

--Delete
DELETE FROM WorkerType_View
WHERE EmployeeID = 1;

--History table 
SELECT * FROM WorkerTypeHistory
WHERE EmployeeID = 1
ORDER BY StartDate;



--ProjectEmployee_view
SELECT * FROM ProjectEmployee;
SELECT * FROM ProjectEmployee_View;

DESC ProjectEmployee_View;
SELECT ProjectID, EmployeeID FROM ProjectEmployee_View
WHERE ProjectName = 'House A' AND EmployeeName = 'Ashish Sharma';


--insert
INSERT INTO ProjectEmployee_View (
    ProjectName, EmployeeName, StartDate, Role
) VALUES (
    'House A', 'Ashish Sharma', SYSDATE, 'Engineer'
);

--Update
UPDATE ProjectEmployee_View
SET Role = 'Supervisor'
WHERE ProjectName = 'House A' AND EmployeeName = 'Ashish Sharma';


--Delete
DELETE FROM ProjectEmployee_View
WHERE ProjectName = 'House A' AND EmployeeName = 'Ashish Sharma';

--History
SELECT * FROM ProjectEmployeeHistory
WHERE ProjectID = (SELECT ProjectID FROM Project WHERE ProjectName = 'House A')
  AND EmployeeID = (SELECT EmployeeID FROM Employee WHERE Name = 'Ashish Sharma')
ORDER BY StartDate;


--Tracking_View
SELECT * FROM Tracking_View;
SELECT * FROM TrackingHistory ORDER BY HistoryID;
SELECT * FROM TrackingStatus;

--Insert
INSERT INTO Tracking_View (
    TrackingID, OrderID, TrackingStatus, TrackingNumber, ShippedDate, DeliveryDate
) VALUES (
    3, 1, 'Pending', 'NEW123456', TO_DATE('2025-08-01', 'YYYY-MM-DD'), NULL
);

--Update
UPDATE Tracking_View
SET TrackingStatus = 'In Transit',
    TrackingNumber = 'NEW123456-UPD',
    ShippedDate = TO_DATE('2025-08-02', 'YYYY-MM-DD')
WHERE TrackingID = 3;

--Delete
DELETE FROM Tracking_View WHERE TrackingID = 3;

SELECT * FROM TrackingHistory;



--Order_View
-- List all triggers related to Order_View
SELECT TRIGGER_NAME, TABLE_NAME, TRIGGERING_EVENT, TRIGGER_TYPE, STATUS
FROM USER_TRIGGERS
WHERE TABLE_NAME IN ('ORDER_VIEW', 'ORDERSTATUSHISTORY')
ORDER BY TABLE_NAME, TRIGGER_NAME;

-- See current order view
SELECT * FROM Order_View;

-- Insert into Order_View
SELECT * FROM OrderTable;

INSERT INTO Order_View (
    OrderID, ProjectID, SupplierID, OrderDate, DeliveryDate, TotalCost, Status
) VALUES (
    225, 1, 1, TO_DATE('2024-04-10', 'YYYY-MM-DD'), TO_DATE('2024-04-20', 'YYYY-MM-DD'), 1200.00, 'Pending'
);

SELECT * FROM OrderStatusHistory
WHERE OrderID = 25;
--Update
UPDATE Order_View
SET TotalCost = 1400,
    Status = 'Delivered'
WHERE OrderID = 225;

SELECT * FROM OrderStatusHistory
WHERE OrderID = 225;
--Delete
DELETE FROM Order_View
WHERE OrderID = 225;

--History
SELECT * FROM OrderStatusHistory
WHERE OrderID = 225
ORDER BY StartDate;



