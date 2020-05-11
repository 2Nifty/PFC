



--select * from [Porteous$Sales Cr_Memo Line]


RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2)



SELECT		CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2) AS [Date],
		[Location Code], [Return Reason Code], RIGHT('000' + CAST(COUNT([Return Reason Code]) as VARCHAR(3)),3) AS RecordCount, SUM(ExtValue) AS ExtendedValue
FROM		(SELECT [Posting Date], [Location Code], [Return Reason Code], [Document No_], [Line No_],
			[Sell-to Customer No_], Type, No_, Quantity, Quantity * [Unit Cost (LCY)] AS ExtValue
		 FROM	[Porteous$Sales Cr_Memo Line]
		 WHERE	(Quantity * [Unit Cost (LCY)] > 0) and ([Return Reason Code]<>'') and (Type = 2)) Reasons

--		 WHERE	(Quantity * [Unit Cost (LCY)] > 0) and ([Return Reason Code]<>'') and 
--			([Posting Date] BETWEEN CONVERT(DATETIME, '2008-03-01 00:00:00', 102) AND
--						CONVERT(DATETIME, '2008-03-29 00:00:00', 102)) AND (Type = 2)) Reasons


GROUP BY	[Location Code], [Return Reason Code], CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2)
ORDER BY	CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + RIGHT('00' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)),2), [Location Code], [Return Reason Code]



--WHERE	[Last Date Modified] = 
--CAST(DATEPART(yyyy,Getdate()) as varchar(4)) + '-' + CAST(DATEPART(mm,GETDATE()) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GETDATE()) AS varchar(2)) and




select [Salesperson Code], * from [Porteous$Customer]
Order By [Salesperson Code]


	

SelCmd = "SELECT CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)) AS [Date], [Location Code], [Return Reason Code], COUNT([Return Reason Code]) AS RecordCount, SUM(ExtValue) AS ExtendedValue FROM (SELECT [Posting Date], [Location Code], [Return Reason Code], [Document No_], [Line No_], [Sell-to Customer No_], Type, No_, Quantity, Quantity * [Unit Cost (LCY)] AS ExtValue FROM [Porteous$Sales Cr_Memo Line] WHERE (Quantity * [Unit Cost (LCY)] > 0) and ([Return Reason Code]<>'') and (Type = 2)) Reasons GROUP BY [Location Code], [Return Reason Code], CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)) ORDER BY CAST(DATEPART(yyyy,[Posting Date]) as VARCHAR(4)) + '/' + CAST(DATEPART(mm,[Posting Date]) as varchar(2)), [Location Code], [Return Reason Code]"
