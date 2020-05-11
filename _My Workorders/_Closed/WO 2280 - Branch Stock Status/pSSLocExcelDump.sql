USE [DEVPERP]
GO

drop proc [pSSLocExcelDump]
go


/****** Object:  StoredProcedure [dbo].[pSSLocExcelDump]    Script Date: 03/22/2011 12:10:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pSSLocExcelDump]
	@LocID varchar(10),
	@StrCat char(5),
	@StrSize char(4),
	@StrVar char(3),
	@EndCat char(5),
	@EndSize char(4),
	@EndVar char(3)

AS
BEGIN
-- ======================================================================
-- Author:	Charles Rojas
-- Created:	11/15/2010
-- Mod:		03/22/2011 - TDixon - Create dump for CORP
--								- Add PO, TI and OW Summary columns
-- Desc:	WO2177 Stock status Excel Dump
-- ======================================================================
	SET NOCOUNT ON;

	if (UPPER(@LocID) = 'CORP')
	    BEGIN
			SELECT	@LocID as Location
					,IM.ItemNo
					,IM.CatDesc
					,CONVERT(VARCHAR(30),IM.ItemSize) as ItemSize
					,IM.Finish
					,CONVERT(VARCHAR(30),IM.UPCCd) as UPCCd
					,IM.BoxSize			--Add Routing No once we bring it to ItemMaster
					,IM.SellStkUMQty
					,IM.SellStkUM
					,IM.PcsPerPallet
					,IM.SuperUM
					,'' as SVC
					,'' as ROP
					,'' as ROPDays
					,isnull(StkSts.AvlQty,0) as AvlQty
					,isnull(StkSts.OHQty,0) as OHQty
					,isnull(StkSts.WOQty,0) as WOQty
					,isnull(StkSts.POQty,0) as POQty
					,isnull(StkSts.TIQty,0) as TIQty
					,isnull(StkSts.OWQty,0) as OWQty
					,isnull((SELECT	Top 1 isnull(DocNo,'None')
							 FROM	SumItem SI (NoLock)
							 WHERE	SourceCd = 'WO' and SI.ItemNo = IM.ItemNo),0) as OpenMRPNo
			FROM	ItemMaster IM (NoLock) LEFT OUTER JOIN
					(SELECT	ItemNo
							,sum(CASE rtrim(SourceCd)
									  WHEN 'SO' THEN Qty
									  WHEN 'TO' THEN Qty
									  WHEN 'OH' THEN Qty
									  WHEN 'RE' THEN Qty
									  WHEN 'NA' THEN Qty
									  ELSE 0
								 END) as AvlQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'OH' THEN Qty
									  WHEN 'RE' THEN Qty
									  WHEN 'NA' THEN Qty
									  ELSE 0
								 END) as OHQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'WO' THEN Qty
									  ELSE 0
								 END) as WOQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'PO' THEN Qty
									  ELSE 0
								 END) as POQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'TI' THEN Qty
									  ELSE 0
								 END) as TIQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'OW' THEN Qty
									  ELSE 0
								 END) as OWQty
					 FROM	SumItem SI (NoLock)
					 WHERE	LEFT(ItemNo, 4) <> '9999' AND
							LEFT(ItemNo,5) >= @StrCat AND SUBSTRING(ItemNo,7,4) >= @StrSize AND RIGHT(ItemNo,3) >= @StrVar AND
							LEFT(ItemNo,5) <= @EndCat AND SUBSTRING(ItemNo,7,4) <= @EndSize AND RIGHT(ItemNo,3) <= @EndVar
					 GROUP BY ItemNo) StkSts
			ON		IM.ItemNo = StkSts.ItemNo
			WHERE	LEFT(IM.ItemNo, 4) <> '9999' AND
					LEFT(IM.ItemNo,5) >= @StrCat AND SUBSTRING(IM.ItemNo,7,4) >= @StrSize AND RIGHT(IM.ItemNo,3) >= @StrVar AND
					LEFT(IM.ItemNo,5) <= @EndCat AND SUBSTRING(IM.ItemNo,7,4) <= @EndSize AND RIGHT(IM.ItemNo,3) <= @EndVar
			ORDER BY IM.ItemNo, right(IM.ItemNo, 1)
	    END
	else
		BEGIN
			SELECT	IB.Location
					,IM.ItemNo
					,IM.CatDesc
					,CONVERT(VARCHAR(30),IM.ItemSize) as ItemSize
					,IM.Finish
					,CONVERT(VARCHAR(30),IM.UPCCd) as UPCCd
					,IM.BoxSize			--Add Routing No once we bring it to ItemMaster
					,IM.SellStkUMQty
					,IM.SellStkUM
					,IM.PcsPerPallet
					,IM.SuperUM
					,IB.SalesVelocityCd as SVC
					,Convert(Decimal(18,1), IB.ReOrderPoint) as ROP
					,LM.ROPDays
					,isnull(StkSts.AvlQty,0) as AvlQty
					,isnull(StkSts.OHQty,0) as OHQty
					,isnull(StkSts.WOQty,0) as WOQty
					,isnull(StkSts.POQty,0) as POQty
					,isnull(StkSts.TIQty,0) as TIQty
					,isnull(StkSts.OWQty,0) as OWQty
					,isnull((SELECT	Top 1 isnull(DocNo,'None')
							 FROM	SumItem SI (NoLock)
							 WHERE	SourceCd = 'WO' and SI.ItemNo = IM.ItemNo and SI.Location = IB.Location),0) as OpenMRPNo
			FROM	ItemMaster IM (NoLock) INNER JOIN
					ItemBranch IB (NoLock)
			ON		IM.pItemMasterID = IB.fItemMasterID INNER JOIN
					LocMaster LM (NoLock)
			ON		LM.LocID = IB.Location LEFT OUTER JOIN
					(SELECT	ItemNo
							,Location
							,sum(CASE rtrim(SourceCd)
									  WHEN 'SO' THEN Qty
									  WHEN 'TO' THEN Qty
									  WHEN 'OH' THEN Qty
									  WHEN 'RE' THEN Qty
									  WHEN 'NA' THEN Qty
									  ELSE 0
								 END) as AvlQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'OH' THEN Qty
									  WHEN 'RE' THEN Qty
									  WHEN 'NA' THEN Qty
									  ELSE 0
								 END) as OHQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'WO' THEN Qty
									  ELSE 0
								 END) as WOQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'PO' THEN Qty
									  ELSE 0
								 END) as POQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'TI' THEN Qty
									  ELSE 0
								 END) as TIQty
							,sum(CASE rtrim(SourceCd)
									  WHEN 'OW' THEN Qty
									  ELSE 0
								 END) as OWQty
					 FROM	SumItem SI (NoLock)
					 WHERE	LEFT(ItemNo, 4) <> '9999' AND
							LEFT(ItemNo,5) >= @StrCat AND SUBSTRING(ItemNo,7,4) >= @StrSize AND RIGHT(ItemNo,3) >= @StrVar AND
							LEFT(ItemNo,5) <= @EndCat AND SUBSTRING(ItemNo,7,4) <= @EndSize AND RIGHT(ItemNo,3) <= @EndVar
					 GROUP BY ItemNo, Location
					 HAVING	Location = @LocID) StkSts
			ON		IM.ItemNo = StkSts.ItemNo and StkSts.Location = IB.Location
			WHERE	IB.Location = @LocId AND LEFT(IM.ItemNo, 4) <> '9999' AND
					LEFT(IM.ItemNo,5) >= @StrCat AND SUBSTRING(IM.ItemNo,7,4) >= @StrSize AND RIGHT(IM.ItemNo,3) >= @StrVar AND
					LEFT(IM.ItemNo,5) <= @EndCat AND SUBSTRING(IM.ItemNo,7,4) <= @EndSize AND RIGHT(IM.ItemNo,3) <= @EndVar
			ORDER BY IB.Location, IM.ItemNo, right(IM.ItemNo, 1)
		END
END
