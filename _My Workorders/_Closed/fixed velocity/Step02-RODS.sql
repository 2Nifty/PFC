
--RODS
--Create tempVelocity table of ROD Items that have a Super Equiv
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tempVelocity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[tempVelocity]
go

SELECT		[Item No_], SUM(Quantity) AS Quantity, [Super Equiv_ Qty_], [Super Equiv_ UOM]
INTO		tempVelocity
FROM		(SELECT	[Porteous$Actual Usage Entry].[Item No_], [Porteous$Actual Usage Entry].[Usage Location], [Porteous$Actual Usage Entry].[Posting date], [Porteous$Actual Usage Entry].Quantity, Porteous$Item.[Super Equiv_ UOM], Porteous$Item.[Super Equiv_ Qty_]
FROM		[Porteous$Actual Usage Entry] INNER JOIN
                Porteous$Item ON [Porteous$Actual Usage Entry].[Item No_] = Porteous$Item.No_
                WHERE	([Porteous$Actual Usage Entry].[Exclude from Usage (ILE)] = 0) AND (DATEDIFF(d, [Porteous$Actual Usage Entry].[Posting date], GETDATE()) < 365) AND (SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 1, 5) = '00170' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 1, 5) = '00171') AND (SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 2) = '50') OR (SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 1, 5) = '04170' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 1, 5) = '04171' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 1, 5) = '04172') AND (SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 3) = '500')) AUE
GROUP BY	[Item No_], [Super Equiv_ Qty_], [Super Equiv_ UOM]
HAVING		([Super Equiv_ UOM] <> '')
ORDER BY	[Item No_]
go



--Update 'A' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'A'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] >= 10.0) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go


--Update 'B' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'B'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] >= 4.0) AND ((Quantity / 12 / 25) / [Super Equiv_ Qty_] < 10.0) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'C' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'C'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] >= 1.6) AND ((Quantity / 12 / 25) / [Super Equiv_ Qty_] < 4.0) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'D' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'D'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] >= 0.7) AND ((Quantity / 12 / 25) / [Super Equiv_ Qty_] < 1.6) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'E' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'E'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] >= 0.3) AND ((Quantity / 12 / 25) / [Super Equiv_ Qty_] < 0.7) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'F' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'F'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] >= 0.1) AND ((Quantity / 12 / 25) / [Super Equiv_ Qty_] < 0.3) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'G' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'G'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] >= 0.01) AND ((Quantity / 12 / 25) / [Super Equiv_ Qty_] < 0.1) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'H' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'H'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] > 0) AND ((Quantity / 12 / 25) / [Super Equiv_ Qty_] < 0.01) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = '')))
go



--Update 'I' items from tempVelocity (BULK)
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'I'
WHERE	(EXISTS
	(SELECT * FROM tempVelocity
	 WHERE ((Quantity / 12 / 25) / [Super Equiv_ Qty_] <= 0) AND ([Item No_]=No_) AND ([Corp Fixed Velocity Code] = ''))) OR
	(NOT EXISTS
	(SELECT * FROM tempVelocity) AND ([Corp Fixed Velocity Code] = ''))
go
