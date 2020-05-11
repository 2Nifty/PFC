--exec sp_columns [Porteous$Vendor]



SELECT	--*
NV5.[No_], NV5.[Name],

--CASE WHEN NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Name] END as [NV5.Name], CASE WHEN NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Name] END as [NV3.Name],

--Lead Time Special
	CASE WHEN
		CASE WHEN CHARINDEX('D', NV5.[Lead Time Calculation]) > 0
			THEN Replace(NV5.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV5.[Lead Time Calculation], '','')*1
		END <>
		CASE WHEN CHARINDEX('D', NV3.[Lead Time Calculation]) > 0
			THEN Replace(NV3.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV3.[Lead Time Calculation], '','')*1
		END --COLLATE SQL_Latin1_General_CP1_CI_AS
	THEN
		CASE WHEN CHARINDEX('D', NV5.[Lead Time Calculation]) > 0
			THEN Replace(NV5.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV5.[Lead Time Calculation], '','')*1
		END
	END as [NV5.Lead Time Calculation],
	CASE WHEN
		CASE WHEN CHARINDEX('D', NV5.[Lead Time Calculation]) > 0
			THEN Replace(NV5.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV5.[Lead Time Calculation], '','')*1
		END <>
		CASE WHEN CHARINDEX('D', NV3.[Lead Time Calculation]) > 0
			THEN Replace(NV3.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV3.[Lead Time Calculation], '','')*1
		END --COLLATE SQL_Latin1_General_CP1_CI_AS
	THEN
		CASE WHEN CHARINDEX('D', NV3.[Lead Time Calculation]) > 0
			THEN Replace(NV3.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV3.[Lead Time Calculation], '','')*1
		END
	END as [NV3.Lead Time Calculation]


FROM	[Porteous$Vendor] NV5 INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] NV3
ON	NV5.[No_] = NV3.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
where
	--SPECIAL LEAD TIME CALC
	CASE WHEN CHARINDEX('D', NV5.[Lead Time Calculation]) > 0
		THEN Replace(NV5.[Lead Time Calculation], 'D','')*1
		ELSE Replace(NV5.[Lead Time Calculation], '','')*1
	END <>
	CASE WHEN CHARINDEX('D', NV3.[Lead Time Calculation]) > 0
		THEN Replace(NV3.[Lead Time Calculation], 'D','')*1
		ELSE Replace(NV3.[Lead Time Calculation], '','')*1
	END


------------------------------------------------------------------------------------------------------------------
	

