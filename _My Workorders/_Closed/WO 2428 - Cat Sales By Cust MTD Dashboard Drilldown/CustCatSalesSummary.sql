--From: Tom White3 
--Sent: Monday, June 06, 2011 9:27 AM
--FW: WO2428 {Category sales by customer month to date dash board display}

CREATE TABLE [dbo].[CustCatSalesSummary]
(	 [pCustCatSlsSummID] [int] IDENTITY(1,1) NOT NULL,
	 [CustomerNo] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	 [Category] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	 [BuyCategory] [varchar] (20),
	 [FiscalPeriodNo] [int] NULL,
	 [SalesDollars] [decimal](18, 6) NULL,
	 [SalesCost] [decimal](18, 6) NULL,
	 [NoofOrders] [decimal](18, 6) NULL,
	 [OtherSalesCost] [decimal](18, 6) NULL,
	 [OtherSalesDol] [decimal](18, 6) NULL,
	 [CommissionDollars] [decimal](18, 6) NULL,
	 [TotalWeight] [decimal](18, 6) NULL,
	 [PostingDt] [datetime] NULL,
	 [EntryID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	 [EntryDt] [datetime] NULL,
	 [ChangeID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	 [ChangeDt] [datetime] NULL,
	 [StatusCd] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	 [CategoryDesc] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	 [CalendarFiscalPeriod] [int] NULL,
	 [NoofPFCSOEQuotes] [int] NULL,
	 [NoofPFCSOEOrders] [int] NULL,
	 [NoofWebQuotes] [int] NULL,
	 [NoofWebOrders] [int] NULL,
	 [NoofDirectConnectQuotes] [int] NULL,
	 [NoofDirectConnectOrders] [int] NULL,
	 [NoofSDKQuotes] [int] NULL,
	 [NoofSDKOrders] [int] NULL,
	 [NoofInxSQLQuotes] [int] NULL,
	 [NoofInxSQLOrders] [int] NULL,
	 [NoofTimesFilledWeb] [int] NULL,
	 [NoofTimesPartialWeb] [int] NULL,
	 [NoofTimesZerosWeb] [int] NULL,
	 [NoofTimesFilledPFCSOE] [int] NULL,
	 [NoofTimesPartialPFCSOE] [int] NULL,
	 [NoofTimesZerosPFCSOE] [int] NULL,
	 [NoofTimesFilledDirectConnect] [int] NULL,
	 [NoofTimesPartialDirectConnect] [int] NULL,
	 [NoofTimesZerosDirectConnect] [int] NULL,
	 [NoofTimesFilledSDK] [int] NULL,
	 [NoofTimesPartialSDK] [int] NULL,
	 [NoofTimesZerosSDK] [int] NULL,
	 [NoofTimesFilledInxSQL] [int] NULL,
	 [NoofTimesPartialInxSQL] [int] NULL,
	 [NoofTimesZerosInxSQL] [int] NULL,
	 [NoofPFCSOEOnlyOrders] [int] NULL,
 CONSTRAINT [pkpCustCatSlsSummID] PRIMARY KEY CLUSTERED 
(	 [pCustCatSlsSummID] ASC) WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
go
create index idxCatCustNoFYPerNo on CustCatSalesSummary(Category,CustomerNo,FiscalPeriodNo)
go
create index idxFYPerNoCustNoCat on CustCatSalesSummary(FiscalPeriodNo,CustomerNo,Category)
go
create index idxCustNoCategory on CustCatSalesSummary(CustomerNo,Category)
go
