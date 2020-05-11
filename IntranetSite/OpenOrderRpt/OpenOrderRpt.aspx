<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OpenOrderRpt.aspx.cs" Inherits="OpenOrderRpt" %>

<%@ Register Src="UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc3" %>
<%@ Register Src="UserControls/Header.ascx" TagName="Header" TagPrefix="uc2" %>
<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Open Order Report</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />    
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script language="javascript" src="../Common/javascript/ContextMenu.js"></script>

    <script>

    function LoadHelp()
    {
        window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }
    
    function PrintReport()
    {   
        var URL = "OpenOrderRptPreview.aspx?SortCommand=" + document.getElementById("hidSort").value +
                                            "&Cust=" + document.getElementById("hidCust").value +
                                            "&OrdType=" + document.getElementById("hidOrdType").value +
                                            "&SalesPerson=" + document.getElementById("hidSalesPerson").value +
                                            "&CustShipLoc=" + document.getElementById("hidCustShipLoc").value +
                                            "&ShipLoc=" + document.getElementById("hidShipLoc").value +
                                            "&OrdTypeDesc=" + getQuerystring("OrdTypeDesc") +
                                            "&CustShipLocDesc=" + getQuerystring("CustShipLocDesc") +
                                            "&ShipLocDesc=" + getQuerystring("ShipLocDesc") +
                                            "&BadMgn=" + document.getElementById("hidBadMgn").value;
        window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }
    
    function Close(session)
    {
        OpenOrderRpt.DeleteExcel('OpenOrderRpt'+session).value;        
        window.close();
    }

    function getQuerystring(key, default_)
    {
      if (default_==null) default_=""; 
      key = key.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
      var regex = new RegExp("[\\?&]"+key+"=([^&#]*)");
      var qs = regex.exec(window.location.href);
      if(qs == null)
        return default_;
      else
        return qs[1];
    }
    </script>

</head>
<body  onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server" >
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="100%" height="400" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="2" valign="middle">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="2">
                                            <uc2:Header ID="Header1" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td class="PageHead" colspan="4" style="height: 30px">
                                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                            <tr>
                                                                <td class="Left5pxPadd BannerText" width="70%">
                                                                    Open Order Report
                                                                </td>
                                                                <td align="right" style="width: 30%; padding-right: 5px;">
                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="../Common/images/ExporttoExcel.gif"
                                                        OnClick="ExportRpt_Click" />
                                                                            </td>
                                                                            <td>
                                                                                <img src="../Common/images/Print.gif" onclick="Javascript:PrintReport();" style="cursor: hand" />                                                                                    
                                                                            </td>
                                                                            <td>
                                                                                <img src="../Common/images/close.gif" onclick="Javascript:Close('<%=Session["SessionID"].ToString() %>');" style="cursor: hand" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="PageBg">
                            <td colspan="2"  class="LeftPadding TabHead">
                                <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label1" runat="server" Text="Cust No:" Width="50px" Height="20px"></asp:Label></td>
                                                <td style="width: 160px">
                                                    <asp:Label ID="lblCustNo" runat="server" Width="80px" Height="20px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="Label3" runat="server" Text="Order Type:" Width="70px" Height="20px"></asp:Label></td>
                                                <td style="width: 160px">
                                                    <asp:Label ID="lblOrderType" runat="server" Width="160px" Height="20px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="Label7" runat="server" Height="20px" Text="Salesperson:" Width="80px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblSalesPerson" runat="server" Height="20px" Width="99px"></asp:Label></td>
                                            </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label2" runat="server" Height="20px" Text="Sales Loc:" Width="60px"></asp:Label></td>
                                        <td style="width: 160px">
                                            <asp:Label ID="lblSalesLoc" runat="server" Height="20px" Width="160px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="Label5" runat="server" Height="20px" Text="Ship Loc:" Width="60px"></asp:Label></td>
                                        <td style="width: 160px">
                                            <asp:Label ID="lblShipLoc" runat="server" Height="20px" Width="160px"></asp:Label></td>
                                        <td colspan="2">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label9" runat="server" Height="20px" Text="Show:" Width="40px"></asp:Label></td>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="lblLineType" runat="server" Height="20px" Width="137px"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                        </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr style="padding-left:1px;">
                                        <td valign="top" style="height: 314px; width: 100%;">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; width: 1015px; height: 500px; border: 0px solid;">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" Width="1445" runat="server" BorderWidth="1px"
                                                    ShowFooter="False" AutoGenerateColumns="False" PageSize="20" AllowSorting="true" UseAccessibleHeader=false
                                                    AllowPaging="true" PagerStyle-Visible="false" OnSortCommand="GridView1_SortCommand" OnItemDataBound="GridView1_ItemDataBound">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD"  Height=18px />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" Height=18px/>
                                                   <Columns>
                                                        <asp:BoundColumn DataField="CustNo" HeaderText="Cust No" SortExpression="CustNo">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CustName" HeaderText="Cust Name" SortExpression="CustName">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="275px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="275px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SONumber" HeaderText="SO Number" SortExpression="SONumber">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PONumber" HeaderText="PO Number" SortExpression="PONumber">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="90px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="90px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Ref" HeaderText="Reference" SortExpression="Ref">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="140px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="140px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Item" HeaderText="Item No" SortExpression="Item">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="120px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="120px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Description" HeaderText="Description" SortExpression="Description">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="325px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="325px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Quantity" HeaderText="Quantity" SortExpression="Quantity" DataFormatString="{0:0}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="UOM" HeaderText="UOM" SortExpression="UOM">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="40px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="40px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="UnitPrice" HeaderText="Unit Price" SortExpression="UnitPrice" DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Mgn%" HeaderText="Mgn %" SortExpression="Mgn%" DataFormatString="{0:0.00%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OrderDt" HeaderText="Order Date" SortExpression="OrderDt" DataFormatString="{0:MM/dd/yyyy}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="80px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ShipDt" HeaderText="Ship Date" SortExpression="ShipDt" DataFormatString="{0:MM/dd/yyyy}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="80px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="80px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SalesLoc" HeaderText="Sell Loc" SortExpression="SalesLoc">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="20px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="20px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ShipLoc" HeaderText="Ship Loc" SortExpression="ShipLoc">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="20px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="20px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AltPrice" HeaderText="Alt Price" SortExpression="AltPrice" DataFormatString="{0:C}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="60px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="60px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AltUOM" HeaderText="Alt UOM" SortExpression="Alt UOM">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="30px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="30px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SalesPerson" HeaderText="Salesperson" SortExpression="SalesPerson">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
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
                                            <uc1:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" Visible="false" />
                                            <input id="hidSort" type="hidden" name="hidSort" runat="server">
                                            <asp:HiddenField ID="hidReferer" runat="server" />
                                            <asp:HiddenField ID="hidCust" runat="server" />
                                            <asp:HiddenField ID="hidOrdType" runat="server" />
                                            <asp:HiddenField ID="hidSalesPerson" runat="server" />
                                            <asp:HiddenField ID="hidCustShipLoc" runat="server" />
                                            <asp:HiddenField ID="hidShipLoc" runat="server" />
                                            <asp:HiddenField ID="hidBadMgn" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" width="100%">
                    <uc3:Footer ID="Footer1" Title="Open Order Report" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
