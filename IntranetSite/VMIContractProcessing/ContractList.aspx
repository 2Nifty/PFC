<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ContractList.aspx.cs" Inherits="VMIContractProcessing_ContractList" EnableViewState="true" %>

<%@ Register Src="../Common/UserControls/MinBottomFrame.ascx" TagName="MinBottomFrame"
    TagPrefix="uc3" %>

<%@ Register Src="../Common/UserControls/Minpager.ascx" TagName="Minpager" TagPrefix="uc2" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>VMI Reports</title>
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet"
        type="text/css" />
        
</head>
<body style="margin: 3px">
    <form id="form1" runat="server">
        <table id="master" class="DashBoardBk" style="width: 100%; border-collapse: collapse;
            page-break-after: always;">
            <tr>
                <td >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                        <tr>
                            <td width="62%" valign="middle">
                                <img src="../Common/Images/Logo.gif" width="453" height="50" hspace="25" vspace="10"></td>
                            <td width="38%" valign="bottom" class="10pxPadding">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="DashBoardBk">
                        <tr>
                            <td valign="middle" class="PageHead" colspan="2">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="DashBoardBk">
                                    <tr>
                                        <td class="PageHead">
                                            <div align="left" class="LeftPadding">
                                                Customer Contract List</div>
                                        </td>
                                        <td class="PageHead" align="right">
                                            <img style="cursor: hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:parent.window.close();" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" bgcolor="#EFF9FC" colspan="2">
                                </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" style="width: 91%" align=center>
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; border: 0px solid; width: 100%;height:300px">
                                                <asp:DataGrid PageSize="20" ID="dgAnalysis" BackColor="#F4FBFD" AllowPaging="True"
                                                    runat="server" Width="100%" AutoGenerateColumns="False" PagerStyle-Visible="false"
                                                    BorderWidth="1px" AllowSorting="True" OnItemDataBound="dgAnalysis_ItemDataBound"
                                                    OnSortCommand="dgAnalysis_SortCommand" OnPageIndexChanged="dgAnalysis_PageIndexChanged">
                                                    <HeaderStyle HorizontalAlign="center" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <ItemStyle CssClass="GridItem" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Left" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right"  DataField="ContractNo" HeaderText="Contract #" SortExpression="ContractNo" HeaderStyle-Wrap=false>
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" DataField="Chain" HeaderText="Chain #" SortExpression="Chain" HeaderStyle-Wrap=false></asp:BoundColumn>
                                                        <asp:BoundColumn FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="right" DataField="CustomerPO" HeaderText="Customer PO" SortExpression="CustomerPO" HeaderStyle-Wrap=false>
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap=false>
                                                            <ItemTemplate>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn FooterStyle-CssClass=GridHead  HeaderStyle-CssClass=GridHead ItemStyle-CssClass=GridItem ItemStyle-HorizontalAlign="center" HeaderStyle-Wrap=false>
                                                            <ItemTemplate>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle Visible="False" />
                                                </asp:DataGrid>
                                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                    Visible="False"></asp:Label>
                                            </div>
                                             <uc2:Minpager ID="Pager1" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                                <input type="hidden" runat="server" id="hidSort" />
                            </td>
                        </tr>
                        
                       
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc3:MinBottomFrame ID="MinBottomFrame1" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
