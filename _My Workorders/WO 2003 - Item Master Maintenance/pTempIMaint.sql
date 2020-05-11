drop proc [pIMGetItem]
GO

/****** Object:  StoredProcedure [dbo].[pIMGetItem]    Script Date: 01/31/2012 11:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pIMGetItem]
	@Item	VARCHAR(20),
	@OrigID	VARCHAR(20),	--Original pItemMasterID to be used during COPY
	@SessID	VARCHAR(20),	--User Session ID to be used during INSERT & COPY
	@Mode	VARCHAR(10)		--'SELECT'	= SELECT the corresponding ItemMaster record
							--'PARENT'	= Validate the PARENT item and BOM Indicator
							--'INSERT'	= INSERT the new ItemMaster record to set db defaults & return the newly added record
							--'COPY'	= COPY the new ItemMaster DESTINATION record to set db defaults & return the newly added record
							--'CLEAR'	= CLEAR (Physically DELETE) stranded ItemMaster & ItemUM SETUP records
AS
-- =============================================
-- Author:	Tod Dixon
-- Created:	02/09/2012
-- Desc:	PERP Item Maintenance procedure to Find & Validate the ItemMaster Data
-- Returns:	Tables[0] = ItemMaster
--			Tables[1] = ItemUOM
--			Tables[2] = ItemBranch
--			Tables[3] = ItemUPC
--			Tables[4] = CategoryDesc (from List)
--			Tables[5] = ItemUMDivisor (from List)
-- =============================================

/*

	exec [pIMGetItem] '00020-2525-020', '', '', 'SELECT'
	exec [pIMGetItem] '00200-4200-401', '', '', 'SELECT'

	exec [pIMGetItem] '00200-3333-999', '', '54292', 'INSERT'
	exec [pIMGetItem] '00200-3333-123', 3, '54292', 'COPY'


*/

BEGIN
	SET NOCOUNT ON;

	DECLARE	@FromItemID varchar(20);
	DECLARE	@ItemID varchar(20);
	DECLARE	@ItemNo varchar(20);
	DECLARE	@CatNo varchar(5);
	DECLARE	@ParentNo varchar(20);
	DECLARE @BOMCount int;
	DECLARE	@HubCode varchar(10);

	if (@Mode = 'INSERT')
		BEGIN
			--We should not need to check for duplicate because the page
			--will not enter INSERT mode until duplicates are checked.
			INSERT INTO	ItemMaster
						(ItemNo, EntryID, EntryDt, DeleteID, DeleteDt)
			VALUES		(@Item, 'InsTemp-'+@SessID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), 'SETUP-'+@SessID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))
		END

	if (@Mode = 'COPY')
		BEGIN
			--We should not need to check for duplicate because the page
			--will not enter COPY mode until duplicates are checked.
			INSERT INTO	ItemMaster
						(ItemNo, EntryID, EntryDt, DeleteID, DeleteDt)
			VALUES		(@Item, 'CopyTemp-'+@SessID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), 'SETUP-'+@SessID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))
		END

	if (@Mode = 'CLEAR')
		BEGIN
			--Physically DELETE stranded ItemMaster & ItemUM SETUP records
			DELETE
			FROM	ItemMaster
			WHERE	EntryId like '%Temp-'+@SessID+'%' or
					DeleteId like '%SETUP-'+@SessID+'%'

			DELETE
			FROM	ItemUM
			WHERE	EntryId like '%Temp-'+@SessID+'%' or
					DeleteId like '%SETUP-'+@SessID+'%'

			return;
		END

	if (@Mode = 'PARENT')
		BEGIN
			SET @ParentNo = @Item

			--Check if the BOM exists
			SELECT	@BOMCount = count(BOM.ParentItemNo)
			FROM	BOM (NoLock) BOM
			WHERE	BOM.ParentItemNo = @ParentNo

			--Validate the ParentItem and the BOM Indicator
			SELECT	IM.pItemMasterID,
					IM.ItemNo,
					IM.ParentProdNo,
					CASE WHEN @BOMCount > 0 THEN 'Yes' ELSE 'No' END as BOMInd
			FROM	ItemMaster (NoLock) IM
			WHERE	ItemNo = @ParentNo

			return;
		END

	--Fetch the pItemMasterID	
	SELECT	@ItemID = IM.pItemMasterID,
			@ItemNo = IM.ItemNo,
			@ParentNo = IM.ParentProdNo
	FROM	ItemMaster (NoLock) IM
	WHERE	ItemNo = @Item
	
	--SET the Category Number
	SET		@CatNo = left(@Item,5)
