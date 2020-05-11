drop proc [pTEMPIMGetFastFields]
go

/****** Object:  StoredProcedure [dbo].[pTEMPIMGetFastFields]    Script Date: 04/27/2012 13:59:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec pTEMPIMGetFastFields 'BoxSize'

CREATE PROCEDURE [dbo].[pTEMPIMGetFastFields]
	@FieldName varchar(30)
AS
BEGIN

	DECLARE	@Query nvarchar(max)

--declare @FieldName varchar(30)
--set @FieldName = 'CatDesc'


	SET		@Query = 'SELECT	 ItemNo, ' + @FieldName + ', ' + @FieldName + ' ' +
					 'FROM ItemMaster WHERE ItemNo in (''00900-3232-080'', ' +
									'''00056-2420-081'', ' +
									'''00087-2660-082'', ' +
									'''00384-2824-084'', ' +
									'''00086-2624-088'', ' +
									'''00661-0816-089'', ' +
									'''00380-2820-020'', ' +
									'''00390-4200-021'', ' +
									'''00375-2600-024'', ' +
									'''00370-2300-028'', ' +
									'''00370-3400-029'', ' +
									'''00170-2610-100'', ' +
									'''00170-4106-101'', ' +
									'''00170-4210-104'', ' +
									'''99999-6969-161'') ORDER BY ItemNo'

	PRINT	@Query
	EXEC	sp_executesql @Query

END