--Check [Porteous$Vendor]
SELECT	NV5.[No_], NV5.[Name],
	CASE WHEN NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Name] END as [NV5.Name], CASE WHEN NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Name] END as [NV3.Name],
	CASE WHEN NV5.[Search Name]< >NV3.[Search Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Search Name] END as [NV5.Search Name], CASE WHEN NV5.[Search Name]< >NV3.[Search Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Search Name] END as [NV3.Search Name],
	CASE WHEN NV5.[Name 2]< >NV3.[Name 2] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Name 2] END as [NV5.Name 2], CASE WHEN NV5.[Name 2]< >NV3.[Name 2] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Name 2] END as [NV3.Name 2],
	CASE WHEN NV5.[Address]< >NV3.[Address] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Address] END as [NV5.Address], CASE WHEN NV5.[Address]< >NV3.[Address] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Address] END as [NV3.Address],
	CASE WHEN NV5.[Address 2]< >NV3.[Address 2] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Address 2] END as [NV5.Address 2], CASE WHEN NV5.[Address 2]< >NV3.[Address 2] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Address 2] END as [NV3.Address 2],
	CASE WHEN NV5.[City]< >NV3.[City] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[City] END as [NV5.City], CASE WHEN NV5.[City]< >NV3.[City] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[City] END as [NV3.City],
	CASE WHEN NV5.[Contact]< >NV3.[Contact] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Contact] END as [NV5.Contact], CASE WHEN NV5.[Contact]< >NV3.[Contact] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Contact] END as [NV3.Contact],
	CASE WHEN NV5.[Phone No_]< >NV3.[Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Phone No_] END as [NV5.Phone No_], CASE WHEN NV5.[Phone No_]< >NV3.[Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Phone No_] END as [NV3.Phone No_],
	CASE WHEN NV5.[Telex No_]< >NV3.[Telex No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Telex No_] END as [NV5.Telex No_], CASE WHEN NV5.[Telex No_]< >NV3.[Telex No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Telex No_] END as [NV3.Telex No_],
	CASE WHEN NV5.[Our Account No_]< >NV3.[Our Account No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Our Account No_] END as [NV5.Our Account No_], CASE WHEN NV5.[Our Account No_]< >NV3.[Our Account No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Our Account No_] END as [NV3.Our Account No_],
	CASE WHEN NV5.[Territory Code]< >NV3.[Territory Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Territory Code] END as [NV5.Territory Code], CASE WHEN NV5.[Territory Code]< >NV3.[Territory Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Territory Code] END as [NV3.Territory Code],
	CASE WHEN NV5.[Global Dimension 1 Code]< >NV3.[Global Dimension 1 Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Global Dimension 1 Code] END as [NV5.Global Dimension 1 Code], CASE WHEN NV5.[Global Dimension 1 Code]< >NV3.[Global Dimension 1 Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Global Dimension 1 Code] END as [NV3.Global Dimension 1 Code],
	CASE WHEN NV5.[Global Dimension 2 Code]< >NV3.[Global Dimension 2 Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Global Dimension 2 Code] END as [NV5.Global Dimension 2 Code], CASE WHEN NV5.[Global Dimension 2 Code]< >NV3.[Global Dimension 2 Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Global Dimension 2 Code] END as [NV3.Global Dimension 2 Code],
	CASE WHEN NV5.[Budgeted Amount]< >NV3.[Budgeted Amount]  THEN NV5.[Budgeted Amount] END as [NV5.Budgeted Amount], CASE WHEN NV5.[Budgeted Amount]< >NV3.[Budgeted Amount]  THEN NV3.[Budgeted Amount] END as [NV3.Budgeted Amount],
	CASE WHEN NV5.[Vendor Posting Group]< >NV3.[Vendor Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Vendor Posting Group] END as [NV5.Vendor Posting Group], CASE WHEN NV5.[Vendor Posting Group]< >NV3.[Vendor Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Vendor Posting Group] END as [NV3.Vendor Posting Group],
	CASE WHEN NV5.[Currency Code]< >NV3.[Currency Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Currency Code] END as [NV5.Currency Code], CASE WHEN NV5.[Currency Code]< >NV3.[Currency Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Currency Code] END as [NV3.Currency Code],
	CASE WHEN NV5.[Language Code]< >NV3.[Language Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Language Code] END as [NV5.Language Code], CASE WHEN NV5.[Language Code]< >NV3.[Language Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Language Code] END as [NV3.Language Code],
	CASE WHEN NV5.[Statistics Group]< >NV3.[Statistics Group]  THEN NV5.[Statistics Group] END as [NV5.Statistics Group], CASE WHEN NV5.[Statistics Group]< >NV3.[Statistics Group]  THEN NV3.[Statistics Group] END as [NV3.Statistics Group],
	CASE WHEN NV5.[Payment Terms Code]< >NV3.[Payment Terms Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Payment Terms Code] END as [NV5.Payment Terms Code], CASE WHEN NV5.[Payment Terms Code]< >NV3.[Payment Terms Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Payment Terms Code] END as [NV3.Payment Terms Code],
	CASE WHEN NV5.[Fin_ Charge Terms Code]< >NV3.[Fin_ Charge Terms Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Fin_ Charge Terms Code] END as [NV5.Fin_ Charge Terms Code], CASE WHEN NV5.[Fin_ Charge Terms Code]< >NV3.[Fin_ Charge Terms Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Fin_ Charge Terms Code] END as [NV3.Fin_ Charge Terms Code],
	CASE WHEN NV5.[Purchaser Code]< >NV3.[Purchaser Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Purchaser Code] END as [NV5.Purchaser Code], CASE WHEN NV5.[Purchaser Code]< >NV3.[Purchaser Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Purchaser Code] END as [NV3.Purchaser Code],
	CASE WHEN NV5.[Shipment Method Code]< >NV3.[Shipment Method Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Shipment Method Code] END as [NV5.Shipment Method Code], CASE WHEN NV5.[Shipment Method Code]< >NV3.[Shipment Method Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Shipment Method Code] END as [NV3.Shipment Method Code],
	CASE WHEN NV5.[Shipping Agent Code]< >NV3.[Shipping Agent Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Shipping Agent Code] END as [NV5.Shipping Agent Code], CASE WHEN NV5.[Shipping Agent Code]< >NV3.[Shipping Agent Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Shipping Agent Code] END as [NV3.Shipping Agent Code],
	CASE WHEN NV5.[Invoice Disc_ Code]< >NV3.[Invoice Disc_ Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Invoice Disc_ Code] END as [NV5.Invoice Disc_ Code], CASE WHEN NV5.[Invoice Disc_ Code]< >NV3.[Invoice Disc_ Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Invoice Disc_ Code] END as [NV3.Invoice Disc_ Code],
	CASE WHEN NV5.[Country_Region Code]< >NV3.[Country Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Country_Region Code] END as [NV5.Country_Region Code], CASE WHEN NV5.[Country_Region Code]< >NV3.[Country Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Country Code] END as [NV3.Country Code],
	CASE WHEN NV5.[Blocked]< >NV3.[Blocked]  THEN NV5.[Blocked] END as [NV5.Blocked], CASE WHEN NV5.[Blocked]< >NV3.[Blocked]  THEN NV3.[Blocked] END as [NV3.Blocked],
	CASE WHEN NV5.[Pay-to Vendor No_]< >NV3.[Pay-to Vendor No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Pay-to Vendor No_] END as [NV5.Pay-to Vendor No_], CASE WHEN NV5.[Pay-to Vendor No_]< >NV3.[Pay-to Vendor No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Pay-to Vendor No_] END as [NV3.Pay-to Vendor No_],
	CASE WHEN NV5.[Priority]< >NV3.[Priority]  THEN NV5.[Priority] END as [NV5.Priority], CASE WHEN NV5.[Priority]< >NV3.[Priority]  THEN NV3.[Priority] END as [NV3.Priority],
	CASE WHEN NV5.[Payment Method Code]< >NV3.[Payment Method Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Payment Method Code] END as [NV5.Payment Method Code], CASE WHEN NV5.[Payment Method Code]< >NV3.[Payment Method Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Payment Method Code] END as [NV3.Payment Method Code],
	CASE WHEN NV5.[Application Method]< >NV3.[Application Method]  THEN NV5.[Application Method] END as [NV5.Application Method], CASE WHEN NV5.[Application Method]< >NV3.[Application Method]  THEN NV3.[Application Method] END as [NV3.Application Method],
	CASE WHEN NV5.[Prices Including VAT]< >NV3.[Prices Including VAT]  THEN NV5.[Prices Including VAT] END as [NV5.Prices Including VAT], CASE WHEN NV5.[Prices Including VAT]< >NV3.[Prices Including VAT]  THEN NV3.[Prices Including VAT] END as [NV3.Prices Including VAT],
	CASE WHEN NV5.[Fax No_]< >NV3.[Fax No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Fax No_] END as [NV5.Fax No_], CASE WHEN NV5.[Fax No_]< >NV3.[Fax No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Fax No_] END as [NV3.Fax No_],
	CASE WHEN NV5.[Telex Answer Back]< >NV3.[Telex Answer Back] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Telex Answer Back] END as [NV5.Telex Answer Back], CASE WHEN NV5.[Telex Answer Back]< >NV3.[Telex Answer Back] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Telex Answer Back] END as [NV3.Telex Answer Back],
	CASE WHEN NV5.[VAT Registration No_]< >NV3.[VAT Registration No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[VAT Registration No_] END as [NV5.VAT Registration No_], CASE WHEN NV5.[VAT Registration No_]< >NV3.[VAT Registration No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[VAT Registration No_] END as [NV3.VAT Registration No_],
	CASE WHEN NV5.[Gen_ Bus_ Posting Group]< >NV3.[Gen_ Bus_ Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Gen_ Bus_ Posting Group] END as [NV5.Gen_ Bus_ Posting Group], CASE WHEN NV5.[Gen_ Bus_ Posting Group]< >NV3.[Gen_ Bus_ Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Gen_ Bus_ Posting Group] END as [NV3.Gen_ Bus_ Posting Group],
	CASE WHEN NV5.[Post Code]< >NV3.[Post Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Post Code] END as [NV5.Post Code], CASE WHEN NV5.[Post Code]< >NV3.[Post Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Post Code] END as [NV3.Post Code],
	CASE WHEN NV5.[County]< >NV3.[County] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[County] END as [NV5.County], CASE WHEN NV5.[County]< >NV3.[County] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[County] END as [NV3.County],
	CASE WHEN NV5.[E-Mail]< >NV3.[E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[E-Mail] END as [NV5.E-Mail], CASE WHEN NV5.[E-Mail]< >NV3.[E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[E-Mail] END as [NV3.E-Mail],
	CASE WHEN NV5.[Home Page]< >NV3.[Home Page] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Home Page] END as [NV5.Home Page], CASE WHEN NV5.[Home Page]< >NV3.[Home Page] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Home Page] END as [NV3.Home Page],
	CASE WHEN NV5.[No_ Series]< >NV3.[No_ Series] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[No_ Series] END as [NV5.No_ Series], CASE WHEN NV5.[No_ Series]< >NV3.[No_ Series] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[No_ Series] END as [NV3.No_ Series],
	CASE WHEN NV5.[Tax Area Code]< >NV3.[Tax Area Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Tax Area Code] END as [NV5.Tax Area Code], CASE WHEN NV5.[Tax Area Code]< >NV3.[Tax Area Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Tax Area Code] END as [NV3.Tax Area Code],
	CASE WHEN NV5.[Tax Liable]< >NV3.[Tax Liable]  THEN NV5.[Tax Liable] END as [NV5.Tax Liable], CASE WHEN NV5.[Tax Liable]< >NV3.[Tax Liable]  THEN NV3.[Tax Liable] END as [NV3.Tax Liable],
	CASE WHEN NV5.[VAT Bus_ Posting Group]< >NV3.[VAT Bus_ Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[VAT Bus_ Posting Group] END as [NV5.VAT Bus_ Posting Group], CASE WHEN NV5.[VAT Bus_ Posting Group]< >NV3.[VAT Bus_ Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[VAT Bus_ Posting Group] END as [NV3.VAT Bus_ Posting Group],
	CASE WHEN NV5.[Block Payment Tolerance]< >NV3.[Block Payment Tolerance]  THEN NV5.[Block Payment Tolerance] END as [NV5.Block Payment Tolerance], CASE WHEN NV5.[Block Payment Tolerance]< >NV3.[Block Payment Tolerance]  THEN NV3.[Block Payment Tolerance] END as [NV3.Block Payment Tolerance],
	CASE WHEN NV5.[Primary Contact No_]< >NV3.[Primary Contact No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Primary Contact No_] END as [NV5.Primary Contact No_], CASE WHEN NV5.[Primary Contact No_]< >NV3.[Primary Contact No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Primary Contact No_] END as [NV3.Primary Contact No_],
	CASE WHEN NV5.[Responsibility Center]< >NV3.[Responsibility Center] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Responsibility Center] END as [NV5.Responsibility Center], CASE WHEN NV5.[Responsibility Center]< >NV3.[Responsibility Center] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Responsibility Center] END as [NV3.Responsibility Center],
	CASE WHEN NV5.[Location Code]< >NV3.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Location Code] END as [NV5.Location Code], CASE WHEN NV5.[Location Code]< >NV3.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Location Code] END as [NV3.Location Code],
	--SPECIAL LEAD TIME CALC
	CASE WHEN
		CASE WHEN CHARINDEX('D', NV5.[Lead Time Calculation]) > 0
			THEN Replace(NV5.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV5.[Lead Time Calculation], '','')*1
		END <>
		CASE WHEN CHARINDEX('D', NV3.[Lead Time Calculation]) > 0
			THEN Replace(NV3.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV3.[Lead Time Calculation], '','')*1
		END --COLLATE SQL_Latin1_General_CP1_CI_AS
	THEN
		CASE WHEN CHARINDEX('D', NV5.[Lead Time Calculation]) > 0
			THEN Replace(NV5.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV5.[Lead Time Calculation], '','')*1
		END
	END as [NV5.Lead Time Calculation],
	CASE WHEN
		CASE WHEN CHARINDEX('D', NV5.[Lead Time Calculation]) > 0
			THEN Replace(NV5.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV5.[Lead Time Calculation], '','')*1
		END <>
		CASE WHEN CHARINDEX('D', NV3.[Lead Time Calculation]) > 0
			THEN Replace(NV3.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV3.[Lead Time Calculation], '','')*1
		END --COLLATE SQL_Latin1_General_CP1_CI_AS
	THEN
		CASE WHEN CHARINDEX('D', NV3.[Lead Time Calculation]) > 0
			THEN Replace(NV3.[Lead Time Calculation], 'D','')*1
			ELSE Replace(NV3.[Lead Time Calculation], '','')*1
		END
	END as [NV3.Lead Time Calculation],

	CASE WHEN NV5.[Base Calendar Code]< >NV3.[Base Calendar Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Base Calendar Code] END as [NV5.Base Calendar Code], CASE WHEN NV5.[Base Calendar Code]< >NV3.[Base Calendar Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Base Calendar Code] END as [NV3.Base Calendar Code],
	CASE WHEN NV5.[UPS Zone]< >NV3.[UPS Zone] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[UPS Zone] END as [NV5.UPS Zone], CASE WHEN NV5.[UPS Zone]< >NV3.[UPS Zone] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[UPS Zone] END as [NV3.UPS Zone],
	CASE WHEN NV5.[Federal ID No_]< >NV3.[Federal ID No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Federal ID No_] END as [NV5.Federal ID No_], CASE WHEN NV5.[Federal ID No_]< >NV3.[Federal ID No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Federal ID No_] END as [NV3.Federal ID No_],
	CASE WHEN NV5.[Bank Communication]< >NV3.[Bank Communication]  THEN NV5.[Bank Communication] END as [NV5.Bank Communication], CASE WHEN NV5.[Bank Communication]< >NV3.[Bank Communication]  THEN NV3.[Bank Communication] END as [NV3.Bank Communication],
	CASE WHEN NV5.[1099 Code]< >NV3.[1099 Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[1099 Code] END as [NV5.1099 Code], CASE WHEN NV5.[1099 Code]< >NV3.[1099 Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[1099 Code] END as [NV3.1099 Code],
	CASE WHEN NV5.[Landed Cost Code]< >NV3.[Landed Cost Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Landed Cost Code] END as [NV5.Landed Cost Code], CASE WHEN NV5.[Landed Cost Code]< >NV3.[Landed Cost Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Landed Cost Code] END as [NV3.Landed Cost Code],
	NV5.[Last Date Modified] AS [NV5.Last Date Modified], NV3.[Last Date Modified] AS [NV3.Last Date Modified]
FROM	[Porteous$Vendor] NV5 INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Vendor] NV3
ON	NV5.[No_] = NV3.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	
	NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Search Name]< >NV3.[Search Name] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Name 2]< >NV3.[Name 2] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Address]< >NV3.[Address] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Address 2]< >NV3.[Address 2] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[City]< >NV3.[City] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Contact]< >NV3.[Contact] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Phone No_]< >NV3.[Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Telex No_]< >NV3.[Telex No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Our Account No_]< >NV3.[Our Account No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Territory Code]< >NV3.[Territory Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Global Dimension 1 Code]< >NV3.[Global Dimension 1 Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Global Dimension 2 Code]< >NV3.[Global Dimension 2 Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Budgeted Amount]< >NV3.[Budgeted Amount]  or
	NV5.[Vendor Posting Group]< >NV3.[Vendor Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Currency Code]< >NV3.[Currency Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Language Code]< >NV3.[Language Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Statistics Group]< >NV3.[Statistics Group]  or
	NV5.[Payment Terms Code]< >NV3.[Payment Terms Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Fin_ Charge Terms Code]< >NV3.[Fin_ Charge Terms Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Purchaser Code]< >NV3.[Purchaser Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Shipment Method Code]< >NV3.[Shipment Method Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Shipping Agent Code]< >NV3.[Shipping Agent Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Invoice Disc_ Code]< >NV3.[Invoice Disc_ Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Country_Region Code]< >NV3.[Country Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Blocked]< >NV3.[Blocked]  or
	NV5.[Pay-to Vendor No_]< >NV3.[Pay-to Vendor No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Priority]< >NV3.[Priority]  or
	NV5.[Payment Method Code]< >NV3.[Payment Method Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Application Method]< >NV3.[Application Method]  or
	NV5.[Prices Including VAT]< >NV3.[Prices Including VAT]  or
	NV5.[Fax No_]< >NV3.[Fax No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Telex Answer Back]< >NV3.[Telex Answer Back] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[VAT Registration No_]< >NV3.[VAT Registration No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Gen_ Bus_ Posting Group]< >NV3.[Gen_ Bus_ Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Post Code]< >NV3.[Post Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[County]< >NV3.[County] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[E-Mail]< >NV3.[E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Home Page]< >NV3.[Home Page] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[No_ Series]< >NV3.[No_ Series] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Tax Area Code]< >NV3.[Tax Area Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Tax Liable]< >NV3.[Tax Liable]  or
	NV5.[VAT Bus_ Posting Group]< >NV3.[VAT Bus_ Posting Group] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Block Payment Tolerance]< >NV3.[Block Payment Tolerance]  or
	NV5.[Primary Contact No_]< >NV3.[Primary Contact No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Responsibility Center]< >NV3.[Responsibility Center] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Location Code]< >NV3.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	--SPECIAL LEAD TIME CALC
	CASE WHEN CHARINDEX('D', NV5.[Lead Time Calculation]) > 0
		THEN Replace(NV5.[Lead Time Calculation], 'D','')*1
		ELSE Replace(NV5.[Lead Time Calculation], '','')*1
	END <>
	CASE WHEN CHARINDEX('D', NV3.[Lead Time Calculation]) > 0
		THEN Replace(NV3.[Lead Time Calculation], 'D','')*1
		ELSE Replace(NV3.[Lead Time Calculation], '','')*1
	END or

	NV5.[Base Calendar Code]< >NV3.[Base Calendar Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[UPS Zone]< >NV3.[UPS Zone] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Federal ID No_]< >NV3.[Federal ID No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Bank Communication]< >NV3.[Bank Communication]  or
	NV5.[1099 Code]< >NV3.[1099 Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Landed Cost Code]< >NV3.[Landed Cost Code] COLLATE SQL_Latin1_General_CP1_CI_AS




