<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="WhseShipListDetail.aspx.cs"
    Inherits=" PFC.Intranet.ListMaintenance._WhseShipListDetail" ValidateRequest="false" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shipping List Detail</title>
    <link href="../MaintenanceApps/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
    <style>
        table.grid tr td {color:#333333;height:17px;}
    </style>
    <script>
    
    function SetPreviousValue(PreviousValue,CtrlTxtID)
    {
        if(PreviousValue !="")
        {
            document.getElementById(CtrlTxtID.replace("txtPalletNo","hidPrivousValue")).value = PreviousValue;
        }
    }

    function EnterToTab(e,ctlId)
    {
        if(event.keyCode ==13)
        {    
            event.keyCode = 9; 
            return event.keyCode;
        }
    }
    
    function UpdatePalletNo(txtPalletNoId)
    {
        var _pListDetailId = document.getElementById(txtPalletNoId.replace("_txtPalletNo","_hidpListDetailId")).value;          
        var _docNo = document.getElementById(txtPalletNoId.replace("_txtPalletNo","_hidDocNo")).value; 
        var _palletNo = document.getElementById(txtPalletNoId).value;
        var _previousValue = document.getElementById(txtPalletNoId.replace("_txtPalletNo","_hidPrivousValue")).value;
        var _fListId = '<%= Request.QueryString["ListId"].ToString() %>';
        
        if(_previousValue != _palletNo)
        {
            var _result = _WhseShipListDetail.UpdatePalletNumber(_pListDetailId,_palletNo,_docNo,_fListId).value;
             
            if(_result!= "")
            {
                alert(_result);
                document.getElementById(txtPalletNoId).focus();
                document.getElementById(txtPalletNoId).select();  
                return;             
            }            
        }
        
        // Set focus to next text box                
        var currentTxtCtlId = txtPalletNoId.replace("_txtPalletNo","").replace("dgListItem_ctl","");                
        var nextTxtCtlId = parseInt(currentTxtCtlId) + 1;
        var nextCtl;
        
        if(nextTxtCtlId <= 9)                
            nextCtl = txtPalletNoId.replace(currentTxtCtlId, "0" + nextTxtCtlId);
        else
            nextCtl = txtPalletNoId.replace(currentTxtCtlId, nextTxtCtlId);
            
        document.getElementById(nextCtl).focus();        
    }
    
    function RefreshParent()
    {
        window.opener.parent.document.getElementById("ibtnSearchList").click();
    }
        
    function CheckDuplicate()
    {
        var _fListId = '<%= Request.QueryString["ListId"].ToString() %>';
        var _result = _WhseShipListDetail.CheckOrderAlreadyExist(document.getElementById("txtNewDocNo").value, _fListId).value;  
        
        if(_result[0] != "")
        {
            if(ShowYesorNo("Order already on List ("+ _result[2]  +"), do you want to remove and add to this list?"))
            {
                var _result = _WhseShipListDetail.DeleteExistingDetailLine(_result[1]).value;   
                document.getElementById("btnAddItem").click();  
            }            
            return false;
        }
        
        return false;
        
    }
    </script>
    
    <script language="vbscript">
    Function ShowYesorNo(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbyesno,"Sales Order Entry")
    if intBtnClick=6 then 
        ShowYesorNo= true 
    else 
        ShowYesorNo= false
     end if
    end Function
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
                                <asp:Label ID="lblBtnHeader" runat="server" Text="Shipping List Maintenance - Detail"
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
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="width: 10px;">
                                                        <asp:Label ID="Label22" runat="server" Text="Pallet No:" Width="63px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 10px;">
                                                        <asp:TextBox MaxLength="20" CssClass="FormCtrl" ID="txtNewPalletNo" runat="server"
                                                            onfocus="javascript:this.select();"
                                                            onkeydown="javascript:if((event.keyCode==13 )&& (this.value != '')){ EnterToTab(event,this.id); }"
                                                            Width="120px"></asp:TextBox>
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 20px">
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 10px;">
                                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Document No:" Width="78px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 10px;">
                                                        <asp:TextBox ID="txtNewDocNo" runat="server" CssClass="FormCtrl" 
                                                            onfocus="javascript:this.select();"
                                                            onkeydown="javascript:if(event.keyCode==37){document.getElementById('txtNewPalletNo').focus();}"
                                                            MaxLength="20" Width="120px"></asp:TextBox></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 50px;">
                                                        <asp:ImageButton ID="btnAddItem" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/newadd.gif"
                                                            TabIndex="11" OnClick="btnAddItem_Click" OnClientClick="CheckDuplicate();" /></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 700px;">
                                                        <asp:HiddenField ID="hidpListdtlId" runat="server" />                                                        
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="Label3" runat="server" Text="Document No:" Width="79px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:TextBox ID="txtExistingDocNo" runat="server" CssClass="FormCtrl" MaxLength="20" Width="120px"></asp:TextBox></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="4">
                                                        <asp:Label ID="lblItemDesc" runat="server" Font-Bold="True" Width="438px"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="Label4" runat="server" Text="Pallet No:" Width="63px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:TextBox ID="txtExistingPalletNo" runat="server" CssClass="FormCtrl" MaxLength="20" Width="120px"></asp:TextBox></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                    </td>
                                                    <td align="left" class="splitBorder_r_h Left2pxPadd Right2pxPadd" colspan="4">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td style="padding-right: 10px;">
                                                                    <asp:ImageButton ID="ibtnCancel" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/btnClear.gif"
                                                                        TabIndex="11" OnClick="ibtnCancel_Click" /></td>
                                                                <td style="padding-right: 10px">
                                                                    <asp:ImageButton ID="btnDelete" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/BtnDelete.gif"
                                                                        TabIndex="11" OnClick="btnDelete_Click" OnClientClick="javascript:return confirm('Do you want to delete this item?');"/></td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnUpdateLine" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/BtnSave.gif"
                                                                        TabIndex="11" OnClick="ibtnUpdateLine_Click" /></td>
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
                                                position: relative; top: 0px; left: 0px; height: 340px; width: 100%; border: 0px solid;">
                                                <asp:DataGrid CssClass="grid" Style="height: auto" Width="100%" runat="server" ID="dgListItem"
                                                    GridLines="both" AutoGenerateColumns="false" UseAccessibleHeader="true" AllowSorting="True"
                                                    AllowPaging="true" PagerStyle-Visible="false" OnSortCommand="dgItem_SortCommand" ShowFooter=true
                                                    TabIndex="19" OnItemCommand="dgListItem_ItemCommand" OnItemDataBound="dgListItem_ItemDataBound">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="zebra" Height=20px  />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Action">
                                                            <ItemTemplate>                                                           
                                                                <asp:LinkButton ID="lnkEdit" Font-Underline="true" ForeColor="green"  OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                 CommandName="Edit"  CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pShipListDetailID")%>'
                                                                    runat="server" Text="Edit"></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" OnClientClick="javascript:return confirm('Do you want to delete this item?');" CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pShipListDetailID")%>'
                                                                    runat="server" Text="Delete"></asp:LinkButton>                                                                    
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                                            <FooterStyle HorizontalAlign=Left Font-Bold=true />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="OrderNo" HeaderText="Document No" SortExpression="OrderNo">
                                                            <ItemStyle Width="80px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Pallet No" SortExpression="PalletNo">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="txtPalletNo"  CssClass="FormCtrl" 
                                                                    Text='<%#DataBinder.Eval(Container,"DataItem.PalletNo")%>'
                                                                    onfocus="javascript:this.select();SetPreviousValue(this.value,this.id);"
                                                                    onkeydown="javascript:if((event.keyCode==13 )&& (this.value != '')){ EnterToTab(event,this.id); }"
                                                                    onblur="javascript:UpdatePalletNo(this.id);"
                                                                    runat="server" Width="80px" ></asp:TextBox>
                                                                <asp:HiddenField ID="hidPrivousValue" runat="server" Value="" />
                                                                <asp:HiddenField ID="hidpListDetailId"  Value='<%#DataBinder.Eval(Container,"DataItem.pShipListDetailID")%>'
                                                                    runat="server"></asp:HiddenField>
                                                                <asp:HiddenField ID="hidDocNo"  Value='<%#DataBinder.Eval(Container,"DataItem.OrderNo")%>'
                                                                    runat="server"></asp:HiddenField>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="CustNo" HeaderText="Cust #" SortExpression="CustNo">
                                                            <ItemStyle Width="50px" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>                                                   
                                                        <asp:BoundColumn DataField="CustName" SortExpression="CustName" HeaderText="Customer Name">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="150px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CustPONo" SortExpression="CustPONo" HeaderText="PO #">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="City" SortExpression="City" HeaderText="City">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="State" SortExpression="State" HeaderText="State">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="40px" HorizontalAlign="Center" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ShipWght" SortExpression="ShipWght" HeaderText="Doc Lbs">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="60px" HorizontalAlign="Right" />
                                                            <FooterStyle HorizontalAlign=Right Font-Bold=true /> 
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
                    <uc2:BottomFooter ID="ucFooter" Title="Warehouse Shipping List - Detail" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
