USE [PERP]
GO

drop proc [pSOEProcessInvoices]
go

/****** Object:  StoredProcedure [dbo].[pSOEProcessInvoices]    Script Date: 01/05/2012 16:51:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pSOEProcessInvoices] 
AS
BEGIN
	-- =============================================
	-- Mod: 02/06/2009 Craig Parks:	Set InvoiceDt and InvoiceNo in SOHeaderRel & SOHeaderHist
	-- Mod: 02/11/2009 Craig Parks:	- Delete Soft Locks for orders flagged for invoice
	--				- Don't Invoice any held order
	-- Mod: 03/25/2009 Craig Parks:	Post Customer Metrics when Invoice created
	-- Mod: 08/06/2009 Craig Parks:	Post IM TransAQudit for 'SALE', 'TO', 'RGR'
	-- Mod: 08/12/2009 Craig Parks:	Ship orders where location is marked Ship Method ERP
	-- Mod: 08/25/2009 Craig Parks:	Add NOLOCK where possible
	-- Mod: 09/22/2009 Craig Parks:	Correct update of invoice from History to Rel
	-- Mod: 10/01/2009 Craig parks:	- Correct update of Transfers
	--				- Use pSOECreateCALPNInformation to post IMTransactionAudit and LPNAuditControl
	--				  for pending Transfer receipt
	-- Mod: 10/27/2009 Craig Parks:	- Strip time from InvoiceDt
	--				- Skip InvoiceFlags if already invoiced
	-- Mod: 11/03/2009 Craig Parks:	Update ARPostDt when Invoice is created, Rearrange post of AR
	-- Mod: 11/05/2009 Craig Parks:	When QtyShipped NULL set to QtyOrdered
	-- Mod: 12/16/2009 Craig Parks:	Don't invoice deleted orders
	-- Mod: 12/22/2009 Craig Parks:	Use loc hieaqrchy to assign Locmaster for credits ship,order,usage,'00'
	-- Mod: 04/27/2010 Craig Parks:	Write Receipt transactions for RGA receipts
	--	
	-- Mod: 07/22/2010 CSR: Remove ERP Ship Method to create CA records [WO1989]
	-- Mod: 09/13/2010 CSR: Change to use ItemBranch Unit Cost from ACD [WO2028]
	-- Mod: 10/20/2010 TMD: Added WO processing where SUBTYPE = 41 thru 49 [WO2097]
	-- Mod: 10/28/2011 CSR: Delete related Released Sales Order from CustomerMetrics table [WO2637]
	-- Mod:	01/09/2012 TMD:	Set CustomerMetrics.DeleteDt instead of deleting the record
	-- =============================================

	-- EXEC [pSOEProcessInvoices]


	UPDATE	InvoiceFlags
	SET		StatusCD = 'IP'
	FROM	SOHeaderRel [SOHR] (NOLOCK)
	WHERE	InvoiceFlags.InvoiceDt IS NULL
			AND InvoiceFlags.OrderNo = [SOHR].OrderNo
			AND [SOHR].HoldDt IS NULL
			AND [SOHR].InvoiceNo IS NULL

	SET NOCOUNT ON;

	-- Create History Headers for Orders flagged for Invoice
	DECLARE	INVF CURSOR FOR 
	SELECT	[IF].fSOHeaderID, [IF].OrderNo, [IF].InvoiceDt,[IF].StatusCd
	FROM	InvoiceFlags [IF] , SOHeaderRel [SOHR] (NOLOCK)
	WHERE	[IF].InvoiceDt IS NULL
			AND [IF].StatusCd ='IP'
			AND [IF].OrderNo = [SOHR].OrderNo
			AND [SOHR].HoldDt is NULL
			AND [SOHR].InvoiceNo IS NULL
			AND [SOHR].DeleteDt IS NULL -- Skip deleted Sales Orders
	FOR UPDATE of [IF].InvoiceDt, [IF].StatusCd

	OPEN INVF
	DECLARE	@beginInv BIGINT,
			@endingValue BIGINT,
			@invCount BIGINT,
			@endInv BIGINT,
			@maxInt BIGINT,
			@fSOHeaderID BIGINT,
			@OrderNo BIGINT,
			@invoiceDt DATETIME,
			@statusCD CHAR(2),
			@lockedBy VARCHAR(50),
			@IMTrans VARCHAR(5),
			@retVal INT

	-- GET Invoice Odometer and set correct beginning invoice value
	FETCH NEXT FROM INVF INTO @fSOHeaderID, @OrderNo, @invoiceDt, @statusCd
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SELECT	@maxInt = POWER(2.0,31) - 1
			DECLARE	@procret int
			DELETE 
			FROM	SoftLockStats	
			WHERE	TableRowItem='SOHeaderRel' 
					AND TypeofRowItem = @fSOHeaderID

			EXEC	@procret = dbo.pSoftLock @resource = 'SOHeaderRel' ,
					@function = 'Lock', @key = @fSOHeaderID,
					@uid = 'CreateInvoice',
					@curApplication = 'SOEInvoice'

			SET		@lockedBy = (SELECT EntryID
								FROM SoftLockStats
								WHERE TableRowItem='SOHeaderRel' 
								AND TypeofRowItem = @fSOHeaderID)

			DECLARE @shipMethCd VARCHAR(4),
					@subType VARCHAR(2)

			SELECT	@shipMethCd = ISNULL(ShipMethCd,''), @subType=SubType
			FROM	LocMaster (NOLOCK),	SOHeaderRel (NOLOCK)
			WHERE	OrderNo = @OrderNo 
					and LocID = ISNULL(ShipLoc,ISNULL(OrderLoc,ISNULL(UsageLoc,'00')))

			--CSR 07/22/10: Removed per WO1989
			--IF (@ShipMethCd = 'ERP') AND (CONVERT(INT,@subtype) <= 50) EXEC pSOECreateCAforERPOrder @orderNo = @OrderNo -- Ship Ship Method ERP orders

			-- Process Invoice if Lock Successful
			IF @lockedBy = 'CreateInvoice'
				BEGIN
					-- Update Current Avg Cost and reextend line with Qty Shipped
					UPDATE	SODetailRel 
					SET		SODetailRel.UnitCost = ItemBranch.UnitCost
							,QtyShipped = CASE WHEN QtyShipped IS NULL THEN QtyOrdered ELSE QtyShipped END 
					FROM	ItemMaster (NOLOCK), ItemBranch (NOLOCK), SOHeaderRel (NOLOCK)
					WHERE	fSOHeaderrelID = pSOHeaderRelID 
							AND OrderNo = @fSOHeaderID
							AND SODetailRel.ItemNo = ItemMaster.ItemNo
							AND ItemMaster.pItemMasterID = ItemBranch.fItemMasterID
							AND ItemBranch.Location = SODetailRel.IMLoc

					--  CSR 09/13/10: removed per WO2028
					--	OpenDataSource('SQLOLEDB','Data Source=PFCerpdb;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_Daily] ACD,
					--	PFCAC.dbo.AvgCst_Daily (NOLOCK) ACD, 

					-- Re-Extend the Order Lines and reset the Header Totals
					DECLARE	@pSOHeaderRelID BIGINT
					SELECT	@pSOHeaderRelID = pSOHeaderRelID
					FROM	SOHeaderRel (NOLOCK)
					WHERE	OrderNo = @fSOHeaderID
					-- Re-Extend the order before invoice
					EXEC	pSOERecomputePrice @orderID = @pSOHeaderRelID
					EXEC	pSOEExt @OrderID = @pSOHeaderRelID, @line = 0, @type = 'ORDER', @table = 'Rel' 
					-- Create History Header for Order Flagged for invoice
					EXEC dbo.pSOECreateHistOrdHeader @userName='CreateInvoice', @orderID = @fSOHeaderID
					-- Create History Detail for Order Flagged for invoice
					EXEC dbo.pSOECreateHistOrdDetail @userName='CreateInvoice', @orderID = @fSOHeaderID
					-- Create Expenses for Order Flagged for invoicing
					EXEC dbo.pSOECreateHistExpense @userName='CreateInvoice', @orderID = @fSOHeaderID
					-- Create Comments for Orders Flagged for Invoicing
					EXEC dbo.pSOECreateHistComments @userName='CreateInvoice', @orderID = @fSOHeaderID
					-- Process Transfers & WorkOrders
					IF (CONVERT(INT,@subtype) = 5 or (CONVERT(INT,@subtype) >= 41 and CONVERT(INT,@subtype) <= 49))
						BEGIN
							-- Add CA WIP records to the DNLOAD table for WorkOrder SubTypes only
							IF (CONVERT(INT,@subtype) >= 46 and CONVERT(INT,@subtype) <= 49)
								BEGIN
								-- Process the CA records for Picked WorkOrder sales lines that are invoiced
									EXEC pSOEProcessWOInvoice @orderNo = @fSOHeaderID
								END
							-- UPDATE InvoiceDt in TOHeaderHist
							UPDATE	TOHeaderHist
							SET		InvoiceDt = dbo.fStripDate(GetDate())
							WHERE	OrderNo = @orderNo
							-- UPDATE InvoiceDt in SOHeaderRel
							UPDATE	SOHeaderRel
							SET		SOHeaderRel.InvoiceDT = SOHH.InvoiceDt
							FROM	TOHeaderHist SOHH
							WHERE	SOHeaderRel.OrderNo = SOHH.OrderNo 
									AND SOHeaderRel.OrderNo = @OrderNo

							IF (CONVERT(INT,@subtype) >= 41 and CONVERT(INT,@subtype) <= 49)
								BEGIN
									-- UPDATE WipDt in POHeader
									UPDATE	POHeader
									SET		POHeader.WipDt = SOHR.InvoiceDt
									FROM	SOHeaderRel SOHR
									WHERE	SOHR.OrderNo = @OrderNo
											AND POHeader.POOrderNo = SOHR.CustPONo
								END
						END
					ELSE
						-- Process Non-Transfers & Non-WorkOrders (Assign Invoice Numbers)
						BEGIN
							SELECT	@beginInv = BeginValue, @endingValue = EndingValue
							FROM	dbo.Odometer (NOLOCK)
							WHERE	OdomName = 'INVOICE'
							-- Establish the selection of Invoices to process
							-- Establish the Invoice Count
							SET @invCount = 1 
							-- Check for Odometer wrap and reset as necessary
							SET @endInv = @beginInv + @invCount
							IF	@endingValue IS NOT NULL
							IF	@endingvalue >= @endInv
								BEGIN
									SET	@BeginInv = 0
									SET @endInv = @beginInv + @invCount
			   					END
			   				ELSE IF @endingValue > @maxInt
								BEGIN
									SET @beginInv = 0
									SET @endInv = @beginInv + @invCount
								END;
							-- Set the invoice number using the beginning odometer and the row number in the inv selection
							-- UPDATE InvoiceNo and InvoiceDt in SOHeaderRel
							UPDATE	SOHeaderHist
							SET		InvoiceNo = (@beginInv + 1)
									,InvoiceDt = dbo.fStripDate(GetDate())
									,ARPostDt = dbo.fStripDate(GetDate())
							WHERE	OrderNo = @fSOHeaderID
							-- Set the Invoice Odometer for subsequent use
							UPDATE	dbo.Odometer
							SET		BeginValue = @endInv
							WHERE	OdomName = 'INVOICE'
							-- UPDATE InvoiceNo & InvoiceDt in SOHeaderRel
							UPDATE	SOHeaderRel
							SET		SOHeaderRel.InvoiceNo = SOHH.InvoiceNo
									,SOHeaderRel.InvoiceDT = SOHH.InvoiceDt
							FROM	SOHeaderHist SOHH
							WHERE	SOHeaderRel.OrderNo = SOHH.OrderNo
									AND SOHeaderRel.OrderNo = @OrderNo
							-- CustomerMetrics
							DECLARE	@pSOHeaderHistID BIGINT
							SELECT	@pSOHeaderHistID = pSOHeaderHistID
							FROM	SOHeaderHist (NOLOCK)
							WHERE	OrderNo = @fSOHeaderID
							EXEC [dbo].[pSOEProcessCustomerMetrics] @orderID = @pSOHeaderHistID, @lineNo = 0, @table  = 'SOHeaderHist'

							-- WO2637 Delete related Released Sales Order from CustomerMetrics table
							-- WO2712 SET DeleteDt instead of deleting the record
							--DELETE 
							--FROM	CustomerMetrics 
							--WHERE	OrderNo = @fSOHeaderID AND MetricType ='SO'
							UPDATE	CustomerMetrics
							SET		DeleteDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
							WHERE	OrderNo = @fSOHeaderID AND MetricType ='SO'

						END
					-- Set the InvoiceFlags row as processed
					UPDATE InvoiceFlags SET InvoiceDt = GetDate() WHERE CURRENT of INVF
					-- WRITE IMTransaction Audit for Non-WorkOrder SubTypes
					IF (CONVERT(INT,@subtype) < 41 or CONVERT(INT,@subtype) > 49)
						BEGIN
							SET	@IMTrans = 'SALE'
							IF (CONVERT(INT,@subtype) = 5) 
								SET @IMTrans = 'TO'
							IF (CONVERT(INT,@subtype) = 53) 
								SET @IMTrans = 'RGR'
							-- Write IMTransactionAudit for orders that affect Inventory
							IF (CONVERT(INT,@subtype) <= 53)
								EXEC @retVal=pUTCreateIMTransAudit @trans = @IMTrans, @srcTable = 'SOHeaderRel', @DocNo = @fSOHeaderID
						END
					-- Release the Released Order Soft Lock
					EXEC	@procret = dbo.pSoftLock 
							@resource = 'SOHeaderRel',
							@function = 'Release',
							@key = @fSOHeaderID,
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

	SET	@begInvDT = (SELECT MIN(InvoiceDt) FROM InvoiceFlags (NOLOCK) WHERE StatusCD = 'IP')
	SET @endInvDt = (SELECT MAX(InvoiceDt) FROM InvoiceFlags (NOLOCK) WHERE StatusCD = 'IP')

	EXEC [dbo].[pSOEProcessARActivity]	@begDt = @begInvDT,
										@endDt = @endInvDt,
										@userName = '[pSOEProcessInvoicesAR]'
	-- General Ledger Detail
	EXEC [dbo].[pSOEProcessGLDetail]	@begDt = @begInvDT,
										@endDt = @endInvDt,
										@userName = '[pSOEProcessInvoicesGL]'

	-- Post statistical and interface tables
	-- Item Branch Usage
	EXEC [dbo].[pSOEProcessItemBranchUsage] @begDt = @begInvDT,
											@endDt = @endInvDt,
											@type = 'SALE',
											@userName = '[pSOEProcessInvoicesItmUse]'

	-- Customer Sales Summary
	SET @begInvDT = (SELECT MIN(InvoiceDt) FROM InvoiceFlags (NOLOCK) WHERE StatusCD = 'IP')
	SET @endInvDt = (SELECT MAX(InvoiceDt) FROM InvoiceFlags (NOLOCK) WHERE StatusCD = 'IP')

	EXEC [dbo].[pSOEProcessCustSlsSumm] @begDt = @begInvDT,
										@endDt = @endInvDt,
										@userName = '[pSOEProcessInvoicesCustSls]'

	-- Set Invoice Posted in Flags table
	UPDATE	InvoiceFlags
	SET		InvoicePostedDt = dbo.fStripDate(GetDate()), StatusCd = NULL
	WHERE	InvoiceDt IS NOT NULL
			AND InvoicePostedDT IS NULL
			AND StatusCd = 'IP'

	UPDATE	InvoiceFlags
	SET		InvoicePostedDt = dbo.fStripDate(GetDate())
			,InvoiceDt=GETDATE()
			,StatusCd = NULL
	WHERE	EXISTS 
			(SELECT 1 
			FROM SOHeaderRel SOHR (NOLOCK) 
			WHERE SOHR.OrderNo = InvoiceFlags.OrderNo 
			AND InvoiceNo IS NOT NULL) 
			AND StatusCd = 'IP'
END

