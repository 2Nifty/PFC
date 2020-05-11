<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PackSlipRequest.aspx.cs"
    Inherits="PFC.Intranet.PackSlipPrompt" %>

<%@ Register Src="~/Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Post Packslips</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="Javascript">
      <!--
    function isNumberKey(evt)
    {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;

        return true;
    }
      
    function UpdateDefaultPrinter()
    {
        var NwPrinter = document.getElementById("ddlPrinterName").options[document.getElementById("ddlPrinterName").options.selectedIndex].value;
        PackSlipPrompt.UpdateUserDefaultPrinter(NwPrinter);
        document.getElementById("txtOrderNo").focus();
    }
    //-->
    </script>

</head>
<body scroll="auto">
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="scmPostBack">
        </asp:ScriptManager>
        <table width="100%">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="top">
                                <uc1:PageHeader ID="PageHeader1" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="height: 100%;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Print Post Pick Packslip
                                                </div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    &nbsp;</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:UpdatePanel ID="pnlEntry" runat="server">
                                                            <contenttemplate>
                                                                <table border="0" cellpadding="5" cellspacing="0" style="width: 200px;">
                                                                    <tr>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Printer Name:" Width="85px"></asp:Label></td>
                                                                        <td colspan="3">
                                                                            <asp:DropDownList ID="ddlPrinterName" runat="server" CssClass="FormCtrl" Width="170px" onchange = "UpdateDefaultPrinter()">
                                                                            </asp:DropDownList></td>
                                                                        <td colspan="1">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="Label2" runat="server" Text="Order Number:" Font-Bold="True" Width="85px"></asp:Label></td>
                                                                        <td colspan="3">
                                                                            <asp:TextBox ID="txtOrderNo" runat="server" CssClass="FormCtrl" Height="15px" Width="165px"
                                                                                onkeypress="return isNumberKey(event);" 
                                                                                onkeydown="javascript: if(event.keyCode==9 || event.keyCode==13 ){event.keyCode=9; return event.keyCode}"
                                                                                onblur="javascript:if(this.value!=''){document.getElementById('btnPostPckSlip').click();}"></asp:TextBox></td>
                                                                        <td colspan="1">
                                                                            <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                                                                <ProgressTemplate>
                                                                                    <strong>Loading...</strong>
                                                                                </ProgressTemplate>
                                                                            </asp:UpdateProgress>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 100px">
                                                                            </td>
                                                                        <td colspan="4">
                                                                            <asp:CheckBox ID="chkCertsRequired" runat="server" Checked="True" Font-Bold="False"
                                                                            Text="Include Certs Attachment" Width="168px" /></td>
                                                                             <%-- OLD Code CSR 03/22/12 <asp:CheckBox ID="chkCertsRequired" runat="server" Checked="False" Font-Bold="True"  --%> 
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 100px">
                                                                        </td>
                                                                        <td colspan="3">
                                                                            <asp:Button ID="btnPostPckSlip" runat="server" CssClass="FormCtrl" Style="display: none;"
                                                                                OnClick="btnPostPckSlip_Click" /></td>
                                                                        <td colspan="1">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </contenttemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 100%; padding-left: 10px; padding-bottom: 5px; padding-top: 5px;"
                                valign="top">
                                <asp:UpdatePanel runat="server" ID="pnlStatus" UpdateMode="Conditional">
                                    <contenttemplate>
                                        <asp:Label ID="lblError" runat="server" Font-Bold="True"
                                            Width="350px" ForeColor="Red"></asp:Label>
                                    </contenttemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg" style="">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="padding-left: 80px; padding-top: 15px;">
                                        <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
                                            <contenttemplate>&nbsp;<img src="../Common/images/close.gif"
                                            onclick="javascript:history.back();" style="cursor: hand" />
                                        </contenttemplate>
                                        </asp:UpdatePanel>
                                    </span>
                                </div>
                            </td>
                            <td class="BluBg">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
