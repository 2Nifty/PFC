Declare @CustNo varchar(20)
Declare	@Period varchar(20)
set @CustNo ='024061'
set @Period ='201011'

Select	CS.CurYear*100+CS.CurMo as Period
		,CS.CustNo
		,cast(isnull(CS.CMSales,0) as decimal(18,0)) as FMECurYrSales
		,cast(isnull(CS.LMSales,0) as decimal(18,0)) as FMELastYrSales
		,cast(isnull(CS.YTDSales,0) as decimal(18,0)) as FYECurYrSales
		,cast(isnull(CS.LYTDSales,0) as decimal(18,0)) as FYELastYrSales
		,Cast(Case	When isnull(CS.LMSales,0) = 0 then 0 else (isnull(CS.CMSales,0)-isnull(CS.LMSales,0))/isnull(CS.LMSales,0) end*100 as decimal(18,1)) as MEPctChange
		,Cast(Case	When isnull(CS.LYTDSales,0) = 0 then 0 else (isnull(CS.YTDSales,0)-isnull(CS.LYTDSales,0))/isnull(CS.LYTDSales,0) end *100 as decimal(18,1)) as YEPctChange
		,Cast(Cast(isnull(CGM,0) as decimal(18,0)) as varchar(50)) + ' / ' + Cast(cast(isnull(CGMPct,0)*100 as decimal(18,1)) as varchar(50)) as FMCurYrGM
From	CuvnalSum CS (nolock)
Where	CS.CustNo = @CustNo
		And CS.CurYear*100+CS.CurMo = @Period