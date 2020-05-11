
Partial Class ExcelTop
    Inherits System.Web.UI.Page
    Dim xl As Excel.Application
    Dim CurWindow As Excel.Window
    Dim CurSheet As Excel.Worksheet
    Dim CurWorkBooks As Excel.Workbooks

    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click
        CurWorkBooks = xl.Workbooks.Open("SCC200702141636.xls")
        'CurWindow = Excel.Window.open("SCC200702141636.xls")
    End Sub
End Class
