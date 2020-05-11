<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemAliasMaint.aspx.cs" Inherits="ItemAliasMaint"
    EnableEventValidation="false" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Item Alias Maintenance </title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <script>
    function ZItem(itemNo,itemControlId)
    {
        var _searchButtonId = (itemControlId == "txtSearchItemNo" ? "btnSearch" : "btnHidSearch");
        var completeItem=0;
        var ZItemInd=$get("ItemPromptInd");
        event.keyCode=0;        
        if (ZItemInd.value != 'Z')
        {
            event.keyCode=9;
            return false;
        }
        if (itemNo.length >= 14)
        {
            $get(_searchButtonId).click();
            return false;
        }
        if (itemNo.length == 0)
        {
            return false;
        }
        // process ZItem
        switch(itemNo.split('-').length)
        {
            case 1:
                // this is actually taken care of by the item alias search
                itemNo = "00000" + itemNo;
                itemNo = itemNo.substr(itemNo.length-5,5);
                $get(itemControlId).value=itemNo+"-";  
                break;
            case 2:
                // close if they are entering an empty part
                if (itemNo.split('-')[0] == "00000") {ClosePage()};
                section = "0000" + itemNo.split('-')[1];
                section = section.substr(section.length-4,4);
                $get(itemControlId).value=itemNo.split('-')[0]+"-"+section+"-";  
                break;
            case 3:
                section = "000" + itemNo.split('-')[2];
                section = section.substr(section.length-3,3);
                $get(itemControlId).value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                completeItem=1;
                break;
        }
        if (completeItem==1) 
        {
            $get(_searchButtonId).click();
        }
        return false;
    }
    
    function ValidateCustNo()
    {
        if(document.getElementById('txtSearchCustNo').value == "")
        {
            alert('Invalid Customer Number');
            document.getElementById('txtSearchCustNo').focus();
            return false;
        }
        
        return true;
    }
    </script>

