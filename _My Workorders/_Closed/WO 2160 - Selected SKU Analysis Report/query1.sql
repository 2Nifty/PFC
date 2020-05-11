


declare @StrLoc varchar(4),
		@EndLoc varchar(4),
		@LocList nvarchar(4000),
		@StrCat varchar(5),
		@EndCat varchar(5),
		@CatList nvarchar(4000),
		@StrSize varchar(4),
		@EndSize varchar(4),
		@SizeList nvarchar(4000),
		@StrVar varchar(4),
		@EndVar varchar(4),
		@VarList nvarchar(4000),
		@StrCFV varchar(4),
		@EndCFV varchar(4),
		@CFVList nvarchar(4000),
		@StrSVC varchar(4),
		@EndSVC varchar(4),
		@SVCList nvarchar(4000)



--------------------------------------------------------------------------------
-- Load #tItemUM --
-------------------

drop table #tItemUM

--Less than 10 seconds in PFCDEVDB.PERP
SELECT	Base.ItemNo,
		isnull(Base.BaseStkUM,'') as BaseStkUM,
		isnull(Base.BaseStkUMQty,0) as BaseStkUMQty,
		--PurchPriceAlt
		isnull(Base.PurchPriceAltUM,'') as PurchPriceAltUM,
		isnull(Base.PurchPriceAltUMQty,0) as PurchPriceAltUMQty,
		isnull(Base.PurchPriceAltBaseUMQty,0) as PurchPriceAltBaseUMQty,
		isnull(Base.PurchPriceAltUMWght,0) as PurchPriceAltUMWght,
		--PurchCostAlt
		isnull(AltPurch.PurchCostAltUM,'') as PurchCostAltUM,
		isnull(AltPurch.PurchCostAltUMQty,0) as PurchCostAltUMQty,
		isnull(AltPurch.PurchCostAltBaseUMQty,0) as PurchCostAltBaseUMQty,
		isnull(AltPurch.PurchCostAltUMWght,0) as PurchCostAltUMWght,
		--AltSell
		isnull(AltSell.AltSellUM,'') as AltSellUM,
		isnull(AltSell.AltSellUMQty,0) as AltSellUMQty,
		isnull(AltSell.AltSellBaseUMQty,0) as AltSellBaseUMQty,
		isnull(AltSell.AltSellUMWght,0) as AltSellUMWght,
		--SuperEqv
		isnull(SuperEqv.SuperUM,'') as SuperUM,
		isnull(SuperEqv.SuperUMQty,0) as SuperUMQty,
		isnull(SuperEqv.SuperBaseUMQty,0) as SuperBaseUMQty,
		isnull(SuperEqv.SuperUMWght,0) as SuperUMWght
INTO	#tItemUM
FROM	(SELECT	IM.ItemNo,
				IM.SellStkUM as BaseStkUM,			--base stk uom
				IM.SellStkUMQty as BaseStkUMQty,	--base stk qty
				IM.PriceUM as PurchPriceAltUM,		--purch alt UM
				IUM.QtyPerUM as PurchPriceAltUMQty,
				IUM.AltSellStkUMQty as PurchPriceAltBaseUMQty,
				IUM.Weight as PurchPriceAltUMWght
		FROM	ItemMaster IM inner join
				ItemUM IUM
		ON		pItemMasterID = fItemMasterID
		WHERE	IM.PriceUM = IUM.UM) Base

		INNER JOIN

		(SELECT	IM.ItemNo,
				IM.CostPurUM as PurchCostAltUM,		--purch alt
				IUM.QtyPerUM as PurchCostAltUMQty,
				IUM.AltSellStkUMQty as PurchCostAltBaseUMQty,
				IUM.Weight as PurchCostAltUMWght
		FROM	ItemMaster IM inner join
				ItemUM IUM
		ON		pItemMasterID = fItemMasterID
		WHERE	IM.CostPurUM = IUM.UM) AltPurch

		ON		Base.ItemNo = AltPurch.ItemNo INNER JOIN

		(SELECT	IM.ItemNo,
				IM.SellUM as AltSellUM,			--alt sell
				IUM.QtyPerUM as AltSellUMQty,
				IUM.AltSellStkUMQty as AltSellBaseUMQty,
				IUM.Weight as AltSellUMWght
		FROM	ItemMaster IM inner join
				ItemUM IUM
		ON		pItemMasterID = fItemMasterID
		WHERE	IM.SellUM = IUM.UM) AltSell

		ON		Base.ItemNo = AltSell.ItemNo INNER JOIN

		(SELECT	IM.ItemNo,
				IM.SuperUM as SuperUM,		--super eqv
				IUM.QtyPerUM as SuperUMQty,
				IUM.AltSellStkUMQty as SuperBaseUMQty,
				IUM.Weight as SuperUMWght
		FROM	ItemMaster IM inner join
				ItemUM IUM
		ON		pItemMasterID = fItemMasterID
		WHERE	IM.SuperUM = IUM.UM) SuperEqv

		ON		Base.ItemNo = SuperEqv.ItemNo

