
Partial Class Update
    Inherits System.Web.UI.Page
    Dim NVDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("NVConnectionString")
    Dim cn, cn2 As New System.Data.SqlClient.SqlConnection
    Dim rs, rs2 As System.Data.SqlClient.SqlDataReader
    Dim command, command2 As New System.Data.SqlClient.SqlCommand
    Dim loop1, loop2 As Integer
    Dim InsertString As String
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.Form("CostsReady") = "Yes" Then
            cn.ConnectionString = NVDB.ConnectionString
            cn.Open()
            Command.Connection = cn
            loop2 = 0
            For Each ItemUpd As String In Request.Form
                If ItemUpd.StartsWith("NewCost") Then
                    Dim DetailRow As New TableRow()
                    Dim DetailCell1, DetailCell2, DetailCell3, DetailCell4, DetailCell5, DetailCell6, DetailCell7 As New TableCell()
                    DetailCell1.Text = Mid(ItemUpd, 8, 14)
                    DetailRow.Cells.Add(DetailCell1)
                    If Request.Form("Ignore" & Mid(ItemUpd, 8, 14)) <> "on" Then
                        UpdateString = "update [Porteous$Item] "
                        UpdateString = UpdateString & "set [Standard Cost] = " & Request.Form(ItemUpd)
                        UpdateString = UpdateString & "/(select PuchUOM.[Qty_ per Unit of Measure] "
                        UpdateString = UpdateString & "from [Porteous$Item Unit of Measure] BaseUOM "
                        UpdateString = UpdateString & " inner join "
                        UpdateString = UpdateString & "[Porteous$Item Unit of Measure] PuchUOM "
                        UpdateString = UpdateString & "on [Porteous$Item].[No_]=PuchUOM.[Item No_] and "
                        UpdateString = UpdateString & "BaseUOM.[Purchase Price Per Alt_]=PuchUOM.[Code] "
                        UpdateString = UpdateString & "where [Porteous$Item].[No_]=BaseUOM.[Item No_] and BaseUOM.[Purchase Qty Alt_]=1)  "
                        UpdateString = UpdateString & " where [No_] = '" & Mid(ItemUpd, 8, 14) & "'"
                        command.CommandText = UpdateString
                        loop1 = command.ExecuteNonQuery
                        loop2 = loop2 + 1
                        'StatusText.Text = "Ignore" & Request.Form("Ignore" & Mid(ItemUpd, 8, 14))
                        DetailCell2.Text = "Set to " & Request.Form(ItemUpd)
                        DetailCell2.HorizontalAlign = HorizontalAlign.Left
                        DetailRow.Cells.Add(DetailCell2)
                    Else
                        DetailCell2.Text = "Ignored"
                        DetailCell2.ForeColor = Drawing.Color.Red
                        DetailRow.Cells.Add(DetailCell2)
                    End If
                    WorkTable.Rows.Add(DetailRow)
                    'Exit For
                End If
            Next
            cn.Close()
        End If

    End Sub
End Class
