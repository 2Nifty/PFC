if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pIMLabelCNV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pIMLabelCNV]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE [dbo].[pIMLabelCNV] AS

DECLARE PWWCursor CURSOR GLOBAL FOR

SELECT DISTINCT (replace(Item.ItemNo,'-','')) as ItemNo,

		--UOM.[Super Equivalent] as SuperEquiv,
		CASE WHEN UOM.UM = Item.SuperUM THEN 1 ELSE 0 END as SuperEquiv,

		--UOM.[Sales Qty Alt_] as ALTQTY,
		CASE WHEN UOM.AltSellStkUMQty = Item.SellStkUMQty THEN 1 ELSE 0 END as ALTQTY,

		Item.ItemSize as [Size No_ Description],
		Item.CatDesc as [Cat_ No_ Description],
		Item.Finish as [Plating Type],
		REPLICATE(' ',6-len(cast (cast (UOM.AltSellStkUMQty as integer) as char(6)))) + (cast (cast (UOM.AltSellStkUMQty as integer) as char(6))) as BaseQty,
		Item.SellStkUM as [Base Unit of Measure],
		'      ' as Whse,
		'       ' as UnitCost,
		REPLICATE(' ',7-len(cast (cast (Item.ListPrice as decimal(7,2)) as char(7)))) + (cast (cast (Item.ListPrice as decimal(7,2)) as char(7))) as [Unit Price],
		Item.UPCCd as [UPC Code],
		'        ' as INVALF,
		'  ' as BOXCODE,
		REPLICATE(' ',6-len(cast (cast (Item.GrossWght as decimal(7,2)) as char(7)))) + (cast (cast (Item.GrossWght as decimal(7,2)) as char(7))) as Gross,
		REPLICATE(' ',7-len(cast (cast (Item.HundredWght as decimal(7,2)) as char(7)))) + (cast (cast (Item.HundredWght as decimal(7,2)) as char(7))) as CWgt,
		'  ' as COUNTRY,
		REPLICATE(' ',6-len(cast (cast (UOM.QtyPerUM as integer) as char(6)))) + (cast (cast (UOM.QtyPerUM as integer) as char(6))) as QTYPERUOM,
		' ' as CorpClass,
		UOM.UM,
		' ' as Basis,
		'       ' as INCOMP,
		'  ' as INCMPD,
		RIGHT(Item.CategoryDescAlt1, 30) as INPKDS1,
		RIGHT(Item.CategoryDescAlt2, 30) as INPKDS2,
		RIGHT(Item.CategoryDescAlt3, 30) as INPKDS3,
		Item.SizeDescAlt1 + '          ' as INPKSZ1,
		'                              ' as INPKSZ2
FROM    ItemMaster Item (NoLock) INNER JOIN
		ItemUM UOM (NoLock)
ON		Item.pItemMasterId = UOM.fItemMasterID
WHERE	isnull(Item.DeleteDt,0) = 0 AND
		Item.ItemStat = 'S' AND
		Item.ItemNo >= '00000-0000-000' AND
		Item.ItemNo <= '99999-9999-999' AND
		Item.ListPrice < 10000  AND
		Item.GrossWght < 10000 AND
		Item.HundredWght < 10000
ORDER BY	(replace(Item.ItemNo,'-',''))

-- Row Holding Variables
DECLARE @ItemNo				varchar(12)
DECLARE @SuperEquiv			varchar(1)
DECLARE @ALTQTY				varchar(1)
DECLARE @SizeDescr			varchar(20)
DECLARE @CatDescr			varchar(25)
DECLARE @PlatingType			varchar(4)
DECLARE @BaseQty			varchar(6)
DECLARE @BaseUOM			varchar(2)
DECLARE @Whse				varchar(6)
DECLARE @UnitCost			varchar(7)
DECLARE @UnitListPrice			varchar(7)
DECLARE @UPC_Code			varchar(12)
DECLARE @INVALF				varchar(8)
DECLARE @BOXCODE			varchar(2)
DECLARE @Gross				varchar(6)
DECLARE @CWgt				varchar(7)
DECLARE @COUNTRY			varchar(2)
DECLARE @QTYPERUOM			varchar(6)
DECLARE @CorpClass			varchar(1)
DECLARE @code_				varchar(10)
DECLARE @Basis				varchar(1)
DECLARE @INCOMP				varchar(7)
DECLARE @INCMPD				varchar(2)
DECLARE @INPKDS1			varchar(30)
DECLARE @INPKDS2			varchar(30)
DECLARE @INPKDS3			varchar(30)
DECLARE @INPKSZ1			varchar(30)
DECLARE @INPKSZ2			varchar(30)

-- Valid values for tempTABLE
DECLARE @outItemNo			varchar(12)
DECLARE @outSizeDescr			varchar(20)
DECLARE @outCatDescr			varchar(25)
DECLARE @outPlatingType			varchar(4)
DECLARE @outBaseQty			varchar(6)
DECLARE @outBaseUOM			varchar(2)
DECLARE @outWhse			varchar(6)
DECLARE @outUnitCost			varchar(7)
DECLARE @outUnitListPrice		varchar(7)
DECLARE @outUPC_Code			varchar(12)
DECLARE @outINVALF			varchar(8)
DECLARE @outBOXCODE			varchar(2)
DECLARE @outGross			varchar(6)
DECLARE @outCWgt			varchar(7)
DECLARE @outCOUNTRY			varchar(2)
DECLARE @outQTYPERUOM			varchar(6)
DECLARE @outCorpClass			varchar(1)
DECLARE @outCode			varchar(1)
DECLARE @outBasis			varchar(1)
DECLARE @outINCOMP			varchar(7)
DECLARE @outINCMPD			varchar(2)
DECLARE @outINPKDS1			varchar(30)
DECLARE @outINPKDS2			varchar(30)
DECLARE @outINPKDS3			varchar(30)
DECLARE @outINPKSZ1			varchar(30)
DECLARE @outINPKSZ2			varchar(30)