--select @ItemID as pItemmasterID, @ItemNo as ItemNo, @CatNo as CatNo

	--Check if the BOM exists
	SELECT	@BOMCount = count(BOM.ParentItemNo)
	FROM	BOM (NoLock) BOM
	WHERE	BOM.ParentItemNo = @ParentNo
--select @BOMCount as BOMCount

	--Set Hub Control Code
	SELECT	@HubCode = AppOptionValue
	FROM	AppPref
	WHERE	ApplicationCd='IM' AND AppOptionType='IMHubLoc'
--select @HubCode as HubCode

	--Copy the UM records
	if (@Mode = 'COPY')
		BEGIN
			INSERT INTO	ItemUM
						(fItemMasterID, UM, AltSellStkUMQty, QtyPerUM, UnitsPerUnit, Weight, Volume, SequenceNo, EntryID, EntryDt, DeleteID, DeleteDt, StatusCd)
			SELECT		@ItemID, UM, AltSellStkUMQty, QtyPerUM, UnitsPerUnit, Weight, Volume, SequenceNo, 'CopyTemp-'+@SessID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), 'SETUP-'+@SessID, CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), StatusCd
			FROM		ItemUM (NoLock) UM
			WHERE		UM.fItemMasterID = @OrigID
		END

	--Read the ItemUMDivisor List
	SELECT	LD.ListValue as UOM,
			LD.ListDtlDesc as Divisor
	INTO	#tItemUMDivisor
	FROM	ListMaster (NoLock) LM inner join
			ListDetail (NoLock) LD
	ON		LM.pListMasterID = LD.fListMasterID
	WHERE	LM.ListName = 'ItemUMDivisor'
--select @ from #tItemUMDivisor

	-----------------------------------------------------
	--TABLE[0] - Read the corresponding ItemMaster record
	SELECT	pItemMasterID as ItemID,
			left(IM.ItemNo,5) as CatNo,
			substring(IM.ItemNo,7,4) as SizeNo,
			right(IM.ItemNo,3) as VarNo,
			IM.ItemNo,
			IM.LengthDesc,
			IM.DiameterDesc,
			IM.CatDesc,
			IM.ItemSize as SizeDesc,
			IM.Finish as Plating,
			IM.ItemDesc,
			IM.UPCCd,
			IM.CategoryDescAlt1 as AltDesc,
			IM.CategoryDescAlt2 as AltDesc2,
			IM.CategoryDescAlt3 as AltDesc3,
			IM.SizeDescAlt1 as AltSize,
			IM.CustNo,
			IM.ItemPriceGroup,
			IM.BoxSize as RoutingNo,
			CASE WHEN @BOMCount > 0 THEN 'Yes' ELSE 'No' END as BOMInd,
			IM.ParentProdNo,
			IM.CorpFixedVelocity,
			IM.PPICode,
--			IM.TariffCd as HarmonizingCd,
			IM.Tariff as HarmonizingCd,
			IM.WebEnabledInd,
			IM.CertRequiredInd,
			IM.HazMatInd,		--Prop65
			IM.QualityInd as FQAInd,
			IM.PalPtnrInd as PtPartner,
			IM.ListPrice,
			IM.HundredWght,
			IM.GrossWght,
			IM.Wght as NetWght,
			IM.PCLBFTInd,
			IM.SellStkUM as BaseUOM,
			IM.SellStkUMQty as UnitsPerBase,
			IM.PcsPerPallet as UnitsPerSE,
			IM.SellUM as SellUOM,
			IM.CostPurUM as PurchUOM,
			IM.SuperUM as SuperUOM,
			CASE WHEN IM.SellStkUMQty = 0
				 THEN 0
				 ELSE IM.PcsPerPallet / IM.SellStkUMQty
			END as SuperUOMQty,
			isnull(IM.EntryID,'') as EntryID,
			IM.EntryDt,
			isnull(IM.ChangeID,'') as ChangeID,
			IM.ChangeDt,
			isnull(IM.DeleteID,'') as DeleteID,
			IM.DeleteDt
	FROM	ItemMaster (NoLock) IM
	WHERE	IM.pItemMasterID = @ItemID

	--TABLE[1] - Read the corresponding ItemUM record(s)
	SELECT	UOM.fItemMasterID as ItemID,
			UOM.UM as UOM,
			UOM.AltSellStkUMQty as AltQty,
			UOM.QtyPerUM as QtyPer,
			isnull(UOMDiv.Divisor,0) as UOMDivisor,
			isnull(UOM.EntryID,'') as EntryID,
			UOM.EntryDt,
			isnull(UOM.ChangeID,'') as ChangeID,
			UOM.ChangeDt,
			isnull(UOM.DeleteID,'') as DeleteID,
			UOM.DeleteDt,
			--UOMUpdStatus - 0=No update; 1=UPDATE; 2=INSERT; -1=DELETED
			CASE WHEN isnull(UOM.DeleteDt,0) = 0
				 THEN 0
				 ELSE CASE WHEN left(isnull(UOM.DeleteID,''),5) = 'SETUP'
						   THEN 1
						   ELSE -1
					  END
			END as UOMUpdStatus
	FROM	ItemUM (NoLock) UOM left outer join
			#tItemUMDivisor (NoLock) UOMDiv
	ON		UOM.UM = UOMDiv.UOM
	WHERE	UOM.fItemMasterID = @ItemID
	ORDER BY UOM.UM

	--TABLE[2] - Read the corresponding ItemBranch Stocking Branch record(s)
	SELECT	Loc.LocID as Location,
