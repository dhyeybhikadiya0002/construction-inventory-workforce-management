--Order Table
-- Step 1: Drop old column from Order
ALTER TABLE OrderTable
DROP COLUMN Status;

-- 1. Create the OrderStatus master table 
CREATE TABLE OrderStatus (
    StatusID INT PRIMARY KEY,
    StatusName VARCHAR2(50)
);

-- 2. Insert initial statuses
INSERT INTO OrderStatus VALUES (1, 'Ordered');
INSERT INTO OrderStatus VALUES (2, 'Shipped');
INSERT INTO OrderStatus VALUES (3, 'Delivered');
INSERT INTO OrderStatus VALUES (4, 'Cancelled');

-- 3. Create OrderStatusHistory table to track status changes over time
CREATE TABLE OrderStatusHistory (
    HistoryID INT PRIMARY KEY,
    OrderID INT,
    StatusID INT,
    StartDate DATE,
    EndDate DATE,
    Notes VARCHAR2(100),
    FOREIGN KEY (OrderID) REFERENCES OrderTable(OrderID),
    FOREIGN KEY (StatusID) REFERENCES OrderStatus(StatusID)
);

-- 4. Insert sample historical data for 4 orders 
INSERT INTO OrderStatusHistory VALUES (1, 1, 1, TO_DATE('2024-01-01','YYYY-MM-DD'), NULL, 'Order placed');
INSERT INTO OrderStatusHistory VALUES (2, 2, 2, TO_DATE('2024-02-10','YYYY-MM-DD'), NULL, 'Shipped to site');
INSERT INTO OrderStatusHistory VALUES (3, 3, 3, TO_DATE('2024-03-15','YYYY-MM-DD'), NULL, 'Delivered');
INSERT INTO OrderStatusHistory VALUES (4, 4, 4, TO_DATE('2024-04-01','YYYY-MM-DD'), NULL, 'Order cancelled');

-- 5. Create a sequence for auto-generating HistoryID
CREATE SEQUENCE ORDERSTATUSHISTORY_SEQ START WITH 5 INCREMENT BY 1;

-- 6. Create a view that combines OrderTable with the current status from history
-- Existing view can be replaced using CREATE OR REPLACE VIEW Order_View.
CREATE OR REPLACE VIEW Order_View AS
SELECT
    H.HistoryID,
    O.OrderID,
    O.ProjectID,
    O.SupplierID,
    O.OrderDate,
    O.DeliveryDate,
    O.TotalCost,
    S.StatusName AS Status,
    H.StartDate,
    H.EndDate,
    H.Notes
FROM
    OrderTable O
    JOIN OrderStatusHistory H ON O.OrderID = H.OrderID
    JOIN OrderStatus S ON H.StatusID = S.StatusID
WHERE
    H.EndDate IS NULL;


CREATE OR REPLACE TRIGGER trg_insert_order_view
INSTEAD OF INSERT ON Order_View
FOR EACH ROW
DECLARE
    v_status_id INT;
BEGIN
   
    INSERT INTO OrderTable (
        OrderID, ProjectID, SupplierID, OrderDate, DeliveryDate, TotalCost
    ) VALUES (
        :NEW.OrderID, :NEW.ProjectID, :NEW.SupplierID,
        :NEW.OrderDate, :NEW.DeliveryDate, :NEW.TotalCost
    );


    SELECT StatusID INTO v_status_id
    FROM OrderStatus
    WHERE StatusName = :NEW.Status;

   
    INSERT INTO OrderStatusHistory (
        HistoryID, OrderID, StatusID, StartDate, EndDate, Notes
    ) VALUES (
        ORDERSTATUSHISTORY_SEQ.NEXTVAL,
        :NEW.OrderID,
        v_status_id,
        SYSDATE,
        NULL,
        'Inserted via view'
    );
END;
/


CREATE OR REPLACE TRIGGER trg_update_order_view
INSTEAD OF UPDATE ON Order_View
FOR EACH ROW
DECLARE
    v_status_id INT;
