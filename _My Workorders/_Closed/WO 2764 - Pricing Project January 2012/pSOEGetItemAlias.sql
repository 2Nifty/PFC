drop proc [pSOEGetItemAlias]
GO

/****** Object:  StoredProcedure [dbo].[pSOEGetItemAlias]    Script Date: 01/31/2012 11:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pSOEGetItemAlias]
	@SearchItemNo VARCHAR(20) = '',
	@Organization VARCHAR(20) = '',
	@PrimaryBranch VARCHAR(10) = '',
	@SearchType VARCHAR(10) = ''
AS
-- =============================================
-- Author:	Tom Slater
-- Created:	11/10/2008
-- Desc:	PERP SOE Item procedure: 
--			Find the item and possibly the customer alias
--			SearchType: 'Alias' = look for item alias; 'PFC' = look for PFC Item
--
-- Mod:		12/22/2011 - Sathish:	If no item alias for Sell To number, use Bill To number
-- Mod:		01/31/2012 - TMD:		Return ItemBranch.CostBasis field
-- =============================================

/*
exec pSOEGetItemAlias '00200-2400-021', '555555', '15', 'PFC'

-- To test bill to CustNo
exec pSOEGetItemAlias 'CB51618212Z', '001006', '15', 'Alias' 
*/

BEGIN
	SET NOCOUNT ON;

	-- setup environment
	declare @AliasID int;
	declare @ItemID int;
	declare @ItemFoundIn varchar(20);
	declare @PFCItem varchar(20);
	declare @CustItem varchar(20);
	declare @ItemDesc varchar(50);
	declare @CustDesc varchar(50);
	declare @ItemQty decimal(18,0);
	declare @ItemUOM varchar(10);
	declare @AltQty decimal(18,0);
	declare @AltUOM varchar(10);
	declare @SuperQty decimal(18,0);
	declare @SuperUOM varchar(10);
	declare @PieceQty decimal(18,0);
	declare @PieceUOMText varchar(10);
	declare @ColorInd char(2);
	declare @StockInd tinyint;
	declare @SKUID int;
	declare @SKUCount int;
	declare @AltPrice  decimal(18,6);
	declare @AltPriceUOM varchar(10);
	declare @PriceCode varchar(10);
	declare @QtyPerUnit  varchar(20);
	declare @PriceOrigin  varchar(20);
	declare @ReplacementCost decimal(18,6);
	declare @ListPrice decimal(18,6);
	declare @StdCost decimal(18,6);
	declare @SVCode varchar(10);
	declare @CVCode varchar(10);
	declare @FVCode varchar(10);
	declare @HundredWght decimal(18,6);
	declare @Wght decimal(18,6);
	declare @GrossWght decimal(18,6);
	declare @QOH bigint;
	declare @LocName varchar(50);
	declare @CertRequiredInd char(2);
	declare @SubItemInd char(2);
	declare @SellOutItemInd char(2);
	declare @CostBasis char(2);

	declare @ErrorClass char(4);
	declare @ErrorType char(4);
	declare @ErrorCode varchar(4);

	-- set defaults
	set @ErrorClass = 'SOE';
	set @ErrorType = '';
	set @ErrorCode = '0000';
	set @ItemFoundIn = '';
	set @ItemDesc = '';
	set @CustDesc = '';
	set @ItemUOM = '';
	set @ItemID = -1;
	set @AliasID = -1;

	--Price, Price Method, Discounted Price, Inventory Price 1, Price code from Caller, Commission %,
	--Commission dollars, Alt. Price, Alt. Price UOM, & All (Navision Sales Desk) Worksheet Fields 

	-- Try Alias first if we got an organization
	IF @SearchType = 'Alias'
		BEGIN	-- look in item alias
			--print	'Look in Item Alias';
			SELECT	@AliasID = pItemAliasID  
			FROM	ItemAlias WITH (NOLOCK)
			WHERE	(AliasItemNo = @SearchItemNo)
					and	((OrganizationNo = @Organization)
					or (OrganizationNo = '000000'));
		
			-- Try to get item info using Bill To number
			IF isnull(@AliasID, -1) = -1
				BEGIN
					--print	'Try to get item info using Bill To number';
					SELECT	@AliasID = pItemAliasID  
					FROM	ItemAlias WITH (NOLOCK)
					WHERE	(AliasItemNo = @SearchItemNo)
							and	OrganizationNo in ( SELECT	fbilltoNo 
													FROM	CustomerMaster (NOLOCK) 
													WHERE	CustNo=@Organization)
				END

			IF isnull(@AliasID, -1) <> -1
				-- We got an alias, so do the big select and be done
				BEGIN	-- Return ItemAlias
					--print	'Return Itemalias';
					SELECT	@ItemID = pItemMasterID
							,@PFCItem = Item.ItemNo
							,@CustItem = Alias.AliasItemNo
							,@ItemDesc = Item.ItemDesc
							,@CustDesc = Alias.AliasDesc
							,@ItemQty = Item.SellStkUMQty
							,@ItemUOM = case when (isnull(rtrim(CustUM.UM), '') <> '')
													then Alias.UOM
													else Item.SellStkUM
										end
							,@ItemFoundIn = 'XRef'
							,@SuperQty = isnull(Super.QtyPerUM,0)
							,@SuperUOM = Item.SuperUM
							,@AltQty = isnull(Item.SellStkUMQty*Alt.QtyPerUM,1)
							,@AltUOM = Item.SellUM
							,@PieceQty = isnull(Piece.AltSellStkUMQty,0)
							,@ColorInd = Item.PriceWorkSheetColorInd
							,@FVCode = Item.CorpFixedVelocity
							,@ListPrice = Item.ListPrice
							,@HundredWght = isnull(Item.HundredWght,0)
							,@Wght = isnull(Item.Wght,0)
							,@GrossWght = coalesce(Item.GrossWght,0)
							,@CertRequiredInd = Item.CertRequiredInd
							,@SubItemInd = isnull(Item.SubItemInd,'N')
							,@SellOutItemInd = isnull(Item.SellOutItemInd,'N')
					FROM	ItemAlias Alias WITH (NOLOCK) inner join
							ItemMaster Item WITH (NOLOCK)
					ON		Item.ItemNo = Alias.ItemNo inner join
							ItemUM WITH (NOLOCK)
					ON		Item.pItemMasterID = ItemUM.fItemMasterID and Item.SellStkUM = ItemUM.UM left outer join
							ItemUM Super WITH (NOLOCK)
					ON		Item.pItemMasterID = Super.fItemMasterID and Item.SuperUM = Super.UM inner join
							ItemUM Alt WITH (NOLOCK)
					ON		Item.pItemMasterID = Alt.fItemMasterID and Item.SellUM = Alt.UM left outer join
							ItemUM CustUM WITH (NOLOCK)
					ON		Item.pItemMasterID = CustUM.fItemMasterID and Alias.UOM = CustUM.UM left outer join
							ItemUM Piece WITH (NOLOCK)
					ON		Item.pItemMasterID = Piece.fItemMasterID and Piece.UM = 'PC'
					WHERE	pItemAliasID=@AliasID;

					GOTO GetOther;	-- now get other data
				END		-- Return ItemAlias
			ELSE
				BEGIN	-- Alias not found (return error code)
					set @ErrorCode = '0001';
					set @ErrorType = 'E';
					GOTO ErrorResult;
				END		-- Alias Not found
		END		-- look in item alias


	-- Try to find the PFC item number
	IF @SearchType = 'PFC'
		BEGIN	-- Return ItemMaster
			--print	'Return ItemMaster';
			SELECT	@ItemID = pItemMasterID
					,@CustItem = isnull(Alias.AliasItemNo,'No Alias')
					,@PFCItem = Item.ItemNo
					,@ItemDesc = Item.ItemDesc 
					,@CustDesc = isnull(Alias.AliasDesc, '')
					,@ItemQty = Item.SellStkUMQty
					,@ItemUOM = Item.SellStkUM  
					,@ItemFoundIn = 'IM'
					,@SuperQty = isnull(Super.QtyPerUM,0)
					,@SuperUOM = Item.SuperUM
					,@AltQty = isnull(Item.SellStkUMQty*Alt.QtyPerUM,1)
					,@AltUOM = Item.SellUM
					,@PieceQty = isnull(Piece.AltSellStkUMQty,0)
					,@ColorInd = Item.PriceWorkSheetColorInd
					,@FVCode = Item.CorpFixedVelocity
					,@ListPrice = Item.ListPrice
					,@HundredWght = isnull(Item.HundredWght,0)
					,@Wght = isnull(Item.Wght,0)
					,@GrossWght = coalesce(Item.GrossWght,0)
					,@CertRequiredInd = coalesce(Item.CertRequiredInd, '0')
					,@SubItemInd = isnull(Item.SubItemInd,'N')
					,@SellOutItemInd = isnull(Item.SellOutItemInd,'N')
			FROM	ItemMaster Item WITH (NOLOCK) inner join
					ItemUM WITH (NOLOCK)
			ON		Item.pItemMasterID = ItemUM.fItemMasterID and Item.SellStkUM = ItemUM.UM left outer join
					ItemUM Super WITH (NOLOCK)
			ON		Item.pItemMasterID = Super.fItemMasterID and Item.SuperUM = Super.UM inner join
					ItemUM Alt WITH (NOLOCK)
			ON		Item.pItemMasterID = Alt.fItemMasterID and Item.SellUM = Alt.UM left outer join
					ItemUM Piece WITH (NOLOCK)
			ON		Item.pItemMasterID = Piece.fItemMasterID and Piece.UM = 'PC' left outer join
					ItemAlias Alias WITH (NOLOCK)
			ON		Item.ItemNo = Alias.ItemNo and OrganizationNo = @Organization
			WHERE	Item.ItemNo = @SearchItemNo;
		END		-- Return ItemMaster

	IF isnull(@ItemID,-1) = -1
		BEGIN	-- Item not found (return error code)
			set @ErrorCode = '0001';
			set @ErrorType = 'E';
			GOTO ErrorResult;
		END		-- Item not found

