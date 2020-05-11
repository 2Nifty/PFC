Imports System.Data

Partial Class ProcessMaint
    Inherits System.Web.UI.Page
    Dim ReportsDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCReportsConnectionString")
    Dim cn, cn2, cn3, cn4 As New System.Data.SqlClient.SqlConnection
    Dim command, command2, command3, command4 As New System.Data.SqlClient.SqlCommand
    Dim rs, rs2, rs3, rs4 As System.Data.SqlClient.SqlDataReader
    Dim dtFilters, dtSteps As DataTable

    Sub BindStepData(ByVal ProcesCode As String)
        Dim dsStepDetail As DataSet = New DataSet()
        cn.ConnectionString = ReportsDB.ConnectionString
        cn.Open()
        command.Connection = cn
        command.CommandText = "Select * from ADProcessConfig where ProcessCode = '" & ProcesCode & "' order by RunOrder "
        Dim da As SqlClient.SqlDataAdapter = New SqlClient.SqlDataAdapter(command)
        da.Fill(dsStepDetail)
        If dsStepDetail.Tables(0).Rows.Count > 0 Then
            dtSteps = dsStepDetail.Tables(0)
            ShowTree(ProcesCode)
            DetailPanel.Visible = True
        Else
            lblErrorMessage.Text = "No matching records on file"
            DetailPanel.Visible = False
        End If
        StepGrid.DataSource = dtSteps
        StepGrid.DataBind()
        Session("Steps") = dtSteps
        cn.Close()
        MasterLabel.Text = ProcesCode
    End Sub

    Sub BindFilterData(ByVal ProcesCode As String)
        Dim dsFilterDetail As DataSet = New DataSet()
        cn.ConnectionString = ReportsDB.ConnectionString
        cn.Open()
        command.Connection = cn
        command.CommandText = "Select * from ADProcessFilter where ProcessCode = '" & ProcesCode & "' order by BegCat, Package, Plating "
        Dim da As SqlClient.SqlDataAdapter = New SqlClient.SqlDataAdapter(command)
        da.Fill(dsFilterDetail)
        If dsFilterDetail.Tables(0).Rows.Count > 0 Then
            dtFilters = dsFilterDetail.Tables(0)
            FilterStat.Text = ""
        Else
            FilterStat.Text = "No Filters Defined"
        End If
        FilterGrid.DataSource = dtFilters
        Session("Filters") = dtFilters
        FilterGrid.DataBind()
        FilterSaveButt.Visible = False
        FilterAddButt.Visible = True
        cn.Close()
    End Sub

    Protected Sub FindButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles FindButt.Click
        PageFunc.Value = "Find"
        UpdPanel.Visible = False
        DetailPanel.Visible = True
        DetailPanel.Height = 380
        BindStepData(ProcessFilter.SelectedValue)
        FilterPanel.Visible = True
        BindFilterData(ProcessFilter.SelectedValue)
        ProcessUpd.Text = ""
        RunOrderUpd.Text = ""
    End Sub

    Protected Sub AddButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles AddButt.Click
        UpdFunction.Value = "Add"
        PageFunc.Value = "Add"
        UpdPanel.Visible = True
        DetailPanel.Height = 275
        ProcessUpd.ReadOnly = False
        ProcessUpd.Focus()
    End Sub

    Protected Sub FilterAddButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles FilterAddButt.Click
        Dim columnValues As String
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        columnValues = " '" + MasterLabel.Text + "' "
        columnValues += ", '" + BegCat.Text + "' "
        columnValues += ", '" + EndCat.Text + "' "
        columnValues += ", '" + Package.Text + "' "
        columnValues += ", '" + Plating.Text + "' "
        'columnValues += ", SYSTEM_USER, getdate()"
        command2.CommandText = "insert into ADProcessFilter (ProcessCode, BegCat, EndCat, Package, Plating) values (" + columnValues + ")"
        command2.ExecuteNonQuery()
        command2.CommandText = ""
        cn2.Close()
        BindFilterData(MasterLabel.Text)
    End Sub

    Protected Sub FilterSaveButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles FilterSaveButt.Click
        Dim columnValues As String
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        columnValues = " ProcessCode = '" + MasterLabel.Text + "' "
        columnValues += ", BegCat = '" + BegCat.Text + "' "
        columnValues += ", EndCat = '" + EndCat.Text + "' "
        columnValues += ", Package = '" + Package.Text + "' "
        columnValues += ", Plating = '" + Plating.Text + "' "
        command2.CommandText = "update ADProcessFilter set " + columnValues + " where FilterRecID = " + HiddenFilterID.Value
        command2.ExecuteNonQuery()
        cn2.Close()
        BindFilterData(MasterLabel.Text)
        FilterSaveButt.Visible = False
        FilterAddButt.Visible = True
    End Sub

    Protected Sub GridEditHandler(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        Dim row As GridViewRow = StepGrid.Rows(e.NewEditIndex)
        HiddenID.Value = row.Cells(row.Cells.Count - 1).Text
        ProcessUpd.Text = row.Cells(1).Text
        ProcessUpd.ReadOnly = True
        StepList.SelectedValue = row.Cells(2).Text
        StepList.Focus()
        RunOrderUpd.Text = row.Cells(3).Text
        UpdFunction.Value = "Upd"
        PageFunc.Value = "Upd"
        UpdPanel.Visible = True
        DetailPanel.Height = 275
    End Sub

    Protected Sub FilterEditHandler(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        Dim row As GridViewRow = FilterGrid.Rows(e.NewEditIndex)
        HiddenFilterID.Value = row.Cells(row.Cells.Count - 1).Text
        BegCat.Text = row.Cells(1).Text
        BegCat.Focus()
        EndCat.Text = row.Cells(2).Text
        Package.Text = row.Cells(3).Text
        Plating.Text = row.Cells(4).Text
        FilterSaveButt.Visible = True
        FilterAddButt.Visible = False
    End Sub

    Sub GridDeleteHandler(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Dim row As GridViewRow = StepGrid.Rows(e.RowIndex)
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "delete from ADProcessConfig where ProcessRecID = " + row.Cells(row.Cells.Count - 1).Text + " "
        command2.ExecuteNonQuery()
        BindStepData(MasterLabel.Text)
    End Sub

    Sub FilterDeleteHandler(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Dim row As GridViewRow = FilterGrid.Rows(e.RowIndex)
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "delete from ADProcessFilter where FilterRecID = " + row.Cells(row.Cells.Count - 1).Text + " "
        command2.ExecuteNonQuery()
        BindFilterData(MasterLabel.Text)
    End Sub

    Sub SortStepGrid(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
        Dim dv As DataView = New DataView()
        dv.Table = Session("Steps")
        dv.Sort = e.SortExpression
        StepGrid.DataSource = dv
        StepGrid.DataBind()
    End Sub

    Sub SortFilterGrid(ByVal sender As Object, ByVal e As GridViewSortEventArgs)
        Dim dv As DataView = New DataView()
        dv.Table = Session("Filters")
        dv.Sort = e.SortExpression
        FilterGrid.DataSource = dv
        FilterGrid.DataBind()
    End Sub

    Protected Sub SaveButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles SaveButt.Click
        Dim columnValues As String
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        If UpdFunction.Value = "Add" Then
            columnValues = " '" + ProcessUpd.Text + "' "
            columnValues += ", '" + StepList.SelectedValue + "' "
            columnValues += ", " + RunOrderUpd.Text + " "
            columnValues += ", SYSTEM_USER, getdate()"
            command2.CommandText = "insert into ADProcessConfig (ProcessCode, StepCode, RunOrder, EnteredID, EnteredDate) values (" + columnValues + ")"
            command2.ExecuteNonQuery()
            command2.CommandText = ""
            BindStepData(ProcessUpd.Text)
            DetailPanel.Visible = True
        Else
            columnValues = " ProcessCode = '" + ProcessUpd.Text + "' "
            columnValues += ", StepCode = '" + StepList.SelectedValue + "' "
            columnValues += ", RunOrder = " + RunOrderUpd.Text + " "
            columnValues += ", ChangedID = SYSTEM_USER"
            columnValues += ", ChangedDate = getdate()"
            command2.CommandText = "update ADProcessConfig set " + columnValues + " where ProcessRecID = " + HiddenID.Value
            command2.ExecuteNonQuery()
            BindStepData(ProcessFilter.SelectedValue)
            DetailPanel.Visible = True
            PageFunc.Value = "Find"
        End If
        cn2.Close()
    End Sub

    Protected Sub DoneButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles DoneButt.Click
        UpdFunction.Value = "Add"
        PageFunc.Value = "Find"
        UpdPanel.Visible = False
        DetailPanel.Height = 380
    End Sub

    Protected Sub HandleTree(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim Treevalues() As String
        Treevalues = TreeView1.SelectedNode.Value.Split(",")
        Select Case Treevalues(0)
            Case "Process"
                HiddenID.Value = Treevalues(1)
                ProcessUpd.Text = Treevalues(2)
                ProcessUpd.ReadOnly = True
                StepList.SelectedValue = Treevalues(3)
                StepList.Focus()
                RunOrderUpd.Text = Treevalues(4)
                UpdFunction.Value = "Upd"
                PageFunc.Value = "Upd"
                UpdPanel.Visible = True
                DetailPanel.Height = 275
        End Select

    End Sub

    Sub ShowTree(ByVal TreeProcess As String)
        Dim tcn, tcn2, tcn3, tcn4 As New System.Data.SqlClient.SqlConnection
        Dim tcommand, tcommand2, tcommand3, tcommand4 As New System.Data.SqlClient.SqlCommand
        Dim trs, trs2, trs3, trs4 As System.Data.SqlClient.SqlDataReader
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
        tcommand2.CommandText = "Select * from ADProcessConfig where ProcessCode = '" & TreeProcess & "' order by ProcessCode,RunOrder"
        trs2 = tcommand2.ExecuteReader()
        If trs2.HasRows Then
            TreePanel.Visible = True
            Do While trs2.Read()
                Dim CurNode1 As TreeNode = New TreeNode
                CurStep = "<B>" & trs2("RunOrder") & "</B>  StepCode:<B>" & trs2("StepCode") & "</B>"
                CurNode1.SelectAction = TreeNodeSelectAction.SelectExpand
                CurNode1.Text = CurStep
                CurNode1.Value = "Process," & CStr(trs2("ProcessRecID")) & "," & trs2("ProcessCode") & "," & trs2("StepCode") & "," & CStr(trs2("RunOrder"))
                TreeView1.Nodes.Add(CurNode1)
                tcommand3.CommandText = "Select * from ADStepConfig where StepCode = '" & trs2("StepCode") & "'"
                trs3 = tcommand3.ExecuteReader()
                If trs3.HasRows Then
                    Do While trs3.Read()
                        Dim CurNode2 As TreeNode = New TreeNode
                        CurDetail = "Hub:<B>" & trs3("HubBranch") & "</B> CFVCs:<B>" & trs3("VelocityCodes") & "</B>  ROP Mult.:<B>" & trs3("HubROPFactor") & "</B>"
                        CurNode2.SelectAction = TreeNodeSelectAction.None
                        CurNode2.Text = CurDetail
                        CurNode2.Value = "StepConfig," & trs3("StepCode")
                        TreeView1.Nodes(level1).ChildNodes.Add(CurNode2)
                        level2 += 1
                    Loop
                End If
                trs3.Close()
                tcommand3.CommandText = "Select * from ADStepDetail where StepCode = '" & trs2("StepCode") & "'"
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
                        End If
                        trs4.Close()
                        level2 += 1
                        level3 = 0
                    Loop
                End If
                trs3.Close()
                TreeView1.Nodes(level1).Expand()
                level1 += 1
                level2 = 0
            Loop
        End If
        trs2.Close()
        tcn2.Close()
        tcn3.Close()
        tcn4.Close()
        'TreeView1.ExpandDepth = "FullyExpand"
    End Sub

End Class
