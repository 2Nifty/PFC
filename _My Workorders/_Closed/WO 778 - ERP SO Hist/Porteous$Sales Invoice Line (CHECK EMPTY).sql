SELECT	[VAT %],
	[Units per Parcel],
	[Unit Volume],
	[Appl_-to Item Entry],
--	[Shortcut Dimension 2 Code],
	[Job No_],
	[Appl_-to Job Entry],
	[Phase Code],
	[Task Code],
	[Step Code],
	[Job Applies-to ID],
	[Apply and Close (Job)],
	[Work Type Code],
--	[Drop Shipment],
--	[VAT Calculation Type],
	[Transaction Type],
	[Transport Method],
	[Attached to Line No_],
	[Exit Point],
	[Area],
	[Transaction Specification],
	[Tax Area Code],
	[Tax Liable],
	[Tax Group Code],
	[VAT Bus_ Posting Group],
	[VAT Prod_ Posting Group],
	[Blanket Order No_],
	[Blanket Order Line No_],
	[VAT Difference],
	[VAT Identifier],
	[Variant Code],
--	[Bin Code],
--	[FA Posting Date],
	[Depreciation Book Code],
	[Depr_ until FA Posting Date],
	[Duplicate in Depreciation Book],
	[Use Duplication List],
	[Responsibility Center],
--	[Purchasing Code],
	[Product Group Code],
	[Appl_-from Item Entry],
	[Service Contract No_],
	[Service Order No_],
	[Service Item No_],
	[Appl_-to Service Entry],
	[Service Item Line No_],
	[Serv_ Price Adjmt_ Gr_ Code],
--	[Package Tracking No_],
	[EDI Item Cross Ref_],
--	[EDI Unit of Measure],
--	[EDI Segment Group],
--	[Shipping Charge],
	[Qty_ Packed (Base)],
--	[Pack],
	[Rate Quoted],
	[Std_ Package Unit of Meas Code],
	[Std_ Package Quantity],
	[Qty_ per Std_ Package],
	[Std_ Package Qty_ to Ship],
	[Std_ Packs per Package],
	[Package Quantity],
	[Package Qty_ to Ship],
	[E-Ship Whse_ Outst_ Qty (Base)],
--	[Shipping Charge BOL No_],
	[Required Shipping Agent Code],
	[Required E-Ship Agent Service],
	[Allow Other Ship_ Agent_Serv_],
--	[Order Date],
	[Manufacturer Code],
	[Tool Repair Tech],
	[List Price],
--	[Ship-to PO No_],
	[Shipping Advice],
	[Resource Group No_],
	[Tag No_],
	[Customer Bin],
	[FB Order No_],
	[FB Line No_],
	[Ship-to Code],
	[Vendor No_],
	[Vendor Item No_],
	[Prod_ Order No_],
	[Excl_ from Usage],
--	[EDI Original UOM],
--	[Residential Delivery],
	[COD Payment],
	[World Wide Service],
	[E-Ship Agent Code],
	[E-Ship Agent Service],
	[Shipping Payment Type],
	[Third Party Ship_ Account No_],
	[Shipping Insurance] --,
--	[Shipment No_],
--	[Shipment Line No_],
--	[Back Order],
--	[Back Order Qty]
FROM	[Porteous$Sales Invoice Line]
WHERE
	[VAT %] <> .0 or 
	[Units per Parcel] <> .0 or 
	[Unit Volume] <> .0 or 
	[Appl_-to Item Entry] <> 0 or 
--	[Shortcut Dimension 2 Code] <> '' or 
	[Job No_] <> '' or 
	[Appl_-to Job Entry] <> 0 or 
	[Phase Code] <> '' or 
	[Task Code] <> '' or 
	[Step Code] <> '' or 
	[Job Applies-to ID] <> '' or 
	[Apply and Close (Job)] <> 0 or 
	[Work Type Code] <> '' or 
