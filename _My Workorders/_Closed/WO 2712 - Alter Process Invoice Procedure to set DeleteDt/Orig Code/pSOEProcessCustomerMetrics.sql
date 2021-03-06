USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pSOEProcessCustomerMetrics]    Script Date: 01/05/2012 16:50:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[pSOEProcessCustomerMetrics] 
	-- Add the parameters for the stored procedure here
	@orderID BIGINT = 0, 
	@lineNo int = 0,
	@table VARCHAR(50) = 'SOHeaderRel'

AS
BEGIN
-- =============================================
-- Author:		Craig Parks
-- Create date: 01/27/2009
-- Description:	Create Update Customer Metrics on order completion
-- Parameters: @orderID = order or qupote ID for update
--   @lineNo = 0 all not deleted order lines, # a specific line number
--   @table = dataset for update / insert  of CustomerMetrics
-- Modified: 1/28/2009 Craig Parks Process Invoices
-- Modified: 1/29/2009 Craig Parks Process Rep Quotes
-- Modified 2/3/2009 Craig Parks Process Web Quotes
-- Modified 3/25/2009 Craig Parks Process SO and IV SubType '50 and Below
-- Modified: 6/1/2009 Craig Parks Correct Update Insert statement for RepQuote and WebQuote
-- Modified: 12/7/2009 Craig Partks Insure all column references are qualified when using multi tables
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @custNo VARCHAR(10),
@itemNo VARCHAR(20),
@entryDt DATETIME,
@wkLineNo INT,
@uPDINS CHAR(2),
@orderLoc VARCHAR(10),
@shipLoc VARCHAR(10),
@subType VARCHAR(10)
-- Get header related information for the order dataset
IF @table = 'SOHeaderRel' BEGIN
	SELECT @custNo = SellToCustNo, @orderLoc =  OrderLoc, @shipLoc = ShipLoc,
	@subtype = SubType
	FROM SOHeaderRel (NOLOCK) WHERE pSOHeaderRelID = @orderID
    IF @subtype <= '50' BEGIN
			IF @lineNo <> 0 BEGIN -- Process 1 line Item
			  SET @uPDINS = 'I' -- Default to Insert
			  SET @wkLineNo = @lineNo
			-- Determine if a row already exists for the Customer Item No dataset combination
			  SELECT @uPDINS = 'U' WHERE EXISTS ( SELECT 1 FROM CustomerMetrics (NOLOCK) CM, SODetailRel (NOLOCK) SD WHERE
			  CM.CustNo = @custNo AND CM.ItemNo = SD.ItemNo  AND CM.MetricType = 'SO'
			  AND SD.fSOHeaderRelID = @orderID
			  AND SD.LineNumber = @wklineNo)
			  EXEC pSOEProcessCustomerMetricsLineNo -- Process the Line item
				@orderID = @orderID, 
				@lineNo = @wkLineNo,
				@updIns = @uPDINS,
				@table = @table,
				@metricType = 'SO',
				@entryID = 'pSOEProcessCustomerMetrics',
				@custNo = @custNo,
				@orderLoc = @orderloc,
				@shipLoc = @shipLoc

			  END -- Process 1 Line
			ELSE BEGIN -- Process All Lines
			-- Declare a cursor to get line numbers for the order that are not deleted
			  DECLARE SOLInes CURSOR FOR SELECT SD.LineNumber FROM SoDetailRel SD (NOLOCK) WHERE
			  SD.fSOHeaderRelID = @orderID AND SD.DeleteDt IS NULL
			  ORDER BY SD.Linenumber
			  OPEN SOLines
			  FETCH NEXT FROM SOLines INTO @wkLineNo -- Get the first order line to process
			  WHILE @@FETCH_Status = 0 BEGIN -- Loop to process each line
				SET @uPDINS = 'I'
			-- See if there is a CustomerMetrics row for the Customer, Line and dataset
				SELECT @uPDINS = 'U' WHERE EXISTS ( SELECT 1 FROM CustomerMetrics (NOLOCK) CM,
				SODetailRel (NOLOCK) SD WHERE
				CM.CustNo = @custNo AND CM.ItemNo = SD.ItemNo  AND CM.MetricType = 'SO'
				AND SD.fSOHeaderRelID = @orderID
				AND SD.LineNumber = @wklineNo)
				EXEC pSOEProcessCustomerMetricsLineNo -- Process the line
				  @orderID = @orderID, 
				  @lineNo = @wkLineNo,
				  @updIns = @uPDINS,
				  @table = @table,
				  @metricType = 'SO',
				  @entryID = 'pSOEProcessCustomerMetrics',
				  @custNo = @custNo,
				  @orderLoc = @orderloc,
				  @shipLoc = @shipLoc
			   FETCH NEXT FROM SOLines INTO @wkLineNo -- Get Next Line to process
			  END
			  CLOSE SOLines -- Close the linenumbers cursor
			  DEALLOCATE SOLines -- Deallocate the Line number cursor
			END -- Process ALL Lines
	END -- Process Order SubType 50 and Below only
