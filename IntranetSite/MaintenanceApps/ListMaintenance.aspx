<%@ Page Language="C#" EnableEventValidation="true" AutoEventWireup="true" CodeFile="ListMaintenance.aspx.cs"
    Inherits=" PFC.Intranet.ListMaintenance._ListMaintenance" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>List Maintenance</title>
    <link href="Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
</head>
<script>

</script>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
     <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr >
                <td height="5%" id="tdHeader">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;">
                    <table class="shadeBgDown" width="100%">
                        <tr>
                            <td class="Left2pxPadd DarkBluTxt boldText" width="100px">
                                <span>List Selection</span></td>
                            <td>
                            <asp:UpdatePanel ID="pnlSearchList" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                                <asp:DropDownList ID="ddlListSelection" AutoPostBack="true" CssClass="FormCtrl" Width="250px"
                                    Height="20px" runat="server" OnSelectedIndexChanged="ddlListSelection_SelectedIndexChanged">
                                </asp:DropDownList>
                                </ContentTemplate></asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                <asp:UpdatePanel ID="pnlListMaster" runat="server" UpdateMode="conditional">
                        <ContentTemplate>  <asp:Panel ID="plMaster" runat="server"  DefaultButton="ibtnListSave">
                    <table cellpadding="0" cellspacing="0" width="100%" class="blueBorder" style="border-collapse: collapse;">
                        <tr>
                            <td class="lightBlueBg">
                                <asp:Label ID="lblInfo" CssClass="BanText" runat="server" Text="List Information"></asp:Label></td>
                            <td class="lightBlueBg" align="right" valign="Middle">
                          
                                <asp:ImageButton ID="ibtnListSave" CausesValidation="false" OnClientClick="javascript:return CheckMasterRequiredField();"  runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif" OnClick="ibtnListSave_Click" Visible="False" TabIndex="5" />
                                <asp:ImageButton ID="ibtnListAdd" CausesValidation="false" runat="server"  ImageUrl="~/MaintenanceApps/Common/images/newadd.gif" OnClick="ibtnListAdd_Click" TabIndex="11" />
                                <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"/>
                             </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 10px;" width="100%" colspan="2">
                            
                                <table width="100%" style="border-collapse: collapse;">
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt boldText"><asp:LinkButton ID="lnkListMaster" runat="server" Font-Underline="true" Text="List" TabIndex="15"></asp:LinkButton>                                            
                                              <div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <span class="boldText">Change ID: </span>
                                                    <asp:Label ID="lblChangeID" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                                    <td>
                                                    <span class="boldText" style="padding-left:5px;">Change Date: </span>
                                                    <asp:Label ID="lblChangeDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                            </tr>                                            
                                            <tr>
                                                <td>
                                                    <span class="boldText">Entry ID: </span>
                                                    <asp:Label ID="lblEntryID" runat="server" Text="" Font-Bold="false"></asp:Label></td>                                            
                                                <td>
                                                    <span class="boldText" style="padding-left:5px;" >Entry Date: </span>
                                                    <asp:Label ID="lblEntryDate" runat="server" Text="" Font-Bold="false"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </div>
                                        </td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 200px">
                                            <asp:TextBox MaxLength="20" CssClass="FormCtrl" ID="txtListName" runat="server" Width="150px"></asp:TextBox>
                                           <span style="color:Red;"> * </span>
                                        </td>
                                        <td class="Left2pxPadd DarkBluTxt" style="width: 7px">
                                        <td class="Left2pxPadd DarkBluTxt boldText" width="90">
                                            Comments</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" rowspan="2" width="250px">
                                            <asp:TextBox  CssClass="FormCtrl Sbar" ID="txtListComments" TextMode="MultiLine"
                                                Height="60px" Width="200px" MaxLength="255" runat="server" TabIndex="3"></asp:TextBox>                                                
                                        </td>                                        
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" rowspan="2">
                                            <table class="blueBorder shadeBgDown">
                                                <tr>
                                                    <td>
                                                        <asp:CheckBoxList ID="chkListType"  runat="server" Width="200px" CssClass="boldText" TabIndex="4">
                                                            <asp:ListItem Text=" System Requirement" ></asp:ListItem>
                                                            <asp:ListItem Text=" User Option" ></asp:ListItem>
                                                            <asp:ListItem Text=" Not PFC Related" ></asp:ListItem>
                                                        </asp:CheckBoxList></td>
                                                </tr>
                                            </table>
                                        </td>
                                        
                                    </tr>
                                    <tr>
                                        <td class="Left2pxPadd DarkBluTxt boldText">
                                            Description</td>
                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" style="width: 200px">
                                            <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtListDesc" runat="server"
                                                Width="150px" TabIndex="1"></asp:TextBox></td>
                                    </tr>
                                    <tr><td colspan="7" >&nbsp;</td></tr>
                                    <tr>
                                        <td class="lightBlueBg" colspan="7" style="padding-left: 120px; vertical-align: middle;
                                            border-collapse: collapse;">
                                            <asp:ImageButton ID="ibtnListDelete" OnClientClick="javascript:return confirm('Do you want to delete this list?');" CausesValidation="false" runat="server" ImageUrl="~/MaintenanceApps/Common/images/btndelete.gif" OnClick="ibtnListDelete_Click" TabIndex="12" />
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
                <td>
                 <asp:UpdatePanel ID="pnlListDetail" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:Panel ID="plDetail" runat="server"  DefaultButton="ibtnItemSave"> <table width="100%">
                        <tr>
                            <td width="50%" valign="top">
                                <table width="100%" class="blueBorder" style="border-collapse: collapse;">
                                 <tr>
                                        <td class="lightBlueBg" nowrap="nowrap">
                                            <asp:Label ID="Label1" CssClass="BanText" runat="server" Text="Item"></asp:Label>
                                        </td>
                                        <td class="lightBlueBg" align="right">
                                            <asp:ImageButton ID="ibtnItemAdd" CausesValidation="false" runat="server" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif" OnClick="ibtnItemAdd_Click" TabIndex="13" />&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <div id="div-datagrid" class="Sbar" align="center" style="overflow-x: hidden; overflow-y:auto;
                                                position: relative; top: 0px; left: 0px; height: 340px; width: 100%; border: 0px solid;">
                                                <asp:DataGrid CssClass="grid" style="height:auto" Width="99%" runat="server" ID="dgItem" GridLines="both" 
                                                    AutoGenerateColumns="false" UseAccessibleHeader="true" AllowSorting="True" OnItemCommand="dgItem_ItemCommand" OnItemDataBound="dgItem_ItemDataBound" OnSortCommand="dgItem_SortCommand" TabIndex="19" >
                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                    <ItemStyle CssClass="GridItem" />
                                                    <AlternatingItemStyle CssClass="zebra" />
                                                    <FooterStyle CssClass="lightBlueBg" />
                                                    <Columns>
                                                    
                                                        <asp:TemplateColumn HeaderText="Action">
                                                            <ItemTemplate>                                                           
                                                                <asp:LinkButton ID="lnkEdit" Font-Underline="true" ForeColor="green"  OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                 CommandName="Edit"  CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pListDetailID")%>'
                                                                    runat="server" Text="Edit"></asp:LinkButton>
                                                                <asp:LinkButton ID="lnkDelete" Font-Underline="true" ForeColor="#cc0000" OnClientClick="javascript:return confirm('Do you want to delete this item?');" CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.pListDetailID")%>'
                                                                    runat="server" Text="Delete"></asp:LinkButton>                                                                    
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn SortExpression="ListValue" DataField="ListValue" HeaderText="Item">
                                                            <ItemStyle CssClass="Left5pxPadd" Width="120px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ListDtlDesc" HeaderText="Description" SortExpression="ListDtlDesc">
                                                            <ItemStyle Width="170px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SequenceNo" HeaderText="Seq #" SortExpression="SequenceNo">
                                                            <ItemStyle  Width="50px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="GLAccountNo" SortExpression="GLAccountNo" HeaderText="GL Account">
                                                            <ItemStyle CssClass="Left5pxPadd"  Width="70px" HorizontalAlign="Left" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid><asp:Label ID="lblListMsg" Font-Bold="true" ForeColor="#cc0000" runat="server" Text="No Records Found" ></asp:Label><input
                                                    type="hidden" id="hidSort" runat="server" tabindex="17" />
                                                    <asp:HiddenField ID ="hidScrollTop" runat ="server" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" width="50%">
                                <table width="100%" id="tblDetailEntry" runat="server" class="blueBorder" style="border-collapse: collapse;">
                                    <tr>
                                        <td class="lightBlueBg" nowrap="nowrap">
                                            <asp:Label ID="lblHeader" CssClass="BanText" runat="server" Text="Item Information"></asp:Label>
                                        </td>
                                        <td class="lightBlueBg" align="right">
                                            <asp:ImageButton ID="ibtnItemClose" CausesValidation="false" runat="server" ImageUrl="~/MaintenanceApps/Common/images/close.gif" OnClick="ibtnItemClose_Click" TabIndex="13" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding-top: 10px;" width="100%">
                                            <table width="100%" cellpadding="5px" >
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" width="15%" style="padding-left:30px;">
                                                        Item
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" width="300px">
                                                        <asp:TextBox MaxLength="60" CssClass="FormCtrl" ID="txtItem" runat="server" Width="150px" TabIndex="6"></asp:TextBox><span style="color:Red;"> * </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left:30px;">
                                                        Description
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" width="300px">
                                                        <asp:TextBox MaxLength="40" CssClass="FormCtrl" ID="txtItemDesc" runat="server" Width="150px" TabIndex="7"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left:30px;">
                                                        Sequence
                                                    </td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" width="300px">
                                                        <asp:TextBox MaxLength="5" CssClass="FormCtrl" ID="txtSequence" runat="server" Width="50px" onkeypress="javascript:ValdateNumber();" TabIndex="8"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left:30px;">
                                                        GL Account</td>
                                                    <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                        <asp:DropDownList ID="ddlGLAccount" CssClass="FormCtrl" Width="155px"
                                                            Height="20px" runat="server" TabIndex="9">
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="lightBlueBg" colspan="7" style="padding-left: 120px; vertical-align: middle;
                                            border-collapse: collapse;">
                                            <asp:ImageButton ID="ibtnItemSave" CausesValidation="false" OnClientClick="javascript:return CheckDetailRequiredField();"  runat="server" ImageUrl="~/MaintenanceApps/Common/images/btnsave.gif" OnClick="ibtnItemSave_Click" TabIndex="10" />
                                           
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                            </asp:Panel>
                   
                    </ContentTemplate></asp:UpdatePanel>
                </td>
            </tr>
             <tr>
                <td  class="BluBg buttonBar" height="20px">
                <table><tr><td>  <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                runat="server" Text=""></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel></td><td> <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout=false>
                        <ProgressTemplate>
                            <span style="padding-left: 5px;font-weight:bold;" >Loading...</span>                         
                        </ProgressTemplate>
                    </asp:UpdateProgress> </td></tr></table>
                                    
             </td>
            </tr>
            <tr>
                <td>               
                    <uc2:BottomFooter ID="ucFooter" Title="List Maintenance" runat="server" />                    
                </td>
            </tr>
            <tr><td> <asp:UpdatePanel ID="pnlHidValue" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                <input type=hidden runat=server id="hidMstrMode" />
                <input type=hidden runat=server id="hidDtlMode" />
                <input type="hidden" id="hidDetailID" runat="server" /></ContentTemplate></asp:UpdatePanel></td></tr>
        </table>
    </form>
</body>
</html>
