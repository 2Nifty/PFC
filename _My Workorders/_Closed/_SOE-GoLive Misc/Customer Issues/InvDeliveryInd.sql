select [EDI Invoice], [Document Delivery], [Last Date Modified], [Last Modified By], * from [Porteous$Customer] where No_='100029'



UPDATE	[Porteous$Customer]
SET	[EDI Invoice]=0,
	[Document Delivery]=1,
	[Last Date Modified]=CAST(FLOOR( CAST( GetDate() AS FLOAT ) )AS DATETIME),
	[Last Modified By]='TOD'
WHERE	No_='100029'