------------------------------------------------------------------------------------------------------------------
	
--exec sp_columns [Porteous$Contact]



SELECT		*
FROM		[Porteous$Contact] NV5
--INNER JOIN	[Porteous$Contact Business Relation] CBR
--ON		Cont5.[No_] = CBR.[Contact No_]
INNER JOIN	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact] NV3
ON		NV5.[No_] = NV3.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
--WHERE		CBR.[Business Relation Code] = 'VEND'






	
--Check [Porteous$Contact]
SELECT	NV5.[No_] AS ContactNo, CBR.[No_] AS VendorNo, NV5.[Name],
	CASE WHEN NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Name] END as [NV5.Name], CASE WHEN NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Name] END as [NV3.Name],
	CASE WHEN NV5.[Search Name]< >NV3.[Search Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Search Name] END as [NV5.Search Name], CASE WHEN NV5.[Search Name]< >NV3.[Search Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Search Name] END as [NV3.Search Name],
	CASE WHEN NV5.[Name 2]< >NV3.[Name 2] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Name 2] END as [NV5.Name 2], CASE WHEN NV5.[Name 2]< >NV3.[Name 2] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Name 2] END as [NV3.Name 2],
	CASE WHEN NV5.[Address]< >NV3.[Address] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Address] END as [NV5.Address], CASE WHEN NV5.[Address]< >NV3.[Address] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Address] END as [NV3.Address],
	CASE WHEN NV5.[Address 2]< >NV3.[Address 2] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Address 2] END as [NV5.Address 2], CASE WHEN NV5.[Address 2]< >NV3.[Address 2] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Address 2] END as [NV3.Address 2],
	CASE WHEN NV5.[City]< >NV3.[City] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[City] END as [NV5.City], CASE WHEN NV5.[City]< >NV3.[City] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[City] END as [NV3.City],
	CASE WHEN NV5.[Phone No_]< >NV3.[Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Phone No_] END as [NV5.Phone No_], CASE WHEN NV5.[Phone No_]< >NV3.[Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Phone No_] END as [NV3.Phone No_],
	CASE WHEN NV5.[Telex No_]< >NV3.[Telex No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Telex No_] END as [NV5.Telex No_], CASE WHEN NV5.[Telex No_]< >NV3.[Telex No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Telex No_] END as [NV3.Telex No_],
	CASE WHEN NV5.[Territory Code]< >NV3.[Territory Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Territory Code] END as [NV5.Territory Code], CASE WHEN NV5.[Territory Code]< >NV3.[Territory Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Territory Code] END as [NV3.Territory Code],
	CASE WHEN NV5.[Currency Code]< >NV3.[Currency Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Currency Code] END as [NV5.Currency Code], CASE WHEN NV5.[Currency Code]< >NV3.[Currency Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Currency Code] END as [NV3.Currency Code],
	CASE WHEN NV5.[Language Code]< >NV3.[Language Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Language Code] END as [NV5.Language Code], CASE WHEN NV5.[Language Code]< >NV3.[Language Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Language Code] END as [NV3.Language Code],
	CASE WHEN NV5.[Salesperson Code]< >NV3.[Salesperson Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Salesperson Code] END as [NV5.Salesperson Code], CASE WHEN NV5.[Salesperson Code]< >NV3.[Salesperson Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Salesperson Code] END as [NV3.Salesperson Code],
	CASE WHEN NV5.[Country_Region Code]< >NV3.[Country Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Country_Region Code] END as [NV5.Country_Region Code], CASE WHEN NV5.[Country_Region Code]< >NV3.[Country Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Country Code] END as [NV3.Country Code],
	CASE WHEN NV5.[Fax No_]< >NV3.[Fax No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Fax No_] END as [NV5.Fax No_], CASE WHEN NV5.[Fax No_]< >NV3.[Fax No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Fax No_] END as [NV3.Fax No_],
	CASE WHEN NV5.[Telex Answer Back]< >NV3.[Telex Answer Back] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Telex Answer Back] END as [NV5.Telex Answer Back], CASE WHEN NV5.[Telex Answer Back]< >NV3.[Telex Answer Back] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Telex Answer Back] END as [NV3.Telex Answer Back],
	CASE WHEN NV5.[VAT Registration No_]< >NV3.[VAT Registration No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[VAT Registration No_] END as [NV5.VAT Registration No_], CASE WHEN NV5.[VAT Registration No_]< >NV3.[VAT Registration No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[VAT Registration No_] END as [NV3.VAT Registration No_],
	CASE WHEN NV5.[Post Code]< >NV3.[Post Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Post Code] END as [NV5.Post Code], CASE WHEN NV5.[Post Code]< >NV3.[Post Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Post Code] END as [NV3.Post Code],
	CASE WHEN NV5.[County]< >NV3.[County] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[County] END as [NV5.County], CASE WHEN NV5.[County]< >NV3.[County] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[County] END as [NV3.County],
	CASE WHEN NV5.[E-Mail]< >NV3.[E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[E-Mail] END as [NV5.E-Mail], CASE WHEN NV5.[E-Mail]< >NV3.[E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[E-Mail] END as [NV3.E-Mail],
	CASE WHEN NV5.[Home Page]< >NV3.[Home Page] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Home Page] END as [NV5.Home Page], CASE WHEN NV5.[Home Page]< >NV3.[Home Page] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Home Page] END as [NV3.Home Page],
	CASE WHEN NV5.[No_ Series]< >NV3.[No_ Series] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[No_ Series] END as [NV5.No_ Series], CASE WHEN NV5.[No_ Series]< >NV3.[No_ Series] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[No_ Series] END as [NV3.No_ Series],
	CASE WHEN NV5.[Type]< >NV3.[Type]  THEN NV5.[Type] END as [NV5.Type], CASE WHEN NV5.[Type]< >NV3.[Type]  THEN NV3.[Type] END as [NV3.Type],
	CASE WHEN NV5.[Company No_]< >NV3.[Company No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Company No_] END as [NV5.Company No_], CASE WHEN NV5.[Company No_]< >NV3.[Company No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Company No_] END as [NV3.Company No_],
	CASE WHEN NV5.[Company Name]< >NV3.[Company Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Company Name] END as [NV5.Company Name], CASE WHEN NV5.[Company Name]< >NV3.[Company Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Company Name] END as [NV3.Company Name],
	CASE WHEN NV5.[Lookup Contact No_]< >NV3.[Lookup Contact No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Lookup Contact No_] END as [NV5.Lookup Contact No_], CASE WHEN NV5.[Lookup Contact No_]< >NV3.[Lookup Contact No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Lookup Contact No_] END as [NV3.Lookup Contact No_],
	CASE WHEN NV5.[First Name]< >NV3.[First Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[First Name] END as [NV5.First Name], CASE WHEN NV5.[First Name]< >NV3.[First Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[First Name] END as [NV3.First Name],
	CASE WHEN NV5.[Middle Name]< >NV3.[Middle Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Middle Name] END as [NV5.Middle Name], CASE WHEN NV5.[Middle Name]< >NV3.[Middle Name] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Middle Name] END as [NV3.Middle Name],
	CASE WHEN NV5.[Surname]< >NV3.[Surname] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Surname] END as [NV5.Surname], CASE WHEN NV5.[Surname]< >NV3.[Surname] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Surname] END as [NV3.Surname],
	CASE WHEN NV5.[Job Title]< >NV3.[Job Title] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Job Title] END as [NV5.Job Title], CASE WHEN NV5.[Job Title]< >NV3.[Job Title] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Job Title] END as [NV3.Job Title],
	CASE WHEN NV5.[Initials]< >NV3.[Initials] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Initials] END as [NV5.Initials], CASE WHEN NV5.[Initials]< >NV3.[Initials] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Initials] END as [NV3.Initials],
	CASE WHEN NV5.[Extension No_]< >NV3.[Extension No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Extension No_] END as [NV5.Extension No_], CASE WHEN NV5.[Extension No_]< >NV3.[Extension No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Extension No_] END as [NV3.Extension No_],
	CASE WHEN NV5.[Mobile Phone No_]< >NV3.[Mobile Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Mobile Phone No_] END as [NV5.Mobile Phone No_], CASE WHEN NV5.[Mobile Phone No_]< >NV3.[Mobile Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Mobile Phone No_] END as [NV3.Mobile Phone No_],
	CASE WHEN NV5.[Pager]< >NV3.[Pager] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Pager] END as [NV5.Pager], CASE WHEN NV5.[Pager]< >NV3.[Pager] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Pager] END as [NV3.Pager],
	CASE WHEN NV5.[Organizational Level Code]< >NV3.[Organizational Level Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Organizational Level Code] END as [NV5.Organizational Level Code], CASE WHEN NV5.[Organizational Level Code]< >NV3.[Organizational Level Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Organizational Level Code] END as [NV3.Organizational Level Code],
	CASE WHEN NV5.[Exclude from Segment]< >NV3.[Exclude from Segment]  THEN NV5.[Exclude from Segment] END as [NV5.Exclude from Segment], CASE WHEN NV5.[Exclude from Segment]< >NV3.[Exclude from Segment]  THEN NV3.[Exclude from Segment] END as [NV3.Exclude from Segment],
	CASE WHEN NV5.[External ID]< >NV3.[External ID] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[External ID] END as [NV5.External ID], CASE WHEN NV5.[External ID]< >NV3.[External ID] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[External ID] END as [NV3.External ID],
	CASE WHEN NV5.[Correspondence Type]< >NV3.[Correspondence Type]  THEN NV5.[Correspondence Type] END as [NV5.Correspondence Type], CASE WHEN NV5.[Correspondence Type]< >NV3.[Correspondence Type]  THEN NV3.[Correspondence Type] END as [NV3.Correspondence Type],
	CASE WHEN NV5.[Salutation Code]< >NV3.[Salutation Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Salutation Code] END as [NV5.Salutation Code], CASE WHEN NV5.[Salutation Code]< >NV3.[Salutation Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Salutation Code] END as [NV3.Salutation Code],
	CASE WHEN NV5.[Search E-Mail]< >NV3.[Search E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Search E-Mail] END as [NV5.Search E-Mail], CASE WHEN NV5.[Search E-Mail]< >NV3.[Search E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Search E-Mail] END as [NV3.Search E-Mail],
	NV5.[Last Date Modified] AS [NV5.Last Date Modified], NV3.[Last Date Modified] AS [NV3.Last Date Modified]
