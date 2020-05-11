<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" CodeFile="WhseShipListMaintenance.aspx.cs"
    Inherits=" PFC.Intranet.ListMaintenance._WhseShipListMaintenance" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shipping List Maintenance</title>
    <link href="../MaintenanceApps/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <style>
    
    table.grid tr td {color:#333333;height:17px;}
        
        		
    .MarkItUp_ContextMenu_MenuTable {
	    border: 1 black solid ;
	    padding: 1 1 1 1 ;
	    shadow: 4 4 4 4 ;
	    z-index: 99 ;
	    background:	white;
	    position: absolute;
	     top: 0;  
        left: 0; 
        filter:	 progid:DXImageTransform.Microsoft.Shadow(color="#B1E7F1", Direction=135, Strength=4) alpha(Opacity=100);
    }

    .MarkItUp_ContextMenu_MenuItemBar {
	    border:			1px solid White;
	    width:			100% ;
	    cursor:			default  ;
    }

    .MarkItUp_ContextMenu_MenuItemBar_Over {
	    background:		#ECF3FF;
	    width:			100%;
	    cursor:			hand;
	    font-family: Verdana;
	    font-size: smaller;
	    border-bottom: 1px solid #79ABFF;
    }

    .MarkItUp_ContextMenu_MenuItem {
	    font-family: Verdana;
	    font-size: 10px;
	    color:	black;
	    text-decoration: none;
	    border-bottom: 1px solid #FFFFFF;
    }
    .MarkItUp_ContextMenu_Outline {
	    border-top: 1px solid #C4DAFF;
	    border-right: 1px solid #79ABFF;
	    border-bottom: 1px solid #79ABFF;
	    border-left: 1px solid #C4DAFF;
	    }


    .bgmsgboxtile {
	    background-image: url(../Images/bgmsgboxtile.jpg);
	    background-repeat: repeat-x;
	    border: thin solid #b3e2f0;
	    background-color: #cfedf5;
	    background-position: left bottom;
	    font-family: Arial, Helvetica, sans-serif;
	    font-size: 12px;
	    color: #003366;
    	
    }

    </style>

    <script>
    
    function SaveDetailIDToSession(chkCtlId)
    {        
        var _chkSelect = document.getElementById(chkCtlId);
        var _hidpDetailId = document.getElementById(chkCtlId.replace("_chkSelect","_pShipListId"));
        
        var result = _WhseShipListMaintenance.StoreDetailIDInSession(_hidpDetailId.value,_chkSelect.checked);            
    }
    
    function ShowGridtooltip(tooltipId, parentId, pShipListId) 
    {   
        if(event.button ==2)
        {
            // Reopen logic
            if(document.getElementById(parentId).innerHTML == 'Closed')            
            {
                document.getElementById('divReopen').style.display = '';      
                document.getElementById('divClose').style.display = 'none';        
            }
            else if(document.getElementById(parentId).innerHTML == 'Open')        
            {    
                document.getElementById('divClose').style.display = '';    
                document.getElementById('divReopen').style.display = 'none'; 
            }
            else
            {
                document.getElementById('divClose').style.display = 'none';  
                document.getElementById('divReopen').style.display = 'none'; 
            }
        
            it = document.getElementById(tooltipId); 
        
            // need to fixate default size (MSIE problem) 
            img = document.getElementById(parentId); 
           
            it.style.top =  event.clientY + 10 + 'px'; 
            it.style.left = event.clientX + 10 + 'px';
           
            // Show the tag in the position
            it.style.display = '';
           
            return false; 
        }
    }
    
    function CallBtnClick(btnCtl)
    {
        document.getElementById(btnCtl).click();
    }
    
    function HideToolTips()
    {
        if(document.getElementById('divToolTips')!=null)divToolTips.style.display='none';
        if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';
    }
    
    function OpenHelp()
    {
        window.open("../Common/Help/Shipping_List_Instructions.pdf");
        return false;
    }
    
    </script>

</head>
<body   onclick="javascript:document.getElementById('lblMessage').innerText='';" 
        onmouseup="javascript:HideToolTips();"
        onmouseout="javascript:HideToolTips();"
        scroll="no">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" border="0" id="mainTable" style="border-collapse: collapse;">
            <tr>
                <td height="5%" id="tdHeader">
                    <table id="tblBtnBanner2" runat="server" class="blueBorder" cellpadding="0" cellspacing="0"
                        style="border-collapse: collapse;" width="100%">
                        <tr runat="server" id="Tr1">
                            <td class="lightBlueBg">
                                <asp:Label ID="lblBtnHeader" runat="server" Text="Shipping List Maintenance" CssClass="BanText"
                                    Width="400px"></asp:Label></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="blueBorder" style="padding: 3px;">
                    <asp:UpdatePanel ID="pnlAddList" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" style="border-collapse: collapse;">
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                        <span>
                                            <asp:Label ID="Label2" runat="server" Text="List Name" Width="70px"></asp:Label></span></td>
                                    <td>
                                        <asp:TextBox ID="txtNewListName" runat="server" CssClass="FormCtrl" MaxLength="20"
                                            Width="150px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="ibtnAddList" CausesValidation="false" runat="server" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                            OnClick="ibtnAddList_Click" TabIndex="11" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlSearchList" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:Panel ID="plMaster" runat="server" DefaultButton="ibtnSearchList">
                                <table cellpadding="0" cellspacing="0" width="100%" class="blueBorder lightBlueBg"
                                    style="border-collapse: collapse;">
                                    <tr>
                                        <td style="padding-top: 10px;" width="100%" colspan="2">
                                            <table width="100%" style="border-collapse: collapse;" border="0" cellspacing="3"
                                                cellpadding="3">
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="width: 10px;">
                                                        <asp:Label ID="Label22" runat="server" Text="List Name" Width="63px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 10px;">
                                                        <asp:TextBox MaxLength="100" CssClass="FormCtrl" ID="txtSearchListName" runat="server"
                                                            Width="120px"></asp:TextBox>
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 20px">
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 10px;">
                                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="List Type" Width="61px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 10px;">
                                                        <asp:DropDownList ID="ddlListType" runat="server" CssClass="FormCtrl" Height="20px"
                                                            Width="95px">
                                                            <asp:ListItem Text="ALL" Value=""></asp:ListItem>
                                                            <asp:ListItem Text="Closed" Value="C"></asp:ListItem>
                                                            <asp:ListItem Text="Open" Value="O" Selected=true></asp:ListItem>
                                                            <asp:ListItem Text="Deleted" Value="D"></asp:ListItem>
                                                        </asp:DropDownList></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 50px;">
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 700px;">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="Label3" runat="server" Text="Location" Width="65px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:DropDownList ID="ddlLocation" runat="server" CssClass="FormCtrl" Height="20px"
                                                            Width="125px">
                                                        </asp:DropDownList></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Start Date" Width="61px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <uc3:novapopupdatepicker ID="dpStartDt" runat="server" />
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="Label4" runat="server" Text="User ID" Width="63px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:DropDownList ID="ddlUserId" runat="server" CssClass="FormCtrl" Height="20px"
                                                            Width="125px">
                                                        </asp:DropDownList></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="End Date" Width="60px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <uc3:novapopupdatepicker ID="dpEndDt" runat="server" />
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:ImageButton ID="ibtnSearchList" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/ShowButton.gif"
                                                            TabIndex="11" OnClick="ibtnSearchList_Click" /></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" align="right">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td style="padding-right: 10px;">
                                                                    <asp:ImageButton ID="ibtnCancel" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/cancel.gif"
                                                                        TabIndex="11" OnClick="ibtnCancel_Click" /></td>
                                                                <td>
                                                                    <asp:ImageButton ID="ImageButton2" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/help.gif" 
                                                                        OnClientClick="return OpenHelp();"
                                                                        TabIndex="11" /></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="left">
                    <asp:UpdatePanel ID="pnlGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:Panel ID="plDetail" runat="server">
                                <table width="100%" class="blueBorder" style="border-collapse: collapse;">
                                    <tr>
                                        <td align="left">
                                            <div id="div-datagrid" class="Sbar" align="center" style="overflow-x: hidden; overflow-y: auto;
                                                position: relative; top: 0px; left: 0px; height: 400px; width: 100%; border: 0px solid;">
                                                <asp:DataGrid CssClass="grid" Style="height: auto" Width="100%" runat="server" ID="dgListItem"
                                                    GridLines="both" AutoGenerateColumns="false" UseAccessibleHeader="true" AllowSorting="True"
                                                    AllowPaging="true" PagerStyle-Visible="false" OnSortCommand="dgItem_SortCommand"
                                                    TabIndex="19" OnItemDataBound="dgListItem_ItemDataBound">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" Height="10px" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="lightBlueBg" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Select">
                                                            <ItemTemplate>
                                                                <asp:CheckBox ID="chkSelect" runat="server" Checked="false" onclick="javascript:SaveDetailIDToSession(this.id);" />
                                                                <asp:HiddenField ID="pShipListId" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.pShipListHeaderID")%>' />
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="40px" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Confirm">
                                                            <ItemTemplate>
                                                                <asp:HyperLink ID="hplConfirmList" runat="server" Visible="true" Width="50px" Style="text-decoration: underline;
                                                                    color: Green" NavigateUrl='<%# "WhseShipListConfirm.aspx?ListId=" + DataBinder.Eval(Container,"DataItem.pShipListHeaderID") + "&ListName=" + DataBinder.Eval(Container,"DataItem.ShipListDesc") + "&Location=" + DataBinder.Eval(Container,"DataItem.LocationCd") + "&EntryID=" + DataBinder.Eval(Container,"DataItem.EntryID") + "&EntryDt=" + DataBinder.Eval(Container,"DataItem.EntryDt") + "&ChangeID=" + DataBinder.Eval(Container,"DataItem.ChangeID") + "&ChangeDt=" + DataBinder.Eval(Container,"DataItem.ChangeDt") +  "&ListTypeValue=" + DataBinder.Eval(Container,"DataItem.ListTypeValue") %>'
                                                                    Text="Confirm"></asp:HyperLink>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="center" Width="50px" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="List Name" SortExpression="ShipListDesc">
                                                            <ItemTemplate>
                                                                <asp:HyperLink ID="hplListName" runat="server" Visible="true" Width="120px" Style="text-decoration: underline;
                                                                    color: Red" NavigateUrl='<%# "WhseShipListDetail.aspx?ListId=" + DataBinder.Eval(Container,"DataItem.pShipListHeaderID") + "&ListName=" + DataBinder.Eval(Container,"DataItem.ShipListDesc") + "&Location=" + DataBinder.Eval(Container,"DataItem.LocationCd") + "&EntryID=" + DataBinder.Eval(Container,"DataItem.EntryID") + "&EntryDt=" + DataBinder.Eval(Container,"DataItem.EntryDt") + "&ChangeID=" + DataBinder.Eval(Container,"DataItem.ChangeID") + "&ChangeDt=" + DataBinder.Eval(Container,"DataItem.ChangeDt") +  "&ListTypeValue=" + DataBinder.Eval(Container,"DataItem.ListTypeValue") %>'
                                                                    Text='<%# DataBinder.Eval(Container,"DataItem.ShipListDesc")%>'></asp:HyperLink>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="LocationCd" HeaderText="Location" SortExpression="LocationCd">
                                                            <ItemStyle Width="50px" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="EntryDt" HeaderText="Date" SortExpression="EntryDt">
                                                            <ItemStyle Width="60px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="EntryID" SortExpression="EntryID" HeaderText="User ID">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ChangeID" SortExpression="ChangeID" HeaderText="Change ID">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ChangeDt" SortExpression="ChangeDt" HeaderText="Change Dt">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Type">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkListType" Text='<%#DataBinder.Eval(Container,"DataItem.ListType")%>'
                                                                    ToolTip="Right click for more options."
                                                                    runat="server" Style="padding-left: 5px;" Font-Underline=true oncontextmenu="return false;"></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="OrderCount" SortExpression="OrderCount" HeaderText="Order Count">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="TotalWght" SortExpression="TotalWght" HeaderText="Total Weight">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PalletCnt" SortExpression="PalletCnt" HeaderText="Pallet Count">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn></asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid><asp:Label ID="lblListMsg" Font-Bold="true" ForeColor="#cc0000" runat="server"
                                                    Text="No Records Found"></asp:Label><input type="hidden" id="hidSort" runat="server"
                                                        tabindex="17" />
                                                <asp:HiddenField ID="hidScrollTop" runat="server" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <uc4:pager ID="pager" runat="server" OnBubbleClick="Pager_PageChanged" />
                                        </td>
                                    </tr>
                                </table>
                                <div id="divDelete" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
                                    word-break: keep-all; position: absolute;" runat="server">
                                    <table border="0" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline">
                                        <tr>
                                            <td style="width: 100px;">
                                                <table border="0" cellspacing="0" width="100%">
                                                    <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                        onmouseover="this.className='GridHead'">
                                                        <td style="width: 5px;">
                                                            <div id="divDeleteItemMenu" style="width: 70px;" runat="server">
                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td>
                                                                            <img src="../Common/Images/delete.jpg" style="padding-right: 8px;" />
                                                                        </td>
                                                                        <td align="left" class="" style="cursor: hand; width: 60px;" onclick="Javascript:if(confirm('Do you want to delete this item?')){CallBtnClick('btnDeleteGridLine');}">
                                                                            <strong>Delete</strong></td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                        onmouseover="this.className='GridHead'">
                                                        <td>
                                                            <div id="divReopen" style="width: 70px;" runat="server">
                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td>
                                                                            <img src="../Common/Images/check.gif" style="width: 18px; height: 18px; padding-right: 5px;" />
                                                                        </td>
                                                                        <td align="left" class="" style="cursor: hand;" onclick="Javascript:return CallBtnClick('btnReopenList');">
                                                                            <asp:Label ID="lblSplitItemDesc" Width="55px" runat="server" Text="Reopen" Font-Bold="true"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                        onmouseover="this.className='GridHead'">
                                                        <td>
                                                            <div id="divClose" style="width: 70px;" runat="server">
                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td>
                                                                            <img src="../Common/Images/check.gif" style="width: 18px; height: 18px; padding-right: 5px;" />
                                                                        </td>
                                                                        <td align="left" class="" style="cursor: hand;" onclick="Javascript:return CallBtnClick('btnCloseList');">
                                                                            <asp:Label ID="Label10" Width="55px" runat="server" Text="Close" Font-Bold="true"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                                        onmouseover="this.className='GridHead'">
                                                        <td style="width: 5px;">
                                                            <div id="divCancelMenu" style="width: 70px;" runat="server">
                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td>
                                                                            <img src="../Common/Images/cancelrequest.gif" style="padding-right: 8px;" />
                                                                        </td>
                                                                        <td align="left" class="" style="cursor: hand;" onclick="Javascript:document.getElementById('divDelete').style.display='none';document.getElementById(hidRowID.value).style.fontWeight='normal';">
                                                                            <strong>Cancel</strong><asp:HiddenField runat="server" value="" id="hidRowID" /></td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlTotal" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%" class="blueBorder lightBlueBg"
                                style="padding: 5px;">
                                <tr>
                                    <td>
                                        <table runat="server" id="tblTotal" border="0">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label1" runat="server" Text="Calculated Totals" Width="110px" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Order Count:" Width="73px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblOrderTotal" runat="server" Font-Bold="True" Width="40px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Total Weight:" Width="75px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblTotalWght" runat="server" Font-Bold="True" Width="73px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Pallet Count:" Width="75px"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblTotalPalletCnt" runat="server" Font-Bold="True" Width="73px"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                    </td>
                                    <td style="width: 50px;padding-top:8px;">
                                        <asp:ImageButton ID="ibtnCalculate" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/Calculate.GIF"
                                            OnClick="ibtnCalculate_Click" TabIndex="11" />
                                        <asp:Button ID="btnDeleteGridLine" CausesValidation="false" runat="server" 
                                            OnClick="btnDeleteGridLine_Click" TabIndex="11" style="display:none;" />
                                        <asp:Button ID="btnReopenList" CausesValidation="false" runat="server" 
                                            OnClick="btnReopenList_Click" TabIndex="11" style="display:none;" />
                                        <asp:Button ID="btnCloseList" CausesValidation="false" runat="server" 
                                            OnClick="btnCloseList_Click" TabIndex="11" style="display:none;" />
                                    </td>
                                    <td style="width: 50px; padding-right: 13px;">
                                        <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();" /></td>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
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
                    <uc2:BottomFooter ID="ucFooter" Title="Warehouse Shipping List Summary" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
    </form>
</body>
</html>
