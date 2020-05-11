--SELECT	*
--INTO	tWO1112NucorNutsAndMetricsAUE
--FROM
--(
SELECT	*
FROM	[Porteous$Actual Usage Entry] AUE
WHERE	((LEFT([Item No_],5)='00208' and RIGHT([Item No_],3)='040') OR 
	 (LEFT([Item No_],5)='00208' and RIGHT([Item No_],3)='041') OR 
	 (LEFT([Item No_],5)='00209' and RIGHT([Item No_],3)='040') OR 
	 (LEFT([Item No_],5)='00209' and RIGHT([Item No_],3)='041') OR 
	 (LEFT([Item No_],5)='00242' and RIGHT([Item No_],3)='040') OR 
	 (LEFT([Item No_],5)='00242' and RIGHT([Item No_],3)='042') OR 
	 (LEFT([Item No_],5)='00243' and RIGHT([Item No_],3)='040') OR 
	 (LEFT([Item No_],5)='00243' and RIGHT([Item No_],3)='042') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='040') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='041') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='090') OR 
	 (LEFT([Item No_],5)='20056' and RIGHT([Item No_],3)='091') OR 
	 (LEFT([Item No_],5)='20057' and RIGHT([Item No_],3)='041') OR 
	 (LEFT([Item No_],5)='20058' and RIGHT([Item No_],3)='041') OR 
	 (LEFT([Item No_],5)='20080' and RIGHT([Item No_],3)='040') OR 
	 (LEFT([Item No_],5)='20080' and RIGHT([Item No_],3)='042')) AND
	[Usage Location] <> '' --and ([Entry No_]='9548094' or [Entry No_]='9441302' or [Entry No_]='9051795')

--) AUE
--WHERE EXISTS (SELECT * FROM [Porteous$Stockkeeping Unit] WHERE [Location Code]=Location AND [Item No_]=NewItem)


ORDER BY [Posting date] DESC --OldItem, Location




select [Exclude from MRP & DP], * from [Porteous$Stockkeeping Unit]
where [Location Code]='03' and [Item No_]='20056-0640-041'





--select * from [Porteous$Actual Usage Entry]