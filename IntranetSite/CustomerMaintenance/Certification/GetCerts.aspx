<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetCerts.aspx.cs" Inherits="GetCerts" %>

<%@ Register Src="~/MaintenanceApps/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/MaintenanceApps/Common/UserControls/Footer.ascx" TagName="Footer"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Certification </title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />

    <script>
        function GetEnlargeImage()
        {
        var hwin;
        hwin=window.open("CertificateView.aspx","GetEnlargeImage",'height=550,width=700,toolbar=0,scrollbars=yes,status=0,resizable=YES,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (550/2))+'','');
        hwin.focus();
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td class="Left2pxPadd DarkBluTxt " width="40%" style="padding-left: 10px; height: 350px;"
                                valign="top">
                                <asp:UpdatePanel ID="upnlCerts" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:Panel ID="pnlSearch" runat="server">
                                            <table cellpadding="2" cellspacing="0" width="100%">
                                                <tr>
                                                    <td style="width: 15px; height: 15px" colspan="2">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblSch" runat="server" Text="Item Number" Width="100px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtItemNumber" CssClass="FormCtrl" runat="server" AutoCompleteType="disabled"
                                                            MaxLength="14" Width="150px"></asp:TextBox></td>
                                                    <td>
                                                        <asp:RequiredFieldValidator ID="rfvItemNumber" runat="server" ControlToValidate="txtItemNumber"
                                                            Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator>
                                                    </td>
                                                    <td>
                                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                                            <ProgressTemplate>
                                                                <asp:Label ID="progress" runat="server" Text="Loading..." Width="80px"></asp:Label>
                                                            </ProgressTemplate>
                                                        </asp:UpdateProgress>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label1" runat="server" Text="Lot Number" Width="80px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtLotNo" runat="server" AutoCompleteType="disabled" CssClass="FormCtrl"
                                                            MaxLength="14" Width="150px"></asp:TextBox></td>
                                                    <td>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtItemNumber"
                                                            Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator></td>
                                                    <td>
                                                        <asp:Button ID="btnGetCert" runat="server" Text="Get Certs" OnClick="btnGetCert_Click" /></td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                  </ContentTemplate>
                                  </asp:UpdatePanel>
                                </td>
                                <td class="redTxt" style="font-weight: bold;" visible="false" id="tdAssist" runat="server" valign="top" >
                                    <table cellpadding="2" cellspacing="0" width="100%" >
                                        <tr>
                                            <td style="width: 15px; height: 15px">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15px; height: 15px">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="redTxt" style="font-weight: bold;">
                                                very Sorry.We were unable to find a matching certification.Please
                                                <br />
                                                check the your information and try your search again or click the<br />
                                                "Certs Assistance" button Below.
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 15px; height: 15px">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="redhead" style="height: 18px">
                                                <asp:Button ID="btnCerts" runat="server" Text="Certs Assistance" OnClick="btnGetCert_Click" />
                                                  </td>
                                        </tr>
                                        <tr>
                                            <td class="redTxt" style="font-weight: bold;">
                                                The "Certs assistance" button will send an email to PFC with your<br />
                                                information using your e-mail address.
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                </tr>
                                </table>
                                </td>
                                 </tr>
                   
               
                            <tr>
                                <td style="height: 500px" visible="false">
                                    <asp:HyperLink ID="hplEnlarge" Target="_blank" runat="server">
                                        <asp:Image ID="imgCerts" Width="500px" Visible="false" Height="500px" runat="server"
                                            Style="cursor: hand;" />
                                    </asp:HyperLink>
                                </td>
                            </tr>
                        <tr>
                        </tr>
                        <tr>
                            <td style="width: 1253px">
                                <uc2:Footer ID="BottomFrame2" Title="Certificate Page" runat="server" />
                            </td>
                        </tr>
                    </table>
    </form>
</body>
</html>
