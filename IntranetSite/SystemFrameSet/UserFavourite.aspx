<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserFavourite.aspx.cs" Inherits="PFC.Intranet.UserFavourite" %>

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

<body >
    <form id="form1" runat="server" >
        <table width="50%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2" style="height: 75px; width: 507px;">
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
            <tr id="dggShortcuts" visible="false" runat="server">
                <td colspan="2" style="width: 507px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr >
                            <td class=PageBg ><span class=TabHead>&nbsp;&nbsp;Edit Shortcuts</span>
                                </td>
                        </tr>
                        <tr height="1">
                        </tr>
                        <tr width="100%" id="tr2">
                            <td height=140 valign=top >
                                <table align="left" width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td >
                                            <asp:DataGrid ID="dgShortcuts" AutoGenerateColumns="false" AllowPaging="true" runat="server" BorderWidth=1 GridLines=Both
                                                Width="100%" PageSize="5" OnDeleteCommand="dgShortcuts_DeleteCommand" OnPageIndexChanged="dgShortcuts_PageIndexChanged"
                                                OnEditCommand="dgShortcuts_EditCommand">
                                                <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF"></AlternatingItemStyle>
                                                <ItemStyle CssClass="GridItem" BackColor="#f4fbfd"></ItemStyle>
                                                <HeaderStyle CssClass="GridItem" BackColor="#dff3f9" Font-Bold="true"></HeaderStyle>
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="ID" HeaderStyle-Font-Bold="true">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.ID")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Content" HeaderStyle-Font-Bold="true">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.Content")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="LinkButton6" runat="server" Text="Edit" Visible="true" ForeColor="#339966"
                                                                CommandName="Edit" CausesValidation="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="LinkButton5" runat="server" Text="X" Font-Bold="true" Visible="true"
                                                                ForeColor="#FF3366" CommandName="Delete" CausesValidation="false" CssClass="delete"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                                <PagerStyle NextPageText="Next" PrevPageText="Previous" BackColor="#dff3f9" HorizontalAlign="Right" CssClass="GridPager">
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
            <tr>
                <td>
                </td>
            </tr>
            <tr>
                <td colspan="2" id="tdShortcuts" runat="server" visible="false" style="width: 507px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr class="PageHeadsmall">
                            <td class=PageBg ><span class=TabHead>
                                &nbsp;&nbsp;Add Shortcuts</span>
                            </td>
                        </tr>
                       <tr width="100%">
                            <td>
                                <table width="75%" border="0" cellspacing="4" cellpadding="5">
                                    <tr>
                                        <td class="login">
                                            <div>
                                                Select Module Name</div>
                                        </td>
                                        <td>
                                            <div>
                                                <asp:DropDownList ID="ddlmoduleName" CssClass="FormControls" runat="server" Width="157px">
                                                </asp:DropDownList></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="login">
                                            <div>
                                                Shortcut Name</div>
                                        </td>
                                        <td>
                                            <div>
                                                <asp:TextBox ID="txtShortcutName" runat="server" CssClass="FormControls" Width="150px" MaxLength="30"></asp:TextBox></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="login">
                                            Shortcut Description</td>
                                        <td>
                                            <asp:TextBox ID="txtShortcutDesc" runat="server" Height="50px" TextMode="MultiLine" Width="175px" CssClass="FormControls"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td class="login">
                                            <div>
                                                &nbsp;</div>
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="ibtnshortcut" runat="server" ImageUrl="~/Common/Images/newadd.gif"
                                                OnClick="ibtnshortcut_Click" />
                                            <img src="../common/images/close.gif" id="imgClose" onclick="javascript:window.close();" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr id="dggFavourite" runat="server" visible="false">
                <td colspan="2" style="width: 507px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr class="PageHeadsmall">
                            <td class=PageBg ><span class=TabHead>
                                &nbsp;&nbsp;Edit Favourites</span></td>
                        </tr>
                        <tr height="1">
                        </tr>
                        <tr width="100%">
                            <td valign=top height=140>
                                <table align="left" width="100%" border="0">
                                    <tr>
                                        <td class="login">
                                            <asp:DataGrid ID="dgFavourites" AutoGenerateColumns="false" AllowPaging="true" runat="server"
                                                Width="100%" PageSize="5" OnDeleteCommand="dgFavourites_DeleteCommand" OnEditCommand="dgFavourites_EditCommand"
                                                OnPageIndexChanged="dgFavourites_PageIndexChanged">
                                                <AlternatingItemStyle BackColor="#FFFFFF" CssClass="GridItem" />
                                                <ItemStyle BackColor="#f4fbfd" CssClass="GridItem" />
                                                <HeaderStyle BackColor="#dff3f9" CssClass="GridItem" Font-Bold="true" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="ID" HeaderStyle-Font-Bold="true">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label3" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.ID")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Content" HeaderStyle-Font-Bold="true">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label4" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.Content")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="false" CommandName="Edit"
                                                                ForeColor="#339966" Text="Edit" Visible="true"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="LinkButton4" runat="server" CausesValidation="false" CommandName="Delete"
                                                                CssClass="delete" Font-Bold="true" ForeColor="#FF3366" Text="X" Visible="true"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                                <PagerStyle CssClass="GridPager" BackColor="#dff3f9" HorizontalAlign="Right" NextPageText="Next" PrevPageText="Previous" />
                                            </asp:DataGrid></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                </td>
            </tr>
            <tr id="tdFavourite" runat="server" visible="false">
                <td colspan="2" style="width: 507px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr class="PageHeadsmall">
                            <td class=PageBg ><span class=TabHead>
                                &nbsp;&nbsp;Add Favourites</span>
                            </td>
                        </tr>
                        <tr width="100%">
                            <td height=185 valign=top>
                                <table  width="75%" border="0" cellspacing="4" cellpadding="5">
                                    <tr>
                                        <td class="login">
                                            <div>
                                                Favourite's Name</div>
                                        </td>
                                        <td>
                                            <div>
                                                <asp:TextBox ID="txtFavorite" runat="server" CssClass="FormControls" Width="200px" MaxLength="30"></asp:TextBox></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="login">
                                            <div>
                                                Favourite URL</div>
                                        </td>
                                        <td>
                                            <div>
                                                <asp:TextBox ID="txtFavouriteURl" runat="server" CssClass="FormControls" Width="200px"></asp:TextBox></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="login">
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="ibtnfavourite" runat="server" ImageUrl="~/Common/Images/newadd.gif"
                                                OnClick="ibtnfavourite_Click" />
                                            <img src="../common/images/close.gif" id="img1" onclick="javascript:window.close();" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" id="dggDolist" visible="false" runat="server" style="width: 507px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr class="PageHeadsmall">
                            <td class=PageBg ><span class=TabHead>
                                &nbsp;&nbsp;Edit Do List</span>
                            </td>
                        </tr>
                        <tr height="1">
                        </tr>
                        <tr width="100%">
                            <td height=140 valign=top align=left>
                                <table align="left" width="100%" border="0">
                                    <tr>
                                        <td align=left>
                                            <asp:DataGrid ID="dgList" AutoGenerateColumns="false" AllowPaging="true" runat="server"
                                                Width="100%" PageSize="5" OnDeleteCommand="dgList_DeleteCommand" OnEditCommand="dgList_EditCommand"
                                                OnPageIndexChanged="dgList_PageIndexChanged" OnItemDataBound="dgList_ItemDataBound">
                                                <AlternatingItemStyle BackColor="#FFFFFF" CssClass="GridItem" />
                                                <ItemStyle BackColor="#f4fbfd" CssClass="GridItem" />
                                                <HeaderStyle BackColor="#dff3f9" CssClass="GridItem" Font-Bold="true" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="ID" HeaderStyle-Font-Bold="true" >
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label5" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.ID")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Title" HeaderStyle-Font-Bold="true">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label6" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.Content")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderText="Description" HeaderStyle-Font-Bold="true">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label7" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.Description")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn>
                                                    
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="false" CommandName="Edit"
                                                                ForeColor="#339966" Text="Edit" Visible="true"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="false" CommandName="Delete"
                                                                CssClass="delete" Font-Bold="true" ForeColor="#FF3366" Text="X" Visible="true"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                                <PagerStyle CssClass="GridPager" BackColor="#dff3f9" HorizontalAlign="Right" NextPageText="Next" PrevPageText="Previous" />
                                            </asp:DataGrid></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                </td>
            </tr>
            <tr id="tdDoList" runat="server" visible="false">
                <td colspan="2" style="width: 507px">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr class="PageHeadsmall">
                            <td class=PageBg ><span class=TabHead>
                                &nbsp;&nbsp;Add Do List</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                        </tr>
                        <tr width="100%">
                            <td align="left" height="185" valign="top">
                                <table width="75%" border="0" cellspacing="4" cellpadding="5">
                                    <tr>
                                        <td class="login">
                                            <div>
                                                List Title</div>
                                        </td>
                                        <td>
                                            <div>
                                                <asp:TextBox ID="txtdolist" runat="server" CssClass="FormControls" MaxLength="30"></asp:TextBox></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="login">
                                            List Description</td>
                                        <td>
                                            <asp:TextBox ID="txtdolistdesc" runat="server" Height="50px" TextMode="MultiLine" Width="175px" CssClass="FormControls"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td class="login">
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="ibtnDoList" runat="server" ImageUrl="~/Common/Images/newadd.gif"
                                                OnClick="ibtnDoList_Click" />
                                            <img src="../common/images/close.gif" id="img2" onclick="javascript:window.close();" /></td>
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
                            <td width="23%" height="25" class="foottxt1"><a href="http://www.porteousfastener.com/" style="color:#1c7893" target=_blank>&nbsp;&nbsp;Copyright 2007 Porteous Fastener Co. All rights reserved.,</a> </td>
                            <td width="13%" align=right ><a href="http://www.novantus.com" target="_blank"><img src="../Common/Images/umbrellaPower.gif" border="0Px" /></a></td>
                      </tr>
                    </table>
                   
                   </td>
            </tr>
        </table>
    </form>
</body>
</html>
