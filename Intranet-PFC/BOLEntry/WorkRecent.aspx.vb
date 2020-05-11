
Partial Class WorkRecent
    Inherits System.Web.UI.Page
    Dim cn, cn2 As New System.Data.SqlClient.SqlConnection
    Dim command, command2 As New System.Data.SqlClient.SqlCommand
    Dim PFCDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("BOLEntryConnectionString")
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim rs
        cn.ConnectionString = PFCDB.ConnectionString
        cn.Open()
        command.Connection = cn
        SelectString = "SELECT   BillofLadingNo AS [BOL No], EntryDt AS [BOL Dt], ISNULL(ToAllocWght,0) AS [Alloc By Weight], ISNULL(TotBOLWght,0) AS [Total BOL Wght], ISNULL(ToAllocAmt,0) AS [Alloc By Amt], ISNULL(TotBOLAmt,0) AS [Total BOL Amt] FROM AvgCstPORecExpenses ORDER BY EntryDt DESC,BillofLadingNo"

        'SelectString = SelectString & "WHERE GroupNo = " & GroupToUse.Value
        command.CommandText = SelectString
        rs = command.ExecuteReader
        If rs.HasRows Then
            Do While rs.Read
                Dim DetailRow As New TableRow()
                Dim DetailCell1, DetailCell2, DetailCell3, DetailCell4, DetailCell5, DetailCell6 As New TableCell()
                Dim CellLiteral1, CellLiteral2 As New Literal
                DetailCell1.Text = rs("Bol No")
                DetailCell1.Width = 110
                DetailCell1.HorizontalAlign = HorizontalAlign.Center
                DetailRow.Cells.Add(DetailCell1)
                DetailCell2.Text = Format(rs("Bol Dt"), "MM/dd/yyyy")
                DetailCell2.Width = 80
                DetailCell2.HorizontalAlign = HorizontalAlign.Center
                DetailRow.Cells.Add(DetailCell2)
                DetailCell3.HorizontalAlign = HorizontalAlign.Center
                DetailCell3.Text = Format(rs("Alloc By Weight"), "$###0.00")
                DetailCell3.Width = 120
                DetailRow.Cells.Add(DetailCell3)
                DetailCell4.HorizontalAlign = HorizontalAlign.Center
                DetailCell4.Text = Format(rs("Alloc By Amt"), "$###0.00")
                DetailCell4.Width = 120
                DetailRow.Cells.Add(DetailCell4)
                'DetailCell5.Text = Format(rs("Total BOL Wght"), "######0.00")
                DetailCell5.Text = rs("Total BOL Wght")
                DetailCell5.HorizontalAlign = HorizontalAlign.Center
                DetailCell5.Width = 120
                DetailRow.Cells.Add(DetailCell5)
                'DetailCell6.Text = Format(rs("Total BOL Amt"), "$######0.000")
                DetailCell6.Text = rs("Total BOL Amt")
                DetailCell6.HorizontalAlign = HorizontalAlign.Center
                DetailCell6.Width = 120
                DetailRow.Cells.Add(DetailCell6)
                WorkTable.Rows.Add(DetailRow)
            Loop
        Else
            Dim DetailRow As New TableRow()
            Dim DetailCell1 As New TableCell()
            DetailCell1.Text = "No records BOL Table"
            DetailCell1.ForeColor = Drawing.Color.Red
            DetailCell1.ColumnSpan = 7
            DetailCell1.HorizontalAlign = HorizontalAlign.Center
            DetailRow.Cells.Add(DetailCell1)
            WorkTable.Rows.Add(DetailRow)
        End If
        rs.Close()
        CalcCount = "(" & WorkTable.Rows.Count & ")"
        cn.Close()

    End Sub
End Class
