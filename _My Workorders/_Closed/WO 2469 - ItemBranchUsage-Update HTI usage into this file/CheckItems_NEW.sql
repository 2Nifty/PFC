
SELECT	distinct LoadID, LoadDt
FROM	HTIUsage
WHERE	isnull(LoadID,'') = 'WO2469.2_Secondary_HTI_Usage_History_Load'


--------------------------------------------------------------------------------------------------
--6578
----NoAlias tab
--Invalid PFCItem - Invalid AltItem
SELECT	Distinct
	HTIItem, 
	PFCItem, PFCItemFlg, AltItem, AltItemFlg--, isnull(DeleteDt,'') as ItemDelDt
FROM	HTIUsage --LEFT OUTER JOIN
--	ItemMaster (NoLock)
--ON	PFCItem = ItemNo
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'N'
order by PFCItem DESC, HTIItem

--Check Delete dates on ItemMaster
SELECT	DeleteDt, * FROM ItemMaster WHERE ItemNo in
(SELECT	Distinct
	PFCItem
FROM	tWO2469_HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'N' AND isnull(PFCItem,'') <> '')
order by ItemNo

SELECT	DeleteDt, * FROM ItemMaster WHERE ItemNo in
(SELECT	Distinct
	AltItem
FROM	tWO2469_HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'N' AND isnull(AltItem,'') <> '')
order by ItemNo


--------------------------------------------------------------------------------------------------

----NoAltPFC tab
--Valid PFCItem - Invalid AltItem
SELECT	Distinct
	HTIItem,
	PFCItem, 
	PFCItemFlg, AltItem, AltItemFlg
FROM	HTIUsage
WHERE	PFCItemFlg = 'Y' AND AltItemFlg = 'N'
	and isnull(LoadID,'') = 'WO2469.2_Secondary_HTI_Usage_History_Load'
order by HTIItem 

select deletedt, * from Itemmaster where ItemNo in
(SELECT	Distinct
	AltItem
FROM	HTIUsage
WHERE	PFCItemFlg = 'Y' AND AltItemFlg = 'N' and isnull(LoadID,'') = 'WO2469.2_Secondary_HTI_Usage_History_Load')



--------------------------------------------------------------------------------------------------

----InvalidPFC tab
--Invalid PFCItem - Valid AltItem
SELECT	Distinct
	HTIItem, PFCItem, PFCItemFlg, AltItem, AltItemFlg--, isnull(DeleteDt,'') as ItemDelDt
FROM	HTIUsage --LEFT OUTER JOIN
--	ItemMaster (NoLock)
--ON	PFCItem = ItemNo
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'Y'
	and isnull(LoadID,'') = 'WO2469.2_Secondary_HTI_Usage_History_Load'
order by HTIItem



--Check Delete dates on ItemMaster
SELECT	DeleteDt, * FROM ItemMaster WHERE ItemNo in
(SELECT	Distinct
	PFCItem
--FROM	tWO2469_HTIUsage
FROM	HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'Y' AND isnull(PFCItem,'') <> '' and isnull(LoadID,'') = 'WO2469.2_Secondary_HTI_Usage_History_Load')
order by ItemNo

SELECT	DeleteDt, * FROM ItemMaster WHERE ItemNo in
(SELECT	Distinct
	AltItem
--FROM	tWO2469_HTIUsage
FROM	HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'Y' AND isnull(AltItem,'') <> '' and isnull(LoadID,'') = 'WO2469.2_Secondary_HTI_Usage_History_Load')
order by ItemNo






--------------------------------------------------------------------------------------------------

----ValidAlt tab
--Valid PFCItem - Valid AltItem
SELECT	Distinct
	HTIItem, PFCItem, PFCItemFlg, AltItem, AltItemFlg
FROM	HTIUsage
WHERE	PFCItemFlg = 'Y' AND AltItemFlg = 'Y'
	and isnull(LoadID,'') = 'WO2469.2_Secondary_HTI_Usage_History_Load'
order by HTIItem

--------------------------------------------------------------------------------------------------





update	HTIUsage
set	LoadID = '', LoadDt = ''
--select * from HTIUsage
where	(PFCItemFlg = 'Y' OR AltItemFlg = 'Y')
	and isnull(LoadID,'') = 'WO2469.2_Secondary_HTI_Usage_History_Load'