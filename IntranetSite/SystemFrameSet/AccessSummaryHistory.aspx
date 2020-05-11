<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AccessSummaryHistory.aspx.cs" Inherits="PFC.Intranet.UserFavourite" %>

<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Dashboard</title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
</head>

<script language="javascript">
    function RefreshPage()
    {   
     window.opener.location.href="Dashboard.aspx";    
    }
</script>

<body>
    <form id="form1" runat="server" >
        <table width="50%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td width="100%" colspan="2" style="height: 75px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
                        <tr>
                            <td width="62%" valign="middle">
                                <img src="../Common/Images/Logo.gif" width="453" height="50" hspace="25" vspace="10"></td>
                            <td width="38%" valign="bottom" class="10pxPadding">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr runat="server">
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr class="PageHeadsmall">
                            <td>
                                &nbsp;&nbsp;Access Summary History</td>
                                <td align="right">
                                <img src="../common/images/close.gif" id="img1" onclick="javascript:window.close();" />
                                </td>
                        </tr>
                        <tr height="1">
                        </tr>
                        <tr width="100%">
                            <td height=350 valign=top colspan="2">
                                <table align="left" width="100%" border="0" cellspacing="4" cellpadding="5">
                                    <tr>
                                        <td class="login">
                                            <asp:DataGrid ID="dgAccessHistory" AutoGenerateColumns="false" AllowPaging="true" runat="server" BorderWidth=1 GridLines=Both
                                                Width="100%" PageSize="18" OnPageIndexChanged="dgAccessHistory_PageIndexChanged">
                                                <AlternatingItemStyle CssClass="GridItem" BackColor="White"></AlternatingItemStyle>
                                                <ItemStyle CssClass="GridItem" BackColor="#F4FBFD"></ItemStyle>
                                                <HeaderStyle CssClass="GridItem" BackColor="#DFF3F9" Font-Bold="True"></HeaderStyle>
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Module Name">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.ModuleName")%>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle Font-Bold="True" />
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Start Time">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.StartTime")%>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle Font-Bold="True" />
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="IP Address">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.HostIP")%>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle Font-Bold="True" />
                                                    </asp:TemplateColumn>
                                                   
                                                </Columns>
                                                <PagerStyle NextPageText="Next" PrevPageText="Previous"  BackColor="#DFF3F9" HorizontalAlign="Right" CssClass="GridPager">
                                                </PagerStyle>
                                            </asp:DataGrid>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr bgcolor="#DFF3F9">
                <td width="72%" height="25" class="foottxt1">
                   <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="23%" height="25" class="foottxt1"><a href="http://www.porteousfastener.com/" style="color:#1c7893" target=_blank>&nbsp;&nbsp;Copyright 2006 @ Porteous Fastener Co.,</a> </td>
                            <td width="13%" align=right ><a href="http://www.novantus.com" target="_blank"><img src="../Common/Images/umbrellaPower.gif" border="0Px" /></a></td>
                      </tr>
                    </table>
                   
                   </td>
            </tr>
        </table>
    </form>
</body>
</html>
