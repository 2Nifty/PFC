
--select DISTINCT OrderFreightCd, OrderFreightName from SOHeader

UPDATE	SOHeader
SET	OrderFreightCd = CASE
----			    WHEN OrderFreightCd = 'BRNCHBEST' THEN ''		--Do Not Use This Code
			    WHEN OrderFreightCd = 'COL-3RD' THEN 'COL-3RD'
			    WHEN OrderFreightCd = 'COL-COD' THEN 'COL-COD'
			    WHEN OrderFreightCd = 'COLLECT' THEN 'COL'
			    WHEN OrderFreightCd = 'CONTAINER' THEN 'CON'
--			    WHEN OrderFreightCd = 'DELIVERY' THEN ''
----			    WHEN OrderFreightCd = 'PPD' THEN ''			--Do Not Use This Code
			    WHEN OrderFreightCd = 'PPD & $25' THEN 'PPD25'
			    WHEN OrderFreightCd = 'PPD & $35' THEN 'PPD35'
			    WHEN OrderFreightCd = 'PPD & $40' THEN 'PPD40'
			    WHEN OrderFreightCd = 'PPD & $50' THEN 'PPD50'
			    WHEN OrderFreightCd = 'PPD & $75' THEN 'PPD75'
			    WHEN OrderFreightCd = 'PPD & CHG' THEN 'PPDCHG'
			    WHEN OrderFreightCd = 'PPD-1000LB' THEN 'PPD-1000'
			    WHEN OrderFreightCd = 'PPD-1500LB' THEN 'PPD-1500'
			    WHEN OrderFreightCd = 'PPD-2000LB' THEN 'PPD-2000'
			    WHEN OrderFreightCd = 'PPD-2500LB' THEN 'PPD-2500'
--			    WHEN OrderFreightCd = 'PPD-250LB' THEN ''
			    WHEN OrderFreightCd = 'PPD-3500LB' THEN 'PPD-3500'
			    WHEN OrderFreightCd = 'PPD-3RD' THEN 'PPD3rd'
			    WHEN OrderFreightCd = 'PPD-5000LB' THEN 'PPD-5000'
			    WHEN OrderFreightCd = 'PPD-500LB' THEN 'PPD-500'
			    WHEN OrderFreightCd = 'PPD-600LB' THEN 'PPD-600'
			    WHEN OrderFreightCd = 'PPD-750LB' THEN 'PPD-750'
----			    WHEN OrderFreightCd = 'PPD-ADD' THEN ''		--Do Not Use This Code
			    WHEN OrderFreightCd = 'PPD-ANCHOR' THEN 'PPDANC'
----			    WHEN OrderFreightCd = 'PPD-CLE' THEN ''		--Not in [Porteous$Shipment Method]
			    WHEN OrderFreightCd = 'PPD-DEV' THEN 'PPDDEV'
			    WHEN OrderFreightCd = 'PPD-HDWE' THEN 'PPDHDWE'
--			    WHEN OrderFreightCd = 'PPD-LOCAL' THEN ''
			    WHEN OrderFreightCd = 'PPD-MILL' THEN 'PPDMILL'
			    WHEN OrderFreightCd = 'PPD-NC-BO' THEN 'PPDBO'
			    WHEN OrderFreightCd = 'PPD-NC-ERR' THEN 'PPDERR'
--			    WHEN OrderFreightCd = 'PPD-NC-TRN' THEN ''
			    WHEN OrderFreightCd = 'P-PPD' THEN 'P-PPD'
			    WHEN OrderFreightCd = 'P-UPS' THEN 'P-UPS'
			    WHEN OrderFreightCd = 'P-WILL CAL' THEN 'P-WC'
----			    WHEN OrderFreightCd = 'UPS' THEN ''			--Do Not Use This Code
----			    WHEN OrderFreightCd = 'WILL CALL' THEN ''		--Do Not Use This Code
			    ELSE OrderFreightCd
			 END

UPDATE	SOHeader
SET	OrderFreightName = Fght.Dsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Fght
WHERE	TableType = 'Fght' AND OrderFreightCd = Fght.TableCd
