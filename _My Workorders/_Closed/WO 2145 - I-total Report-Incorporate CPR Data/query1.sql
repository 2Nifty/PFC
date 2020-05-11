SELECT distinct Branch + Category as OldKey
into #OldList
FROM
	(SELECT	DR.EndDate as CurrentDt,
		CGD.GroupNo as BuyGroupNo,
		CGD.Description as BuyGroupDesc,
		CGD.DonGroup as DonGroupDesc, 
		CGD.DonGroupNo,
		CGD.DonSort,
		Case 	when AC.Branch = 'VENDTRANS' THEN '9995'
			when AC.Branch = 'INTRATRANS' THEN '9992'
			when AC.Branch = 'CARTRANS' THEN '9991'
			Else AC.Branch
		end as Branch,
		Left(AC.ItemNo,5) as Category,
		Case 	when AC.Branch between '00' and '98' then 'Branch'	
			when AC.Branch = 'VENDTRANS' THEN 'On-the-Water'
			Else AC.Branch
		End as ITotalGroup,
		AC.ItemNo, 
		IM.ItemDesc as Descr,
		Case 	when substring(AC.ItemNo,12,1) in ('0','1','5') then 'Bulk' 
			When substring(AC.ItemNo,12,1) in ('2') then 'Mill' 
			else 'Package'
		End as ProdClass,
		ISNULL(NVStats.SVC,'') as SVC,
		IM.CatVelocityCd as CVC,
		AC.BegQOH as QtyOnHand,      
		AC.BegAC AS AvgCost,
		AC.BegQOH * AC.BegAC as ExtendedAvgCost,
		IM.Wght as Net, 
		AC.BegQOH * IM.Wght as ExtendedNetWeight,
		IM.GrossWght as Gross, 
		AC.BegQOH * IM.GrossWght as ExtendedGrossWeight,
		ISNULL(MoUse,0) as MoUse,
		isnull(AC.BegAC*MoUse,0) as ExtendedThirtyDayUseCost,
		isnull(IM.Wght*MoUse,0) as ExtendedThirtyDayUseWeight,
		ISNULL(StndCst,0) as StndCst,
		ISNULL(RplCst,0) as RplCst
	From 	
		(SELECT	IB.Location AS Loc, .
			IM.ItemNo AS Item, 
			IB.ReplacementCost AS RplCst, 
			IB.StdCost AS StndCst, 
			IB.ReOrderPoint / 3 AS MoUse, 
			IB.SalesVelocityCd AS SVC
		FROM	ItemMaster IM (NoLock) 
		INNER JOIN ItemBranch IB (NoLock) ON 
			IM.pItemMasterID = IB.fItemMasterID
		WHERE	(IB.Location BETWEEN '01' AND '90')
		) NVStats
	Right Outer Join OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.AvgCst_Daily AC  ON	
		AC.ItemNo=NVStats.Item and AC.Branch=NVStats.Loc 
	Right Outer Join ItemMaster IM (NoLock) ON
		AC.ItemNo=IM.ItemNo
	Right Outer Join CAS_CatGrpDesc CGD (NoLock) ON
		left(AC.ItemNo,5) = CGD.Category
	Cross Join DashboardRanges DR (NoLock)
	Where   AC.BegQOH > 0
		and AC.Branch not in ('00','17','99','Transit')
		and DR.DashboardParameter = 'CurrentDay'
		-- and AC.CurDate BETWEEN @BegDate and @EndDate
	) Raw1
Group by CurrentDt,Branch,Category,DonGroupNo,DonGroupDesc,DonSort,BuyGroupNo,BuyGroupDesc,ITotalGroup

select * from #OldList




