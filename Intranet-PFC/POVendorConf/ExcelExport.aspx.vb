
Partial Class ExcelExport
    Inherits System.Web.UI.Page
    Dim loop1, loop2 As Integer
    Public arr1(), arr2(), ExcelFile As String
    Dim coll As NameValueCollection

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Load Header collection into NameValueCollection object.
        coll = Request.QueryString
        ' Put the names of all keys into a string array.
        arr1 = coll.AllKeys
        For loop1 = 0 To arr1.GetUpperBound(0)
            'Response.Write("Key: " & arr1(loop1) & "<br>")
            arr2 = coll.GetValues(loop1)
            ' Get all values under this key.
            For loop2 = 0 To arr2.GetUpperBound(0)
                'Response.Write("Value " & CStr(loop2) & ": " & Server.HtmlEncode(arr2(loop2)) & "<br>")
                If arr1(loop1) = "Filename" And loop2 = 0 Then ExcelFile = Server.HtmlEncode(arr2(loop2))
            Next loop2
        Next loop1
    End Sub
End Class
