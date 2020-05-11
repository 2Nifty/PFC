--56865
select count(*) from POHeader
Where	isnull(POSubType,0) between 41 and 49

--56283
select count(podetail.fpoheaderid) from POHeader inner join podetail on ppoheaderid=fpoheaderid
Where	isnull(POSubType,0) between 41 and 49


select count(*) from POHeader Where	isnull(POSubType,0) not between 41 and 49
select count(*) from POHeader where isnull(CompleteDt,'') = '' and isnull(POSubType,0) not between 41 and 49
select count(*) from POHeader where isnull(CompleteDt,'') <> '' and isnull(POSubType,0) not between 41 and 49

select count(*) from POHeaderHist
select count(*) from POHeaderHist where isnull(CompleteDt,'') = ''
select count(*) from POHeaderHist where isnull(CompleteDt,'') <> ''