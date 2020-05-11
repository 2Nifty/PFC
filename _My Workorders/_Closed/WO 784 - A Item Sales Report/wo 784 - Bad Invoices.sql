


SELECT     [Porteous$Sales Invoice Header].No_ as Document, [Porteous$Sales Invoice Line].[Line No_], [Porteous$Sales Invoice Line].No_ AS [Item No], 
	   [Porteous$Sales Invoice Line].Description,
	   [Porteous$Sales Invoice Header].[Location Code] as HdrLoc, 
           [Porteous$Sales Invoice Line].[Location Code] AS [LinLoc],
           [Porteous$Sales Invoice Line].[Shipment Date], 
           [Porteous$Sales Invoice Line].Quantity,
	   [Porteous$Sales Invoice Header].[Sell-to Customer No_], 
           [Porteous$Sales Invoice Header].[Sell-to Customer Name], [Porteous$Sales Invoice Header].[Bill-to Customer No_], 
           [Porteous$Sales Invoice Header].[Bill-to Name], [Porteous$Sales Invoice Header].[Order Date], 
           [Porteous$Sales Invoice Header].[User ID]
FROM       [Porteous$Sales Invoice Header] INNER JOIN
           [Porteous$Sales Invoice Line] ON [Porteous$Sales Invoice Header].No_ = [Porteous$Sales Invoice Line].[Document No_]
WHERE     ([Porteous$Sales Invoice Line].No_ = '') OR
          (LEFT([Porteous$Sales Invoice Header].No_, 2) = 'DI') OR
          ([Porteous$Sales Invoice Header].No_ > '7000') AND ([Porteous$Sales Invoice Header].No_ < '8000')
Order By [Porteous$Sales Invoice Header].No_




SELECT     [Porteous$Sales Invoice Header].No_ as Document, [Porteous$Sales Invoice Line].[Line No_], [Porteous$Sales Invoice Line].No_ AS [Item No], 
	   [Porteous$Sales Invoice Line].Description,
	   [Porteous$Sales Invoice Header].[Location Code] as HdrLoc, 
           [Porteous$Sales Invoice Line].[Location Code] AS [LinLoc],
           [Porteous$Sales Invoice Line].[Shipment Date], 
           [Porteous$Sales Invoice Line].Quantity,
	   [Porteous$Sales Invoice Header].[Sell-to Customer No_], 
           [Porteous$Sales Invoice Header].[Sell-to Customer Name], [Porteous$Sales Invoice Header].[Bill-to Customer No_], 
           [Porteous$Sales Invoice Header].[Bill-to Name], [Porteous$Sales Invoice Header].[Order Date], 
           [Porteous$Sales Invoice Header].[User ID]
FROM       [Porteous$Sales Invoice Header] INNER JOIN
           [Porteous$Sales Invoice Line] ON [Porteous$Sales Invoice Header].No_ = [Porteous$Sales Invoice Line].[Document No_]
WHERE     [Porteous$Sales Invoice Header].[Sell-to Customer No_]>22 and [Porteous$Sales Invoice Header].[Sell-to Customer No_]<1000
Order By [Porteous$Sales Invoice Header].No_




SELECT     [Porteous$Sales Invoice Header].No_ as Document, [Porteous$Sales Invoice Line].[Line No_], [Porteous$Sales Invoice Line].No_ AS [Item No], 
	   [Porteous$Sales Invoice Line].Description, [Porteous$Sales Invoice Line].Type,
	   [Porteous$Sales Invoice Header].[Location Code] as HdrLoc, 
           [Porteous$Sales Invoice Line].[Location Code] AS [LinLoc],
           [Porteous$Sales Invoice Line].[Shipment Date], 
           [Porteous$Sales Invoice Line].Quantity,
	   [Porteous$Sales Invoice Header].[Sell-to Customer No_], 
           [Porteous$Sales Invoice Header].[Sell-to Customer Name], [Porteous$Sales Invoice Header].[Bill-to Customer No_], 
           [Porteous$Sales Invoice Header].[Bill-to Name], [Porteous$Sales Invoice Header].[Order Date], 
           [Porteous$Sales Invoice Header].[User ID]
FROM       [Porteous$Sales Invoice Header] INNER JOIN
           [Porteous$Sales Invoice Line] ON [Porteous$Sales Invoice Header].No_ = [Porteous$Sales Invoice Line].[Document No_]
WHERE     [Porteous$Sales Invoice Line].Type=2 and [Porteous$Sales Invoice Line].No_ <> ''
Order By [Porteous$Sales Invoice Line].No_



--------------------------------------------------------------------------------------------------------




select * from [Porteous$Sales Invoice Header] where LEFT([No_],2)='DI' or ([No_]>'7000' and [No_]<'8000')
select * from [Porteous$Sales Invoice Line] where LEFT([Document No_],2)='DI' or ([Document No_]>'7000' and [Document No_]<'8000')


select * from [Porteous$Sales Invoice Header] where LEFT([No_],2)<>'IP' and  LEFT([No_],2)<>'DI' and ([No_]<'7000' or [No_]>'8000')
select * from [Porteous$Sales Invoice Line] where LEFT([Document No_],2)<>'IP' and  LEFT([Document No_],2)<>'DI' and ([Document No_]<'7000' or [Document No_]>'8000')



--select * from [Porteous$Sales Invoice Line] where [No_]='4001'

