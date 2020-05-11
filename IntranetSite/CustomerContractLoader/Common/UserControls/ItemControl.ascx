<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemControl.ascx.cs" Inherits="PFC.Intranet.ItemControl" %>
<table width="100%" border="0px" cellpadding="0" cellspacing="0px">
    <tr>
        <td>
            <table width="100%" class="HeaderPanels" height=20px border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="padding-left: 6px;">
                        <asp:Table ID="HeadTable" runat="server">
                            <asp:TableRow>
                                <asp:TableCell HorizontalAlign="Center">
                                    <asp:Image ID="HeadImage" runat="server" Height="75px" />
                                </asp:TableCell>
                                <asp:TableCell>
                                    <asp:Image ID="BodyImage" runat="server" />
                                </asp:TableCell>
                            </asp:TableRow>
                        </asp:Table>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="height: 20px">
                                    <asp:Label Font-Bold="true" Font-Size="Larger" ID="lblProduct" runat="server" Visible="false"
                                        Text="Label"></asp:Label>
                                    <asp:Label ID="lblCategoryItem" Font-Bold="true" Font-Size="Larger" runat="server"
                                        Visible="false" Text="Label"></asp:Label>
                                </td>
                                <td style="height: 20px">
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 20px">
                                    <asp:Label ID="imageDescription" runat="server"></asp:Label>
                                </td>
                                <td style="padding-left: 5px; height: 20px">
                                        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                        <ProgressTemplate>
                                            <span><strong>Loading...</strong></span>
                                        </ProgressTemplate>
                                        </asp:UpdateProgress>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td align="right" valign="top" style="padding-right: 10px">
                        <asp:Panel ID="pnlitem" DefaultButton="btnEmpty" runat="server">
                            <table id="tblResult" runat="server">
                                <tr>
                                    <td style="width: 100px">
                                        <asp:Button UseSubmitBehavior="false" CausesValidation="false" Width="100px" ID="btnPlating"
                                            CssClass="frmBtn" runat="server" Text="Plating" OnClick="btnPlating_Click" />
                                    </td>
                                    <td >
                                        <asp:Button UseSubmitBehavior="false" CausesValidation="false" Width="100px" ID="btnPackage"
                                            CssClass="frmBtn" runat="server" Text="Package" OnClick="btnPackage_Click" />
                                    </td>
                                    <td>
                                        <asp:Button UseSubmitBehavior="false" CausesValidation="false" Width="100px" CssClass="frmBtn"
                                            ID="btnGetResults" runat="server" Text="Reset" OnClick="btnGetResults_Click" />
                                    </td>
                                    <td>
                                        <asp:Button ID="btnEmpty" Width="0" Height="0" Text="empty" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:ListBox Width="100px" ID="lstBoxPlating" runat="server" CssClass="ddlCtrl" Visible="False"
                                            AutoPostBack="True" OnSelectedIndexChanged="lstBoxPlating_SelectedIndexChanged">
                                        </asp:ListBox>
                                    </td>
                                    <td valign="top">
                                        <asp:ListBox AutoPostBack="true" Width="100px" ID="lstBoxPackage" runat="server"
                                            CssClass="ddlCtrl" Visible="False" OnSelectedIndexChanged="lstBoxPackage_SelectedIndexChanged">
                                        </asp:ListBox>
                                    </td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="3">
                                        <asp:Label Style="text-align: left; padding-top: 20px;" Font-Bold="True" Visible="False"
                                            ForeColor="#BF0000" ID="lblQueryMessage" runat="server" Text="Your results are displayed below, create your cross-reference information by filling in your Item No."
                                            Width="364px"></asp:Label></td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%" valign="top" style="height: 15px; padding: 0px;">
            <table width="100%" border="0px" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <table id="tblProduct" border="0" cellpadding="0" cellspacing="0" width="100%" runat="server">
                            <tr>
                                <td>
                                    <div style="overflow-x: hidden; overflow-y: scroll; height: 595px; width: 100%; border: 1px solid #88D2E9;"
                                        class="Sbar">
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <asp:DataGrid Width="100%" GridLines="none" ShowHeader="false" ID="dgProductLine"
                                                        runat="server" EnableViewState="True" AllowPaging="false" PageSize="2" AutoGenerateColumns="false"
                                                        OnItemDataBound="dgProductLine_ItemDataBound">
                                                        <ItemStyle BorderColor="#4BBADE" Height="25px" />
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:HiddenField ID="hidProduct" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "PRODUCTLINE") %>' />
                                                                                <asp:Label Font-Bold="true" ID="lblProduct" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "PRODUCTLINEDESC") %>'></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="100%" style="padding-left: 30px;">
                                                                                <asp:DataList ID="dlProductItem" Width="100%" runat="server" OnItemDataBound="dlProductItem_ItemDataBound">
                                                                                    <ItemTemplate>
                                                                                        <table>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:HiddenField ID="hidCategoryID" Value='<%# DataBinder.Eval(Container.DataItem, "Category") %>'
                                                                                                        runat="server" />
                                                                                                    <asp:LinkButton Style="color: #003366" OnClick="lnkProductItem_Click" PostBackUrl='<%# "../../ItemBuilder.aspx?CategoryItem="+Server.UrlEncode( DataBinder.Eval(Container.DataItem, "Description").ToString())%>'
                                                                                                        ID="lnkProductItem" Text='<%# DataBinder.Eval(Container.DataItem, "Description") %>'
                                                                                                        runat="server"></asp:LinkButton>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </ItemTemplate>
                                                                                </asp:DataList>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle Visible="False"></PagerStyle>
                                                    </asp:DataGrid>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table id="Table1" border="0" cellpadding="0" cellspacing="0" visible="true" width="100%"
                            runat="server">
                            <tr>
                                <td align="center" style="padding-top: 20px;">
                                    <asp:Label ForeColor="red" Font-Bold="true" Height="20px" ID="lblMessage" Visible="false"
                                        runat="server" Text="No Data Found"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <table id="tblFilter" runat="server" border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="width: 90%;">
                                                <asp:DataGrid CssClass="grid" AutoGenerateColumns="false" GridLines="None" EnableViewState="True"
                                                    AllowPaging="True" PageSize="18" ID="dgFinalFilter" Visible="true" runat="server"
                                                    ShowHeader="true" Width="100%" OnItemDataBound="dgFinalFilter_ItemDataBound"
                                                    OnDeleteCommand="dgFinalFilter_DeleteCommand" OnEditCommand="dgFinalFilter_EditCommand">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" Height="20px" />
                                                    <AlternatingItemStyle CssClass="zebra" Height="20px" />
                                                    <Columns>
                                                    
                                                        <asp:BoundColumn DataField="ItemNo" HeaderText="PFC Item No."></asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Customer Item No." ItemStyle-Width="100">
                                                            <ItemTemplate>
                                                                <asp:TextBox onfocus="javascript:this.select();" onkeydown="ConvertKeyPress(this.id)"
                                                                    ID="txtCustomerNo" CssClass="formCtrl" Visible='<%# (DataBinder.Eval(Container,"DataItem.CrossRefNumber").ToString()=="")? true : false %>'
                                                                    MaxLength="40" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.CrossRefNumber") %>'
                                                                    AutoPostBack="True" OnTextChanged="txtCustomerNo_TextChanged"></asp:TextBox>
                                                                <asp:Label Width="140px" ID="lblCustomerNo" runat="server" Visible='<%# (DataBinder.Eval(Container,"DataItem.CrossRefNumber").ToString()=="")? false : true %>'
                                                                    Text='<%# DataBinder.Eval(Container,"DataItem.CrossRefNumber") %>'></asp:Label>   
                                                                <asp:Label Width="140px" ID="lblID" runat="server" Visible=false
                                                                    Text='<%# DataBinder.Eval(Container,"DataItem.pItemAliasID") %>'></asp:Label>                                                             
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="Description" HeaderText="Size Description"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Plating" HeaderText="Plating"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="Quantity" HeaderText="Quantity Per UM"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SuperEquivalent" HeaderText="Super Equivalent"></asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Actions">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="LinkButton1" runat="server" Text="Edit" Visible="true" ForeColor="green"
                                                                    Enabled='<%# (DataBinder.Eval(Container,"DataItem.CrossRefNumber").ToString()=="")? false : true %>'
                                                                    CommandName="Edit"></asp:LinkButton>
                                                                <asp:LinkButton ID="LinkButton2" Enabled='<%# (DataBinder.Eval(Container,"DataItem.CrossRefNumber").ToString()=="")? false : true %>'
                                                                    CommandName="Delete" runat="server" Text="Delete" Visible="true" ForeColor="red"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle Visible="False"></PagerStyle>
                                                </asp:DataGrid>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" class="PagerBk">
                                                <table id="tblFilterPager" runat="server">
                                                    <tr>
                                                        <td>
                                                            <asp:ImageButton ID="btnlast" ImageUrl="~/ItemBuilder/Common/Images/btnlasto.jpg"
                                                                runat="server" OnCommand="btnlast_Command" />
                                                        </td>
                                                        <td>
                                                            <asp:ImageButton ID="btnBack" ImageUrl="~/ItemBuilder/Common/Images/btnbacko.jpg"
                                                                runat="server" OnCommand="btnBack_Command" />
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="Label4" Text="Page" Font-Bold="true" runat="server" />
                                                        </td>
                                                        <td style="width: 83px">
                                                            <asp:DropDownList Visible="true" ID="ddlFinalFilter" runat="server" AutoPostBack="True"
                                                                Width="70" Height="20" CssClass="formCtrl" Style="text-align: right;" OnSelectedIndexChanged="ddlFinalFilter_SelectedIndexChanged">
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td>
                                                            <asp:ImageButton ID="btnForward" ImageUrl="~/ItemBuilder/Common/Images/btnforwardo.jpg"
                                                                runat="server" OnCommand="btnForward_Command" />
                                                        </td>
                                                        <td>
                                                            <asp:ImageButton ID="btnFirst" ImageUrl="~/ItemBuilder/Common/Images/btnfirsto.jpg"
                                                                runat="server" OnCommand="btnFirst_Command" />
                                                        </td>
                                                    </tr>
                                                </table>
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
                        <table id="Table2" border="0" cellpadding="0" cellspacing="0" width="100%" runat="server">
                            <tr>
                                <td align="right">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td style="width: 100px">
                                                <asp:Button Width="75px" ID="btnClose" CssClass="frmBtn" runat="server" Text="OK" Visible=false
                                                    OnClientClick="javascript:window.close();" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
