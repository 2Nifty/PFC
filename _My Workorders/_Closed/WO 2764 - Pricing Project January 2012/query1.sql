--exec sp_columns ItemBranch


select * from Itemmaster where ItemNo='00200-2400-021'

select CostBasis, * from Itembranch where fItemMasterID=53799 and Location=15

update ItemBranch
set CostBasis='SA'
where fItemMasterID=53811




exec pSOEGetItemAlias '00200-2400-021', '555555', '15', 'Alias'

exec pSOEGetItemAlias '00200-2400-021', '555555', '15', 'PFC'



select * from ItemMaster where pitemmasterid=53811 or pitemmasterid=53799

	--print	'Get other data: ID=' + cast(@ItemID as varchar(20)) + ' - Loc=' + cast(@PrimaryBranch as varchar(20));
	SELECT	fItemMasterID
			,ReplacementCost
			,StdCost
			,SalesVelocityCd
			,CatVelocityCd
			,StockInd
			,CostBasis
	FROM	ItemBranch WITH (NOLOCK)
	WHERE	(ItemBranch.fItemMasterID = 53811 or fitemmasterid=53799) and Location = '15';
--	print	'CostBasis=' + cast(@CostBasis as varchar(20));