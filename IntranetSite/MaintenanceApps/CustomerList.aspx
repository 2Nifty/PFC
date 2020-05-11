<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerList.aspx.cs" Inherits="CustomerList" %>

<%@ Register Src="Common/UserControls/MinFooter.ascx" TagName="Footer" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Organization Standard Comments</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/PFCCustomer.js"></script>

    <script>    
    function BindCustomer(customerno)
    { 
        window.opener.document.getElementById("txtCode").value = customerno;
        window.opener.document.getElementById("txtCode").focus();
        CallBtnClick("btnSearch");
       
        window.close();
    }
    function CallBtnClick(id)
    {
        var btnBind = window.opener.document.getElementById(id);
            
        if (typeof btnBind == 'object')
        { 
            btnBind.click();
            return false; 
        } 
        return;
    }

    </script>

</head>
<body bgcolor="#ECF9FB" scroll="no" style="margin: 3px">
    <form id="form1" runat="server">
        <div>
            <table width="100%" cellpadding="0" cellspacing="0" class="splitBorder">
                <tr>
                    <td class="splitBorder" style="padding-top:10px" align=center>
                        <asp:Label ID="lblMessage" ForeColor="red" Font-Bold="true" CssClass="Tabhead" runat="server"
                            Visible="false" Text="No record found"></asp:Label></td>
                </tr>
                <tr>
                    <td class="splitBorder">
                        <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px;
                                    left: 0px; width: 850px; height: 370px; border: 0px solid; color:White">
                            <asp:DataGrid  ID="dgCustomerList" BorderColor="#9AB8C3" runat="server" BorderWidth="0" Width="900px"
                                 GridLines="both" AutoGenerateColumns="False"  OnItemDataBound="dgCustomerList_ItemDataBound" OnSortCommand="dgCustomerList_SortCommand"
                                AllowSorting="True" TabIndex="19">
                                <HeaderStyle HorizontalAlign="center" Height="25px" CssClass="GridHead" BorderColor="#DAEEEF"
                                    Font-Bold="true" BackColor="#DFF3F9" />
                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                <ItemStyle CssClass="item" BorderColor="#DAEEEF" Wrap="False" BackColor="#FFFFFF"
                                    Height="20px" BorderWidth="1px" />
                                <AlternatingItemStyle BorderColor="#DAEEEF" CssClass="itemShade" BackColor="#ECF9FB"
                                    Height="20px" BorderWidth="1px" />
                                <Columns>
                                    <asp:BoundColumn DataField="CustNo"   HeaderText="No" ItemStyle-Width="50" ItemStyle-BorderWidth="1px"
                                        HeaderStyle-BorderWidth="1" HeaderStyle-CssClass ="locked"  ItemStyle-CssClass ="locked link" ItemStyle-Font-Underline=true ></asp:BoundColumn>
                                    <asp:BoundColumn DataField="CustName" HeaderText="CustomerName" ItemStyle-Width="250"
                                        HeaderStyle-CssClass ="locked link"  ItemStyle-CssClass ="locked link"  ItemStyle-BorderWidth="1px" HeaderStyle-BorderWidth="1"></asp:BoundColumn>
                                   
                                    <asp:BoundColumn DataField="Email" HeaderText="Email" ItemStyle-Width="150" ItemStyle-BorderWidth="1px"
                                        HeaderStyle-BorderWidth="1"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="AddrLine1" HeaderText="Address1" ItemStyle-Width="170"
                                        ItemStyle-BorderWidth="1px" HeaderStyle-BorderWidth="1"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="City" HeaderText="City" ItemStyle-Width="80" ItemStyle-BorderWidth="1px"
                                        HeaderStyle-BorderWidth="1"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="State" HeaderText="State" ItemStyle-Width="50" ItemStyle-BorderWidth="1px"
                                        HeaderStyle-BorderWidth="1"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="PostCd" HeaderText="PostCode" ItemStyle-Width="50" ItemStyle-BorderWidth="1px"
                                        HeaderStyle-BorderWidth="1"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="Country" HeaderText="Country" ItemStyle-Width="50" ItemStyle-BorderWidth="1px"
                                        HeaderStyle-BorderWidth="1"></asp:BoundColumn>
                                                                         
                                </Columns>
                            </asp:DataGrid>
                            <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                            <input id="hidfname" type="hidden" name="Hidden1" runat="server">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="background: url(common/images/commandlineBg.jpg) left -80px;
                        padding-right: 10px">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="splitborder_t_v splitborder_b_v" style="padding-top:5px;" align="right" width="100%" id="td1">
                                    <img src="Common/Images/close.gif" style="cursor: hand;" onclick="javascript:window.close();"
                                        id="img3" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Customer Selection" runat="server"></uc2:Footer>
                </td>
            </tr>
            </table>
        </div>
    </form>
    <script>
self.focus();
</script>
</body>
</html>
