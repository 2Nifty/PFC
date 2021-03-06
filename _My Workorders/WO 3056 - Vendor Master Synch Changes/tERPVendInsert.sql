USE [PFCFinance]
GO
/****** Object:  Table [dbo].[tERPVendInsert]    Script Date: 09/12/2012 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tERPVendInsert](
	[timestamp] [timestamp] NOT NULL,
	[No_] [varchar](20) NOT NULL,
	[Name] [varchar](40) NOT NULL,
	[Search Name] [varchar](50) NOT NULL,
	[Name 2] [varchar](40) NOT NULL,
	[Address] [varchar](40) NOT NULL,
	[Address 2] [varchar](40) NOT NULL,
	[City] [varchar](20) NOT NULL,
	[Contact] [varchar](30) NOT NULL,
	[Phone No_] [varchar](25) NOT NULL,
	[Telex No_] [varchar](20) NOT NULL,
	[Our Account No_] [varchar](20) NOT NULL,
	[Territory Code] [varchar](10) NOT NULL,
	[Global Dimension 1 Code] [varchar](20) NOT NULL,
	[Global Dimension 2 Code] [varchar](20) NOT NULL,
	[Budgeted Amount] [decimal](38, 20) NOT NULL,
	[Vendor Posting Group] [varchar](10) NOT NULL,
	[Currency Code] [varchar](10) NOT NULL,
	[Language Code] [varchar](10) NOT NULL,
	[Statistics Group] [int] NOT NULL,
	[Payment Terms Code] [varchar](10) NOT NULL,
	[Fin_ Charge Terms Code] [varchar](10) NOT NULL,
	[Purchaser Code] [varchar](10) NOT NULL,
	[Shipment Method Code] [varchar](10) NOT NULL,
	[Shipping Agent Code] [varchar](10) NOT NULL,
	[Invoice Disc_ Code] [varchar](20) NOT NULL,
	[Country_Region Code] [varchar](10) NOT NULL,
	[Blocked] [int] NOT NULL,
	[Pay-to Vendor No_] [varchar](20) NOT NULL,
	[Priority] [int] NOT NULL,
	[Payment Method Code] [varchar](10) NOT NULL,
	[Last Date Modified] [datetime] NOT NULL,
	[Application Method] [int] NOT NULL,
	[Prices Including VAT] [tinyint] NOT NULL,
	[Fax No_] [varchar](25) NOT NULL,
	[Telex Answer Back] [varchar](20) NOT NULL,
	[VAT Registration No_] [varchar](20) NOT NULL,
	[Gen_ Bus_ Posting Group] [varchar](10) NOT NULL,
	[Picture] [image] NULL,
	[Post Code] [varchar](10) NOT NULL,
	[County] [varchar](2) NOT NULL,
	[E-Mail] [varchar](80) NOT NULL,
	[Home Page] [varchar](80) NOT NULL,
	[No_ Series] [varchar](10) NOT NULL,
	[Tax Area Code] [varchar](20) NOT NULL,
	[Tax Liable] [tinyint] NOT NULL,
	[VAT Bus_ Posting Group] [varchar](10) NOT NULL,
	[Block Payment Tolerance] [tinyint] NOT NULL,
	[IC Partner Code] [varchar](20) NOT NULL,
	[Prepayment %] [decimal](38, 20) NOT NULL,
	[Primary Contact No_] [varchar](20) NOT NULL,
	[Responsibility Center] [varchar](10) NOT NULL,
	[Location Code] [varchar](10) NOT NULL,
	[Lead Time Calculation] [varchar](32) NOT NULL,
	[Base Calendar Code] [varchar](10) NOT NULL,
	[UPS Zone] [varchar](2) NOT NULL,
	[Federal ID No_] [varchar](30) NOT NULL,
	[Bank Communication] [int] NOT NULL,
	[Check Date Format] [int] NOT NULL,
	[Check Date Separator] [int] NOT NULL,
	[1099 Code] [varchar](10) NOT NULL,
	[Landed Cost Code] [varchar](10) NOT NULL,
	[Transit Time Calculation] [varchar](32) NOT NULL,
	[VendType] [char](5) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF