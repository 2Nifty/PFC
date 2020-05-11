<%@ Page Language="C#" AutoEventWireup="true" Debug="true" CodeFile="PalletPartnerUpload.aspx.cs" Inherits="PalletPartnerUpload" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Upload Pallet Partner Excel File</title>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script language="javascript" src="../Common/javascript/ContextMenu.js"></script>

    <script language="javascript" src="../Common/javascript/browsercompatibility.js"></script>

    <script>

    function LoadHelp()
    {
        window.open('Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }

    </script>
</head>
<body bottommargin="0">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="5" height="97" valign="top" class="BannerBg">
                                <div class="bannerImg">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="PageHead" width="100%" height="100%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td valign="middle" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Upload Pallet Partner Excel File
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr class="PageBg" height="30px">
                                        <td align="left" valign="middle" class="TabHead">
                                            &nbsp;&nbsp;Select Excel file to upload:
                                            <asp:FileUpLoad id="SingleFileName" Width="500" runat="server" />
                                        </td>
                                        <td align="right" valign="middle" class="TabHead">
                                            <asp:ImageButton ID="btnFileSel" Visible="true" runat="server" ImageUrl="../Common/images/ok.gif" OnClick="btnFileSel_Click" />
                                            &nbsp;
<%--                                                <asp:ImageButton ID="btnClose" Visible="true" runat="server" ImageURL="../Common/images/close.gif" />--%>
                                            <img id="btnClose" src="../Common/images/close.gif" style="cursor: hand" runat="server" />
                                            <img src="../Common/images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr class="Left5pxPadd"><td class="readtxt"><asp:Label ID="lblFileMessage" runat="server" /></td></tr>
                                    <tr class="Left5pxPadd"><td class="readtxt"><asp:Label ID="lblUpdateMessage" runat="server" /></td></tr>
                                    <tr class="Left5pxPadd">
                                        <td valign="top" width="100%" style="height: 314px">
                                            <div class="Sbar" id="div-datagrid" style="overflow: auto; position: relative; top: 0px;
                                                left: 0px; width: 1000px; height: 400px; border: 0px solid;">
                                                <asp:GridView ID="GridView1" runat="server" BorderColor="Black" BorderStyle="Solid">
                                                <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                                </asp:GridView>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <table width="100%" cellpadding="0" cellspacing="0" class="Left5pxPadd">
                                    <tr class="PageBg">
                                        <td valign="middle" class="TabHead">
<%--                                            <asp:Label ID="lblFilter" runat="server" Text="Record Filter" Visible="false" />
                                            <asp:RadioButton ID="btnFilterAll" runat="server" GroupName="btnFilter" Visible="false"
                                                Text="All" OnCheckedChanged="FilterSet" AutoPostBack="true" />
                                            <asp:RadioButton ID="btnFilterGood" runat="server" GroupName="btnFilter" Visible="false"
                                                Text="Good" OnCheckedChanged="FilterSet" AutoPostBack="true" />
                                            <asp:RadioButton ID="btnFilterBad" runat="server" GroupName="btnFilter" Visible="false"
                                                Text="Bad" OnCheckedChanged="FilterSet" AutoPostBack="true" />--%>
                                        </td>
                                        <td align="right" valign="middle" class="TabHead">
                                            <asp:ImageButton ID="btnAccept" runat="server" ImageUrl="../Common/images/accept.jpg" Visible="false" OnClick="btnAccept_Click" />
                                        </td>
                                        <td></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
