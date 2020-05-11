<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="PFC.Intranet.Homepage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Change PFC Intranet Password</title>
  <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
</head>
<body>
    <form id="form1" runat="server">
        
   	
    <table width="50%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td width="100%" colspan="2" style="height: 75px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                        <tr>
                            <td width="62%" valign="middle">
                                <img src="../Common/Images/Logo.gif" width="453" height="50" hspace="25" vspace="10"></td>
                            <td width="38%" valign="bottom" class="10pxPadding">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr width="100%">
            <td height="140">
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="75%">
									<tr>
										<td width="120"></td>
										<td width="270" class="frwrk_maincnt" style="height: 14px">
										<b></b></td>
									</tr>
									<tr>
										<td width="120" class="login">Current Password</td>
										<td width="270" >
										<asp:textbox id="txtExistingPassWord" runat="server" TextMode="Password" CssClass="FormControls" Width="150px"></asp:textbox></td>
									</tr>
									<tr>
										<td width="120" class="login">New Password</td>
										<td width="270" >
										<asp:TextBox id="txtNewPassword" runat="server" TextMode="Password" CssClass="FormControls" Width="150px"></asp:TextBox></td>
									</tr>
									<tr>
										<td width="120" class="login">Confirm Password</td>
										<td width="270" >
										<asp:TextBox id="txtConfirmPassword" runat="server" TextMode="Password" CssClass="FormControls" Width="150px"></asp:TextBox></td>
									</tr>
									<TR align="center">
											<TD colSpan="2" style="height: 19px">
												<asp:label id="lblError" ForeColor="red" runat="server" CssClass="FormControls"  Width="312px" ></asp:label></TD>
										</TR>
									<tr>
										<td width="120"></td>
										<td width="270" class="frwrk_maincnt">
										<asp:ImageButton id="Ibtnsave"  ImageUrl="~/Common/Images/submit.gif" runat="server" OnClick="Ibtnsave_Click"/>&nbsp;&nbsp;&nbsp;
										
                                            <img src="../Common/Images/cancel.gif" onclick="javascript:window.close();" style="cursor:hand" /></td>
									</tr>
								</table>
            </td>
            
            </tr>
            <tr bgcolor="#DFF3F9">
                <td width="72%" height="25" class="foottxt1">
                   <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="23%" height="25" class="foottxt1"><a href="http://www.porteousfastener.com/" style="color:#1c7893" target=_blank>&nbsp;&nbsp;Copyright 2007 Porteous Fastener Co. All rights reserved.,</a> </td>
                            <td width="13%" align=right ><a href="http://www.novantus.com" target="_blank"><img src="../Common/Images/umbrellaPower.gif" border="0Px" /></a></td>
                      </tr>
                    </table>
                   
                   </td>
            </tr>
        </table>
    </form>
</body>
</html>
