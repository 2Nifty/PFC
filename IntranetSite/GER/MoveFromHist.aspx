<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false" CodeFile="MoveFromHist.aspx.cs" Inherits="GERMoveFromHist" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>GER History Move</title>
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
                       <asp:Label ID="lblParentMenuName" CssClass=BannerText runat="server" Text="Move BOL from History for Reprocessing"></asp:Label>
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
                               <asp:BoundField DataField="BOLNo" HeaderText="BOL Number" SortExpression="BOLNo" ItemStyle-Width="100px" 
                                HeaderStyle-HorizontalAlign="left"/>
                              <asp:BoundField DataField="ProcDt" HeaderText="Processed"  HtmlEncode="false" ItemStyle-Width="180px">
                                   <ItemStyle HorizontalAlign="Center"  />
                               </asp:BoundField>
                           </Columns>
                            </asp:GridView>
                            </td>
                            <td class=Left5pxPadd>
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
                            <asp:GridView ID="NVStatusGrid" runat="server" AutoGenerateColumns="False" >
                           <Columns>
                               <asp:BoundField DataField="DataType" HeaderText="NV Record" SortExpression="BOLNo" ItemStyle-Width="100px" 
                                HeaderStyle-HorizontalAlign="left"/>
                              <asp:BoundField DataField="DataStatus" HeaderText="Status"  HtmlEncode="false" ItemStyle-Width="80px">
                                   <ItemStyle HorizontalAlign="Left"  />
                               </asp:BoundField>
                              <asp:BoundField DataField="RcptNo" HeaderText="Rcpt"  HtmlEncode="false" ItemStyle-Width="80px">
                                   <ItemStyle HorizontalAlign="Left"  />
                               </asp:BoundField>
                              <asp:BoundField DataField="RcptLine" HeaderText="Line"  HtmlEncode="false" ItemStyle-Width="60px">
                                   <ItemStyle HorizontalAlign="Left"  />
                               </asp:BoundField>
                              <asp:BoundField DataField="Item" HeaderText="Item"  HtmlEncode="false" ItemStyle-Width="100px">
                                   <ItemStyle HorizontalAlign="Left"  />
                               </asp:BoundField>
                              <asp:BoundField DataField="PONo" HeaderText="PO Number"  HtmlEncode="false" ItemStyle-Width="80px">
                                   <ItemStyle HorizontalAlign="Left"  />
                               </asp:BoundField>
                              <asp:BoundField DataField="POLine" HeaderText="Line"  HtmlEncode="false" ItemStyle-Width="60px">
                                   <ItemStyle HorizontalAlign="Left"  />
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
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label></td>
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
