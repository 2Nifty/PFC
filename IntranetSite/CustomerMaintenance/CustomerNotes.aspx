<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerNotes.aspx.cs" Inherits="Notes" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/subFooter.ascx" TagName="Footer" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>SOE - Customer Notes</title>
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
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlContactEntry" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%;
                    height: 100%">
                    <tr>
                        <td class="lightBg" style="padding: 5px;">
                            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" style="padding-left: 5px">
                                        <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Customer No:" Width="80px"></asp:Label></td>
                                    <td align="left">
                                        <asp:Label ID="lblCustNumber" runat="server" Font-Bold="False" CssClass="lblBluebox"
                                            Width="70px"></asp:Label>
                                    </td>
                                    <td>
                                    </td>
                                    <td align="right">
                                        <asp:Label ID="Label18" runat="server" Font-Bold="True" Text="Notes Type" Width="117px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:UpdatePanel ID="upType" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:DropDownList ID="ddlType" AutoPostBack="true" CssClass="lbl_whitebox" runat="server"
                                                    Height="20" Width="130" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                    <td>
                                    </td>
                                    <td width="35%" align="right">
                                        <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="~/Common/Images/help.gif" />
                                        <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="lightBg" style="vertical-align: top; padding-bottom: 5px; padding-top: 5px;
                            padding-right: 5px; padding-left: 5px">
                            <asp:UpdatePanel ID="upTaxEntry" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <table cellpadding="1" cellspacing="0" width="100%" class="data" border="0" bordercolor="#efefef">
                                        <tr>
                                            <td align="left" width="625px">
                                                <asp:TextBox ID="txtNotes" CssClass="lbl_whitebox" runat="server" Width="580" TextMode="MultiLine"
                                                    Height="70" onfocus="javascript:textCheck(this);" onkeypress="javascript:textCounter(this);"
                                                    Text="Enter Notes Here..."></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvComment" runat="server" ForeColor="red" ControlToValidate="txtNotes"
                                                    ErrorMessage="  *"></asp:RequiredFieldValidator>
                                            </td>
                                            <td valign="top" align="right" style="padding-right: 5px;">
                                                <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/btnSave.gif"
                                                    OnClick="ibtnSave_Click" />
                                                    <asp:HiddenField ID="hidNotesID" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:UpdatePanel ID="upTaxGrid" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                        overflow-y: auto; position: relative; top: 0px; left: 0px; height: 320px; border: 1px solid #88D2E9;
                                        width: 705px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                        scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                        scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                        <asp:DataList ID="dlNotes" runat="server" ItemStyle-VerticalAlign="Top" ItemStyle-HorizontalAlign="Left"
                                            RepeatDirection="Vertical" RepeatColumns="1">
                                            <ItemStyle CssClass="item" Wrap="true" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                            <ItemTemplate>
                                                <table cellpadding="3" cellspacing="0" border="0">
                                                    <tr>
                                                        <td valign="top">
                                                            <asp:Label Width="75px" ID="lblDate" runat="server" Text='<%#DataBinder.Eval(Container,"DataItem.EntryDt")%>'
                                                                Visible="true"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label Width="600px" ID="lblNotes" runat="server" Text=<%#DataBinder.Eval(Container,"DataItem.Notes") + "  <span style='font-style :italic; color :Red' > by " + DataBinder.Eval(Container,"DataItem.EntryID") + "</span >" %>
                                                                Visible="true"></asp:Label>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                            style="height: 20px; background-position: -80px  left;">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="left" width="87%">
                                        <asp:UpdateProgress ID="upPanel" runat="server">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:UpdatePanel ID="upProgress" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:Footer ID="Footer1" Title="Notes" runat="server"></uc2:Footer>
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
