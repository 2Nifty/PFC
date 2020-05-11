--17-aug-2011

--41153
select count(*) as HTI2009 from tWO2469_HTI2009
--37330
select count(*) as HTI2010 from tWO2469_HTI2010
--41153 + 37330 = 78483
SELECT * INTO #tWO2469_HTIUsage FROM
(SELECT * FROM tWO2469_HTI2009 UNION SELECT * FROM tWO2469_HTI2010) tmp

--78435 (-48)
select count(*) as HTIUsage from #tWO2469_HTIUsage


--43 same record
select * from tWO2469_HTI2009 hti2009
where exists (select * from tWO2469_HTI2010 hti2010 where 
hti2009.HTILoc = hti2010.HTILoc
and hti2009.HTIItem = hti2010.HTIItem
and hti2009.HTIItemDesc = hti2010.HTIItemDesc
and hti2009.HTIPack = hti2010.HTIPack
and hti2009.HTISalesDol = hti2010.HTISalesDol
and hti2009.HTICartonQty = hti2010.HTICartonQty
and hti2009.HTICostDol = hti2010.HTICostDol
and hti2009.PFCItem = hti2010.PFCItem
and hti2009.PFCItemFlg = hti2010.PFCItemFlg
and hti2009.AltItem = hti2010.AltItem
and hti2009.AltItemFlg = hti2010.AltItemFlg) 


exec sp_columns tWO2469_HTI2009


--------------------------------------------------------------------------------------------------
--6593
----NoAlias tab
--Invalid PFCItem - Invalid AltItem
SELECT	Distinct
	HTIItem, 
	PFCItem, PFCItemFlg, AltItem, AltItemFlg--, isnull(DeleteDt,'') as ItemDelDt
FROM	#tWO2469_HTIUsage LEFT OUTER JOIN
	ItemMaster (NoLock)
ON	PFCItem = ItemNo
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'N'
order by PFCItem DESC, HTIItem

--Check Delete dates on ItemMaster
SELECT	DeleteDt, * FROM ItemMaster WHERE ItemNo in
(SELECT	Distinct
	PFCItem
FROM	#tWO2469_HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'N' AND isnull(PFCItem,'') <> '')
order by ItemNo

SELECT	DeleteDt, * FROM ItemMaster WHERE ItemNo in
(SELECT	Distinct
	AltItem
FROM	#tWO2469_HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'N' AND isnull(AltItem,'') <> '')
order by ItemNo


--------------------------------------------------------------------------------------------------

----NoAltPFC tab
--Valid PFCItem - Invalid AltItem
SELECT	Distinct
	HTIItem,
	PFCItem, 
	PFCItemFlg, AltItem, AltItemFlg
FROM	#tWO2469_HTIUsage
WHERE	PFCItemFlg = 'Y' AND AltItemFlg = 'N'
order by HTIItem

--------------------------------------------------------------------------------------------------

----InvalidPFC tab
--Invalid PFCItem - Valid AltItem
SELECT	Distinct
	HTIItem, PFCItem, PFCItemFlg, AltItem, AltItemFlg--, isnull(DeleteDt,'') as ItemDelDt
FROM	#tWO2469_HTIUsage LEFT OUTER JOIN
	ItemMaster (NoLock)
ON	PFCItem = ItemNo
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'Y'
order by HTIItem



--Check Delete dates on ItemMaster
SELECT	DeleteDt, * FROM ItemMaster WHERE ItemNo in
(SELECT	Distinct
	PFCItem
FROM	#tWO2469_HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'Y' AND isnull(PFCItem,'') <> '')
order by ItemNo

SELECT	DeleteDt, * FROM ItemMaster WHERE ItemNo in
(SELECT	Distinct
	AltItem
FROM	#tWO2469_HTIUsage
WHERE	PFCItemFlg = 'N' AND AltItemFlg = 'Y' AND isnull(AltItem,'') <> '')
order by ItemNo






--------------------------------------------------------------------------------------------------

----ValidAlt tab
--Valid PFCItem - Valid AltItem
SELECT	Distinct
	HTIItem, PFCItem, PFCItemFlg, AltItem, AltItemFlg
FROM	#tWO2469_HTIUsage
WHERE	PFCItemFlg = 'Y' AND AltItemFlg = 'Y'
order by HTIItem

--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--Valid AltItem
SELECT	Distinct
	HTIItem, PFCItem, PFCItemFlg, AltItem, AltItemFlg
FROM	#tWO2469_HTIUsage
WHERE	--PFCItemFlg = 'Y' AND 
	AltItemFlg = 'Y'
order by AltItem



