CREATE   PROCEDURE [pACGetItemBranchDetail] 
	@BeginDt	DATETIME,
	@EndDt		DATETIME,
	@ItemNo		VARCHAR(20), 
	@Branch		VARCHAR(10)

AS
BEGIN

-- =============================================
-- Author:	Charles Rojas
-- Create date:	09/02/09
-- Modified By:	Tod Dixon
-- Mod Date:	09/03/09
-- Mods:	Added @BeginDt and @EndDt paramaters
-- Description:	Dumps Item Average Cost History for Tom for FYE2009
-- Parameters:	@BeginDt = Beginning Date
--		@EndDt = Ending Date
--		@ItemNo = Item Number
--		@Branch = Branch Number
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

SELECT	*
FROM
(
SELECT	CONVERT(DATETIME, @BeginDt-1, 102) as CurDate, Branch, ItemNo, BegQOH as QOH, 0 as RcptQty, 0 as IssQty, 0 as AdjQty, '' as DocNo, '' as ParentDocNo, '' as SourceID
FROM	AvgCst_DailyHist WITH (NOLOCK)
WHERE	(CurDate = CONVERT(DATETIME, @BeginDt, 102)) AND
	ItemNo = @ItemNo AND Branch = @Branch

Union

SELECT	RecDate as CurDate, Branch, ItemNo, 0 as QOH, QtyRec as RcptQty, 0 as IssQty, 0 as AdjQty, DocNo, ParentDocNo, SourceID
FROM	AvgCst_RecHist WITH (NOLOCK)
WHERE	(RecDate BETWEEN CONVERT(DATETIME, @BeginDt, 102) AND CONVERT(DATETIME, @EndDt, 102)) AND
	ItemNo = @ItemNo AND Branch = @Branch

Union

SELECT	IssDate as CurDate, Branch, ItemNo, 0 as QOH, 0 as RcptQty, QtyReq*-1 as IssQty, 0 as AdjQty, DocNo, '' as ParentDocNo, SourceID
FROM	AvgCst_DailyIssHist WITH (NOLOCK)
WHERE	(IssDate BETWEEN CONVERT(DATETIME, @BeginDt, 102) AND CONVERT(DATETIME, @EndDt, 102)) AND
	ItemNo = @ItemNo AND Branch = @Branch

Union

SELECT	AdjDate as CurDate, Branch, ItemNo, 0 as QOH, 0 as RcptQty, 0 as IssQty, Qty as AdjQty, DocNo, '' as ParentDocNo, SourceID
FROM	AvgCst_AdjHist WITH (NOLOCK)
Where	(AdjDate BETWEEN CONVERT(DATETIME, @BeginDt, 102) AND CONVERT(DATETIME, @EndDt, 102)) AND
	ItemNo = @ItemNo AND Branch = @Branch

Union

SELECT	CONVERT(DATETIME, @EndDt+1, 102) as CurDate, Branch, ItemNo, BegQOH as QOH, 0 as RcptQty, 0 as IssQty, 0 as AdjQty, '' as DocNo, '' as ParentDocNo, '' as SourceID
FROM	AvgCst_DailyHist WITH (NOLOCK)
WHERE	(CurDate = CONVERT(DATETIME, @EndDt, 102)) AND 
	ItemNo = @ItemNo AND Branch = @Branch
) tmp
Order by CurDate

END


GO
