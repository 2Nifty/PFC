USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pSOEProcessInvoices]    Script Date: 10/20/2010 17:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[pSOEProcessInvoices] 
AS
BEGIN
-- =============================================
-- Author:		Craig Parks
-- Create date: 12/15/2008
-- Description:	Create and Post Sales Invoices ( Demon Procedure
-- Parameters: None
-- Copy shipped orders to History invoices
-- Assign Invoice numbers
-- Extend Order Line items
-- sum invoices
-- Set Invoice date and Invoice Printed date
-- Post Customer Sales
-- Post Item Sales
-- Post GL Detail
-- Post AR Detail
-- Post IM Sales Transactions
-- Modified: 2/6/2009 Craig Parks Det InvoiceDt and InvoiceNo in SOHeaderRel as well as SOHeaderHist
-- Modified 2/11/2009 Craig Parks Delete any Soft Lock for orders flagged for invoice,
--    Don't Invoice an order if it is held
-- Modified: 3/25/2009 Craig Parks Post Customer Metrics when Invoice created
-- Modified: 8/6/2009 Craig Parks Post IM TransAQudit for 'SALE', 'TO', 'RGR'
-- Modified: 8/12/2009 Craig Parks Ship orders where location is marked ship Method ERP
-- Modified: 8/25/2009 Craig Parks Use NOLOCK where possible
-- ModifiedL 9/22/2009 Craig Parks Correct update of invoice from History to Rel
-- Modified: 10/1/2009 Craig parks See above (Transfers) and use pSOECreateCALPNInformation
--	For posting IMTransactionAudit and LPNAuditControl for pending Transfer receipt
-- Modified: 10/27/2009 Craig Parks Strip time from InvoiceDt, Skip InvoiceFlags if Already invoiced
-- Mofified: 11/3/2009 Update ARPostDt when Invoice is created, ReArrange post of AR
-- Modified: 11/5/2009 Craig Parks When QtyShipped NULL set to Qty Ordered
-- Modified: 12/16/2009 Craig Parks Don't invoice deleted orders
-- Modified: 12/22/2009 Craig Parks use loc hieaqrchy to ass Locmaster for credits ship,order,usage,'00'
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
UPDATE InvoiceFlags SET StatusCD = 'IP' FROM SOHeaderRel [SOHR] (NOLOCK)
WHERE InvoiceFlags.InvoiceDt IS NULL AND InvoiceFlags.OrderNo = [SOHR].OrderNo
AND [SOHR].HoldDt IS NULL
AND [SOHR].InvoiceNo IS NULL

-- Create History Headers for Orders flagged for Invoice
DECLARE INVF CURSOR FOR 
SELECT [IF].fSOHeaderID, [IF].OrderNo, [IF].InvoiceDt,[IF].StatusCd
FROM InvoiceFlags [IF] , SOHeaderRel [SOHR] (NOLOCK) WHERE [IF].InvoiceDt IS NULL
AND [IF].StatusCd ='IP'
AND [IF].OrderNo = [SOHR].OrderNo
and [SOHR].HoldDt is NULL
AND [SOHR].InvoiceNo IS NULL
AND [SOHR].DeleteDt IS NULL -- Skip deleted Sales Orders
FOR UPDATE of [IF].InvoiceDt, [IF].StatusCd
OPEN INVF
DECLARE @beginInv BIGINT,
@endingValue BIGINT,
@invCount BIGINT,
@endInv BIGINT,
@maxInt BIGINT,
@fSOHeaderID BIGINT,
@OrderNo BIGINT,
@invoiceDt DATETIME,
@statusCD CHAR(2),
@lockedBy VARCHAR(50)
DECLARE 
@IMTrans VARCHAR(5),
@retVal INT

FETCH NEXT FROM INVF INTO @fSOHeaderID, @OrderNo, @invoiceDt, @statusCd
-- GET Invoice Odometer and set correct beginning invoice value
WHILE (@@FETCH_STATUS = 0) BEGIN
SELECT @maxInt = POWER(2.0,31) - 1
DECLARE @procret int
DELETE FROM SoftLockStats WHERE TableRowItem='SOHeaderRel' AND TypeofRowItem = @fSOHeaderID
EXEC @procret = dbo.pSoftLock @resource = 'SOHeaderRel' ,
@function = 'Lock', @key = @fSOHeaderID,
@uid = 'CreateInvoice',
@curApplication = 'SOEInvoice'
SET @lockedBy = (SELECT EntryID FROM SoftLockStats WHERE
TableRowItem='SOHeaderRel' AND TypeofRowItem = @fSOHeaderID)
DECLARE @shipMethCd VARCHAR(4),
@subType VARCHAR(2)
SELECT @shipMethCd=ISNULL(ShipMethCd,''), @subType=SubType from LocMaster (NOLOCK),
SOHeaderRel (NOLOCK) WHERE OrderNo = @OrderNo and LocID = ISNULL(ShipLoc,ISNULL(OrderLoc,ISNULL(UsageLoc,'00')))
IF (@ShipMethCd = 'ERP') AND (CONVERT(INT,@subtype) <= 50) EXEC pSOECreateCAforERPOrder @orderNo = @OrderNo -- Ship Ship Method ERP orders
IF @lockedBy = 'CreateInvoice' BEGIN --Process Invoice if Lock Successful
	-- Update Current Avg Cost and reextend line with Qty Shipped
	UPDATE SODetailRel SET UnitCost = BegAC,QtyShipped = CASE WHEN QtyShipped IS NULL
	THEN QtyOrdered ELSE QtyShipped END FROM
	PFCAC.dbo.AvgCst_Daily (NOLOCK) ACD, SOHeaderRel (NOLOCK)
	WHERE fSOHeaderrelID = pSOHeaderRelID and OrderNo = @fSOHeaderID
	AND IMLoc = ACD.Branch
	AND SODetailRel.ItemNo = ACD.ItemNo
	-- Re-Extend the Order Lines and reset the Header Totals
	DECLARE @pSOHeaderRelID BIGINT
	SELECT @pSOHeaderRelID =  pSOHeaderRelID FROM SOHeaderRel (NOLOCK)
	WHERE OrderNo = @fSOHeaderID
-- reextend the order before invoice
	EXEC pSOERecomputePrice @orderID = @pSOHeaderRelID
	EXEC pSOEExt @OrderID = @pSOHeaderRelID, @line = 0, @type = 'ORDER', @table = 'Rel' 

	EXEC dbo.pSOECreateHistOrdHeader @userName='CreateInvoice', @orderID = @fSOHeaderID
	-- Create History Detail for Order Flagged for invoice
	EXEC dbo.pSOECreateHistOrdDetail @userName='CreateInvoice', @orderID = @fSOHeaderID
	-- Create Expenses for Order Flagged for invoicing
	EXEC dbo.pSOECreateHistExpense @userName='CreateInvoice', @orderID = @fSOHeaderID
	-- Create Comments for Orders Flagged for Invoicing
	EXEC dbo.pSOECreateHistComments @userName='CreateInvoice', @orderID = @fSOHeaderID
	-- Assign Invoice Numbers
	IF (CONVERT(INT,@subtype) <>5) BEGIN -- Don't assign and invoice number to Transfers sub-type 5
		SELECT @beginInv = BeginValue, @endingValue = EndingValue
		FROM dbo.Odometer (NOLOCK) WHERE OdomName = 'INVOICE'
		-- Establish the selection of Invoices to process
		-- Establish the Invoice Count
		SET @invCount = 1 
		-- Check for Odometer wrap and reset as necessary
		SET @endInv = @beginInv + @invCount
		IF @endingValue IS NOT NULL
		  IF @endingvalue >= @endInv BEGIN
			SET @BeginInv = 0
			SET @endInv = @beginInv + @invCount
		  END
		ELSE IF @endingValue > @maxInt BEGIN
		  SET @beginInv = 0
		  SET @endInv = @beginInv + @invCount
		END;
		-- Set the invoice number using the beginning odometer and the row number in the inv selection
	-- UPDATE InvoiceNo and InvoiceDt in SOHeaderRel
		UPDATE SOHeaderHist SET InvoiceNo = (@beginInv + 1), InvoiceDt = dbo.fStripDate(GetDate()),
		ARPostDt = dbo.fStripDate(GetDate()) WHERE
		OrderNo = @fSOHeaderID
		-- Set the Invoice Odometer for subsequent use
		UPDATE dbo.Odometer SET BeginValue = @endInv WHERE OdomName = 'INVOICE'
		UPDATE SOHeaderRel SET SOHeaderRel.InvoiceNo = SOHH.InvoiceNo, SOHeaderRel.InvoiceDT = SOHH.InvoiceDt
		FROM SOHeaderHist SOHH WHERE SOHeaderRel.OrderNo = SOHH.OrderNo AND
		SOHeaderRel.OrderNo = @OrderNo
		-- CustomerMetrics
		DECLARE @pSOHeaderHistID BIGINT
		SELECT @pSOHeaderHistID =  pSOHeaderHistID FROM SOHeaderHist (NOLOCK)
		WHERE OrderNo = @fSOHeaderID

		EXEC [dbo].[pSOEProcessCustomerMetrics]
			@orderID = @pSOHeaderHistID, 
			@lineNo = 0,
			@table  = 'SOHeaderHist'

	END  -- Don't assign an invoice number to Transfers sub type 5
	ELSE BEGIN -- Process the subtype 5 Update Transfer Order History
		UPDATE TOHeaderHist SET InvoiceDt = dbo.fStripDate(GetDate())
		WHERE OrderNo = @orderNo
	-- UPDATE InvoiceDt in SOHeaderRel
		UPDATE SOHeaderRel SET SOHeaderRel.InvoiceDT = SOHH.InvoiceDt
		FROM TOHeaderHist SOHH WHERE SOHeaderRel.OrderNo = SOHH.OrderNo 
		AND SOHeaderRel.OrderNo = @OrderNo

	END -- Update TOHeaderHist
-- show the Invoiceflags row is processed
	UPDATE InvoiceFlags SET InvoiceDt = GetDate() WHERE CURRENT of INVF

-- WRITE IMTransaction Audit
SET @IMTrans = 'SALE'
IF (CONVERT(INT,@subtype) = 5) SET @IMTrans = 'TO'
IF (CONVERT(INT,@subtype) = 53) SET @IMTrans = 'RGR'
IF (CONVERT(INT,@subtype) < 51) 
IF (CONVERT(INT,@subtype) < 51) -- Write IMTransactionAudit for orders that affect Inventory
	EXEC @retVal=pUTCreateIMTransAudit @trans = @IMTrans, @srcTable = 'SOHeaderRel', @DocNo = @fSOHeaderID
-- Release the Released Order Soft Lock
	EXEC @procret = dbo.pSoftLock @resource = 'SOHeaderRel' ,
	@function = 'Release', @key = @fSOHeaderID,
	@uid = 'CreateInvoice',
	@curApplication = 'SOEInvoice'

END -- Lock Successful Invoice Processed
FETCH NEXT FROM INVF INTO @fSOHeaderID, @OrderNo, @InvoiceDt, @statusCd
END -- FETCH Loop
CLOSE INVF
DEALLOCATE INVF
-- Accounts Receivable Activity
DECLARE @begInvDt DATETIME,
@endInvDt DATETIME
SET @begInvDT = (SELECT MIN(InvoiceDt) FROM InvoiceFlags (NOLOCK) WHERE StatusCD = 'IP')
SET @endInvDt = (SELECT MAX(InvoiceDt) FROM InvoiceFlags (NOLOCK) WHERE StatusCD = 'IP')
EXEC [dbo].[pSOEProcessARActivity]
@begDt = @begInvDT,
@endDt = @endInvDt,
@userName = '[pSOEProcessInvoicesAR]'
-- General Ledger Detail
EXEC [dbo].[pSOEProcessGLDetail]
@begDt = @begInvDT,
@endDt = @endInvDt,
@userName = '[pSOEProcessInvoicesGL]'

-- Post statistical and interface tables
-- Item Branch Usage
EXEC [dbo].[pSOEProcessItemBranchUsage] 
@begDt = @begInvDT,
@endDt = @endInvDt,
@type = 'SALE',
@userName = '[pSOEProcessInvoicesItmUse]'
-- Customer Sales Summary
SET @begInvDT = (SELECT MIN(InvoiceDt) FROM InvoiceFlags (NOLOCK) WHERE StatusCD = 'IP')
SET @endInvDt = (SELECT MAX(InvoiceDt) FROM InvoiceFlags (NOLOCK) WHERE StatusCD = 'IP')
EXEC [dbo].[pSOEProcessCustSlsSumm] 
@begDt = @begInvDT,
@endDt = @endInvDt,
@userName = '[pSOEProcessInvoicesCustSls]'

-- Set Invoice Posted in Flags table
UPDATE InvoiceFlags SET InvoicePostedDt = dbo.fStripDate(GetDate()),
StatusCd = NULL WHERE InvoiceDt IS NOT NULL
AND InvoicePostedDT IS NULL
AND StatusCd = 'IP'
UPDATE InvoiceFlags SET InvoicePostedDt = dbo.fStripDate(GetDate()),
InvoiceDt=GETDATE(),
StatusCd = NULL WHERE EXISTS (SELECT 1 FROM SOHEADERRel SOHR (NOLOCK) where 
SOHR.OrderNo = InvoiceFlags.OrderNo and InvoiceNo IS NOT NULL) 
AND StatusCd = 'IP'

--
END


















