drop procedure pMaintCustPriceSched
go

CREATE  procedure [dbo].[pMaintCustPriceSched]
@Mode varchar(20),		--Select, Add, Update, Delete, Dup, Item
@CustPriceID numeric(9,0),	--CustomerPrice record ID used for Update & Delete
@ContractID varchar(20),	--CustomerPrice ContractID used for Select
@ItemNo varchar(20),		--CustomerPrice data field used for Add/Update
@PriceMethod char(2),		--CustomerPrice data field used for Add/Update
@EffDt varchar(50),		--CustomerPrice data field used for Add/Update
@AltSellPrice money,		--CustomerPrice data field used for Add/Update
@ContractPrice money,		--CustomerPrice data field used for Add/Update
@DiscPct float,			--CustomerPrice data field used for Add/Update
@PriceMethodFut char(2),	--CustomerPrice data field used for Add/Update
@EffDtFut varchar(50),		--CustomerPrice data field used for Add/Update
@AltSellPriceFut money,		--CustomerPrice data field used for Add/Update
@ContractPriceFut money,	--CustomerPrice data field used for Add/Update
@DiscPctFut float,		--CustomerPrice data field used for Add/Update
@UserName varchar(50)		--EntryID/ChangeID for Add/Update

as

----pMaintCustPriceSched
----Written By: Tod Dixon
----Application: Maintenance Apps

--Select mode
IF (@Mode = 'Select')
   BEGIN
	--SELECT the records from the Database for the selected @ContractID
	SELECT	pCustomerPriceID,
		CustNo as ContractID,
		CustomerPrice.ItemNo,
		ISNULL(ItemUM.ItemDesc,'') as ItemDesc,
		ISNULL(ItemUM.CatDesc,'') as CatDesc,
		ISNULL(ItemUM.ItemSize,'') as ItemSize,
		ISNULL(ItemUM.SellUM,'') as SellUM,
		ISNULL(ItemUM.SellStkUM,'') as SellStkUM,
		ISNULL(ItemUM.AltSellStkUMQty,1) as AltSellStkUMQty,
		LTRIM(RTRIM(PriceMethod)) as PriceMethod,
		CASE CAST(FLOOR(CAST(EffDt AS FLOAT)) AS DATETIME)
		     WHEN '1753-01-01' THEN null
		     ELSE EffDt
		END AS EffDt,
		ISNULL(AltSellPrice,0) as AltSellPrice,
		ISNULL(ContractPrice,0) as SellPrice,
--		ISNULL(DiscPct,0) * 0.01 as DiscPct,
		ISNULL(DiscPct,0) as DiscPct,
		LTRIM(RTRIM(FutPriceMetod)) as FutPriceMethod,
		CASE CAST(FLOOR(CAST(FutEffDt AS FLOAT)) AS DATETIME)
		     WHEN '1753-01-01' THEN null
		     ELSE FutEffDt
		END AS FutEffDt,
		ISNULL(FutAltSellPrice,0) as FutAltSellPrice,
		ISNULL(FutContractPrice,0) as FutSellPrice,
--		ISNULL(FutDiscPct,0) * 0.01 as FutDiscPct,
		ISNULL(FutDiscPct,0) as FutDiscPct,
		EntryID,
		EntryDt,
		ChangeID,
		ChangeDt
	FROM	CustomerPrice (NoLock) LEFT OUTER JOIN
		(SELECT	Item.ItemNo, Item.ItemDesc, Item.CatDesc, Item.ItemSize,
			Item.SellUM, Item.SellStkUM, UM.UM, UM.AltSellStkUMQty
		 FROM	ItemMaster Item (NoLock) LEFT OUTER JOIN
			ItemUM UM (NoLock)
		 ON	Item.pItemMasterID = UM.fItemMasterID AND Item.SellUM = UM.UM) ItemUM
	ON	CustomerPrice.ItemNo = ItemUM.ItemNo
	WHERE	CustNo = @ContractID
   END

