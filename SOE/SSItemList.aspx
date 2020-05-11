<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SSItemList.aspx.cs" Inherits="SSItemList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
    var StockStatusWindow;
    function pageUnload() {
        SetScreenPos("SSItems");
        if (StockStatusWindow != null) {StockStatusWindow.close();}
    }
    function ClosePage()
    {
        window.close();	
    }
    function OpenHelp(topic)
    {
        window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    function DoStockStatus(ItemNo)
    {
        if (StockStatusWindow != null) {StockStatusWindow.close();StockStatusWindow=null;}
        StockStatusWindow = OpenAtPos('SSList', 'StockStatus.aspx?ItemNo='+ItemNo+'&ListCall=1', 'toolbar=0,scrollbars=0,status=0,resizable=YES', 0, 0, 1024, 560);    
    }
    function SetHeight()
    { 
        var yh = document.documentElement.clientHeight;  
        var xw = document.documentElement.clientWidth;  
        //take out room for top panel
        yh = yh - 60;
        var DetailPanel = $get("ItemsPanel");
        DetailPanel.style.height = yh;  
        //var DetailGrid = $get("ItemsGridView");
        //DetailGrid.style.height = yh;  
    }
    </script>

    <title>Stock Items</title>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/SSStyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .HeadPlace
        {
	        position:absolute;
	        left: 3px;
	        top: 35px;
        }
    </style>
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="SSItemListScriptManager" runat="server" />
        <div>
            <table width="100%">
                <tr class="panelborder">
                    <td>
                        <asp:UpdatePanel ID="HeaderUpdatePanel" runat="server">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td align="right" class="bold">
                                            &nbsp;&nbsp;Category
                                        </td>
                                        <td>
                                            <asp:Label CssClass="ws_whitebox" ID="CatTextBox" runat="server" Width="50px"></asp:Label>
                                        </td>
                                        <td align="right" class="bold">
                                            &nbsp;&nbsp;Size
                                        </td>
                                        <td>
                                            <asp:Label CssClass="ws_whitebox" ID="SizeTextBox" runat="server" Width="40px"></asp:Label>
                                        </td>
                                        <td align="right" class="bold">
                                            &nbsp;&nbsp;Variance
                                        </td>
                                        <td>
                                            <asp:Label CssClass="ws_whitebox" ID="VarTextBox" runat="server" Width="30px"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td align="right">
                        <img src="Common/images/help.gif" style="cursor: hand" alt="Click here for Help"
                            onclick="OpenHelp('StockItems');" />&nbsp;
                        <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="~/Common/Images/Close.gif"
                            PostBackUrl="javascript:window.close();" CausesValidation="false" ToolTip="Close the Report Window" />&nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="middle" colspan="2">
                        <asp:Panel ID="ItemsPanel" runat="server" Height="700px" Width="100%" CssClass="panelborder"
                            ScrollBars="Vertical">
                            <div style="height:17px;"></div>
                            <asp:UpdatePanel ID="ItemsUpdatePanel" UpdateMode="Conditional" runat="server">
                                <ContentTemplate>
                                    <asp:GridView ID="ItemsGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads HeadPlace"
                                        BackColor="#f4fbfd" OnRowDataBound="DetailRowBound" Width="98%">
                                        <AlternatingRowStyle BackColor="#FFFFFF" />
                                        <Columns>
                                            <asp:TemplateField ItemStyle-Width="20%" HeaderText="Item Number" HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-HorizontalAlign="center" SortExpression="ItemNo">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="SSLink" runat="server" Text='<%# Eval("ItemNo") %>' 
                                                     CausesValidation="false" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="ItemDesc" HeaderText="Description" ItemStyle-HorizontalAlign="Left"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="45%" />
                                            <asp:BoundField DataField="SellGlued" HeaderText="Qty/Unit" ItemStyle-HorizontalAlign="right"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="15%" />
                                            <asp:TemplateField ItemStyle-Width="20%" HeaderText="Parent Item No" HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-HorizontalAlign="center" SortExpression="ParentProdNo">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="SPLink" runat="server" Text='<%# Eval("ParentProdNo") %>' 
                                                     CausesValidation="false" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