BEGIN
    -- Update OrderTable
    UPDATE OrderTable
    SET ProjectID = :NEW.ProjectID,
        SupplierID = :NEW.SupplierID,
        OrderDate = :NEW.OrderDate,
        DeliveryDate = :NEW.DeliveryDate,
        TotalCost = :NEW.TotalCost
    WHERE OrderID = :OLD.OrderID;

  
    IF :OLD.Status != :NEW.Status THEN
       
        UPDATE OrderStatusHistory
        SET EndDate = SYSDATE
        WHERE OrderID = :OLD.OrderID AND EndDate IS NULL;

       
        SELECT StatusID INTO v_status_id
        FROM OrderStatus
        WHERE StatusName = :NEW.Status;

        -- Insert new history record
        INSERT INTO OrderStatusHistory (
            HistoryID, OrderID, StatusID, StartDate, EndDate, Notes
        ) VALUES (
            ORDERSTATUSHISTORY_SEQ.NEXTVAL, :NEW.OrderID, v_status_id, SYSDATE, NULL, 'Updated via view'
        );
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_delete_order_view
INSTEAD OF DELETE ON Order_View
FOR EACH ROW
BEGIN
  -- Only close the history record; do NOT delete from OrderTable
  UPDATE OrderStatusHistory
  SET EndDate = SYSDATE,
      Notes = 'Deleted via view'
  WHERE OrderID = :OLD.OrderID
    AND EndDate IS NULL;
END;
/


--Material Table

-- Step 1: Drop the old column from Material if it exists
ALTER TABLE Material DROP COLUMN QuantityInStock;

-- Step 2: Create the MaterialQuantityHistory table
CREATE TABLE MaterialQuantityHistory (
    HistoryID INT PRIMARY KEY,
    MaterialID INT,
    Quantity INT,
    StartDate DATE,
    EndDate DATE,
    Notes VARCHAR2(100),
    FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
);

-- Step 3: Insert sample historical data
INSERT INTO MaterialQuantityHistory VALUES (1, 1, 100, TO_DATE('2024-01-01','YYYY-MM-DD'), NULL, 'Initial stock');
INSERT INTO MaterialQuantityHistory VALUES (2, 2, 500, TO_DATE('2024-02-15','YYYY-MM-DD'), NULL, 'Restocked');

-- Step 4: Create the Material_View to show current quantity
-- Existing view can be replaced using CREATE OR REPLACE VIEW Material_View.
CREATE OR REPLACE VIEW Material_View AS
SELECT
    H.HistoryID,
    M.MaterialID,
    M.Name,
    M.Description,
    M.Type,
    M.Unit,
    M.WarehouseID,  
    H.Quantity,
    H.StartDate,
    H.EndDate,
    H.Notes
FROM
    Material M
    JOIN MaterialQuantityHistory H ON M.MaterialID = H.MaterialID
WHERE
    H.EndDate IS NULL;


-- Step 5: Create a sequence for HistoryID
CREATE SEQUENCE MaterialQuantityHistory_seq START WITH 3;

-- Step 6: INSTEAD OF INSERT Trigger
CREATE OR REPLACE TRIGGER trg_insert_material_view
INSTEAD OF INSERT ON Material_View
FOR EACH ROW
BEGIN
    INSERT INTO MaterialQuantityHistory (
        HistoryID, MaterialID, Quantity, StartDate, EndDate, Notes
    )
    VALUES (
        MaterialQuantityHistory_seq.NEXTVAL,
        :NEW.MaterialID,
        :NEW.Quantity,
        SYSDATE,
        NULL,
        'Inserted via view'
    );
END;
/

-- Step 7: INSTEAD OF UPDATE Trigger
CREATE OR REPLACE TRIGGER trg_update_material_view
INSTEAD OF UPDATE ON Material_View
FOR EACH ROW
BEGIN
  
   
        UPDATE MaterialQuantityHistory
        SET EndDate = SYSDATE
        WHERE MaterialID = :OLD.MaterialID
          AND EndDate IS NULL;

        INSERT INTO MaterialQuantityHistory (
            HistoryID, MaterialID, Quantity, StartDate, EndDate, Notes
        )
        VALUES (
            MaterialQuantityHistory_seq.NEXTVAL,
            :NEW.MaterialID,
            :NEW.Quantity,
            SYSDATE,
            NULL,
            'Updated via view'
        );
   
END;
/

-- Step 8: INSTEAD OF DELETE Trigger
CREATE OR REPLACE TRIGGER trg_delete_material_view
INSTEAD OF DELETE ON Material_View
FOR EACH ROW
BEGIN
    -- End the current active record
    UPDATE MaterialQuantityHistory
    SET EndDate = SYSDATE,
        Notes = 'Deleted via view'
    WHERE MaterialID = :OLD.MaterialID
      AND EndDate IS NULL;
