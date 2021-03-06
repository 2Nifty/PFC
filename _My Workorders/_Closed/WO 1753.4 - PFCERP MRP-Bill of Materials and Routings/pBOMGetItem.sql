USE [DEVPERP]
GO
/****** Object:  StoredProcedure [dbo].[pBOMGetItem]    Script Date: 07/15/2011 14:02:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pBOMGetItem]
	@SearchItemNo VARCHAR(20) = ''
AS
BEGIN
-- ================================================
-- Author:	Pete Arreola
-- Created:	11/04/2010
-- Desc:	Bill of Materials get item & check BOM
-- Created:	11/04/2010
-- ================================================

/*

exec pBOMGetItem '00200-2400-021'

*/


	SET NOCOUNT ON;

	declare @ItemID bigint;
	declare @PFCItem varchar(20);
	declare @ItemCategory char(5);
	declare @ItemDesc varchar(50);
	declare @CatDesc varchar(50);
	declare @ParentProdNo varchar(40);
	declare @Finish varchar(4);
	declare @PriceUM char(5);
	declare @CostUM char(5);
	declare @ItemQty decimal(18,0);
	declare @ItemUOM varchar(10);
	declare @CorpFixedVelocity varchar(10);
	declare @PackageVelocity varchar(10);
	declare @CatVelocityCd varchar(10);
	declare @SellGlued varchar(30);
	declare @CostGlued varchar(30);
	declare @SuperGlued varchar(30);
	declare @LowProfileQty decimal(18,0);
	declare @AltQty decimal(18,0);
	declare @AltUOM varchar(10);
	declare @SuperQty decimal(18,0);
	declare @SuperUOM varchar(10);
	declare @HundredWght decimal(18,2);
	declare @NetWght decimal(18,2);
	declare @GrossWght decimal(18,2);
	declare @ListPrice decimal(18,2);
	declare @Tariff varchar(20);
	declare @UPC varchar(20);
	declare @PPI varchar(20);
	declare @PackageGroup varchar(30);
	declare @WebEnabled varchar(10);
	declare @Created datetime;
	declare @pSecUserID numeric(9,0);
	declare @CPROk int;
	declare @ErrorClass char(4);
	declare @ErrorType char(4);
	declare @ErrorCode varchar(4);

	-- set defaults
	set @ErrorClass = 'SOE';
	set @ErrorType = '';
	set @ErrorCode = '0000';
	set @ItemUOM = '';
	set @ItemID = -1;

	-- Try to find the item number
	SELECT	@ItemID = pItemMasterID  
			,@PFCItem = Item.ItemNo
			,@ParentProdNo = isnull(Item.ParentProdNo,'')
			,@ItemDesc = Item.ItemDesc
			,@ItemCategory = left(Item.ItemNo, 5) 
			,@CatDesc = Item.CatDesc 
			,@ItemQty = Item.SellStkUMQty
			,@ItemUOM = Item.SellStkUM  
			,@PriceUM = Item.PriceUM  
			,@CostUM = Item.CostPurUM
			,@SellGlued = convert(varchar(30), Item.SellStkUMQty) + '/' + Item.SellStkUM
			,@SuperQty = isnull(Super.QtyPerUM,0)
			,@SuperUOM = Item.SuperUM
			,@SuperGlued = convert(varchar(30), convert(int, isnull(Super.QtyPerUM,0))) + '/' + Item.SuperUM
			,@LowProfileQty = isnull(LowProfilePalletQty,0)
			,@AltQty = isnull(Item.SellStkUMQty*Alt.QtyPerUM,1)
			,@AltUOM = Item.SellUM
			,@NetWght = Item.Wght
			,@GrossWght = Item.GrossWght
			,@HundredWght = Item.HundredWght
			,@ListPrice = Item.ListPrice
			,@Tariff = Item.Tariff
			,@UPC = Item.UPCCd
			,@CostGlued = convert(varchar(30), convert(decimal(18,2), Item.ReplacementCostAlt)) + '/' + Item.SellUM
			,@WebEnabled = case WebEnabledInd when 0 then 'No' else 'Yes' end
			,@PackageGroup = Item.PackageGroup
			,@Finish = Finish
			,@CorpFixedVelocity = CorpFixedVelocity
			,@CatVelocityCd = isnull(CatVelocityCd,'')
			,@PPI = isnull(PalPtnrInd,'')
			,@Created = Item.EntryDt
			,@PackageVelocity = PackageVelocityCd
	FROM	ItemMaster Item (NOLOCK) inner join
			ItemUM (NOLOCK)
	ON		Item.pItemMasterID = ItemUM.fItemMasterID and Item.SellStkUM = ItemUM.UM left outer join
			ItemUM Super (NOLOCK)
	ON		Item.pItemMasterID = Super.fItemMasterID and Item.SuperUM = Super.UM inner join
			ItemUM Alt (NOLOCK)
	ON		Item.pItemMasterID = Alt.fItemMasterID and Item.SellUM = Alt.UM
	WHERE	ItemNo = @SearchItemNo;

	IF isnull(@ItemID,-1) = -1	-- Item not found, we are done
	  BEGIN
		set @ErrorCode = '0001';
		set @ErrorType = 'E';
		GOTO ErrorResult;
	  END

	--Look for CPR security enabled
	SELECT	@pSecUserID = pSecUserID 
	FROM	SecurityMembers (NOLOCK) INNER JOIN
			SecurityUsers (NOLOCK) 
	ON		SecurityMembers.SecUserID = SecurityUsers.pSecUserID
	WHERE	SecurityGroupApp = 'SSC(Q)' and SecurityUsers.UserName = @UserName

	set @CPROk = 0;

	if @pSecUserID is not null set @CPROk = 1;

	GOTO NormalEnd;


