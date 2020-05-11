select [Last Date Modified], [Last Modified By], [Bill-to Customer No_], * from [Porteous$Customer] where No_='201697' or No_='201696'



update [Porteous$Customer]
set [Last Date Modified]=CAST(FLOOR( CAST( GetDate() AS FLOAT ) )AS DATETIME),
	[Last Modified By]='TOD'
where No_='201697' or No_='201696'





select CustCd, fBillToNo, * from tERPCustUpdate



--Set BT for [No_] that is assigned as [Bill-to Customer No_] on another account
UPDATE	tERPCustUpdate
SET	CustCd='BT', fBillToNo=''
FROM	(SELECT [No_] AS Cust, [Bill-to Customer No_] AS BillTo
	 FROM [Porteous$Customer]) Cust
WHERE	[No_]=Cust.BillTo


--Set ST for [No_] <> [Bill-to Customer No_] and [Bill-to Customer No_] not blank
UPDATE	tERPCustUpdate
SET	CustCd='ST', fBillToNo=[Bill-to Customer No_]
FROM	tERPCustUpdate
WHERE	[No_]<>[Bill-to Customer No_] AND [Bill-to Customer No_]<>''


--Set BTST for all remaining unassigned records
UPDATE	tERPCustUpdate
SET	CustCd='BTST', fBillToNo=[No_]
FROM	tERPCustUpdate
WHERE	CustCd is NULL


--Set BTST for any BT that does not start with 1 
UPDATE	tERPCustUpdate
SET	CustCd='BTST', fBillToNo=[No_]
FROM	tERPCustUpdate
WHERE	CustCd='BT' AND LEFT([No_], 1) <> 1