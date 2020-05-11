<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemControl.ascx.cs" Inherits="ItemControl" %>

 
<table cellpadding="0" height=50px width=100% style="border-top-width:1px;border:1px solid #88D2E9;" bgcolor="#ECF9FB">
    <tr>
        <td valign="top">
            <table border="0" cellpadding="0" cellspacing="0" class="BorderAll">
                <tr class="PagecontrolHd" width="100%">
                    <td>
                        <table cellpadding="0" cellspacing="0">                            
                            <tr>
                                <td>
                                    <asp:Label ID="lblProductLine" runat="server" style="padding-left:10px" CssClass="TabHead" Text="Product Line"></asp:Label><asp:HiddenField id=hidResetFlag runat=server /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList EnableViewState="true" ID="ddlProductLine" Width=100  CssClass="cnt"
                                        AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlProductLine_SelectedIndexChanged"
                                        onclick="javascript:OnDropDownClick(this.id);">
                                    </asp:DropDownList> <asp:HiddenField ID=hidProductLine runat=server />       </td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="divProductLine" style="position: absolute;z-index:99;">
                                        <asp:ListBox EnableViewState="true" ID="lstProductLine" Width=100  CssClass="cnt"
                                            AutoPostBack="true" runat="server" OnSelectedIndexChanged="lstProductLine_SelectedIndexChanged">
                                        </asp:ListBox></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0">                           
                            <tr>
                                <td>
                                    <asp:Label ID="lblCategory" CssClass="TabHead" style="padding-left:10px" runat="server" Text="Category"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlCategory"  runat="server" Width=280px CssClass="cnt"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"
                                        onclick="javascript:OnDropDownClick(this.id);">
                                    </asp:DropDownList><asp:HiddenField ID="hidCategory" runat=server /></td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="divCategory" style="position: absolute;z-index:99;">
                                        <asp:ListBox ID="lstCategory" Height="330px" Width=280px  CssClass="cnt" AutoPostBack="true"
                                            runat="server" OnSelectedIndexChanged="lstCategory_SelectedIndexChanged"></asp:ListBox></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            
                            <tr>
                                <td>
                                    <asp:Label ID="lblDiameter" CssClass="TabHead" style="padding-left:10px" runat="server" Text="Diameter"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlDiameter"  runat="server" Width=80px AutoPostBack="true"
                                        CssClass="cnt" OnSelectedIndexChanged="ddlDiameter_SelectedIndexChanged"
                                        onclick="javascript:OnDropDownClick(this.id);" >
                                    </asp:DropDownList><asp:HiddenField ID="hidDiameter" runat=server /></td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="divDiameter" style="position: absolute;z-index:99;">
                                        <asp:ListBox ID="lstDiameter"  Height="200px" Width=80px CssClass="cnt" AutoPostBack="true"
                                            runat="server" OnSelectedIndexChanged="lstDiameter_SelectedIndexChanged"></asp:ListBox></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            
                            <tr>
                                <td>
                                    <asp:Label ID="lblLength" CssClass="TabHead" style="padding-left:10px" runat="server" Text="Length"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlLength"  runat="server" Width=60px AutoPostBack="true"
                                        CssClass="cnt" OnSelectedIndexChanged="ddlLength_SelectedIndexChanged" onclick="javascript:OnDropDownClick(this.id);">
                                    </asp:DropDownList><asp:HiddenField ID="hidLength" runat=server /></td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="divLength" style="position: absolute;z-index:99;">
                                        <asp:ListBox ID="lstLength"  Height="330px" Width=60px CssClass="cnt" AutoPostBack="true"
                                            runat="server" OnSelectedIndexChanged="lstLength_SelectedIndexChanged"></asp:ListBox></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            
                            <tr>
                                <td>
                                    <asp:Label ID="lblPlating" CssClass="TabHead" style="padding-left:10px" runat="server" Text="Plating"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlPlating" Width=60px runat="server" AutoPostBack="true"
                                        CssClass="cnt" OnSelectedIndexChanged="ddlPlating_SelectedIndexChanged"
                                        onclick="javascript:OnDropDownClick(this.id);">
                                    </asp:DropDownList><asp:HiddenField ID="hidPlating" runat=server /></td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="divPlating" style="position: absolute;z-index:99;">
                                        <asp:ListBox ID="lstPlating" Width=60px Height="200" CssClass="cnt" AutoPostBack="true"
                                            runat="server" OnSelectedIndexChanged="lstPlating_SelectedIndexChanged"></asp:ListBox></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td >
                        <table cellpadding="0" cellspacing="0">
                            
                            <tr>
                                <td>
                                    <asp:Label ID="lblPackage" CssClass="TabHead" style="padding-left:10px" runat="server" Text="Package"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlPackage" Width=80px OnSelectedIndexChanged="ddlPackage_SelectedIndexChanged"
                                        runat="server" onkeypress="ShowItem(document.frNewQuote.UCItemLookup_btnGetItem);"
                                        CssClass="cnt" onchange="LoadItemValue(this)" AutoPostBack="true" onclick="javascript:document.getElementById('divPackage').style.display='none';">
                                    </asp:DropDownList></td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="divPackage" style="position: absolute;z-index:99;">
                                        <asp:ListBox  ID="lstPackage" Width=80px Height="200" OnSelectedIndexChanged="lstPackage_SelectedIndexChanged"
                                            CssClass="cnt" AutoPostBack="true" runat="server"></asp:ListBox></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign=middle>
                    
                        <table cellpadding="0" cellspacing="0">
                            
                            <tr><td>&nbsp;</td>
                            </tr>
                            <tr>
                               <td> 
                                    &nbsp;&nbsp;<img src="../../Common/images/getitem.gif" id="btnGetItem" alt="Get Item Detail" style="cursor: hand;"
                            onclick="GetItemLookup(this);" runat="server" />&nbsp;<asp:ImageButton ID="ibtnReset" runat="server"
                                CausesValidation="false" OnClientClick="HideUserControl();" OnClick="ibtnReset_Click"  ToolTip="Reset item builder selections" ImageUrl="../../Common/images/reset.gif" />
                        <asp:Button ID=btnPost style="display:none;" runat=server OnClick="btnClick_Click" CausesValidation=false /> <asp:HiddenField ID=hidControlName runat=server /> 
                               </td>
                            </tr>
                            <tr><td><div id="div1" style="position: absolute;z-index:99;">&nbsp;</div></td></tr>
                        </table>
                        
                        
                    </td>
                </tr>
            </table>
            
        </td>
    </tr>
    
    
</table>
