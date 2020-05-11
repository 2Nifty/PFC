



--CREATE concat_comment
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[concat_comment]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[concat_comment]
GO

CREATE Function concat_comment(@Type int, @No varchar(20))
Returns varchar(255) as
   BEGIN
      DECLARE	@str varchar(255)

      SELECT	@str = coalesce(@str+' - ','') + Comment
      FROM	[Porteous$Comment Line]
      WHERE	[Table Name] = @Type AND [No_] = @No AND Comment <> ''
      GROUP BY	[Line No_], Comment
      ORDER BY	[Line No_]

      RETURN	@str
   END
GO


-------------------------------------------------------------------------------------


--Load CustomerNotes
SELECT	pCustMstrID as fCustomerMasterID, [Table Name], [No_] as CustomerNo, 'C' as Type, dbo.concat_comment([Table Name], [No_]) as Notes
FROM	[Porteous$Comment Line] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[CustomerMaster]
ON	[No_] = CustNo COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	dbo.concat_comment([Table Name], [No_]) <> '' AND [Table Name] = 1  --Customer
GROUP BY [Table Name], [No_], dbo.concat_comment([Table Name], [No_]), pCustMstrID
ORDER BY [No_]


--UPDATE EntryID & EntryDt
--EntryID
UPDATE	CustomerNotes
SET	EntryID = [User ID]
FROM	CustomerNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	CustomerNo = [No_]
WHERE	[User ID] <>'' AND [Table Name] = 1  --Customer

--EntryDt
UPDATE	CustomerNotes
SET	EntryDt = [Date]
FROM	CustomerNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	CustomerNo = [No_]
WHERE	[Date] > '1900-01-01' AND [Table Name] = 1  --Customer


--UPDATE FormsCd
UPDATE	CustomerNotes
SET	FormsCd = 'A'
FROM	CustomerNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	CustomerNo = [No_]
WHERE	([Include in E-Mail] <> 0 OR [Include in Sales Orders] <> 0 OR [Include in Purchase Orders] <> 0) AND
	[Table Name] = 1 --Customer



-------------------------------------------------------------------------------------

--Load VendorNotes
SELECT	pVendMstrID as fVendorMasterID, [Table Name], [No_] as VendorNo, 'V' as Type, dbo.concat_comment([Table Name], [No_]) as Notes
FROM	[Porteous$Comment Line] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[VendorMaster]
ON	[No_] = VendNo COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	dbo.concat_comment([Table Name], [No_]) <> '' AND [Table Name] = 2  --Vendor
GROUP BY [Table Name], [No_], dbo.concat_comment([Table Name], [No_]), pVendMstrID
ORDER BY [No_]


--UPDATE EntryID & EntryDt
--EntryID
UPDATE	VendorNotes
SET	EntryID = [User ID]
FROM	VendorNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	VendorNo = [No_]
WHERE	[User ID] <>'' AND [Table Name] = 2  --Vendor

--EntryDt
UPDATE	VendorNotes
SET	EntryDt = [Date]
FROM	VendorNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	VendorNo = [No_]
WHERE	[Date] > '1900-01-01' AND [Table Name] = 2  --Vendor


--UPDATE FormsCd
UPDATE	VendorNotes
SET	FormsCd = 'A'
FROM	VendorNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	VendorNo = [No_]
WHERE	([Include in E-Mail] <> 0 OR [Include in Sales Orders] <> 0 OR [Include in Purchase Orders] <> 0) AND
	[Table Name] = 2  --Vendor



-------------------------------------------------------------------------------------

--Load ItemNotes
SELECT	pItemMasterID as fItemMasterID, [Table Name], [No_] as ItemNo, 'I' as Type, dbo.concat_comment([Table Name], [No_]) as Notes
FROM	[Porteous$Comment Line] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[ItemMaster]
ON	[No_] = ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	dbo.concat_comment([Table Name], [No_]) <> '' AND [Table Name] = 3  --Item
GROUP BY [Table Name], [No_], dbo.concat_comment([Table Name], [No_]), pItemMasterID
ORDER BY [No_]


--UPDATE EntryID & EntryDt
--EntryID
UPDATE	ItemNotes
SET	EntryID = [User ID]
FROM	ItemNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	ItemNo = [No_]
WHERE	[User ID] <>'' AND [Table Name] = 3  --Item

--EntryDt
UPDATE	ItemNotes
SET	EntryDt = [Date]
FROM	ItemNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	ItemNo = [No_]
WHERE	[Date] > '1900-01-01' AND [Table Name] = 3  --Item


--UPDATE FormsCd
UPDATE	ItemNotes
SET	FormsCd = 'A'
FROM	ItemNotes INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Comment Line]
ON	ItemNo = [No_]
WHERE	([Include in E-Mail] <> 0 OR [Include in Sales Orders] <> 0 OR [Include in Purchase Orders] <> 0) AND
	[Table Name] = 3  --Item


-------------------------------------------------------------------------------------



SELECT	*
FROM	(SELECT	CASE [Table Name]
		   WHEN 1 THEN 'Customer'
		   WHEN 2 THEN 'Vendor'
		   WHEN 3 THEN 'Item'
		END as ComType,
		[Table Name] as ComTypeCode, [No_] as No, SUM(LEN(Comment)) as ComLen, SUM(LEN(Comment)) + (Count(Comment) * 3) as TotComLen,
		dbo.concat_comment([Table Name], [No_]) as FullComment
	 FROM	[Porteous$Comment Line]
	 WHERE	[Table Name] = 1 or  --Customer
		[Table Name] = 2 or  --Vendor
		[Table Name] = 3     --Item
	 GROUP BY [Table Name], [No_]) Length
WHERE	TotComLen > 255



order by TotComLen

--ORDER BY [Table Name]


select LEN(Comment), * from [Porteous$Comment Line]
ORDER BY [Table Name]




SELECT * FROM [Porteous$Comment Line]
--order by [No_]
where [Table Name] = 3 and [Comment]<>''

--[No_]='001811'






select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[CustomerMaster]

select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[CustomerNotes]

select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[VendorNotes]

select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[ItemNotes]
