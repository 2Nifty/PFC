Imports System.IO
Imports System.Data
Partial Class MakeTransfers
    Inherits System.Web.UI.Page
    Dim ReportsDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCReportsConnectionString")
    Dim ERPDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCERPConnectionString")
    Dim cn, cn2, cn3, cn4 As New System.Data.SqlClient.SqlConnection
    Dim command, command2, command3, command4 As New System.Data.SqlClient.SqlCommand
    Dim rs, rs2, rs3, rs4 As System.Data.SqlClient.SqlDataReader
    Dim dtResults, dtWeights, dtStats As DataTable
    Dim ResultsFolder As String = ConfigurationManager.AppSettings.Item("ResultsFolder")
    Dim TransferFileName As String = ConfigurationManager.AppSettings.Item("TransferFileName")

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        'ResultsButt.PostBackUrl = "file:" & ResultsFolder & ResultsFileName
        'HungerButt.PostBackUrl = "file:" & ResultsFolder & HungryFileName
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            TransferPanel.Visible = False
            TransferDetailPanel.Visible = False
            TransferEditPanel.Visible = False
            lblSuccessMessage.Text = "Press Generate Transfers to view Transfers."
            Session("UserID") = Request.LogonUserIdentity.Name.Replace("PFCA.COM\", "").ToLower()
        Else

        End If

    End Sub

    Protected Sub ShowTransferButton_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ShowTransferButton.Click
        Dim rowsaffected As Integer
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "exec pADMakeXFer '','" & PackageRadioButtonList.SelectedValue & "','" + Session("UserID").ToString() + "'"
        If FilterByProcessCheckBox.Checked Then
            command2.CommandText = "exec pADMakeXFer '" & ProcessFilter.SelectedValue.ToString() & "','" & PackageRadioButtonList.SelectedValue & "','" + Session("UserID").ToString() + "'"
        End If
        command2.CommandType = CommandType.Text
        rowsaffected = command2.ExecuteNonQuery()
        FillGrids()
        TransferPanel.Visible = True
        TransferDetailPanel.Visible = True
        lblSuccessMessage.Text = "Transfer headers on the left, detail on the right."
    End Sub

    Protected Sub FillGrids()
        Dim da As SqlClient.SqlDataAdapter = New SqlClient.SqlDataAdapter(command2)
        Dim dsResults As DataSet = New DataSet()
        Dim AppPrefKey As String
        Dim li As ListItem
        If PackageRadioButtonList.SelectedValue = "Bulk" Then AppPrefKey = "ADBPS"
        If PackageRadioButtonList.SelectedValue = "Package" Then AppPrefKey = "ADPPS"
        command2.CommandText = "SELECT FromLoc, ToLoc, TransferNo, LineNumber, Item, ShipQty, Weight, SatisfiedByProcess, Priority, pADResultsID "
        command2.CommandText += " FROM ADResults, AppPref "
        command2.CommandText += " WHERE (TransferNo>'') "
        If FilterByProcessCheckBox.Checked Then
            command2.CommandText += " and (SatisfiedByProcess = '" + ProcessFilter.SelectedValue.ToString() + "')"
        End If
        If RushRadioButtonList.SelectedValue = "Hot" Then
            command2.CommandText += " and (Priority = 1)"
        End If
        If RushRadioButtonList.SelectedValue = "Not" Then
            command2.CommandText += " and (Priority = 0)"
        End If
        If FilterByFromCheckBox.Checked Then
            command2.CommandText += " and ( ( 0 = 1) "
            For Each li In FromListBox.Items
                If (li.Selected) Then
                    command2.CommandText += " or (FromLoc = '" + li.Value.ToString() + "')"
                End If
            Next
            command2.CommandText += ") "
        End If
        If FilterByToCheckBox.Checked Then
            command2.CommandText += " and ( ( 0 = 1) "
            For Each li In ToListBox.Items
                If (li.Selected) Then
                    command2.CommandText += " or (ToLoc = '" + li.Value.ToString() + "')"
                End If
            Next
            command2.CommandText += ") "
        End If
        command2.CommandText += " and (ApplicationCd = 'AD') AND (AppOptionType = '" + AppPrefKey + "')"
        command2.CommandText += " and (charindex(substring(Item,12,1),AppOptionValue)>0)"
        command2.CommandText += " and ADResults.EntryID = '" + Session("UserID").ToString() + "'"
        command2.CommandText += " ORDER BY FromLoc, ToLoc, Priority desc, TransferNo, LineNumber"
        command2.CommandType = CommandType.Text
        da.SelectCommand = command2
        dsResults.Tables.Clear()
        da.Fill(dsResults)
        TransferDetailGridView.DataSource = dsResults
        'ResultsDetail.SelectCommand = command2.CommandText
        TransferDetailGridView.DataBind()
        command2.CommandText = "SELECT FromLoc, ToLoc, TransferNo, count(LineNumber) as Lines, sum(ShipQty) as XFerQty "
        command2.CommandText += " , sum(Qty*Weight) as XFerWght  , case when Priority = 1 then 'Hot' else '' end as XFerRush "
        command2.CommandText += " FROM ADResults, AppPref "
        command2.CommandText += " WHERE  (TransferNo>'') "
        If FilterByProcessCheckBox.Checked Then
            command2.CommandText += " and (SatisfiedByProcess = '" + ProcessFilter.SelectedValue.ToString() + "')"
        End If
        If RushRadioButtonList.SelectedValue = "Hot" Then
            command2.CommandText += " and (Priority = 1)"
        End If
        If RushRadioButtonList.SelectedValue = "Not" Then
            command2.CommandText += " and (Priority = 0)"
        End If
        If FilterByFromCheckBox.Checked Then
            command2.CommandText += " and ( ( 0 = 1) "
            For Each li In FromListBox.Items
                If (li.Selected) Then
                    command2.CommandText += " or (FromLoc = '" + li.Value.ToString() + "')"
                End If
            Next
            command2.CommandText += ") "
        End If
        If FilterByToCheckBox.Checked Then
            command2.CommandText += " and ( ( 0 = 1) "
            For Each li In ToListBox.Items
                If (li.Selected) Then
                    command2.CommandText += " or (ToLoc = '" + li.Value.ToString() + "')"
                End If
            Next
            command2.CommandText += ") "
        End If
        command2.CommandText += " and (ApplicationCd = 'AD') AND (AppOptionType = '" + AppPrefKey + "')"
        command2.CommandText += " and (charindex(substring(Item,12,1),AppOptionValue)>0)"
        command2.CommandText += " and ADResults.EntryID = '" + Session("UserID").ToString() + "'"
        command2.CommandText += " group BY FromLoc, ToLoc, Priority,  TransferNo"
        command2.CommandText += " ORDER BY FromLoc, ToLoc, Priority desc, TransferNo"
        command2.CommandType = CommandType.Text
        da.SelectCommand = command2
        dsResults.Tables.Clear()
        da.Fill(dsResults)
        TransfersGridView.DataSource = dsResults
        TransfersGridView.DataBind()
        TransferEditPanel.Visible = False
        TransferDetailPanel.Height = 500
    End Sub

    Protected Sub ExportTransferButton_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ExportTransferButton.Click
        ' connect to Reports
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        ' Connect to ERP
        cn3.ConnectionString = ERPDB.ConnectionString
        cn3.Open()
        command3.Connection = cn3
        Dim row As GridViewRow
        Dim ERPInsert As String
        For Each row In TransferDetailGridView.Rows
            If row.RowType = DataControlRowType.DataRow Then
                ERPInsert = "insert into ADXfer (XferPriority, XferFrom, XferTo, XferNo, XferLineNo, XferItemNo, " + _
                "XferQty, XferWeight, ADRecID, EntryID, EntryDt) values ( "
                ERPInsert += row.Cells(2).Text + ", "
                ERPInsert += "'" + row.Cells(3).Text + "', "
                ERPInsert += "'" + row.Cells(4).Text + "', "
                ERPInsert += "'" + row.Cells(5).Text + "', "
                ERPInsert += row.Cells(6).Text + ", "
                ERPInsert += "'" + row.Cells(7).Text.Trim() + "', "
                ERPInsert += row.Cells(8).Text + ", "
                ERPInsert += row.Cells(9).Text + ", "
                ERPInsert += row.Cells(10).Text + ", "
                ERPInsert += "'" + Session("UserID").ToString() + "', "
                ERPInsert += "'" + Now().ToString("g") + "') "
                'lblSuccessMessage.Text = ERPInsert
                command3.CommandText = ERPInsert
                command3.ExecuteNonQuery()
                command2.CommandText = "delete from ADResults where pADResultsID = " + row.Cells(row.Cells.Count - 1).Text + " "
                command2.ExecuteNonQuery()
            End If
        Next
        cn2.Close()
        TransferPanel.Visible = False
        TransferDetailPanel.Visible = False
        lblSuccessMessage.Text = "Transfers are ready for NV processing."
    End Sub

    Protected Sub ShowSelectedHandler(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        Dim row As GridViewRow = TransfersGridView.Rows(e.NewEditIndex)
        Dim dsResults As DataSet = New DataSet()
        Dim AppPrefKey As String
        If PackageRadioButtonList.SelectedValue = "Bulk" Then AppPrefKey = "ADBPS"
        If PackageRadioButtonList.SelectedValue = "Package" Then AppPrefKey = "ADPPS"
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        Dim da As SqlClient.SqlDataAdapter = New SqlClient.SqlDataAdapter(command2)
        command2.CommandText = "SELECT FromLoc, ToLoc, TransferNo, LineNumber, Item, ShipQty, Weight, SatisfiedByProcess, Priority, pADResultsID "
        command2.CommandText += " FROM ADResults, AppPref "
        command2.CommandText += " WHERE (TransferNo='" & row.Cells(3).Text & "') "
        command2.CommandText += " and (ApplicationCd = 'AD') AND (AppOptionType = '" + AppPrefKey + "')"
        command2.CommandText += " and (charindex(substring(Item,12,1),AppOptionValue)>0)"
        command2.CommandText += " and ADResults.EntryID = '" + Session("UserID").ToString() + "'"
        command2.CommandText += " ORDER BY FromLoc, ToLoc, TransferNo, LineNumber"
        command2.CommandType = CommandType.Text
        da.SelectCommand = command2
        'ResultsDetail.SelectCommand = command2.CommandText
        dsResults.Tables.Clear()
        da.Fill(dsResults)
        TransferDetailGridView.DataSource = dsResults
        TransferDetailGridView.DataBind()
    End Sub

    Sub GridDeleteHandler(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Dim row As GridViewRow = TransferDetailGridView.Rows(e.RowIndex)
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "delete from ADResults where pADResultsID = " + row.Cells(row.Cells.Count - 1).Text + " "
        command2.ExecuteNonQuery()
        cn2.Close()
        FillGrids()
        lblSuccessMessage.Text = "Line deleted."
    End Sub

    Protected Sub GridEditHandler(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        Dim row As GridViewRow = TransferDetailGridView.Rows(e.NewEditIndex)
        HiddenID.Value = row.Cells(row.Cells.Count - 1).Text
        NewShipQty.Text = row.Cells(8).Text
        NewShipQty.Focus()
        NewPriority.Text = row.Cells(2).Text
        TransferNumberLabel.Text = row.Cells(5).Text & " - " & row.Cells(6).Text
        ItemLabel.Text = row.Cells(7).Text
        TransferEditPanel.Visible = True
        TransferDetailPanel.Height = 375
        lblSuccessMessage.Text = "Accept will save your changes."
    End Sub

    Protected Sub SaveButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles SaveButt.Click
        Dim columnValues As String
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        columnValues = " ShipQty = " + NewShipQty.Text + " "
        columnValues += ", Priority = " + NewPriority.Text + " "
        command2.CommandText = "update ADResults set " + columnValues + " where pADResultsID = " + HiddenID.Value
        command2.ExecuteNonQuery()
        cn2.Close()
        FillGrids()
        lblSuccessMessage.Text = "Record updated."

    End Sub

    Protected Sub DoneButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles DoneButt.Click
        TransferEditPanel.Visible = False
        TransferDetailPanel.Height = 500
        lblSuccessMessage.Text = ""

    End Sub
End Class
