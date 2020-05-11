<%@ Page Language="C#" AutoEventWireup="true"  EnableEventValidation="false"  CodeFile="WorkOrderExport.aspx.cs" Inherits="WorkOrderExport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<% if ((Request.QueryString["ScriptX"] != null) && (Request.QueryString["ScriptX"] == "YES"))
   { %>
<!-- #Include virtual="common/include/ScriptX.inc" -->
    <script src="Common/JavaScript/ScriptX.js" type="text/javascript"></script>
    <script type="text/javascript">
    // Landscape with 1/4 inch margins
    SetPrintSettings(false, 0.25, 0.25, 0.25, 0.25);
    </script>
<% } %>
    <title>WO Export</title>
    <style type="text/css">
    /* Styles are embedded in the page to ensure they are available is all situations */
    .printPage
    {
        font-size : 12pt;
        font-family : Arial, sans-serif;
    }
    .docTitle
    {
        font-size : 20pt;
    }
    .pageHeader
    {
    }
    .newPage
    {
        page-break-before: always
    }
    .locName
    {
        float : left;
        font-size : 18pt;
        font-weight : bold;
        padding-top : 5px;
    }
    .locAddr
    {
        float : left;
        clear : both;
    }
    .rightFloat
    {
        float : right;
    }
    .leftFloat
    {
        float : left;
    }
    .bold
    {
        font-weight: bold;
    }
    .largetext
    {
        font-size : 14pt;
    }
    .medtext
    {
        font-size : 12pt;
    }
    .smalltext
    {
        font-size : 10pt;
    }
    .microtext
    {
        font-size : 8pt;
    }
    .botBord
    {
        border-bottom : 1px solid black;
    }
    .botTopBord
    {
        border-top : 1px solid black;
        border-bottom : 1px solid black;
    }
    .topBord
    {
        border-top : 1px solid black;
    }
    .rightCol
    {
        border-right : 1px solid black;
    }
    .rightPad
    {
        padding-right : 3px;
        text-align : right;
    }
    .leftPad
    {
        padding-left : 3px;
        text-align : left;
    }
    .bottomMessage
    {
        font-size : 11pt;
        font-family : Arial, sans-serif;
    }
    .docTotal
    {
        font-size : 16pt;
    }
    .topComment
    {
        font-size : 18pt;
        padding-left : 10px;
        font-weight: bold;
    }
    .watermark
    {
	    background-repeat: no-repeat;
	    background-position: 50% 20%;
    }
    .barcode
    {
        font-size : 12pt;
        font-family : IDAutomationC39S;
    }
    .barclip1
    {
        padding:0px;
        border:5px solid gray;
        margin:0px;
    }

</style>
</head>
<body>
    <form id="form1" runat="server">
        <center>
            <div class="printPage">
                <div id="TestWatermark" runat="server">
                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                    <asp:Table ID="MainReport" runat="server" Width="100%" CellPadding="0" CellSpacing="0">
                    </asp:Table>
                </div>
            </div>
        </center>
    </form>
</body>
</html>
