/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 6: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   William Chien	
                DATE:      11/7/2017

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
PRINT 'CIS2275, Lab Week 6, Question 1  [3pts possible]:
Show a unique list of supplier states (i.e. no duplication!).' + CHAR(10)

SELECT DISTINCT State
FROM dbo.SUPPLIER
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 2  [3pts possible]:
Write the query to project from invoices the average total price, the minimum total price, and the maximum total 
price.  Money should be formatted to two decimal places (use CAST or CONVERT).' + CHAR(10)
SELECT CONVERT(DECIMAL(10,2), AVG(TotalPrice)) AS "AVG", 
	   CONVERT(DECIMAL(10,2), MIN(TotalPrice)) AS "MIN", 
	   CONVERT(DECIMAL(10,2), MAX(TotalPrice)) AS "MAX"
FROM dbo.INVOICE
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 3  [3pts possible]:
Write a query to list each Type in the STOVE table along with the total number of stoves for that value (use 
GROUP BY with the aggregate function COUNT).  Now write another query to list each unique combination of 
Type and Version, along with the total number of stoves for that combination.' + CHAR(10)
SELECT COUNT(Type) AS "Count", Type
FROM dbo.STOVE
GROUP by Type



SELECT COUNT(*) As "# of Unique combinations", Type
FROM (
		SELECT DISTINCT Type, Version
		FROM dbo.STOVE) t
GROUP by Type


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 4  [3pts possible]:
Display the total Extended Price values from the INV_LINE_ITEM table broken down by invoice number.
Sort the results in descending order by the extended price total.' + CHAR(10)
SELECT ExtendedPrice, FK_InvoiceNbr
FROM dbo.INV_LINE_ITEM
ORDER by ExtendedPrice DESC

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 5  [3pts possible]:
Display the invoice number and the total number of parts for every invoice (hint: add up the Quantity value). 
Do NOT include stoves in your part totals.  Order the list by invoice number, and format output using CAST, 
CONVERT, and/or STR.' + CHAR(10)
SELECT FK_InvoiceNbr, CAST(SUM(Quantity) AS int) AS "Total # of Parts"
FROM dbo.inv_line_item
GROUP By FK_InvoiceNbr
ORDER by FK_InvoiceNbr
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 6  [3pts possible]:
Show the invoice number and total extended price (use SUM) for every invoice in the INV_INE_ITEM table; but omit
invoices whose total extended price is less than $100 (use the HAVING clause).' + CHAR(10)
SELECT FK_InvoiceNbr, SUM(ExtendedPrice)
FROM dbo.INV_LINE_ITEM
GROUP By FK_InvoiceNbr
HAVING SUM(ExtendedPrice) > 100
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 7  [3pts possible]:
Show the part number and total quantity for all parts in the PO_LINE_ITEM table whose total quantity is one gross
(144) or less.  Display results in ascending order by total quantity.' + CHAR(10)
SELECT FK_PartNbr, SUM(Quantity)
FROM dbo.PO_LINE_ITEM
GROUP By FK_PartNbr
HAVING SUM(Quantity) <= 144
ORDER by SUM(Quantity) DESC

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab 6, Question 8  [3pts possible]:
For each repair, show the repair number and total extended price (from the REPAIR_LINE_ITEM table).
i.e. show one line per repair number, with the SUM of ExtendedPrice values for that repair.
Display query results as [T]ext, and avoid this warning message:

    Warning: Null value is eliminated by an aggregate or other SET operation.' + CHAR(10)
SELECT FK_RepairNbr, SUM(ExtendedPrice) AS "Total Price"
FROM dbo.REPAIR_LINE_ITEM
GROUP by FK_RepairNbr


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab 6, Question 9  [3pts possible]:
Show the name, address, and city/state/ZIP code (these last three concatenated into a single line)for all  customers 
who do not live in an apartment.  Sort by customer number.' + CHAR(10)
SELECT Name, StreetAddress, (city +' ' + StateProvince + ' ' + ZipCode) AS 'City/State/ZIP', ApartmentNbr
FROM dbo.CUSTOMER
WHERE ApartmentNbr IS Null


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 10  [3pts possible]:
Use the CREATE TABLE statememnt to make a table in the database; include at least three columns of different data types.
You have access to 275Sandbox where you can actually run your SQL Statement to see if it works;
change from the default FiredUp database by using the pull-down database list on the taskbar, or by 
selecting Query -> Connection -> Change Connection.' + CHAR(10)
--
USE CIS275Sandboxx    -- switch to Sandbox database
BEGIN TRY
CREATE TABLE myTable22222(
	Column1 int PRIMARY KEY,
	Column2 char(25) NOT NULL,
	Column3 Numeric(4) NOT NULL);
