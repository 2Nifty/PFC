<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RBReceiveReport.aspx.cs"
    Inherits="ReceivingReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <style type="text/css">
    /* Styles are embedded in the page to ensure they are available is all situations */
    .printPage
    {
        width : 7.5in;
        height : 10in;
        font-size : 12px;
        font-family : Arial, sans-serif;
    }
    .docTitle
    {
        font-size : 18px;
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
        font-size : 18px;
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
    .bold
    {
        font-weight: bold;
    }
    .smalltext
    {
        font-size : 10px;
    }
    .newLine
    {
        border-bottom : 1px solid black;
    }
    .rightCol
    {
        border-right : 1px solid black;
    }
    .rightPad
    {
        padding-right : 3px;
        text-align : right
    }
    .leftPad
    {
        padding-left : 3px;
        text-align : left
    }
    .bottomMessage
    {
        font-size : 11px;
        font-family : Arial, sans-serif;
    }
    .docTotal
    {
        font-size : 16px;
    }
    .topComment
    {
        font-size : 18px;
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

</style>
    <title>Receiving Report</title>
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
