<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommAnnouncement.aspx.cs"
    Inherits="eCommerceAnnouncementPage" %>

<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>eCommerce Announcements</title>
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
    function AnnouncementRequiredField()
    {
        
        if( document.getElementById("txtTitle").value == '' ||
            document.getElementById("txtMessage").value == '' ||
            document.getElementById('dpEndDt_textBox').value  == '' ||
            document.getElementById('dpStartDt_textBox').value == "")
        {
            alert("'*' fields are mandatory.")
            return false;
        }
        
        return true;
         
    }
    </script>

</head>
<body scroll="no" onclick="javascript:document.getElementById('lblMessage').innerText='';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';"
    onmouseup="divToolTips.style.display='none';">
    <form id="form1" runat="server" defaultfocus="txtSearchCode">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" id="mainTable" width="100%">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;">
                    <table width="100%" class="blueBorder" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td class="lightBlueBg" colspan="2">
                                <asp:UpdatePanel ID="upnlbtnSearch" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnSearch">
                                            <table>
                                                <tr>
                                                    <td style="padding-left: 10px">
                                                        <asp:Label ID="lblSch" runat="server" Font-Bold="True" Text="Branch:" Width="50px"></asp:Label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlLocationSearch" Height="20px" CssClass="FormCtrl" runat="server"
                                                            Width="150px" TabIndex="1">
                                                        </asp:DropDownList></td>
                                                    <td style="padding-left: 20px">
                                                        <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Search By:" Width="65px"></asp:Label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlSearchType" Height="20px" CssClass="FormCtrl" runat="server"
                                                            Width="150px" TabIndex="2">
                                                            <asp:ListItem>ALL</asp:ListItem>
                                                            <asp:ListItem Value="MessageType">Application Type</asp:ListItem>
                                                            <asp:ListItem Value="FormMessage">Title</asp:ListItem>
                                                            <asp:ListItem Value="DisplayMessage">Message</asp:ListItem>
                                                            <asp:ListItem Value="CustomerType">Cust Type</asp:ListItem>
                                                            <asp:ListItem Value="FormType">Form Type</asp:ListItem>                                                            
                                                        </asp:DropDownList></td>
                                                    <td style="padding-left: 20px">
                                                        <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Find:" Width="35px"></asp:Label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtFindText" runat="server" CssClass="FormCtrl" TabIndex="3" Width="150px"></asp:TextBox></td>
                                                    <td>
                                                        <asp:ImageButton ID="btnSearch" runat="server" CausesValidation="False" ImageUrl="~/MaintenanceApps/Common/images/BtnSearch.gif"
                                                            OnClick="btnSearch_Click" TabIndex="4" />
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
                                <asp:Label ID="lblHeading" runat="server" Text="eCommerce Announcements" CssClass="BanText"
                                    Width="334px"></asp:Label></td>
                            <td style="height: 5px" align="right" class="lightBlueBg">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <asp:UpdatePanel ID="upnlAdd" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="width: 80px">
                                                                <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                                    runat="server" CausesValidation="False" OnClick="btnAdd_Click" TabIndex="15" />
                                                            </td>
                                                            <td style="width: 80px">
                                                                <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                                    tabindex="16" />
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
                                <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <table style="padding-left: 10px" align="left" border="0">
                                            <tr>
                                                <td align="left" class="DarkBluTxt">
                                                    <asp:LinkButton ID="lnkCode" runat="server" Style="text-decoration: underline" Text="Branch:"
                                                        Width="85px" TabIndex="21" Font-Bold="True"></asp:LinkButton>
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
                                                    <asp:HiddenField ID="hidPrimaryKey" runat=server Value="" />
                                                </td>
                                                <td colspan="3" style="padding-right: 10px">
                                                    <asp:DropDownList ID="ddlLocation" Height="20px" CssClass="FormCtrl" runat="server"
                                                        Width="150px" TabIndex="5">
                                                    </asp:DropDownList></td>
                                                <td colspan="1" style="padding-left: 10px;">
                                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Height="16px" Text="Start Date:"
                                                        Width="60px"></asp:Label></td>
                                                <td colspan="1" style="padding-right: 10px">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <uc3:novapopupdatepicker ID="dpStartDt" runat="server" TabIndex="9" />
                                                            </td>
                                                            <td>
                                                                <font style="color: red">* </font>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" class="DarkBluTxt">
                                                    <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Application Type:"></asp:Label></td>
                                                <td colspan="3" style="padding-right: 10px">
                                                    <asp:DropDownList ID="ddlMsgType" Height="20px" CssClass="FormCtrl" runat="server"
                                                        Width="150px" TabIndex="6">
                                                    </asp:DropDownList></td>
                                                <td colspan="1" style="padding-left: 10px;">
                                                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Height="16px" Text="End Date:"
                                                        Width="60px"></asp:Label></td>
                                                <td colspan="1" style="padding-right: 10px">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <uc3:novapopupdatepicker ID="dpEndDt" runat="server" TabIndex="10" />
                                                            </td>
                                                            <td>
                                                                <font style="color: red">* </font>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 26px;" class="DarkBluTxt">
                                                    <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Cust Type:" Width="62px"></asp:Label></td>
                                                <td colspan="3">
                                                    <asp:DropDownList ID="ddlCustType" CssClass="FormCtrl" Height="20px" runat="server"
                                                        Width="150px" TabIndex="7">
                                                    </asp:DropDownList></td>
                                                <td style="padding-left: 10px">
                                                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Title:"></asp:Label></td>
                                                <td style="width: 100px">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox ID="txtTitle" runat="server" CssClass="FormCtrl" TabIndex="11" Width="215px"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <font style="color: red">* </font>
                                                            </td>
                                            </tr>
                                        </table>
                                        </td> </tr>
                                        <tr>
                                            <td valign="top" style="padding-left: 10px">
                                                <asp:Label ID="Label4" runat="server" Height="16px" Text="Form Type:" Width="65px"
                                                    Font-Bold="True"></asp:Label></td>
                                            <td colspan="3" valign="top">
                                                <asp:DropDownList ID="ddlFormType" CssClass="FormCtrl" Height="20px" runat="server"
                                                    Width="150px" TabIndex="8">
                                                </asp:DropDownList></td>
                                            <td style="padding-left: 10px" valign="top">
                                                <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Message:"></asp:Label></td>
                                            <td style="width: 100px">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:TextBox ID="txtMessage" runat="server" CssClass="FormCtrl" Height="60px" TabIndex="12"
                                                                TextMode="MultiLine" Width="215px"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <font style="color: red">* </font>
                                                        </td>
                                        </tr>
                                        </table> </td> </tr> </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="lightBlueBg" style="padding-top: 1px; height: 30px; text-align: left;
                                border: none; padding-left: 100px;">
                                <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                                        runat="server" OnClientClick="javascript:return AnnouncementRequiredField();"
                                                        OnClick="btnSave_Click" Visible="false" TabIndex="13" /></td>
                                                <td style="padding-left: 10px;">
                                                    <asp:ImageButton ID="btnCancel" ImageUrl="~/MaintenanceApps/Common/images/cancel.png"
                                                        runat="server" CausesValidation="False" OnClick="btnCancel_Click" TabIndex="14"
                                                        Visible="False" /></td>
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
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                        <div id="div-datagrid" class="Sbar" style="overflow-x: auto; overflow-y: auto; position: relative;
                                            top: 0px; left: 0px; height: 300px; width: 1010px; border: 0px solid;" align="left">
                                            <asp:DataGrid CssClass="grid" BackColor="#f4fbfd" Style="height: auto" ID="dgeCommAnnounce"
                                                GridLines="both" runat="server" AutoGenerateColumns="false" UseAccessibleHeader="true"
                                                AllowSorting="True" PagerStyle-Visible="false" ShowFooter="False" AllowPaging="true"
                                                OnItemCommand="dgeCommAnnounce_ItemCommand"  OnSortCommand="dgeCommAnnounce_SortCommand"
                                                OnItemDataBound="dgeCommAnnounce_ItemDataBound" TabIndex="18">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" VerticalAlign="Top" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <FooterStyle CssClass="lightBlueBg" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Actions">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pHolidayMessageID")%>'>Edit</asp:LinkButton>
                                                            <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pHolidayMessageID")%>'>Delete</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="70px" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="LocName" HeaderText="Branch" SortExpression="LocName">
                                                        <ItemStyle Width="100px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="MsgTypeDesc" HeaderText="App Type" SortExpression="MsgTypeDesc">
                                                        <ItemStyle Width="70px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="FormMessage" HeaderText="Title" SortExpression="FormMessage">
                                                        <ItemStyle Width="135px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="DisplayMessage" HeaderText="Message" SortExpression="DisplayMessage">
                                                        <ItemStyle Width="150px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="CustTypeDesc" HeaderText="Cust Type" SortExpression="CustTypeDesc">
                                                        <ItemStyle Width="120px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="FormTypeDesc" HeaderText="Form Type" SortExpression="FormTypeDesc">
                                                        <ItemStyle Width="120px" CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="StartDt" HeaderText="Start Date" SortExpression="StartDt">
                                                        <ItemStyle CssClass="Left5pxPadd" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="60px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="EndDt" HeaderText="End Date" SortExpression="EndDt">
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
                    <uc2:Footer ID="BottomFrame2" Title="eCommerce Announcements" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
