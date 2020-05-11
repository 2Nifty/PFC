

exec pLoadDashboardCustInvDaily
exec pLoadDashboardCatLocDaily

select * from DashboardRanges

select * from DashboardCustInvDaily order by CustNo, InvoiceNo, LineNumber, ArPostDt
select * from DashboardCatLocDaily order by CategoryGroup, Location, ARPostDt


select distinct OrderSource from SOHeaderHist

select distinct OrderSource from DashboardCustInvDaily


exec sp_columns SOHeaderHist



select * from ListDetail where ListValue='WQ'



---------------------------------------------------------------------------------
--Testing Daily--

--Customer Number Detail Drilldown (024061)
exec pDashboardSODrilldownDaily '**', '024061', '0000000000'


--Invoice Number Detail Drilldown (281990 & 282088)
exec pDashboardSODrilldownDaily '00', '000000', '281990'
exec pDashboardSODrilldownDaily '00', '000000', '282088'


--Invoice Line Item Detail Drilldown (All Locations)
exec pDashboardSODrilldownDaily '00', '000000', '0000000000'


--Report A - Sales Order Header Level (All Locations)
exec pDashboardSODrilldownDaily '00', '******', '0000000000'


--Report B - Customer Sales Order Level (All Locations)
exec pDashboardSODrilldownDaily '00', '000000', '**********'


--Invoice Line Item Detail Drilldown (SPECIFIC LOCATION: 15)
exec pDashboardSODrilldownDaily '15', '000000', '0000000000'


--Report A - Sales Order Header Level (SPECIFIC LOCATION: 15)
exec pDashboardSODrilldownDaily '15', '******', '0000000000'


--Report B - Customer Sales Order Level (SPECIFIC LOCATION: 15)
exec pDashboardSODrilldownDaily '15', '000000', '**********'


--Verification.xls
--exec pDashboardSODrilldownDaily '00', '******', '0000000000'
exec pDashboardSODrilldownDaily '00', '000000', '**********'
exec pDashboardSODrilldownDaily '15', '000000', '**********'
exec pDashboardSODrilldownDaily '**', '024061', '0000000000'
exec pDashboardSODrilldownDaily '**', '038917', '0000000000'
select InvoiceNo, SUM(Cost) from DashboardCustInvDaily where ARPostDt='2010-05-26' and CustNo='024061' group by InvoiceNo
select InvoiceNo, SUM(Cost) from DashboardCustInvDaily where ARPostDt='2010-05-26' and CustNo='038917' group by InvoiceNo


---------------------------------------------------------------------------------
--Testing MTD--

--Customer Number Detail Drilldown (024061)
exec pDashboardSODrilldownMTD '**', '024061', '0000000000'


--Invoice Number Detail Drilldown (281990 & 282088)
exec pDashboardSODrilldownMTD '00', '000000', '281990'
exec pDashboardSODrilldownMTD '00', '000000', '282088'


--Invoice Line Item Detail Drilldown (All Locations)
exec pDashboardSODrilldownMTD '00', '000000', '0000000000'


--Report A - Sales Order Header Level (All Locations)
exec pDashboardSODrilldownMTD '00', '******', '0000000000'


--Report B - Customer Sales Order Level (All Locations)
exec pDashboardSODrilldownMTD '00', '000000', '**********'


--Invoice Line Item Detail Drilldown (SPECIFIC LOCATION: 15)
exec pDashboardSODrilldownMTD '15', '000000', '0000000000'


--Report A - Sales Order Header Level (SPECIFIC LOCATION: 15)
exec pDashboardSODrilldownMTD '15', '******', '0000000000'


--Report B - Customer Sales Order Level (SPECIFIC LOCATION: 15)
exec pDashboardSODrilldownMTD '15', '000000', '**********'


--Verification.xls
--exec pDashboardSODrilldownMTD '00', '******', '0000000000'
exec pDashboardSODrilldownMTD '00', '000000', '**********'
exec pDashboardSODrilldownMTD '15', '000000', '**********'
exec pDashboardSODrilldownMTD '**', '024061', '0000000000'
exec pDashboardSODrilldownMTD '**', '038917', '0000000000'

select InvoiceNo, SUM(Cost) from DashboardCustInvDaily 
where ARPostDt >= '2010-05-02' and ARPostDt <= '2010-05-26' and CustNo='024061'
group by InvoiceNo

select InvoiceNo, SUM(Cost) from DashboardCustInvDaily
where ARPostDt >= '2010-05-02' and ARPostDt <= '2010-05-26' and CustNo='024061' and 
	OrderSource IS NOT NULL and OrderSource <> '' and OrderSource <> 'M'
group by InvoiceNo


select InvoiceNo, SUM(Cost) from DashboardCustInvDaily 
where ARPostDt >= '2010-05-02' and ARPostDt <= '2010-05-26' and CustNo='038917'
group by InvoiceNo

select InvoiceNo, SUM(Cost) from DashboardCustInvDaily
where ARPostDt >= '2010-05-02' and ARPostDt <= '2010-05-26' and CustNo='038917' and 
	OrderSource IS NOT NULL and OrderSource <> '' and OrderSource <> 'M'
group by InvoiceNo



---------------------------------------------------------------------------------
--Testing 021113 MTD--

--Verification.xls
--exec pDashboardSODrilldownMTD '00', '******', '0000000000'
exec pDashboardSODrilldownMTD '00', '000000', '**********'
--exec pDashboardSODrilldownMTD '15', '000000', '**********'
exec pDashboardSODrilldownMTD '**', '021113', '0000000000'

select InvoiceNo, SUM(Cost) from DashboardCustInvDaily 
where ARPostDt >= '2010-05-02' and ARPostDt <= '2010-05-26' and CustNo='021113'
group by InvoiceNo

select InvoiceNo, SUM(Cost) from DashboardCustInvDaily
where ARPostDt >= '2010-05-02' and ARPostDt <= '2010-05-26' and CustNo='021113' and 
	OrderSource IS NOT NULL and OrderSource <> '' and OrderSource <> 'M'
group by InvoiceNo
