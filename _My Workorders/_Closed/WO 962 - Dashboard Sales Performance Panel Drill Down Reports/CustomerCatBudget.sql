
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CustomerCatBudget]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CustomerCatBudget]
GO

create table CustomerCatBudget

(
pCustCatBudgetID     int   identity(1,1),
Location             varchar(10),
CustChain            varchar(25),
CategoryGroup        varchar(10),
Period               int,
FiscalPeriod         int,
OrderType            [char] (2),
Lbs                  decimal(18,6),
SalesDollars         decimal(18,6),
MarginDollars        decimal(18,6),
Expense              decimal(18,6),
EntryID              varchar(50),
EntryDt              datetime,
ChangeID             varchar(50),
ChangeDt             datetime,
StatusCd             char(2)
)

create unique index idxCustCatBudgetID on CustomerCatBudget(pCustCatBudgetID)
go

create clustered index idxCustCatBudgChainGrpPer on CustomerCatBudget(CustChain,CategoryGroup,Period)
go
