exec sp_columns tempLabelData
exec sp_columns tIMLabelCNV


--166977
select count(*) from tempLabelData
select * from tempLabelData where ItemNo='005100708021'

--167019 (-42)
select count(*) from tIMLabelCNV
select * from tIMLabelCNV where ItemNo='005100708021'

--No items from the original file that did not convert to the new file
select ItemNo from tempLabelData
where ItemNo collate SQL_Latin1_General_CP1_CI_AS not in (select ItemNo from tIMLabelCNV)


--42 items in the new file that were not in the original
select ItemNo from tIMLabelCNV
where ItemNo collate SQL_Latin1_General_CP1_CI_AS not in (select ItemNo from tempLabelData)


--166977 records in new file also in orig file
select * from tIMLabelCNV
where ItemNo collate SQL_Latin1_General_CP1_CI_AS in (select ItemNo from tempLabelData)



--21329 differences
select	--New.*
Old.ItemNo,New.ItemNo,
rtrim(Old.[Size No_ Description]) as SizeDesc, rtrim(New.[Size No_ Description]) as SizeDesc,
Old.[Cat_ No_ Description],New.[Cat_ No_ Description],
Old.[Plating Type],New.[Plating Type],
cast(Old.BaseQty as numeric) as BaseQty, cast(New.BaseQty as numeric) as BaseQty,
Old.[Base Unit of Measure],New.[Base Unit of Measure],
Old.Whse,New.Whse,
Old.UnitCost,New.UnitCost,
Old.[Unit List Price],New.[Unit List Price],
Old.[UPC Code],New.[UPC Code],
Old.INVALF,New.INVALF,
Old.BOXCODE,New.BOXCODE,
Old.Gross,New.Gross,
Old.CWgt,New.CWgt,
Old.COUNTRY,New.COUNTRY,
cast(Old.QTYPERUOM as numeric) as QTYPERUOM, cast(New.QTYPERUOM as numeric) as QTYPERUOM,
Old.CorpClass,New.CorpClass,
Old.Code,New.Code,
Old.Basis,New.Basis,
Old.INCOMP,New.INCOMP,
Old.INCMPD,New.INCMPD,
Old.INPKDS1,New.INPKDS1,
Old.INPKDS2,New.INPKDS2,
Old.INPKDS3,New.INPKDS3,
Old.INPKSZ1,New.INPKSZ1,
Old.INPKSZ2,New.INPKSZ2
from	tIMLabelCNV New inner join
	tempLabelData Old 
ON	New.ItemNo = Old.ItemNo collate SQL_Latin1_General_CP1_CI_AS
WHERE
(New.ItemNo<>Old.ItemNo collate SQL_Latin1_General_CP1_CI_AS or 
New.[Size No_ Description]<>Old.[Size No_ Description] collate SQL_Latin1_General_CP1_CI_AS or 
New.[Cat_ No_ Description]<>Old.[Cat_ No_ Description] collate SQL_Latin1_General_CP1_CI_AS or 
New.[Plating Type]<>Old.[Plating Type] collate SQL_Latin1_General_CP1_CI_AS or 
cast(New.BaseQty as numeric)<>cast(Old.BaseQty as numeric) or 
New.[Base Unit of Measure]<>Old.[Base Unit of Measure] collate SQL_Latin1_General_CP1_CI_AS or 
New.Whse<>Old.Whse collate SQL_Latin1_General_CP1_CI_AS or 
New.UnitCost<>Old.UnitCost collate SQL_Latin1_General_CP1_CI_AS or 
New.[Unit List Price]<>Old.[Unit List Price] collate SQL_Latin1_General_CP1_CI_AS or 
New.[UPC Code]<>Old.[UPC Code] collate SQL_Latin1_General_CP1_CI_AS or 
New.INVALF<>Old.INVALF collate SQL_Latin1_General_CP1_CI_AS or 
New.BOXCODE<>Old.BOXCODE collate SQL_Latin1_General_CP1_CI_AS or 
New.Gross<>Old.Gross collate SQL_Latin1_General_CP1_CI_AS or 
New.CWgt<>Old.CWgt collate SQL_Latin1_General_CP1_CI_AS or 
New.COUNTRY<>Old.COUNTRY collate SQL_Latin1_General_CP1_CI_AS or 
cast(New.QTYPERUOM as numeric)<>cast(Old.QTYPERUOM as numeric) or 
New.CorpClass<>Old.CorpClass collate SQL_Latin1_General_CP1_CI_AS or 
New.Code<>Old.Code collate SQL_Latin1_General_CP1_CI_AS or 
New.Basis<>Old.Basis collate SQL_Latin1_General_CP1_CI_AS or 
New.INCOMP<>Old.INCOMP collate SQL_Latin1_General_CP1_CI_AS or 
New.INCMPD<>Old.INCMPD collate SQL_Latin1_General_CP1_CI_AS or 
New.INPKDS1<>Old.INPKDS1 collate SQL_Latin1_General_CP1_CI_AS or 
New.INPKDS2<>Old.INPKDS2 collate SQL_Latin1_General_CP1_CI_AS or 
New.INPKDS3<>Old.INPKDS3 collate SQL_Latin1_General_CP1_CI_AS or 
New.INPKSZ1<>Old.INPKSZ1 collate SQL_Latin1_General_CP1_CI_AS or 
New.INPKSZ2<>Old.INPKSZ2 collate SQL_Latin1_General_CP1_CI_AS)







--21329 differences - 16881 Gross Wght diffs = 4448 others - 3406 INPKSZ1 diffs = 1042 more
--I got rid of all the QTYPER discrepancies by truncating the ERP value. Now I have 1039 more
--I will ignore all of the Base Qty diffs because NV doesn't always re-calc - which leaves 953 discrepancies
-- **we need to make sure these are all calculated properly before golive.
--I will ignore the PCLB code also.  Now only 255
-- **It should be accurate as long as the PCLBFTInd is loaded properly in ERP.
--I got rid of the Unit Price diffs by rounding and then allowing for +/- 0.01.  Only 48 remain
select	--New.*
Old.ItemNo,New.ItemNo,
cast(Old.BaseQty as numeric) as BaseQty, cast(New.BaseQty as numeric) as BaseQty,
Old.[Unit List Price],New.[Unit List Price],

--round(cast(New.[Unit List Price] as decimal(18,6)),2) as NewPrice,
--round(cast(Old.[Unit List Price] as decimal(18,6)) + 0.01,2) as OldPricePlus,
--round(cast(Old.[Unit List Price] as decimal(18,6)) - 0.01,2) as OldPriceMinus,


--Old.Gross,New.Gross,
cast(Old.QTYPERUOM as numeric) as QTYPERUOM, cast(New.QTYPERUOM as numeric) as QTYPERUOM,
Old.Code,New.Code,
Old.INPKDS1,New.INPKDS1,
Old.INPKDS3,New.INPKDS3 --,
--Old.INPKSZ1,New.INPKSZ1
from	tIMLabelCNV New inner join
	tempLabelData Old 
ON	New.ItemNo = Old.ItemNo collate SQL_Latin1_General_CP1_CI_AS
WHERE
(
--cast(New.BaseQty as numeric)<>cast(Old.BaseQty as numeric) or 
(round(cast(New.[Unit List Price] as decimal(18,6)),2) > round(cast(Old.[Unit List Price] as decimal(18,6)) + 0.01,2) and
 round(cast(New.[Unit List Price] as decimal(18,6)),2) < round(cast(Old.[Unit List Price] as decimal(18,6)) - 0.01,2)) or 
--New.[Unit List Price]<>Old.[Unit List Price] collate SQL_Latin1_General_CP1_CI_AS or 
--New.Gross<>Old.Gross collate SQL_Latin1_General_CP1_CI_AS or 
--cast(New.QTYPERUOM as numeric)<>cast(Old.QTYPERUOM as numeric) or 
--New.Code<>Old.Code collate SQL_Latin1_General_CP1_CI_AS or 


--New.INPKDS1<>Old.INPKDS1 collate SQL_Latin1_General_CP1_CI_AS or 
New.INPKDS3<>Old.INPKDS3 collate SQL_Latin1_General_CP1_CI_AS --or 


--New.INPKSZ1<>Old.INPKSZ1 collate SQL_Latin1_General_CP1_CI_AS
)
order by New.ItemNo


