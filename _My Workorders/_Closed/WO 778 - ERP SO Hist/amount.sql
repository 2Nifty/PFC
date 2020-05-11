
select	[Document No_], [Line No_], [No_], [Unit Price], [Net Unit Price],
	[Unit Cost (LCY)], [Unit Cost], [Amount], [Amount Including VAT],
	[VAT Base Amount], [Line Amount]
from	[Porteous$Sales Invoice Line]
where	[Unit Price] <> [Net Unit Price] or 
--	[Unit Cost (LCY)] <> [Unit Cost] or
	[Amount] <> [Amount Including VAT] or [Amount] <> [VAT Base Amount] or
	[Amount] <> [Line Amount]



--exec sp_columns SOHeaderHist


select	[Document No_], [Line No_], [No_], [Quantity], [Unit Price], [Net Unit Price], [Unit Cost (LCY)], [Unit Cost],
	[Amount], [Amount Including VAT], [VAT Base Amount], [Line Amount]
from	[Porteous$Sales Invoice Line]
where	
--	[Unit Price]<>[Net Unit Price] or 
--	[Unit Cost (LCY)] <>[Unit Cost] or
	[Amount]<>0 and [Amount Including VAT]<>0 and [VAT Base Amount]<>0 and [Line Amount]<>0 and
	([Amount]<>[Amount Including VAT] or [Amount]<>[VAT Base Amount] or [Amount]<>[Line Amount])




select	[Document No_], [Line No_], [No_], [Quantity], [Amount], [Amount Including VAT], [VAT Base Amount]
from	[Porteous$Sales Invoice Line]
where	
--	[Unit Price]<>[Net Unit Price] or 
--	[Unit Cost (LCY)] <>[Unit Cost] or
	[Amount]<>0 and [Amount Including VAT]<>0 and [VAT Base Amount]<>0 and
	([Amount]<>[Amount Including VAT] or [Amount]<>[VAT Base Amount])