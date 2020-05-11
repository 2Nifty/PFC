<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CommentEntry.aspx.cs" Inherits="CommentEntry" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>POE- Comment Entry</title>
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
    function OpenPreview()
    {
       var popUp=window.open ("Previewpage.aspx?PONumber="+'<%= Request.QueryString["PONumber"].ToString().Trim() %>',"POCommentEntryPreview",'height=450,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
         popUp.focus();
    }
    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
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
                                        <span style="font-weight: bold; text-decoration: underline;">Comment Settings</span>
                                        <span style="padding-left: 225px;">
                                            <asp:CheckBox ID="chkStandard" Checked="true" runat="server" AutoPostBack="True"
                                                OnCheckedChanged="chkStandard_CheckedChanged" /></span> <span style="font-weight: bold;
                                                    text-decoration: underline;">Standard</span> <span style="padding-left: 1px;">
                                                        <asp:CheckBox AutoPostBack="true" ID="chkVendor" runat="server" OnCheckedChanged="CheckBox2_CheckedChanged" /></span>
                                        <span style="font-weight: bold; text-decoration: underline;">Vendor Specific</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 10px;">
                                        <table cellpadding="1" cellspacing="1" width="98%" style="padding-top: 5px; padding-bottom: 1px;">
                                            <tr>
                                                <td style="font-weight: bold; width: 4px;">
                                                    Type
                                                </td>
                                                <td style="padding-left: 5px;">
                                                    <asp:DropDownList ID="ddlType" AutoPostBack="true" CssClass="lbl_whitebox" runat="server"
                                                        Height="20" Width="130" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="font-weight: bold; padding-left: 20px;">
                                                    Line No
                                                </td>
                                                <td style="padding-left: 10px;">
                                                    <asp:DropDownList ID="ddlLineNo" CssClass="lbl_whitebox" runat="server" Height="20"
                                                        Width="50px" Enabled="false" AutoPostBack="true" OnSelectedIndexChanged="ddlLineNo_SelectedIndexChanged">
                                                    </asp:DropDownList></td>
                                                <td style="padding-left: 25px;">
                                                    <asp:DropDownList ID="ddlStdComment" AutoPostBack="true" CssClass="lbl_whitebox"
                                                        runat="server" Height="20" Width="290px" OnSelectedIndexChanged="ddlStdComment_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="font-weight: bold; width: 4px;">
                                                    Form
                                                </td>
                                                <td style="padding-left: 5px;">
                                                    <asp:DropDownList ID="ddlFrom" CssClass="lbl_whitebox" runat="server" Height="20"
                                                        Width="130">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="font-weight: bold; padding-left: 20px;">
                                                    Sequence
                                                </td>
                                                <td style="padding-left: 10px;">
                                                    <asp:Label ID="lblSequence" runat="server" Text="" Width="30px"></asp:Label>
                                                </td>
                                                <td style="font-weight: bold; text-decoration: underline; padding-left: 25px;">
                                                    User Entered
                                                </td>
                                            </tr>
                                            <tr height=50px >
                                                <td colspan="4" valign=baseline height=50px >
                                                    <%--<table width="50%" onclick="javascript:OpenPreview();" style="cursor:hand;">
                                                        <tr>
                                                            <td>
                                                                <span style="font-weight: bold;">Preview Your
                                                                    <br />
                                                                    Comments</span></td>
                                                            <td>
                                                                <asp:ImageButton ID="imgbtnPreview" ImageUrl="~/Common/Images/pdf.gif" runat="server" /></td>
                                                        </tr>
                                                    </table>--%>
                                                </td>
                                                <td height=50px >
                                                    <table cellpadding="5" cellspacing="0" width="100%">
                                                        <tr>
                                                            <td style="font-weight: bold; padding-left: 0;" valign="top">
                                                                <asp:HiddenField ID="hidCommID" runat="server" />
                                                            </td>
                                                            <td style="padding-left: 20px;">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:TextBox ID="txtComment" MaxLength="255" CssClass="Sbar lbl_whitebox" runat="server"
                                                                        Width="280px" TextMode="MultiLine" Height="75"></asp:TextBox>
                                                                    </td>
                                                                    <td style="padding-left:5px;" valign=top>
                                                                    <asp:RequiredFieldValidator ID="rfvComment" runat="server" ForeColor="red" ControlToValidate="txtComment" Display=Dynamic
                                                                    ErrorMessage="  *"></asp:RequiredFieldValidator>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            </td>
                                                            <td valign="baseline">
                                                                <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/Save.jpg"
                                                                    OnClick="ibtnSave_Click" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                    </td>
                                </tr>
                            </table>
                            </table> </td> </tr>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top">
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
                                overflow-y: auto; position: relative; top: 0px; left: 0px; height: 155px; border: 1px solid #88D2E9;
                                width: 700px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvComment" PagerSettings-Visible="false"
                                    Width="705" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                    AutoGenerateColumns="false" OnRowCommand="gvComment_RowCommand" OnSorting="gvComment_Sorting"
                                    OnRowDataBound="gvComment_RowDataBound" Height="53px">
                                    <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9" />
                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                    <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="25px" BorderWidth="1px" />
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
                                        <asp:BoundField HeaderText="Type" DataField="Type" SortExpression="Type">
                                            <ItemStyle HorizontalAlign="Left" Width="40px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Line No" DataField="CommLineNo" SortExpression="CommlineNO">
                                            <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Comment" DataField="CommText" SortExpression="CommText">
                                            <ItemStyle HorizontalAlign="Left" Width="220px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Form" DataField="FormsCd" SortExpression="FormsCd">
                                            <ItemStyle HorizontalAlign="Left" Width="60px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Sequence No" DataField="CommLineSeqNo" SortExpression="CommLineSeqNo">
                                            <ItemStyle HorizontalAlign="Left" Width="40px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" SortExpression="EntryDt">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" SortExpression="EntryID">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Change Date" DataField="ChangeDt" SortExpression="ChangeDt">
                                            <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" SortExpression="ChangeID">
                                            <ItemStyle HorizontalAlign="Left" Width="80px" CssClass="Left5pxPadd" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Deleted Date" DataField="DeleteDt" SortExpression="DeleteDt">
                                            <ItemStyle HorizontalAlign="Left" Width="90px" CssClass="Left5pxPadd" ForeColor="Red" />
                                        </asp:BoundField>
                                    </Columns>
                                    <PagerSettings Visible="False" />
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
                                    <td>
                                        &nbsp;</td>
                                    <td colspan="4">
                                        <uc3:PrintDialogue ID="PrintDialogue1" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;">
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
