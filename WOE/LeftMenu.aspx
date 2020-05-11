<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LeftMenu.aspx.cs" Inherits="SOEMenu" %>

<%@ Register Src="Common/UserControls/LeftFrame.ascx" TagName="LeftFrame" TagPrefix="asp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script src="Common/JavaScript/WorkOrderEntry.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js"></script>  
    <script src="Common/JavaScript/WorkOrderEntry.js"></script>  
</head>
<body class="LeftBg">
    <form id="form1" runat="server">
        <table id="Table1" height="100%" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td height="100%">
                    <asp:LeftFrame ID="LeftFrame1" runat="server"></asp:LeftFrame>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
