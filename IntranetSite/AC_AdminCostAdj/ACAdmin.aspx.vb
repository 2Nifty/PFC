
Partial Class ACAdmin
    Inherits System.Web.UI.Page
    Dim cn As New System.Data.SqlClient.SqlConnection
    Dim command As New System.Data.SqlClient.SqlCommand
    Dim PFCDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("ACAdminAdj")
    Public SelectString As String
    'ExcpLmtDate.Focus()
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim currentdate As String
        'If Now.DayOfWeek = 1 Then
        '    currentdate = DateAdd(DateInterval.Day, -2, Now.Date)
        'Else
        '    currentdate = DateAdd(DateInterval.Day, -1, Now.Date)
        'End If
        lblMessage.Text = ""
        Dim rs
        cn.ConnectionString = PFCDB.ConnectionString
        cn.Open()
        command.Connection = cn
        SelectString = "Select max(curDate) as currentdate from AvgCstExceptionLog"

        'SelectString = SelectString & "WHERE GroupNo = " & GroupToUse.Value
        command.CommandText = SelectString
        rs = command.ExecuteReader
        If rs.HasRows Then
            Do While rs.Read
                currentdate = rs("currentdate")
            Loop
        End If
        rs.Close()
        cn.Close()

       
        Session("Auth") = System.Web.HttpContext.Current.Session("UserName")
     
        If ExcpLmtDate.Text = "" Then
            Session("LmtDt") = currentdate ' Set base exception Date
            ExcpLmtDate.Text = Session("LmtDt").ToString ' Set base exception Date
        Else
            Session("LmtDt") = ExcpLmtDate.Text ' Set updated exception Date
        End If
        If EffectiveDt.Text = "" Then
            Session("EffDt") = Now.Date ' Establish Effective date
            Dim dispdate As Date
            dispdate = Session("EffDt")
            Dim datestring As String
            Dim datePatt As String = "M/d/yyyy"
            datestring = dispdate.ToString(datePatt)
            EffectiveDt.Text = datestring ' Establish Effective date
            'EffectiveDt.Text = Session("EffDt").ToString ' Establish Effective date
        Else
            Session("EffDt") = EffectiveDt.Text ' Establish Updated Effective date

        End If
    End Sub
    ' Save User entry in session variables
    Protected Sub ExcpLmtDate_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExcpLmtDate.TextChanged

        If ExcpLmtDate.Text <> "" Then
            Try
                Convert.ToDateTime(ExcpLmtDate.Text)
                Session("LmtDt") = Convert.ToDateTime(ExcpLmtDate.Text).ToShortDateString()
                If hidValue.Value <> "" Then
                    ScriptManager.RegisterClientScriptBlock(ExcpLmtDate, GetType(TextBox), "ExcpLmtDate", "Loadreport();", True)
                Else
                    hidValue.Value = ""
                End If

            Catch ex As Exception
                lblMessage.Text = " Invalid Date"
                ExcpLmtDate.Focus()
            End Try

        End If

    End Sub

    'Protected Sub Author_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Author.TextChanged
    '    Session("Auth") = Author.Text
    'End Sub

    Protected Sub EffectiveDt_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles EffectiveDt.TextChanged
        If EffectiveDt.Text <> "" Then
            Try
                If Convert.ToDateTime(EffectiveDt.Text).CompareTo(Convert.ToDateTime(System.DateTime.Now.ToShortDateString())) = 1 OrElse Convert.ToDateTime(EffectiveDt.Text).CompareTo(Convert.ToDateTime(System.DateTime.Now.ToShortDateString())) = 0 Then
                    Session("EffDt") = EffectiveDt.Text
                    If hidValue.Value <> "" Then
                        ScriptManager.RegisterClientScriptBlock(EffectiveDt, GetType(TextBox), "EffectiveDt", "Loadreport();", True)
                    Else
                        hidValue.Value = ""

                    End If


                Else
                    lblMessage.Text = " Invalid Effective Date"
                    EffectiveDt.Focus()
                End If
            Catch ex As Exception
                lblMessage.Text = " Invalid Effective Date"
                EffectiveDt.Focus()

            End Try

        End If


    End Sub


End Class

