<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FooterFrame.aspx.cs" Inherits="System_FrameSet_FooterFrame" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <LINK href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
</head>
<body>
    <form id="form1" runat="server">
        <table id="Table1" height="100%" cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>
                <td>
                    <uc1:BottomFrame ID="BottomFrame1" runat="server" />
                   
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
