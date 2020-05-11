<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LoadRegionPreview.aspx.cs" Inherits="SystemFrameSet_LoadRegionPreview" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Region Sales Performance - Print Preview</title>
      <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
      <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
      <script type="text/javascript">
        function printReport()
        {
             var prtContent = '<html><head><link href="../common/StyleSheet/styles.css" rel="stylesheet" type="text/css" /> <link href="../Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" /></head><body>';
             prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%' ><tr><td style='width:350px;padding-left:25px;'colspan=3 ><h3>Regional Sales Performance</h3></td></tr>";
             prtContent = prtContent +"</table><br>"; 
             prtContent = prtContent +"<table widht=100%><tr><td>";
             prtContent = prtContent + document.getElementById("tdRegionName").innerHTML;  
             prtContent = prtContent +"</td></tr></table><br>";
             prtContent = prtContent +"<br>"; 
             prtContent = prtContent + document.getElementById("4TD").innerHTML;     
             prtContent = prtContent + "</body></html>";
             var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
             prtContent = prtContent.replace(/BORDER-COLLAPSE: collapse;/i,"border-collapse:separate;");
             prtContent = prtContent.replace(/BORDER-LEFT: #c9c6c6 1px solid;/i,"BORDER-LEFT: #c9c6c6 0px solid;");
             prtContent = prtContent.replace(/BORDER-RIGHT: #c9c6c6 1px solid;/i,"BORDER-RIGHT: #c9c6c6 0px solid;");
             prtContent = prtContent.replace(/BORDER-TOP: #c9c6c6 1px solid;/i,"BORDER-TOP: #c9c6c6 0px solid;");
             prtContent = prtContent.replace(/BORDER-BOTTOM: #c9c6c6 1px solid;/i,"BORDER-BOTTOM: #c9c6c6 0px solid;");
             WinPrint.document.write(prtContent);
             WinPrint.document.close();
             WinPrint.focus();
             WinPrint.print();
             WinPrint.close();
             window.close();  
        }
      </script>
</head>
<body >
    <form id="form1" runat="server" >
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                        <tr>
                            <td width="62%" valign="middle">
                                <img src="../Common/Images/Logo.gif" height="50" hspace="25" vspace="10"></td>
                            <td width="38%" valign="bottom" class="10pxPadding">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top">                      
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder" align="center">
                                <tr>
                                    <td width="100%">
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0" class="blueBorder lightBlueBg"
                                            style="border-left: none; border-right: none; border-top: none" >
                                            <tr>
                                                <td align="left">
                                                    <span style="color: #CC0000; font-size: 18px; margin: 0px; padding: 0px; font-weight: normal;
                                                        line-height: 35px; margin-left: 10px;">Region Sales Performance </span>
                                                </td>
                                                <td align="right"><table cellpadding=0 cellspacing=0><tr> <td  >
                                                    <img ID="ibtnPrint"  src="../common/images/print.gif" onclick="printReport();" />
                                                </td>
                                                <td align="right" style="width:1px !important;padding:0px 5px;">
                                                    <asp:ImageButton ID="imgClose" runat="server" ImageUrl="../common/images/close.gif" OnClientClick="javascript:window.close();" />
                                                    <%--<img id="imgClose" align="right" style="cursor: hand" onclick="javascript:window.close();"
                                                        src="../common/images/close.gif" />--%>
                                                </td></tr></table></td>
                                                
                                            </tr>
                                            <tr class="PageBg" id="tdRegionName" height="20">
                                                <td align="left"  class="TabHead" style="padding-left:10px">
                                                    <asp:Label ID="Label1" runat="server" Text="Region Name:"></asp:Label>
                                                    &nbsp;&nbsp;
                                                    <asp:Label ID="lblRegionName" runat="server" Text=""></asp:Label>
                                                </td>
                                                <td class="TabHead" align="right" width =20% colspan="2" nowrap="nowrap">
                                                    Run By :
                                                    <%= Session["UserName"]%>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Run Date :
                                                    <%=DateTime.Now.ToShortDateString()%>
                                                </td>
                                                
                                            </tr>                                                
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="div1" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: auto;
                                            position: relative; top: 0px; left: 0px; width: 1000px; height: 508px; border: 0px solid;">
                                            <div align="left" id="4TD">
                                                <asp:DataList ID="dlRegion" runat="server" OnItemDataBound="dlRegion_ItemDataBound"
                                                    RepeatColumns="3" RepeatDirection="Horizontal" CellSpacing="6" Style="left: 3px;
                                                    top: 3px" CellPadding="0" ShowFooter="False" ShowHeader="False">
                                                    <HeaderTemplate>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <div id="divHeader" runat="server">
                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
                                                            <tr>
                                                                <td class="TabHeadBk">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                                        <tr>
                                                                            <td width="5%">
                                                                                <img src="../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                                                                            <td width="95%">
                                                                                <strong>Branch :
                                                                                    <asp:Label ID="lblBrID" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.LOCID")%>'></asp:Label>
                                                                                    -
                                                                                    <asp:Label ID="lblBrName" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.LOCNAME")%>'></asp:Label>
                                                                                </strong>
                                                                            </td>
                                                                             <%--<td>
                                                                                 <img alt="" src="../Common/Images/dsales_n.gif" visible="true" id="ibtnDailySales" runat="server"
                                                                                                style="cursor: hand; margin-right:0px;" onmouseover="this.src='../Common/Images/dsales_o.gif'"
                                                                                                onmouseout="this.src='../Common/Images/dsales_n.gif'" />
                                                                             </td>
                                                                             <td>
                                                                                 <img alt="" src="../Common/Images/listcsr.gif" visible="true" id="ibtnCSR" runat="server"
                                                                                                style="cursor: hand; margin-right:0px;" onmouseover="this.src='../Common/Images/listcsrmo.gif'"
                                                                                                onmouseout="this.src='../Common/Images/listcsr.gif'" /> 
                                                                            </td>     --%>                                                          
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top">
                                                                    <div align="left" class="TabCntBk" id="4TD">
                                                                        <asp:Table Width="308" ID="dtBrPerformance" runat="server">
                                                                            <asp:TableHeaderRow>
                                                                                <asp:TableHeaderCell></asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Day</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Br Avg</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">MTD</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Forecast</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Budget</asp:TableHeaderCell>
                                                                            </asp:TableHeaderRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>G/M $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Exp Bud</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Profit</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>G/M %</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Sales $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># Order</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># Lines</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Lbs Ship</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Price  Lbs</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>GP $  Lbs</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                        </asp:Table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        </div>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                    </FooterTemplate>
                                                </asp:DataList>
                                                  <div align="center"><asp:Label ID="lblStatus" runat="server" CssClass="redtitle"  Text=""
                                    Visible="False"></asp:Label></div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>  
                </td>
            </tr>            
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td align="right" colspan="2">
                                <uc1:BottomFrame ID="BottomFrame1" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
