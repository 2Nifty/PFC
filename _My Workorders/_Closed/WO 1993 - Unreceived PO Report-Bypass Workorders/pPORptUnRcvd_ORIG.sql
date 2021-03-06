USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pPORptUnRcvd]    Script Date: 09/08/2010 18:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[pPORptUnRcvd]
as
----pPORptUnRcvd
----Author: Tod Dixon
----Created: 2010-Apr-28
----Desc: Find Unreceived PO's including OTW
----Application: Procurement Management

SELECT	DISTINCT
	LD.ListValue as CatNo,
	LD.ListDtlDesc as CatDesc,
	POD.ItemNo,
	SUBSTRING(POD.ItemNo,7,4) as SizeNo,
	RIGHT(POD.ItemNo,3) as VarianceNo,
	IM.ItemSize,
	POH.POOrderNo as DocNo,
	POD.POStatusCd,
	VA.AlphaSearch as VendorCd,
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
INNER JOIN VendorAddress VA (nolock) ON
	VA.VendorNoNV = POH.BuyFromVendorNo 
Inner JOIN ListDetail LD (NoLock)ON	
	LEFT(POD.ItemNo,5) = LD.ListValue 
Inner JOIN ListMaster LM (NoLock) ON	
	LD.fListMasterID = LM.pListMasterID
WHERE	LM.ListName ='CategoryDesc' 
		AND (POH.POSubType between '1' and '4') 
		AND (POD.QtyOrdered - POD.QtyReceived > 0)



--UNION WITH OTW (future)

--SELECT	DISTINCT CatNo
--FROM	#tWO1804_UnrcvdPO

--SELECT	*
--FROM	#tWO1804_UnrcvdPO
