<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RevUnProcessed.aspx.cs" Inherits="ReadyToShip_RevUnProcessed" %>
<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/newfooter.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Goods En Route Ready to Ship V1.0.0</title>
     
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
    <link href="../ReadyToShip/Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <script>
    function CallPrint()
    {
          var vendorQs='<%=Request.QueryString["Vendor"] %>';
          var portQS='<%=Request.QueryString["Port"] %>';
          var winOpen=window.open('UnProcessPreview.aspx?Vendor='+vendorQs+'&Port='+portQS,'UnProcessedPreview','height=710,width=1020,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO','');
          winOpen.focus();
             
    }
    function AdjustHeight()
    {
    
        if(navigator.appName=="Microsoft Internet Explorer" && navigator.appVersion.indexOf("MSIE 7.0")!=-1)
        {
            var divGrid=document.getElementById("div-datagrid");
            divGrid.style.height='575px';
            document.getElementById("divContainer").style.height='575px';
        }
    }
    </script>
    
    <script language=vbscript>
    Function EnBtnClick()
        Dim intBtnClick
        intBtnClick=msgbox("Are you sure you want to place these PO's on Hold?",vbyesno,"Ready to Ship")
        if intBtnClick=6 then 
            EnBtnClick= true 
        else 
            EnBtnClick= false
         end if
    end Function
    </script>
    
</head>
<body onload="javascript:AdjustHeight();" scroll=no onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <div id="Container">
          <uc1:Header ID="Header1" runat="server" />
            <div id="Content">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">                   
                    <tr>
                        <td valign="top" colspan="2" style="border-collapse:collapse;border-top:none;" >
                            <asp:UpdatePanel ID="pnlShipDetails" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <div>
                                        <table cellpadding=0 cellspacing=0 width="100%">
                                            <tr>
                                                <td style="border-collapse: collapse; border-top: none;" bgcolor="#F4FBFD">
                                                    <table width="100%" cellpadding="0" cellspacing="0" >
                                                        <tr>
                                                            <td align="left">
                                                                <strong><asp:Label ID="lblCaption" CssClass="TabHead" Font-Bold="true" runat="server" Text="Vendor/Port of Lading:" Style="padding-left: 10px;"></asp:Label>
                                                                <asp:Label ID="lblVendor" CssClass="TabHead" Font-Bold="true" runat="server" Style="padding-left: 5px;"></asp:Label></strong>
                                                                <strong> - <asp:Label ID="lblPort" CssClass="TabHead" Font-Bold="true" runat="server" ></asp:Label></strong>                                                                                                                           
                                                                 
                                                            </td>
                                                            <td>
                                                                    
                                                            </td>
                                                            <td align="right" style="padding-right: 8px;">
                                                                
                                                            
                                                                <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="conditional">
                                                                    <ContentTemplate>
                                                                        <%--<asp:ImageButton  ID="imgPalceHold" OnClientClick="javascript:if(confirm('Are you sure you want to place these PO\'s on Hold?'))return true; else return false;"  runat="server" OnClick="imgPalceHold_Click" ImageUrl="Common/Images/placeHold.gif" />--%>
                                                                        <asp:ImageButton  ID="imgPalceHold" OnClientClick="return EnBtnClick()"  runat="server" OnClick="imgPalceHold_Click" ImageUrl="Common/Images/placeHold.gif" />
                                                                        <img src="../Common/Images/Print.gif" id="imgPrint" onclick="javascript:CallPrint();" />
                                                                        <img src="../Common/Images/Close.gif" id="imgClose" onclick="javascript:window.close();" />
                                                                        
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div align="center" style="border-collapse: collapse; border-top: none;">
                                        <asp:Label ID="lblStatus" CssClass="TabHead" ForeColor="#CC0000" Font-Bold="true"
                                            runat="server" Style="padding-left: 50px;"></asp:Label></div>
                                    <div class="dataTableContainer" style="height: 595px;" id=divContainer>
                                        <div id="div-datagrid" class="Sbar" style="overflow-y: auto; overflow-x: hidden;
                                            position: relative; top: 0px; left: 0px; width: 100%; height: 595px; border: 0px solid;
                                            background-color: White;border-collapse:collapse;border-top:none;">
                                            <asp:DataGrid CssClass="grid" ShowFooter=false UseAccessibleHeader=true Width=98% GridLines="both" AutoGenerateColumns=false ID="dgReview" runat="server"
                                                >
                                                <HeaderStyle CssClass="gridHeader" HorizontalAlign="center" Height="24px"  />
                                                <ItemStyle CssClass="GridItem" Wrap="False" HorizontalAlign="right" />
                                                <AlternatingItemStyle CssClass="zebra" HorizontalAlign="right" />
                                                <FooterStyle CssClass="lightBlueBg" Font-Bold="true" />
                                                <Columns>
                                                    <asp:BoundColumn ItemStyle-CssClass="Left2pxPadd" ItemStyle-HorizontalAlign=left DataField="PONo" HeaderText="PO #" ItemStyle-Width="60px"></asp:BoundColumn>
                                                    <asp:BoundColumn ItemStyle-CssClass="Left2pxPadd" DataField="ItemNo" HeaderText="Item No" ItemStyle-Width="80px"></asp:BoundColumn>
                                                    <asp:BoundColumn ItemStyle-CssClass="Right2pxPadd" DataField="Qty" DataFormatString="{0:#,##0}" HeaderText="Qty" ItemStyle-Width="50px"></asp:BoundColumn>
                                                    <asp:BoundColumn ItemStyle-CssClass="Right2pxPadd" DataField="GrossWght" HeaderText="Gross Weight" DataFormatString="{0:#,##0.00}" ItemStyle-Width="80px"></asp:BoundColumn>
                                                    <asp:BoundColumn ItemStyle-CssClass="Left2pxPadd" ItemStyle-HorizontalAlign=left DataField="GERRTSStatCd" HeaderText="Priority Code" ItemStyle-Width="80px"></asp:BoundColumn>
                                                     <asp:BoundColumn></asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td class="lightBlueBg">
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                <ProgressTemplate>
                                    <span class="TabHead">Loading...</span></ProgressTemplate>
                            </asp:UpdateProgress>
                            <asp:UpdatePanel ID=pnlStatus runat=server UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:Label runat=server Font-Bold=true id=lblMessage></asp:Label>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                     <tr>
                        <td>
                        
                         <uc2:BottomFooter ID="BottomFrame2"  Title="Ready to Ship - Unprocessed Records"   runat="server" />
                            
                            
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
   
</body>
</html>
