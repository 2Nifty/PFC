Imports System.Data



Partial Class Exceptions
    Inherits System.Web.UI.Page
    Dim cn, cn2 As New System.Data.SqlClient.SqlConnection
    Dim command, command2 As New System.Data.SqlClient.SqlCommand
    Dim PFCDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("ACAdminAdj")
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile, Resolve, EXIDU As String
    Public NewInd As Int16
    Dim dataAdapter As System.Data.SqlClient.SqlDataAdapter
    Dim dsHeaderValue As DataSet
    Dim rowIndex As Int32
    Dim LimitDate As String

    ''' <summary>
    ''' Page_Load : event handlers
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        lblMessage.Text = ""
        lblLossCaption.Visible = False
        lblLossValue.Visible = False

        lblLossCaption.Text = "Find/<&nbsp;Loss>:"
        LimitDate = Session("LmtDt").ToString
        ExcpDate.Text = LimitDate
        ViewState.Add("newi", NewInd.ToString)
        If IsPostBack <> True Then
            SelResolutionDropDownList.Focus()
            GetHeadValue()
            rowIndex = 0
            BindPagerDropdown()
        Else
            dsHeaderValue = CType(Session("HeaderValue"), DataSet)
        End If

    End Sub
 
    ''' <summary>
    ''' Resolution dropdown onchange event handler
    ''' </summary>
    ''' <param name="sender">Object</param>
    ''' <param name="e">EventArg</param>
    ''' <remarks></remarks>
    Protected Sub SelResolutionDropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SelResolutionDropDownList.SelectedIndexChanged
        Try
            lblLossValue.Text = ""
            lblLossCaption.Visible = False
            lblLossValue.Visible = False

            Resolve = SelResolutionDropDownList.Text
            Dim row As DataRow = dsHeaderValue.Tables(0).Rows(ddlPages.SelectedIndex)
            If SelResolutionDropDownList.Text = "REVERSE" Then
                NewAC.Text = row(4) ' Reverse
            ElseIf SelResolutionDropDownList.Text = "ACCEPT" Then
                NewAC.Text = row(6)
            ElseIf SelResolutionDropDownList.Text = "ADMINADJ" Then
                NewAC.Text = row(6)

                NewAC.Focus()
            End If
            NewAC_TextChanged(SelResolutionDropDownList, New System.EventArgs)
        Catch ex As Exception

        End Try

    End Sub
    ''' <summary>
    ''' ok button click event handler : to updated based on mode
    ''' </summary>
    ''' <param name="sender">Object</param>
    ''' <param name="e">EventArg</param>
    ''' <remarks></remarks>
    Protected Sub OK_Excp_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles OK_Excp.Click
        Try
            Dim datarows As DataRow
            If (dsHeaderValue IsNot Nothing AndAlso dsHeaderValue.Tables(0).Rows.Count > 0) Then
                datarows = dsHeaderValue.Tables(0).Rows(ddlPages.SelectedIndex)
            End If

            Resolve = SelResolutionDropDownList.Text
            Dim newi As String = ViewState("newi").ToString
            If ddlPages.Items.Count > 0 Then
                EXIDU = datarows(7)
            Else
                EXIDU = ""
            End If
            Dim status As Boolean
            status = True
            If newi.ToString <> "1" Then ' Update Exception unless we are creating an adjustment not related to and exception
                txtAveCost.Text = NewAC.Text
                SqlHeaderlData.UpdateCommand = "UPDATE AvgCstExceptionLog SET Resolution = '" & Resolve.ToString & "', NewAC = '" & NewAC.Text & "', ChangeDt = GetDate(), ChangeID = '" & Session("UserName").ToString & "' WHERE pExceptionID = '" & EXIDU & "'"
                SqlHeaderlData.Update()

            Else
                NewInd = 0
                ViewState.Add("newi", NewInd.ToString)
            End If
          

            If Resolve = "ADMINADJ" Or Resolve = "REVERSE" Then
                If ValidateItemNumber(txtItem.Text) = True Then
                    SqlHeaderlData.InsertCommand = "INSERT INTO AvgCst_AdminAdj (Effective_Date, Branch, ItemNo, NewCst, ReasonCode, ReferenceNo, Entry_Date, Entry_ID,FindOrLoss) VALUES ('" & Session("EffDt").ToString & "', '" & txtLoc.Text & "','" & txtItem.Text & "','" & txtAveCost.Text & "','" & Resolve & "','" & Session("UserName").ToString & "',Getdate(),'" & Session("UserName").ToString & "','" & lblLossValue.Text & "')"
                    SqlHeaderlData.Insert()
                    status = True
                Else
                    status = False
                End If
            End If
                If status = True Then
                    ClearControl()
                    SelResolutionDropDownList.Enabled = True
                    SelResolutionDropDownList.SelectedIndex = (0)
                    tblEdit.Style.Add(HtmlTextWriterStyle.Display, "")
                    tblAdd.Style.Add(HtmlTextWriterStyle.Display, "none")
                    tblPager.Style.Add(HtmlTextWriterStyle.Display, "")
                    ReceivingHist.Style.Add(HtmlTextWriterStyle.Display, "")
                    gridHeaders.Style.Add(HtmlTextWriterStyle.Display, "")
                    GetHeadValue()
                    BindPagerDropdown()
            End If
            SelResolutionDropDownList.Enabled = True
            SelResolutionDropDownList.SelectedIndex = (0)
        Catch ex As Exception

        End Try
       


    End Sub

    ''' <summary>
    ''' New button click event handler : to change Add mode
    ''' </summary>
    ''' <param name="sender">Object</param>
    ''' <param name="e">EventArg</param>
    ''' <remarks></remarks>
    Protected Sub NewAdj_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles NewAdj.Click

        tblEdit.Style.Add(HtmlTextWriterStyle.Display, "none")
        tblAdd.Style.Add(HtmlTextWriterStyle.Display, "")
        tblPager.Style.Add(HtmlTextWriterStyle.Display, "none")
        ReceivingHist.Style.Add(HtmlTextWriterStyle.Display, "none")
        gridHeaders.Style.Add(HtmlTextWriterStyle.Display, "none")

        ClearControl()
       
        SelResolutionDropDownList.SelectedIndex = (1)
        SelResolutionDropDownList.Enabled = False
        ExcpLoc.Focus()
        NewInd = 1
        ViewState.Add("newi", NewInd.ToString)
        Dim newi As String = ViewState("newi").ToString
    End Sub
    ''' <summary>
    ''' Pager Previous button click event : to fill Previous record
    ''' </summary>
    ''' <param name="sender">Object</param>
    ''' <param name="e">EventArg</param>
    ''' <remarks></remarks>
    Protected Sub ibtnPrevious_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)

        If (ddlPages.SelectedIndex = 0) Then

        Else
            ddlPages.SelectedIndex = ddlPages.SelectedIndex - 1
            BindPageDetails()
        End If
    End Sub
    ''' <summary>
    ''' Pager first button click event : to fill first record
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub ibtnFirst_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Try
            ddlPages.SelectedIndex = 0
            BindPageDetails()
        Catch ex As Exception

        End Try
        

    End Sub
    ''' <summary>
    ''' Pager next button click event : to fill next record
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)

        If ddlPages.SelectedIndex <> ddlPages.Items.Count - 1 Then
            ddlPages.SelectedIndex = ddlPages.SelectedIndex + 1
            BindPageDetails()
        End If


    End Sub
    ''' <summary>
    '''  Pager   button click event : to fill last record
    ''' </summary>
    ''' <param name="sender">Object</param>
    ''' <param name="e">EventArg</param>
    ''' <remarks></remarks>
    Protected Sub btnLast_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)

        ddlPages.SelectedIndex = ddlPages.Items.Count - 1
        BindPageDetails()


    End Sub
    ''' <summary>
    ''' Pager go button click event : to fill record based on enterd value
    ''' </summary>
    ''' <param name="sender">Object</param>
    ''' <param name="e">EventArg</param>
    ''' <remarks></remarks>
    Protected Sub btnGo_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        If (ddlPages.SelectedIndex > 0) Then
            lblMessage.Text = ""

            If (Convert.ToInt32(txtGotoPage.Text.Trim()) >= 1 AndAlso Convert.ToInt32(txtGotoPage.Text.Trim()) <= ddlPages.Items.Count) Then
                ddlPages.SelectedIndex = Convert.ToInt32(txtGotoPage.Text.Trim()) - 1
                BindPageDetails()
            Else
                lblMessage.ForeColor = System.Drawing.Color.FromName("#CC0000")
                lblMessage.Text = "Invalid Page #"

            End If
        End If

    End Sub
    ''' <summary>
    ''' Pager Dropdown onchange event handler : to bind header a nd child
    ''' </summary>
    ''' <param name="sender">Object</param>
    ''' <param name="e">EventArg</param>
    ''' <remarks></remarks>
    Protected Sub ddlPages_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        BindPageDetails()
    End Sub
    ''' <summary>
    ''' BindPagerDropdown : Method used to bind Pager dropdown
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub BindPagerDropdown()

        ddlPages.Items.Clear()
        For count As Int32 = 0 To dsHeaderValue.Tables(0).Rows.Count - 1
            ddlPages.Items.Add(count + 1)
        Next count
        BindPageDetails()

    End Sub
    ''' <summary>
    ''' BindPageDetails : Method used to bind pager detail
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub BindPageDetails()
        lblLossValue.Text = ""
        lblLossCaption.Visible = False
        lblLossValue.Visible = False

        lblCurrentPageRecCount.Text = " " & (ddlPages.SelectedIndex + 1).ToString()
        lblTotalNoOfRec.Text = " " & ddlPages.Items.Count.ToString()
        lblCurrentPage.Text = " " & (ddlPages.SelectedIndex + 1).ToString()
        lblTotalPage.Text = " " & ddlPages.Items.Count.ToString()
        lblCurrentTotalRec.Text = " " & (ddlPages.SelectedIndex + 1).ToString()
        BindHeaderDetail()
    End Sub
    ''' <summary>
    ''' ClearControl : Method used to clear control
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ClearControl()

        txtAveCost.Text = ""
        txtItem.Text = ""
        txtLoc.Text = ""
    End Sub
    ''' <summary>
    ''' GetHeadValue : Method used to get Header detail from AvgCstExceptionLog
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub GetHeadValue()
        Try
            'SelectString = "SELECT CurDate AS Date, Location AS Loc, ItemNo AS [Item No], BegOH AS [Cur OH], BegAC AS [Cur AC], RecQty AS [Rec Qty], CalcAC AS [New AC], pExceptionID AS EXID FROM AvgCstExceptionLog WHERE (CurDate = CONVERT (DATETIME,'" & LimitDate & "')) AND Resolution IS NULL AND Location <> '99' ORDER BY Location, ItemNo, CurDate DESC"
            SelectString = "SELECT a.CurDate AS Date, a.Location AS Loc, a.ItemNo AS [Item No], a.BegOH AS [Cur OH], a.BegAC AS [Cur AC],a.RecQty AS [Rec Qty], a.CalcAC AS [New AC], a.pExceptionID AS EXID,b.BegQOH AS [AvgCstDlyBegOH],b.BegAC AS [AvgCstDlyBegAC] FROM AvgCstExceptionLog a,Avgcst_daily b  WHERE (a.CurDate = CONVERT (DATETIME,'" & LimitDate & "')) AND a.Resolution IS NULL AND a.Location <> '99' AND a.[ItemNo] =b.ItemNo and a.Location=b.Branch ORDER BY a.Location, a.ItemNo, a.CurDate DESC"

            dataAdapter = New System.Data.SqlClient.SqlDataAdapter(SelectString, PFCDB.ConnectionString)

            dsHeaderValue = New DataSet("Header")
            dataAdapter.Fill(dsHeaderValue)

            Session("HeaderValue") = dsHeaderValue
        Catch ex As Exception
            Response.Write(SelectString)
        End Try
        
    End Sub
    ''' <summary>
    ''' BindHeaderDetail : Method used to bing Header detail
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub BindHeaderDetail()
        If (dsHeaderValue IsNot Nothing AndAlso ddlPages.Items.Count > 0) Then
            Dim datarow As DataRow = dsHeaderValue.Tables(0).Rows(ddlPages.SelectedIndex)
            Dim getBranch As New PFC.Intranet.InventoryReconsiliation.InventoryReconsiliation()
            hidLoc.Value = datarow(1)
            ExcpLoc.Text = getBranch.GetBranchName(datarow(1).ToString)
            ExcpItem.Text = datarow(2)
            txtLoc.Text = datarow(1)
            txtItem.Text = datarow(2)
            lblRecptQuantity.Text = datarow(5)
            lblBegAC.Text = datarow(9)

            DisplayAvgCostDailyValues(ExcpItem.Text, hidLoc.Value)

            SelResolutionDropDownList.Enabled = True
            SelResolutionDropDownList.SelectedIndex = (0)

            If SelResolutionDropDownList.SelectedIndex = (2) Then
                NewAC.Text = datarow(4) ' Reverse
                txtAveCost.Text = datarow(4) ' Reverse
            ElseIf SelResolutionDropDownList.SelectedIndex = (1) Then
                NewAC.Text = datarow(6) ' Adjust
                txtAveCost.Text = datarow(6) ' Adjust
                NewAC.Focus()
            Else
                NewAC.Text = datarow(6) ' Accept
                txtAveCost.Text = datarow(6) ' Accept
            End If
        End If
        

    End Sub
    ''' <summary>
    ''' ValidateItemNumber : Method usedto validate PFC Item #
    ''' </summary>
    ''' <param name="strItem">PFc Item #</param>
    ''' <returns>Return Boolean Value </returns>
    ''' <remarks></remarks>
    Private Function ValidateItemNumber(ByVal strItem As String) As Boolean
        Dim utility As New GER.Utility()
        Dim status = utility.ValidatePFCItemNo(strItem)
        If strItem <> "" Then
            If status = "true" Then
                lblMessage.Text = ""
                Return True
            Else
                lblMessage.Text = "Invalid Item #"
                Return False
            End If
        End If

    End Function
    ''' <summary>
    ''' txtItem_TextChanged : Txt Item onchangeevent handler - 
    ''' </summary>
    ''' <param name="sender">Object</param>
    ''' <param name="e">EventArgs</param>
    ''' <remarks>Validate Item noremarks</remarks>
    Protected Sub txtItem_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
       
        ValidateItemNumber(txtItem.Text)

    End Sub

    Protected Sub btnFindLoss_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        

    End Sub

    Protected Sub NewAC_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If SelResolutionDropDownList.Text = "REVERSE" Or SelResolutionDropDownList.Text = "ADMINADJ" Then

            lblLossCaption.Visible = True
            lblLossValue.Visible = True

            Dim _findLoss As Decimal
            _findLoss = (Convert.ToDecimal(NewAC.Text) * lblcuronHand.Text) - (Convert.ToDecimal(lblcuronHand.Text) * Convert.ToDecimal(lblCurAvgCost.Text))
            lblLossValue.Text = Decimal.Round(_findLoss, 2)
            UpdatePanel1.Update()
        Else
            lblLossValue.Text = ""
            lblLossCaption.Visible = False
            lblLossValue.Visible = False
        End If

    End Sub

    Private Function DisplayAvgCostDailyValues(ByVal itemNumber As String, ByVal Branch As String)

        SelectString = "SELECT BegQOH ,BegAC  FROM Avgcst_daily  WHERE  Branch = '" & hidLoc.Value & "' AND [ItemNo] ='" & ExcpItem.Text.Trim() & "'"

        dataAdapter = New System.Data.SqlClient.SqlDataAdapter(SelectString, PFCDB.ConnectionString)
        Dim dsFindLoss As DataSet
        dsFindLoss = New DataSet()
        dataAdapter.Fill(dsFindLoss)
        Dim drFindLoss As DataRow = dsFindLoss.Tables(0).Rows(0)
        lblcuronHand.Text = drFindLoss("BegQOH").ToString()
        lblCurAvgCost.Text = drFindLoss("BegAC").ToString()

    End Function
End Class
