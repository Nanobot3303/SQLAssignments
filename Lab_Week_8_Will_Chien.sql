/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 8: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   William Chien
                DATE:      11/16/2017

*******************************************************************************************
*/

USE FiredUp    -- ensures correct database is active


GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and table names; you should also put each projected column on its own line
and use indentation for neatness.  Example:

   SELECT Name,
          CustomerID
   FROM   CUSTOMER
   WHERE  CustomerID < 106;

All SQL statements should end in a semicolon.  Whatever format you choose for your queries, make
sure that it is readable and consistent.' + CHAR(10)
PRINT 'Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS2275, Lab Week 8, Question 1  [3pts possible]:
Show the customer ID number, name, and email address for all customers; order the list by ID number.  You will 
need to join the CUSTOMER table with the EMAIL table to do this (either implicit or explicit syntax is ok); 
include duplicates for customers with multiple email accounts.  Format all output using CAST, CONVERT and/or STR ' + CHAR(10)
SELECT CustomerID, Name, EMailAddress 
FROM dbo.customer 
			FULL outer join dbo.email
			ON customer.customerid = email.FK_CustomerID
ORDER BY customerid ASC


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 2  [3pts possible]:
Which stoves have been sold?  Project serial number, type, version, and color from the STOVE table; join with the 
INV_LINE_ITEM table to identify the stoves which have been sold.  Concatenate type and version to a single column 
with this format: "Firedup v.1".  Eliminate duplicate lines.  List in order by serial number, and format all output.' + CHAR(10)

SELECT SerialNumber, concat(Type, Version) AS "Firedup v.1", Color
FROM dbo.STOVE 
		FULL outer join dbo.INV_LINE_ITEM
		ON stove.SerialNumber = inv_line_item.fk_stovenbr
		WHERE inv_line_item.fk_stovenbr is not null 
		
		
		
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 3  [3pts possible]:
For every invoice, show the invoice number, the name of the customer, and the name of the employee.  You will need to
join the INVOICE table with EMPLOYEE and CUSTOMER using the appropriate join conditions.  Show the results in ascending
order of invoice number.' + CHAR(10)

SELECT customer.name, I.invoicenbr, E.name
FROM dbo.customer
JOIN dbo.invoice I
ON customer.customerid = I.FK_CustomerID
JOIN dbo.employee E
ON I.fk_empid = E.empid
ORDER BY I.invoicenbr ASC

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 4  [3pts possible]:
List all stove repairs; show the repair number, description, and the total cost of the repair.  You will need to 
join with the REPAIR_LINE_ITEM TABLE and add up the values of ExtendedPrice using SUM. ' + CHAR(10)


SELECT RepairNbr, Description, SUM(RR.extendedprice) TotalPrice
FROM dbo.stove_repair
JOIN dbo.repair_line_item RR
ON rr.fk_repairnbr = stove_repair.RepairNbr
group by repairnbr, description


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 5  [3pts possible]:
Show the name of every employee along with the total number of stove repairs performed by them
(this may be zero - be sure to show every employee!).  You will need to perform an outer join on
EMPLOYEE and STOVE_REPAIR.  Sort the results in descending order by the number of repairs.' + CHAR(10)

SELECT employee.Name, count(stove_repair.repairnbr) as NumberOfRepairs
FROM dbo.employee
full outer join dbo.stove_repair
ON employee.empid = stove_repair.fk_empid
group by employee.name
order by numberofrepairs desc




GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 6  [3pts possible]:
Which sales were made in May of 2002? Display the invoice number, invoice date, and stove number (if any).
Use BETWEEN to specify the date range and list in chronological order by invoice date.' + CHAR(10)


SELECT invoicenbr, invoicedt, fk_stovenbr
from dbo.invoice
join dbo.inv_line_item
on inv_line_item.fk_invoicenbr = invoice.invoicenbr
where invoicedt between '2002-05-01' and '2002-05-31'
order by invoicedt asc
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 7  [3pts possible]:
Show a list of all states from the CUSTOMER table; for each, display the state, the total 
number of customers in that state, and the total number of suppliers there.  Include all
states from CUSTOMER even if they have no suppliers.  Order results by state.' + CHAR(10)

select * from dbo.customer
select * from dbo.supplier

SELECT customer.stateprovince, totalCustomers, TotalSuppliers 
from (select stateprovince, count(CustomerID) totalcustomers from dbo.customer group by stateprovince) customer
full join
	 (select state, count(name) totalSuppliers from dbo.supplier group by state) supplier
	 ON customer.stateprovince = supplier.state
	 order by state;


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 8  [3pts possible]:
Display a list of all stove repairs; for each, show the customer name, address, city/state/zip code (concatenated 
these last three into a single readable column), the repair date, and a description of the repair.  Order by 
repair date, and format all output.  Use an alias for the table names, and apply the alias to the beginning of 
the columns projected; e.g.:

SELECT t.COLUMN1
FROM   TABLENAME AS t
WHERE  t.COLUMN2 = 10;' + CHAR(10)


select c.name, c.streetaddress, concat(c.city, c.stateprovince, c.zipcode) as 'city/state.zip', r.repairdt, r.description
from dbo.customer as c
		FULL outer join dbo.stove_repair as r
		on c.customerid = r.fk_customerid
