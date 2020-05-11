<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FormMessage.aspx.cs" Inherits="FormMessage" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Form Messages</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server" defaultfocus="txtSearchCode">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="Left2pxPadd DarkBluTxt boldText" width="12%" style="padding-left: 10px;">
                    <asp:UpdatePanel ID="upnlbtnSearch" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSch" runat="server" Text="Search By:&nbsp;&nbsp; &nbsp;       Location"
                                                Width="125px"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="ddlSearchLocation" CssClass="FormCtrl" Height="20px" runat="server"
                                                Width="160px">
                                            </asp:DropDownList></td>
                                        <td style="padding-left: 10px;">
                                            <asp:Label ID="Label1" runat="server" Text="Message Type" Width="85px"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="ddlSearchMsgType" CssClass="FormCtrl" Height="20px" runat="server"
                                                Width="160px" TabIndex="1">
                                            </asp:DropDownList></td>
                                        <td style="padding-left: 10px;">
                                            <asp:Label ID="Label2" runat="server" Text="Form Type" Width="65px"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="ddlSearcFrmType" CssClass="FormCtrl" Height="20px" runat="server"
                                                Width="160px" TabIndex="2">
                                            </asp:DropDownList></td>
                                        <td>
                                            <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                OnClick="btnSearch_Click" CausesValidation="False" TabIndex="11" />
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="ibtnClear" runat="server" ImageUrl="~/MaintenanceApps/Common/images/btnClear.gif"
                                                CausesValidation="False" OnClick="ibtnClear_Click" TabIndex="12" />
                                            <asp:HiddenField ID="hidPrimaryKey" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;">
                    <asp:Panel ID="Panel1" runat="server" DefaultButton="btnSave">
                        <table style="width: 100%" class="blueBorder" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td class="lightBlueBg">
                                    <asp:Label ID="lblHeading" runat="server" Text="Enter Form Message Information" CssClass="BanText"
                                        Width="284px"></asp:Label>
                                </td>
                                <td style="width: 100%; height: 5px" align="right" class="lightBlueBg">
                                    <asp:UpdatePanel ID="upnlAdd" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table>
                                                <tr>
                                                    <td style="height: 16px">
                                                        &nbsp;<img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                            tabindex="9" />
                                                        <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                            runat="server" OnClientClick="javascript:return FormMessagesRequiredField();"
                                                            OnClick="btnSave_Click" Visible="false" TabIndex="7" />
                                                        <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                            runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="8" /></td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <table width="175" border="0">
                                                <tr>
                                                    <td class="Left2pxPadd " style="padding-left: 30px" colspan="4">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px">
                                                        <asp:Label ID="Label5" runat="server" Height="16px" Text="Location" Width="90px"></asp:Label></td>
                                                    <td style="width: 300px;">
                                                        <asp:DropDownList ID="ddlLocation" Height="20px" CssClass="FormCtrl" runat="server"
                                                            Width="160px" TabIndex="3">
                                                        </asp:DropDownList></td>
                                                    <td style="width: 300px; height: 26px; padding-left: 10px" valign="top">
                                                        <span style="color: Red;"></span>
                                                    </td>
                                                    <td style="width: 101px; padding-left: 50px" valign="top" rowspan="4">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td class="Left2pxPadd DarkBluTxt boldText" valign="top">
                                                                    <asp:LinkButton ID="lnkCode" runat="server" Font-Underline="true" Text="Message"
                                                                        Width="60px" TabIndex="13"></asp:LinkButton></td>
                                                                <td style="width: 100px" valign="top">
                                                                    <div id="divToolTips" class="list" style="display: none; position: absolute; width: 260px"
                                                                        onmouseup="return false;">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <span class="boldText">Change ID: </span>
                                                                                    <asp:Label ID="lblChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                                <td>
                                                                                    <span class="boldText" style="padding-left: 5px;">Change Date: </span>
                                                                                    <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <span class="boldText">Entry ID: </span>
                                                                                    <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                                <td>
                                                                                    <span class="boldText" style="padding-left: 5px;">Entry Date: </span>
                                                                                    <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                    <asp:TextBox ID="txtComments" CssClass="FormCtrl" runat="server" TabIndex="6" MaxLength="256"
                                                                        Height="90px" TextMode="MultiLine" Width="300px"></asp:TextBox></td>
                                                                <td style="padding-left: 10px;" valign="top">
                                                                    <span style="color: #ff0000">*</span></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                        <asp:Label ID="Label3" runat="server" Height="16px" Text="Message Type" Width="90px"></asp:Label></td>
                                                    <td style="width: 100px; height: 26px">
                                                        <asp:DropDownList ID="ddlMsgType" CssClass="FormCtrl" Height="20px" runat="server"
                                                            Width="160px" TabIndex="4">
                                                        </asp:DropDownList></td>
                                                    <td style="width: 100px; padding-left: 10px;">
                                                        <span style="color: Red;"></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                        <asp:Label ID="Label4" runat="server" Height="16px" Text="Form Type" Width="90px"></asp:Label></td>
                                                    <td style="width: 100px">
                                                        <asp:DropDownList ID="ddlFormType" CssClass="FormCtrl" Height="20px" runat="server"
                                                            Width="160px" TabIndex="5">
                                                        </asp:DropDownList></td>
                                                    <td style="width: 100px">
                                                        <span style="color: #ff0000">&nbsp;&nbsp; </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;" valign="top">
                                                        &nbsp;</td>
                                                    <td style="width: 100px; height: 26px;">
                                                    </td>
                                                    <td style="width: 100px; height: 26px">
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td class="lightBlueBg" style="padding-top: 1px; height: 25px; padding-left: 125px;
                                    text-align: left; border: none;">
                                    <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:ImageButton ID="btnDelete" ImageUrl="~/MaintenanceApps/Common/Images/btndelete.gif"
                                                runat="server" CausesValidation="False" OnClick="btnDelete_Click" TabIndex="16" />&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td class="lightBlueBg" style="padding-top: 1px; height: 5px; text-align: right">
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upnlGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr class="lightBlueBg">
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 7px; width: 4%;">
                                        <span class="BanText">Form Messages&nbsp;</span></td>
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 1px; width: 5%;">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                        <div id="div-datagrid" class="Sbar" style="overflow-x: hidden; overflow-y: auto;
                                            position: relative; top: 0px; left: 0px; height: 340px; width: 1015px; border: 0px solid;"
                                            align="left">
                                            <asp:DataGrid CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="dgCountryCode"
                                                GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                AllowSorting="True" ShowFooter="False" OnItemCommand="dgCountryCode_ItemCommand"
                                                OnSortCommand="dgCountryCode_SortCommand" OnItemDataBound="dgCountryCode_ItemDataBound"
                                                TabIndex="10">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <FooterStyle CssClass="lightBlueBg" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Actions">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pTableID")%>'>Edit</asp:LinkButton>
                                                            <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pTableID")%>'>Delete</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="90px" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="FormMsgLoc" HeaderText="Location" SortExpression="FormMsgLoc">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="50px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="50px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="FormMsgType" HeaderText="Type" SortExpression="FormMsgType">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="50px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="50px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="FrmType" HeaderText="Form" SortExpression="FrmType">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="50px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="50px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Comments" HeaderText="Message" SortExpression="Comments">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="400px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="550px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryDt" HeaderText="Enter Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="EntryDt">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeDt" HeaderText="Change Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="ChangeDt">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
                                                    </asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                            <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                            <asp:HiddenField ID="hidScrollTop" runat="server" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg buttonBar" height="20px" style="width: 930px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="width: 1253px">
                    <uc2:Footer ID="BottomFrame2" Title="Support Tables Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
