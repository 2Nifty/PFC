Imports System.Data

Partial Class StepMaint
    Inherits System.Web.UI.Page
    Dim ReportsDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCReportsConnectionString")
    Dim cn, cn2, cn3, cn4 As New System.Data.SqlClient.SqlConnection
    Dim command, command2, command3, command4 As New System.Data.SqlClient.SqlCommand
    Dim rs, rs2, rs3, rs4 As System.Data.SqlClient.SqlDataReader
    Dim dtConfig, dtDetail As DataTable

    Sub BindStepDetailData(ByVal StepCode As String)
        Dim dsStepDetail As DataSet = New DataSet()
        cn.ConnectionString = ReportsDB.ConnectionString
        cn.Open()
        command.Connection = cn
        command.CommandText = "Select * from ADStepDetail where StepCode = '" & StepCode & "' order by StepIsHub desc "
        Dim da As SqlClient.SqlDataAdapter = New SqlClient.SqlDataAdapter(command)
        da.Fill(dsStepDetail)
        If dsStepDetail.Tables(0).Rows.Count > 0 Then
            dtDetail = dsStepDetail.Tables(0)
            StepDetailPanel.Visible = True
            lblErrorMessage.Text = ""
        Else
            lblErrorMessage.Text = "No matching records on file. Use Add to add detail."
            StepDetailPanel.Visible = False
        End If
        StepDetailGrid.DataSource = dtDetail
        StepDetailGrid.DataBind()
        Session("Steps") = dtDetail
        cn.Close()
        MasterLabel.Text = StepCode
        BindDependentData(StepCode)
    End Sub

    Sub BindDependentData(ByVal StepCode As String)
        cn3.ConnectionString = ReportsDB.ConnectionString
        cn3.Open()
        command3.Connection = cn3
        command3.CommandText = "select distinct ProcessCode from ADProcessConfig where StepCode = '" + MasterLabel.Text + "' "
        rs3 = command3.ExecuteReader
        DependentGrid.DataSource = rs3
        DependentGrid.DataBind()
        cn3.Close()
    End Sub

    Protected Sub SaveButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles SaveButt.Click
        Dim columnValues As String
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        If UpdFunction.Value = "Add" Then
            columnValues = " '" + StepUpd.Text + "' "
            columnValues += ", '" + SupplyBranches.Text + "' "
            columnValues += ", '" + CFVCUpd.Text + "' "
            columnValues += ", " + ROPMultiplier.Text + " "
            columnValues += ", 0, 'A' "
            command2.CommandText = "insert into ADStepConfig (StepCode, HubBranch, VelocityCodes, HubROPFactor, Required, StepType ) values (" + columnValues + ")"
            command2.ExecuteNonQuery()
            command2.CommandText = ""
            ConfigStat.Text = "Step Code " & StepUpd.Text & " has been added. Don't forget the detail for the step."
            MasterLabel.Text = StepUpd.Text
            'StepUpd.Text = ""
            'CFVCUpd.Text = ""
            StepNames.DataBind()
            StepFilter.DataBind()
            ShowTree(MasterLabel.Text)
        Else
            columnValues = " StepCode = '" + StepUpd.Text + "' "
            columnValues += ", HubBranch = '" + SupplyBranches.Text + "' "
            columnValues += ", VelocityCodes = '" + CFVCUpd.Text + "' "
            columnValues += ", HubROPFactor = " + ROPMultiplier.Text + " "
            command2.CommandText = "update ADStepConfig set " + columnValues + " where StepRecID = " + HiddenID.Value
            command2.ExecuteNonQuery()
            ShowTree(StepFilter.SelectedValue)
            ConfigStat.Text = "Step Code " & StepUpd.Text & " updated."
        End If
        cn2.Close()
    End Sub

    Protected Sub DetailAddButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        DetailFunc.Value = "Add"
        DetailStat.Text = "Press Accept to save new record."
        DetailAddButt.Visible = False
        DetailSaveButt.Visible = True
    End Sub

    Protected Sub DetailSaveButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim columnValues As String
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        If DetailFunc.Value = "Add" Then
            columnValues = " '" + MasterLabel.Text + "' "
            columnValues += ", " + StepIsHubBox.Text + " "
            columnValues += ", '" + DetailBranches.Text + "' "
            columnValues += ", '" + MinMaxDropDownList.SelectedValue + "' "
            command2.CommandText = "insert into ADStepDetail (StepCode, StepIsHub, Branches, MinMaxCode) values (" + columnValues + ")"
            command2.ExecuteNonQuery()
            DetailStat.Text = "Detail record added."
        Else
            columnValues = " StepCode = '" + MasterLabel.Text + "' "
            columnValues += ", StepIsHub = " + StepIsHubBox.Text + " "
            columnValues += ", Branches = '" + DetailBranches.Text + "' "
            columnValues += ", MinMaxCode = '" + MinMaxDropDownList.SelectedValue.Trim + "' "
            command2.CommandText = "update ADStepDetail set " + columnValues + " where DetailRecID = " + HiddenStepDetailID.Value
            command2.ExecuteNonQuery()
            DetailStat.Text = "Detail record " & HiddenStepDetailID.Value & " has been updated."
        End If
        cn2.Close()
        ShowTree(MasterLabel.Text)
        BindStepDetailData(MasterLabel.Text)
        DetailAddButt.Visible = True
        DetailSaveButt.Visible = False
    End Sub

    Sub SortStepDetailGrid(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
        Dim dv As DataView = New DataView()
        dv.Table = Session("Steps")
        dv.Sort = e.SortExpression
        StepDetailGrid.DataSource = dv
        StepDetailGrid.DataBind()
    End Sub

    Protected Sub StepDetailEditHandler(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        Dim row As GridViewRow = StepDetailGrid.Rows(e.NewEditIndex)
        HiddenStepDetailID.Value = row.Cells(row.Cells.Count - 1).Text
        StepIsHubBox.Text = row.Cells(1).Text
        StepIsHubBox.Focus()
        DetailBranches.Text = row.Cells(2).Text.Trim
        MinMaxDropDownList.SelectedValue = row.Cells(3).Text
        DetailSaveButt.Visible = True
        DetailAddButt.Visible = False
        DetailFunc.Value = "Upd"
        DetailStat.Text = "Make changes to detail record " & HiddenStepDetailID.Value & " then press Accept."
    End Sub

    Sub StepDetailDeleteHandler(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Dim row As GridViewRow = StepDetailGrid.Rows(e.RowIndex)
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "delete from ADStepDetail where DetailRecID = " + row.Cells(row.Cells.Count - 1).Text + " "
        command2.ExecuteNonQuery()
        DetailStat.Text = "Detail record " & row.Cells(row.Cells.Count - 1).Text & " has been deleted."
        BindStepDetailData(MasterLabel.Text)
        ShowTree(MasterLabel.Text)
        DetailSaveButt.Visible = False
    End Sub

    Protected Sub FindButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles FindButt.Click
        Dim HubBranch As String
        PageFunc.Value = "Find"
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "select * from ADStepConfig where StepCode = '" + StepFilter.SelectedValue + "' "
        command2.ExecuteNonQuery()
        rs2 = command2.ExecuteReader
        If rs2.HasRows Then
            StepDetailPanel.Visible = True
            BindStepDetailData(StepFilter.SelectedValue)
            rs2.Read()
            StepUpd.Text = rs2("StepCode")
            HubBranch = rs2("HubBranch").ToString.Trim
            SupplyBranches.Text = HubBranch
            CFVCUpd.Text = rs2("VelocityCodes")
            ROPMultiplier.Text = rs2("HubROPFactor")
            HiddenID.Value = rs2("StepRecID")
            ShowTree(StepFilter.SelectedValue)
            DetailSaveButt.Visible = False
            ConfigStat.Text = ""
        End If
        cn2.Close()
        DetailStat.Text = ""
    End Sub

    Protected Sub AddButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles AddButt.Click
        UpdFunction.Value = "Add"
        StepDetailPanel.Visible = True
        DetailFunc.Value = "Add"
        DetailStat.Text = "Press Accept to save new record."
        DetailAddButt.Visible = False
        DetailSaveButt.Visible = True
    End Sub

    Protected Sub DeleteButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles DeleteButt.Click
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "delete from ADStepConfig where StepCode = '" + MasterLabel.Text.Trim + "'"
        command2.ExecuteNonQuery()
        command2.CommandText = "delete from ADStepDetail where StepCode = '" + MasterLabel.Text.Trim + "'"
        command2.ExecuteNonQuery()
        UpdFunction.Value = ""
        StepDetailPanel.Visible = False
        DetailFunc.Value = ""
        TreePanel.Visible = False
        lblErrorMessage.Text = "Record Deleted!"
        StepNames.DataBind()
        StepFilter.DataBind()
        StepFilter.Focus()
        cn2.Close()
    End Sub

    Sub ShowTree(ByVal TreeStep As String)
        Dim tcn, tcn2, tcn3, tcn4 As New System.Data.SqlClient.SqlConnection
        Dim tcommand, tcommand2, tcommand3, tcommand4 As New System.Data.SqlClient.SqlCommand
        Dim trs2, trs3, trs4 As System.Data.SqlClient.SqlDataReader
        'trs, 
        Dim level1, level2, level3 As Integer
        Dim CurStep, CurDetail, CurMM As String
        tcn2.ConnectionString = ReportsDB.ConnectionString
        tcn2.Open()
        tcn3.ConnectionString = ReportsDB.ConnectionString
        tcn3.Open()
        tcn4.ConnectionString = ReportsDB.ConnectionString
        tcn4.Open()
        tcommand2.Connection = tcn2
        tcommand3.Connection = tcn3
        tcommand4.Connection = tcn4
        level1 = 0
        level2 = 0
        level3 = 0
        CurStep = ""
        CurDetail = ""
        TreeView1.Nodes.Clear()
        TreePanel.Visible = False
        tcommand2.CommandText = "Select * from ADStepConfig where StepCode = '" & TreeStep & "' "
        trs2 = tcommand2.ExecuteReader()
        If trs2.HasRows Then
            TreePanel.Visible = True
            Do While trs2.Read()
                Dim CurNode1 As TreeNode = New TreeNode
                CurStep = "Supply Hub: <B>" & trs2("HubBranch") & "</B>  CFVCs: <B>" & trs2("VelocityCodes") & "</B>  ROP Mult.: <B>" & trs2("HubROPFactor") & "</B>"
                CurNode1.SelectAction = TreeNodeSelectAction.None
                CurNode1.Text = CurStep
                TreeView1.Nodes.Add(CurNode1)
                tcommand3.CommandText = "Select * from ADStepDetail where StepCode = '" & TreeStep & "'"
                trs3 = tcommand3.ExecuteReader()
                If trs3.HasRows Then
                    Do While trs3.Read()
                        Dim CurNode2 As TreeNode = New TreeNode
                        If trs3("StepIsHub") Then
                            CurDetail = "Hubs:<B>" & trs3("Branches") & "</B> MM:<B>" & trs3("MinMaxCode") & "</B>"
                        Else
                            CurDetail = "Sats:<B>" & trs3("Branches") & "</B> MM:<B>" & trs3("MinMaxCode") & "</B>"
                        End If
                        CurNode2.SelectAction = TreeNodeSelectAction.None
                        CurNode2.Text = CurDetail
                        CurNode2.Value = "StepDetail," & trs3("StepCode") & "," & CStr(trs3("StepIsHub"))
                        TreeView1.Nodes(level1).ChildNodes.Add(CurNode2)
                        tcommand4.CommandText = "Select * from ADMinMax where MinMaxCode = '" & trs3("MinMaxCode") & "' and IsHub = " & trs3("StepIsHub")
                        trs4 = tcommand4.ExecuteReader()
                        If trs4.HasRows Then
                            Do While trs4.Read()
                                Dim CurNode3 As TreeNode = New TreeNode
                                CurMM = " SVCs:<B>" & trs4("SVCRange") & "</B>  Min:<B>" & CStr(trs4("MinFactor")) & "</B>  Max:<B>" & CStr(trs4("MaxFactor")) & "</B>"
                                CurNode3.SelectAction = TreeNodeSelectAction.None
                                CurNode3.Text = CurMM
                                CurNode3.Value = "MinMax," & trs4("MinMaxCode") & "," & CStr(trs4("IsHub"))
                                TreeView1.Nodes(level1).ChildNodes(level2).ChildNodes.Add(CurNode3)
                                level3 += 1
                            Loop
                        Else
                            Dim CurNode3 As TreeNode = New TreeNode
                            If trs3("StepIsHub") Then
                                CurNode3.Text = "Error! MinMax not defined for Hubs"
                                CurNode3.Text += "<br />Either add Hubs to MinMax definition or "
                                CurNode3.Text += "<br />remove Hubs detail from this step"
                            Else
                                CurNode3.Text = "Error! MinMax not defined for Sats"
                                CurNode3.Text += "<br />Either add Satellites  to MinMax definition "
                                CurNode3.Text += "<br />or remove Satellite detail from this step"
                            End If
                            TreeView1.Nodes(level1).ChildNodes(level2).ChildNodes.Add(CurNode3)
                            level3 += 1
                        End If
                        trs4.Close()
                        level2 += 1
                        level3 = 0
                    Loop
                End If
                trs3.Close()
                level1 += 1
                level2 = 0
            Loop
        End If
        trs2.Close()
        tcn2.Close()
        tcn3.Close()
        tcn4.Close()
        TreeView1.ExpandAll()
    End Sub

End Class
