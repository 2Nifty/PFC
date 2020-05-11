
SELECT
[No_], 
[Currency Code],  
[Currency Factor],  
[Prices Including VAT],  
[Language Code],    
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
[Unit Price Orgin],   
--[EDI Ack_ Generated],    
--[EDI WHSE Shp_ Gen],    
--[EDI Ship-to Code],  
--[EDI Ship-for Code],    
--[Double Blind Shipment],  
--[Double Blind Ship-from Cust No],  
--[No Free Freight Lines on Order],   
--[Tool Repair Tech],  
[Ship-to PO No_],  
[Broker_Agent Code],  
--[FB Order No_],   
--[Manufacturer Code],  
--[Serial No_],  
--[Tool Model No_],  
--[Tool Item No_],  
--[Tool Description],  
--[Tool Repair Ticket],  
[Tool Repair Parts Warranty],  
[Tool Repair Labor Warranty],  
--[BizTalk Sales Invoice],  
--[Customer Order No_],  
[BizTalk Document Sent]  
--,[Excl_ from Usage],    
--[Total Freight],  
--[Total Tax],    
--[eConnect Order Status],  
--[Credit Card ID],  
--[Credit Card No],  
--[Credit Card Month],  
--[Credit Card Year],  
--[Credit Card Name],  
--[Invoice Detail Sort]  
FROM [Porteous$Sales Cr_Memo Header] WHERE
[Currency Code] <> '' or 
[Currency Factor] <> 0 or 
[Prices Including VAT] <> 0 or 
[Language Code] <> '' or 
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
[Unit Price Orgin] <> '' or 
--[EDI Ack_ Generated] <> 0 or 
--[EDI WHSE Shp_ Gen] <> 0 or 
--[EDI Ship-to Code] <> '' or 
--[EDI Ship-for Code] <> '' or 
--[Double Blind Shipment] <> 0 or 
--[Double Blind Ship-from Cust No] <> '' or 
--[No Free Freight Lines on Order] <> 0 or 
--[Tool Repair Tech] <> '' or 
[Ship-to PO No_] <> '' or 
[Broker_Agent Code] <> '' or 
--[FB Order No_] <> '' or 
--[Manufacturer Code] <> '' or 
--[Serial No_] <> '' or 
--[Tool Model No_] <> '' or 
--[Tool Item No_] <> '' or 
--[Tool Description] <> '' or 
--[Tool Repair Ticket] <> 0 or 
[Tool Repair Parts Warranty] <> '' or 
[Tool Repair Labor Warranty] <> '' or 
--[BizTalk Sales Invoice] <> 0 or 
--[Customer Order No_] <> '' or 
[BizTalk Document Sent] <> 0 --or 
--[Excl_ from Usage] <> 0 or  
--[Total Freight] <> 0 or 
--[Total Tax] <> 0 or 
--[eConnect Order Status] <> '' or 
--[Credit Card ID] <> '' or 
--[Credit Card No] <> '' or 
--[Credit Card Month] <> 0 or 
--[Credit Card Year] <> 0 or 
--[Credit Card Name] <> '' or 
--[Invoice Detail Sort] <> 0 
order by [No_]