<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OpenOrderRptPrompt.aspx.cs" Inherits="OpenOrderRptPrompt" %>

<%@ Register Src="UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Open Order Report</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="../Common/javascript/ContextMenu.js"></script>


    <script>

    function LoadHelp()
    {
        window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }

    function ViewReport(url)
    {
        window.open(url ,'OpenOrdRpt','height=700,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");	
    }

    //Open Customer look up
    function LoadCustomerLookup(_custNo)
    {   
        //var Url = "http://10.1.36.34/SOE/CustomerList.aspx?Customer=" + _custNo+"&ctrlName=OpenOrdRpt";
        var Url = '<%=ConfigurationManager.AppSettings["SOESiteURL"].ToString() %>' + "CustomerList.aspx?Customer=" + _custNo+"&ctrlName=OpenOrdRpt";
        window.open(Url,'CustomerList' ,'height=460,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
    }
    
    </script>

</head>
<body>
    <form id="form1" runat="server" defaultbutton="btnView">
    <asp:ScriptManager ID="MyScript" EnablePartialRendering="true" runat="server">
                    </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="100%" height="400" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td colspan="2" valign="middle">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" colspan="2">
                                            <uc1:PageHeader ID="PageHeader1" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="PageHead" style="height: 40px;">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">Open Order Report</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="Javascript:history.back();" style="cursor: hand" />
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr height="30px">
                                        <td align="left" valign="middle" class="TabHead" colspan="2">
                                            <table class="LeftPadding">
                                                <tr>
                                                    <td style="padding-left: 20px; height: 20px;">Cust No:</td>
                                                    <td style="width: 80px; height: 20px;"><asp:TextBox ID="iCustNo" Style="height:18px;" runat="server" Width="50px" MaxLength="6" OnFocus="javascript:this.select();" OnTextChanged="iCustNo_TextChanged" CssClass="FormCtrl" AutoPostBack="true" /></td>
                                                    <td style="padding-left: 15px; height: 20px;"></td>
                                                    <td style="padding-left: 15px; height: 20px;"></td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 20px">
                                                        Order Type:</td>
                                                    <td style="width: 80px">
                                                        <asp:DropDownList ID="iOrderType" runat="server" CssClass="FormCtrl" Width="200px" /></td>
                                                    <td style="padding-left: 15px">
                                                    </td>
                                                    <td style="padding-left: 15px">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 20px">
                                                        Sales Loc:</td>
                                                    <td style="width: 80px">
                                                        <asp:DropDownList ID="iCustShipLoc" runat="server" CssClass="FormCtrl" Width="150px" /></td>
                                                    <td style="padding-left: 15px">
                                                    </td>
                                                    <td style="padding-left: 15px">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 20px">
                                                        Ship Loc:</td>
                                                    <td style="width: 80px">
                                                        <asp:DropDownList ID="iShipLoc" runat="server" CssClass="FormCtrl" Width="150px" /></td>
                                                    <td style="padding-left: 15px">
                                                    </td>
                                                    <td style="padding-left: 15px">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 20px">
                                                        Salesperson:</td>
                                                    <td style="width: 80px">
                                                        <asp:TextBox ID="iSalesPerson" Style="height:18px;" runat="server" Width="150px" MaxLength="150" CssClass="FormCtrl" /></td>
                                                    <td style="padding-left: 15px">
                                                    </td>
                                                    <td style="padding-left: 15px">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 20px">Bad Mgn:</td>
                                                    <td style="width: 80px;"><asp:CheckBox ID="iBadMgn" runat="server" /></td>
                                                    <td style="padding-left: 15px"></td>
                                                    <td style="padding-left: 15px"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr class="PageBg" height="30">
                                        <td align="left" class="TabHead" colspan="2" valign="middle" style="padding-left: 40px">
                                        <asp:UpdatePanel ID="udpReportContent" UpdateMode="Conditional" RenderMode="Inline"
                                    runat="server">
                                    <contenttemplate>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="width: 100px">                                                    
                                                        <asp:ImageButton ID="btnView" runat="server" Style="cursor: hand" ImageUrl="../Common/images/ViewReport.gif" OnClick="btnView_Click" /></td>
                                                    <td style="width: 100px">
                                                    <img src="../Common/images/help.gif" onclick="LoadHelp();" style="cursor: hand" /></td>
                                                </tr>
                                            </table>
                                            </contenttemplate>
                                            </asp:UpdatePanel>
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
