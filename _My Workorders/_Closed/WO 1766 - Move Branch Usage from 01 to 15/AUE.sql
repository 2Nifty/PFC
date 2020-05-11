SELECT	[Sales Velocity Code] as SVC, [Reorder Point] AS ROP, [Last Date Modified], *
FROM	[Porteous$Stockkeeping Unit] (NoLock)
WHERE	[Location Code]='01' AND [Sales Velocity Code] >= 'A' AND [Sales Velocity Code] <= 'K' AND
	(SUBSTRING([Item No_],12,1) = '0' OR 
	 SUBSTRING([Item No_],12,1) = '1' OR 
	 SUBSTRING([Item No_],12,1) = '5')
	
order by [Sales Velocity Code]



----12647 Records Updated - less than 2 minutes in SQLP
--Update branch 01 SKUs with position 10 equal to 0, 1 or 5 where Sales Velocity code is A..K
--Set the ROP to .3 and set the Sales Velocity code to 'K'
UPDATE	[Porteous$Stockkeeping Unit]
SET	[Sales Velocity Code] = 'K',
	[Reorder Point] = 0.3,
	[Last Date Modified] = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)
WHERE	[Location Code] = '01' AND [Sales Velocity Code] >= 'A' AND [Sales Velocity Code] <= 'K' AND
	(SUBSTRING([Item No_],12,1) = '0' OR 
	 SUBSTRING([Item No_],12,1) = '1' OR 
	 SUBSTRING([Item No_],12,1) = '5')




exec sp_columns [Porteous$Stockkeeping Unit]
exec sp_columns [Porteous$Actual Usage Entry]



SELECT	*
FROM	[Porteous$Actual Usage Entry]
WHERE	[Usage Location] = '01' AND
	(SUBSTRING([Item No_],12,1) = '0' OR 
	 SUBSTRING([Item No_],12,1) = '1' OR 
	 SUBSTRING([Item No_],12,1) = '5')



----217366 Records Updated - less than 5 minutes in SQLP
--Update branch 01 usage where item number position 10 equal to 0, 1 or 5
--Change the usage branch to 15, else leave the usage branch as is
UPDATE	[Porteous$Actual Usage Entry]
SET	[Usage Location] = '15'
WHERE	[Usage Location] = '01' AND
	(SUBSTRING([Item No_],12,1) = '0' OR 
	 SUBSTRING([Item No_],12,1) = '1' OR 
	 SUBSTRING([Item No_],12,1) = '5')