--select [Size No_ Description Alt_ 1], * from [Porteous$Item] where No_='00019-2512-021'
--select SizeDescAlt1, * from ItemMaster where ItemNo='00019-2512-021'


select	ItemNo, CategoryDescAlt1, [Cat_ No_ Description Alt_ 1] as NV_CatDescAlt1, IM.*
from	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster IM inner join
	[Porteous$Item] NV
on	IM.ItemNo collate SQL_Latin1_General_CP1_CI_AS = NV.No_
where	IM.CategoryDescAlt1 collate SQL_Latin1_General_CP1_CI_AS <> [Cat_ No_ Description Alt_ 1]

select	ItemNo, CategoryDescAlt2, [Cat_ No_ Description Alt_ 2] as NV_CatDescAlt2, IM.*
from	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster IM inner join
	[Porteous$Item] NV
on	IM.ItemNo collate SQL_Latin1_General_CP1_CI_AS = NV.No_
where	IM.CategoryDescAlt2 collate SQL_Latin1_General_CP1_CI_AS <> [Cat_ No_ Description Alt_ 2]

select	ItemNo, CategoryDescAlt3, [Cat_ No_ Description Alt_ 3] as NV_CatDescAlt3, IM.*
from	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster IM inner join
	[Porteous$Item] NV
on	IM.ItemNo collate SQL_Latin1_General_CP1_CI_AS = NV.No_
where	IM.CategoryDescAlt3 collate SQL_Latin1_General_CP1_CI_AS <> [Cat_ No_ Description Alt_ 3]

select	IM.ItemNo, IM.ItemDesc as ERP_ItemDesc, IM.SizeDescAlt1 as ERP_SizeDescAlt1,
	NV.[Size No_ Description Alt_ 1] as NV_SizeDescAlt1, NV.[Description] as NV_Description  --, IM.*
from	OpenDataSource('SQLOLEDB','Data Source=pfcerpdb;User ID=pfcnormal;Password=pfcnormal').perp.dbo.ItemMaster IM inner join
	[Porteous$Item] NV (NoLock)
on	IM.ItemNo collate SQL_Latin1_General_CP1_CI_AS = NV.No_
where	IM.SizeDescAlt1 collate SQL_Latin1_General_CP1_CI_AS <> NV.[Size No_ Description Alt_ 1] 
order by ItemNo



select [Qty__Base UOM],* from [Porteous$Item] 
where No_='00510-0708-021'

select * from [Porteous$Item Unit of Measure] UOM (Nolock) where [Item No_]='00510-0708-021'


select No_, [Unit Price], REPLICATE(' ',7-len(cast (cast (Item.[Unit Price] as decimal(7,2)) as char(7)))) + (cast (cast (Item.[Unit Price] as decimal(7,2)) as char(7))) as [Unit Price]
from [Porteous$Item] Item where No_='00022-2432-411'




--recheck these
select [Size No_ Description Alt_ 1], [Last Date Modified], * from [Porteous$Item] where No_='00019-2512-021'
select [Cat_ No_ Description Alt_ 1], [Last Date Modified], * from [Porteous$Item] where No_ in ('00100-2661-011','00140-2520-021')
select [Cat_ No_ Description Alt_ 3], [Last Date Modified], * from [Porteous$Item] where No_='02342-2018-401'


select [Qty__Base UOM],* from [Porteous$Item] 
where No_='00510-0708-021'

--select SizeDescAlt1, changeid, changedt,* from ItemMaster where ItemNo='00019-2512-021'




