-- =============================================================================
-- "Delicious Pizza" Ordering and Delivery Management Database System
-- Schema Definition (Data Definition Language - DDL)
-- 3rd Normal Form (3NF) Relational Architecture
-- Designed by: Chan Hua Shean
-- =============================================================================

-- Drop tables in reverse dependency order if re-running
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Items;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS DeliveryPerson;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Branch;

-- -----------------------------------------------------------------------------
-- 1. Branch Table
-- Stores physical pizza store branch locations
-- -----------------------------------------------------------------------------
CREATE TABLE Branch (
    BranchID VARCHAR(50) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    PRIMARY KEY (BranchID)
);

-- -----------------------------------------------------------------------------
-- 2. Staff Table
-- Represents restaurant employees assigned to specific branches
-- -----------------------------------------------------------------------------
CREATE TABLE Staff (
    StaffID VARCHAR(50) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    BranchID VARCHAR(50) NOT NULL,
    PRIMARY KEY (StaffID),
    CONSTRAINT fk_staff_branch FOREIGN KEY (BranchID) 
        REFERENCES Branch(BranchID) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- 3. DeliveryPerson Table
-- Couriers responsible for transporting orders to customers
-- -----------------------------------------------------------------------------
CREATE TABLE DeliveryPerson (
    DeliveryPersonID VARCHAR(50) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    PRIMARY KEY (DeliveryPersonID)
);

-- -----------------------------------------------------------------------------
-- 4. Customer Table
-- Registered customer profiles with contact details and delivery addresses
-- -----------------------------------------------------------------------------
CREATE TABLE Customer (
    CustomerID VARCHAR(50) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Address VARCHAR(150) NOT NULL,
    Contact VARCHAR(20) NOT NULL,
    PRIMARY KEY (CustomerID)
);

-- -----------------------------------------------------------------------------
-- 5. Items Table
-- Food and beverage menu catalog with item pricing
-- -----------------------------------------------------------------------------
CREATE TABLE Items (
    ItemsID VARCHAR(50) NOT NULL,
    ItemName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    PRIMARY KEY (ItemsID)
);

-- -----------------------------------------------------------------------------
-- 6. Orders Table
-- Header record for customer orders linking branch, staff, and delivery courier
-- -----------------------------------------------------------------------------
CREATE TABLE Orders (
    OrderID VARCHAR(50) NOT NULL,
    CustomerID VARCHAR(50) NOT NULL,
    StaffID VARCHAR(50) NULL,
    DeliveryPersonID VARCHAR(50) NULL,
    BranchID VARCHAR(50) NOT NULL,
    DeliveryStatus VARCHAR(50) NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL CHECK (TotalPrice >= 0),
    OrderDate DATE NOT NULL,
    PRIMARY KEY (OrderID),
    CONSTRAINT fk_order_customer FOREIGN KEY (CustomerID) 
        REFERENCES Customer(CustomerID) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_order_staff FOREIGN KEY (StaffID) 
        REFERENCES Staff(StaffID) 
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_order_delivery FOREIGN KEY (DeliveryPersonID) 
        REFERENCES DeliveryPerson(DeliveryPersonID) 
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_order_branch FOREIGN KEY (BranchID) 
        REFERENCES Branch(BranchID) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- 7. OrderItem Table
-- Composite associative entity resolving many-to-many relationship 
-- between Orders and Menu Items
-- -----------------------------------------------------------------------------
CREATE TABLE OrderItem (
    OrderID VARCHAR(50) NOT NULL,
    ItemsID VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    PRIMARY KEY (OrderID, ItemsID),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_item FOREIGN KEY (ItemsID) 
        REFERENCES Items(ItemsID) 
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- -----------------------------------------------------------------------------
-- 8. Review Table
-- Post-delivery customer ratings and feedback
-- -----------------------------------------------------------------------------
CREATE TABLE Review (
    ReviewID VARCHAR(50) NOT NULL,
    CustomerID VARCHAR(50) NOT NULL,
    OrderID VARCHAR(50) NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment VARCHAR(255) NULL,
    ReviewDate DATE NOT NULL,
    PRIMARY KEY (ReviewID),
    CONSTRAINT fk_review_customer FOREIGN KEY (CustomerID) 
        REFERENCES Customer(CustomerID) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_review_order FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID) 
        ON UPDATE CASCADE ON DELETE CASCADE
);
