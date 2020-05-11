Imports System
Imports System.IO


Partial Class _Default
    Inherits System.Web.UI.Page
    Public StatMessage, ExcelFileName As String

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        ExcelFileName = Literal1.Text
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsPostBack Then
            Dim path As String = Literal1.Text
            Dim fileOK As Boolean = False
            If FileUpload1.HasFile Then
                Dim fileExtension As String
                fileExtension = System.IO.Path. _
                    GetExtension(FileUpload1.FileName).ToLower()
                Dim allowedExtensions As String() = _
                    {".xls"}
                For i As Integer = 0 To allowedExtensions.Length - 1
                    If fileExtension = allowedExtensions(i) Then
                        fileOK = True
                    End If
                Next
                If fileOK Then
                    Try
                        FileUpload1.PostedFile.SaveAs(path & _
                             FileUpload1.FileName)
                        Label1.Text = "File uploaded!"
                    Catch ex As Exception
                        Label1.Text = "File could not be uploaded."
                    End Try
                    Server.Transfer("VMIImport.aspx?xls=" & FileUpload1.FileName, True)
                    'FileUpload1.Dispose()
                Else
                    Label1.Text = "Cannot accept files of this type."
                End If
            End If
        End If
        'ExcelFileName = Literal1.Text
        'ExcelFileName = ""
        ' Create a reference to the directory.
        Dim di As New DirectoryInfo(Literal1.Text)
        ' Create an array representing the files in the  directory.
        Dim fi As FileInfo() = di.GetFiles("*.xls")
        Dim fiTemp As FileInfo
        Dim ctr As Integer
        ctr = 0
        'dscol.ColumnName = "Name"
        For Each fiTemp In fi
            Dim DetailRow As New TableRow()
            ctr = ctr + 1
            Dim DetailCell1, DetailCell2, DetailCell3, DetailCell4, DetailCell5, DetailCell6, DetailCell7 As New TableCell()
            Dim IgnoreBox As New CheckBox
            Dim NewButton As New Button
            Dim CellLiteral1, CellLiteral2 As New Literal
            NewButton.Text = "Review"
            NewButton.ID = "Contract" & fiTemp.Name
            NewButton.Width = 50
            NewButton.ToolTip = "Click To PREVIEW CONTRACT PRIOR TO UPDATING"
            NewButton.PostBackUrl = "VMIImport.aspx"
            'NewButton.CssClass = "LeftPadding"
            NewButton.BorderStyle = BorderStyle.None
            NewButton.ForeColor = Drawing.Color.Black
            NewButton.BackColor = Drawing.Color.White

            NewButton.Font.Underline = True
            'newbutton.
            DetailCell1.HorizontalAlign = HorizontalAlign.Left
            DetailCell1.Controls.Add(NewButton)
            CellLiteral1.Text = fiTemp.Name
            DetailCell1.Controls.Add(CellLiteral1)
            DetailRow.Cells.Add(DetailCell1)
            DetailCell2.Text = fiTemp.LastWriteTime
            DetailRow.Cells.Add(DetailCell2)
            DetailRow.HorizontalAlign = HorizontalAlign.Left
            WorkTable.Rows.Add(DetailRow)

        Next fiTemp

    End Sub
End Class
