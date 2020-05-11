Imports System.Data

Partial Class _Default
    Inherits System.Web.UI.Page
    Public SelectStr As String
    Dim dv As DataView
    Dim SelectArguments As New DataSourceSelectArguments

    Protected Sub Reprint_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles Reprint.Click
        BuildSelect()
        SelectStr += "order by No_ desc "
        SqlHeaderlData.SelectCommand = SelectStr
        dv = SqlHeaderlData.Select(SelectArguments)
        If dv.Count > 0 Then
            HeaderView.DataBind()
            If dv.Count = 1 Then
                HiddenShipper.Value = dv.Item(0).Row.Item("Shipper").ToString
                ShipperDetail.Visible = True
                OpStatus.Text = "Single Shipper Found"
                ReprintOnly.Focus()
                SearchPanel.Visible = False
                ShipperGridPanel.Visible = False
                ShipperHeaderPanel.Visible = False
            Else
                FillTable(dv)
                ShipperHeaderPanel.Visible = True
                ShipperGridPanel.Visible = True
                SearchPanel.Visible = False
                OpStatus.Text = SelectStr
            End If
        Else
            ShipperDetail.Visible = False
            OpStatus.Text = "Shipper has not been through or is in Repick."
            BranchFilterDropDownList.Focus()
            SearchPanel.Visible = True
        End If

    End Sub

    Protected Sub FillTable(ByVal dv As Data.DataView)
        Dim rs As DataRowView
        For Each rs In dv
            Dim DetailRow As New TableRow()
            Dim DetailCell1, DetailCell2, DetailCell3, DetailCell4, DetailCell5, DetailCell6, DetailCell7, DetailCell8 As New TableCell()
            Dim IgnoreBox As New CheckBox
            Dim NewCostBox As New TextBox
            Dim radio1, radio2, radio3 As New RadioButton
            Dim CellLiteral1, CellLiteral2 As New Literal
            DetailCell1.Text = rs("Shipper")
            DetailCell1.Width = 110
            DetailCell1.HorizontalAlign = HorizontalAlign.Center
            DetailRow.Cells.Add(DetailCell1)
            DetailCell2.Text = rs("Ship-to Name")
            DetailCell2.Width = 300
            DetailCell2.HorizontalAlign = HorizontalAlign.Left
            DetailRow.Cells.Add(DetailCell2)
            DetailCell3.HorizontalAlign = HorizontalAlign.Center
            DetailCell3.Text = rs("Branch")
            DetailCell3.Width = 40
            DetailRow.Cells.Add(DetailCell3)
            DetailCell4.Text = rs("Shipping Location")
            DetailCell4.HorizontalAlign = HorizontalAlign.Center
            DetailCell4.Width = 40
            DetailRow.Cells.Add(DetailCell4)
            DetailCell5.Text = Format(rs("Showdate"), "MM/dd/yyyy HH:mm:ss")
            DetailCell5.HorizontalAlign = HorizontalAlign.Center
            DetailCell5.Width = 180
            DetailRow.Cells.Add(DetailCell5)
            If Convert.IsDBNull(rs("InsideSales")) Then
                DetailCell6.Text = "Empty"
            Else
                DetailCell6.Text = rs("InsideSales")
            End If
            DetailCell6.HorizontalAlign = HorizontalAlign.Left
            DetailCell6.Width = 120
            DetailRow.Cells.Add(DetailCell6)
            DetailCell7.HorizontalAlign = HorizontalAlign.Center
            DetailCell7.Width = 50
            DetailCell8.HorizontalAlign = HorizontalAlign.Center
            DetailCell8.Width = 50
            radio1.ID = "Reprint" & rs("Shipper")
            radio1.GroupName = "Do" & rs("Shipper")
            radio1.ToolTip = "Reprint " & rs("Shipper")
            DetailCell7.Controls.Add(radio1)
            DetailRow.Cells.Add(DetailCell7)
            radio2.ID = "Repick" & rs("Shipper")
            radio2.GroupName = "Do" & rs("Shipper")
            radio2.ToolTip = "Repick/Reprint " & rs("Shipper")
            DetailCell8.Controls.Add(radio2)
            DetailRow.Cells.Add(DetailCell8)
            WorkTable.Rows.Add(DetailRow)
        Next
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        ShipperDetail.Visible = False
        ShipperHeaderPanel.Visible = False
        ShipperGridPanel.Visible = False
        SearchPanel.Visible = True
        OpStatus.Text = "Enter the branch, a shipper number range (optional) and a date range."
        BranchFilterDropDownList.Focus()
        BegDate.SelectedDate = DateAdd(DateInterval.Day, -7, Now).ToShortDateString
        EndDate.SelectedDate = Now.ToShortDateString
    End Sub

    Protected Sub ReprintOnly_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ReprintOnly.Click
        SqlHeaderlData.UpdateCommand = "update ThePipeSalesHeader set ThePipeStepCtr=200000 where [No_] = '" & HiddenShipper.Value & "'"
        SqlHeaderlData.Update()
        OpStatus.Text = "Shipper should reprint in the next 5 minutes."
        ShipperDetail.Visible = False
        BranchFilterDropDownList.Focus()
        SearchPanel.Visible = True
    End Sub

    Protected Sub ReprintRepick_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ReprintRepick.Click
        SqlHeaderlData.DeleteCommand = "delete from ThePipeSalesHeader where [No_] = '" & HiddenShipper.Value & "'"
        SqlHeaderlData.Delete()
        OpStatus.Text = "Shipper should reprint and refresh in RB in the next 5 minutes"
        ShipperDetail.Visible = False
        SearchPanel.Visible = True
        BranchFilterDropDownList.Focus()
    End Sub

    Protected Sub Cancel_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles Cancel.Click
        ShipperDetail.Visible = False
        SearchPanel.Visible = True
        BranchFilterDropDownList.Focus()
        OpStatus.Text = "Enter the branch, a shipper number range (optional) and a date range."
    End Sub

    Protected Sub GridCancel_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles GridCancelButton.Click
        ShipperHeaderPanel.Visible = False
        ShipperGridPanel.Visible = False
        SearchPanel.Visible = True
        BranchFilterDropDownList.Focus()
        OpStatus.Text = "Enter the branch, a shipper number range (optional) and a date range."
    End Sub

    Protected Sub TableSort_Click(ByVal sender As Object, ByVal e As EventArgs)
        BuildSelect()
        SqlHeaderlData.SelectCommand = SelectStr
        dv = SqlHeaderlData.Select(SelectArguments)
        Select Case sender.ID.ToString
            Case "Shipper"
                dv.Sort = "Shipper"
            Case "Cust"
                dv.Sort = "Ship-to Name"
            Case "Br"
                dv.Sort = "Branch"
            Case "Ship"
                dv.Sort = "Shipping Location"
            Case "Date"
                dv.Sort = "Showdate"
            Case "Tech"
                dv.Sort = "InsideSales"
        End Select
        WorkTable.Rows.Clear()
        FillTable(dv)
    End Sub

    Protected Sub BuildSelect()
        SelectArguments.TotalRowCount = True
        SelectStr = "select  No_ AS Shipper, [Shortcut Dimension 1 Code] as Branch, ThePipeStepCtr, ThePipeIn, ThePipeOut, [Ship-to Name], "
        SelectStr += "[Ship-to Name 2], [Ship-to Address], [Ship-to Address 2], "
        SelectStr += "[Ship-to City], [Ship-to Contact], [External Document No_] AS PONumber, [Inside Salesperson Code] AS InsideSales, "
        If PipeDate.Checked Then
            SelectStr += " ThePipeOut as Showdate, "
        Else
            SelectStr += " [Order Date] as Showdate, "
        End If
        SelectStr += "[Posting Date],[Shipping Location] from ThePipeSalesHeader where 1=1 "
        If BegShipperToProcess.Text <> "" And EndShipperToProcess.Text <> "" Then
            SelectStr += "and [No_] between '" & BegShipperToProcess.Text & "' and '" & EndShipperToProcess.Text & "' "
        End If
        If BegShipperToProcess.Text = "" And EndShipperToProcess.Text <> "" Then
            SelectStr += "and [No_] < '" & EndShipperToProcess.Text & "' "
        End If
        If BegShipperToProcess.Text <> "" And EndShipperToProcess.Text = "" Then
            SelectStr += "and [No_] > '" & BegShipperToProcess.Text & "'  "
        End If
        If PipeDate.Checked Then
            SelectStr += "and CONVERT (varchar, ThePipeOut, 112) between CONVERT (varchar, CONVERT (DATETIME,'" & BegDate.SelectedDate & "'), 112) and CONVERT (varchar, CONVERT (DATETIME,'" & EndDate.SelectedDate & "'), 112) "
        Else
            SelectStr += "and CONVERT (varchar, [Order Date], 112) between CONVERT (varchar, CONVERT (DATETIME,'" & BegDate.SelectedDate & "'), 112) and CONVERT (varchar, CONVERT (DATETIME,'" & EndDate.SelectedDate & "'), 112) "
        End If
        If ShippingBranch.Checked Then
            SelectStr += "and [Shipping Location] = '" & BranchFilterDropDownList.SelectedValue & "' "
        Else
            SelectStr += "and [Shortcut Dimension 1 Code] = '" & BranchFilterDropDownList.SelectedValue & "' "
        End If
    End Sub

End Class
