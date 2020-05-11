<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PurchaseImportXmlExport.aspx.cs" Inherits="PurchaseImportXmlExport" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer2" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script>
        var PurchImpReceiptWindow;
        function pageUnload() 
        {
            if (PurchImpReceiptWindow != null) {PurchImpReceiptWindow.close();PurchImpReceiptWindow=null;}
        }
        function ClosePage()
        {
            window.close();	
        }

        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            // size the grid
            var DetailGridPanel = $get("DetailGridPanel");
            if (DetailGridPanel != null)
            {
                DetailGridPanel.style.height = yh - 132;  
                //DetailGridPanel.style.width = xw - 5;  Visible="false"
            }
        }
    </script>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <title>Purchase Import XML Export</title>
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="PIXmlScriptManager" runat="server" EnablePartialRendering="true" />
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel1" runat="server">
                <ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                        <tr>
                            <td colspan="2">
                                <uc1:Header ID="Pageheader" runat="server"></uc1:Header>
                                <asp:HiddenField ID="LocFilter" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="PageHead" style="height: 40px">
                                <div class="LeftPadding">
                                    <div align="left" class="BannerText">
                                        Purchase Import XML Export</div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="height: 50px; padding-left: 10px;">
                                <asp:UpdatePanel ID="DataUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table cellspacing="2" cellpadding="1" border="0">
                                            <tr>
                                                <td style="width: 160px; padding-left: 10px;">
                                                    <b>Puchase Order to Process</b>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtPONo" runat="server" Width="100px"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:ImageButton ID="btnSubmit" OnClick="Submit_Click" AlternateText="Create an XML file for the PO"
                                                        runat="server" ImageUrl="../Common/Images/submit.gif" CausesValidation="false" />
                                                    <asp:HiddenField ID="hidXMLFilePath" runat="server" />
                                                    <asp:HiddenField ID="hidXMLName" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="DataUpdatePanel">
                                                        <ProgressTemplate>
                                                            <div align="left" class="BannerText">
                                                                Processing.......</div>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblProcessed" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:ImageButton ID="btnConfirm" OnClick="Confirm_Click" AlternateText="Confirm that you want to process this PO."
                                                        runat="server" ImageUrl="../Common/Images/ok.gif" CausesValidation="false" />
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="height: 170px; padding-left: 10px;">
                                <asp:UpdatePanel ID="FTPUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table cellspacing="2" cellpadding="1" border="0">
                                            <tr>
                                                <td colspan="3" class="BannerText" style="padding-left: 10px;">
                                                    <b>FTP Process Configuration</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 160px; padding-left: 10px;">
                                                    <b>FTP Site Address (URL)</b>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtFTPSite" runat="server" Width="200px"></asp:TextBox>
                                                </td>
                                                <td>
                                                    E.G. ftp://xxx.xxxxx.com
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 160px; padding-left: 10px;">
                                                    <b>User Name</b>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtFTPUser" runat="server" Width="100px"></asp:TextBox>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 160px; padding-left: 10px;">
                                                    <b>Password</b>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtFTPPassword" runat="server" Width="100px"></asp:TextBox>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:ImageButton ID="bntFTP" OnClick="FTP_Click" AlternateText="Send the XML file to an FTP Site"
                                                        runat="server" ImageUrl="../Common/Images/submit.gif" CausesValidation="false" />
                                                </td>
                                                <td>
                                                    <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="FTPUpdatePanel">
                                                        <ProgressTemplate>
                                                            <div align="left" class="BannerText">
                                                                FTP File Upload in Process.......</div>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="height: 350px; padding-left: 10px;">
                                <asp:Panel ID="FilePanel" runat="server" ScrollBars="vertical" Height="330px">
                                    <asp:UpdatePanel ID="FileUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table width="100%">
                                                <tr>
                                                    <td align="left">
                                                        <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="BluBg">
                                <asp:Panel ID="BottomPanel" runat="server">
                                    <table width="100%">
                                        <tr>
                                            <td align="left">
                                                &nbsp;&nbsp;&nbsp;
                                                <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                                                    <ContentTemplate>
                                                        <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                                        <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="right">
                                                <asp:ImageButton ID="GridCloseButton" ImageUrl="../Common/Images/close.gif" runat="server"
                                                    OnClientClick="ClosePage();" /></td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <uc2:Footer2 ID="PageFooter2" runat="server"></uc2:Footer2>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
