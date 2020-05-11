<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderEntryHeader.ascx.cs" Inherits="Common_UserControls_Header" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
            <tr>
                <td class="TabHead" width="12%" colspan="2"><strong>Customer Number</strong></td>
                <td class="" width="12%"  colspan="2">
                    <asp:TextBox ID="txtCustNo" CssClass="cnt" onkeypress="javascript:return ValdateNumbers();"
                        Width="100px" runat="server" onblur="javascript:BindCustomerDetail();"></asp:TextBox>
                                       <asp:Button ID="btnLoadCustomer" runat="server" Style="display: none;" Text="Bill To" OnClick="btnLoadCustomer_Click" />
                    <asp:HiddenField ID="hidCust" runat="server" />
                    <asp:RequiredFieldValidator ID="rqvCustNo" runat="server" ControlToValidate="txtCustNo"
                        CssClass="cnt" Display="Dynamic" ErrorMessage="* Required"></asp:RequiredFieldValidator></td>
                <td class="TabHead" style="border-left:1px Solid #8BD3E9;" width="5%" valign="top" rowspan="4">
                    <asp:LinkButton CssClass="TabHead bold" ID=lnkBillTo Text="Sold To:" runat=server OnClientClick="Javascript:document.getElementById('CustDet_hidCurrentControl').value=this.id;CallBtnClick('CustDet_btnGetDetails');return false;"></asp:LinkButton>
                    </td>
                <td rowspan="4" width="20%" colspan="2">                
                    <asp:Label ID="lblBill_Name" runat="server"></asp:Label><br />
                    <asp:Label ID="lblBill_Contact" runat="server"></asp:Label>
                    <asp:Label ID="lblBill_City" runat="server"></asp:Label><asp:Label ID="lblBillCom" runat="server" Text=","></asp:Label><asp:Label ID="lblBill_Territory" runat="server"></asp:Label>&nbsp;<asp:Label ID="lblBill_Pincode" runat="server"></asp:Label><br />
                    <asp:Label ID="lblBill_Phone" runat="server"></asp:Label>
                </td>
                <td class="TabHead" valign="top" width="5%" rowspan="4">
                    <strong><asp:LinkButton ID=lnkShipTo runat=server Text="Ship To:" CssClass="TabHead bold" OnClientClick="Javascript:document.getElementById('CustDet_hidCurrentControl').value=this.id;CallBtnClick('CustDet_btnGetDetails');return false;"></asp:LinkButton></strong></td>
                <td style="border-right:1px Solid #8BD3E9;" rowspan="4" colspan="2" width="20%">
                    <asp:Label ID="lblShip_Name" runat="server"></asp:Label><br />
                    <asp:Label ID="lblShip_Contact" runat="server"></asp:Label>
                    <asp:Label ID="lblShip_City" runat="server"></asp:Label><asp:Label ID="lblShipCom" runat="server" Text=","></asp:Label><asp:Label ID="lblShip_Territory" runat="server"></asp:Label>&nbsp;<asp:Label ID="lblShip_Pincode" runat="server"></asp:Label><br />
                    <asp:Label ID="lblShip_Phone" runat="server"></asp:Label>
                </td>
                <td class="TabHead" width="15%" style="padding-left:25px"  colspan="2"><asp:LinkButton ID=lnkUsage runat=server Text="Usage Location:" CssClass="TabHead bold" OnClientClick="Javascript:document.getElementById('CustDet_hidCurrentControl').value=this.id;CallBtnClick('CustDet_btnGetDetails');return false;"></asp:LinkButton></td>
                <td class="cnt" width="8%" align=left style="padding-left:9px">
                   <asp:Label ID=lblUsageLoc CssClass="lbl_whitebox" runat=server Text=""/></td>
            </tr>
            <tr>
                <td class="TabHead bold"  colspan="2">
                    Sales Order Number</td>
                <td class="cnt" colspan="2">
                   <asp:TextBox ID="txtSONumber" CssClass="cnt" onfocus="javascript:document.getElementById('CustDet_hidPreviousValue').value=this.value;" Width="100px" onblur="javascript:LoadDetails(this.value);" onkeydown="javascript:return KeyEvent(this.value);" runat="server"></asp:TextBox>
                    <asp:HiddenField ID=hidPreviousValue runat=server />
                    <asp:Button ID=btnLoadAll runat=server style="display:none;" CausesValidation="false" OnClick="btnLoadAll_Click"></asp:Button>
                </td>
                <td class="TabHead bold" style="padding-left:25px" colspan="2">
                   <asp:Label ID=lblSalesHead Text="Total Sales $:" runat=server ></asp:Label> </td>
                <td class="" align=left style="padding-left:9px" colspan="2">
                   <asp:Label ID=lblSales CssClass="lbl_whitebox" runat=server Text=""></asp:Label>                   
                    </td>
            </tr>
            <asp:UpdatePanel ID="upContext" runat="server" UpdateMode=Conditional>
                                <ContentTemplate>
                    <div id="divTool" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
                                word-break: keep-all; position: absolute;">
                                        
                                <table width="20%" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                                    class="MarkItUp_ContextMenu_Outline">
                                    <tr>
                                        <td class="bgmsgboxtile">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="90%" class="txtBlue">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bgtxtbox">
                                            <table width="100%" border="0" cellspacing="0">
                                                <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                    class="MarkItUp_ContextMenu_MenuItem">
                                                    <td>
                                                        <asp:ListBox CssClass="cnt Sbar" AutoPostBack="true" Width="200px" ID="lstDetails"
                                                            runat="server" OnSelectedIndexChanged="lstDetails_SelectedIndexChanged" ></asp:ListBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Button Style="display: none;" ID="btnGetDetails" runat="server" Text="" OnClick="btnGetDetails_Click" />
                                                        <asp:HiddenField ID="hidCurrentControl" Value="" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>  
                            </div>
                      </ContentTemplate>
                    </asp:UpdatePanel>                 
                            
                      