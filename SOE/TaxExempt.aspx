<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TaxExempt.aspx.cs" Inherits="TaxExempt" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="SoHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>SOE - TaxExempt</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <script src="Common/JavaScript/Common.js" type="text/javascript"></script>
    <style>
    .list
    {
	line-height:23px;
	background:#FFFFCC;
	padding:0px 10px;
	border:1px solid #FAEE9A;
	position:absolute;
	z-index:1;
	top:0px;
	}
	.boldText
    {
	font-weight: bold;
    }

    </style>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlContactEntry" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <table class="HeaderPanels" border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                    <tr>
                        <td class="lightBg" style="padding: 5px;">
                            <table border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left">
                                        <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Customer No:" Width="80px"></asp:Label></td>
                                    <td align="left">
                                        <asp:Label ID="lblCustNumber" runat="server" Font-Bold="False" CssClass="lblBluebox" Width="50px"></asp:Label>
                                    </td>
                                    <td></td>
                                    <td align="right">
                                        <asp:Label ID="Label18" runat="server" Font-Bold="True" Text="Customer Name:" Width="117px"></asp:Label>
                                    </td>
                                    <td align="left">
                                        <asp:Label ID="lblCustName" runat="server" Font-Bold="False" CssClass="lblBluebox" Width="200px"></asp:Label>
                                    </td>
                                    <td></td>
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
                            padding-left: 5px">
                            <asp:UpdatePanel ID="upTaxEntry" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <table cellpadding="3" cellspacing="0" width="100%" class="data" border="0" bordercolor="#efefef">
                                        <tr>
                                            <td width="150px">
                                                <asp:LinkButton ID="lnkListMaster" runat="server" Font-Underline="true" Font-Bold=true Text="Resale Certificate No."
                                                    TabIndex="1"></asp:LinkButton>
                                                <div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                                <span class="boldText">Change ID: </span>
                                                                <asp:Label ID="lblChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                            <td>
                                                                <span class="boldText" style="padding-left: 5px;">Change Date: </span>
                                                                <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <span class="boldText">Entry ID: </span>
                                                                <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                            <td>
                                                                <span class="boldText" style="padding-left: 5px;">Entry Date: </span>
                                                                <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <td align =left><asp:TextBox ID="txtCert" CssClass="lbl_whitebox" runat="server" Width="150"  TabIndex ="1" MaxLength="20" ></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvComment" runat="server" ForeColor="red" ControlToValidate="txtCert"
                                                                    ErrorMessage="  *"></asp:RequiredFieldValidator>
                                            </td>
                                            <td rowspan =3 align =right valign ="top" style="padding-right:8px;"  >
                                                <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/Save.jpg"
                                                    OnClick="ibtnSave_Click" /></td>
                                        </tr>
                                        <tr>
                                            <td style="font-weight:bold;">
                                                State</td>
                                            <td>
                                                <asp:DropDownList ID="ddlState" AutoPostBack="false" CssClass="lbl_whitebox" runat="server"
                                                Height="20" Width="130" >
                                            </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr style="font-weight:bold;">
                                            <td>Expiration Date</td>
                                            <td>
                                                <uc5:novapopupdatepicker ID="dtpExpDate" TabIndex ="3" runat="server" /><asp:HiddenField ID="hidTaxID" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:UpdatePanel ID="upTaxGrid" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: auto;
                                        overflow-y: auto; position: relative; top: 0px; left: 0px; height: 328px; border: 1px solid #88D2E9;
                                        width: 705px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                        scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                        scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                        <asp:GridView ShowFooter="false" UseAccessibleHeader="true" ID="gvTax" PagerSettings-Visible="false"
                                             runat="server" Width=100% AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                            AutoGenerateColumns="false" OnSorting="gvTax_Sorting" OnRowCommand="gvTax_RowCommand"
                                            OnRowDataBound="gvTax_RowDataBound">
                                            <HeaderStyle HorizontalAlign="center" CssClass="GridHead" Font-Bold="true" BackColor="#DFF3F9" />
                                            <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                            <RowStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                            <AlternatingRowStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="Actions">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                            Style="padding-left: 5px" runat="server" CommandName="Edits" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pTaxExemptID")%>'>Edit</asp:LinkButton>
                                                        <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                            Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                            CommandName="Deletes" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pTaxExemptID")%>'>Delete</asp:LinkButton>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="80px" />
                                                </asp:TemplateField>
                                                <asp:BoundField HeaderText="Resale Certificate No." DataField="ResaleCertNo" SortExpression="ResaleCertNo" ItemStyle-CssClass="Left5pxPadd">
                                                    <ItemStyle HorizontalAlign="Left" Width="100px" />
                                                </asp:BoundField>
                                                <asp:BoundField HeaderText="State" DataField="State" SortExpression="State" ItemStyle-CssClass="Left5pxPadd">
                                                    <ItemStyle HorizontalAlign="Left" Width="100px" />
                                                </asp:BoundField>
                                                <asp:BoundField HeaderText="Expiration Date" DataField="ExpirationDt" SortExpression="ExpirationDt" ItemStyle-CssClass="Left5pxPadd">
                                                    <ItemStyle HorizontalAlign="Left" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField HeaderText=" "    />
                                            </Columns>
                                        </asp:GridView>
                                        <input id="hidSort" type="hidden" name="Hidden1" runat="server">
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
                                    <td align="left" width="100%">
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
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <uc2:Footer ID="Footer1" Title="Tax Exempt" runat="server"></uc2:Footer>
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