IF (@Mode = 'Add')
   BEGIN
	--INSERT the new record into the Database
	INSERT INTO	CustomerPrice
			(CustNo, ItemNo, PriceMethod, FutPriceMetod,
			 EffDt, FutEffDt, AltSellPrice, FutAltSellPrice,
			 ContractPrice, FutContractPrice, DiscPct, FutDiscPct,
			 EntryID, EntryDt)
			VALUES
			(@ContractID, @ItemNo, @PriceMethod, @PriceMethodFut,
			 CAST(@EffDt AS DATETIME), CAST(@EffDtFut AS DATETIME), @AltSellPrice, @AltSellPriceFut,
			 @ContractPrice, @ContractPriceFut, @DiscPct, @DiscPctFut,
			 @UserName, GETDATE())

	--SELECT the newly added record from the Database
	SELECT	pCustomerPriceID,
		CustNo as ContractID,
		CustomerPrice.ItemNo,
		ISNULL(ItemUM.ItemDesc,'') as ItemDesc,
		ISNULL(ItemUM.CatDesc,'') as CatDesc,
		ISNULL(ItemUM.ItemSize,'') as ItemSize,
		ISNULL(ItemUM.SellUM,'') as SellUM,
		ISNULL(ItemUM.SellStkUM,'') as SellStkUM,
		ISNULL(ItemUM.AltSellStkUMQty,1) as AltSellStkUMQty,
		LTRIM(RTRIM(PriceMethod)) as PriceMethod,
		CASE CAST(FLOOR(CAST(EffDt AS FLOAT)) AS DATETIME)
		     WHEN '1753-01-01' THEN null
		     ELSE EffDt
		END AS EffDt,
		ISNULL(AltSellPrice,0) as AltSellPrice,
		ISNULL(ContractPrice,0) as SellPrice,
--		ISNULL(DiscPct,0) * 0.01 as DiscPct,
		ISNULL(DiscPct,0) as DiscPct,
		LTRIM(RTRIM(FutPriceMetod)) as FutPriceMethod,
		CASE CAST(FLOOR(CAST(FutEffDt AS FLOAT)) AS DATETIME)
		     WHEN '1753-01-01' THEN null
		     ELSE FutEffDt
		END AS FutEffDt,
		ISNULL(FutAltSellPrice,0) as FutAltSellPrice,
		ISNULL(FutContractPrice,0) as FutSellPrice,
--		ISNULL(FutDiscPct,0) * 0.01 as FutDiscPct,
		ISNULL(FutDiscPct,0) as FutDiscPct,
		EntryID,
		EntryDt,
		ChangeID,
		ChangeDt
	FROM	CustomerPrice (NoLock) LEFT OUTER JOIN
		(SELECT	Item.ItemNo, Item.ItemDesc, Item.CatDesc, Item.ItemSize,
			Item.SellUM, Item.SellStkUM, UM.UM, UM.AltSellStkUMQty
		 FROM	ItemMaster Item (NoLock) LEFT OUTER JOIN
			ItemUM UM (NoLock)
		 ON	Item.pItemMasterID = UM.fItemMasterID AND Item.SellUM = UM.UM) ItemUM
	ON	CustomerPrice.ItemNo = ItemUM.ItemNo
	WHERE	CustNo = @ContractID AND
		CustomerPrice.ItemNo = @ItemNo
   END

IF (@Mode = 'Update')
   BEGIN
	--UPDATE the current record in the Database based on @CustPriceID
	UPDATE	CustomerPrice
	SET	PriceMethod = @PriceMethod,
		EffDt = CAST(@EffDt AS DATETIME),
		AltSellPrice = @AltSellPrice,
		ContractPrice = @ContractPrice,
		DiscPct = @DiscPct,
		FutPriceMetod = @PriceMethodFut,
		FutEffDt = CAST(@EffDtFut AS DATETIME),
		FutAltSellPrice = @AltSellPriceFut,
		FutContractPrice = @ContractPriceFut,
		FutDiscPct = @DiscPctFut,
		ChangeID = @UserName,
		ChangeDt = GetDate()
	WHERE	pCustomerPriceID = @CustPriceID
   END

IF (@Mode = 'Delete')
   BEGIN
	--DELETE the selected record from the Database based on @CustPriceID
	DELETE
	FROM	CustomerPrice
	WHERE	pCustomerPriceID = @CustPriceID
   END

IF (@Mode = 'Dup')
   BEGIN
	--Check the Database for duplicates based on @ContractID & @ItemNo
	SELECT	pCustomerPriceID,
		CustNo as ContractID,
		ItemNo
	FROM	CustomerPrice (NoLock)
	WHERE	CustNo = @ContractID AND
		ItemNo = @ItemNo
   END

IF (@Mode = 'Item')
   BEGIN
	--Validate @ItemNo
	SELECT	Item.ItemNo,
		Item.ItemDesc,
		Item.CatDesc,
		Item.ItemSize,
		Item.SellUM,
		Item.SellStkUM,
		ISNULL(UM.UM, Item.SellUM) as UM,
		ISNULL(UM.AltSellStkUMQty, 1) as AltSellStkUMQty
	FROM	ItemMaster Item (NoLock) LEFT OUTER JOIN
		ItemUM UM (NoLock)
	ON	Item.pItemMasterID = UM.fItemMasterID AND Item.SellUM = UM.UM
	WHERE	ItemNo = @ItemNo
   END
GO
