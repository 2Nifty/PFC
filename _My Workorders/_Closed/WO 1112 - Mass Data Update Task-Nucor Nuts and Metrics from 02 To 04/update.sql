if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1112NucorNutsAndMetricsAUE') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1112NucorNutsAndMetricsAUE

SELECT	*
INTO	tWO1112NucorNutsAndMetricsAUE
FROM
(
SELECT	DISTINCT [Item No_] AS OldItem, [Usage Location] AS Location,
	CASE LEFT([Item No_],5)
		WHEN '00208' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '021' THEN LEFT([Item No_],11) + '041'
				  END
		WHEN '00209' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '021' THEN LEFT([Item No_],11) + '041'
				  END
		WHEN '00242' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '022' THEN LEFT([Item No_],11) + '042'
				  END
		WHEN '00243' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '022' THEN LEFT([Item No_],11) + '042'
				  END
		WHEN '20056' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '021' THEN LEFT([Item No_],11) + '041'
					WHEN '080' THEN LEFT([Item No_],11) + '090'
					WHEN '081' THEN LEFT([Item No_],11) + '091'
				  END
		WHEN '20057' THEN CASE RIGHT([Item No_],3)
					WHEN '021' THEN LEFT([Item No_],11) + '041'
				  END
		WHEN '20058' THEN CASE RIGHT([Item No_],3)
					WHEN '021' THEN LEFT([Item No_],11) + '041'
				  END
		WHEN '20080' THEN CASE RIGHT([Item No_],3)
					WHEN '020' THEN LEFT([Item No_],11) + '040'
					WHEN '022' THEN LEFT([Item No_],11) + '042'
				  END
	END AS NewItem
FROM	[Porteous$Actual Usage Entry] AUE
WHERE	((LEFT([Item No_],5)='00208' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='00208' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='00209' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='00209' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='00242' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='00242' and RIGHT([Item No_],3)='022') OR 
	 (LEFT([Item No_],5)='00243' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='00243' and RIGHT([Item No_],3)='022') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='080') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='081') OR 
	 (LEFT([Item No_],5)='20057' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='20058' and RIGHT([Item No_],3)='021') OR 
	 (LEFT([Item No_],5)='20080' and RIGHT([Item No_],3)='020') OR 
	 (LEFT([Item No_],5)='20080' and RIGHT([Item No_],3)='022')) AND
	[Usage Location] <> ''
) AUE
WHERE EXISTS (SELECT * FROM [Porteous$Stockkeeping Unit] WHERE [Location Code]=Location AND [Item No_]=NewItem)
ORDER BY OldItem, Location



UPDATE	[Porteous$Actual Usage Entry]
SET	[Item No_]=NewItem,
	[Source Item No_]=NewItem,
	[Variance No_]=RIGHT(NewItem,3),
	[Source Quantity]=ROUND(([Source Quantity] * 1.25),0),
	[Quantity]=ROUND(([Quantity] * 1.25),0)
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN tWO1112NucorNutsAndMetricsAUE ON AUE.[Item No_]=OldItem AND AUE.[Usage Location]=Location
