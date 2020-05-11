<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Locations.ascx.cs" Inherits="LeftFrame" %>
<table cellpadding="0" cellspacing="0" width="100%" >


    <tr>
        <td>
            <div style="overflow-y: auto; overflow-x: auto;  position: relative;height:440px;
                width: 290px;" class="Sbar">
                <asp:TreeView ID="MenuFrameTV" runat="server" Width="99%" ExpandDepth="0"
                    ExpandImageToolTip="Expand" CollapseImageToolTip="Collapse" >
                    <RootNodeStyle CssClass=" DarkBluTxt boldText" />
                    <HoverNodeStyle BackColor="#E0F0FF " />
                    <LeafNodeStyle CssClass="Left2pxPadd DarkBluTxt boldText LeafStyle"  />
                    <ParentNodeStyle CssClass=" DarkBluTxt boldText"  />
                    <SelectedNodeStyle BackColor="#E0F0FF" />
                </asp:TreeView>
              <asp:HiddenField ID="hidLocName" runat ="server" />
                <asp:Button ID="btnLocation" runat="server" Text="Location" CausesValidation="false" 
                 OnClick="btnLocation_Click" style="display:none ;" />  
                 
            </div>
        </td>
    </tr>
</table>
