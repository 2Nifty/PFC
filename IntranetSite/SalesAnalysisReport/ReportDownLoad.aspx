<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportDownLoad.aspx.cs" Inherits="SalesAnalysisReport_ReportDownLoad" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DownLoad</title>
    <link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        
        <table width="450"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2">
            <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
              <tr>
                <td width="62%" valign="middle" ><img src="Images/small_Logo.gif" hspace="25" vspace="10"></td>
              </tr>
            </table></td>
          </tr>
          <tr><td></td></tr>
          <tr>
            <td width="100%" valign="top">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" class="LoginFormBk">
              <tr>
                <td height="50"  valign="top" >
                  <div align="left">  
                  
                    <table width=100% cellpadding=0 cellspacing=0>
                        <tr><td align=center height=30px><span class=GridHead style="color:green">Report has been successsfully exported to excel file</span></td></tr>
                        <tr><td align=center height=30px><a target="_blank" id= lnkDownLoad runat=server>Click here to Download the report</a></td></tr>
                        <tr><td valign=middle align=center height=30px></td></tr>
                    </table>
                  
                  </div></td>
                </tr>
            </table></td>
          </tr>
          <tr bgcolor="#DFF3F9">
            <td height="29" colspan="2" class="BluTopBord"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="72%" height="25" class="foottxt1">&nbsp;&nbsp;Copyright 2006 @ Porteous Fastener Co.,&nbsp;</td>
                <td width="28%" class="foottxt1"><i>powered by Novantus</i></td>
              </tr>
            </table></td>
          </tr>
        </table>
    </form>
</body>
</html>