order by repairdt desc

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 9  [3pts possible]:
Show a list of each supplier, along with a cash total of the extended price for all of their purchase orders. 
Display the supplier name and price total; sort alphabetically by supplier name and show the total in money 
format (i.e. $ and two decimal places ); rename the columns using AS.  Hint: you will need to join three tables,
use GROUP BY, and SUM(). ' + CHAR(10)

select * from dbo.supplier
select * from dbo.purchase_order order by fk_suppliernbr asc
select * from po_line_item order by extendedprice

select supplier.Name, '$' + convert(varchar(12),SUM(extendedprice), 1) TotalPrice
from dbo.supplier
join dbo.purchase_order 
on supplier.suppliernbr = purchase_order.fk_suppliernbr
join dbo.po_line_item
on purchase_order.ponbr = po_line_item.fk_ponbr
group by name
order by name asc



GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 10  [3pts possible]:
For each invoice, show the total cost of all parts; this is calculated by multiplying the invoice Quantity by the 
Cost for the part.   Show the invoice number and total cost (one line per invoice!).  Format all output (show 
money appropriately).' + CHAR(10)


select fk_invoicenbr, '$' + convert(varchar(12),sum(p.cost * inv_line_item.quantity),1) as totalPrice 
from dbo.inv_line_item
full join dbo.invoice i
on i.totalprice = inv_line_item.extendedprice
full join part p
on p.partnbr = inv_line_item.fk_partnbr
group by fk_invoicenbr 


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 11  [3pts possible]:
Show the customer id, name, and the total of invoice extended price values for all customers who live in Oregon 
(exclude all others!).  Your output should include only one line for each customer.  Sort by customer ID.' + CHAR(10)

select customerid, name, '$' + convert(varchar(12),sum(extendedprice), 1) TotalPrice
from dbo.customer
join dbo.invoice
on customer.customerid = invoice.fk_customerid
join dbo.inv_line_item
on invoice.invoicenbr = inv_line_item.fk_invoicenbr
where stateprovince = 'OR'
group by customerid, name
order by customerid ASC


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 12  [3pts possible]:
For every invoice, display the invoice number, customer name, phone number, and email address.  Include duplicates 
where more than one email address or phone number exists.  List in order of customer name; format all output.' + CHAR(10)

select invoicenbr as Invoice, customer.name as customerName, phone.phonenbr as phoneNumber, email.emailaddress as emailAddress
from dbo.customer
join dbo.email
on email.fk_customerid = customer.customerid
join dbo.invoice
on invoice.fk_customerid = customer.customerid
join dbo.phone
on phone.fk_customerid = customer.customerid
order by name asc


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 13  [3pts possible]:
For every stove repair, display the stove serial number, Type and Version, the Cost of the repair, the Price of the
stove, and the percentage of the Price which the repair actually cost (i.e. Cost divided by Price).  Try to display
this last value as a whole number with a percentage sign (%).' + CHAR(10)

select serialnumber, stove.type as TypeofStove, stove.version, '$' + convert(varchar(12),stove_repair.cost,1) as RepairCost, '$' + convert(varchar(12),stove_type.price,1) as PriceofStove, cast(cast((Cost/Price)*100 as decimal(18,0)) as varchar(5)) + '%' as Percentage
from dbo.stove
join dbo.stove_repair
on stove_repair.fk_stovenbr = stove.serialnumber
join stove_type
on stove_type.type = stove.type
group by serialnumber, stove.type, stove.version, cost, price


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 14  [3pts possible]:
For every part, display the part number, description, the total number of repairs involving this part, the total
Quantity of the part for those repairs (use SUM), the total number of invoices involving this part, and the total
Quantity of the part for those invoices.  Use OUTER JOINs to display information for all parts, even if they are not
involved with any repairs or invoices.  You can solve this using only three tables (but be sure to avoid duplicates in
your counts!)...  Sort the output by part number.' + CHAR(10)


select partnbr as Part#, part.description as Description, count(r.quantity) as Total#Repairs, sum(r.quantity) as TotalQuantityofPart, count(I.fk_invoicenbr) as Total#InvoicesofPart, sum(I.quantity) as TotalQuantInvoices
from dbo.part
full outer join dbo.inv_line_item I
on part.partnbr = I.fk_partnbr
full outer join dbo.repair_line_item R
on r.fk_partnbr = part.partnbr
group by partnbr, r.quantity, part.description
order by partnbr
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 8, Question 15  [3pts possible]:
Which invoices have involved parts whose name contains the words "widget" or "whatsit" (anywhere within the 
string)?  Display the invoice number and invoice date; sort output by invoice number.' + CHAR(10)
select * from part
select * from invoice
select * from inv_line_item

select invoicenbr as Invoice#, invoicedt as InvoiceDate
from dbo.invoice
full outer join dbo.inv_line_item INV
on inv.fk_invoicenbr = invoice.invoicenbr
full outer join dbo.part P
on p.partnbr = inv.fk_partnbr
where description like '%Widget%' 
	or description like '%Whatsit%' 
order by invoicenbr


GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 8' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


