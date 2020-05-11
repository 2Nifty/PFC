SELECT
[No_],
[Bill-to Name 2],  
----[Posting Description],  
--[Shortcut Dimension 1 Code],  
--[Shortcut Dimension 2 Code],  
--[Customer Posting Group],  
[Applies-to Doc_ Type],  
[Applies-to Doc_ No_],    
--[Gen_ Bus_ Posting Group],   
[Sell-to Customer Name 2],   
--[Pre-Assigned No_ Series],  
--[No_ Series],  
--[Order No_ Series],  
--[Pre-Assigned No_],  
[Ship-to UPS Zone],   
------[EDI Order],  
------[EDI Internal Doc_ No_],  
------[EDI Invoice Generated],  
----[EDI Inv_ Gen_ Date],   
----[EDI Ack_ Gen_ Date],  
----[EDI WHSE Shp_ Gen Date],  
[EDI Trade Partner],  
[EDI Sell-to Code],    
--[Residential Delivery],  
--[Blind Shipment],   
--[E-Mail Confirmation Handled],  
--[E-Mail Invoice Notice Handled],  
--[Entered Date],  
[E-Mail],    
--[Tool Repair Priority],   
----[Date Sent],  
----[Time Sent],   
[eConnect Ref_ No_],  
[eConnect Order],   
------[Get Shipment Used],   
[ContractNo]
FROM [Porteous$Sales Invoice Header] WHERE
[Bill-to Name 2] <> '' or 
----([Posting Description] <> '' and [Posting Description] NOT LIKE 'Invoice%' and [Posting Description] NOT LIKE 'Order%' and [Posting Description] NOT LIKE 'Credit%') or 
--[Shortcut Dimension 1 Code] <> '' or 
--[Shortcut Dimension 2 Code] <> '' or 
--[Customer Posting Group] <> '' or 
[Applies-to Doc_ Type] <> 0 or 
[Applies-to Doc_ No_] <> '' or 
--[Gen_ Bus_ Posting Group] <> '' or 
[Sell-to Customer Name 2] <> '' or 
--[Pre-Assigned No_ Series] <> '' or 
--[No_ Series] <> '' or 
--[Order No_ Series] <> '' or 
--[Pre-Assigned No_] <> '' or 
[Ship-to UPS Zone] <> '' or 
------[EDI Order] <> 0 or 
------[EDI Internal Doc_ No_] <> '' or 
------[EDI Invoice Generated] <> 0 or 
----([EDI Inv_ Gen_ Date] <> 0 and CAST([EDI Inv_ Gen_ Date] as VARCHAR(20)) NOT LIKE '1753%') or 
----([EDI Ack_ Gen_ Date] <> 0 and CAST([EDI Ack_ Gen_ Date] as VARCHAR(20)) NOT LIKE '1753%') or 
----([EDI WHSE Shp_ Gen Date] <> 0 and CAST([EDI WHSE Shp_ Gen Date] as VARCHAR(20)) NOT LIKE '1753%') or 
[EDI Trade Partner] <> '' or 
[EDI Sell-to Code] <> '' or 
--[Residential Delivery] <> 0 or 
--[Blind Shipment] <> 0 or 
--[E-Mail Confirmation Handled] <> 0 or 
--[E-Mail Invoice Notice Handled] <> 0 or 
--[Entered Date] <> 0 or 
[E-Mail] <> '' or 
--[Tool Repair Priority] <> 0 or 
----([Date Sent] <> 0 and CAST([Date Sent] as VARCHAR(20)) NOT LIKE '1753%') or 
----([Time Sent] <> 0 and CAST([Time Sent] as VARCHAR(20)) NOT LIKE '1753%') or 
[eConnect Ref_ No_] <> '' or 
[eConnect Order] <> 0 or 
------[Get Shipment Used] <> 0 or 
[ContractNo] <> ''
order by [No_]