SELECT	Porteous$Item.[No_] AS ItemNo, 
--	isnull((SELECT	MAX([No_])
--		FROM	[Porteous$Production BOM Line]
--		WHERE	[Line No_] = 10000 AND [Porteous$Production BOM Line].[Production BOM No_] = [Porteous$Item].[No_]),'') AS ParentProdNo,
	Porteous$Item.[Description] AS ItemDesc,
	'S' AS ItemStat,
	'N' AS Rectrans,
	'' AS Specification,
	Porteous$Item.[Harmonizing Tariff Code] AS Tariff,
	Porteous$Item.[Cat_ No_ Description] AS CatDesc,
	Porteous$Item.[Plating Type] AS Finish,
	Porteous$Item.[Size No_ Description] AS ItemSize,
	Porteous$Item.[Item Disc_ Group] as PriceCat,
	Porteous$Item.[Super Equiv_ Qty_] * Porteous$Item.[Qty__Base UOM] AS PcsPerPallet,
	Porteous$Item.[Base Unit of Measure] AS SellStkUM,
	Porteous$Item.[Qty__Base UOM] AS SellStkUMQty,
--	isnull((SELECT	MAX([Purchase Price Per Alt_])
--		FROM	[Porteous$Item Unit of Measure]
--		WHERE	[Porteous$Item Unit of Measure].[Item No_] = Porteous$Item.[No_] AND [Purchase Qty Alt_] = 1),'') AS CostPurUM,
--	isnull((SELECT	MAX([Purchase Price Per Alt_])
--		FROM	[Porteous$Item Unit of Measure]
--		WHERE	[Porteous$Item Unit of Measure].[Item No_] = Porteous$Item.[No_] AND [Purchase Qty Alt_] = 1),'') AS PriceUM,
	Porteous$Item.[Super Equiv_ UOM] AS SuperUM,
--	isnull((SELECT	MAX([Sales Price Per Alt_])
--		FROM	[Porteous$Item Unit of Measure]
--		WHERE	[Porteous$Item Unit of Measure].[Item No_] = Porteous$Item.[No_] AND [Sales Qty Alt_] = 1),'') AS SellUM,
--	isnull((SELECT	MAX(Code)
--		FROM	[Porteous$Item Unit of Measure]
--		WHERE	[Porteous$Item Unit of Measure].[Item No_] = Porteous$Item.[No_] AND Code = 'SL'),'') AS SleeveUM,
	Porteous$Item.[Base Unit of Measure] AS StkUM,
	Porteous$Item.[Net Weight] AS Wght,
	Porteous$Item.[Gross Weight] AS GrossWght,
	Porteous$Item.[Gross Weight] * [Super Equiv_ Qty_] AS CUMGrossWght,
	Porteous$Item.[Net Weight] * [Super Equiv_ Qty_] AS CUMNetWght,
	Porteous$Item.[Weight_100] AS HundredWght,
	Porteous$Item.[UPC Code] AS UPCCd,
	'50' AS CommodityCd,
	'N' AS SerialNoCd,
	'N' AS FormatCd,
	Porteous$Item.[Hazardous] AS HazMatInd,
	Porteous$Item.[Web Enabled] AS WebEnabledInd,
	Porteous$Item.[Corp Fixed Velocity Code] AS CorpFixedVelocity,
	Porteous$Item.[Date Created] AS EntryDt,
	'WO1481' AS EntryID,
	Porteous$Item.[Last Date Modified] AS ChangeDt,
	Porteous$Item.[Category Velocity Code] AS CatVelocityCd,
	Porteous$Item.[Unit Price] AS ListPrice,
	Porteous$Item.[PriceWorkSheetColorInd] AS PriceWorkSheetColorInd,
	Porteous$Item.[Package Grouping] AS PackageGroup,
	Porteous$Item.[Item Group Code] AS ItemPriceGroup,
	Porteous$Item.[Cert] AS CertRequiredInd,
	Porteous$Item.[PPI Code] AS PPICode,
	Porteous$Item.[FQA] AS QualityInd,
	Porteous$Item.[LowProfilePalletPQty] AS LowProfilePalletQty,
	Porteous$Item.[DiameterDesc] AS DiameterDesc,
	Porteous$Item.[LengthDesc] AS LengthDesc,
	Porteous$Item.[Routing No_] AS BoxSize,
	left(Porteous$Item.[Cat_ No_ Description Alt_ 1],40) as CategoryDescAlt1,
	left(Porteous$Item.[Cat_ No_ Description Alt_ 2],40) as CategoryDescAlt2,
	left(Porteous$Item.[Cat_ No_ Description Alt_ 3],40) as CategoryDescAlt3,
	Porteous$Item.[Size No_ Description Alt_ 1] as SizeDescAlt1,
	Porteous$Item.[Customer No_] as CustNo
