
SELECT     Porteous$Item.No_, Porteous$Item.[Corp Fixed Velocity Code], [Porteous$Stockkeeping Unit].[Sales Velocity Code], [Porteous$Stockkeeping Unit].[Super Equiv_ Qty_], [Porteous$Stockkeeping Unit].[Super Equiv_ UOM], [Net Weight]
FROM         Porteous$Item INNER JOIN
                      [Porteous$Stockkeeping Unit] ON Porteous$Item.No_ = [Porteous$Stockkeeping Unit].[Item No_] AND 
                      [Porteous$Stockkeeping Unit].[Location Code] = 1
order by Porteous$Item.No_




--PKG
--Create tempVelocity table of PKG Items that have NO Super Equiv
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tempVelocity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[tempVelocity]
go

SELECT		[Item No_], SUM(Quantity) AS Quantity, [Net Weight], [Net Weight] AS Pounds
--INTO		tempVelocity
FROM		(SELECT	[Porteous$Actual Usage Entry].[Item No_], [Porteous$Actual Usage Entry].[Usage Location], [Porteous$Actual Usage Entry].[Posting date], [Porteous$Actual Usage Entry].Quantity, [Porteous$Stockkeeping Unit].[Super Equiv_ Qty_], [Porteous$Stockkeeping Unit].[Super Equiv_ UOM], Porteous$Item.[Net Weight]
FROM		[Porteous$Actual Usage Entry] INNER JOIN
		[Porteous$Stockkeeping Unit] ON [Porteous$Actual Usage Entry].[Usage Location] = [Porteous$Stockkeeping Unit].[Location Code] AND [Porteous$Actual Usage Entry].[Item No_] = [Porteous$Stockkeeping Unit].[Item No_] INNER JOIN
                [Porteous$Item] ON [Porteous$Stockkeeping Unit].[Item No_] = Porteous$Item.No_
		WHERE	(SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) <> 2) AND ([Porteous$Actual Usage Entry].[Exclude from Usage (ILE)] = 0) AND (DATEDIFF(d, [Porteous$Actual Usage Entry].[Posting date], GETDATE()) < 400) AND (SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '4' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '6' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '7' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '8' OR SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) = '9')) AUE
GROUP BY	[Item No_], [Net Weight], [Super Equiv_ UOM], Quantity
HAVING		([Super Equiv_ UOM] = '' and [Item No_]='00050-2616-971')
ORDER BY	[Item No_]





SELECT    Porteous$Item.No_, Porteous$Item.[Corp Fixed Velocity Code], [Porteous$Stockkeeping Unit].[Sales Velocity Code], 
                      tempVelocity.Quantity, tempVelocity.[Net Weight], tempVelocity.Pounds
FROM         Porteous$Item INNER JOIN
                      [Porteous$Stockkeeping Unit] ON Porteous$Item.No_ = [Porteous$Stockkeeping Unit].[Item No_] AND
			[Porteous$Stockkeeping Unit].[Location Code] = 1 AND Porteous$Item.[Corp Fixed Velocity Code] <> '' INNER JOIN
                      tempVelocity ON [Porteous$Stockkeeping Unit].[Item No_] = tempVelocity.[Item No_]
where [No_]='00050-2616-971'
order by Porteous$Item.No_


select [Location Code], [Item No_],  [Super Equiv_ UOM] from [Porteous$Stockkeeping Unit] where [Item No_]='00050-2616-971'


SELECT     Porteous$Item.No_, Porteous$Item.[Corp Fixed Velocity Code], [Porteous$Stockkeeping Unit].[Sales Velocity Code]
FROM         Porteous$Item INNER JOIN
                      [Porteous$Stockkeeping Unit] ON Porteous$Item.No_ = [Porteous$Stockkeeping Unit].[Item No_]
                     
where [No_]='00050-2616-971'
order by Porteous$Item.No_




SELECT	[Porteous$Actual Usage Entry].[Item No_], [Porteous$Actual Usage Entry].[Usage Location], [Porteous$Actual Usage Entry].[Posting date],
	[Porteous$Actual Usage Entry].Quantity as QTY, [Porteous$Stockkeeping Unit].[Super Equiv_ Qty_], [Porteous$Stockkeeping Unit].[Super Equiv_ UOM],
	Porteous$Item.[Net Weight]
FROM		[Porteous$Actual Usage Entry] INNER JOIN
		[Porteous$Stockkeeping Unit] ON [Porteous$Actual Usage Entry].[Usage Location] = [Porteous$Stockkeeping Unit].[Location Code] AND [Porteous$Actual Usage Entry].[Item No_] = [Porteous$Stockkeeping Unit].[Item No_] INNER JOIN
                [Porteous$Item] ON [Porteous$Stockkeeping Unit].[Item No_] = Porteous$Item.No_
		WHERE	(SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) <> 2) AND 
			([Porteous$Actual Usage Entry].[Exclude from Usage (ILE)] = 0) AND
			(DATEDIFF(d, [Porteous$Actual Usage Entry].[Posting date], GETDATE()) < 365) AND
			([Porteous$Actual Usage Entry].[Item No_] = '00050-2616-971')



SELECT	[Porteous$Actual Usage Entry].[Item No_], [Porteous$Actual Usage Entry].[Usage Location], [Porteous$Actual Usage Entry].[Posting date],
	[Porteous$Actual Usage Entry].Quantity as QTY, [Porteous$Stockkeeping Unit].[Super Equiv_ Qty_], [Porteous$Stockkeeping Unit].[Super Equiv_ UOM],
	Porteous$Item.[Net Weight]
FROM		[Porteous$Actual Usage Entry] INNER JOIN
		[Porteous$Stockkeeping Unit] ON [Porteous$Actual Usage Entry].[Usage Location] = [Porteous$Stockkeeping Unit].[Location Code] AND [Porteous$Actual Usage Entry].[Item No_] = [Porteous$Stockkeeping Unit].[Item No_] INNER JOIN
                [Porteous$Item] ON [Porteous$Stockkeeping Unit].[Item No_] = Porteous$Item.No_
		WHERE	(SUBSTRING([Porteous$Actual Usage Entry].[Item No_], 12, 1) <> 2) AND 
			([Porteous$Actual Usage Entry].[Exclude from Usage (ILE)] = 0) AND
			([Porteous$Actual Usage Entry].[Item No_] = '00050-2616-971')



select  * from [Porteous$Actual Usage Entry] where [Order Type]='Sale'