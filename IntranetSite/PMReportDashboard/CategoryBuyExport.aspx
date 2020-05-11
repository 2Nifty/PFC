<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="CategoryBuyExport.aspx.cs" Inherits="CategoryBuyExport" %>

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
    <title>CPR Buy Report</title>
    <style type="text/css">
    .TotBord 
	    {
	    border-top-width: 1px;
	    border-top-style: solid;
	    border-top-color: black;
	    border-bottom-width: 1px;
	    border-bottom-style: solid;
	    border-bottom-color: black;
	    font-weight: bold;
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
	    font-weight: bold;
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
    	border-bottom-width: 1px;
	    border-bottom-style: solid;
	    border-bottom-color: black;
    }
    .noData {
        font-family: Arial, Helvetica, sans-serif;	
	    font-weight: bold;
	    font-size: 24pt;
    }
    .NewPage {page-break-before: always;}
    .GridItem {
        font-family: 'Arial Narrow', Arial, Helvetica, sans-serif;	
        font-size: 11pt; 
        color: #000000; 
        text-decoration:none; 
        padding-top: 0px; 
        padding-right: 2px; 
        padding-left: 2px; 
        padding-bottom: 1px;
    }
    .ItemData {
        font-family: Arial, Helvetica, sans-serif;	
        font-size: 11pt; 
        color: #000000; 
        text-decoration:none; 
        padding-right: 2px; 
    }
    .VendorData {
        font-family: Arial, Helvetica, sans-serif;	
        font-size: 11pt; 
        color: #000000; 
        text-decoration:none; 
        padding-top: 1px; 
        padding-right: 2px; 
        padding-bottom: 1px;
    	border-bottom-width: 1px;
	    border-bottom-style: solid;
	    border-bottom-color: black;
    }
    
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="HiddenFactor" runat="server" />
        <asp:HiddenField ID="VMIChain" runat="server" />
        <asp:HiddenField ID="VMIContract" runat="server" />
        <asp:HiddenField ID="VMIRun" runat="server" />
        <asp:HiddenField ID="LongReport" runat="server" />
        <asp:HiddenField ID="StatusFileName" runat="server" />
        <asp:Table ID="RepTable" runat="server" CellPadding="0" CellSpacing="0">
        </asp:Table>
    </form>
</body>
</html>
