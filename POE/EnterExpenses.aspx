<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EnterExpenses.aspx.cs" Inherits="EnterExpenses" %>
<%@ Register Src="~/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc4" %>
<%@ Register Src="~/Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="~/Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>POE - Enter Expenses</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    
    <script>
    function CloseForm()
    {
        //window.opener.parent.bodyFrame.document.getElementById("btnCheckExpComment").click();            
        window.close();
    }
    </script>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%"
            class="HeaderPanels">
            <tr>
                <td>
                    <uc1:SoHeader ID="SoHeader" runat="server"></uc1:SoHeader>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="vertical-align: top; padding-bottom: 10px; padding-top: 10px;
                    padding-left: 5px">
                    <asp:UpdatePanel ID="upExpenseEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table cellpadding="1" cellspacing="0" width="100%" class="data" border="0" bordercolor="#efefef">
                                <tr style="font-weight: bold;">
                                    <td>
                                        Line No
                                    </td>
                                    <td>
                                        Code
                                    </td>
                                    <td>
                                        Description
                                    </td>
                                    <td>
                                        <asp:Label ID="lblPctCaption" runat="server" Text="Percent"></asp:Label>
                                    </td>
                                    <td>
                                        Amount
                                    </td>
                                    <td>
                                        Indicator
                                    </td>
                                    <td>
                                    </td>
                                    <td rowspan="2" align="center" valign="middle">
                                        <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/Save.jpg"
                                            OnClick="ibtnSave_Click" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:HiddenField ID="hidExpenseID" runat="server" />
                                        <asp:Label ID="lblLineNo" CssClass="lblbox" runat="server" Text="1" Width="30"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlCode" AutoPostBack="true" CssClass="lbl_whitebox" runat="server"
                                            Height="20" Width="140px" OnSelectedIndexChanged="ddlCode_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblDescription" CssClass="lblbox" runat="server" Text="" Width="140"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPercent" CssClass="lbl_whitebox" runat="server" Width="50" AutoPostBack="true"
                                            OnTextChanged="txtPercent_TextChanged" CausesValidation=true onkeypress="javascript:ValdateNumberWithDot(this.value);" MaxLength="15"></asp:TextBox>
                                       
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAmount" CssClass="lbl_whitebox" runat="server" Width="50" AutoPostBack="true"
                                            OnTextChanged="txtAmount_TextChanged" CausesValidation="true"  onkeypress="javascript:ValdateNumberWithDot(this.value);" MaxLength ="15"></asp:TextBox>
                                       
                                    </td>
                                    <td>
                                        <asp:Label ID="lblIndicator" CssClass="lblbox" runat="server" Text="" Width="30"></asp:Label>
                                    </td>
                                    <td style="font-weight: bold;">
                                        <asp:CheckBox ID="chkTaxable" runat="server" Text="Taxable" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upExpenseGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 237px; border: 1px solid #88D2E9;
                                width: 705px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvExpense" PagerSettings-Visible="false"
                                    Width="900" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                    AutoGenerateColumns="false" OnSorting="gvExpense_Sorting" OnRowCommand="gvExpense_RowCommand"
                                    OnRowDataBound="gvExpense_RowDataBound">
                                    <HeaderStyle HorizontalAlign="center" CssClass="GridHead" Font-Bold="true" BackColor="#DFF3F9" />
                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                    <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="25px" BorderWidth="1px" />
                                    <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="25px" BorderWidth="1px" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                    Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pPOExpenseID")%>'>Edit</asp:LinkButton>
                                                <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                    Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                    CommandName="Deletes" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pPOExpenseID")%>'>Delete</asp:LinkButton>
                                            </ItemTemplate>
                                            <ItemStyle Width="90px" />
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="Line" DataField="LineNumber" SortExpression="LineNumber"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Code" DataField="ExpenseCd" SortExpression="ExpenseCd"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Description" DataField="Dsc" SortExpression="Dsc" ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="180px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Amount" DataField="Amount" DataFormatString ="{0:00.00}" SortExpression="Amount" ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="right" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Taxable" DataField="TaxStatus" SortExpression="TaxStatus"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="center" Width="30px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Cost" DataField="Cost" SortExpression="Cost" ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Indicator" DataField="ExpenseInd" SortExpression="ExpenseInd"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="center" Width="30px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Delete Date" DataField="DeleteDt" SortExpression="DeleteDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Change Date" DataField="ChangeDt" SortExpression="ChangeDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" SortExpression="ChangeID"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                <asp:HiddenField ID="hidNetSales" runat="server" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="left" width="89%">
                                <asp:UpdateProgress ID="upPanel" runat="server">
                                    <ProgressTemplate>
                                        <span class="TabHead">Loading...</span></ProgressTemplate>
                                </asp:UpdateProgress>
                                <asp:UpdatePanel ID="upProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                         <asp:RegularExpressionValidator ID="revPerscent"  ControlToValidate="txtPercent" SetFocusOnError="true" 
                                         Font-Bold="true" runat="server" ValidationExpression="^[+-]?\d+(\.\d{1,5})?" ErrorMessage="<br/>Enter Valid Percent"
                                         Display="dynamic"></asp:RegularExpressionValidator>
                                         <asp:RegularExpressionValidator ID="revAmount" ControlToValidate="txtAmount" SetFocusOnError="true"
                                         Font-Bold="true" runat="server" ValidationExpression="^[+-]?\d+(\.\d{1,5})?" ErrorMessage="Enter Valid Amount"
                                         Display="dynamic"></asp:RegularExpressionValidator> 
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                             <td>
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                 <ContentTemplate>
                                 <uc4:PrintDialogue id="PrintDialogue1" runat="server"></uc4:PrintDialogue>
                                 </ContentTemplate>
                                </asp:UpdatePanel>
                                </td> 
                        </tr>
                    </table>
                </td>
            </tr>
             <tr>                
                <td align=right style="padding-right:5px;">
                    <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:CloseForm();" /></td>
                <td>
                
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Enter Expenses" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>

   <%-- <script language="javascript">
   
     document.getElementById("hidNetSales").value=window.opener.parent.bodyFrame.form1.document.getElementById("lblSales").innerHTML;    
    </script>--%>

</body>
</html>
