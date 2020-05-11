<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostBasis.aspx.cs" Inherits="CostBasisPage" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/subFooter.ascx" TagName="Footer" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Cost Basis</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>

    <script>
    //--------------------------------------------------------------------------------------
    function textCounter() 
    {
        var maxlimit=254;
        var txtMax=document.getElementById("txtNotes").value;
        if (txtMax.length > maxlimit) // if too long...trim it!
            document.getElementById("txtNotes").value=document.getElementById("txtNotes").value.substring(0, maxlimit-1);
        
    } 
    //--------------------------------------------------------------------------------------
     function textCheck() 
    {
        var txtMax=document.getElementById("txtNotes").value;
        
        if (txtMax == "Enter Notes Here...") // if too long...trim it!
            document.getElementById("txtNotes").value="";
      
    }
    //--------------------------------------------------------------------------------------     
    </script>

</head>
<body  >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlContactEntry" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 400px;
                    height: 100%">
                    <tr>
                        <td class="lightBg" style="padding: 5px;padding-top:10px;">
                            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" style="padding-left: 5px">
                                        <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Customer No:" Width="80px"></asp:Label></td>
                                    <td align="left">
                                        <asp:Label ID="lblCustNumber" runat="server" Font-Bold="False" CssClass="lblBluebox"
                                            Width="121px"></asp:Label>
                                    </td>
                                    <td width="35%" align="right">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 5px">
                                        <asp:Label ID="Label18" runat="server" Font-Bold="True" Text="Cost Basis:" Width="77px"></asp:Label></td>
                                    <td align="left">
                                        &nbsp;<asp:DropDownList ID="ddlCostBasis" AutoPostBack="true" CssClass="lbl_whitebox" runat="server"
                                                    Height="20" Width="130">
                                                </asp:DropDownList></td>
                                    <td align="right" width="35%">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="padding-left: 5px">
                                    </td>
                                    <td align="left">
                                        <table border="0" cellpadding="0" cellspacing="3">
                                            <tr>
                                                <td style="width: 100px">
                                                <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/btnSave.gif"
                                                    OnClick="ibtnSave_Click" /></td>
                                                <td style="padding-left: 5px; width: 100px">
                                                    <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td align="right" width="35%">
                                                </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="lightBg" style="vertical-align: top; padding-bottom: 5px; padding-top: 5px;
                            padding-right: 5px; padding-left: 5px">
                            <asp:UpdatePanel ID="upProgress" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <asp:Label ID="lblMessage" runat="server" CssClass="Tabhead" Font-Bold="True" ForeColor="Green"></asp:Label>
                                </ContentTemplate>
                            </asp:UpdatePanel>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:Footer ID="Footer1" Title="Cost Basis" runat="server"></uc2:Footer>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script>
self.focus();
    </script>

</body>
</html>
