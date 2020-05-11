
Partial Class AvgSellPrcBlkPreview
    Inherits System.Web.UI.Page

    Protected Sub CrystalReportViewer1_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles CrystalReportViewer1.Load
        If Not Page.IsPostBack Then
            ibtnClose.Attributes.Add("onclick", "javascript:window.location='" & Request.ServerVariables("HTTP_REFERER").ToString() & "'")
        End If
    End Sub
End Class
