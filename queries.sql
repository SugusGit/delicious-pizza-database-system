-- =============================================================================
-- "Delicious Pizza" Analytical Queries (Data Manipulation Language - DML)
-- 15 Business Intelligence & Operational Queries
-- Designed & Implemented by: Chan Hua Shean
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Query 1: High-Value Orders
-- Business Question: Find customers who placed orders with a total amount 
-- greater than $50. Sort the list by descending order of total price.
-- Purpose: Identifies high-spending transactions for VIP customer tracking.
-- -----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.Name AS CustomerName,
    o.OrderID,
    o.TotalPrice,
    o.OrderDate
FROM Customer c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.TotalPrice > 50.00
ORDER BY o.TotalPrice DESC;


-- -----------------------------------------------------------------------------
-- Query 2: Delivered Orders in Specific Date Window (October 2023)
-- Business Question: Find all orders placed between '2023-10-01' and '2023-10-31' 
-- with a delivery status of "Delivered".
-- Purpose: Analyzes operational fulfillment performance over monthly reporting periods.
-- -----------------------------------------------------------------------------
SELECT 
    OrderID,
    CustomerID,
    TotalPrice,
    OrderDate,
    DeliveryStatus
FROM Orders
WHERE OrderDate BETWEEN '2023-10-01' AND '2023-10-31'
  AND DeliveryStatus = 'Delivered'
ORDER BY OrderDate ASC;


-- -----------------------------------------------------------------------------
-- Query 3: Minimum Order Value per Customer
-- Business Question: Find the minimum order value for each customer.
-- Purpose: Establishes baseline basket sizes for targeted promotional strategies.
-- -----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.Name AS CustomerName,
    MIN(o.TotalPrice) AS MinOrderValue
FROM Customer c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY MinOrderValue ASC;


-- -----------------------------------------------------------------------------
-- Query 4: Customer Specific Item History ("Sarah")
-- Business Question: Find all menu items ordered by a customer named "Sarah".
-- Purpose: Supports personalized marketing and recommendation engines.
-- -----------------------------------------------------------------------------
SELECT DISTINCT 
    c.Name AS CustomerName,
    i.ItemsID,
    i.ItemName,
    i.Price
FROM Customer c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderItem oi ON o.OrderID = oi.OrderID
INNER JOIN Items i ON oi.ItemsID = i.ItemsID
WHERE c.Name LIKE 'Sarah%'
ORDER BY i.ItemName ASC;


-- -----------------------------------------------------------------------------
-- Query 5: Average Customer Satisfaction Rating per Branch
-- Business Question: Find the average rating given to each restaurant branch.
-- Purpose: Pinpoints branch operational quality and customer service benchmarks.
-- -----------------------------------------------------------------------------
SELECT 
    b.BranchID,
    b.Address AS BranchAddress,
    ROUND(AVG(r.Rating), 2) AS AverageRating,
    COUNT(r.ReviewID) AS ReviewCount
FROM Branch b
INNER JOIN Orders o ON b.BranchID = o.BranchID
INNER JOIN Review r ON o.OrderID = r.OrderID
GROUP BY b.BranchID, b.Address
ORDER BY AverageRating DESC;


-- -----------------------------------------------------------------------------
-- Query 6: Customers Who Ordered a Specific Item ("Hawaiian Pizza")
-- Business Question: Find customers who ordered "Hawaiian Pizza".
-- Purpose: Enables product-level cohort segmentation for campaigns.
-- -----------------------------------------------------------------------------
SELECT DISTINCT 
    c.CustomerID,
    c.Name AS CustomerName,
    c.Email,
    c.Contact,
    i.ItemName
FROM Customer c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderItem oi ON o.OrderID = oi.OrderID
INNER JOIN Items i ON oi.ItemsID = i.ItemsID
WHERE i.ItemName = 'Hawaiian Pizza'
ORDER BY c.Name ASC;


-- -----------------------------------------------------------------------------
-- Query 7: Total Revenue Generated per Delivery Person
-- Business Question: Calculate the total revenue generated from deliveries 
-- handled by each delivery person.
-- Purpose: Evaluates driver productivity and calculates commission incentives.
-- -----------------------------------------------------------------------------
SELECT 
    dp.DeliveryPersonID,
    dp.Name AS DeliveryPersonName,
    COUNT(o.OrderID) AS TotalDeliveriesHandled,
    SUM(o.TotalPrice) AS TotalRevenueGenerated
FROM DeliveryPerson dp
INNER JOIN Orders o ON dp.DeliveryPersonID = o.DeliveryPersonID
WHERE o.DeliveryStatus = 'Delivered'
GROUP BY dp.DeliveryPersonID, dp.Name
ORDER BY TotalRevenueGenerated DESC;


-- -----------------------------------------------------------------------------
-- Query 8: Top-Selling Menu Item
-- Business Question: Find the top-selling menu item (the item ordered the most).
-- Purpose: Guides inventory planning, supply purchasing, and kitchen preparation.
-- -----------------------------------------------------------------------------
SELECT 
    i.ItemsID,
    i.ItemName,
    COUNT(oi.ItemsID) AS TimesOrdered,
    SUM(oi.Price) AS TotalSales