GetOther:
	set @QOH = 0;
	set @SKUCount = 0;

	--print	'Get other data: ID=' + cast(@ItemID as varchar(20)) + ' - Loc=' + cast(@PrimaryBranch as varchar(20));
	SELECT	@SKUID = fItemMasterID
			,@ReplacementCost = ReplacementCost
			,@StdCost = StdCost
			,@SVCode = SalesVelocityCd
			,@CVCode = CatVelocityCd
			,@StockInd = StockInd
			,@CostBasis = CostBasis
	FROM	ItemBranch WITH (NOLOCK)
	WHERE	ItemBranch.fItemMasterID = @ItemID and Location = @PrimaryBranch;
	--print	'CostBasis=' + cast(@CostBasis as varchar(20));

	IF isnull(@SKUID,-1) = -1
		BEGIN	--SKU not found (return warning/error code)
			--print 'SKU not found'
			set @ErrorCode = '0021';
			set @ErrorType = 'W';

			SELECT	@SKUCount = count(*)
			FROM	ItemBranch WITH (NOLOCK)
			WHERE	ItemBranch.fItemMasterID = @ItemID;
			--		and ItemBranch.StockInd = 1;

			IF @SKUCount = 0
				-- no SKU found anywhere
				BEGIN
					set @ErrorCode = '0022';
					set @ErrorType = 'E';
					GOTO ErrorResult;
				END
		END		--SKU not found
	else
		BEGIN
			SELECT	@QOH = isnull(dbo.fGetBrAvailability(@PFCItem, @PrimaryBranch, @ItemUOM),0);
		END

	set	@ReplacementCost = isnull(@ReplacementCost,0);
	set @StdCost = isnull(@StdCost,0);
	set	@SVCode = isnull(@SVCode,'');
	set @CVCode = isnull(@CVCode,'');
	set @PieceUOMText = case when charindex('WT',@AltUOM)<>0 then 'LBS'
							 when charindex('FT',@AltUOM)<>0 then 'Feet'
															 else 'Pcs'
						end;

	SELECT	@LocName = LocName
	FROM	LocMaster WITH (NOLOCK)
	WHERE	LocID = @PrimaryBranch;

	-- Normal end of procedure
	GOTO NormalEnd;

