<%@ Page Language="VB" AutoEventWireup="false" %>
<%@ Register TagPrefix="CR" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Open Purchase Orders Report</title>
<link href="Intranet.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:HyperLink ID="OpenPOHelp" runat="server" BorderStyle="Solid" BorderWidth="1px"
            NavigateUrl="OpenPOHelp.aspx">Open PO Help</asp:HyperLink>
        &nbsp; &nbsp;&nbsp;
        <asp:TextBox ID="OpenPOLabel" runat="server" Font-Bold="True" Font-Size="Larger" Width="285px">Open Purchase Orders Report</asp:TextBox><br />
        <br />
        <CR:CrystalReportViewer ID="CrystalReportViewer1" Runat="server" AutoDataBind="True"
            Height="947px" ReportSourceID="OpenPO" Width="845px" EnableDatabaseLogonPrompt="false" HasCrystalLogo="False" 
            HasRefreshButton="True" ReuseParameterValuesOnRefresh="true" CssClass="notice" />
        <CR:CrystalReportSource ID="OpenPO" runat="server">
            <Report FileName="OpenPurchaseOrder.rpt">
            </Report>
        </CR:CrystalReportSource>
    
    </div>
    </form>
</body>
</html>
