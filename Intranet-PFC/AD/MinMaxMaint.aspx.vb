Imports System.Data

Partial Class MinMaxMaint
    Inherits System.Web.UI.Page
    Dim ReportsDB As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("PFCReportsConnectionString")
    Dim cn, cn2, cn3, cn4 As New System.Data.SqlClient.SqlConnection
    Dim command, command2, command3, command4 As New System.Data.SqlClient.SqlCommand
    Dim rs, rs2, rs3, rs4 As System.Data.SqlClient.SqlDataReader

    Sub BindMinMaxData(ByVal MinMaxCode As String)
        Dim WhereStr As String = ""
        If MinMaxCode <> "" Then
            WhereStr = " where MinMaxCode = '" & MinMaxCode & "'"
        End If
        cn3.ConnectionString = ReportsDB.ConnectionString
        cn3.Open()
        command3.Connection = cn3
        command3.CommandText = "SELECT * FROM ADMinMax " & WhereStr & " ORDER BY MinMaxCode, IsHub, SVCRange"
        rs3 = command3.ExecuteReader
        MinMaxGrid.DataSource = rs3
        MinMaxGrid.DataBind()
        cn3.Close()
    End Sub

    Sub BindDependentData(ByVal MinMaxCode As String)
        cn3.ConnectionString = ReportsDB.ConnectionString
        cn3.Open()
        command3.Connection = cn3
        command3.CommandText = "select distinct StepCode from ADStepDetail where MinMaxCode = '" + MinMaxCode + "' "
        rs3 = command3.ExecuteReader
        DependentGrid.DataSource = rs3
        DependentGrid.DataBind()
        cn3.Close()
    End Sub

    Protected Sub EditHandler(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        Dim row As GridViewRow = MinMaxGrid.Rows(e.NewEditIndex)
        HiddenID.Value = row.Cells(row.Cells.Count - 1).Text
        MinMaxUpd.Text = row.Cells(1).Text
        MinMaxUpd.Focus()
        SVCUpd.Text = row.Cells(2).Text.Trim
        IsHubBox.Text = row.Cells(3).Text
        MinFactorBox.Text = row.Cells(4).Text
        MaxFactorBox.Text = row.Cells(5).Text
        UpdFunction.Value = "Upd"
    End Sub

    Sub DeleteHandler(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Dim row As GridViewRow = MinMaxGrid.Rows(e.RowIndex)
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "delete from ADMinMax where pADMinMaxID = " + row.Cells(row.Cells.Count - 1).Text + " "
        command2.ExecuteNonQuery()
        lblSuccessMessage.Text = "Detail record " & row.Cells(row.Cells.Count - 1).Text & " has been deleted."
        BindMinMaxData(MinMaxFilter.SelectedValue)
    End Sub

    Protected Sub SaveButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles SaveButt.Click
        Dim columnValues As String
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        If UpdFunction.Value = "Add" Then
            columnValues = " '" + MinMaxUpd.Text + "' "
            columnValues += ", '" + SVCUpd.Text + "' "
            columnValues += ", " + IsHubBox.Text + " "
            columnValues += ", " + MinFactorBox.Text + " "
            columnValues += ", " + MaxFactorBox.Text + " "
            command2.CommandText = "insert into ADMinMax (MinMaxCode, SVCRange, IsHub, MinFactor, MaxFactor) values (" + columnValues + ")"
            command2.ExecuteNonQuery()
            lblSuccessMessage.Text = "Record added."
            BindMinMaxData("")
        Else
            columnValues = " MinMaxCode = '" + MinMaxUpd.Text + "' "
            columnValues += ", SVCRange = '" + SVCUpd.Text + "' "
            columnValues += ", IsHub = " + IsHubBox.Text + " "
            columnValues += ", MinFactor = " + MinFactorBox.Text + " "
            columnValues += ", MaxFactor = " + MaxFactorBox.Text + " "
            command2.CommandText = "update ADMinMax set " + columnValues + " where pADMinMaxID = " + HiddenID.Value
            command2.ExecuteNonQuery()
            lblSuccessMessage.Text = "Record updated."
            BindMinMaxData(MinMaxUpd.Text)
        End If
        MinMaxFilter.DataBind()
        command2.CommandText = ""
        cn2.Close()
    End Sub

    Protected Sub FindButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles FindButt.Click
        PageFunc.Value = "Find"
        cn2.ConnectionString = ReportsDB.ConnectionString
        cn2.Open()
        command2.Connection = cn2
        command2.CommandText = "select * from ADMinMax where MinMaxCode = '" + MinMaxFilter.SelectedValue + "' "
        command2.ExecuteNonQuery()
        rs2 = command2.ExecuteReader
        If rs2.HasRows Then
            rs2.Read()
            MinMaxUpd.Text = rs2("MinMaxCode")
            SVCUpd.Text = rs2("SVCRange")
            IsHubBox.Text = rs2("IsHub")
            MinFactorBox.Text = rs2("MinFactor")
            MaxFactorBox.Text = rs2("MaxFactor")
            HiddenID.Value = rs2("pADMinMaxID")
            BindMinMaxData(MinMaxFilter.SelectedValue)
            BindDependentData(MinMaxFilter.SelectedValue)
        End If
        cn2.Close()

    End Sub

    Protected Sub AddButt_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles AddButt.Click
        UpdFunction.Value = "Add"
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindMinMaxData("")
        End If
    End Sub
End Class
