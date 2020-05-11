<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemStandardComments.aspx.cs" Inherits="ItemStandardComments" %>

<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head2" runat="server">
    <title>Item Standard Comments Maintenance</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script src="../Common/Javascript/zItem.js" type="text/javascript"></script>

    <style type="text/css">
        .LabelCtrl2
        {
	        font-family: Arial, Helvetica, sans-serif;
	        font-size: 11px;
	        color: #003366;
        }
    </style>

    <script language="javascript" type="text/javascript">
        function Close(session)
        {
            window.close();
        }
        
        function Unload()
        {
            ItemStandardComments.Unload().value;
        }
    </script>

</head>
<body onunload="javascript:Unload();">
    <form id="frmMain" runat="server">
        <asp:ScriptManager runat="server" ID="smItemStdCmnt">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;">
            <tr>
                <td style="height: 5%;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlMain" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <%--BEGIN MAIN--%>
                            <table id="tblMain" style="width: 100%; height: 630px;" class="blueBorder" cellpadding="0" cellspacing="0">
                                <tr style="vertical-align: top;">
                                    <td>
                                        <table id="tblPrompt" border="0" cellpadding="0" cellspacing="0" style="width: 100%; height:35px;" class="lightBlueBg">
                                            <tr style="height:100%">
                                                <td class="Left5pxPadd" style="width:50px;">
                                                    <b>Item No</b>
                                                </td>
                                                <td style="width:100px;">
                                                    <asp:TextBox ID="txtItemNo" runat="server" MaxLength="14" CssClass="FormCtrl2" Width="85px" Text="77777-7777-777"
                                                        onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9 || event.keyCode==13){return zItem(this.value, this.id);}" />
                                                </td>
                                                <td>
                                                    <table id="tblSearch" runat="server">
                                                        <tr>
                                                            <td style="width:50px;">
                                                                <b>Type</b>
                                                            </td>
                                                            <td style="width:125px;">
                                                                <asp:DropDownList ID="ddlTypeSearch" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlTypeSearch_SelectedIndexChanged" />
                                                            </td>
                                                            <td style="width:75px;">
                                                                <b>Form Code</b>
                                                            </td>
                                                            <td style="width:125px;">
                                                                <asp:DropDownList ID="ddlFormSearch" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFormSearch_SelectedIndexChanged" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td align="right" style="padding-right:15px">
                                                    <asp:ImageButton ID="btnAdd" runat="server" ImageUrl="../Common/images/newadd.gif" CausesValidation="False" OnClick="btnAdd_Click" />
                                                    &nbsp;&nbsp;
                                                    <asp:ImageButton ID="btnCancel" runat="server" ImageUrl="../Common/images/cancel.gif" CausesValidation="False" OnClick="btnCancel_Click" />
                                                    &nbsp;&nbsp;
                                                    <img id="CloseButton" alt="Close" src="../Common/images/close.gif" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');" />
                                                </td>
                                            </tr>
                                        </table>
                                        <asp:UpdatePanel ID="pnlMaintHdr" UpdateMode="conditional" runat="server">
                                            <ContentTemplate>
                                                <table cellspacing="0" cellpadding="0" height="40px" width="100%" class="lightBlueBg">
                                                    <tr>
                                                        <td class="Left5pxPadd BannerText">
                                                            <asp:Label ID="lblMaintHdr" runat="server" Text="" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:UpdatePanel ID="pnlEdit" UpdateMode="conditional" runat="server">
                                            <ContentTemplate>
                                                <%--BEGIN Item Info & Comment Edit Section--%>
                                                <table id="tblEdit" cellpadding="0" border="0" cellspacing="0" width="100%" style="padding-top:10px; padding-bottom:10px; border-bottom:solid 1px #4BBADE;">
                                                    <tr>
                                                        <td style="width:40%; padding-left:20px; vertical-align:top;">
                                                            <table id="tblEditDesc" runat="server" cellpadding="0" border="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td style="width:75px; height:25px;">
                                                                        <b>Item No</b>
                                                                    </td>
                                                                    <td style="height:25px;">
                                                                        <asp:Label ID="lblItemNo" runat="server" CssClass="LabelCtrl2" Text="99999-9999-999" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="width:75px; height:25px;">
                                                                        <b>Cat Desc</b>
                                                                    </td>
                                                                    <td style="height:25px;">
                                                                        <asp:Label ID="lblCatDesc" runat="server" CssClass="LabelCtrl2" Text="\~~**** lblCatDesc ~~ FIFTY CHARACTERS MAX ****~~/" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="width:75px; height:25px;">
                                                                        <b>Item Desc</b>
                                                                    </td>
                                                                    <td style="height:25px;">
                                                                        <asp:Label ID="lblItemDesc" runat="server" CssClass="LabelCtrl2" Text="## [20] Size Desc ##*** [26] Category Desc ***04PL" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td style="width:60%; padding-left:20px; border-left:solid 1px #4BBADE; vertical-align:top;">
                                                            <table id="tblEditCmnt" runat="server" cellpadding="0" border="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td>
                                                                        <table>
                                                                            <tr>
                                                                                <td style="width:75px; height:25px;">
                                                                                    <b>Type</b>
                                                                                </td>
                                                                                <td style="width:150px; height:25px;">
                                                                                    <asp:DropDownList ID="ddlCmntType" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" />
                                                                                </td>
                                                                                <td style="width:75px; height:25px;">
                                                                                    <b>Form Code</b>
                                                                                </td>
                                                                                <td style="width:150px; height:25px;">
                                                                                    <asp:DropDownList ID="ddlFormCd" CssClass="FormCtrl2" Width="105px" Height="20px" runat="server" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <table>
                                                                            <tr>
                                                                                <td style="width:75px; height:25px; vertical-align:top;">
                                                                                    <b>Comments</b>
                                                                                    <br /><i>500 char max</i>
                                                                                </td>
                                                                                <td style="width:350px; height:100px; vertical-align:top;">
                                                                                    <asp:TextBox ID="txtCmntText" runat="server" Wrap="true" MaxLength="500" TextMode="MultiLine" Width="450px" Height="90px" onfocus="javascript:this.select();" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <table>
                                                                            <tr>
                                                                                <td align="right" style="width:535px;">
                                                                                    <asp:ImageButton ID="btnSave" runat="server" ImageUrl="../Common/images/BtnSave.gif" CausesValidation="False" OnClick="btnSave_Click" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:HiddenField ID="hidMaintMode" runat="server" />
                                                                        <asp:HiddenField ID="hidIMNoteID" runat="server" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <%--END Item Info & Comment Edit Section--%>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>

                                        <asp:UpdatePanel ID="pnlGrid" UpdateMode="conditional" runat="server">
                                            <ContentTemplate>
                                                <%--BEGIN Comment Grid Section--%>
                                                <table cellspacing="0" cellpadding="0" height="40px" width="100%" class="lightBlueBg">
                                                    <tr>
                                                        <td class="Left5pxPadd BannerText">
                                                            Item Standard Comments
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table style="height:320px; width:100%; background-color:#ECF9FB;">
                                                    <tr>
                                                        <td align="center" style="vertical-align:middle;">
                                                            <div id="divCmntGrid" runat="server" style="overflow:auto; height:305px; width:1010px;">
                                                                <asp:GridView ID="gvComments" runat="server" ShowFooter="false" AutoGenerateColumns="false" Width="990px"
                                                                    BorderWidth="1px" BorderColor="#DAEEEF" UseAccessibleHeader="false" PagerSettings-Visible="false" AllowPaging="false"
                                                                    OnRowCommand="gvComments_RowCommand" OnRowDataBound="gvComments_RowDataBound">
                                                                    <HeaderStyle CssClass="GridHead" Wrap="true" BackColor="#ECF9FB" BorderColor="#DAEEEF" HorizontalAlign="Center" />
                                                                    <RowStyle CssClass="GridItem" Wrap="false" BackColor="White" BorderColor="White" HorizontalAlign="Center" />
                                                                    <AlternatingRowStyle CssClass="GridItem" Wrap="false" BackColor="#F4FBFD" BorderColor="#DAEEEF" HorizontalAlign="Center" />
                                                                    <EmptyDataRowStyle CssClass="GridHead" Wrap="false" BackColor="#DFF3F9" BorderWidth="0" HorizontalAlign="Center" />
                                                                    <FooterStyle CssClass="GridHead" Wrap="true" BackColor="#DFF3F9" BorderColor="#DAEEEF" HorizontalAlign="Center" />
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="Action" ItemStyle-Width="75px">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="lblNoAction" runat="server" Visible="false" Text="None" Font-Bold="true"></asp:Label>
                                                                                <asp:LinkButton ID="lnkEdit" Font-Underline="true" ForeColor="#006600" CausesValidation="false"
                                                                                    CommandName="EDT" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pItemNotesID")%>' runat="server" Text="Edit" />
                                                                                &nbsp;
                                                                                <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" CausesValidation="false"
                                                                                    OnClientClick="javascript:if(confirm('Are you sure you want to delete this Comment?')==true){document.getElementById('hidDelNote').value = 'true';} else {document.getElementById('hidDelNote').value = 'false';}"
                                                                                    CommandName="DEL" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pItemNotesID")%>' runat="server" Text="Delete" />
                                                                            </ItemTemplate>
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField HeaderText="Type" DataField="Type" HtmlEncode="false" ItemStyle-Width="40px" />
                                                                        <asp:BoundField HeaderText="Form Cd" DataField="FormCd" HtmlEncode="false" ItemStyle-Width="40px" />
                                                                        <asp:BoundField HeaderText="Comment" DataField="Notes" HtmlEncode="false" ItemStyle-Width="485px" ItemStyle-HorizontalAlign="Left" />
                                                                        <asp:BoundField HeaderText="Entry ID" DataField="EntryID" HtmlEncode="false" ItemStyle-Width="100px" />
                                                                        <asp:BoundField HeaderText="Entry Date" DataField="EntryDt" HtmlEncode="false" ItemStyle-Width="75px" DataFormatString="{0:MM/dd/yyyy}" />
                                                                        <asp:BoundField HeaderText="Change ID" DataField="ChangeID" HtmlEncode="false" ItemStyle-Width="100px" />
                                                                        <asp:BoundField HeaderText="Change Date" DataField="ChangeDt" HtmlEncode="false" ItemStyle-Width="75px" DataFormatString="{0:MM/dd/yyyy}" />
                                                                    </Columns>
                                                                </asp:GridView>
                                                            </div>


                                                        </td>
                                                        </tr>
                                                </table>
                                                <%--END Comment Grid Section--%>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:Button ID="btnHidSubmitItem" runat="server" Style="display: none;" OnClick="btnHidSubmitItem_Click" />
                                        <asp:HiddenField ID="hidNoteInd" runat="server" />
                                        <asp:HiddenField ID="hidDelNote" runat="server" />
                                        <asp:HiddenField ID="hidSecurity" runat="server" />
                                    </td>
                                </tr>
                            </table>
                            <%--END MAIN--%>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <%--Status Bar--%>
                <td style="height:20px; background-color:#ECF9FB; padding-left:5px; border-top:1px solid #88D2E9;">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Item Standard Comments Maintenance v1.0" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

