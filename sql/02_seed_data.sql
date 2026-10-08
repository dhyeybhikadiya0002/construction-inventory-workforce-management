--Warehouse values--
INSERT INTO Warehouse VALUES (1, 'Ottawa Warehouse', '123 Main St', 'Ottawa', 'ON', 'A1A1A1', '111-111-1111', 'ottawa@warehouse.com', 10000, 'Donald');
INSERT INTO Warehouse VALUES (2, 'Toronto Warehouse', '456 Queen St', 'Toronto', 'ON', 'B1B1B1', '222-222-2222', 'toronto@warehouse.com', 5500, 'Smith');
INSERT INTO Warehouse VALUES (3, 'Vancouver Warehouse', '789 King St', 'Vancouver', 'BC', 'C1C1C1', '333-333-3333', 'vancouver@warehouse.com', 7000, 'Boby');
INSERT INTO Warehouse VALUES (4, 'Montreal Warehouse', '1011 Duke St', 'Montreal', 'QC', 'D1D1D1', '444-444-4444', 'montreal@warehouse.com', 6000, 'Brown');
INSERT INTO Warehouse VALUES (5, 'Calgary Warehouse', '1213 York St', 'Calgary', 'AB', 'E1E1E1', '555-555-5555', 'calgary@warehouse.com', 2000, 'Kaido');
INSERT INTO Warehouse VALUES (6, 'Hamilton Warehouse', '1011 Duke St', 'Hamilton', 'ON', 'D1D1D2', '666-444-4444', 'hamilton@warehouse.com', 6500, 'Chris');
INSERT INTO Warehouse VALUES (7, 'Oakville Warehouse', '1213 York St', 'Oakville', 'ON', 'E1E1E2', '777-555-5555', 'oakville@warehouse.com', 2500, 'Alex');

--Project values--
INSERT INTO Project VALUES (1, 'Condo D', '123 Toronto Lane', 'Toronto', 'ON', 'In Progress', DATE '2024-01-01', DATE '2025-01-01', 6000000.00);
INSERT INTO Project VALUES (2, 'House A', '456 Ottawa St', 'Ottawa', 'ON', 'Planned', DATE '2025-02-01', DATE '2025-09-30', 5000000.00);
INSERT INTO Project VALUES (3, 'Condo L', '789 Vancouver Ave', 'Vancouver', 'BC', 'In Progress', DATE '2023-11-15', DATE '2026-05-15', 20000000.00);
INSERT INTO Project VALUES (4, 'Townhouse E', '1011 Montreal St', 'Montreal', 'QC', 'Not Started', DATE '2024-07-01', DATE '2025-11-30', 650000.00);
INSERT INTO Project VALUES (5, 'House E', '1213 Calgary St', 'Calgary', 'AB', 'Planned', DATE '2025-07-01', DATE '2026-01-31', 6000000.00);
INSERT INTO Project VALUES (6, 'Condo P', '789 Oakville Ave', 'Oakville', 'ON', 'In Progress', DATE '2023-11-15', DATE '2026-05-15', 20000000.00);
INSERT INTO Project VALUES (7, 'Townhouse Z', '1011 Hamilton St', 'Hamilton', 'ON', 'Not Started', DATE '2024-07-01', DATE '2025-11-30', 650000.00);

--Supplier value--
INSERT INTO Supplier VALUES (1, 'ABC Supplies', 'Quin', '905-111-1111', 'abc@supplies.com', '100 Finn Ave', 'Ottawa', 'ON', 'A2A2A1');
INSERT INTO Supplier VALUES (2, 'ABC Materials', 'Dhyey', '905-222-2222', 'abc@materials.com', '200 Finn Ave', 'Toronto', 'ON', 'A2A2A2');
INSERT INTO Supplier VALUES (3, '123 Building Inc', 'Dhyeyye', '905-333-3333', '123@building.com', '300 Finn Ave', 'Vancouver', 'BC', 'A2A2A3');
INSERT INTO Supplier VALUES (4, '123 Bricks', 'Ashish', '905-444-4444', '123@bricks.com', '400 Finn Ave', 'Montreal', 'QC', 'A2A2A4');
INSERT INTO Supplier VALUES (5, 'ABC Concrete', 'Jim', '905-555-5555', 'abc@concrete.com', '500 Finn Ave', 'Calgary', 'AB', 'A2A2A5');
INSERT INTO Supplier VALUES (6, 'XYZ Supplies', 'Max', '905-666-6666', 'xyz@supplies.com', '100 Finn Ave', 'Oakville', 'ON', 'A2A2A6');
INSERT INTO Supplier VALUES (7, 'XYZ Materials', 'Min', '905-777-7777', 'abc@materials.com', '200 Finn Ave', 'Hamilton', 'ON', 'A2A2A7');

--Material Value--
INSERT INTO Material VALUES (1, 'Cement', 'High-strength cement', 'Bags', 10.50, 500, 1);
INSERT INTO Material VALUES (2, 'Sand', 'Sand', 'Concrete', 10.50, 10000, 2);
INSERT INTO Material VALUES (3, 'Steel', 'Reinforced steel', 'Tons', 250.00, 20, 3);
INSERT INTO Material VALUES (4, 'Drywall', 'Standard drywall sheets', 'Sheets', 15.00, 100, 4);
INSERT INTO Material VALUES (5, 'Wood', 'Oak wood', 'Pieces', 25.00, 250, 5);
INSERT INTO Material VALUES (6, 'Bricks', 'Walls Bricks', 'Pieces', 250.00, 10000, 6);
INSERT INTO Material VALUES (7, 'Nails', 'Steel Nails', 'Pieces', 50.00, 250, 7);

