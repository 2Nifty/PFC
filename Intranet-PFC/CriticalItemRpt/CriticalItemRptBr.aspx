<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CriticalItemRptBr.aspx.vb" Inherits="CriticalItemRptBr" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Branch Critical Item Report Summary</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="javascript/ContextMenu.js"></script>

    <script language="javascript" src="javascript/browsercompatibility.js"></script>

    <script language="javascript">

    function ViewDetail(LocNum)
    {
        var URL = "CriticalItemDet.aspx?Critical=0~VelocityCode=" + document.getElementById("VelocityCode").value + "~VelocityType=" + document.getElementById("VelocityType").value + "~LocNum=" + LocNum
        URL = "ProgressBar.aspx?destPage=" + URL
        window.open(URL,'DetailBr','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }                                                        

    function ViewCritical(LocNum)
    {
        var URL = "CriticalItemDet.aspx?Critical=1~VelocityCode=" + document.getElementById("VelocityCode").value + "~VelocityType=" + document.getElementById("VelocityType").value + "~LocNum=" + LocNum
        URL = "ProgressBar.aspx?destPage=" + URL
        window.open(URL,'CriticalBr','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }  

    function PrintReport()
    {
//        var URL = "CriticalItemRptPreviewBr.aspx?LocNum=" + document.getElementById("LocNum").value + "&LocDesc=" + document.getElementById("LocDesc").value
        var URL = "CriticalItemRptPreviewBr.aspx?VelocityCode=" + document.getElementById("VelocityCode").value + "&VelocityType=" + document.getElementById("VelocityType").value
        window.open(URL,'PreviewBr','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }

    function LoadHelp()
    {
        window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }

    </script>

</head>
<body bottommargin="0" onmouseup="Hide();">
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
                            <td class="PageHead" width="100%" height="100%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td valign="middle" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Branch Critical Item Report Summary&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <asp:DropDownList AutoPostBack="true" ID="ddVelocityList" runat="server" />
                                                    <asp:HiddenField ID="VelocityCode" runat="server" />
                                                    <asp:HiddenField ID="VelocityType" runat="server" />
                                                </div>
                                            </div>
                                        </td>
                                        <td align="right" valign="middle">
                                            <asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="images/ExporttoExcel.gif" />
                                            <img src="images/Print.gif"  onclick="Javascript:PrintReport();" style="cursor: hand" />
                                            <img src="Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                            <img src="images/close.gif" onclick="javascript:parent.window.close();;" style="cursor: hand" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" width="100%">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; width: 1000px; height: 450px; border: 0px solid;">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px" 
                                                    AutoGenerateColumns="False" ShowFooter="True">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="Location" HeaderText="Location" SortExpression="Location">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Left" Width="175px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="175px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:HyperLinkColumn DataTextField="TotCount" DataNavigateUrlField="LocationCode"
                                                            DataTextFormatString="{0:N0}" DataNavigateUrlFormatString="javascript:ViewDetail('{0}');"
                                                            HeaderText="Item Count" SortExpression="TotCount">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:HyperLinkColumn>

                                                        <asp:BoundColumn DataField="TotCount" Visible="false" />

                                                        <asp:HyperLinkColumn DataTextField="CriticalCount" DataNavigateUrlField="LocationCode"
                                                            DataTextFormatString="{0:N0}" DataNavigateUrlFormatString="javascript:ViewCritical('{0}');"
                                                            HeaderText="Critical Item Count" SortExpression="CriticalCount">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:HyperLinkColumn>
                                                        
                                                        <asp:BoundColumn DataField="CriticalCount" Visible="false" />
                                                        
                                                        <asp:BoundColumn DataField="CriticalCountPct" HeaderText="% Critical" SortExpression="CriticalCountPct"
                                                            DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TotWght" HeaderText="30D Usage Lbs" SortExpression="TotWght">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TotWghtCritical" HeaderText="Critical Pounds" SortExpression="TotWghtCritical">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CriticalWghtPct" HeaderText="% Critical (Pounds)" SortExpression="CriticalWghtPct"
                                                            DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NonCriticalWghtPct" HeaderText="% Non Critical (Pounds)"
                                                            SortExpression="NonCriticalWghtPct" DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TargetPct" HeaderText="Target %" SortExpression="TargetPct"
                                                            DataFormatString="{0:0.0%}">
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
                    </table>
                </td>
            </tr>
        </table>
    </form>
        <script>window.parent.document.getElementById("Progress").style.display='none';</script>
</body>
</html>