FROM	Porteous$Item
WHERE	Porteous$Item.No_ = '00019-2512-021'

-------------------------------------------------------------------------------------------------------------------------------
--LABELS

exec sp_columns tblinvitems


--168228
select count(*) from tblInvItems
--where PRODNO='000192408021'

--168184
select count(*) from tblInvItems_SQLP
--where PRODNO='000192408021'


--168184 total records
--983 differences
SELECT	New.PRODNO as ItemNo,
/**
	New.PRODNO as PRODNO_New, Old.PRODNO as PRODNO_Old,
	New.PLATEDIDG as PLATEDIDG_New, Old.PLATEDIDG as PLATEDIDG_Old,
	New.PRODDSH as PRODDSH_New, Old.PRODDSH as PRODDSH_Old,
	New.ITEMDESC as ITEMDESC_New, Old.ITEMDESC as ITEMDESC_Old,
	New.ITMDESC1 as ITMDESC1_New, Old.ITMDESC1 as ITMDESC1_Old,
	New.CATDESC as CATDESC_New, Old.CATDESC as CATDESC_Old,
	New.PLATEDESC as PLATEDESC_New, Old.PLATEDESC as PLATEDESC_Old,
	New.PLATDESC as PLATDESC_New, Old.PLATDESC as PLATDESC_Old,
	New.PLATE2 as PLATE2_New, Old.PLATE2 as PLATE2_Old,
	New.UOMSELL as UOMSELL_New, Old.UOMSELL as UOMSELL_Old,
	New.UPCCODE as UPCCODE_New, Old.UPCCODE as UPCCODE_Old,
	New.LOTUPC as LOTUPC_New, Old.LOTUPC as LOTUPC_Old,
	New.MIDUPC as MIDUPC_New, Old.MIDUPC as MIDUPC_Old,
	New.[CHECK] as CHECK_New, Old.[CHECK] as CHECK_Old,
	New.ITMDESC2 as ITMDESC2_New, Old.ITMDESC2 as ITMDESC2_Old,
	New.ITMDESC3 as ITMDESC3_New, Old.ITMDESC3 as ITMDESC3_Old,
	New.ITMDESC4 as ITMDESC4_New, Old.ITMDESC4 as ITMDESC4_Old,
	New.ITMDESC5 as ITMDESC5_New, Old.ITMDESC5 as ITMDESC5_Old,
	New.ITMDESC6 as ITMDESC6_New, Old.ITMDESC6 as ITMDESC6_Old,
	New.PCXNAME as PCXNAME_New, Old.PCXNAME as PCXNAME_Old,
	New.HEAD as HEAD_New, Old.HEAD as HEAD_Old,
	New.SPCXNAME as SPCXNAME_New, Old.SPCXNAME as SPCXNAME_Old,
	New.SHEAD as SHEAD_New, Old.SHEAD as SHEAD_Old,
	New.LCPGNAME as LCPGNAME_New, Old.LCPGNAME as LCPGNAME_Old,
	New.LCPGHEAD as LCPGHEAD_New, Old.LCPGHEAD as LCPGHEAD_Old,
	New.HEADSTYL as HEADSTYL_New, Old.HEADSTYL as HEADSTYL_Old,
	New.CODEDATE as CODEDATE_New, Old.CODEDATE as CODEDATE_Old,
	New.MASTERLOC as MASTERLOC_New, Old.MASTERLOC as MASTERLOC_Old,
	New.MASTLOC as MASTLOC_New, Old.MASTLOC as MASTLOC_Old,
	New.NEWCAT1 as NEWCAT1_New, Old.NEWCAT1 as NEWCAT1_Old,
	New.NEWCAT2 as NEWCAT2_New, Old.NEWCAT2 as NEWCAT2_Old,
	New.NEWCAT3 as NEWCAT3_New, Old.NEWCAT3 as NEWCAT3_Old,
	New.NEWSIZE as NEWSIZE_New, Old.NEWSIZE as NEWSIZE_Old,
	New.RODDISPLAY as RODDISPLAY_New, Old.RODDISPLAY as RODDISPLAY_Old,
	New.RODPCS as RODPCS_New, Old.RODPCS as RODPCS_Old
	New.CONTWGHT as CONTWGHT_New, Old.CONTWGHT as CONTWGHT_Old,
	New.SLVQTY as SLVQTY_New, Old.SLVQTY as SLVQTY_Old,
	New.ALPHCODE as ALPHCODE_New, Old.ALPHCODE as ALPHCODE_Old,
	New.PO as PO_New, Old.PO as PO_Old,
	New.COUNTRY as COUNTRY_New, Old.COUNTRY as COUNTRY_Old,
	New.HEADDESC as HEADDESC_New, Old.HEADDESC as HEADDESC_Old,
	New.QTRDESC as QTRDESC_New, Old.QTRDESC as QTRDESC_Old,
	New.COLOR as COLOR_New, Old.COLOR as COLOR_Old,
	New.LBLTYPE as LBLTYPE_New, Old.LBLTYPE as LBLTYPE_Old,
	New.WGT100 as WGT100_New, Old.WGT100 as WGT100_Old
**/
	New.SELLUNIT as SELLUNIT_New, Old.SELLUNIT as SELLUNIT_Old,
	New.CARRIED as CARRIED_New, Old.CARRIED as CARRIED_Old,
	New.QTYDESIG as QTYDESIG_New, Old.QTYDESIG as QTYDESIG_Old,
	New.SUPERMULT as SUPERMULT_New, Old.SUPERMULT as SUPERMULT_Old,
	New.CASEQTY as CASEQTY_New, Old.CASEQTY as CASEQTY_Old,
	New.UNITPRICE as UNITPRICE_New, 
	round(cast(New.UNITPRICE as decimal(18,6)),2) as NewUnitPriceRound,
	Old.UNITPRICE as UNITPRICE_Old,
	round(cast(Old.UNITPRICE as decimal(18,6)),2) as OldUnitPriceRound,
	round(cast(Old.UNITPRICE as decimal(18,6)) + 0.01,2) as OldPricePlus,
	round(cast(Old.UNITPRICE as decimal(18,6)) - 0.01,2) as OldPriceMinus
