
SELECT	ItemNo, DensityFactor, *
FROM	ItemMaster (NoLock) IM
WHERE	ItemStat = 'M' and
		rtrim(ItemNo) in
		(SELECT	DISTINCT
				rtrim(Box.BoxSize) as BoxSize
		 FROM	ItemMaster (NoLock) Box
		 WHERE	isnull(BoxSize,'') <> '')



SELECT	[Code], [Weight Factor]
INTO	#tNVPkg
FROM	OpenDataSource('SQLOLEDB','Data Source=enterprisesql;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Package Size] NVPkg

select * from #tNVPkg

UPDATE	ItemMaster
SET		DensityFactor = isnull(Pkg.[Weight Factor],0)
FROM    ItemMaster IM (NoLock) LEFT OUTER JOIN
		#tNVPkg Pkg (NoLock)
ON		rtrim(IM.ItemNo) = rtrim(Pkg.[Code])
WHERE	IM.ItemStat = 'M' and
		rtrim(IM.ItemNo) in
		(SELECT	DISTINCT
				rtrim(Box.BoxSize) as BoxSize
		 FROM	ItemMaster (NoLock) Box
		 WHERE	isnull(Box.BoxSize,'') <> '')


exec sp_columns ItemMaster


select * from ItemMaster where ItemStat = 'M'


select [Code], [Weight Factor] from OpenDataSource('SQLOLEDB','Data Source=enterprisesql;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Package Size]
where [Code] in ('020','040')


select densityfactor from itemmaster where itemstat='M' and itemno in ('020','040')




---------------------------------------------------------------------

--fix discrepancies

update itemmaster set GrossWght = 0

(SELECT	ItemNo, DensityFactor
FROM	ItemMaster (NoLock) IM 
WHERE	ItemStat='M') tDensity


select * FROM #tDensity


--UPDATE	ItemMaster
--SET		GrossWght = Wght + isnull(Density.DensityFactor,0)
SELECT	IM.ItemNo, isnull(IM.BoxSize,'') as BoxSize, IM.Wght, IM.GrossWght, IM.ItemStat,
		isnull(Density.ItemNo,'') as DensityCd, isnull(Density.DensityFactor,0) as DensityFactor,
		isnull(IM.Wght,0) + isnull(Density.DensityFactor,0) as NewGross
FROM	ItemMaster (NoLock) IM LEFT OUTER JOIN
		(SELECT	ItemNo, DensityFactor
		 FROM	ItemMaster (NoLock) IM 
		 WHERE	ItemStat='M') Density
ON		isnull(IM.BoxSize,'') = isnull(Density.ItemNo,'')
WHERE	IM.ItemStat = 'S'
and round((isnull(IM.Wght,0) + isnull(Density.DensityFactor,0)),5) <> round(IM.GrossWght,5)






--UPDATE	ItemMaster
--SET		GrossWght = Wght + isnull(Density.DensityFactor,0)
--FROM	ItemMaster (NoLock) IM LEFT OUTER JOIN
--		(SELECT	ItemNo, DensityFactor
--		 FROM	ItemMaster (NoLock) IM 
--		 WHERE	ItemStat='M') Density
--ON		isnull(IM.BoxSize,'') = isnull(Density.ItemNo,'')
--WHERE	IM.ItemStat = 'S'
--		and round((isnull(IM.Wght,0) + isnull(Density.DensityFactor,0)),5) <> round(IM.GrossWght,5)




---------------------------------------------------------------------

--discrepancies


--3360 items with BoxSize='007' and the appropriate adder applied
select ItemNo, boxsize, wght, grosswght, grosswght-wght as addr, round(grosswght-wght,5) as roundaddr from ItemMaster
where BoxSize='007'  and round(grosswght-wght,5) = 0.21875


--580 items with BoxSize='007' and INAPPROPRIATE adder applied
--(all except 25 of these rows have 0 adder - meaning NetWght = GrossWght)
select ItemNo, boxsize, wght, grosswght, grosswght-wght as addr, round(grosswght-wght,5) as roundaddr from ItemMaster
where BoxSize='007'  and round(grosswght-wght,5) <> 0.21875


--38453 items with BoxSize='020' and the appropriate adder applied
select ItemNo, boxsize, wght, grosswght, grosswght-wght as addr, round(grosswght-wght,5) as roundaddr
from ItemMaster (nolock)
where BoxSize='020' and round(grosswght-wght,5) = 1.11111

--1200 items with BoxSize='020' and INAPPROPRIATE adder applied
select ItemNo, boxsize, wght, grosswght, grosswght-wght as addr, round(grosswght-wght,5) as roundaddr
from ItemMaster (nolock)
where BoxSize='020' and round(grosswght-wght,5) <> 1.11111
and round(grosswght-wght,5) <> 0