END TRY
BEGIN CATCH END CATCH
GO

GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 11  [3pts possible]:
Based upon your work in last week''s lab, identify two entities which are involved in a one-to-many relationship.
Write the SQL statement to create the table on the n"oe" side of the relationship.
Make sure that you deafine a primry key for your table.' + CHAR(10)
--
USE CIS275Sandboxx    -- switch to Sandbox database
BEGIN TRY 
CREATE TABLE CUSTOMER
	(NAME NVARCHAR(20) PRIMARY KEY,
	 STREET_ADDRESS NVARCHAR(80),
	 JOIN_DATE NVARCHAR(80))
	 

CREATE TABLE LOYALTY
	(REWARDS_NUMBER NVARCHAR(20) PRIMARY KEY,
	 CUSTOMER_NAME NVARCHAR(80),
	 JOIN_DATE NVARCHAR(80));
END TRY
BEGIN CATCH END CATCH
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 12  [3pts possible]:
Write two separate SQL statements to insert data into the table that you just created.  Explicitly specify the columns,
into which the data should be inserted in corresponding order.' + CHAR(10)
--
USE CIS275Sandboxx    -- switch to Sandbox database
BEGIN TRY
INSERT dbo.LOYALTY (REWARDS_NUMBER, CUSTOMER_NAME, JOIN_DATE)
	VALUES (12345, 'BLAH BLAH', 'OCTOBER 31, 2017')

INSERT dbo.LOYALTY (REWARDS_NUMBER, CUSTOMER_NAME, JOIN_DATE)
	VALUES (999, 'HORSESHOE', 'JANUARY 1, 2020')
END TRY
BEGIN CATCH END CATCH	
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 13  [3pts possible]:
Select all rows from the new table you''ve just created (there should only be the two rows you just inserted!). 
Order the output by your table''s primary key; format all columns using CAST, CONVERT and/or STR.' + CHAR(10)
--

USE CIS275Sandboxx    -- switch to Sandbox database
SELECT *
FROM dbo.LOYALTY
ORDER by REWARDS_NUMBER

GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 14  [3pts possible]:
Write the SQL statement to add a column called "LastModified" to your table; this should be of the data type DATETIME.
Ensure that the column may not contain NULLs, and provide a DEFAULT value for rows that may have this value missing.' + CHAR(10)
--
USE CIS275Sandboxx    -- switch to Sandbox database


ALTER TABLE dbo.LOYALTY
	ADD Last_Modified datetime NOT NULL DEFAULT 'no input';


GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 6, Question 15  [3pts possible]:
Write the SQL statement to create the other table from the 1:N relationship above; link the two tables using the 
appropriate database CONSTRAINT.  What effect will this have on data inserted into the new table?  (answer with a PRINT
statement or in comments)' + CHAR(10)
--
USE CIS275Sandboxx    -- switch to Sandbox database
BEGIN TRY
CREATE TABLE Transactions 
	(TransactionNumber NVARCHAR(80) PRIMARY KEY,
	 FK_CustomerName NVARCHAR(20) NOT NULL,
	 FK_Loyalty NVARCHAR(80) NOT NULL,
	 FOREIGN KEY (FK_CustomerName) REFERENCES dbo.Customer(Name),
	 FOREIGN KEY (FK_Loyalty) REFERENCES dbo.Loyalty(Rewards_Number)) 
END TRY
BEGIN CATCH END CATCH
-- The changes made on the new table, make the same changes to the other table that it is attached to. 
GO


USE FiredUp -- Switch back to default database

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 6' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


