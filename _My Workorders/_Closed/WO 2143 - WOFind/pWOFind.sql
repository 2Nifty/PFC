drop procedure [dbo].[pWOFind]
go


CREATE  procedure [dbo].[pWOFind]
	@UserId varchar(20),
	@WOType varchar(20),
	@MfgLoc varchar(10),
	@StatusDesc varchar(10),
	@StartDt datetime,
	@EndDt datetime

as

----pWOFind
----Written By: Tod Dixon
----Application: WOE

--Exec [pWOFind] '', '', '', '', '2010-Oct-01' ,'2010-Nov-16'
--Exec [pWOFind] 'toms', '', '', '', '' ,''
--Exec [pWOFind] '', '', '', '', '' ,''


SET	@EndDt = @EndDt + ' 23:59:59.59'

SELECT	POH.POOrderNo,
	POH.POType,
	POH.LocationCd,
	POD.ItemNo,
	POD.ItemDesc,
	isnull(POD.QtyOrdered,0) AS QtyOrdered,
	POD.BaseQtyUM,
	POH.SORefNo,
	isnull(isnull(POH.ChangeID,POH.EntryID),'') AS UserId,
	POH.OrderDt,
	POH.PickSheetDt,
	POD.RequestedReceiptDt,
	POH.MakeOrderDt,
	POH.AllocationDt,
	POH.WIPDt,
	POH.CompleteDt,
	POH.DeleteDt
FROM	POHeader POH (NoLock) INNER JOIN
	PODetail POD (NoLock)
