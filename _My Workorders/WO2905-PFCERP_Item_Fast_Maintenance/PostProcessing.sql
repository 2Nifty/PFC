--We need one set for NUMERIC and one set for ALPHA


	--------------------------------------
	--  Post-Processing Data Validation  --
	--------------------------------------
	PRINT	''
	PRINT	'--Processing ItemMaster.' + @FieldName
	PRINT	'--BEGIN Pre-Processing Data Validation'

	SET	@UpdType = 'ALPHA'
	IF (@FieldName = 'CatDesc')
	  BEGIN
		--TMD (???): Does CatDesc need to validate against the Cateogry table?
		PRINT	'----??? Validate CatDesc ???'
	  END
	IF (@FieldName = 'ItemSize')
	  BEGIN
		PRINT	'----No Pre-Processing Data Validation Required'
	  END
	IF (@FieldName = 'Finish')	--Plating
	  BEGIN
		PRINT	'----Validate against CatalogPlating table'
		UPDATE	tIMFastMaintTest
		SET		ExceptionInd = 1,
				ExceptionMsg = 'Plating Code not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT [CODE] FROM CatalogPlating (NOLOCK))
											--^We might want to put some/all of these validation tables into a temp table up front
	  END
	IF (@FieldName = 'DiameterDesc')
	  BEGIN
		PRINT	'----No Pre-Processing Data Validation Required'
	  END
	IF (@FieldName = 'LengthDesc')
	  BEGIN
		PRINT	'----No Pre-Processing Data Validation Required'
	  END
	IF (@FieldName = 'CustNo')
	  BEGIN
		PRINT	'----Zero pad Customer Number'
		UPDATE	tIMFastMaintTest
		SET		NewData = RIGHT('000000'+isnull(NewData,''),6)
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0

		PRINT	'----Validate against CustomerMaster table'
		UPDATE	tIMFastMaintTest
		SET		ExceptionInd = 1,
				ExceptionMsg = 'Customer Number not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT CustNo FROM CustomerMaster (NOLOCK))
											--^We might want to put some/all of these validation tables into a temp table up front
	  END
	IF (@FieldName = 'BoxSize')	--RoutingNo
	  BEGIN
		PRINT	'----Zero pad Routing Number'
		UPDATE	tIMFastMaintTest
		SET		NewData = RIGHT('000'+isnull(NewData,''),3)
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0

		PRINT	'----Validate against ItemMaster table WHERE ItemStat=M'
		UPDATE	tIMFastMaintTest
		SET		ExceptionInd = 1,
				ExceptionMsg = 'Routing Number not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT rtrim(ItemNo) FROM ItemMaster (NOLOCK) WHERE ItemStat = 'M')
											--^We might want to put some/all of these validation tables into a temp table up front
	  END
	IF (@FieldName = 'PPICode')
	  BEGIN
		PRINT	'----Validate against ListMaster/Detail (ItemPPICd)'
		UPDATE	tIMFastMaintTest
		SET		ExceptionInd = 1,
				ExceptionMsg = 'PPI Code not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT ListValue FROM ListMaster (NOLOCK) INNER JOIN ListDetail (NOLOCK) ON pListMasterID=fListMasterID WHERE ListName='ItemPPICd')
											--^We might want to put some/all of these validation tables into a temp table up front
	  END
	IF (@FieldName = 'Tariff')	--Harmonizing Code
	  BEGIN
		PRINT	'----Validate against TABLES table (GERTARIFF)'
		UPDATE	tIMFastMaintTest
		SET		ExceptionInd = 1,
				ExceptionMsg = 'Harmonizing Tariff Code not valid'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0 AND
				isnull(NewData,'') NOT IN (SELECT DISTINCT Dsc FROM TABLES (NOLOCK) WHERE TableType='GERTARIFF')
											--^We might want to put some/all of these validation tables into a temp table up front
	  END
	IF (@FieldName = 'WebEnabledInd')
	  BEGIN
		--TMD (???): 0 or 1 - we should translate to TRUE/FALSE or YES/NO
		PRINT	'----??? 0 or 1 - we should translate to TRUE/FALSE or YES/NO ???'
	  END
	IF (@FieldName = 'CertRequiredInd')
	  BEGIN
		--TMD (???): 0 or 1 - we should translate to TRUE/FALSE or YES/NO
		PRINT	'----??? 0 or 1 - we should translate to TRUE/FALSE or YES/NO ???'
	  END
	IF (@FieldName = 'HazMatInd')
	  BEGIN
		--TMD (???): 0 or 1 - we should translate to TRUE/FALSE or YES/NO
		PRINT	'----??? 0 or 1 - we should translate to TRUE/FALSE or YES/NO ???'
	  END
	IF (@FieldName = 'QualityInd')	--FQA Item
	  BEGIN
		--TMD (???): 0 or 1 - we should translate to TRUE/FALSE or YES/NO
		PRINT	'----??? 0 or 1 - we should translate to TRUE/FALSE or YES/NO ???'
	  END
	IF (@FieldName = 'PalPtnrInd')	--Pallet Partner
	  BEGIN
		--TMD (???): 0 or 1 - we should translate to TRUE/FALSE or YES/NO
		PRINT	'----??? 0 or 1 - we should translate to TRUE/FALSE or YES/NO ???'
	  END


	IF (@FieldName = 'PCLBFTInd')
	  BEGIN
		--TMD (Validate): Use ListMaster/Detail (ItemCalcUOM)
		PRINT	'----Validate against ListMaster/Detail'
	  END
	IF (@FieldName = 'SellStkUM')	--Base UOM
	  BEGIN
		--TMD (Validate): Use ListMaster/Detail (UMName)
		PRINT	'----Validate against ListMaster/Detail'
	  END
	IF (@FieldName = 'SellUM')
	  BEGIN
		--TMD (Validate): Use ListMaster/Detail (SellPurUOM)
		PRINT	'----Validate against ListMaster/Detail'
	  END
	IF (@FieldName = 'CostPurUM')	--PurchUM
	  BEGIN
		--TMD (Validate): Use ListMaster/Detail (SellPurUOM)
		PRINT	'----Validate against ListMaster/Detail'
	  END
	IF (@FieldName = 'SuperUM')
	  BEGIN
		--TMD (Validate): Use ListMaster/Detail (SuperEquivUOM)
		PRINT	'----Validate against ListMaster/Detail'
	  END




