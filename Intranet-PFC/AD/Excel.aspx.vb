
Partial Class Excel
    Inherits System.Web.UI.Page
    Dim ResultsFolder As String = ConfigurationManager.AppSettings.Item("ResultsFolder")
    Dim ResultsFileName As String = ConfigurationManager.AppSettings.Item("ResultsFileName")
    Dim HungryFileName As String = ConfigurationManager.AppSettings.Item("HungryFileName")

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        ResultsButt.PostBackUrl = "file:" & ResultsFolder & ResultsFileName
        HungerButt.PostBackUrl = "file:" & ResultsFolder & HungryFileName

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

        End If

    End Sub
End Class
