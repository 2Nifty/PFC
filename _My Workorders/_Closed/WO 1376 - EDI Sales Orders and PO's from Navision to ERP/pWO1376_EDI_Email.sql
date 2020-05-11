
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pWO1376_EDI_Email]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pWO1376_EDI_Email]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.pWO1376_EDI_Email 
AS
-- ===================================================================
-- Author:	Tod Dixon
-- Create date:	2009-Jul-22
-- Description:	EDI Email notification for WO1376_Daily_SO_EDI_To_ERP
-- ===================================================================

IF ((SELECT	COUNT(*)
     FROM	SOHeader
     WHERE	EXISTS (SELECT	RefSONo
			FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
			WHERE	TempSO.RefSONo = SOHeader.RefSONo)) > 0)
  BEGIN
     PRINT 'EDI Orders Found'
--   Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','EDI_NV@porteousfastener.com, it_ops@porteousfastener.com',		--TO & FROM
     Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','tdixon@porteousfastener.com',						--TO & FROM
     					'New EDI Orders from NaVision  [WO1376_Daily_SO_EDI_To_ERP]',						--Subject
     					'Please see the list (attached) of EDI orders moved from NaVision to ERP.',				--Body
     					'\\pfcfiles\userdb\WO1376_Daily_SO_To_EDI.csv'								--Attachment
  END
ELSE 
  BEGIN
     PRINT 'No EDI Orders Found'
--   Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','it_ops@porteousfastener.com',						--TO & FROM
     Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','tdixon@porteousfastener.com',						--TO & FROM
     					'Complete: WO1376_Daily_SO_EDI_To_ERP',									--Subject
     					'WO1376_Daily_SO_EDI_To_ERP.dts appears to have completed successfully.<br>No EDI Orders found.',	--Body
     					''													--Attachment
  END

GO
