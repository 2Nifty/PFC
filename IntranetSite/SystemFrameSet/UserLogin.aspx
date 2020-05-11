<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserLogin.aspx.cs" Inherits="PFC.Intranet.UserLogin" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PFC Intranet-User Login Page</title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
    <script>
    
    //
    // Checking for popup blocker 
    //
    function PopupBlockerchecker() 
    {
        
	    var Strfeature = "" ;
	    var WindowOpen = window.open('FooterFrame.aspx','name','width=10,height=10,,top=1000,left=1000');	
	    try
	    {
		    var obj = WindowOpen.name;
		    WindowOpen.close();
	    } 
	    catch(e)
	    { 
		     alert("\t You have enabled popup blocker. \n Please disable to use all the features of PFC Insider application.");
	    }
    }
     function LoadForgot()
    {
        var hWnd=window.open("ForgotPassword.aspx", 'Forgot', 'height=230,width=500,scrollbars=no,status=no,top='+((screen.height/2) - (480/2))+',left='+((screen.width/2) - (500/2))+',resizable=no');		
        
        hWnd.opener = self;	
	    if (window.focus) {hWnd.focus()}
        return false;
    }
    
    </script>
</head>
<body onload="PopupBlockerchecker()">
    <form id="form1" runat="server" defaultfocus="txtLoginName" > 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                        <tr>
                            <td width="62%" valign="middle">
                                <img src="../Common/Images/Logo.gif" width="453" height="50" hspace="25" vspace="10"></td>
                                    <td width="38%" valign="bottom">
                               
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CFEDF5">
                        <tr>
                            <td valign="top" class="LoginFormBk" width="26%">
                                <img src="../Common/Images/loginBanner.jpg" width="313"></td>
                            <td width="74%" valign="top" class="LoginFormBk">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="Left2pxPadd">
                                    <tr>
                                        <td class="BannerText">
                                            PFC Login
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <table width="80%" border="0" cellspacing="4" cellpadding="4">
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td class="login">
                                                        <asp:Label ID="lblUserStatus" CssClass="Required" runat="server" Text=" Invalid Login ID and Password "
                                                            Visible="false"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td width="17%" class="login">
                                                        &nbsp;&nbsp;&nbsp;Login ID</td>
                                                    <td width="83%">
                                                        <asp:TextBox CssClass="FormControls" ID="txtLoginName" Width="150px" runat="server"></asp:TextBox><asp:RequiredFieldValidator
                                                            CssClass="Required" Display="Dynamic" ID="rfvLoginName" runat="server" ControlToValidate="txtLoginName"
                                                            ErrorMessage="*"></asp:RequiredFieldValidator>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtLoginName"
                                                        Display="Dynamic" ErrorMessage="Invalid User Name" ValidationExpression="[a-zA-Z0-9_\*]+$"></asp:RegularExpressionValidator> </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span class="login">&nbsp;&nbsp;&nbsp;Password</span></td>
                                                    <td>
                                                        <asp:TextBox CssClass="FormControls" ID="txtPassword" TextMode="password" runat="server"
                                                            Width="150px"></asp:TextBox><asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                                                ControlToValidate="txtPassword" Display="Dynamic" CssClass="Required" ErrorMessage="*"></asp:RequiredFieldValidator></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;</td>
                                                    <td>
                                                        <asp:ImageButton ImageUrl="~/Common/Images/login.gif" runat="server" ID="btnSubmit"
                                                            OnClick="btnSubmit_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="login">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td class="login" >
                                            Lost your Password ? No problem! <a href="#" onclick="LoadForgot()">click here</a> and we will send it
                                            to you.</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr bgcolor="#DFF3F9">
                <td height="29" colspan="2" valign="bottom" class="BluTopBord">
                    <uc1:BottomFrame ID="BottomFrame1" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
