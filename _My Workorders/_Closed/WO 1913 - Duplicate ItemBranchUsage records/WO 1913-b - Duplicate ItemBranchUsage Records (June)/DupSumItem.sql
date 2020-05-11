
select SI.* from SumItem SI inner join
(
select * from
(select Count(*) as reccount, Location, ItemNo, SourceCd from SumItem
group by Location, ItemNo, SourceCd) tmp
where reccount > 1 and  SourceCd='oh'
) dups
on SI.Location = dups.Location and SI.ItemNo = dups.ItemNo and SI.SourceCd = dups.SourceCd
order by SI.Location, SI.ItemNo, SI.SourceCd
