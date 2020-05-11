exec sp_columns CustomerPrice
exec sp_columns CategoryBuyGroups

select * from CustomerPrice
select * from UnprocessedCategoryPrice
select * from SOheader


exec sp_columns UnprocessedCategoryPrice
exec sp_columns ItemMaster

select * from Itemmaster


select	Branch ,CustomerNo ,CustomerName ,GroupType ,GroupNo ,GroupDesc,
	BuyGroupNo ,BuyGroupDesc ,SalesHistory ,GMPctPriceCost,
	TargetGMPct ,ExistingCustPricePct ,Approved
from	UnprocessedCategoryPrice


--delete from UnprocessedCategoryPrice where CustomerNo='004401'


INSERT INTO UnprocessedCategoryPrice
		(Branch
		,CustomerNo
		,CustomerName
		,GroupType
		,GroupNo
		,GroupDesc
		,BuyGroupNo
		,BuyGroupDesc
		,SalesHistory
		,GMPctPriceCost
		,TargetGMPct
		,ExistingCustPricePct
		,Approved
		,EntryID
		,EntryDt
		)
select 		Branch
		,CustomerNo
		,CustomerName
		,GroupType
		,GroupNo
		,GroupDesc
		,BuyGroupNo
		,BuyGroupDesc
		,SalesHistory
		,GMPctPriceCost
		,TargetGMPct
		,ExistingCustPricePct
		,Approved
		,'WO1832' as EntryID
		,GETDATE() as EntryDt
from	tWO1832



select * from tWO1832

select * from UnprocessedCategoryPrice where changedt is not null and Approved <> '0'
order by groupno

update UnprocessedCategoryPrice set Approved = 0
--ChangeDt = null

truncate table UnprocessedCategoryPrice


select * from UnprocessedCategoryPrice
where CustomerNo='004401' and GroupType='B'
order by SalesHistory desc



exec pCustPriceGetHist '001005'




select * from UnprocessedCategoryPrice
order by BuyGroupNo ASC, GroupNo DESC