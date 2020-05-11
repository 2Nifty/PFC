--166,907
select * from tempLabelData

--166,907
select distinct ItemNo from tempLabelData


--EnterpriseSQL = 773,745
SELECT DISTINCT (replace(Item.No_,'-','')) as ItemNo,

		UOM.[Super Equivalent] as SuperEquiv,
		UOM.[Sales Qty Alt_] as ALTQTY,

		Item.[Size No_ Description],
		Item.[Cat_ No_ Description],
		Item.[Plating Type],
		REPLICATE(' ',6-len(cast (cast (UOM.[Alt_ Base Qty_] as integer) as char(6)))) + (cast (cast (UOM.[Alt_ Base Qty_] as integer) as char(6))) as BaseQty,
		Item.[Base Unit of Measure],
		'      ' as Whse,
		'       ' as UnitCost,
		REPLICATE(' ',7-len(cast (cast (Item.[Unit Price] as decimal(7,2)) as char(7)))) + (cast (cast (Item.[Unit Price] as decimal(7,2)) as char(7))) as [Unit Price],
		Item.[UPC Code],
		'        ' as INVALF,
		'  ' as BOXCODE,
		REPLICATE(' ',6-len(cast (cast (Item.[Gross Weight] as decimal(7,2)) as char(7)))) + (cast (cast (Item.[Gross Weight] as decimal(7,2)) as char(7))) as Gross,
		REPLICATE(' ',7-len(cast (cast (Item.[Weight_100] as decimal(7,2)) as char(7)))) + (cast (cast (Item.[Weight_100] as decimal(7,2)) as char(7))) as CWgt,
		'  ' as COUNTRY,
		REPLICATE(' ',6-len(cast (cast (UOM.[Qty_ per Unit of Measure] as integer) as char(6)))) + (cast (cast (UOM.[Qty_ per Unit of Measure] as integer) as char(6))) as QTYPERUOM,
		' ' as CorpClass,
		UOM.Code,
		' ' as Basis,
		'       ' as INCOMP,
		'  ' as INCMPD,
		RIGHT(Item.[Cat_ No_ Description Alt_ 1], 30) as INPKDS1,
		RIGHT(Item.[Cat_ No_ Description Alt_ 2], 30) as INPKDS2,
		RIGHT(Item.[Cat_ No_ Description Alt_ 3], 30) as INPKDS3,
		Item.[Size No_ Description Alt_ 1]+'          ' as INPKSZ1,
		'                              ' as INPKSZ2
FROM    	Porteous$Item Item
inner JOIN	[Porteous$Item Unit of Measure] UOM ON
		Item.No_ = UOM.[Item No_]
where		Item.No_ >= '00000-0000-000' AND
		Item.No_ <= '99999-9999-999' AND
		Item.[Unit Price] < 10000  AND
		Item.[Gross Weight] < 10000 AND
		Item.[Weight_100] < 10000
--and Item.No_='00200-4200-401'





select distinct [No_]
into tLabelData
from Porteous$Item Item
where		Item.No_ >= '00000-0000-000' AND
		Item.No_ <= '99999-9999-999' AND
		Item.[Unit Price] < 10000  AND
		Item.[Gross Weight] < 10000 AND
		Item.[Weight_100] < 10000


select * from  Porteous$Item where No_='00024-3072-401'