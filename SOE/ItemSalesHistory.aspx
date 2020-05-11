<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemSalesHistory.aspx.cs" Inherits="ShowItemSalesHistory" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script>
        function pageUnload() {
            SetScreenPos("ItemHistory");
        }
        function ClosePage()
        {
            window.close();	
        }
        function OpenHelp(topic)
        {
            window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
        }
        function LoadRefData()
        {
            if (document.getElementById('HasProcessed').value != '1') 
            {
                // process once
                document.getElementById('HasProcessed').value = '1';
                // load the page data. hidden fields are used for data needed to feed the stored procedure
                document.getElementById('SoldToNoLabel').innerText = 
                    window.opener.parent.document.getElementById('CustNoTextBox').value;
                document.getElementById('CustNoHidden').value = 
                    window.opener.parent.document.getElementById('CustNoTextBox').value;
                document.getElementById('SoldToNameLabel').innerText = 
                    window.opener.parent.document.getElementById('CustNameLabel').innerText;
                document.getElementById('SoldToCityStateLabel').innerText = 
                    window.opener.parent.document.getElementById('SoldToCity').value +
                    ', ' + window.opener.parent.document.getElementById('SoldToState').value +
                    ' ' + window.opener.parent.document.getElementById('SoldToZip').value +
                    ' ' + window.opener.parent.document.getElementById('SoldToCountry').value;
                document.getElementById('SoldToPhoneLabel').innerText = 
                    window.opener.parent.document.getElementById('SoldToPhone').value;
                document.getElementById('ShipToNoLabel').innerText = 
                    window.opener.parent.document.getElementById('ShipToNo').value;
                document.getElementById('ShipToNameLabel').innerText = 
                    window.opener.parent.document.getElementById('ShipToName').value;
                document.getElementById('ShipToCityStateLabel').innerText = 
                    window.opener.parent.document.getElementById('ShipToCity').value +
                    ', ' + window.opener.parent.document.getElementById('ShipToState').value +
                    ' ' + window.opener.parent.document.getElementById('ShipToZip').value +
                    ' ' + window.opener.parent.document.getElementById('ShipToCountry').value;
                document.getElementById('ShipToPhoneLabel').innerText = 
                    window.opener.parent.document.getElementById('ShipToPhone').value;
                document.getElementById('PriceCodeLabel').innerText = 
                    window.opener.parent.document.getElementById('HeadingPriceCodeLabel').innerText;
                document.getElementById('ItemNoLabel').innerText = 
                    window.opener.parent.document.getElementById('InternalItemLabel').innerText;
                document.getElementById('ItemNoHidden').value = 
                    window.opener.parent.document.getElementById('InternalItemLabel').innerText;
                document.getElementById('DescriptionLabel').innerText = 
                    window.opener.parent.document.getElementById('ItemDescLabel').innerText;
                document.getElementById('DescriptionHidden').innerText = 
                    window.opener.parent.document.getElementById('ItemDescLabel').innerText;
                //alert(window.opener.parent.document.getElementById('InternalItemLabel').innerText);
                // Make it happen
                document.getElementById('ItemSubmit').click();
            }
        }
    </script>
    <title>Item Sales History</title>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#ECF9FB"  onload="LoadRefData();">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ItemHistoryScriptManager" runat="server" EnablePartialRendering="true"/>
    <div>
        <table width="800px">
            <tr>
                <td class="Left5pxPadd">
                    <table width="790px" style="border:1px solid #88D2E9; ">
                        <tr>
                            <td class="Left5pxPadd" valign="top">
                                <table>
                                    <tr>
                                        <td class="bold">Sold To:
                                        </td>
                                        <td>
                                            <asp:Label ID="SoldToNameLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="5" valign="top">
                                            <asp:Label ID="SoldToNoLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="SoldToAddr1Label" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="SoldToAddr2Label" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="SoldToCityStateLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="SoldToPhoneLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top">
                                <table>
                                    <tr>
                                        <td class="bold">Ship To:
                                        </td>
                                        <td>
                                            <asp:Label ID="ShipToNameLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="5" valign="top">
                                            <asp:Label ID="ShipToNoLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="ShipToAddr1Label" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="ShipToAddr2Label" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="ShipToCityStateLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="ShipToPhoneLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top">
                                <table>
<%--                                    <tr>
                                        <td class="bold">Rep No:
                                        </td>
                                        <td>
                                            <asp:Label ID="RepNoLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bold">Rep Name:
                                        </td>
                                        <td>
                                            <asp:Label ID="RepNameLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
--%>                                    <tr>
                                        <td class="bold">Price Code:
                                        </td>
                                        <td>
                                            <asp:Label ID="PriceCodeLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
