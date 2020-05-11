<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CommentEntry.aspx.cs" Inherits="CommentEntry" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc3" %>

<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE- Comment Entry</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <script>
    function CloseForm()
    {
        if (window.opener.parent.bodyFrame != null)
        {
            window.opener.parent.bodyFrame.document.getElementById("btnCheckExpComment").click();            
        }
        window.close();
    }
    </script>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1"  AsyncPostBackTimeout ="360000"  EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%;"
            class="HeaderPanels">
            <tr>
                <td>
                    <uc1:SoHeader ID="SoHeader" runat="server"></uc1:SoHeader>
                </td>
            </tr>
            <tr>
                <td class="lightBg" style="vertical-align: top; padding-bottom: 3px; padding-top: 3px;
                    padding-left: 5px">
                    <asp:UpdatePanel ID="upCommentEntry" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="1" width="75%" align="center" style="padding-top: 5px;
                                            padding-bottom: 1px;">
                                            <tr>
                                                <td style="font-weight: bold;">
                                                    Type
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlType" AutoPostBack="true" CssClass="lbl_whitebox" runat="server"
                                                        Height="20" Width="130" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="font-weight: bold;">
                                                    Sequence:
                                                </td>
                                                <td>
                                                    <%--  <asp:DropDownList ID="ddlSequence" CssClass="lbl_whitebox" runat="server" Height="20"
                                                        Width="50">
                                                    </asp:DropDownList>--%>
                                                    <asp:Label ID="lblSequence" runat="server" Text="" Width="30px"></asp:Label>
                                                </td>
                                                <td style="font-weight: bold;">
                                                    Form
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlFrom" CssClass="lbl_whitebox" runat="server" Height="20"
                                                        Width="130">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="8">
                                                    <table cellpadding="5" cellspacing="0" width="90%">
                                                        <tr>
                                                            <td style="font-weight: bold; padding-left: 0;">
                                                                Standard Comments</td>
                                                            <td align="left" style="padding-top: 5; padding-bottom: 5px;">
                                                                <asp:DropDownList ID="ddlStdComment" AutoPostBack="true" CssClass="lbl_whitebox"
                                                                    runat="server" Height="20" Width="302px" OnSelectedIndexChanged="ddlStdComment_SelectedIndexChanged">
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="font-weight: bold; padding-left: 0;" valign="top">
                                                                Comments
                                                                <asp:HiddenField ID="hidCommID" runat="server" />
                                                            </td>
                                                            <td align="left">
                                                                <asp:TextBox ID="txtComment" MaxLength="255" CssClass="Sbar lbl_whitebox" runat="server"
                                                                    Width="295px" TextMode="MultiLine" Height="70"></asp:TextBox>
                                                                <asp:RequiredFieldValidator ID="rfvComment" runat="server" ForeColor="red" ControlToValidate="txtComment"
                                                                    ErrorMessage="  *"></asp:RequiredFieldValidator>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="middle" colspan="8" style="padding-right: 5px;">
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td align=left style="padding-left:82px;">&nbsp;
                                        <asp:Label ID="lblItemCaption" runat="server" Text="Item #" Width="40px" Font-Bold="True" Visible=false></asp:Label></td>
                                                <td align=left style="padding-left:0px;">
                                        <asp:Label ID="lblItemDesc" runat="server" Width="200px" Visible=false></asp:Label></td>
                                                <td style="width: 100px">
                                                    <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/Save.jpg"
                                            OnClick="ibtnSave_Click" /></td>
                                            </tr>
                                        </table>
                                        &nbsp;</td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upFilter" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="2" width="100%" align="center">
                                <tr>
                                    <td align="center" width="10%" style="padding-left: 25px;">
                                        <asp:DropDownList ID="ddlFilter" AutoPostBack="true" CssClass="lbl_whitebox" runat="server"
                                            Height="20" Width="120px" OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="font-weight: bold; padding-left: 15px;">
                                        <asp:CheckBox ID="chkComment" runat="server" Text="Deleted Comments" OnCheckedChanged="chkComment_CheckedChanged"
                                            AutoPostBack="true" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upCommentGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 195px; border: 1px solid #88D2E9;
                                width: 705px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvComment" PagerSettings-Visible="false"
                                    Width="750" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                    AutoGenerateColumns="false" OnRowCommand="gvComment_RowCommand" OnSorting="gvComment_Sorting"
                                    OnRowDataBound="gvComment_RowDataBound">
                                    <HeaderStyle HorizontalAlign="center" CssClass="GridHead" Font-Bold="true" BackColor="#DFF3F9" />
                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                    <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="25px" BorderWidth="1px" />
                                    <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="25px" BorderWidth="1px" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                    Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"pSOCommID") %>'>Edit</asp:LinkButton>
                                                <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                    Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                    CommandName="Deletes" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"pSOCommID" )%>'>Delete</asp:LinkButton>
                                            </ItemTemplate>
                                            <ItemStyle Width="90px" />
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="Type" DataField="Type" SortExpression="Type" ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Line No" DataField="CommLineNo" SortExpression="CommlineNO"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Comment" DataField="CommText" SortExpression="CommText"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="220px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Form" DataField="FormsCd" SortExpression="FormsCd" ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Sequence No" DataField="CommLineSeqNo" SortExpression="CommLineSeqNo"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="40px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Change Date" DataField="ChangeDt" SortExpression="ChangeDt"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="70px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" SortExpression="ChangeID"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Deleted Date" DataField="DeleteDt" ItemStyle-ForeColor="red"
                                            SortExpression="DeleteDt" ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="90px" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                <input id="hidIsCommentAvailable" type="hidden" value="false" name="Hidden1" runat="server">
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="left" width="89%">
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
                                    <td>
                                        <td>&nbsp;</td>
                                            <td colspan = 4><uc3:PrintDialogue ID="PrintDialogue1" runat="server" /></td>
                                    
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
             <tr>                
                <td align=right style="padding-right:5px;">
                    <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:CloseForm()" /></td>
                <td>
                
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Comment Entry" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
