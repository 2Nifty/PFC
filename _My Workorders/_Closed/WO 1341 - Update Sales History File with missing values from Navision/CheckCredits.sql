--select ARPostDt, SubType, OrderType, OrderCarrier, OrderCarName, * from SOHeaderHist 
--where SubType is null and OrderCarName is null
--Order by ARPostDt

select distinct ARPostDt from SOHeaderHist where SubType is null order by ARPostDt


select ARPostDt, SubType, OrderType, OrderCarrier, OrderCarName, OrderFreightCd, OrderFreightName, * from SOHeaderHist 
where  --ARPostDT > Cast('2009-09-27 00:00:00.000' as DATETIME)
SubType is null and OrderFreightCd is not null

order by ARPostDt

and OrderType='51'


select ARPostDt, SubType, OrderType, OrderCarrier, OrderCarName, OrderFreightCd, OrderFreightName, * from SOHeaderHist 
where  SubType is null and OrderFreightCd is not null
order by ARPostDt


update SOHeaderHist
set SubType='51'
where  SubType is null and OrderFreightCd is not null



select * from SOHeaderHist where SubType='51' and OrderType <> '51'

select DISTINCT ARPostDt, SubType, OrderType  from SOHeaderHist 
where OrderType='51' and SubType is null --and OrderFreightCd is not null
order by ARPostDt


select * from SOHeaderHist
where ARPostDT < Cast('2009-09-28 00:00:00.000' as DATETIME) and SubType is null