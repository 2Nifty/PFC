declare
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


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  Test Params  --
-------------------

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
	SET @StrCat = '00200'
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
	SET @StrVar = '02?'
	SET @EndVar = '02?'
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
	SET @StrSVC = '~'
	SET @EndSVC = 'z'
	SET @SVCList = '~'

--	SET @StrSVC = '~'
--	SET @EndSVC = '~'
--	SET @SVCList = 'B,J,N'
--	SET @SVCList = REPLACE(@SVCList,'''','')
----	select @SVCList as SVCList


--Date
	SET @StrDt = '01/01/1970'
	SET @EndDt = '12/31/2120'
	SET @DateCtl = 'AFTER'

-----------------------
--  End Test Params  --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




	SELECT	DISTINCT
			'CORP' as Location,
			IM.ItemNo,
			IM.ItemDesc,					--Full Description (???)
			cast(cast(isnull(UM.AltSellUMQty,0) as DECIMAL(12,2)) as VARCHAR(20)) + '/' + UM.AltSellUM as AltSell,
			cast(cast(isnull(UM.SuperUMQty,0) as DECIMAL(12,2)) as VARCHAR(20)) + '/' + UM.SuperUM as SuperEqv,
			IB.StockInd,
			isnull(IBQty.QtyOH,0) as QtyOH,
			isnull(IBQty.QtyAvail,0) as QtyAvail,
			isnull(IBSum.Capacity,0) as Capacity,
			--Avg Cost per Alt UOM - which field for AvgCost - how to calc???  --  UnitCost
			isnull(IM.HundredWght,0) as HundredWght,
			isnull(IM.Wght,0) as NetWght,
			isnull(IM.GrossWght,0) as GrossWght,
			isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0) as ExtNetWghtOH,
			isnull(IBQty.QtyOH,0) * isnull(IB.UnitCost,0) as ExtCostOH,
			CASE (isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0))
				WHEN 0	THEN 0
						ELSE (isnull(IBQty.QtyOH,0) * isnull(IB.UnitCost,0)) / (isnull(IBQty.QtyOH,0) * isnull(IM.Wght,0))
			END as NetAvgLBVal,
			isnull(IBSum.ReOrderPoint,0) as ReOrderPoint,
			isnull(IBQty.QtyOW,0) + isnull(IBQty.QtyOO,0) as UnRcvdPOQty,	--OW + OO???
			isnull(IBQty.QtyTrf,0) as TrfQty,
			isnull(IBQty.QtyRelProd,0) as ProdOrdQty,
			isnull(IBQty.QtyOW,0) as OWQty,
			IM.BoxSize as RoutingNo,		--Routing Number
			IM.CorpFixedVelocity,
			IB.SalesVelocityCd,
			--Stock keeping unit exists for at least one location with SVC A..K
			CASE WHEN (IBSVC.SVCInd > 0) THEN 'Yes' ELSE 'No' END as SVCInd,
			IM.TariffCd,					--Harmonizing tax code
			CASE WHEN (IM.WebEnabledInd > 0) THEN 'Yes' ELSE 'No' END as WebEnabledInd,
			IM.PPICode,
			IM.UPCCd,
			IM.ParentProdNo,
			--Customer Number associated with item - Where does it live in NV???
			IM.EntryDt,						--Date Item Created - setup date???
			CASE WHEN (IM.QualityInd > 0) THEN 'Yes' ELSE 'No' END as FQAInd,	--FQA Item
			CASE WHEN (IM.CertRequiredInd > 0) THEN 'Yes' ELSE 'No' END as CertRequiredInd,
			--Prop 65 item - Where does it live in NV???
			isnull(BuyGrp.GroupNo,'') as BuyGroupNo,
			isnull(BuyGrp.ReportSort,'') as ReportSort,
			isnull(BuyGrp.ReportGroup,'') as ReportGroup,
			isnull(BuyGrp.ReportGroupNo,'') as ReportGroupNo,
			IM.ListPrice,
			IB.SmoothAvg,
			IB.PriceCost,
			IB.ReplacementCost
	FROM	ItemMaster IM (NoLock) INNER JOIN
			#tItemUM UM (NoLock)
	ON		IM.ItemNo = UM.ItemNo INNER JOIN
			#tItemBranch IB (NoLock)
	ON		IM.ItemNo = IB.ItemNo LEFT OUTER JOIN
			CategoryBuyGroups BuyGrp (NoLock)
	ON		LEFT(IM.ItemNo,5) = BuyGrp.Category LEFT OUTER JOIN
			#tItemBranchSum IBSum (NoLock)
	ON		IM.ItemNo = IBSum.ItemNo LEFT OUTER JOIN
			#tIBSVC IBSVC (NoLock)
	ON		IM.ItemNo = IBSVC.ItemNo LEFT OUTER JOIN
			#tIBQty IBQty (NoLock)
	ON		IM.ItemNo = IBQty.ItemNo LEFT OUTER JOIN
			#tPrimeVend PrimeVend (NoLock)
	ON		IM.ItemNo = PrimeVend.ItemNo
	WHERE	----Location
			--((isnull(IB.Location,'') BETWEEN @StrLoc AND @EndLoc) or
			--CHARINDEX(isnull(IB.Location,''), @LocList) > 0) and

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



--
--select * from #tPrimeVend
--select * from #tItemUM
--select * from #tIBQty
--select * from #tIBSVC
--select * from #tItemBranch
--select * from #tItemBranchSum 



--drop table #tPrimeVend
--drop table #tItemUM
--drop table #tIBQty
--drop table #tIBSVC
--drop table #tItemBranch
--drop table #tItemBranchSum 




select Itemno, unitcost from itemmaster inner join Itembranch on pitemmasterid=fitemmasterid where Location ='01' and ItemNo in ('00200-2400-020','00200-2400-021','00200-2400-022','00200-2400-024')

