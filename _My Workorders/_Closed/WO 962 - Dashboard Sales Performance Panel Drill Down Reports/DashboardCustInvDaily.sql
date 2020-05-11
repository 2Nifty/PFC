
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardCustInvDaily]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DashboardCustInvDaily]
GO

CREATE TABLE dbo.DashboardCustInvDaily

( 
InvoiceNo	varchar (20),
RefSONo		varchar (20),
CustNo		varchar (10),
CustName	varchar (40),
Location	varchar (10),
ARPostDt	datetime,
ItemNo		varchar (30),
LineNumber	int,
SalesDollars    decimal(18,6),
Lbs             decimal(18,6),
SalesPerLb      decimal(18,6),
Cost            decimal(18,6),
MarginDollars   decimal(18,6),
MarginPct       decimal(18,6),
MarginPerLb     decimal(18,6),
EntryID         varchar(50),
EntryDt         datetime,
ChangeID        varchar(50),
ChangeDt        datetime,
StatusCd        char(2)
)

GO
