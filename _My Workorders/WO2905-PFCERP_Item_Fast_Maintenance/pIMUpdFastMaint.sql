drop proc [pIMUpdFastMaint]
GO

/****** Object:  StoredProcedure [dbo].[pIMUpdFastMaint]    Script Date: 01/31/2012 11:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pIMUpdFastMaint]
	@TableName	VARCHAR(400),
	@FieldName	VARCHAR(50),
	@UserID		VARCHAR(50)
AS
-- =============================================
-- Author:	Tod Dixon
-- Created:	04/24/2012
-- Desc:	WO2905 - PERP Fast Item Maintenance procedure
-- =============================================

/*

	exec [pIMUpdFastMaint] 't_20120613_IMFastMaint02Update15867tod_CatDesc', 'CatDesc', 'TODtest3'
	exec [pIMUpdFastMaint] 't_20120614_IMFastMaint02Update15871tod_Finish', 'Finish', 'TODtest4'
	exec [pIMUpdFastMaint] 't_20120614_IMFastMaint02Update15871tod_CustNo', 'CustNo', 'TODtestCUST'
	exec [pIMUpdFastMaint] 't_20120614_IMFastMaint02Update15871tod_BoxSize', 'BoxSize', 'TodTestBoxSizeBULK'
	exec [pIMUpdFastMaint] 't_20120614_IMFastMaint02Update15871tod_PPICode', 'PPICode', 'TODtest7'
	exec [pIMUpdFastMaint] 't_20120629_IMFastMaint02Update15980tod_Tariff', 'Tariff', 'TodTestTariff2'
	exec [pIMUpdFastMaint] 't_20120615_IMFastMaint02Update15882tod_ListPrice', 'ListPrice', 'TodTestListPrice'

*/

BEGIN
	SET NOCOUNT ON;

	DECLARE	@Query nvarchar(max)
	DECLARE	@UpdType varchar(10)	--ALPHA or NUMERIC
	DECLARE	@ItemNo	varchar(20)
	DECLARE @ItemID int
	DECLARE @PCLBFTInd varchar(5)
	DECLARE @LockID varchar(50)
	DECLARE @LockStat varchar(5)
	DECLARE @tSoftLockStat TABLE (EntryID varchar(50), Status varchar(5))
	DECLARE	@ItemDataCol varchar(255)
	DECLARE	@OrigDataCol varchar(255)
	DECLARE	@NewDataCol varchar(255)
	DECLARE	@OrigData nvarchar(255)
	DECLARE @NewData nvarchar(255)
	DECLARE @NumericData decimal(18,6)
	DECLARE @RecCount int
	DECLARE @ListName varchar(50)
	DECLARE @Density decimal(18,6)
	DECLARE @MaxLen int
	DECLARE @BaseQtyPer decimal(18,6)
	DECLARE @AltQty decimal(18,6)
	DECLARE @QtyPer decimal(18,6)
	DECLARE @Divisor decimal(18,6)
	DECLARE @NetWght decimal(18,6)
	DECLARE	@emailSubject varchar(255)
	DECLARE	@emailUser varchar(50)

	SET		@emailSubject = '[' + @FieldName + '] Fast Maint ABORT'
	SET		@emailUser = 'it@porteousfastener.com'
	SELECT	@emailUser = EmailAddress FROM SecurityUsers WHERE UserName = @UserID

	------------------------------------------------
	------------------------------------------------
	--  SELECT all modified data from @TableName  --
	--      INTO [IMFastMaint] and then           --
	--         DROP temp table @TableName         --
	------------------------------------------------

	PRINT	'--Update Field = ItemMaster.' + @FieldName
	PRINT	''

	--Should we validate @FieldName as a valid field?
	--SELECT * FROM information_schema.columns WHERE TABLE_NAME = 'ItemMaster' and COLUMN_NAME = @FieldName

	PRINT	'--SET column names'
	SELECT	@ItemDataCol=COLUMN_NAME FROM information_schema.columns WHERE TABLE_NAME = @TableName AND ORDINAL_POSITION = 1
	SELECT	@OrigDataCol=COLUMN_NAME FROM information_schema.columns WHERE TABLE_NAME = @TableName AND ORDINAL_POSITION = 2
	SELECT	@NewDataCol =COLUMN_NAME FROM information_schema.columns WHERE TABLE_NAME = @TableName AND ORDINAL_POSITION = 3
	--select @ItemDataCol as col1, @OrigDataCol as col2, @NewDataCol as col3

	PRINT	'--INSERT all modified data FROM ' + @TableName + ' INTO IMFastMaint table'
	PRINT	'--[Column names: ' + @ItemDataCol + '; ' + @OrigDataCol + '; ' + @NewDataCol + ']'

