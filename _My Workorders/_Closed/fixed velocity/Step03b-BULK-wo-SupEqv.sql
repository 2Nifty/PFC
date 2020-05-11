
--BULK
--Create tempVelocity table of BULK Items that have NO Super Equiv
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tempVelocity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[tempVelocity]
go

SELECT		[Item No_], SUM (Quantity) AS Quantity, [Net Weight], SUM(Quantity * [Net Weight]) AS Pounds
INTO		tempVelocity
FROM		(SELECT	[Porteous$Actual Usage Entry].[Item No_], [Porteous$Actual Usage Entry].[Usage Location], [Porteous$Actual Usage Entry].[Posting date], [Porteous$Actual Usage Entry].Quantity, Porteous$Item.[Net Weight], Porteous$Item.[Super Equiv_ UOM], Porteous$Item.[Super Equiv_ Qty_]
FROM		[Porteous$Actual Usage Entry] INNER JOIN
		Porteous$Item ON [Porteous$Actual Usage Entry].[Item No_] = Porteous$Item.No_
		WHERE ([Porteous$Actual Usage Entry].[Exclude from Usage (ILE)] = 0) AND (DATEDIFF(d, [Porteous$Actual Usage Entry].[Posting date], GETDATE()) < 365) AND (SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '0' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '1' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '2' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '3' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '5')) AUE
GROUP BY	[Item No_], [Net Weight], [Super Equiv_ UOM]
HAVING		([Super Equiv_ UOM] = '')
ORDER BY	[Item No_]


--Update 'A' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'A'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 142000) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go


--Update 'B' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'B'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 84300) AND (Pounds / 12 < 142000) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'C' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'C'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 29800) AND (Pounds / 12 < 84300) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'D' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'D'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 10350) AND (Pounds / 12 < 29800) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'E' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'E'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 6350) AND (Pounds / 12 < 10350) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'F' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'F'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 1800) AND (Pounds / 12 < 6350) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'G' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'G'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 >= 135) AND (Pounds / 12 < 1800) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'H' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'H'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE (Pounds / 12 > 0) AND (Pounds / 12 < 135) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'I' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'I'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Pounds / 12) <= 0) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = ''))) OR
	(NOT EXISTS
	(SELECT * FROM tempVelocity) AND ([Corp Fixed Velocity Code] = ''))
go
