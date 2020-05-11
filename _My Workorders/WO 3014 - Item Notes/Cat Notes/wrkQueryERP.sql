select Len(cast(Notes as varchar(4000))) from CategorybuyGroups

update CategorybuyGroups
set Notes = null, changeid=''


select Notes, * from CategoryBuyGroups

exec sp_columns CategoryBuyGroups


--UPDATE Category Spec Notes
UPDATE	CategoryBuyGroups
SET	Notes = CatNote.Notes
FROM	(


SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Category,
	dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Notes
FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Standard Text Line Comment] NV
WHERE	left([No_],4) = 'SPEC'


) CatNote
WHERE	Buyer.Code = POHeader.Buyer



exec sp_columns CategoryBuyGroups

select Notes, * from CategoryBuyGroups where Category='00217'


select * from CategoryBuyGroups where notes is null 

