select * from UnprocessedCategoryPrice
where CustomerNo='065251' 
select distinct CustomerNo, GroupNo from UnprocessedCategoryPrice
where CustomerNo='065251'




		DELETE
		FROM	UnprocessedCategoryPrice
		WHERE	CustomerNo = @CustomerNo AND GroupNo = @GroupNo





DELETE
FROM	UnprocessedCategoryPrice
WHERE

Branch
CustomerNo
GroupNo
GroupType


--703
select Count(*) from UnprocessedCategoryPrice
where CustomerNo in ('029587','065251','072653')

-----------------------------------------------------------------


DELETE
FROM	UnprocessedCategoryPrice
WHERE	CustomerNo in  (SELECT	DISTINCT CustomerNo
			FROM	UnprocessedCategoryPrice
--			WHERE	Approved = 'Y')
			WHERE	StatusCd = 'UP')
go

DELETE
FROM	UnprocessedCategoryPrice
WHERE	StatusCd = 'UP'
go

DELETE
FROM	UnprocessedCategoryPrice
WHERE	EntryDt < CAST(FLOOR(CAST(GetDate()-2 AS FLOAT)) AS DATETIME)
go


