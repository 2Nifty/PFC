<%@ Page Language="VB" AutoEventWireup="false" CodeFile="OpenPOHelp.aspx.vb" Inherits="OpenPOHelp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head>
<title>Open Purchase Orders Report Help</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="Intranet.css" rel="stylesheet" type="text/css" />
</head>

<body bgcolor="#9A0201" topmargin="4" >
<table width="755" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#000000">
  <tr>
    <td width="744" bgcolor="#FFFFFF"><img src="PFCImages/PFC_Top_Banner.gif" 
    alt="Porteous Fastener Company - High Quality Nuts &amp; Bolts, Screws, Washers &amp; Anchors" 
    width="755" height="86" border="0" usemap="#Map"></td>
  </tr>
  <tr>
    <td align="center" bgcolor="#FFFFFF">      <div align="left"></div>
      <table width="755" border="0" cellspacing="0" cellpadding="0">
          <tr> 
<%--            <td width="151" height="333" align="left" valign="top"> 
                <!-- #include file="PageMenu.htm" --></td>
--%>            <td width="10" align="left" valign="top" bgcolor="#FFFFFF"></td>
            <td width="584" align="left" valign="top" bgcolor="#FFFFFF"><p align="left">
              <B>Running the Purchase Orders Report</B><br>
                The parameters are:
                <br /><i>PO Number - Enter a Range of Valid PO Numbers (Defaults to All&nbsp;</i><br />
                <i>PO Status - Select PO Status from The Drop Down Menu&nbsp;<br />
                <i>Vendor - Select Vendor from the Drop Down Menu&nbsp;<br />
                <i>Branchs - Select 1 or More Branches (Shift Click, or Ctrl Click), (Default All Branches)&nbsp;<br />
                <i>Orgin Date - Enter a range or List of Origination Dates&nbsp;<br />
                <i>Planned Date - Enter a range or list of Planned Receipt Dates&nbsp;<br />
                <i>Rev date - Enter a range or list of Revised Receipt Dates&nbsp;<br />

                You must make an entry for all fields.<P>
                Once you have selected your parameters
                press the OK button at the bottom of the page to preview the report.
            </p>
                <p>
                    Once the report is previewed, you can search<img src="images/search.gif" />, export<img src="images/export.gif" /> 
                    or print<img src="images/print.gif" /> from the toolbar at the top of the page. If you're exporting
                    to Excel, copy the data from the Excel page that appears and paste it into Excel.
                    When pasting, do a Paste Special and paste as Excel 8.0 Workbook</p>
                To run the report again with new choices, press the Refresh <img src="images/refresh.gif" /> button while the report is previewed.<p>
                    &nbsp;</p>
                 <p>Use the <- browser back arrow button to return to report selection</p>
            </td>
            <td width="10" align="left" valign="top" bordercolor="#FFFFFF" bgcolor="#DCDCDC"><div align="center"><br>
              <br>
            </div></td>
        </tr>
      </table>
    </td>
  </tr>
</table>

</body>
</html>

