
Partial Class CanadaBLSummaryRpt
    Inherits System.Web.UI.Page
    Dim SqlDataSource4, SqlDataSource5 As New System.Data.SqlClient.SqlConnection("Data Source=EnterpriseSql;Initial Catalog=PFCLive;Persist Security Info=True;User ID=pfcnormal;Password=pfcnormal")
    Dim cmd, cmd2 As New System.Data.SqlClient.SqlCommand
    Dim rs, rs2 As System.Data.SqlClient.SqlDataReader
    Public ExportFile As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        cmd.CommandText = "spCanadaBL"
        cmd.Parameters.AddWithValue("@BLNo", Request.QueryString("BLNo"))
        cmd.CommandType = System.Data.CommandType.StoredProcedure
        cmd.Connection = SqlDataSource4

        SqlDataSource4.Open()
        cmd.ExecuteNonQuery()
        SqlDataSource4.Close()
    End Sub

    Protected Sub ExportSummary_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ExportSummary.Click

        ExportFile = "Excel\Summary" & Request.QueryString("BLNo") & ".xls"
        FileOpen(1, My.Request.PhysicalApplicationPath & ExportFile, OpenMode.Output)   ' Open file for output.

        PrintLine(1, "BL #" & Chr(9) & _
            "Category" & Chr(9) & _
            "Description" & Chr(9) & _
            "Tot Cat Qty" & Chr(9) & _
            "UOM" & Chr(9) & _
            "Cat Line Count" & Chr(9) & _
            "Tot Avg Cost Ext" & Chr(9) & _
            "Tot Canada Declaration Value" & Chr(9) & _
            "Tot Gross Wgt" & Chr(9) & _
            "Tot Net Wgt" & Chr(9) & _
            "Tot Net Wgt in KG")

        cmd2.CommandText = "SELECT [BL No], [Cat No], [Cat Desc], SUM(Quantity) AS CatQty, [Unit of Measure Code], CatLineCount, SUM([Avg Cost Ext]) AS [Avg Cost Ext], SUM([Avg Cost Ext (CAN)]) AS [Declared Cost Ext], SUM([Gross Wgt Ext]) AS [Gross Wgt], SUM([Net Wgt Ext]) AS [Net Wgt], SUM([Net Wgt Ext (KG)]) AS [Net Wgt (KG)] FROM tempLandedCostLines GROUP BY [Cat No], [Cat Desc], [Unit of Measure Code], CatLineCount, [BL No] ORDER BY [Cat No]"
        cmd2.Connection = SqlDataSource5
        SqlDataSource5.Open()

        rs = cmd2.ExecuteReader

        If rs.HasRows Then
            Do While rs.Read
                PrintLine(1, rs("BL No") & Chr(9) & _
                             rs("Cat No") & Chr(9) & _
                             rs("Cat Desc") & Chr(9) & _
                             rs("CatQty") & Chr(9) & _
                             rs("Unit of Measure Code") & Chr(9) & _
                             rs("CatLineCount") & Chr(9) & _
                             Format(rs("Avg Cost Ext"), "$###,##0.00") & Chr(9) & _
                             Format(rs("Declared Cost Ext"), "$###,##0.00") & Chr(9) & _
                             Format(rs("Gross Wgt"), "###,##0.000") & Chr(9) & _
                             Format(rs("Net Wgt"), "###,##0.000") & Chr(9) & _
                             Format(rs("Net Wgt (KG)"), "###,##0.000"))
            Loop
        Else
            PrintLine(1, "No Records Found " & rs("BL No"))
        End If

        rs.Close()
        SqlDataSource4.Close()
        SqlDataSource5.Close()
        FileClose(1)           ' Close file.

        ExportFile = "Excel\Summary" & Request.QueryString("BLNo") & ".xls"
        Me.Server.Transfer("ExcelSummary.aspx?Filename=" & ExportFile, True)

    End Sub
End Class
