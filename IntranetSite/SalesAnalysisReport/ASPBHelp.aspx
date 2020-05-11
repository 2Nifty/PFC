<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ASPBHelp.aspx.vb" Inherits="ASPBHelp" %>

<%@ Register Src="~/IntranetTheme/UserControls/PageHeader.ascx" TagName="Header"
    TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head>
<title>Average Cost Selling Price - Bulk Report Help</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../IntranetTheme/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>

<body topmargin="4" >
 <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <uc1:Header ID="PageHeader1" runat="server" />
            </td>
        </tr>
        <tr>
            <td align="center">
                <div align="left">
                </div>
                <table width="100%" border="0" cellspacing="0" cellpadding="3">
                    <tr>
                        <%--            <td width="151" height="333" align="left" valign="top"> 
                <!-- #include file="PageMenu.htm" --></td>
--%>
<td align="left" class="GreenHd" valign="middle">
                            <b><font face="Arial" color="#990000" size="2">&nbsp;Running the Average Selling Price - Bulk Report</font></b>
                            
                        </td>
                        <td align="right" class="GreenHd" valign="middle">
                            <img style="cursor: hand;" onclick="javascript:window.close();" src="../IntranetTheme/Images/Buttons/Close.gif" />
                        </td>
                    </tr>
                    <tr>
                        <td class="blackTxtHelp" colspan="2" align="left" valign="top">
                            <blockquote>
            <p align="left"><br>
                <font size="2" face="Arial">The parameters are:</font>                </p>
            </blockquote>
                            <ul>
                              <li>
                              <font size="2" face="Arial"><strong>Month</strong> - Select month for the report from the Drop Down List&nbsp;</font></li>
                              <li>                                <font size="2" face="Arial"><strong>Year</strong> - Enter 4 digit Year&nbsp;</font><br />
                                                  </li>
                            </ul>
                            <blockquote><font size="2" face="Arial">
              You must make an entry for both fields.</font>
                              <P>
                  <font size="2" face="Arial">Once you have selected your parameters
                  press the <strong>OK</strong> button at the bottom of the page to preview the report.</font>
                                </p>
                              <p>
                     <font size="2" face="Arial"> Once the report is previewed, you can search<img src="PFCimages/search.gif" />, export<img src="PFCimages/export.gif" /> 
                      or print<img src="PFCimages/print.gif" /> from the toolbar at the top of the page. If you're exporting
                      to Excel, copy the data from the Excel page that appears and paste it into Excel.
                      When pasting, do a <strong>Paste Special</strong> and paste as Excel 8.0 Workbook</font></p>
                              <font size="2" face="Arial">To run the report again with new choices, press the <strong>Refresh</strong> <img src="PFCimages/refresh.gif" /> button while the report is previewed.
                              </font><br />
                      </blockquote></td>

        </tr>
        <tr valign="top">
                        <td height="37" colspan="2" class="GreenHd">
                            &nbsp;</td>
                    </tr>
      </table>
    </td>
  </tr>
</table>

</body>
</html>