print 'test'

	SET		@Query = 'INSERT	INTO	IMFastMaint' + char(13) +
					 '				(ItemNo, DataField, ' + char(13) +
					 '				 OriginalData, NewData, ' + char(13) +
					 '				 EntryDt, EntryID)' + char(13) +
					 '		SELECT	 ' + @ItemDataCol + ', ''' + @FieldName + ''' as DataField,' + char(13) +
					 '				 ' + @OrigDataCol + ' as OriginalData, ' + @NewDataCol + ' as NewData,' + char(13) +
					 '				 GetDate() as EntryDt, ''' + @UserID + ''' as EntryID' + char(13) +
					 '		FROM	 ' + @TableName + ' (NOLOCK)' + char(13) +
					 '		WHERE	 isnull([' + @NewDataCol + '],'''') <> '''' AND ' + char(13) +
					 '				 isnull([' + @OrigDataCol + '],'''') <> isnull([' + @NewDataCol + '],'''') COLLATE Latin1_General_CS_AS'
	PRINT	@Query
	EXEC	sp_executesql @Query
--SELECT * FROM IMFastMaint WHERE isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0

	PRINT	''
	PRINT	'--DROP TABLE ' + @TableName
	SET		@Query = 'DROP TABLE ' + @TableName
	print	@Query
	EXEC	sp_executesql @Query

	--------------------------------------
	--  Pre-Processing Data Validation  --
	--------------------------------------
	PRINT	''
	PRINT	'--Processing ItemMaster.' + @FieldName
	PRINT	''
	PRINT	'--BEGIN Pre-Processing Data Validation'

	SET	@UpdType = 'ALPHA'

	--CREATE #tItemUMDivisor for fields that update ItemUM
	IF (@FieldName = 'Wght' OR @FieldName = 'PCLBFTInd' OR @FieldName = 'SellStkUM' OR @FieldName = 'SellUM' OR @FieldName = 'CostPurUM' or @FieldName = 'SuperUM')
	  BEGIN
		--Read the ItemUMDivisor List
		PRINT	'----Create #tItemUMDivisor for ItemUM update'
		SELECT	LD.ListValue as UOM,
				LD.ListDtlDesc as Divisor
		INTO	#tItemUMDivisor
		FROM	ListMaster (NoLock) LM inner join
				ListDetail (NoLock) LD
		ON		LM.pListMasterID = LD.fListMasterID
		WHERE	LM.ListName = 'ItemUMDivisor'
		--select * from #tItemUMDivisor
	  END

	--Validate Numeric Data
	IF (@FieldName = 'ListPrice' OR @FieldName = 'HundredWght' OR @FieldName = 'Wght' OR @FieldName = 'PcsPerPallet')
	  BEGIN
		PRINT	'----Validate ' + @FieldName + ' is Numeric'
		UPDATE	IMFastMaint
		SET		ExceptionInd = 9,
				ExceptionMsg = @FieldName + ' value must be numeric'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
				ISNUMERIC(NewData) <> 1

		PRINT	'----Convert ' + @FieldName + ' to DECIMAL(18,6)'
		SET		@UpdType = 'NUMERIC'
		UPDATE	IMFastMaint
		SET		NumericData = CAST(isnull(NewData,'0') as DECIMAL(18,6))
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0

		PRINT	'----Check for NEGATIVE values'
		UPDATE	IMFastMaint
		SET		ExceptionInd = 9,
				ExceptionMsg = @FieldName + ' value can not be NEGATIVE'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
				isnull(NumericData,0) < 0

		IF (@FieldName = 'HundredWght' OR @FieldName = 'Wght')	--Can not be ZERO
		  BEGIN
			PRINT	'----Check for ZERO values'
			UPDATE	IMFastMaint
			SET		ExceptionInd = 9,
					ExceptionMsg = @FieldName + ' value can not be ZERO'
			WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
					isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
					isnull(NumericData,0) = 0
		  END

		IF (@FieldName = 'PcsPerPallet')	--UPDATE PcsPerPallet = NumericData * SellStkUMQty
		  BEGIN
			PRINT	'----UPDATE PcsPerPallet = NumericData * SellStkUMQty'
			UPDATE	IMFastMaint
			SET		NumericData = FM.NumericData * IM.SellStkUMQty
			FROM	IMFastMaint (NoLock) FM INNER JOIN
					ItemMaster (NoLock) IM
			ON		FM.ItemNo = IM.ItemNo
			WHERE	isnull(FM.DataField,'') = @FieldName AND isnull(FM.EntryID,'') = @UserID AND
					isnull(FM.CompleteID,'') = '' AND isnull(FM.ExceptionInd,0) <= 0
		  END
	  END

	--Validate Check Box Data
	IF (@FieldName = 'WebEnabledInd' OR @FieldName = 'CertRequiredInd' OR @FieldName = 'HazMatInd' OR @FieldName = 'QualityInd' OR @FieldName = 'PalPtnrInd')
	  BEGIN
		PRINT	'----Check boxes: "Y" or "Yes" = 1 - "N" or "No" = 0'
		UPDATE	IMFastMaint
		SET		ExceptionInd = 1,
				ExceptionMsg = @FieldName + ' must equal Y/Yes or N/No'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
				LEFT(isnull(NewData,''),1) NOT IN ('Y','N','1','0')

		PRINT	'----UPDATE "Y" or "Yes" = 1 - "N" or "No" = 0'
		UPDATE	IMFastMaint
		SET		NewData = CASE WHEN LEFT(isnull(NewData,''),1) IN ('Y','1') THEN 1 ELSE 0 END
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 
	  END

	--Validate against ListMaster/ListDetail
	IF (@FieldName = 'PPICode' OR @FieldName = 'PCLBFTInd' OR @FieldName = 'SellStkUM' OR @FieldName = 'SellUM' OR @FieldName = 'CostPurUM' OR @FieldName = 'SuperUM')
	  BEGIN
		IF (@FieldName = 'PPICode')
		  BEGIN
			SET @ListName = 'ItemPPICd'
			PRINT	'----Zero pad PPICode'
			UPDATE	IMFastMaint
			SET		NewData = RIGHT('00000000'+isnull(NewData,''),8)
			WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
					isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0
		  END
		IF (@FieldName = 'PCLBFTInd') SET @ListName = 'ItemCalcUOM'
		IF (@FieldName = 'SellStkUM') SET @ListName = 'UMName'		--BaseUM
		IF (@FieldName = 'SellUM') SET @ListName = 'SellPurUOM'		--SellUM
		IF (@FieldName = 'CostPurUM') SET @ListName = 'SellPurUOM'	--PurchUM
		IF (@FieldName = 'SuperUM') SET @ListName = 'SuperEquivUOM'

		PRINT	'----Validate ' + @FieldName + ' against ListMaster/Detail WHERE ListName=''' + @ListName + ''''
		UPDATE	IMFastMaint
		SET		ExceptionInd = 1,
				ExceptionMsg = @FieldName + ' not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT ListValue FROM ListMaster (NOLOCK) INNER JOIN ListDetail (NOLOCK) ON pListMasterID=fListMasterID WHERE ListName=@ListName)
											--^We might want to put some/all of these validation tables into a temp table up front
	  END

	IF (@FieldName = 'CustNo')
	  BEGIN
		PRINT	'----Zero pad Customer Number'
		UPDATE	IMFastMaint
		SET		NewData = RIGHT('000000'+isnull(NewData,''),6)
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0

		PRINT	'----Validate against CustomerMaster table'
		UPDATE	IMFastMaint
		SET		ExceptionInd = 1,
				ExceptionMsg = 'Customer Number not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT CustNo FROM CustomerMaster (NOLOCK))
											--^We might want to put some/all of these validation tables into a temp table up front
	  END

	IF (@FieldName = 'BoxSize')	--RoutingNo
	  BEGIN
		PRINT	'----Zero pad Routing Number'
		UPDATE	IMFastMaint
		SET		NewData = RIGHT('000'+isnull(NewData,''),3)
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0

		PRINT	'----Validate against ItemMaster table WHERE ItemStat=M'
		UPDATE	IMFastMaint
		SET		ExceptionInd = 1,
				ExceptionMsg = 'Routing Number not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT rtrim(ItemNo) FROM ItemMaster (NOLOCK) WHERE ItemStat = 'M')
											--^We might want to put some/all of these validation tables into a temp table up front
	  END

	IF (@FieldName = 'Tariff')	--Harmonizing Code
	  BEGIN
		PRINT	'----Validate against TABLES table (GERTARIFF)'
		UPDATE	IMFastMaint
		SET		ExceptionInd = 1,
				ExceptionMsg = 'Harmonizing Tariff Code not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT Dsc FROM TABLES (NOLOCK) WHERE TableType='GERTARIFF')
											--^We might want to put some/all of these validation tables into a temp table up front
	  END

	--Validate Alpha fields for truncation
	IF (@FieldName = 'CatDesc' OR @FieldName = 'ItemSize' OR @FieldName = 'Finish' OR @FieldName = 'DiameterDesc' OR @FieldName = 'LengthDesc')
	  BEGIN
		IF (@FieldName = 'CatDesc') SET @MaxLen = 50
		IF (@FieldName = 'ItemSize') SET @MaxLen = 20
		IF (@FieldName = 'Finish') SET @MaxLen = 4
		IF (@FieldName = 'DiameterDesc') SET @MaxLen = 15
		IF (@FieldName = 'LengthDesc') SET @MaxLen = 15

		PRINT	'----Remove single quotes'
		UPDATE	IMFastMaint
		SET		NewData = replace(NewData,'''','')
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID

		PRINT	'----Validate field truncation'
		UPDATE	IMFastMaint
		SET		NewData = left(NewData,@MaxLen),
				ExceptionInd = -9,
				ExceptionMsg = @FieldName + ' was TRUNCATED to ' + cast(@MaxLen as varchar(5)) + ' characters'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
				LEN(isnull(NewData,'')) > @MaxLen

		IF (@FieldName = 'CatDesc')
		  BEGIN
			PRINT	'----Validate CatDesc truncation for full Item Desc build (26 char max)'
			SET		@MaxLen = 26
			UPDATE	IMFastMaint
			SET		ExceptionInd = -9,
					ExceptionMsg = CASE WHEN isnull(ExceptionMsg,'') = ''
										THEN @FieldName + ' was TRUNCATED to ' + cast(@MaxLen as varchar(5)) + ' characters for the full Item Desc build'
										ELSE ExceptionMsg + ' (and to ' + cast(@MaxLen as varchar(5)) + ' characters for the full Item Desc build)'
								   END
			WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
					isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
					LEN(isnull(NewData,'')) > @MaxLen
		  END

		IF (@FieldName = 'Finish')	--Plating
		  BEGIN
			PRINT	'----Validate against CatalogPlating table'
			UPDATE	IMFastMaint
			SET		ExceptionInd = 1,

					ExceptionMsg = CASE WHEN isnull(ExceptionMsg,'') = ''
										THEN 'Plating Code not valid'
										ELSE ExceptionMsg + ' and Plating Code not valid'
								   END
			WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
					isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0 AND
					isnull(NewData,'') NOT IN (SELECT DISTINCT [CODE] FROM CatalogPlating (NOLOCK))
												--^We might want to put some/all of these validation tables into a temp table up front
		  END
	  END
	PRINT	'--END Pre-Processing Data Validation'
