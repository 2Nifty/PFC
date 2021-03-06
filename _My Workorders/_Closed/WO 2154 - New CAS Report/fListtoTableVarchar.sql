USE [DEVPERP]
GO
/****** Object:  UserDefinedFunction [dbo].[fListToTableVarchar]    Script Date: 01/17/2011 13:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fListToTableVarchar](@list as nvarchar(max), @delim as varchar(10))
RETURNS @listTable table(
  Value varchar(100)
  )
AS
BEGIN
    --Declare helper to identify the position of the delim
    DECLARE @DelimPosition INT
    
    --Prime the loop, with an initial check for the delim
    SET @DelimPosition = CHARINDEX(@delim, @list)

    --Loop through, until we no longer find the delimiter
    WHILE @DelimPosition > 0
    BEGIN
        --Add the item to the table
        INSERT INTO @listTable(Value)
            VALUES(CAST(RTRIM(LEFT(@list, @DelimPosition - 1)) AS varchar(100)))
    
        --Remove the entry from the List
        SET @list = right(@list, len(@list) - @DelimPosition)

        --Perform position comparison
        SET @DelimPosition = CHARINDEX(@delim, @list)
    END

    --If we still have an entry, add it to the list
    IF len(@list) > 0
        insert into @listTable(Value)
        values(CAST(RTRIM(@list) AS varchar(100)))

  RETURN
END

