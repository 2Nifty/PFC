<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CriticalItemRpt.aspx.vb"
    Inherits="CriticalItemRpt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>BULK Critical Item Report Summary</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="javascript/ContextMenu.js"></script>

    <script language="javascript" src="javascript/browsercompatibility.js"></script>

    <script language="javascript">

    function ViewBranch(VelocityCode)
    {
//        var URL = "CriticalItemRptBr.aspx?VelocityCode=" + VelocityCode + "~VelocityType=" + document.getElementById("VelocityType").value
        var URL = "CriticalItemRptBr.aspx?VelocityType=" + document.getElementById("VelocityType").value + "~VelocityCode=" + VelocityCode
        URL = "ProgressBar.aspx?destPage=" + URL
        window.open(URL,'Branch','height=710,width=1020,scrollbars=no,status=yes,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    } 

    function ViewDetail(VelocityCode)
    {
        var URL = "CriticalItemDet.aspx?Critical=0~VelocityCode=" + VelocityCode + "~VelocityType=" + document.getElementById("VelocityType").value + "~LocNum=" + document.getElementById("LocNum").value + "~LocDesc=" + document.getElementById("LocDesc").value
        URL = "ProgressBar.aspx?destPage=" + URL
        window.open(URL,'Detail','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }                                                        

    function ViewAllDetail(URL)
    {
        URL = URL + "?Critical=0~VelocityCode=~VelocityType=~LocNum=" + document.getElementById("LocNum").value + "~LocDesc=" + document.getElementById("LocDesc").value
        URL = "ProgressBar.aspx?destPage=" + URL
        var w = window.open(URL,'Detail','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
        w.focus()
        return false
    }  

    function ViewCritical(VelocityCode)
    {
        var URL = "CriticalItemDet.aspx?Critical=1~VelocityCode=" + VelocityCode + "~VelocityType=" + document.getElementById("VelocityType").value + "~LocNum=" + document.getElementById("LocNum").value + "~LocDesc=" + document.getElementById("LocDesc").value
        URL = "ProgressBar.aspx?destPage=" + URL
        window.open(URL,'Critical','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
    }  

    function ViewAllCritical(URL)
    {
        URL = URL + "?Critical=1~VelocityCode=~VelocityType=~LocNum=" + document.getElementById("LocNum").value + "~LocDesc=" + document.getElementById("LocDesc").value
        URL = "ProgressBar.aspx?destPage=" + URL
        var w = window.open(URL,'Detail','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
        w.focus()
        return false
    }   

    function PrintReport()
    {
        var URL = "CriticalItemRptPreview.aspx?VelocityType=" + document.getElementById("VelocityType").value + "&LocNum=" + document.getElementById("LocNum").value + "&LocDesc=" + document.getElementById("LocDesc").value;
        window.open(URL,'Preview','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES','');
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
                                                    BULK Critical Item Report Summary
                                                    <asp:HiddenField ID="VelocityType" runat="server" />
                                                    <asp:HiddenField ID="LocNum" runat="server" />
                                                    <asp:HiddenField ID="LocDesc" runat="server" />
                                                </div>
                                            </div>
                                        </td>
                                        <td align="right" valign="middle">
                                            <asp:ImageButton ID="ExportRpt" runat="server" Style="cursor: hand" ImageUrl="images/ExporttoExcel.gif" />
                                            <img src="images/Print.gif"  onclick="Javascript:PrintReport();" style="cursor: hand" />
                                            <img src="Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                            <img src="images/close.gif" onclick="javascript:window.history.back();" style="cursor: hand" />
                                        </td>
                                    </tr>
                                    <tr class="PageBg" height="30px">
                                       <td align="left" valign="middle" class="TabHead">
                                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                          <asp:RadioButton ID="RBCorp" GroupName="VelocityCode" runat="server" Text="Corp Fixed Velocity" AutoPostBack="true" />
                                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                          <asp:RadioButton ID="RBCat" GroupName="VelocityCode" runat="server" Text="Category Velocity" AutoPostBack="true" />
                                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;                                          
                                          <asp:DropDownList AutoPostBack="true" ID="LocationList" runat="server" />
                                       </td>
                                       <td></td>
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
                                                left: 0px; width: 1000px; height: 300px; border: 0px solid;">
                                                <asp:DataGrid ID="GridView1" BackColor="#F4FBFD" runat="server" BorderWidth="1px" 
                                                    AutoGenerateColumns="False" ShowFooter="True">
                                                    <HeaderStyle BackColor="#DFF3F9" Font-Bold="True" HorizontalAlign="Center" CssClass="GridHead" />
                                                    <ItemStyle CssClass="GridItem" BorderStyle="Solid" Wrap="False" BackColor="#F4FBFD" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                    <AlternatingItemStyle CssClass="GridItem" BackColor="White" />
                                                    <Columns>
                                                        <%-- Column 00 --%>
                                                        <asp:HyperLinkColumn DataTextField="VelocityCode" DataNavigateUrlField="VelocityCode"
                                                            DataNavigateUrlFormatString="javascript:ViewBranch('{0}');"
                                                            HeaderText="Velocity Code" SortExpression="VelocityCode">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Center" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:HyperLinkColumn>

                                                        <%-- Column 01 --%>
                                                        <asp:HyperLinkColumn DataTextField="TotCount" DataNavigateUrlField="VelocityCode"
                                                            DataTextFormatString="{0:N0}" DataNavigateUrlFormatString="javascript:ViewDetail('{0}');"
                                                            HeaderText="Item Count" SortExpression="TotCount">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:HyperLinkColumn>

                                                        <%-- Column 02 --%>
                                                        <asp:BoundColumn DataField="TotCount" Visible="false" />

                                                        <%-- Column 03 --%>
                                                        <asp:HyperLinkColumn DataTextField="CriticalCount" DataNavigateUrlField="VelocityCode"
                                                            DataTextFormatString="{0:N0}" DataNavigateUrlFormatString="javascript:ViewCritical('{0}');"
                                                            HeaderText="Critical Item Count" SortExpression="CriticalCount">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:HyperLinkColumn>

                                                        <%-- Column 04 --%>                                                        
                                                        <asp:BoundColumn DataField="CriticalCount" Visible="false" />
                                                        
                                                        <%-- Column 05 --%>
                                                        <asp:BoundColumn DataField="CriticalCountPct" HeaderText="% Critical" SortExpression="CriticalCountPct"
                                                            DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <%-- Column 06 --%>
                                                        <asp:BoundColumn DataField="TotWght" HeaderText="30D Usage Lbs" SortExpression="TotWght">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <%-- Column 07 --%>
                                                        <asp:BoundColumn DataField="TotWghtCritical" HeaderText="Critical Pounds" SortExpression="TotWghtCritical">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="100px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="100px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <%-- Column 08 --%>
                                                        <asp:BoundColumn DataField="CriticalWghtPct" HeaderText="% Critical (Pounds)" SortExpression="CriticalWghtPct"
                                                            DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <%-- Column 09 --%>
                                                        <asp:BoundColumn DataField="NonCriticalWghtPct" HeaderText="% Non Critical (Pounds)"
                                                            SortExpression="NonCriticalWghtPct" DataFormatString="{0:0.0%}">
                                                            <ItemStyle CssClass="GridItem" HorizontalAlign="Right" Width="75px" />
                                                            <FooterStyle CssClass="GridHead" />
                                                            <HeaderStyle CssClass="GridHead" Width="75px" Font-Bold="True" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>

                                                        <%-- Column 10 --%>
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
</body>
</html>
