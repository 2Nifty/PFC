USE [DEVPERP]
GO
/****** Object:  StoredProcedure [dbo].[pCustPriceGetHist]    Script Date: 03/26/2010 17:04:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[pCustPriceGetHist]
@CustNo varchar(20)
as
/*
	=============================================
	Author:		Tom Slater
	Create date: 3/15/2010
	Description: Get Customer Price History for Category Price Schedule Maintenance
	=============================================
	Derived from pWO1755_GetCustData Written By Charles Rojas
	Create Date: 02/19/10

	exec pCustPriceGetHist '004401'
*/
BEGIN
declare @RecsFound BIGINT;
set @RecsFound = 0;
-- see if there are any approval records waiting
select 
	@RecsFound=count(*)
from UnprocessedCategoryPrice with (NOLOCK)
where CustomerNo = @CustNo;

if isnull(@RecsFound,0) > 0
	begin

	select *
		,'1' as RecType
	from UnprocessedCategoryPrice with (NOLOCK)
	where CustomerNo = @CustNo;

	SELECT	CustNo as CustomerNo
			,CustName as CustomerName
			,ShipLocation as Branch
			,CreditInd
			,ContractSchd1
			,ContractSchd2
			,ContractSchd3
			,ContractSchedule4
			,ContractSchedule5
			,ContractSchedule6
			,ContractSchedule7
			,TargetGrossMarginPct
			,WebDiscountPct
			,WebDiscountInd
			,(SELECT LD.ListDtlDesc FROM CustomerMaster (NoLock) INNER JOIN
				(SELECT ListValue, ListDtlDesc FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID=fListMasterID WHERE ListName='CustDefPriceSchd') LD
				 ON LD.ListValue=CustomerDefaultPrice WHERE CustNo=@CustNo) as CustomerDefaultPrice
			,(SELECT LD.ListDtlDesc FROM CustomerMaster (NoLock) INNER JOIN
				(SELECT ListValue, ListDtlDesc FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID=fListMasterID WHERE ListName='CustPriceInd') LD
				 ON LD.ListValue=CustomerPriceInd WHERE CustNo=@CustNo) as CustomerPriceInd
	FROM	CustomerMaster CM (Nolock) 
	WHERE	CM.CustNo=@CustNo;	

	end
else
	begin
	SELECT	tmp2.Branch
		,tmp2.CustNo as CustomerNo
		,tmp2.CustName as CustomerName
		,tmp2.GroupNo
		,tmp2.GroupDesc
		,tmp2.GroupSales as SalesHistory
		,round(tmp2.PriceCostGMPct,2) as GMPctPriceCost
		,0.0 as TargetGMPct
		,'0' as Approved
		,'0' as RecType
		,-1 as pUnprocessedCategoryPriceID
	FROM
		(SELECT CustNo
			,CustName
			,Branch
			,ListValue as GroupNo
			,ListDtlDesc as GroupDesc
			,isnull(sum(Sales),0) as GroupSales
			,Case when Sum(Sales) = 0 then 0 
				else 100*Sum(PriceGMDol)/sum(Sales) end as PriceCostGMPct
		From
			(SELECT	SOH.ARPostDt 
				,SOH.SellToCustNo as CustNo 
				,CM.CustShipLocation as Branch
				,SOH.SellToCustName as CustName 
				,SOD.ItemNo 
				,CAS.GroupNo as ListValue
				,CAS.Description as ListDtlDesc
				,SOD.QtyShipped 
				,SOD.NetUnitPrice 
				,SOD.UnitCost 
				,IB.PriceCost
				,IB.CurrentReplacementCost 
				,IB.ReplacementCost 
				,SOH.InvoiceNo
				,isnull(SOD.QtyShipped*SOD.NetUnitPrice,0) as Sales
				,SOD.QtyShipped*SOD.NetUnitPrice - SOD.QtyShipped*SOD.UnitCost as AvgGMDol
				,Case 	when isnull(IB.ReplacementCost,0) = 0  then SOD.QtyShipped*SOD.NetUnitPrice - SOD.QtyShipped*SOD.UnitCost
						Else SOD.QtyShipped*SOD.NetUnitPrice - SOD.QtyShipped*IB.ReplacementCost 
				End as RplGMDol
				,Case 	when isnull(IB.PriceCost,0) = 0  then SOD.QtyShipped*SOD.NetUnitPrice - SOD.QtyShipped*SOD.UnitCost
						Else SOD.QtyShipped*SOD.NetUnitPrice - SOD.QtyShipped*IB.PriceCost 
				End as PriceGMDol
			FROM	ItemBranch IB (NoLock)
			INNER JOIN SOHeaderHist SOH  (NoLock)
			INNER JOIN SODetailHist SOD (NoLock) ON 
				SOH.pSOHeaderHistID = SOD.fSOHeaderHistID 
			INNER JOIN ItemMaster IM (NoLock) ON 
				SOD.ItemNo = IM.ItemNo  ON 
				IB.fItemMasterID = IM.pItemMasterID 
				AND IB.Location = SOD.IMLoc 
			Left Outer Join CategoryBuyGroups CAS (NoLock) ON
				CAS.Category = left(SOD.ItemNo,5)
			INNER JOIN FiscalCalendar FC (NoLock) On
				SOH.ARPostDt = FC.CurrentDt
			INNER JOIN CustomerMaster CM (Nolock) ON
				CM.CustNo = SOH.SellToCustNo
			Left Outer Join CompetitorPrice CP (Nolock) ON
				CP.PFCItem = SOD.ItemNo
			--Use last 3 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
			WHERE	substring(SOD.ItemNo,12,1) in ('0','1','5')
				AND (FC.FiscalCalYear*100+FiscalCalMonth Between (datepart(yyyy,dateadd(m,-3,getdate()))*100)+datepart(m,dateadd(m,-3,getdate()))
				AND (datepart(yyyy,dateadd(m,-1,getdate()))*100)+datepart(m,dateadd(m,-1,getdate())))
				And Case when CP.PFCItem is null then '' else 'Skip' end <>'SKIP'
				AND SOH.SellToCustNo=@CustNo
			) tmp
		Group by CustNo, CustName, Branch, ListValue,ListDtlDesc
		) tmp2
	Order by tmp2.CustNo, tmp2.GroupSales desc;

	SELECT	CustNo as CustomerNo
			,CustName as CustomerName
			,ShipLocation as Branch
			,CreditInd
			,ContractSchd1
			,ContractSchd2
			,ContractSchd3
			,ContractSchedule4
			,ContractSchedule5
			,ContractSchedule6
			,ContractSchedule7
			,TargetGrossMarginPct
			,WebDiscountPct
			,WebDiscountInd
			,(SELECT LD.ListDtlDesc FROM CustomerMaster (NoLock) INNER JOIN
				(SELECT ListValue, ListDtlDesc FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID=fListMasterID WHERE ListName='CustDefPriceSchd') LD
				 ON LD.ListValue=CustomerDefaultPrice WHERE CustNo=@CustNo) as CustomerDefaultPrice
			,(SELECT LD.ListDtlDesc FROM CustomerMaster (NoLock) INNER JOIN
				(SELECT ListValue, ListDtlDesc FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID=fListMasterID WHERE ListName='CustPriceInd') LD
				 ON LD.ListValue=CustomerPriceInd WHERE CustNo=@CustNo) as CustomerPriceInd
	FROM	CustomerMaster CM (Nolock) 
	WHERE	CM.CustNo=@CustNo;	

	end;

End
