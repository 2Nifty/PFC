
Partial Class BudgetImport
    Inherits System.Web.UI.Page
    Public StatMessage, ExcelFileName As String
    Public LogonID, BegCat, EndCat, SelectString, UpdateString, CalcCount, ExportFile As String
    Public BadCount, z As Integer
    Public ConnectString, UserID As String
    Public LoadYear, LoadMonth As Integer
    Public ds As New System.Data.DataSet()
    Public LoadTable As Data.DataTable = New Data.DataTable("BudgetLines")


    Sub LoadIt()
        Dim cn2 As New System.Data.SqlClient.SqlConnection
        Dim command2 As New System.Data.SqlClient.SqlCommand
        Dim rs2 As System.Data.SqlClient.SqlDataReader
        Dim ctr As Integer
        cn2.ConnectionString = ConfigurationManager.AppSettings("ReportsConnectionString")
        cn2.Open()
        command2.Connection = cn2
        'StatMessage = ConnectString
        'OPStatus.Text = StatMessage
        Dim readText() As String
        Try
            readText = File.ReadAllLines(ExcelFileName)
        Catch ex As Exception
            OPStatus.Text = ExcelFileName & " cannot be loaded.  " & ex.Message
            If ex.Message.Contains("It is already opened exclusively by another user") Then
                OPStatus.Text = ExcelFileName & " is locked. Close Excel."

            End If
            Exit Sub
        End Try
        Dim ExcelLine, RecordType As String
        Dim IsDataLine, IsValidFile, IsBranchData As Boolean
        IsValidFile = False
        IsBranchData = False
        For Each ExcelLine In readText
            IsDataLine = False
            Dim DetailRow As New TableRow()
            ctr = ctr + 1
            Dim DetailCell1, DetailCell2, DetailCell3, DetailCell4, DetailCell5, DetailCell6, DetailCell7 As New TableCell()
            Dim LineData() As String
            Dim LineDataLabel As New HiddenField
            Dim Literal1 As New Literal
            LineData = ExcelLine.Split(Chr(9))
            'DetailCell2.Text = "OK"
            If InStr(LineData(0), "Porteous Fastener Company") > 0 Then
                DetailCell2.Text = "OK"
                DetailCell3.Text = " "
                IsValidFile = True
            End If
            If InStr(LineData(0), "Includes Branch") > 0 Then
                DetailCell2.Text = "'" & Right(LineData(0), 2) & "'"
                DetailCell3.Text = "LocNo"
                IsDataLine = True
                IsBranchData = True
                RecordType = "Branch PandL"
                HiddenLocation.Value = Right(LineData(0), 2)
            End If
            If InStr(LineData(0), "CONSOLIDATED INCOME STATEMENT") > 0 Then
                DetailCell2.Text = "'00'"
                DetailCell3.Text = "LocNo"
                IsDataLine = True
                RecordType = "Consolidated PandL"
                HiddenLocation.Value = "00"
            End If
            If InStr(LineData(0), "NET SALES") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "NetSales"
                IsDataLine = True
            End If
            If InStr(LineData(0), "COST OF SALES") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "COGS"
                IsDataLine = True
            End If
            If InStr(LineData(0), "TRANSER FREIGHT IN (COGS)") > 0 _
                Or InStr(LineData(0), "TRANSFER FREIGHT IN (COGS)") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "TransFrght"
                IsDataLine = True
            End If
            If InStr(LineData(0), "GROSS PROFIT") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "GrossProfit"
                IsDataLine = True
            End If
            If InStr(LineData(0), "TOTAL WAREHOUSE EXPENSE") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "WhseExp"
                IsDataLine = True
            End If
            If InStr(LineData(0), "TOTAL SELLING EXPENSE") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "SellExp"
                IsDataLine = True
            End If
            If InStr(LineData(0), "TOTAL TRANS-OUT EXPENSE") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "TransExp"
                IsDataLine = True
            End If
            If InStr(LineData(0), "GENERAL & ADMIN EXPENSE") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "AdminExp"
                IsDataLine = True
            End If
            If InStr(LineData(0), "CORPORATE ALLOCATION") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "CorpAlloc"
                IsDataLine = True
            End If
            If (LineData(0) = "OTHER (INCOME) EXPENSE" And IsBranchData) Or _
            (InStr(LineData(0), "TOTAL OTHER (INCOME) EXPENSE") > 0 And Not IsBranchData) Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "OtherExpIncome"
                IsDataLine = True
            End If
            If InStr(LineData(0), "BRANCH BONUS") > 0 And IsBranchData Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "BranchBonus"
                IsDataLine = True
            End If
            If InStr(LineData(0), "BRANCH RELOCATION/LAYOUT") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "BranchRelocation"
                IsDataLine = True
            End If
            If InStr(LineData(0), "PROFIT (LOSS) BEFORE TAXES") > 0 Or _
            InStr(LineData(0), "INCOME (LOSS) BEFORE TAXES") > 0 Then
                DetailCell2.Text = Format(MakeNumber(LineData(1)), "#,##0")
                DetailCell3.Text = "EBIT"
                IsDataLine = True
            End If
            If IsDataLine Then
                DetailCell1.Text = ExcelLine
                LineDataLabel.Value = DetailCell2.Text.Replace(",", "")
                LineDataLabel.ID = "xx" & DetailCell3.Text
                'LineDataLabel.Visible = False
                Literal1.Text = DetailCell3.Text
                DetailCell4.Controls.Add(Literal1)
                DetailCell4.Controls.Add(LineDataLabel)
                DetailRow.Cells.Add(DetailCell1)
                DetailCell2.HorizontalAlign = HorizontalAlign.Right
                DetailRow.Cells.Add(DetailCell2)
                DetailRow.Cells.Add(DetailCell4)
                WorkTable.Rows.Add(DetailRow)
            End If
        Next
        OPStatus.Text = "Loaded " & ExcelFileName & " in page. Review data below. Use the Update button to add data to system."
        ExcelInPage.Visible = True
        If Not IsValidFile Then
            OPStatus.Text = "Bad File."
            BadCount = BadCount + 1
        Else
            HiddenType.Value = RecordType
        End If
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        'UserID = Session("UserName").ToString()
        Dim FormThing As String
        For Each FormThing In Request.Form
            If InStr(FormThing, ".txt") > 0 Then
                ExcelFileName = Mid(FormThing, 5)
                LoadYear = Request.Form("LoadYear")
                LoadMonth = Request.Form("LoadMonth")
                Exit For
            End If
        Next
        If ExcelFileName = "" Then
            ExcelFileName = Request.QueryString("xls")
            LoadYear = Request.QueryString("year")
            LoadMonth = Request.QueryString("month")
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        OPStatus.Text = ExcelFileName
        If Not IsPostBack Then
            If ExcelFileName <> "" Then
                Dim ExcelPath As String = ConfigurationManager.AppSettings("ExcelFilePath")
                ExcelFileName = ExcelPath & ExcelFileName
                LoadSpreadSheet.Enabled = True
                HiddenFileName.Value = ExcelFileName
                HiddenYear.Value = LoadYear
                HiddenMonth.Value = LoadMonth
                StatMessage = "Loading file for review. One moment....."
                LoadIt()
                If BadCount > 0 Then
                    LoadSpreadSheet.Visible = False
                End If
            Else
                OPStatus.Text = "File Name required. Go back and enter an Excel file to load."
            End If
        Else
            ProcessLines()
        End If
    End Sub

    Sub LoadBudget_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles LoadSpreadSheet.Click
        'ProcessLines()
    End Sub

    Sub ProcessLines()
        Dim cn2 As New System.Data.SqlClient.SqlConnection
        Dim command2 As New System.Data.SqlClient.SqlCommand
        cn2.ConnectionString = ConfigurationManager.AppSettings("ReportsConnectionString")
        cn2.Open()
        command2.Connection = cn2
        Dim DetailRow As String
        Dim ValString As String = "("
        Dim ColString As String = "("

        For Each DetailRow In Request.Form
            If Left(DetailRow, 2) = "xx" Then
                ColString = ColString + Mid(DetailRow, 3) + ","
                ValString = ValString + Request.Form(DetailRow) + ","
            End If
        Next
        ' Delete matching records
        SelectString = "delete from AcctStmts "
        SelectString = SelectString & "where(LocNo = '" & Request.Form("HiddenLocation") & "') "
        SelectString = SelectString & "and (Type='" & Request.Form("HiddenType") & "') "
        SelectString = SelectString & "and (CurMonth=" & Request.Form("HiddenMonth") & ") "
        SelectString = SelectString & "and (CurYear=" & Request.Form("HiddenYear") & ") "
        command2.CommandText = SelectString
        z = command2.ExecuteNonQuery
        'OPStatus.Text = SelectString
        ColString = ColString + "CurMonth,CurYear,Type"
        ValString = ValString + Request.Form("HiddenMonth") + ","
        ValString = ValString + Request.Form("HiddenYear") + ",'"
        ValString = ValString + Request.Form("HiddenType") + "'"
        If Request.Form("HiddenType") = "Branch PandL" Then
            ColString = ColString + ",AdminExp,BranchRelocation"
            ValString = ValString + ",0,0"
        End If
        If Request.Form("HiddenType") = "Consolidated PandL" Then
            ColString = ColString + ",CorpAlloc,BranchBonus"
            ValString = ValString + ",0,0"
        End If
        ColString = ColString + ",EntryDt,EntryID"
        ValString = ValString + ",'" & Now.ToString & "','" & UserID & "'"
        SelectString = "insert into AcctStmts " & ColString & ") values " & ValString & ")"
        ' insert records
        command2.CommandText = SelectString
        z = command2.ExecuteNonQuery
        cn2.Close()
        OPStatus.Text = "Loaded spreadsheet."
        LoadSpreadSheet.Visible = False
        ExcelInPage.Visible = False
    End Sub

    Function MakeNumber(ByVal CellData As String) As Decimal
        Dim NewValue As Decimal
        CellData = CellData.Replace(Chr(34), "")

        If CellData.Length = 0 Then
            NewValue = 0
        Else
            NewValue = CDec(CellData)

        End If
        Return NewValue
    End Function
End Class
