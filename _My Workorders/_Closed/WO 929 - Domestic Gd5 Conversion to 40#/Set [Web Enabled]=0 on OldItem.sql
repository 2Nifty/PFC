--Set [Web Enabled]=0 on OldItem
UPDATE	[Porteous$Item]
SET	[Web Enabled] = 0
FROM
(SELECT	LEFT(NewItem.[No_],11) + RIGHT(NewItem.[No_],1) AS CheckItem04, CheckItem02,
	OldItem.[No_] AS OldItem, NewItem.[No_] AS NewItem,
	OldItem.[Web Enabled] AS OldWebEnabled, NewItem.[Web Enabled] AS NewWebEnabled
 FROM	[Porteous$Item] NewItem
INNER JOIN
(SELECT	LEFT([No_],11) + RIGHT([No_],1) AS CheckItem02, *
 FROM	[Porteous$Item]
 WHERE SUBSTRING([No_],12,2)='02') OldItem
ON	LEFT(NewItem.[No_],11) + RIGHT(NewItem.[No_],1) = CheckItem02
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewItem.[No_] = [40Lb].[Item]) ItemUpd
WHERE	[No_]=OldItem