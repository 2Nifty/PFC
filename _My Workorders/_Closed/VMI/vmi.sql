if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VMI_Contract_Mngmt]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[VMI_Contract_Mngmt]
GO

CREATE TABLE [dbo].[VMI_Contract_Mngmt] (
	[ContractNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Chain] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ItemNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Branch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Loc_EAU_Qty] [int] NULL ,
	[Loc_EAU_30_Day_Qty] [float] NULL ,
	[Act_30D_Use_Qty] [float] NULL ,
	[Act_Forecast_Qty] [float] NULL ,
	[Tot_Brn_30D_Qty] [float] NULL ,
	[Brn_Avail] [int] NULL ,
	[VMI_Res_Qty] [int] NULL ,
	[VMI_Res_Factor] [float] NULL ,
	[VMI_Res_Need_Qty] [float] NULL ,
	[OO_Qty] [int] NULL ,
	[Next_PO_Date] [datetime] NULL ,
	[Next_PO_Qty] [int] NULL ,
	[Next_PO_Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Trans_Qty] [int] NULL ,
	[Next_Trans_Date] [datetime] NULL ,
	[Next_Trans_Qty] [int] NULL ,
	[Buy_Factor] [float] NULL ,
	[Buy_Qty] [int] NULL 
) ON [PRIMARY]
GO

