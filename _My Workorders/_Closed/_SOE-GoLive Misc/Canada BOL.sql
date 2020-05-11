select BolNo, * from SOHeaderRel where BOLNo<>'' order by TotalCost


select * from SODetailRel where fSOHeaderRelID in (Select pSOHeaderRelID from SOHeaderRel where BOLNo<>'')


select BOLNO, * from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=fSOHeaderRelID
where OrderType='TO' and BOLNO<>''


select BOLNO, * from SOHeaderRel where pSOHeaderRelID=38900
select  * from SODetailRel where fSOHeaderRelID =38900





exec pBOLRpt '8289300000001043729'
SELECT     [BL No], [Cat No], [Cat Desc], SUM(Quantity) AS CatQty, [Unit of Measure Code], CatLineCount, SUM([Avg Cost Ext]) AS [Avg Cost Ext], SUM([Avg Cost Ext (CAN)]) AS [Declared Cost Ext], SUM([Gross Wgt Ext]) AS [Gross Wgt], SUM([Net Wgt Ext]) AS [Net Wgt], SUM([Net Wgt Ext (KG)])    AS [Net Wgt (KG)] 
FROM         tLandedCostLines 
GROUP BY [Cat No], [Cat Desc], [Unit of Measure Code], CatLineCount, [BL No] ORDER BY [Cat No]