----NUMERIC FIELDS

	IF (@FieldName = 'ListPrice')
	  BEGIN
		PRINT	'----Validate Numeric'
		UPDATE	tIMFastMaintTest
		SET		ExceptionInd = 9,
				ExceptionMsg = 'List price value must be numeric'
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0 AND
				ISNUMERIC(NewData) <> 1

		PRINT	'----Convert to DECIMAL(18,6)'
		SET		@UpdType = 'NUMERIC'
		UPDATE	tIMFastMaintTest
		SET		NumericData = CAST(isnull(NewData,'0') as DECIMAL(18,6))
		WHERE	isnull(DataField,'') = @FieldName AND isnull(EntryID,'') = @UserID AND
				isnull(CompleteID,'') = '' AND isnull(ExceptionInd,0) = 0
	  END
	IF (@FieldName = 'HundredWght')
	  BEGIN
		--TMD (Validate): Numeric
		PRINT	'----Validate Numeric'
	  END
	IF (@FieldName = 'Wght')	--Net Wght
	  BEGIN
		--TMD (Validate): Numeric
		PRINT	'----Validate Numeric'
	  END


	IF (@FieldName = 'PcsPerPallet')
	  BEGIN
		--TMD (Validate): Numeric
		--TMD (???): Is it PcsPerPallet or SellStkUMQty that he wants to 'adjust' ... or the SuperUMQty ... or all?
		PRINT	'----Validate Numeric'
	  END




	PRINT	'--END Pre-Processing Data Validation'