--			CASE WHEN isnull(SKU.ItemNo,'') = '' THEN 'No ' + isnull(Loc.ShortCode,'Brn') + ' Record' ELSE Loc.LocName END as LocStatus,
			isnull(Loc.LocName,'') as LocStatus,
			isnull(Loc.LocName,'') as LocName,
			isnull(Loc.ShortCode,'') as ShortCode,
			--Loc.MaintainIMQtyInd as BrnInd,
			CASE WHEN isnull(SKU.ItemNo,'') = '' THEN 'Ins' ELSE 'Upd' END as LocEdit,
--			CASE WHEN isnull(SKU.ItemNo,'') = '' THEN 'No ' + isnull(Loc.ShortCode,'Brn') + ' Record' ELSE SKU.ItemNo END as ItemNo,
			SKU.fItemMasterID as BrnID,
			CASE WHEN isnull(ItemNo,'') = ''
					THEN 'No'
					ELSE CASE WHEN isnull(SKU.StockInd,0) = 1 THEN 'Yes' ELSE 'No' END
			END as StockInd,
			isnull(SKU.SVC,'N') as SVC,
			isnull(SKU.ROP,0.0) as ROP,
			isnull(SKU.Capacity,0) as Capacity,
			CASE WHEN isnull(Loc.IMDisplayColor,'') = @HubCode THEN 'Y' ELSE 'N' END as BrnHubInd,
			--BrnUpdStatus - 0=No update; 1=UPDATE; 2=INSERT; -1=DELETED; -2=Does not exist
			CASE WHEN isnull(SKU.ItemNo,'') = '' THEN -2 ELSE 0 END as BrnUpdStatus
	FROM	LocMaster Loc (NoLock) LEFT OUTER JOIN
			(SELECT	IM.ItemNo,
					IM.pItemMasterID,
					Brn.fItemMasterID,
					Brn.Location,
					Brn.StockInd,
					Brn.SalesVelocityCd as SVC,
					Brn.ReorderPoint as ROP,
					Brn.Capacity
			 FROM	ItemMaster IM (NoLock) INNER JOIN
					ItemBranch Brn (NoLock)
			 ON		IM.pItemMasterID = Brn.fItemMasterID
			 WHERE	IM.ItemNo = @Item) SKU
	ON		SKU.Location = Loc.LocID
	WHERE	Loc.MaintainIMQtyInd = 'Y'
	ORDER BY Loc.LocID

	--TABLE[3] - Read the corresponding ItemUPC record
	SELECT	*
	FROM	ItemUPC UPC
	WHERE	UPC.ItemNo = @ItemNo

	--TABLE[4] - Read the corresponding CategoryDesc List record
	SELECT	LD.ListValue as Category,
			LD.ListDtlDesc as CategoryDesc
	FROM	ListMaster (NoLock) LM inner join
			ListDetail (NoLock) LD
	ON		LM.pListMasterID = LD.fListMasterID
	WHERE	LM.ListName = 'CategoryDesc' and LD.ListValue = @CatNo

	--TABLE[5] - Return the ItemUMDivisor List (#tItemUMDivisor)
	SELECT	*
	FROM	#tItemUMDivisor (NoLock)
END
GO