FROM	[Porteous$Contact] NV5 INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact] NV3
ON	NV5.[No_] = NV3.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	[Porteous$Contact Business Relation] CBR
ON	NV5.[No_] = CBR.[Contact No_]
WHERE	CBR.[Business Relation Code] = 'VEND' and (
	NV5.[Name]< >NV3.[Name] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Search Name]< >NV3.[Search Name] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Name 2]< >NV3.[Name 2] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Address]< >NV3.[Address] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Address 2]< >NV3.[Address 2] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[City]< >NV3.[City] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Phone No_]< >NV3.[Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Telex No_]< >NV3.[Telex No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Territory Code]< >NV3.[Territory Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Currency Code]< >NV3.[Currency Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Language Code]< >NV3.[Language Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Salesperson Code]< >NV3.[Salesperson Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Country_Region Code]< >NV3.[Country Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Fax No_]< >NV3.[Fax No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Telex Answer Back]< >NV3.[Telex Answer Back] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[VAT Registration No_]< >NV3.[VAT Registration No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Post Code]< >NV3.[Post Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[County]< >NV3.[County] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[E-Mail]< >NV3.[E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Home Page]< >NV3.[Home Page] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[No_ Series]< >NV3.[No_ Series] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Type]< >NV3.[Type]  or
	NV5.[Company No_]< >NV3.[Company No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Company Name]< >NV3.[Company Name] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Lookup Contact No_]< >NV3.[Lookup Contact No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[First Name]< >NV3.[First Name] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Middle Name]< >NV3.[Middle Name] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Surname]< >NV3.[Surname] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Job Title]< >NV3.[Job Title] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Initials]< >NV3.[Initials] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Extension No_]< >NV3.[Extension No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Mobile Phone No_]< >NV3.[Mobile Phone No_] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Pager]< >NV3.[Pager] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Organizational Level Code]< >NV3.[Organizational Level Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Exclude from Segment]< >NV3.[Exclude from Segment]  or
	NV5.[External ID]< >NV3.[External ID] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Correspondence Type]< >NV3.[Correspondence Type]  or
	NV5.[Salutation Code]< >NV3.[Salutation Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Search E-Mail]< >NV3.[Search E-Mail] COLLATE SQL_Latin1_General_CP1_CI_AS
	)


------------------------------------------------------------------------------------------------------------------
	
--exec sp_columns [Porteous$Contact Business Relation]



SELECT	NV5.[No_],
	CASE WHEN NV5.[Business Relation Code]< >NV3.[Business Relation Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV5.[Business Relation Code] END as [NV5.Business Relation Code], CASE WHEN NV5.[Business Relation Code]< >NV3.[Business Relation Code] COLLATE SQL_Latin1_General_CP1_CI_AS THEN NV3.[Business Relation Code] END as [NV3.Business Relation Code],
	CASE WHEN NV5.[Link to Table]< >NV3.[Link to Table]  THEN NV5.[Link to Table] END as [NV5.Link to Table], CASE WHEN NV5.[Link to Table]< >NV3.[Link to Table]  THEN NV3.[Link to Table] END as [NV3.Link to Table]
FROM	[Porteous$Contact Business Relation] NV5 INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Contact Business Relation] NV3
ON	NV5.[No_] = NV3.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	
	NV5.[Business Relation Code]< >NV3.[Business Relation Code] COLLATE SQL_Latin1_General_CP1_CI_AS or
	NV5.[Link to Table]< >NV3.[Link to Table]
