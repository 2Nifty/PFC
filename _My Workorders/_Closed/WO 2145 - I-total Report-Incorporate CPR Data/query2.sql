
select * from rptitotal
order by Branch, ItemNo

select * from rptitotalhist
select * from rptitotalbuygrouphist

select * from CPR_Daily

------------------------------------------------------------
truncate table rptitotal
truncate table rptitotalhist
truncate table rptitotalbuygrouphist

truncate table Itemmaster
truncate table ItemBranch

truncate table CPR_Daily
truncate table CAS_CatGrpDesc
truncate table dashboardranges


truncate table pfcac.dbo.AvgCst_Daily
------------------------------------------------------------


exec pRPTItotal 

select * from CPR_Daily
WHERE	LocationCode BETWEEN '01' AND '90'




select ItemNo+' '+LocationCode from CPR_Daily
WHERE	LocationCode BETWEEN '01' AND '90'
and ItemNo+' '+LocationCode in 
(select DIStINCT ItemNo+' '+Branch from rptitotal)





select --distinct
* from rptitotalbuygrouphist
where CurrentDt = CAST (FLOOR (CAST (GetDate()-1 AS FLOAT)) AS DATETIME)
order by CurrentDt, Branch, Category, DonGroupNo, DonGroupDesc, DonSort, BuyGroupNo, BuyGroupDesc, ITotalGroup






select * from rptItotal
where ItemNo in
(
'00020-2412-020',
'00020-2412-021',
'00020-2412-450',
'00020-2412-451',
'00020-2412-500',
'00050-2726-020',
'00050-2726-021',
'00050-2726-022',
'00050-2726-401',
'00050-2726-601',
'00050-2726-951',
'00170-2606-020',
'00170-2606-021',
'00170-2606-024',
'00170-2606-441',
'00170-2606-500',
'00170-2610-020',
'00170-2610-021',
'00170-2610-024',
'00170-2610-251',
'00170-2610-510',
'00370-4200-020',
'00370-4200-021',
'00370-4200-022',
'00370-4200-024',
'00370-4200-400',
'00370-4200-401',
'00370-4200-404',
'00370-4200-420',
'00370-4200-421',
'00370-4200-450',
'00370-4200-571',
'00370-4200-951',
'00500-1420-021',
'00500-1420-401',
'00500-1420-451',
'00500-1420-601',
'00500-1420-811',
'00500-1422-021',
'00500-1422-401',
'00500-1422-451',
'00500-1424-021',
'00500-1424-401',
'00500-1424-451',
'00500-1424-601',
'06510-0618-400',
'06510-0618-600',
'06510-0618-610',
'06510-0618-620',
'06510-0618-800',
'06510-0620-400',
'06510-0620-600',
'06510-0620-610',
'06510-0620-620',
'06510-0620-800',
'06510-0620-810',
'06510-0624-400',
'06510-0624-600',
'20080-1230-020',
'20080-1230-040',
'20080-1230-042',
'20080-1235-020',
'20080-1235-022',
'20080-1235-040',
'20080-1235-042',
'20080-1235-402',
'20080-1235-500',
'20080-1235-572',
'62050-0001-660',
'62050-0010-600',
'62050-0020-600',
'62050-0100-600',
'62050-0200-600',
'62050-2400-600',
'62050-2401-600',
'62050-2402-600',
'62050-2403-600',
'62050-2600-600',
'62050-2601-600',
'62050-2602-600',
'62050-2603-600',
'62050-2604-600',
'62050-2605-600',
'62050-2800-600',
'62050-2801-600',
'99907-1001-899',
'99907-1002-899',
'99907-1004-899',
'99907-1005-899',
'99907-1008-899',
'99907-1009-899',
'99907-1012-899',
'99907-1013-899',
'99907-1015-899',
'99999-5418-020',
'99999-5418-021',
'99999-5419-021',
'99999-5463-020',
'99999-5466-050',
'99999-5468-504',
'99999-5469-504',
'99999-5470-504',
'99999-5491-250'
)
order by Branch, ItemNo


update rptitotal
set CurrentDt = 
CAST (FLOOR (CAST (GetDate()-7 AS FLOAT)) AS DATETIME)

select getdate()-7




select * from rptitotalhist



insert into rptitotalhist values
(getdate()-8,