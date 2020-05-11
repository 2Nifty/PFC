<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CommonLink.ascx.cs" Inherits="PFC.POE.UserControls.CommonLink" %>
        
<td style="word-break:keep-all;height:25px;" >
    &nbsp;<asp:LinkButton ID="lbtnLink" Font-Bold="True" runat="server" ></asp:LinkButton>
</td>            
<td class="" align="left">
     <asp:TextBox ID="lblValue" runat="server" onfocus="javascript:this.select();" CssClass="lbl_whitebox"  
         Text=""></asp:TextBox>
    <asp:HiddenField ID="hidMode" runat="server" />
</td>