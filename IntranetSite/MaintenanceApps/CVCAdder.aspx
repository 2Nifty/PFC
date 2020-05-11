<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CVCAdder.aspx.cs" Inherits="CVCAdderPage" %>

<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>CVC Adder Maintenance</title>
    <link href="../MaintenanceApps/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
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

    <script>
    function PopulateRegions()
    {
        var corpValue = document.getElementById("txtCorpCurrent").value;
        document.getElementById("txtNWCurrent").value = corpValue;
        document.getElementById("txtCNTRLCurrent").value = corpValue;
        document.getElementById("txtNWCurrent").value = corpValue;
        document.getElementById("txtWESTCurrent").value = corpValue;
        document.getElementById("txtMTNCurrent").value = corpValue;
        document.getElementById("txtSWCurrent").value = corpValue;
        document.getElementById("txtSECurrent").value = corpValue;
        document.getElementById("txtNECurrent").value = corpValue;
    }
    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';"
    onmouseup="divToolTips.style.display='none';">
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
                <td style="padding-top: 1px;">
                    <table style="width: 100%" class="blueBorder" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="lightBlueBg" colspan="2">
                                <asp:UpdatePanel ID="upnlbtnSearch" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                            <table>
                                                <tr>
                                                    <td style="padding-left: 10px">
                                                        <asp:Label ID="lblSch" runat="server" Font-Bold="True" Text="Category:" Width="65px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtSearchCategory" runat="server" CssClass="FormCtrl" TabIndex="1"
                                                            Width="70px"></asp:TextBox></td>
                                                    <td style="padding-left: 20px">
                                                        <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Plating:" Width="50px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtSearchPlating" runat="server" CssClass="FormCtrl" TabIndex="2"
                                                            Width="70px"></asp:TextBox></td>
                                                    <td>
                                                        <asp:ImageButton ID="btnSearch" runat="server" CausesValidation="False" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                            OnClick="btnSearch_Click" TabIndex="3" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="lightBlueBg">
                                <asp:Label ID="lblHeading" runat="server" Text="CVC Adder Maintenance" CssClass="BanText"
                                    Width="334px"></asp:Label></td>
                            <td style="width: 100%; height: 5px" align="right" class="lightBlueBg">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <asp:ImageButton ID="btnExportExcel" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                runat="server" CausesValidation="False" TabIndex="5" OnClick="btnExportExcel_Click" />
                                        </td>
                                        <td>
                                            <asp:UpdatePanel ID="upnlAdd" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="width: 80px">
                                                                <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                                    runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="5" />
                                                            </td>
                                                            <td style="width: 80px">
                                                                <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                                    tabindex="4" />
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
                        <tr>
                            <td colspan="2">
                                <div style="width: 300px">
                                    <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <table style="padding-left: 10px" align="left">
                                                <tr>
                                                    <td class="DarkBluTxt">
                                                    </td>
                                                    <td colspan="3">
                                                        <div id="divToolTips" class="list" style="display: none; position: absolute; width: 260px"
                                                            onmouseup="return false;">
                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td>
                                                                        <span class="boldText">Change ID: </span>
                                                                        <asp:Label ID="lblChangeID" runat="server" Font-Bold="False"></asp:Label></td>
                                                                    <td>
                                                                        <span class="boldText" style="padding-left: 5px;">Change Date: </span>
                                                                        <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <span class="boldText">Entry ID: </span>
                                                                        <asp:Label ID="lblEntryID" runat="server" Font-Bold="False"></asp:Label></td>
                                                                    <td>
                                                                        <span class="boldText" style="padding-left: 5px;">Entry Date: </span>
                                                                        <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                    <td colspan="10" align="center">
                                                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Adder Entry"></asp:Label>
                                                        <asp:HiddenField ID="hidPrimaryKey" runat="server" Value="" />
                                                        <asp:HiddenField ID="hidFileName" runat="server" Value="" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" class="DarkBluTxt">
                                                        <asp:LinkButton ID="lnkCode" runat="server" Style="text-decoration: underline" Text="Category:"
                                                            Width="80px" TabIndex="21" Font-Bold="True"></asp:LinkButton></td>
                                                    <td colspan="3" style="padding-right: 10px">
                                                        <asp:DropDownList ID="ddlCategory" Height="20px" CssClass="FormCtrl" runat="server"
                                                            Width="220px" TabIndex="6">
                                                        </asp:DropDownList></td>
                                                    <td class="DarkBluTxt">
                                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Corp"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtCorpCurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="10" Width="50px" onblur="javascript:PopulateRegions();"></asp:TextBox></td>
                                                    <td style="padding-left: 10px; width: 100px">
                                                        <asp:Label ID="lblCorpPrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                    <td style="padding-left: 20px; width: 100px">
                                                        <asp:Label ID="Label8" runat="server" Height="16px" Text="NW" Width="40px" Font-Bold="True"></asp:Label></td>
                                                    <td style="padding-left: 10px; width: 100px">
                                                        <asp:TextBox ID="txtNWCurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="13" Width="50px"></asp:TextBox></td>
                                                    <td style="padding-left: 10px; width: 100px">
                                                        <asp:Label ID="lblNWPrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                    <td style="padding-left: 20px; width: 100px">
                                                        <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="CNTRL"></asp:Label></td>
                                                    <td style="padding-left: 10px; width: 100px">
                                                        <asp:TextBox ID="txtCNTRLCurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="16" Width="50px"></asp:TextBox></td>
                                                    <td style="padding-left: 10px; width: 100px">
                                                        <asp:Label ID="lblCNTRLPrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td style="height: 26px;" class="DarkBluTxt">
                                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Plating:"></asp:Label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlPlating" CssClass="FormCtrl" Height="20px" runat="server"
                                                            Width="100px" TabIndex="7">
                                                        </asp:DropDownList></td>
                                                    <td style="width: 100px">
                                                    </td>
                                                    <td style="width: 100px">
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="Label6" runat="server" Height="16px" Text="Pkg/Case" Width="60px"
                                                            CssClass="DarkBluTxt"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtPkgCaseCurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="11" Width="50px"></asp:TextBox></td>
                                                    <td style="width: 100px" class="DarkBluTxt">
                                                        <asp:Label ID="lblPkgCasePrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                    <td class="DarkBluTxt" style="width: 100px; padding-left: 20px;">
                                                        <asp:Label ID="Label17" runat="server" Font-Bold="True" Text="MTN"></asp:Label></td>
                                                    <td class="DarkBluTxt" style="width: 100px">
                                                        <asp:TextBox ID="txtMTNCurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="14" Width="50px"></asp:TextBox></td>
                                                    <td class="DarkBluTxt" style="width: 100px">
                                                        <asp:Label ID="lblMTNPrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                    <td class="DarkBluTxt" style="padding-left: 20px">
                                                        <asp:Label ID="Label19" runat="server" Font-Bold="True" Text="SE"></asp:Label></td>
                                                    <td class="DarkBluTxt" style="width: 100px">
                                                        <asp:TextBox ID="txtSECurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="17" Width="50px"></asp:TextBox></td>
                                                    <td class="DarkBluTxt" style="width: 100px">
                                                        <asp:Label ID="lblSEPrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td style="height: 26px;" class="DarkBluTxt">
                                                        <asp:Label ID="Label4" runat="server" Height="16px" Text="CVC:" Width="78px" Font-Bold="True"></asp:Label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlCVCCode" CssClass="FormCtrl" Height="20px" runat="server"
                                                            Width="100px" TabIndex="8">
                                                        </asp:DropDownList></td>
                                                    <td>
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td class="DarkBluTxt">
                                                        <asp:Label ID="Label7" runat="server" Height="16px" Text="WEST" Width="60px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtWestCurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="12" Width="50px"></asp:TextBox></td>
                                                    <td class="DarkBluTxt">
                                                        <asp:Label ID="lblWestPrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                    <td class="DarkBluTxt" style="padding-left: 20px">
                                                        <asp:Label ID="Label18" runat="server" Font-Bold="True" Text="SW"></asp:Label></td>
                                                    <td class="DarkBluTxt">
                                                        <asp:TextBox ID="txtSWCurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="15" Width="50px"></asp:TextBox></td>
                                                    <td class="DarkBluTxt">
                                                        <asp:Label ID="lblSWPrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                    <td class="DarkBluTxt" style="padding-left: 20px">
                                                        <asp:Label ID="Label20" runat="server" Font-Bold="True" Text="NE"></asp:Label></td>
                                                    <td class="DarkBluTxt">
                                                        <asp:TextBox ID="txtNECurrent" runat="server" CssClass="FormCtrl" MaxLength="20"
                                                            TabIndex="18" Width="50px"></asp:TextBox></td>
                                                    <td class="DarkBluTxt">
                                                        <asp:Label ID="lblNEPrevious" runat="server" Font-Bold="False" ForeColor="Gray"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td class="DarkBluTxt" style="height: 26px;">
                                                        <asp:Label ID="Label1" runat="server" Font-Bold="True" Height="16px" Text="Effective Date:"
                                                            Width="80px"></asp:Label></td>
                                                    <td>
                                                        <uc3:novapopupdatepicker ID="dpEffectiveDt" runat="server" TabIndex="9" />
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td class="DarkBluTxt">
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td class="DarkBluTxt">
                                                    </td>
                                                    <td class="DarkBluTxt" style="padding-left: 20px">
                                                    </td>
                                                    <td class="DarkBluTxt">
                                                    </td>
                                                    <td class="DarkBluTxt">
                                                    </td>
                                                    <td class="DarkBluTxt">
                                                    </td>
                                                    <td class="DarkBluTxt">
                                                    </td>
                                                    <td class="DarkBluTxt">
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="lightBlueBg" style="padding-top: 1px; height: 30px; padding-left: 200px;
                                text-align: left; border: none;">
                                <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 100px">
                                                    <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                        runat="server" OnClientClick="javascript:return CVCAdderRequiredField();" OnClick="btnSave_Click"
                                                        Visible="false" TabIndex="19" /></td>
                                                <td style="padding-left: 10px; width: 150px">
                                                    <asp:ImageButton ID="btnCancel" ImageUrl="~/MaintenanceApps/Common/images/cancel.png"
                                                        runat="server" CausesValidation="False" OnClick="btnCancel_Click" TabIndex="20" /></td>
                                                <td style="padding-left: 10px; width: 150px">
                                                    <asp:ImageButton ID="btnSetAllEffDt" ImageUrl="~/MaintenanceApps/Common/images/SetAll.gif"
                                                        runat="server" OnClick="btnSetAllEffDt_Click"
                                                        Visible="false" TabIndex="19" /></td>
                                            </tr>
                                        </table>
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
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 30px; width: 4%; padding-left: 10px;">
                                        <asp:CheckBox ID="chkShowDelete" runat="server" Text="Show Deleted Records" Font-Bold="True"
                                            TabIndex="22" AutoPostBack="True" OnCheckedChanged="chkShowDelete_CheckedChanged" /></td>
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 1px; width: 5%;">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                        <div id="div-datagrid" class="Sbar" style="overflow-x: auto; overflow-y: auto; position: relative;
                                            top: 0px; left: 0px; height: 325px; width: 1020px; border: 0px solid;" align="left">
                                            <asp:DataGrid CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="dgCVCAdder"
                                                GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                AllowSorting="True" PagerStyle-Visible="false" ShowFooter="False" AllowPaging="true"
                                                OnItemCommand="dgCountryCode_ItemCommand" Width="1000px" OnSortCommand="dgCountryCode_SortCommand"
                                                OnItemDataBound="dgCountryCode_ItemDataBound" TabIndex="18">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <FooterStyle CssClass="lightBlueBg" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Actions">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pCVCAddersID")%>'>Edit</asp:LinkButton>
                                                            <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pCVCAddersID")%>'>Delete</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="90px" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="Category" HeaderText="Category" SortExpression="Category">
                                                        <ItemStyle Width="50px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Plating" HeaderText="Pltng" SortExpression="Plating">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="CVCCd" HeaderText="CVC" SortExpression="CVCCd">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="CorpAdder" HeaderText="Corp" SortExpression="CorpAdder">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="STDCostAdder" HeaderText="StdCost" SortExpression="STDCostAdder">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Packagecaseadder" HeaderText="Pkg/Case" SortExpression="Packagecaseadder">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="1West" HeaderText="West" SortExpression="1West">
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="30px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="2NW" HeaderText="NW" SortExpression="2NW">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="3Mtn" HeaderText="Mtn" SortExpression="3Mtn">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="4SW" HeaderText="SW" SortExpression="4SW">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="5Cntrl" HeaderText="Cntrl" SortExpression="5Cntrl">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="6SE" HeaderText="SE" SortExpression="6SE">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="7NE" HeaderText="NE" SortExpression="7NE">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EffectiveDt" HeaderText="Eff Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="EffectiveDt">
                                                        <ItemStyle Width="55px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryDt" HeaderText="Entry Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="EntryDt">
                                                        <ItemStyle Width="55px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeDt" HeaderText="Change Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="ChangeDt">
                                                        <ItemStyle Width="55px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="DeleteDt" HeaderText="Delete Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="DeleteDt">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                            <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                            <asp:HiddenField ID="hidScrollTop" runat="server" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-top: 1px; height: 7px">
                                        <uc4:pager ID="pager" runat="server" OnBubbleClick="Pager_PageChanged" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="lightBlueBg" height="20px" style="width: 930px">
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
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false" DisplayAfter="0">
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
                    <uc2:Footer ID="BottomFrame2" Title="CVC Adder Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
