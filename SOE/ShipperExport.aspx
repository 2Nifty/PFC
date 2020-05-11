<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShipperExport.aspx.cs" Inherits="ShipperExport" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<% if ((Request.QueryString["ScriptX"] != null) && (Request.QueryString["ScriptX"] == "YES"))
   { %>
<!-- #Include virtual="common/include/ScriptX.inc" -->
    <script src="Common/JavaScript/ScriptX.js" type="text/javascript"></script>
    <script type="text/javascript">
    // Landscape with 1/4 inch margins
    SetPrintSettings(false, 0.25, 0.25, 0.25, 0.25);
    </script>
<% } %>
    <script>
    // onload="SetTotPages();"
        function SetTotPages()
        {
            var TotPageValue = document.getElementById("TotPageHidden").value;
            if (TotPageValue != null)
            {
                for (var i = 1;  i <= TotPageValue; i++)
                {
                    var PageText = document.getElementById("XPageFooter"+i).lastChild.lastChild.lastChild.lastChild;
                    PageText.innerText = PageText.innerText.replace(/XX/,TotPageValue);
                }
            }
        }
    </script>

    <style type="text/css">
    /* Styles are embedded in the page to ensure they are available is all situations */
    .printPage
    {
        /* width : 10.5in;
        height : 8in;*/
        font-size : 10pt;
        font-family : Arial, sans-serif;
    }
    .posAbsolute
    {
        position : absolute;
    }
    .pageFooter
    {
        left : 0.15in;
    }
    .docFooter
    {
        left : 0.15in;
    }
    .docTitle
    {
        font-size : 16pt;
        font-weight : bold;
    }
    .pageHeader
    {
        left : 0.15in;
    }
    .newPage
    {
        page-break-before: always
    }
    .tenthLine
    {
        height : 0.1in;
    }
    .locName
    {
        float : left;
        font-size : 18pt;
    }
    .locAddr
    {
        float : left;
        clear : both;
        font-size : 12pt;
    }
    .rightFloat
    {
        float : right;
    }
    .bold
    {
        font-weight: bold;
    }
    .big24text
    {
        font-size : 24pt;
    }
    .big14text
    {
        font-size : 14pt;
    }
    .largetext
    {
        font-size : 12pt;
    }
    .medtext
    {
        font-size : 11pt;
    }
    .smalltext
    {
        font-size : 10pt;
    }
    .microtext
    {
        font-size : 6pt;
    }
    .newLine
    {
        border-bottom : 3px solid black;
    }
    .bothLine
    {
        border-top : 3px solid black;
        border-bottom : 3px solid black;
    }
    .rightCol
    {
        padding-right : 3px;
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
        font-size : 14pt;
        padding-left : 5px;
    }
    .watermark
    {
	    background-repeat: no-repeat;
	    background-position: 50% 0%;
    }

</style>
    <title>Receiving Report</title>
</head>
<body >
    <form id="form1" runat="server">
        <center>
            <div class="printPage">
                    <asp:HiddenField ID="TotPageHidden" runat="server" />
                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                    <asp:Table ID="MainReport" runat="server" Width="100%" CellPadding="0" CellSpacing="0">
                    </asp:Table>
            </div>
        </center>
    </form>
    <script>
            var TotPageValue = document.getElementById("TotPageHidden").value;
            if (TotPageValue != null)
            {
                for (var i = 1;  i <= TotPageValue; i++)
                {
                    var PageText = document.getElementById("XPageFooter"+i).lastChild.lastChild.lastChild.lastChild;
                    PageText.innerText = PageText.innerText.replace(/XX/,TotPageValue);
                }
            }
    </script>
</body>
</html>