END -- Sales Orders
ELSE IF @table = 'SOHeaderHist' BEGIN -- Invoices
	SELECT @custNo = SellToCustNo, @orderLoc =  OrderLoc, @shipLoc = ShipLoc,
	@subtype = SubType
	FROM SOHeaderHist (NOLOCK) WHERE pSOHeaderHistID = @orderID
	IF (@subType <= '50') BEGIN
		IF @lineNo <> 0 BEGIN -- Process 1 line Item
		  SET @uPDINS = 'I' -- Default to Insert
		  SET @wkLineNo = @lineNo
		-- Determine if a row already exists for the Customer Item No dataset combination
		  SELECT @uPDINS = 'U' WHERE EXISTS ( SELECT 1 FROM CustomerMetrics (NOLOCK) CM, SODetailHist (NOLOCK) SD WHERE
		  CM.CustNo = @custNo AND CM.ItemNo = SD.ItemNo  AND CM.MetricType = 'IV'
		  AND SD.fSOHeaderHistID = @orderID
		  AND SD.LineNumber = @wklineNo)
		  EXEC pSOEProcessCustomerMetricsLineNo -- Process the Line item
			@orderID = @orderID, 
			@lineNo = @wkLineNo,
			@updIns = @uPDINS,
			@table = @table,
			@metricType = 'IV',
			@entryID = 'pSOEProcessCustomerMetrics',
			@custNo = @custNo,
			@orderLoc = @orderloc,
			@shipLoc = @shipLoc

		  END -- Process 1 Line
		ELSE BEGIN -- Process All Lines
		-- Declare a cursor to get line numbers for the order that are not deleted
		  DECLARE SOLInes CURSOR FOR SELECT SD.LineNumber FROM SoDetailHist SD (NOLOCK) WHERE
		  SD.fSOHeaderHistID = @orderID AND SD.DeleteDt IS NULL
		  ORDER BY SD.Linenumber
		  OPEN SOLines
		  FETCH NEXT FROM SOLines INTO @wkLineNo -- Get the first order line to process
		  WHILE @@FETCH_Status = 0 BEGIN -- Loop to process each line
			SET @uPDINS = 'I'
		-- See if there is a CustomerMetrics row for the Customer, Line and dataset
			SELECT @uPDINS = 'U' WHERE EXISTS ( SELECT 1 FROM CustomerMetrics (NOLOCK) CM,
			SODetailHist (NOLOCK) SD WHERE
			CM.CustNo = @custNo AND CM.ItemNo = SD.ItemNo  AND CM.MetricType = 'IV'
			AND SD.fSOHeaderHistID = @orderID
			AND SD.LineNumber = @wklineNo)
			EXEC pSOEProcessCustomerMetricsLineNo -- Process the line
			  @orderID = @orderID, 
			  @lineNo = @wkLineNo,
			  @updIns = @uPDINS,
			  @table = @table,
			  @metricType = 'IV',
			  @entryID = 'pSOEProcessCustomerMetrics',
			  @custNo = @custNo,
			  @orderLoc = @orderloc,
			  @shipLoc = @shipLoc
		   FETCH NEXT FROM SOLines INTO @wkLineNo -- Get Next Line to process
		  END
		  CLOSE SOLines -- Close the linenumbers cursor
		  DEALLOCATE SOLines -- Deallocate the Line number cursor
		END -- Process ALL Lines
	END -- Proces Invoices for Order SubType <= '50'

	END -- Invoices
