select [Global Dimension 1 Code] from Porteous$Customer where [No_]=039651
go
select Code, [E-Mail] from Porteous$Location where Code='02'




select * from vmi_contract


--Use this Query to populate ContractMngmt

SELECT		VMI_Contract.ContractNo AS ContractNo, VMI_Contract.Chain AS Chain, VMI_Contract.ItemNo AS ItemNo, VMI_ContractDetail.Branch AS Branch, 

		VMI_ContractDetail.AnnualQty / DATEDIFF (day, VMI_Contract.StartDate, VMI_Contract.EndDate) * 365 AS Loc_EAU_Qty, 
		(VMI_ContractDetail.AnnualQty / DATEDIFF (day, VMI_Contract.StartDate, VMI_Contract.EndDate) * 365) / 12 AS Loc_EAU_30_Day_Qty, 
		CPR_Daily.Use_30Day_Qty AS Tot_Brn_30D_Qty, CPR_Daily.Avail_Qty AS Brn_Avl, 

		CPR_Daily.OO_Qty AS OO_Qty, CPR_Daily.OO_Next_Date AS Next_PO_Date, CPR_Daily.OO_Next_Qty AS Next_PO_Qty, 
		CPR_Daily.OO_Next_Status AS Next_PO_Status, CPR_Daily.Trf_Qty AS Trans_Qty, CPR_Daily.Trf_Next_Date AS Next_Trans_Date, 
		CPR_Daily.Trf_Next_Qty AS Next_Trans_Qty, CPR_Daily.CPR_Buy_Factor AS Buy_Factor, CPR_Daily.CPR_Buy_Qty AS Buy_Qty
FROM		VMI_Contract INNER JOIN
		VMI_ContractDetail ON VMI_Contract.ItemNo = VMI_ContractDetail.ItemNo AND VMI_Contract.ContractNo = VMI_ContractDetail.ContractNo INNER JOIN
		CPR_Daily ON VMI_ContractDetail.ItemNo = CPR_Daily.ItemNo AND VMI_ContractDetail.Branch = CPR_Daily.LocationCode
WHERE		(VMI_Contract.Closed <> '1')




--Turn this into an update for the 30D_Use field in ContractMngmt

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tempVMI') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tempVMI
go

SELECT		[NV$Sales Invoice Header].ContractNo, [NV$Sales Invoice Line].No_, [NV$Sales Invoice Line].[Sales Location],
CASE WHEN	(DATEDIFF(day, VMI_Contract.StartDate, CuvnalRanges.EndDate) < 30)
		   THEN 0
		   ELSE SUM([NV$Sales Invoice Line].Quantity) / ((DATEDIFF(day, VMI_Contract.StartDate, CuvnalRanges.EndDate) - (DATEDIFF(day, VMI_Contract.StartDate, CuvnalRanges.EndDate) % 30)) / 30)
END		AS [30D_Use]
INTO		tempVMI
FROM		[NV$Sales Invoice Header] INNER JOIN
		[NV$Sales Invoice Line] ON [NV$Sales Invoice Header].No_ = [NV$Sales Invoice Line].[Document No_] INNER JOIN
		VMI_Contract ON [NV$Sales Invoice Header].ContractNo = VMI_Contract.ContractNo CROSS JOIN
		CuvnalRanges
WHERE		([NV$Sales Invoice Header].[Order Date] >= VMI_Contract.StartDate) AND ([NV$Sales Invoice Header].[Order Date] <= CuvnalRanges.EndDate)
GROUP BY	[NV$Sales Invoice Header].ContractNo, [NV$Sales Invoice Line].[Sales Location], [NV$Sales Invoice Line].No_,
		VMI_Contract.StartDate, CuvnalRanges.EndDate, CuvnalRanges.CuvnalParameter
HAVING		(CuvnalRanges.CuvnalParameter = 'PreviousMonth')
go

UPDATE	VMI_Contract_Mngmt
SET	[Act_30D_Use_Qty] = [tempVMI].[30D_Use]
FROM	[tempVMI]
WHERE	VMI_Contract_Mngmt.ContractNo=tempVMI.ContractNo AND VMI_Contract_Mngmt.ItemNo=tempVMI.No_ AND VMI_Contract_Mngmt.Branch=tempVMI.[Sales Location]
go



SELECT     ItemNo AS Expr1, LocationCode, Avail_Qty, Avail_Wgt, Avail_Cost, OO_Qty, OO_Wgt, OO_Cost, OO_30_Qty, OO_60_Qty, OO_90_Qty, OO_Next_Qty, 
                      OO_Next_Date, Use_30Day_Qty, CPR_Buy_Qty, CPR_Buy_Wgt, CPR_Buy_Cost, CPR_Buy_Factor
FROM         CPR_Daily
WHERE     (ItemNo = '00050-2450-021') AND (LocationCode = '11')



select * from tempVMI
select * from VMI_CONTRACT_Mngmt
