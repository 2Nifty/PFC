
SELECT     [NV$Sales Invoice Header].ContractNo, [NV$Sales Invoice Line].[Sales Location], [NV$Sales Invoice Line].No_, SUM([NV$Sales Invoice Line].Quantity) 
                      / DATEDIFF(day, VMI_Contract.StartDate, GETDATE()) * 30 AS Qty, VMI_Contract.StartDate
FROM         [NV$Sales Invoice Header] INNER JOIN
                      [NV$Sales Invoice Line] ON [NV$Sales Invoice Header].No_ = [NV$Sales Invoice Line].[Document No_] INNER JOIN
                      VMI_Contract ON [NV$Sales Invoice Header].ContractNo = VMI_Contract.ContractNo
GROUP BY [NV$Sales Invoice Header].ContractNo, [NV$Sales Invoice Line].[Sales Location], [NV$Sales Invoice Line].No_, VMI_Contract.StartDate

go



SELECT     VMI_Contract.ContractNo AS ContractNo, VMI_Contract.Chain AS Chain, VMI_Contract.ItemNo AS ItemNo, VMI_ContractDetail.Branch AS Branch, 
                      VMI_ContractDetail.AnnualQty AS Loc_EAU_Qty, VMI_ContractDetail.AnnualQty / 12 AS Loc_EAU_30_Day_Qty, 
                      CPR_Daily.Use_30Day_Qty AS Tot_Brn_30D_Qty, CPR_Daily.Avail_Qty AS Brn_Avl, CPR_Daily.OO_Qty AS OO_Qty, 
                      CPR_Daily.OO_Next_Date AS Next_PO_Date, CPR_Daily.OO_Next_Qty AS Next_PO_Qty, CPR_Daily.OO_Next_Status AS Next_PO_Status, 
                      CPR_Daily.Trf_Qty AS Trans_Qty, CPR_Daily.Trf_Next_Date AS Next_Trans_Date, CPR_Daily.Trf_Next_Qty AS Next_Trans_Qty, 
                      CPR_Daily.CPR_Buy_Factor AS Buy_Factor, CPR_Daily.CPR_Buy_Qty AS Buy_Qty, U.Qty AS [30D_Use]
FROM         VMI_Contract RIGHT OUTER JOIN
                      CPR_Daily INNER JOIN
                      VMI_ContractDetail ON CPR_Daily.ItemNo = VMI_ContractDetail.ItemNo AND CPR_Daily.LocationCode = VMI_ContractDetail.Branch LEFT OUTER JOIN
                          (SELECT     [NV$Sales Invoice Header].ContractNo, [NV$Sales Invoice Line].[Sales Location], [NV$Sales Invoice Line].No_, 
                                                   SUM([NV$Sales Invoice Line].Quantity) / DATEDIFF(day, VMI_Contract.StartDate, GETDATE()) * 30 AS QTY, 
                                                   VMI_Contract.StartDate
                            FROM          [NV$Sales Invoice Header] INNER JOIN
                                                   [NV$Sales Invoice Line] ON [NV$Sales Invoice Header].No_ = [NV$Sales Invoice Line].[Document No_] INNER JOIN
                                                   VMI_Contract ON [NV$Sales Invoice Header].ContractNo = VMI_Contract.ContractNo
                            GROUP BY [NV$Sales Invoice Header].ContractNo, [NV$Sales Invoice Line].[Sales Location], [NV$Sales Invoice Line].No_, VMI_Contract.StartDate) 
                      U ON VMI_ContractDetail.ContractNo = U.[ContractNo] AND VMI_ContractDetail.Branch = U.[Sales Location] AND 
                      VMI_ContractDetail.ItemNo = U.No_ ON VMI_Contract.ContractNo = VMI_ContractDetail.ContractNo AND 
                      VMI_Contract.Chain = VMI_ContractDetail.Chain AND VMI_Contract.ItemNo = VMI_ContractDetail.ItemNo
WHERE     (VMI_Contract.Closed <> '1')
ORDER BY VMI_Contract.Chain