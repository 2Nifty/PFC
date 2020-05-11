select	Line.[Document No_], Line.[Line No_], Line.[Location Code]--, *
from	[Porteous$Sales Header] Header inner join
	[Porteous$Sales Line] Line
on	Header.[No_] = Line.[Document No_]
where	Line.[Document No_] > 'SO1945086' and Line.[Document No_] < 'SO3092550' and 
	ROUND(Line.[Quantity],0,1) > 0 AND Line.[No_] <> '' AND
	(Header.[Document Type] = 1 OR Header.[Document Type] = 3 OR Header.[Document Type] = 5) and
	(Line.[Document No_] = 'SO2349033' or
	Line.[Document No_] = 'SO2707627' or
	Line.[Document No_] = 'SO2708565' or
	Line.[Document No_] = 'SO2712646' or
	Line.[Document No_] = 'SO2845810' or
	Line.[Document No_] = 'SO2899344' or
	Line.[Document No_] = 'SO2904283' or
	Line.[Document No_] = 'SO2981207' or
	Line.[Document No_] = 'SO2992543' or
	Line.[Document No_] = 'SO3002777' or
	Line.[Document No_] = 'SO3040467' or
	Line.[Document No_] = 'SO3043128' or
	Line.[Document No_] = 'SO3045102' or
	Line.[Document No_] = 'SO3045639' or
	Line.[Document No_] = 'SO3048227' or
	Line.[Document No_] = 'SO3054921' or
	Line.[Document No_] = 'SO3054946' or
	Line.[Document No_] = 'SO3059201' or
	Line.[Document No_] = 'SO3067129' or
	Line.[Document No_] = 'SO3067925' or
	Line.[Document No_] = 'SO3072972' or
	Line.[Document No_] = 'SO3075037' or
	Line.[Document No_] = 'SO3079939' or
	Line.[Document No_] = 'SO3080232' or
	Line.[Document No_] = 'SO3080311' or
	Line.[Document No_] = 'SO3081626' or
	Line.[Document No_] = 'SO3084254' or
	Line.[Document No_] = 'SO3084701' or
	Line.[Document No_] = 'SO3085954' or
	Line.[Document No_] = 'SO3086735' or
	Line.[Document No_] = 'SO3087338' or
	Line.[Document No_] = 'SO3089261')
order by [Document No_], [Line No_]



Select	RefSONo, LineNumber, ShipLoc, ShipLocName, IMLoc, CustShipLoc
from	PFCReports.dbo.SOHeader inner join
	PFCReports.dbo.SODetail Dtl
on	pSOHeaderID = Dtl.fSOHeaderID
where
(RefSONo = 'SO2349033' or
RefSONo = 'SO2707627' or
RefSONo = 'SO2708565' or
RefSONo = 'SO2712646' or
RefSONo = 'SO2845810' or
RefSONo = 'SO2899344' or
RefSONo = 'SO2904283' or
RefSONo = 'SO2981207' or
RefSONo = 'SO2992543' or
RefSONo = 'SO3002777' or
RefSONo = 'SO3040467' or
RefSONo = 'SO3043128' or
RefSONo = 'SO3045102' or
RefSONo = 'SO3045639' or
RefSONo = 'SO3048227' or
RefSONo = 'SO3054921' or
RefSONo = 'SO3054946' or
RefSONo = 'SO3059201' or
RefSONo = 'SO3067129' or
RefSONo = 'SO3067925' or
RefSONo = 'SO3072972' or
RefSONo = 'SO3075037' or
RefSONo = 'SO3079939' or
RefSONo = 'SO3080232' or
RefSONo = 'SO3080311' or
RefSONo = 'SO3081626' or
RefSONo = 'SO3084254' or
RefSONo = 'SO3084701' or
RefSONo = 'SO3085954' or
RefSONo = 'SO3086735' or
RefSONo = 'SO3087338' or
RefSONo = 'SO3089261')
order by RefSONo, LineNumber
