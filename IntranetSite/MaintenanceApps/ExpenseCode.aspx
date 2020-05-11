<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExpenseCode.aspx.cs" Inherits="MaintenanceApps_ExpenseCode" %>


<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Expense Codes</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
        <script src="Common/Javascript/Common.js" type="text/javascript" ></script>
</head>
<body  scroll=no onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';"  onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
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
                    <asp:UpdatePanel ID="upnlbtnSearch" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                        <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                         <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblSch" runat="server" Text="Search By Code" Width="100px"></asp:Label></td>
                                    <td style="width: 100px">
                                        <asp:TextBox ID="txtSearchCode" CssClass="FormCtrl" runat="server" AutoCompleteType="disabled"
                                            MaxLength="10" Width="150px"></asp:TextBox></td>
                                    <td style="width: 100px">
                                        <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                            OnClick="btnSearch_Click" CausesValidation="False" /><asp:HiddenField ID="hidPrimaryKey"
                                                runat="server" />
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
                  <asp:Panel ID="Panel1" runat="server" DefaultButton="btnSave">
                    <table style="width: 100%" class="blueBorder" cellpadding="0" cellspacing="0" >
                        <tr>
                            <td class="lightBlueBg">
                                <asp:Label ID="lblHeading" runat="server" Text="Enter Expense Code Information" CssClass="BanText"
                                    Width="284px"></asp:Label></td>
                            <td style="width: 656px; height: 5px" align="right" class="lightBlueBg">
                                <asp:UpdatePanel ID="upnlAdd" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table  >
                                            <tr>
                                                <td style="height: 16px">
                                                     <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                        runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="12" />
                                                    &nbsp;<img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();" tabindex="13" />                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                          </td>
          </tr>
                        <tr>
                            <td colspan="2">
                                <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table width="175">
                                            <tr>
                                                <td class="Left2pxPadd " style="padding-left:30px" colspan="4">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px">
                                                <asp:LinkButton ID="lnkCode" runat="server" Font-Underline="true" Text="Code" TabIndex="14"></asp:LinkButton>  
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
                                                <td style="width: 300px;">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="width: 100px">
                                                    <asp:TextBox ID="txtCode" TabIndex="1" CssClass="FormCtrl" runat="server" MaxLength="20" Width="110px"></asp:TextBox></td>
                                                            <td style="width: 100px;padding-left:10px;">
                                                                <span style="color: #ff0000">*</span></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="width: 300px; height: 26px">
                                                    <span style="color:Red;"></span></td>
                                                <td style="width: 101px; padding-left: 30px" rowspan="8">
                                                    <asp:UpdatePanel ID="upnlchkSelectAll" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <table cellpadding="0" cellspacing="0" class="blueBorder" style="border-collapse: collapse">
                                                                <tr>
                                                                    <td style="height: 22px" class="lightBlueBg">
                                                                        <asp:CheckBox ID="chkSelectAll" runat="server" Text="Select / Deselect All" Width="130px"
                                                                            AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" ForeColor="#CC0000" TabIndex="10" Font-Bold="True" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="blueBorder" style="padding-top: 1px; height: 138px;">
                                                                        <asp:CheckBoxList ID="chkSelection" runat="server" Height="40px" RepeatColumns="1"
                                                                            RepeatDirection="Horizontal" Width="130px" AutoPostBack="True" TabIndex="11" Font-Bold="True">
                                                                            <asp:ListItem>GL</asp:ListItem>
                                                                            <asp:ListItem>AP</asp:ListItem>
                                                                            <asp:ListItem>AR</asp:ListItem>
                                                                            <asp:ListItem>SO</asp:ListItem>
                                                                            <asp:ListItem>PO</asp:ListItem>
                                                                            <asp:ListItem>IM</asp:ListItem>
                                                                            <asp:ListItem>VM</asp:ListItem>
                                                                            <asp:ListItem>WO</asp:ListItem>
                                                                            <asp:ListItem>MM</asp:ListItem>
                                                                            <asp:ListItem>SM</asp:ListItem>
                                                                        </asp:CheckBoxList>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                    <asp:Label ID="Label3" runat="server" Height="16px" Text="Description" Width="111px"></asp:Label></td>
                                                <td style="width: 100px; height: 15px">
                                                    <asp:TextBox ID="txtDescription"  CssClass="FormCtrl" runat="server" TabIndex="2" MaxLength="50" Width="300px"></asp:TextBox></td>
                                                <td style="width: 100px;padding-left:10px;">
                                                     <span style="color:Red;">*</span></td>
                                            </tr>
                                            <tr>
                                                <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left:10px;">
                                                    <asp:Label ID="Label4" runat="server" Height="16px" Text="Short Description" Width="111px"></asp:Label></td>
                                                <td style="width: 100px">
                                                    <asp:TextBox ID="txtShortDesc" CssClass="FormCtrl" runat="server" TabIndex="3" MaxLength="50" Width="200px"></asp:TextBox></td>
                                                <td style="width: 100px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10px;" valign="middle">
                                                    <asp:Label ID="Label5" runat="server" Height="16px" Text="GL Account" Width="111px" Font-Bold="True"></asp:Label></td>
                                                <td style="width: 100px; height: 16px;">
                                                    <asp:DropDownList ID="ddlGLAccount" CssClass="FormCtrl"  TabIndex="4"  Height="20px" Width="200px" runat="server"></asp:DropDownList> </td>
                                                    <%--<asp:TextBox ID="txtGLAccount" CssClass="FormCtrl" runat="server" TabIndex="4" MaxLength="15" Width="200px"></asp:TextBox></td>--%>
                                                <td style="width: 100px; height: 16px">
                                                </td>
                                            </tr>
                                             <tr>
                                                <td style="padding-left: 10px;" valign="middle">
                                                    <asp:Label ID="Label1" runat="server" Height="16px" Text="Percentage" Width="111px" Font-Bold="True"></asp:Label></td>
                                                <td style="width: 100px; height: 16px;">
                                                    <asp:TextBox ID="txtPercent" CssClass="FormCtrl" runat="server" TabIndex="5" MaxLength="3" onkeypress="javascript:ValdatePercentage();"  Width="110px"></asp:TextBox></td>
                                                <td style="width: 100px; height: 16px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10px" valign="middle">
                                                                <asp:Label ID="Label2" runat="server" Height="16px" Text="Expense Type" Width="111px" Font-Bold="True"></asp:Label></td>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="width: 100px">
                                                                <asp:DropDownList ID="ddlExpType" CssClass="FormCtrl" TabIndex="6" Height="20px"
                                                                    Width="115px" runat="server">
                                                                </asp:DropDownList></td>
                                                            <td style="padding-left: 20px; width: 100px">
                                                                <asp:Label ID="Label8" runat="server" Height="16px" Text="Expense Line#" Width="90px" Font-Bold="True"></asp:Label></td>
                                                            <td style="width: 100px">
                                                                <asp:TextBox ID="txtExpLine" CssClass="FormCtrl" runat="server" TabIndex="7" onkeypress="javascript:ValdateNumber();" MaxLength="10"
                                                                    Width="70px"></asp:TextBox></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10px" valign="middle">
                                                                <asp:Label ID="Label6" runat="server" Height="16px" Text="Tax Status" Width="111px" Font-Bold="True"></asp:Label></td>
                                                <td style="width: 100px; height: 16px">
                                                                <asp:DropDownList ID="ddlTaxStatus" CssClass="FormCtrl" TabIndex="7" Height="20px"
                                                                    Width="115px" runat="server">
                                                                </asp:DropDownList></td>
                                                <td style="width: 100px; height: 16px">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding-left: 10px" valign="middle">
                                                    <asp:Label ID="Label7" runat="server" Height="16px" Text="Indicator" Width="111px" Font-Bold="True"></asp:Label></td>
                                                <td style="width: 100px; height: 16px">
                                                     <asp:DropDownList ID="ddlIndicator" CssClass="FormCtrl"  TabIndex="9"  Height="20px" Width="200px" runat="server"></asp:DropDownList></td>
                                                <td style="width: 100px; height: 16px">
                                                </td>
                                            </tr>
                                            <tr><td colspan ="3"></td> </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                        <%--<td class="lightBlueBg" style="padding-top: 1px; height: 28px; text-align: right;border: none;">--%>
                            <td class="lightBlueBg" style="padding-top: 1px; width:350px; padding-left: 50px; text-align:left; border:none;" > <%--style="padding-top: 1px; height: 30px; padding-left: 125px; text-align:left; border:none;" >--%>
                                <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                          runat="server" OnClientClick="javascript:return MaintenaceAppsRequiredField();" OnClick="btnSave_Click" Visible="false" TabIndex="14" />
                                        <asp:ImageButton ID="btnCancel" ImageUrl="~/MaintenanceApps/Common/images/cancel.png"
                                            runat="server" CausesValidation="False" TabIndex="15" OnClick="btnCancel_Click" />
                                        <asp:ImageButton ID="btnDelete" ImageUrl="~/MaintenanceApps/Common/Images/btndelete.gif"
                                            runat="server" CausesValidation="False" OnClick="btnDelete_Click" TabIndex="16" />&nbsp;
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td class="lightBlueBg" style="padding-top: 1px; height: 5px; text-align: right; width: 656px;">
                            </td>
                        </tr>
                    </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td  valign="top" >
                    <asp:UpdatePanel ID="upnlGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr class="lightBlueBg">
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 7px; width: 4%;">
                                        <span class="BanText" >Expense Codes</span>
                                    </td>
                                    <td class="lightBlueBg" style="padding-top: 1px; height: 1px; width: 5%;">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                        <div id="div-datagrid" class="Sbar" style="overflow-x:auto; overflow-y: auto;
                                            position: relative; top: 0px; left: 0px; height: 210px; width: 850px; border: 0px solid;"
                                            align="left">
                                            <asp:DataGrid CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="dgExpenseCode"
                                                GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                AllowSorting="True" ShowFooter="False" OnItemCommand="dgExpenseCode_ItemCommand"
                                                OnSortCommand="dgExpenseCode_SortCommand"  TabIndex="17" OnItemDataBound="dgExpenseCode_ItemDataBound">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <FooterStyle CssClass="lightBlueBg" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Actions">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pTableID")%>'>Edit</asp:LinkButton>
                                                            <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pTableID")%>'>Delete</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="90px" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="TableCd" HeaderText="Code" SortExpression="TableCd">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="75px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="75px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="Dsc" HeaderText="Description" SortExpression="Dsc">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="150px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="300px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ShortDsc" HeaderText="Short Description" SortExpression="ShortDsc">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="150px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="200px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EntryDt" HeaderText="Enter Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="EntryDt">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="ChangeDt" HeaderText="Change Date" DataFormatString="{0:MM/dd/yyyy}"
                                                        SortExpression="ChangeDt">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="100px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="100px" />
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
                <td style="width: 1253px">
                    <uc2:Footer ID="BottomFrame2" Title="Expense Codes" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