</head>
<body onunload="javascript:Unload();" onclick="javascript:document.getElementById('lblMessage').innerText='';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';"
    onmouseup="divToolTips.style.display='none';">
    <form id="frmFreightAddr" runat="server">
        <asp:ScriptManager runat="server" ID="smItemAlias">
        </asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;"
            id="mainTable">
            <tr>
                <td height="5%" id="tdHeaders">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <table id="tblMain" style="width: 100%; height: 625px; border-collapse: collapse;"
                        class="blueBorder" cellpadding="0" cellspacing="0">
                        <tr style="vertical-align: top;">
                            <td>
                                <%--BODY--%>
                                <table id="tblTop" style="width: 100%; border-collapse: collapse;" class="blueBorder"
                                    cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="lightBlueBg" colspan="2">
                                            <asp:UpdatePanel ID="upnlTop" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Panel ID="pnlTop" runat="server" DefaultButton="btnSearch">
                                                        <table width="100%" style="padding-left: 0px; border-collapse: collapse;">
                                                            <tr>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblSearchItemNo" runat="server" Font-Bold="True" Text="Item No:" Width="50px"></asp:Label></td>
                                                                <td style="width: 90px">
                                                                    <asp:TextBox ID="txtSearchItemNo" runat="server" Width="90px" CssClass="FormCtrl"
                                                                        TabIndex="1" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13 || event.keyCode==9){return ZItem(this.value,this.id);}"
                                                                        MaxLength="20"></asp:TextBox>
                                                                </td>
                                                                <td>
                                                                    <asp:Button ID="btnHidSearch" runat="server" Text="hidButton" Style="display: none;"
                                                                        CausesValidation="false" OnClick="btnHidSearch_Click" />
                                                                    <asp:HiddenField ID="ItemPromptInd" runat="server" Value="Z" />
                                                                </td>
                                                                <td>
                                                                    <asp:Button ID="btnHidSearchCustNo" runat="server" Text="hidCustButton" Style="display: none;"
                                                                        CausesValidation="false" />
                                                                    <asp:HiddenField ID="HiddenCustNo" runat="server" Value="Z" />
                                                                </td>
                                                                <td style="padding-left: 0px">
                                                                    <asp:Label ID="lblCustNo" runat="server" Font-Bold="True" Text="Customer No:" Width="80px"></asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox ID="txtSearchCustNo" runat="server" CssClass="FormCtrl" TabIndex="2"
                                                                        CausesValidation="false" OnTextChanged="txtSearchItemNo_TextChanged" Width="80px"
                                                                        MaxLength="20"></asp:TextBox>
                                                                </td>
                                                                <td style="padding-right: 315px">
                                                                    <asp:ImageButton ID="btnSearch" CausesValidation="false" runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                                        OnClick="btnSearch_Click" TabIndex="3" />
                                                                </td>
                                                                <td align="right" style="padding-right: 5px;" width="28%">
                                                                    <asp:ImageButton ID="btnAdd" CausesValidation="false" runat="server" ImageUrl="common/Images/newAdd.gif"
                                                                        OnClientClick="javascript:return ValidateCustNo();" OnClick="btnAdd_Click" />
                                                                    <img id="imgClose" src="Common/images/close.jpg" style="cursor: hand" onclick="javascript:window.close();" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                                <table style="width: 100%; border-collapse: collapse;" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td colspan="4">
                                            <asp:UpdatePanel ID="upnlEdit" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table id="tblEdit" style="width: 100%; height: 130px;" runat="server" class="blueBorder">
                                                        <tr>
                                                            <td align="left" class="DarkBluTxt" style="padding-left: 5px">
                                                                <asp:LinkButton ID="lblItemNo" runat="server" Font-Underline="true" Text="PFC Item No:" Font-Bold=true
                                                                    TabIndex="16" Width="80px"></asp:LinkButton>
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
                                                            <td style="width: 200px">
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox ID="txtItemNo" CssClass="FormCtrl" runat="server" Width="100px" OnTextChanged="txtItemNo_TextChanged"
                                                                                TabIndex="4" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13 || event.keyCode==9){return ZItem(this.value,this.id);}"
                                                                                MaxLength="20"></asp:TextBox>
                                                                        </td>
                                                                        <td style="padding-left: 5px;">
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtItemNo"
                                                                                ErrorMessage="*" Font-Bold="true"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="DarkBluTxt" style="width: 97px">
                                                                <asp:Label ID="lblAliasType" runat="server" Font-Bold="True" Text="Alias Type:"></asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlAliasType" CssClass="FormCtrl" Height="20px" runat="server"
                                                                    Width="105px" TabIndex="8">
                                                                </asp:DropDownList></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="DarkBluTxt" style="padding-left: 5px">
                                                                <asp:Label ID="lblAliasItemNo" runat="server" Font-Bold="True" Text="Alias Item No:"></asp:Label></td>
                                                            <td>
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox ID="txtAliasItemNo" runat="server" CssClass="FormCtrl" MaxLength="30"
                                                                                OnTextChanged="txtAliasItemNo_TextChanged" TabIndex="5" Width="150px"></asp:TextBox>
                                                                        </td>
                                                                        <td style="padding-left: 5px;">
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtAliasItemNo"
                                                                                ErrorMessage="*" Font-Bold="true"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td class="DarkBluTxt" style="width: 97px;">
                                                                <asp:Label ID="lblUOM" runat="server" Text="UOM:" Width="40px" Font-Bold="True"></asp:Label></td>
                                                            <td>
                                                                <asp:TextBox ID="txtUOM" runat="server" CssClass="FormCtrl" MaxLength="3" TabIndex="9"
                                                                    OnTextChanged="txtUOM_TextChanged" Width="100px"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="DarkBluTxt" style="padding-left: 5px">
                                                                <asp:Label ID="lblAliasDesc" runat="server" Text="Alias Desc:" Width="75px" Font-Bold="True"></asp:Label></td>
                                                            <td>
                                                                <asp:TextBox ID="txtAliasDesc" runat="server" CssClass="FormCtrl" MaxLength="50"
                                                                    OnTextChanged="txtAliasDesc_TextChanged" TabIndex="6" Width="150px"></asp:TextBox></td>
                                                            <td class="DarkBluTxt" style="width: 97px">
                                                                <asp:Label ID="lblOrganizationNo" runat="server" Text="Customer No:" Width="76px"
                                                                    Font-Bold="True"></asp:Label></td>
                                                            <td>
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox ID="txtOrganizationNo" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                                                OnTextChanged="txtOrganizationNo_TextChanged" TabIndex="10" Width="100px"></asp:TextBox>
                                                                        </td>
                                                                        <td style="padding-left: 5px;">
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" Font-Bold="true" runat="server"
                                                                                ControlToValidate="txtOrganizationNo" ErrorMessage="*"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="DarkBluTxt" style="width: 65px; padding-left: 6px;">
                                                                <asp:Label ID="lblAliasWhseNo" runat="server" Font-Bold="True" Text="Alias Whse No:"
                                                                    Width="85px"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtAliasWhseNo" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                                    OnTextChanged="txtAliasWhseNo_TextChanged" TabIndex="7" Width="150px"></asp:TextBox></td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                                <table id="tblBtnBanner" style="width: 100%" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <table style="width: 100%;" cellpadding="0" cellspacing="0">
                                                <tr style="vertical-align: top">
                                                    <td>
                                                        <asp:UpdatePanel ID="pnlBtnBanner" UpdateMode="Conditional" runat="server">
                                                            <ContentTemplate>
                                                                <table id="tblBtnBanner2" runat="server" class="blueBorder" cellpadding="0" cellspacing="0"
                                                                    width="100%">
                                                                    <tr runat="server" id="tdHeader">
                                                                        <td class="lightBlueBg">
                                                                            <asp:Label ID="lblBtnHeader" runat="server" Text="Item Alias Maintenance" CssClass="BanText"
                                                                                Width="300px"></asp:Label></td>
                                                                        <td style="width: 1000%; height: 5px" align="right" class="lightBlueBg">
                                                                            <table>
                                                                                <tr>
                                                                                    <td style="height: 16px">
                                                                                        &nbsp;<asp:ImageButton ID="btnSave" Visible="false" CausesValidation="true" runat="server"
                                                                                            ImageUrl="common/Images/BtnSave.gif" OnClick="btnSave_Click" />
                                                                                        <asp:ImageButton ID="btnCancel" Visible="false" runat="server" ImageUrl="common/Images/cancel.png"
                                                                                            CausesValidation="false" OnClick="btnCancel_Click" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td valign="top">
                                            <asp:UpdatePanel ID="pnlAliasGrid" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <div runat="server" id="divAliasGrid" visible="false">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <div id="div-datagrid" class="Sbar" align="left" style="overflow: auto; width: 1020px;
                                                                        position: relative; top: 0px; left: 0px; height: 390px; border: 0px solid; vertical-align: top;
                                                                        overflow-y: scroll;">
                                                                        <asp:DataGrid ID="dgItemAliasGrid" Width="1003px" runat="server" BorderWidth="1px"
                                                                            BorderColor="#DAEEEF" CssClass="grid" Style="height: auto;" UseAccessibleHeader="True"
                                                                            AutoGenerateColumns="False" AllowSorting="True" PagerStyle-Visible="false" OnItemCommand="dgItemAlias_ItemCommand"
                                                                            OnSortCommand="dgItemAlias_SortCommand" AllowPaging="True" PageSize="17">
                                                                            <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                                            <ItemStyle CssClass="GridItem" Height="10px" />
                                                                            <AlternatingItemStyle CssClass="zebra" Height="10px" />
                                                                            <FooterStyle CssClass="lightBlueBg" HorizontalAlign="Right" />
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="Actions">
                                                                                    <ItemTemplate>
                                                                                        <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                                            Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                                            CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pItemAliasID")%>'>Edit</asp:LinkButton>
                                                                                        <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                                            Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                                            CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pItemAliasID")%>'>Delete</asp:LinkButton>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle Width="65px" />
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="OrganizationNo" HeaderText="Cust No" SortExpression="OrganizationNo">
                                                                                    <ItemStyle Width="45px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ItemNo" HeaderText="PFC Item No" SortExpression="ItemNo">
                                                                                    <ItemStyle Width="90px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="AliasItemNo" HeaderText="Alias Item No" SortExpression="AliasItemNo">
                                                                                    <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="AliasDesc" HeaderText="Alias Desc" SortExpression="AliasDesc">
                                                                                    <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="AliasType" HeaderText="Alias Type" SortExpression="AliasType">
                                                                                    <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="AliasWhseNo" HeaderText="Alias Whse No" SortExpression="AliasWhseNo">
                                                                                    <ItemStyle Width="50px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="UOM" HeaderText="UOM" SortExpression="UOM">
                                                                                    <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                    <HeaderStyle Width="45px" HorizontalAlign="Center" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="LastModBy" HeaderText="Change ID" SortExpression="LastModBy">
                                                                                    <ItemStyle Width="75px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="LastModDate" HeaderText="Change Date" DataFormatString="{0:MM/dd/yyyy}"
                                                                                    SortExpression="LastModDate">
                                                                                    <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                                                </asp:BoundColumn>
                                                                            </Columns>
                                                                            <PagerStyle Visible="False" />
                                                                        </asp:DataGrid>
                                                                        <asp:HiddenField ID="hidScrollTop" runat="server" />
                                                                        <asp:HiddenField ID="hidPrimaryKey" runat="server" />
                                                                        <asp:HiddenField ID="hidEditMode" runat="server" />
                                                                        <asp:HiddenField ID="hidItemAliasID" runat="server" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <uc3:pager ID="Pager1" OnBubbleClick="Pager_PageChanged" runat="server" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                                <%--END BODY--%>
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
                                <asp:UpdatePanel ID="pnlUpdate" runat="server" UpdateMode="conditional">
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
                    <uc2:BottomFooter ID="BottomFooterID" Title="Item Alias Maintenance"
                        runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
