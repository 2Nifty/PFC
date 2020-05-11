
DECLARE	@CRLF CHAR(2),
--	@Body TEXT
	@Body VARCHAR(8000)

SET @CRLF = CHAR(13) + CHAR(10)
SET @Body = 'Line 1' + @CRLF + 'Line2'

select @Body

drop table tTodTest
CREATE TABLE tTodTest (Body TEXT)
INSERT INTO tTodTest VALUES ('Line 1' + @CRLF + 'Line2')
select * from tTodTest


exec DTQ_SP_SendMail 'IT_OPS@porteousfastener.com','tdixon@porteousfastener.com','test email','test body'--,'c:\test.txt'

select * from DTQ_Mail_Failures



SELECT	OrderNo AS [ERP Order No], RefSONo, CustShipLoc AS [Sales Loc], ShipLoc AS [Shipping Loc],
	SellToCustNo AS [Sell To Cust], SellToCustName AS [Cust Name],SchShipDt AS [Sched Ship Date],
	CustReqDt AS [Req Delivery Date], CustPONo AS [Cust PO No]
FROM	SOHeader
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)
Order By CustShipLoc, RefSONo

-----------------------------------------------------------------

DECLARE @CRLF CHAR(1),
	@Body VARCHAR(8000)

SET @CRLF = CHAR(13)
SET @Body = 'Line 1' + @CRLF + 'Line2'

print @Body
exec DTQ_SP_SendMail 'IT_OPS@porteousfastener.com','tdixon@porteousfastener.com,tslater@porteousfastener.com','test email',@Body