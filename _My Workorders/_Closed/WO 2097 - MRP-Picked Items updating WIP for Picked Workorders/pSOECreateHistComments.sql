drop procedure pSOECreateHistComments
go


CREATE PROCEDURE [dbo].[pSOECreateHistComments] 
	@username VARCHAR(50) = NULL,
	@orderID BIGINT = 0
AS
BEGIN
	-- =============================================
	-- Author:	Craig Parks
	-- Create date:	11/12/2008
	-- Parameters:	@orderID = Order ID of source Order SOHeader,
	--		@username  = Calling User Name,
	--		@orderID = Released Comments ID and History Order Header Order No
	-- Description:	Create Comments for Released Sales Orders
	-- Modified: 10/21/10 TMD: Write to TOCommentsHist where SUBTYPE = 41 thru 49 [WO2097]
	-- =============================================	
	
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@subType VARCHAR(2)
	SELECT @subType = SubType FROM SOHeaderRel WHERE OrderNo = @orderID

	-- See if the Released order is a Transfer or WorkOrder SubType
	IF (CONVERT(INT, @subtype) = 5 or (CONVERT(INT, @subtype) >= 41 and CONVERT(INT, @subtype) <= 49))
	   BEGIN	-- Insert into TOCommentsHist
		INSERT
		INTO	dbo.TOCommentsHist
			(fTOHeaderHistID, [Type], FormsCd, CommLineNo, CommLineSeqNo, CommText, DeleteDt, EntryID, EntryDt) 
		SELECT	pTOHeaderHistID, [Type], FormsCd, CommLineNo, CommLineSeqNo, CommText, SOC.DeleteDt, @userName, GetDate()
		FROM	dbo.SOCommentsRel (NOLOCK) SOC,
			TOHeaderHist (NOLOCK) SOHH
		WHERE	SOC.fSOHeaderRelID = @orderID AND SOC.DeleteDt IS NULL AND SOHH.OrderNo = @orderID AND
			(([Type] IN ('CB', 'CT') OR 
			 ([Type] = 'LC' AND CommLineNo IN (SELECT LineNumber
			 				   FROM   dbo.TODetailHist (NOLOCK)
			 				   WHERE  fTOHeaderHistID = SOHH.pTOHeaderHistID AND DeleteDt IS NULL))))
	   END
	ELSE
	   BEGIN	-- Insert into SOCommentsHist
		INSERT
		INTO	dbo.SOCommentsHist
			(fSOHeaderHistID, [Type], FormsCd, CommLineNo, CommLineSeqNo, CommText, DeleteDt, EntryID, EntryDt) 
		SELECT	pSOHeaderHistID, [Type], FormsCd, CommLineNo, CommLineSeqNo, CommText, SOC.DeleteDt, @userName, GetDate()
		FROM	dbo.SOCommentsRel (NOLOCK) SOC,
			SOHeaderHist (NOLOCK) SOHH
		WHERE	SOC.fSOHeaderRelID = @orderID AND SOC.DeleteDt IS NULL AND SOHH.OrderNo = @orderID AND
			(([Type] IN ('CB', 'CT') OR 
			 ([Type] = 'LC' AND CommLineNo IN (SELECT LineNumber
			 				   FROM   dbo.SODetailHist (NOLOCK)
			 				   WHERE  fSOHeaderHistID = SOHH.pSOHeaderHistID AND DeleteDt IS NULL))))
	   END
END







