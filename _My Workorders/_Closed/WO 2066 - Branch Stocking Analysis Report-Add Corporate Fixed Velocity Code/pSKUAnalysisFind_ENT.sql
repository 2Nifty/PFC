
create PROCEDURE [dbo].[pSKUAnalysisFind] 
	-- Add the parameters for the stored procedure here
	@BegCat char(5), 
	@EndCat char(5), 
	@BegPkg char(2), 
	@EndPkg char(2), 
	@BegPlt char(1), 
	@EndPlt char(1),
	@SortKeys varchar(1000)
AS
BEGIN
	SET NOCOUNT ON;
	declare @Loc char(6);
	declare @ColCtr integer;
	declare @SVC char(8);
	declare @Item varchar(20);
	declare @SizeDesc varchar(20);
	declare @CodeKey varchar(20);
	declare @KeyTemp varchar(50);
	declare @KeyPos int;
	declare @SortOrder int;
	if @EndCat = '' set @EndCat = @BegCat
	if @EndPkg = '' set @EndPkg = @BegPkg
	if @EndPlt = '' set @EndPlt = @BegPlt
	if @BegPkg = '' set @EndPkg = '99'
	if @BegPlt = '' set @EndPlt = '9'
	if @BegPkg = '' set @BegPkg = '00'
	if @BegPlt = '' set @BegPlt = '0'
	-- create a table to hold the SKU data
	CREATE TABLE #SKUGrid (
		[Item] varchar(50) NOT NULL ,
		[SizeDesc] varchar(50) NOT NULL default ('') ,
		[Col01] char(8) NOT NULL DEFAULT ('Z'),
		[Col02] char(8) NOT NULL DEFAULT ('Z'),
		[Col03] char(8) NOT NULL DEFAULT ('Z'),
		[Col04] char(8) NOT NULL DEFAULT ('Z'),
		[Col05] char(8) NOT NULL DEFAULT ('Z'),
		[Col06] char(8) NOT NULL DEFAULT ('Z'),
		[Col07] char(8) NOT NULL DEFAULT ('Z'),
		[Col08] char(8) NOT NULL DEFAULT ('Z'),
		[Col09] char(8) NOT NULL DEFAULT ('Z'),
		[Col10] char(8) NOT NULL DEFAULT ('Z'),
		[Col11] char(8) NOT NULL DEFAULT ('Z'),
		[Col12] char(8) NOT NULL DEFAULT ('Z'),
		[Col13] char(8) NOT NULL DEFAULT ('Z'),
		[Col14] char(8) NOT NULL DEFAULT ('Z'),
		[Col15] char(8) NOT NULL DEFAULT ('Z'),
		[Col16] char(8) NOT NULL DEFAULT ('Z'),
		[Col17] char(8) NOT NULL DEFAULT ('Z'),
		[Col18] char(8) NOT NULL DEFAULT ('Z'),
		[Col19] char(8) NOT NULL DEFAULT ('Z'),
		[Col20] char(8) NOT NULL DEFAULT ('Z'),
		[Col21] char(8) NOT NULL DEFAULT ('Z'),
		[Col22] char(8) NOT NULL DEFAULT ('Z'),
		[Col23] char(8) NOT NULL DEFAULT ('Z'),
		[Col24] char(8) NOT NULL DEFAULT ('Z'),
		[Col25] char(8) NOT NULL DEFAULT ('Z'),
		[Col26] char(8) NOT NULL DEFAULT ('Z'),
		[Col27] char(8) NOT NULL DEFAULT ('Z'),
		[Col28] char(8) NOT NULL DEFAULT ('Z'),
		[Col29] char(8) NOT NULL DEFAULT ('Z'),
		[Col30] char(8) NOT NULL DEFAULT ('Z'),
		[Col31] char(8) NOT NULL DEFAULT ('Z'),
		PRIMARY KEY  CLUSTERED 
		( [Item] ) WITH  FILLFACTOR = 85  ON [PRIMARY] 
	) ON [PRIMARY]
	-- create a table to hold the Sort Keys
	CREATE TABLE #SKUKeys (
		Code varchar(50) COLLATE Latin1_General_CS_AS NOT NULL ,
		SortKey int NOT NULL DEFAULT (0),
		PRIMARY KEY  CLUSTERED 
		( Code ) WITH  FILLFACTOR = 85  ON [PRIMARY] 
	) ON [PRIMARY]
	-- fill the table with the keys
	while len(@SortKeys) >= 3
	begin
		set @KeyTemp = substring(@SortKeys,1,charindex(':',@SortKeys));
		set @CodeKey = substring(@KeyTemp,1,charindex(';',@SortKeys)-1);
		set @SortOrder = convert(int,substring(@KeyTemp,charindex(';',@SortKeys)+1,charindex(':',@SortKeys)-charindex(';',@SortKeys)-1));
		--set @KeyPos = charindex(':',@SortKeys);
		set @SortKeys = right(@SortKeys,len(@SortKeys)-charindex(':',@SortKeys))
		insert into #SKUKeys values (@CodeKey, @SortOrder);
		--print '@CodeKey=' + @CodeKey + '  @SortOrder=' + convert(varchar, @SortOrder); 
	end;
	-- get the column headings
	select 
	[Location Code] as Loc
	into #SKULocs
	from [Porteous$Stockkeeping Unit] WITH (NOLOCK)
	inner join #SKUKeys
	on Code = [Location Code]
	where substring([Item No_], 1, 5) between @BegCat and @EndCat
	and substring([Item No_], 12, 2) between @BegPkg and @EndPkg
	and substring([Item No_], 14, 1) between @BegPlt and @EndPlt
	group by [Location Code], SortKey
	order by SortKey;
	-- now go though the locs
	declare SKUFix cursor  for
		select Loc from #SKULocs;
	OPEN SKUFix;
	FETCH NEXT FROM SKUFix into @Loc;
	set @ColCtr = 1;
	WHILE @@FETCH_STATUS = 0
		-- find matching items
		BEGIN
		declare SKUItems cursor  for
			select 
			[Item No_] as Item
			,[Size No_ Description] as SizeDesc
			,case [Sales Velocity Code]
				when 'N' then convert(char(8), convert(decimal(9,1),SKU.[Reorder Point]))
				else [Sales Velocity Code] end as SVC
			from [Porteous$Stockkeeping Unit] SKU WITH (NOLOCK)
			inner join [Porteous$Item] IM WITH (NOLOCK)
			on SKU.[Item No_] = IM.[No_]
			inner join #SKUKeys
			on Code = [Location Code]
			where substring([Item No_], 1, 5) between @BegCat and @EndCat
			and substring([Item No_], 12, 2) between @BegPkg and @EndPkg
			and substring([Item No_], 14, 1) between @BegPlt and @EndPlt
			and [Location Code] = @Loc
			order by SortKey
		OPEN SKUItems;
		FETCH NEXT FROM SKUItems into @Item, @SizeDesc, @SVC;
		WHILE @@FETCH_STATUS = 0
			-- Do updates if required
			BEGIN
			if @ColCtr = 1 
				begin update #SKUGrid set [Col01] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col01]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 2 
				begin update #SKUGrid set [Col02] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col02]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 3 
				begin update #SKUGrid set [Col03] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col03]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 4 
				begin update #SKUGrid set [Col04] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col04]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 5
				begin update #SKUGrid set [Col05] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col05]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 6 
				begin update #SKUGrid set [Col06] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col06]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 7 
				begin update #SKUGrid set [Col07] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col07]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 8 
				begin update #SKUGrid set [Col08] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col08]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 9 
				begin update #SKUGrid set [Col09] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col09]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 10 
				begin update #SKUGrid set [Col10] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col10]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 11 
				begin update #SKUGrid set [Col11] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col11]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 12 
				begin update #SKUGrid set [Col12] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col12]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 13 
				begin update #SKUGrid set [Col13] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col13]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 14 
				begin update #SKUGrid set [Col14] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col14]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 15 
				begin update #SKUGrid set [Col15] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col15]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 16 
				begin update #SKUGrid set [Col16] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col16]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 17 
				begin update #SKUGrid set [Col17] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col17]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 18 
				begin update #SKUGrid set [Col18] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col18]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 19 
				begin update #SKUGrid set [Col19] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col19]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 20 
				begin update #SKUGrid set [Col20] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col20]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 21 
				begin update #SKUGrid set [Col21] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col21]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 22 
				begin update #SKUGrid set [Col22] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col22]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 23 
				begin update #SKUGrid set [Col23] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col23]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 24 
				begin update #SKUGrid set [Col24] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col24]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 25 
				begin update #SKUGrid set [Col25] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col25]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 26 
				begin update #SKUGrid set [Col26] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col26]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 27 
				begin update #SKUGrid set [Col27] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col27]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 28 
				begin update #SKUGrid set [Col28] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col28]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 29 
				begin update #SKUGrid set [Col29] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col29]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 30 
				begin update #SKUGrid set [Col30] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col30]) values (@Item, @SizeDesc, @SVC); end;
			if @ColCtr = 31 
				begin update #SKUGrid set [Col31] = @SVC where [Item] = @Item;
				if @@rowcount = 0 insert #SKUGrid ([Item], [SizeDesc], [Col31]) values (@Item, @SizeDesc, @SVC); end;
			FETCH NEXT FROM SKUItems into @Item, @SizeDesc, @SVC;
			end;
		CLOSE SKUItems;
		DEALLOCATE SKUItems;


		set @ColCtr = @ColCtr + 1;
		FETCH NEXT FROM SKUFix into @Loc;
		end;
	CLOSE SKUFix;
	DEALLOCATE SKUFix;
	select * from #SKUGrid;
	select * from #SKULocs;
END

GO
