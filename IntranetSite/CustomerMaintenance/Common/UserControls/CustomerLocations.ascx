<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomerLocations.ascx.cs"
    Inherits="PFC.Intranet.Maintenance.Location" %>

<table  cellpadding="0" cellspacing="0" width="100%" class="blueBorder">
    <tr valign="middle">
        <td class="lightBlueBg">
            <asp:Label ID="lblInfo" CssClass="smallBanText" runat="server" Text="Locations"></asp:Label>
        </td>
        <td class="lightBlueBg" align="right">
            <asp:ImageButton ID="btnExpand" CausesValidation="false" runat="server" ImageUrl="~/customerMaintenance/Common/images/mExpand.gif"
                OnClick="btnExpand_Click" />
            <asp:ImageButton ID="btnCollapse" CausesValidation=false runat="server" ImageUrl="~/customerMaintenance/Common/images/Collapse.gif"
                OnClick="btnCollapse_Click" /> <asp:HiddenField ID="hidCustomerID" runat="server" /> </td>
    </tr>
    <tr>
        <td colspan="2" valign="top" >
        <div style="overflow-y:auto;overflow-x:auto;height:390px;position:relative;width:220px;" class="Sbar">
            <asp:TreeView ID="MenuFrameTV" runat="server" Width="100%" ExpandDepth=0 style="height:auto;">
                <RootNodeStyle CssClass="boldText" />
                <HoverNodeStyle BackColor="#E0F0FF " />
                <LeafNodeStyle CssClass="boldText" />
                <ParentNodeStyle CssClass="boldText" />
                <SelectedNodeStyle BackColor="#E0F0FF" />
            </asp:TreeView>
            </div>
        </td>
    </tr>
</table>      
 
