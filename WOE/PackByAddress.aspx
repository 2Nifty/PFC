<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PackByAddress.aspx.cs" Inherits="PFC.WebPage.PackByInformation" %>

<%@ Register Src="Common/UserControls/MinFooter.ascx" TagName="MinFooter" TagPrefix="uc6" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>WOE - Pack By Information</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    // function to relaod sold to contact information in parent window
    function RefreshPackByContact(contactName)
    {        
        window.opener.parent.bodyFrame.document.getElementById("lblPckContact").innerText = contactName;
        
    }    
    </script>

</head>
<body   onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1"  AsyncPostBackTimeout ="360000" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%;
            height: 100%">
            <tr>
                <td class="lightBg" style="padding: 0px;">
                    <table border="0" cellpadding="3" cellspacing="0" width="100%">
                        <tr>
                            <td style="width: 50px; padding-left: 8px;">
                                <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Sales Order Number"
                                    Width="117px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblWONumber" runat="server" Font-Bold="False" CssClass="lblBluebox"
                                    Style="padding-left: 5px" Width="50px"></asp:Label>
                                <input id="hidCustNo" type="hidden" name="hidCustNo" runat="server">&nbsp;
                            </td>
                            <td>
                            </td>
                            <td style="width: 100px; padding-right: 7px;" align="right">
                                <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="~/Common/Images/help.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                    <asp:UpdatePanel ID="pnlContactEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table height="5px" border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                    <td colspan="2">
                                        </td>
                                    <td>
                                    </td>
                                    <td colspan="2">
                                        </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 5px;">
                                            <tr>
                                                <td align="center">
                                                    <hr color="#003366" />
                                                </td>
                                                <td align="center" width="50px">
                                                    <asp:Label ID="Label6" runat="server" Text="Address" Font-Bold="True" Width="55px"></asp:Label></td>
                                                <td align="center">
                                                    <hr align="center" color="#003366" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="75px">
                                    </td>
                                    <td colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tr>
                                                <td align="center">
                                                    <hr color="#003366" />
                                                </td>
                                                <td align="center" width="50px">
                                                    <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Contact"></asp:Label></td>
                                                <td align="center">
                                                    <hr align="center" color="#003366" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" Text="Name" Font-Bold="True" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblName" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Name" Width="70px"></asp:Label></td>
                                    <td colspan="1">
                                        <asp:Label ID="lblContactName" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Address 1" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblAddress1" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Fax" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblContactFax" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Address 2" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblAddress2" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Email" Width="70px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblContactEmail" runat="server" CssClass="lblBluebox" Font-Bold="False"
                                            Width="170px"></asp:Label></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="City / State" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCity" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label><asp:Label
                                            Style="padding-left: 5px" ID="lblState" runat="server" Font-Bold="False" Width="50px"
                                            CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        </td>
                                    <td>
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/Save.jpg"
                                            OnClick="ibtnSave_Click" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Postcode" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPostcode" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        </td>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Country" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCountry" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        </td>
                                    <td>
                                        &nbsp;</td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;<asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Phone" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblPhone" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        </td>
                                    <td>
                                        </td>
                                    <td align="right">
                                        </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="border-collapse: collapse;" valign=top>
                      <asp:UpdatePanel ID="pnlGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="blueBorder" runat="server" id="divGrid">
                                <table width="100%" cellpadding="0" cellspacing="0" border="0" class="blueBorder lightBlueBg"
                                    style="border-left: none; border-right: none; border-top: none">
                                    <tr>
                                        <td style="padding-left: 15px; width: 40px; padding-top: 5px; padding-bottom: 5px;">
                                            <span style="font-weight: bold;">View</span></td>
                                        <td style="padding-top: 5px; padding-bottom: 5px;">
                                            <asp:DropDownList CssClass="lbl_whitebox" Height="20px" ID="ddlGridMode" AutoPostBack="true"
                                                runat="server" OnSelectedIndexChanged="ddlGridMode_SelectedIndexChanged" >
                                                <asp:ListItem Text="Pack By Addresses" Value="Address"></asp:ListItem>
                                                <asp:ListItem Text="Contacts" Value="Contacts"></asp:ListItem>
                                            </asp:DropDownList></td>
                                        <tr>
                                </table>
                                <table cellpadding="0" cellspacing="0" width="100%" align="center">
                                    <tr>
                                        <td colspan="2" style="height: 220px">
                                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 220px; border: 1px solid #88D2E9;
                                                width: 710px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94" >
                                                <asp:GridView ShowFooter="false" Visible=false UseAccessibleHeader="true"
                                                    ID="gvContacts" PagerSettings-Visible="false" Width="800" runat="server" AllowPaging="false"
                                                    ShowHeader="true" AllowSorting="true" AutoGenerateColumns="false" OnRowCommand="gvContacts_RowCommand"
                                                    OnSorting="gvContacts_Sorting" OnRowDataBound="gvContacts_RowDataBound1">
                                                    <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true"
                                                        BackColor="#DFF3F9" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                                    <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                                    <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#CC0000"
                                                                    Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"pCustContactsID") %>'><%# DataBinder.Eval(Container.DataItem, "Name")%></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="80px" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField HeaderText="Fax" DataField="FaxNo" SortExpression="FaxNo" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Email" DataField="EmailAddr" SortExpression="EmailAddr"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="150px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Entry Date" DataFormatString="{0:mm/dd/yyyy}" DataField="EntryDt" SortExpression="EntryDt"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" SortExpression="ChangeID"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Change Date" DataFormatString="{0:mm/dd/yyyy}" DataField="ChangeDt" SortExpression="ChangeDt"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                                <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvAddress" PagerSettings-Visible="false"
                                                    Width="1000" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                                    AutoGenerateColumns="false" OnRowCommand="gvAddress_RowCommand" OnSorting="gvAddress_Sorting">
                                                    <HeaderStyle HorizontalAlign="center" Height="20px" CssClass="GridHead" Font-Bold="true"
                                                        BackColor="#DFF3F9" />
                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                                    <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                                    <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Name" SortExpression="LocName">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#CC0000"
                                                                    Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"LocID") %>'><%# DataBinder.Eval(Container.DataItem, "LocName")%></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="120px" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField HeaderText="Address 1" DataField="LocAdress1" SortExpression="LocAdress1"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="120px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Address 2" DataField="LocAdress2" SortExpression="LocAdress2"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="City" DataField="LocCity" SortExpression="LocCity" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="State" DataField="LocState" SortExpression="LocState" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="40px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="PostCode" DataField="LocPostCode" SortExpression="LocPostCode"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Country" DataField="LocCountry" SortExpression="LocCountry"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Phone" DataField="LocPhone" SortExpression="LocPhone" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Entry Date" DataFormatString="{0:mm/dd/yyyy}" DataField="EntryDt" SortExpression="EntryDt"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" SortExpression="ChangeID"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Change Date" DataFormatString="{0:mm/dd/yyyy}" DataField="ChangeDt" SortExpression="ChangeDt"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                                <input id="hidLocCode" type="hidden" name="Hidden1" runat="server">
                                                <input id="hidAddressSort" type="hidden" name="Hidden1" runat="server">
                                                <input id="hidContactSort" type="hidden" name="Hidden1" runat="server">
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <asp:UpdatePanel ID="pnlStatusMessage" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="left" style="padding-left: 10px;" width="90%">
                                        <asp:UpdateProgress ID="pnlProgress" runat="server">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td colspan="4">
                                        <uc5:PrintDialogue ID="printDialogue" runat="server" Visible="false"></uc5:PrintDialogue>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" width="90%">
                                    </td>
                                    <td colspan="4" style="padding-top: 3px; padding-bottom: 3px; padding-right: 5px;">
                                        <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc6:MinFooter ID="MinFooter1" runat="server" Title="Pack By Information" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
