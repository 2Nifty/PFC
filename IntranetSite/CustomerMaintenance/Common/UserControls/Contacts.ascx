<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Contacts.ascx.cs" Inherits="PFC.Intranet.Maintenance.Contacts" %>
<%@ Register Src="PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc1" %>
<script>

function CheckRequiredField(ctrlId)
{
    var locName=document.getElementById(ctrlId.replace('ibtnUpdate','txtName')).value;
    
    if(locName.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}

</script>
<table cellpadding="0" cellspacing="0" width="100%" class="blueBorder" style="border-collapse: collapse;">
    <tr>
        <td>
            <table cellpadding="0" class="lightBlueBg" cellspacing="0" width="100%">
                <tr>
                    <td>
                        <asp:Label ID="lblContact" CssClass="BanText" runat="server" Text="Contacts"></asp:Label>
                    </td>
                    <td align="right">
                        <asp:ImageButton ID="btnAdd" runat="server" ImageUrl="~/customerMaintenance/Common/images/newAdd.gif"
                            OnClick="btnAdd_Click" CausesValidation="False" /><asp:Button ID="btnShowContact"
                                Visible="false" runat="server" />
                        <asp:HiddenField ID="hidAddressID" runat="server" />
                        <asp:HiddenField ID="hidMode" runat="server" />
                        <asp:HiddenField ID="hidContactID" runat="server" />
                        <asp:HiddenField ID="hidCustomerNo" runat="server" />
                        <asp:HiddenField ID="hidContactCount" runat="server" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Panel ID="pnlContacts" runat="server" DefaultButton="ibtnUpdate">
                <table width="100%" id="tblContactEntry" runat="server" style="border-collapse: collapse;">
                    <tr>
                        <td style="padding-top: 10px; padding-bottom: 10px;">
                            <table width="70%" cellpadding="1" style="border-collapse: collapse;">
                                <tr>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblName" runat="server" Text="Name"></asp:Label></td>
                                    <td class="Left2pxPadd">
                                        <asp:TextBox MaxLength="30" CssClass="FormCtrl" ID="txtName" runat="server"></asp:TextBox>
                                        <span style="color: Red;">*</span>
                                    </td>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblCode" runat="server" Text="Contact Code"></asp:Label></td>
                                    <td class="Left2pxPadd">
                                        <asp:DropDownList ID="ddlCode" CssClass="FormCtrl" runat="server" Width="120px" Height="20px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblJT" runat="server" Text="Job Title "></asp:Label></td>
                                    <td class="Left2pxPadd">
                                        <asp:TextBox MaxLength="50" CssClass="FormCtrl" ID="txtJobTitle" runat="server"></asp:TextBox></td>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblType" runat="server" Text="Contact Type"></asp:Label></td>
                                    <td class="Left2pxPadd">
                                        <asp:DropDownList ID="ddlType" CssClass="FormCtrl" runat="server" Width="120px" Height="20px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblPh" runat="server" Text="Phone "></asp:Label></td>
                                    <td>
                                        <uc1:PhoneNumber ID="phContact" runat="server" />
                                    </td>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblExtn" runat="server" Text="Ext "></asp:Label></td>
                                    <td class="Left2pxPadd">
                                        <asp:TextBox MaxLength="7" CssClass="FormCtrl" onkeypress="javascript:ValdateNumber();"
                                            ID="txtExt" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblMp" MaxLength="14" runat="server" Text="Mobile Phone "></asp:Label></td>
                                    <td>
                                        <uc1:PhoneNumber ID="txtMphone" runat="server" />
                                    </td>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblFx" MaxLength="14" runat="server" Text="Fax "></asp:Label></td>
                                    <td>
                                        <uc1:PhoneNumber ID="fxContact" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblMail" runat="server" Text="Email "></asp:Label></td>
                                    <td colspan="1" class="Left2pxPadd">
                                        <asp:TextBox MaxLength="80" CssClass="FormCtrl" ID="txtEmail" runat="server" Width="250px"></asp:TextBox></td>
                                    <td colspan="2">
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid Email"
                                            ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd">
                                        <asp:Label ID="lblDp" runat="server" Text="Department "></asp:Label></td>
                                    <td colspan="3" class="Left2pxPadd">
                                        <asp:TextBox CssClass="FormCtrl" ID="txtDepartment" runat="server" Width="250px"></asp:TextBox></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr height="36" valign="middle" style="padding-top: 10px;">
                        <td class="lightBlueBg" style="padding-left: 120px; vertical-align: middle; border-collapse: collapse;
                            border: 0;">
                            <asp:ImageButton ID="ibtnUpdate" OnClientClick="javascript:return CheckRequiredField(this.id);"
                                CausesValidation="true" runat="server" ImageUrl="~/customerMaintenance/Common/images/update.gif"
                                OnClick="ibtnUpdate_Click" />
                            <asp:ImageButton ID="ibtnCancel" runat="server" ImageUrl="~/customerMaintenance/Common/images/cancel.png"
                                CausesValidation="False" OnClick="ibtnCancel_Click" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </td>
    </tr>
    <tr>
        <td style="border-collapse: collapse;" width="100%" id="tdDisplay" runat="server"
            align="center">
            <div id="divDisplay" runat="server" class="Sbar" style="overflow-y: auto; overflow-x: hidden;
                width: 100%; position: relative;">
                <asp:Label ID="lblMessage" Style="padding-left: 2px;" ForeColor="red" Font-Bold="true"
                    runat="server" Text="No Records Found"></asp:Label>
                <asp:DataList Style="height: auto;" ID="dlContacts" runat="server" Width="100%" RepeatDirection="horizontal"
                    RepeatColumns="4" OnItemCommand="dlContacts_ItemCommand" OnItemDataBound="dlContacts_ItemDataBound">
                    <ItemStyle CssClass="grayBorder" Width="25%" HorizontalAlign="left" />
                    <ItemTemplate>
                        <table cellpadding="1" cellspacing="0" width="100%" style="border-collapse: collapse;">
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="lblName" runat="server" CssClass="grayboldText" Text='<%#DataBinder.Eval(Container,"DataItem.Name") %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="lblJT" runat="server" CssClass="grayboldText" Text="Job Title: "></asp:Label>
                                    <asp:Label ID="lblJobTitle" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.JobTitle") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="lblDp" runat="server" CssClass="grayboldText" Text="Department: "></asp:Label>
                                    <asp:Label ID="lblDepartment" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.Department") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="lblPh" runat="server" CssClass="grayboldText" Text="Phone: "></asp:Label>
                                    <asp:Label ID="lblPhone" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.Phone") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="lblMp" runat="server" CssClass="grayboldText" Text="Mobile Phone: "></asp:Label>
                                    <asp:Label ID="lblMphone" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.MobilePhone") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="lblFx" runat="server" CssClass="grayboldText" Text="Fax: "></asp:Label>
                                    <asp:Label ID="lblFax" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.FaxNo") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="lblMail" runat="server" CssClass="grayboldText" Text="Email: "></asp:Label>
                                    <asp:Label ID="lblEmail" CssClass="grayText" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.EmailAddr") %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" nowrap="nowrap">
                                    <asp:LinkButton ID="lbtnEdit" Font-Underline="true" CausesValidation="false" runat="server"
                                        CssClass="link" CommandName="Edit" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pCustContactsID") %>'>Edit</asp:LinkButton>
                                    <asp:LinkButton ID="lnkDelete" Font-Underline="true" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pCustContactsID") %>'
                                        CausesValidation="false" runat="server" CssClass="link" CommandName="Delete">Delete</asp:LinkButton></td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:DataList>
            </div>
        </td>
    </tr>
</table>
