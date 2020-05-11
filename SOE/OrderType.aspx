<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderType.aspx.cs" Inherits="OrderTypeDisplay" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>SOE - Order Selection </title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <style>
    .list
    {
	line-height:23px;
	background:#FFFFCC;
	padding:0px 10px;
	border:1px solid #FAEE9A;
	position:absolute;
	z-index:1;
	top:0px;
	}
	.boldText
    {
	font-weight: bold;
    }

    </style>
    <script type="text/javascript">
        // function to relaod sold to contact information in parent window
        function ReloadPO(orderNumber)
        {        
            window.opener.parent.bodyFrame.document.getElementById("CustDet_txtSONumber").value=orderNumber;
            window.opener.parent.bodyFrame.LoadOrder(orderNumber);
            window.close();
        }  
        
        function DisplayInvalidOrderNumber()
        {        
            var lblMessage = window.opener.parent.bodyFrame.document.getElementById("lblMessage");         
            lblMessage.innerText = "Invalid Sales Order Number";
            window.close();
        } 
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="pnlContainer" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                     <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 200">
                    <tr>
                        <td class="lightBg" style="padding: 5px;">
                            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left">
                                        <asp:Label ID="lblCaption" runat="server" Font-Bold="True" Text="Order Selection for Order #" Width="275px"></asp:Label></td>
                                    <td width="35%" align="right">
                                        &nbsp;<asp:ImageButton ID=ibtnClose ImageUrl="~/Common/Images/Close.gif" runat=server OnClick="ibtnClose_Click1" tabindex="1"/>
                                    </td>
                                </tr>
                            </table>
                        
                            </td>
                    </tr>
                    <tr>
                        <td  style="vertical-align: top; padding-bottom: 5px; padding-top: 5px;
                            padding-left: 5px;background-color:White;" >
                              <div class="Sbar" onclick="javascript:document.getElementById('lnkOriginalOrder').focus()" oncontextmenu="Javascript:return false;" id="divdatagrid" style="overflow-x: hidden;
                                                    overflow-y: auto; position: relative; top: 0px; left: 0px; height: 280px; border: 1px solid #88D2E9;
                                                    width: 98%; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                                    scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                                    scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94" runat="server">
                      <table border="0" cellpadding="0" cellspacing="3" style="width: 100%;">
                               <tr>
                                    <td style="width: 100px; height: 20px;font-weight:bold;" valign=top>
                                        <asp:Label ID="lblOrgOrder" runat="server" Height="20px" Text="Original Order"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="width: 100px; height: 20px;padding-left:20px;" valign=top>
                                        <asp:LinkButton ID="lnkOriginalOrder" runat="server" OnClick="lnkOriginalOrder_Click"></asp:LinkButton></td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;font-weight:bold;" valign=top>
                                        <asp:Label ID="lblRelOrder" runat="server" Height="20px" Text="Released Order"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="width: 100%;padding-left:20px;" valign=top>
                                        <asp:DataList ID="dlReleased" runat="server" OnItemCommand="dlReleased_ItemCommand" >
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkRel" runat="server" CommandName="Load" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"pSOHeaderRelID") %>' Text='<%#DataBinder.Eval(Container.DataItem,"ShipLoc") %>'></asp:LinkButton>
                                        </ItemTemplate>
                                        </asp:DataList></td>
                                </tr>
                                 <tr>
                                    <td style="width: 100px;font-weight:bold;" valign=top>
                                        <asp:Label ID="lblInvOrder" runat="server" Height="20px" Text="Invoices"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="width: 100%;padding-left:20px;" valign=top>
                                      <asp:DataList ID="dlInvoiced" runat="server" OnItemCommand="dlInvoiced_ItemCommand">
                                    <ItemTemplate>
                                         <asp:LinkButton ID="lnkInvoiced" runat="server" CommandName="Load" CommandArgument='<%#DataBinder.Eval(Container.DataItem,"pSOHeaderHistID") %>' Text='<%#DataBinder.Eval(Container.DataItem,"ShipLoc") %>'></asp:LinkButton>
                                        </ItemTemplate>
                                        </asp:DataList> </td>
                                </tr>
                            </table></div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:Footer ID="Footer1" Title="Available Orders" runat="server"></uc2:Footer>
                        </td>
                    </tr>
                </table>     
                </ContentTemplate>
            </asp:UpdatePanel>
    </form>
<script>
    self.focus();
</script>


</body>
</html>
