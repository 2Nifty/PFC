
Partial Class CriticalItemRptBr
    Inherits System.Web.UI.Page
    Dim SelCmd As String
    Public ExcelFile, ExportFile As String
    Dim TotItemCount, TotCriticalCount, TotLbs, TotCriticalLbs, RecCount As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            'This loads the DropDown list to select the Velocity Code
            If (Request.QueryString("VelocityType") = "Corp") Then
                SelCmd = "SELECT AppOptionValue as Velocity, 'Corp Fixed Velocity Code = ' + AppOptionValue as ListIndex from AppPref WHERE AppOptionType='CITargetPer' ORDER BY AppOptionValue"
            Else
                SelCmd = "SELECT AppOptionValue as Velocity, 'Category Velocity Code = ' + AppOptionValue as ListIndex from AppPref WHERE AppOptionType='VelocityCode' ORDER BY AppOptionValue"
            End If
            BindVelocityList()
            ddVelocityList.SelectedValue = Request.QueryString("VelocityCode")
            VelocityCode.Value = Request.QueryString("VelocityCode")
        End If

        VelocityType.Value = Request.QueryString("VelocityType")
        If (Request.QueryString("VelocityType") = "Corp") Then
            SelCmd = "SELECT [LocationCode], [LocationName], [LocationCode] + '-' + [LocationName] as Location, [TotCount], [CriticalCount], [CriticalCountPct], [TotWght], [TotWghtCritical], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct] FROM [CriticalItemSummary] WHERE ([VelocityCode] = '" + ddVelocityList.SelectedValue.ToString + "')"
            ExcelFile = "CriticalItemsBrCorp.xls"
        Else
            SelCmd = "SELECT [LocationCode], [LocationName], [LocationCode] + '-' + [LocationName] as Location, [TotCount], [CriticalCount], [CriticalCountPct], [TotWght], [TotWghtCritical], [CriticalWghtPct], [NonCriticalWghtPct], [TargetPct] FROM [CriticalItemSummaryCat] WHERE ([VelocityCode] = '" + ddVelocityList.SelectedValue.ToString + "')"
            ExcelFile = "CriticalItemsBrCat.xls"
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

    Private Sub BindVelocityList()
        Dim adp As New Data.SqlClient.SqlDataAdapter(SelCmd, System.Web.Configuration.WebConfigurationManager.ConnectionStrings("csPFCReports").ConnectionString)
        Dim ds As New Data.DataSet

        adp.Fill(ds)
        ddVelocityList.DataSource = ds.Tables(0)
        ddVelocityList.DataTextField = "ListIndex"
        ddVelocityList.DataValueField = "Velocity"
        ddVelocityList.DataBind()
    End Sub

    Private Sub DataGrid1_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles GridView1.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            If e.Item.ItemIndex > 0 Then
                TotLbs = TotLbs + Convert.ToInt32(e.Item.Cells(6).Text)
                TotCriticalLbs = TotCriticalLbs + Convert.ToInt32(e.Item.Cells(7).Text)
            End If
            e.Item.Cells(6).Text = Format(CDbl(e.Item.Cells(6).Text), "##,##0")
            e.Item.Cells(7).Text = Format(CDbl(e.Item.Cells(7).Text), "##,##0")
        End If

        If e.Item.ItemType = ListItemType.Footer Then

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

        PrintLine(1, "Loc No" & Chr(9) & _
            "Location Name" & Chr(9) & _
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
                PrintLine(1, ds.Tables(0).Rows(RecCount).Item("LocationCode").ToString & Chr(9) & _
                             ds.Tables(0).Rows(RecCount).Item("LocationName").ToString & Chr(9) & _
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

    Protected Sub ddVelocityList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddVelocityList.SelectedIndexChanged
        VelocityCode.Value = ddVelocityList.SelectedValue
    End Sub
End Class
