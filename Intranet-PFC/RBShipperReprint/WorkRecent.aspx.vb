
Partial Class WorkRecent
    Inherits System.Web.UI.Page
    Dim cn, cn2 As New System.Data.SqlClient.SqlConnection
    Dim command, command2 As New System.Data.SqlClient.SqlCommand
    Dim PFCDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("TheRBPipeConnectionString")
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim rs, rs2 As System.Data.SqlClient.SqlDataReader
        cn.ConnectionString = PFCDB.ConnectionString
        cn.Open()
        command.Connection = cn
        If IsPostBack Then
            SelectString = "SELECT  TimeInTunnel AS Dur, ThePipeIn, ThePipeOut, ThePipeStepCtr, No_ AS Shipper, [Shipping Location] AS Branch, [Location Name 2] AS BrName FROM TimeInTunnel"
            SelectString = SelectString & " WHERE [Shipping Location] = '" & BranchFilter.SelectedValue & "'"
        Else
            SelectString = "SELECT  TimeInTunnel AS Dur, ThePipeIn, ThePipeOut, ThePipeStepCtr, No_ AS Shipper, [Shipping Location] AS Branch, [Location Name 2] AS BrName FROM TimeInTunnel"
        End If
        command.CommandText = SelectString
        rs = command.ExecuteReader
        If rs.HasRows Then
            Do While rs.Read
                Dim DetailRow As New TableRow()
                Dim DetailCell1, DetailCell2, DetailCell3, DetailCell4, DetailCell5, DetailCell6, DetailCell7, DetailCell8 As New TableCell()
                Dim IgnoreBox As New CheckBox
                Dim NewCostBox As New TextBox
                Dim radio1, radio2, radio3 As New RadioButton
                Dim CellLiteral1, CellLiteral2 As New Literal
                DetailCell1.Text = rs("Shipper")
                DetailCell1.Width = 110
                DetailCell1.HorizontalAlign = HorizontalAlign.Center
                DetailRow.Cells.Add(DetailCell1)
                DetailCell2.Text = rs("Branch")
                DetailCell2.Width = 50
                DetailCell2.HorizontalAlign = HorizontalAlign.Center
                DetailRow.Cells.Add(DetailCell2)
                DetailCell3.HorizontalAlign = HorizontalAlign.Center
                DetailCell3.Text = Format(rs("ThePipeStepCtr"), "###0")
                DetailCell3.Width = 70
                DetailRow.Cells.Add(DetailCell3)
                If Convert.IsDBNull(rs("ThePipeIn")) Then
                    DetailCell4.Text = "Empty"
                Else
                    DetailCell4.Text = Format(rs("ThePipeIn"), "MM/dd/yyyy HH:mm:ss")
                End If
                DetailCell4.HorizontalAlign = HorizontalAlign.Center
                DetailCell4.Width = 210
                DetailRow.Cells.Add(DetailCell4)
                DetailCell5.Text = Format(rs("ThePipeOut"), "MM/dd/yyyy HH:mm:ss")
                DetailCell5.HorizontalAlign = HorizontalAlign.Center
                DetailCell5.Width = 210
                DetailRow.Cells.Add(DetailCell5)
                If Convert.IsDBNull(rs("BrName")) Then
                    DetailCell6.Text = "Empty"
                Else
                    DetailCell6.Text = rs("BrName")
                End If
                DetailCell6.HorizontalAlign = HorizontalAlign.Center
                DetailCell6.Width = 150
                DetailRow.Cells.Add(DetailCell6)
                DetailCell7.HorizontalAlign = HorizontalAlign.Center
                DetailCell7.Width = 50
                DetailCell8.HorizontalAlign = HorizontalAlign.Center
                DetailCell8.Width = 50
                radio1.ID = "Reprint" & rs("Shipper")
                radio1.GroupName = "Do" & rs("Shipper")
                radio1.ToolTip = "Reprint " & rs("Shipper")
                DetailCell7.Controls.Add(radio1)
                DetailRow.Cells.Add(DetailCell7)
                radio2.ID = "Repick" & rs("Shipper")
                radio2.GroupName = "Do" & rs("Shipper")
                radio2.ToolTip = "Repick/Reprint " & rs("Shipper")
                DetailCell8.Controls.Add(radio2)
                DetailRow.Cells.Add(DetailCell8)
                WorkTable.Rows.Add(DetailRow)
            Loop
            StatusText.Text = ""
        Else
            Dim DetailRow As New TableRow()
            Dim DetailCell1 As New TableCell()
            DetailCell1.Text = "No records in TimeInTunnel"
            DetailCell1.ForeColor = Drawing.Color.Red
            DetailCell1.ColumnSpan = 7
            DetailCell1.HorizontalAlign = HorizontalAlign.Center
            DetailRow.Cells.Add(DetailCell1)
            WorkTable.Rows.Add(DetailRow)
            UpdCostButton.Visible = False
            StatusText.Text = "No Records"
        End If
        rs.Close()
        CalcCount = "(" & WorkTable.Rows.Count & ")"
        cn.Close()
    End Sub
End Class