select * from
(

	SELECT
--			DISTINCT Branch, Category
			CurrentDt,
			Branch,
			Category,
			DonGroupNo,
			DonGroupDesc,
			DonSort,
			BuyGroupNo,
			BuyGroupDesc,
			ITotalGroup,
			isnull(sum(QtyOnHand),0) as ExtendedQtyOnHand,
			isnull(sum(ExtendedAvgCost),0) as ExtendedAvgCost,
			isnull(sum(ExtendedNetWeight),0) as ExtendedNetWeight,
			isnull(sum(ExtendedGrossWeight),0) as ExtendedGrossWeight,
			isnull(sum(MoUse),0) as ExtendedThirtyDayUsage,
			isnull(sum(ExtendedThirtyDayUseCost),0) as ExtendedThirtyDayUseCost,
			isnull(sum(ExtendedThirtyDayUseWeight),0) as ExtendedThirtyDayUseWeight,
			0 as Actual12MonthsSalesDollars,
			0 as Actual12MonthsSalesLbs,
			'pRPTItotalBuyGroup' as EntryId,
			CAST({ fn CURDATE() } AS DATETIME) as EntryDt
	FROM	(



SELECT	DR.EndDate as CurrentDt,
					CGD.GroupNo as BuyGroupNo,
					CGD.Description as BuyGroupDesc,
					CGD.DonGroup as DonGroupDesc, 
					CGD.DonGroupNo,
					CGD.DonSort,
					CASE WHEN AC.Branch =  'VENDTRANS' THEN '9995'
						 WHEN AC.Branch = 'INTRATRANS' THEN '9992'
						 WHEN AC.Branch =   'CARTRANS' THEN '9991'
--????					 WHEN AC.Branch =  'BR40TRANS' THEN '9990'
						 ELSE AC.Branch
					END as Branch,
					Left(AC.ItemNo,5) as Category,
					CASE WHEN AC.Branch BETWEEN '00' AND '98' THEN 'Branch'	
						 WHEN AC.Branch =         'VENDTRANS' THEN 'On-the-Water'
						 ELSE AC.Branch
					END as ITotalGroup,
					AC.ItemNo, 
					IM.ItemDesc as Descr,
					CASE WHEN substring(AC.ItemNo,12,1) in ('0','1','5') THEN 'Bulk' 
						 WHEN substring(AC.ItemNo,12,1) in ('2')         THEN 'Mill'
						 ELSE 'Package'
					END as ProdClass,
					ISNULL(NVStats.SVC,'') as SVC,
					IM.CatVelocityCd as CVC,
					AC.BegQOH as QtyOnHand,      
					AC.BegAC AS AvgCost,
					AC.BegQOH * AC.BegAC as ExtendedAvgCost,
					IM.Wght as Net, 
					AC.BegQOH * IM.Wght as ExtendedNetWeight,
					IM.GrossWght as Gross, 
					AC.BegQOH * IM.GrossWght as ExtendedGrossWeight,
					ISNULL(MoUse,0) as MoUse,
					isnull(AC.BegAC*MoUse,0) as ExtendedThirtyDayUseCost,
					isnull(IM.Wght*MoUse,0) as ExtendedThirtyDayUseWeight,
					ISNULL(StndCst,0) as StndCst,
					ISNULL(RplCst,0) as RplCst
			 FROM	PFCAC.dbo.AvgCst_Daily AC (NoLock) INNER JOIN
					ItemMaster IM (NoLock)
			 ON		AC.ItemNo = IM.ItemNo LEFT OUTER JOIN
					CAS_CatGrpDesc CGD (NoLock)
			 ON		left(AC.ItemNo,5) = CGD.Category LEFT OUTER JOIN
					(SELECT	IB.Location AS Loc, .
							IM.ItemNo AS Item, 
							IB.ReplacementCost AS RplCst, 
							IB.StdCost AS StndCst, 
							IB.ReOrderPoint / 3 AS MoUse, 
							IB.SalesVelocityCd AS SVC
					 FROM	ItemMaster IM (NoLock) INNER JOIN
							ItemBranch IB (NoLock)
					 ON		IM.pItemMasterID = IB.fItemMasterID
					 WHERE	IB.Location BETWEEN '01' AND '90') NVStats
			 ON		AC.ItemNo = NVStats.Item AND AC.Branch = NVStats.Loc CROSS JOIN
					DashboardRanges DR (NoLock)
			 Where	AC.BegQOH > 0 and
	--				AC.CurDate BETWEEN @BegDate and @EndDate and
					AC.Branch not in ('00','17','99','Transit') and
					DR.DashboardParameter = 'CurrentDay'




) Raw1
	Group by CurrentDt, Branch, Category, DonGroupNo, DonGroupDesc, DonSort, BuyGroupNo, BuyGroupDesc, ITotalGroup


) newlist


where Branch + Category not in

(
select * from #OldList

)
	






select	DonGroupNo,
		DonGroup, DonSort--, BuyGroupNo, BuyGroupDesc, *
from	CAS_CatGrpDesc Don (NoLock)
where	isnull(DonGroupNo,'') = ''





select * from CAS_CatGrpDesc
where CATEGORY in ('02370','02365','02367','02362')






select	distinct left(ItemNo,5)
from	PFCAC.dbo.AvgCst_Daily AC (NoLock)
where	AC.Branch not in ('00','17','99','Transit') and
		AC.Branch between '01' AND '90' and
		left(ItemNo,5) not in (select Category from CAS_CatGrpDesc)
order by left(ItemNo,5)