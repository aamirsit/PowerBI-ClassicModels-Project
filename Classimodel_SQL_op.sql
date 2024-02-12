use classicmodels;

-- Created a view Which helps user to find the Customers Whose payments is yet be received.

CREATE VIEW customers_payment AS 
SELECT 
	customerNumber,
    CONCAT(contactFirstName," ",contactLastName) as CustomerName,
    customerName as Company, 
    SUM(priceEach * quantityOrdered) as Sales,
    IFNULL((SELECT SUM(amount) FROM payments WHERE customerNumber = c.customerNumber ),0) as Amount_received,
    SUM(priceEach * quantityOrdered) - IFNULL((SELECT SUM(amount) FROM payments WHERE customerNumber = c.customerNumber ),0) as AmountLeft
FROM customers c 
	 JOIN orders USING(customerNumber) 
     JOIN orderdetails USING(orderNumber) 
WHERE status IN ( "Shipped","Resolved","Disputed")
GROUP BY customerNumber
HAVING AmountLeft > 0
ORDER BY customerNumber;

--     What is the name of the customer, the order number, and the total cost of the mostexpensive orders?
SELECT 
	orderNumber,
	customerNumber,
    customerName,
    SUM(quantityOrdered * buyPrice ) as Total_cost
FROM customers c 
	JOIN orders USING(customerNumber)
    JOIN orderDetails USING(orderNumber)
    JOIN products USING(productCode)
GROUP BY orderNumber
ORDER BY total_cost DESC
LIMIT 1;

-- ProductLine Wise Revenue
SELECT 
	productline, 
    SUM(priceEach*QuantityOrdered) as Revenue
FROM orders 
	JOIN orderdetails USING(orderNumber)
	JOIN products USING(productCode) 
    JOIN productlines USING(productline)
WHERE status IN ("Shipped","Resolved","Disputed")
GROUP BY productline
ORDER BY Revenue DESC;
    
-- Year and month Wise Revenue, Profit, Cost , Qty Sold
SELECT 
	YEAR(orderDate) as Year,
    monthname(orderDate) as Month,
	SUM(priceEach*QuantityOrdered) as Revenue,
    SUM(QuantityOrdered*buyPrice) as Cost,
    SUM(QuantityOrdered*(priceEach-buyPrice)) as Profit,
    SUM(QuantityOrdered) as qty
FROM 
	orderdetails JOIN orders USING(orderNumber)
    JOIN products USING(productCode)
WHERE status IN ("Shipped","Resolved","Disputed")
GROUP BY year,month;
    

