



CREATE   PROCEDURE [pACGetItemBranchDetail] 
	-- Add the parameters for the stored procedure here
	@ItemNo VARCHAR(20), 
	@Branch VARCHAR(10)

AS
BEGIN
-- =============================================
-- Author:		Charles Rojas
-- Create date: 09/02/09
-- Description:	Dumps Item Average Cost History for Tom for FYE2009
-- Parameters: 	@ItemNo = Item Number
--   		@Branch = Branch Number
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
Select * from (
SELECT     CONVERT(DATETIME, '2008-09-01 00:00:00', 102) as CurDate, Branch, ItemNo, BegQOH as FY09QOH, 0 as RcptQty, 0 as IssQty, 0 as AdjQty, '' as DocNo, '' as PartentDocNo, '' as SourceID
FROM         AvgCst_DailyHist
WHERE     (CurDate = CONVERT(DATETIME, '2008-09-02 00:00:00', 102))
	  And ItemNo = @ItemNo
	  And Branch = @Branch

Union

SELECT     RecDate as CurDate, Branch, ItemNo, 0 as FY09QOH, QtyRec as RcptQty, 0 as IssQty, 0 as AdjQty, DocNo, ParentDocNo, SourceID
FROM         AvgCst_RecHist
WHERE     (RecDate BETWEEN CONVERT(DATETIME, '2008-09-02 00:00:00', 102) AND CONVERT(DATETIME, '2009-08-29 00:00:00', 102))
	  And ItemNo = @ItemNo
	  And Branch = @Branch

Union

SELECT     IssDate as CurDate, Branch, ItemNo, 0 as FY09QOH, 0 as RcptQty, QtyReq*-1 as IssQty, 0 as AdjQty, DocNo, '' as ParentDocNo, SourceID
FROM         AvgCst_DailyIssHist
WHERE     (IssDate BETWEEN CONVERT(DATETIME, '2008-09-02 00:00:00', 102) AND CONVERT(DATETIME, '2009-08-29 00:00:00', 102))
	  And ItemNo = @ItemNo
	  And Branch = @Branch

Union

SELECT     AdjDate as CurDate, Branch, ItemNo, 0 as FY09QOH, 0 as RcptQty, 0 as IssQty, Qty as AdjQty, DocNo, '' as ParentDocNo, SourceID
FROM         AvgCst_AdjHist
Where (AdjDate BETWEEN CONVERT(DATETIME, '2008-09-02 00:00:00', 102) AND CONVERT(DATETIME, '2009-08-29 00:00:00', 102))
	  And ItemNo = @ItemNo
	  And Branch = @Branch

Union

SELECT    CONVERT(DATETIME, '2009-08-30 00:00:00', 102) as CurDate, Branch, ItemNo, BegQOH as FY09QOH, 0 as RcptQty, 0 as IssQty, 0 as AdjQty, '' as DocNo, '' as PartentDocNo, '' as SourceID
FROM         AvgCst_DailyHist
WHERE     (CurDate = CONVERT(DATETIME, '2009-08-29 00:00:00', 102))
	  And ItemNo = @ItemNo
	  And Branch = @Branch) tmp
Order by CurDate

END






GO
