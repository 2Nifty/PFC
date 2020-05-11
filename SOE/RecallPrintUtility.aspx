<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RecallPrintUtility.aspx.cs" Inherits="RecallPrintUtility"
    EnableEventValidation="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Print Utility</title>
    <link href="Common/StyleSheet/fixFloat_IE6.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/utilityWndStyles.css" rel="stylesheet" type="text/css" />

</head>
<body scroll="no" style="margin: 2px;"  >
    <form runat="server" id="form1">
        <asp:ScriptManager ID="scmPrintUtility" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlButtons" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="wndContainer clearfix" style="width: 638px">
                    <div class="wndTitle" >
                        <div class="wndControls">
                            <a href="#" style="display: block; background: #cc0000; border: 1px solid #990000;
                                width: 25px; text-align: center; line-height: 22px; cursor: pointer; color: #ffffff;
                                text-decoration: none;" onclick="javascript:window.opener.focus();parent.window.close();">X</a>
                        </div>
                        Porteous Export Utility Window
                    </div>
                    <div class="wndBody">
                        <table cellpadding=0 cellspacing=0 border=0 style="padding-bottom:5px;padding-left:10px;" width=100%>
                            <tr>
                                <td align="left" class="txtLogin">
                                    <asp:Label ID="lblCust" CssClass="BannerText"  runat="server"></asp:Label>
                                </td>
                                <td align="right" style="width: 250px;padding-right:10px;" valign=bottom ><strong>
                                    <asp:Label ID="lblSubject"  runat="server"></asp:Label></strong>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding=0 cellspacing=0 border=0 style="padding-left:10px;">
                            <tr>
                                <td>
                                   <%-- <asp:ImageButton ImageUrl="~/images/UserLibrary/Print_n.gif" ID="btnPrint" runat="server"
                                        OnClick="btnPrint_Click" />--%>
                                    <asp:ImageButton ImageUrl="~/Common/Images/Email_n.gif" ID="btnEmail" runat="server"
                                        OnClick="btnEmail_Click" />
                                   <%-- <asp:ImageButton ImageUrl="~/images/UserLibrary/fax_n.gif" ID="btnFax" runat="server"
                                        OnClick="btnFax_Click" />--%>
                                </td>
                            </tr>
                        </table>
                       <%-- <asp:UpdatePanel ID="pnlPint" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 620px; height: 220px;" cellpadding=0 cellspacing=0 border=0 class="wndContent">
                                    <tr>
                                        <td style="width: 600px;" valign="top">
                                            <table cellpadding=0 cellspacing=0 border=0 style="padding-top:10px;">
                                                <tr>
                                                <td colspan=2 style="padding-left:10px;"> <asp:Label ID="Label2" runat="server" Text="Page Setup "></asp:Label>
                                                <asp:HiddenField ID="HidPageSetup" runat="server" />
                                                </td>
                                                    <td>
                                                        <asp:RadioButton ID="rdoPortrait" runat="server" OnCheckedChanged="rdoPortrait_CheckedChanged"
                                                             AutoPostBack="True" Checked="True"  Text ="Portrait" GroupName="PageSetup" /></td>
                                                   
                                                    <td>
                                                        <asp:RadioButton ID="rdoLandscape" runat="server" OnCheckedChanged="rdoLandscape_CheckedChanged"
                                                            AutoPostBack="True" Text="Landscape" GroupName="PageSetup" /></td>
                                                   
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:RadioButton ID="rdoText" runat="server" OnCheckedChanged="rdoText_CheckedChanged"
                                                            AutoPostBack="True" Checked="True" GroupName="Print" /></td>
                                                    <td style="width: 80px; height: 27px;">
                                                        <asp:Label ID="Label5" runat="server" Text="Network Path "></asp:Label></td>
                                                    <td style="width: 100px" colspan =2>
                                                        <asp:TextBox ID="txtPrint" runat="server" Width="320px" CssClass="FormControls"></asp:TextBox></td>
                                                </tr>
                                                
                                            </table>
                                            <table  cellpadding=0 cellspacing=0 border=0>
                                          
                                                <tr>
                                                    <td>
                                                        <asp:RadioButton ID="rdoPrint" runat="server" OnCheckedChanged="rdoPrint_CheckedChanged"
                                                            AutoPostBack="True" GroupName="Print" /></td>
                                                    <td style="width: 80px; height: 27px;">
                                                        <asp:Label ID="Label7" runat="server" Text="Domain " Width="80px"></asp:Label></td>
                                                    <td style="width: 80px">
                                                        <asp:DropDownList ID="ddlPrinterServer" runat="server" Width="80px" OnSelectedIndexChanged="ddlPrinterServer_SelectedIndexChanged"
                                                            Enabled="False" CssClass="FormControls" AutoPostBack="True">
                                                        </asp:DropDownList></td>
                                                    <td style="width: 60px" align="right">
                                                        <asp:Label ID="Label8" runat="server" Text="Printer" Width="60px"></asp:Label></td>
                                                    <td style="width: 100px">
                                                        <asp:DropDownList ID="ddlPrinterName" runat="server" Width="187px" Enabled="False"
                                                            CssClass="FormControls">
                                                        </asp:DropDownList></td>
                                                </tr>
                                            </table>
                                            <table  cellpadding=0 cellspacing=0 border=0  style="padding-top:10px;">
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <asp:ImageButton OnClick="btnPostPrint_Click1" ImageUrl="~/images/UserLibrary/postrequest.gif"
                                                            CausesValidation="false" ID="btnPostPrint" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <table  cellpadding=0 cellspacing=0 border=0>
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <div align="center" id="divBannerPrint" class="MessageText" runat="server">
                                                            <asp:Label ForeColor="DarkGreen" ID="lblmsgPrint"
                                                                runat="server"></asp:Label>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>--%>
                        <asp:UpdatePanel ID="pnlEmail" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 620px; height: 220px;" class="wndContent Sbar">
                                    <tr>
                                        <td style="width: 700px;" valign="top">
                                            <table>
                                                <tr>
                                                    <td style="width: 56px">
                                                        <asp:Label ID="Label1" runat="server" Text="Email To" Width="46px"></asp:Label></td>
                                                    <td style="width: 137px">
                                                        <asp:TextBox ID="txtEmailTo" runat="server" Width="373px" CssClass="FormControls"></asp:TextBox><asp:RequiredFieldValidator
                                                            ID="RequiredFieldValidator1" runat="server" ControlToValidate=txtEmailTo SetFocusOnError="true" ErrorMessage="&nbsp;*"></asp:RequiredFieldValidator></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 56px">
                                                        <asp:Label ID="Label3" runat="server" Text="Subject"></asp:Label></td>
                                                    <td style="width: 137px">
                                                        <asp:TextBox ID="txtSubject" runat="server" Width="372px" CssClass="FormControls"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 56px">
                                                        <asp:Label ID="Label4" runat="server" Text="Comments"></asp:Label></td>
                                                    <td style="width: 137px">
                                                        <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" Width="372px" Height="100px"
                                                            CssClass="FormControls"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <asp:ImageButton ImageUrl="~/Common/Images/postrequest.gif" ID="btnPostEmail" CausesValidation="true"
                                                            runat="server" OnClick="btnPostEmail_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <div align="center" id="divBannerEmail" class="MessageText" runat="server">
                                                            <asp:Label ForeColor="DarkGreen" ID="lblmsgEmail"
                                                                runat="server" Text=""></asp:Label>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <%--<asp:UpdatePanel ID="pnlFax" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 620px; height: 220px;" class="wndContent Sbar">
                                    <tr>
                                        <td style="width: 700px;" valign="top">
                                            <table>
                                                <tr>
                                                    <td style="width: 100px; height: 27px;">
                                                        <asp:Label ID="Label6" runat="server" Text="Customer Fax No" Width="100px"></asp:Label></td>
                                                    <td style="width: 328px; height: 27px;">
                                                        <asp:TextBox ID="txtCustomerFaxNo" runat="server" Width="328px" CssClass="FormControls"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <asp:ImageButton ID="btnPostFax" ImageUrl="~/images/UserLibrary/postrequest.gif" runat="server"
                                                            CausesValidation="false" OnClick="btnPostFax_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <div align="center" id="divBanner" class="MessageText" runat="server">
                                                            <asp:Label ForeColor="DarkGreen" ID="lblmsg" runat="server"
                                                                Text=""></asp:Label>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>--%>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>    
</body>
</html>
