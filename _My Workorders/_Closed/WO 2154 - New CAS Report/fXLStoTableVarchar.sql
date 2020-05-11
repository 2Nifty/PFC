drop function fXLSToTableVarchar
go

CREATE FUNCTION [dbo].[fXLSToTableVarchar](@file as varchar(500))
RETURNS @listTable table(Value varchar(100))
AS
BEGIN
	DECLARE @listTable table(Value varchar(100))
	DECLARE @file varchar(500)
	SET @file = 'c:\WO2154_CustList.xls'

	DECLARE @SQL nvarchar(4000)
--	SET @SQL = 'SELECT F1 as Value INTO @listTable FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;HDR=NO;Database=' + @file + ''',''SELECT * FROM [Sheet1$]'')'

set @SQL = 'INSERT INTO @listTable(Value) (SELECT	F1 as Value FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;HDR=NO;Database=' + @file + ''',''SELECT * FROM [Sheet1$]'')'


	EXEC sp_executesql @SQL
  RETURN
END
GO
