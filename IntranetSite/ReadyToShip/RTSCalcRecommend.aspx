<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RTSCalcRecommend.aspx.cs"
    Inherits="RTSCalcRecommend" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>RTS Calculate Recommended</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="6000">
        </asp:ScriptManager>
        <div id="Container">
            <uc1:Header ID="Header1" runat="server" />
            <div id="Content">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table width="100%" cellspacing="0">
                            <tr class="PageHead">
                                <td class="BannerText" colspan="2">
                                    <div class="Left5pxPadd">
                                        Run Recommended Ready to Ship Calculations
                                    </div>
                                </td>
                            </tr>
                            <tr class="PageBg">
                                <td align="left">
                                    <table>
                                        <td class="Left5pxPadd">
                                            <b><asp:Label ID="IncludeLabel" runat="server" Text="Include Summary Quantities - HTI:"></asp:Label></b>
                                        </td>
                                        <td align="left">
                                            <b>
                                                <asp:CheckBox ID="IncludeSummQtys" runat="server" />
                                            </b>
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="OKButton" runat="server" CssClass="Left5pxPadd" ImageUrl="../Common/Images/ok.gif"
                                                OnClick="OKButton_Click" />
                                        </td>
                                    </table>
                                </td>
                                <td align="right">
                                    <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg"
                                        PostBackUrl="RTSMenu.aspx" CausesValidation="false" />
                                    &nbsp; &nbsp;
                                </td>
                            </tr>
                            <tr class="PageBg">
                                <td colspan="2">
                                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                                    &nbsp; &nbsp;
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="OKButton" />
                    </Triggers>
                </asp:UpdatePanel>
                <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                    <ProgressTemplate>
                        <br />
                        &nbsp;&nbsp; Recalculating Recommended quantities. One moment.....
                        <asp:Image ID="GreenLaser" runat="server" ImageUrl="Common/Images/BURSTANI.GIF" />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </div>
    </form>
</body>
</html>
