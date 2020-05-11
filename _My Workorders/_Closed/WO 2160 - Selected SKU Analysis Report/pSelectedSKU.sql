--exec pSelectedSKU '10','15','~','00000','99999','~','0000','9999','~','021','021','~','~','z','~','~','z','~','01/01/1998','12/31/1998','BETWEEN'

--exec pSelectedSKU '0','999999999','~','00200','00299','~','0000','9999','~','02?','02?','~','~','z','~','~','z','~','01/01/1970','12/31/2120','AFTER'


drop proc pSelectedSKU
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================
-- Author:	Tod Dixon
-- Created:	2011-Dec-12
-- Desc:	Return GridView data for Selected SKU
-- ==============================================

CREATE PROCEDURE pSelectedSKU
	@StrLoc varchar(4),
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
	@SVCList nvarchar(4000),
	@StrDt datetime,
	@EndDt datetime,
	@DateCtl varchar(10)
AS
BEGIN

/**
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  Test Params  --
-------------------

--Location
--	SET @StrLoc = '0'
--	SET @EndLoc = '999999999'
--	SET @LocList = '~'

	SET @StrLoc = '~'
	SET @EndLoc = '~'
	SET @LocList = '05,06,10'
	SET @LocList = REPLACE(@LocList,'''','')
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

-----------------------
--  End Test Params  --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
**/


---+++++++++++++++++++++++++++++++++++++++++++++++++++++---
---              Start: Build Work Tables               ---
---+++++++++++++++++++++++++++++++++++++++++++++++++++++---

