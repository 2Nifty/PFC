SELECT     No_, [Bill-to Customer No_], Name, Address, City, County, [Post Code], CustCd, fBillToNo
FROM         Porteous$Customer
WHERE     (No_ = '030512') OR
                      (No_ = '130512')


SELECT     No_, [Bill-to Customer No_], Name, Address, City, County, [Post Code], CustCd, fBillToNo
FROM         Porteous$Customer
WHERE     (No_ = '030465')
--where CustCd='BTST'


SELECT     No_, [Bill-to Customer No_], Name, Address, City, County, [Post Code], CustCd, fBillToNo
FROM         Porteous$Customer
--WHERE     ([Bill-to Customer No_] = '100029')
WHERE     ([Bill-to Customer No_] = '100001')


SELECT     No_, [Bill-to Customer No_], Name, Address, City, County, [Post Code], CustCd, fBillToNo
FROM         Porteous$Customer
WHERE     (No_ = '066814') or (No_ = '201073')


------------------------------------------------------------------------------------------------------


--ERP
SELECT *
  FROM [PERP].[dbo].[CustomerMaster]
where CustNo='030512' or CustNo='130512' or CustNo='030465' or CustNo='033508' or CustNo='033509' or 
CustNo='033512' or CustNo='033699' or CustNo='065295' or CustNo='100029' or CustNo='066814' or CustNo='201073'
order by CustNo 

SELECT * 
  FROM [PERP].[dbo].[CustomerAddress]
where Type <> 'SHP' and Type <> 'DSHP' and
(fCustomerMasterID='2240' or
fCustomerMasterID='2246' or
fCustomerMasterID='2446' or
fCustomerMasterID='2447' or
fCustomerMasterID='2449' or
fCustomerMasterID='2472' or
fCustomerMasterID='6005' or
fCustomerMasterID='6200' or
fCustomerMasterID='8387' or
fCustomerMasterID='9100' or
fCustomerMasterID='10903')


------------------------------------------------------------------------------------------------------


--Add CustCd and fBillToNo columns to [Porteous$Customer]
IF EXISTS  (SELECT TABLE_NAME, COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME='Porteous$Customer' AND COLUMN_NAME = 'CustCd')
ALTER TABLE	[Porteous$Customer]
DROP COLUMN	CustCd, fBillToNo
GO

ALTER TABLE	[Porteous$Customer]
ADD		CustCd char(4) NULL, fBillToNo varchar(10) NULL
GO


--Set BT for [No_] that is assigned as [Bill-to Customer No_] on another account
UPDATE	[Porteous$Customer]
SET	CustCd='BT', fBillToNo=''
FROM	(SELECT [No_] AS Cust, [Bill-to Customer No_] AS BillTo
	 FROM [Porteous$Customer]) Cust
WHERE	[No_]=Cust.BillTo


--Set ST for [No_] <> [Bill-to Customer No_] and [Bill-to Customer No_] not blank
UPDATE	[Porteous$Customer]
SET	CustCd='ST', fBillToNo=[Bill-to Customer No_]
FROM	[Porteous$Customer]
WHERE	[No_]<>[Bill-to Customer No_] AND [Bill-to Customer No_]<>''


--Set BTST for all remaining unassigned records
UPDATE	[Porteous$Customer]
SET	CustCd='BTST', fBillToNo=[No_]
FROM	[Porteous$Customer]
WHERE	CustCd is NULL


--Set BTST for any BT that starts with 0
UPDATE	[Porteous$Customer]
SET	CustCd='BTST', fBillToNo=[No_]
FROM	[Porteous$Customer]
WHERE	CustCd='BT' AND LEFT([No_], 1)=0



