<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SSDocs.aspx.cs" Inherits="SSDocs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script>
    var DocWindow;

    function pageUnload() 
    {
        if ($get("TypeHidden").value == 'SO')
        {
            SetScreenPos("SSDocSO");
        }
    }
    function ClosePage()
    {
        window.close();	
    }
    function OpenHelp(topic)
    {
        window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
    function ShowDoc(DocNo)
    {
        if (DocWindow != null) {DocWindow.close();DocWindow=null;}
        //alert(location.hostname);
        if (($get("TypeHidden").value == 'PO') || ($get("TypeHidden").value == 'WO'))
        {
            DocWindow = OpenAtPos('SSDocsDoc', 
                $get("POEURL").value + 'PORecall.aspx?PONumber='+DocNo, 'toolbar=0,scrollbars=0,status=0,resizable=0', 0, 0, 1024, 560);    
        }
        else
        {
            DocWindow = OpenAtPos('SSDocsDoc', 
                'SORecall/SORecall.aspx?DocNo='+DocNo+'&DocType=R', 'toolbar=0,scrollbars=0,status=0,resizable=0', 0, 0, 1024, 560);    
        }
    }
    function SetHeight()
    { 
        var yh = document.documentElement.clientHeight;  
        var xw = document.documentElement.clientWidth;  
        //take out room for top panel
        yh = yh - 70;
        var DetailPanel = $get("DocsPanel");
        DetailPanel.style.height = yh;  
        //var DetailGrid = $get("ItemsGridView");
        //DetailGrid.style.height = yh;  
    }
    </script>
    <title>Stock Docs</title>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/SSStyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .HeadPlace
        {
	        position:absolute;
	        left: 5px;
	        top: 50px;
        }
    </style>
</head>
<body class="bold" onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="SSDocsScriptManager" runat="server" />
        <div>
            <table width="100%" class="panelborder">
                <tr class="panelborder">
                    <td>
                        <asp:UpdatePanel ID="HeaderUpdatePanel" runat="server">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="ItemNoLabel" runat="server" Width="150px"></asp:Label>
                                            <asp:HiddenField ID="TypeHidden" runat="server" />
                                            <asp:HiddenField ID="POEURL" runat="server" />
                                        </td>
                                        <td>
                                            <asp:Label ID="ItemDescLabel" runat="server" Text="" Width="220px">
                                            </asp:Label>
                                        </td>
                                        </tr>
                                        <tr>
                                        <td>
                                            <asp:Label ID="LocationLabel" runat="server" Text="">
                                            </asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="TypeLabel" runat="server" Text="" >
                                            </asp:Label>
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
                        <asp:Panel ID="DocsPanel" runat="server" Height="700px" Width="100%" CssClass="panelborder"
                            ScrollBars="Vertical">
                            <div style="height:17px;"></div>
                            <asp:UpdatePanel ID="DocsUpdatePanel" UpdateMode="Conditional" runat="server">
                                <ContentTemplate>
                                    <asp:GridView ID="DocsGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads HeadPlace"
                                        BackColor="#f4fbfd" OnRowDataBound="DetailRowBound" Width="98%">
                                        <AlternatingRowStyle BackColor="#FFFFFF" />
                                        <Columns>
                                            <asp:BoundField DataField="DocDesc" HeaderText="Doc Type" ItemStyle-HorizontalAlign="center"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="15%" />
                                            <asp:TemplateField ItemStyle-Width="9%" HeaderText="Number" HeaderStyle-HorizontalAlign="Center"
                                                ItemStyle-HorizontalAlign="center" SortExpression="OrderNumber">
                                                <ItemTemplate>
                                                    <asp:Label ID="SSLabel" runat="server"  Text='<%# Eval("OrderNumber") %>' />
                                                    <asp:LinkButton ID="SSLink" runat="server" Text='<%# Eval("OrderNumber") %>' 
                                                     CausesValidation="false" CssClass="GridLink" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="DocStatDesc" HeaderText="Status" ItemStyle-HorizontalAlign="center"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="12%" />
                                            <asp:BoundField DataField="Quantity" ItemStyle-HorizontalAlign="right" HeaderText="Quantity"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="6%"  DataFormatString="{0:###,##0} "/>
                                            <asp:BoundField DataField="RequestDt" HeaderText="Req Date" ItemStyle-HorizontalAlign="center"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="10%" DataFormatString="{0:MM/dd/yyyy}" />
                                            <asp:BoundField DataField="PONo" HeaderText="External Doc No" ItemStyle-HorizontalAlign="left"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="14%" />
                                            <asp:BoundField DataField="AcctNo" HeaderText="Acct No" ItemStyle-HorizontalAlign="center"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="9%" />
                                            <asp:BoundField DataField="AcctName" HeaderText="Name" ItemStyle-HorizontalAlign="left"
                                                HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="25%" />
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