--select * from #tItemUM

--------------------------------------------------------------------------------
-- Load #tIBQty --
------------------

drop table #tIBQty

--Less than 5 seconds in PFCDEVDB.PERP
SELECT	ItemNo
		,Location
		-- these do not match SOE, these are CPR specific
		-- 	(QOH - AllocTransfer - ReleaseProd - SOQty) + (OnOrder + ReleaseProd) + OTW + (TRF + AllocTransfer) AS TotalStockOrders, 
		,QtyAvail	= sum(case	rtrim(SourceCd)
								when 'SO' then Qty
								when 'OH' then Qty
								when 'RE' then Qty
								when 'NA' then Qty
								when 'TO' then Qty
								else 0 end)
		,QtyOH		= sum(case	rtrim(SourceCd)
								when 'OH' then Qty
								else 0 end)
		,QtySO		= sum(case	when rtrim(SourceCd)='SO' and isnull(SumItem.StatusCd,'')<>'BO'
								then abs(Qty)
								else 0 end)
		,QtyTrfAlloc= sum(case	rtrim(SourceCd)
								when 'TO' then abs(Qty)
								else 0 end)
		,QtyTrf		= sum(case	rtrim(SourceCd)
								when 'TI' then Qty
								else 0 end)
		,QtyOW		= sum(case	rtrim(SourceCd)
								when 'OW' then Qty
								else 0 end)
		,QtyOO		= sum(case	rtrim(SourceCd)
								when 'PO' then Qty
								when 'WO' then Qty
								else 0 end)
		,QtyRelProd	= sum(case	rtrim(SourceCd)
								when 'WO' then Qty
								else 0 end)
INTO	#tIBQty
FROM	SumItem (NOLOCK) INNER JOIN
		LocMaster Branch (NOLOCK)
ON		SumItem.Location = Branch.LocID
GROUP BY ItemNo, Location

--select * from #tIBQty

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--Location
	SET @StrLoc = '0'
	SET @EndLoc = '999999999'
	SET @LocList = '~'

