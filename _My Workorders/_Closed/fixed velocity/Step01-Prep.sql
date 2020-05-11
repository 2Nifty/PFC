--Make everything BLANK
update Porteous$Item
set [Corp Fixed Velocity Code] = ''
go


-- I) Assign 'N' if there is no Carson SKU for the item
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'N'
WHERE	(NOT EXISTS
	(SELECT	[Item No_], [Location Code]
	 FROM	[Porteous$Stockkeeping Unit]
	 WHERE	[Item No_] = Porteous$Item.No_ AND [Location Code] = '01'))
go


-- II) Assign 'N' if the Carson SKU Sales Velocity Code is 'N'
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'N'
WHERE	(EXISTS
     	(SELECT	[Item No_], [Location Code], [Sales Velocity Code]
	 FROM	[Porteous$Stockkeeping Unit]
	 WHERE	Porteous$Item.No_ = [Item No_] AND [Location Code] = '01' AND [Porteous$Stockkeeping Unit].[Sales Velocity Code] = 'N'))
go


-- III) Assign 'N' to all items whose Category number is 70000-80000 OR 99999 OR if the items Variance code is 2** should be set to N.
UPDATE	Porteous$Item
SET	[Corp Fixed Velocity Code] = 'N'
WHERE	(SUBSTRING(No_, 1, 5) >= '70000') AND (SUBSTRING(No_, 1, 5) <= '80000') OR (SUBSTRING(No_, 1, 5) >= '99999') OR (SUBSTRING(No_, 12, 1) = '2')
go