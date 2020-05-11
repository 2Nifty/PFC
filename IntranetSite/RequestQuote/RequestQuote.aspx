<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RequestQuote.aspx.cs" Inherits="ReqQuote" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Request Quote</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <%--<link href="Common/StyleSheets/RFQStyleSheet.css" rel="stylesheet" type="text/css" />--%>
    <link href="Common/StyleSheets/Quote.css" rel="stylesheet" type="text/css" />
    <style>
   
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div align="center" style="width: 1000px;">
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <table width="1024px" border="0" cellspacing="0" cellpadding="0" class="BorderLR">
                <tr>
                    <td colspan="4" class="topBg">
                        <table width="1020px">
                            <tr>
                                <td align="left">
                                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td class="PageHead" valign=top align="left" width="1024px" colspan="0" style="height: 30px">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td>
                                                <strong class="BannerText">Request For Quote</strong></td>
                                            <td align="right" style="vertical-align:middle;padding-top:5px;">
                                                <asp:Image Style="cursor: hand;" ID="imgClose" ImageUrl="~/Common/Images/Close.gif"
                                                    onclick="javascript:window.close();" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table width="1024px" border="0" cellspacing="0" cellpadding="0" class="BorderLR">
                <tr>
                    <td rowspan="2" class="tabBk" width="100">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    <a href=RequestQuote.aspx target=_self>
                                        <img id="imgHome" src="Common/images/homenormal.gif" onmouseover="this.src='Common/images/home_over.gif'" onmouseout="this.src='Common/images/homenormal.gif'" border="0"></a></td>
                            </tr>
                        </table>
                    </td>
                    <td width="1" rowspan="2" class="tabBk" valign="middle">
                        <div align="right">
                            <img src="Common/images/tabcut.jpg" width="32" height="45"></div>
                    </td>
                    <td colspan="2" class="helpTopBg" valign="top">
                        <img src="Common/images/helpTopBg.jpg" width="0" height="13"></td>
                </tr>
                <tr>
                    <td style="background-image: url(Common/images/helpBG.jpg);" height="25px">
                    </td>
                    <td style="background-image: url(Common/images/helpBG.jpg);">
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <img src="Common/images/topBase.jpg" height="3" width="100%"></td>
                </tr>
            </table>
            <table width="1024px" border="0" cellspacing="0" cellpadding="0" class="BlueBorder">
                <tr>
                    <td class="LoginFormBk">
                        <asp:UpdatePanel ID="upnlQuote" UpdateMode="conditional" runat="server">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td align=left>
                                            <table width=80%>
                                                <tr>
                                                    <td style="width:100px;">
                                                     <asp:Label ID="Label1"  Font-Bold="true" runat="server"
                                                      Text="Select PFC Branch"></asp:Label>
                                                       </td>
                                                    <td align="left">
                                                        <asp:DropDownList CssClass=ddlCtrl ID="ddlBranch" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                                                        </asp:DropDownList></td>
                                                    <td>
                                                     <asp:Label ID="Label2"  Font-Bold="true" runat="server"
                                                      Text=" Search By"></asp:Label>
                                                       </td>
                                                    <td align="left">
                                                        <asp:DropDownList CssClass=ddlCtrl ID="ddlSearch" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSearch_SelectedIndexChanged">
                                                        </asp:DropDownList></td>
                                                    <td>
                                                     <asp:Label ID="Label3"  Font-Bold="true" runat="server"
                                                      Text="Find"></asp:Label>
                                                        </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="txtFind" CssClass=formCtrl runat="server"></asp:TextBox></td>
                                                    <td align="left">
                                                        <asp:Button  CssClass="frmBtn" ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign=top>
                                            <asp:Label ID="lblMsg" Visible="false" ForeColor="red" Font-Bold="true" runat="server"
                                                Text="No records found"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign=top>
                                            <div id="div-datagrid" class="Sbar" style="overflow-x: auto; overflow-y: auto; position: relative;
                                                top: 0px; left: 0px; height:465px; width: 1010px; border-top:2px solid;" align="left">
                                                <asp:DataGrid ID="dgRequestQuote"  Width="1010px" OnPageIndexChanged="dgRequestQuote_PageIndexChanged" CssClass="grid"
                                                    AllowPaging="true" AllowSorting="True" ShowFooter="False" AutoGenerateColumns="false" GridLines="None"
                                                    runat="server" OnSortCommand="dgRequestQuote_SortCommand" OnItemDataBound="dgRequestQuote_ItemDataBound">
                                                    <HeaderStyle CssClass="gridHeader"  ForeColor="Black"  Font-Bold=True HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" Height="20px" />
                                                    <AlternatingItemStyle CssClass="zebra" Height="20px" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Customer Name" SortExpression="CustomerName">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblCustName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"CustomerName")%>'></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle Font-Bold="True" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Customer#"  SortExpression="CustomerNumber">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblCust" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"CustomerNumber")%>'></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="80px" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="User Name" SortExpression="AdministratorEmailID">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblUserName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"AdministratorEmailID")%>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="RFQ ID #" SortExpression="SessionID">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblRFQ" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SessionID")%>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Cust Ref #" SortExpression="CustRefNo">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblCustRef" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"CustRefNo")%>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="RFQ Method" SortExpression="SystemName">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblRFQMethod" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SystemName")%>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Date Submitted" SortExpression="QuotationDate">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSubmitDate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"QuotationDate")%>'></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="80px" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Status" SortExpression="RFQCompleteDt">
                                                            <ItemTemplate>
                                                                <asp:HiddenField ID="hidQuoteNo" Value='<%# DataBinder.Eval(Container.DataItem,"SessionID")%>' runat="server" />
                                                                <asp:HyperLink Visible="true"  ID="lnkEdit" runat="server" Font-Bold=true style="color:Blue;text-decoration:underline;"></asp:HyperLink>
                                                            </ItemTemplate>
                                                            <HeaderStyle ForeColor="Black" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Date Completed" SortExpression="RFQCompleteDt">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblCompletedDate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"RFQCompleteDt")%>'></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="80px" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="PFC Sales Rep" SortExpression="PFCSalesRep">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblSalesRef" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PFCSalesRep")%>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>
                                                <uc4:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" />
                                            </div>
                                            <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
