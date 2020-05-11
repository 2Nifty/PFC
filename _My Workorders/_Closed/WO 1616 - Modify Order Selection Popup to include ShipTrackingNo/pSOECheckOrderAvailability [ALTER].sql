
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


-- ==================================================================================================
-- Procedure :	[pSOECheckOrderAvailability]
-- Comments	 :  Check for availability in all the Order tables 
-- ----------------------------------------------------------------------------------------------------
-- Date			Developer		Action		Purpose
-- ----------------------------------------------------------------------------------------------------
-- 01/Jan/2009		Sathish			Created
-- 01/08/2008		Sathya			Modified
-- 11-Jan-2010		TDixon			Modified	Append ShipTrackingNo
-- ====================================================================================================  
ALTER  PROCEDURE [dbo].[pSOECheckOrderAvailability]
@orderNo varchar(20)
AS

BEGIN
	DECLARE @ORDERAVAIL INT
	
	IF (UPPER(SUBSTRING(@orderNo,1,2)) = 'SO')
	   BEGIN		
		select @ORDERAVAIL = count(*) from SOHeaderRel where SOHeaderRel.RefSONo=@orderNo
		IF (@ORDERAVAIL >0)
		   BEGIN
			select	ShipLoc
			from	SOHeader
			where	SOHeader.pSOHeaderID=''

			select	OrderNo as pSOHeaderHistID,
				convert(varchar(20),OrderNo) + ' - Brn ' + convert(varchar(20),ShipLoc) + ' - Inv# ' + InvoiceNo +
				   (case when (ShipTrackingNo is not null and ShipTrackingNo <> '') then ' Tk# ' + ShipTrackingNo else ' ' end) as ShipLoc,
				fSOHeaderID
			from	SOHeaderHist
			where	SOHeaderHist.pSOHeaderHistID='' 

			select	OrderNo as pSOHeaderRelID,
				convert(varchar(20),pSOHeaderRelID) + ' - Brn ' + convert(varchar(20),ShipLoc) +
				   (case when (PickDt is not null and PickCompDt is not null and ShippedDt is not null and ConfirmShipDt is not null) then ' - Shipped'
					 when (PickDt is not null and PickCompDt is not null and ShippedDt is not null and ConfirmShipDt is null) then ' - Shipping'
					 when (PickDt is not null and PickCompDt is not null and ShippedDt is null and ConfirmShipDt is null) then ' - Picked'
					 when (PickDt is not null and PickCompDt is null and ShippedDt is  null and ConfirmShipDt is null) then '- Picking'
					 when (Allocdt is null and RlsWhseDt is null and deletedt is null) then ' - On Hold'
					 when (deletedt is not null and deletedt <>'') then ' - Deleted'
					 else ' - Warehouse'
				    end) + 
				   (case when (ShipTrackingNo is not null and ShipTrackingNo <> '') then ' Tk# ' + ShipTrackingNo else ' ' end) as ShipLoc,
				fSOHeaderID
			from	SOHeaderRel
			where	SOHeaderRel.RefSONo=@orderNo 			
		   END
		ELSE
		   BEGIN
			select	ShipLoc
			from	SOHeader
			where	SOHeader.pSOHeaderID=''

			select	OrderNo as pSOHeaderHistID,
				convert(varchar(20),OrderNo) + ' - Brn ' + convert(varchar(20),ShipLoc) + ' - Inv# ' + InvoiceNo + 
				   (case when (ShipTrackingNo is not null and ShipTrackingNo <> '') then ' Tk# ' + ShipTrackingNo else ' ' end) as ShipLoc,
				fSOHeaderID
			from	SOHeaderHist
			where	SOHeaderHist.RefSONo=@orderNo 

			select	OrderNo as pSOHeaderRelID,
				convert(varchar(20),pSOHeaderRelID) + ' - Brn '	+ convert(varchar(20),ShipLoc) +
				   (case when (PickDt is not null and PickCompDt is not null and ShippedDt is not null and ConfirmShipDt is not null) then ' - Shipped'
					 when (PickDt is not null and PickCompDt is not null and ShippedDt is not null and ConfirmShipDt is null) then ' - Shipping'
					 when (PickDt is not null and PickCompDt is not null and ShippedDt is null and ConfirmShipDt is null) then ' - Picked'
					 when (PickDt is not null and PickCompDt is null and ShippedDt is  null and ConfirmShipDt is null) then '- Picking'
					 when (Allocdt is null and RlsWhseDt is null and deletedt is null) then ' - On Hold'
					 when (deletedt is not null and deletedt <>'') then ' - Deleted'
					 else ' - Warehouse'
				    end) +
			   	   (case when (ShipTrackingNo is not null and ShipTrackingNo <> '') then ' Tk# ' + ShipTrackingNo else ' ' end) as ShipLoc,
				fSOHeaderID
			from	SOHeaderRel
			where	SOHeaderRel.pSOHeaderRelID=''
		   END
	   END
	ELSE 
	   BEGIN
		select	ShipLoc
		from	SOHeader
		where	SOHeader.fSOHeaderID=@orderNo

		--select OrderNo as pSOHeaderHistID,convert(varchar(20),OrderNo) + ' - Brn '+ convert(varchar(20),ShipLoc)  as ShipLoc,fSOHeaderID  from SOHeaderHist where SOHeaderHist.fSOHeaderID in (Select pSOHeaderRelID from SOHeaderRel where SOHeaderRel.fSOHeaderID=@orderNo) 

		select	OrderNo as pSOHeaderHistID,
			convert(varchar(20),OrderNo) + ' - Brn ' + convert(varchar(20),ShipLoc) + ' - Inv# ' + InvoiceNo + 
			   (case when (ShipTrackingNo is not null and ShipTrackingNo <> '') then ' Tk# ' + ShipTrackingNo else ' ' end) as ShipLoc,
			fSOHeaderID
		from	SOHeaderHist where SOHeaderHist.fSOHeaderID=@orderNo 

		select	OrderNo as pSOHeaderRelID,
			convert(varchar(20),pSOHeaderRelID) + ' - Brn ' + convert(varchar(20),ShipLoc) +
			   (case when (PickDt is not null and PickCompDt is not null and ShippedDt is not null and ConfirmShipDt is not null) then ' - Shipped'
				 when (PickDt is not null and PickCompDt is not null and ShippedDt is not null and ConfirmShipDt is null) then ' - Shipping'
				 when (PickDt is not null and PickCompDt is not null and ShippedDt is null and ConfirmShipDt is null) then ' - Picked'
				 when (PickDt is not null and PickCompDt is null and ShippedDt is  null and ConfirmShipDt is null) then '- Picking'
				 when (Allocdt is null and RlsWhseDt is null and deletedt is null) then ' - On Hold'
				 when (deletedt is not null and deletedt <>'') then ' - Deleted'
				 else ' - Warehouse'
			    end) +
			   (case when (ShipTrackingNo is not null and ShipTrackingNo <> '') then ' Tk# ' + ShipTrackingNo else ' ' end) as ShipLoc,
			fSOHeaderID
		from	SOHeaderRel
		where	SOHeaderRel.fSOHeaderID=@orderNo and SOHeaderRel.InvoiceDt is null
	   END 
END

