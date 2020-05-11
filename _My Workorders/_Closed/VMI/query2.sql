
SELECT     [NV$Sales Header].ContractNo, SUM([NV$Sales Line].Quantity) AS QTY, VMI_Contract.MonthFactor
FROM         [NV$Sales Header] INNER JOIN
                      VMI_Contract ON [NV$Sales Header].ContractNo = VMI_Contract.ContractNo INNER JOIN
                      [NV$Sales Line] ON [NV$Sales Header].No_ = [NV$Sales Line].[Document No_]
GROUP BY [NV$Sales Header].ContractNo, [NV$Sales Line].[Sales Location], [NV$Sales Line].No_, VMI_Contract.MonthFactor

