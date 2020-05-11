Imports System.Configuration
Partial Class _Default
    Inherits System.Web.UI.Page
    Dim PFCDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCReportsConnectionString")
    Dim NVDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("NVConnectionString")
    Dim cn, cn2 As New System.Data.SqlClient.SqlConnection
    Dim command, command2 As New System.Data.SqlClient.SqlCommand
    Dim loop1, loop2 As Integer
    Dim InsertString As String
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile As String
    Dim ConnectArray(), ValueArray() As String
    Dim ExportPrefix As String = ConfigurationManager.AppSettings.Item("ExportFileName")

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SaveButton.Visible = False
        UpdateButton.Visible = False
        OptionPanel.Visible = False
        CostPanel.Visible = False
        UpdCostLabel.Visible = False
        UpdCostButton.Visible = False
        LogonID = HttpContext.Current.User.Identity.Name
        LogonID = Mid(LogonID, InStr(LogonID, "\") + 1)
        ConnectArray = Split(NVDB.ConnectionString, ";")
        ValueArray = Split(ConnectArray(0), "=")
        DBServer.Value = ValueArray(1)
        ValueArray = Split(ConnectArray(1), "=")
        DBName.Value = ValueArray(1)
        UpdCostLabel.Text = "Update Costs in " & DBName.Value & " on " & DBServer.Value
        CalcCount = ""
        ExportFile = ExportPrefix & Format(Now, "yyyyMMddHHmm") & ".xls"
        'StatusText.Text = LogonID
        StatusText.Text = ""
        VelocityCodeFilter2.Text = VelocityCodeFilter2.Text.ToUpper
        VelocityCodeFilter.Text = VelocityCodeFilter.Text.ToUpper
        If CostsReady.Value = "Yes" Then
            UpdCostLabel.Visible = True
            UpdCostButton.Visible = True
        End If
        If OptionStat.Value = "New" Then
            SaveButton.Visible = True
            OptionPanel.Visible = True
        End If
        If OptionStat.Value = "Found" Then
            UpdateButton.Visible = True
            OptionPanel.Visible = True
        End If
        'If IsPostBack Then
        '    GetSCCRecord()
        'End If
    End Sub

    Protected Sub SaveButton_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles SaveButton.Click
        InsertString = "insert into SCCOptions "
        InsertString = InsertString & " (GroupNo, DiscountReciprocal, VelocityAdder, PremiumCategoryAdder, PackagingAdder, Created, UserID )"
        InsertString = InsertString & " values (" & SelectedGroup.SelectedValue & ", "
        InsertString = InsertString & DiscountReciprocal.Text & ", "
        InsertString = InsertString & VelocityAdder.Text & ", "
        InsertString = InsertString & PremiumCategoryAdder.Text & ", "
        InsertString = InsertString & PackagingAdder.Text & ", '"
        InsertString = InsertString & Now() & "', "
        InsertString = InsertString & "'" & LogonID & "')"
        cn.ConnectionString = PFCDB.ConnectionString
        cn.Open()
        command.Connection = cn
        command.CommandText = InsertString
        loop1 = command.ExecuteNonQuery
        StatusText.Text = "Option Record Added"
        cn.Close()
    End Sub

    Protected Sub UpdateButton_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles UpdateButton.Click
        UpdateString = "update SCCOptions set "
        UpdateString = UpdateString & "DiscountReciprocal = " & DiscountReciprocal.Text & ", "
        UpdateString = UpdateString & "VelocityAdder = " & VelocityAdder.Text & ", "
        UpdateString = UpdateString & "PremiumCategoryAdder = " & PremiumCategoryAdder.Text & ", "
        UpdateString = UpdateString & "PackagingAdder = " & PackagingAdder.Text & ", "
        UpdateString = UpdateString & "Updated = '" & Now() & "', "
        UpdateString = UpdateString & "UserID = '" & LogonID & "' "
        UpdateString = UpdateString & " where GroupNo = " & SelectedGroup.SelectedValue & " "
        cn.ConnectionString = PFCDB.ConnectionString
        cn.Open()
        command.Connection = cn
        command.CommandText = UpdateString
        loop1 = command.ExecuteNonQuery
        StatusText.Text = "Option Record Updated"
        cn.Close()
    End Sub

    Protected Sub ExportButton_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ExportCosts.Click
        Dim rs, rs2 As System.Data.SqlClient.SqlDataReader
        If ExportFile <> "" Then
            FileOpen(1, My.Request.PhysicalApplicationPath & ExportFile, OpenMode.Output)   ' Open file for output.
            PrintLine(1, "PFC Item Number" & Chr(9) & _
                "Direct Cost" & Chr(9) & _
                "Base Cost" & Chr(9) & _
                "Starting Date" & Chr(9) & _
                "Cost Origin" & Chr(9) & _
                "Std. Cost")
            cn.ConnectionString = NVDB.ConnectionString
            cn.Open()
            command.Connection = cn
            cn2.ConnectionString = PFCDB.ConnectionString
            cn2.Open()
            command2.Connection = cn2
            SelectString = "SELECT Category FROM CAS_CatGrpDesc "
            SelectString = SelectString & "WHERE GroupNo = " & GroupToUse.Value
            command2.CommandText = SelectString
            rs2 = command2.ExecuteReader
            VelocityCodeFilter2.Text = VelocityCodeFilter2.Text.ToUpper
            VelocityCodeFilter.Text = VelocityCodeFilter.Text.ToUpper
            Do While rs2.Read
                BuildSelectString(rs2("Category"))
                command.CommandText = SelectString
                '    <%= SelectString %>
                rs = command.ExecuteReader
                If rs.HasRows Then
                    Do While rs.Read
                        Dim CostAmt, StandardCost, LandingAdder As Decimal
                        Dim CostDate As Date
                        Dim CostOrigin As String
                        If Convert.IsDBNull(rs("PurchaseUnitCost")) And Convert.IsDBNull(rs("BomUnitCost")) Then
                            PrintLine(1, rs("Item") & Chr(9) & "Missing Vendor Price")
                        Else
                            If InStr("0125", Mid(rs("Item"), 12, 1)) > 0 Then
                                If Convert.IsDBNull(rs("PurchaseUnitCost")) Then
                                    PrintLine(1, rs("Item") & Chr(9) & "Missing Vendor Price")   ' Separate strings with a tab.
                                Else
                                    ValueArray = Split(rs("PurchaseUnitCost"), ";")
                                    CostDate = ValueArray(0)
                                    CostAmt = ValueArray(1)
                                    LandingAdder = ValueArray(2)
                                    StandardCost = ((CostAmt + (LandingAdder * CostAmt)) * ((100 - DiscountReciprocal.Text) * 0.01)) * _
                                        ((100 + VelocityAdder.Text) * 0.01) * ((100 + PremiumCategoryAdder.Text) * 0.01)
                                    CostOrigin = "Purch"
                                End If
                            Else
                                If Convert.IsDBNull(rs("BomUnitCost")) Then
                                    ValueArray = Split(rs("PurchaseUnitCost"), ";")
                                    CostDate = ValueArray(0)
                                    CostAmt = ValueArray(1)
                                    LandingAdder = ValueArray(2)
                                    CostOrigin = "Purch"
                                    StandardCost = ((CostAmt + (LandingAdder * CostAmt)) * ((100 - DiscountReciprocal.Text) * 0.01)) * _
                                        ((100 + VelocityAdder.Text) * 0.01) * ((100 + PremiumCategoryAdder.Text) * 0.01)
                                Else
                                    ValueArray = Split(rs("BomUnitCost"), ";")
                                    CostDate = ValueArray(0)
                                    CostAmt = ValueArray(1)
                                    LandingAdder = ValueArray(2)
                                    CostOrigin = "BOM"
                                    StandardCost = ((CostAmt + (LandingAdder * CostAmt)) * ((100 - DiscountReciprocal.Text) * 0.01)) * _
                                        ((100 + VelocityAdder.Text) * 0.01) * ((100 + PremiumCategoryAdder.Text) * 0.01) * ((100 + PackagingAdder.Text) * 0.01)
                                End If
                            End If
                            PrintLine(1, rs("Item") & Chr(9) & Format(CostAmt, "#,##0.000") & Chr(9) & _
                                Format((CostAmt + (LandingAdder * CostAmt)) * ((100 - DiscountReciprocal.Text) * 0.01), "#,##0.000") & Chr(9) & _
                                Format(CostDate, "MM/dd/yyyy") & Chr(9) & _
                                CostOrigin & Chr(9) & _
                                Format(StandardCost, "##,##0.000"))
                        End If
                    Loop
                Else
                    PrintLine(1, "!!! No Costs for Category " & rs2("Category") & " !!!")
                End If
                rs.Close()
            Loop
            StatusText.Text = "Data Exported to " & ExportFile
            cn.Close()
            rs2.Close()
            cn2.Close()
            FileClose(1)   ' Close file.
        Else
            StatusText.Text = "File Name Not configured. Call IT"
        End If
        CostsReady.Value = "No"
        UpdCostLabel.Visible = False
        UpdCostButton.Visible = False
        Me.Server.Transfer("ExcelPage.aspx?Filename=" & ExportFile, True)
    End Sub

    Protected Sub GetOption_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles GetOption.Click
        SelectString = "SELECT [GroupNo], [DiscountReciprocal], [VelocityAdder], [PremiumCategoryAdder], [PackagingAdder], [Created], [Updated], [UserID]" & _
           "  FROM SCCOptions where [GroupNo] = " & SelectedGroup.SelectedValue
        GetSCCRecord(SelectString)
        VelocityCodeFilter2.Text = VelocityCodeFilter.Text
        VelocityCodeFilter.Text = ""
        PackageFilter2.Text = PackageFilter.Text
        PackageFilter.Text = ""
        PlatingFilter2.Text = PlatingFilter.Text
        PlatingFilter.Text = ""
        GroupToUse.Value = SelectedGroup.SelectedValue
        SelectedGroup2.SelectedValue = SelectedGroup.SelectedValue
    End Sub

    Protected Sub GetOptionDropDown2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SelectedGroup2.SelectedIndexChanged
        SelectString = "SELECT [GroupNo], [DiscountReciprocal], [VelocityAdder], [PremiumCategoryAdder], [PackagingAdder], [Created], [Updated], [UserID]" & _
            "  FROM SCCOptions where [GroupNo] = " & SelectedGroup2.SelectedValue
        GroupToUse.Value = SelectedGroup2.SelectedValue
        GetSCCRecord(SelectString)
    End Sub

    Protected Sub GetSCCRecord(ByVal CommandString As String)
        Dim rs As System.Data.SqlClient.SqlDataReader
        cn.ConnectionString = PFCDB.ConnectionString
        cn.Open()
        command.Connection = cn
        command.CommandText = CommandString
        VelocityCodeFilter2.Text = VelocityCodeFilter2.Text.ToUpper
        VelocityCodeFilter.Text = VelocityCodeFilter.Text.ToUpper
        BegCat = Mid(SelectedGroup.Items(SelectedGroup.SelectedIndex).Text, InStr(SelectedGroup.Items(SelectedGroup.SelectedIndex).Text, ":") + 2, 5)
        EndCat = Mid(SelectedGroup.Items(SelectedGroup.SelectedIndex).Text, InStr(SelectedGroup.Items(SelectedGroup.SelectedIndex).Text, ":") + 8, 5)
        'BegRange.Text = BegCat
        'EndRange.Text = EndCat
        ExportFile = ExportPrefix & Format(Now, "yyyyMMddHHmm") & ".txt"
        rs = command.ExecuteReader
        If rs.HasRows Then
            rs.Read()
            StatusText.Text = "Option Record Found"
            DiscountReciprocal.Text = rs("DiscountReciprocal")
            VelocityAdder.Text = rs("VelocityAdder")
            PremiumCategoryAdder.Text = rs("PremiumCategoryAdder")
            PackagingAdder.Text = rs("PackagingAdder")
            UpdateButton.Visible = True
            SaveButton.Visible = False
            OptionStat.Value = "Found"
        Else
            StatusText.Text = "New Option Record"
            'DiscountReciprocal.Text = "0"
            'VelocityAdder.Text = "0"
            'PremiumCategoryAdder.Text = "0"
            'PackagingAdder.Text = "0"
            'LocationFreightAdder.Text = "0"
            SaveButton.Visible = True
            UpdateButton.Visible = False
            OptionStat.Value = "New"
        End If
        OptionPanel.Visible = True
        CostsReady.Value = "No"
        UpdCostLabel.Visible = False
        UpdCostButton.Visible = False
        FilterTable.Visible = False
        HeadingOptions.Visible = True
        'tblTD.Attributes.Add("class", "PageHead")	 
        rs.Close()
        cn.Close()
        ExportFile = ExportPrefix & Format(Now, "yyyyMMddHHmm") & ".xls"
    End Sub


    Protected Sub CalcCosts_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles CalcCosts.Click
        Dim rs, rs2 As System.Data.SqlClient.SqlDataReader
        cn.ConnectionString = NVDB.ConnectionString
        cn.Open()
        command.Connection = cn
        cn2.ConnectionString = PFCDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        SelectString = "SELECT Category FROM CAS_CatGrpDesc with (nolock) "
        SelectString = SelectString & "WHERE GroupNo = " & GroupToUse.Value
        command2.CommandText = SelectString
        rs2 = command2.ExecuteReader
        Do While rs2.Read
            VelocityCodeFilter2.Text = VelocityCodeFilter2.Text.ToUpper
            VelocityCodeFilter.Text = VelocityCodeFilter.Text.ToUpper
            BuildSelectString(rs2("Category"))
            command.CommandText = SelectString
            '    <%= SelectString %>
            rs = command.ExecuteReader
            If rs.HasRows Then
                Do While rs.Read
                    Dim DetailRow As New TableRow()
                    Dim DetailCell1, DetailCell2, DetailCell3, DetailCell4, DetailCell5, DetailCell6, DetailCell7 As New TableCell()
                    Dim IgnoreBox As New CheckBox
                    Dim NewCostBox As New TextBox
                    Dim CellLiteral1, CellLiteral2 As New Literal
                    Dim CostAmt, StandardCost, LandingAdder As Decimal
                    Dim CostDate As Date
                    Dim CostOrigin As String
                    DetailCell1.Text = rs("Item")
                    DetailCell1.Width = 110
                    DetailRow.Cells.Add(DetailCell1)
                    If Convert.IsDBNull(rs("PurchaseUnitCost")) And Convert.IsDBNull(rs("BomUnitCost")) Then
                        DetailCell2.Text = "Missing Vendor Price"
                        DetailCell2.ForeColor = Drawing.Color.Red
                        DetailCell2.ColumnSpan = 6
                        DetailCell2.HorizontalAlign = HorizontalAlign.Center
                        DetailRow.Cells.Add(DetailCell2)
                    Else
                        If InStr("0125", Mid(rs("Item"), 12, 1)) > 0 Then
                            If Convert.IsDBNull(rs("PurchaseUnitCost")) Then
                                DetailCell2.Text = "Missing Vendor Price"
                                DetailCell2.ForeColor = Drawing.Color.Red
                                DetailCell2.ColumnSpan = 6
                                DetailCell2.HorizontalAlign = HorizontalAlign.Center
                                DetailRow.Cells.Add(DetailCell2)
                            Else
                                ValueArray = Split(rs("PurchaseUnitCost"), ";")
                                CostDate = ValueArray(0)
                                CostAmt = ValueArray(1)
                                LandingAdder = ValueArray(2)
                                StandardCost = ((CostAmt + (LandingAdder * CostAmt)) * ((100 - DiscountReciprocal.Text) * 0.01)) * _
                                    ((100 + VelocityAdder.Text) * 0.01) * ((100 + PremiumCategoryAdder.Text) * 0.01)
                                CostOrigin = "Purch"
                                DetailCell2.Text = Format(CostAmt, "#,##0.000")
                                DetailCell2.HorizontalAlign = HorizontalAlign.Right
                                DetailCell2.Width = 70
                                DetailRow.Cells.Add(DetailCell2)
                            End If
                        Else
                            If Convert.IsDBNull(rs("BomUnitCost")) Then
                                ValueArray = Split(rs("PurchaseUnitCost"), ";")
                                CostDate = ValueArray(0)
                                CostAmt = ValueArray(1)
                                LandingAdder = ValueArray(2)
                                CostOrigin = "Purch"
                                DetailCell5.ForeColor = Drawing.Color.Blue
                                StandardCost = ((CostAmt + (LandingAdder * CostAmt)) * ((100 - DiscountReciprocal.Text) * 0.01)) * _
                                    ((100 + VelocityAdder.Text) * 0.01) * ((100 + PremiumCategoryAdder.Text) * 0.01)
                                DetailCell2.Text = Format(CostAmt, "#,##0.000")
                                DetailCell2.HorizontalAlign = HorizontalAlign.Right
                                DetailCell2.Width = 70
                                DetailRow.Cells.Add(DetailCell2)
                            Else
                                ValueArray = Split(rs("BomUnitCost"), ";")
                                CostDate = ValueArray(0)
                                CostAmt = ValueArray(1)
                                LandingAdder = ValueArray(2)
                                CostOrigin = "BOM"
                                StandardCost = ((CostAmt + (LandingAdder * CostAmt)) * ((100 - DiscountReciprocal.Text) * 0.01)) * _
                                    ((100 + VelocityAdder.Text) * 0.01) * ((100 + PremiumCategoryAdder.Text) * 0.01) * ((100 + PackagingAdder.Text) * 0.01)
                                DetailCell2.Text = Format(CostAmt, "#,##0.000")
                                DetailCell2.HorizontalAlign = HorizontalAlign.Right
                                DetailCell2.Width = 70
                                DetailRow.Cells.Add(DetailCell2)
                            End If
                        End If
                        DetailCell3.Text = Format((CostAmt + (LandingAdder * CostAmt)) * ((100 - DiscountReciprocal.Text) * 0.01), "#,##0.000")
                        DetailCell3.HorizontalAlign = HorizontalAlign.Right
                        DetailCell3.Width = 70
                        DetailRow.Cells.Add(DetailCell3)
                        DetailCell4.Text = Format(CostDate, "MM/dd/yyyy")
                        DetailCell4.HorizontalAlign = HorizontalAlign.Right
                        DetailCell4.Width = 80
                        DetailRow.Cells.Add(DetailCell4)
                        DetailCell5.Text = CostOrigin
                        DetailCell5.HorizontalAlign = HorizontalAlign.Center
                        DetailCell5.Width = 50
                        DetailRow.Cells.Add(DetailCell5)
                        DetailCell6.HorizontalAlign = HorizontalAlign.Right
                        DetailCell6.Width = 80
                        DetailCell7.HorizontalAlign = HorizontalAlign.Center
                        DetailCell7.Width = 50
                        If StandardCost <> 0 Then
                            NewCostBox.Text = Format(StandardCost, "##,##0.000")
                            NewCostBox.ID = "NewCost" & rs("Item")
                            NewCostBox.Width = 60
                            DetailCell6.Controls.Add(NewCostBox)
                            DetailRow.Cells.Add(DetailCell6)
                            IgnoreBox.ID = "Ignore" & rs("Item")
                            DetailCell7.Controls.Add(IgnoreBox)
                            DetailRow.Cells.Add(DetailCell7)
                        Else
                            DetailCell6.Text = Format(StandardCost, "##,##0.000")
                            DetailRow.Cells.Add(DetailCell6)
                            DetailCell7.Text = "UOM"
                            DetailRow.Cells.Add(DetailCell7)
                        End If
                    End If
DetailRow.CssClass="GridItem"
                    WorkTable.Rows.Add(DetailRow)
                Loop
            Else
                Dim DetailRow As New TableRow()
                Dim DetailCell1 As New TableCell()
                DetailCell1.Text = "!!! No Costs for Category " & rs2("Category") & " !!!"
                DetailCell1.ForeColor = Drawing.Color.Red
                DetailCell1.ColumnSpan = 7
                DetailCell1.HorizontalAlign = HorizontalAlign.Center
                DetailRow.Cells.Add(DetailCell1)
                WorkTable.Rows.Add(DetailRow)
            End If
            rs.Close()
        Loop
        CalcCount = "(" & WorkTable.Rows.Count & ")"
        If WorkTable.Rows.Count > 0 Then
            CostPanel.Visible = True
            CostsReady.Value = "Yes"
            UpdCostLabel.Visible = True
            UpdCostButton.Visible = True
        Else
            StatusText.Text = "No Cost Records on File"
        End If
        cn.Close()
        rs2.Close()
        cn2.Close()
    End Sub

    Protected Sub BuildSelectString(ByVal CurCat As String)
        SelectString = "SELECT IT.[No_] as Item, "
        SelectString = SelectString & "(select max(convert(varchar,[Starting Date],102)+';'+"
        SelectString = SelectString & "convert(varchar,[Alt_ Price])+';'+"
        SelectString = SelectString & "convert(varchar,(([Anticipated Landed Cost]-[Direct Unit Cost])/[Direct Unit Cost]))) "
        SelectString = SelectString & "FROM [Porteous$Item Vendor] IV inner JOIN [Porteous$Purchase Price] PP   "
        SelectString = SelectString & "on IV.[Vendor No_] = PP.[Vendor No_] AND "
        SelectString = SelectString & "IV.[Item No_] = PP.[Item No_] "
        SelectString = SelectString & "where IT.[No_] = IV.[Item No_] and "
        SelectString = SelectString & "(IV.[Priority Ranking] = 1) and "
        SelectString = SelectString & "PP.[Direct Unit Cost]>0 and "
        SelectString = SelectString & "(PP.[Ending Date] = CONVERT(DATETIME, '1753-01-01 00:00:00', 102))"
        SelectString = SelectString & "group by IV.[Item No_]) as PurchaseUnitCost,"
        SelectString = SelectString & "(select max(convert(varchar,PP.[Starting Date],102)+';'+"
        SelectString = SelectString & "convert(varchar,[Alt_ Price])+';'+"
        SelectString = SelectString & "convert(varchar,([Anticipated Landed Cost]-[Direct Unit Cost])/[Direct Unit Cost])) "
        SelectString = SelectString & "FROM [Porteous$Item Vendor] IV , "
        SelectString = SelectString & "[Porteous$Production BOM Line] BOM , "
        SelectString = SelectString & "[Porteous$Purchase Price] PP  "
        SelectString = SelectString & "where BOM.[No_] = IV.[Item No_] and "
        SelectString = SelectString & "IV.[Vendor No_] = PP.[Vendor No_] AND "
        SelectString = SelectString & "IT.[No_] = BOM.[Production BOM No_] and "
        SelectString = SelectString & "BOM.[No_] = PP.[Item No_] and "
        SelectString = SelectString & "(IV.[Priority Ranking] = 1) and "
        SelectString = SelectString & "[Direct Unit Cost]>0 and "
        SelectString = SelectString & "(PP.[Ending Date] = CONVERT(DATETIME, '1753-01-01 00:00:00', 102)) and "
        SelectString = SelectString & "BOM.[Line No_] = 10000 "
        SelectString = SelectString & "group by IV.[Item No_]) as BomUnitCost "
        SelectString = SelectString & "FROM  [Porteous$Item] IT with (nolock) "
        SelectString = SelectString & "WHERE "
        SelectString = SelectString & "(IT.[Cat_ No_] = '" & CurCat & "') "
        If Trim(PackageFilter.Text) <> "" Then
            SelectString = SelectString & " AND (left(IT.[Variance No_]," & Len(Trim(PackageFilter.Text)) & ") = '" & Trim(PackageFilter.Text) & "')"
        End If
        If Trim(PackageFilter2.Text) <> "" Then
            SelectString = SelectString & " AND (left(IT.[Variance No_]," & Len(Trim(PackageFilter2.Text)) & ") = '" & Trim(PackageFilter2.Text) & "')"
        End If
        If Trim(PlatingFilter.Text) <> "" Then
            SelectString = SelectString & " AND (right(IT.[Variance No_],1) = '" & Trim(PlatingFilter.Text) & "')"
        End If
        If Trim(PlatingFilter2.Text) <> "" Then
            SelectString = SelectString & " AND (right(IT.[Variance No_],1) = '" & Trim(PlatingFilter2.Text) & "')"
        End If
        If Trim(VelocityCodeFilter2.Text) <> "N" And Trim(VelocityCodeFilter.Text) <> "N" Then
            SelectString = SelectString & " AND ([Corp Fixed Velocity Code] <> 'N')"
        End If
        If Trim(VelocityCodeFilter.Text) <> "" Then
            SelectString = SelectString & " AND ([Corp Fixed Velocity Code] = '" & VelocityCodeFilter.Text & "')"
        End If
        If Trim(VelocityCodeFilter2.Text) <> "" Then
            SelectString = SelectString & " AND ([Corp Fixed Velocity Code] = '" & VelocityCodeFilter2.Text & "')"
        End If
        SelectString = SelectString & " order by IT.[No_]"
    End Sub
End Class