DECLARE @checkItem			varchar(12)

OPEN PWWCursor
FETCH NEXT FROM PWWCursor INTO @ItemNo, @SuperEquiv, @ALTQTY, @SizeDescr, @CatDescr, @PlatingType, @BaseQty, @BaseUOM, @Whse, @UnitCost, @UnitListPrice, @UPC_Code, @INVALF, @BOXCODE, @Gross, @CWgt, @COUNTRY, @QTYPERUOM, @CorpClass, @code_, @Basis, @INCOMP, @INCMPD, @INPKDS1, @INPKDS2, @INPKDS3, @INPKSZ1, @INPKSZ2

SET @CheckItem =@ItemNo

SET @outItemNo = @ItemNo
SET @outSizeDescr = @SizeDescr
SET @outCatDescr = @CatDescr
SET @outPlatingType = @PlatingType

SET @outBaseUOM = @BaseUOM
SET @outWhse = @Whse
SET @outUnitCost = @UnitCost
SET @outUnitListPrice = @UnitListPrice
SET @outUPC_Code = @UPC_Code
SET @outINVALF = @INVALF
SET @outBOXCODE = @BOXCODE
SET @outGross = @Gross
SET @outCWgt = @CWgt
SET @outCOUNTRY = @COUNTRY

SET @outCorpClass = @CorpClass
-- SET @outCode = @code_
SET @outCode = ''
SET @outBasis = @Basis
SET @outINCOMP = @INCOMP
SET @outINCMPD = @INCMPD
SET @outINPKDS1 = @INPKDS1
SET @outINPKDS2 = @INPKDS2
SET @outINPKDS3 = @INPKDS3
SET @outINPKSZ1 = @INPKSZ1
SET @outINPKSZ2 = @INPKSZ2

SET @outBaseQTY = '0'
SET @outQTYPERUOM = '0'

WHILE @@FETCH_STATUS=0
   BEGIN

      IF @ItemNo <> @CheckItem
         BEGIN
		INSERT	INTO	 tIMLabelCNV (ItemNo, [Size No_ Description], [Cat_ No_ Description], [Plating Type], BaseQty, [Base Unit of Measure], Whse, UnitCost, [Unit List Price], [UPC Code], INVALF, BOXCODE, Gross, CWgt, COUNTRY, QTYPERUOM, CorpClass, Code, Basis, INCOMP, INCMPD, INPKDS1, INPKDS2, INPKDS3, INPKSZ1, INPKSZ2)
			VALUES	(@outItemNo, @outSizeDescr, @outCatDescr, @outPlatingType, @outBaseQty, @outBaseUOM, @outWhse, @outUnitCost, @outUnitListPrice, @outUPC_Code, @outINVALF, @outBOXCODE, @outGross, @outCWgt, @outCOUNTRY, @outQTYPERUOM, @outCorpClass, @outCode, @outBasis, @outINCOMP, @outINCMPD, @outINPKDS1, @outINPKDS2, @outINPKDS3, @outINPKSZ1, @outINPKSZ2)

		SET @CheckItem =@ItemNo

		SET @outItemNo = @ItemNo
		SET @outSizeDescr = @SizeDescr
		SET @outCatDescr = @CatDescr
		SET @outPlatingType = @PlatingType
		SET @outBaseUOM = @BaseUOM
		SET @outWhse = @Whse
		SET @outUnitCost = @UnitCost
		SET @outUnitListPrice = @UnitListPrice
		SET @outUPC_Code = @UPC_Code
		SET @outINVALF = @INVALF
		SET @outBOXCODE = @BOXCODE
		SET @outGross = @Gross
		SET @outCWgt = @CWgt
		SET @outCOUNTRY = @COUNTRY
		SET @outCorpClass = @CorpClass
--		SET @outCode = @code_
		SET @outCode = ''
		SET @outBasis = @Basis
		SET @outINCOMP = @INCOMP
		SET @outINCMPD = @INCMPD
		SET @outINPKDS1 = @INPKDS1
		SET @outINPKDS2 = @INPKDS2
		SET @outINPKDS3 = @INPKDS3
		SET @outINPKSZ1 = @INPKSZ1
		SET @outINPKSZ2 = @INPKSZ2
		SET @outBaseQTY = '0'
		SET @outQTYPERUOM = '0'
	 END
      
      IF @ALTQTY = '1' SET @outBaseQTY = @BaseQty
      IF @SuperEQUIV = '1' SET @outQTYPERUOM = @QTYPERUOM

      IF @Code_ = 'PC' SET @outCode = 'P'
      IF @Code_ = 'LB' SET @outCode = '#'
      IF @Code_ = 'FT' SET @outCode = 'F'
      
      FETCH NEXT FROM PWWCursor INTO @ItemNo, @SuperEquiv, @ALTQTY, @SizeDescr, @CatDescr, @PlatingType, @BaseQty, @BaseUOM, @Whse, @UnitCost, @UnitListPrice, @UPC_Code, @INVALF, @BOXCODE, @Gross, @CWgt, @COUNTRY, @QTYPERUOM, @CorpClass, @code_, @Basis, @INCOMP, @INCMPD, @INPKDS1, @INPKDS2, @INPKDS3, @INPKSZ1, @INPKSZ2
   END

CLOSE PWWCursor
DEALLOCATE PWWCursor

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

