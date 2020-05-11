<%@ Page Language="C#" AutoEventWireup="true" CodeFile="POVendorConf.aspx.cs" Inherits="POVendorConf" %>
<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>PO Vendor Confirmation Report</title>
        <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="../Common/javascript/ContextMenu.js"></script>

    <script language="javascript" src="../Common/javascript/browsercompatibility.js"></script>

    <script>

    function LoadHelp()
    {
        window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }
    
    function PrintReport()
    {
        var URL = "POVendorConfPreview.aspx?SortCommand=" + document.getElementById("hidSort").value;
        window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }

    </script>
</head>
<body>
    <form id="form1" runat="server">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="100%" height="400" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td colspan="2" valign="middle" >
                        <table width="100%"  border="0" cellspacing="0" cellpadding="0" >
                            <tr><td valign="top" colspan=2>
                                <uc1:PageHeader ID="PageHeader1" runat="server" />
                            </td></tr>
                            <tr><td class="PageHead" style="height: 40px"><div class="LeftPadding"><div align="left" class="BannerText"> PO Vendor Confirmation Report</div></div></td>
                                <td class="PageHead"  style="height: 40px" >
                            <div class="LeftPadding"><div align="left" class="BannerText" >
                                            &nbsp;<asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="../Common/images/ExporttoExcel.gif"
                                                OnClick="ExportRpt_Click" />
                                            <img src="../Common/images/Print.gif" onclick="Javascript:PrintReport();" style="cursor: hand" />
                                            <img src="../Common/images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                            <img id="btnClose" src="../Common/images/close.gif" style="cursor: hand" runat="server" />
                             </div></div></td>
                            </tr>
                        </table>
                </td>
            </tr>
<%--        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
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
                                                    PO Vendor Confirmation Report</div>
                                            </div>
                                        </td>
                                        <td align="right" valign="middle">
                                        <div class="LeftPadding"><div align="right" class="BannerText" >
                                            &nbsp;<asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="../Common/images/ExporttoExcel.gif"
                                                OnClick="ExportRpt_Click" />
                                            <img src="../Common/images/Print.gif" onclick="Javascript:PrintReport();" style="cursor: hand" />
                                            <img src="../Common/images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                            <img id="btnClose" src="../Common/images/close.gif" style="cursor: hand" runat="server" />
                                        </div></div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>--%>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr class="Left5pxPadd">
                                        <td valign="top" width="100%" style="height: 314px">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; width: 1000px; height: 400px; border: 0px solid;">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px"
                                                    ShowFooter="False" AutoGenerateColumns="False" PageSize="20" AllowSorting="true" AllowPaging="true"
                                                    PagerStyle-Visible="false" OnSortCommand="GridView1_SortCommand">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="PO No" HeaderText="PO No" SortExpression="PO No">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Vendor No" HeaderText="Vendor No" SortExpression="Vendor No">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="80px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Vendor Short Code" HeaderText="Vendor Short Code" SortExpression="Vendor Short Code">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="200px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="200px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PO Date" HeaderText="PO Date" SortExpression="PO Date">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="95px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="95px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="POQty" HeaderText="Total PO Qty" SortExpression="POQty"
                                                            DataFormatString="{0:0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="95px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="95px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="POAmt" HeaderText="Total PO Amount" SortExpression="POAmt"
                                                            DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="95px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="95px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OutstandingQty" HeaderText="Outstanding Qty" SortExpression="OutstandingQty"
                                                            DataFormatString="{0:0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="95px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="95px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Due Date" HeaderText="Due Date" SortExpression="Due Date"
                                                            DataFormatString="{0:MM/dd/yyyy}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="80px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" HorizontalAlign="Center" />
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
                                            <INPUT id="hidSort" type="hidden" name="hidSort" runat="server">
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