<%--                                    <tr>
                                        <td class="bold">Contract No:
                                        </td>
                                        <td>
                                            <asp:Label ID="ContactNoLabel" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
--%>                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="Left5pxPadd">
                <asp:UpdatePanel ID="ItemUpdatePanel" runat="server" UpdateMode="Conditional"><ContentTemplate>
                 <table width="790px" style="border:1px solid #88D2E9; ">
                    <tr class="bold">
                        <td align="right"><div >Item #</div>
                        </td>
                        <td>
                            <asp:Label CssClass="lbl_whitebox" ID="ItemNoLabel" runat="server" Text="" Width="100px"
                             ></asp:Label>&nbsp;
                            <asp:HiddenField ID="ItemNoHidden" runat="server" />
                        </td>
                        <td align="right"><div  >Description:</div>
                        </td>
                        <td>
                            <asp:Label CssClass="lbl_whitebox" ID="DescriptionLabel" runat="server" Text=" " Width="250px"
                             ></asp:Label>
                            <asp:HiddenField ID="DescriptionHidden" runat="server" />
                            <asp:Button id="ItemSubmit" name="ItemSubmit" OnClick="ShowHistoryButton_Click"
                                    runat="server" Text="Button"  style="display:none;"/>
                            <asp:HiddenField ID="HasProcessed" runat="server"  Value="0"/>
                            <asp:HiddenField ID="CustNoHidden" runat="server" />
                       </td>
                    </tr>
                </table>
                </ContentTemplate>
                <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ItemSubmit" />
                </Triggers>
                </asp:UpdatePanel>
               </td>
            </tr>
            <tr>
                <td class="Left5pxPadd" align="center" valign="middle">
                    <asp:Panel ID="HistoryPanel" runat="server" Height="260px" width="790px" 
                    style="border:1px solid #88D2E9; background-color:#FFFFFF" >
                        <asp:UpdatePanel ID="HistoryUpdatePanel" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                        <asp:GridView ID="HistoryGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                         Width="98%" RowStyle-CssClass="priceDarkLabel">
                        <AlternatingRowStyle CssClass="priceLightLabel" />
                        <Columns>
                        <asp:BoundField DataField="FiscalPeriodNo" HeaderText="Period"  DataFormatString="{0:####/##} "
                        ItemStyle-HorizontalAlign="Right"/>
                        <asp:BoundField DataField="LatestSalesPrice" HeaderText="Latest Price" DataFormatString="${0:#,##0.00} " 
                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60"/>
                        <asp:BoundField DataField="LatestSalesCost" HeaderText="Latest Cost" DataFormatString="${0:#,##0.00} " 
                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60"/>
                        <asp:BoundField DataField="LatestMargin" DataFormatString="%{0:#,##0.0} " HeaderText="Latest Margin"
                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60"/>
                        <asp:BoundField DataField="LatestPriceLB" DataFormatString="${0:#,##0.00} " HeaderText="Latest $/LB"
                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60" />
                        <asp:BoundField DataField="QtyShipped" HeaderText="Shipped"  DataFormatString="{0:#,##0} "
                        ItemStyle-HorizontalAlign="Right"/>
                        <asp:BoundField DataField="QtyOrdered" HeaderText="Ordered"  DataFormatString="{0:#,##0} "
                        ItemStyle-HorizontalAlign="Right"/>
                        <asp:BoundField DataField="TotalWeight" HeaderText="Total Weight" DataFormatString="{0:#,##0} " 
                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="60"/>
                        <asp:BoundField DataField="NoofOrders" HeaderText="# Orders"  DataFormatString="{0:#,##0} "
                        ItemStyle-HorizontalAlign="Right"/>
                        <asp:BoundField DataField="SalesDollars"  HeaderText="Sales" DataFormatString="${0:#,##0} " 
                        ItemStyle-HorizontalAlign="Right"/>
                        <asp:BoundField DataField="SalesCost"  HeaderText="Cost" DataFormatString="${0:#,##0} "
                        ItemStyle-HorizontalAlign="Right"/>
                        </Columns>
                        </asp:GridView>
                        </ContentTemplate>
                        </asp:UpdatePanel>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%">
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional"><ContentTemplate>
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td align="right">
                            <img src="Common/images/help.gif" style="cursor:hand" alt="Click here for Help"
                                            onclick="OpenHelp('ItemHistory');" />&nbsp;&nbsp;
                            <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();" alt="Close Page">&nbsp;&nbsp;
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
<script>
    //alert(window.opener.parent.document.getElementById('SoldToCity').value);
    //document.form1.SoldToPhone.value = window.opener.parent.bodyFrame.document.getElementById('CustDet_lblSold_Phone').innerText;
</script>
</html>
