
Partial Class _Default
    Inherits System.Web.UI.Page
    Dim ReportsDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCReportsConnectionString")
    Dim cn, cn2, cn3, cn4 As New System.Data.SqlClient.SqlConnection
    Dim command, command2, command3, command4 As New System.Data.SqlClient.SqlCommand
    Dim rs, rs2, rs3, rs4 As System.Data.SqlClient.SqlDataReader
    Dim level0, level1, level2, level3 As Integer
    Dim CurProcess, CurStep, CurDetail, CurMM As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsPostBack Then
        Else
            'ShowTree()
            'Server.Execute("file:\\pfcrnd\lib\ad\results.xls", False)
            raiseevent ExcelButt.Click()
        End If

    End Sub

    Sub ShowTree()
        cn.ConnectionString = ReportsDB.ConnectionString
        cn.Open()
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        cn3.ConnectionString = ReportsDB.ConnectionString
        cn3.Open()
        cn4.ConnectionString = ReportsDB.ConnectionString
        cn4.Open()
        command.Connection = cn
        command2.Connection = cn2
        command3.Connection = cn3
        command4.Connection = cn4
        ' get the detail data
        command.CommandText = "Select distinct ProcessCode from ADProcessConfig order by ProcessCode"
        'RunTextBox.Text += SQLCommand & vbCrLf
        rs = command.ExecuteReader()
        level0 = 0
        level1 = 0
        level2 = 0
        CurProcess = ""
        CurStep = ""
        CurDetail = ""
        TreeView1.Nodes.Clear()
        If rs.HasRows Then
            Do While rs.Read()
                Dim CurNode0 As TreeNode = New TreeNode
                CurProcess = rs("ProcessCode")
                CurNode0.SelectAction = TreeNodeSelectAction.SelectExpand
                CurNode0.Text = CurProcess
                CurNode0.Value = CurProcess
                TreeView1.Nodes.Add(CurNode0)
                command2.CommandText = "Select * from ADProcessConfig where ProcessCode = '" & CurProcess & "' order by ProcessCode,RunOrder"
                rs2 = command2.ExecuteReader()
                If rs2.HasRows Then
                    Do While rs2.Read()
                        Dim CurNode1 As TreeNode = New TreeNode
                        CurStep = "<B>" & rs2("RunOrder") & "</B>  StepCode:<B>" & rs2("StepCode") & "</B>"
                        CurNode1.SelectAction = TreeNodeSelectAction.SelectExpand
                        CurNode1.Text = CurStep
                        CurNode1.Value = rs2("StepCode")
                        TreeView1.Nodes(level0).ChildNodes.Add(CurNode1)
                        command3.CommandText = "Select * from ADStepConfig where StepCode = '" & rs2("StepCode") & "'"
                        rs3 = command3.ExecuteReader()
                        If rs3.HasRows Then
                            Do While rs3.Read()
                                Dim CurNode2 As TreeNode = New TreeNode
                                CurDetail = "Hub:<B>" & rs3("HubBranch") & "</B> CFVCs:<B>" & rs3("VelocityCodes") & "</B>"
                                CurNode2.SelectAction = TreeNodeSelectAction.SelectExpand
                                CurNode2.Text = CurDetail
                                CurNode2.Value = rs3("StepCode")
                                TreeView1.Nodes(level0).ChildNodes(level1).ChildNodes.Add(New TreeNode(CurDetail))
                                level2 += 1
                            Loop
                        End If
                        rs3.Close()
                        command3.CommandText = "Select * from ADStepDetail where StepCode = '" & rs2("StepCode") & "'"
                        rs3 = command3.ExecuteReader()
                        If rs3.HasRows Then
                            Do While rs3.Read()
                                Dim CurNode2 As TreeNode = New TreeNode
                                If rs3("StepIsHub") Then
                                    CurDetail = "Hubs:<B>" & rs3("Branches") & "</B> MM:<B>" & rs3("MinMaxCode") & "</B>"
                                Else
                                    CurDetail = "Sats:<B>" & rs3("Branches") & "</B> MM:<B>" & rs3("MinMaxCode") & "</B>"
                                End If
                                CurNode2.SelectAction = TreeNodeSelectAction.SelectExpand
                                CurNode2.Text = CurDetail
                                CurNode2.Value = rs3("StepCode") & "," & CStr(rs3("StepIsHub"))
                                TreeView1.Nodes(level0).ChildNodes(level1).ChildNodes.Add(CurNode2)
                                command4.CommandText = "Select * from ADMinMax where MinMaxCode = '" & rs3("MinMaxCode") & "' and IsHub = " & rs3("StepIsHub")
                                rs4 = command4.ExecuteReader()
                                If rs4.HasRows Then
                                    Do While rs4.Read()
                                        Dim CurNode3 As TreeNode = New TreeNode
                                        CurMM = " SVCs:<B>" & rs4("SVCRange") & "</B>  Min:<B>" & CStr(rs4("MinFactor")) & "</B>  Max:<B>" & CStr(rs4("MaxFactor")) & "</B>"
                                        CurNode3.SelectAction = TreeNodeSelectAction.SelectExpand
                                        CurNode3.Text = CurMM
                                        CurNode3.Value = rs4("MinMaxCode") & "," & CStr(rs4("IsHub"))
                                        TreeView1.Nodes(level0).ChildNodes(level1).ChildNodes(level2).ChildNodes.Add(New TreeNode(CurMM))
                                        level3 += 1
                                    Loop
                                End If
                                rs4.Close()
                                level2 += 1
                                level3 = 0
                            Loop
                        End If
                        rs3.Close()
                        level1 += 1
                        level2 = 0
                        level3 = 0
                    Loop
                End If
                rs2.Close()
                level0 += 1
                level1 = 0
                level2 = 0
                level3 = 0
                'If rs("StepCode") <> CurStep Then
                '    TreeView1.Nodes(level0).ChildNodes.Add(New TreeNode(rs("StepCode")))
                '    CurStep = rs("StepCode")
                'End If
            Loop
        End If
        rs.Close()
        cn.Close()
        cn2.Close()
        cn3.Close()
        cn4.Close()
    End Sub

    'Protected Sub TreeView1_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TreeView1.SelectedNodeChanged
    '    Label1.Text = TreeView1.SelectedNode.Text
    'End Sub

    Protected Sub HandleTree(ByVal sender As Object, ByVal e As System.EventArgs)
        Label1.Text = TreeView1.SelectedNode.Text
    End Sub

    Protected Sub TreeView1_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs) Handles TreeView1.DataBinding

    End Sub

    Protected Sub TreeView1_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles TreeView1.DataBound

    End Sub

    Protected Sub TreeView1_TreeNodeCollapsed(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles TreeView1.TreeNodeCollapsed

    End Sub

    Protected Sub TreeView1_TreeNodeExpanded(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles TreeView1.TreeNodeExpanded

    End Sub

End Class