ErrorResult:	-- something bad happened, we send back only the procedure results
	select @ErrorClass as ErrorClass, @ErrorType as ErrorType, @ErrorCode as ErrorCode ;
	GOTO ProcEnd;


NormalEnd:		-- Normal end of procedure. Return procedure results and data
	select @ErrorClass as ErrorClass, @ErrorType as ErrorType, @ErrorCode as ErrorCode ;

	select @PFCItem as FoundItem, 
		@ParentProdNo as ParentProdNo,
		@ItemDesc as ItemDesc, 
		@ItemCategory as ItemCategory,
		@CatDesc as CatDesc, 
		@ItemQty as ItemQty,
		@ItemUOM as ItemUOM, 
		@PriceUM as PriceUM,
		@CostUM as CostUM,
		@SellGlued as SellGlued,
		@SuperQty as SuperQty,
		@SuperUOM as SuperUM,
		@SuperGlued as SuperGlued,
		@LowProfileQty as LowProfileQty,
		@AltQty as AltQtyPerUM,
		@AltUOM as AltPriceUM,
		@NetWght as NetWght,
		@GrossWght as GrossWght, 
		@HundredWght as HundredWght,
		@ListPrice as ListPrice,
		@Tariff as Tariff,
		@UPC as UPC,
		@CostGlued as CostGlued,
		@PackageGroup as PackageGroup,
		@Finish as Finish,
		@CorpFixedVelocity as CorpFixedVelocity,
		@CatVelocityCd as CatVelocityCd,
		@PPI as PPI,
		'' as StockInd,
		@Created as Created,
		@WebEnabled as WebEnabled,
		@CPROk as CPROk,
		@PackageVelocity as PackageVelocity
		;
	-- now the grid data
	SELECT LocID  
		,LocName
		,LocType
		,Case when isnull(LocMaster.ROPDays,0) = 0 then 0 else (ReOrderPoint/LocMaster.ROPDays)*30 end as Use30D
		,SalesVelocityCd as SVCode
		,isnull(CatVelocityCd,'') as CatVCode
		,ReOrderPoint as ROP
		,Avail
		,QOH
		,-1 * Sales as Sales
		,-1 * TransOut as TransOut
		,-1 * Back as Back
		,PO
		,OTW
		,WO
		,RO
		,TransIn
		,AvgCost
		,isnull(LastLandedCost, 0) as LastCost
		,StdCost
		,coalesce(CurrentReplacementCost, ReplacementCost, 0) as ReplCost
		,AvgCost * QtyPerUM as SellAvgCost
		,isnull(LastLandedCost, 0) * QtyPerUM as SellLastCost
		,StdCost * QtyPerUM as SellStdCost
		,coalesce(CurrentReplacementCost, ReplacementCost, 0) * QtyPerUM as SellReplCost
		,convert(varchar(30), convert(decimal(18,2), AvgCost)) + '/' + @ItemUOM as AvgGlued
		,convert(varchar(30), convert(decimal(18,2), AvgCost * QtyPerUM)) + '/' + @AltUOM as SellAvgGlued
		,convert(varchar(30), convert(decimal(18,2), isnull(LastLandedCost, 0) * QtyPerUM)) + '/' + @AltUOM as SellLastGlued
		,convert(varchar(30), convert(decimal(18,2), PriceCost * QtyPerUM)) + '/' + @AltUOM as SellStdGlued
		,convert(varchar(30), convert(decimal(18,2), coalesce(ReplacementCost, 0) * QtyPerUM)) + '/' + @AltUOM as SellReplGlued
		,QtyPerUM
		,case StockInd when 1 then 'Yes' else 'No' end as Stocked
		,SortKey = isnull(IMBranchSort,0)
		,IMDisplayColor = isnull(IMDisplayColor,'B')
		,LocMaster.ROPDays
		FROM LocMaster WITH (NOLOCK)
		left outer join 
		(
			select 
			ItemNo
			,Location
			,Avail = sum(case rtrim(SourceCd)
				when 'SO' then Qty
				when 'TO' then Qty
				when 'OH' then Qty
				when 'RE' then Qty
				when 'NA' then Qty
				else 0 end)
			,QOH = sum(case rtrim(SourceCd)
				when 'OH' then Qty
				when 'RE' then Qty
				when 'NA' then Qty
				else 0 end)
			,Sales = sum(case 
				when rtrim(SourceCd)='SO' and isnull(StatusCd,'')<>'BO' then Qty
				else 0 end)
			,TransOut = sum(case rtrim(SourceCd)
				when 'TO' then Qty
				else 0 end)
			,Back = sum(case 
				when rtrim(SourceCd)='SO' and isnull(StatusCd,'')='BO' then Qty
				else 0 end)
			,TransIn = sum(case rtrim(SourceCd)
				when 'TI' then Qty
				else 0 end)
			,OTW = sum(case rtrim(SourceCd)
				when 'OW' then Qty
				else 0 end)
			,PO = sum(case rtrim(SourceCd)
				when 'PO' then Qty
				else 0 end)
			,WO = sum(case rtrim(SourceCd)
				when 'WO' then Qty
				else 0 end)
			,RO = sum(case rtrim(SourceCd)
				when 'RG' then Qty
				else 0 end)
			from SumItem WITH (NOLOCK)
			where ItemNo=@SearchItemNo
			group by ItemNo, Location
		) ItemQtys
		on ItemQtys.Location = LocID
		left outer join ItemBranch WITH (NOLOCK) 
		on ItemBranch.Location  = LocID
			and fItemMasterID = @ItemID
		inner join ItemUM WITH (NOLOCK)
			on ItemUM.fItemMasterID = @ItemID
			and UM = @AltUOM
		where rtrim(LocType) = 'B'
			--and ItemNo=@SearchItemNo
		order by IMBranchSort
;
ProcEnd:
-- final clean up

END
