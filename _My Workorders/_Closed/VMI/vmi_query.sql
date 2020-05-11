SELECT     VMI_Contract.ContractNo, VMI_Contract.Chain, VMI_Contract.ItemNo, VMI_ContracDetail.Branch, VMI_ContracDetail.AnnualQty, 
                      VMI_ContracDetail.Qty30Day, tCPRComplete.Usage30day
FROM         VMI_Contract INNER JOIN
                      VMI_ContracDetail ON VMI_Contract.ContractNo = VMI_ContracDetail.ContractNo AND VMI_Contract.Chain = VMI_ContracDetail.Chain AND 
                      VMI_Contract.ItemNo = VMI_ContracDetail.ItemNo INNER JOIN
                      tCPRComplete ON VMI_ContracDetail.ItemNo = tCPRComplete.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE     (VMI_Contract.Closed <> '1')