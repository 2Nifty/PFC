<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BodyFrame.aspx.cs" Inherits="PFC.Intranet.BodyFrame" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">
    <script  type="text/javascript" >
     function formatGrid()
{
    if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1))
    {}
    else
    {
        var strForm=document.form1.innerHTML;
        document.form1.innerHTML=strForm.replace(/rules\=\"all\"/g,'');
    }
}
     function OpenWin(url)
      {
      
         var hwin=window.open(url,'NewWindow','height=700,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (850/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
         hwin.focus();
      }
    </script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" scroll="yes">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top">
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                    </td>
            </tr>
            <tr>
                <td valign="middle" class="PageHead">
                    <span class="Left5pxPadd">
                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text=""></asp:Label></span>
                </td>
            </tr>
            <tr>
                <td valign="top" class="LoginFormBk" height="300">
                    <div class="Left5pxPadd">
                        <asp:DataGrid ID="dgDisplay" runat="server" AutoGenerateColumns="False" OnItemDataBound="dgDisplay_ItemDataBound"
                        BorderWidth="0">
                            <ItemStyle CssClass="BodyFrameblackTxt" Width="250"></ItemStyle>
                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <Columns>
                                <asp:TemplateColumn>
                                    <ItemTemplate>
                                        <img src="../Common/Images/Bullet.gif" hspace="5" />
                                        <asp:HyperLink  CssClass="BodyFrameblackTxt" ID="HyperLink1" NavigateUrl='<%# GetURL(Container)%>' Text='<%#DataBinder.Eval(Container, "DataItem.Name")%>'
                                            runat="server" Target="_self"></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                 <asp:BoundColumn DataField ="ReqDashBoard"  Visible=false > </asp:BoundColumn>
                                <asp:BoundColumn DataField ="ClientExtAppsURL" Visible=false > </asp:BoundColumn>
                           
                            </Columns>
                        </asp:DataGrid></div>
                </td>
            </tr>
        </table>
    </form>
</body>
<script>formatGrid();</script>
</html>
