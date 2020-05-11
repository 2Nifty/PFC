<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreditView.aspx.cs" Inherits="CreditView" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=11.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>View Credit Memo V1.0.0</title>
    <style type="text/css">
    /* Styles are embedded in the page to ensure they are available is all situations */
    .Logo
    {
	    background-repeat: no-repeat;
        background-image:url(Common/Images/PfcredSmall.gif);
    }

</style>
</head>
<body style="margin: 0px">
    <form id="form1" runat="server">
        <div>
            <CR:CrystalReportViewer ID="CreditMemoReportViewer" runat="server" AutoDataBind="true"  
             ReportSourceID="CreditMemoReportSource"  EnableDatabaseLogonPrompt="false" HasRefreshButton="True" HasCrystalLogo="False"/>
            <CR:CrystalReportSource ID="CreditMemoReportSource" runat="server" >
            </CR:CrystalReportSource>
        </div>
    </form>
</body>
</html>
