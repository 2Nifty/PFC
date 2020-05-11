drop Procedure [dbo].[pCustPriceWorkUnprocessed]
go

CREATE Procedure [dbo].[pCustPriceWorkUnprocessed]
	@Action char(1),
	@Branch varchar(10),
	@CustomerNo varchar(10),
	@CustomerName varchar(40),
	@GroupType char(2),
	@GroupNo varchar(20),
	@GroupDesc varchar(80),
	@BuyGroupNo nvarchar(5),
	@BuyGroupDesc varchar(80),
	@SalesHistory decimal(18, 6),
	@GMPctPriceCost decimal(18, 6),
	@GMPctAvgCost decimal(18, 6),
	@SalesHistoryTot decimal(18, 6),
	@GMPctPriceCostTot decimal(18, 6),
	@GMPctAvgCostTot decimal(18, 6),
	@SalesHistoryEComm decimal(18, 6),
	@GMPctPriceCostEComm decimal(18, 6),
	@GMPctAvgCostEComm decimal(18, 6),
	@SalesHistory12Mo decimal(18, 6),
	@GMPctPriceCost12Mo decimal(18, 6),
	@GMPctAvgCost12Mo decimal(18, 6),
	@TargetGMPct decimal(18, 6),
	@ExistingCustPricePct decimal(18, 6),
	@Approved char(1),
	@EntryID varchar(50)   
as
/*
	=============================================================================================
	Author:	Tom Slater
	Create date: 3/15/2010
	Description: Work UnprocessedCategoryPrice records for Category Price Schedule Maintenance
	Action: I = Insert; U = Update

	Modified 10/05/10 (TMD-WO2002)	-Added SalesHistory12Mo & GMPctPriceCost12Mo
	Modified 11/04/05 (TMD-WO2152)	-Added GMPctAvgCost & GMPctAvgCost
					-Added SalesHistoryTot, GMPctPriceCostTot & GMPctAvgCostTot
					-Added SalesHistoryEComm, GMPctPriceCostEComm & GMPctAvgCostEComm
	=============================================================================================
*/

BEGIN
	DECLARE @EntryDate DATETIME
	set @EntryDate = getdate()

	IF @Action = 'I'
	   BEGIN
		DELETE
		FROM	UnprocessedCategoryPrice
		WHERE	CustomerNo = @CustomerNo AND GroupNo = @GroupNo

		INSERT INTO UnprocessedCategoryPrice
				(Branch,
				 CustomerNo,
				 CustomerName,
				 GroupType,
				 GroupNo,
				 GroupDesc,
				 BuyGroupNo,
				 BuyGroupDesc,
				 SalesHistory,
				 GMPctPriceCost,
				 GMPctAvgCost,
				 SalesHistoryTot,
				 GMPctPriceCostTot,
				 GMPctAvgCostTot,
				 SalesHistoryEComm,
				 GMPctPriceCostEComm,
				 GMPctAvgCostEComm,
				 SalesHistory12Mo,
				 GMPctPriceCost12Mo,
				 GMPctAvgCost12Mo,
				 TargetGMPct,
				 ExistingCustPricePct,
				 Approved,
				 EntryID,
				 EntryDt)
		VALUES		(@Branch,
				 @CustomerNo,
				 @CustomerName,
				 @GroupType,
				 @GroupNo,
				 @GroupDesc,
				 @BuyGroupNo,
				 @BuyGroupDesc,
				 @SalesHistory,
				 @GMPctPriceCost,
				 @GMPctAvgCost,
				 @SalesHistoryTot,
				 @GMPctPriceCostTot,
				 @GMPctAvgCostTot,
				 @SalesHistoryEComm,
				 @GMPctPriceCostEComm,
				 @GMPctAvgCostEComm,
				 @SalesHistory12Mo,
				 @GMPctPriceCost12Mo,
				 @GMPctAvgCost12Mo,
				 @TargetGMPct,
				 @ExistingCustPricePct,
				 @Approved,
				 @EntryID,
				 @EntryDate)
	   END
	   
	IF @Action = 'U'
	   BEGIN
		UPDATE	UnprocessedCategoryPrice
		SET	Approved = @Approved,
			TargetGMPct = @TargetGMPct,
			ExistingCustPricePct = @ExistingCustPricePct,
			ChangeID = @EntryID,
			ChangeDt = @EntryDate
		WHERE	CustomerNo = @CustomerNo AND GroupNo = @GroupNo
	   END
END
