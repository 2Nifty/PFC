<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RBMoveTransfersHelp.aspx.cs" Inherits="Warehouse_RBMoveTransfersHelp" %>
<%@ Register Src="IntranetTheme/UserControls/PageHeader.ascx" TagName="Header"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>NV->RB Transfer Receipts Help</title>
    <link href="IntranetTheme/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
   <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <uc1:Header ID="PageHeader1" runat="server" />
            </td>
        </tr>
        <tr>
            <td align="center">
                <div align="left">
                </div>
                <table width="100%" border="0" cellspacing="0" cellpadding="3">
                    <tr>
                        <%--            <td width="151" height="333" align="left" valign="top"> 
                <!-- #include file="PageMenu.htm" --></td>
--%>
<td align="left">
                            <div class="GreenHd">
                                <b><font face="Arial" color="#990000" size="2">&nbsp;Radio Beacon Create Transfer Receipts Help</font></b></div>
                        </td>
                    </tr>
                    <tr>
                        <td class="blackTxtHelp" align="left" valign="top">
                            <blockquote>
                                    <p align="left">
                                        <ul>
                                        <li>Enter the NV TO numbers for the receipts you want to create in RB.</li>
                                        <li>Numbers must start with TO or TS.</li>
                                        <li>Copying a single column from Excel and pasting into the list is OK.</li>
                                        <li>can delete from the list by selecting the row and deleting it.</li>
                                        <li>Press the SUBMIT button to move the transfer reciepts to RB.</li>
                                        </ul>
                                    </p>
                                    <br />
                                    <p>
                                        Use the <- browser back arrow button to return to report selection</p>
                            </blockquote>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td height="37" class="GreenHd">
                            &nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