-----------------------
-- Build #tPrimeVend --
-----------------------
--Less than 10 seconds in PFCDEVDB.PERP
	SELECT	DISTINCT
			ItemNo, VendorNo, VendorName
	INTO	#tPrimeVend
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CPR_VendorDetail
	WHERE	VendorRank = 1 AND
			--Category
			((isnull(LEFT(ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
			  CHARINDEX(isnull(LEFT(ItemNo,5),''), @CatList) > 0) and
			--Size
			((isnull(substring(ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
			  CHARINDEX(isnull(substring(ItemNo,7,4),''), @SizeList) > 0) and
			--Variance
			((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
			 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
																	 ELSE isnull(substring(@StrVar,1,1),'')
													END and
			  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
																	 ELSE isnull(substring(@StrVar,2,1),'')
													END and
			  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
																	 ELSE isnull(substring(@StrVar,3,1),'')
													END) or
			  CHARINDEX(isnull(substring(ItemNo,12,3),''), @VarList) > 0)

--select * from #tPrimeVend


--------------------
-- Build #tItemUM --
--------------------
--Less than 10 seconds in PFCDEVDB.PERP
	SELECT	DISTINCT
			--Base
			Base.ItemNo,
			isnull(Base.BaseStkUM,'') as BaseStkUM,
			isnull(Base.BaseStkQty,0) as BaseStkQty,
			isnull(Base.AltUM,'') as AltUM,
			--AltPurch
			isnull(AltPurch.AltPurchUM,'') as AltPurchUM,
			isnull(AltPurch.AltPurchQty,0) as AltPurchQty,
			--AltSell
			isnull(AltSell.AltSellUM,'') as AltSellUM,
			isnull(AltSell.AltSellQty,0) as AltSellQty,
			--SuperUM
			isnull(SuperEqv.SuperUM,'') as SuperUM,
			isnull(SuperEqv.SuperQty,0) as SuperQty
	INTO	#tItemUM
	FROM	(--Base
			 SELECT	IM.ItemNo,
					IM.SellStkUM as BaseStkUM,
					IM.SellStkUMQty as BaseStkQty,
					IM.PriceUM as AltUM
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.PriceUM = IUM.UM AND
					--Category
					((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
					  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
					--Size
					((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
					  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
					--Variance
					((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
					 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
																			 ELSE isnull(substring(@StrVar,1,1),'')
															END and
					  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
																			 ELSE isnull(substring(@StrVar,2,1),'')
															END and
					  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
																			 ELSE isnull(substring(@StrVar,3,1),'')
															END) or
					  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)) Base INNER JOIN
			(--AltPurch
			 SELECT	IM.ItemNo,
					IM.CostPurUM as AltPurchUM,
					IUM.AltSellStkUMQty as AltPurchQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.CostPurUM = IUM.UM AND
					--Category
					((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
					  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
					--Size
					((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
					  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
					--Variance
					((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
					 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
																			 ELSE isnull(substring(@StrVar,1,1),'')
															END and
					  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
																			 ELSE isnull(substring(@StrVar,2,1),'')
															END and
					  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
																			 ELSE isnull(substring(@StrVar,3,1),'')
															END) or
					  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)) AltPurch
			ON		Base.ItemNo = AltPurch.ItemNo INNER JOIN
			(--AltSell
			 SELECT	IM.ItemNo,
					IM.SellUM as AltSellUM,
					IUM.AltSellStkUMQty as AltSellQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.SellUM = IUM.UM AND
					--Category
					((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
					  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
					--Size
					((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
					  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
					--Variance
					((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
					 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
																			 ELSE isnull(substring(@StrVar,1,1),'')
															END and
					  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
																			 ELSE isnull(substring(@StrVar,2,1),'')
															END and
					  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
																			 ELSE isnull(substring(@StrVar,3,1),'')
															END) or
					  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)) AltSell
			ON		Base.ItemNo = AltSell.ItemNo INNER JOIN
			(--SuperUM
			 SELECT	IM.ItemNo,
					IM.SuperUM as SuperUM,
					IUM.QtyPerUM as SuperQty
			 FROM	ItemMaster IM inner join
					ItemUM IUM
			 ON		pItemMasterID = fItemMasterID
			 WHERE	IM.SuperUM = IUM.UM AND
					--Category
					((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
					  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and
					--Size
					((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
					  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and
					--Variance
					((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
					 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
																			 ELSE isnull(substring(@StrVar,1,1),'')
															END and
					  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
																			 ELSE isnull(substring(@StrVar,2,1),'')
															END and
					  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
																	WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
																			 ELSE isnull(substring(@StrVar,3,1),'')
															END) or
					  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)) SuperEqv
			ON		Base.ItemNo = SuperEqv.ItemNo

--select * from #tItemUM


-------------------
-- Build #tIBQty --
-------------------
--Less than 5 seconds in PFCDEVDB.PERP
	SELECT	DISTINCT
			ItemNo
			,Location
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
	WHERE	--Location
			((isnull(Location,'') BETWEEN @StrLoc AND @EndLoc) or
			CHARINDEX(isnull(Location,''), @LocList) > 0) and
			--Category
			((isnull(LEFT(ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
			  CHARINDEX(isnull(LEFT(ItemNo,5),''), @CatList) > 0) and
			--Size
			((isnull(substring(ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
			  CHARINDEX(isnull(substring(ItemNo,7,4),''), @SizeList) > 0) and
			--Variance
			((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
			 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
																	 ELSE isnull(substring(@StrVar,1,1),'')
													END and
			  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
																	 ELSE isnull(substring(@StrVar,2,1),'')
													END and
			  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
																	 ELSE isnull(substring(@StrVar,3,1),'')
													END) or
			  CHARINDEX(isnull(substring(ItemNo,12,3),''), @VarList) > 0)
	GROUP BY ItemNo, Location

--select * from #tIBQty


---------------------
-- Build #tIBPOQty --
---------------------
--Less than 5 seconds in PFCDEVDB.PERP ???
	SELECT	POD.ItemNo,
			POD.ReceivingLocation as Location,
			sum(POD.QtyOrdered - POD.QtyReceived) as TotPOQtyDue
	INTO	#tIBPOQty
	FROM	POHeader POH (NoLock) INNER JOIN
			PODetail POD (NoLock)
	ON		POH.pPOHeaderID = POD.fPOHeaderID
	WHERE	(POH.POSubType between '1' and '20') AND (POD.QtyOrdered - POD.QtyReceived > 0)
	GROUP BY POD.ItemNo, POD.ReceivingLocation

--select * from #tIBPOQty


-------------------
-- Build #tIBSVC --
-------------------
--Less than 5 seconds in PFCDEVDB.PERP  ?????
	SELECT	DISTINCT
			IM.ItemNo,
			sum(CASE WHEN IB.SalesVelocityCd in ('A','B','C','D','E','F','G','H','I','K') THEN 1 ELSE 0 END) as SVCInd
	INTO	#tIBSVC
	FROM	ItemMaster IM (NoLock) INNER JOIN
			ItemBranch IB (NoLock)
	ON		pItemMasterID = fItemMasterID
	WHERE	--Category
			((isnull(LEFT(ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
			  CHARINDEX(isnull(LEFT(ItemNo,5),''), @CatList) > 0) and
			--Size
			((isnull(substring(ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
			  CHARINDEX(isnull(substring(ItemNo,7,4),''), @SizeList) > 0) and
			--Variance
			((isnull(substring(ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
			 (isnull(substring(ItemNo,12,1),'') =	CASE isnull(substring(@StrVar,1,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,12,1),'')
																	 ELSE isnull(substring(@StrVar,1,1),'')
													END and
			  isnull(substring(ItemNo,13,1),'') =	CASE isnull(substring(@StrVar,2,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,13,1),'')
																	 ELSE isnull(substring(@StrVar,2,1),'')
													END and
			  isnull(substring(ItemNo,14,1),'') =	CASE isnull(substring(@StrVar,3,1),'')
															WHEN '?' THEN isnull(substring(ItemNo,14,1),'')
																	 ELSE isnull(substring(@StrVar,3,1),'')
													END) or
			  CHARINDEX(isnull(substring(ItemNo,12,3),''), @VarList) > 0)
	GROUP BY IM.ItemNo

--select * from #tIBSVC

---+++++++++++++++++++++++++++++++++++++++++++++++++++++---
---               End: Build Work Tables                ---
---+++++++++++++++++++++++++++++++++++++++++++++++++++++---

	SELECT	DISTINCT
			IB.Location,
			IM.ItemNo,
			IM.ItemDesc,														--Full Description
			cast(cast(isnull(UM.AltSellQty,0) as DECIMAL(12,2)) as VARCHAR(20)) + '/' + UM.AltSellUM as AltSell,
			cast(cast(isnull(UM.SuperQty,0) as DECIMAL(12,2)) as VARCHAR(20)) + '/' + UM.SuperUM as SuperQty,
			CASE WHEN (IB.StockInd > 0) THEN 'Yes' ELSE 'No' END as StockInd,
			isnull(IBQty.QtyOH,0) as QtyOH,
			isnull(IBQty.QtyAvail,0) as QtyAvail,
			isnull(IB.Capacity,0) as Capacity,
			CASE WHEN (isnull(UM.AltSellQty,0) = 0) THEN 0 ELSE isnull(IB.UnitCost,0) / isnull(UM.AltSellQty,0) END as AvgCostAltUM,
			isnull(IM.HundredWght,0) as HundredWght,
			isnull(IM.Wght,0) as NetWght,
			isnull(IM.GrossWght,0) as GrossWght,
			isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0) as ExtNetWghtOH,
			isnull(IBQty.QtyOH,0) * isnull(IB.UnitCost,0) as ExtCostOH,
			CASE (isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0))
				WHEN 0	THEN 0
						ELSE (isnull(IBQty.QtyOH,0) * isnull(IB.UnitCost,0)) / (isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0))
			END as NetAvgLBVal,
			isnull(IB.ReOrderPoint,0) as ReOrderPoint,
			isnull(POQty.TotPOQtyDue,0) + isnull(IBQty.QtyOW,0) as UnRcvdPOQty,
			isnull(IBQty.QtyTrf,0) as TrfQty,
			isnull(IBQty.QtyRelProd,0) as ProdOrdQty,
			isnull(IBQty.QtyOW,0) as OWQty,
			IM.BoxSize as RoutingNo,
			IM.CorpFixedVelocity,
			IB.SalesVelocityCd,
			CASE WHEN (IBSVC.SVCInd > 0) THEN 'Yes' ELSE 'No' END as SVCInd,	--SKU exists for at least one location with SVC A..K
			IM.TariffCd,														--Harmonizing tax code
			CASE WHEN (IM.WebEnabledInd > 0) THEN 'Yes' ELSE 'No' END as WebEnabledInd,
			IM.PPICode,
			IM.UPCCd,
			IM.ParentProdNo,
			isnull(IM.CustNo,'') as IMCustNo,									--Customer Number associated with item
			IM.EntryDt,															--Date Item Created (setup date)
			CASE WHEN (IM.QualityInd > 0) THEN 'Yes' ELSE 'No' END as FQAInd,
			CASE WHEN (IM.CertRequiredInd > 0) THEN 'Yes' ELSE 'No' END as CertRequiredInd,
			CASE WHEN (IM.HazMatInd > 0) THEN 'Yes' ELSE 'No' END as Prop65,
			isnull(BuyGrp.GroupNo,'') as BuyGroupNo,
			isnull(BuyGrp.ReportSort,'') as ReportSort,
			isnull(BuyGrp.ReportGroup,'') as ReportGroup,
			isnull(BuyGrp.ReportGroupNo,'') as ReportGroupNo,
			IM.ListPrice,
			IB.StdCost as SmoothAvg,
			IB.PriceCost,
			IB.ReplacementCost
	FROM	ItemMaster IM (NoLock) INNER JOIN
			#tItemUM UM (NoLock)
	ON		IM.ItemNo = UM.ItemNo INNER JOIN
			ItemBranch IB (NoLock)
	ON		IM.pItemMasterID = IB.fItemMasterID LEFT OUTER JOIN
			CategoryBuyGroups BuyGrp (NoLock)
	ON		LEFT(IM.ItemNo,5) = BuyGrp.Category LEFT OUTER JOIN
			#tIBSVC IBSVC (NoLock)
	ON		IM.ItemNo = IBSVC.ItemNo LEFT OUTER JOIN
			#tIBQty IBQty (NoLock)
	ON		IM.ItemNo = IBQty.ItemNo and IB.Location = IBQty.Location LEFT OUTER JOIN
			#tIBPOQty POQty (NoLock)
	ON		IM.ItemNo = POQty.ItemNo and IB.Location = POQty.Location LEFT OUTER JOIN
			#tPrimeVend PrimeVend (NoLock)
	ON		IM.ItemNo = PrimeVend.ItemNo
	WHERE	--Location
			((isnull(IB.Location,'') BETWEEN @StrLoc AND @EndLoc) or
			CHARINDEX(isnull(IB.Location,''), @LocList) > 0) and

			--Category
			((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
			  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and

			--Size
			((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
			  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and

			--Variance
			((isnull(substring(IM.ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
			 (isnull(substring(IM.ItemNo,12,1),'') = CASE isnull(substring(@StrVar,1,1),'')
															WHEN '?' THEN isnull(substring(IM.ItemNo,12,1),'')
																	 ELSE isnull(substring(@StrVar,1,1),'')
													 END and
			  isnull(substring(IM.ItemNo,13,1),'') = CASE isnull(substring(@StrVar,2,1),'')
															WHEN '?' THEN isnull(substring(IM.ItemNo,13,1),'')
																	 ELSE isnull(substring(@StrVar,2,1),'')
													 END and
			  isnull(substring(IM.ItemNo,14,1),'') = CASE isnull(substring(@StrVar,3,1),'')
															WHEN '?' THEN isnull(substring(IM.ItemNo,14,1),'')
																	 ELSE isnull(substring(@StrVar,3,1),'')
													 END) or
			  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0) and

			--Corp Fixed Velocity Code
			((isnull(IM.CorpFixedVelocity,'') BETWEEN @StrCFV AND @EndCFV) or
			  CHARINDEX(isnull(IM.CorpFixedVelocity,''), @CFVList) > 0) and

			--Sales Velocity Code
			((isnull(IB.SalesVelocityCd,'') BETWEEN @StrSVC AND @EndSVC) or
			  CHARINDEX(isnull(IB.SalesVelocityCd,''), @SVCList) > 0) and

			--Item Set-up date (EntryDt)
			(isnull(IM.EntryDt,0) BETWEEN @StrDt AND @EndDt)

	ORDER BY ItemNo, Location


drop table #tPrimeVend
drop table #tItemUM
drop table #tIBQty
drop table #tIBPOQty
drop table #tIBSVC

END
GO