--SELECT * FROM IMFastMaint WHERE isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0

	-------------------------
	--  Primary UPDATE(S)  --
	-------------------------
	PRINT	''
	PRINT	'--BEGIN Primary UPDATE [' + @UpdType + '] Build the CURSOR based on the Update Type'
	IF (@UpdType = 'NUMERIC')
	  BEGIN
		DECLARE c1 CURSOR FOR
				SELECT	ItemNo, OriginalData, isnull(NumericData,0) as NewData
				FROM	IMFastMaint
				WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0
		OPEN c1
		FETCH NEXT FROM c1 INTO @ItemNo, @OrigData, @NumericData
	  END
	ELSE
	  BEGIN
		DECLARE c1 CURSOR FOR
				SELECT	ItemNo, OriginalData, isnull(NewData,'') as NewData
				FROM	IMFastMaint
				WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) <= 0
		OPEN c1
		FETCH NEXT FROM c1 INTO @ItemNo, @OrigData, @NewData
	  END

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT	@ItemID = pItemMasterID, @PCLBFTInd = PCLBFTInd FROM ItemMaster (NoLock) WHERE ItemNo = @ItemNo
		PRINT	'----Check for ItemMaster record lock'
		DELETE	@tSoftLockStat
		INSERT	INTO @tSoftLockStat EXEC pSoftLock 'ItemMaster', 'Lock', @ItemID, @UserID, 'FIMM'
		SELECT	@LockID = EntryID, @LockStat = Status FROM @tSoftLockStat
		IF (@LockStat = 'L')
		  BEGIN
			--Record is LOCKED by another user - CREATE Exception
			PRINT	'------Item ' + @ItemNo + ' locked by ' + @LockID
			UPDATE	IMFastMaint
			SET		ExceptionInd = 8,
					ExceptionMsg = 'Item ' + @ItemNo + ' locked by ' + @LockID
			WHERE	CURRENT of c1
		  END
		ELSE
		  BEGIN
			IF (@UpdType = 'NUMERIC')
			  BEGIN
				--Record is NOT locked by another user - Primary UPDATE ItemMaster (Numeric)
				PRINT	'------' + @FieldName + ' (' + @UpdType + ') -- ' + @PCLBFTInd + ' ' + @ItemNo + ' (' + CAST(@ItemID as VARCHAR(50)) + ') -- Orig: ' + @OrigData + ' - New: ' + CAST(@NumericData as VARCHAR(50))
				SET		@Query = char(9) + char(9) + 'UPDATE	ItemMaster' + char(13) +
								 char(9) + char(9) + 'SET		' + @FieldName + ' = ' + CAST(@NumericData as VARCHAR(50)) + ',' + char(13) +
								 char(9) + char(9) + '		ChangeDt = GetDate(),' + char(13) +
								 char(9) + char(9) + '		ChangeID = ''' + @UserID + '''' + char(13) +
								 char(9) + char(9) + 'WHERE	pItemMasterID = ' + CAST(@ItemID as VARCHAR(50))
				print	@Query
				EXEC	sp_executesql @Query
			  END
			ELSE
			  BEGIN
				--Record is NOT locked by another user - Primary UPDATE ItemMaster (Alpha)
				PRINT	'------' + @FieldName + ' (' + @UpdType + ') -- ' + @PCLBFTInd + ' ' + @ItemNo + ' (' + CAST(@ItemID as VARCHAR(50)) + ') -- Orig: ' + @OrigData + ' - New: ' + @NewData
				SET		@Query = char(9) + char(9) + 'UPDATE	ItemMaster' + char(13) +
								 char(9) + char(9) + 'SET		' + @FieldName + ' = ''' + @NewData + ''',' + char(13) +
								 char(9) + char(9) + '		ChangeDt = GetDate(),' + char(13) +
								 char(9) + char(9) + '		ChangeID = ''' + @UserID + '''' + char(13) +
								 char(9) + char(9) + 'WHERE	pItemMasterID = ' + CAST(@ItemID as VARCHAR(50))
				print	@Query
				EXEC	sp_executesql @Query
			  END

			-----------------------------------------------
			--  Post-Processing (update dependent data)  --
			-----------------------------------------------
			IF (@FieldName = 'CatDesc' OR @FieldName = 'ItemSize' OR @FieldName = 'Finish')
			  BEGIN
				PRINT	'------UPDATE ItemDesc = ItemSize + CatDesc + Finish'
				UPDATE	ItemMaster
				SET		ItemDesc = LEFT(isnull(ItemSize,'') + '                    ',20) +
								   LEFT(isnull(CatDesc,'') + '                          ',26) + 
								   LEFT(isnull(Finish,'') + '    ',4),
						ChangeDt = GetDate(),
						ChangeID = @UserID
				WHERE	pItemMasterID = @ItemID
			  END

			IF (@FieldName = 'BoxSize')
			  BEGIN
				SELECT	@Density = IM.DensityFactor
				FROM	ItemMaster (NoLock) IM
				WHERE	IM.ItemStat = 'M' and RTRIM(IM.ItemNo) = RTRIM(@NewData)

				PRINT	'------UPDATE GrossWght using new Routing/BoxSize adder: ' + CAST(isnull(@Density,0) as varchar(20))
				UPDATE	ItemMaster
				SET		GrossWght = Wght + isnull(@Density,0),
						ChangeDt = GetDate(),
						ChangeID = @UserID
				WHERE	pItemMasterID = @ItemID
			  END

			IF (@FieldName = 'HundredWght')
			  BEGIN		--HundredWght
				SELECT	@Density = IM.DensityFactor
				FROM	ItemMaster (NoLock) IM
				WHERE	IM.ItemStat = 'M' and RTRIM(IM.ItemNo) in (SELECT BoxSize FROM ItemMaster WHERE pItemMasterID = @ItemID)

				PRINT	'------Wght/100 Pcs changed: ' + @PCLBFTInd + ' Item'
				IF (@PCLBFTInd = 'LB')
				  BEGIN
					--LB Item - UPDATE PC Record in ItemUM
					PRINT	'--------UPDATE PC Record in ItemUM'
					UPDATE	ItemUM
					SET		AltSellStkUMQty = IM.Wght / IM.HundredWght * 100,
							QtyPerUM = 1 / (IM.Wght / IM.HundredWght * 100),
							ChangeDt = GetDate(),
							ChangeID = @UserID
					FROM	ItemMaster (NoLock) IM
					WHERE	IM.pItemMasterID = @ItemID AND
							IM.pItemMasterID = ItemUM.fItemMasterID AND ItemUM.UM = 'PC'
				  END
				ELSE
				  BEGIN
					--PC/FT Item - UPDATE Net & Gross Wght; Update LB record in ItemUM
					PRINT	'--------UPDATE Net & Gross Wght' 
					UPDATE	ItemMaster
					SET		Wght = SellStkUMQty / 100 * HundredWght,
							GrossWght = (SellStkUMQty / 100 * HundredWght) + isnull(@Density,0),
							ChangeDt = GetDate(),
							ChangeID = @UserID
					WHERE	pItemMasterID = @ItemID

					PRINT	'--------Update LB Record in ItemUM' 
					UPDATE	ItemUM
					SET		AltSellStkUMQty = IM.Wght,
							QtyPerUM = 1 / IM.Wght,
							ChangeDt = GetDate(),
							ChangeID = @UserID
					FROM	ItemMaster (NoLock) IM
					WHERE	IM.pItemMasterID = @ItemID AND
							IM.pItemMasterID = ItemUM.fItemMasterID AND ItemUM.UM = 'LB'
				  END
			  END		--HundredWght

			IF (@FieldName = 'Wght')
			  BEGIN		--NetWght
				SELECT	@Density = IM.DensityFactor
				FROM	ItemMaster (NoLock) IM
				WHERE	IM.ItemStat = 'M' and RTRIM(IM.ItemNo) in (SELECT BoxSize FROM ItemMaster WHERE pItemMasterID = @ItemID)

				PRINT	'------Net Wght changed: ' + @PCLBFTInd + ' Item'

				--PC/LB/FT Item - Update LB record in ItemUM
				PRINT	'--------Update LB Record in ItemUM' 
				UPDATE	ItemUM
				SET		AltSellStkUMQty = IM.Wght,
						QtyPerUM = 1 / IM.Wght,
						ChangeDt = GetDate(),
						ChangeID = @UserID
				FROM	ItemMaster (NoLock) IM
				WHERE	IM.pItemMasterID = @ItemID AND
						IM.pItemMasterID = ItemUM.fItemMasterID AND ItemUM.UM = 'LB'

				IF (@PCLBFTInd = 'LB')
				  BEGIN
					--LB Item - Update Base Qty & Gross; UPDATE PC Record & Recalc UOMs
					PRINT	'--------Update Base Qty, PcsPerPallet & Gross Wght'
					UPDATE	ItemMaster
					SET		GrossWght = Wght + isnull(@Density,0),
							SellStkUMQty = Wght,
							PcsPerPallet = Wght * (PcsPerPallet / SellStkUMQty),
							ChangeDt = GetDate(),
							ChangeID = @UserID
					WHERE	pItemMasterID = @ItemID

					PRINT	'--------Update PC Record in ItemUM'
					UPDATE	ItemUM
					SET		AltSellStkUMQty = IM.Wght / IM.HundredWght * 100,
							QtyPerUM = 1 / (IM.Wght / IM.HundredWght * 100),
							ChangeDt = GetDate(),
							ChangeID = @UserID
					FROM	ItemMaster (NoLock) IM
					WHERE	IM.pItemMasterID = @ItemID AND
							IM.pItemMasterID = ItemUM.fItemMasterID AND ItemUM.UM = 'PC'

					PRINT	'--------Get Base Qty Per'
					SELECT	@BaseQtyPer = isnull(UM.QtyPerUM,0)
					FROM	ItemMaster IM (NoLock) INNER JOIN
							ItemUM UM (NoLock)
					ON		IM.pItemMasterID = UM.fItemMasterID AND IM.PCLBFTInd = UM.UM
					WHERE	IM.pItemMasterID = @ItemID

					PRINT	'--------Recalc UOMs - Base Qty Per=' + cast(@BaseQtyPer as varchar(20))
					UPDATE	ItemUM
					SET		AltSellStkUMQty = IM.SellStkUMQty / tDiv.Divisor,
							QtyPerUM = tDiv.Divisor * @BaseQtyPer,
							ChangeDt = GetDate(),
							ChangeID = @UserID
					FROM	ItemMaster IM (NoLock) INNER JOIN
							ItemUM UM (NoLock)
					ON		IM.pItemMasterID = UM.fItemMasterID INNER JOIN
							#tItemUMDivisor tDiv (NoLock)
					ON		UM.UM = tDiv.UOM
					WHERE	isnull(tDiv.Divisor,0) <> 0 AND IM.pItemMasterID = @ItemID
				  END
				ELSE
				  BEGIN
					--PC/FT Item - UPDATE Hundred & Gross Wght
					PRINT	'--------UPDATE Hundred & Gross Wght'
					UPDATE	ItemMaster
					SET		HundredWght = Wght * 100 / SellStkUMQty,
							GrossWght = Wght + isnull(@Density,0),
							ChangeDt = GetDate(),
							ChangeID = @UserID
					WHERE	pItemMasterID = @ItemID
				  END
			  END		--NetWght

			IF (@FieldName = 'PCLBFTInd' OR @FieldName = 'SellStkUM' OR @FieldName = 'SellUM' OR @FieldName = 'CostPurUM' or @FieldName = 'SuperUM')
			  BEGIN		--ItemUM Change
				PRINT	'------' + @FieldName + ' changed to ' + @NewData

				--Make sure the ItemUM record exists; If not, create it
				SELECT	@RecCount = COUNT(*) FROM ItemUM WHERE fItemMasterID = @ItemID and UM = @NewData
				IF (@RecCount <= 0)
				  BEGIN		--ItemUM record does not exist
					PRINT	'--------ItemUM record does not exist (create it)'
					PRINT	'--------SET @AltQty & @QtyPer'
					SET		@Divisor = 0
					IF (@NewData = 'LB')
					  BEGIN
							SELECT	@NetWght = Wght FROM ItemMaster IM (NoLock) WHERE pItemmasterID = @ItemID
							SET	@AltQty = @NetWght
							SET	@QtyPer = 1 / @NetWght
					  END
					ELSE
					  BEGIN	--Not LB
						SELECT	@Divisor = Divisor FROM #tItemUMDivisor WHERE UOM = @NewData
						IF (@Divisor = 0)
						  BEGIN	--Divisor
							IF (@FieldName = 'PCLBFTInd')
							  BEGIN
								SET	@AltQty = 1
								SET	@QtyPer = 0
							  END
							ELSE
							  BEGIN
								SET	@AltQty = 0
								IF (@FieldName = 'SuperUM')
								  BEGIN
									SELECT	@QtyPer = CASE WHEN isnull(SellStkUMQty,0) = 0 THEN 0 ELSE PcsPerPallet / SellStkUMQty END
									FROM	ItemMaster (NoLock)
									WHERE	pItemMasterID = @ItemID
								  END
								ELSE
								  BEGIN
									SET	@QtyPer = 1
								  END
							  END
						  END	--Divisor
						ELSE
						  BEGIN	--No Divisor
							SELECT	@BaseQtyPer = isnull(UM.QtyPerUM,0)
							FROM	ItemMaster IM (NoLock) INNER JOIN
									ItemUM UM (NoLock)
							ON		IM.pItemMasterID = UM.fItemMasterID AND IM.PCLBFTInd = UM.UM
							WHERE	IM.pItemMasterID = @ItemID

							SELECT	@AltQty = SellStkUMQty / @Divisor,
									@QtyPer = @Divisor * @BaseQtyPer
							FROM	ItemMaster (NoLock)
							WHERE	pItemMasterID = @ItemID
						  END	--No Divisor
					  END	--Not LB

					--INSERT the record INTO ItemUM
					PRINT	'--------INSERT the ' + @NewData + ' record INTO ItemUM (@AltQty=' + cast(@AltQty as VARCHAR(20)) + ' | @QtyPer=' + cast(@QtyPer as VARCHAR(20)) + ' | Divisor=' + cast(@Divisor as VARCHAR(20)) + ')'
					INSERT INTO	ItemUM	(fItemMasterID, UM, AltSellStkUMQty, QtyPerUM, UnitsPerUnit,
										 Weight, Volume, SequenceNo, EntryID, EntryDt, StatusCd)
								VALUES	(@ItemID, @NewData, @AltQty, @QtyPer, 1,
										 0, 0, 1, @UserID, GetDate(), 0)
				  END		--ItemUM record does not exist

				--UPDATE SellStkUMQty & PcsPerPallet
				IF (@FieldName = 'PCLBFTInd')
				  BEGIN
					PRINT	'--------UPDATE SellStkUMQty & PcsPerPallet'
					UPDATE	ItemMaster
					SET		SellStkUMQty = UM.AltSellStkUMQty,
							PcsPerPallet = CASE WHEN isnull(SellStkUMQty,0) = 0 THEN 0 ELSE UM.AltSellStkUMQty * (PcsPerPallet / SellStkUMQty) END
					FROM	ItemUM UM (NoLock)
					WHERE	pItemMasterID = @ItemID AND pItemMasterID = UM.fItemMasterID AND PCLBFTInd = UM.UM
				  END
			  END		--ItemUM Change

			IF (@FieldName = 'PcsPerPallet')	--Super UOM Qty
			  BEGIN
				PRINT	'------UPDATE Super UOM Qty in ItemUM'
				UPDATE	ItemUM
				SET		QtyPerUM = CASE WHEN isnull(IM.SellStkUMQty,0) = 0 THEN 0 ELSE IM.PcsPerPallet / IM.SellStkUMQty END
				FROM	ItemMaster IM (NoLock)
				WHERE	IM.pItemMasterID = fItemMasterID AND IM.SuperUM = UM
			  END

			PRINT	'------UPDATE CompleteDt and CompleteID'
			UPDATE	IMFastMaint
			SET		CompleteID = @UserID,
					CompleteDt = GetDate()
			WHERE	CURRENT of c1

			PRINT	'------Unlock the ItemMaster record'
			INSERT	INTO @tSoftLockStat EXEC pSoftLock 'ItemMaster', 'Release', @ItemID, @UserID, 'FIMM'
		  END

		IF (@UpdType = 'NUMERIC')
			FETCH NEXT FROM c1 INTO @ItemNo, @OrigData, @NumericData
		ELSE
			FETCH NEXT FROM c1 INTO @ItemNo, @OrigData, @NewData
		PRINT	''
	END
	CLOSE c1
	DEALLOCATE c1
	PRINT	'--END Primary UPDATE'
--SELECT * FROM IMFastMaint WHERE isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID

	PRINT	''
	PRINT	'--BEGIN Process Exceptions'
	PRINT	'----Find Exceptions'
	SELECT	ItemNo,
			rtrim(DataField) as FieldName, 
			rtrim(OriginalData)  as Orig_Value, 
			rtrim(NewData) as New_Value,
			CASE WHEN isnull(ExceptionInd,0) > 0 THEN 'ERROR' ELSE 'WARNING' END as Severity,
			rtrim(ExceptionMsg) as ErrMsg
	INTO	##tExceptions
	FROM	IMFastMaint (NoLock)
	WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND isnull(ExceptionInd,0) <> 0

	If (@@rowcount <> 0)
	  BEGIN
		SET		@emailSubject = '[' + @FieldName + '] Fast Maint Exceptions '
		PRINT	'----Email Exceptions to ' + @emailUser + ' - ' + @emailSubject

		EXEC	msdb.dbo.sp_send_dbmail
				@recipients = @emailUser,
				@subject = @emailSubject,
--				@body=N'test',
				@execute_query_database = 'PERP',
				@query = N'select * from ##tExceptions',
				@attach_query_result_as_file = 1;

		PRINT	'----Mark Exceptions Complete'
		UPDATE	IMFastMaint
		SET		ExceptionInd = 0
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND isnull(ExceptionInd,0) <> 0
	  END
	ELSE
	  BEGIN
		SET		@emailSubject = '[' + @FieldName + '] Fast Maint Success '
		PRINT	'----Email Success to ' + @emailUser + ' - ' + @emailSubject
		EXEC	msdb.dbo.sp_send_dbmail
				@recipients = @emailUser,    
				@subject = @emailSubject
--				@body=N'test'
	  END

	DROP TABLE	##tExceptions
	PRINT	'--END Process Exceptions'
END
