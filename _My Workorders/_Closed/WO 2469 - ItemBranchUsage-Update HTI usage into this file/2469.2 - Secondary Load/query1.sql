
--6593
----NoAlias tab
--Invalid PFCItem - Invalid AltItem
SELECT	Distinct
	HTI.HTIItem, 
	HTI.PFCItem, HTI.PFCItemFlg, HTI.AltItem, HTI.AltItemFlg
FROM	(SELECT * FROM tWO2469_HTI2009 UNION SELECT * FROM tWO2469_HTI2010) HTI 
WHERE	HTI.PFCItemFlg = 'N' AND HTI.AltItemFlg = 'N'
order by HTI.PFCItem DESC, HTI.HTIItem



update [tWO2469.2_HTIUnmatchedItems]
set 	AltItemFlg = 'N'
WHERE	left(HTIItem,4)='10F1' or left(HTIItem,4)='10R1'




SELECT	*
FROM	tWO2469_HTI2009 HTI2009
WHERE 	(PFCItemFLG = 'N' OR AltItemFlg = 'N') and isnull(HTIItem,'') <> ''
order by HTIItem

SELECT	*
FROM	tWO2469_HTI2010 HTI2010
WHERE 	(PFCItemFLG = 'N' OR AltItemFlg = 'N') and isnull(HTIItem,'') <> ''
order by HTIItem




--Load Create tWO2469.2_HTI2009
SELECT	*
FROM	tWO2469_HTI2009 HTI2009
WHERE	HTIItem IN (SELECT DISTINCT HTIItem--, *
		    FROM   [tWO2469.2_HTIUnmatchedItems]
		    WHERE  PFCItemFLG = 'Y' OR AltItemFlg = 'Y')


SELECT	*
FROM	tWO2469_HTI2010 HTI2010
WHERE	HTIItem IN (SELECT DISTINCT HTIItem--, *
		    FROM   [tWO2469.2_HTIUnmatchedItems]
		    WHERE  PFCItemFLG = 'Y' OR AltItemFlg = 'Y')



select * from [tWO2469.2_HTI2009]

select * from [tWO2469.2_HTI2009Summ]


select * from tWO2469_HTIAlias
where AliasItemNo 
in
('10F14RZ',
'10R10R',
'10R10RQ',
'10R12RQ',
'10R12RZ',
'10R12SJ',
'10R12SZ')



update tWO2469_HTIAlias
set ItemNo = '00200-2400-401'
where AliasItemNo 
in
('10F14RZ',
'10R10R',
'10R10RQ',
'10R12RQ',
'10R12RZ',
'10R12SJ',
'10R12SZ')