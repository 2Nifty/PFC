<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SelectContacts.aspx.cs" Inherits="SelectContacts" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Select Contacts </title>
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
                <td>
                    <asp:Label ID="Label1" runat="server"  ></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upnlContactsGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: hidden;
                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 220px; border: 1px solid #88D2E9;
                                width: 500px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                <asp:GridView UseAccessibleHeader="true" ID="gvContacts" PagerSettings-Visible="false"
                                    Width="480" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                    AutoGenerateColumns="false" ShowFooter="False" OnRowDataBound="gvContacts_RowDataBound" OnSorting="gvContacts_Sorting1">
                                    <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9"
                                        Height="20px" />
                                    <FooterStyle Font-Bold="True" VerticalAlign="Top" HorizontalAlign="Right" />
                                    <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="20px" BorderWidth="1px" />
                                    <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Select" SortExpression="CustNo">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="true" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hidControlId" runat="server" />
                                                <asp:CheckBox ID="chkSelect" runat="server" />
                                            </ItemTemplate>
                                            <ItemStyle Width="40px" HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="Contact Type" DataField="ContactType" SortExpression="ContactType">
                                            <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Contact Name" DataField="Name" SortExpression="Name">
                                            <ItemStyle HorizontalAlign="Left" Width="150px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="E-Mail Address" DataField="EmailAddr" SortExpression="EmailAddr">
                                            <ItemStyle HorizontalAlign="Left" Width="200px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Fax Number" DataField="FaxNo" SortExpression="FaxNo">
                                            <ItemStyle HorizontalAlign="Left" Width="180px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                    </Columns>
                                    <PagerSettings Visible="False" />
                                </asp:GridView>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td  class="BluBg buttonBar" height="20px" style="width: 930px" width="45%">
                    <table>
                        <tr>
                            <td width="40%">
                                <asp:UpdatePanel ID="upMessage" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="padding-left: 5px;" align="left" width="89%">
                                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="true">
                                                        <ProgressTemplate>
                                                            <span class="TabHead">Loading...</span></ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                    <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;">
                    <asp:ImageButton ID="btnOk" runat="server" ImageUrl="Common/Images/Ok.gif" OnClick="btnOk_Click" />
                    <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
