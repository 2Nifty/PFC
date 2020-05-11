
Partial Class CanadaBLDetailRpt
    Inherits System.Web.UI.Page
    Dim SqlDataSource4, SqlDataSource5 As New System.Data.SqlClient.SqlConnection("Data Source=Enterprisesql;Initial Catalog=PFCLive;Persist Security Info=True;User ID=pfcnormal;Password=pfcnormal")
    Dim cmd, cmd2 As New System.Data.SqlClient.SqlCommand
    Dim rs, rs2 As System.Data.SqlClient.SqlDataReader
    Public ExportFile As String

    Protected Sub ExportDetail_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ExportDetail.Click

        ExportFile = "Excel\Detail" & Request.QueryString("BLNo") & ".xls"
        FileOpen(1, My.Request.PhysicalApplicationPath & ExportFile, OpenMode.Output)   ' Open file for output.

        PrintLine(1, "TO #" & Chr(9) & _
                      "Line #" & Chr(9) & _
                      "Cat Line Count" & Chr(9) & _
                      "Cat No" & Chr(9) & _
                      "UOM" & Chr(9) & _
                      "Quantity" & Chr(9) & _
                      "Cat Desc" & Chr(9) & _
                      "B/L No" & Chr(9) & _
                      "Item No" & Chr(9) & _
                      "Trf From Code" & Chr(9) & _
                      "Gross Wgt Ext" & Chr(9) & _
                      "Net Wgt Ext" & Chr(9) & _
                      "Net Wgt Ext (KG)" & Chr(9) & _
                      "Avg (Unit) Cost" & Chr(9) & _
                      "Avg Cost Ext" & Chr(9) & _
                      "Landed Cost" & Chr(9) & _
                      "Direct Unit Cost" & Chr(9) & _
                      "Landed %" & Chr(9) & _
                      "Duty %" & Chr(9) & _
                      "Avg Cost - Landed %" & Chr(9) & _
                      "Canada Declaration Value" & Chr(9) & _
                      "Canada Declaration Value Ext" & Chr(9) & _
                      "Harmonizing Code")

        cmd2.CommandText = "SELECT * FROM tempLandedCostLines ORDER BY [Cat No]"
        cmd2.Connection = SqlDataSource5
        SqlDataSource5.Open()

        rs = cmd2.ExecuteReader

        If rs.HasRows Then
            Do While rs.Read
                PrintLine(1, rs("TO #") & Chr(9) & _
                             rs("Line No_") & Chr(9) & _
                             rs("CatLineCount") & Chr(9) & _
                             rs("Cat No") & Chr(9) & _
                             rs("Unit of Measure Code") & Chr(9) & _
                             rs("Quantity") & Chr(9) & _
                             rs("Cat Desc") & Chr(9) & _
                             rs("BL No") & Chr(9) & _
                             rs("Item No_") & Chr(9) & _
                             rs("Transfer-from Code") & Chr(9) & _
                             Format(rs("Gross Wgt Ext"), "###,##0.000") & Chr(9) & _
                             Format(rs("Net Wgt Ext"), "###,##0.000") & Chr(9) & _
                             Format(rs("Net Wgt Ext (KG)"), "###,##0.000") & Chr(9) & _
                             Format(rs("Unit Cost"), "$###,##0.00") & Chr(9) & _
                             Format(rs("Avg Cost Ext"), "$###,##0.00") & Chr(9) & _
                             Format(rs("AntLandCost"), "$###,##0.00") & Chr(9) & _
                             Format(rs("Direct Unit Cost"), "$###,##0.00") & Chr(9) & _
                             Format(rs("Landed Adder %"), "##0.000") & Chr(9) & _
                             Format(rs("Duty %"), "##0.000") & Chr(9) & _
                             Format(rs("AvgCostAdders"), "##0.000") & Chr(9) & _
                             Format(rs("AvgCost Duty Only"), "$###,##0.00") & Chr(9) & _
                             Format(rs("Avg Cost Ext (CAN)"), "$###,##0.00") & Chr(9) & _
                             rs("Harmonizing Tariff Code"))
            Loop
        Else
            PrintLine(1, "No Records Found " & rs("BL No"))
        End If

        rs.Close()
        SqlDataSource5.Close()
        FileClose(1)           ' Close file.

        ExportFile = "Excel\Detail" & Request.QueryString("BLNo") & ".xls"
        Me.Server.Transfer("ExcelDetail.aspx?Filename=" & ExportFile, True)

    End Sub
End Class
