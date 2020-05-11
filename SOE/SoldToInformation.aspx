<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SoldToInformation.aspx.cs"
    Inherits="SoldToInformation" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="CEHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE- Pending Orders & Quotes</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/PendingOrdersAndQuotes.js"></script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server" defaultbutton="ibtnSearch">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
            <tr>
                <td class="lightBg" style="padding: 10px;">
                    <table border="0" cellpadding="0" cellspacing="0" width=100%>
                        <tr>
                            <td style="width: 100px">
                                <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Sales Order Number"
                                    Width="117px"></asp:Label></td>
                            <td style="width: 100px">
                                <asp:Label ID="lblSONumber" runat="server" Font-Bold="True"></asp:Label></td>
                            <td>
                            </td>
                            <td style="width: 100px" align=right>
                                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Common/Images/help.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                    <asp:UpdatePanel ID="pnlPendingOrderEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="3" cellspacing="0">
                                <tr>
                                    <td colspan="2" style="height: 14px">
                                    </td>
                                    <td style="width: 50px; height: 14px">
                                    </td>
                                    <td colspan="2" style="height: 14px">
                                        <asp:CheckBox ID="CheckBox1" runat="server" Font-Bold="True" Text="New Contact" /></td>
                                    <td style="width: 50px; height: 14px">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="height: 14px">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                                            <tr>
                                                <td align="center">
                                                    <hr color="#003366" />
                                                </td>
                                                <td style="width: 60px; height: 14px;" align="center">
                                                    <asp:Label ID="Label6" runat="server" Text="Address" Font-Bold="True"></asp:Label></td>
                                                <td align="center">
                                                    <hr align="center" color="#003366" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50px; height: 14px">
                                    </td>
                                    <td style="height: 14px" colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                                            <tr>
                                                <td align="center">
                                                    <hr color="#003366" />
                                                </td>
                                                <td style="width: 60px; height: 14px;" align="center">
                                                    <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Contact"></asp:Label></td>
                                                <td align="center">
                                                    <hr align="center" color="#003366" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50px; height: 14px">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" Text="Name" Font-Bold="True" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblName" runat="server" Font-Bold="True" Width="160px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Name" Width="70px"></asp:Label></td>
                                    <td colspan="1">
                                        <asp:TextBox ID="txtContactName" runat="server" Width="160px"></asp:TextBox></td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Address 1" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblAddress1" runat="server" Font-Bold="True" Width="160px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Job Title" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtContactJobTitle" runat="server" Width="160px"></asp:TextBox></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Address 2" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblAddress2" runat="server" Font-Bold="True" Width="160px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Department" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtContactDepart" runat="server" Width="160px"></asp:TextBox></td>
                                    <td>
                                        </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="City / State" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCity" runat="server" Font-Bold="True" Width="100px"></asp:Label>
                                        <asp:Label style="padding-left:5px" ID="lblState" runat="server" Font-Bold="True" Width="50px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Phone / Ext" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtContactPhoneNo" runat="server" Width="100px"></asp:TextBox>
                                        <asp:TextBox style="padding-left:0px" ID="txtContactExt" runat="server" Width="50px"></asp:TextBox></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Postcode" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPostcode" runat="server" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label17" runat="server" Font-Bold="True" Text="Fax No" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtContactFax" runat="server" Width="100px"></asp:TextBox></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Country" Width="59px"></asp:Label></td>
                                    <td >
                                        <asp:Label ID="lblCountry" runat="server" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label16" runat="server" Font-Bold="True" Text="Mobile No" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtContactMob" runat="server" Width="100px"></asp:TextBox></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 122px; height: 16px">
                                        &nbsp;<asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Phone" Width="59px"></asp:Label></td>
                                    <td style="height: 16px">
                                        <asp:Label ID="lblPhone" runat="server" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td style="height: 16px">
                                    </td>
                                    <td style="height: 16px">
                                        <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Email" Width="70px"></asp:Label></td>
                                    <td align="right" style="height: 16px">
                                        <asp:TextBox ID="txtContactEmail" runat="server" Width="160px"></asp:TextBox></td>
                                    <td style="height: 16px">
                                        <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/Save.jpg" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="padding: 5PX;">
                    <asp:UpdatePanel ID="pnlPendingOrderGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%" align="center">
                                <tr>
                                    <td colspan="2">
                                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="divdatagrid" style="overflow-x: auto;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 290px; border: 1px solid #88D2E9;
                                            width: 695px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                            scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                            scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94" runat="server">
                                            <asp:GridView ShowFooter="false" ID="gvPendingOrders" PagerSettings-Visible="false"
                                                Width="850" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                                AutoGenerateColumns="false" OnRowCommand="gvPendingOrders_RowCommand" OnSorting="gvPendingOrders_Sorting">
                                                <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true"
                                                    BackColor="#DFF3F9" />
                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                                <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                                <Columns>
                                                    <asp:BoundField HeaderText="Ship Loc" DataField="ShipLoc" SortExpression="ShipLoc"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Order No." SortExpression="OrderNo">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#CC0000"
                                                                Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"pSOHeaderID") %>'><%# DataBinder.Eval(Container.DataItem,"OrderNo") %></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="50px" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderText="Customer No." DataField="SellToCustNo" SortExpression="SellToCustNo"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Customer Name" DataField="SellToCustName" SortExpression="SellToCustName"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="150px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Order Amt." DataField="TotalOrder" SortExpression="TotalOrder"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Order Date" DataField="OrderDt" SortExpression="OrderDt"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Cust Req’d" DataField="OrderPromDt" SortExpression="OrderPromDt"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Status" DataField="StatusCd" SortExpression="StatusCd"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt"
                                                        ItemStyle-CssClass="Left5pxPadd">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Deleted Date" DataField="DeleteDt" SortExpression="DeleteDt"
                                                        ItemStyle-CssClass="Left5pxPadd" Visible="false">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                    </asp:BoundField>
                                                </Columns>
                                            </asp:GridView>
                                            <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                            <input id="hidPrintURL" type="hidden" name="hidPrintURL" runat="server">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="left" width="85%">
                                <asp:UpdateProgress ID="pnlProgress" runat="server">
                                    <ProgressTemplate>
                                        <span class="TabHead">Loading...</span></ProgressTemplate>
                                </asp:UpdateProgress>
                                <asp:UpdatePanel ID="pnlStatusMessage" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:ImageButton ID="ibtnDeletedItem" ImageUrl="~/Common/Images/expand.gif" ToolTip="Click here to show deleted orders"
                                    runat="server" OnClick="ibtnDeletedItem_Click1" /></td>
                            <td>
                                <img src="Common/Images/mail.gif" style="cursor: hand;" id="imgMail" /></td>
                            <td>
                                <img src="Common/Images/pdf.gif" onclick="ExportRpt('pdf');" style="cursor: hand;"
                                    id="imgPDF" /></td>
                            <td>
                                <img src="Common/Images/printer.gif" onclick="ExportRpt('Print');" style="cursor: hand;"
                                    id="imgPrinter" /></td>
                            <td>
                                &nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="FooterC" Title="Sold To Information" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
