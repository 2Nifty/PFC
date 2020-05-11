<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReceiveReportPrompt.aspx.cs"
    Inherits="WarehouseMgmt_ReceiveReportPrompt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Receiving Report Prompt</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function OpenReport(location,LocName,ContainerNo,BOLNo,DocumentNo)
    {
        var Url =  "ReceiveReport.aspx?Location="+ location +"&LocName=" + LocName+"&ContainerNo="+ContainerNo+"&BOLNo="+BOLNo+"&DocumentNo="+DocumentNo ;  
       
        window.open(Url,"ReceiveReport" ,'height=650,width=958,scrollbars=yes,status=no,top='+((screen.height/2) - (625/2))+',left='+((screen.width/2) - (1038/2))+',resizable=No',"");
        window.close();
    }
    </script>

</head>
<body>
    <form id="form1" runat="server" defaultbutton="btnPrompt" defaultfocus="txtLPNNo">
        <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%;
            height: 200">
            <tr>
                <td class="PageHead" style="padding: 5px;">
                    <table border="0" cellpadding="3" cellspacing="0" width="100%">
                        <tr>
                            <td align="left" class="Left5pxPadd BannerText">
                                Receiving Report
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top; padding-bottom: 5px; padding-top: 5px; padding-left: 10px;
                    background-color: White;">
                    <table cellpadding="0" cellspacing="0">
                        <tr height="28px">
                            <td>
                                <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Receipt Branch " Width="150px"></asp:Label>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlLocation" runat="server" Width="157px" CssClass="FormCtrl">
                                </asp:DropDownList>                                
                        <tr height="28px">
                            <td>
                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Container Number "
                                    Width="150px"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtContainerNo" runat="server" CssClass="FormCtrl" Width="150px" MaxLength="30"></asp:TextBox>                                
                            </td>
                        </tr>
                        <tr height="28px">
                            <td>
                                <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Bill of Number "
                                    Width="150px"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtBOLNo" runat="server" CssClass="FormCtrl" Width="150px" MaxLength="20"></asp:TextBox>
                                
                            </td>
                        </tr>
                        <tr height="28px">
                            <td>
                                <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Document Number "
                                    Width="150px"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtDocumentNo" runat="server" CssClass="FormCtrl" Width="150px" MaxLength="30"></asp:TextBox>
                            </td>
                            <tr height="20px">     </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 10px" class="BluBg buttonBar Left5pxPadd" height="28px">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="padding-left: 5px; padding-right: 3px" valign="top">
                                <img align="right" src="Common/Images/help.gif" style="cursor: hand;" />
                            </td>
                            <td style="padding-left: 5px;" valign="top">
                            <asp:ImageButton ImageUrl="~/WarehouseMgmt/Common/Images/btnClear.gif" runat="server" ID="btnClear" OnClick="btnClear_Click"/>
                            </td>
                            <td width="40%"></td>
                            <td style="padding-right: 5px;" valign="top" align="right">
                                <asp:ImageButton ImageUrl="~/WarehouseMgmt/Common/Images/ok.gif" runat="server" ID="btnPrompt"
                                    OnClick="btnPrompt_Click" CausesValidation="true" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
