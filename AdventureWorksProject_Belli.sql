/*
BUS 205 - Applied Business Technology
<Mia Belli>
Due: 2022-03-10
*/


# AdventureWorks SQL Query #1
# Request for Information #1: Display ratings and comments of products that received an average or below average rating.
/* Rationale #1: This query shows customers' feedback which the company can evaluate and make changes if necessary. 
For example, with this information, the company can view the product(s) that are not as popular if there are multiple 
bad ratings and then make inventory and purchasing adjustments. */
USE adventureworks;
SELECT product.productnumber, product.name, productreview.rating, productreview.comments
FROM product
	INNER JOIN productreview
		ON product.productID = productreview.productID
WHERE productreview.rating <= '3';


# AdventureWorks SQL Query #2
# Request for Information #2: Show all products that are categorized as socks and the current inventory for each product. 
/* Rationale #2: This query is helpful when trying to find how much of a product is currently on hand. 
It also aids in making inventory decisions by indictating if the company needs to buy more socks. */
USE adventureworks;
SELECT product.name, product.productnumber, productinventory.quantity
FROM product
	INNER JOIN productsubcategory
		ON productsubcategory.productsubcategoryID = product.productsubcategoryID
	INNER JOIN productinventory
		ON product.productID = productinventory.productID
WHERE productsubcategory.name = ('Socks');


# AdventureWorks SQL Query #3
# Request for Information #3: Calculate the total sales revenue in August.
/* Rationale #3: This is helpful when trying to find out how much revenue was made from sales orders in a certain month.
Then, the total sales revenue of a month can be compared to other months where we can try to predict trends and 
determine which month is the busiest and generates the most revenue. */
USE adventureworks;
SELECT SUM(salesorderheader.totaldue) AS TotalSalesRevenue
FROM salesorderheader
WHERE orderdate BETWEEN '2001-08-01' AND '2001-08-31';


# AdventureWorks SQL Query #4
/* Request for Information #4: List all employees' ID, names, and positions who are paid greater than 
							  the average pay wage.
Rationale #4: If the company is going through a hard time and needs to reduce costs by cutting people's pay, it is
good to know who is being paid a certain amount. Usually, people, who are paid more, have their wages cut more.
With information from this specific query which finds individuals who are paid a wage above average, decisions on 
how much to reduce their pay can be made based on their position or job. */
USE adventureworks;
SELECT employee.employeeID, CONCAT(contact.lastname,',',contact.firstname) AS EmployeeName, 
	employee.title, employeepayhistory.rate
FROM employee
	INNER JOIN employeepayhistory
		ON employee.employeeID = employeepayhistory.employeeID
	INNER JOIN contact
		ON employee.contactID = contact.contactID
GROUP BY employee.employeeID, CONCAT(contact.lastname,',',contact.firstname), employee.title, employeepayhistory.rate
HAVING (AVG(employeepayhistory.rate) > 
			(SELECT AVG(rate)
			 FROM employeepayhistory
			)
		)
ORDER BY employeepayhistory.rate;


# AdventureWorks SQL Query #5
# Request for Information #5: Show the average difference in pay wages between females and males.
/* Rationale #5: This query is valuable because it helps indicate gender equality in the workplace.
If there is a big gap in wages, then the employees are being treated unfairly and unethnically. The company
can then make changes to wages if necessary. */
USE adventureworks;
SELECT (SELECT COUNT(employee.gender)
	FROM employee
	WHERE employee.gender = 'F') AS TotalFemaleEmployees,
    (SELECT AVG(employeepayhistory.rate)
    FROM employeepayhistory
			INNER JOIN employee
				ON employeepayhistory.employeeID = employee.employeeID
		WHERE employee.gender = 'F') AS AverageFemalePay,
    
    (SELECT COUNT(employee.gender)
	FROM employee
	WHERE employee.gender = 'M') AS TotalMaleEmployees,
    (SELECT AVG(employeepayhistory.rate)
    FROM employeepayhistory
			INNER JOIN employee
				ON employeepayhistory.employeeID = employee.employeeID
		WHERE employee.gender = 'M') AS AverageMalePay,
		
        ((
		SELECT AVG(employeepayhistory.rate)
		FROM employeepayhistory
			INNER JOIN employee
				ON employeepayhistory.employeeID = employee.employeeID
		WHERE employee.gender = 'F'
        ) - 
	(SELECT AVG(employeepayhistory.rate)
	FROM employeepayhistory
		INNER JOIN employee
			ON employeepayhistory.employeeID = employee.employeeID
	WHERE employee.gender = 'M')
    ) AS DifferenceInPay;


