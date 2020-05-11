<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ApplicationPref.aspx.cs"
    Inherits="CountryCodeMaster" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Application Preferences</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
    <script>
    
    function ValdateNumber()
    {
        if(event.keyCode<46 || event.keyCode>58 )
            event.keyCode=0;
    }

    </script>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';" onmouseup="divToolTips.style.display='none';"
    onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';"
    topmargin="3">
    <form id="form1" runat="server" defaultfocus="txtCode">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" id="mainTable">
            <tr>
                <td>
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                        <tr>
                            <td>
                                <span class="BanText">Application Preferences Information </span>
                            </td>
                            <td style="width: 100px">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="height: 26px">
                                            <asp:ImageButton ID="btnAdd" ImageUrl="~/MaintenanceApps/Common/images/newadd.gif"
                                                runat="server" CausesValidation="False" TabIndex="10" OnClick="btnAdd_Click1" />
                                        </td>
                                        <td style="padding-left: 10px; height: 26px;">
                                            <img id="CloseButton" src="Common/images/close.jpg" onclick="javascript:window.close();"
                                                tabindex="11" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 20px">
                    <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table width="175">
                                <tr>
                                    <td class="Left2pxPadd " style="padding-left: 30px" colspan="6">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px; width: 166px;">
                                        <asp:LinkButton ID="lnkCode" runat="server" Font-Underline="true" Text="Code" TabIndex="14"></asp:LinkButton>
                                        <div id="divToolTips" class="list" style="display: none; position: absolute;" onmouseup="return false;">
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
                                    <td style="width: 300px;">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 100px; height: 21px;">
                                                    <asp:TextBox ID="txtCode" TabIndex="1" CssClass="FormCtrl" runat="server" MaxLength="20"></asp:TextBox></td>
                                                <td style="width: 100px; padding-left: 10px; height: 21px;">
                                                    <span style="color: #ff0000">*</span></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 300px; height: 26px">
                                        <span style="color: Red;"></span>
                                    </td>
                                    <td style="width: 300px; height: 26px">
                                    </td>
                                    <td style="width: 300px; height: 26px">
                                        <asp:Label ID="Label5" runat="server" Height="16px" Text="Description" Width="100px"
                                            Font-Bold="True"></asp:Label></td>
                                    <td style="padding-left: 0px" rowspan="5" valign="top">
                                        <asp:TextBox ID="txtComments" CssClass="FormCtrl" runat="server" TabIndex="3" MaxLength="100"
                                            Height="80px" TextMode="MultiLine" Width="230px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px; width: 166px;">
                                        <asp:Label ID="Label3" runat="server" Height="16px" Text="Type" Width="90px"></asp:Label></td>
                                    <td style="width: 100px; height: 26px">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 100px; height: 21px;">
                                                    <asp:TextBox ID="txtType" CssClass="FormCtrl" runat="server" TabIndex="2"
                                                        MaxLength="48" Width="120px"></asp:TextBox>
                                                </td>
                                                <td style="width: 100px; padding-left: 10px; height: 21px;">
                                                    <span style="color: #ff0000">*</span></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 100px; padding-left: 10px;">
                                        <span style="color: Red;"></span>
                                    </td>
                                    <td style="padding-left: 10px; width: 100px">
                                    </td>
                                    <td style="padding-left: 10px; width: 100px">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px; width: 166px;">
                                        <asp:Label ID="Label4" runat="server" Height="16px" Text="Value" Width="90px"></asp:Label></td>
                                    <td style="width: 100px">
                                        <asp:TextBox ID="txtValue" CssClass="FormCtrl" runat="server" TabIndex="2" MaxLength="15"
                                            Width="120px"></asp:TextBox></td>
                                    <td style="width: 100px">
                                    </td>
                                    <td style="width: 100px">
                                    </td>
                                    <td style="width: 100px">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px; width: 166px;">
                                        <asp:Label ID="Label1" runat="server" Height="16px" Text="Number" Width="90px"></asp:Label></td>
                                    <td style="width: 100px">
                                        <asp:TextBox ID="txtNumber" runat="server" CssClass="FormCtrl" onkeypress="ValdateNumber();" MaxLength="8" TabIndex="2"
                                            Width="120px"></asp:TextBox>&nbsp;</td>
                                    <td style="width: 100px">
                                    </td>
                                    <td style="width: 100px">
                                    </td>
                                    <td style="width: 100px">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                    </td>
                                    <td style="width: 100px; height: 26px; padding-top: 5px;">
                                    </td>
                                    <td style="width: 100px; height: 26px; padding-top: 5px;">
                                    </td>
                                    <td style="width: 100px; padding-top: 5px; height: 26px">
                                    </td>
                                    <td style="width: 100px; padding-top: 5px; height: 26px">
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg" align="right" style="padding-top: 1px; height: 25px; padding-right: 10px;
                    border-top-style: none; border-right-style: none; border-left-style: none;">
                    <asp:UpdatePanel ID="upnlbtnsave" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                                <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                     <asp:ImageButton ID="btnSave" ImageUrl="~/MaintenanceApps/Common/images/BtnSave.gif"
                                runat="server" CausesValidation="False" OnClick="btnSave_Click1" TabIndex="16" />
                                                </td>
                                                <td></td>
                                            </tr>
                                        </table>
                           
                           
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="upnlGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr class="lightBlueBg">
                                    <td class="lightBlueBg" colspan="2" style="padding-top: 1px; height: 1px">
                                        <span class="BanText">Application Preferences</span> &nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                        <div id="div-datagrid" class="Sbar" style="overflow-x: hidden; overflow-y: auto;
                                            position: relative; top: 0px; left: 0px; height: 350px; width: 1020px; border: 0px solid;"
                                            align="left">
                                            <asp:DataGrid CssClass="grid" BackColor="#F4FBFD" Style="height: auto" ID="dgAppPref"
                                                GridLines="Both" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="True"
                                                AllowSorting="True" OnItemCommand="dgAppPref_ItemCommand" OnSortCommand="dgAppPref_SortCommand"
                                                OnItemDataBound="dgAppPref_ItemDataBound" TabIndex="13">
                                                <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                <ItemStyle CssClass="GridItem" />
                                                <AlternatingItemStyle CssClass="zebra" />
                                                <FooterStyle CssClass="lightBlueBg" />
                                                <Columns>
                                                    <asp:TemplateColumn HeaderText="Actions">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lnlEdit" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:document.getElementById('hidScrollTop').value =document.getElementById('div-datagrid').scrollTop;"
                                                                CommandName="Edit" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pAppPrefID")%>'>Edit</asp:LinkButton>
                                                            <asp:LinkButton ID="lnlDelete" CausesValidation="false" Font-Underline="true" ForeColor="#cc0000"
                                                                Style="padding-left: 5px" runat="server" OnClientClick="javascript:return confirm('Are you sure you want to delete?');"
                                                                CommandName="Delete" CommandArgument='<%#  DataBinder.Eval(Container.DataItem,"pAppPrefID")%>'>Delete</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="80px" />
                                                    </asp:TemplateColumn>
                                                    <asp:BoundColumn DataField="ApplicationCd" HeaderText="Code" SortExpression="ApplicationCd">
                                                        <HeaderStyle Width="75px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="AppOptionType" HeaderText="Type" SortExpression="AppOptionType">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="80px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="80px" />
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn DataField="AppOptionTypeDesc" HeaderText="Description" SortExpression="AppOptionTypeDesc">
                                                        <ItemStyle CssClass="Left5pxPadd" Width="300px" HorizontalAlign="Left" />
                                                        <HeaderStyle Width="300px" />
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
                                            <input type="hidden" id="hidPrimaryKey" runat="server" tabindex="12" />
                                            <asp:HiddenField ID="hidScrollTop" runat="server" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar">
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
                                <asp:UpdateProgress ID="upPanel" DisplayAfter="2" runat="server" DynamicLayout="false">
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
                <td class="BluBg buttonBar">
                    <uc2:Footer ID="Footer1" runat="server" Title="Application Preferences" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
