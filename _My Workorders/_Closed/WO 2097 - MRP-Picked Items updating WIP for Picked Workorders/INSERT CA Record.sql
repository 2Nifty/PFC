INSERT
INTO	OpenDataSource('SQLOLEDB','Data Source=PFCRFDB;User ID=pfcnormal;Password=pfcnormal').rbeacon.dbo.[DNLOAD]
	(FIELD001, FIELD002,FIELD003,FIELD004, FIELD005, FIELD006, FIELD007, FIELD008, FIELD009, FIELD010,
	FIELD011, FIELD012, FIELD013, FIELD014, FIELD015, FIELD016, FIELD017, FIELD018, FIELD019, FIELD020,
	FIELD021, FIELD022, FIELD023, FIELD024, FIELD025, FIELD026, FIELD027, FIELD028, FIELD029, FIELD030, FIELD031)

--delete me
Declare @OrderNo varchar(20)
Set @OrderNo ='357719'
--end delete me 


SELECT	'CA' as [Type]
	,'MA' AS AdjType
	,SOD.ItemNo
	,Left(ItemDsc,40)
	,1 as UM
	,'' AS ProdCls
	,IM.UPCCd
	,CAST(CAST(QtyShipped AS INT) AS VARCHAR) AS ToReceive
	,'1' AS Packsize
	,'+' AS QtySign
	,RTRIM(SOH.CustShipLoc)+'WIP01' As RecBin
	,'' AS resStockFlag
	,CAST(OrderNo AS VARCHAR) as PONo
	,'' AS Comment
	,'' AS attr1
	,'' AS attr2
	,'' AS attr3
	,'' AS attr4
	,'' AS attr5
	,'' AS attr6
	,'' AS attr7
	,'' AS attr8
	,'' AS attr9
	,'' AS attr10
	,'0000000000' AS RcvAttr
	,'' AS ExpectedRecDt
	,'' AS ClientName
	,'' AS InnerPack
	,'' AS MinRepl
	,'' AS MaxRepl
	,'WO' + CAST(@orderNo as VARCHAR) AS LicensePlate --Put in the Transfer Order LP No here
FROM	SOHeaderRel (NOLOCK) SOH JOIN
	SODetailRel (NOLOCK) SOD
ON 	pSOHeaderRelID = fSOHeaderRelID,
	ItemMaster (NOLOCK) IM
WHERE	OrderNo = @orderNo  --Change the Released Order Number Here
--	AND SOH.SubType between '46' and '49'
	AND SOD.ItemNo = IM.ItemNo 
	AND(QtyShipped  <> 0 OR QtyOrdered < 0)
	AND SOD.DeleteDt IS NULL 
	AND SOH.DeleteDt IS NULL


SELECT	'CA' as [Type]
		,'MA' AS AdjType
		,SOD.ItemNo
		,Left(ItemDsc,40)
		,1 as UM
		,'' AS ProdCls
		,IM.UPCCd
		,CAST(CAST(QtyShipped AS INT) AS VARCHAR) AS WipQty
		,'1' AS Packsize
		,'+' AS QtySign
		,RTRIM(SOH.ShipLoc)+'WIP01' As RecBin
		,'' AS resStockFlag
		,CAST(SOH.OrderNo AS VARCHAR) as PONo
		,'' AS Comment
		,'' AS attr1
		,'' AS attr2
		,'' AS attr3
		,'' AS attr4
		,'' AS attr5
		,'' AS attr6
		,'' AS attr7
		,'' AS attr8
		,'' AS attr9
		,'' AS attr10
		,'0000000000' AS RcvAttr
		,'' AS ExpectedRecDt
		,'' AS ClientName
		,'' AS InnerPack
		,'' AS MinRepl
		,'' AS MaxRepl
		,SOH.CustPONo AS LicensePlate --Put in the WorkOrder number LPN here
FROM	SOHeaderRel (NOLOCK) SOH 
JOIN	SODetailRel (NOLOCK) SOD ON 
		pSOHeaderRelID = fSOHeaderRelID
		,ItemMaster (NOLOCK) IM
WHERE	OrderNo = @orderNo  --Change the Released Order Number Here
		AND SOD.ItemNo = IM.ItemNo 
		AND(QtyShipped  <> 0 OR QtyOrdered < 0)
		AND SOD.DeleteDt IS NULL 
		AND SOH.DeleteDt IS NULL