ErrorResult:
	-- something bad happened, we send back only the procedure results
	select @ErrorClass as ErrorClass, @ErrorType as ErrorType, @ErrorCode as ErrorCode ;
	GOTO ProcEnd;

NormalEnd:
	-- Normal end of procedure. Return procedure results and data
	select @ErrorClass as ErrorClass, @ErrorType as ErrorType, @ErrorCode as ErrorCode ;

	-- give it back
	select	@ItemID as ItemID
			,@PFCItem as FoundItem
			,@CustItem as CustItem 
			,@ItemDesc as ItemDesc 
			,@CustDesc as CustDesc
			,@ItemQty as ItemQty
			,@ItemUOM as ItemUOM 
			,@ItemFoundIn as ItemFoundIn
			,@SuperQty as SuperQty
			,@SuperUOM as SuperUM
			,@AltQty as AltQtyPerUM
			,@AltUOM as AltPriceUM
			,case when @PieceQty = 0 then @ItemQty else @PieceQty end as PieceQty
			,@PieceUOMText as PieceUOMText
			,isnull(@ColorInd,'0') as ColorInd
			,@SVCode as SalesVelocityCd
			,@CVCode as CatVelocityCd
			,@FVCode as FixedVelocityCd
			,isnull(@StockInd,0) as StockInd
			,@ReplacementCost as ReplacementCost
			,@StdCost as StdCost
			,@ListPrice as ListPrice
			,@HundredWght as HundredWght
			,@Wght as Wght
			,@GrossWght as GrossWght
			,@QOH as QOH
			,@LocName as LocName
			,@CertRequiredInd as CertRequiredInd
			,@SubItemInd as SubItemInd
			,@SellOutItemInd as SellOutItemInd
			,isnull(@CostBasis,'') as CostBasis;

ProcEnd:
	-- final clean up

END
