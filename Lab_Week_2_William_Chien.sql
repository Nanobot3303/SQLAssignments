/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 2: using SQL SERVER 2012 and the FiredUp database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   William Chien
                DATE:      10/6/17

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
PRINT 'CIS2275, Lab Week 2, Question 1  [3pts possible]:
Write the query to project everything (all columns, all rows) from the CUSTOMER table.' + CHAR(10)
SELECT *
FROM dbo.CUSTOMER
ORDER By Name ASC;
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 2, Question 2  [3pts possible]:
Project the SerialNumber, Type, Version, and Color for all rows in the STOVE table.' + CHAR(10)
SELECT SerialNumber, Type, Version, Color
FROM dbo.STOVE
ORDER By SerialNumber ASC
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 2, Question 3  [3pts possible]:
Display the part number and description for all parts; show results in ascending order of SalesPrice.' + CHAR(10)
SELECT PartNbr, Description
FROM dbo.PART
ORDER By SalesPrice ASC
GO



GO
PRINT CHAR(10) + 'CIS2275, Lab Week 2, Question 4  [3pts possible]:
Write a query to display the Description and Sales Price for part number 569:' + CHAR(10)
SELECT Description, SalesPrice, PartNbr=569
FROM dbo.PART
GO


GO
PRINT CHAR(10) + 'CIS2275, Lab Week 2, Question 5  [3pts possible]:
Display everything from the PART table which has a Cost greater than $1.
Re-name each column using the AS keyword.' + CHAR(10)
SELECT * 
FROM dbo.PART
WHERE SalesPrice > $1 
SELECT PartNbr AS part#, Description AS Descriptionnn, Cost AS CostofPart, SalesPrice AS Price
FROM dbo.PART


GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 2' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


