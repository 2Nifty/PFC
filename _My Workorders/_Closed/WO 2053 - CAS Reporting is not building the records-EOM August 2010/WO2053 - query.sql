
declare @BegPer INT,
	@EndPer INT

SET	@BegPer = (dbo.fGetCuvnalMo1FYYear(Getdate()) * 100) + dbo.fGetCuvNalMo1FY(Getdate())
SET	@EndPer = (dbo.fGetCuvnalYear(Getdate()) * 100) + dbo.fGetCuvnalMonth(Getdate())

SELECT	dbo.fGetCuvnalYear(Getdate()) AS CurYear,
	dbo.fGetCuvnalMonth(Getdate()) AS CurMonth,
	CustNo,
	SUM(ISNULL(InvQty,0) * ISNULL(SellPrice,0)) AS Sales,
	SUM(ISNULL(InvQty,0) * ISNULL(NetWgt,0)) AS Wght,
	100 * (dbo.fDivide((SUM(ISNULL(InvQty,0) * ISNULL(SellPrice,0)) - SUM(ISNULL(InvQty,0) * ISNULL(SellCost,0))), SUM(ISNULL(InvQty,0) * ISNULL(SellPrice,0)),4)) AS GMPCT,
	0 AS PctTotSls,
	dbo.fDivide(Sum(ISNULL(InvQty,0) * ISNULL(SellPrice,0)),SUM(ISNULL(InvQty,0) * ISNULL(NetWgt,0)),5) AS DolLb,
	0 AS CatRank,
	[Location Code],
	ISNULL(GroupNo,0) GroupNo,
	ISNULL(substring([Description],1,30),'UNDEFINED')  AS Dsc,
	SUM(ISNULL(InvQty,0) * ISNULL(SellPrice,0)) - SUM(ISNULL(InvQty,0) * ISNULL(SellCost,0)) AS GM,
	system_user AS EntryID,
	getdate() AS EntryDt,
	'Customer'  AS RecType
FROM	CuvnalDtl CSI INNER JOIN
	CuvnalTempCustomer Cust
ON	CSI.CustNo = Cust.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS LEFT OUTER JOIN
	CAS_CatGrpDesc 
ON	CSI.Category = CAS_CatGrpDesc.Category 
--WHERE	(CurYear * 100) + CurMo BETWEEN (dbo.fGetCuvnalMo1FYYear(Getdate()) * 100) + dbo.fGetCuvNalMo1FY(Getdate()) AND
--					(dbo.fGetCuvnalYear(Getdate()) * 100) + dbo.fGetCuvnalMonth(Getdate())

WHERE	(CurYear * 100) + CurMo BETWEEN @BegPer AND @EndPer


Group BY CustNo, Cust.[Location Code], GroupNo, [Description]



--(CurYear * 100) + CurMo BETWEEN '200909' and '201008'


--and CustNo='024061'



select	getdate()-30 --Saturday 7/31/10
select	(dbo.fGetCuvnalMo1FYYear(Getdate()-30) * 100) + dbo.fGetCuvNalMo1FY(Getdate()-30),	--200909
	(dbo.fGetCuvnalYear(Getdate()-30) * 100) + dbo.fGetCuvnalMonth(Getdate()-30)		--201007

select	getdate()-29 --Sunday 8/1/10
select	(dbo.fGetCuvnalMo1FYYear(Getdate()-29) * 100) + dbo.fGetCuvNalMo1FY(Getdate()-29),	--200909
	(dbo.fGetCuvnalYear(Getdate()-29) * 100) + dbo.fGetCuvnalMonth(Getdate()-29)		--201007


select	getdate()-2 --Saturday 8/28/10
select	(dbo.fGetCuvnalMo1FYYear(Getdate()-2) * 100) + dbo.fGetCuvNalMo1FY(Getdate()-2),	--201009 should be 200909
	(dbo.fGetCuvnalYear(Getdate()-2) * 100) + dbo.fGetCuvnalMonth(Getdate()-2)		--201008

select	getdate()-1 --Sunday 8/29/10
select	(dbo.fGetCuvnalMo1FYYear(Getdate()-1) * 100) + dbo.fGetCuvNalMo1FY(Getdate()-1),	--201009 should be 200909
	(dbo.fGetCuvnalYear(Getdate()-1) * 100) + dbo.fGetCuvnalMonth(Getdate()-1)		--201008



select	getdate()+26 --Saturday 9/25/10
select	(dbo.fGetCuvnalMo1FYYear(Getdate()+26) * 100) + dbo.fGetCuvNalMo1FY(Getdate()+26),	--201009
	(dbo.fGetCuvnalYear(Getdate()+26) * 100) + dbo.fGetCuvnalMonth(Getdate()+26)		--201009

select	getdate()+27 --Sunday 9/26/10
select	(dbo.fGetCuvnalMo1FYYear(Getdate()+27) * 100) + dbo.fGetCuvNalMo1FY(Getdate()+27),	--201009
	(dbo.fGetCuvnalYear(Getdate()+27) * 100) + dbo.fGetCuvnalMonth(Getdate()+27)		--201009


select	getdate()+61 --Saturday 10/30/10
select	(dbo.fGetCuvnalMo1FYYear(Getdate()+61) * 100) + dbo.fGetCuvNalMo1FY(Getdate()+61),	--201009
	(dbo.fGetCuvnalYear(Getdate()+61) * 100) + dbo.fGetCuvnalMonth(Getdate()+61)		--201010

select	getdate()+62 --Sunday 10/31/10
select	(dbo.fGetCuvnalMo1FYYear(Getdate()+62) * 100) + dbo.fGetCuvNalMo1FY(Getdate()+62),	--201009
	(dbo.fGetCuvnalYear(Getdate()+62) * 100) + dbo.fGetCuvnalMonth(Getdate()+62)		--201010


select	getdate() --current day
select	(dbo.fGetCuvnalMo1FYYear(Getdate()) * 100) + dbo.fGetCuvNalMo1FY(Getdate()),		--201009 should be 200909
	(dbo.fGetCuvnalYear(Getdate()) * 100) + dbo.fGetCuvnalMonth(Getdate())			--201008





select	getdate()+10 --middle of month (9/10/10)
select	(dbo.fGetCuvnalMo1FYYear(Getdate()+10) * 100) + dbo.fGetCuvNalMo1FY(Getdate()+10),		--201009 should be 200909
	(dbo.fGetCuvnalYear(Getdate()+10) * 100) + dbo.fGetCuvnalMonth(Getdate()+10)			--201008



select	dbo.fGetCuvnalMo1FYYear(Getdate()),
	dbo.fGetCuvNalMo1FY(Getdate()),
	dbo.fGetCuvnalYear(Getdate()),
	dbo.fGetCuvnalMonth(Getdate())