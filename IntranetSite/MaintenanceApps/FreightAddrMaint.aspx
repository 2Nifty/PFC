<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FreightAddrMaint.aspx.cs" Inherits="FreightAddrMaint" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Freight Adder Maintenance</title>
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <script src="Common/javascript/Common.js" type="text/javascript"></script>

    <style type="text/css">
        .myFormCtrl
        {
	        font-family: Arial, Helvetica, sans-serif;	
	        font-size: 11px;	
	        font-weight: normal;	
	        color: #000000;	
	    }
    </style>

    <script>

        function Close()
        {
            FreightAddrMaint.ReleaseLock().value;
//            window.close();
        }

    </script>


</head>
<body onunload="javascript:Close();">
    <form id="frmFreightAddr" runat="server">
        <asp:ScriptManager runat="server" ID="smFreightAddr">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="mainTable">
            <tr>
                <td height="5%" id="tdHeaders">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr class="PageHead shadeBgDown">
                <td class="Left2pxPadd DarkBluTxt boldText blueBorder shadeBgDown">
                    <asp:UpdatePanel ID="pnlSearch" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table height="25" width="100%"style="padding-left: 0px;">
                                <tr id="trsearchText" runat="server">
                                    <td>
                                        <asp:Label ID="lblSch" ForeColor="#CC0000" runat="server" Text="Search by :"></asp:Label>
                                    </td>
                                    <td align="right">
                                        <asp:Label ID="lblFromLoc" runat="server" Text="From Location" Width="100px"></asp:Label></td>
                                    <td>
                                        &nbsp<asp:DropDownList ID="ddlFromLocSearch" runat="server" CssClass="myFormCtrl"></asp:DropDownList>
                                    </td>
                                    <td width="140" align="right">
                                        <asp:Label ID="lblToLoc" runat="server" Text="To Location" Width="90px"></asp:Label>
                                    </td>
                                    <td>
                                        &nbsp<asp:DropDownList ID="ddlToLocSearch" runat="server" CssClass="myFormCtrl"></asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/MaintenanceApps/Common/images/Search.jpg"
                                            CausesValidation="false"  OnClick="btnSearch_Click" />
                                    </td>
                                    <td align="right" style="padding-right: 5px;" width="28%">
                                        <asp:ImageButton ID="btnAdd" Visible="false" runat="server" ImageUrl="common/Images/newAdd.gif"
                                            CausesValidation="false" OnClick="btnAdd_Click" />
                                        <img id="imgClose" src="Common/images/close.jpg" style="cursor:hand" onclick="javascript:window.close();" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 0px; padding-left: 0px;">
                    <asp:UpdatePanel ID="pnlContent" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table id="ContentTable" width="100%" border="0" cellspacing="0" cellpadding="0" visible="false" runat="server">
                                <tr>
                                    <td class="lightBlueBg">
                                        <asp:Label ID="lblHeading" runat="server" Text="Freight Adder Information" CssClass="BanText"
                                            Width="300px"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="border-right: solid 1px #c9c6c6; padding-bottom: 5px;">
                                        <asp:Panel ID="pnlFreight" runat="server">
                                            <table>
                                                <tr><td colspan="4"><br /></td></tr>
                                                <tr>
                                                    <td width="25"></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" width="100">From Location</td>
                                                    <td class="Left2pxPadd" width="220">
                                                        <asp:DropDownList ID="ddlFromLocEdit" runat="server" CssClass="myFormCtrl" AutoPostBack="True"
                                                                OnSelectedIndexChanged="ddlFromLocEdit_SelectedIndexChanged"></asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblFromAddress" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">To Location</td>
                                                    <td class="Left2pxPadd">
                                                        <asp:DropDownList ID="ddlToLocEdit" runat="server" CssClass="myFormCtrl" AutoPostBack="True"
                                                                OnSelectedIndexChanged="ddlToLocEdit_SelectedIndexChanged"></asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblToAddress" runat="server" Text=""></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">LTL Per LB</td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" style="text-align:right" runat="server" ID="txtLTL" MaxLength="12" Width="100px"
                                                                OnFocus="javascript:this.select();" OnTextChanged="txtLTL_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                    </td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">Line-Haul Per Lb</td>
                                                    <td class="Left2pxPadd">
                                                        <asp:TextBox CssClass="FormCtrl" style="text-align:right" runat="server" ID="txtLineHaul" MaxLength="12" Width="100px"
                                                                OnFocus="javascript:this.select();" OnTextChanged="txtLineHaul_TextChanged" AutoPostBack="True"></asp:TextBox>
                                                    </td>
                                                    <td></td>
                                                </tr>
                                                <tr><td><br /></td></tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlLink" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" width="100%">
                                <tr runat="server" id="tdHeader">
                                    <td class="lightBlueBg">
                                        <asp:Label ID="lblHeader" runat="server" Text="Freight Adders" CssClass="BanText"
                                            Width="300px"></asp:Label></td>
                                    <td style="width: 100%; height: 5px" align="right" class="lightBlueBg">
                                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                            <ContentTemplate>
                                                <table  >
                                                    <tr>
                                                        <td style="height: 16px">
                                                            &nbsp;<asp:ImageButton ID="btnSave" Visible="false" CausesValidation="true" runat="server" ImageUrl="common/Images/BtnSave.gif" OnClick="btnSave_Click" />
                                                            <asp:ImageButton ID="btnCancel" Visible="false" runat="server" ImageUrl="common/Images/cancel.png" CausesValidation="false" OnClick="btnCancel_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td height="350px" valign="top">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top">
                                <asp:UpdatePanel ID="pnlFreightGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="tdFreight" visible="true">
                                            <div id="div-datagrid" class="Sbar" align="center" style="overflow: auto; width: 1020px; 
                                                position: relative; top: 0px; left: 0px; height: 350px; border: 0px solid; vertical-align: top;">
                                                <asp:DataGrid ID="dgFreight" Width="1130px" runat="server" GridLines="both" BorderWidth="1px"
                                                    TabIndex="-1" ShowFooter="false" AllowSorting="true" CssClass="grid" Style="height: auto"
                                                    UseAccessibleHeader="true" AutoGenerateColumns="false" BorderColor="#DAEEEF" PagerStyle-Visible="false"
                                                    OnItemDataBound="dgFreight_ItemDataBound" OnSortCommand="dgFreight_SortCommand" OnItemCommand="dgFreight_ItemCommand">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="lightBlueBg" />
                                                    <Columns>
                                                        <asp:TemplateColumn ItemStyle-Width="80px" HeaderText="Actions" HeaderStyle-Width="80px"
                                                            ItemStyle-HorizontalAlign="center">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblNoAction" runat="server" Visible="false" Text="None" Font-Bold="true"></asp:Label>
                                                                <asp:LinkButton ID="lnkEdit" Font-Underline="true" CommandName="Edit" ForeColor="#006600"
                                                                    CausesValidation="false" Style="padding-left: 5px" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pFreightAdderId")%>'
                                                                    runat="server" Visible="false" Text="Edit"></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" CausesValidation="false"
                                                                    Style="padding-left: 5px" OnClientClick="javascript:if(confirm('Are you sure you want to delete?')==true){document.getElementById('hidDelConf').value = 'true';} else {document.getElementById('hidDelConf').value = 'false';}"
                                                                    CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pFreightAdderId")%>'
                                                                    runat="server" Visible="false" Text="Delete"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Center" HeaderText="From Loc"
                                                            FooterStyle-HorizontalAlign="right" DataField="FromLocation" SortExpression="FromLocation"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Center" HeaderText="To Loc"
                                                            FooterStyle-HorizontalAlign="right" DataField="ToLocation" SortExpression="ToLocation"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Center" HeaderText="From Zip"
                                                            FooterStyle-HorizontalAlign="right" DataField="FromZipCd" SortExpression="FromZipCd"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="75" ItemStyle-HorizontalAlign="Center" HeaderText="To Zip"
                                                            FooterStyle-HorizontalAlign="right" DataField="ToZipCd" SortExpression="ToZipCd"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="75" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" ItemStyle-HorizontalAlign="Right" HeaderText="LTL Per Lb"
                                                            FooterStyle-HorizontalAlign="right" DataField="LTLRatePerLb" SortExpression="LTLRatePerLb"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="125" HeaderStyle-Wrap="false" DataFormatString="{0:$#,0.000000}"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" ItemStyle-HorizontalAlign="Right" HeaderText="Line-Haul Per Lb"
                                                            FooterStyle-HorizontalAlign="right" DataField="LineHaulRatePerLb" SortExpression="LineHaulRatePerLb"
                                                            ItemStyle-Wrap="false" ItemStyle-Width="125" HeaderStyle-Wrap="false" DataFormatString="{0:$#,0.000000}"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" HeaderText="Entry ID" FooterStyle-HorizontalAlign="right"
                                                            DataField="EntryID" SortExpression="EntryID" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right"
                                                            ItemStyle-Width="125" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" HeaderText="Entry Date" FooterStyle-HorizontalAlign="right"
                                                            DataFormatString="{0:MM/dd/yyyy}" DataField="EntryDt" SortExpression="EntryDt"
                                                            ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="125"
                                                            HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" HeaderText="Change ID" FooterStyle-HorizontalAlign="right"
                                                            DataField="ChangeID" SortExpression="ChangeID" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right"
                                                            ItemStyle-Width="125" HeaderStyle-Wrap="false"></asp:BoundColumn>

                                                        <asp:BoundColumn HeaderStyle-Width="125" HeaderText="Change Date" FooterStyle-HorizontalAlign="right"
                                                            DataFormatString="{0:MM/dd/yyyy}" DataField="ChangeDt" SortExpression="ChangeDt"
                                                            ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="125"
                                                            HeaderStyle-Wrap="false"></asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                                <%--   *****  Hidden Fields  *****   --%>
                                                    <input type="hidden" id="hidSort" runat="server" />
                                                    <asp:HiddenField ID="hidFocus" runat="server" Value="ddlFromLocSearch" />
                                                    <asp:HiddenField ID="hidSecurity" runat="server" />
                                                    <asp:HiddenField ID="hidEditMode" runat="server" />
                                                    <asp:HiddenField ID="hidCheckLoc" runat="server" Value="No" />
                                                    <asp:HiddenField ID="hidFromZipCd" runat="server" />
                                                    <asp:HiddenField ID="hidToZipCd" runat="server" />
                                                    <asp:HiddenField ID="hidRecID" runat="server" />
                                                    <asp:HiddenField ID="hidDelConf" runat="server" />
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdateProgress ID="pnlUpdate" runat="server" DynamicLayout="false">
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
                    <uc2:BottomFooter ID="BottomFooterID" Title="Freight Adder Maintenance" runat="server" />
                </td>
            </tr>

<%--
    <tr><td>
        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox></td></tr>
    <tr><td>
        <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox></td></tr>
    <tr><td>
        <asp:TextBox ID="TextBox3" runat="server"></asp:TextBox></td></tr>
--%>


        </table>

<%--
       <script language="javascript">
            var o = document.getElementById("txtLineHaul");
            o.focus();
        </script>
--%>
    </form>
</body>
</html>
