<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="CompetitorPriceMaint.aspx.cs"
    Inherits="CompetitorPriceMaint" %>

<%@ Register Src="../Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc6" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc4" %>
<%@ Register Src="~/Common/UserControls/PhoneNumber.ascx" TagName="Phone" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Competitor Price Maintenance</title>    
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
<style>
.cnt 
{
	font-family: Arial;	
	font-size: 11px;	
	font-weight: normal;	
	color: #000000;	
	margin-left: 15px;
}
</style>
    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <script>
       
    function zItem(itemNo)
    {
        document.getElementById("lblMessage").innerText = "";

        if(itemNo != "")
        {
            var section = "";
            var completeItem = 0;
            var result = "";
            var status = "";

            switch(itemNo.split('-').length)
            {
                case 1:
                    event.keyCode = 0;
                    itemNo = "00000" + itemNo;
                    itemNo = itemNo.substr(itemNo.length-5,5);
                    document.getElementById("txtPFCItemNo").value = itemNo + "-"; 
                    break;
                case 2:
                    ////close if they are entering an empty part
                    //if (itemNo.split('-')[0] == "00000") {ClosePage()};
                    event.keyCode = 0;
                    section = "0000" + itemNo.split('-')[1];
                    section = section.substr(section.length-4,4);
                    document.getElementById("txtPFCItemNo").value = itemNo.split('-')[0] + "-" + section + "-";  
                    break;
                case 3:
                    event.keyCode = 0;
                    section = "000" + itemNo.split('-')[2];
                    section = section.substr(section.length-3,3);
                    document.getElementById("txtPFCItemNo").value = itemNo.split('-')[0] + "-" + itemNo.split('-')[1] + "-" + section;  
                    completeItem = 1;
                    break;
            }

            if (completeItem == 1)
            {
                itemNo = document.getElementById("txtPFCItemNo").value;
                document.getElementById("btnGetItem").click();
            }
        }
        else
        {
            event.keyCode = 0;
            document.getElementById("txtPFCItemNo").focus();
        }
    }
    
    function RefreshPricingWorkSheet()
    {
        window.opener.parent.document.getElementById("btnRefreshCompPrice").click();
    }

    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';if(document.getElementById('divToolTips')!=null)document.getElementById('divToolTips').style.display = 'none';">
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
                <td class="Left2pxPadd boldText lightBlueBg">
                    <asp:UpdatePanel ID="upnlbtnSearch" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td style="padding-left: 5px;">
                                                        <asp:Label ID="Label1" runat="server" Text="Competitor Name" Width="105px"></asp:Label></td>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlCompName" runat="server" CssClass="FormCtrl" Height="20px"
                                                            Width="180px">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td style="padding-left: 10px;">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td style="width: 80px">
                                                                    <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                                        OnClick="btnSearch_Click" CausesValidation="False" TabIndex="16" /></td>
                                                                <td style="width: 100px">
                                                                    <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                                        runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="17"/></td>
                                                            </tr>
                                                        </table>
                                                        <asp:HiddenField ID="hidPrimaryKey" runat="server" />
                                                        <asp:HiddenField ID="hidRegionId" runat="server" />
                                                        <asp:HiddenField ID="hidCompName" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td style="height: 16px; padding-right: 10px;" align="right">
                                            <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                tabindex="18" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <asp:UpdatePanel ID="pnlPriceMaint" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table id="tblPriceMaint" runat="server" visible="false" width="100%" border="0"
                                cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <table  id="tblPriceMaintHeader" runat="server" class="blueBorder" width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="lightBlueBg">
                                                    <asp:Label ID="lblHeading" runat="server" Text="Enter Competitor Price" CssClass="BanText"
                                                        Width="325px"></asp:Label></td>
                                                <td style="height: 5px" align="right" class="lightBlueBg">
                                                    &nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="padding-top: 0px; padding-left: 5px;">
                                                    <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <asp:Panel ID="Panel1" runat="server" DefaultButton="btnEmpty">
                                                                <table border="0" cellpadding="2" cellspacing="2" id="tblDataEntry" runat="server">
                                                                    <tr>
                                                                        <td style="width: 100px">
                                                                            <asp:LinkButton ID="lnkCode" Font-Underline="True" Text="PFC Item No:" TabIndex="14"
                                                                                runat="server" Font-Bold="True" Width="108px"></asp:LinkButton></td>
                                                                        <td style="width: 100px">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtPFCItemNo" AutoCompleteType="Disabled"
                                                                                            TabIndex="1" MaxLength="14" Width="125px" OnFocus="javascript:this.select();"
                                                                                            OnKeyDown="javascript:if(event.keyCode==9)event.keyCode=13;return event.keyCode;"
                                                                                            OnKeyPress="javascript:if(event.keyCode==13)zItem(this.value);"></asp:TextBox>
                                                                                        <asp:Button ID="btnGetItem" runat="server" Style="display: none;" OnClick="btnGetItem_Click"
                                                                                            CausesValidation="false" />
                                                                                    </td>
                                                                                    <td style="padding-left:3px;">
                                                                                        <span style="color: Red;"><b>*</b></span></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td style="width: 20px">
                                                                        </td>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Competitor Price:" Width="108px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox ID="txtCompPrice" runat="server" CssClass="FormCtrl" Width="87px" TabIndex="5" onkeypress="ValdatePercentage();"></asp:TextBox>
                                                                                        <asp:HiddenField ID="hidPreviousPrice" runat="server" />
                                                                                    </td>
                                                                                    <td  style="padding-left:3px;">
                                                                                        <span style="color: Red;"><b>*</b></span></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td style="width: 20px">
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Weight/UM:" Width="70px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <asp:TextBox ID="txtWghtPerUM" runat="server" CssClass="FormCtrl" Width="87px" TabIndex="10"  onkeypress="ValdatePercentage();"></asp:TextBox></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="PFC Sell UM:" Width="108px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="lblPFCSellUM" runat="server" Width="126px"></asp:Label></td>
                                                                        <td>
                                                                        </td>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Competitor Price UM:"
                                                                                Width="120px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <asp:TextBox ID="txtCompPriceUM" runat="server" CssClass="FormCtrl" Width="87px"
                                                                                TabIndex="6"></asp:TextBox></td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Stock Ind:" Width="70px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                <tr>
                                                                                    <td style="width: 100px">
                                                                                        <asp:RadioButton ID="rdoStockYes" runat="server" Font-Bold="True" Text="Yes" TabIndex="11"
                                                                                            Checked="True" GroupName="Stock" /></td>
                                                                                    <td style="width: 100px">
                                                                                        <asp:RadioButton ID="rdoStockNo" runat="server" Font-Bold="True" Text="No" TabIndex="12"
                                                                                            GroupName="Stock" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="PFC Cust No:" Width="129px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <asp:TextBox ID="txtPFCCustNo" runat="server" CssClass="FormCtrl" Width="125px" TabIndex="2"></asp:TextBox></td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Competitor Price Dt:"
                                                                                Width="118px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <uc4:novapopupdatepicker ID="dpCompPriceDt" runat="server" TabIndex="7" />
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td style="width: 100px">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Competitor Item No:"
                                                                                Width="129px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <asp:TextBox ID="txtCompItemNo" runat="server" CssClass="FormCtrl" Width="125px"
                                                                                TabIndex="3"></asp:TextBox></td>
                                                                        <td>
                                                                        </td>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Comp. Price/100Lbs:"
                                                                                Width="119px"></asp:Label></td>
                                                                        <td style="width: 100px">
                                                                            <asp:TextBox ID="txtCompPricePerLb" runat="server" CssClass="FormCtrl" Width="87px" onkeypress="ValdatePercentage();"
                                                                                TabIndex="8"></asp:TextBox></td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td style="width: 100px">
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 100px; height: 16px">
                                                                            <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Competitor Item Desc:"
                                                                                Width="129px"></asp:Label></td>
                                                                        <td style="width: 100px; height: 16px">
                                                                            <asp:TextBox ID="txtCompItemDesc" runat="server" CssClass="FormCtrl" Width="125px"
                                                                                TabIndex="4"></asp:TextBox></td>
                                                                        <td>
                                                                        </td>
                                                                        <td style="width: 100px; height: 16px">
                                                                            <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="PcsCount:" Width="70px"></asp:Label></td>
                                                                        <td style="width: 100px; height: 16px">
                                                                            <asp:TextBox ID="txtPcsCount" runat="server" CssClass="FormCtrl" Width="87px" TabIndex="9"  onkeypress="ValdatePercentage();"></asp:TextBox></td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td style="width: 100px; height: 16px">
                                                                            <asp:Button ID="btnEmpty" runat="server" Style="display: none;" OnClick="btnGetItem_Click"
                                                                                CausesValidation="false" /></td>
                                                                    </tr>
                                                                </table>
                                                                <div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
                                                                    <table border="0" cellpadding="0" cellspacing="0" style="border-color: Black; border: 1px;">
                                                                        <tr>
                                                                            <td>
                                                                                <span class="boldText">Change ID: </span>
                                                                                <asp:Label ID="lblChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                            <td style="font-weight: bold">
                                                                                <span class="boldText" style="padding-left: 5px;">Change Date: </span>
                                                                                <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                        </tr>
                                                                        <tr style="font-weight: bold">
                                                                            <td>
                                                                                <span class="boldText">Entry ID: </span>
                                                                                <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                            <td>
                                                                                <span class="boldText" style="padding-left: 5px;">Entry Date: </span>
                                                                                <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </asp:Panel>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="lightBlueBg" align="right" colspan="2" style="border-right: medium none;
                                                    border-top: medium none; border-left: medium none; padding-top: 1px; border-bottom: medium none;
                                                    height: 25px;">
                                                    <asp:UpdatePanel ID="upnlButtons" UpdateMode="conditional" runat="server">
                                                        <ContentTemplate>
                                                            <table border="0">
                                                                <tr>
                                                                    <td class="lightBlueBg" style="border-right: medium none; border-top: medium none;
                                                                        border-left: medium none; padding-top: 1px; border-bottom: medium none; height: 25px;
                                                                        text-align: left">
                                                                    </td>
                                                                    <td class="lightBlueBg" style="padding-top: 1px; height: 25px; text-align: left;
                                                                        border: none;">
                                                                        <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                                            runat="server" OnClick="btnSave_Click" Visible="false" TabIndex="14" /></td>
                                                                    <td class="lightBlueBg" style="padding-top: 1px; height: 25px; text-align: right;
                                                                        border: none; padding-left: 0px; padding-right: 10px;">
                                                                        <asp:ImageButton ID="btnCancel" ImageUrl="~/MaintenanceApps/Common/images/cancel.png"
                                                                            runat="server" TabIndex="15" Visible="false" OnClick="btnCancel_Click1" /></td>
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
                                    <td>
                                        <asp:UpdatePanel ID="upnlGrid" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <table id="tblGrid" runat=server width="100%" border=0 cellpadding="0" cellspacing="0">
                                                    <tr class="lightBlueBg">
                                                        <td class="lightBlueBg" style="padding-top: 1px; height: 7px; width: 4%;">                                                            
                                                                <asp:Label ID="lblGridHeading" runat="server" CssClass="BanText" Text="Competitor Price"
                                                                    Width="325px"></asp:Label></td>
                                                        <td class="lightBlueBg" style="padding-top: 1px; height: 1px; width: 5%;">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="padding-top: 1px; height: 7px;" colspan="2">
                                                            <div id="divdatagrid" runat=server class="Sbar" style="overflow-x: auto; overflow-y: auto; position: relative;
                                                                top: 0px; left: 0px; height: 340px; width: 1010px; border: 0px solid;" align="left">
                                                                <asp:DataGrid CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="dgCompPrice"
                                                                    GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                                    AllowSorting="True" ShowFooter="False" OnItemCommand="dgCompPrice_ItemCommand"
                                                                    OnSortCommand="dgCompPrice_SortCommand" OnItemDataBound="dgCompPrice_ItemDataBound"
                                                                    TabIndex="19" Width="1300px" AllowPaging=true>
                                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                                    <ItemStyle CssClass="GridItem" />
                                                                    <AlternatingItemStyle CssClass="zebra" />
                                                                    <FooterStyle CssClass="lightBlueBg" />
                                                                    <Columns>
                                                                        <asp:TemplateColumn HeaderText="Actions">
                                                                            <ItemTemplate>
                                                                                <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                                    Style="padding-left: 5px" runat="server" CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pCompetitorItemsID")%>'>Edit</asp:LinkButton>
                                                                                <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                                    Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                                    CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pCompetitorItemsID")%>'>Delete</asp:LinkButton>
                                                                            </ItemTemplate>
                                                                            <ItemStyle Width="80px" />
                                                                        </asp:TemplateColumn>
                                                                        <asp:BoundColumn DataField="PFCItemNo" HeaderText="PFC Item #" SortExpression="PFCItemNo">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="120px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="120px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="PFCSellUM" HeaderText="PFC Sell UM" SortExpression="PFCSellUM">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="50px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="50px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorItemNo" HeaderText="Comp. Item #" SortExpression="CompetitorItemNo">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="100px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorItemDesc" HeaderText="Comp. Item Desc" SortExpression="CompetitorItemDesc">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="150px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="150px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="PFCCustNo" HeaderText="PFC. Cust #" SortExpression="PFCCustNo">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="100px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorPrice" HeaderText="Comp. Price" SortExpression="CompetitorPrice">
                                                                            <ItemStyle Width="50px" HorizontalAlign="Right" />
                                                                            <HeaderStyle Width="50px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorPriceUM" HeaderText="Comp. Price UM" SortExpression="CompetitorPriceUM">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="50px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="50px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorPriceDate" HeaderText="Comp. Price Dt" SortExpression="CompetitorPriceDate">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="50px" HorizontalAlign="Center" />
                                                                            <HeaderStyle Width="50px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorPricePer100Lbs" HeaderText="Comp. Price/100Lbs"
                                                                            SortExpression="CompetitorPricePer100Lbs">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Right" />
                                                                            <HeaderStyle Width="60px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorPcsCount" HeaderText="Comp. Pcs Count" SortExpression="CompetitorPcsCount">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Right" />
                                                                            <HeaderStyle Width="60px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorWghtPerUM" HeaderText="Comp. Wght Per UM" SortExpression="CompetitorWghtPerUM">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Right" />
                                                                            <HeaderStyle Width="70px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="CompetitorStockInd" HeaderText="Stock Ind" SortExpression="CompetitorStockInd">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="50px" HorizontalAlign="Center" />
                                                                            <HeaderStyle Width="50px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="60px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="EntryDt" HeaderText="Enter Date" DataFormatString="{0:MM/dd/yyyy}"
                                                                            SortExpression="EntryDt">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="60px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="60px" />
                                                                        </asp:BoundColumn>
                                                                        <asp:BoundColumn DataField="ChangeDt" HeaderText="Change Dt" DataFormatString="{0:MM/dd/yyyy}"
                                                                            SortExpression="ChangeDt">
                                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Left" />
                                                                            <HeaderStyle Width="60px" />
                                                                        </asp:BoundColumn>
                                                                    </Columns>
                                                                </asp:DataGrid>
                                                                <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                                                <input type="hidden" id="hidpCompetitorItemsID" runat="server" tabindex="12" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="lightBlueBg"  width="100%" colspan="2"  >
                                                            <uc5:Pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged"/>                                                        
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
                <td style="width: 1253px">
                    <uc2:Footer ID="BottomFrame2" Title="Competitor Price Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
