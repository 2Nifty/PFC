<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvoiceRecallExport.aspx.cs"
    Inherits="InvoiceRecallExport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Invoice Recall</title>
    <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet"
        type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" class="HeaderPanels" cellpadding="0" cellspacing="0">
            <tr>
                <td class="lightBg" width="100%">
                    <asp:UpdatePanel ID="upnlBillInfo" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="SubHeaderPanels" style="padding-left: 4px;" valign="top">
                                        <asp:Panel ID="pnlSearch" runat="server">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="height: 15px; padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                                                        <asp:Label ID="lblInvoiceNo" runat="server" Text="Invoice No: " Font-Bold="True"
                                                            Width="80px"></asp:Label>&nbsp;
                                                        <asp:HiddenField ID="hidCust" runat="server" />
                                                    </td>
                                                    <td style="height: 15px; padding-bottom: 5px; padding-left: 2px; padding-right: 5px;">
                                                        <asp:TextBox ID="txtInvoiceNumber" runat="server" CssClass="lbl_whitebox" Width="114px" OnTextChanged="txtInvoiceNumber_TextChanged"> </asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtInvoiceNumber"
                                                            Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px; height:20px;font-weight:bold" valign="top">
                                                        Bill To :
                                                    </td>
                                                    <td style="padding-bottom: 5px; padding-left: 2px; padding-right: 5px;height:20px" valign="top">
                                                        <asp:Label ID="lblBillCustNo" runat="server"  Font-Bold="True" ></asp:Label>
                                                        <asp:Label ID="lblCustCom" runat="server"  Font-Bold="True" Text="/" Visible="false"></asp:Label>
                                                        <asp:Label ID="lblBillCustName" runat="server" Font-Bold="True" ></asp:Label>
                                                    </td>
                                                    <td valign="top" style="width: 78px">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px; height:20px;font-weight:bold " valign="top">
                                                        Bill To Fax :
                                                    </td>
                                                    <td style="padding-bottom: 5px; padding-left: 2px; padding-right: 5px;height:20px"  valign="top">
                                                        <asp:Label ID="lblBillToFax" runat="server" CssClass="lbl_whitebox"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;height:20px;font-weight:bold " valign="top">
                                                        Bill To EMail :
                                                    </td>
                                                    <td style="padding-bottom: 5px; padding-left: 2px; padding-right: 5px;height:20px" valign="top">
                                                        <asp:Label ID="lblBillToMail" runat="server" CssClass="lbl_whitebox"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upnlInvoiceGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvInvoice" PagerSettings-Visible="false"
                                Width="700" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="false"
                                AutoGenerateColumns="false">
                                <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true" />
                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Invoice No">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnlInvoiceNo" CausesValidation="false" Font-Underline="true"
                                                ForeColor="#006600" Style="padding-left: 5px" Text='<%#DataBinder.Eval(Container.DataItem,"InvoiceNo") %>'
                                                runat="server" CommandName="BindInvoice"></asp:LinkButton>
                                        </ItemTemplate>
                                        <FooterStyle HorizontalAlign="Right" />
                                        <ItemStyle  HorizontalAlign ="Center" Width="90px" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Cust No" DataField="SellToCustNo" SortExpression="SellToCustNo">
                                        <ItemStyle HorizontalAlign="Center" Width="70px" CssClass="Left5pxPadd" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Invioce Date" DataField="InvoiceDt" SortExpression="InvoiceDt">
                                        <ItemStyle HorizontalAlign="Center" Width="90px" CssClass="Left5pxPadd" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Cust PO No" DataField="CustPONo" SortExpression="CustPONo">
                                        <ItemStyle HorizontalAlign="Center" Width="90px" CssClass="Left5pxPadd" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Invoice Amt" DataField="TotalOrder" SortExpression="TotalOrder"
                                        DataFormatString="{0:$ #,##0.00}">
                                        <ItemStyle HorizontalAlign="Right" Width="90px" CssClass="Left5pxPadd" />
                                        <FooterStyle HorizontalAlign="Right" />
                                    </asp:BoundField>
                                </Columns>
                                <PagerSettings Visible="False" />
                            </asp:GridView>
                                <input id="hidSortControl" type="hidden" name="Hidden1" runat="server">
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