SELECT
[No_], 
[Currency Code],  
[Currency Factor],  
[Prices Including VAT],  
[Language Code],  
--[Applies-to Doc_ Type],  
--[Applies-to Doc_ No_],  
[Bal_ Account No_],  
[Job No_],  
[VAT Registration No_],  
[Reason Code],   
[EU 3-Party Trade],  
[Transaction Type],  
[Transport Method],  
[Exit Point],  
[Correction],  
[Area],  
[Transaction Specification],  
[Tax Area Code],  
[Tax Liable],  
[VAT Bus_ Posting Group],  
[VAT Base Discount %],  
[Campaign No_],  
[Responsibility Center],  
[Service Mgt_ Document],  
--[Ship-to UPS Zone],  
[Unit Price Orgin],   
[EDI Ack_ Generated],    
[EDI WHSE Shp_ Gen],   
--[EDI Trade Partner],  
--[EDI Sell-to Code],  
[EDI Ship-to Code],  
[EDI Ship-for Code],    
[Double Blind Shipment],  
[Double Blind Ship-from Cust No],  
[No Free Freight Lines on Order],   
[Tool Repair Tech],  
--[E-Mail],  
[Ship-to PO No_],  
[Broker_Agent Code],  
[FB Order No_],   
[Manufacturer Code],  
[Serial No_],  
[Tool Model No_],  
[Tool Item No_],  
[Tool Description],  
[Tool Repair Ticket],  
[Tool Repair Parts Warranty],  
[Tool Repair Labor Warranty],  
[BizTalk Sales Invoice],  
[Customer Order No_],  
[BizTalk Document Sent],  
[Excl_ from Usage],  
--[eConnect Ref_ No_],  
[Total Freight],  
[Total Tax],  
--[eConnect Order],  
[eConnect Order Status],  
[Credit Card ID],  
[Credit Card No],  
[Credit Card Month],  
[Credit Card Year],  
[Credit Card Name],  
[Invoice Detail Sort]  
--, [ContractNo]
FROM [Porteous$Sales Invoice Header] WHERE
[Currency Code] <> '' or 
[Currency Factor] <> 0 or 
[Prices Including VAT] <> 0 or 
[Language Code] <> '' or 
--[Applies-to Doc_ Type] <> 0 or 
--[Applies-to Doc_ No_] <> '' or 
[Bal_ Account No_] <> '' or 
[Job No_] <> '' or 
[VAT Registration No_] <> '' or 
[Reason Code] <> '' or 
[EU 3-Party Trade] <> '' or 
[Transaction Type] <> '' or 
[Transport Method] <> '' or 
[Exit Point] <> '' or 
[Correction] <> 0 or 
[Area] <> '' or 
[Transaction Specification] <> '' or 
[Tax Area Code] <> '' or 
[Tax Liable] <> 0 or 
[VAT Bus_ Posting Group] <> '' or 
[VAT Base Discount %] <> 0 or 
[Campaign No_] <> '' or 
[Responsibility Center] <> '' or 
[Service Mgt_ Document] <> 0 or 
--[Ship-to UPS Zone] <> '' or 
[Unit Price Orgin] <> '' or 
[EDI Ack_ Generated] <> 0 or 
[EDI WHSE Shp_ Gen] <> 0 or 
--[EDI Trade Partner] <> '' or 
--[EDI Sell-to Code] <> '' or 
[EDI Ship-to Code] <> '' or 
[EDI Ship-for Code] <> '' or 
[Double Blind Shipment] <> 0 or 
[Double Blind Ship-from Cust No] <> '' or 
[No Free Freight Lines on Order] <> 0 or 
[Tool Repair Tech] <> '' or 
--[E-Mail] <> '' or 
[Ship-to PO No_] <> '' or 
[Broker_Agent Code] <> '' or 
[FB Order No_] <> '' or 
[Manufacturer Code] <> '' or 
[Serial No_] <> '' or 
[Tool Model No_] <> '' or 
[Tool Item No_] <> '' or 
[Tool Description] <> '' or 
[Tool Repair Ticket] <> 0 or 
[Tool Repair Parts Warranty] <> '' or 
[Tool Repair Labor Warranty] <> '' or 
[BizTalk Sales Invoice] <> 0 or 
[Customer Order No_] <> '' or 
[BizTalk Document Sent] <> 0 or 
[Excl_ from Usage] <> 0 or 
--[eConnect Ref_ No_] <> '' or 
[Total Freight] <> 0 or 
[Total Tax] <> 0 or 
--[eConnect Order] <> 0 or 
[eConnect Order Status] <> '' or 
[Credit Card ID] <> '' or 
[Credit Card No] <> '' or 
[Credit Card Month] <> 0 or 
[Credit Card Year] <> 0 or 
[Credit Card Name] <> '' or 
[Invoice Detail Sort] <> 0 
-- or [ContractNo] <> ''
order by [No_]