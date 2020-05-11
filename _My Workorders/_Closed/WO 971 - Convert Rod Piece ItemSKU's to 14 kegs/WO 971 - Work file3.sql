
select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem50, * from [Porteous$Stockkeeping Unit] where (LEFT([Item No_],5)='00170' or
				    LEFT([Item No_],5)='00171' or LEFT([Item No_],5)='04170' or LEFT([Item No_],5)='04171' or LEFT([Item No_],5)='04172') and
				    SUBSTRING([Item No_],12,2)='50' --and [Reorder Point] < 0




select LEFT([ItemNo],11) + RIGHT([ItemNo],1) AS CheckItem50, * from PFCReports.[dbo].SODetailHist where (LEFT([ItemNo],5)='00170' or
				    LEFT([ItemNo],5)='00171' or LEFT([ItemNo],5)='04170' or LEFT([ItemNo],5)='04171' or LEFT([ItemNo],5)='04172') and
				    SUBSTRING([ItemNo],12,2)='50' and [QtyShipped]=0


SELECT	*
INTO	PFCReports.[dbo].tSODetailZeroShipped
FROM	PFCReports.[dbo].SODetailHist
WHERE	(LEFT([ItemNo],5)='00170' or LEFT([ItemNo],5)='00171' or LEFT([ItemNo],5)='04170' or LEFT([ItemNo],5)='04171' or LEFT([ItemNo],5)='04172') and
	 SUBSTRING([ItemNo],12,2)='50' and [QtyShipped]=0



select LEFT(SKU.[Item No_],11) + RIGHT(SKU.[Item No_],1) AS CheckItem50, AUE.[Source Quantity], AUE.[Quantity], * from [Porteous$Stockkeeping Unit] SKU
inner join
[Porteous$Actual Usage Entry] AUE
on
AUE.[Item No_]=SKU.[Item No_] and AUE.[Usage Location]=SKU.[Location Code]
where (LEFT(SKU.[Item No_],5)='00170' or
    LEFT(SKU.[Item No_],5)='00171' or LEFT(SKU.[Item No_],5)='04170' or LEFT(SKU.[Item No_],5)='04171' or LEFT(SKU.[Item No_],5)='04172') and
    SUBSTRING(SKU.[Item No_],12,2)='50' and ([Source Quantity] = 0 or [Quantity] = 0)
	--and [Source Quantity] < 0 and [Quantity] > 0


select PFCReports.[dbo].SODetailHist.*
FROM	PFCReports.[dbo].SOHeaderHist INNER JOIN
	PFCReports.[dbo].SODetailHist ON pSOHeaderHistID = fSOHeaderHistID
--INNER JOIN
--(SELECT	*
--FROM	tRodItems) Rods
--ON	[ItemNo]=Rods.[Item No_] COLLATE SQL_Latin1_General_CP1_CI_AS and [UsageLoc]=Rods.[Location Code] COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	[QtyShipped] = 0 and
	NOT EXISTS (SELECT * FROM PFCReports.[dbo].tSODetailZeroShipped)





select ROUND(-0.6,0)
