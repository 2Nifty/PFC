
--PKG
--Create tempVelocity table of PKG Items that have NO Super Equiv
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tempVelocity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[tempVelocity]
go

SELECT		[Item No_], SUM (Quantity) AS Quantity, [Net Weight], SUM(Quantity * [Net Weight]) AS Pounds
INTO		tempVelocity
FROM		(SELECT     [Porteous$Actual Usage Entry].[Item No_], [Porteous$Actual Usage Entry].[Usage Location], [Porteous$Actual Usage Entry].[Posting date], 
                                              [Porteous$Actual Usage Entry].Quantity, Porteous$Item.[Net Weight], Porteous$Item.[Super Equiv_ UOM], 
                                              Porteous$Item.[Super Equiv_ Qty_]
                       FROM          [Porteous$Actual Usage Entry] INNER JOIN
                                              Porteous$Item ON [Porteous$Actual Usage Entry].[Item No_] = Porteous$Item.No_
                       WHERE      ([Porteous$Actual Usage Entry].[Exclude from Usage (ILE)] = 0) AND (DATEDIFF(d, [Porteous$Actual Usage Entry].[Posting date], GETDATE()) 
                                              < 365) AND (SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '4' OR
                                              SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '6' OR
                                              SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '7' OR
                                              SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '8' OR
                                              SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '9')) AUE
GROUP BY	[Item No_], [Net Weight], [Super Equiv_ UOM]
HAVING		([Super Equiv_ UOM] = '')
ORDER BY	[Item No_]


--Update 'A' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'A'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 2040) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go


--Update 'B' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'B'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 1020) AND (Pounds / 12 < 2040) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'C' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'C'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 210) AND (Pounds / 12 < 1020) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'D' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'D'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 120) AND (Pounds / 12 < 210) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'E' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'E'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 60) AND (Pounds / 12 < 120) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'F' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'F'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 30) AND (Pounds / 12 < 60) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'G' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'G'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 3) AND (Pounds / 12 < 30) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'H' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'H'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 > 0) AND (Pounds / 12 < 3) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'I' items from tempVelocity (Pkg)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'I'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Pounds / 12) <= 0) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = ''))) OR
	(NOT EXISTS
	(SELECT * FROM tempVelocity) AND ([Corp Fixed Velocity Code] = ''))
go