IF ((SELECT COUNT(*) FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader WHERE ShipLoc is NULL or ShipLoc = '' or ShipLoc='0' or ShipLoc='00') > 0)
   BEGIN
	PRINT 'Blank ShipLocs found'
	Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','cisaminger@porteousfastener.com, it_ops@porteousfastener.com, crojas@porteousfastener.com',
					   'WO1245 - NV Sales Orders with no [Shipping Location]',
					   'Attached please find a list of NV Sales Orders with no [Shipping Location] and NV Transfer Orders with no [Transfer-from Code].<br><br>These orders need to be fixed in NV so they will convert properly to ERP.',
					   '\\pfcfiles\userdb\WO1245_NoShipLoc.csv'
   END
ELSE 
   BEGIN
	PRINT 'No blank ShipLocs'
   END





	Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com', 'tdixon@porteousfastener.com',
					   'Testing DTQ_SP_SendMailWithAttachment',
					   'Test DTQ_SP_SendMailWithAttachment',
					   '\\pfcfiles\userdb\WebEnabled00086.xls'

exec sp_columns IMFastMaint

SELECT	ItemNo,
		rtrim(DataField) as FieldName, 
		rtrim(OriginalData)  as Orig_Value, 
		rtrim(NewData) as New_Value,
		CASE WHEN isnull(ExceptionInd,0) > 0 THEN 'ERROR' ELSE 'WARNING' END as Severity,
		rtrim(ExceptionMsg) as ErrMsg
--INTO	##tExceptions
FROM	IMFastMaint (NoLock)
WHERE	isnull(ExceptionInd,0) <> 0

--select * from ##tExceptions

If (@@rowcount <> 0)
Begin
            EXEC msdb.dbo.sp_send_dbmail
            @recipients='tdixon@porteousfastener.com',    
            @subject = 'testing dbmail',                            
            @body=N'testing dbmail',
            @execute_query_database = 'PERP',
            @query = N'select * from ##tExceptions',
	    @attach_query_result_as_file = 1;
END

drop table ##tExceptions


-- Check any sell to customer exist in DirectConn registration table
Select      CustRegistration.ID as DCUserID,
            CustRegistration.CustomerNumber as [Customer #],
            CustMaster.CustName as [Cust Name]
Into  ##tempDCUsers
From  DTQ_CustomerRegistration (NOLOCK) as CustRegistration LEFT OUTER JOIN
            OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[CustomerMaster]  as CustMaster 
            ON CustRegistration.CustomerNumber = CustMaster.CustNo
Where CustMaster.CustCd='BT' 


If (@@rowcount <> 0)
Begin
            EXEC msdb.dbo.sp_send_dbmail
            @recipients=@adminEmailID,    
            @subject = 'Direct Connect - Bad Customer Number Found',                            
            @body=N'Bad customer number(Bill To) found in direct connect registration table.',
            @execute_query_database = 'QAPFCQuotesDB',
            @query = N'select * from  ##tempDCUsers';
End



select * from ##tExceptions


 SELECT * 
INTO OUTFILE 'testingemail.csv' FIELDS TERMINATED BY ',' LINES TERMINATED BY 'n';
FROM ##tExceptions