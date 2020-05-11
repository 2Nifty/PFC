
Partial Class Update
    Inherits System.Web.UI.Page
    Dim RBDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("TheRBPipeConnectionString")
    Dim cn, cn2 As New System.Data.SqlClient.SqlConnection
    Dim rs, rs2 As System.Data.SqlClient.SqlDataReader
    Dim command, command2 As New System.Data.SqlClient.SqlCommand
    Dim loop1, loop2 As Integer
    Dim InsertString As String
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            cn.ConnectionString = RBDB.ConnectionString
            cn.Open()
            command.Connection = cn
            loop2 = 0
            Session("BackTo") = Request.Form.Item("BackTo").ToString
            For Each ItemUpd As String In Request.Form
                If ItemUpd.StartsWith("Do") Then
                    Dim DetailRow As New TableRow()
                    Dim DetailCell1, DetailCell2, DetailCell3, DetailCell4, DetailCell5, DetailCell6, DetailCell7 As New TableCell()
                    DetailCell1.Text = Mid(ItemUpd, 3, 14)
                    DetailRow.Cells.Add(DetailCell1)
                    If Request.Form(ItemUpd).StartsWith("Reprint") Then
                        UpdateString = "update ThePipeSalesHeader "
                        UpdateString = UpdateString & "set ThePipeStepCtr = 200000 "
                        UpdateString = UpdateString & " where [No_] = '" & Mid(ItemUpd, 3, 14) & "'"
                        command.CommandText = UpdateString
                        loop1 = command.ExecuteNonQuery
                        loop2 = loop2 + 1
                        DetailCell2.Text = "Reprinted"
                        DetailCell2.HorizontalAlign = HorizontalAlign.Left
                        DetailRow.Cells.Add(DetailCell2)
                    End If
                    If Request.Form(ItemUpd).StartsWith("Repick") Then
                        UpdateString = "delete from ThePipeSalesHeader "
                        UpdateString = UpdateString & " where [No_] = '" & Mid(ItemUpd, 3, 14) & "'"
                        command.CommandText = UpdateString
                        loop1 = command.ExecuteNonQuery
                        loop2 = loop2 + 1
                        DetailCell2.Text = "Repicked and reprinted"
                        DetailCell2.HorizontalAlign = HorizontalAlign.Left
                        DetailRow.Cells.Add(DetailCell2)
                    End If
                    WorkTable.Rows.Add(DetailRow)
                End If
            Next
            cn.Close()
        End If
    End Sub

    Protected Sub CloseButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles CloseButt.Click
        Server.Transfer(Session("BackTo"), False)
    End Sub
End Class
