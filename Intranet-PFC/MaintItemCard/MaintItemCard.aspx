<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MaintItemCard.aspx.vb" Inherits="_MaintItemCard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>PFC Item Card Maintenance</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">

function LoadHelp()
    {
    window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="5" height="97" valign="top" class="BannerBg">
                                <div width="100%" class="bannerImg">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" valign="top" style="height: 100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    PFC Item Card Maintenance
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <tr>
                                    <td colspan="2">
                                        <table border="0" cellspacing="0" cellpadding="3" width="600">
                                            <tr>
                                                <td style="width: 68px">
                                                    <span class="LeftPadding" style="width: 100px;">Item #</span></td>
                                                <td colspan="2">
                                                    <asp:TextBox ID="txtItemNo" runat="server" MaxLength="14" Width="110px" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <div class="LeftPadding">
                        <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:ImageButton ID="btnNext" runat="server" Style="cursor: hand" ImageUrl="images/Next.gif" />&nbsp;
                            <img src="Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                        </span>
                    </div>
                </td>
            </tr>
            <% If IsPostBack Then%>
            <tr>
                <td colspan="2">
                    <br />
                    <asp:Label ID="lblItemNo" runat="server" Font-Bold="True" Font-Size="Medium" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <b><i>Base UOM: </i></b>
                    <asp:Label ID="lblBaseUOM" runat="server" Font-Bold="True" Font-Size="Larger" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b><i>Plating: </i></b>
                    <asp:Label ID="lblPlate" runat="server" Font-Bold="True" Font-Size="Larger" /><br />
                    <asp:Label ID="lblItemDesc" runat="server" Font-Bold="True" Font-Size="X-Large" /><br />
                    <% If lblItemDesc.Text <> "Item Not On File" Then%>
                    <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0"
                        style="height: 135px">
                        <tr>
                            <td valign="top" width="100%" style="height: 135px">
                                <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                    left: 0px; width: 1000px; height: 135px; border: 0px solid;">
                                    <table width="35%" border="0" cellspacing="1">
                                        <col width="30%" />
                                        <col width="20%" />
                                        <col width="10%" />
                                        <tr>
                                            <td>
                                                <br />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="right">
                                                <b>Current Values</b></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp&nbsp&nbsp Corp Fixed Velocity Code</td>
                                            <td>
                                                <asp:TextBox ID="iCorpCode" runat="server" MaxLength="1" Width="35px" /></td>
                                            <td align="right">
                                                <asp:Label ID="sCorpCode" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp&nbsp&nbsp Pallet Partner Flag</td>
                                            <td>
                                                <asp:DropDownList ID="iPPFlagDD" runat="server" Width="57px" >
                                                    <asp:ListItem Value="0">False</asp:ListItem>
                                                    <asp:ListItem Value="1">True</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td align="right">
                                                <asp:Label ID="sPPFlag" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp&nbsp&nbsp Web Enabled Flag</td>
                                            <td>
                                                <asp:DropDownList ID="iWebFlagDD" runat="server" Width="57px" >
                                                    <asp:ListItem Value="0">False</asp:ListItem>
                                                    <asp:ListItem Value="1">True</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td align="right">
                                                <asp:Label ID="sWebFlag" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:ImageButton ID="btnUpdate" onkeydown="if (event.keyCode==9) {document.getElementById('txtItemNo').focus()}" runat="server" Style="cursor: hand" ImageUrl="images/Update.gif" />
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <% End If%>
            <% End If%>
        </table>
    </form>
</body>
</html>
