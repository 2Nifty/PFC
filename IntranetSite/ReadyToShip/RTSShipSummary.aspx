<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RTSShipSummary.aspx.cs" Inherits="ReadyToShip_RTSShipSummary" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/newfooter.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Goods En Route Ready to Ship V1.0.0</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
    <link href="../ReadyToShip/Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet"
        type="text/css" />

    <script language="javascript" src="Common/Javascript/ContextMenu.js"></script>

    <script>
        var hid='';
        function ReviewPending()
        {   
            var ddlValue=document.getElementById('ddlVendor').value;
            var winOpen=window.open('RevUnProcessed.aspx?Vendor='+ddlValue.split('-')[0]+'&Port='+ddlValue.split('-')[1],'UnProcessed','height=710,width=1020,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO','');
            winOpen.focus();
            
        }
    
        function ShowToolTip(event,ctlVal,ctlID)
        {
            
                if(event.button==2)
                {
                xstooltip_show('divToolTip',ctlID,289, 49);
                document.getElementById('hidHold').value=ctlVal;
                return false;
                }
           
        }
    
      function Hide()
      {
            if(hid!='true')
                xstooltip_hide('divToolTip');
            else
                hid='';
      }
  
      function SetVal(ctlID)
      {
            if(ctlID=='imgDivClose')
              xstooltip_hide('divToolTip');
            else 
            {
                if(ctlID=='divToolTip')
                    hid='true';
                else 
                    hid='';
            }
      }
      function SetVisible()
      {
            hid='true';
      }
    
    function AdjustHeight()
    {
    
//        if(navigator.appName=="Microsoft Internet Explorer" && navigator.appVersion.indexOf("MSIE 7.0")!=-1)
//        {
//            var divGrid=document.getElementById("div-datagrid");
//            divGrid.style.height='525px';
//            document.getElementById("divContainer").style.height='525px';
//           
//           
//        }
    }
    </script>

