
drop proc [pSOEProcessCustomerMetrics]
go

/****** Object:  StoredProcedure [dbo].[pSOEProcessCustomerMetrics]    Script Date: 01/05/2012 16:50:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pSOEProcessCustomerMetrics] 
	@orderID BIGINT = 0, 
	@lineNo int = 0,
	@table VARCHAR(50) = 'SOHeaderRel'

AS
BEGIN

	-- ======================================================================
	-- Created:	Craig Parks
	-- Date:	01/27/2009
	-- Desc:	Create Update Customer Metrics on order completion
	-- Params:	@orderID= order or qupote ID for update
	--			@lineNo	= 0 all not deleted order lines, # a specific line number
	--			@table	= dataset for update / insert  of CustomerMetrics
	-- ======================================================================
	-- Mod:	01/28/2009 Craig Parks:	Process Invoices
	-- Mod:	01/29/2009 Craig Parks:	Process Rep Quotes
	-- Mod:	02/03/2009 Craig Parks:	Process Web Quotes
	-- Mod:	03/25/2009 Craig Parks:	Process SO and IV SubType '50 and Below
	-- Mod:	06/01/2009 Craig Parks:	Correct Update Insert statement for RepQuote and WebQuote
	-- Mod: 12/07/2009 Craig Parks:	Insure all column references are qualified when using multi tables
	--
	-- Mod: 01/09/2012 TMD:	Reformat Craig Parks code
	-- ======================================================================

	SET NOCOUNT ON;

	DECLARE	@custNo VARCHAR(10),
			@wkLineNo INT,
			@UPDINS CHAR(2),		-- UPDATE or INSERT Ctl
			@orderLoc VARCHAR(10),
			@shipLoc VARCHAR(10),
			@subType VARCHAR(10)


	--SOHeaderRel - Released Orders (REL)
	IF @table = 'SOHeaderRel' 
		BEGIN	-- Begin SOHeaderRel

			SELECT	@custNo = SellToCustNo, @orderLoc =  OrderLoc, @shipLoc = ShipLoc, @subType = SubType
			FROM	SOHeaderRel (NOLOCK)
			WHERE	pSOHeaderRelID = @orderID

			IF @subType <= '50'
				BEGIN	-- SubType less than or equal '50' (REL)

					IF @lineNo <> 0
						BEGIN	-- Process 1 line Item (REL)
							SET @UPDINS = 'I' -- Default to Insert
							SET @wkLineNo = @lineNo
							
							-- Determine if a row already exists for the Customer Item No dataset combination
							SELECT	@UPDINS = 'U'
							WHERE	EXISTS (SELECT	1 
											FROM	CustomerMetrics (NOLOCK) CM, SODetailRel (NOLOCK) SD
											WHERE	CM.CustNo = @custNo AND CM.ItemNo = SD.ItemNo  AND CM.MetricType = 'SO'
													AND SD.fSOHeaderRelID = @orderID AND SD.LineNumber = @wkLineNo)

							EXEC pSOEProcessCustomerMetricsLineNo	-- Process the Line item
									@orderID = @orderID, 
									@lineNo = @wkLineNo,
									@UPDINS = @UPDINS,
									@table = @table,
									@metricType = 'SO',
									@entryID = 'pSOEProcessCustomerMetrics',
									@custNo = @custNo,
									@orderLoc = @orderLoc,
									@shipLoc = @shipLoc
						END		-- Process 1 Line Item (REL)
					ELSE
						BEGIN	-- Process All Line Items (REL)

							-- Declare a cursor to get line numbers for the order that are not deleted
							DECLARE	SOLines CURSOR FOR
							SELECT	SD.LineNumber
							FROM	SODetailRel SD (NOLOCK)
							WHERE	SD.fSOHeaderRelID = @orderID AND SD.DeleteDt IS NULL
							ORDER BY SD.Linenumber

							OPEN SOLines
							FETCH NEXT FROM SOLines INTO @wkLineNo	-- Get the first order line to process
							WHILE @@FETCH_Status = 0
								BEGIN	-- Loop to process each line (REL)
									SET @UPDINS = 'I'
									-- Determine if a row already exists for the Customer Item No dataset combination
									SELECT	@UPDINS = 'U'
									WHERE	EXISTS (SELECT	1 
													FROM	CustomerMetrics (NOLOCK) CM, SODetailRel (NOLOCK) SD
													WHERE	CM.CustNo = @custNo AND CM.ItemNo = SD.ItemNo  AND CM.MetricType = 'SO'
															AND SD.fSOHeaderRelID = @orderID AND SD.LineNumber = @wkLineNo)

									EXEC pSOEProcessCustomerMetricsLineNo	-- Process the Line item
											@orderID = @orderID, 
											@lineNo = @wkLineNo,
											@UPDINS = @UPDINS,
											@table = @table,
											@metricType = 'SO',
											@entryID = 'pSOEProcessCustomerMetrics',
											@custNo = @custNo,
											@orderLoc = @orderLoc,
											@shipLoc = @shipLoc

									FETCH NEXT FROM SOLines INTO @wkLineNo	-- Get the next order line to process
								END	-- Loop to process each line (REL)
							CLOSE SOLines
							DEALLOCATE SOLines
						END	-- Process All Line Items (REL)
				END	-- SubType less than or equal '50' (REL)
		END	-- End SOHeaderRel

	ELSE

	--SOHeaderHist - Invoices (HIST)
	IF @table = 'SOHeaderHist'
		BEGIN	-- Begin SOHeaderHist

			SELECT	@custNo = SellToCustNo, @orderLoc =  OrderLoc, @shipLoc = ShipLoc, @subType = SubType
			FROM	SOHeaderHist (NOLOCK)
			WHERE	pSOHeaderHistID = @orderID

			IF (@subType <= '50')
				BEGIN	-- SubType less than or equal '50' (HIST)

					IF @lineNo <> 0
						BEGIN	-- Process 1 line Item (HIST)
							SET @UPDINS = 'I' -- Default to Insert
							SET @wkLineNo = @lineNo
							
							-- Determine if a row already exists for the Customer Item No dataset combination
							SELECT	@UPDINS = 'U'
							WHERE	EXISTS (SELECT	1 
											FROM	CustomerMetrics (NOLOCK) CM, SODetailHist (NOLOCK) SD
											WHERE	CM.CustNo = @custNo AND CM.ItemNo = SD.ItemNo  AND CM.MetricType = 'IV'
													AND SD.fSOHeaderHistID = @orderID AND SD.LineNumber = @wkLineNo)

							EXEC pSOEProcessCustomerMetricsLineNo	-- Process the Line item
									@orderID = @orderID, 
									@lineNo = @wkLineNo,
									@UPDINS = @UPDINS,
									@table = @table,
									@metricType = 'IV',
									@entryID = 'pSOEProcessCustomerMetrics',
									@custNo = @custNo,
									@orderLoc = @orderLoc,
									@shipLoc = @shipLoc
						END	-- Process 1 Line Item (HIST)

				ELSE
					BEGIN	-- Process All Lines (HIST)

						-- Declare a cursor to get line numbers for the order that are not deleted
						DECLARE	SOLines CURSOR FOR
						SELECT	SD.LineNumber
						FROM	SODetailHist SD (NOLOCK)
						WHERE	SD.fSOHeaderHistID = @orderID AND SD.DeleteDt IS NULL
						ORDER BY SD.Linenumber

						OPEN SOLines
						FETCH NEXT FROM SOLines INTO @wkLineNo	-- Get the first order line to process
						WHILE @@FETCH_Status = 0
							BEGIN	-- Loop to process each line (HIST)
								SET @UPDINS = 'I'
								-- Determine if a row already exists for the Customer Item No dataset combination
								SELECT	@UPDINS = 'U'
								WHERE	EXISTS (SELECT	1 
												FROM	CustomerMetrics (NOLOCK) CM, SODetailHist (NOLOCK) SD
												WHERE	CM.CustNo = @custNo AND CM.ItemNo = SD.ItemNo  AND CM.MetricType = 'IV'
														AND SD.fSOHeaderHistID = @orderID AND SD.LineNumber = @wkLineNo)

								EXEC pSOEProcessCustomerMetricsLineNo	-- Process the Line item
										@orderID = @orderID, 
										@lineNo = @wkLineNo,
										@UPDINS = @UPDINS,
										@table = @table,
										@metricType = 'IV',
										@entryID = 'pSOEProcessCustomerMetrics',
										@custNo = @custNo,
										@orderLoc = @orderLoc,
										@shipLoc = @shipLoc

								FETCH NEXT FROM SOLines INTO @wkLineNo	-- Get the next order line to process
							END	-- Loop to process each line (HIST)
						CLOSE SOLines
						DEALLOCATE SOLines
					END	-- Process All Line Items (HIST)
			END	-- SubType less than or equal '50' (HIST)
		END	-- End SOHeaderHist

	ELSE

	--RepQuote - Internal Quote
	IF @table = 'RepQuote'
		BEGIN	-- Begin RepQuote

			SELECT	@custNo = CustomerNumber, @shipLoc =  LocationCode, @orderLoc = ISNULL(SalesLocationCode,LocationCode)
			FROM	DTQ_CustomerQuotation (NOLOCK)
			WHERE	ID = @orderID

			SET	@UPDINS = 'I'	-- Default to Insert
			SET @wkLineNo = 0	-- Not used for Quotes

			-- Determine if a row already exists for the Customer Item No dataset combination
			SELECT	@UPDINS = 'U'
			WHERE	EXISTS (SELECT	1
							FROM	CustomerMetrics (NOLOCK) CM, DTQ_CustomerQuotation (NOLOCK) SD
							WHERE	CM.CustNo = @custNo AND SD.ID = @orderID AND CM.MetricType = 'RQ'
									AND CM.ItemNo = SD.PFCItemNo COLLATE SQL_Latin1_General_CP1_CI_AS)

			EXEC pSOEProcessCustomerMetricsLineNo	-- Process the Line item
					@orderID = @orderID, 
					@lineNo = @wkLineNo,
					@UPDINS = @UPDINS,
					@table = @table,
					@metricType = 'RQ',
					@entryID = 'pSOEProcessCustomerMetrics',
					@custNo = @custNo,
					@orderLoc = @orderLoc,
					@shipLoc = @shipLoc
		END	-- End RepQuote

	ELSE

	--WebQuote - PFCDirect, Web, SDK, InxSQL
	IF @table = 'WebQuote'
		BEGIN	-- Begin WebQuote

			--PRINT 'Processing In WebQuote' + cast(@orderID as VARCHAR)

			SELECT	@custNo = CustNo, @shipLoc = ShipFromLocation , @orderLoc = ISNULL(EntryLocation,ShipFromLocation)
			FROM	WebActivityPosting (NOLOCK)
			WHERE	QuoteRowID = @orderID

			SET	@UPDINS = 'I'	-- Default to Insert
			SET @wkLineNo = 0	-- Not used for Quotes

			-- Determine if a row already exists for the Customer Item No dataset combination
			SELECT	@UPDINS = 'U'
			WHERE	EXISTS (SELECT	1
							FROM	CustomerMetrics (NOLOCK) CM, WebActivityPosting (NOLOCK) WAP
							WHERE	CM.CustNo = @custNo AND QuoteRowID = @orderID AND CM.MetricType = 'WQ'
									AND CM.ItemNo = WAP.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS)

							EXEC pSOEProcessCustomerMetricsLineNo -- Process the Line item
									@orderID = @orderID, 
									@lineNo = @wkLineNo,
									@UPDINS = @UPDINS,
									@table = @table,
									@metricType = 'WQ',
									@entryID = 'pSOEProcessCustomerMetrics',
									@custNo = @custNo,
									@orderLoc = @orderLoc,
									@shipLoc = @shipLoc
		END	-- End WebQuote

	RETURN(0)	-- return to caller
END	-- Procedure


/*
	  EXEC pSOEProcessCustomerMetricsLineNo -- Process the Line item
		@orderID = 3358, 
		@lineNo = 0,
		@UPDINS = 'I',
		@table = 'WebQuote',
		@metricType = 'WQ',
		@entryID = 'pSOEProcessCustomerMetrics',
		@custNo = '010602',
		@orderLoc = '01',
		@shipLoc = '01'

*/



