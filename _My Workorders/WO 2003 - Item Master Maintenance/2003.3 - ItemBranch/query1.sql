
------------------------------------------------------------------

declare @ItemNo VARCHAR(20)
set @ItemNo = '00020-2525-020'
set @ItemNo = '00200-4200-401'

SELECT	Loc.LocID as Location,
		CASE WHEN isnull(ItemNo,'') = '' THEN 'No Br Record' ELSE Loc.LocName END as LocName,
		--Loc.MaintainIMQtyInd as BrnInd,
		isnull(SKU.ItemNo,'No Br Record') as ItemNo,
		SKU.fItemMasterID as BrnID,
		CASE WHEN isnull(SKU.StockInd,0) = 1 THEN 'Yes' ELSE 'No' END as StockInd,
		isnull(SKU.SVC,'K') as SVC,
		isnull(SKU.ROP,0.8) as ROP,
		isnull(SKU.Capacity,0) as Capacity
FROM	LocMaster Loc (NoLock) LEFT OUTER JOIN
		(SELECT	IM.ItemNo,
				IM.pItemMasterID,
				Brn.fItemMasterID,
				Brn.Location,
				Brn.StockInd,
				Brn.SalesVelocityCd as SVC,
				Brn.ReorderPoint as ROP,
				Brn.Capacity
		 FROM	ItemMaster IM (NoLock) INNER JOIN
				ItemBranch Brn (NoLock)
		 ON		IM.pItemMasterID = Brn.fItemMasterID
		 WHERE	IM.ItemNo = @ItemNo) SKU
ON		SKU.Location = Loc.LocID
WHERE	Loc.MaintainIMQtyInd = 'Y'
ORDER BY Loc.LocID



-------------------------------------------------------------------


select fitemmasterid, count(*) from itembranch
group by fitemmasterid

select * from ItemMaster where pitemmasterid = 370


--select * from ItemBranch


select * from LocMaster where MaintainIMQtyInd = 'Y'
order by LocID

----------------------------------------------------------------------




select DeleteDt, * from Itembranch

exec sp_columns Itembranch

select distinct capacity from itembranch order by capacity



exec sp_columns itemmaster





update itemmaster set PCLBFTInd = ''
where ItemNo='00020-2525-020'


select * from itemmaster where isnull(PCLBFTInd,'') = '' and isnull(DeleteDt,'') =''