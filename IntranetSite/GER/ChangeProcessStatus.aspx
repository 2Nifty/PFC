<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false" CodeFile="ChangeProcessStatus.aspx.cs" Inherits="GERChangeProcessStatus" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GER Process Status</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css">
   
    <style>
    .PageBg 
    {
	    background-color: #B3E2F0;
	    padding: 1px;
    }    
    </style>
</head>
<body >
    <form id="form1" runat="server" defaultbutton="FindBOLButt">
        <table width=100%>
            <tr>
                <td valign=middle class=PageHead colspan=2>
                       <span class=Left5pxPadd>
                       <asp:Label ID="lblParentMenuName" CssClass=BannerText runat="server" Text="Change Process Status To Now"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr>
                <td width=200>
                <asp:Panel ID="PromptPanel" runat="server" height="30" Width="200px">
                    <table width="200">
                        <tr>
                            <td width="100">
                            <asp:Label ID="BOLLabel" runat="server" Text="BOL&nbsp;Number"></asp:Label>
                            </td>
                            <td width="100">
                        <asp:TextBox ID="BOLNumberBox" runat="server" onFocus="this.select();"></asp:TextBox>
                                <input id="PrintHide" name="PrintHide" type="hidden"  value="Print"/>
                            </td>
                            <td>
                        <asp:ImageButton ID="FindBOLButt" runat="server" ImageUrl="../Common/Images/search.gif" />
                            </td>
                        </tr>
                    </table>        
                </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td>
                            <asp:GridView ID="PreUpdateGridView" runat="server" AutoGenerateColumns="False" >
                           <Columns>
                               <asp:BoundField DataField="BOLNo" HeaderText="BOL Number" SortExpression="BOLNo" ItemStyle-Width="140px" 
                                HeaderStyle-HorizontalAlign="left"/>
                              <asp:BoundField DataField="ProcessRecInd" HeaderText="Current Setting"  HtmlEncode="false" ItemStyle-Width="140px">
                                   <ItemStyle HorizontalAlign="Center"  />
                               </asp:BoundField>
                           </Columns>
                            </asp:GridView>
                            </td>
                            <td>
                        <asp:ImageButton ID="UpdateButton" runat="server" ImageUrl="../Common/Images/update.gif" OnClick="UpdateButton_Click" 
                        CausesValidation="false" />
                            </td>
                        </tr>
                    </table>        
                </td>
            </tr>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td>
                            <asp:GridView ID="ResultsGridView" runat="server" AutoGenerateColumns="False">
                            <Columns>
                            <asp:BoundField DataField="BOLNo" HeaderText="BOL Number" SortExpression="BOLNo" ItemStyle-Width="140px" 
                            HeaderStyle-HorizontalAlign="left"/>
                            <asp:BoundField DataField="ProcessRecInd" HeaderText="Updated Setting"  HtmlEncode="false" ItemStyle-Width="140px">
                               <ItemStyle HorizontalAlign="Center"  />
                            </asp:BoundField>
                            </Columns>
                            </asp:GridView>
                            </td>
                        </tr>
                    </table>        
                </td>
            </tr>
            <tr>
                <td colspan=2>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                    <td align="left" class="PageBg">
                    <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label></td>
                    <td align="right" class="PageBg" valign="bottom">
                        <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                        <td style="padding-left: 5px">
                            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg" 
                                PostBackUrl="../InvReportDashboard/GERDashBoard.aspx" />
                        </td>
                        </tr>
                        </table>
                    </td>
                    </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>

</html>
