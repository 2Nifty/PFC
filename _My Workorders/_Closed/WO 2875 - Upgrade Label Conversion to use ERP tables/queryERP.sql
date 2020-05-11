--486,386
select * from tIMLabelCNV

--167546
select distinct ItemNo from tIMLabelCNV


select distinct ItemNo from tIMLabelCNV
where ItemNo not in 
(select distinct ItemNo from OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tempLabelData)



--PERP = 776,328
SELECT DISTINCT (replace(Item.ItemNo,'-','')) as ItemNo,

		--UOM.[Super Equivalent] as SuperEquiv,
		CASE WHEN UOM.UM = Item.SuperUM THEN 1 ELSE 0 END as SuperEquiv,

		--UOM.[Sales Qty Alt_] as ALTQTY,
		CASE WHEN UOM.AltSellStkUMQty = Item.SellStkUMQty THEN 1 ELSE 0 END as ALTQTY,

		Item.ItemSize as [Size No_ Description],
		Item.CatDesc as [Cat_ No_ Description],
		Item.Finish as [Plating Type],
		REPLICATE(' ',6-len(cast (cast (UOM.AltSellStkUMQty as integer) as char(6)))) + (cast (cast (UOM.AltSellStkUMQty as integer) as char(6))) as BaseQty,
		Item.SellStkUM as [Base Unit of Measure],
		'      ' as Whse,
		'       ' as UnitCost,
		REPLICATE(' ',7-len(cast (cast (Item.ListPrice as decimal(7,2)) as char(7)))) + (cast (cast (Item.ListPrice as decimal(7,2)) as char(7))) as [Unit Price],
		Item.UPCCd as [UPC Code],
		'        ' as INVALF,
		'  ' as BOXCODE,
		REPLICATE(' ',6-len(cast (cast (Item.GrossWght as decimal(7,2)) as char(7)))) + (cast (cast (Item.GrossWght as decimal(7,2)) as char(7))) as Gross,
		REPLICATE(' ',7-len(cast (cast (Item.HundredWght as decimal(7,2)) as char(7)))) + (cast (cast (Item.HundredWght as decimal(7,2)) as char(7))) as CWgt,
		'  ' as COUNTRY,
		REPLICATE(' ',6-len(cast (cast (UOM.QtyPerUM as integer) as char(6)))) + (cast (cast (UOM.QtyPerUM as integer) as char(6))) as QTYPERUOM,
		' ' as CorpClass,
		UOM.UM,
		' ' as Basis,
		'       ' as INCOMP,
		'  ' as INCMPD,
		RIGHT(Item.CategoryDescAlt1, 30) as INPKDS1,
		RIGHT(Item.CategoryDescAlt2, 30) as INPKDS2,
		RIGHT(Item.CategoryDescAlt3, 30) as INPKDS3,
		Item.SizeDescAlt1 + '          ' as INPKSZ1,
		'                              ' as INPKSZ2
FROM    	ItemMaster Item (NoLock) INNER JOIN
		ItemUM UOM (NoLock)
ON		Item.pItemMasterId = UOM.fItemMasterID
WHERE		isnull(Item.DeleteDt,0) = 0 AND
		Item.ItemStat = 'S' AND
		Item.ItemNo >= '00000-0000-000' AND
		Item.ItemNo <= '99999-9999-999' AND
		Item.ListPrice < 10000  AND
		Item.GrossWght < 10000 AND
		Item.HundredWght < 10000
and  Item.ItemNo='00200-4200-401'


select DiameterDesc, * from ItemMaster
where ItemNo='00200-4200-401'

exec sp_columns 

select distinct ItemStat from ItemMaster
select ItemStat, * from ItemMaster
select * from ItemUm


select  * from ItemMaster Item
WHERE		isnull(Item.DeleteDt,0) = 0 AND
		Item.ItemStat = 'S' AND
		Item.ItemNo >= '00000-0000-000' AND
		Item.ItemNo <= '99999-9999-999' AND
		Item.ListPrice < 10000  AND
		Item.GrossWght < 10000 AND
		Item.HundredWght < 10000

and ItemNo not in 
(select distinct No_ from OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tLabelData)
