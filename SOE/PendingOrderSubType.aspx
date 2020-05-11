<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PendingOrderSubType.aspx.cs" Inherits="OrderTypeDisplay" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Pending Order Type</title>
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
   
</head>
<body >
    <form id="form1" runat="server">
    <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="pnlContainer" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                     <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 200">
                    <tr>
                        <td class="lightBg" style="padding: 5px;padding-left:10px;">
                            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left">
                                        <asp:Label ID="lblCaption" runat="server" Font-Bold="True" Text="Unmade Order: Select Pending Order Type </br> and Click Close" Width="275px"></asp:Label></td>
                                    <td width="35%" align="right">
                                        &nbsp;<img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" />
                                    </td>
                                </tr>
                            </table>
                        
                            </td>
                    </tr>
                    <tr>
                        <td  style="vertical-align: top; padding-bottom: 5px; padding-top: 5px;
                            padding-left: 10px;background-color:White;" height=130px >
                            <table width=100%><tr><td ><asp:DropDownList ID="ddlOrderType"  CssClass="cnt Sbar" Width="200" runat="server" AutoPostBack=true OnSelectedIndexChanged="ddlOrderType_SelectedIndexChanged">
                            </asp:DropDownList><span style="color:Red;">*</span></td><td>
                               </td></tr></table>
                            
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:Footer ID="Footer1" Title="Select Pending Order Type" runat="server"></uc2:Footer>
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
