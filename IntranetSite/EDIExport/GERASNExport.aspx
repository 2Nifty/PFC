<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GERASNExport.aspx.cs" Inherits="GERASNExport" %>

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
	.title { border : 1px solid black; font-family : Arial, sans-serif; font-size : 20pt; } 
	.border { border : 1px solid black; } 
	.borderc { border : 1px solid black; text-align:center; }
	.bordercred { border : 1px solid black; text-align:center; color:red; font-weight: bold;} 
	.borderr { border : 1px solid black; text-align:right; } 
	.left { text-align:left; }
	.center { text-align:center; }
	.right { text-align:right; }
	.rightbold { text-align:right; font-weight: bold; }
	.heading { font-family : Arial, sans-serif; font-size : 10pt; background-color: #CCCCCC; border : 1px solid black;}
	.headingc { font-family : Arial, sans-serif; font-size : 10pt; background-color: #CCCCCC; border : 1px solid black; text-align:center;} 
    .watermark
    {
	    background-repeat: no-repeat;
	    background-position: 50% 20%;
    }
    .barcode
    {
        font-size : 12pt;
        font-family : IDAutomationC39M;
    }

</style>
    <title>Receiving Report</title>
</head>
<body>
    <form id="form1" runat="server">
        <center>
            <div>
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
