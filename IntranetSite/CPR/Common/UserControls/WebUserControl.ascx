<%@ Control Language="C#" AutoEventWireup="true" CodeFile="WebUserControl.ascx.cs" Inherits="CPR_Common_UserControls_WebUserControl" %>
  <asp:fileupload ID="Fileupload1" runat="server" EnableViewState="true"></asp:fileupload>
        <asp:Button ID="Button1d" runat="server" Text="Button" OnClick="Button1_Click" />
        
        <asp:Button ID="btn" runat="server" Text="Button" OnClientClick="javascript:document.getElementById(this.id.replace('btn','Fileupload1')).click();return false;"  />