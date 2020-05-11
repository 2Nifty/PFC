select	Line.[Document No_], Line.[Line No_], Line.[Location Code]--, *
FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] Hdr Inner join
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] Line
ON	Hdr.[No_] = Line.[Document No_]
WHERE	ROUND(Line.[Quantity],0,1) > 0 AND Line.No_ <> '' AND Line.Type=2 AND --Line.[Location Code]='' and 
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = Hdr.[No_])
order by Line.[Document No_], Line.[Line No_]


Select	RefSONo, LineNumber, ShipLoc, ShipLocName, IMLoc, CustShipLoc
from	SOHeader inner join
	SODetail Dtl
on	pSOHeaderID = Dtl.fSOHeaderID
where	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)
order by RefSONo, LineNumber