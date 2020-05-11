<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" CodeFile="CustomerPriceRanking.aspx.cs"
    Inherits=" PFC.Intranet.ListMaintenance._CustPriceRanking" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Price Ranking Maintenance</title>
    <link href="../MaintenanceApps/Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

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
    
    function HideToolTips()
    {
        if(document.getElementById('divToolTips')!=null)divToolTips.style.display='none';
        if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';
    }
    
    function ShowPriceAnalysis()
    {
        window.open("../CustomerMaintenance/PriceAnalysisReport.aspx?CustNo=" + document.getElementById("txtCustNo").value ,'PriceAnalysis' ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (700/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            
    }
    
    function UpdateContractCode(ddlContractCdId)
    {
        
        var contractCdIndex = document.getElementById(ddlContractCdId).selectedIndex;
        var _newContractCd = document.getElementById(ddlContractCdId).options[contractCdIndex].value; 
        var _ddlContractCd = document.getElementById(ddlContractCdId);
        var _hidpCustPriceRankId = document.getElementById(ddlContractCdId.replace("_ddlGridContractCd","_hidpCustPriceRankingID")).value;  
        var _hidPreviousCrontractCd = document.getElementById(ddlContractCdId.replace("_ddlGridContractCd","_hidPreviuosContractCd")).value; 
        var _lblChangeDt = document.getElementById(ddlContractCdId.replace("_ddlGridContractCd","_lblChangeDt")); 
        var _lblChangeID = document.getElementById(ddlContractCdId.replace("_ddlGridContractCd","_lblChangeID"));         
        var _custNo = document.getElementById("txtCustNo").value;
        
        var _result = _CustPriceRanking.UpdateCustContractCd(_hidpCustPriceRankId,_newContractCd,_custNo).value;        
        if(_result[0] != "")
        {
            alert(_result[0]);
            _ddlContractCd.value = _hidPreviousCrontractCd;            
        }
        else
        {
            _lblChangeID.innerHTML = _result[1];
            _lblChangeDt.innerHTML = _result[2];
            document.getElementById("lblMessage").style.display = '';
            document.getElementById("lblMessage").innerText = "Data has been successfully updated.";
        }
        
    }
    
    function RefreshParent()
    {
        var mode = '<%= Request.QueryString["Mode"] %>';
        if(mode != null && mode=='ContractPage')
        {
            window.opener.frmCustContMaint.document.getElementById("btnSearch").click();
            window.setTimeout('',2000); // we need this delay to refresh parent window
        }
        
    }
        
    </script>

</head>
<body scroll="no" onclick="javascript:document.getElementById('lblMessage').innerText='';" 
    onmouseup="javascript:HideToolTips();"
    onmouseout="javascript:HideToolTips();" 
    onunload="javascript:RefreshParent();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" border="0" id="mainTable" style="border-collapse: collapse;">
            <tr>
                <td height="5%" id="tdHeader">
                    <table id="tblBtnBanner2" runat="server" class="blueBorder" cellpadding="0" cellspacing="0"
                        style="border-collapse: collapse;" width="100%">
                        <tr runat="server">
                            <td>
                                <uc1:Header ID="Header1" runat="server" />
                            </td>
                        </tr>
                        <tr runat="server" id="Tr1">
                            <td class="lightBlueBg">
                                <asp:Label ID="lblBtnHeader" runat="server" Text="Customer Price Ranking Maintenance"
                                    CssClass="BanText" Width="400px"></asp:Label></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="blueBorder shadeBgDown" style="padding: 3px; border-bottom: 0px; border-top: 0px;">
                    <asp:UpdatePanel ID="pnlSearch" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table border="0" style="border-collapse: collapse;" width="100%">
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText" style="width: 100px;">
                                        <span>
                                            <asp:Label ID="Label2" runat="server" Text="Customer Number:" Width="110px"></asp:Label></span></td>
                                    <td style="width: 100px;">
                                        <asp:TextBox ID="txtCustNo" runat="server" onfocus="javascript:this.select();" onkeydown="javascript:if((event.keyCode==13 )&& (this.value != '')){ EnterToTab(event,this.id); }"
                                            onblur="javascript:document.getElementById('btnSearchCust').click();" CssClass="FormCtrl"
                                            MaxLength="20" Width="100px"></asp:TextBox>
                                        <asp:Button ID="btnSearchCust" runat="server" OnClick="btnSearchCust_Click" Style="display: none" />
                                    </td>
                                    <td style="width: 100px; padding-left: 20px;">
                                        <asp:CheckBox ID="chkShowDeleted" Text="Show Deleted Records" runat="server" Width="173px"
                                            Font-Bold="True" AutoPostBack="True" OnCheckedChanged="chkShowDeleted_CheckedChanged" /></td>
                                    <td>
                                    </td>
                                    <td style="width: 50px; padding-right: 5px;">
                                        <asp:ImageButton ID="ibtnAddList" CausesValidation="false" runat="server" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                            OnClick="ibtnAddList_Click" TabIndex="11" /></td>
                                    <td style="width: 50px; padding-right: 5px;">
                                        <asp:ImageButton ID="ibtnPriceAnalysis" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/PriceAnalysis.GIF" OnClientClick="javascript:ShowPriceAnalysis(); return false;"
                                            TabIndex="11" /></td>
                                    <td style="width: 50px; padding-right: 10px;">
                                        <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();" /></td>
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
                            <asp:Panel ID="plMaster" runat="server" DefaultButton="ibtnSave">
                                <table cellpadding="0" cellspacing="2" width="100%" style="border-collapse: collapse;">
                                    <tr>
                                        <td valign="top" style="padding-top: 5px" width="500" class="blueBorder shadeBgDown">
                                            <table style="border-collapse: collapse;" border="0" cellspacing="3" cellpadding="0">
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="width: 10px">
                                                        <asp:Label ID="lblCustNo" runat="server" Font-Bold="True" Width="40px"></asp:Label></td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="width: 10px;">
                                                        <asp:Label ID="lblCustName" runat="server" Width="273px" Font-Bold="False"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="lblAddress1" runat="server" Width="273px" Font-Bold="False"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="lblAddress2" runat="server" Width="273px" Font-Bold="False"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <asp:Label ID="lblCity" runat="server" Width="273px" Font-Bold="False"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label5" runat="server" Text="Phone:" Width="41px"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="lblPhone" runat="server" Width="98px" Font-Bold="False"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label ID="Label7" runat="server" Text="Fax:" Width="27px"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="lblFaxNo" runat="server" Width="102px" Font-Bold="False"></asp:Label></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top" style="padding-top: 5px;" class="blueBorder shadeBgDown">
                                            <table runat=server id="tblAddContract" style="border-collapse: collapse;" width="100%" border="0" cellspacing="3"
                                                cellpadding="3">
                                                <tr>
                                                    <td class="Left2pxPadd boldText" style="width: 40px;">
                                                        <asp:Label ID="Label3" runat="server" Text="Contract Code" Width="80px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 50px;">
                                                        <asp:DropDownList ID="ddlContractCd" runat="server" CssClass="FormCtrl" Height="20px"
                                                            Width="200px">
                                                        </asp:DropDownList></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd boldText">
                                                        <asp:Label ID="Label4" runat="server" Text="Ranking" Width="56px"></asp:Label></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:DropDownList ID="ddlRanking" runat="server" CssClass="FormCtrl" Height="20px"
                                                            Width="125px">
                                                        </asp:DropDownList></td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" align="right">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td align="right" style="padding-right: 10px;">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td style="padding-right: 10px;">
                                                                    <asp:ImageButton ID="ibtnSave" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/BtnSave.gif"
                                                                        TabIndex="11" OnClick="ibtnSave_Click" /></td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnCancel" CausesValidation="false" runat="server" ImageUrl="~/Common/Images/cancel.gif"
                                                                        TabIndex="11" OnClick="ibtnCancel_Click" /></td>
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
                                                position: relative; top: 0px; left: 0px; height: 410px; width: 100%; border: 0px solid;">
                                                <asp:DataGrid CssClass="grid" Style="height: auto" Width="100%" runat="server" ID="dgListItem"
                                                    GridLines="both" AutoGenerateColumns="false" UseAccessibleHeader="true" AllowSorting="True"
                                                    AllowPaging="true" PagerStyle-Visible="false" OnSortCommand="dgItem_SortCommand"
                                                    TabIndex="19" OnItemDataBound="dgListItem_ItemDataBound" OnItemCommand="dgListItem_ItemCommand">
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" Height="10px" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="lightBlueBg" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Action">
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" OnClientClick="javascript:return confirm('Do you want to delete this item?');"
                                                                    CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pCustomerPriceRankingID")%>'
                                                                    runat="server" Text="Delete"></asp:LinkButton>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                                            <FooterStyle HorizontalAlign="Left" Font-Bold="true" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Contract Code" SortExpression="ContractCode">
                                                            <ItemTemplate>
                                                                <asp:DropDownList ID="ddlGridContractCd" runat="server" CssClass="FormCtrl" Height="20px" onchange="javascript:UpdateContractCode(this.id);"
                                                                    Width="200px">
                                                                </asp:DropDownList>
                                                                <asp:HiddenField ID="hidPreviuosContractCd" Value='<%#DataBinder.Eval(Container,"DataItem.ContractCode")%>'
                                                                    runat="server"></asp:HiddenField>
                                                                <asp:HiddenField ID="hidpCustPriceRankingID" Value='<%#DataBinder.Eval(Container,"DataItem.pCustomerPriceRankingID")%>'
                                                                    runat="server"></asp:HiddenField>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="60px" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="Ranking" HeaderText="Ranking" SortExpression="Ranking">
                                                            <HeaderStyle Width="60px" />
                                                            <ItemStyle Width="50px" HorizontalAlign="Right" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="EntryID" SortExpression="EntryID" HeaderText="Entry ID">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="EntryDt" HeaderText="Entry Date" SortExpression="EntryDt">
                                                            <ItemStyle Width="70px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                         <asp:TemplateColumn HeaderText="Change ID" SortExpression="ChangeID" >
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblChangeID" Text='<%#DataBinder.Eval(Container,"DataItem.ChangeID")%>'
                                                                    runat="server"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                                        </asp:TemplateColumn>                                                        
                                                        <asp:TemplateColumn HeaderText="Change Date" SortExpression="ChangeDt" >
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblChangeDt" Text='<%#DataBinder.Eval(Container,"DataItem.ChangeDt")%>'
                                                                    runat="server"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="DeleteDt" SortExpression="DeleteDt" HeaderText="Delete Date">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="70px" HorizontalAlign="Left" />
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
                                <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="false" DisplayAfter=0>
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
                    <uc2:BottomFooter ID="BottomFooter1" Title="Customer Price Ranking" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
