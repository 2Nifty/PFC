<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserSecurity.ascx.cs"
    Inherits="UserSecurityData" %>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td colspan="3">
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;" class="Left5pxPadd Search">
                            <tr>
                                <td class="Left5pxPadd BannerText" width="70%">
                                    User Security
                                </td>
                                <td align="right" style="padding-right: 5px;">
                                </td>
                                <td align="center">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" style="padding-top: 5px; padding-left: 10px; padding-bottom: 15px;">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="width: 100px">
                                </td>
                                <td style="width: 100px">
                                </td>
                                <td align=left>
                                    <table cellpadding="0" cellspacing="0" border=0 width="100%">
                                        <tr>
                                            <td width="15%" class="DarkBluTxt boldText" height="20px"
                                                style="text-decoration: underline">
                                                User's Name:
                                            </td>
                                            <td width="35%" align="left" style="padding-left: 3px;">
                                                <asp:Label ID="lblUser" runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <table border="0" onmouseup="UpdateSecurity();" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td bgcolor="#DFF3F9" style="border: 1px solid; border-collapse: collapse; border-bottom: 1px"
                                                height="19px" class="GridHead" width="200px">
                                                <span style="padding-left: 5px">Security Groups</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" border="0" width="100%" class="Search">
                                                    <tr>
                                                        <td width="67px" style="padding-left: 2px; border: 1px solid; border-collapse: collapse;
                                                            border-bottom: 1px">
                                                            <span style="padding-left: 5px;"><strong>Group</strong></span>
                                                        </td>
                                                        <td width="100px" style="padding-left: 5px; border: 1px solid; border-collapse: collapse;
                                                            border-bottom: 1px">
                                                            <strong>Application</strong>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td onselectstart="javascript:DisableSelect();" width="200px">
                                                <asp:UpdatePanel ID="upnlSecurityGrid" UpdateMode="conditional" runat="server">
                                                    <ContentTemplate>
                                                        <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                                            top: 0px; left: 0px; height: 250px; width: 202px; border: 0px solid; border-collapse: collapse;">
                                                            <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" PageSize="17"
                                                                Style="border-collapse: collapse; height: auto;" Width="201px" ID="gvSecurityGroups"
                                                                runat="server" AllowPaging="false" ShowHeader="false" ShowFooter="false" AllowSorting="false"
                                                                BorderWidth="1" AutoGenerateColumns="false" OnRowDataBound="gvSecurityGroups_RowDataBound">
                                                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                                                    HorizontalAlign="Center" />
                                                                <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                                                    Height="19px" HorizontalAlign="Left" />
                                                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                                                    HorizontalAlign="Center" />
                                                                <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"
                                                                    HorizontalAlign="Center" />
                                                                <Columns>
                                                                    <asp:BoundField HeaderText="Group" DataField="ListValue" SortExpression="ListValue"
                                                                        ItemStyle-CssClass="Left5pxPadd">
                                                                        <ItemStyle HorizontalAlign="Left" Width="70px" />
                                                                        <FooterStyle HorizontalAlign="Right" />
                                                                        <HeaderStyle HorizontalAlign="center" Width="70px" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField HtmlEncode="false" HeaderText="Application" DataField="GroupCd" SortExpression="GroupCd">
                                                                        <ItemStyle HorizontalAlign="Center" Width="130px" Wrap="False" />
                                                                        <FooterStyle HorizontalAlign="Right" />
                                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="120px" />
                                                                    </asp:BoundField>
                                                                </Columns>
                                                            </asp:GridView>
                                                            <asp:HiddenField ID="hidValue" runat="server" />
                                                            <asp:HiddenField ID="hidUser" runat="server" />
                                                            <asp:Button ID="btnSecurityUpdate" runat="server" CausesValidation="false" Style="display: none;"
                                                                Text=" " OnClick="btnSecurityUpdate_Click" /></div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width: 100px; padding-top: 50px;" align=center valign="top">
                                    <img id="Img1" src="../images/Lock.gif" alt="Lock" runat="server" /></td>
                                <td style="width: 100px">
                                    <table border="0" onmouseup="UpdateUser();" cellpadding="0" cellspacing="0">
                                        <tr height="19px">
                                            <td bgcolor="#DFF3F9" class="GridHead" width="200px" style="padding-left: 2px; border: 1px solid;
                                                border-collapse: collapse; border-bottom: 1px">
                                                <span style="padding-left: 5px">User's Groups - </span>
                                                <asp:Label ID="lblUserName" runat="server" ForeColor="#CC0000" Style="padding-left: 2px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" border="0" width="100%" class="Search">
                                                    <tr>
                                                        <td width="113px" style="padding-left: 2px; border: 1px solid; border-collapse: collapse;
                                                            border-bottom: 1px">
                                                            <strong>
                                                            <span style="padding-left: 2px">Group</span> </strong>
                                                        </td>
                                                        <td width="100px" style="padding-left: 2px; border: 1px solid; border-collapse: collapse;
                                                            border-bottom: 1px">
                                                            <strong>Application </strong>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="100%" onselectstart="javascript:DisableSelect();">
                                                <asp:UpdatePanel ID="upnlGroupGrid" UpdateMode="conditional" runat="server">
                                                    <ContentTemplate>
                                                        <div class="Sbar" id="div1" style="overflow-x: hidden; overflow-y: auto; position: relative;
                                                            top: 0px; left: 0px; height: 125px; width: 253px; border: 0px solid;">
                                                            <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" PageSize="17"
                                                                Style="border-collapse: collapse;" Width="252px" ID="gvUserGroup" runat="server"
                                                                AllowPaging="false" BorderWidth="1" ShowHeader="false" ShowFooter="false" AllowSorting="false"
                                                                AutoGenerateColumns="false" OnRowDataBound="gvUserGroup_RowDataBound">
                                                                <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                                                    HorizontalAlign="Center" />
                                                                <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                                                    Height="19px" HorizontalAlign="Left" />
                                                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                                                    HorizontalAlign="Center" />
                                                                <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"
                                                                    HorizontalAlign="Center" />
                                                                <Columns>
                                                                    <asp:BoundField HeaderText="Group" DataField="SecGroupID" DataFormatString="" SortExpression="SecGroupID"
                                                                        ItemStyle-CssClass="Left5pxPadd">
                                                                        <ItemStyle HorizontalAlign="Left" Width="100px" />
                                                                        <FooterStyle HorizontalAlign="Right" />
                                                                        <HeaderStyle HorizontalAlign="center" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField HtmlEncode="false" HeaderText="Application" DataField="SecurityGroupApp"
                                                                        SortExpression="SecurityGroupApp">
                                                                        <ItemStyle HorizontalAlign="Center" Width="100px" Wrap="False" />
                                                                        <FooterStyle HorizontalAlign="Right" />
                                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="100px" />
                                                                    </asp:BoundField>
                                                                    <asp:BoundField HtmlEncode="false" HeaderText="ID" DataField="pSecMembersID" SortExpression="pSecMembersID">
                                                                        <ItemStyle HorizontalAlign="Center" Wrap="False" CssClass="hide" />
                                                                        <FooterStyle HorizontalAlign="Right" CssClass="hide" />
                                                                        <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="30px" CssClass="hide" />
                                                                    </asp:BoundField>
                                                                </Columns>
                                                            </asp:GridView>
                                                            <asp:Button ID="btnUserUpdate" runat="server" Style="display: none;" CausesValidation="false"
                                                                Text=" " OnClick="btnUserUpdate_Click" />
                                                            <asp:HiddenField ID="hidUserValue" runat="server" />
                                                            <asp:HiddenField ID="hidUserID" runat="server" />
                                                            <asp:HiddenField ID="hidUserIDVal" runat="server" />
                                                        </div>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr height="33px">
                                            <td>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:UpdatePanel ID="upnlPermGrid" UpdateMode="conditional" runat="server">
                                                    <ContentTemplate>
                                                        <table cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td class="GridHead" height="20" style="border-right: 0px; border-top: 0px; border-left: 1px solid;
                                                                    border-bottom: 0px; border-collapse: collapse" width="200" bgcolor="#dff3f9">
                                                                     <span style="padding-left: 5px">User's Permission</span>
                                                                </td>
                                                                <td align="center" class="GridHead" style="border-right: 1px solid; border-top: 0px;
                                                                    border-left: 0px; border-bottom: 0px; border-collapse: collapse" width="50" bgcolor="#dff3f9">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="200" height="20" style="border: 1px solid; border-collapse: collapse;
                                                                    border-right: 0px; border-bottom: 0px; border-top: 0px" class="Search">
                                                                    <strong>
                                                                    <span style="padding-left: 5px">Quick Set By Application</span> </strong>
                                                                </td>
                                                                <td width="50" align="center" style="border: 1px solid; border-collapse: collapse;
                                                                    border-left: 0px; border-bottom: 0px; border-top: 0px" class="Search">
                                                                    <img id="Img2" src="../images/key.gif" alt="Key" runat="server" width="20" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="250" colspan="2" style="border: 1px solid; border-collapse: collapse;">
                                                                    <div class="Sbar" id="div2" style="overflow-x: auto; overflow-y: scroll; position: relative;
                                                                        top: 0px; left: 0px; height: 200px; width: 250px; border: 0px solid;">
                                                                        <table cellpadding="2" cellspacing="0" border="1" width="93%">
                                                                            <tr>
                                                                                <td style="border: 1px solid; border-collapse: collapse;width:20px;">
                                                                                    &nbsp;</td>
                                                                                <td width="50" style="border: 1px solid; border-collapse: collapse;">
                                                                                    <asp:Label ID="Label1" runat="server" Width="40px">Query-only</asp:Label></td>
                                                                                <td width="40" style="border: 1px solid; border-collapse: collapse;">
                                                                                    Full</td>
                                                                                <td width="30" style="border: 1px solid; border-collapse: collapse;">
                                                                                    Groups</td>
                                                                                <td width="40" style="border: 1px solid; border-collapse: collapse; color: #CC0000;
                                                                                    font-weight: bold">
                                                                                    Deny</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td style="border: 1px solid; border-collapse: collapse; font-weight: bold">
                                                                                    AP
                                                                                </td>
                                                                                <td colspan="4" style="border: 1px solid; border-collapse: collapse; padding-left: 10px;">
                                                                                    <asp:RadioButtonList ID="rdlAP" runat="server" RepeatDirection="Horizontal" Width="100%"
                                                                                        >
                                                                                        <asp:ListItem Text="" Value="Q"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="F"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="G" Selected="true"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="D"></asp:ListItem>
                                                                                    </asp:RadioButtonList>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td style="border: 1px solid; border-collapse: collapse; font-weight: bold">
                                                                                    AR
                                                                                </td>
                                                                                <td colspan="4" style="border: 1px solid; border-collapse: collapse; padding-left: 10px;">
                                                                                    <asp:RadioButtonList ID="rdlAR" runat="server" RepeatDirection="Horizontal" Width="100%"
                                                                                        >
                                                                                        <asp:ListItem Text="" Value="Q"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="F"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="G" Selected="true"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="D"></asp:ListItem>
                                                                                    </asp:RadioButtonList>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td style="border: 1px solid; border-collapse: collapse; font-weight: bold">
                                                                                    GL
                                                                                </td>
                                                                                <td colspan="4" style="border: 1px solid; border-collapse: collapse; padding-left: 10px;">
                                                                                    <asp:RadioButtonList ID="rdlGL" runat="server" RepeatDirection="Horizontal" Width="100%"
                                                                                        >
                                                                                        <asp:ListItem Text="" Value="Q"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="F"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="G" Selected="true"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="D"></asp:ListItem>
                                                                                    </asp:RadioButtonList>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td style="border: 1px solid; border-collapse: collapse; font-weight: bold">
                                                                                    IM
                                                                                </td>
                                                                                <td colspan="4" style="border: 1px solid; border-collapse: collapse; padding-left: 10px;">
                                                                                    <asp:RadioButtonList ID="rdlIM" runat="server" RepeatDirection="Horizontal" Width="100%"
                                                                                        >
                                                                                        <asp:ListItem Text="" Value="Q"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="F"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="G" Selected="true"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="D"></asp:ListItem>
                                                                                    </asp:RadioButtonList>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td style="border: 1px solid; border-collapse: collapse; font-weight: bold">
                                                                                    POE
                                                                                </td>
                                                                                <td colspan="4" style="border: 1px solid; border-collapse: collapse; padding-left: 10px;">
                                                                                    <asp:RadioButtonList ID="rdlPOE" runat="server" RepeatDirection="Horizontal" Width="100%"
                                                                                        >
                                                                                        <asp:ListItem Text="" Value="Q"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="F"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="G" Selected="true"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="D"></asp:ListItem>
                                                                                    </asp:RadioButtonList>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td style="border: 1px solid; border-collapse: collapse; font-weight: bold">
                                                                                    SOE
                                                                                </td>
                                                                                <td colspan="4" style="border: 1px solid; border-collapse: collapse; padding-left: 10px;">
                                                                                    <asp:RadioButtonList ID="rdlSOE" runat="server" RepeatDirection="Horizontal" Width="100%"
                                                                                        >
                                                                                        <asp:ListItem Text="" Value="Q"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="F"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="G" Selected="true"></asp:ListItem>
                                                                                        <asp:ListItem Text="" Value="D"></asp:ListItem>
                                                                                    </asp:RadioButtonList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
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
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="BluBg buttonBar Left5pxPadd" style="border-top: solid 1px #DAEEEF; padding-right: 10px;" colspan="3" align="right">
                        <table cellpadding="0" cellspacing="0" style="padding-top: 0px;">
                            <tr>
                                <td>
                                </td>
                                <td align="right" style="padding-right: 5px;" valign="top">
                                    <asp:ImageButton runat="server" ID="ibtnSave" ImageUrl="~/EmployeeData/Common/images/BtnSave.gif"
                                        ImageAlign="middle" OnClick="ibtnSave_Click" CausesValidation="false"  />
                                </td>
                                <td width="70px" style="padding-right: 3px;" valign="top">
                                    <img id="btnClose" src="../images/close.jpg" onclick="javascript:window.close();"
                                        runat="server" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
