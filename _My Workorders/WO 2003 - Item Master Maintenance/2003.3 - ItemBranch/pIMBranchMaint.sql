USE [PERP]
GO

drop proc [pIMBranchMaint]
go

/****** Object:  StoredProcedure [dbo].[pIMBranchMaint]    Script Date: 10/09/2012 16:16:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pIMBranchMaint]
	@ItemID	VARCHAR(20),	--Original pItemMasterID for the Item
	@LocID	VARCHAR(5),		--Location number (LocID)
	@StkInd	VARCHAR(5),		--IM Stock Indicator: YES or NO; Default to NO
	@SVC	VARCHAR(5),		--SVC Code: Default to 'N'
	@ROP	VARCHAR(20),	--Reorder point: Default to 0.0
	@BinCap	VARCHAR(20),	--Bin Capacity: Default to 0
	@User	VARCHAR(50),	--User Name to set EntryID/ChangeID
	@Mode	VARCHAR(10)		--'UPDATE'	= UPDATE the corresponding ItemBranch record
							--'INSERT'	= INSERT the new ItemBranch record
AS
-- =============================================
-- Author:	Tod Dixon
-- Created:	06/01/2012
-- Desc:	PERP Item Maintenance procedure to INSERT & UPDATE ItemBranch data
-- =============================================

/*

	exec [pIMBranchMaint] '3','01','NO','N','9','tod-test','UPDATE' 
	exec [pIMBranchMaint] '370','02','YES','K','99.9','tod-test','INSERT' 

*/

BEGIN
	SET NOCOUNT ON;

	if (@StkInd = 'YES')
	  BEGIN
		SET @StkInd = '1'
	  END
	else
	  BEGIN
		SET @StkInd = '0'
	  END
	if (@SVC = '') SET @SVC = 'N'
	if (@ROP = '') SET @ROP = '0.0'
	if (@BinCap = '') SET @BinCap = '0'

	if (@Mode = 'UPDATE')
	  BEGIN
		UPDATE	ItemBranch
		SET		StockInd = CAST(@StkInd as TINYINT),
				SalesVelocityCd = @SVC,
				ReorderPoint = CAST(@ROP as DECIMAL(17,4)),
				Capacity = CAST(@BinCap as NUMERIC),
				ChangeID = @User,
				ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
		WHERE	fItemMasterID = @ItemID AND Location = @LocID
	  END

	if (@Mode = 'INSERT')
	  BEGIN
		--TMD: What else do we need to load into the new IB record???
		--		Loc Name, Short Code, etc ...
		INSERT INTO	ItemBranch
					(fItemMasterID,
					 Location,
					 StockInd,
					 SalesVelocityCd,
					 ReorderPoint,
					 Capacity,
					 EntryID,
					 EntryDt)
		VALUES		(@ItemID,
					 @LocID,
					 CAST(@StkInd as TINYINT),
					 @SVC,
					 CAST(@ROP as DECIMAL(17,4)),
					 CAST(@BinCap as NUMERIC),
					 @User,
					 CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))
	  END
END
