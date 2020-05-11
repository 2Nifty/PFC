<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="CPRReportExport.aspx.cs"
    Inherits="CPRReport" %>

<%@ Register Src="Common/UserControls/FooterImage.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<% if ((Request.QueryString["ScriptX"] != null) && (Request.QueryString["ScriptX"] == "YES"))
   { %>
<!-- #Include virtual="../common/include/ScriptX.inc" -->
    <script src="../Common/JavaScript/ScriptX.js" type="text/javascript"></script>
    <script type="text/javascript">
    // Landscape with 1/4 inch margins
    SetPrintSettings(false, 0.25, 0.25, 0.25, 0.25);
    </script>
<% } %>
    <title>CPR Report</title>
    <style type="text/css">
    .TotBord 
	    {
	    border-top-width: 1px;
	    border-top-style: solid;
	    border-top-color: black;
	    border-bottom-width: 1px;
	    border-bottom-style: solid;
	    border-bottom-color: black;
	    }
    .TotBordGroup 
	    {
	    border-top-width: 1px;
	    border-top-style: solid;
	    border-top-color: black;
	    border-bottom-width: 1px;
	    border-bottom-style: solid;
	    border-bottom-color: black;
	    border-right-width: 1px;
	    border-right-style: solid;
	    border-right-color: black;
	    }
    .NewPage 
	{
		page-break-before: always;
	}
    .rightBorder {
	    border-right-width: 1px;
	    border-right-style: solid;
	    border-right-color: black;
    }
    .bottomBorder {
	    font-weight: bold;
    	border-bottom-width: 1px;
	    border-bottom-style: solid;
	    border-bottom-color: black;
    }
    .noData {
        font-family: Arial, Helvetica, sans-serif;	
	    font-weight: bold;
	    font-size: 24px;
    }
    .NewPage {page-break-before: always;}
    .GridItem {
    font-family: 'Arial Narrow', Arial, Helvetica, sans-serif;	
    font-size: 10pt; 
    color: #000000; 
    text-decoration:none; 
    padding-top: 0px; 
    padding-right: 1px; 
    padding-bottom: 0px;
    }
    .XFerGrid {
    font-family: 'Arial Narrow', Arial, Helvetica, sans-serif;	
    font-size: 11pt; 
    color: #000000; 
    text-decoration:none; 
    padding-top: 1px; 
    padding-right: 1px; 
    padding-bottom: 0px;
    }
    
    </style>
</head>
<body style="margin:0px;">
    <form id="form1" runat="server">
        <asp:HiddenField ID="HiddenFactor" runat="server" />
        <asp:HiddenField ID="HiddenIncludeSummQtys" runat="server" />
        <asp:HiddenField ID="VMIChain" runat="server" />
        <asp:HiddenField ID="VMIContract" runat="server" />
        <asp:HiddenField ID="VMIRun" runat="server" />
        <asp:HiddenField ID="ReportFormat" runat="server" />
        <asp:HiddenField ID="StatusFileName" runat="server" />
        <asp:Table ID="RepTable" runat="server">
        </asp:Table>
    </form>
</body>
</html>
