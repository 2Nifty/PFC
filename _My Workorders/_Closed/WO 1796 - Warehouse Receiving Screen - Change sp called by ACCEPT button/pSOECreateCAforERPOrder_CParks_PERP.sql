USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pSOECreateCAforERPOrder]    Script Date: 04/22/2010 16:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pSOECreateCAforERPOrder] 
	-- Add the parameters for the stored procedure here
	@orderNo BIGINT = 0
AS
BEGIN
-- =============================================
-- Author:		Craig Parks
-- Create date: 8/12/2009
-- Description:	Create RB Adjustments to Ship ERP Orders
-- Parameters: @orderNo = Order number of ERP order to ship
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO 
OpenDataSource('SQLOLEDB','Data Source=PFCRFDB;User ID=pfcnormal;Password=pfcnormal').rbeacon.dbo.[DNLOAD]
(FIELD001, FIELD002,FIELD003,FIELD004, FIELD005, FIELD006, FIELD007, FIELD008, FIELD009, FIELD010,
FIELD011, FIELD012, FIELD013, FIELD014, FIELD015, FIELD016, FIELD017, FIELD018, FIELD019,
FIELD020, FIELD021, FIELD022, FIELD023, FIELD024, FIELD025, FIELD026, FIELD027, FIELD028, FIELD029,
FIELD030, FIELD031) SELECT 'CA' as [Type], 'MA' AS AdjType, SOD.ItemNo, Left(ItemDsc,40), 1 as UM, NULL AS ProdCls,
IM.UPCCd, CAST(CAST(QtyShipped AS INT) AS VARCHAR) AS ToReceive, '1' AS Packsize, '-' AS QtySign, SOD.IMLoc+'STK'+SOD.IMLoc As PickBin,
NULL AS resStockFlag, CAST(OrderNo AS VARCHAR) as PONo, NULL AS Comment, '' AS attr1, '' AS attr2,
'' AS attr3, '' AS attr4, '' AS attr5, '' AS attr6, '' AS attr7, '' AS attr8, '' AS attr9,
'' AS attr10, '0000000000' RcvAttr, '' AS ExpectedRecDt, NULL AS ClientName, NULL AS InnerPack, NULL AS MinRepl, NULL AS MaxRepl,
NULL AS LicensePlate FROM SOHeaderRel (NOLOCK) SOH JOIN SODetailRel (NOLOCK) SOD
ON pSOHeaderRelID = fSOHeaderRelID, ItemMaster (NOLOCK) IM
WHERE OrderNo = @orderNo AND SOD.ItemNo = IM.ItemNo 
END

