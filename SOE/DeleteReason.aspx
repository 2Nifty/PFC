<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeleteReason.aspx.cs" Inherits="OrderTypeDisplay" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>SOE - Delete Reason</title>
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
        function DeleteOrder()
        {  
            window.opener.parent.bodyFrame.CallBtnClick('btnOrderDelete');
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
                                        <asp:Label ID="lblCaption" runat="server" Font-Bold="True" Text="Order Delete Reason" Width="275px"></asp:Label></td>
                                    <td width="35%" align="right">
                                        &nbsp;<img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" />
                                    </td>
                                </tr>
                            </table>
                        
                            </td>
                    </tr>
                    <tr>
                        <td  style="vertical-align: top; padding-bottom: 5px; padding-top: 5px;
                            padding-left: 5px;background-color:White;" >
                            <table width=100%><tr><td><asp:DropDownList ID="ddlReasonCode"  CssClass="cnt Sbar" Width="200" runat="server">
                            </asp:DropDownList><span style="color:Red;">*</span></td><td>
                                <asp:ImageButton ID="ibtnUpdate" ImageUrl="Common/Images/ok.gif" style="cursor: hand;" runat="server" OnClick="ibtnUpdate_Click" /></td></tr></table>
                            
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:Footer ID="Footer1" Title="Delete Reason" runat="server"></uc2:Footer>
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
