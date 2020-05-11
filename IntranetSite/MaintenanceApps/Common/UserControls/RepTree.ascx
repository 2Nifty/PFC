<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RepTree.ascx.cs" Inherits="RepTree" %>
<table cellpadding="0" cellspacing="0" border="0" width="100%" >
    <tr>
        <td>
            <div style="overflow-y: auto; overflow-x:auto; height: 475px; position:relative; width: 290px" class="Sbar">
                <asp:TreeView ID="MenuFrameTV" runat="server" Width="99%" ExpandDepth="0"
                    ExpandImageToolTip="Expand" CollapseImageToolTip="Collapse">
                    <RootNodeStyle CssClass=" DarkBluTxt boldText LeafStyle" />
                    <HoverNodeStyle BackColor="#E0F0FF" />
                    <LeafNodeStyle CssClass="Left2pxPadd DarkBluTxt boldText LeafStyle" 
                        VerticalPadding="2px" />
                    <ParentNodeStyle CssClass=" DarkBluTxt boldText" />
                    <SelectedNodeStyle BackColor="#E0F0FF" />
                </asp:TreeView>
                <asp:HiddenField ID="hidLeftFrameBindMode" runat="server" />                
            </div>
        </td>
    </tr>
</table>
