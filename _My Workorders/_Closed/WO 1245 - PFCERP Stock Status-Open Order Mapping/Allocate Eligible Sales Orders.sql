
-- =============================================
-- Author:		Craig Parks
-- Create date: 11/19/2008
-- Description:	Process Sales Order Allocation Requests FROM THE SOALLOCATION table (Demon Procedure)
-- Modified 1/6/2008 Craig Parks Process Re-extension and Allocation for Released orders
-- Modified: 1/28/2009 Craig Parks Update Customer Metrics for previously allocated and changed orders
-- 2/17/2009 Tempory  Bypass order with SOAllocation status code not null
-- Modified: 3/16/2009 Craig Parks Send Order not held to RB
-- Modified: 4/3/2009 Craig Parks Mark order type '51' either Held or Invoice if MO for SOHeaderRel
-- Modified: 4/6/2009 Craig Parks Make RGA Order sub Type = 53 not 51
-- Modified: 4/28/2009 Craig Parks Add POAllocation by Call to pPOEProcessAllocation
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @orderID BIGINT,
@table VARCHAR(50),
@userName VARCHAR(50),
@AllocDt DATETIME,
@HeaderStatus CHAR(2),
@ErrorLogID INT,
@ChangeID VARCHAR(50),
@ChangeDt DATETIME,
@today DATETIME,
@carrierCd VARCHAR(10),
@holdCd VARCHAR(10)

SELECT @today = CONVERT (DATETIME,Convert(VARCHAR,GetDate()))
DECLARE SOALLOC CURSOR FOR
	SELECT fSOHeaderID, OrderSrcTable, EntryID,
    AllocDt,OrderCarrier, HeaderStatus, ErrorLogID,
    ChangeID, ChangeDt, StatusCd
    FROM
    SOAllocation
    WHERE AllocDt IS NULL and HeaderStatus IS NULL
    FOR UPDATE OF AllocDt, HeaderStatus, ErrorLogID,
    ChangeID, ChangeDt
OPEN SOALLOC
FETCH NEXT FROM SOALLOC INTO @orderID, @table, @username,
@AllocDt,
@carrierCd,
@HeaderStatus,
@ErrorLogID,
@ChangeID,
@ChangeDt,
@holdCd

WHILE (@@FETCH_STATUS = 0)
  BEGIN
    DECLARE @result INT
    IF @table = 'SOHeader' BEGIN
      UPDATE SODetail SET CarrierCd = @carrierCd WHERE fSOHeaderID = @orderID
      AND CarrierCd IS NULL 
      EXEC @result=pSOEAllocOrderBatch @orderID = @orderID, @userName = @username, @holdCd = @holdCd
      IF @Result <> 1 -- Locked by another user
        UPDATE SOAllocation SET
        ErrorLogID = @result,
        ChangeID = 'pProcesAlloc',
        ChangeDt = GetDate(),
        AllocDt = @today,
        HeaderStatus=
        CASE WHEN @result = 0 THEN 'S'
        ELSE 'F' END 
        WHERE CURRENT of SOAlloc
    END -- Table SOHeader
    ELSE IF (@table = 'SOHeaderRel') BEGIN -- SOHeaderRel
		DECLARE @subType Varchar(10)
		SELECT @subType = SubType FROM SOHeaderRel WHERE pSOHeaderRelID = @orderID
-- Re-extend the sales Order
        EXEC @result = pSOEExt @orderID = @orderID, @line = 0,
        @type = 'SUM', @table = 'Rel'
       IF (@subtype < '51') BEGIN
-- Allocate the released order
		   EXEC @result = pSOEMaintainAllocations 
				@orderID = @orderID, 
				@function = 'ALLOC',
				@username  = @userName,
				@caller = 'STANDALONE'
			IF @Result <> 1 BEGIN -- Locked by another user
					UPDATE SOAllocation SET
					ErrorLogID = @result,
					ChangeID = 'pProcessAlloc',
					ChangeDt = GetDate(),
					AllocDt = @today,
					HeaderStatus=
					CASE WHEN @result = 0 THEN 'S'
					ELSE 'F' END 
					WHERE CURRENT of SOAlloc
				-- EXEC pSOEProcessCustomerMetrics -- Update CustomerMetrics
				-- @orderID = @orderID,
				-- @lineNo = 0,
				-- @table = 'SOHeaderRel'
			IF (@holdCd IS NULL)  -- Send Order to RB if not held Apply hold release logic
				EXEC pSOECreatePickFlag @orderID = @OrderID, @userName = @userName
			END --result <> 1
       END -- Order SubType <= '50'
	   ELSE IF (@subType > '50') BEGIN
			IF (@holdCd IS NOT NULL) BEGIN
				UPDATE SOHeaderRel SET HoldReason = CASE WHEN @subType = '53' THEN 'RG'
				WHEN @subType = '60' THEN 'DS'
				ELSE
				@holdCd END, -- CASE @subType
				HoldDt = GetDate()
				WHERE pSOHeaderRelID =@orderID 
				UPDATE SOHeaderRel SET HoldReasonName = ISNULL(ShortDsc,'N/A') FROM Tables
				WHERE TableType IN ('RES','REAS') AND TableCd = HoldReason AND pSOHeaderrelID = @orderID
			END -- @holdCd NOT NULL
----			ELSE
			IF (@subType = '53') AND (@holdCD IS NULL)
				INSERT INTO InvoiceFlags (fSOHeaderID, OrderNo, OrderRelNo, DocumentSrcTable, EntryID, EntryDt)
				SELECT pSOHeaderRelID, OrderNo, OrderRelNo, 'SOHeaderRel', 'MakeOrder', GetDate()
				FROM SoheaderRel WHERE OrderNo = @orderID -- Flag the RGA Order for Invoicing

			UPDATE SOAllocation SET -- Set SOAllocation Processed for SubType > 50
			ErrorLogID = 0,
			ChangeID = 'pProcessAlloc',
			ChangeDt = GetDate(),
			AllocDt = @today,
			HeaderStatus= 'S' where Current of SOAlloc

       END -- Order SubType > '50'

    END -- Table SOHeaderRel

      FETCH NEXT FROM SOALLOC INTO @orderID, @table, @username,
      @AllocDt,
	  @carrierCd,
      @HeaderStatus,
      @ErrorLogID,
      @ChangeID,
      @ChangeDt,
      @holdCd
  END
CLOSE SOAlloc
DEALLOCATE SOAlloc
GO