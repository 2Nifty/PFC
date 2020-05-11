
Partial Class BudgetImport
    Inherits System.Web.UI.Page
    Public StatMessage, ExcelFileName As String
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile As String
    Public BadCount, z As Integer
    Public ConnectString, UserID As String
    Public BudgetMonth, BudgetYear As Integer
    Public ds As New System.Data.DataSet()
    Public BudgetTable As Data.DataTable = New Data.DataTable("BudgetLines")


    Sub LoadIt()
        Dim cn2 As New System.Data.SqlClient.SqlConnection
        Dim command2 As New System.Data.SqlClient.SqlCommand
        Dim rs2 As System.Data.SqlClient.SqlDataReader
        'cn.ConnectionString = PFCDB.ConnectionString
        'cn.Open()
        'Command.Connection = cn
        'PFCDB = ConfigurationManager.appsettings("ReportsConnectionString")
        cn2.ConnectionString = ConfigurationManager.appsettings("ReportsConnectionString")
        cn2.Open()
        command2.Connection = cn2
        'Do While rs2.Read
        Dim cn As System.Data.OleDb.OleDbConnection
        Dim cmd As System.Data.OleDb.OleDbDataAdapter
        Dim XtndProp As String = ";Extended Properties=Excel 8.0;"
        Dim ExProvider As String = "provider=Microsoft.Jet.OLEDB.4.0;data source="
        Dim ItemDesc As String
        cn = New System.Data.OleDb.OleDbConnection
        '    "data source=C:\myData.XLS")
        '\\Pfcsqlt\slaterpod\Catalog\PackPrice.xls
        ConnectString = ExProvider & ExcelFileName & XtndProp
        'ConnectString = ExProvider & "\\Pfcsqlt\slaterpod\Catalog\PackagePrices.xls" & XtndProp
        cn.ConnectionString = ConnectString
        cmd = New System.Data.OleDb.OleDbDataAdapter("select '' as Status, '' as YearMo,* from [Sheet1$] raw where [Customer]<>'' ", cn)
        'StatMessage = ConnectString
        'OPStatus.Text = StatMessage
        Try
            cn.Open()
        Catch ex As Exception
            OPStatus.Text = ExcelFileName & " cannot be loaded.  " & ex.Message
            If ex.Message.Contains("It is already opened exclusively by another user") Then
                OPStatus.Text = ExcelFileName & " is locked. Close Excel."

            End If
            Exit Sub
        End Try
        Dim drow As Data.DataRow
        'rs = cmd.ExecuteReader

        cmd.Fill(ds)
        BudgetTable = ds.Tables.Item(0)
        BadCount = 0
        'SelectString = SelectString & "delete FROM [CSAR_CustomerBudgets]  "
        'SelectString = SelectString & "where UserID='" & UserID & "' "
        'command2.CommandText = SelectString
        'z = command2.ExecuteNonQuery

        For Each drow In BudgetTable.Rows
            'Response.Write(drow("Budget No") & ":")
            drow("YearMo") = CStr(BudgetMonth) & "/" & CStr(BudgetYear)
            If Len(drow("Customer")) = 0 Then
                drow("Status") = drow("Status") & "Customer Number Missing. "
                BadCount = BadCount + 1
            Else
                SelectString = "SELECT Name as CustomerName FROM CuvnalTempCustomer with (nolock)  "
                SelectString = SelectString & "WHERE No_ = '" & drow("Customer") & "'"
                command2.CommandText = SelectString
                rs2 = command2.ExecuteReader
                If Not rs2.HasRows Then
                    drow("Status") = drow("Status") & "Customer not found. "
                    BadCount = BadCount + 1
                Else
                    'rs2.Read()
                    'Response.Write(rs2("ChainName"))
                End If
                rs2.Close()
            End If
            If Not IsNumeric(drow("Budget01")) Then
                drow("Status") = drow("Status") & "Budget01 Qty Bad. "
                BadCount = BadCount + 1
            End If
            drow.AcceptChanges()
            ' see if it exists
            'SelectString = "select BudgetNo from VMI_Budget_Temp where "
            'SelectString = SelectString & " UserID = '" & UserID & "' and "
            'SelectString = SelectString & " CustomerNumber = '" & drow("Customer") & "'  "
            'command2.CommandText = SelectString
            'rs2 = command2.ExecuteReader
            'If rs2.HasRows Then
            '    rs2.Close()
            '    SelectString = "update VMI_Budget_Temp "
            '    SelectString = SelectString & "set [EAU_Qty]=[EAU_Qty]+ "
            '    SelectString = SelectString & " " & drow("Budget Usage Qty") & " where "
            '    SelectString = SelectString & " UserID = '" & UserID & "' and "
            '    SelectString = SelectString & " BudgetNo = '" & drow("Budget No") & "' and "
            '    SelectString = SelectString & " Chain = '" & drow("Chain Name") & "' and "
            '    SelectString = SelectString & " ItemNo = '" & drow("PFC Item No") & "'  "
            '    command2.CommandText = SelectString
            '    z = command2.ExecuteNonQuery
            'Else
            '    rs2.Close()
            '    SelectString = "insert into VMI_Budget_Temp "
            '    SelectString = SelectString & "(BudgetNo, Chain, ItemNo, [ItemDesc], [SubItemNo], [CrossRef], [EAU_Qty], [BudgetPrice], [E_Profit_Pct], [StartDate], "
            '    SelectString = SelectString & "[EndDate], [Salesperson], [OrderMethod], [Vendor], [Contact], [ContactPhone], [MonthFactor], [Closed], [CustomerPO], UserID) values ("
            '    SelectString = SelectString & "'" & drow("Budget No") & "', "
            '    SelectString = SelectString & "'" & drow("Chain Name") & "', "
            '    SelectString = SelectString & "'" & drow("PFC Item No") & "', "
            '    SelectString = SelectString & "'" & ItemDesc & "', "
            '    SelectString = SelectString & "'" & drow("Substitute No") & "', "
            '    SelectString = SelectString & "'" & drow("Cross Ref No") & "', "
            '    SelectString = SelectString & " " & drow("Budget Usage Qty") & " , "
            '    SelectString = SelectString & " " & drow("Price Per Base UOM") & " , "
            '    SelectString = SelectString & " 0.01*" & drow("Expected GP Pct") & ", "
            '    SelectString = SelectString & "'" & drow("Start Date") & "', "
            '    SelectString = SelectString & "'" & drow("End Date") & "', "
            '    SelectString = SelectString & "'" & drow("PFC Salesperson") & "', "
            '    SelectString = SelectString & "'" & drow("Order Method") & "', "
            '    SelectString = SelectString & "'" & drow("Vendor Code") & "', "
            '    SelectString = SelectString & "'" & drow("Cust Contact Name") & "', "
            '    SelectString = SelectString & "'" & drow("Cust Contact Phone") & "', "
            '    SelectString = SelectString & " " & drow("Month Factor") & " , "
            '    SelectString = SelectString & "0, "
            '    SelectString = SelectString & "'" & drow("Customer PO No") & "', "
            '    SelectString = SelectString & "'" & UserID & "') "
            '    command2.CommandText = SelectString
            '    z = command2.ExecuteNonQuery
            'End If
        Next
        'rs = cmd.Container
        'Do While rs.Read > 0
        '    Response.Write(rs("Budget No"))
        'Loop
        cn.Close()
        BudgetGrid.DataSource = ds
        BudgetGrid.DataBind()
        Dim rw As System.Web.UI.WebControls.GridViewRow
        Dim ctr As Integer
        For Each rw In BudgetGrid.Rows
            rw.Cells.Item(0).Wrap = False
            'rw.Cells.Item(1).Wrap = False
            'rw.Cells.Item(2).Wrap = False
            For ctr = 3 To 14
                rw.Cells.Item(ctr).Text = Format(CDec(rw.Cells.Item(ctr).Text), "#,##0")
                rw.Cells.Item(ctr).HorizontalAlign = HorizontalAlign.Right
            Next
            'rw.Cells.Item(4).Text = Format(CDate(rw.Cells.Item(4).Text), "MM/dd/yyyy")
            'rw.Cells.Item(5).Wrap = False
            'rw.Cells.Item(6).Wrap = False
            'rw.Cells.Item(8).Text = Format(CDec(rw.Cells.Item(8).Text), "#,##0")
            'rw.Cells.Item(8).HorizontalAlign = HorizontalAlign.Right
            'rw.Cells.Item(9).Text = Format(CDec(rw.Cells.Item(9).Text), "#,##0.000")
            'rw.Cells.Item(9).HorizontalAlign = HorizontalAlign.Right
            'rw.Cells.Item(10).HorizontalAlign = HorizontalAlign.Right
            'rw.Cells.Item(14).Wrap = False
        Next
        'BudgetGrid.Columns(1).ItemStyle.Width = 100
        OPStatus.Text = "Loaded " & ExcelFileName & " in page. Review data below. Use the Update button to apply Budgets."
        ExcelInPage.Visible = True
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        UserID = Session("UserName").ToString()
        Dim Budget As String
        For Each Budget In Request.Form
            If InStr(Budget, ".xls") > 0 Then
                ExcelFileName = Mid(Budget, 7)
                BudgetYear = Request.Form("BudgetYear")
                BudgetMonth = Request.Form("BudgetMonth")
                Exit For
            End If
        Next
        If ExcelFileName = "" Then
            ExcelFileName = Request.QueryString("xls")
            BudgetYear = Request.QueryString("year")
            BudgetMonth = Request.QueryString("month")
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        OPStatus.Text = ExcelFileName
        If Not ispostback And ExcelFileName <> "" Then
            Dim BudgetPath As String = ConfigurationManager.AppSettings("BudgetExcelFilePath")
            ExcelFileName = BudgetPath & ExcelFileName
            LoadBudget.Enabled = True
            hiddenfilename.value = ExcelFileName
            HiddenBudgetYear.value = BudgetYear
            HiddenBudgetMonth.value = BudgetMonth
            StatMessage = "Loading file for review. One moment....."
            LoadIt()
            If BadCount > 0 Then
                LoadBudget.Visible = False
                OPStatus.Text = CStr(BadCount) & " Errors must be fixed."
            End If
        Else
            OPStatus.Text = "File Name required. Go back and enter an Excel Budget file to load."
        End If
    End Sub

    Sub LoadBudget_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles LoadBudget.Click
        Dim command As New System.Data.SqlClient.SqlCommand
        Dim cn2 As New System.Data.SqlClient.SqlConnection
        Dim command2 As New System.Data.SqlClient.SqlCommand
        cn2.ConnectionString = ConfigurationManager.appsettings("ReportsConnectionString")
        cn2.Open()
        command2.Connection = cn2
        Dim cn As System.Data.OleDb.OleDbConnection
        Dim cmd As System.Data.OleDb.OleDbDataAdapter
        Dim XtndProp As String = ";Extended Properties=Excel 8.0;"
        Dim ExProvider As String = "provider=Microsoft.Jet.OLEDB.4.0;data source="
        cn = New System.Data.OleDb.OleDbConnection
        ExcelFileName = hiddenfilename.value
        ConnectString = ExProvider & ExcelFileName & XtndProp
        cn.ConnectionString = ConnectString
        cmd = New System.Data.OleDb.OleDbDataAdapter("select * from [Sheet1$] raw where [Customer]<>'' ", cn)
        cn.Open()
        Dim drow As Data.DataRow
        cmd.Fill(ds)
        BudgetTable = ds.Tables.Item(0)
        BudgetYear = HiddenBudgetYear.value
        BudgetMonth = HiddenBudgetMonth.value
        For Each drow In BudgetTable.Rows
            AddBudgetLines(drow, command2)
        Next
        cn2.Close()
        OPStatus.Text = "Loaded " & z & " line(s) into system. Budget updates have been applied."
        LoadBudget.Visible = False
        ExcelInPage.Visible = False
    End Sub

    Sub AddBudgetLines(ByVal SheetRow As Data.DataRow, ByVal CommandObj As System.Data.SqlClient.SqlCommand)
        Dim NextDate As Date
        Dim ColName As String
        Dim i As Integer
        ' Delete matching records
        SelectString = "delete from CSAR_CustomerBudgets "
        SelectString = SelectString & "where(CustomerNumber = '" & SheetRow("Customer") & "') "
        SelectString = SelectString & "and (CurMo=" & BudgetMonth & ") "
        SelectString = SelectString & "and (CurYr=" & BudgetYear & ") "
        CommandObj.CommandText = SelectString
        z = CommandObj.ExecuteNonQuery
        ' insert records
        SelectString = "insert into CSAR_CustomerBudgets "
        SelectString = SelectString & "([CustomerNumber], [CurMo], [CurYr], [BudgetAmt], [UserID])"
        SelectString = SelectString & " values  "
        SelectString = SelectString & "('" & SheetRow("Customer") & "' "
        SelectString = SelectString & ",'" & BudgetMonth & "' "
        SelectString = SelectString & ",'" & BudgetYear & "' "
        SelectString = SelectString & ",'" & SheetRow("Budget01") & "' "
        SelectString = SelectString & ",'" & UserID & "' )"
        CommandObj.CommandText = SelectString
        z = CommandObj.ExecuteNonQuery
        NextDate = CDate(BudgetMonth & "/1/" & BudgetYear)
        For i = 2 To 12
            NextDate = dateadd("m", 1, NextDate)
            ColName = "Budget" & format(i, "00")
            ' Delete matching records
            SelectString = "delete from CSAR_CustomerBudgets "
            SelectString = SelectString & "where(CustomerNumber = '" & SheetRow("Customer") & "') "
            SelectString = SelectString & "and (CurMo=" & NextDate.Month & ") "
            SelectString = SelectString & "and (CurYr=" & NextDate.Year & ") "
            CommandObj.CommandText = SelectString
            z = CommandObj.ExecuteNonQuery
            ' insert records
            SelectString = "insert into CSAR_CustomerBudgets "
            SelectString = SelectString & "([CustomerNumber], [CurMo], [CurYr], [BudgetAmt], [UserID])"
            SelectString = SelectString & " values  "
            SelectString = SelectString & "('" & SheetRow("Customer") & "' "
            SelectString = SelectString & ",'" & NextDate.Month & "' "
            SelectString = SelectString & ",'" & NextDate.Year & "' "
            SelectString = SelectString & ",'" & SheetRow(ColName) & "' "
            SelectString = SelectString & ",'" & UserID & "' )"
            CommandObj.CommandText = SelectString
            z = CommandObj.ExecuteNonQuery

        Next
    End Sub
End Class