--	SET @StrLoc = '~'
--	SET @EndLoc = '~'
--	SET @LocList = '05,06,10'
--	SET @LocList = REPLACE(@LocList,'''','')
--	select @LocList as LocList


--Category
	SET @StrCat = '00020'
	SET @EndCat = '00299'
	SET @CatList = '~'

--	SET @StrCat = '~'
--	SET @EndCat = '~'
--	SET @CatList = '00024,00501,04175'
--	SET @CatList = REPLACE(@CatList,'''','')
----	select @CatList as CatList


--Size
	SET @StrSize = '0000'
	SET @EndSize = '9999'
	SET @SizeList = '~'

--	SET @StrSize = '~'
--	SET @EndSize = '~'
--	SET @SizeList = '2412,2418'
--	SET @SizeList = REPLACE(@SizeList,'''','')
--	select @SizeList as SizeList


--Variance
	SET @StrVar = '020'
	SET @EndVar = '029'
	SET @VarList = '~'

--	SET @StrVar = '~'
--	SET @EndVar = '~'
--	SET @VarList = '021,101,450'
--	SET @VarList = REPLACE(@VarList,'''','')
--	select @VarList as VarList


--CFV
	SET @StrCFV = '~'
	SET @EndCFV = 'z'
	SET @CFVList = '~'

--	SET @StrCFV = '~'
--	SET @EndCFV = '~'
--	SET @CFVList = 'D,E,I,P'
--	SET @CFVList = REPLACE(@CFVList,'''','')
--	select @CFVList as CFVList


--SVC
--	SET @StrSVC = 'F'
--	SET @EndSVC = 'K'
--	SET @SVCList = '~'

	SET @StrSVC = '~'
	SET @EndSVC = '~'
	SET @SVCList = 'B,J,N'
	SET @SVCList = REPLACE(@SVCList,'''','')
----	select @SVCList as SVCList

--------------------------------------------------------------------

--select * from ItemMaster


SELECT
--		IB.Location,
--		IM.ItemNo,
--		LEFT(IM.ItemNo,5) as Cat,
--		substring(IM.ItemNo,7,4) as Size,
--		substring(IM.ItemNo,12,3) as [Var],
--
--		IM.CorpFixedVelocity as CFV,
--		IB.SalesVelocityCd as SVC,

		IM.ItemNo,
		isnull(BuyGrp.Category,LEFT(IM.ItemNo,5)) as CatNo,
		IB.Location,
		IM.ItemSize,
		IM.CatDesc,
		IM.Finish,
		IM.ItemDesc,		--???

		UM.BaseStkUMQty,
		UM.BaseStkUM,

		UM.PurchPriceAltUM,
		UM.PurchPriceAltUMQty,
		UM.PurchPriceAltBaseUMQty,
		UM.PurchPriceAltUMWght,

--		UM.PurchCostAltUM,
--		UM.PurchCostAltUMQty,
--		UM.PurchCostAltBaseUMQty,
--		UM.PurchCostAltUMWght,

		UM.AltSellUMQty,
		UM.AltSellUM,
		UM.AltSellBaseUMQty,
		UM.AltSellUMWght,

		UM.SuperUMQty,
		UM.SuperUM,
		UM.SuperBaseUMQty,
		UM.SuperUMWght,

		IB.StockInd,

		IBQty.QtyOH,
		IBQty.QtyAvail,
		IB.Capacity,
		IB.ROPDays,
		IB.ReOrderPoint,

		isnull(IM.HundredWght,0) as HundredWght,
		isnull(IM.Wght,0) as NetWght,
		isnull(IM.GrossWght,0) as GrossWght,
--		IM.CUMGrossWght,	--Cost UM
--		IM.CUMNetWght,		--Cost UM
--		IM.PUMGrossWght,	--Purch UM
--		IM.PUMNetWght,		--Purch UM
		isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0) as NetWghtOH,
		isnull(IBQty.QtyOH,0) * isnull(IM.GrossWght,0) as GrossWghtOH,

		isnull(IB.AvgCost,0) as AvgCost,	--Avg Cost???
		--Avg Cost per Alt UM ???
		isnull(IBQty.QtyOH,0) * isnull(Ib.AvgCost,0) as ExtCostOH,

		CASE (isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0))
			WHEN 0	THEN 0
			ELSE	(isnull(IBQty.QtyOH,0) * isnull(Ib.AvgCost,0)) / (isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0))
		END as NetAvgLBVal,

		CASE (isnull(IBQty.QtyOH,0) * isnull(IM.GrossWght,0))
			WHEN 0	THEN 0
					ELSE (isnull(IBQty.QtyOH,0) * isnull(Ib.AvgCost,0)) / (isnull(IBQty.QtyOH,0) * isnull(IM.GrossWght,0))
		END as GrossAvgLBVal,

		isnull(IBQty.QtyOW,0) + isnull(IBQty.QtyOO,0) as UnRcvdPOQty,	--Unreceived PO?
		isnull(IBQty.QtyTrf,0) as TrfQty,
		isnull(QtyRelProd,0) as ProdOrdQty,
		isnull(IBQty.QtyOW,0) as OWQty,

		--Routing Number for item???
		--Harmonizing tax code???
		--Customer # associated with item
		--FQA Item
		--Prop 65 item
		--Production BOM #
		--Stock keeping unit exists for at least one location with SCV A..K


		isnull(BuyGrp.GroupNo,'') as BuyGroupNo,	--Category group No
		isnull(BuyGrp.ReportSort,'') as ReportSort,
		isnull(BuyGrp.ReportGroup,'') as ReportGroup,
		isnull(BuyGrp.ReportGroupNo,'') as ReportGroupNo,


		IB.SalesVelocityCd,
