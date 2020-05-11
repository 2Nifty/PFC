
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pPORptUnRcvd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pPORptUnRcvd]
GO

CREATE  PROCEDURE [dbo].[pPORptUnRcvd]
as

----pPORptUnRcvd
----Author: Tod Dixon
----Created: 2010-Apr-28
----Desc: Find Unreceived PO's including OTW
----Application: Procurement Management

SELECT	LD.ListValue as CatNo,
	LD.ListDtlDesc as CatDesc,
	POD.ItemNo,
	SUBSTRING(POD.ItemNo,7,4) as SizeNo,
	RIGHT(POD.ItemNo,3) as VarianceNo,
	IM.ItemSize,
	POH.POOrderNo as DocNo,
	POD.POStatusCd,
	VM.Code as VendorCd,
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
FROM	POHeader POH (NoLock) INNER JOIN
	PODetail POD (NoLock)
ON	POH.pPOHeaderID = POD.fPOHeaderID INNER JOIN
	ItemMaster IM (NoLock)
ON	IM.ItemNo = POD.ItemNo INNER JOIN
	VendorMaster VM (NoLock)
ON	VM.VendNo = POH.BuyFromVendorNo INNER JOIN
	ListDetail LD (NoLock)
ON	LEFT(POD.ItemNo,5) = LD.ListValue INNER JOIN
	ListMaster LM (NoLock)
ON	LD.fListMasterID = LM.pListMasterID
WHERE	LM.ListName ='CategoryDesc' AND (POH.POSubType between '1' and '4') AND (POD.QtyOrdered - POD.QtyReceived > 0)

--UNION WITH OTW (future)

--SELECT	DISTINCT CatNo
--FROM	#tWO1804_UnrcvdPO

--SELECT	*
--FROM	#tWO1804_UnrcvdPO

GO