ON	POH.pPOHeaderID = POD.fPOHeaderID
WHERE	--isnull(POH.DeleteDt,'') = '' AND isnull(POD.DeleteDt,'') = '' AND
	POH.POType in  (SELECT	ListValue AS WOType
			FROM	ListMaster LM (NoLock) INNER JOIN
				ListDetail LD (NoLock)
			ON	LM.pListMasterID = LD.fListMasterID
			WHERE	ListName = 'WOOrderType') AND
	isnull(POH.OrderDt,'') >= CASE isnull(@StartDt,'') WHEN '' THEN CAST(0 as DATETIME) ELSE CAST(@StartDt as DATETIME) END AND 
	isnull(POH.OrderDt,'') <= CASE isnull(@EndDt,'') WHEN '' THEN CAST('2999-Dec-31' as DATETIME) ELSE CAST(@EndDt as DATETIME) END AND 
	isnull(isnull(POH.ChangeID,POH.EntryID),'') LIKE CASE isnull(@UserId,'') WHEN '' THEN '%' ELSE @UserId END AND
	isnull(POH.POType,'') LIKE CASE isnull(@WOType,'') WHEN '' THEN '%' ELSE @WOType END AND
	isnull(POH.LocationCd,'') LIKE CASE isnull(@MfgLoc,'') WHEN '' THEN '%' ELSE @MfgLoc END AND


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
--															--
--	--------------------------------------------------------------------------------------------------------	--
--	|  Status --> | 'U'nallocated | 'A'llocated | 'W'arehouse | 'P'icked in WIP | 'C'ompleted |  'D'eleted |	--
--	|=======================================================================================================	--
--	|MakeOrderDt  |      null     |  11/17/2010 |  11/17/2010 |    11/17/2010   |      n/a    |     n/a    |	--
--	|AllocationDt |      null     |  11/17/2010 |  11/17/2010 |    11/17/2010   |      n/a    |     n/a    |	--
--	|PickSheetDt  |      null     |     null    |  11/17/2010 |    11/17/2010   |      n/a    |     n/a    |	--
--	|WIPDt        |      null     |     null    |     null    |    11/17/2010   |      n/a    |     n/a    |	--
--	|CompleteDt   |      null     |     null    |     null    |       null      |  11/17/2010 |     n/a    |	--
--	|DeleteDt     |      null     |     null    |     null    |       null      |      n/a    | 11/17/2010 |	--
--	--------------------------------------------------------------------------------------------------------	--
--															--
	--MakeOrderDt is null (Status 'U')
	isnull(POH.MakeOrderDt,'') =	CASE isnull(@StatusDesc,'') WHEN 'U' THEN ''
								    ELSE isnull(POH.MakeOrderDt,'') END AND
	--MakeOrderDt is not null (Status 'A', 'W' & 'P')
	isnull(POH.MakeOrderDt,'') <>	CASE isnull(@StatusDesc,'') WHEN 'A' THEN ''
								    WHEN 'W' THEN ''
								    WHEN 'P' THEN ''
								    ELSE CAST('2999-Dec-31' as DATETIME) END AND 

	--AllocationDt is null (Status 'U')
	isnull(POH.AllocationDt,'') =	CASE isnull(@StatusDesc,'') WHEN 'U' THEN ''
								    ELSE isnull(POH.AllocationDt,'') END AND
	--AllocationDt is not null (Status 'A', 'W' & 'P')
	isnull(POH.AllocationDt,'') <>	CASE isnull(@StatusDesc,'') WHEN 'A' THEN ''
								    WHEN 'W' THEN ''
								    WHEN 'P' THEN ''
								    ELSE CAST('2999-Dec-31' as DATETIME) END AND 

	--PickSheetDt is null (Status 'U' & 'A')
	isnull(POH.PickSheetDt,'') =	CASE isnull(@StatusDesc,'') WHEN 'U' THEN ''
								    WHEN 'A' THEN ''
								    ELSE isnull(POH.PickSheetDt,'') END AND
	--PickSheetDt is not null (Status 'W' & 'P')
	isnull(POH.PickSheetDt,'') <>	CASE isnull(@StatusDesc,'') WHEN 'W' THEN ''
								    WHEN 'P' THEN ''
								    ELSE CAST('2999-Dec-31' as DATETIME) END AND

	--WIPDt is null (Status 'U', 'A' & 'W')
	isnull(POH.WIPDt,'') =		CASE isnull(@StatusDesc,'') WHEN 'U' THEN ''
								    WHEN 'A' THEN ''
								    WHEN 'W' THEN ''
								    ELSE isnull(POH.WIPDt,'') END AND
	--WIPDt is not null (Status 'P')
	isnull(POH.WIPDt,'') <>		CASE isnull(@StatusDesc,'') WHEN 'P' THEN ''
								    ELSE CAST('2999-Dec-31' as DATETIME) END AND

	--CompleteDt is null (Status 'U', 'A', 'W' & 'P')
	isnull(POH.CompleteDt,'') =	CASE isnull(@StatusDesc,'') WHEN 'U' THEN ''
								    WHEN 'A' THEN ''
								    WHEN 'W' THEN ''
								    WHEN 'P' THEN ''
								    ELSE isnull(POH.CompleteDt,'') END AND
	--CompleteDt is not null (Status 'C')
	isnull(POH.CompleteDt,'') <>	CASE isnull(@StatusDesc,'') WHEN 'C' THEN ''
								    ELSE CAST('2999-Dec-31' as DATETIME) END AND

	--DeleteDt is null (Status 'U', 'A', 'W', 'P' & 'C')
	isnull(POH.DeleteDt,'') =	CASE isnull(@StatusDesc,'') WHEN 'U' THEN ''
								    WHEN 'A' THEN ''
								    WHEN 'W' THEN ''
								    WHEN 'P' THEN ''
								    WHEN 'C' THEN ''
								    ELSE isnull(POH.DeleteDt,'') END AND
	--DeleteDt is not null (Status 'D')
	isnull(POH.DeleteDt,'') <>	CASE isnull(@StatusDesc,'') WHEN 'D' THEN ''
								    ELSE CAST('2999-Dec-31' as DATETIME) END
--															--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

ORDER BY POH.POOrderNo