FROM	tblInvItems New (nolock) inner join
	tblInvItems_SQLP Old (nolock)
ON	New.ProdNo = Old.ProdNo
WHERE
/**
--Zero DIFFs on these fields
	New.PRODNO <> Old.PRODNO or 
	New.PLATEDIDG <> Old.PLATEDIDG or 
	New.PRODDSH <> Old.PRODDSH or 
	New.ITEMDESC <> Old.ITEMDESC or 
	New.ITMDESC1 <> Old.ITMDESC1 or 
	New.CATDESC <> Old.CATDESC or 
	New.PLATEDESC <> Old.PLATEDESC or 
	New.PLATDESC <> Old.PLATDESC or 
	New.PLATE2 <> Old.PLATE2 or 
	New.UOMSELL <> Old.UOMSELL or 
	New.UPCCODE <> Old.UPCCODE or 
	New.LOTUPC <> Old.LOTUPC or 
	New.MIDUPC <> Old.MIDUPC or 
	New.[CHECK] <> Old.[CHECK] or 
	New.ITMDESC2 <> Old.ITMDESC2 or 
	New.ITMDESC3 <> Old.ITMDESC3 or 
	New.ITMDESC4 <> Old.ITMDESC4 or 
	New.ITMDESC5 <> Old.ITMDESC5 or 
	New.ITMDESC6 <> Old.ITMDESC6 or 
	New.PCXNAME <> Old.PCXNAME or 
	New.HEAD <> Old.HEAD or 
	New.SPCXNAME <> Old.SPCXNAME or 
	New.SHEAD <> Old.SHEAD or 
	New.LCPGNAME <> Old.LCPGNAME or 
	New.LCPGHEAD <> Old.LCPGHEAD or 
	New.HEADSTYL <> Old.HEADSTYL or 
	New.CODEDATE <> Old.CODEDATE or 
	New.MASTERLOC <> Old.MASTERLOC or 
	New.MASTLOC <> Old.MASTLOC or 
	New.NEWCAT1 <> Old.NEWCAT1 or 
	New.NEWCAT2 <> Old.NEWCAT2 or 
	New.NEWCAT3 <> Old.NEWCAT3 or 
	New.NEWSIZE <> Old.NEWSIZE or 
	New.RODDISPLAY <> Old.RODDISPLAY or 
	New.RODPCS <> Old.RODPCS or
	New.CONTWGHT <> Old.CONTWGHT or		--0
	New.SLVQTY <> Old.SLVQTY or		--0
	New.ALPHCODE <> Old.ALPHCODE or		--0
	New.PO <> Old.PO or			--0
	New.COUNTRY <> Old.COUNTRY or		--0
	New.HEADDESC <> Old.HEADDESC or		--0
	New.QTRDESC <> Old.QTRDESC or		--0
	New.COLOR <> Old.COLOR or		--0
	New.LBLTYPE <> Old.LBLTYPE or		--0
	New.WGT100 <> Old.WGT100		--0
**/

