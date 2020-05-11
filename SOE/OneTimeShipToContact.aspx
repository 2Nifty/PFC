<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OneTimeShipToContact.aspx.cs"
    Inherits="ShipToInformations" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE - Ship To Address</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/PendingOrdersAndQuotes.js"></script>

    <script type="text/javascript" src="Common/JavaScript/Common.js"></script>
<script type="text/javascript">
function CheckItem()
{
    if(document.getElementById("txtName").value !="" && document.getElementById("txtContactName").value !="")
    {
        return true;
    }
    else
    {   
        alert("Address Name and Contact Name are mandatory");
        return false;
    }
}
</script>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" >
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
                                <asp:Label ID="lblSONumber" runat="server" Font-Bold="False" CssClass="lblBluebox"
                                    Style="padding-left: 5px" Width="50px"></asp:Label>
                                <input id="hidCustNo" type="hidden" name="hidCustNo" runat="server"></td>
                            <td>
                            </td>
                            <td style="width: 100px" align="right">
                                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Common/Images/help.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                    <asp:UpdatePanel ID="pnlEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table height="5px" border="0" cellpadding="3" cellspacing="0">
                                <tr>
                                    <td colspan="2">
                                        <asp:CheckBox ID="chkOneTime" TabIndex=1 runat="server" Font-Bold="True" AutoPostBack="true"
                                            Text="One - Time Ship To   " OnCheckedChanged="chkOneTime_CheckedChanged" />
                                        <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><asp:CheckBox AutoPostBack="true"
                                            ID="chkNewShip" runat="server" TabIndex=2 Font-Bold="True" Text="New Ship To" OnCheckedChanged="chkNewShip_CheckedChanged"  /></td>
                                    <td colspan="2">
                                        &nbsp;
                                    </td>
                                    <td colspan="2">
                                        <asp:CheckBox ID="chkNewContact" TabIndex=11 runat="server" Font-Bold="True" Text="New Contact"
                                            AutoPostBack="true" OnCheckedChanged="chkNewContact_CheckedChanged" /></td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <asp:Panel ID="pnlAddress" runat="server">
                                            <table height="5px" border="0" cellpadding="3" cellspacing="0">
                                                <tr>
                                                    <td colspan="2">
                                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                                                            <tr>
                                                                <td align="center">
                                                                    <hr color="#003366" />
                                                                </td>
                                                                <td align="center" width="50px">
                                                                    <asp:Label ID="Label6" runat="server" Text="Address" Font-Bold="True"></asp:Label></td>
                                                                <td align="center">
                                                                    <hr align="center" color="#003366" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td width="75px">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label1" runat="server" Text="Name" Font-Bold="True" Width="60px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtName" TabIndex=3 runat="server" Font-Bold="False" Width="170px" MaxLength="40"
                                                            CssClass="lbl_whitebox"></asp:TextBox><asp:RequiredFieldValidator ID="rfvAddressName"
                                                                runat="server" ControlToValidate="txtName" ForeColor="red" ErrorMessage=" *"></asp:RequiredFieldValidator></td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Address 1" Width="59px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddress1" TabIndex=4 runat="server" Font-Bold="False" MaxLength="40" Width="170px"
                                                            CssClass="lbl_whitebox"></asp:TextBox></td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Address 2" MaxLength="40"
                                                            Width="60px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtAddress2" TabIndex=5 runat="server" Font-Bold="False" Width="170px" CssClass="lbl_whitebox"></asp:TextBox></td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="City / State" Width="59px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtCity" runat="server" TabIndex=6 Font-Bold="False" Width="105px" MaxLength="20"
                                                            CssClass="lbl_whitebox"></asp:TextBox>
                                                        <asp:TextBox Style="padding-left: 5px" TabIndex=7 ID="txtState" MaxLength="2" runat="server"
                                                            Font-Bold="False" Width="50px" CssClass="lbl_whitebox"></asp:TextBox></td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Postcode" Width="59px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtPostcode" runat="server" TabIndex=8 Font-Bold="False" MaxLength="10" Width="105px"
                                                            CssClass="lbl_whitebox"></asp:TextBox></td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Country" Width="59px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtCountry" runat="server" TabIndex=9 Font-Bold="False" Width="105px" MaxLength="4"
                                                            CssClass="lbl_whitebox"></asp:TextBox></td>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;<asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Phone" Width="59px"></asp:Label></td>
                                                    <td>
                                                        <uc4:PhoneNumber ID="txtPhone" TabIndex=10 runat="server" CssClass="lbl_whitebox" Width="105" />
                                                    </td>
                                                    <td>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                    <td colspan="3">
                                        <asp:Panel ID="pnlContacts" runat="server">
                                            <table border="0" cellpadding="3" cellspacing="0" style="width: 100%; height: 100%">
                                                <tr>
                                                    <td colspan="2">
                                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
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
                                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Name" Width="70px"></asp:Label></td>
                                                    <td colspan="1" style="padding-left: 3px;">
                                                        <asp:TextBox ID="txtContactName" TabIndex=12 runat="server" Width="170px" CssClass="lbl_whitebox"
                                                            MaxLength="30"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtName"
                                                            ForeColor="red" ErrorMessage=" *"></asp:RequiredFieldValidator></td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" style="padding: 0 0 0 0;">
                                                        <asp:Panel ID="pnlSubContacts" runat="server">
                                                            <table cellpadding="3" cellspacing="0">
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Job Title" Width="70px"></asp:Label></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtContactJobTitle" TabIndex=13 runat="server" Width="170px" MaxLength="50"
                                                                            CssClass="lbl_whitebox"></asp:TextBox></td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Department" Width="70px"></asp:Label></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtContactDepart" TabIndex=14 runat="server" Width="170px" MaxLength="20" CssClass="lbl_whitebox"></asp:TextBox></td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Phone / Ext" Width="70px"></asp:Label></td>
                                                                    <td>
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <uc4:PhoneNumber ID="txtContactPhoneNo" TabIndex=15 runat="server" CssClass="lbl_whitebox" Width="105" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;<asp:TextBox Style="padding-left: 0px" ID="txtContactExt" MaxLength="7" runat="server"
                                                                                        Width="53px" CssClass="lbl_whitebox" TabIndex=16></asp:TextBox></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="Label17" runat="server" Font-Bold="True" Text="Fax No" Width="70px"></asp:Label></td>
                                                                    <td>
                                                                        <uc4:PhoneNumber ID="txtContactFax" TabIndex=17 runat="server" CssClass="lbl_whitebox" Width="105" />
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="Label16" runat="server" Font-Bold="True" Text="Mobile No" Width="70px"></asp:Label></td>
                                                                    <td>
                                                                        <uc4:PhoneNumber ID="txtContactMob" TabIndex=18 runat="server" CssClass="lbl_whitebox" Width="105" />
                                                                    </td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Email" Width="70px"></asp:Label></td>
                                                                    <td>
                                                                        <asp:TextBox ID="txtContactEmail" TabIndex=19 MaxLength="50" runat="server" Width="170px" CssClass="lbl_whitebox"></asp:TextBox></td>
                                                                    <td>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                    <td align="right" valign="bottom">
                                        <asp:ImageButton ID="ibtnSave" TabIndex=20 OnClientClick="javascript:return CheckItem();" runat="server" ImageUrl="~/Common/Images/Save.jpg"
                                            OnClick="ibtnSave_Click" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="border-collapse: collapse;">
                    <asp:UpdatePanel ID="pnlPendingOrderGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="blueBorder" runat="server" id="divGrid">
                                <table width="100%" cellpadding="0" cellspacing="0" border="0" class="blueBorder lightBlueBg"
                                    style="border-left: none; border-right: none; border-top: none">
                                    <tr>
                                        <td style="padding-left: 15px; width: 40px; padding-top: 5px; padding-bottom: 5px;">
                                            <span style="font-weight: bold;">View</span></td>
                                        <td style="padding-top: 5px; padding-bottom: 5px;">
                                            <asp:DropDownList CssClass="lbl_whitebox" Height="20px" ID="ddlGridMode" AutoPostBack="true"
                                                runat="server" OnSelectedIndexChanged="ddlGridMode_SelectedIndexChanged">
                                                <asp:ListItem Text="Ship To Addresses" Value="Ship"></asp:ListItem>
                                                <asp:ListItem Text="Contacts" Value="Contacts"></asp:ListItem>
                                            </asp:DropDownList></td>
                                        <tr>
                                </table>
                                <table cellpadding="0" cellspacing="0" width="100%" align="center">
                                    <tr>
                                        <td colspan="2">
                                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 185px; border: 1px solid #88D2E9;
                                                width: 705px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94" >
                                                <asp:GridView ShowFooter="false" Style="display: none;" UseAccessibleHeader="true"
                                                    ID="gvContacts" PagerSettings-Visible="false" Width="1000" runat="server" AllowPaging="false"
                                                    ShowHeader="true" AllowSorting="true" AutoGenerateColumns="false" OnRowCommand="gvContacts_RowCommand"
                                                    OnSorting="gvContacts_Sorting">
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
                                                        <asp:BoundField HeaderText="Job Title" DataField="JobTitle" SortExpression="JobTitle"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Department" DataField="Department" SortExpression="Department"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Phone" DataField="Phone" SortExpression="Phone" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Ext" DataField="PhoneExt" SortExpression="PhoneExt" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="40px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Fax" DataField="FaxNo" SortExpression="FaxNo" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Mobile" DataField="MobilePhone" SortExpression="MobilePhone"
                                                            ItemStyle-CssClass="Left5pxPadd">
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
                                                        <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" SortExpression="ChangeID"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Change Date" DataField="ChangeDt" SortExpression="ChangeDt"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Deleted Date" DataField="DeleteDt" SortExpression="DeleteDt"
                                                            ItemStyle-CssClass="Left5pxPadd" Visible="false">
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
                                                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#CC0000"
                                                                    Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"pCustomerAddressID") %>'><%# DataBinder.Eval(Container.DataItem, "Name")%></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <ItemStyle Width="120px" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField HeaderText="Address 1" DataField="Address1" SortExpression="Address1"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="120px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Address 2" DataField="Address2" SortExpression="Address2"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="City" DataField="City" SortExpression="City" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="State" DataField="State" SortExpression="State" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="40px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="PostCode" DataField="PostCode" SortExpression="PostCode"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Country" DataField="Country" SortExpression="Country"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Phone" DataField="PhoneNo" SortExpression="PhoneNo" ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" SortExpression="ChangeID"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                        <asp:BoundField HeaderText="Change Date" DataField="ChangeDt" SortExpression="ChangeDt"
                                                            ItemStyle-CssClass="Left5pxPadd">
                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
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
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="left" width="85%">
                                <asp:UpdateProgress ID="pnlProgress" runat="server">
                                    <ProgressTemplate>
                                        <span class="TabHead">Loading...</span></ProgressTemplate>
                                </asp:UpdateProgress>
                                <asp:UpdatePanel ID="pnlStatusMessage" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <uc5:PrintDialogue ID="printDialogue" runat="server"></uc5:PrintDialogue>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" width="87%">
                            </td>
                            <td colspan="4" style="padding-top: 3px; padding-bottom: 3px; padding-right: 5px;">
                                <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="FooterC" Title="Ship To Information" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
