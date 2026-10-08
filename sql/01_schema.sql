-- Warehouse
CREATE TABLE Warehouse (
    WarehouseID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Address VARCHAR2(100),
    City VARCHAR2(50),
    Province VARCHAR2(50),
    PostalCode VARCHAR2(20),
    Phone VARCHAR2(20),
    Email VARCHAR2(100),
    Capacity NUMBER,
    ManagerName VARCHAR2(100)
);

-- Project
CREATE TABLE Project (
    ProjectID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Location VARCHAR2(100),
    City VARCHAR2(50),
    Province VARCHAR2(50),
    Status VARCHAR2(20),
    StartDate DATE,
    EndDate DATE,
    Budget NUMBER(15,2)
);

-- Supplier
CREATE TABLE Supplier (
    SupplierID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    ContactPersonName VARCHAR2(100),
    Phone VARCHAR2(20),
    Email VARCHAR2(100),
    Address VARCHAR2(200),
    City VARCHAR2(50),
    Province VARCHAR2(50),
    PostalCode VARCHAR2(20)
);

-- Material
CREATE TABLE Material (
    MaterialID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Description VARCHAR2(200),
    Type VARCHAR2(50),
    Unit VARCHAR2(20),
    QuantityInStock NUMBER,
    WarehouseID NUMBER,
    CONSTRAINT fk_material_warehouse FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID)
);

-- Order (using OrderTable since ORDER is a reserved word in Oracle)
CREATE TABLE OrderTable (
    OrderID NUMBER PRIMARY KEY,
    ProjectID NUMBER,
    SupplierID NUMBER,
    OrderDate DATE,
    DeliveryDate DATE,
    TotalCost NUMBER(12,2),
    Status VARCHAR2(20),
    CONSTRAINT fk_order_project FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID),
    CONSTRAINT fk_order_supplier FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

-- Tracking (linked to Order)
CREATE TABLE Tracking (
    TrackingID NUMBER PRIMARY KEY,
    OrderID NUMBER,
    Status VARCHAR2(50),
    ShippedDate DATE,
    DeliveryDate DATE,
    TrackingNumber VARCHAR2(50),
    CONSTRAINT fk_tracking_order FOREIGN KEY (OrderID) REFERENCES OrderTable(OrderID)
);

-- Employee
CREATE TABLE Employee (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Department VARCHAR2(50),
    Email VARCHAR2(100),
    Phone VARCHAR2(20)
);

-- Many-to-many table: ProjectEmployee
CREATE TABLE ProjectEmployee (
    ProjectID NUMBER,
    EmployeeID NUMBER,
    AssignedDate DATE,
    Role VARCHAR2(50),
    CONSTRAINT pk_project_employee PRIMARY KEY (ProjectID, EmployeeID),
    CONSTRAINT fk_pe_project FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID),
    CONSTRAINT fk_pe_employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- WorkerType Table (the "is-a" relationship)
CREATE TABLE WorkerType (
    EmployeeID NUMBER PRIMARY KEY,
    EmploymentType VARCHAR2(50),
    EmployeeName VARCHAR2(100),
    CONSTRAINT fk_workertype_employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Create sequences for auto-incrementing primary keys (optional)
CREATE SEQUENCE seq_warehouse_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_project_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_supplier_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_material_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_order_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tracking_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_employee_id START WITH 1 INCREMENT BY 1;