<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ActivePromos.aspx.cs" Inherits="SelectContacts" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Available Promotions</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">
    function Pass(val,mode)
    {
    
        if(mode.toLowerCase()=="Email".toLowerCase())
        {
            
            window.opener.form1.document.getElementById('txtEmailTo').value= val;
           
        }
        else
        {
            window.opener.form1.document.getElementById('txtCustomerFaxNo').value=val;
        }
        self.close();
        window.opener.focus();
        
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" class="HeaderPanels" cellpadding="0" cellspacing="0">
            <tr>
                <td style="height: 25px" align="center">
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="Medium">Promotions</asp:Label>
                </td>
            </tr>
            <tr>
                <td style="height: 220px;">
                    <asp:UpdatePanel ID="upnlContactsGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: hidden;
                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 237px; border: 1px solid #88D2E9;
                                width: 470px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <asp:GridView UseAccessibleHeader="true" ID="gvPromos" PagerSettings-Visible="false"
                                                Width="475px" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                                AutoGenerateColumns="false" ShowFooter="False">
                                                <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9"
                                                    Height="20px" />
                                                <FooterStyle Font-Bold="True" VerticalAlign="Top" HorizontalAlign="Right" />
                                                <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="20px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Promotion">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblPromoDesc" Style="padding-left: 5px;" Width="200px" runat="server"
                                                                Text='<%#DataBinder.Eval(Container,"DataItem.PromotionDesc") %>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle Width="150px" />
                                                        <ItemStyle HorizontalAlign="Left" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Promotion Disc %">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblPromoDescPct" CssClass="PaddingRight2PX" Width="30px" runat="server"
                                                                Text='<%#DataBinder.Eval(Container,"DataItem.DiscountPercent") + "%" %>' />
                                                        </ItemTemplate>
                                                        <HeaderStyle Width="60px" />
                                                        <ItemStyle HorizontalAlign="Right" CssClass="PaddingRight2PX" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Promotion End Date">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblPromoEndDt" CssClass="PaddingRight2PX" Text='<%# DataBinder.Eval(Container,"DataItem.PromotionEndDt") %>'
                                                                runat="server" />
                                                        </ItemTemplate>
                                                        <HeaderStyle Width="70px" />
                                                        <ItemStyle HorizontalAlign="Right" CssClass="PaddingRight2PX" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Promo Avail. Apps">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblOrderSource" Style="padding-left: 5px;" Text='<%# DataBinder.Eval(Container,"DataItem.OrderSource") %>'
                                                                runat="server" />
                                                        </ItemTemplate>
                                                        <HeaderStyle Width="70px" />
                                                        <ItemStyle HorizontalAlign="Left" CssClass="PaddingRight2PX" />
                                                    </asp:TemplateField>
                                                </Columns>
                                                <PagerSettings Visible="False" />
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align=center>
                                            <asp:Label ID="lblMessage" runat="server" Text="No promotions available!" Visible="false" ForeColor=red
                                                Font-Bold="True" Style="padding-top: 20px; padding-bottom: 20px;" Font-Size="Medium"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" style="width: 630px" width="45%">
                    <table width="100%">
                        <tr>
                            <td width="40%" align="left">
                                &nbsp;
                            </td>
                            <td align="right" width="40%">
                                <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
