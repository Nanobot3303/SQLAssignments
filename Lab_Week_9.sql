/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 9: using SQL SERVER 2012 and the FiredUp database
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
PRINT 'CIS2275, Lab Week 9, Question 1  [3pts possible]:
Show the serial numbers of all the "FiredAlways" stoves which have been invoiced.  Use whichever method you prefer 
(a join or a subquery).  List in order of serial number and eliminate duplicates.' + CHAR(10)


select distinct serialnumber
from dbo.stove
join dbo.inv_line_item INV
on inv.fk_stovenbr = stove.serialnumber
join dbo.invoice I
on i.invoicenbr = inv.fk_invoicenbr
where type like 'FiredAlways'
order by serialnumber asc

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 2  [3pts possible]:
Show the name and email address of all customers who have ever brought a stove in for repair (include duplicates and 
ignore customers without email addresses). ' + CHAR(10)

select name, emailaddress
from dbo.customer
join dbo.email E
on e.fk_customerid = customer.customerid
join dbo.stove_repair R
on r.fk_customerid = customer.customerid



GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 3  [3pts possible]:
What stoves have been sold to customers with the last name of "Smith"?  Display the customer name, stove number, stove 
type, and stove version and show the results in customer name order.' + CHAR(10)

select name as CustomerName, serialnumber as Stove#, type as StoveType, Version as StoveVersion
from dbo.customer
join dbo.invoice i
on customer.customerid = i.fk_customerid
join inv_line_item inv
on inv.fk_invoicenbr = i.invoicenbr
join dbo.stove s
on s.serialnumber = inv.fk_stovenbr
where name like '%Smith%'
order by name asc

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 4  [3pts possible]:
What employee has sold the most stoves in the most popular state?  ("most popular state" means the state or states for 
customers who purchased the most stoves, regardless of the stove type and version; do not hardcode a specific state 
into your query)  Display the employee number, employee name, the name of the most popular state, and the number of 
stoves sold by the employee in that state.  If there is more than one employee then display them all.' + CHAR(10)


select top 1 count(stateprovince) #StoveSold, empid as Employee#, e.name as EmployeeName, stateprovince as MostPopularState
from dbo.customer
join dbo.invoice i
on i.fk_customerid = customer.customerid
join dbo.employee e
on e.empid = i.fk_empid
group by stateprovince, empid, e.name
order by #StoveSold desc

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 5  [3pts possible]:
Identify all the sales associates who have ever sold the FiredAlways version 1 stove; show a breakdown of the total 
number sold by color.  i.e. for each line, show the employee name, the stove color, and the total number sold.  Sort 
the results by name, then color.' + CHAR(10)

select name, color, count(color) Total#SoldbyColor
from dbo.invoice
join dbo.inv_line_item i
on i.fk_invoicenbr = invoice.invoicenbr
join dbo.stove s
on s.serialnumber = i.fk_stovenbr
join dbo.employee e
on e.empid = invoice.fk_empid
where type like '%FiredAlways%' AND version = '1'
group by color, name



GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 6  [3pts possible]:
Show the name and phone number for all customers who have a Hotmail address (i.e. an entry in the EMAIL table which 
ends in hotmail.com).  Include duplicate names where multiple phone numbers exist; sort results by customer name.' + CHAR(10)


select name, phonenbr, emailaddress
from dbo.customer
full outer join dbo.email e
on e.fk_customerid = customer.customerid
join dbo.phone p
on p.fk_customerid = customer.customerid
where emailaddress like '%hotmail.com%'
order by name

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 7  [3pts possible]:
Show the purchase order number, average SalesPrice, and average ExtendedPrice for parts priced between $1 and $2 which 
were ordered from suppliers in Virginia.  List in descending order of average ExtendedPrice.  Format all output. ' + CHAR(10)

select Ponbr as PurchaseOrder#, '$' + convert(varchar(10),avg(salesprice)) as AvgSales, '$' + convert(varchar(12),avg(extendedprice),1) as AvgExtended
from dbo.purchase_order
join dbo.po_line_item p
on p.fk_ponbr = purchase_order.ponbr
join dbo.part 
on part.partnbr = p.fk_partnbr
join dbo.supplier s
on s.suppliernbr = purchase_order.fk_suppliernbr
where part.cost between '1' and '2'
group by ponbr
order by avgextended desc


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 8  [3pts possible]:
Which invoice has the second-lowest total price among invoices that do not include a sale of a FiredAlways stove? 
Display the invoice number, invoice date, and invoice total price.  If there is more than one invoice then display all 
of them. (Note: finding invoices that do not include a FiredAlways stove is NOT the same as finding invoices where a 
line item contains something other than a FiredAlways stove -- invoices have more than one line.  Avoid a JOIN with the 
STOVE since the lowest price may not involve any stove sales.)' + CHAR(10)

SELECT TOP 1 WITH TIES
       InvoiceNbr AS 'Invoice Number',
       InvoiceDt AS 'Invoice Date',
       TotalPrice AS 'Invoice Total Price'
FROM (SELECT TOP 2 WITH TIES
             InvoiceNbr ,
             InvoiceDT ,
             TotalPrice 
      FROM INVOICE
      WHERE InvoiceNbr NOT IN (SELECT FK_InvoiceNbr
                               FROM INV_LINE_ITEM
                               WHERE FK_StoveNbr IN (SELECT serialnumber
                                                     FROM STOVE
                                                    WHERE type = 'FiredAlways'))
      ORDER BY TotalPrice ASC) as MYTABLE
ORDER BY 'Invoice Total Price' DESC;



GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 9  [3pts possible]:
What employee(s) have sold the most stoves in the least popular color ("least popular color" means the color that has 
been purchased the least number of times, regardless of the stove type and version. Do not hardcode a specific color 
into your query)?  If there is more than one employee tied for the most then display them all.  If there is a tie for 
"least popular color" then you may pick ANY of them.  Display the employee name, number of stoves sold, and the least 
popular color.' + CHAR(10)

--What is asked
--select employee.name as name, inv_line_item.quantity as QuantitySold, --least popular color

--databases: EMPLOYEE, INV_LINE_ITEM, INVOICE, STOVE

--CONDITION: EMPLOYEE THAT SOLD THE MOST STOVES
			--THE LEAST POPULAR COLOR
select * from inv_line_item

--WHICH EMPLOYEE SOLD THE MOST AMOUNT OF STOVES:
select top 1 name, max(quantity) as #ofStoveSold
from dbo.employee
join dbo.invoice i
on i.fk_empid = employee.empid
join dbo.inv_line_item inv
on inv.fk_invoicenbr = i.invoicenbr
group by name, quantity
order by #ofStoveSold desc 

--least popular color 
select top 1 color, count(quantity) as #ofStoves
from dbo.inv_line_item
join dbo.stove 
on stove.serialnumber =  inv_line_item.fk_stovenbr
group by color
order by #ofStoves ASC











GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 9, Question 10  [3pts possible]:
Show a breakdown of all part entries in invoices.  For each invoice, show the customer name, invoice number, the number 
of invoice lines for parts (exclude stoves!), the total number of parts for the invoice (add up Quantity), and the total 
ExtendedPrice values for these parts.  Format all output; sort by customer name, then invoice number. ' + CHAR(10)
--
-- [Insert your code here]
--
GO


GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 9' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


