<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Description.aspx.cs" Inherits="SystemFrameSet_Description" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Description</title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
</head>
<body style="margin:5px">
    <form id="form1" runat="server">
     <table width="50%" border="0" cellspacing="0" cellpadding="0" class="BlueBorder" runat="server" id="BodyTable">
     <tr>
                <td colspan="2" style="height: 75px; width: 507px;">
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
            <tr>
                <td>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="width: 507px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr class="PageHeadsmall">
                            <td  >
                            <asp:Label ID="lblHeader" runat="server" CssClass=" " Text=""></asp:Label>                                                      
                             </td>
                            <td>
                             <IMG id="imgClose" align="right" style="cursor:hand"     onclick="javascript:window.close();" 
src="../common/images/close.gif" />   
                            </td>  
                            
                           
                               
                        </tr>
                       <tr width="75%">
                            <td colspan="2" height="85">
                                <table width="75%" border="0" cellspacing="4" cellpadding="5" align="center">
                                    <tr>
                                        <td class="login" colspan="2" rowspan="2">
                                            <div id="Description" runat="server" style="width:450px;word-wrap:break-word"> 
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                    </tr>
                                </table>
                            </td>
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