FROM Items i
INNER JOIN OrderItem oi ON i.ItemsID = oi.ItemsID
GROUP BY i.ItemsID, i.ItemName
ORDER BY TimesOrdered DESC, TotalSales DESC;


-- -----------------------------------------------------------------------------
-- Query 9: Customers with Active Orders in October 2024
-- Business Question: Find customers who placed orders in October 2024.
-- Purpose: Generates monthly cohort retention and sales breakdown.
-- -----------------------------------------------------------------------------
SELECT DISTINCT 
    c.CustomerID,
    c.Name AS CustomerName,
    o.OrderID,
    o.OrderDate,
    o.TotalPrice
FROM Customer c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN '2024-10-01' AND '2024-10-31'
ORDER BY o.OrderDate ASC;


-- -----------------------------------------------------------------------------
-- Query 10: Inactive / Idle Customers (Zero Orders Placed)
-- Business Question: Find customers who have not placed any orders.
-- Purpose: Identifies churned or newly registered users for re-engagement promos.
-- -----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.Name AS CustomerName,
    c.Email,
    c.Contact
FROM Customer c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL
ORDER BY c.CustomerID ASC;


-- -----------------------------------------------------------------------------
-- Query 11: Inner Join Order Summary
-- Business Question: List all orders with customer names and restaurant addresses.
-- Only show records where both customer and restaurant exist.
-- Purpose: Verifies relational integrity across customer transactions and branch origins.
-- -----------------------------------------------------------------------------
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    b.Address AS RestaurantBranchAddress,
    o.TotalPrice,
    o.DeliveryStatus,
    o.OrderDate
FROM Orders o
INNER JOIN Customer c ON o.CustomerID = c.CustomerID
INNER JOIN Branch b ON o.BranchID = b.BranchID
ORDER BY o.OrderDate DESC;


-- -----------------------------------------------------------------------------
-- Query 12: Delivery Assignments (Including Unassigned Orders)
-- Business Question: Display all deliveries, including those without assigned 
-- delivery personnel, showing the customer name and delivery person's name.
-- Purpose: Monitors unassigned dispatch queue to prevent order fulfillment bottlenecks.
-- -----------------------------------------------------------------------------
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    COALESCE(dp.Name, 'UNASSIGNED / PENDING') AS DeliveryPersonName,
    o.DeliveryStatus,
    o.TotalPrice
FROM Orders o
INNER JOIN Customer c ON o.CustomerID = c.CustomerID
LEFT JOIN DeliveryPerson dp ON o.DeliveryPersonID = dp.DeliveryPersonID
ORDER BY o.OrderID ASC;


-- -----------------------------------------------------------------------------
-- Query 13: 5-Star Reviews Correlated with Branch and Delivery Personnel
-- Business Question: Find customers who gave a 5-star rating, and match with the 
-- restaurant branch and delivery person reviewed.
-- Purpose: Identifies high-performing staff combinations driving peak customer delight.
-- -----------------------------------------------------------------------------
SELECT 
    r.ReviewID,
    c.Name AS CustomerName,
    r.Rating,
    r.Comment,
    b.BranchID,
    b.Address AS RestaurantBranch,
    dp.Name AS DeliveryPersonName
FROM Review r
INNER JOIN Customer c ON r.CustomerID = c.CustomerID
INNER JOIN Orders o ON r.OrderID = o.OrderID
INNER JOIN Branch b ON o.BranchID = b.BranchID
LEFT JOIN DeliveryPerson dp ON o.DeliveryPersonID = dp.DeliveryPersonID
WHERE r.Rating = 5
ORDER BY r.ReviewDate DESC;


-- -----------------------------------------------------------------------------
-- Query 14: Delivery Workforce Utilization (Including Zero Deliveries)
-- Business Question: Show all delivery personnel and the total orders they handled, 
-- including those with zero deliveries.
-- Purpose: Workload balancing and driver utilization audits across shifts.
-- -----------------------------------------------------------------------------
SELECT 
    dp.DeliveryPersonID,
    dp.Name AS DeliveryPersonName,
    COUNT(o.OrderID) AS TotalOrdersHandled
FROM DeliveryPerson dp
LEFT JOIN Orders o ON dp.DeliveryPersonID = o.DeliveryPersonID
GROUP BY dp.DeliveryPersonID, dp.Name
ORDER BY TotalOrdersHandled DESC;


-- -----------------------------------------------------------------------------
-- Query 15: Lifetime Customer Spending (Including Zero Spend)
-- Business Question: Show all customers with their total spending. 
-- Include customers who haven't placed any orders.
-- Purpose: Customer Lifetime Value (CLV) calculation and cohort tiering (Gold/Silver/Inactive).
-- -----------------------------------------------------------------------------
SELECT 
    c.CustomerID,
    c.Name AS CustomerName,
    c.Email,
    COALESCE(SUM(o.TotalPrice), 0.00) AS TotalSpending,
    COUNT(o.OrderID) AS OrdersCount
FROM Customer c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name, c.Email
ORDER BY TotalSpending DESC;