--		IB.FixedVelocityCd,
		IM.CorpFixedVelocity,
		IM.WebEnabledInd,
		IM.PPICode,
		IM.UPCCd,
		IM.EntryDt,			--Item Setup Date???
		IM.EntryID,
		IM.CertRequiredInd

---- Nick's fields
--List Price
--Smoothed Average Cost
--Price Cost
--Replacement Cost
--Prime Vendor




FROM	ItemMaster IM (NoLock) INNER JOIN
		#tItemUM UM (NoLock)
ON		IM.ItemNo = UM.ItemNo INNER JOIN
		ItemBranch IB (NoLock)
ON		IM.pItemMasterID = IB.fItemMasterID LEFT OUTER JOIN
		CategoryBuyGroups BuyGrp (NoLock)
ON		LEFT(IM.ItemNo,5) = BuyGrp.Category LEFT OUTER JOIN
		#tIBQty IBQty (NoLock)
ON		IM.ItemNo = IBQty.ItemNo and IB.Location = IBQty.Location
WHERE	--Location
		((isnull(IB.Location,'') BETWEEN @StrLoc AND @EndLoc) or
--		(isnull(Location,'') in (SELECT Value FROM fListToTablevarchar(@LocList,',')))) and
		CHARINDEX(isnull(IB.Location,''), @LocList) > 0) and
		--Category
		((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
--		(isnull(LEFT(IM.ItemNo,5),'') in (SELECT Value FROM fListToTablevarchar(@CatList,',')))) and
		CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
		--Size
		((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
--		(isnull(substring(ItemNo,7,4),'') in (SELECT Value FROM fListToTablevarchar(@SizeList,',')))) and
		CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
		--Variance
		((isnull(substring(IM.ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
--		(isnull(substring(ItemNo,12,3),'') in (SELECT Value FROM fListToTablevarchar(@VarList,',')))) and
		CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0) and
		--Corp Fixed Velocity Code
		((isnull(IM.CorpFixedVelocity,'') BETWEEN @StrCFV AND @EndCFV) or
--		(isnull(IM.CorpFixedVelocity,'') in (SELECT Value FROM fListToTablevarchar(@CFVList,',')))) and
		CHARINDEX(isnull(IM.CorpFixedVelocity,''), @CFVList) > 0) and
		--Sales velocity Code
		((isnull(IB.SalesVelocityCd,'') BETWEEN @StrSVC AND @EndSVC) or
--		(isnull(IB.SalesVelocityCd,'') in (SELECT Value FROM fListToTablevarchar(@SVCList,','))))
		CHARINDEX(isnull(IB.SalesVelocityCd,''), @SVCList) > 0)

order by ItemNo, Location
--order by SVC


---------------------------------------------------------------------------------------------------------------------------

--select itemno, substring(ItemNo,7,4) as size, substring(ItemNo,12,3) as [var] from ItemMaster


--select CorpFixedVelocity, * from itemmaster
--select SalesVelocityCd, * from itembranch


--select * from ItemMaster
--exec sp_columns ItemBranch


--select itemmaster.itemno, itemum.* from 
--itemmaster inner join itemum on pitemmasterid=fitemmasterid
--where itemmaster.itemno in
--('00019-2412-021','00019-2412-101','00019-2418-021','00019-2418-101','00020-2412-021','00020-2412-101','00020-2412-450','00020-2418-450','00023-2418-021','00024-2412-101','00024-2418-101')

--order by ItemNo
 