
Partial Class CriticalItemRpt
    Inherits System.Web.UI.Page
    Dim SelCmd As String
    Public ExcelFile, ExportFile As String
    Dim TotItemCount, TotCriticalCount, TotLbs, TotCriticalLbs, RecCount As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            RBCorp.Checked = True
            SelCmd = "SELECT LocID, LocName, LocID + ' - ' + LocName as ListIndex from LocMaster ORDER BY LocID"
            BindLocationList()
            LocNum.Value = "00"
            LocDesc.Value = "00 - Porteous Fastener Company"
        End If

        If RBCorp.Checked = True Then
            'Response.Write("Corp")
            VelocityType.Value = "Corp"
            SelCmd = "SELECT [VelocityCode], [TotCount], [CriticalCount], [CriticalCountPct], [TotWght], [TotWghtCritical], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct] FROM [CriticalItemSummary] WHERE ([LocationCode] = " + LocationList.SelectedValue.ToString + ")"
            ExcelFile = "CriticalItemsCorp.xls"
        End If

        If RBCat.Checked = True Then
            'Response.Write("Cat")
            VelocityType.Value = "Cat"
            SelCmd = "SELECT [VelocityCode], [TotCount], [CriticalCount], [CriticalCountPct], [TotWght], [TotWghtCritical], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct] FROM [CriticalItemSummaryCat] WHERE ([LocationCode] = " + LocationList.SelectedValue.ToString + ")"
            ExcelFile = "CriticalItemsCat.xls"
        End If
        BindDataGrid()
    End Sub

    Private Sub BindDataGrid()
        Dim adp As New Data.SqlClient.SqlDataAdapter(SelCmd, System.Web.Configuration.WebConfigurationManager.ConnectionStrings("csPFCReports").ConnectionString)
        Dim ds As New Data.DataSet

        adp.Fill(ds)
        GridView1.DataSource = ds.Tables(0)
        GridView1.DataBind()
    End Sub

    Private Sub BindLocationList()
        Dim adp As New Data.SqlClient.SqlDataAdapter(SelCmd, System.Web.Configuration.WebConfigurationManager.ConnectionStrings("csPFCReports").ConnectionString)
        Dim ds As New Data.DataSet

        adp.Fill(ds)
        LocationList.DataSource = ds.Tables(0)
        LocationList.DataTextField = "ListIndex"
        LocationList.DataValueField = "LocID"
        LocationList.DataBind()
        LocationList.SelectedValue = 0
    End Sub

    Private Sub DataGrid1_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles GridView1.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            TotItemCount = TotItemCount + Convert.ToInt32(e.Item.Cells(2).Text)
            TotCriticalCount = TotCriticalCount + Convert.ToInt32(e.Item.Cells(4).Text)

            TotLbs = TotLbs + Convert.ToInt32(e.Item.Cells(6).Text)
            e.Item.Cells(6).Text = Format(CDbl(e.Item.Cells(6).Text), "##,##0")

            TotCriticalLbs = TotCriticalLbs + Convert.ToInt32(e.Item.Cells(7).Text)
            e.Item.Cells(7).Text = Format(CDbl(e.Item.Cells(7).Text), "##,##0")
        End If

        If e.Item.ItemType = ListItemType.Footer Then

            Dim HLinkItem As New HyperLink
            e.Item.Cells(1).Text = TotItemCount
            e.Item.Cells(1).Text = Format(CDbl(e.Item.Cells(1).Text), "##,##0")
            HLinkItem.Target = "new"
            HLinkItem.Attributes("onclick") = "return ViewAllDetail(this.href)"
            HLinkItem.NavigateUrl = "CriticalItemDet.aspx"
            HLinkItem.Text = e.Item.Cells(1).Text
            e.Item.Cells(1).Controls.Add(HLinkItem)

            Dim HLinkCritical As New HyperLink
            e.Item.Cells(3).Text = TotCriticalCount
            e.Item.Cells(3).Text = Format(CDbl(e.Item.Cells(3).Text), "##,##0")
            HLinkCritical.Target = "new"
            HLinkCritical.Attributes("onclick") = "return ViewAllCritical(this.href)"
            HLinkCritical.NavigateUrl = "CriticalItemDet.aspx"
            HLinkCritical.Text = e.Item.Cells(3).Text
            e.Item.Cells(3).Controls.Add(HLinkCritical)

            e.Item.Cells(5).Text = 0
            If TotItemCount > 0 Then
                e.Item.Cells(5).Text = TotCriticalCount / TotItemCount
            End If
            e.Item.Cells(5).Text = Format(CDbl(e.Item.Cells(5).Text), "##0.0%")

            e.Item.Cells(6).Text = TotLbs
            e.Item.Cells(6).Text = Format(CDbl(e.Item.Cells(6).Text), "##,##0")

            e.Item.Cells(7).Text = TotCriticalLbs
            e.Item.Cells(7).Text = Format(CDbl(e.Item.Cells(7).Text), "##,##0")

            e.Item.Cells(8).Text = 0
            e.Item.Cells(9).Text = 0
            If TotLbs > 0 Then
                e.Item.Cells(8).Text = TotCriticalLbs / TotLbs
                e.Item.Cells(9).Text = (100 - (TotCriticalLbs / TotLbs * 100)) / 100
            End If
            e.Item.Cells(8).Text = Format(CDbl(e.Item.Cells(8).Text), "##0.0%")
            e.Item.Cells(9).Text = Format(CDbl(e.Item.Cells(9).Text), "##0.0%")
        End If
    End Sub

    Protected Sub ExportRpt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ExportRpt.Click
        Dim adp As New Data.SqlClient.SqlDataAdapter(SelCmd, System.Web.Configuration.WebConfigurationManager.ConnectionStrings("csPFCReports").ConnectionString)
        Dim ds As New Data.DataSet

        ExportFile = "CriticalItemRpt\Excel\" + ExcelFile
        FileOpen(1, My.Request.PhysicalApplicationPath & ExportFile, OpenMode.Output)   ' Open file for output.

        PrintLine(1, "Velocity Code" & Chr(9) & _
            "Item Count" & Chr(9) & _
            "Critical Item Count" & Chr(9) & _
            "% Critical" & Chr(9) & _
            "30D Usage Lbs" & Chr(9) & _
            "Critical Pounds" & Chr(9) & _
            "% Critical (Pounds)" & Chr(9) & _
            "% Non Critical (Pounds)" & Chr(9) & _
            "Target %")

        adp.Fill(ds)

        If ds.Tables(0).Rows.Count() > 0 Then
            For RecCount = 0 To (ds.Tables(0).Rows.Count() - 1)
                PrintLine(1, ds.Tables(0).Rows(RecCount).Item("VelocityCode").ToString & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("TotCount"), "###,##0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("CriticalCount"), "###,##0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("CriticalCountPct"), "##0.0%") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("TotWght"), "#,###,##0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("TotWghtCritical"), "#,###,##0") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("CriticalWghtPct"), "##0.0%") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("NonCriticalWghtPct"), "##0.0%") & Chr(9) & _
                             Format(ds.Tables(0).Rows(RecCount).Item("TargetPct"), "##0.0%"))
            Next
        Else
            PrintLine(1, "Error in CriticalItemSummary Table - No Records Found")
        End If

        FileClose(1)           ' Close file.

        ExportFile = "Excel\" + ExcelFile
        Me.Server.Transfer("ExcelSummary.aspx?Filename=" & ExportFile, True)

    End Sub

    Protected Sub LocationList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles LocationList.SelectedIndexChanged
        LocNum.Value = LocationList.SelectedValue
        LocDesc.Value = LocationList.SelectedItem.Text
    End Sub
End Class
