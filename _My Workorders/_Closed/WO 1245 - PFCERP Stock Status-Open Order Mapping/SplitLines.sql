select DISTINCT
HDR.[No_] as Doc, HDR.[Location Code] as HdrLoc, LINE.[Location Code] as LineLoc, LINE.[Line No_] as [LineNo] from [Porteous$Sales Header] HDR inner join [Porteous$Sales Line] LINE on HDR.[No_]=LINE.[Document No_]
where 
HDR.[No_]='SO2707627' or
HDR.[No_]='SO2708565' or
HDR.[No_]='SO2845810' or
HDR.[No_]='SO2947718' or
HDR.[No_]='SO2968625' or
--HDR.[No_]='TO1208491' or


HDR.[No_]='SO2845739' or
HDR.[No_]='SO2886757' or
HDR.[No_]='SO2894084' or
HDR.[No_]='SO2904000' or
HDR.[No_]='SO2944459' or
HDR.[No_]='SO2945805' or
HDR.[No_]='SO2951442' or
HDR.[No_]='SO2958020'

order by HDR.[No_], LINE.[Line No_]




select DISTINCT
HDR.[No_] as Doc, HDR.[Transfer-from Code] as HdrLoc, LINE.[Transfer-from Code] as LineLoc, LINE.[Line No_] as [LineNo] from [Porteous$Transfer Header] HDR inner join [Porteous$Transfer Line] LINE on HDR.[No_]=LINE.[Document No_]
where 
HDR.[No_]='TO1208491'
order by HDR.[No_], LINE.[Line No_]


--select * from [Porteous$Sales Line]
--select * from [Porteous$Transfer Line]





--split lines
select distinct RefSONo, IMLoc from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID
--where IMLoc=''

--RefSONo='SO2708565'
where RefSONo='SO2708565' or 
RefSONo='SO2845739' or 
RefSONo='SO2886757' or 
RefSONo='SO2894084' or 
RefSONo='SO2904000' or 
RefSONo='SO2944459' or 
RefSONo='SO2945805' or 
RefSONo='SO2951442' or 
RefSONo='SO2958020' or 

RefSONo='SO2707627' or 
RefSONo='SO2845810' or 
RefSONo='SO2947718' or 
RefSONo='SO2968625' or 
RefSONo='TO1208491'
order by RefSONo




select  RefSONo, SODetail.IMLoc from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID
where RefSONo='SO2707627' 



select  DISTINCT SOHeader.RefSONo, SODetail.IMLoc from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID, 
(select SOHeader.RefSONo, IMLoc from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID) DTL
where SOHeader.RefSONo=DTL.RefSONo and SODetail.IMLoc<>DTL.IMLoc
order by SOHeader.RefSONo


-----------------------------------------------------------------------------------


--1287 split to 1287 and 1288:
select SODetail.IMLoc, SODetail.RqstdShipDt, SODetail.CarrierCd, SODetail.* from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID where OrderNo='1287'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='1287'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='1288'

--1695 split to 1696 and 1697
select SODetail.IMLoc, SODetail.RqstdShipDt, SODetail.CarrierCd, SODetail.* from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID where OrderNo='1695'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='1696'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='1697'

--2121 split to 2123 and 2124 
select SODetail.IMLoc, SODetail.RqstdShipDt, SODetail.CarrierCd, SODetail.* from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID where OrderNo='2121'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='2123'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='2124'

--2313 split to 2316 and 2317
select SODetail.IMLoc, SODetail.RqstdShipDt, SODetail.CarrierCd, SODetail.* from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID where OrderNo='2313'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='2316'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='2317'

--2449 split to 2453 and 2454
select SODetail.IMLoc, SODetail.RqstdShipDt, SODetail.CarrierCd, SODetail.* from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID where OrderNo='2449'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='2453'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='2454'

--3823 split to 3828 and 3829
select SODetail.IMLoc, SODetail.RqstdShipDt, SODetail.CarrierCd, SODetail.* from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID where OrderNo='3823'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='3828'
--select SODetailRel.IMLoc, SODetailRel.* from SOHeaderRel inner join SODetailRel on pSOHeaderRelID=SODetailRel.fSOHeaderRelID where OrderNo='3829'

--1287
--1695
--2121
--2313
--2449
--3823
