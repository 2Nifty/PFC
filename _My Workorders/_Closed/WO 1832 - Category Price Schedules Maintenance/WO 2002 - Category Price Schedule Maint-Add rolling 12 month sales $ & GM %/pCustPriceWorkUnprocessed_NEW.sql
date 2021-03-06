drop proc pCustPriceWorkUnprocessed
go

--USE [PERP]
--GO
/****** Object:  StoredProcedure [dbo].[pCustPriceWorkUnprocessed]    Script Date: 09/01/2010 15:29:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
	@SalesHistory12Mo decimal(18, 6),
	@GMPctPriceCost12Mo decimal(18, 6),
	@TargetGMPct decimal(18, 6),
	@ExistingCustPricePct decimal(18, 6),
	@Approved char(1),
	@EntryID varchar(50)   
as
/*
	=============================================
	Author:		Tom Slater
	Create date: 3/15/2010
	Description: Work UnprocessedCategoryPrice records for Category Price Schedule Maintenance
	Action:I=InsertU=Update
	=============================================

*/

BEGIN
	DECLARE @EntryDate DATETIME
	set @EntryDate = getdate()

	IF @Action = 'I'
	   BEGIN
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
				 SalesHistory12Mo,
				 GMPctPriceCost12Mo,
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
				 @SalesHistory12Mo,
				 @GMPctPriceCost12Mo,
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
