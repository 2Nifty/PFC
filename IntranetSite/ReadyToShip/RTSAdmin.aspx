<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RTSAdmin.aspx.cs" Inherits="RTSAdmin" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>RTS Admin Menu</title>
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
                                <td class="BannerText">
                                    <div class="Left5pxPadd">
                                        Goods En Route Ready to Ship - Administration Page
                                    </div>
                                </td>
                                <td align="right">
                                    <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg"
                                        PostBackUrl="RTSMenu.aspx" CausesValidation="false" />
                                    &nbsp; &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="Left5pxPadd">
                                    <br />
                                    <span style="font-size: large; color: Blue">Prepare New Week</span><br />
                                    <b>Press the OK button below to confirm that you intend to prepare the Ready To<br />
                                        Ship process for the new week. This process will delete all the data from last week.</b><br />
                                    &nbsp; &nbsp;
                                </td>
                            </tr>
                            <tr class="PageBg">
                                <td align="left" colspan="2" valign="middle">
                                    <asp:ImageButton ID="OKButton" runat="server" CssClass="Left5pxPadd" ImageUrl="../Common/Images/ok.gif"
                                        OnClick="NewWeekButton_Click" />
                                    Click OK - Clears tables and begins new week Ready to Ship proceesing.</td>
                            </tr>
                            <tr>
                                <td colspan="2" class="Left5pxPadd">
                                    <br />
                                    <span style="font-size: large; color: Blue">Re-run Recommended Ready to Ship Calculations</span><br />
                                    <b>Press the OK button below to recalculate the recommended Ready To Ship quantities.<br />
                                        This process will destroy the previous calculations and all actions.</b><br />
                                    &nbsp; &nbsp;
                                </td>
                            </tr>
                            <tr class="PageBg">
                                <td align="left" colspan="2" valign="middle">
                                    <table>
                                        <td class="Left5pxPadd">
                                            <b>Include Summary Quantities - HTI:</b>
                                        </td>
                                        <td align="left">
                                            <b>
                                                <asp:CheckBox ID="IncludeSummQtys" runat="server" />
                                            </b>
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="ImageButton1" runat="server" CssClass="Left5pxPadd" ImageUrl="../Common/Images/ok.gif"
                                                OnClick="RecalcButton_Click" />
                                            Click OK - - Recalculates the recommended quantities and updates them in the tables
                                        </td>
                                    </table>
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
                        <asp:AsyncPostBackTrigger ControlID="ImageButton1" />
                    </Triggers>
                </asp:UpdatePanel>
                <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                    <ProgressTemplate>
                        <br />
                        Recalculating Recommended quantities. One moment.....
                        <asp:Image ID="GreenLaser" runat="server" ImageUrl="Common/Images/BURSTANI.GIF" />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </div>
    </form>
</body>
</html>
