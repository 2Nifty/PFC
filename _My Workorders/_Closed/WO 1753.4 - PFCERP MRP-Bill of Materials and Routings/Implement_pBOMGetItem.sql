USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pBOMGetItem]    Script Date: 02/24/2012 18:06:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pBOMGetItem]
	@ItemNo VARCHAR(20),
	@RecCtl VARCHAR(10)		--'ITEM'	returns Item info
							--'BOM'		returns BOM info
							--'UM'		returns UM info
AS
BEGIN
	-- ================================================
	-- Author:	Tod Dixon
	-- Created:	07/19/2011
	-- Desc:	Bill of Materials get item & check BOM
	-- ================================================

/*

exec pBOMGetItem '00020-2408-020', 'ITEM'
exec pBOMGetItem '00200-2400-401', 'BOM'
exec pBOMGetItem '00020-2408-020', 'UM'

*/

	SET NOCOUNT ON;

	DECLARE	@NextSeqNo int;
	SET @NextSeqNo = 0;

	IF (@RecCtl = 'ITEM')
	   BEGIN
			--Validate the item number
			SELECT	Item.pItemMasterID as ItemID
					,Item.ItemNo as ItemNo
					,left(Item.ItemNo,5) as Category

					,Item.ItemDesc as ItemDesc
					,Item.CatDesc as CatDesc
					,Item.Finish as PltTyp
					,isnull(Item.ParentProdNo,'') as ParentItem

					,Item.HundredWght as [100Wght]
					,Item.Wght as NetWght
					,Item.GrossWght as GrossWght
					,' ' as StockInd

					,Item.SellStkUM as SellStkUM
					-- ??? ,Item.AltUM as AltUM
					,convert(varchar(30),Item.SellStkUMQty) + '/' + Item.SellStkUM as SellStk
					,convert(varchar(30),convert(int,isnull(Super.QtyPerUM,0))) + '/' + Item.SuperUM as SupEqv
					,Item.PriceUM  as PriceUM
					,Item.CostPurUM as CostUM

					,convert(varchar(30),convert(decimal(18,2),Item.ReplacementCostAlt)) + '/' + Item.SellUM as StdCost
					,Item.ListPrice as ListPrice
					,Item.CorpFixedVelocity as CFV
					,isnull(Item.CatVelocityCd,'') as CVC

					,Item.UPCCd as UPCCd
					,Item.Tariff as Tariff
					,isnull(Item.PalPtnrInd,'') as PPI
					,Item.EntryDt as CreateDt

					,case Item.WebEnabledInd when 0 then 'No' else 'Yes' end as WebEnabled
					,Item.PackageGroup as PkgGrp
					,isnull(Item.LowProfilePalletQty,0) as LowProfile
					,Item.PackageVelocityCd as PVC
			FROM	ItemMaster Item (NOLOCK) left outer join
					ItemUM Super (NOLOCK)
			ON		Item.pItemMasterID = Super.fItemMasterID and Item.SuperUM = Super.UM
			WHERE	Item.ItemNo = @ItemNo AND ItemStat <> 'I' AND isnull(Item.DeleteDt,'') = ''
	   END

	IF (@RecCtl = 'BOM')
	   BEGIN
			SELECT	@NextSeqNo = max(isnull(Dtl.SeqNo,0))
			FROM	BOM Hdr (NoLock) left outer join
					BOMDetail Dtl (NoLock)
			ON		Hdr.pBOMID = Dtl.fBOMID
			WHERE	Hdr.ParentItemNo = @ItemNo AND isnull(Hdr.DeleteDt,'') = '' AND isnull(Dtl.DeleteDt,'') = ''

			IF (@NextSeqNo = 0)
			   BEGIN
					SET @NextSeqNo = 100;
			   END
			ELSE
			   BEGIN
					SET @NextSeqNo = @NextSeqNo + 100;
			   END
			--select @NextSeqNo as NextSeqNo

			--Check for BOM records
			SELECT	Hdr.pBOMID as BOMId
					,Hdr.ParentItemNo as BOMParent
					,Hdr.ParentDesc as BOMParentDesc
					,Hdr.ParentUM as BOMParentUM
					,isnull(Hdr.Qty,0) as BOMQty
					,isnull(Hdr.BillType,'') as BOMParentBillType

					,isnull(Dtl.ChildNo,'') as BOMItem
					,isnull(Dtl.ChildDesc,'No Child') as BOMItemDesc
					,isnull(Dtl.QtyPerAssembly,0) as BOMQtyPer
					,isnull(Dtl.BuildUM,'') as BOMUM
					--,convert(varchar(30),convert(decimal(18,2),Dtl.QtyPerAssembly)) + '/' + Dtl.BuildUM as BOMQtyPerUM
					,isnull(Dtl.Remarks,'') as BOMRemarks
					,isnull(Dtl.SeqNo,@NextSeqNo) as BOMSeqNo
					,isnull(Dtl.BillType,'') as BOMBillType
					,@NextSeqNo as NextSeqNo
			FROM	BOM Hdr (NoLock) left outer join
					BOMDetail Dtl (NoLock)
			ON		Hdr.pBOMID = Dtl.fBOMID
			WHERE	Hdr.ParentItemNo = @ItemNo AND isnull(Hdr.DeleteDt,'') = '' AND isnull(Dtl.DeleteDt,'') = ''
			ORDER BY isnull(Dtl.SeqNo,@NextSeqNo)
	   END

	IF (@RecCtl = 'UM')
	   BEGIN
			--Get list of UM Names - #tUMName
			SELECT	LD.ListValue + ' - ' + LD.ListDtlDesc as ListDesc,
					LD.ListValue,
					LD.SequenceNo
			INTO	#tUMName
			FROM	ListMaster LM (NoLock) inner join
					ListDetail LD (NoLock)
			ON		LM.pListMasterID = LD.fListMasterID
			WHERE	LM.ListName = 'UMName'
			--select * from #tUMName

			--TABLE[1] - UM info
			SELECT	Item.ItemNo,
					isnull(ItemUM.UM,'') as UM,
					isnull(tUM.ListDesc,'') as ListDesc,
					isnull(tUM.ListValue,'') as ListValue,
					isnull(ItemUM.AltSellStkUMQty,0) as AltSellStkUMQty,
					isnull(ItemUM.QtyPerUM,0) as QtyPerUM
			FROM	ItemMaster Item (NOLOCK) left outer join
					ItemUM (NOLOCK)
			ON		Item.pItemMasterID = ItemUM.fItemMasterID INNER JOIN
					#tUMName tUM (NOLOCK)
			ON		ItemUM.UM = tUM.ListValue
			WHERE	ItemNo = @ItemNo AND isnull(Item.DeleteDt,'') = ''
		--	WHERE	ItemNo = '00200-2400-401' AND isnull(Item.DeleteDt,'') = ''
			ORDER BY tUM.SequenceNo

			DROP TABLE #tUMName
	   END
END
