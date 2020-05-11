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
