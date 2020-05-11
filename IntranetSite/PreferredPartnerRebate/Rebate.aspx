<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Rebate.aspx.cs" Inherits="Rebate" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Rebate</title>
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <script>
     function GetCustName()
    {
    var name=document.getElementById("ddlChainCust").value;
    
    document.getElementById("lblCustName").innerText =name;
    }
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px; width: 1253px;">
                    <uc1:Header ID="Header1" runat="server"></uc1:Header>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;">
                    <asp:Panel ID="Panel1" runat="server">
                        <table style="width: 100%" class="blueBorder lightBlueBg" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <table width="175">
                                                <tr>
                                                    <td class="Left2pxPadd " style="padding-left: 30px" colspan="3">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px">
                                                        <asp:Label ID="lblProgramName" runat="server" Height="16px" Text="Program Name" Width="150px"></asp:Label>
                                                    </td>
                                                    <td style="width: 300px; height: 30px" colspan="2">
                                                        <asp:DropDownList ID="ddlProgram" Width="200px" CssClass="FormCtrls" runat="server"
                                                            AutoPostBack="true" OnSelectedIndexChanged="ddlProgram_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="rfvProgram" runat="server" ControlToValidate="ddlProgram"
                                                            Display="Dynamic" ErrorMessage=" *Required"></asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                        <asp:RadioButtonList ID="rdoCustChain" runat="server" RepeatDirection="Horizontal"
                                                            AutoPostBack="true" OnSelectedIndexChanged="rdoCustChain_SelectedIndexChanged">
                                                            <asp:ListItem Value="Chain" Selected="True">Chain#</asp:ListItem>
                                                            <asp:ListItem Value="Cust">Cust#</asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                    <td style="width: 100px; height: 30px">
                                                        <asp:DropDownList ID="ddlChainCust" Width="200px" CssClass="FormCtrls" runat="server"
                                                            AutoPostBack="true" onchange="javascript:GetCustName();" OnSelectedIndexChanged="ddlChainCust_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="rfvChainCust" runat="server" ControlToValidate="ddlChainCust"
                                                            ErrorMessage=" *Required " Display="Dynamic"></asp:RequiredFieldValidator>
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                        <asp:Label ID="lblCustName" runat="server" Height="16px" Width="150px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                        <asp:Label ID="Label4" runat="server" Height="16px" Text="Start Date" Width="111px"></asp:Label></td>
                                                    <td style="width: 150px" colspan="2">
                                                        <uc3:novapopupdatepicker ID="dtpStartDate" runat="server" />
                                                    </td>
                                                </tr>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;" valign="top">
                                                        <asp:Label ID="Label5" runat="server" Height="16px" Text="End Date" Width="111px"></asp:Label></td>
                                                    <td style="width: 150px" colspan="2">
                                                        <uc3:novapopupdatepicker ID="dtpEndDate" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
