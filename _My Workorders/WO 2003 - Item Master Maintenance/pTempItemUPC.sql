drop proc [pIMGetUPC]
GO

/****** Object:  StoredProcedure [dbo].[pIMGetUPC]    Script Date: 01/31/2012 11:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pIMGetUPC]
	@ItemNo		VARCHAR(20),	--ItemNo
	@UPCCd		VARCHAR(20),	--UPC Code
	@UPCType	VARCHAR(4),		--'PKG' or 'BULK'
	@Mode		VARCHAR(10),	--'GETNEW'	= Get the next avl UPC for the specified type. Also, return any existing UPC record.
								--'SETNEW'	= Set the specified UPC for the specified type. Also, release any existing UPC record.
	@User		VARCHAR(50)		--User Name to set ChangeID
AS
-- =============================================
-- Author:	Tod Dixon
-- Created:	02/09/2012
-- Desc:	PERP Item Maintenance procedure for ItemUPC
-- =============================================

/*
	exec [pIMGetUPC] '00200-4200-401', '', 'PKG', 'GETNEW', ''
	exec [pIMGetUPC] '00200-2800-401', '082893012131', '', 'SETNEW', 'TOD'
*/


BEGIN
	SET NOCOUNT ON;

	DECLARE	@UPCid varchar(20);

	if (@Mode = 'GETNEW')
	  BEGIN
		--Find teh ID of the next available UPC record
		SELECT	TOP 1 @UPCid = pItemUPCID
		FROM	ItemUPC (NoLock) UPC
		WHERE	isnull(ItemNo,'') = '' and isnull(ItemType,'') = @UPCType
		ORDER BY UPCCd

		--Set the new ItemUPC in TEMP mode
		UPDATE	ItemUPC
		SET		ItemNo = @ItemNo,
				ChangeID = 'TEMP-' + @User,
				ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
		FROM	ItemUPC (NoLock) UPC
		WHERE	pItemUPCID = @UPCid

		--Return the newly assigned UPC data
		SELECT	*
		FROM	ItemUPC (NoLock) UPC
		WHERE	pItemUPCID = @UPCid
	  END

	if (@Mode = 'SETNEW')
	  BEGIN
		--Release any existing ItemUPC
		UPDATE	ItemUPC
		SET		ItemNo = '',
				ChangeID = @User,
				ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
		WHERE	ItemNo = @ItemNo and UPCCd <> @UPCCd

		--Set the new ItemUPC
		UPDATE	ItemUPC
		SET		ItemNo = @ItemNo,
				ChangeID = @User,
				ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
		FROM	ItemUPC (NoLock) UPC
		WHERE	UPCCd = @UPCCd

		--Select the newly set ItemUPC
		SELECT	*
		FROM	ItemUPC (NoLock) UPC
		WHERE	ItemNo = @ItemNo
	  END
END
GO
