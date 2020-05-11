drop proc [pSOECreateCAforERPOrder_TDixon] 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[pSOECreateCAforERPOrder_TDixon] 
	-- Add the parameters for the stored procedure here
	@orderNo BIGINT = 0
AS
BEGIN
-- =============================================
-- Author:		Craig Parks
-- Create date: 8/12/2009
-- Description:	Create RB Adjustments to Ship ERP Orders
-- Parameters: @orderNo = Order number of ERP order to ship
-- Modified: 3/25/2010 Craig Parks Ship only available record remainter in Sales bin
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
/*
	EXEC [pSOECreateCAforERPOrder_TDixon] @orderNo=20727
*/
SET NOCOUNT ON;

SELECT	fSOHeaderRelID AS StkID,
	SODR.ItemNo,
	LINENUMBER AS [LineNo],
	ISNULL(BLA.LOCATION,IMLoc) AS Location,
	ISNULL(SUM (ISNULL(QUANTITY,0) * ISNULL(PACKSIZE,0)),0) AS OnHandRB,
	SUM(QtyShipped) AS Requested
INTO	#ONHandRB
FROM	SoDetailRel SODR (NOLOCK) LEFT OUTER JOIN 
	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.[BINLOCAT] BLA
ON	SODR.ItemNo = BLA.PRODUCT AND SODR.IMLoc = BLA.LOCATION and BLA.BINLABEL = SODR.IMLoc+'STK'+SODR.IMLoc
WHERE	fSOHeaderRelID = @OrderNo
GROUP BY fSOHeaderRelID, SODR.ItemNo, LineNumber, ISNULL(BLA.LOCATION,IMLoc)


--PRINT 'Order '+CAST(@orderNo as VARCHAR)
--SELECT * FROM #ONHandRB


INSERT INTO OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.[DNLOAD]
	(FIELD001, FIELD002,FIELD003,FIELD004, FIELD005, FIELD006, FIELD007, FIELD008, FIELD009, FIELD010, FIELD011,
	 FIELD012, FIELD013, FIELD014, FIELD015, FIELD016, FIELD017, FIELD018, FIELD019, FIELD020, FIELD021, FIELD022,
	 FIELD023, FIELD024, FIELD025, FIELD026, FIELD027, FIELD028, FIELD029, FIELD030, FIELD031)
SELECT	'CA' as [Type],
	'MA' AS AdjType,
	SOD.ItemNo,
	Left(ItemDsc,40) AS ItemDsc,
	1 as UM,
	NULL AS ProdCls,
	IM.UPCCd, 
	CASE WHEN QtyShipped <= OnHandRB
	     THEN CAST(CAST(QtyShipped AS INT) AS VARCHAR) 
	     ELSE CAST(CAST(OnHandRB AS INT) AS VARCHAR)
	END AS ToReceive,
	'1' AS Packsize,
	'-' AS QtySign,
	SOD.IMLoc+'STK'+SOD.IMLoc As PickBin,
	NULL AS resStockFlag,
	CAST(OrderNo AS VARCHAR) as PONo,
	NULL AS Comment,
	'' AS attr1,
	'' AS attr2,
	'' AS attr3,
	'' AS attr4,
	'' AS attr5,
	'' AS attr6,
	'' AS attr7,
	'' AS attr8,
	'' AS attr9,
	'' AS attr10,
	'0000000000' AS RcvAttr,
	'' AS ExpectedRecDt,
	NULL AS ClientName,
	NULL AS InnerPack,
	NULL AS MinRepl,
	NULL AS MaxRepl,
	NULL AS LicensePlate
FROM	SOHeaderRel (NOLOCK) SOH JOIN SODetailRel (NOLOCK) SOD
ON	pSOHeaderRelID = fSOHeaderRelID,
	ItemMaster (NOLOCK) IM, #ONHandRB 
WHERE	OrderNo = StkID AND SOD.ItemNo = IM.ItemNo AND StkID = fSOHeaderRelID AND
	SOD.ItemNo = #ONHandRB.ItemNo AND LineNumber = [LineNo] AND
	CASE WHEN QtyShipped <= OnHandRB
	     THEN CAST(CAST(QtyShipped AS INT) AS VARCHAR) 
	     ELSE CAST(CAST(OnHandRB AS INT) AS VARCHAR)
	END > 0


INSERT INTO OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.[DNLOAD]
	(FIELD001, FIELD002,FIELD003,FIELD004, FIELD005, FIELD006, FIELD007, FIELD008, FIELD009, FIELD010, FIELD011,
	 FIELD012, FIELD013, FIELD014, FIELD015, FIELD016, FIELD017, FIELD018, FIELD019,
	 FIELD020, FIELD021, FIELD022, FIELD023, FIELD024, FIELD025, FIELD026, FIELD027, FIELD028, FIELD029,
	 FIELD030, FIELD031)
SELECT	'CA' as [Type],
	'MA' AS AdjType,
	SOD.ItemNo,
	Left(ItemDsc,40) AS ItemDsc,
	1 as UM,
	NULL AS ProdCls,
	IM.UPCCd, 
	CAST(CAST((QtyShipped - OnHandRB) AS INT) AS VARCHAR) AS SOLD,
	'1' AS Packsize, '+' AS QtySign,
	SOD.IMLoc+'SALE'+SOD.IMLoc As PickBin,
	NULL AS resStockFlag,
	CAST(OrderNo AS VARCHAR) as PONo,
	NULL AS Comment,
	'' AS attr1,
	'' AS attr2,
	'' AS attr3,
	'' AS attr4,
	'' AS attr5,
	'' AS attr6,
	'' AS attr7,
	'' AS attr8,
	'' AS attr9,
	'' AS attr10,
	'0000000000' AS RcvAttr,
	'' AS ExpectedRecDt,
	NULL AS ClientName,
	NULL AS InnerPack,
	NULL AS MinRepl,
	NULL AS MaxRepl,
	'SALE:'+CAST(StkID AS VARCHAR) AS LicensePlate
FROM	SOHeaderRel (NOLOCK) SOH JOIN SODetailRel (NOLOCK) SOD
ON 	pSOHeaderRelID = fSOHeaderRelID,
	ItemMaster (NOLOCK) IM, #ONHandRB 
WHERE	OrderNo = StkID AND SOD.ItemNo = IM.ItemNo  AND StkID = fSOHeaderRelID AND
	#ONHandRB.ItemNo = SOD.ItemNo AND LineNumber = [LineNo] AND (QtyShipped - OnHandRB) > 0

DROP table #ONHandRB

END