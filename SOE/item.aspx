<%@ Page Language="C#" AutoEventWireup="true" CodeFile="item.aspx.cs" Inherits="item" %>

<%@ Register Src="Common/UserControls/ItemControl.ascx" TagName="ItemControl"
    TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/ItemFamily.ascx" TagName="ItemFamily" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title> 
    <script src="Common/JavaScript/ItemBuilder.js" type="text/javascript"></script>

    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="SMOrderEntry" runat="server" EnablePartialRendering="true">
            </asp:ScriptManager>
   <%-- <div>
      <asp:UpdatePanel UpdateMode="Conditional" ID="pnlItem" runat="server">
                                        <ContentTemplate>
        <uc1:WSItemControl ID="WSItemControl" runat="server" /></ContentTemplate></asp:UpdatePanel>
    </div>
         <asp:UpdatePanel UpdateMode="Conditional" ID="pnlFamily" runat="server">
                                        <ContentTemplate>
        <uc2:WSItemFamily ID="WSItemFamily" runat="server" OnItemClick="UpdateItemLookup" /></ContentTemplate></asp:UpdatePanel>--%>
        
        <table cellpadding="0" cellspacing="0" id="tblGrid" height="height: 320px" width="100%">
                            <tr>
                                <td valign="top" align="left" id="TDFamily" runat="server" style="display: none;">
                                    <asp:UpdatePanel UpdateMode="Conditional" ID="FamilyPanel" runat="server">
                                        <ContentTemplate>
                                            <uc1:ItemFamily ID="UCItemFamily" runat="server" OnItemClick="UpdateItemLookup" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td valign="top" width="100%">
                                    <table cellpadding="0" border="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td valign="top" id="TDItem" runat="server" style="display: none;">
                                                <asp:UpdatePanel UpdateMode="Conditional" ID="ControlPanel" runat="server">
                                                    <ContentTemplate>
                                                        <uc2:ItemControl ID="UCItemLookup" OnPackageChange="ItemControl_OnPackageChange"
                                                            OnChange="ItemControl_OnChange" runat="server" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr></tr></table></td></tr></table>
                                            <asp:UpdatePanel ID="pnlLineDtl" runat="server" UpdateMode="conditional">
                            <ContentTemplate> <asp:HiddenField ID="hidShowHide" runat="server" />
                                            <asp:ImageButton ID="imgShowItemBuilder" ImageUrl="~/Common/Images/showitembuilder.gif"
                                                runat="server" AlternateText="Show Item Builder" OnClick="imgShowItemBuilder_Click"
                                                OnClientClick="Javascript:document.getElementById('TDFamily').style.display='';SetGridHeight('ItemFamily');return true;" /><asp:ImageButton ID="ibtnHide" ImageUrl="~/Common/Images/hideitembuilder.gif" runat="server"
                                                AlternateText="Hide Item Builder" OnClick="ibtnHide_Click" OnClientClick="Javascript:document.getElementById('TDFamily').style.display='none';SetGridHeight('ItemFamily');return true;"
                                                Visible="false" /></ContentTemplate></asp:UpdatePanel>
    </form>
</body>
</html>
