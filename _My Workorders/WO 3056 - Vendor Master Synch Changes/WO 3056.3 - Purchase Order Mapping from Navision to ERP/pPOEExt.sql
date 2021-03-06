USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pPOEExt]    Script Date: 09/19/2012 17:34:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pPOEExt]
	@ExtType varchar(20) = '',
	@pPoHeaderId varchar(20) = ''
AS
-- =============================================
-- Author:		Sathish
-- Create date:	08/10/2010
-- Description:	Procedure to Extend PODetail & POHeader totals
-- =============================================
/*
exec [pPOEExt] 'POHeader','9820'
*/

BEGIN
	SET NOCOUNT ON;

	declare @totCost decimal(18,6);	
	declare @totNetWght decimal(18,6);

	IF @ExtType ='POHeader'
	BEGIN
		Select 	@totCost=sum(ExtendedCost),
				@totNetWght = sum(ExtendedWeight)
		From	PODetail
		Where	fPoHeaderID = @pPoHeaderId and DeleteDt is Null
		
		-- Update PoHeader Table
		Update	POHeader 
		Set		TotalCost = ISNULL(@totCost,0),
				TotalNetWeight = ISNULL(@totNetWght,0)
		Where	pPoHeaderID = @pPoHeaderId 

	END
		

END















