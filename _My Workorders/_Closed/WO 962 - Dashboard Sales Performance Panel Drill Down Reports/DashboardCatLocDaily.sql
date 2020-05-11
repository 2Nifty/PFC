
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardCatLocDaily]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardCatLocDaily]
GO

CREATE TABLE dbo.DashboardCatLocDaily

( 
CategoryGroup     varchar (10),
Location          varchar (10),
ARPostDt          datetime,
SalesDollars      decimal(18,6),
Lbs               decimal(18,6),
SalesPerLb        decimal(18,6),
Cost              decimal(18,6),
MarginDollars     decimal(18,6),
MarginPct         decimal(18,6),
MarginPerLb       decimal(18,6),
Profit            decimal(18,6),
BudgetLbs         decimal(18,6),
BudgetSales       decimal(18,6),
BudgetMargin      decimal(18,6),
BudgetMarginPct   decimal(18,6),
BudgetExp         decimal(18,6),
EntryID           varchar(50),
EntryDt           datetime,
ChangeID          varchar(50),
ChangeDt          datetime,
StatusCd          char(2)
)

GO
