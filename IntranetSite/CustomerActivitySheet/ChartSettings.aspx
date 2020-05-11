<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChartSettings.aspx.cs" Inherits="PFC.Intranet.CustomerActivity.ChartSettings" %>
<%@ Register TagPrefix="dotnet" Namespace="dotnetCHARTING" Assembly="dotnetCHARTING" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>PFC CAS Report - Chart Setting</title>
     <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
      <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="BlueBorder" runat="server" id="BodyTable">
     <tr>
                <td colspan="2" style="width: 507px;">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
      <tr>
        <td width="62%" valign="middle" ><img src="Images/CASHeader.jpg" width="365" height="49"></td>
        
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
                            <td>&nbsp;&nbsp; Chart Settings
                                &nbsp;</td>
                            <td>
                           
                             <IMG id="imgClose" align="right" style="cursor:hand" onclick="javascript:window.close();" src="../common/images/close.gif" />   
                            </td>  
                            
                           
                               
                        </tr>
                       <tr width="100%">
                            <td colspan="2" height="85">
                                <table width="100%" border="0" cellspacing="4" cellpadding="5" align="center">
                                    <tr>
                                        <td class="login" width="35%" >
                                            Chart Type</td>
                                         <td class="login" >
                                             <asp:DropDownList AutoPostBack="true" ID="ddlChartType" CssClass="FormControls" Width="200" runat="server" OnSelectedIndexChanged="ddlChartType_SelectedIndexChanged">
                                               <asp:ListItem>Combo</asp:ListItem>
                                            <asp:ListItem>ComboSideBySide</asp:ListItem>
                                            <asp:ListItem>ComboHorizontal</asp:ListItem>
                                            <asp:ListItem>Pie</asp:ListItem>
                                            <asp:ListItem>Pies</asp:ListItem>
                                            <asp:ListItem>Donut</asp:ListItem>
                                            <asp:ListItem>Donuts</asp:ListItem>
                                            <asp:ListItem>Radar</asp:ListItem>
                                            <asp:ListItem>Scatter</asp:ListItem>
                                            <asp:ListItem>Bubble</asp:ListItem>
                                            <asp:ListItem>Financial</asp:ListItem>
                                            <asp:ListItem>Gantt</asp:ListItem>
                                            <asp:ListItem>Gantt</asp:ListItem>
                                             </asp:DropDownList></td>
                                    </tr>
                                     <tr>
                                        <td class="login" width="35%" >
                                            Chart Color Palette</td>
                                         <td class="login" >
                                            <asp:DropDownList AutoPostBack="true" ID="ddlPalette" CssClass="FormControls" Width="200" runat="server" OnSelectedIndexChanged="ddlPalette_SelectedIndexChanged">
                                            <asp:ListItem>None</asp:ListItem>
                                            <asp:ListItem>One</asp:ListItem>
                                            <asp:ListItem>Two</asp:ListItem>
                                            <asp:ListItem>Three</asp:ListItem>
                                            <asp:ListItem>Four</asp:ListItem>
                                            <asp:ListItem>Five</asp:ListItem>
                                            <asp:ListItem>Random</asp:ListItem>
                                            <asp:ListItem>Autumn</asp:ListItem>
                                            <asp:ListItem>Bright</asp:ListItem>
                                            <asp:ListItem>Lavender</asp:ListItem>
                                            <asp:ListItem>Midtones</asp:ListItem>
                                            <asp:ListItem>Mixed</asp:ListItem>                                            
                                            <asp:ListItem>Pastel</asp:ListItem>
                                            <asp:ListItem>Poppies</asp:ListItem>
                                            <asp:ListItem>Spring</asp:ListItem>                                            
                                            <asp:ListItem>WarmEarth</asp:ListItem>
                                            <asp:ListItem>WaterMeadow</asp:ListItem>
                                            <asp:ListItem>DarkRainbow</asp:ListItem>                                            
                                            <asp:ListItem>MidRange</asp:ListItem>
                                            <asp:ListItem>VividDark</asp:ListItem>
                                            </asp:DropDownList>
                                            </td>
                                    </tr>
                                       <tr>
                                        <td class="login" width="35%" >
                                           </td>
                                         <td class="login" >
                                             <asp:ImageButton  ID="imgApply" ImageUrl="~/CustomerActivitySheet/Images/Apply.gif" runat="server" OnClick="imgApply_Click" /> &nbsp;&nbsp;<asp:ImageButton  ID="imgbtnDefault" ImageUrl="~/CustomerActivitySheet/Images/set Default.gif" runat="server" OnClick="imgbtnDefault_Click"  />  </td>
                                    </tr>
                                        <tr class="SheetHead">
                                        <td class="redhead" colspan="2" align="center">
                                          PREVIEW </td>                                         
                                    </tr>
                                      <tr>
                                        <td class="login" colspan="2" align="center" >
                                          <dotnet:Chart ID="chartModule" Width="330" Height="200" runat="server" Use3D="true"
                                                                    ImageFormat="Jpg" PaletteName="None"  >
                                              
                                                                </dotnet:Chart>
                                            </td>                                         
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
                            <td width="13%" align=right ><a href="http://www.novantus.com" target="_blank"><img src="../Common/Images/umbrellaPower.gif" border="0Px"  alt="Powered By www.novantus.com"/></a></td>
                      </tr>
                    </table>
                   
                   </td>
            </tr>
      </table>
    </form>
</body>
</html>
 <asp:Image id="imgsave" style="cursor:hand" ImageUrl="../common/images/close.gif" runat="server" /> &nbsp;