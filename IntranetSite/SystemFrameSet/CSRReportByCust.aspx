<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CSRReportByCust.aspx.cs"
    Inherits="SystemFrameSet_CSRReportByCust" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CSR Report - By Assigned Customers</title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Common/Javascript/ContextMenu.js"></script>

    <style>
        a:active {
        text-decoration: underline;
        color: green;
        }
        a:hover {
        text-decoration: underline;
        color: green;
        }
        a:visited {
        text-decoration: underline;
        color: green;
        }
        a:link {
        text-decoration: underline;
        }
        a {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 11px;
        color: green;
        }
    </style>

    <script language="javascript">

    function doOpen(url,name)
    {
        var w = window.open(url, name, 'height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				
        w.focus();
        return false;        
    }
    
    function ShowToolTip(event,strOrdHeaderURL,strOrdCustomerURL,ctlID)
    {
        if(event.button==2)
        {
            OrdHeaderURL=strOrdHeaderURL;
            OrdCustomerURL=strOrdCustomerURL;
            //xstooltip_show('divToolTip',ctlID,event.screenX, event.screenY,event);
            ShowDiv('divToolTip',ctlID,event);
            return false;
        }
    }

    function ShowOrdHeader()
    {
        window.open(OrdHeaderURL,'Header' ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=no',"");
        xstooltip_hide('divToolTip');
    }
    
    function ShowOrdCustomer()
    {
        window.open(OrdCustomerURL, 'Customer', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no');
        xstooltip_hide('divToolTip');
    }

    function ShowDiv(divCtlId,parentCtlId,event)
    {
        it = document.getElementById(divCtlId);                  
        var scrollBarPosistion = document.getElementById("div1").scrollTop;
        var mouseYPoint = (event.clientY + scrollBarPosistion ) - 140 ;
        it.style.top =  mouseYPoint + 'px';         
        it.style.left = event.clientX + 'px'; 
        it.style.display = '';
    }
        
    function HideToolTip(ctlID)
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

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
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
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="BlueBorder"
                                align="center">
                                <tr>
                                    <td width="100%">
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0" class="blueBorder lightBlueBg"
                                            style="border-left: none; border-right: none; border-top: none">
                                            <tr>
                                                <td align="left" width="90%" style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px;
                                                    padding-top: 5px">
                                                    <span style="color: #CC0000; font-size: 18px; margin: 0px; padding: 0px; font-weight: normal;
                                                        line-height: 25px; margin-left: 10px;">CSR Report - By Assigned Customers</span>
                                                </td>
                                                <td align="left" colspan="2">
                                                    <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="conditional" runat="server">
                                                        <ContentTemplate>
                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td style="width: 100px">
                                                                        <asp:ImageButton runat="server" Style="cursor: hand" ID="ibtnPrint" ImageUrl="~/Common/Images/Print.gif"
                                                                            ImageAlign="middle" OnClick="ibtnPrint_Click" /></td>
                                                                    <td style="width: 100px">
                                                                        <asp:ImageButton ID="ibtnClose" runat="server" Style="padding-right: 10px;" ImageUrl="../common/images/close.gif"
                                                                            OnClick="ibtnClose_Click" /></td>
                                                                </tr>
                                                            </table>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                            <tr class="PageBg" height="20">
                                                <td align="left" class="TabHead" style="padding-left: 10px" colspan="2">
                                                    <asp:Label ID="Label1" runat="server" Text="Branch Name"></asp:Label>
                                                    &nbsp;&nbsp;
                                                    <asp:DropDownList CssClass="FormControls" ID="ddlBranch" runat="server" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged"
                                                        AutoPostBack="true" Width="170px">
                                                    </asp:DropDownList></td>
                                                <td align="right" style="padding-right: 15px">
                                                    <asp:UpdateProgress DynamicLayout="false" ID="upPanel" runat="server">
                                                        <ProgressTemplate>
                                                            <span style="padding-left: 5px" class="TabHead">Loading...</span>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                </td>
                                            </tr>
                                            <tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="div1" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: auto;
                                            position: relative; top: 0px; left: 0px; width: 950px; height: 508px; border: 0px solid;">
                                            <div align="left" id="4TD">
                                                <asp:DataList ID="dlRegion" runat="server" OnItemDataBound="dlRegion_ItemDataBound"
                                                    RepeatColumns="2" RepeatDirection="Horizontal" CellSpacing="6" Style="left: 3px;
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
                                                                                <strong>CSR :
                                                                                    <asp:Label ID="lblBrID" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.USERNAME")%>'></asp:Label>
                                                                                </strong>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top">
                                                                    <div align="left" class="TabCntBk" id="4TD">
                                                                        <asp:Table Width="400px" ID="tblCSRPerfRpt" runat="server">
                                                                            <asp:TableHeaderRow>
                                                                                <asp:TableHeaderCell></asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Day</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Avg Day</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">MTD</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right">Forecast</asp:TableHeaderCell>
                                                                                <asp:TableHeaderCell HorizontalAlign="Right" Width="15%">Goal</asp:TableHeaderCell>
                                                                            </asp:TableHeaderRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>G/M $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>G/M %</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Sales $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># Order</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># Lines</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># Cust Assigned</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># Cust Bought</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>eCom Sales $</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>eCom GM %</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># eCom Q Orders</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># eCom Q Lines</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># CSR Q Orders</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell># CSR Q Lines</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Lbs Ship</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.00"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>Price Lbs</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.000"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.000"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.000"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.000"></asp:TableCell>
                                                                            </asp:TableRow>
                                                                            <asp:TableRow>
                                                                                <asp:TableCell>GM $ Lbs</asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.000"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.000"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.000"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="-"></asp:TableCell>
                                                                                <asp:TableCell HorizontalAlign="Right" Text="0.000"></asp:TableCell>
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
                                                <div align="center">
                                                    <asp:Label ID="lblNorecords" runat="server" CssClass="redtitle" Visible="false" Text="No Records Found"></asp:Label>
                                                </div>
                                                <div id="divToolTip" oncontextmenu="Javascript:return false;" class="MarkItUp_ContextMenu_MenuTable"
                                                    style="display: none; word-break: keep-all;" onmousedown="HideToolTip(this.id)">
                                                    <table width="220" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                                                        class="MarkItUp_ContextMenu_Outline">
                                                        <tr>
                                                            <td class="bgmsgboxtile">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td width="90%" class="txtBlue">
                                                                            Sales Order Drilldown</td>
                                                                        <td width="10%" align="center" valign="middle">
                                                                            <div align="right">
                                                                                <span class="bgmsgboxtile1">
                                                                                    <img src="../Common/Images/closeicon.gif" id="imgDivClose" style="cursor: hand;"
                                                                                        onmousedown="HideToolTip(this.id)" alt="Close"></span></div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="bgtxtbox">
                                                                <table width="100%" border="0" cellspacing="0">
                                                                    <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowOrdHeader();"
                                                                        onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class="MarkItUp_ContextMenu_MenuItem">
                                                                        <td width="10%" valign="middle">
                                                                            <img src="../Common/Images/email.gif" /></td>
                                                                        <td width="90%" valign="middle">
                                                                            <div id="divCAS" style="vertical-align: middle; word-wrap: normal;" class="MarkItUp_ContextMenu_MenuItem"
                                                                                onclick="ShowOrdHeader();">
                                                                                Sales Order Header By Invoice</div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="ShowOrdCustomer();"
                                                                        onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class="MarkItUp_ContextMenu_MenuItem">
                                                                        <td width="10%" valign="middle">
                                                                            <img src="../Common/Images/email.gif" /></td>
                                                                        <td width="90%" valign="middle">
                                                                            <div id="divReport" class="MarkItUp_ContextMenu_MenuItem" style="vertical-align: middle;
                                                                                word-wrap: normal;" onclick="ShowOrdCustomer();">
                                                                                Sales Order Header By Customer</div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
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

    <script>if(window.parent.document.getElementById("Progress")){window.parent.document.getElementById("Progress").style.display='none';}</script>

</body>
</html>

<script>
    function PrintReport(url)
    {
            var hwin=window.open('CSRReportByCustPreview.aspx?'+url, 'CSRReportPrint', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
            hwin.focus();
    }
</script>

