select Hdr.[Location Code], Lin.[Location Code], *
from	[Porteous$Sales Invoice Header] Hdr Inner join
	[Porteous$Sales Invoice Line] Lin
on	Hdr.[No_] = Lin.[Document No_]
where	Hdr.[Location Code] <> Lin.[Location Code]








SELECT	DISTINCT Lin.[Document No_] AS Doc, Lin.[Location Code] as Loc
from	[Porteous$Sales Invoice Header] Hdr Inner join
	[Porteous$Sales Invoice Line] Lin
on	Hdr.[No_] = Lin.[Document No_]
where  Lin.Type=2 AND Lin.No_ <> '' AND Hdr.[Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)
order by Lin.[Document No_]


select Hdr.[Location Code], Lin.[Location Code], Hdr.[Shortcut Dimension 1 Code], Hdr.[Posting Date], Hdr.[No_], [Line No_]--,*
from [Porteous$Sales Invoice Header] Hdr inner join
	[Porteous$Sales Invoice Line] Lin
on Hdr.[No_]=Lin.[Document No_]
where Hdr.[No_]='IP2301092' or Hdr.[No_]='IP1765857' or Hdr.[No_]='IP2847888' or Hdr.[No_]='IP2434538' or Hdr.[No_]='IP2853049'
order by Hdr.[No_], [Line No_]


select [Location Code], *
from [Porteous$Sales Invoice Line]
where [Document No_]='IP2301092' or [Document No_]='IP1765857' or [Document No_]='IP2847888' or [Document No_]='IP2434538' or [Document No_]='IP2853049'




SELECT	 Lin.[Document No_] AS Doc, Lin.[Location Code] as Loc, Lin.*
from	[Porteous$Sales Invoice Header] Hdr Inner join
	[Porteous$Sales Invoice Line] Lin
on	Hdr.[No_] = Lin.[Document No_]
where  --Lin.Type=2 AND Lin.No_ <> '' AND Lin.[Location Code]='' and 
Hdr.[Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)
order by Lin.[Document No_]