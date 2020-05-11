
Partial Class _Default
    Inherits System.Web.UI.Page
    Public SelectStr As String


    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        SearchPanel.Visible = True
        OpStatus.Text = "Enter BOL Information"
        BOLNumber.Focus()


    End Sub

    Protected Sub OK_BOL_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles OK_BOL.Click
        If BOLNumber.Text > "" Then
            SqlHeaderlData.InsertCommand = "INSERT INTO AvgCstPORecExpenses (BillofLadingNo,EntryDt, ToAllocWght, ToAllocAmt, EntryID) VALUES ('" & BOLNumber.Text & "','" & BOLDate.Text & "'," & WghtAmt.Text & "," & AmtAmt.Text & ",'WEB')"
            SqlHeaderlData.Insert()
            OpStatus.Text = "BOL Added"
            BOLNumber.Text = ""
            BOLDate.Text = ""
            WghtAmt.Text = ""
            AmtAmt.Text = ""
            BOLNumber.Focus()
        End If

    End Sub

    Protected Sub BOLNumber_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles BOLNumber.TextChanged
        SelectStr = "SELECT BillofLadingNo FROM AvgCstPORecExpenses WHERE BillofLadingNo = '" & BOLNumber.Text & "'"
        SqlHeaderlData.SelectCommand = SelectStr
        HeaderView.DataBind()
        If HeaderView.Rows.Count > 0 Then
            'HeaderGrid.DataBind()
            OpStatus.Text = "BOL Already Created"
            If BOLDate.Text <> "" Then
                BOLNumber.Text = ""
                BOLDate.Text = ""
                WghtAmt.Text = ""
                AmtAmt.Text = ""
                BOLNumber.Focus()
            End If
        Else
            OpStatus.Text = "Enter BOL Information."
            BOLDate.Focus()
        End If

    End Sub


    Protected Sub BOLDate_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles BOLDate.TextChanged

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub Del_BOL_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles Del_BOL.Click
        If BOLNumber.Text > "" Then
            SqlHeaderlData.DeleteCommand = "DELETE FROM AvgCstPORecExpenses WHERE BillofLadingNo = '" & BOLNumber.Text & "'"
            SqlHeaderlData.Delete()
            OpStatus.Text = "BOL Deleted"
            BOLNumber.Text = ""
            BOLNumber.Focus()

        End If

    End Sub
End Class
