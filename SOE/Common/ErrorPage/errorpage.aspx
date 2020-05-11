<%@ Page language="c#" Inherits="Novantus.Umbrella.Common.ErrorPage.ErrorPage" CodeFile="ErrorPage.aspx.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
    <title>ErrorPage</title>
    <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" Content="C#">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
    <style type="text/css"> <!-- .HeaderBk { background-image: url(images/HeaderBk.jpg); background-repeat: repeat-x; background-position: left top; }
	.HeaderTDBorder { border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #FFFFFF; }
	.FooterBk { background-image: url(images/FooterBk.jpg); background-repeat: repeat-x; background-position: left bottom; }
	.CopyrightMsg { font-family: Arial, Helvetica, sans-serif; font-size: 10px; font-weight: normal; color: #99A6B9; text-decoration: none; }
	.CopyrightMsg:hover { font-family: Arial, Helvetica, sans-serif; font-size: 10px; font-weight: normal; color: #99A6B9; text-decoration: underline; }
	.DisplayTDBk { border-right-width: 1px; border-left-width: 1px; border-right-style: solid; border-left-style: solid; border-right-color: #5a9bde; border-left-color: #5a9bde; background-color: #EAF4FF; }
	.DisplayBk { background-color: #FFFFFF; }
	.InterfaceSlctTab { background-color: #F1F8FF; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #DCEDFF; height: 25px; }
	.InterfaceNameTab { background-color: #f6f6f6; height: 25px; }
	.IntfaceNameBotBorder { border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #CCCCCC; }
	.InterfacePropTDBk { background-color: #cce4ff; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #aed5ff; height: 25px; }
	.WhiteBorder { border: 1px solid #FFFFFF; }
	.OptionsHdBk { background-color: #eaf4ff; height: 25px; }
	.BlackContent { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #000000; text-decoration: none; margin-left: 15px; }
	.edit { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #0033CC; text-decoration: none; margin-left: 15px; }
	.FormControls { font-family: Tahoma, arial; font-size: 11px; font-weight: normal; color: #000000; width: 125px; margin-left: 15px; }
	.FormButtons { margin-right: 15px; margin-left: 15px; }
	.BlackBold { font-family: Arial, Helvetica, sans-serif; font-size: 11px; font-weight: bold; color: #000000; margin-left: 15px; }
	.BlueContent { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #003366; text-decoration: none; margin-left: 15px; }
	.IntPropButtonsBk { background-color: #eaf4ff; height: 25px; border: 1px solid #aed5ff; }
	.BritBlueBold { font-family: Arial, Helvetica, sans-serif; font-size: 11px; font-weight: bold; color: #0066cc; margin-left: 15px; }
	.GrayContent { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #666666; text-decoration: none; margin-left: 15px; }
	.BlueBorder { border: 1px solid #CCE4FF; }
	.NodePropertyBK { background-color: #f6f6f6; height: 25px; }
	.TableHead { background-color: #55AAFF; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #99CCFF; height: 25px; }
	.WhiteBold { font-family: Arial, Helvetica, sans-serif; font-size: 11px; font-weight: bold; color: #FFFFFF; margin-left: 15px; }
	.delete { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #FF0000; text-decoration: none; margin-left: 15px; }
	.duplicate { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #00CC99; text-decoration: none; margin-left: 15px; }
	.copy { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #996600; text-decoration: none; margin-left: 15px; }
	.publish { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #990000; text-decoration: none; margin-left: 15px; }
	.preview { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #FF33CC; text-decoration: none; margin-left: 15px; }
	.status { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #006600; text-decoration: none; margin-left: 15px; }
	.download { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #663399; text-decoration: none; margin-left: 15px; }
	.Msgblock { background-color: #F0F0F0; border: 1px solid #DDDDDD; }
	.ErrPosition { margin-top: 40px; }
	.err { font-family: Arial, Helvetica, sans-serif; font-size: 11px; font-weight: bold; color: #FF0000; margin-left: 15px; }
	.errmsg { font-family: Tahoma, Arial; font-size: 11px; font-weight: normal; color: #CC0000; text-decoration: none; margin-left: 15px; }
	.Msgblock { background-color: #F0F0F0; border: 1px solid #DDDDDD; }
	--> 
	</style>
</HEAD>
  <body>
	
    <form id="Form1" method="post" runat="server">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="HeaderBk">
      <tr  >
        <td width="1%" align="left" valign="top" class="HeaderTDBorder"><div align="left"><img src="images/HeaderLCurve.jpg" width="15" height="57"></div></td>
        <td width="62%" valign="middle" ><img src="../../Common/Images/Logo.gif" width="453"></td>
        <td width="2%" align="right" valign="top" class="HeaderTDBorder"><div align="right"><img src="images/HeaderRCurve.jpg" width="15" height="57"></div></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td height="400" valign="top" class="DisplayTDBk">
    <table width="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff" class="WhiteBorder">
      <tr>
        <td width="100%" class="IntfaceNameBotBorder">
        <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="WhiteBorder" >
          <tr>
            <td class="InterfaceNameTab"><div align="left" class="BlackBold">
                  <DIV class=BlackBold align=left> Security 
                  System</DIV></div></td>
          </tr>
        </table>
        </td>
      </tr>
      <tr>
        <td height="400" valign="top" >
            <table width="391" border="0" align="center" cellpadding="0" cellspacing="0" class="Msgblock">
            <tr>
                <td width="77" ><img src="images/err.gif" width="55" height="55" hspace="10"></td>
                <td height="120" ><div><span class="err">Unavailable&nbsp;&nbsp;: </span></div>
                  <div class="errmsg"><span > Sorry the request cannot be processed at this moment.Please try again later. </span></div>
                              <DIV class=errmsg><SPAN>If&nbsp;problem persist Please contact 
                              administrator.&nbsp;</SPAN></DIV></td>
            </tr>
            </table>
        </td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="FooterBk">
      <tr>
        <td width="1%" align="left" valign="bottom"><img src="images/FooterLCurve.jpg" width="10" height="18"></td>
        <td width="98%"><div align="right" class="CopyrightMsg">Copyright 2007 @ <a href="http://www.porteousfastener.com/" class="CopyrightMsg">Porteous Fastener Co.,</a>. All Rights Reserved. </div></td>
        <td width="1%" align="right" valign="bottom"><img src="images/FooterRCurve.jpg" width="10" height="18"></td>
      </tr>
    </table></td>
  </tr>
</table>
     </form>
	
  </body>
</HTML>
