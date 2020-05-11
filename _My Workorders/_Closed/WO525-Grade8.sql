

select * from [Porteous$Actual Usage Entry] where [Item No_]<>[Source Item No_]

SELECT     [tempAUE].[Entry No_], [tempAUE].[Item No_] AS ItemNo, [tempAUE].[Source Item No_], [tempAUE].[Cat_ No_], 
                      [tempAUE].[Size No_], [tempAUE].[Variance No_], tempGrade8.[Old number], tempGrade8.[New number]
FROM         [tempAUE] INNER JOIN
                      tempGrade8 ON [tempAUE].[Item No_] = tempGrade8.[Old number]
WHERE     (tempGrade8.[Old number] <> tempGrade8.[New number]) and [tempAUE].[Item No_]<>[tempAUE].[Source Item No_]
ORDER BY ItemNo


SELECT     [tempAUE].[Entry No_], [tempAUE].[Item No_] AS ItemNo, [tempAUE].[Source Item No_], [tempAUE].[Cat_ No_], 
                      [tempAUE].[Size No_], [tempAUE].[Variance No_]
FROM         [tempAUE] 
WHERE     [tempAUE].[Item No_]='00080-2408-040'
order by [Entry No_]


SELECT     [Porteous$Actual Usage Entry].[Entry No_], [Porteous$Actual Usage Entry].[Item No_] AS ItemNo, [Porteous$Actual Usage Entry].[Source Item No_], [Porteous$Actual Usage Entry].[Cat_ No_], 
                      [Porteous$Actual Usage Entry].[Size No_], [Porteous$Actual Usage Entry].[Variance No_]
FROM         [Porteous$Actual Usage Entry] 
WHERE     [Porteous$Actual Usage Entry].[Item No_]='00080-2408-040'
order by [Entry No_]




----------------------

update	[Porteous$Actual Usage Entry]
set	[Porteous$Actual Usage Entry].[Item No_] = tempGrade8.[New number], [Porteous$Actual Usage Entry].[Source Item No_] = tempGrade8.[New number],
	[Porteous$Actual Usage Entry].[Cat_ No_] = SUBSTRING(tempGrade8.[New number], 1, 5),
	[Porteous$Actual Usage Entry].[Size No_] = SUBSTRING(tempGrade8.[New number], 7, 4),
	[Porteous$Actual Usage Entry].[Variance No_] = SUBSTRING(tempGrade8.[New number], 12, 3)
FROM         [Porteous$Actual Usage Entry] INNER JOIN
                      tempGrade8 ON [Porteous$Actual Usage Entry].[Item No_] = tempGrade8.[Old number]
WHERE     (tempGrade8.[Old number] <> tempGrade8.[New number])


--------------------