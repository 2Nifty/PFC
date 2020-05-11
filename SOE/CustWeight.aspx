<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustWeight.aspx.cs" Inherits="CustWeight" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="PageFooter" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script>
    function pageUnload() {
        SetScreenPos("CustWeight");
    }
    function ClosePage()
    {
        window.close();	
    }
    function OpenHelp(topic)
    {
        window.open('WorkSheetHelp.aspx#' + topic + '','WorkSheetHelp','height=768,width=650,toolbar=0,scrollbars=0,status=0,resizable=YES,left=0','');    
    }
        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 78;
            //var maindiv = $get("maindiv")
            //maindiv.style.height = document.documentElement.clientHeight;  
            var HeaderPanel = $get("HeaderPanel")
            HeaderPanel.style.height = yh * 0.2;  
            var WeightPanel = $get("WeightPanel")
            WeightPanel.style.height = (yh * 0.8);  
            
        }
    </script>
    <title>Weights V1.0.0</title>
    <script src="Common/JavaScript/WorkSheet.js" type="text/javascript"></script>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/PriceSheetStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#DFF3F9" onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="CustWeightScriptManager" runat="server" EnablePartialRendering="true"/>
    <div>
        <table width="100%">
            <tr>
                <td class="Left5pxPadd">
                    <asp:Panel ID="HeaderPanel" runat="server" style="border: 1px solid #88D2E9; display: block;">
                    <asp:UpdatePanel ID="HeaderUpdatePanel" runat="server">
                    <ContentTemplate>
                    <table >
                        <tr>
                            <td class="Left5pxPadd" valign="top">
                                <table>
                                    <tr>
                                        <td class="bold">Customer:
                                        </td>
                                        <td>
                                            <asp:Label CssClass="ws_whitebox_left" ID="CustNoLabel" runat="server" Text="" Width="280px"
                                            TabIndex=1 ></asp:Label>&nbsp;
                                            <asp:HiddenField ID="CustNoHid" runat="server" />
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="bold" >
                                            Address:
                                        </td>
                                        <td>
                                            <asp:Label CssClass="ws_whitebox_left" ID="AddressLabel" runat="server" Text="" Width="280"
                                            ></asp:Label>
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="bold">ShipLoc:
                                        </td>
                                        <td>
                                            <asp:Label CssClass="ws_whitebox_left" ID="ShipLocLabel" runat="server" Text="" Width="40px"
                                            TabIndex=1 ></asp:Label>&nbsp;
                                        </td>
                                        <td>
                                            <asp:UpdateProgress ID="HeaderUpdateProgress" runat="server">
                                            <ProgressTemplate>
                                            Loading....
                                            <asp:Image ID="ProgressImage" ImageUrl="Common/Images/PFCYellowBall.gif" runat="server" />
                                            </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td class="Left5pxPadd" align="left" valign="middle">
                    <asp:Panel ID="WeightPanel" runat="server" Width="99%" style="border:1px solid #88D2E9; background-color:#FFFFFF" 
                     ScrollBars="Vertical" >
                        <asp:UpdatePanel ID="WeightsUpdatePanel" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                        <asp:GridView ID="WeightsGridView" runat="server" AutoGenerateColumns="false" HeaderStyle-CssClass="GridHeads"
                         Width="90%" RowStyle-CssClass="priceDarkLabel" >
                        <AlternatingRowStyle CssClass="priceLightLabel" />
                        <Columns>
                        <asp:BoundField DataField="ShipLoc" HeaderText="" 
                            ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="40"/>
                        <asp:BoundField DataField="ShipLocName" HeaderText="Location"
                            ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="100"/>
                        <asp:BoundField DataField="CarrierGlued" HeaderText="Carrier" ItemStyle-CssClass="Left5pxPadd" 
                            ItemStyle-HorizontalAlign="left" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="150"/>
                        <asp:BoundField DataField="CarrierWeight" HeaderText="Weight" DataFormatString="{0:##,###,##0.00} " 
                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="95"/>
                        </Columns>
                        </asp:GridView>
                        </ContentTemplate>
                        </asp:UpdatePanel>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td class="Left5pxPadd">
                    <table width="100%" style="border: 1px solid #88D2E9; ">
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional"><ContentTemplate>
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td align="right">
                            <asp:ImageButton ID="CloseButt" ImageUrl="Common/Images/close.gif"
                                onkeyDown="javascript:if(event.keyCode==9 || event.keyCode==13){this.click();return false;}"
                                OnClientClick="ClosePage();"
                                runat="server" AlternateText="Close Page" AccessKey="C" ToolTip="Close Page" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <uc1:PageFooter ID="WeightFoot"  Title="Customer Sched to Ship Weight" runat="server" />
        </table>
    </div>
    </form>
</body>
</html>
