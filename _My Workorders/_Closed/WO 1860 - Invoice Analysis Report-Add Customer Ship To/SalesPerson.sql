
select DISTINCT RepName AS ShortDsc
from RepMaster INNER JOIN SOHeaderHist ON SalesRepName = RepName
where RepEmail is not null AND RepEmail <> '' AND left(RepName,2) <> 'xx' ORDER BY RepName



  string _tableName = "RepMaster INNER JOIN SOHeaderHist ON SalesRepName = RepName";
            string _columnName = "DISTINCT RepName AS ShortDsc";
            string _whereClause = "RepEmail is not null AND RepEmail <> '' AND left(RepName,2) <> 'xx' ORDER BY RepName";


exec UGEN_SP_Select 'RepMaster INNER JOIN SOHeaderHist ON SalesRepName = RepName', 'DISTINCT RepName AS ShortDsc', 'RepEmail is not null AND RepEmail <> '''' AND left(RepName,2) <> ''xx'' ORDER BY RepName'
