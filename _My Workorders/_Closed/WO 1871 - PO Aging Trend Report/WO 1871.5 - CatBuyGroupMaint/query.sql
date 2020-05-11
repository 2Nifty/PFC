select Category, 
GroupNo, ReportGroupNo, ReportGroup, ReportSort, MonthsBuyFactor, ExpensePerLb, UsageForecastPct
from CategoryBuyGroups
order by Category



select distinct ReportGroupNo, ReportGroup
from CategoryBuyGroups

--delete from CategoryBuyGroups where Category='00024'



xGroupNo
xCategory
??Description
xMonthsBuyFactor
xExpensePerLb
xReportSort
xReportGroup
xReportGroupNo
xxEntryID
xxEntryDt
xxChangeID
xxChangeDt
xxStatusCd
xxpCategoryBuyGroups
xUsageForecastPct

--delete from CategoryBuyGroups where EntryID is null

select * from CategoryBuyGroups
where ChangeID is not null


select Category, Description, len(Description) from CategoryBuyGroups
order by len(Description)

exec sp_columns CategoryBuyGroups


SELECT	DISTINCT
	LEFT(ItemNo,5),
	CatDesc
FROM	ItemMaster (NoLock)
--WHERE	CHARINDEX('-',ItemNo) = 6
ORDER BY LEFT(ItemNo,5)


--141813
select * from ItemMaster
where CHARINDEX('-',ItemNo)=6

select * from ItemMaster
where ItemStat='S' and 
CHARINDEX('-',ItemNo)<>6

exec sp_columns ItemMaster



SELECT --ListValue AS CatNo, ListDtlDesc AS CatDesc
	max(len(ListDtlDesc))
FROM   ListMaster INNER JOIN ListDetail ON pListMasterID=fListMasterId
WHERE  ListName='CategoryDesc'
order by ListValue



INSERT INTO CategoryBuyGroups
		(Category, [Description], GroupNo, ReportGroupNo, ReportGroup, ReportSort,
		 MonthsBuyFactor, ExpensePerLb, UsageForecastPct, EntryID, EntryDt)
	VALUES	('12345', 'Tod Test Desc', '15', '10', 'Bolts', '10', '9999', '9.99', '99.99', 'TOD', GETDATE())

select * from CategoryBuyGroups where Category='12345'

--delete from CategoryBuyGroups where Category='00024'



select * from CategoryBuyGroups where Category='00024'
