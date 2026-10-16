-- =============================================================================
-- "Delicious Pizza" Sample Data Seed Script
-- Realistic test data populating 3NF normalized tables
-- Supports all 15 business query evaluation scenarios
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Insert Branches
-- -----------------------------------------------------------------------------
INSERT INTO Branch (BranchID, Address) VALUES
('B001', '123 Bukit Bintang, Kuala Lumpur'),
('B002', '45 Jalan Bangsar, Kuala Lumpur'),
('B003', '88 Persiaran Gurney, Penang'),
('B004', '12 Jalan Sultan Ismail, Kuala Lumpur');

-- -----------------------------------------------------------------------------
-- 2. Insert Staff
-- -----------------------------------------------------------------------------
INSERT INTO Staff (StaffID, Name, BranchID) VALUES
('S001', 'Alice Tan', 'B001'),
('S002', 'Bob Smith', 'B001'),
('S003', 'Charlie Wong', 'B002'),
('S004', 'Diana Prince', 'B003'),
('S005', 'Edward Lim', 'B004');

-- -----------------------------------------------------------------------------
-- 3. Insert Delivery Personnel
-- Note: DP005 has zero deliveries assigned to test outer join queries
-- -----------------------------------------------------------------------------
INSERT INTO DeliveryPerson (DeliveryPersonID, Name) VALUES
('DP001', 'Ahmed Khan'),
('DP002', 'Siti Nurhaliza'),
('DP003', 'David Miller'),
('DP004', 'Rajesh Kumar'),
('DP005', 'Lucas Gray'); -- Unassigned driver for testing

-- -----------------------------------------------------------------------------
-- 4. Insert Customers
-- Note: C005 and C006 have placed zero orders to test idle customer queries
-- -----------------------------------------------------------------------------
INSERT INTO Customer (CustomerID, Name, Email, Address, Contact) VALUES
('C001', 'Sarah Lee', 'sarah.lee@example.com', '15 Mont Kiara Pines, KL', '+60123456781'),
('C002', 'Michael Chang', 'm.chang@example.com', '28 Bangsar South, KL', '+60123456782'),
('C003', 'Emma Watson', 'emma.w@example.com', '7 Damansara Heights, KL', '+60123456783'),
('C004', 'Kenji Sato', 'kenji.sato@example.com', '102 Solaris Dutamas, KL', '+60123456784'),
('C005', 'Chloe Bennett', 'chloe.b@example.com', '55 Subang Jaya, Selangor', '+60123456785'),
('C006', 'Daniel Craig', 'daniel.c@example.com', '9 Cyberjaya Cyberview, Selangor', '+60123456786');

-- -----------------------------------------------------------------------------
-- 5. Insert Menu Items
-- -----------------------------------------------------------------------------
INSERT INTO Items (ItemsID, ItemName, Price) VALUES
('ITM001', 'Hawaiian Pizza', 32.50),
('ITM002', 'Pepperoni Supreme', 35.00),
('ITM003', 'Four Cheese Pizza', 34.00),
('ITM004', 'Garlic Bread', 8.50),
('ITM005', 'BBQ Chicken Wings', 18.00),
('ITM006', 'Mushroom Soup', 9.50),
('ITM007', 'Coca-Cola (1.5L)', 6.00),
('ITM008', 'Tiramisu Dessert', 12.00);

-- -----------------------------------------------------------------------------
-- 6. Insert Orders
-- Includes orders from Oct 2023, Oct 2024, > $50, delivered & unassigned statuses
-- -----------------------------------------------------------------------------
INSERT INTO Orders (OrderID, CustomerID, StaffID, DeliveryPersonID, BranchID, DeliveryStatus, TotalPrice, OrderDate) VALUES
('ORD101', 'C001', 'S001', 'DP001', 'B001', 'Delivered', 59.00, '2023-10-05'),
('ORD102', 'C002', 'S001', 'DP002', 'B001', 'Delivered', 35.00, '2023-10-18'),
('ORD103', 'C003', 'S003', 'DP001', 'B002', 'Delivered', 68.50, '2023-10-22'),
('ORD104', 'C001', 'S002', 'DP003', 'B001', 'Delivered', 41.00, '2024-05-14'),
('ORD105', 'C004', 'S004', 'DP004', 'B003', 'Delivered', 26.50, '2024-07-20'),
('ORD106', 'C001', 'S001', 'DP001', 'B001', 'Delivered', 56.50, '2024-10-02'),
('ORD107', 'C002', 'S003', 'DP002', 'B002', 'Delivered', 72.00, '2024-10-15'),
('ORD108', 'C003', 'S005', NULL,   'B004', 'Pending',   20.50, '2024-10-28'); -- Order without assigned delivery person

-- -----------------------------------------------------------------------------
-- 7. Insert Order Items (Order Breakdown)
-- -----------------------------------------------------------------------------
INSERT INTO OrderItem (OrderID, ItemsID, Price) VALUES
('ORD101', 'ITM001', 32.50), -- Sarah Lee ordered Hawaiian Pizza
('ORD101', 'ITM005', 18.00),
('ORD101', 'ITM004', 8.50),

('ORD102', 'ITM002', 35.00),

('ORD103', 'ITM001', 32.50), -- Emma Watson ordered Hawaiian Pizza
('ORD103', 'ITM002', 35.00),
('ORD103', 'ITM007', 6.00),

('ORD104', 'ITM001', 32.50), -- Sarah Lee ordered Hawaiian Pizza
('ORD104', 'ITM004', 8.50),

('ORD105', 'ITM005', 18.00),
('ORD105', 'ITM004', 8.50),

('ORD106', 'ITM001', 32.50), -- Sarah Lee ordered Hawaiian Pizza in Oct 2024
('ORD106', 'ITM008', 12.00),
('ORD106', 'ITM007', 6.00),

('ORD107', 'ITM002', 35.00),
('ORD107', 'ITM003', 34.00),
('ORD107', 'ITM007', 6.00),

('ORD108', 'ITM004', 8.50),
('ORD108', 'ITM008', 12.00);

-- -----------------------------------------------------------------------------
-- 8. Insert Customer Reviews
-- -----------------------------------------------------------------------------
INSERT INTO Review (ReviewID, CustomerID, OrderID, Rating, Comment, ReviewDate) VALUES
('REV001', 'C001', 'ORD101', 5, 'Super fast delivery and the Hawaiian pizza was piping hot!', '2023-10-05'),
('REV002', 'C002', 'ORD102', 4, 'Great pepperoni pizza, good service.', '2023-10-19'),
('REV003', 'C003', 'ORD103', 5, 'Ahmed was very courteous and the food was amazing!', '2023-10-23'),
('REV004', 'C004', 'ORD105', 3, 'Delivery was slightly delayed during peak hours.', '2024-07-21'),
('REV005', 'C001', 'ORD106', 5, 'Consistently top notch quality. Best pizza in town!', '2024-10-03'),
('REV006', 'C002', 'ORD107', 4, 'Crispy crust and generous cheese toppings.', '2024-10-16');
