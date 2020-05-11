
Partial Class VMIImport
    Inherits System.Web.UI.Page
    Public StatMessage, ExcelFileName As String
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile As String
    Public BadCount, z As Integer
    Public ConnectString, UserID As String
    Public ds As New System.Data.DataSet()
    Public PFCDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCReportsConnectionString")
    Public ContractTable As Data.DataTable = New Data.DataTable("ContractLines")


    Sub LoadIt()
        Dim cn2 As New System.Data.SqlClient.SqlConnection
        Dim command2 As New System.Data.SqlClient.SqlCommand
        Dim rs2 As System.Data.SqlClient.SqlDataReader
        'cn.ConnectionString = PFCDB.ConnectionString
        'cn.Open()
        'Command.Connection = cn
        cn2.ConnectionString = PFCDB.ConnectionString
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
        cmd = New System.Data.OleDb.OleDbDataAdapter("select '' as Status,* from [Sheet1$] raw where [Contract No]<>'' ", cn)
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
        ContractTable = ds.Tables.Item(0)
        BadCount = 0
        SelectString = SelectString & "delete FROM [VMI_Contract_Temp]  "
        SelectString = SelectString & "where UserID='" & UserID & "' "
        command2.CommandText = SelectString
        z = command2.ExecuteNonQuery

        For Each drow In ContractTable.Rows
            'Response.Write(drow("Contract No") & ":")
            If Len(drow("Chain Name")) = 0 Then
                drow("Status") = drow("Status") & "Chain Name Missing. "
                BadCount = BadCount + 1
            Else
                SelectString = "SELECT Name as ChainName FROM VMI_Chain with (nolock) "
                SelectString = SelectString & "WHERE Code = '" & drow("Chain Name") & "'"
                command2.CommandText = SelectString
                rs2 = command2.ExecuteReader
                If Not rs2.HasRows Then
                    drow("Status") = drow("Status") & "Chain not found. "
                    BadCount = BadCount + 1
                Else
                    'rs2.Read()
                    'Response.Write(rs2("ChainName"))
                End If
                rs2.Close()
            End If
            If Len(drow("Contract No")) = 0 Then
                drow("Status") = drow("Status") & "Contract No Missing. "
                BadCount = BadCount + 1
            End If
            If Not IsDate(drow("Start Date")) Then
                drow("Status") = drow("Status") & "Start Date Bad. "
                BadCount = BadCount + 1
            End If
            If Not IsDate(drow("End Date")) Then
                drow("Status") = drow("Status") & "End Date Bad. "
                BadCount = BadCount + 1
            End If
            ItemDesc = ""
            If Len(drow("PFC Item No")) = 0 Then
                drow("Status") = drow("Status") & "Item No Missing. "
                BadCount = BadCount + 1
            Else
                SelectString = "SELECT Description as ItemDesc FROM CuvnalTempItem with (nolock) "
                SelectString = SelectString & "WHERE No_ = '" & drow("PFC Item No") & "'"
                command2.CommandText = SelectString
                rs2 = command2.ExecuteReader
                If Not rs2.HasRows Then
                    drow("Status") = drow("Status") & "Item not found. "
                    BadCount = BadCount + 1
                Else
                    rs2.Read()
                    ItemDesc = rs2("ItemDesc")
                    'rs2.Read()
                    'Response.Write(rs2("ChainName"))
                End If
                rs2.Close()
            End If
            If Not IsNumeric(drow("Contract Usage Qty")) Then
                drow("Status") = drow("Status") & "Usage Qty Bad. "
                BadCount = BadCount + 1
            End If
            If Not IsNumeric(drow("Price Per Base UOM")) Then
                drow("Status") = drow("Status") & "Price Per base UOM bad "
                BadCount = BadCount + 1
            End If
            If Not IsNumeric(drow("Expected GP Pct")) Then
                drow("Status") = drow("Status") & "Expected GP Pct bad. "
                BadCount = BadCount + 1
            End If
            If Len(drow("Cust Contact Name")) = 0 Then
                drow("Status") = drow("Status") & "Cust Contact Name Missing. "
                BadCount = BadCount + 1
            End If
            If Len(drow("Cust Contact Phone")) = 0 Then
                drow("Status") = drow("Status") & "Cust Contact Phone Missing. "
                BadCount = BadCount + 1
            End If
            If Not IsNumeric(drow("Month Factor")) Then
                drow("Status") = drow("Status") & "Month Factor bad. "
                BadCount = BadCount + 1
            End If
            If Len(drow("Customer PO No")) = 0 Then
                drow("Status") = drow("Status") & "Cust PO Missing. "
                BadCount = BadCount + 1
            End If
            drow.AcceptChanges()
            ' see if it exists
            SelectString = "select ContractNo from VMI_Contract_Temp where "
            SelectString = SelectString & " UserID = '" & UserID & "' and "
            SelectString = SelectString & " ContractNo = '" & drow("Contract No") & "' and "
            SelectString = SelectString & " Chain = '" & drow("Chain Name") & "' and "
            SelectString = SelectString & " ItemNo = '" & drow("PFC Item No") & "'  "
            command2.CommandText = SelectString
            rs2 = command2.ExecuteReader
            If rs2.HasRows Then
                rs2.Close()
                SelectString = "update VMI_Contract_Temp "
                SelectString = SelectString & "set [EAU_Qty]=[EAU_Qty]+ "
                SelectString = SelectString & " " & drow("Contract Usage Qty") & " where "
                SelectString = SelectString & " UserID = '" & UserID & "' and "
                SelectString = SelectString & " ContractNo = '" & drow("Contract No") & "' and "
                SelectString = SelectString & " Chain = '" & drow("Chain Name") & "' and "
                SelectString = SelectString & " ItemNo = '" & drow("PFC Item No") & "'  "
                command2.CommandText = SelectString
                z = command2.ExecuteNonQuery
            Else
                rs2.Close()
                SelectString = "insert into VMI_Contract_Temp "
                SelectString = SelectString & "(ContractNo, Chain, ItemNo, [ItemDesc], [SubItemNo], [CrossRef], [EAU_Qty], [ContractPrice], [E_Profit_Pct], [StartDate], "
                SelectString = SelectString & "[EndDate], [Salesperson], [OrderMethod], [Vendor], [Contact], [ContactPhone], [MonthFactor], [Closed], [CustomerPO], UserID) values ("
                SelectString = SelectString & "'" & drow("Contract No") & "', "
                SelectString = SelectString & "'" & drow("Chain Name") & "', "
                SelectString = SelectString & "'" & drow("PFC Item No") & "', "
                SelectString = SelectString & "'" & ItemDesc & "', "
                SelectString = SelectString & "'" & drow("Substitute No") & "', "
                SelectString = SelectString & "'" & drow("Cross Ref No") & "', "
                SelectString = SelectString & " " & drow("Contract Usage Qty") & " , "
                SelectString = SelectString & " " & drow("Price Per Base UOM") & " , "
                SelectString = SelectString & " 0.01*" & drow("Expected GP Pct") & ", "
                SelectString = SelectString & "'" & drow("Start Date") & "', "
                SelectString = SelectString & "'" & drow("End Date") & "', "
                SelectString = SelectString & "'" & drow("PFC Salesperson") & "', "
                SelectString = SelectString & "'" & drow("Order Method") & "', "
                SelectString = SelectString & "'" & drow("Vendor Code") & "', "
                SelectString = SelectString & "'" & drow("Cust Contact Name") & "', "
                SelectString = SelectString & "'" & drow("Cust Contact Phone") & "', "
                SelectString = SelectString & " " & drow("Month Factor") & " , "
                SelectString = SelectString & "0, "
                SelectString = SelectString & "'" & drow("Customer PO No") & "', "
                SelectString = SelectString & "'" & UserID & "') "
                command2.CommandText = SelectString
                z = command2.ExecuteNonQuery
            End If
        Next
        'rs = cmd.Container
        'Do While rs.Read > 0
        '    Response.Write(rs("Contract No"))
        'Loop
        cn.Close()
        PriceGrid.DataSource = ds
        PriceGrid.DataBind()
        Dim rw As System.Web.UI.WebControls.GridViewRow
        For Each rw In PriceGrid.Rows
            rw.Cells.Item(0).Wrap = False
            rw.Cells.Item(1).Wrap = False
            rw.Cells.Item(2).Wrap = False
            rw.Cells.Item(3).Text = Format(CDate(rw.Cells.Item(3).Text), "MM/dd/yyyy")
            rw.Cells.Item(4).Text = Format(CDate(rw.Cells.Item(4).Text), "MM/dd/yyyy")
            rw.Cells.Item(5).Wrap = False
            rw.Cells.Item(6).Wrap = False
            rw.Cells.Item(8).Text = Format(CDec(rw.Cells.Item(8).Text), "#,##0")
            rw.Cells.Item(8).HorizontalAlign = HorizontalAlign.Right
            rw.Cells.Item(9).Text = Format(CDec(rw.Cells.Item(9).Text), "#,##0.000")
            rw.Cells.Item(9).HorizontalAlign = HorizontalAlign.Right
            rw.Cells.Item(10).HorizontalAlign = HorizontalAlign.Right
            rw.Cells.Item(14).Wrap = False
        Next
        'PriceGrid.Columns(1).ItemStyle.Width = 100
        OPStatus.Text = "Loaded " & ExcelFileName & " in page. Review data below. Use the Update button to apply contract prices ."
        ExcelInPage.Visible = True
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Me.User.Identity.Name.Split("\")(1)
        Dim contract As String
        For Each contract In Request.Form
            If InStr(contract, ".xls") > 0 Then
                ExcelFileName = Mid(contract, 9)
                Exit For
            End If
        Next
        If ExcelFileName = "" Then
            ExcelFileName = Request.QueryString("xls")
        End If
        OPStatus.Text = ExcelFileName
        If ExcelFileName <> "" Then
            Dim VMIPath As String = ConfigurationManager.AppSettings("ExcelFilePath")
            ExcelFileName = VMIPath & ExcelFileName
            LoadContract.Enabled = True
            StatMessage = "Loading file for review. One moment....."
            LoadIt()
            If BadCount > 0 Then
                LoadContract.Visible = False
                OPStatus.Text = CStr(BadCount) & " Errors must be fixed."
            End If
        Else
            OPStatus.Text = "File Name required. Go back and enter an Excel Contract file to load."
        End If
    End Sub

    Sub LoadContract_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles LoadContract.Click
        Dim command As New System.Data.SqlClient.SqlCommand
        Dim cn2 As New System.Data.SqlClient.SqlConnection
        Dim command2 As New System.Data.SqlClient.SqlCommand
        cn2.ConnectionString = PFCDB.ConnectionString
        cn2.Open()
        ' Delete matching records
        command2.Connection = cn2
        SelectString = "delete from VMI_Contract where exists "
        SelectString = SelectString & "(select ContractNo from VMI_Contract_Temp "
        SelectString = SelectString & "where(VMI_Contract.ContractNo = VMI_Contract_Temp.ContractNo) "
        SelectString = SelectString & "and (VMI_Contract.Chain=VMI_Contract_Temp.Chain) "
        SelectString = SelectString & "and (VMI_Contract.ItemNo=VMI_Contract_Temp.ItemNo)"
        SelectString = SelectString & "and UserID='" & UserID & "')"
        command2.CommandText = SelectString
        z = command2.ExecuteNonQuery
        'Response.Write(drow("Contract No") & ":")
        ' insert temp records
        SelectString = "insert into VMI_Contract "
        SelectString = SelectString & "SELECT [RecID], [ContractNo], [Chain], [ItemNo], [ItemDesc], [SubItemNo], [CrossRef], [EAU_Qty], [ContractPrice], [E_Profit_Pct], [StartDate], [EndDate], [Salesperson], [OrderMethod], [Vendor], [Contact], [ContactPhone], [MonthFactor], [Closed], [CustomerPO] "
        SelectString = SelectString & "FROM [VMI_Contract_Temp]  "
        SelectString = SelectString & "where UserID='" & UserID & "' "
        command2.CommandText = SelectString
        z = command2.ExecuteNonQuery
        cn2.Close()
        OPStatus.Text = "Loaded " & z & " line(s) into system. Contract price updates have been applied."
        LoadContract.Visible = False
        ExcelInPage.Visible = False
    End Sub
End Class
