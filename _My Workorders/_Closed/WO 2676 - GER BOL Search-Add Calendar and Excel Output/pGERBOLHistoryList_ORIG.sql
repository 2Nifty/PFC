USE [PFCReports]
GO
/****** Object:  StoredProcedure [dbo].[pGERBOLHistoryList]    Script Date: 11/28/2011 13:26:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pGERBOLHistoryList]
	@ItemNo varchar(25),
	@PONumber varchar(25),
	@ContainerNo varchar(50),
	@Location varchar(10)
	
AS
-- =============================================
-- Author:		Charles Rojas
-- Create date: 03/07/11
-- Description:	WO2329 GER BOL Search Capability
-- =============================================

/*
exec pGERBOLHistoryList '01110-2650-500','',''
exec pGERBOLHistoryList '01110-2650-500', '21020331',''
exec pGERBOLHistoryList '','21020331', ''
exec pGERBOLHistoryList '','','TCLU2762071'
*/
--
BEGIN
	SET NOCOUNT ON;
	SET @ItemNo = isnull(@ItemNo,'');
	SET @PONumber = isnull(@PONumber,'');
	SET @ContainerNo = isnull(@ContainerNo,'');

	SELECT	BOLNo
			,VendInvNo
			,VendInvDt
			,ContainerNo
			,PFCPONo
			,PFCItemNo
			,PFCItemDesc
			,PFCLocNo
			,RcptQty
			,CONVERT(varchar(10),EntryDt,101) as EntryDt
	FROM	GERDetailHist
	WHERE	PFCItemNo like Case When @ItemNo = '' then '%' else @ItemNo end
			AND PFCPONo like Case when @PONumber = '' then '%' else @PONumber end
			AND ContainerNo like Case when @ContainerNo = '' then '%' else @ContainerNo end
			And PFCLocNo like Case when @Location = '' then '%' else @Location end
	ORDER BY EntryDt desc


END

