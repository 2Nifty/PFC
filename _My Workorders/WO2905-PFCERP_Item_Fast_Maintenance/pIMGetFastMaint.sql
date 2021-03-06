drop proc [pIMGetFastMaint]
go

/****** Object:  StoredProcedure [dbo].[pIMGetFastMaint]    Script Date: 04/27/2012 13:59:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================
-- Author:	Tod Dixon
-- Created:	2012-Apr-27
-- Desc:	WO2905 - Item Fast Maintenance
-- ==============================================

/*
exec [pIMGetFastMaint]	'00200','00200','~',
						'2400','2400','~',
						'000','999','~',
						'','z','~',
						'','z','~',
						'1970-01-01', '2120-12-31','AFTER'
*/

CREATE PROCEDURE [dbo].[pIMGetFastMaint]
	@StrCat varchar(5),
	@EndCat varchar(5),
	@CatList nvarchar(4000),
	@StrSize varchar(4),
	@EndSize varchar(4),
	@SizeList nvarchar(4000),
	@StrVar varchar(4),
	@EndVar varchar(4),
	@VarList nvarchar(4000),
	@StrHarmCd varchar(20),
	@EndHarmCd varchar(20),
	@HarmCdList nvarchar(4000),
	@StrPPI varchar(30),
	@EndPPI varchar(30),
	@PPIList nvarchar(4000),
	@StrDt datetime,
	@EndDt datetime,
	@DateCtl varchar(10)
AS
BEGIN

	SELECT	DISTINCT
			IM.pItemMasterID as ItemID,
			IM.ItemNo,
			IM.LengthDesc,
			IM.DiameterDesc,
			IM.CatDesc,
			IM.ItemSize,
			IM.Finish,
			IM.ItemDesc,
			IM.CustNo,
			IM.BoxSize,
			IM.PPICode,
			IM.Tariff,
			CASE WHEN isnull(IM.WebEnabledInd,0) = 1 THEN 'Y' ELSE 'N' END as WebEnabledInd,
			CASE WHEN isnull(IM.CertRequiredInd,0) = 1 THEN 'Y' ELSE 'N' END as CertRequiredInd,
			CASE WHEN isnull(IM.HazMatInd,0) = 1 THEN 'Y' ELSE 'N' END as HazMatInd,			--Prop65
			CASE WHEN isnull(IM.QualityInd,0) = 1 THEN 'Y' ELSE 'N' END as QualityInd,			--FQA
			CASE WHEN isnull(IM.PalPtnrInd,0) = 1 THEN 'Y' ELSE 'N' END as PalPtnrInd,
			IM.ListPrice,
			IM.HundredWght,
			IM.Wght,
			IM.SellStkUM,
			IM.SellUM,
			IM.CostPurUM,
			IM.SuperUM,
			CASE WHEN IM.SellStkUMQty = 0
				 THEN 0
				 ELSE IM.PcsPerPallet / IM.SellStkUMQty
			END as PcsPerPallet,	--SuperUMQty
			isnull(IM.EntryID,'') as EntryID,
			IM.EntryDt,
			isnull(IM.ChangeID,'') as ChangeID,
			IM.ChangeDt,
			isnull(IM.DeleteID,'') as DeleteID,
			IM.DeleteDt

	FROM	ItemMaster IM (NoLock)
	WHERE	--Category
			((isnull(LEFT(IM.ItemNo,5),'') BETWEEN @StrCat AND @EndCat) or
			  CHARINDEX(isnull(LEFT(IM.ItemNo,5),''), @CatList) > 0) and

			--Size
			((isnull(substring(IM.ItemNo,7,4),'') BETWEEN @StrSize AND @EndSize) or
			  CHARINDEX(isnull(substring(IM.ItemNo,7,4),''), @SizeList) > 0) and

			--Variance
			((isnull(substring(IM.ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or
			 (isnull(substring(IM.ItemNo,12,1),'') = CASE isnull(substring(@StrVar,1,1),'')
															WHEN '?' THEN isnull(substring(IM.ItemNo,12,1),'')
																	 ELSE isnull(substring(@StrVar,1,1),'')
													 END and
			  isnull(substring(IM.ItemNo,13,1),'') = CASE isnull(substring(@StrVar,2,1),'')
															WHEN '?' THEN isnull(substring(IM.ItemNo,13,1),'')
																	 ELSE isnull(substring(@StrVar,2,1),'')
													 END and
			  isnull(substring(IM.ItemNo,14,1),'') = CASE isnull(substring(@StrVar,3,1),'')
															WHEN '?' THEN isnull(substring(IM.ItemNo,14,1),'')
																	 ELSE isnull(substring(@StrVar,3,1),'')
													 END) or
			  CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0) and

			--Harmonizing Code
			((isnull(IM.Tariff,'') BETWEEN @StrHarmCd AND @EndHarmCd) or
			  CHARINDEX(isnull(IM.Tariff,''), @HarmCdList) > 0) and

			--PPI Code
			((isnull(IM.PPICode,'') BETWEEN @StrPPI AND @EndPPI) or
			  CHARINDEX(isnull(IM.PPICode,''), @PPIList) > 0) --and

			--Item Set-up date (EntryDt)
			--(isnull(IM.EntryDt,0) BETWEEN @StrDt AND @EndDt)

	ORDER BY ItemNo

END
