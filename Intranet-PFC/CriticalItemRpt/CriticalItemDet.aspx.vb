
Partial Class CriticalItemDet
    Inherits System.Web.UI.Page
    Dim SelCmd As String
    Public ExcelFile, ExportFile As String
    Dim TotQty, GrdtotQty, RecCount As Integer
    Dim TotUse, GrdTotUse, TotMonths, GrdTotMonths, TotLbs, GrdTotLbs, TotCriticalLbs, GrdTotCriticalLbs, TotCriticalPct, GrdTotCriticalPct As Decimal
    Dim TotQtyWgt As Decimal

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (String.IsNullOrEmpty(Request.QueryString("VelocityCode").ToString())) Then
            SelCmd = "SELECT [ItemNo], [CorpFixedVelCode] as VelocityCode, [ExtSoldWght], [AvailQty], [TotUse30], [AvailQty] * [Net_Wgt] as QtyWgt, [AvailQty] * [Net_Wgt] / [ExtSoldWght] AS MonthsOnHand, [CriticalQty], [CriticalFlag], [NonCriticalFlag], [CriticalWght], [NonCriticalWght], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct], [Description], [LocationCode], [LocationName], [Net_Wgt] as NetWgt FROM [CriticalItemDetail] WHERE [CriticalFlag] >= " & Request.QueryString("Critical") & " AND [LocationCode] = " & Request.QueryString("LocNum") & " ORDER BY ItemNo"
            If (Request.QueryString("Critical") > 0) Then
                lblVelocityType.Text = "All Velocity Codes - Critical Items Only"
            Else
                lblVelocityType.Text = "All Velocity Codes"
            End If
            ExcelFile = "CriticalDetailAll.xls"
        Else
            If (Request.QueryString("VelocityType") = "Corp") Then
                SelCmd = "SELECT [ItemNo], [CorpFixedVelCode] as VelocityCode, [ExtSoldWght], [AvailQty], [TotUse30], [AvailQty] * [Net_Wgt] as QtyWgt, [AvailQty] * [Net_Wgt] / [ExtSoldWght] AS MonthsOnHand, [CriticalQty], [CriticalFlag], [NonCriticalFlag], [CriticalWght], [NonCriticalWght], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct], [Description], [LocationCode], [LocationName], [Net_Wgt] as NetWgt FROM [CriticalItemDetail] WHERE [CorpFixedVelCode] = '" & Request.QueryString("VelocityCode") & "' AND [CriticalFlag] >= " & Request.QueryString("Critical") & " AND [LocationCode] = " & Request.QueryString("LocNum") & " ORDER BY ItemNo"
                lblVelocityType.Text = "Corp Fixed Velocity : " + Request.QueryString("VelocityCode")
                If (Request.QueryString("Critical") > 0) Then
                    lblVelocityType.Text = lblVelocityType.Text + " - Critical Items Only"
                End If
                ExcelFile = "CriticalDetailCorp.xls"
            Else
                SelCmd = "SELECT [ItemNo], [CatVelCode] as VelocityCode, [ExtSoldWght], [AvailQty], [TotUse30], [AvailQty] * [Net_Wgt] as QtyWgt, [AvailQty] * [Net_Wgt] / [ExtSoldWght] AS MonthsOnHand, [CriticalQty], [CriticalFlag], [NonCriticalFlag], [CriticalWght], [NonCriticalWght], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPctCat] AS TargetPct, [Description], [LocationCode], [LocationName], [Net_Wgt] as NetWgt FROM [CriticalItemDetail] WHERE [CatVelCode] = '" & Request.QueryString("VelocityCode") & "' AND [CriticalFlag] >= " & Request.QueryString("Critical") & " AND [LocationCode] = " & Request.QueryString("LocNum") & " ORDER BY ItemNo"
                lblVelocityType.Text = "Category Velocity : " + Request.QueryString("VelocityCode")
                If (Request.QueryString("Critical") > 0) Then
                    lblVelocityType.Text = lblVelocityType.Text + " - Critical Items Only"
                End If
                ExcelFile = "CriticalDetailCat.xls"
            End If
        End If

        If Not Page.IsPostBack Then
            BindDataGrid()
        End If

        If Request.QueryString("LocDesc") <> "" Then
            LocDesc.Text = Request.QueryString("LocDesc")
        End If
    End Sub

    Private Sub Pager_PageChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Pager1.BubbleClick
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber
        BindDataGrid()
    End Sub

    Private Sub BindDataGrid()
        Dim adp As New Data.SqlClient.SqlDataAdapter(SelCmd, System.Web.Configuration.WebConfigurationManager.ConnectionStrings("csPFCReports").ConnectionString)
        Dim ds As New Data.DataSet

        adp.Fill(ds)
        GridView1.DataSource = ds.Tables(0)

        If ds.Tables(0).Rows.Count > 0 Then
            GrdtotQty = ds.Tables(0).Compute("sum(AvailQty)", "")
            lblTotQty.Text = Format(CDbl(GrdtotQty), "##,##0")

            GrdTotUse = ds.Tables(0).Compute("sum(TotUse30)", "")
            lblTotUse.Text = Format(CDbl(GrdTotUse), "##,##0")

            GrdTotMonths = ds.Tables(0).Compute("sum(QtyWgt) / sum(ExtSoldWght)", "")
            lblTotMonths.Text = Format(CDbl(GrdTotMonths), "##,##0.0")

            GrdTotLbs = ds.Tables(0).Compute("sum(ExtSoldWght)", "")
            lblTotLbs.Text = Format(CDbl(GrdTotLbs), "##,##0")

            GrdTotCriticalLbs = ds.Tables(0).Compute("sum(CriticalWght)", "")
            lblTotCriticalLbs.Text = Format(CDbl(GrdTotCriticalLbs), "##,##0")

            GrdTotCriticalPct = 0
            If GrdTotLbs > 0 Then
                GrdTotCriticalPct = GrdTotCriticalLbs / GrdTotLbs
            End If
            If GrdTotCriticalPct > 1 Then
                GrdTotCriticalPct = 1
            End If
            lblCriticalPct.Text = Format(CDbl(GrdTotCriticalPct), "##0.0%")

            lblNonCriticalPct.Text = Format(1 - CDbl(GrdTotCriticalPct), "##0.0%")

            If Request.QueryString("LocDesc") = "" Then
                LocDesc.Text = ds.Tables(0).Rows(1).Item(14).ToString() + " - " + ds.Tables(0).Rows(1).Item(15).ToString()
            End If
        End If

        Pager1.InitPager(GridView1, 22)
    End Sub


    Private Sub DataGrid1_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles GridView1.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then

            'Response.Write(e.Item.Cells(2).Text)
            TotQty = TotQty + Convert.ToInt32(e.Item.Cells(2).Text)
            e.Item.Cells(2).Text = Format(CDbl(e.Item.Cells(2).Text), "##,##0")

            TotUse = TotUse + Convert.ToDecimal(e.Item.Cells(3).Text)
            e.Item.Cells(3).Text = Format(CDbl(e.Item.Cells(3).Text), "##,##0")

            'TotMonths = TotMonths + Convert.ToDecimal(e.Item.Cells(4).Text)
            e.Item.Cells(4).Text = Format(CDbl(e.Item.Cells(4).Text), "##,##0.0")

            TotLbs = TotLbs + Convert.ToDecimal(e.Item.Cells(5).Text)
            e.Item.Cells(5).Text = Format(CDbl(e.Item.Cells(5).Text), "##,##0")

            TotCriticalLbs = TotCriticalLbs + Convert.ToDecimal(e.Item.Cells(6).Text)
            e.Item.Cells(6).Text = Format(CDbl(e.Item.Cells(6).Text), "##,##0")

            TotQtyWgt = TotQtyWgt + Convert.ToDecimal(e.Item.Cells(2).Text) * Convert.ToDecimal(e.Item.Cells(10).Text)
        End If

        If e.Item.ItemType = ListItemType.Footer Then
            e.Item.Cells(1).Text = "Sub-Totals:"

            e.Item.Cells(2).Text = TotQty
            e.Item.Cells(2).Text = Format(CDbl(e.Item.Cells(2).Text), "##,##0")

            e.Item.Cells(3).Text = TotUse
            e.Item.Cells(3).Text = Format(CDbl(e.Item.Cells(3).Text), "##,##0")

            e.Item.Cells(4).Text = TotQtyWgt / TotLbs
            e.Item.Cells(4).Text = Format(CDbl(e.Item.Cells(4).Text), "##,##0.0")

            e.Item.Cells(5).Text = TotLbs
            e.Item.Cells(5).Text = Format(CDbl(e.Item.Cells(5).Text), "##,##0")

            e.Item.Cells(6).Text = TotCriticalLbs
            e.Item.Cells(6).Text = Format(CDbl(e.Item.Cells(6).Text), "##,##0")

            TotCriticalPct = 0
            If TotLbs > 0 Then
                TotCriticalPct = TotCriticalLbs / TotLbs
            End If
            If TotCriticalPct > 1 Then
                TotCriticalPct = 1
            End If
            e.Item.Cells(7).Text = Format(CDbl(TotCriticalPct), "##0.0%")

            e.Item.Cells(8).Text = Format(1 - CDbl(TotCriticalPct), "##0.0%")

        End If
    End Sub


    Protected Sub ExportRpt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ExportRpt.Click
        Dim adp As New Data.SqlClient.SqlDataAdapter(SelCmd, System.Web.Configuration.WebConfigurationManager.ConnectionStrings("csPFCReports").ConnectionString)
        Dim ds As New Data.DataSet

        ExportFile = "CriticalItemRpt\Excel\" + ExcelFile
        FileOpen(1, My.Request.PhysicalApplicationPath & ExportFile, OpenMode.Output)   ' Open file for output.

        PrintLine(1, "Item" & Chr(9) & _
            "Description" & Chr(9) & _
            "Available" & Chr(9) & _
            "30 Day Usage" & Chr(9) & _
            "Months On-Hand" & Chr(9) & _
            "30D Usage Lbs" & Chr(9) & _
            "Critical Pounds" & Chr(9) & _
            "% Critical (Pounds)" & Chr(9) & _
            "% Non Critical (Pounds)" & Chr(9) & _
            "Target %")

        adp.Fill(ds)

        If ds.Tables(0).Rows.Count() > 0 Then
            For RecCount = 0 To (ds.Tables(0).Rows.Count() - 1)
                PrintLine(1, ds.Tables(0).Rows(RecCount).Item("ItemNo").ToString & Chr(9) & _
                             ds.Tables(0).Rows(RecCount).Item("Description").ToString & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("AvailQty"), "###,##0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("TotUse30"), "###,##0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("MonthsOnHand"), "###,##0.0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("ExtSoldWght"), "#,###,##0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("CriticalWght"), "#,###,##0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("CriticalWghtPct"), "##0.0%") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("NonCriticalWghtPct"), "##0.0%") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("TargetPct"), "##0.0%"))
            Next
        Else
            PrintLine(1, "No detail records found in CriticalItemDetail Table")
        End If

        FileClose(1)           ' Close file.

        ExportFile = "Excel\" + ExcelFile
        Me.Server.Transfer("ExcelDetail.aspx?Filename=" & ExportFile, True)

    End Sub

End Class
