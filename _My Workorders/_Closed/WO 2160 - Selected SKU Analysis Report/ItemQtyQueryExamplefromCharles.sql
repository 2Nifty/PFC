-- corporate level inventory qty reporting by item query
Select	IM.ItemNo
		,sum(AvlQty) as AvlQty
		,sum(TrfQty) as TrfQty
		,sum(OWQty) as OWQty
		,sum(RTSBQty) as RTSBQty
		,sum(STSEQty) as STSEQty
		,sum(STSJQty) as STSJQty
Into	##InvPosition
From	(Select	Coalesce(SI.ItemNo,RTSB.ItemNo,StsE.ItemNo,StsJ.ItemNo) as ItemNo
				,AvlQty = isnull(sum(case rtrim(SourceCd)
									when 'SO' then Qty
									when 'OH' then Qty
									when 'RE' then Qty
									when 'NA' then Qty
									when 'TO' then Qty
									else 0 end),0)
				,TrfQty = isnull(sum(case rtrim(SourceCd)
									when 'TI' then Qty
									else 0 end),0)
				,OWQty = isnull(sum(case rtrim(SourceCd)
									when 'OW' then Qty
									else 0 end),0)
				,isnull(max(RTSB.RTSBQty),0) as RTSBQty	
				,isnull(max(StsE.StsEQty),0) as STSEQty	
				,isnull(max(StsJ.StsJQty),0) as STSJQty	
		From	SumItem SI (nolock)
		Full Outer Join (Select	ItemNo, sum(RTSBQty) as RTSBQty
						FROM	(Select	POD.ItemNo
										,POD.QtyOrdered - POD.QtyReceived as RTSBQty
								From	POHeader POH (nolock)
								Inner Join PODetail POD (nolock) ON	
										POH.pPOHeaderID	= POD.fPOHeaderID
								Inner Join ItemMaster IM (nolock) ON
										IM.ItemNo = POD.ItemNo
								Where	isnull(POD.DeleteDt,'01/01/1900') = '01/01/1900'
										and isnull(POH.DeleteDt,'01/01/1900') = '01/01/1900'
										and POD.QtyOrdered - POD.QtyReceived  > 0 
										and POSubType not between '40' and '49'
										and POD.POStatusCd in ('B') -- B is RTS Approved
								) tmp
						Group by ItemNo) RTSB ON
						RTSB.ItemNo = SI.ItemNo
		Full Outer Join (Select	ItemNo, sum(StsEQty) as StsEQty
						FROM	(Select	POD.ItemNo
										,POD.QtyOrdered - POD.QtyReceived as StsEQty
								From	POHeader POH (nolock)
								Inner Join PODetail POD (nolock) ON	
										POH.pPOHeaderID	= POD.fPOHeaderID
								Inner Join ItemMaster IM (nolock) ON
										IM.ItemNo = POD.ItemNo
								Where	isnull(POD.DeleteDt,'01/01/1900') = '01/01/1900'
										and isnull(POH.DeleteDt,'01/01/1900') = '01/01/1900'
										and POD.QtyOrdered - POD.QtyReceived  > 0 
										and POSubType not between '40' and '49'
										and POD.POStatusCd in ('E') -- Already Expedited
								) tmp
						Group by ItemNo) StsE ON
						StsE.ItemNo = SI.ItemNo
		Full Outer Join (Select	ItemNo, sum(StsJQty) as StsJQty
						FROM	(Select	POD.ItemNo
										,POD.QtyOrdered - POD.QtyReceived as StsJQty
								From	POHeader POH (nolock)
								Inner Join PODetail POD (nolock) ON	
										POH.pPOHeaderID	= POD.fPOHeaderID
								Inner Join ItemMaster IM (nolock) ON
										IM.ItemNo = POD.ItemNo
								Where	isnull(POD.DeleteDt,'01/01/1900') = '01/01/1900'
										and isnull(POH.DeleteDt,'01/01/1900') = '01/01/1900'
										and POD.QtyOrdered - POD.QtyReceived  > 0 
										and POSubType not between '40' and '49'
										and POD.POStatusCd in ('J') -- Vendor has revised due date 
								) tmp
						Group by ItemNo) StsJ ON
						StsJ.ItemNo = SI.ItemNo
		Group by SI.ItemNo, RTSB.ItemNo, StsE.ItemNo, StsJ.ItemNo
		) RawData
Inner Join ItemMaster IM (nolock) ON
		IM.ItemNo = RawData.ItemNo
Group by IM.ItemNo, RawData.ItemNo
