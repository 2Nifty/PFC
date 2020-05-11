
Partial Class _MaintItemCard
    Inherits System.Web.UI.Page
    Dim SqlDataSource As New System.Data.SqlClient.SqlConnection("Data Source=EnterpriseSQL;Initial Catalog=PFCLive;Persist Security Info=True;User ID=pfcnormal;Password=pfcnormal")
    Dim cmd As New System.Data.SqlClient.SqlCommand
    Dim rs As System.Data.SqlClient.SqlDataReader
    Public ExportFile As String

    Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnNext.Click
        rsRead()
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnUpdate.Click

        If iCorpCode.Text = "" Then
            iCorpCode.Text = sCorpCode.Text
        End If

        cmd.CommandText = "UPDATE [Porteous$Item] SET "
        cmd.CommandText = cmd.CommandText & "[Corp Fixed Velocity Code]='" & UCase(iCorpCode.Text) & "'"
        cmd.CommandText = cmd.CommandText & ", [Pallet Partner Flag]='" & iPPFlagDD.Text & "'"
        cmd.CommandText = cmd.CommandText & ", [Web Enabled]='" & iWebFlagDD.Text & "'"
        cmd.CommandText = cmd.CommandText & "WHERE ([No_] = '" & lblItemNo.Text & "')"
        cmd.Connection = SqlDataSource
        SqlDataSource.Open()
        cmd.ExecuteNonQuery()
        SqlDataSource.Close()

        rsRead()

        txtItemNo.Focus()

    End Sub

    Public Sub rsRead()

        If txtItemNo.Text = "" Then
            txtItemNo.Text = lblItemNo.Text
        End If

        cmd.CommandText = "SELECT [No_], [Description], [Base Unit of Measure], [Plating Type], [Web Enabled], [Corp Fixed Velocity Code], [Pallet Partner Flag] FROM [Porteous$Item] WHERE ([No_] = '" & txtItemNo.Text & "')"
        cmd.Connection = SqlDataSource
        SqlDataSource.Open()
        rs = cmd.ExecuteReader

        If rs.HasRows Then
            While rs.Read()
                lblItemNo.Text = rs("No_").ToString()
                lblItemDesc.Text = rs("Description").ToString()
                lblBaseUOM.Text = rs("Base Unit Of Measure").ToString()
                lblPlate.Text = rs("Plating Type").ToString()
                sCorpCode.Text = rs("Corp Fixed Velocity Code").ToString()
                If rs("Pallet Partner Flag") = "1" Then
                    sPPFlag.Text = "True"
                Else
                    sPPFlag.Text = "False"
                End If
                If rs("Web Enabled") = "1" Then
                    sWebFlag.Text = "True"
                Else
                    sWebFlag.Text = "False"
                End If
                iCorpCode.Text = ""
                iPPFlagDD.Text = rs("Pallet Partner Flag")
                iWebFlagDD.Text = rs("Web Enabled")
                iCorpCode.Focus()
            End While
        Else
            lblItemNo.Text = txtItemNo.Text
            lblItemDesc.Text = "Item Not On File"
            lblBaseUOM.Text = ""
            lblPlate.Text = ""
            sCorpCode.Text = ""
            sPPFlag.Text = ""
            sWebFlag.Text = ""
            iCorpCode.Text = ""
            iPPFlagDD.Text = ""
            iWebFlagDD.Text = ""
            txtItemNo.Focus()
        End If

        txtItemNo.Text = ""

        rs.Close()
        SqlDataSource.Close()

    End Sub

End Class