--	[Drop Shipment] <> 0 or 
--	[VAT Calculation Type] <> 0 or 
	[Transaction Type] <> '' or 
	[Transport Method] <> '' or 
	[Attached to Line No_] <> 0 or 
	[Exit Point] <> '' or 
	[Area] <> '' or 
	[Transaction Specification] <> '' or 
	[Tax Area Code] <> '' or 
	[Tax Liable] <> 0 or 
	[Tax Group Code] <> '' or 
	[VAT Bus_ Posting Group] <> '' or 
	[VAT Prod_ Posting Group] <> '' or 
	[Blanket Order No_] <> '' or 
	[Blanket Order Line No_] <> 0 or 
	[VAT Difference] <> .0 or 
	[VAT Identifier] <> '' or 
	[Variant Code] <> '' or 
--	[Bin Code] <> '' or 
--	([FA Posting Date] <> 0 and CAST([FA Posting Date] as VARCHAR(20)) NOT LIKE '1753%') or 
	[Depreciation Book Code] <> '' or 
	[Depr_ until FA Posting Date] <> 0 or 
	[Duplicate in Depreciation Book] <> '' or 
	[Use Duplication List] <> 0 or 
	[Responsibility Center] <> '' or 
--	[Purchasing Code] <> '' or 
	[Product Group Code] <> '' or 
	[Appl_-from Item Entry] <> 0 or 
	[Service Contract No_] <> '' or 
	[Service Order No_] <> '' or 
	[Service Item No_] <> '' or 
	[Appl_-to Service Entry] <> 0 or 
	[Service Item Line No_] <> 0 or 
	[Serv_ Price Adjmt_ Gr_ Code] <> '' or 
--	[Package Tracking No_] <> '' or 
	[EDI Item Cross Ref_] <> '' or 
--	[EDI Unit of Measure] <> '' or 
--	[EDI Segment Group] <> 0 or 
--	[Shipping Charge] <> 0 or 
	[Qty_ Packed (Base)] <> .0 or 
--	[Pack] <> 1 or 
	[Rate Quoted] <> 0 or 
	[Std_ Package Unit of Meas Code] <> '' or 
	[Std_ Package Quantity] <> .0 or 
	[Qty_ per Std_ Package] <> .0 or 
	[Std_ Package Qty_ to Ship] <> .0 or 
	[Std_ Packs per Package] <> 0 or 
	[Package Quantity] <> .0 or 
	[Package Qty_ to Ship] <> .0 or 
	[E-Ship Whse_ Outst_ Qty (Base)] <> .0 or 
--	[Shipping Charge BOL No_] <> '' or 
	[Required Shipping Agent Code] <> '' or 
	[Required E-Ship Agent Service] <> '' or 
	[Allow Other Ship_ Agent_Serv_] <> 0 or 
--	([Order Date] <> 0 and CAST([Order Date] as VARCHAR(20)) NOT LIKE '1753%') or 
	[Manufacturer Code] <> '' or 
	[Tool Repair Tech] <> '' or 
	[List Price] <> .0 or 
--	[Ship-to PO No_] <> '' or 
	[Shipping Advice] <> 0 or 
	[Resource Group No_] <> '' or 
	[Tag No_] <> '' or 
	[Customer Bin] <> '' or 
	[FB Order No_] <> '' or 
	[FB Line No_] <> 0 or 
	[Ship-to Code] <> '' or 
	[Vendor No_] <> '' or 
	[Vendor Item No_] <> '' or 
	[Prod_ Order No_] <> '' or 
	[Excl_ from Usage] <> 0 or 
--	[EDI Original UOM] <> '' or 
--	[Residential Delivery] <> 0 or 
	[COD Payment] <> 0 or 
	[World Wide Service] <> 0 or 
	[E-Ship Agent Code] <> '' or 
	[E-Ship Agent Service] <> '' or 
	[Shipping Payment Type] <> 0 or 
	[Third Party Ship_ Account No_] <> '' or 
	[Shipping Insurance] <> 0 --or 
--	[Shipment No_] <> '' or 
--	[Shipment Line No_] <> 0 or 
--	[Back Order] <> 0 or 
--	[Back Order Qty] <> .0
