Imports System
Imports System.IO
Imports System.Net

Partial Class RBMoveXfer
    Inherits System.Web.UI.Page
    Shared Branch, FullFileName, SQLCommand, SQLCommand2 As String
    Dim RBDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("RBConnectionString")
    Dim NVDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("NVConnectionString")
    Dim cn, cn2, cn3 As New System.Data.SqlClient.SqlConnection
    Dim ODBCcn As New System.Data.Odbc.OdbcConnection
    Dim command, command2, command3 As New System.Data.SqlClient.SqlCommand
    Dim ODBCcommand As New System.Data.Odbc.OdbcCommand
    Dim rs, rs2 As System.Data.SqlClient.SqlDataReader
    Dim loop1, opstat, recctr As Integer
    Dim LogonID, NVDBName, TOsToMove, TOSelection, SignInd, CurTO As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsPostBack Then
        Else
            RunTextBox.Text = "Enter the NV TO numbers for the receipts you want to create in RB. " & _
                "All numbers must start with TO or TS." & vbCrLf & vbCrLf & _
                "Copying a single column from Excel and pasting into the list is OK. " & _
                "You can delete from the list by selecting the row and deleting it." & vbCrLf & vbCrLf & _
                "Press the SUBMIT button to move the transfer reciepts to RB."
        End If
        LogonID = HttpContext.Current.User.Identity.Name
        LogonID = Mid(LogonID, InStr(LogonID, "\") + 1)
        UserLabel.Text = "Welcome, " & LogonID
    End Sub

    Protected Sub SubmitButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles SubmitButt.Click
        NVDBName = NVDB.ConnectionString.Split(";")(1)
        NVDBName = NVDBName.Split("=")(1)
        TOsToMove = OrdersToProcessTextBox.Text
        TOSelection = ""
        RunTextBox.Text = ""
        For loop1 = 0 To TOsToMove.Split(vbLf).Length - 1
            CurTO = TOsToMove.Split(vbLf)(loop1).Trim
            If CurTO <> "" Then
                If CurTO.Substring(0, 2) = "TO" Then
                    TOSelection += "([Transfer Order No_] LIKE '" & CurTO & "') or "
                ElseIf CurTO.Substring(0, 2) = "TS" Then
                    TOSelection += "([Document No_] LIKE '" & CurTO & "') or "
                Else
                    RunTextBox.Text += "'" & CurTO & "' ignored because it does not start with TO or TS." & vbCrLf
                End If
            Else
                Exit For
            End If
        Next
        If TOSelection <> "" Then
            ProcessSelection()
        Else
            RunTextBox.Text += vbCrLf & vbCrLf & "There are no valid TO numbers to process. No receipts created!"
        End If
    End Sub

    Sub ProcessSelection()
        RunPanel.Visible = False
        cn.ConnectionString = NVDB.ConnectionString
        cn.Open()
        command.Connection = cn
        ' remove the last 'or'
        TOSelection = TOSelection.Substring(0, TOSelection.Length - 3)
        SQLCommand = "SELECT "
        SQLCommand += "RBBin = [Transfer-to Code] + 'RCPT' + [Transfer-from Code], "
        SQLCommand += "RBLPN = case when len(rtrim([Container No_]))>0 then [Transfer-to Code] + [Container No_] "
        SQLCommand += "when len(rtrim(TL.[Transfer Order No_])) < 9 then TL.[Transfer Order No_]+REPLICATE ( '-' , 9-len(rtrim(TL.[Transfer Order No_]))) "
        SQLCommand += "else TL.[Transfer Order No_] end, "
        SQLCommand += " [Item No_], [Description], [Quantity], [Original Purchase Order]  "
        SQLCommand += "FROM [Porteous$Transfer Shipment Line] TL WITH (NOLOCK)  "
        SQLCommand += "WHERE (( "
        SQLCommand += TOSelection
        SQLCommand += ") AND (Quantity > 0)) "
        SQLCommand += "ORDER BY [Line No_] "
        command.CommandText = SQLCommand
        'RunTextBox.Text = SQLCommand & vbCrLf
        rs = command.ExecuteReader
        If rs.HasRows Then
            Dim dt As New Data.DataTable()
            Dim dr As Data.DataRow
            ' Build Grid columns
            dt.Columns.Add(New Data.DataColumn("Bin Number", GetType(String)))
            dt.Columns.Add(New Data.DataColumn("License Plate", GetType(String)))
            dt.Columns.Add(New Data.DataColumn("PFC Item Number", GetType(String)))
            dt.Columns.Add(New Data.DataColumn("Quantity", GetType(Int32)))
            ' connect to Radio Beacon
            cn2.ConnectionString = RBDB.ConnectionString
            cn2.Open()
            command2.Connection = cn2
            recctr = 0
            Do While rs.Read
                If rs("Quantity") < 0 Then
                    SignInd = "-"
                Else
                    SignInd = "+"
                End If
                SQLCommand = "insert into DNLOAD "
                SQLCommand += "([FIELD001],[FIELD002],[FIELD003],[FIELD004],[FIELD005],"
                SQLCommand += "[FIELD008],[FIELD009],[FIELD010],[FIELD011],[FIELD012],[FIELD013],[FIELD025],[FIELD031]"
                SQLCommand += ") values ('CA','MA', "
                SQLCommand += "convert(char(20),'" & rs("Item No_").Trim & "'), "
                SQLCommand += "'" & Left(rs("Description"), 40) & "', "
                SQLCommand += "1, "
                SQLCommand += "replace(convert(varchar,cast((cast(isnull(abs(" & rs("Quantity") & "),0) as bigint)) as money),1),'.00','') ,"
                SQLCommand += "1, "
                SQLCommand += "'" & SignInd & "', "
                SQLCommand += "'" & rs("RBBin").Trim & "', "
                SQLCommand += "0, "
                SQLCommand += "'" & rs("Original Purchase Order").Trim & "', "
                SQLCommand += "'0000000000', "
                SQLCommand += "'" & rs("RBLPN").Trim & "') "
                command2.CommandText = SQLCommand
                loop1 = command2.ExecuteNonQuery()
                'RunTextBox.Text += SQLCommand & vbCrLf
                'RunTextBox.Text += rs("RBLPN").Trim & vbTab & rs("Item No_").Trim & vbTab & rs("Quantity") & vbCrLf
                recctr += 1
                ' Build Grid Row
                dr = dt.NewRow()
                dr(0) = " " & rs("RBBin").Trim
                dr(1) = " " & rs("RBLPN").Trim
                dr(2) = " " & rs("Item No_").Trim
                dr(3) = rs("Quantity")
                dt.Rows.Add(dr)
            Loop
            cn2.Close()
            RunTextBox.Text += recctr & " lines added." & vbCrLf & vbCrLf & "You may enter more TO numbers."
            OrdersToProcessTextBox.Text = ""
            Dim dv As New Data.DataView(dt)
            ResultsGrid.DataSource = dv
            ResultsGrid.DataBind()
            RunPanel.Visible = True
        Else
            RunTextBox.Text += vbCrLf & "None of these transfers are on file!" & vbCrLf
        End If
        cn.Close()
    End Sub
End Class
