SELECT     [Porteous$Sales Line].No_, [Porteous$Sales Line].[Unit Cost (LCY)], [Porteous$Sales Line].[Sales Cost], [Porteous$Sales Line].[Alt_ Sales Cost], 
                      [Porteous$Sales Line].[Location Code], [Porteous$Stockkeeping Unit].[Unit Cost]
FROM         [Porteous$Sales Line] INNER JOIN
                      [Porteous$Stockkeeping Unit] ON [Porteous$Sales Line].[Location Code] = [Porteous$Stockkeeping Unit].[Location Code] AND 
                      [Porteous$Sales Line].No_ = [Porteous$Stockkeeping Unit].[Item No_] AND 
                      [Porteous$Sales Line].[Sales Cost] <> [Porteous$Sales Line].[Unit Cost (LCY)]
ORDER BY [Porteous$Sales Line].No_


select [No_], [Repl Cost (LCY)], [Unit Cost (LCY)], [Porteous$Sales Line].[Sales Cost], Quantity, [Qty_ per Unit of Measure] from [Porteous$Sales Line]
where [Porteous$Sales Line].[Document No_] = 'SC100493'

select * from [Porteous$Sales Cr_Memo Line]
where [Document No_] = 'SC100493'


select [Item No_], [Location Code], [Replacement Cost] from [Porteous$Stockkeeping Unit] where [Item No_]='00171-4103-501'




--update  [Porteous$Stockkeeping Unit]
--set     [Porteous$Stockkeeping Unit].[Replacement Cost] = [tempStockkeeping Unit].[Replacement Cost]
--FROM         [Porteous$Stockkeeping Unit] INNER JOIN
--                      [tempStockkeeping Unit] ON [Porteous$Stockkeeping Unit].[Location Code] = [tempStockkeeping Unit].[Location Code] AND 
--                      [Porteous$Stockkeeping Unit].[Item No_] = [tempStockkeeping Unit].[Item No_]