<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation=false CodeFile="OrganisationStandardComments.aspx.cs"
    Inherits="StandardComments" %>

<%@ Register Src="~/Common/UserControls/PhoneNumber.ascx" TagName="Phone" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Organization Standard Comments</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>

    <script>
       
        function LoadCustomer(_custNo,_type)
        {   
            var Url = "CustomerList.aspx?ctrlName=sHistory&Type="+_type+"&Customer=" + _custNo;
            window.open(Url,'CustomerList' ,'height=450,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
        }
        
        function CommentsCount(text,long) 
        {

	        var maxlength = new Number(long); // Change number to your max length.

	        if (text.value.length > maxlength){

		        text.value = text.value.substring(0,maxlength);

		        alert(" Only " + long + " chars allowed");

	        }

        }


    </script>

</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';if(document.getElementById('divToolTips')!=null)document.getElementById('divToolTips').style.display = 'none';">
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
                <td class="Left2pxPadd boldText lightBlueBg" style="padding-left: 10px;">
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
                                                    <td style="padding-left: 20px;">
                                                        <asp:Label ID="Label1" runat="server" Text="Customer Number" Width="150px"></asp:Label></td>
                                                    <td>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtCustNo" CssClass="FormCtrl" runat="server" MaxLength="10" Width="150px"></asp:TextBox></td>                                                    
                                                    <td style="padding-left: 10px;">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td style="width: 80px">
                                                                    <asp:ImageButton ID="btnSearch"    runat="server" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                                        OnClick="btnSearch_Click" CausesValidation="False" TabIndex="15" /></td>
                                                                <td style="width: 100px">
                                                                    <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                                        runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="10" Visible=false /></td>
                                                            </tr>
                                                        </table>
                                                        <asp:HiddenField ID="hidPrimaryKey" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td style="height: 16px; padding-right: 10px;" align="right">
                                            <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                tabindex="11" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="height: 560px" valign=top>
                    <asp:UpdatePanel ID="upnlOrgSttComments" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <table id="tblOrgStdCOmments" runat="server" visible="false" width="100%" border="0"
                        cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <table class="blueBorder" width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="lightBlueBg">
                                            <asp:Label ID="lblHeading" runat="server" Text="Enter Organization Standard Comments"
                                                CssClass="BanText" Width="325px"></asp:Label></td>
                                        <td style="height: 5px" align="right" class="lightBlueBg">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding-top: 0px;">
                                            <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <table border="0" style="height: 120px;">
                                                        <tr>
                                                            <td runat="server" valign="top" style="border-left: 10px; width: 300px; padding-top: 5px;"
                                                                bordercolor="blue" id="Td1">
                                                                <table>
                                                                    <tr>
                                                                        <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px; font-weight: bold;">
                                                                            <asp:Label Width="200px" ID="lbltype" runat="server"></asp:Label>
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
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                                            <asp:Label Width="300px" ID="lblName" runat="server"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                                            <asp:Label Width="300px" ID="lblAddress" runat="server"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                                            <asp:Label ID="lblCityInfo" runat="server" Width="300px"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                                            <asp:Label Width="100px" ID="lblCountry" runat="server"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                                            <asp:Label Width="200px" ID="lblPhone" runat="server"></asp:Label>&nbsp;
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                            <td visible="false" runat="server" id="tdComment" valign="top" style="padding-left: 15px;
                                                                padding-top: 5px; border-left: 1px solid #7ecfe7;">
                                                                <table border="0" id="tblDataEntry" visible="false" runat="server" cellpadding="0"
                                                                    cellspacing="0">
                                                                    <tr>
                                                                        <td style="width: 100px" valign="top">
                                                                            <table>
                                                                                <tr>
                                                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-bottom: 25px" valign="top">
                                                                                        <asp:LinkButton ID="lnkCode" Font-Underline="true" Text="Comments" TabIndex="14"
                                                                                            runat="server"></asp:LinkButton></td>
                                                                                    <td style="padding-top: 1px">
                                                                                        <asp:TextBox ID="txtComment" TextMode="MultiLine" runat="server" CssClass="FormCtrl"
                                                                                            Height="70px" Width="260px" MaxLength="100" onKeyUp="CommentsCount(this,255)" onChange="CommentsCount(this,255)" ></asp:TextBox></td>
                                                                                    <td valign=top>
                                                                                        <span style="color: Red">*</span></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="Left2pxPadd DarkBluTxt boldText">
                                                                                        Line No</td>
                                                                                    <td>
                                                                                        <asp:TextBox Width="100px" MaxLength=10 onkeypress="javascript:ValdateNumber();" ID="txtLine" runat="server" CssClass="FormCtrl"></asp:TextBox></td>
                                                                                    <td>
                                                                                        </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td style="width: 100px; padding-left: 10px;">
                                                                            <asp:UpdatePanel ID="upnlchkSelectAll" runat="server" UpdateMode="conditional">
                                                                                <ContentTemplate>
                                                                                    <table cellpadding="0" cellspacing="0" class="blueBorder" style="border-collapse: collapse">
                                                                                        <tr>
                                                                                            <td style="height: 22px" class="lightBlueBg">
                                                                                                <asp:CheckBox ID="chkSelectAll" runat="server" Text="Select / Deselect All" Width="130px"
                                                                                                    AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" ForeColor="#CC0000"
                                                                                                    TabIndex="7" Font-Bold="True" />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="blueBorder" style="padding-top: 1px;">
                                                                                                <asp:CheckBoxList ID="chkSelection" runat="server" Height="20px" RepeatDirection="vertical"
                                                                                                    Width="130px" AutoPostBack="True" TabIndex="8" Font-Bold="True">
                                                                                                    <asp:ListItem>SO</asp:ListItem>
                                                                                                    <asp:ListItem>PO</asp:ListItem>
                                                                                                    <asp:ListItem>Email</asp:ListItem>
                                                                                                </asp:CheckBoxList>
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
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="lightBlueBg" align=right colspan="2" style="border-right: medium none; border-top: medium none;
                                            border-left: medium none; padding-top: 1px; border-bottom: medium none; height: 25px;">
                                            <asp:UpdatePanel ID="upnlButtons" UpdateMode="conditional" runat="server">
                                                <ContentTemplate>
                                                    <table border="0">
                                                        <tr>
                                                            <td class="lightBlueBg" style="border-right: medium none; border-top: medium none;
                                                                border-left: medium none; padding-top: 1px; border-bottom: medium none; height: 25px;
                                                                text-align: left">
                                                                <asp:ImageButton Visible="false" ID="btnDelete" ImageUrl="~/MaintenanceApps/Common/Images/btndelete.gif"
                                                                    runat="server" CausesValidation="False" OnClick="btnDelete_Click" TabIndex="12" /></td>
                                                            <td class="lightBlueBg" style="border-right: medium none; border-top: medium none;
                                                                border-left: medium none; padding-left: 310px; padding-top: 1px; border-bottom: medium none;
                                                                height: 25px; text-align: left">
                                                                <asp:ImageButton Visible="false" ID="btnNext" ImageUrl="~/MaintenanceApps/Common/Images/next.gif"
                                                                    runat="server" CausesValidation="False" TabIndex="12" OnClick="btnNext_Click" /></td>
                                                            <td class="lightBlueBg" style="padding-top: 1px; height: 25px; text-align: left;
                                                                border: none;">
                                                                <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                                    runat="server" OnClick="btnSave_Click" Visible="false" TabIndex="9" /></td>
                                                            <td class="lightBlueBg" style="padding-top: 1px; height: 25px; text-align: right;
                                                                border: none; padding-left: 360px;padding-right:10px;">
                                                                <asp:ImageButton ID="btnCancel" ImageUrl="~/MaintenanceApps/Common/images/cancel.png"
                                                                    runat="server" TabIndex="9" Visible="false" OnClick="btnCancel_Click1" /></td>
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
                                        <table width="300%" cellpadding="0" cellspacing="0">
                                            <tr class="lightBlueBg">
                                                <td class="lightBlueBg" style="padding-top: 1px; height: 7px; width: 4%;">
                                                    <span class="BanText">Organization Standard Comments</span>
                                                </td>
                                                <td class="lightBlueBg" style="padding-top: 1px; height: 1px; width: 5%;">
                                                    &nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td style="padding-top: 1px; height: 7px;" colspan="2">
                                                    <div id="div-datagrid" class="Sbar" style="overflow-x: hidden; overflow-y: auto;
                                                        position: relative; top: 0px; left: 0px; height: 340px; width: 1020px; border: 0px solid;"
                                                        align="left">
                                                        <asp:DataGrid CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="dgCountryCode"
                                                            GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                            AllowSorting="True" ShowFooter="False" OnItemCommand="dgCountryCode_ItemCommand"
                                                            OnSortCommand="dgCountryCode_SortCommand" OnItemDataBound="dgCountryCode_ItemDataBound"
                                                            TabIndex="13">
                                                            <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                            <ItemStyle CssClass="GridItem" />
                                                            <AlternatingItemStyle CssClass="zebra" />
                                                            <FooterStyle CssClass="lightBlueBg" />
                                                            <Columns>
                                                                <asp:TemplateColumn HeaderText="Actions">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                            Style="padding-left: 5px" runat="server" CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pTableID")%>'>Edit</asp:LinkButton>
                                                                        <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                            Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                            CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pTableID")%>'>Delete</asp:LinkButton>
                                                                    </ItemTemplate>
                                                                    <ItemStyle Width="80px" />
                                                                </asp:TemplateColumn>
                                                                <asp:BoundColumn DataField="TableName" HeaderText="Type" SortExpression="TableName">
                                                                    <ItemStyle CssClass="Left5pxPadd" Width="50px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="50px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="Name" HeaderText="Name" SortExpression="Name">
                                                                    <ItemStyle CssClass="Left5pxPadd" Width="200px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="200px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="Comments" HeaderText="Comment" SortExpression="Comments">
                                                                    <ItemStyle CssClass="Left5pxPadd" Width="320px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="320px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="EntryID" HeaderText="Entry ID" SortExpression="EntryID">
                                                                    <ItemStyle CssClass="Left5pxPadd" Width="80px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="80px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="EntryDt" HeaderText="Enter Date" DataFormatString="{0:MM/dd/yyyy}"
                                                                    SortExpression="EntryDt">
                                                                    <ItemStyle CssClass="Left5pxPadd" Width="80px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="80px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="ChangeID" HeaderText="Change ID" SortExpression="ChangeID">
                                                                    <ItemStyle CssClass="Left5pxPadd" Width="80px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="80px" />
                                                                </asp:BoundColumn>
                                                                <asp:BoundColumn DataField="ChangeDt" HeaderText="Change Date" DataFormatString="{0:MM/dd/yyyy}"
                                                                    SortExpression="ChangeDt">
                                                                    <ItemStyle CssClass="Left5pxPadd" Width="80px" HorizontalAlign="Left" />
                                                                    <HeaderStyle Width="80px" />
                                                                </asp:BoundColumn>
                                                            </Columns>
                                                        </asp:DataGrid>
                                                        <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                                        <input type="hidden" id="hidpOrgStdComID" runat="server" tabindex="12" />
                                                    </div>
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
                    <uc2:Footer ID="BottomFrame2" Title="Organization Standard Comments" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
