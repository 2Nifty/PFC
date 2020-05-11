<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RGASummary.aspx.cs" Inherits="RGASummary" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Monthly RGA Reason Code Summary</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="javascript/ContextMenu.js"></script>

    <script language="javascript" src="javascript/browsercompatibility.js"></script>

    <script>

    function LoadHelp()
    {
        window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }
    
    function PrintReport()
    {
        var URL = "RGASummaryRptPreview.aspx?BeginDt=" + document.getElementById("lblBeginDt").innerText + "&EndDt=" + document.getElementById("lblEndDt").innerText;
        window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="5" height="97" valign="top" class="BannerBg">
                                <div width="100%" class="bannerImg">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="PageHead" width="100%" valign="top" style="height: 40px">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td valign="middle" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Monthly RGA Reason Code Summary</div>
                                            </div>
                                        </td>
                                        <td align="right" valign="middle">
                                            &nbsp;<asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="images/ExporttoExcel.gif"
                                                OnClick="ExportRpt_Click" />
                                            <img src="images/Print.gif" onclick="Javascript:PrintReport();" style="cursor: hand" />
                                            <img src="Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                            <img id="btnClose" src="images/close.gif" style="cursor: hand" runat="server" />
                                        </td>
                                    </tr>
                                    <tr class="PageBg" height="30px">
                                        <td align="left" valign="middle" class="TabHead">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fiscal Period:&nbsp;&nbsp;&nbsp;
                                            <asp:DropDownList AutoPostBack="true" ID="ddFiscalPeriod" runat="server" OnSelectedIndexChanged="ddFiscalPeriod_SelectedIndexChanged" />
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            Start Date:&nbsp;&nbsp;&nbsp;<asp:Label ID="lblBeginDt" runat="server" Text="NoBeginDt"></asp:Label>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            End Date:&nbsp;&nbsp;&nbsp;<asp:Label ID="lblEndDt" runat="server" Text="NoEndDt"></asp:Label>
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr class="Left5pxPadd">
                                        <td valign="top" width="100%" style="height: 314px">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; width: 1000px; height: 400px; border: 0px solid;">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                                    ShowFooter="False" AutoGenerateColumns="False" PageSize="20" AllowPaging="true"
                                                    PagerStyle-Visible="false">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="Date" HeaderText="Date" SortExpression="Date">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Location Code" HeaderText="Location" SortExpression="Location Code">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Return Reason Code" HeaderText="Return Reason Code" SortExpression="Return Reason Code">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Record Count" HeaderText="Record Count" SortExpression="Record Count"
                                                            DataFormatString="{0:0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="50px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="50px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ExtendedValue" HeaderText="Extended Value" SortExpression="ExtendedValue"
                                                            DataFormatString="{0:$0.00}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="BluBg">
                                <table width="100%" id="tblPager" runat="SERVER">
                                    <tr>
                                        <td>
                                            <uc1:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
