<%@ Control Language="C#" AutoEventWireup="true" CodeFile="VendorSearch.ascx.cs"
    Inherits="PFC.Intranet.VendorMaintenance.VendorSearch" %>

<asp:Panel ID="Panel1" runat="server" Width="100%" DefaultButton="btnSearch">   <table width="100%" class="shadeBgDown">
            <tr>
                <td class="Left2pxPadd DarkBluTxt boldText" width="12%">
                    <asp:Label ID="lblSch" runat="server" Text="Vendor Search"></asp:Label>
                </td>
                <td valign="middle">
                    <table>
                        <tr>
                            <td>
                                <asp:TextBox AutoCompleteType=disabled MaxLength=10 onkeyup="javascript:BindDDLVendor(this);" onkeypress="javascript:if(event.keycode==13){if(document.getElementById('divSearch')!=null)document.getElementById('divSearch').style.display = 'none';if(this.value.replace(/\s/g,'')!='')document.getElementById(this.id.replace('txtVendor','btnSearch')).click();return false;}" ID="txtVendor" runat="server"
                                    CssClass="FormCtrl" onblur="javascript:if(IsNumeric(this.value)){document.getElementById(this.id.replace('txtVendor','hidVendor')).value=this.valie}else {document.getElementById(this.id.replace('txtVendor','hidVendor')).value='';}" Width="150px"></asp:TextBox><br /><asp:HiddenField ID=hidVendor runat=server />
                                <div id="divSearch" style="position: absolute; display: none;">
                                    <asp:ListBox ID="lstVendor" onkeypress="javascript:if(event.keyCode==13){LstVendorClick(this.id);}" onclick="Javascript:LstVendorClick(this.id);"
                                        runat="server" CssClass="FormCtrl list" Width="158px" Height="150px"></asp:ListBox>
                                </div>
                            </td>
                            <td></td>
                            <td>
                                <asp:HiddenField ID="hidSearchMode" runat="server" Value="" />
                                <asp:HiddenField ID=hidType runat=server />
                                <asp:HiddenField ID=hidAddrID runat=server />
                                <asp:HiddenField ID=hidParentAddID runat=server />
                                <input type="hidden" id="hidVenType" value=""/>
                                <%--<asp:ImageButton ID="btnSearch"  OnClientClick="javascript:return CheckLock(this.id);" runat="server" ImageUrl="~/VendorMaintenance/Common/images/search.jpg" OnClick="btnSearch_Click" CausesValidation="False" />--%>
                                <asp:Button ID="btnSearch" Width="70px" Height=23 OnClientClick="javascript:return CheckLock(this.id);" runat="server" Text="" style="background-image:url(Common/images/Search.jpg);background-color:Transparent;border:none;cursor:hand;" OnClick="btnSearch_Click" CausesValidation="False" />
                            </td>
                           
                        </tr>
                    </table> 
                </td>
                <td class="Right2pxPadd" align="right">
                    <asp:ImageButton ID="btnAdd" runat="server" OnClientClick="javascript:return PromptNewVendor(this.id);"  CausesValidation="false" ImageUrl="~/VendorMaintenance/Common/images/newAdd.gif"
                        OnClick="btnAdd_Click" />
                    <asp:ImageButton ID="btnUpdate" OnClientClick="javascript:return CheckLock(this.id.replace('btnUpdate','btnSearch'));" runat="server" ImageUrl="~/VendorMaintenance/Common/images/edit.gif" CausesValidation="False" OnClick="btnUpdate_Click" />
                     <asp:ImageButton ID="ibtnDelete" runat="server"  CausesValidation="false" ImageUrl="~/VendorMaintenance/Common/images/BtnDelete.gif"
                        OnClientClick="javascript:return DeleteVendor(this);" OnClick="btnDelete_Click" />
                  
                    <asp:ImageButton ID="btnHelp" runat="server" ImageUrl="~/VendorMaintenance/Common/images/help.gif" CausesValidation="False" OnClientClick="javascript:LoadHelp();return false;" />
                    <asp:ImageButton ID="btnClose" ImageUrl="~/VendorMaintenance/Common/images/close.jpg"
                        runat="server" OnClientClick="javascript:window.close();" CausesValidation="False" />
                </td>
            </tr>
        </table>
</asp:Panel><script language="javascript">if(document.getElementById('divSearch')!=null)document.getElementById('divSearch').style.display = 'none';</script>


     
    
