
SELECT	[Porteous$Purchase Header].No_ AS [PO No], [Porteous$Purchase Header].[Document Type] AS [PO Type], 
	[Porteous$Purchase Header].[Buy-from Vendor No_] AS [Vendor No], Porteous$Vendor.[Search Name] AS [Vendor Short Code],
	'200'+SUBSTRING([Porteous$Purchase Header].No_,2,1)+'-'+SUBSTRING([Porteous$Purchase Header].No_,3,2)+'-'+SUBSTRING([Porteous$Purchase Header].No_,5,2) AS [PO Date],
	Line.POQty, Line.POAmt, [Porteous$Purchase Header].[Due Date]
FROM	[Porteous$Purchase Header]
INNER JOIN
	(SELECT	[Document No_] AS Doc, [Document Type] AS Type, SUM(Quantity) AS POQty, SUM(Amount) AS POAmt
	 FROM	[Porteous$Purchase Line]
	 GROUP BY [Document No_], [Document Type]) Line
ON [Porteous$Purchase Header].[Document Type] = Line.Type AND [Porteous$Purchase Header].No_ = Line.Doc
INNER JOIN
	Porteous$Vendor
ON [Porteous$Purchase Header].[Buy-from Vendor No_] = Porteous$Vendor.No_
ORDER BY [Porteous$Purchase Header].No_





CREATE VIEW [dbo].[vPOVendorConf] as
----vPOVendorConf
----Written By: Tod Dixon
----Appliction: Inventory Management

SELECT	[Porteous$Purchase Header].No_ AS [PO No], [Porteous$Purchase Header].[Document Type] AS [PO Type], [Line].[Type] AS [Line Type], [Order Type],
	[Porteous$Purchase Header].[Buy-from Vendor No_] AS [Vendor No], Porteous$Vendor.[Search Name] AS [Vendor Short Code],
	'200'+SUBSTRING([Porteous$Purchase Header].No_,2,1)+'-'+SUBSTRING([Porteous$Purchase Header].No_,3,2)+'-'+SUBSTRING([Porteous$Purchase Header].No_,5,2) AS [PO Date],
	[Line].OutstandingQty, Line.POQty, Line.POAmt, [Porteous$Purchase Header].[Due Date]
FROM	[Porteous$Purchase Header]
INNER JOIN
	(SELECT	[Document No_] AS Doc, [Document Type] AS DocType, [Type], SUM(Quantity) AS POQty, SUM(Amount) AS POAmt, SUM([Outstanding Quantity]) AS OutstandingQty
	 FROM	[Porteous$Purchase Line]
	 GROUP BY [Document No_], [Document Type], [Type]) Line
ON	[Porteous$Purchase Header].[Document Type] = Line.DocType AND [Porteous$Purchase Header].No_ = Line.Doc
INNER JOIN
	Porteous$Vendor
ON	[Porteous$Purchase Header].[Buy-from Vendor No_] = Porteous$Vendor.No_
WHERE	([Line].Type = 2) AND (left([Line].[Doc],1) between '1' and '5') AND ([Line].OutstandingQty > 0) AND
	([Porteous$Purchase Header].[Order Date] > CONVERT(DATETIME, '2006-08-25 00:00:00', 102))
--ORDER BY [Porteous$Purchase Header].No_

go



http://pfcdev/TDixon/POVendorConf/POVendorConf.aspx