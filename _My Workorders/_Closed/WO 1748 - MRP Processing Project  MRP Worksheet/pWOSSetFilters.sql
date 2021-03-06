
/****** Object:  StoredProcedure [dbo].[pWOSSetFilters]    Script Date: 04/01/2010 12:44:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[pWOSSetFilters]
@WhereClause varchar(max)
as
----pWOSSetFilters
----Written By: Tod Dixon
----Application: MRP

DECLARE @sql NVARCHAR(4000),
	@error VARCHAR(200) 

IF @WhereClause = 'WHERE '
   BEGIN
	SET @sql = 'SELECT pWOWorkSheetID, UsageVelocityCd, ActionStatus, PriorityCd, WOItemNo, WOItemDesc, ' + 
		   '       ActionQty, ActionType, AcceptActionDt, WOBranch, WODueDt, ParentItemNo ' +
		   'FROM   WOWorkSheet (NOLOCK) ' + 
		   'Order By ActionStatus ASC, WOItemNo ASC, PriorityCd ASC'
   END
ELSE
   BEGIN
	SET @sql = 'SELECT pWOWorkSheetID, UsageVelocityCd, ActionStatus, PriorityCd, WOItemNo, WOItemDesc, ' + 
		   '       ActionQty, ActionType, AcceptActionDt, WOBranch, WODueDt, ParentItemNo ' +
		   'FROM   WOWorkSheet (NOLOCK) ' + @WhereClause + ' ' +
		   'Order By ActionStatus ASC, WOItemNo ASC, PriorityCd ASC'
   END

print @sql
EXEC sp_executesql @sql 

SELECT @error = @@ERROR  
IF @error <> 0   
   BEGIN  
	GOTO ERROR  
   END  
ERROR:

