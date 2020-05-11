exec pPORptUnRcvd


SELECT	DISTINCT LD.ListValue as CatNo,
	LD.ListDtlDesc as CatDesc,
	POD.ItemNo,
	SUBSTRING(POD.ItemNo,7,4) as SizeNo,
	RIGHT(POD.ItemNo,3) as VarianceNo,
	IM.ItemSize,
	POH.POOrderNo as DocNo,
	POD.POStatusCd,
	VA.AlphaSearch as VendorCd,--POH.BuyFromVendorNo ,
	ReceivingLocation as Loc,
	isnull(POD.SuperEquivQty,0) as QtySuperEquiv,
	POD.QtyOrdered,
	POD.QtyReceived,
	POD.RequestedReceiptDt as RequestedDt,
	POD.PlannedRcptDt,
	POD.LastSchdReceiptDt as ExpectedDt,
	POD.QtyOrdered - POD.QtyReceived as QtyDue,
	POD.AlternateCost,
	POD.CostUM,
	POD.ExtendedCost
--INTO	#tWO1804_UnrcvdPO
FROM	POHeader POH (NoLock) 
INNER JOIN PODetail POD (NoLock) ON	
	POH.pPOHeaderID = POD.fPOHeaderID 
INNER JOIN ItemMaster IM (NoLock) ON	
	IM.ItemNo = POD.ItemNo 
INNER JOIN VendorAddress va (NoLock)

--(SELECT DISTINCT VendorNoNV, AlphaSearch FROM VendorAddress (NoLock)) VA
ON	VA.VendorNoNV = POH.BuyFromVendorNo


INNER JOIN ListDetail LD (NoLock)ON	
	LEFT(POD.ItemNo,5) = LD.ListValue 
INNER JOIN ListMaster LM (NoLock) ON	
	LD.fListMasterID = LM.pListMasterID
WHERE	LM.ListName ='CategoryDesc' 
		AND (POH.POSubType between '1' and '4') 
		AND (POD.QtyOrdered - POD.QtyReceived > 0)
--and left(POD.ItemNo,5)='00170' and BuyFromVendorNo='1002642'
--order by ItemNo, ReceivingLocation


select * from ListMaster LM inner join ListDetail LD on LD.fListMasterID = LM.pListMasterID
where LM.ListName ='CategoryDesc' and LD.ListValue = '02791'


select distinct * from VendorAddress where VendorNoNV='1002642'

select POH.POSubType, POD.QtyOrdered, POD.QtyReceived, POD.QtyOrdered - POD.QtyReceived as diff,
* 
FROM	POHeader POH (NoLock) 
INNER JOIN PODetail POD (NoLock) ON	
	POH.pPOHeaderID = POD.fPOHeaderID 
where left(ItemNo,5)='02790'





select ItemNo from ItemMaster
where left(ItemNo,5)='WAITI'
order by left(ItemNo,5)

where not exists

(select  * from ListMaster LM inner join ListDetail LD on LD.fListMasterID = LM.pListMasterID
where LM.ListName ='CategoryDesc' and  left(ItemNo,5)=LD.ListValue)
order by left(ItemNo,5)