USE [PERP]
GO

drop proc [dbo].[pIMMaintStdComments]
go

/****** Object:  StoredProcedure [dbo].[pIMMaintStdComments]    Script Date: 10/02/2012 11:42:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pIMMaintStdComments]
	@Item	VARCHAR(20),
	@Type	VARCHAR(10),
	@FormCd	VARCHAR(2),
	@Note	VARCHAR(512),
	@RecID	INT,
	@SessID	VARCHAR(20),	--User Session ID to be used during INSERT/UPDATE/DELETE
	@Mode	VARCHAR(10)		--'GET'	= Validate ItemMaster record & get corresponding ItemNotes records
							--'UPD'	= UPDATE the Notes field on the selected ItemNotes record (@RecID)
							--'DEL'	= SET the DeleteDt on the selected ItemNotes record (@RecID)

AS
-- =============================================
-- Author:	Tod Dixon
-- Created:	10/02/2012
-- Desc:	PERP Item Notes Maintenance
-- =============================================

/*

	exec [pIMMaintStdComments] '00020-2408-999', '', '', '', 0, 'TOD', 'GET'	--No Item
	exec [pIMMaintStdComments] '00020-2408-020', '', '', '', 0, 'TOD', 'GET'	--No Notes
	exec [pIMMaintStdComments] '00057-2522-021', '', '', '', 0, 'TOD', 'GET'	--1 Note
	exec [pIMMaintStdComments] '00050-2818-221', '', '', '', 0, 'TOD', 'GET'	--Multi note


	exec [pIMMaintStdComments] '00057-2522-021', 'I', 'PO', 'TEST NOTE', 0, 'TOD', 'ADD'

*/

BEGIN
	SET NOCOUNT ON;

	DECLARE	@ItemID	INT;

	if (@Mode = 'GET')
		BEGIN
			SELECT	IM.pItemMasterID,
					IM.ItemNo,
					IM.CatDesc,
					IM.ItemDesc,
					isnull(Notes.pItemNotesID,0) as pItemNotesID,
					isnull(Notes.ItemNo,'') as NotesItem,
					isnull(Notes.[Type],'') as [Type],
					isnull(Notes.FormsCd,'') as FormCd,
					isnull(Notes.Notes,'NONOTES') as Notes,
					isnull(Notes.EntryID,'') as EntryID,
					Notes.EntryDt,
					isnull(Notes.ChangeID,'') as ChangeID,
					Notes.ChangeDt
			FROM	ItemMaster IM (NoLock) LEFT OUTER JOIN
					ItemNotes Notes (NoLock)
			ON		IM.pItemMasterID = Notes.fItemMasterID AND isnull(Notes.DeleteDt,'') = ''
			WHERE	IM.ItemNo = @Item
			ORDER BY isnull(Notes.pItemNotesID,0)
		END

	if (@Mode = 'UPD')
		BEGIN
			UPDATE	ItemNotes
			SET		Notes = @Note,
					ChangeID = @SessID,
					ChangeDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
			WHERE	pItemNotesID = @RecID
		END

	if (@Mode = 'ADD')
		BEGIN
			SELECT	Notes.*
			FROM	ItemMaster IM (NoLock) LEFT OUTER JOIN
					ItemNotes Notes (NoLock)
			ON		IM.pItemMasterID = Notes.fItemMasterID
			WHERE	isnull(Notes.DeleteDt,'') = '' AND
					IM.ItemNo = @Item AND
					Notes.[Type] = @Type AND
					Notes.FormsCd = @FormCd

			if (@@RowCount <= 0)
			   BEGIN
					SELECT	@ItemID = pItemMasterID
					FROM	ItemMaster (NoLock)
					WHERE	ItemNo = @Item

					INSERT
					INTO	ItemNotes
							(fItemMasterID, ItemNo, [Type], Notes, EntryID, EntryDt, FormsCd)
					VALUES	(@ItemID, @Item, @Type, @Note, @SessID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), @FormCd)
			   END
		END

	if (@Mode = 'DEL')
		BEGIN
			UPDATE	ItemNotes
			SET		DeleteID = @SessID,
					DeleteDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
			WHERE	pItemNotesID = @RecID
		END

END
