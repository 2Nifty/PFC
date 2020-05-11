		--Ready To Ship (PO's) [RTS]
		 SELECT	TotRTS.GroupNo,
			ROUND(SUM(TotRTS.TotLbs),0) as TotRTSLbs
		 FROM	(SELECT	PO.GroupNo,
			 	SUM(PO.ExtWgt) as TotLbs
	 		 FROM	(SELECT	POL.[Location Code] AS Loc, 
					BUY.GroupNo,
					BUY.[Description] as GrpDesc,
					POL.[Outstanding Net Weight] AS ExtWgt
				 FROM	OpenDataSource ('SQLOLEDB', 'Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal' ).PFCLive.[dbo].[Porteous$Purchase Line] POL INNER JOIN
		 			ItemMaster IM
				 ON	IM.[ItemNo]=POL.[No_] LEFT OUTER JOIN
				 	CategoryBuyGroups BUY (NoLock)
				 ON	LEFT(POL.No_, 5) = BUY.Category COLLATE Latin1_General_CS_AS
				 WHERE	POL.Type = 2 AND								--PO Line Type = ITEM
					POL.[Outstanding Quantity] > 0 AND						--PO has outstanding Qty
				 	POL.[Expected Receipt Date] > CONVERT(DATETIME, '2010-01-01 00:00:00', 102) AND	--Ignoring old PO's
					(POL.[Location Code] between '00' and '18') AND					--Branches 00 to 18 only
					(POL.[PO Status Code] = 'B') AND						--'B' Status only is RTS
					LEFT([Document No_],1) in ('0','1','2') AND					--Doc No begins with 0, 1, 2
--					SUBSTRING(POL.No_,12,1) in ('0','1','5') AND					--Bulk Items only
					IM.WebEnabledInd ='1') PO							--Web Enabled only
			 GROUP BY PO.Loc, PO.GroupNo) TotRTS
		 GROUP BY TotRTS.GroupNo

--SubTotGroup BOLTS
--where	GroupNo=15 or GroupNo=20 or GroupNo=30 or GroupNo=60 or
--	GroupNo=110 or GroupNo=120 or GroupNo=125 or GroupNo=130

ORDER BY TotRTS.GroupNo







		--Ready To Ship (PO's) [RTS]
		 SELECT	TotRTS.GroupNo,
			ROUND(SUM(TotRTS.TotLbs),0) as TotRTSLbs
		 FROM	(SELECT	PO.GroupNo,
			 	SUM(PO.ExtWgt) as TotLbs
	 		 FROM	(SELECT	POL.[ReceivingLocation] AS Loc, 
					BUY.GroupNo,
					BUY.[Description] as GrpDesc,
					(POL.QtyOrdered - POL.QtyReceived) * IM.Wght AS ExtWgt
				 FROM	PODetail POL INNER JOIN
		 			ItemMaster IM
				 ON	IM.[ItemNo]=POL.[ItemNo] LEFT OUTER JOIN
				 	CategoryBuyGroups BUY (NoLock)
				 ON	LEFT(POL.ItemNo, 5) = BUY.Category COLLATE Latin1_General_CS_AS
				 WHERE	
--					POL.Type = 2 AND									--PO Line Type = ITEM
					(POL.QtyOrdered - POL.QtyReceived) > 0 AND						--PO has outstanding Qty
				 	POL.[LastSchdReceiptDt] > CONVERT(DATETIME, '2010-01-01 00:00:00', 102) AND		--Ignoring old PO's
					(POL.[ReceivingLocation] between '00' and '18') AND					--Branches 00 to 18 only
					(POL.[POStatusCd] = 'B') AND								--'B' Status only is RTS
					LEFT([POOrderNo],1) in ('0','1','2') AND						--Doc No begins with 0, 1, 2
--					SUBSTRING(POL.ItemNo,12,1) in ('0','1','5') AND						--Bulk Items only
					IM.WebEnabledInd ='1') PO							--Web Enabled only
			 GROUP BY PO.Loc, PO.GroupNo) TotRTS
		 GROUP BY TotRTS.GroupNo

--SubTotGroup BOLTS
--where	GroupNo=15 or GroupNo=20 or GroupNo=30 or GroupNo=60 or
--	GroupNo=110 or GroupNo=120 or GroupNo=125 or GroupNo=130

ORDER BY TotRTS.GroupNo
