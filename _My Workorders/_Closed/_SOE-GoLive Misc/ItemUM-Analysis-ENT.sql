select [Last Date Modified], * from [Porteous$Item] where No_='99907-6005-699'

select [Last Date Modified], * from [Porteous$Item Unit of Measure] where [Item No_]='99907-6005-699'


select CostPurUM, PriceUM, SellUM, SleeveUM, *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster
where  [ItemNo]='99907-6005-699'

select *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemUM
where  fItemMasterID=130714


       SELECT  MAX([Purchase Price Per Alt_]) as CostPurUM
                         FROM    [Porteous$Item Unit of Measure]
                         WHERE   [Porteous$Item Unit of Measure].[Item No_] = '99907-6005-699' AND [Purchase Qty Alt_] = 1

       SELECT MAX([Purchase Price Per Alt_]) as PriceUM
                       FROM   [Porteous$Item Unit of Measure]
                       WHERE  [Porteous$Item Unit of Measure].[Item No_] = '99907-6005-699' AND [Purchase Qty Alt_]= 1

       SELECT    MAX([Sales Price Per Alt_]) as SellUM
                      FROM  [Porteous$Item Unit of Measure]
                      WHERE [Porteous$Item Unit of Measure].[Item No_] = '99907-6005-699' AND [Sales Qty Alt_] = 1

       SELECT MAX(Code) as SleeveUM
                        FROM   [Porteous$Item Unit of Measure]
                        WHERE  [Porteous$Item Unit of Measure].[Item No_] = '99907-6005-699' AND [Code] = 'SL'