END;
/



--WorkerType Table
-- Step 1: Drop the old column from WorkerType
ALTER TABLE WorkerType
DROP COLUMN EmploymentType;

-- Step 2: Create normalized table to store employment types
CREATE TABLE EmploymentType (
    TypeID INT PRIMARY KEY,
    TypeName VARCHAR2(50)
);

-- Step 3: Add some values
INSERT INTO EmploymentType VALUES (1, 'Full-Time');
INSERT INTO EmploymentType VALUES (2, 'Part-Time');
INSERT INTO EmploymentType VALUES (3, 'Contractor');

-- Step 4: Create the association table for tracking historical changes
CREATE TABLE WorkerTypeHistory (
    HistoryID INT PRIMARY KEY,
    EmployeeID INT,
    TypeID INT,
    StartDate DATE,
    EndDate DATE,
    Notes VARCHAR2(100),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (TypeID) REFERENCES EmploymentType(TypeID)
);

-- Step 5: Insert sample historical data
INSERT INTO WorkerTypeHistory VALUES (1, 1, 1, TO_DATE('2023-01-01','YYYY-MM-DD'), NULL, 'Full-time since joining');
INSERT INTO WorkerTypeHistory VALUES (2, 2, 3, TO_DATE('2024-03-01','YYYY-MM-DD'), NULL, 'Hired as contractor');

-- Step 6: Create a view to show current employment type
-- Existing view can be replaced using CREATE OR REPLACE VIEW WorkerType_View.
CREATE OR REPLACE VIEW WorkerType_View AS
SELECT
    H.HistoryID,
    E.EmployeeID,
    E.Name AS EmployeeName,
    T.TypeName AS EmploymentType,
    H.StartDate,
    H.EndDate,
    H.Notes
FROM
    Employee E
    JOIN WorkerTypeHistory H ON E.EmployeeID = H.EmployeeID
    JOIN EmploymentType T ON H.TypeID = T.TypeID
WHERE
    H.EndDate IS NULL;


-- Step 7: Create sequence and trigger for inserting into view
CREATE SEQUENCE WorkerTypeHistory_seq START WITH 3;

--Trigger INSERT
CREATE OR REPLACE TRIGGER trg_insert_worker_view
INSTEAD OF INSERT ON WorkerType_View
FOR EACH ROW
BEGIN
    INSERT INTO WorkerTypeHistory (
        HistoryID, EmployeeID, TypeID, StartDate, EndDate, Notes
    )
    VALUES (
        WorkerTypeHistory_seq.NEXTVAL,
        :NEW.EmployeeID,
        (SELECT TypeID FROM EmploymentType WHERE TypeName = :NEW.EmploymentType),
        SYSDATE,
        NULL,
        'Inserted via view'
    );
END;
/

--Trigger UPDATE
CREATE OR REPLACE TRIGGER trg_update_workertype_view
INSTEAD OF UPDATE ON WorkerType_View
FOR EACH ROW
BEGIN
    UPDATE WorkerTypeHistory
    SET EndDate = SYSDATE
    WHERE EmployeeID = :OLD.EmployeeID AND EndDate IS NULL;

    INSERT INTO WorkerTypeHistory (
        HistoryID, EmployeeID, TypeID, StartDate, EndDate, Notes
    )
    VALUES (
        WorkerTypeHistory_Seq.NEXTVAL,
        :NEW.EmployeeID,
        (SELECT TypeID FROM EmploymentType WHERE TypeName = :NEW.EmploymentType),
        SYSDATE,
        NULL,
        'Updated via view'
    );
END;
/

--Trigger DELETE
CREATE OR REPLACE TRIGGER trg_delete_workertype_view
INSTEAD OF DELETE ON WorkerType_View
FOR EACH ROW
BEGIN
  -- Delete from WorkerType table
  DELETE FROM WorkerType
  WHERE EmployeeID = :OLD.EmployeeID;

  -- Close current history record
  UPDATE WorkerTypeHistory
  SET EndDate = SYSDATE, Notes = 'Deleted via view'
  WHERE EmployeeID = :OLD.EmployeeID AND EndDate IS NULL;
END;
/





-- ProjectEmployee Table