--	New.SELLUNIT <> Old.SELLUNIT --or	--672	TMD: uses SellStkUMQty - do we need to synch this up with UM
--	New.CARRIED <> Old.CARRIED --or		--105	TMD: Carried & QtyDesig are based on PCLBFTInd - do we need to validate this
--	New.QTYDESIG <> Old.QTYDESIG --or	--101	TMD: Carried & QtyDesig are based on PCLBFTInd - do we need to validate this
--	New.SUPERMULT <> Old.SUPERMULT --or	--1	IGNORE
--	New.CASEQTY <> Old.CASEQTY --or		--672	TMD: this is calcualted from SellStkUMQty * SuperUMQty
--	New.UNITPRICE <> Old.UNITPRICE --or	--207

	--Round the prices and they are all within .01 of each other
--	(round(cast(New.UNITPRICE as decimal(18,6)),2) > round(cast(Old.UNITPRICE as decimal(18,6)) + 0.01,2) and
--	 round(cast(New.UNITPRICE as decimal(18,6)),2) < round(cast(Old.UNITPRICE as decimal(18,6)) - 0.01,2))



------------------------------------------------------------------------------------------------------------------------------------


--Check the xref data.

--1496 distinct
select distinct PRODNO from acs
select distinct PRODNO from acs_sqlp


--1632
select count(*) from acs
select count(*) from acs_sqlp

SELECT	isnull(Old.PRODNO,'') + ' - ' + isnull(Old.CUSTPROD,'') as OldKey, Old.*
FROM	ACS_SQLP Old
WHERE	isnull(Old.PRODNO,'') + ' - ' + isnull(Old.CUSTPROD,'') not in
	(SELECT	DISTINCT isnull(New.PRODNO,'') + ' - ' + isnull(New.CUSTPROD,'') as NewKey FROM ACS New)

--2732
select * from amikay
select count(*) from amikay
select count(*) from amikay_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	amikay_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM amikay New)

--487
select * from avnet
select count(*) from avnet
select count(*) from avnet_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	avnet_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM avnet New)



--250
select * from buildex
select count(*) from buildex
select count(*) from buildex_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	buildex_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM buildex New)





--1444
select * from [cross]
select count(*) from [cross]
select count(*) from [cross_sqlp]

SELECT	isnull(Old.PRODNO,'') + ' - ' + isnull(Old.UPC,'') + ' - ' + isnull(Old.UPCCODE,'') + ' - ' + isnull(Old.HEADMK,'') as OldKey, Old.*
FROM	[cross_sqlp] Old
WHERE	isnull(Old.PRODNO,'') + ' - ' + isnull(Old.UPC,'') + ' - ' + isnull(Old.UPCCODE,'') + ' - ' + isnull(Old.HEADMK,'') not in
	(SELECT	DISTINCT isnull(New.PRODNO,'') + ' - ' + isnull(New.UPC,'') + ' - ' + isnull(New.UPCCODE,'') + ' - ' + isnull(New.HEADMK,'') as NewKey FROM [cross] New)



