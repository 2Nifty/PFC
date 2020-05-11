<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GLAccount.aspx.cs" Inherits="FormMessage" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<%@ Register Src="~/MaintenanceApps/Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
    
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GL Account</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet" type="text/css" />
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
    .FormCtrl 
{
	font-family: Arial, Helvetica, sans-serif;	
	font-size: 11px;	
	font-weight: normal;	
	color: #000000;	
	
}

    </style>
    <script>
    function checkNum(evt)
{

var carCode = (evt.which) ? evt.which : event.keyCode
if (carCode > 31 && (carCode < 48) || (carCode > 57)){
    return false;
    }
}
    </script>
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
                <td style="padding-top: 1px;">
                    <table style="width: 100%" class="blueBorder" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="lightBlueBg" style="width: 451px">
                                <asp:Label ID="lblHeading" runat="server" Text="GL Account Information" CssClass="BanText"
                                    Width="334px"></asp:Label></td>
                            <td style="height: 5px" align="right" class="lightBlueBg">
                                <asp:UpdatePanel ID="upnlAdd" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table>
                                            <tr>
                                                <td style="height: 16px">
                                                    &nbsp;<img id="CloseButton"  src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                        tabindex="17" />
                                                    
                                                    <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                        runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="14" /></td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-left: 100px;">
                                <div style="width:100px">
                                    <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <table >
                                                <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label13" runat="server" Text="Location" CssClass="DarkBluTxt"></asp:Label>
                                                                </td>
                                                                <td >
                                                                    <asp:DropDownList CssClass="FormCtrl" ID="ddlLocation" Height="25px"  runat="server"
                                                                        Width="125px" TabIndex="1" AutoPostBack="True" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged">
                                                                    </asp:DropDownList></td><td>
                                                                     <asp:RequiredFieldValidator ControlToValidate="ddlLocation"  InitialValue="" ID="RequiredFieldValidator7" runat="server">*</asp:RequiredFieldValidator>
                                                                </td>
                                                                
                                                            </tr>
                                                            <tr>
                                                                <td style="height: 26px">
                                                                    <asp:LinkButton ID="lnkCode" runat="server" Style="text-decoration: underline" Text="Account No"
                                                                        Width="100px" TabIndex="13" CssClass="DarkBluTxt"></asp:LinkButton></td>
                                                                <td style="width: 757px; height: 26px">
                                                                    <asp:TextBox CssClass="FormCtrl" ID="txtAccountNo" TabIndex="2" runat="server"></asp:TextBox>
                                                                    <div id="divToolTips" class="list" align="left" style="display: none; position: absolute;
                                                                        width: 260px" onmouseup="return false;">
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
                                                               <td>
                                                                   <asp:RequiredFieldValidator ControlToValidate="txtAccountNo" ID="RequiredFieldValidator1" runat="server">*</asp:RequiredFieldValidator></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left">
                                                                    <asp:Label ID="Label5" runat="server" CssClass="DarkBluTxt" Font-Bold="True" Text="Alias Account No"></asp:Label></td>
                                                                <td style="width: 757px">
                                                                    <asp:TextBox CssClass="FormCtrl" TabIndex="3" ID="txtAliasNo" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td>
                                                                   <asp:RequiredFieldValidator ControlToValidate="txtAliasNo" ID="RequiredFieldValidator2" runat="server">*</asp:RequiredFieldValidator></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left">
                                                                    <asp:Label ID="Label1" runat="server" CssClass="DarkBluTxt" Font-Bold="True" Text="Description"></asp:Label></td>
                                                                <td style="width: 757px" >
                                                                    <asp:TextBox TabIndex="4" CssClass="FormCtrl" ID="txtDescription" runat="server"></asp:TextBox>
                                                                </td>
                                                                <td>
                                                                   <asp:RequiredFieldValidator ControlToValidate="txtDescription" ID="RequiredFieldValidator3" runat="server">*</asp:RequiredFieldValidator></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left">
                                                                    <asp:Label ID="Label6" runat="server" CssClass="DarkBluTxt" Font-Bold="True" Text="Department"></asp:Label></td>
                                                                <td style="width: 757px" >
                                                                   <asp:DropDownList Width="125px" ID="ddlDept" Height="25px" CssClass="FormCtrl" runat="server"
                                                                         TabIndex="5">
                                                                    </asp:DropDownList>
                                                                </td>
                                                                <td >
                                                                    <span style="color: Red;"></span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    </td>
                                                    <td valign=top  >
                                                        <table >
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label17" runat="server" Text="Account Type" CssClass="DarkBluTxt" Width="81px"
                                                                       ></asp:Label></td>
                                                                <td >
                                                                    <asp:TextBox Width="250px" TabIndex=6 CssClass="FormCtrl" ID="txtAccount" MaxLength=2 runat="server"></asp:TextBox>
                                                                </td>
                                                                <td>
                                                                   <asp:RequiredFieldValidator ControlToValidate="txtAccount" ID="RequiredFieldValidator4" runat="server">*</asp:RequiredFieldValidator></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label2" runat="server" Text="Post Level" CssClass="DarkBluTxt" Width="118px" ></asp:Label></td>
                                                                <td >
                                                                    <asp:TextBox Width="90px" TabIndex=7 CssClass="FormCtrl" ID="txtPostLevel" MaxLength="2" runat="server"></asp:TextBox>
                                                                
                                                                  
                                                                   <asp:RequiredFieldValidator ControlToValidate="txtPostLevel" ID="RequiredFieldValidator5" runat="server">*</asp:RequiredFieldValidator>
                                                                   </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="DarkBluTxt">
                                                                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Sequence No"></asp:Label>
                                                                </td>
                                                                <td >
                                                                    <asp:TextBox Width="90px" TabIndex=8 onKeyPress="javascript:return checkNum(event);" CssClass="FormCtrl" ID="txtSequenceNo" runat="server"></asp:TextBox>
                                                                
                                                                   <asp:RequiredFieldValidator ControlToValidate="txtSequenceNo" ID="RequiredFieldValidator6" runat="server">*</asp:RequiredFieldValidator></td>
                                                            </tr>
                                                            <tr>
                                                                <td class="DarkBluTxt">
                                                                    <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Effective Date"></asp:Label>
                                                                </td>
                                                                <td>
                                                                 <asp:Panel ID="pnlDate" runat="server">
                                                                    <uc3:novapopupdatepicker TabIndex=9 ID="dtEffectiveDate" runat="server" />
                                                                   </asp:Panel>
                                                                </td>
                                                                
                                                            </tr>
                                                            <tr>
                                                                <td class="DarkBluTxt" style="height: 16px">
                                                                    <asp:Label ID="lblDelete" runat="server" Visible=false Font-Bold="True" Text="Delete Date"></asp:Label>
                                                                </td>
                                                                <td style="height: 16px" >
                                                                    <asp:Label ID="lblDeleteDate" runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </td>
                        </tr>
                        <tr>
                        <td ></td>
                            <td align=right >
                                <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="btnDelete" ImageUrl="~/MaintenanceApps/Common/Images/btndelete.gif"
                                            runat="server" Visible=false CausesValidation="False" OnClick="btnDelete_Click" TabIndex="16" />&nbsp;
                                            <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                        runat="server" OnClick="btnSave_Click" CausesValidation=true
                                                        Visible="false" TabIndex="10" />
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
                            <table  cellpadding="0" cellspacing="0">
                                <tr class="lightBlueBg">
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 7px; width: 4%;">
                                        <span class="BanText">GL Accounts &nbsp;</span></td>
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 1px; width: 5%;">
                                        &nbsp;</td>
                                </tr>
                                <tr><td>
                                    <asp:CheckBox ID="chkDelete" Font-Bold=true Text="Show Deleted Accounts" runat="server" AutoPostBack="True" OnCheckedChanged="chkDelete_CheckedChanged" /></td></tr>
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                        <div id="div-datagrid" class="Sbar" style="overflow-x: auto; overflow-y: auto; position: relative;
                                            top: 0px; left: 0px; height:330px; width: 1015px; border: 0px solid;" align="left">
                                            <asp:DataGrid PagerStyle-Visible=false CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="dgCountryCode"
                                                GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                AllowSorting="True" ShowFooter="False" OnItemCommand="dgCountryCode_ItemCommand" PageSize=5
                                                Width="995px" AllowPaging=true  OnSortCommand="dgCountryCode_SortCommand" OnItemDataBound="dgCountryCode_ItemDataBound"
                                                TabIndex="18" OnPageIndexChanged="dgCountryCode_PageIndexChanged">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <FooterStyle CssClass="lightBlueBg" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Actions">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pGLAcctMasterID")%>'>Edit</asp:LinkButton>
                                                            <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pGLAcctMasterID")%>'>Delete</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="60px" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="Location" HeaderText="Location" SortExpression="Location">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="AccountNo" HeaderText="Gl Account" SortExpression="AccountNo">
                                                        <ItemStyle Width="70px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="AccountDescription" HeaderText="Description" SortExpression="AccountDescription">
                                                        <ItemStyle Width="150px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryDt" HeaderText="Enter Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="EntryDt">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                        <ItemStyle Width="60px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeDt" HeaderText="Change Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="ChangeDt">
                                                        <ItemStyle Width="30px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                            <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                            <asp:HiddenField ID="hidScrollTop" runat="server" />
                                            <asp:HiddenField ID="hidPrimaryKey" runat="server" />
                                        </div>
                                        <uc4:pager ID="Pager1" OnBubbleClick=Pager_PageChanged runat="server" />
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
                    <uc2:Footer ID="BottomFrame2" Title="GL Account Master" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