-- STEP 1: Create the Role Lookup Table
CREATE TABLE EmployeeRole (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR2(50)
);

-- STEP 2: Insert Sample Roles
INSERT INTO EmployeeRole VALUES (1, 'Manager');
INSERT INTO EmployeeRole VALUES (2, 'Supervisor');
INSERT INTO EmployeeRole VALUES (3, 'Engineer');
INSERT INTO EmployeeRole VALUES (4, 'Architect');

-- STEP 3: Create Historical Table
CREATE TABLE ProjectEmployeeHistory (
    HistoryID INT PRIMARY KEY,
    ProjectID INT,
    EmployeeID INT,
    RoleID INT,
    StartDate DATE,
    EndDate DATE,
    Notes VARCHAR2(100),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (RoleID) REFERENCES EmployeeRole(RoleID)
);

-- STEP 4: Create a View to Represent Current Assignment
-- Existing view can be replaced using CREATE OR REPLACE VIEW ProjectEmployee_View.
CREATE OR REPLACE VIEW ProjectEmployee_View AS
SELECT
    h.HistoryID,
    h.ProjectID,
    h.EmployeeID,
    p.Name AS ProjectName,
    e.Name AS EmployeeName,
    r.RoleName AS Role,
    h.StartDate,
    h.EndDate,
    h.Notes
FROM
    ProjectEmployeeHistory h
    JOIN Project p ON h.ProjectID = p.ProjectID
    JOIN Employee e ON h.EmployeeID = e.EmployeeID
    JOIN EmployeeRole r ON h.RoleID = r.RoleID
WHERE
    h.EndDate IS NULL;


-- STEP 5: Create a Sequence for HistoryID
CREATE SEQUENCE ProjectEmployeeHistory_seq START WITH 100;

-- STEP 6: Trigger for INSERT
CREATE OR REPLACE TRIGGER trg_insert_projectemployee_view
INSTEAD OF INSERT ON ProjectEmployee_View
FOR EACH ROW
BEGIN
    INSERT INTO ProjectEmployeeHistory (
        HistoryID, ProjectID, EmployeeID, RoleID, StartDate, EndDate, Notes
    )
    VALUES (
        ProjectEmployeeHistory_seq.NEXTVAL,
        :NEW.ProjectID,
        :NEW.EmployeeID,
        (SELECT RoleID FROM EmployeeRole WHERE RoleName = :NEW.Role),
        :NEW.StartDate,
        NULL,
        'Inserted via view'
    );
END;
/

-- STEP 7: Trigger for UPDATE
CREATE OR REPLACE TRIGGER trg_update_projectemployee_view
INSTEAD OF UPDATE ON ProjectEmployee_View
FOR EACH ROW
BEGIN
   
    UPDATE ProjectEmployeeHistory
    SET EndDate = SYSDATE,
        Notes = 'Updated via view'
    WHERE ProjectID = :OLD.ProjectID AND EmployeeID = :OLD.EmployeeID AND EndDate IS NULL;

 
    INSERT INTO ProjectEmployeeHistory (
        HistoryID, ProjectID, EmployeeID, RoleID, StartDate, EndDate, Notes
    )
    VALUES (
        ProjectEmployeeHistory_seq.NEXTVAL,
        :NEW.ProjectID,
        :NEW.EmployeeID,
        (SELECT RoleID FROM EmployeeRole WHERE RoleName = :NEW.Role),
        :NEW.StartDate,
        NULL,
        'Updated via view'
    );
END;
/

-- STEP 8: Trigger for DELETE
CREATE OR REPLACE TRIGGER trg_delete_projectemployee_view
INSTEAD OF DELETE ON ProjectEmployee_View
FOR EACH ROW
BEGIN
    UPDATE ProjectEmployeeHistory
    SET EndDate = SYSDATE,
        Notes = 'Deleted via view'
    WHERE ProjectID = :OLD.ProjectID AND EmployeeID = :OLD.EmployeeID AND EndDate IS NULL;
END;
/



--Tracking Table


-- Step 1: Drop old column from Tracking (if exists)
ALTER TABLE Tracking DROP COLUMN Status;

-- Step 2: Create TrackingStatus master table
CREATE TABLE TrackingStatus (
    StatusID INT PRIMARY KEY,
    StatusName VARCHAR2(50)
);

