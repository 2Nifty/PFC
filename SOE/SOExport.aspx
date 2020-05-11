<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SOExport.aspx.cs" Inherits="SOExport" %>

<%@ Register Src="Common/UserControls/PrintDocLogo.ascx" TagName="DocLogo" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<% if ((Request.QueryString["ScriptX"] != null) && (Request.QueryString["ScriptX"] == "YES"))
   { %>
<!-- #Include virtual="common/include/ScriptX.inc" -->
    <script src="Common/JavaScript/ScriptX.js" type="text/javascript"></script>
    <script type="text/javascript">
    // Portrait with 1/4 inch margins
    SetPrintSettings(true, 0.25, 0.25, 0.25, 0.25);
    </script>
<% } %>
    <title>Order Document</title>
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
        font-size : 24px;
        font-style : italic;
        border-bottom : 1px solid black;
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
    .desctext
    {
        font-size : 11px;
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

</style>
</head>
<body style="margin : 0px;">
    <form id="form1" runat="server">
        <center><div class="printPage"><div id="TestWatermark" runat="server">
            <asp:Table ID="DocTable" runat="server" Width="100%" CellPadding="0" CellSpacing="0">
                <asp:TableRow ID="header" CssClass="pageHeader">
                    <asp:TableCell ColumnSpan="6">
                        <table width="100%">
                            <tr>
                                <td width="30%" valign="top" id="PFCLogo">
                                    <uc1:DocLogo ID="PFCLogoImage" runat="server" />
                                </td>
                                <td width="70%" align="center" valign="top">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td colspan="5" class="docTitle">
                                                Porteous Fastener Co. 
                                                <asp:Label ID="DocTitleLabel" runat="server" Text="Label"></asp:Label>
                                                <asp:HiddenField ID="NumberOfPages" runat="server" />
                                                <asp:HiddenField ID="DocType" runat="server" />
                                                <asp:HiddenField ID="LineSort" runat="server" />
                                                <asp:HiddenField ID="HeaderTable" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left">
                                                &nbsp;&nbsp; Reference:
                                            </td>
                                            <td align="right">
                                                Customer ID:
                                            </td>
                                            <td align="right">
                                                Order Date:
                                            </td>
                                            <td align="right">
                                                Order Number:
                                            </td>
                                            <td align="right">
                                                Page:
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left">
                                                &nbsp;&nbsp;
                                                <asp:Label ID="ReferenceLabel" runat="server"></asp:Label>
                                            </td>
                                            <td align="right">
                                                &nbsp;&nbsp;
                                                <asp:Label ID="CustIDLabel" runat="server"></asp:Label>
                                            </td>
                                            <td align="right">
                                                <asp:Label ID="OrderDateLabel" runat="server"></asp:Label>
                                            </td>
                                            <td align="right">
                                                <asp:Label ID="OrderNumberLabel" runat="server"></asp:Label>
                                            </td>
                                            <td align="right" id="pageNoCell">
                                                <asp:Label ID="PageNumberLabel" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <div class="locName">
                                                    <asp:Label ID="LocNameLabel" runat="server"></asp:Label></div>
                                                <asp:Label ID="LocAddr1" runat="server" CssClass="locAddr"></asp:Label>
                                                <asp:Label ID="LocAddr2" runat="server" CssClass="locAddr"></asp:Label>
                                                <asp:Label ID="LocCityStZip" runat="server" CssClass="locAddr"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow ID="subHeader">
                    <asp:TableCell>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <col width="18%" />
                            <col width="36%" />
                            <col width="12%" />
                            <col width="34%" />
                            <tr>
                                <td align="right">
                                    Inside Sales Rep
                                </td>
                                <td align="left" class="bold">
                                    &nbsp;
                                    <asp:Label ID="InsideNameLabel" runat="server"></asp:Label>
                                </td>
                                <td align="right">
                                    Sales Mgr
                                </td>
                                <td align="left" class="bold">
                                    &nbsp;
                                    <asp:Label ID="MgrNameLabel" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    E-Mail
                                </td>
                                <td align="left" class="bold">
                                    &nbsp;
                                    <asp:Label ID="InsideEMailLabel" runat="server"></asp:Label>
                                </td>
                                <td align="right">
                                    E-Mail
                                </td>
                                <td align="left" class="bold">
                                    &nbsp;
                                    <asp:Label ID="MgrEMailLabel" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    Phone
                                </td>
                                <td align="left">
                                    &nbsp;
                                    <asp:Label ID="InsidePhoneLabel" runat="server"></asp:Label>
                                </td>
                                <td align="right">
                                    Phone
                                </td>
                                <td align="left">
                                    &nbsp;
                                    <asp:Label ID="MgrPhoneLabel" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    FAX
                                </td>
                                <td align="left">
                                    &nbsp;
                                    <asp:Label ID="InsideFAXLabel" runat="server"></asp:Label>
                                </td>
                                <td align="right">
                                    FAX
                                </td>
                                <td align="left">
                                    &nbsp;
                                    <asp:Label ID="MgrFAXLabel" runat="server"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <col width="35%" />
                            <col width="35%" />
                            <col width="30%" />
                            <tr>
                                <td valign="top">
                                    <asp:Label ID="BillLabel1" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="BillLabel2" runat="server" CssClass="locAddr bold"></asp:Label>
                                    <asp:Label ID="BillLabel3" runat="server" CssClass="locAddr bold"></asp:Label>
                                    <asp:Label ID="BillLabel4" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="BillLabel5" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="BillLabel6" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="BillLabel7" runat="server" CssClass="locAddr"></asp:Label>
                                </td>
                                <td valign="top">
                                    <asp:Label ID="SellLabel1" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="SellLabel2" runat="server" CssClass="locAddr bold"></asp:Label>
                                    <asp:Label ID="SellLabel3" runat="server" CssClass="locAddr bold"></asp:Label>
                                    <asp:Label ID="SellLabel4" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="SellLabel5" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="SellLabel6" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="SellLabel7" runat="server" CssClass="locAddr"></asp:Label>
                                </td>
                                <td valign="top">
                                    <asp:Label ID="ShipLabel1" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="ShipLabel2" runat="server" CssClass="locAddr bold"></asp:Label>
                                    <asp:Label ID="ShipLabel3" runat="server" CssClass="locAddr bold"></asp:Label>
                                    <asp:Label ID="ShipLabel4" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="ShipLabel5" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="ShipLabel6" runat="server" CssClass="locAddr"></asp:Label>
                                    <asp:Label ID="ShipLabel7" runat="server" CssClass="locAddr"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <col width="15%" />
                            <col width="15%" />
                            <col width="15%" />
                            <col width="15%" />
                            <col width="10%" />
                            <col width="30%" />
                            <tr>
                                <td colspan="6" class="topComment">
                                    <asp:Label ID="CommentTopLabel" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    Your Reference:
                                </td>
                                <td align="left" colspan="5">
                                    <asp:Label ID="YourReferenceLabel" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    PO Number:
                                </td>
                                <td align="left" colspan="5">
                                    <asp:Label ID="PONumberLabel" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    Date:
                                </td>
                                <td align="left">
                                    <asp:Label ID="DateLabel" runat="server"></asp:Label>
                                </td>
                                <td align="right">
                                    Shipment Date:
                                </td>
                                <td align="left">
                                    <asp:Label ID="ShipmentDateLabel" runat="server"></asp:Label>
                                </td>
                                <td align="right">
                                    Terms:
                                </td>
                                <td align="left">
                                    <asp:Label ID="TermsLabel" runat="server"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <div id="headerComment">
                        </div>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </div></div></center>
    </form>
</body>
</html>
