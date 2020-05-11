<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="WhseShipListConfirm.aspx.cs"
    Inherits=" PFC.Intranet.ListMaintenance._WhseShipListConfirm" ValidateRequest="false" %>

<%@ Register Src="../Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="../PrintUtility/Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc6" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shipping List Confirmation</title>
    <link href="../MaintenanceApps/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
    <style>
        table.grid tr td {color:#333333;height:17px;}
    </style>
    <style>
    .barcode
    {
        font-size : 12pt;
        font-family : IDAutomationC39S;
    }
    </style>
    <script>
    
    function PrintReport()
    {  
        var WinPrint = window.open('../Common/ErrorPage/print.aspx','Print','height=710,width=710,scrollbars=no,status=no,top=0,left=0,resizable=NO',"");       
    } 
    </script>
    
</head>


<body 
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';"
    scroll="no">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="scmListDtl" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" border="0" id="mainTable" style="border-collapse: collapse;">
            <tr>
                <td height="5%" id="tdHeader">
                    <table id="tblBtnBanner2" runat="server" class="blueBorder" cellpadding="0" cellspacing="0"
                        style="border-collapse: collapse;" width="100%">
                        <tr runat="server" id="Tr1">
                            <td class="lightBlueBg">
                                <asp:Label ID="lblBtnHeader" runat="server" Text="Shipping List Confirmation"
                                    CssClass="BanText" Width="400px"></asp:Label></td>                            
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
                                            <asp:Label ID="Label2" runat="server" Text="List Name:" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblListName" runat="server" Font-Bold="True" Text="" Width="150px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Location:" Width="50px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblLocation" runat="server" Font-Bold="True" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Entry ID:" Width="45px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblEntryID" runat="server" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="Date:" Width="30px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblEntryDt" runat="server" Font-Bold="True" Width="90px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Change ID:" Width="59px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblChangeId" runat="server" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Date:" Width="30px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblChangeDt" runat="server" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblListType" runat="server" Text="List Type: Deleted" ForeColor=red Font-Bold="True" Width="110px" Visible=false></asp:Label></td>
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
                            <asp:Panel ID="plMaster" runat="server" DefaultButton="btnAddItem">
                                <table cellpadding="0" cellspacing="0" width="100%" class="blueBorder lightBlueBg"
                                    style="border-collapse: collapse;">
                                    <tr>
                                        <td style="padding-top: 10px;" width="100%" colspan="2">
                                            <table width="100%" style="border-collapse: collapse;" border="0" cellspacing="3"
                                                cellpadding="3">
                                                <tr>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 10px;">
                                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Document No:" Width="78px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 10px;">
                                                        <asp:TextBox ID="txtNewDocNo" runat="server" CssClass="FormCtrl" 
                                                            onfocus="javascript:this.select();"
                                                            onkeydown="javascript:if(event.keyCode==37){document.getElementById('txtNewPalletNo').focus();}"
                                                            MaxLength="20" Width="120px"></asp:TextBox></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 50px;">
                                                        <asp:ImageButton ID="btnAddItem" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/confirm.gif"
                                                            TabIndex="11" OnClick="btnAddItem_Click" OnClientClick="CheckDuplicate();" /></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 700px;">
                                                        <asp:HiddenField ID="hidpListdtlId" runat="server" />                                                        
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width:60px;">
                                                        <uc6:PrintDialogue ID="PrintDialogue1" runat="server" />
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
                                                position: relative; top: 0px; left: 0px; height: 510px; width: 100%; border: 0px solid;">
                                                <asp:DataGrid CssClass="grid" Style="height: auto" Width="100%" runat="server" ID="dgListItem"
                                                    GridLines="both" AutoGenerateColumns="false" UseAccessibleHeader="true" AllowSorting="True"
                                                    AllowPaging="true" PagerStyle-Visible="false" OnSortCommand="dgItem_SortCommand" ShowFooter=true
                                                    TabIndex="19" OnItemDataBound="dgListItem_ItemDataBound">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="zebra" Height=20px  />
                                                    <Columns>                                                                                                                
                                                        <asp:BoundColumn DataField="OrderNo" HeaderText="Document No" SortExpression="OrderNo">
                                                            <ItemStyle Width="80px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CustName" SortExpression="CustName" HeaderText="Customer Name">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="150px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PalletNo" HeaderText="Pallet No" SortExpression="PalletNo">
                                                            <ItemStyle Width="80px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>  
                                                        <asp:BoundColumn DataField="ShipWght" SortExpression="ShipWght" HeaderText="Doc Lbs">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Right" />
                                                            <FooterStyle HorizontalAlign=Right Font-Bold=true /> 
                                                        </asp:BoundColumn>                                                 
                                                        <asp:BoundColumn DataField="EntryID" SortExpression="EntryID" HeaderText="EntryID">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="80px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ChangeID" SortExpression="ChangeID" HeaderText="Change ID">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="80px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CustPONo" SortExpression="CustPONo" HeaderText="PO #">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="140px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>                                                        
                                                        <asp:BoundColumn DataField="StatusCd" SortExpression="StatusCd" HeaderText="Status">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Center" />
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
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" height="20px">
                    <table width="100%">
                        <tr>
                            <td>
                                <table border=0>
                                    <tr>
                                        <td>
                                            <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false">
                                                <ProgressTemplate>
                                                    <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                                </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                        <td>
                                        
                                            <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                        runat="server" Text=""></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td align="right" style="padding-right: 10px;">
                                <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFooter ID="ucFooter" Title="Warehouse Shipping List - Confirmation" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