-- Step 3: Insert status values
INSERT INTO TrackingStatus VALUES (1, 'Pending');
INSERT INTO TrackingStatus VALUES (2, 'In Transit');
INSERT INTO TrackingStatus VALUES (3, 'Delivered');

-- Step 4: Create TrackingHistory table
CREATE TABLE TrackingHistory (
    HistoryID INT PRIMARY KEY,
    TrackingID INT,
    StatusID INT,
    TrackingNumber VARCHAR2(50),
    ShippedDate DATE,
    DeliveryDate DATE,
    StartDate DATE,
    EndDate DATE,
    Notes VARCHAR2(100),
    FOREIGN KEY (TrackingID) REFERENCES Tracking(TrackingID),
    FOREIGN KEY (StatusID) REFERENCES TrackingStatus(StatusID)
);

-- Step 5: Insert sample history data
INSERT INTO TrackingHistory VALUES (1, 1, 3, 'FDX12345', TO_DATE('2024-01-07','YYYY-MM-DD'), TO_DATE('2024-01-10','YYYY-MM-DD'), TO_DATE('2024-01-07','YYYY-MM-DD'), NULL, 'Delivered');
INSERT INTO TrackingHistory VALUES (2, 2, 1, 'UPS23456', NULL, NULL, TO_DATE('2024-01-10','YYYY-MM-DD'), NULL, 'Order created');

-- Step 6: Create view to show current tracking status
CREATE OR REPLACE VIEW Tracking_View AS
SELECT
    t.TrackingID,
    o.OrderID,
    s.StatusName AS TrackingStatus,
    h.TrackingNumber,
    h.ShippedDate,
    h.DeliveryDate
FROM Tracking t
JOIN OrderTable o ON t.OrderID = o.OrderID
JOIN TrackingHistory h ON t.TrackingID = h.TrackingID
JOIN TrackingStatus s ON h.StatusID = s.StatusID
WHERE h.EndDate IS NULL;

-- Step 7: Create sequence for TrackingHistory
CREATE SEQUENCE TrackingHistory_seq START WITH 3 INCREMENT BY 1;

-- Step 8: INSTEAD OF INSERT trigger
CREATE OR REPLACE TRIGGER trg_insert_tracking_view
INSTEAD OF INSERT ON Tracking_View
FOR EACH ROW
BEGIN
    INSERT INTO TrackingHistory (
        HistoryID, TrackingID, StatusID, TrackingNumber,
        ShippedDate, DeliveryDate, StartDate, EndDate, Notes
    )
    VALUES (
        TrackingHistory_seq.NEXTVAL,
        :NEW.TrackingID,
        (SELECT StatusID FROM TrackingStatus WHERE StatusName = :NEW.TrackingStatus),
        :NEW.TrackingNumber,
        :NEW.ShippedDate,
        :NEW.DeliveryDate,
        SYSDATE,
        NULL,
        'Inserted via view'
    );
END;
/

-- Step 9: INSTEAD OF UPDATE trigger
CREATE OR REPLACE TRIGGER trg_update_tracking_view
INSTEAD OF UPDATE ON Tracking_View
FOR EACH ROW
BEGIN
    
    UPDATE TrackingHistory
    SET EndDate = SYSDATE
    WHERE TrackingID = :OLD.TrackingID AND EndDate IS NULL;


    INSERT INTO TrackingHistory (
        HistoryID, TrackingID, StatusID, TrackingNumber,
        ShippedDate, DeliveryDate, StartDate, EndDate, Notes
    )
    VALUES (
        TrackingHistory_seq.NEXTVAL,
        :NEW.TrackingID,
        (SELECT StatusID FROM TrackingStatus WHERE StatusName = :NEW.TrackingStatus),
        :NEW.TrackingNumber,
        :NEW.ShippedDate,
        :NEW.DeliveryDate,
        SYSDATE,
        NULL,
        'Updated via view'
    );
END;
/

-- Step 10: INSTEAD OF DELETE trigger
CREATE OR REPLACE TRIGGER trg_delete_tracking_view
INSTEAD OF DELETE ON Tracking_View
FOR EACH ROW
BEGIN
    
    UPDATE TrackingHistory
    SET EndDate = SYSDATE, Notes = 'Deleted via view'
    WHERE TrackingID = :OLD.TrackingID AND EndDate IS NULL;

    

END;
/










    