ELSE IF @table = 'RepQuote' BEGIN -- Internal rep Quote
	SELECT @custNo = CustomerNumber, @shipLoc =  LocationCode, @orderLoc = ISNULL(SalesLocationCode,LocationCode)
	FROM DTQ_CustomerQuotation (NOLOCK) WHERE ID = @orderID
	  SET @uPDINS = 'I' -- Default to Insert
	  SET @wkLineNo = 0 -- Not used for Quotes
	-- Determine if a row already exists for the Customer Item No dataset combination
	  SELECT @uPDINS = 'U' WHERE EXISTS ( SELECT 1 FROM CustomerMetrics (NOLOCK) CM, DTQ_CustomerQuotation (NOLOCK) SD WHERE
	  CM.CustNo = @custNo AND CM.ItemNo = SD.PFCItemNo COLLATE SQL_Latin1_General_CP1_CI_AS  AND SD.ID = @orderID
	  AND CM.MetricType = 'RQ')
	  EXEC pSOEProcessCustomerMetricsLineNo -- Process the Line item
		@orderID = @orderID, 
		@lineNo = @wkLineNo,
		@updIns = @uPDINS,
		@table = @table,
		@metricType = 'RQ',
		@entryID = 'pSOEProcessCustomerMetrics',
		@custNo = @custNo,
		@orderLoc = @orderloc,
		@shipLoc = @shipLoc

END -- @table = 'RepQuote
ELSE IF (@table = 'WebQuote') BEGIN -- PFCDirect, Web Quote, SDK Quote, InxSQL quote
--PRINT 'Processing In WebQuote'+cast (@orderID as VARCHAR)
	SELECT @custNo = CustNo, @shipLoc = ShipFromLocation , @orderLoc = ISNULL(EntryLocation,ShipFromLocation)
	FROM
	WebActivityPosting (NOLOCK)
--DTQ_CustomerQuotation (NOLOCK)
      WHERE QuoteRowID = @orderID
	  SET @uPDINS = 'I' -- Default to Insert
	  SET @wkLineNo = 0 -- Not used for Quotes
	-- Determine if a row already exists for the Customer Item No dataset combination
	  SELECT @uPDINS = 'U' WHERE EXISTS ( SELECT 1 FROM CustomerMetrics (NOLOCK) CM,
	  WebActivityPosting WAP (NOLOCK)
      WHERE
	  CM.CustNo = @custNo AND CM.ItemNo = WAP.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS 
	  AND QuoteRowID = @orderID
	  AND CM.MetricType = 'WQ')


	  EXEC pSOEProcessCustomerMetricsLineNo -- Process the Line item
		@orderID = @orderID, 
		@lineNo = @wkLineNo,
		@updIns = @uPDINS,
		@table = @table,
		@metricType = 'WQ',
		@entryID = 'pSOEProcessCustomerMetrics',
		@custNo = @custNo,
		@orderLoc = @orderloc,
		@shipLoc = @shipLoc

END -- @table = 'WebQuote

RETURN(0) -- return to caller
END -- Procedure


/*
	  EXEC pSOEProcessCustomerMetricsLineNo -- Process the Line item
		@orderID = 3358, 
		@lineNo = 0,
		@updIns = 'I',
		@table = 'WebQuote',
		@metricType = 'WQ',
		@entryID = 'pSOEProcessCustomerMetrics',
		@custNo = '010602',
		@orderLoc = '01',
		@shipLoc = '01'

*/



