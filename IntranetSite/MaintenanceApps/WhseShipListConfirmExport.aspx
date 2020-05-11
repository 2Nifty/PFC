<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="WhseShipListConfirmExport.aspx.cs"
    Inherits=" PFC.Intranet.ListMaintenance._WhseShipListConfirm" ValidateRequest="false" %>

<%@ Register Src="../Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc6" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shipping List Confirmation</title>
    <link href="../MaintenanceApps/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
 
    <style>
    .barcode
    {
        font-size : 12pt;
        font-family : IDAutomationC39S;
    }
      
body,td,th {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #003366;
}
    </style>
    <script>
    
    function PrintReport()
    {  
        var WinPrint = window.open('../Common/ErrorPage/print.aspx','Print','height=710,width=710,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    } 
    </script>
    
</head>


<body
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';"
    scroll="no">
    <form id="form1" runat="server" >
        &nbsp;
    </form>
</body>
</html>