--1444
select * from newell
select count(*) from newell
select count(*) from newell_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	newell_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM newell New)



--4209
select * from umbrako
select count(*) from umbrako
select count(*) from umbrako_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	umbrako_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM umbrako New)



--583
select * from vsi
select count(*) from vsi
select count(*) from vsi_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	vsi_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM vsi New)


----------------------------------------

--755 vs 754
select * from usanchor
select count(*) from usanchor
select count(*) from usanchor_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	usanchor_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM usanchor New)

--6545 vs 6538
select * from f10600
select count(*) from f10600
select count(*) from f10600_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	f10600_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM f10600 New)

--145 vs 437   ???
select * from Curtis
select count(*) from Curtis
select count(*) from Curtis_sqlp

SELECT	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') as OldKey, Old.*
FROM	Curtis_SQLP Old
WHERE	isnull(Old.PFCPRODNO,'') + ' - ' + isnull(Old.PRODNO,'') + ' - ' + isnull(Old.W_Location,'') + ' - ' + isnull(Old.CUSPRDCLAS,'') + ' - ' + isnull(Old.CUSUPC,'') not in
	(SELECT	DISTINCT isnull(New.PFCPRODNO,'') + ' - ' + isnull(New.PRODNO,'') + ' - ' + isnull(New.W_Location,'') + ' - ' + isnull(New.CUSPRDCLAS,'') + ' - ' + isnull(New.CUSUPC,'') as NewKey FROM Curtis New)



-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

--168162 records
--17829 diffs
select	New.ProdNo, 
New.SELLUNIT, Old.SELLUNIT, 	--671
New.CARRIED, Old.CARRIED, 	--107
New.QTYDESIG, Old.QTYDESIG, 	--102
New.CONTWGHT, Old.CONTWGHT, 	--16869
New.SUPERMULT, Old.SUPERMULT, 	--1
New.CASEQTY, Old.CASEQTY, 	--671
New.UNITPRICE, Old.UNITPRICE,  	--207
round(cast(New.UNITPRICE as decimal(18,6)),2) as NewUnitPriceRound,
round(cast(Old.UNITPRICE as decimal(18,6)),2) as OldUnitPriceRound,
round(cast(Old.UNITPRICE as decimal(18,6)) + 0.01,2) as OldPricePlus,
round(cast(Old.UNITPRICE as decimal(18,6)) - 0.01,2) as OldPriceMinus

from	tblInvItems New (nolock) inner join
	tblInvItems_SQLP Old (nolock)
On	New.ProdNo = Old.ProdNo
where
--New.SELLUNIT <> Old.SELLUNIT		--671	IGNORE: uses SellStkUMQty - TMD: do we need to synch this up with UM
--(New.CARRIED <> Old.CARRIED or	--107	IGNORE: Carried & QtyDesig are based on PCLBFTInd - TMD: do we need to validate this
--New.QTYDESIG <> Old.QTYDESIG)		--102	IGNORE: ^see above^
--New.CONTWGHT <> Old.CONTWGHT		--16869 IGNORE these weight discrepancies
--New.SUPERMULT <> Old.SUPERMULT	--1	IGNORE
--New.CASEQTY <> Old.CASEQTY		--671	IGNORE: this is calcualted from SellStkQty * SuperUMQty
--New.UNITPRICE <> Old.UNITPRICE	--207

--Round the prices and they are all within .01 of each other
(round(cast(New.UNITPRICE as decimal(18,6)),2) > round(cast(Old.UNITPRICE as decimal(18,6)) + 0.01,2) and
 round(cast(New.UNITPRICE as decimal(18,6)),2) < round(cast(Old.UNITPRICE as decimal(18,6)) - 0.01,2))




select * from tIMLabelCNV
where ItemNo='005000722021'

select * from TempLabelData
where ItemNo='005000722021'




select * from AMIKAY
order by PFCPRODNO

select * from AMIKAY_SQLP
order by PFCPRODNO


select * from ItemMaster where SizeDescAlt1 = null

exec pimlabelcnv