--Order value-- (Note: Using OrderTable instead of [Order])
INSERT INTO OrderTable VALUES (1, 1, 1, DATE '2025-01-05', DATE '2025-01-10', 5000.00, 'Delivered');
INSERT INTO OrderTable VALUES (2, 2, 2, DATE '2025-03-10', DATE '2025-03-20', 12000.00, 'Pending');
INSERT INTO OrderTable VALUES (3, 3, 3, DATE '2025-05-15', DATE '2025-05-25', 15000.00, 'Delivered');
INSERT INTO OrderTable VALUES (4, 4, 4, DATE '2025-06-20', DATE '2025-07-01', 3000.00, 'Pending');
INSERT INTO OrderTable VALUES (5, 5, 5, DATE '2025-07-05', DATE '2025-07-15', 7500.00, 'In Transit');
INSERT INTO OrderTable VALUES (6, 6, 6, DATE '2024-06-20', DATE '2025-07-01', 3000.00, 'Pending');
INSERT INTO OrderTable VALUES (7, 7, 7, DATE '2024-07-05', DATE '2025-07-15', 7500.00, 'In Transit');

--Tracking value--
INSERT INTO Tracking VALUES (1, 1, 'Delivered', DATE '2024-01-07', DATE '2024-01-10', 'FDX12345');
INSERT INTO Tracking VALUES (2, 2, 'Pending', NULL, NULL, 'UPS23456');
INSERT INTO Tracking VALUES (3, 3, 'Delivered', DATE '2025-02-18', DATE '2025-05-25', 'P45678');
INSERT INTO Tracking VALUES (4, 4, 'In Transit', DATE '2025-04-25', NULL, 'DHL78901');
INSERT INTO Tracking VALUES (5, 5, 'In Transit', DATE '2025-03-10', NULL, 'CP67890');
INSERT INTO Tracking VALUES (6, 6, 'Pending', DATE '2025-05-10', NULL, 'UPS23456');
INSERT INTO Tracking VALUES (7, 7, 'Delivered', DATE '2025-05-18', NULL, 'P45678');

--Employee value-- (Note: Removed extra column that doesn't exist in schema)
INSERT INTO Employee VALUES (1, 'Project contributor', 'Construction', 'Project contributor@construction.com', '613-111-1111');
INSERT INTO Employee VALUES (2, 'Dhruv Kanani', 'Construction', 'dhruvkanani@construction.com', '613-111-1112');
INSERT INTO Employee VALUES (3, 'Ashish Sharma', 'Engineering', 'ashishsharma@engineer.com', '613-111-1113');
INSERT INTO Employee VALUES (4, 'Laura White', 'Design', 'laurawhite@architect.com', '613-111-1114');
INSERT INTO Employee VALUES (5, 'Pat Brown', 'Maintenance', 'patbrown@maintenance.com', '613-111-1115');
INSERT INTO Employee VALUES (6, 'Laura Brown', 'Design', 'laurabrown@architect.com', '613-111-1116');
INSERT INTO Employee VALUES (7, 'Lory White', 'Design', 'lorywhite@architect.com', '613-111-1117');

--ProjectEmployee value--
INSERT INTO ProjectEmployee VALUES (1, 1, DATE '2025-10-20', 'Manager');
INSERT INTO ProjectEmployee VALUES (5, 2, DATE '2025-01-02', 'Supervisor');
INSERT INTO ProjectEmployee VALUES (2, 3, DATE '2025-03-01', 'Engineer');
INSERT INTO ProjectEmployee VALUES (3, 4, DATE '2025-05-15', 'Architect');
INSERT INTO ProjectEmployee VALUES (4, 5, DATE '2025-06-20', 'Manager');
INSERT INTO ProjectEmployee VALUES (6, 6, DATE '2025-03-01', 'Architect');
INSERT INTO ProjectEmployee VALUES (7, 7, DATE '2025-05-15', 'Architect');

--WorkerType values--
INSERT INTO WorkerType VALUES (1, 'Fulltime', 'Project contributor');
INSERT INTO WorkerType VALUES (2, 'Parttime', 'Dhruv Kanani');
INSERT INTO WorkerType VALUES (3, 'Contract', 'Ashish Sharma');
INSERT INTO WorkerType VALUES (4, 'Intern', 'Laura White');
INSERT INTO WorkerType VALUES (5, 'Fulltime', 'Pat Brown');
INSERT INTO WorkerType VALUES (6, 'Parttime', 'Laura Brown');
INSERT INTO WorkerType VALUES (7, 'Contract', 'Lory White');

-- Commit all inserts
COMMIT;

--Query 1: Get OrderID and Project Name
SELECT o.OrderID, p.Name
FROM OrderTable o
JOIN Project p ON o.ProjectID = p.ProjectID;

--Query 2: Get Project Name and Employee Name
SELECT p.Name AS ProjectName, e.Name AS EmployeeName
FROM Project p
JOIN ProjectEmployee pe ON p.ProjectID = pe.ProjectID
JOIN Employee e ON pe.EmployeeID = e.EmployeeID;

--Query 3: Update Material information
UPDATE Material
SET Name = 'Concrete Mix',
    QuantityInStock = 200,
    WarehouseID = 2
WHERE MaterialID = 2;

-- Commit the update
COMMIT;