</head>
<body onmouseup="Hide();" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <div id="Container">
            <uc1:Header ID="Header1" runat="server" />
            <div id="Content">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <%--<tr>
                        <td valign="top" colspan="2" class="lightBlueBg blueBorder" style="border-collapse:collapse;" >
                            <h2>
                                Vendor/Port Summary in Pounds</h2>
                        </td>
                    </tr>--%>
                    <tr>
                        <td valign="top" colspan="2" style="border-collapse: collapse; border-top: none;">
                            <asp:UpdatePanel ID="pnlShipDetails" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <div>
                                        <table class="shadeBgUp" border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td style="width: 250; padding-left: 10px;" height="30px">
                                                    <strong>
                                                        <asp:DropDownList ID="ddlVendor" AutoPostBack="true" runat="server" Width="200px"
                                                            OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged" CssClass="txtBox">
                                                        </asp:DropDownList>
                                                    </strong>
                                                </td>
                                                <td nowrap="nowrap" width="300px" align="left">
                                                    <strong>
                                                        <asp:Label ID="lblVendor" CssClass="TabHead" Font-Bold="true" runat="server" Style="padding-left: 10px;"></asp:Label></strong>
                                                </td>
                                                <td width="100%" align="right">
                                                             <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:ImageButton OnClick="btnAccept_Click" ID="btnAccept" runat="server" ImageUrl="Common/Images/accept.jpg" /></td>
                                                                    <td>
                                                                        <img src="Common/Images/Close.jpg" id="imgClose" style="padding-left: 3px;" onclick="javascript:window.close();" /></td>
                                                                </tr>
                                                            </table>
                                                     <%--<asp:UpdatePanel ID="upAccept" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>--%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="1" style="width: 100%; padding-left: 10px; font-weight: bold; height: 20px;">
                                                    <span style="color: #cc0000;">Pounds Not Processed :</span>
                                                    <asp:Label ID="lblPounds" runat="server" Style="color: #cc0000; text-decoration: underline;
                                                        cursor: hand;" onclick="ReviewPending();"></asp:Label>
                                                </td>
                                                <td colspan="2" align="right" style="font-weight:bold;"></td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="dataTableContainer" style="border-collapse: collapse; border-top: none;
                                        height: 535px;" id="divContainer">
                                        <div id="div-datagrid" class="Sbar" style="overflow-y: auto; overflow-x: auto; position: relative;
                                            top: 0px; left: 0px; width: 100%; height: auto; border: 0px solid; background-color: White;">
                                            <asp:DataGrid CssClass="grid" GridLines="both" ID="dgShipSummary" runat="server"
                                                ShowFooter="true" OnItemDataBound="dgShipSummary_ItemDataBound" >
                                                <HeaderStyle CssClass="gridHeader" HorizontalAlign="center" />
                                                <ItemStyle CssClass="GridItem" Wrap="False" HorizontalAlign="right" />
                                                <AlternatingItemStyle CssClass="zebra" HorizontalAlign="right" />
                                                <FooterStyle CssClass="lightBlueBg" Font-Bold="true" />
                                            </asp:DataGrid>
                                            <asp:Table ID="ReceiptDatesTable" runat="server" CssClass="lightBlueBg">
                                            <asp:TableRow ID="DatesRow" runat="server">
                                            <asp:TableCell CssClass="Left5pxPadd" Width="103px" runat="server">
                                                <b>Receipt Dates</b>
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server">
                                                &nbsp;
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox3" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField1" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox4" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField2" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox5" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField3" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox6" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField4" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox7" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField5" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox8" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField6" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox9" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField7" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox10" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField8" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox11" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField9" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox12" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField10" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox13" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField11" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox14" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField12" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox15" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField13" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox16" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField14" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox17" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField15" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox18" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField16" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox19" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField17" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell Width="63px" runat="server" Visible="false">
                                                <asp:TextBox ID="TextBox20" runat="server" Width="50px"></asp:TextBox>
                                                <asp:HiddenField ID="HiddenField18" runat="server" />
                                            </asp:TableCell>
                                            <asp:TableCell ID="TableCell1" Width="60px" runat="server">
                                                &nbsp;
                                            </asp:TableCell>
                                            </asp:TableRow>
                                            </asp:Table>
                                            <div style="padding-top:5px;padding-left:2px;font-style:italic;"><span style="font-style:italic;">Note : All values are in pounds</span></div>
                                            <div align="center" style="border-collapse: collapse; border-top: none;">
                                                <asp:Label ID="lblStatus" CssClass="TabHead" ForeColor="#CC0000" Font-Bold="true"
                                                    runat="server" Style="padding-left: 50px;"></asp:Label></div>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td style="border-collapse: collapse; border-top: none;">
                            <table width="100%" cellpadding="0" cellspacing="0" class="BluBg buttonBar">
                                <tr>
                                    <td width="50%" align="left">
                                        <asp:UpdateProgress ID="upPanel" runat="server">
                                            <ProgressTemplate>
                                                <span class="TabHead" style="padding-left: 25px;">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:UpdatePanel ID="upLabel" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:Label ID="lblFlag" CssClass="TabHead" Style="padding-left: 25px;" ForeColor="green"
                                                    runat="server" Text=""></asp:Label>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                    <td align="right" style="padding-right: 8px;">
                                  
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                         
                            <uc2:BottomFooter ID="BottomFrame2" Title="Vendor/Port Summary in Pounds" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="divToolTip" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
            word-break: keep-all;" onmouseup="return false;" onmousedown="SetVal(this.id)">
            <table width="200px" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                class="MarkItUp_ContextMenu_Outline">
                <tr>
                    <td class="bgmsgboxtile">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="90%" class="txtBlue">
                                    GERRTS Vendor Summary</td>
                                <td width="10%" align="center" valign="middle">
                                    <div align="right">
                                        <span class="bgmsgboxtile1">
                                            <img src="Common/Images/close.gif" id="imgDivClose" style="cursor: hand;" onmousedown="SetVal(this.id)"
                                                alt="Close"></span></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="bgtxtbox">
                        <table width="100%" border="0" cellspacing="0">
                            <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                class="MarkItUp_ContextMenu_MenuItem">
                                <td width="90%" valign="middle">
                                    <%--<div id=divCAS  style="vertical-align:middle;color:#cc0000;" class=MarkItUp_ContextMenu_MenuItem onclick="ShowCAS();">Hold all Pounds for this Branch</div>--%>
                                    <asp:UpdatePanel ID="pnlHold" runat="server">
                                        <ContentTemplate>
                                            <asp:LinkButton ID="lnkHold" runat="server" ForeColor="#cc0000" Font-Underline="false"
                                                Text="Hold all Pounds for this Branch" OnClientClick="javascript:document.getElementById('divToolTip').style.display='none';"
                                                OnClick="lnkHold_Click"></asp:LinkButton>
                                            <asp:HiddenField ID="hidHold" runat="server" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
