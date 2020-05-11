<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GLPosting.aspx.cs" Inherits="FormMessage" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GL Posting</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <style>    
    .DarkBluTxt 
    {
	    font-family: Arial, Helvetica, sans-serif;
	    font-size: 11px;
	    color: #003366;
	    padding-left: 10px;
	    font-weight:bold;
	    text-align:left;
	    vertical-align:middle;
    }
    </style>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server" defaultfocus="txtSearchCode">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="Left2pxPadd DarkBluTxt boldText" width="12%" style="padding-left: 10px;">
                    <asp:UpdatePanel ID="upnlbtnSearch" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSch" runat="server" Text="Search By:" Width="70px"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList ID="ddlSearch" CssClass="FormCtrl" Height="20px" runat="server" Width="160px">
                                                <asp:ListItem>--- Select ---</asp:ListItem>
                                                <asp:ListItem Value="LocationCd">Branch Location</asp:ListItem>
                                                <asp:ListItem Value="OrganizationGLCd">Customer Code</asp:ListItem>
                                                <asp:ListItem Value="ItemGLCd">Item Code</asp:ListItem>
                                            </asp:DropDownList></td>
                                        <td>
                                            &nbsp;<asp:TextBox ID="txtSearchText" runat="server" CssClass="FormCtrl"></asp:TextBox></td>
                                        <td>
                                            <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                OnClick="btnSearch_Click" CausesValidation="False" TabIndex="15" />
                                        </td>
                                        <td>
                                            &nbsp;<asp:HiddenField ID="hidPrimaryKey" runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;">               
                        <table style="width: 100%" class="blueBorder" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="lightBlueBg">
                                    <asp:Label ID="lblHeading" runat="server" Text="Enter GL Posting Record Information"
                                        CssClass="BanText" Width="334px"></asp:Label></td>
                                <td style="width: 100%; height: 5px" align="right" class="lightBlueBg">
                                    <asp:UpdatePanel ID="upnlAdd" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table>
                                                <tr>
                                                    <td style="height: 16px">
                                                        &nbsp;<img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                            tabindex="17" />
                                                        <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                            runat="server" OnClientClick="javascript:return GLPostingRequiredField();"
                                                            OnClick="btnSave_Click" Visible="false" TabIndex="13" />
                                                        <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                            runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="14" /></td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                            <tr>
                                <td colspan=2 style="padding-left:190px;">
                                <div  style="width:300px">
                                        <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <table  style="padding-left: 10px" align="left">
                                                    <tr>
                                                        <td>
                                                            <asp:LinkButton ID="lnkCode" runat="server" style="text-decoration:underline" Text="Application Type" Width="100px"
                                                                TabIndex="13" CssClass="DarkBluTxt"></asp:LinkButton></td>
                                                        <td style="width: 300px;">
                                                            <asp:DropDownList ID="ddlAppType" Height="20px" CssClass="FormCtrl" runat="server"
                                                                Width="160px" TabIndex="3">
                                                            </asp:DropDownList>
                                                            <div id="divToolTips" class="list" align=left style="display: none; position: absolute; width: 260px"
                                                                onmouseup="return false;">
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
                                                        <td style="width: 300px; height: 26px; padding-left: 10px" valign="middle">
                                                            <span style="color: Red;">*</span></td>
                                                        <td style="padding-left: 10px; width: 300px; height: 26px" valign="top">
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="Label2" runat="server" Text="Customer Code" CssClass="DarkBluTxt"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlCustCode" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="5">
                                                            </asp:DropDownList></td>
                                                        <td class="DarkBluTxt" valign="top">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left">
                                                            <asp:Label ID="Label5" runat="server" CssClass="DarkBluTxt" Font-Bold="True" Text="Branch Location"></asp:Label></td>
                                                        <td style="width: 100px; height: 26px">
                                                            <asp:DropDownList ID="ddlBrLocation" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="4">
                                                            </asp:DropDownList></td>
                                                        <td style="width: 100px; padding-left: 10px;">
                                                            <span style="color: Red;"></span>
                                                        </td>
                                                        <td style="padding-left: 10px; width: 100px">
                                                        </td>
                                                        <td class="DarkBluTxt">
                                                            <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Item Code"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlItemCode" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="5">
                                                            </asp:DropDownList></td>
                                                        <td style="padding-left: 10px; width: 100px">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="7">
                                                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                                                                <tr>
                                                                    <td align="center">
                                                                        <hr color="black" />
                                                                    </td>
                                                                    <td style="width: 60px; height: 14px;" align="center">
                                                                        <asp:Label ID="Label1" runat="server" ForeColor="#CC0000" Text="Accounts" Font-Bold="True"></asp:Label></td>
                                                                    <td align="center">
                                                                        <hr align="center" color="black" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="DarkBluTxt" style="height: 26px;">
                                                            <asp:Label ID="Label4" runat="server" Height="16px" Text="Sales" Width="90px"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlSales" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="5">
                                                            </asp:DropDownList></td>
                                                        <td style="width: 100px">
                                                            <span style="color: #ff0000">&nbsp;&nbsp; </span>
                                                        </td>
                                                        <td style="width: 100px">
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="Label6" runat="server" Height="16px" Text="COGS Labor" Width="90px"
                                                                CssClass="DarkBluTxt"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlCOGSLabor" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="9">
                                                            </asp:DropDownList></td>
                                                        <td style="width: 100px">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td  style="height: 26px;">
                                                            <asp:Label ID="Label10" runat="server" Height="16px" Text="Inventory Material" Width="100px"
                                                                CssClass="DarkBluTxt"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlInvMaterial" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="6">
                                                            </asp:DropDownList></td>
                                                        <td>
                                                        </td>
                                                        <td>
                                                        </td>
                                                        <td class="DarkBluTxt">
                                                            <asp:Label ID="Label7" runat="server" Height="16px" Text="Sales Discount" Width="90px"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlSalesDiscount" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="10">
                                                            </asp:DropDownList></td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="DarkBluTxt"  style="height: 26px;">
                                                            <asp:Label ID="Label11" runat="server" Height="16px" Text="Inventory Labor" Width="90px"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlInvLabor" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="7">
                                                            </asp:DropDownList></td>
                                                        <td>
                                                        </td>
                                                        <td>
                                                        </td>
                                                        <td class="DarkBluTxt">
                                                            <asp:Label ID="Label8" runat="server" Height="16px" Text="A/R Trade" Width="90px"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlARTrade" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="11">
                                                            </asp:DropDownList></td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="DarkBluTxt"  style="height: 26px;">
                                                            <asp:Label ID="Label12" runat="server" Height="16px" Text="COGS Material" Width="90px"></asp:Label></td>
                                                        <td>
                                                            <asp:DropDownList ID="ddlCOGSMaterial" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="8">
                                                            </asp:DropDownList></td>
                                                        <td>
                                                        </td>
                                                        <td>
                                                        </td>
                                                        <td class="DarkBluTxt">
                                                            <asp:Label ID="Label9" runat="server" Height="16px" Text="Miscellaneous" Width="90px"></asp:Label></td>
                                                        <td style="width: 300px">
                                                            <asp:DropDownList ID="ddlMiscellanous" CssClass="FormCtrl" Height="20px" runat="server"
                                                                Width="160px" TabIndex="12">
                                                            </asp:DropDownList></td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="lightBlueBg" style="padding-top: 1px; height: 25px; padding-left: 200px;
                                    text-align: left; border: none;">
                                    <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:ImageButton ID="btnDelete" ImageUrl="~/MaintenanceApps/Common/Images/btndelete.gif"
                                                runat="server" CausesValidation="False" OnClick="btnDelete_Click" TabIndex="16" />&nbsp;
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td class="lightBlueBg" style="padding-top: 1px; height: 5px; text-align: right">
                                </td>
                            </tr>
                        </table>                    
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upnlGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr class="lightBlueBg">
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 7px; width: 4%;">
                                        <span class="BanText">GL Posting Table Records &nbsp;</span></td>
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 1px; width: 5%;">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                        <div id="div-datagrid" class="Sbar" style="overflow-x: auto; overflow-y: auto; position: relative;
                                            top: 0px; left: 0px; height: 280px; width: 1010px; border: 0px solid;" align="left">
                                            <asp:DataGrid CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="dgCountryCode"
                                                GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                AllowSorting="True" ShowFooter="False" OnItemCommand="dgCountryCode_ItemCommand"
                                                Width="1800px" OnSortCommand="dgCountryCode_SortCommand" OnItemDataBound="dgCountryCode_ItemDataBound"
                                                TabIndex="18">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <FooterStyle CssClass="lightBlueBg" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Actions">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                 CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pGLPostingID")%>'>Edit</asp:LinkButton>
                                                            <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pGLPostingID")%>'>Delete</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="80px" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="ApplicationCd" HeaderText="Application Type" SortExpression="ApplicationCd">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="LocationCd" HeaderText="Branch Location" SortExpression="LocationCd">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="OrganizationGLCd" HeaderText="Customer Code" SortExpression="OrganizationGLCd">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ItemGLCd" HeaderText="Item Code" SortExpression="ItemGLCd">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="GLSalesAcct" HeaderText="Sales" SortExpression="GLSalesAcct">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="GLInvMaterialAcct" HeaderText="Inventory Material" SortExpression="GLInvMaterialAcct">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="GLInvLaborAcct" HeaderText="Inventory Labor" SortExpression="GLInvLaborAcct">
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="GLCOGSMaterialAcct" HeaderText="COGS Material" SortExpression="GLCOGSMaterialAcct">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="GLCOGSLaborAcct" HeaderText="COGS Labor" SortExpression="GLCOGSLaborAcct">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="GLSalesDiscountAcct" HeaderText="Sales Discount" SortExpression="GLSalesDiscountAcct">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="GLARTradeAcct" HeaderText="AR Trade" SortExpression="GLARTradeAcct">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="GLMiscAcct" HeaderText="Misc Acct" SortExpression="GLMiscAcct">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryDt" HeaderText="Enter Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="EntryDt">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeDt" HeaderText="Change Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="ChangeDt">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                            <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                            <asp:HiddenField ID ="hidScrollTop" runat ="server" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="BluBg buttonBar" height="20px" style="width: 930px">
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
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
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
                    <uc2:Footer ID="BottomFrame2" Title="Support Tables Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
