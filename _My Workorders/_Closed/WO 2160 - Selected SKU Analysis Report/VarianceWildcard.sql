
declare 
	@StrVar varchar(4),
	@EndVar varchar(4),
	@VarList nvarchar(4000)


--Variance
	SET @StrVar = '020'
	SET @EndVar = '024'
	SET @VarList = '~'

--	SET @StrVar = '~'
--	SET @EndVar = '~'
--	SET @VarList = '021,101,450'
--	SET @VarList = REPLACE(@VarList,'''','')
--	select @VarList as VarList

set @StrVar = '02?'
set @EndVar = '02?'

select distinct isnull(substring(IM.ItemNo,12,3),'')
from ItemMaster IM
where 
		--Variance
		((isnull(substring(IM.ItemNo,12,3),'') BETWEEN @StrVar AND @EndVar) or


		 (
		  isnull(substring(IM.ItemNo,12,1),'') = CASE isnull(substring(@StrVar,1,1),'')
														WHEN '?' THEN isnull(substring(IM.ItemNo,12,1),'')
																 ELSE isnull(substring(@StrVar,1,1),'')
												END
AND
		  isnull(substring(IM.ItemNo,13,1),'') = CASE isnull(substring(@StrVar,2,1),'')
														WHEN '?' THEN isnull(substring(IM.ItemNo,13,1),'')
																 ELSE isnull(substring(@StrVar,2,1),'')
												END
AND
		  isnull(substring(IM.ItemNo,14,1),'') = CASE isnull(substring(@StrVar,3,1),'')
														WHEN '?' THEN isnull(substring(IM.ItemNo,14,1),'')
																 ELSE isnull(substring(@StrVar,3,1),'')
												END


		 ) or
		CHARINDEX(isnull(substring(IM.ItemNo,12,3),''), @VarList) > 0)

order by
isnull(substring(IM.ItemNo,12,3),'')

--select	distinct substring(ItemNo,7,4), substring(ItemNo,7,1), substring(ItemNo,8,1), substring(ItemNo,9,1), substring(ItemNo,10,1)
--from ItemMaster IM
--order by substring(ItemNo,7,4)


