select 
	'' AS [Notification Process Code],
	3 AS [Queue Priority],		--This appears to be populated with other values in 3.7
	0 AS [FQA Required],
	0 AS [Cert Required],
	'' AS [Rebate Group],
	0 AS [Backorder],		--This appears to be populated with other values in 3.7
	'' AS [Delivery Route],
	'' AS [Delivery Stop],
	0 AS [EDI Invoice],		--This appears to be populated with other values in 3.7
	'' AS [E-Ship Agent Service],	--This appears to be populated with other values in 3.7
	0 AS [Free Freight],		--This appears to be populated with other values in 3.7
	0 AS [Residential Delivery],
	'' AS [IRS EIN Number],
	0 AS [Blind Shipment],
	0 AS [Double Blind Shipment],
	'' AS [Double Blind Ship-from Cust No],
	0 AS [No Free Freight Lines on Order],
	0 AS [Shipping Payment Type],	--This appears to be populated with other values in 3.7
	0 AS [Shipping Insurance],
	'' AS [External No_],
	'' AS [Default Ship-for Code],	--This appears to be populated with other values in 3.7
	'' AS [Packing Rule Code],	--This appears to be populated with other values in 3.7
	'' AS [E-Mail Rule Code],
	GETDATE() AS [E-Mail Cust_ Stat_ Send Date],
	0 AS [Use E-Mail Rule for ShipToAddr],
	15 AS [Review Days],		--This appears to be populated with other values in 3.7
	25 AS [Call Days],		--This appears to be populated with other values in 3.7
	35 AS [Hold Days],		--This appears to be populated with other values in 3.7
	'' AS [Default Ship-To Code],	--This appears to be populated with other values in 3.7
	0 AS [Purchase Order Required],	--This appears to be populated with other values in 3.7
	'' AS [Broker_Agent Code],
	0 AS [Tool Repair Priority],
	'' AS [Tool Repair Tech], *








select [No_], [Queue Priority],


select [No_], [Backorder],
select [No_], [EDI Invoice],
select [No_], [E-Ship Agent Service],
select [No_], [Free Freight],
select [No_], [Shipping Payment Type],
[Default Ship-for Code],
[Packing Rule Code],
[Review Days],
[Call Days],
[Hold Days],
[Default Ship-To Code],
[Purchase Order Required], *

from [Porteous$Customer] 
WHERE 

	[Queue Priority]<>3 OR 		 	--This appears to be populated with other values in 3.7
	[Backorder]<>0 OR 			--This appears to be populated with other values in 3.7
	[EDI Invoice]<>0 OR 			--This appears to be populated with other values in 3.7
	[E-Ship Agent Service]<>'' OR 		--This appears to be populated with other values in 3.7
	[Free Freight]<>0 OR  			--This appears to be populated with other values in 3.7
	[Shipping Payment Type]<>0 OR  		--This appears to be populated with other values in 3.7
	[Default Ship-for Code]<>'' OR 		--This appears to be populated with other values in 3.7
	[Packing Rule Code]<>'' OR 		--This appears to be populated with other values in 3.7
	[Review Days]<>15 OR  			--This appears to be populated with other values in 3.7
	[Call Days]<>25 OR 	 		--This appears to be populated with other values in 3.7
	[Hold Days]<>35 OR 	 		--This appears to be populated with other values in 3.7
	[Default Ship-To Code]<>'' OR 		--This appears to be populated with other values in 3.7
	[Purchase Order Required]<>0 	 	--This appears to be populated with other values in 3.7




--select [Shipping Insurance], * from [Porteous$Customer] where [No_]='201073'





select [Use E-Mail Rule for ShipToAddr],* from [Porteous$Customer] where [Use E-Mail Rule for ShipToAddr]<>0





select [No_], [Queue Priority]
from [Porteous$Customer]
WHERE	[Queue Priority]<>3  		 	--This appears to be populated with other values in 3.7

select [No_], [Backorder]
from [Porteous$Customer]
WHERE	[Backorder]<>0  			--This appears to be populated with other values in 3.7

select [No_], [EDI Invoice]
from [Porteous$Customer]
WHERE	[EDI Invoice]<>0  			--This appears to be populated with other values in 3.7


select [No_], [E-Ship Agent Service]
from [Porteous$Customer]
WHERE	[E-Ship Agent Service]<>''  		--This appears to be populated with other values in 3.7


select [No_], [Free Freight]
from [Porteous$Customer]
WHERE	[Free Freight]<>0   			--This appears to be populated with other values in 3.7


select [No_], [Shipping Payment Type]
from [Porteous$Customer]
WHERE	[Shipping Payment Type]<>0   		--This appears to be populated with other values in 3.7


select [No_], [Default Ship-for Code]
from [Porteous$Customer]
WHERE	[Default Ship-for Code]<>'' 		--This appears to be populated with other values in 3.7


select [No_], [Packing Rule Code]
from [Porteous$Customer]
WHERE	[Packing Rule Code]<>''  		--This appears to be populated with other values in 3.7


select [No_], [Review Days]
from [Porteous$Customer]
WHERE	[Review Days]<>15   			--This appears to be populated with other values in 3.7


select [No_], [Call Days]
from [Porteous$Customer]
WHERE	[Call Days]<>25  	 		--This appears to be populated with other values in 3.7


select [No_], [Hold Days]
from [Porteous$Customer]
WHERE	[Hold Days]<>35  	 		--This appears to be populated with other values in 3.7


select [No_], [Default Ship-To Code]
from [Porteous$Customer]
WHERE	[Default Ship-To Code]<>''  		--This appears to be populated with other values in 3.7


select [No_], [Purchase Order Required]
from [Porteous$Customer]
WHERE	[Purchase Order Required]<>0 	 	--This appears to be populated with other values in 3.7