# AdventureWorks SQL Query #6
# Request for Information #6: List products that have not been put in a shopping cart.
/* Rationale #6: This is helpful because it keeps track of products that are still on hand and 
available to sell while also filtering out items that are already in shopping charts of prospective customers. */

USE adventureworks;
SELECT product.productID, product.name, shoppingcartitem.shoppingcartID
FROM product
	LEFT OUTER JOIN shoppingcartitem
		ON product.productID = shoppingcartitem.productID
WHERE shoppingcartitem.shoppingcartID IS NULL;



# AdventureWorks SQL Query #7
/* Request for Information #7: Display each product bought from purchase orders, how many were bought, 
							   and their total costs.
Rationale #7: This is helpful to know so the company understands how much they are paying for products.
This information can be compared to sales revenue and help calculate things like net profit. 
It also keeps a good track of new inventory coming in and its expenses. */

USE adventureworks;
SELECT product.name, COUNT(purchaseorderdetail.orderqty) AS QuantityOrdered,
	SUM(purchaseorderdetail.orderqty*purchaseorderdetail.unitprice) AS TotalPurchasingCost
FROM product
	INNER JOIN purchaseorderdetail
		ON product.productID = purchaseorderdetail.productID
GROUP BY product.Name;



# AdventureWorks SQL Query #8
/* Request for Information #8: List the customers' contact information whose order is in the month of 
							   July and contains a red Sport-100 Helmet. 
 Rationale #8: This query may be helpful to find orders with a specific product and order date.
 For example, if there is a product recall, we can find the orders with the lemon product and email the corresponding 
 customers about the item they purchased. */
USE adventureworks;
SELECT DISTINCT salesorderheader.salesordernumber, salesorderheader.orderdate,
	CONCAT(contact.lastname,',',contact.firstname) AS CustName, contact.emailaddress
FROM salesorderdetail
	INNER JOIN salesorderheader
		ON salesorderheader.salesorderID = salesorderdetail.salesorderID
	INNER JOIN product
		ON product.productID = salesorderdetail.productID
	INNER JOIN individual
		ON salesorderheader.customerID = individual.customerID
	INNER JOIN contact
		ON individual.contactID = contact.contactID
WHERE product.name = 'Sport-100 Helmet, Red' AND 
		salesorderheader.orderdate BETWEEN '2003-07-01' AND '2003-07-31'
GROUP BY CONCAT(contact.lastname,',',contact.firstname), contact.emailaddress, 
	salesorderheader.salesordernumber;



# AdventureWorks SQL Query #9
/* Request for Information #9: Create a masterlist of all vendors, employees, and customers that includes their
								names, phone numbers, and email addresses. 
# Rationale #9: This query is helpful when trying to find a person's contact information especially to send
confirmation emails, invoices, and other important information.  */

USE adventureworks;
SELECT CONCAT(contact.lastname, ', ', contact.firstname) AS Name, 
	   contact.phone, contact.emailaddress,
       'vendor' AS IndividualType
FROM contact
	INNER JOIN vendorcontact
		ON contact.contactID = vendorcontact.contactID
	INNER JOIN vendor
		ON vendor.vendorID = vendorcontact.vendorID

UNION

SELECT CONCAT(contact.lastname, ', ', contact.firstname) AS Name, 
	   contact.phone, contact.emailaddress,
       'employees' AS IndividualType
FROM contact
	INNER JOIN employee
		ON contact.contactID = employee.contactID

UNION

SELECT CONCAT(contact.lastname, ', ', contact.firstname) AS Name, 
	   contact.phone, contact.emailaddress,
       'customers' AS IndividualType
FROM contact
	INNER JOIN individual
		ON contact.contactID = individual.contactID
	INNER JOIN customer 
		ON individual.customerID = customer.customerID;
        
        
        
# AdventureWorks SQL Query #10
/* Request for Information #10: Show all categories that have less than 50 products and find how many products 
								each category has.
Rationale #10: This query shows categories with the least diverse amount of products. 
The small variety of a category demonstrates that items from other categories are the company's main products.
Looking at this data and then comparing it with things like the products' ratings, the company can decide on whether
to reduce the amount of products they offer from a certain category or expand their selection.
*/ 
USE adventureworks; 
SELECT productcategory.productcategoryID, productcategory.name,
		COUNT(product.productID) AS TotalProducts
FROM product
	INNER JOIN productsubcategory
		ON product.productsubcategoryID = productsubcategory.productsubcategoryID
INNER JOIN  productcategory
    ON productsubcategory.productcategoryID = productcategory.productcategoryID
GROUP BY productcategory.productcategoryID, productcategory.name
HAVING TotalProducts < 50
ORDER BY productcategory.productcategoryID ASC;
