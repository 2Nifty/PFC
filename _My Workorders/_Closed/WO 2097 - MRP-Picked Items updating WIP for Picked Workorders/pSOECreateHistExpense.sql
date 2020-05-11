drop procedure pSOECreateHistExpense
go


CREATE PROCEDURE [dbo].[pSOECreateHistExpense] 
	@username VARCHAR(50) = NULL,
	@orderID BIGINT = 0
AS
BEGIN
	-- =============================================
	-- Author:	Craig Parks
	-- Create date:	11/12/2008
	-- Parameters:	@orderID = Order ID of source Order SOHeader,
	--		@username  = Calling User Name,
	--		@orderID = Rel Expense fSOHeaderID and HistoryOrder Header Order No
	-- Description:	Create Expenses for Released Sales Orders
	-- Modified: 1/14/2009 CSP Add ExpenseDesc
	-- Modified: 10/21/10 TMD: Write to TOExpenseHist where SUBTYPE = 41 thru 49 [WO2097]
	-- =============================================

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@subType VARCHAR(2)
	SELECT @subType = SubType FROM SOHeaderRel WHERE OrderNo = @orderID

	-- See if the Released order is a Transfer or WorkOrder SubType
	IF (CONVERT(INT, @subtype) = 5 or (CONVERT(INT, @subtype) >= 41 and CONVERT(INT, @subtype) <= 49))
	   BEGIN	-- Insert into TOExpenseHist
		INSERT
		INTO	dbo.TOExpenseHist
			(fTOHeaderHistID, LineNumber, ExpenseNo, ExpenseCd, Amount, Cost, ExpenseInd,
			 TaxStatus, DeliveryCharge, HandlingCharge, PackagingCharge, MiscCharge, PhoneCharge,
			 DocumentLoc, DeleteDt, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd, ExpenseDesc)
		SELECT	SOHH.pTOHeaderHistID, LineNumber, ExpenseNo, ExpenseCd, Amount, Cost, ExpenseInd,
			TaxStatus, DeliveryCharge, HandlingCharge, PackagingCharge, MiscCharge, PhoneCharge,
			DocumentLoc, SOER.DeleteDt, @userName, SOER.EntryDt, SOER.ChangeID, SOER.ChangeDt, SOER.StatusCd, ExpenseDesc
		FROM	dbo.SOExpenseRel (NOLOCK) SOER,
			dbo.TOHeaderHist (NOLOCK) SOHH
		WHERE	SOER.fSOHeaderRelID = @orderID AND SOHH.OrderNo = @orderID AND SOER.DeleteDt IS NULL
	   END
	ELSE
	   BEGIN	-- Insert into SOExpenseHist
		INSERT
		INTO	dbo.SOExpenseHist
			(fSOHeaderHistID, LineNumber, ExpenseNo, ExpenseCd, Amount, Cost, ExpenseInd,
			 TaxStatus, DeliveryCharge, HandlingCharge, PackagingCharge, MiscCharge, PhoneCharge,
			 DocumentLoc, DeleteDt, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd, ExpenseDesc)
		SELECT	SOHH.pSOHeaderHistID, LineNumber, ExpenseNo, ExpenseCd, Amount, Cost, ExpenseInd,
			TaxStatus, DeliveryCharge, HandlingCharge, PackagingCharge, MiscCharge, PhoneCharge,
			DocumentLoc, SOER.DeleteDt, @userName, SOER.EntryDt, SOER.ChangeID, SOER.ChangeDt, SOER.StatusCd, ExpenseDesc
		FROM	dbo.SOExpenseRel (NOLOCK) SOER,
			dbo.SOHeaderHist (NOLOCK) SOHH
		WHERE	SOER.fSOHeaderRelID = @orderID AND SOHH.OrderNo = @orderID AND SOER.DeleteDt IS NULL
	   END
END






