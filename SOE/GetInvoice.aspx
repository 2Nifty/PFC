<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetInvoice.aspx.cs" Inherits="GetInvoice" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Original Invoice - Preview Page</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/Common.js"></script>
</head>
<body bgcolor="#ECF9FB">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1"  AsyncPostBackTimeout ="360000"  EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <div>
            <table cellpadding="2" style="border: 1px solid #BAEBF4;" cellspacing="0">
                <tr>
                    <td>
                        <table cellpadding="2" width="100%" cellspacing="0">
                            <tr>
                                <td width="400px">
                                    <table cellpadding="3" cellspacing="3">
                                        <tr>
                                            <td style="width: 60px; padding-right: 5px; padding-left: 2px" align="left">
                                                <strong>Invoice No: </strong>
                                            </td>
                                            <td style="padding-right: 3px; padding-left: 2px">
                                                <asp:Label ID="txtInvoiceNumber" runat="server" Font-Bold="false"></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                                <td align="right" style="padding-right: 10px">
                                    &nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center" style="width:880px;height:600px">                        
                        <iframe width=880px height=600px runat=server id=ifrmInvoice></iframe>                        
                    </td>
                </tr>
                <tr>
                    <td align="right" width="100%" id="td1" class="splitborder_t_v splitborder_b_v"
                        style="height: 20px; background-position: -80px  left;" bgcolor="#DFF3F9">
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="left" style="padding-left: 10px;" width="90%">
                                    <asp:UpdateProgress ID="pnlProgress" runat="server">
                                        <ProgressTemplate>
                                            <span class="TabHead">Loading...</span></ProgressTemplate>
                                    </asp:UpdateProgress>
                                    <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                </td>
                                <td colspan="4" style="padding-right: 5px;">
                                    <asp:UpdatePanel ID="pnlContactEntry" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <uc5:PrintDialogue ID="PrintDialogue1" runat="server" EnableFax="true"></uc5:PrintDialogue>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" width="90%">
                                </td>
                                <td colspan="4" style="padding-top: 3px; padding-bottom: 3px; padding-right: 5px;">
                                    <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                                <td>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <uc1:Footer ID="Footer1" runat="server" />
                    </td>
                </tr>                          
            </table>
        </div>
    </form>
</body>
</html>
