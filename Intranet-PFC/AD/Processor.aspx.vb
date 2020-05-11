Imports System.IO
Imports System.Threading
Imports System.Data
Imports System.Web.Services
'Imports AD.WebService

Partial Class Processor
    Inherits System.Web.UI.Page
    Dim ReportsDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCReportsConnectionString")
    Dim DTSServer As String = ConfigurationManager.AppSettings.Item("DTSServer")
    Dim ResultsFolder As String = ConfigurationManager.AppSettings.Item("ResultsFolder")
    Dim ResultsFileName As String = ConfigurationManager.AppSettings.Item("ResultsFileName")
    Dim HungryFileName As String = ConfigurationManager.AppSettings.Item("HungryFileName")
    Dim cn, cn2, cn3, cn4 As New System.Data.SqlClient.SqlConnection
    Dim command, command2, command3, command4 As New System.Data.SqlClient.SqlCommand
    Dim rs, rs2, rs3, rs4 As System.Data.SqlClient.SqlDataReader
    Dim dtResults, dtWeights, dtStats As DataTable
    Dim ExcelFileName, fullpath As String
    Dim ReadResult As Integer

    'Protected Sub RunButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
    '    ' no longer used. process executed in web service
    '    Dim i As Integer
    '    RunStartTime = Now
    '    RunStatUpdatePanel.Update()
    '    cn.ConnectionString = ReportsDB.ConnectionString
    '    cn.Open()
    '    command.Connection = cn
    '    command.CommandTimeout = 0
    '    Server.ScriptTimeout = 6000
    '    i = Timeout.Infinite
    '    command.CommandText = "exec master..xp_cmdshell 'dtsrun /E /S " & DTSServer & " /N ADProcess /A ProcessName:8=" & ProcessSelector.SelectedValue & "'"
    '    lblSuccessMessage.Text = ""
    '    Try
    '        rs = command.ExecuteReader
    '    Catch ex As Exception
    '        lblErrorMessage.Text = "Process has a problem." & ex.Message
    '        Exit Sub
    '    End Try
    '    cn.Close()
    '    FillGrid()
    'End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        lblSuccessMessage.Text = "Select a Process and press Submit to run Auto Distribution." '+ Request.LogonUserIdentity.Name
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'ExcelButt.Attributes.Add("onclick", "javascript:ShowExcel();")
        Session("UserID") = Request.LogonUserIdentity.Name.Replace("PFCA.COM\", "").ToLower()
    End Sub

    Sub SortResultsGrid(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
        ResultsData.SelectCommand = "Select * from ADResults where EntryID = '" + Session("UserID").ToString() + "' order by " & e.SortExpression
        ResultsGrid.DataBind()
    End Sub

    Protected Sub ShowResults_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        FillGrid()
    End Sub

    Protected Sub Row_Command(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs)
        ResultsGrid.Rows(e.NewEditIndex).Focus()
    End Sub

    Protected Sub Update_Command(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs)
        Dim row As GridViewRow = ResultsGrid.Rows(e.RowIndex)
        Dim qty As String = CType(row.Cells(10).FindControl("ShipQty"), TextBox).Text
        ResultsData.UpdateCommand = "Update ADResults SET ShipQty=" & qty & " WHERE (pADResultsID = " & row.Cells(row.Cells.Count - 1).Text & ")"
        ResultsData.Update()
        ResultsGrid.DataBind()
        lblSuccessMessage.Text = "Record Updated"
    End Sub

    Sub FillGrid()
        Try
            Dim dsResults As DataSet = New DataSet()
            cn2.ConnectionString = ReportsDB.ConnectionString
            cn2.Open()
            command2.Connection = cn2
            'ResultsData.SelectCommand = "Select * from ADResults where SatisfiedByProcess = '" & ProcessSelector.SelectedValue & "'"
            ResultsData.SelectCommand = "Select * from ADResults where EntryID = '" + Session("UserID").ToString() + "'"
            ResultsGrid.DataBind()
            Dim da As SqlClient.SqlDataAdapter = New SqlClient.SqlDataAdapter(command2)
            'command2.CommandText = "Select * from ADXferWeights where Process = '" & ProcessSelector.SelectedValue & "'"
            command2.CommandText = "Select * from ADXferWeights where EntryID = '" + Session("UserID").ToString() + "'"
            da.SelectCommand = command2
            dsResults.Tables.Clear()
            da.Fill(dsResults)
            If dsResults.Tables.Count > 0 Then
                If dsResults.Tables(0).Rows.Count > 0 Then
                    dtWeights = dsResults.Tables(0)
                    'command2.CommandText = "SELECT  Process, SUM(Lines) as TotLines, SUM(XferLBS) as TotLBS FROM ADXferWeights where Process = '" & ProcessSelector.SelectedValue & "' GROUP BY Process "
                    command2.CommandText = "SELECT  Process, SUM(Lines) as TotLines, SUM(XferLBS) as TotLBS FROM ADXferWeights where EntryID = '" + Session("UserID").ToString() + "' GROUP BY Process"
                    da.SelectCommand = command2
                    dsResults.Tables.Clear()
                    da.Fill(dsResults)
                    dtWeights.Rows.Add(New Object() {dsResults.Tables(0).Rows(0)("Process"), "", "Total", dsResults.Tables(0).Rows(0)("TotLines"), dsResults.Tables(0).Rows(0)("TotLBS")})
                    WeightGrid.DataSource = dtWeights
                End If
            End If
            WeightGrid.DataBind()
            'command2.CommandText = "Select * from ADLastMetrics where ProcessCode = '" & ProcessSelector.SelectedValue & "' order by StepStarted"
            command2.CommandText = "Select * from ADLastMetrics where EntryID = '" + Session("UserID").ToString() + "' order by StepStarted"
            da.SelectCommand = command2
            dsResults.Tables.Clear()
            da.Fill(dsResults)
            dtStats = dsResults.Tables(0)
            StatGrid.DataSource = dtStats
            StatGrid.DataBind()
            cn2.Close()
            ResultPanel.Visible = True
        Catch ex As System.Exception
            lblErrorMessage.Text = ex.ToString()
        End Try
    End Sub


    Protected Sub ADTimer_Tick(ByVal sender As Object, ByVal e As System.EventArgs)
        UpdateRunStat()
    End Sub

    Sub RunService()
        'QA test: http://localhost/QAAD/ADWebService.asmx
        Dim ADStarter As IAsyncResult
        Dim CallWebService As New ADDts.WebService
        'Try
        ResultPanel.Visible = False
        MainUpdatePanel.Update()
        RunStatPanel.Visible = True
        ExecuteGrid.DataSource = Nothing
        ExecuteGrid.DataBind()
        RunStatLabel.Text = "Starting Process......."
        RunStatUpdatePanel.Update()
        RunStartTime.Value = Now.ToString
        CallWebService.UseDefaultCredentials = True
        ADStarter = CallWebService.BeginStartADProcess(ProcessSelector.SelectedValue, Session("UserID").ToString(), Nothing, Nothing)
        UpdateRunStat()
        ADTimer.Enabled = True
        'Catch ex As Exception
        '    lblErrorMessage.Text = "RunService Error " & ex.ToString()
        '    GreenLaser.Visible = False
        '    ADTimer.Enabled = False
        '    MainUpdatePanel.Update()
        'End Try
    End Sub

    Protected Sub RunButton_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        RunService()
    End Sub

    Sub UpdateRunStat()
        Dim StatLabel As String
        Dim RunSecs As Integer
        Dim IsComplete As Boolean
        Dim Started As Date
        Started = CDate(RunStartTime.Value.ToString)
        Try
            IsComplete = False
            Try
                GreenLaser.Visible = True
                RunSecs = DateDiff(DateInterval.Second, Started, Now) Mod 60
                StatLabel = "Process '" & ProcessSelector.SelectedValue & "' started at " & Started.ToString & _
                " Process has been executing " & DateDiff(DateInterval.Minute, Started, Now).ToString & " minutes and " & _
                RunSecs & " seconds. "
                StatLabel += "Process is still running."
                If DateDiff(DateInterval.Second, Started, Now) > 7 Then
                    cn3.ConnectionString = ReportsDB.ConnectionString
                    cn3.Open()
                    command3.Connection = cn3
                    command3.CommandText = "SELECT StepCode, ran FROM ADProcessMetrics [NOLOCK] where ran > CONVERT(DATETIME,'" & Started.ToString & "', 102) and RunUserID = '" + Session("UserID").ToString() + "' ORDER BY StepStarted "
                    rs3 = command3.ExecuteReader
                    If rs3.HasRows Then
                        While rs3.Read()
                            If rs3(0).ToString = "End" Then
                                IsComplete = True
                                'StatLabel += "<BR>" + command3.CommandText.ToString
                                'StatLabel += "<BR>" + rs3(0).ToString
                                'StatLabel += "<BR>" + rs3(1).ToString
                            End If
                        End While
                        rs3.Close()
                        cn3.Close()
                        If IsComplete Then
                            GreenLaser.Visible = False
                            ADTimer.Enabled = False
                            RunStatPanel.Visible = False
                            StatLabel = "Process complete."
                            RunStatLabel.Text = StatLabel
                            RunStatUpdatePanel.Update()
                            FillGrid()
                            MainUpdatePanel.Update()
                        Else
                            cn2.ConnectionString = ReportsDB.ConnectionString
                            cn2.Open()
                            command2.Connection = cn2
                            command2.CommandText = "SELECT StepCode, StepStarted, StepCompleted FROM ADProcessMetrics [NOLOCK] where ran > CONVERT(DATETIME,'" & Started.ToString & "', 102) and RunUserID = '" + Session("UserID").ToString() + "' ORDER BY StepStarted "
                            'StatLabel += "<BR>" + command2.CommandText.ToString
                            rs2 = command2.ExecuteReader
                            ExecuteGrid.DataSource = rs2
                            ExecuteGrid.DataBind()
                            ExecuteGrid.Visible = True
                            rs2.Close()
                            cn2.Close()
                        End If
                    End If
                End If
            Catch ex As Exception
                StatLabel = "Process Error " & ex.ToString()
                GreenLaser.Visible = False
                ADTimer.Enabled = False
            End Try
            RunStatLabel.Text = StatLabel
            RunStatUpdatePanel.Update()
        Catch ex As Exception
            lblErrorMessage.Text = "UpdateRunStat Error " & ex.ToString()
            GreenLaser.Visible = False
            ADTimer.Enabled = False
            MainUpdatePanel.Update()
        End Try

    End Sub

    Protected Sub ExcelResults_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        CreateExcelFile("Results")
    End Sub

    Protected Sub ExcelHungry_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        CreateExcelFile("Hungry")
    End Sub

    Protected Sub ExcelOver_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        CreateExcelFile("Overstock")
    End Sub
    Private Sub CreateExcelFile(ByVal ResultSource As String)
        '
        ' Create the results detail spreadsheet
        '
        ' Convert a virtual path to a fully qualified physical path.
        Try
            ExcelFileName = "~\\ExcelUploads\\AD" + Session("UserID").ToString() + ".xls"
            fullpath = Request.MapPath("" + ExcelFileName)
            Dim dsResults As DataSet = New DataSet()
            cn2.ConnectionString = ReportsDB.ConnectionString
            cn2.Open()
            command2.Connection = cn2
            Dim da As SqlClient.SqlDataAdapter = New SqlClient.SqlDataAdapter(command2)
            If ResultSource = "Results" Then
                command2.CommandText = "Select * from ADResults where EntryID = '" + Session("UserID").ToString() + "'"
            End If
            If ResultSource = "Hungry" Then
                command2.CommandText = "Select * from ADHungry where EntryID = '" + Session("UserID").ToString() + "' and RecType = 'Standard' order by Item, ToLoc"
            End If
            If ResultSource = "Overstock" Then
                command2.CommandText = "Select * from ADHungry where EntryID = '" + Session("UserID").ToString() + "' and RecType = 'Overstock' order by Item, ToLoc, FromLoc"
            End If
            da.SelectCommand = command2
            da.Fill(dsResults)
            Using sw As StreamWriter = New StreamWriter(fullpath)
                If ResultSource = "Results" Then
                    sw.Write("Item" + vbTab + "From" + vbTab + "CFVC" + vbTab + "To" + vbTab + "SVC" + vbTab + "ROP" + vbTab + "QOH" + vbTab)
                    sw.Write("QOT" + vbTab + "Rcm Qty" + vbTab + "Ship Qty" + vbTab + "Super" + vbTab + "LPP" + vbTab + "Capacity" + vbTab + "RDCAvail" + vbTab)
                    sw.Write("Priority" + vbTab + "SatisfiedByProcess" + vbTab + "SatisfiedByStep")
                End If
                If ResultSource = "Hungry" Then
                    sw.Write("Item" + vbTab + "CFVC" + vbTab + "To" + vbTab + "SVC" + vbTab + "ROP" + vbTab + "QOH" + vbTab)
                    sw.Write("QOT" + vbTab + "Rcm Qty" + vbTab + "Ship Qty" + vbTab + "Super" + vbTab + "LPP" + vbTab + "Capacity" + vbTab + "RDCAvail" + vbTab)
                    sw.Write("IgnoredByProcess" + vbTab + "IgnoredByStep")
                End If
                If ResultSource = "Overstock" Then
                    sw.Write("Item" + vbTab + "From" + vbTab + "CFVC" + vbTab + "To" + vbTab + "SVC" + vbTab + "ROP" + vbTab + "QOH" + vbTab)
                    sw.Write("QOT" + vbTab + "Rcm Qty" + vbTab + "Ship Qty" + vbTab + "Super" + vbTab + "LPP" + vbTab + "Capacity" + vbTab + "RDCAvail" + vbTab)
                    sw.Write("IgnoredByProcess" + vbTab + "IgnoredByStep")
                End If
                sw.WriteLine()
                For Each row As DataRow In dsResults.Tables(0).Rows
                    sw.Write(row("Item").ToString().Trim())
                    sw.Write(vbTab)
                    If ResultSource = "Results" Or ResultSource = "Overstock" Then
                        sw.Write(row("FromLoc").ToString().Trim())
                        sw.Write(vbTab)
                    End If
                    sw.Write(row("CFVC").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("ToLoc").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("SVC").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("ROP").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("QOH").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("QOT").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("Qty").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("ShipQty").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("SuperEqvQty").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("LowProfilePalletQty").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("Capacity").ToString().Trim())
                    sw.Write(vbTab)
                    sw.Write(row("RDCAvail").ToString().Trim())
                    sw.Write(vbTab)
                    If ResultSource = "Results" Then
                        sw.Write(row("Priority").ToString().Trim())
                        sw.Write(vbTab)
                        sw.Write(row("SatisfiedByProcess").ToString().Trim())
                        sw.Write(vbTab)
                        sw.Write(row("SatisfiedByStep").ToString().Trim())
                        sw.Write(vbTab)
                    End If
                    If ResultSource = "Hungry" Or ResultSource = "Overstock" Then
                        sw.Write(row("IgnoredByProcess").ToString().Trim())
                        sw.Write(vbTab)
                        sw.Write(row("IgnoredByStep").ToString().Trim())
                        sw.Write(vbTab)
                    End If
                    sw.WriteLine()
                Next row
            End Using
            ' now open it.
            Dim ShowExcel As String = "window.open('" + Request.ApplicationPath + "/ExcelUploads/AD" + Session("UserID").ToString() + ".xls','ADExcel','','');"
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType, "ShowExcel", ShowExcel, True)

        Catch ex As System.Exception
            lblErrorMessage.Text = ex.ToString()
        End Try
    End Sub


End Class
