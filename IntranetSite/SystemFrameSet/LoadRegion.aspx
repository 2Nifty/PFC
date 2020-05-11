<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LoadRegion.aspx.cs" Inherits="SystemFrameSet_LoadRegion" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Region Sales Performance</title>
      <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
      <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
      <script type="text/javascript">
        function LoadSalesReport(BranchId)
            {
               var hWnd=window.open('../DailySalesReport/DailySalesReport.aspx?BranchID='+BranchId ,'DailySalesReport1','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=No','');
               hWnd.opener = self;	
               if (window.focus) {hWnd.focus()} 
            }
        function LoadCSRReport(BranchId)
            {
                var hWnd=window.open('CSRReport.aspx?BranchID='+ BranchId, 'CSRReport', 'height=710,width=1000,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=No','');		       
                hWnd.opener = self;	
                if (window.focus) {hWnd.focus()}
            }
            function PrintReport(url)
            {
                    var hwin=window.open('LoadRegionPreview.aspx?'+url, 'RegionSalesPrint', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
                    hwin.focus();
            }
      </script>
      <script>
    
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
                    <asp:UpdatePanel ID="pnlItemDetails" runat="server" UpdateMode="conditional">
                        <ContentTemplate>                        
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder" align="center">
                                <tr>
                                    <td width="100%">
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0" class="blueBorder lightBlueBg"
                                            style="border-left: none; border-right: none; border-top: none" >
                                            <tr>
                                                <td width ="25%">
                                                    <span style="color: #CC0000; font-size: 18px; margin: 0px; padding: 0px; font-weight: normal;
                                                        line-height: 35px; margin-left: 10px;">Region Sales Performance </span>
                                                </td>
                                                <td align="left">
                                                    </td>
                                                <td align="right" style="width:1px;vertical-align:middle;">
                                                    <asp:ImageButton ID="ibtnPrint" runat="server" ImageUrl="../common/images/print.gif" OnClick="ibtnPrint_Click" />
                                                </td>
                                                <td align="right" style="width:1px;padding:0px 5px;">
                                                    <asp:ImageButton ID="imgClose" runat="server" ImageUrl="../common/images/close.gif" OnClick="imgClose_Click" />
                                                    <%--<img id="imgClose" align="right" style="cursor: hand" onclick="javascript:window.close();"
                                                        src="../common/images/close.gif" />--%>
                                                </td>                                                
                                            </tr>
                                            <tr class="PageBg" height="20">
                                                <td align="left"  class="TabHead" style="padding-left:10px" colspan="2">
                                                    <asp:Label ID="Label1" runat="server" Text="Region Name"></asp:Label>
                                                    &nbsp;&nbsp;
                                                <asp:DropDownList CssClass="FormControls" ID="ddlRegion" runat="server" OnSelectedIndexChanged="ddlRegion_SelectedIndexChanged"
                                                    AutoPostBack="true">
                                                </asp:DropDownList></td>
                                                <td align="right" style="padding-right:15px" colspan="2">
                                                    <asp:UpdateProgress DynamicLayout=false ID="upPanel" runat="server">
                                                        <ProgressTemplate>
                                                            <span style="padding-left: 5px" class="TabHead">Loading...</span>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
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
                                                                             <td>
                                                                                 <img alt="" src="../Common/Images/dsales_n.gif" visible="true" id="ibtnDailySales" runat="server"
                                                                                                style="cursor: hand; margin-right:0px;" onmouseover="this.src='../Common/Images/dsales_o.gif'"
                                                                                                onmouseout="this.src='../Common/Images/dsales_n.gif'" />
                                                                             </td>
                                                                             <td>
                                                                                 <img alt="" src="../Common/Images/listcsr.gif" visible="true" id="ibtnCSR" runat="server"
                                                                                                style="cursor: hand; margin-right:0px;" onmouseover="this.src='../Common/Images/listcsrmo.gif'"
                                                                                                onmouseout="this.src='../Common/Images/listcsr.gif'" /> 
                                                                            </td>                                                               
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
                        </ContentTemplate>
                    </asp:UpdatePanel>
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
