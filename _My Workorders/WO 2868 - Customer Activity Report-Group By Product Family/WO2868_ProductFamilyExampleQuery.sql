SELECT IC.ITEMID as ItemNo,
       MAX(CC.Code) as ProdFamCd,
       MAX(CC.DESCR) as ProdFamDesc
FROM   CatalogChapter CC (NoLock) INNER JOIN
       ItemCatalog IC (NoLock)
ON     IC.CHAPTER = CC.CODE
GROUP BY IC.ITEMID

