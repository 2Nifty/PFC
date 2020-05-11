<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WOList.aspx.cs" Inherits="PFC.WOE.WOPrintPage" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>WO Printing</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script>
        function PrintReport(url)
        {
            var hwin=window.open('InvoiceAnalysisByCustNoPreview.aspx?'+url, 'InvoiceAnalysisPreview', 'height=700,width=1010,scrollbars=no,status=no,top='+((screen.height/2) - (1010/2))+',left='+((screen.width/2) - (1010/2))+',resizable=NO',"");
            hwin.focus();
        }

        // Function to select all the check boxes in the datagrid
        function SelectAll(chkState)
        {
            // Define the ctrl id in varaiables
            var strCtrlPrefix="dvWOList_ctl0";
            var strCtrlSuffix="_chkSelect";
            
            var SelectAll=document.getElementById(strCtrlPrefix+"2"+"_chkSelectAll");
            SelectAll.checked = chkState;
            for(var i=3;;i++)
            {
                // Get the form Control
                if (i>9)
                    var strCtrlPrefix="dvWOList_ctl";
                else
                    var strCtrlPrefix="dvWOList_ctl0";
                var checkCtrl=document.getElementById(strCtrlPrefix+i+strCtrlSuffix);
                
                // Check or uncheck the checkbox in the datagrid
                if(checkCtrl == null || checkCtrl == 'undefined' ) 
                    break;
                else           
                {   
                    checkCtrl.checked = chkState;
                    UpdateSession(checkCtrl.id);
                }
                
            }
        }
        function UpdateSession(chkId)
        {
            var _WONo = document.getElementById(chkId.replace("_chkSelect","_hidWONo")).value;            
            WOPrintPage.SaveSelectedWorkOrders(_WONo,document.getElementById(chkId).checked);
        }
    </script>

    <script src="../Common/JavaScript/Common.js" type="text/javascript"></script>
</head>
<body onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" colspan="1">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="1">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 30px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            Work Orders: 
                                        </td>
                                        <td align="right" style="width: 20%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        &nbsp;</td>
                                                    <td>
                                                        <img align="right" onclick="Javascript:parent.window.close();"
                                                            src="Common/Images/Close.gif" style="cursor: hand; padding-right: 2px;" />
                                                            </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 545px; width: 1018px; border: 0px solid;">
                                <asp:DataGrid UseAccessibleHeader="true" PageSize="19"
                                    Width="1000px" ID="dvWOList" runat="server" AllowPaging="true" ShowHeader="true"
                                    ShowFooter="false" AllowSorting="true" AutoGenerateColumns="false" OnItemDataBound="dvWOList_RowDataBound"
                                    OnSortCommand="dvWOList_Sorting">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <ItemStyle  CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                        Height="19px" HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Right" />
                                    <Columns>
                                        <asp:TemplateColumn ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" runat="server" ToolTip="Click to select all items listed below."
                                                onclick="Javascript:SelectAll(this.checked);"/>  
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" onclick="javascript:UpdateSession(this.id);" runat="server" />  
                                                <asp:HiddenField ID="hidWONo" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"POOrderNo") %>' />                                          
                                            </ItemTemplate>                                            
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn HeaderText="W. O." DataField="POOrderNo" SortExpression="POOrderNo">
                                            <ItemStyle HorizontalAlign="Center" Width="120px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="70px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="BuyFromVendorNo" HeaderText="Br." SortExpression="BuyFromVendorNo">
                                            <ItemStyle HorizontalAlign="Center" Width="50px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="BuyFromName" HeaderText="Name" SortExpression="BuyFromName">
                                            <ItemStyle HorizontalAlign="Left"  Width="80px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="80px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="OrderDt" HeaderText="W.O. Date" SortExpression="OrderDt">
                                            <ItemStyle HorizontalAlign="Center" Width="140px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="140px" />
                                        </asp:BoundColumn>                                                                              
                                        <asp:BoundColumn DataField="ItemNo" HeaderText="Item" SortExpression="ItemNo">
                                            <ItemStyle HorizontalAlign="Center" Width="100px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Center" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="100px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="QtyOrdered" HeaderText="Qty" DataFormatString="{0:##,###,##0}" SortExpression="QtyOrdered">
                                            <ItemStyle HorizontalAlign="Right" Width="80px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Right" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="80px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="" />
                                    </Columns>
                                </asp:DataGrid>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />
                                <input type="hidden" runat="server" id="hidSort" />
                            </div>
                            <div id="divPager" runat="server">
                                <uc3:pager ID="dvPager" runat="server" OnBubbleClick="Pager_PageChanged" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" colspan="1" height="20px" style="border-top: solid 1px #DAEEEF">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td>
                    <table cellpadding="0" cellspacing="0" style="padding-top: 1px;">
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
                            <td style="width: 80px">
                            <asp:UpdatePanel ID="pnlPrint" runat="server" UpdateMode="conditional">
                                <ContentTemplate>
                                    <uc5:PrintDialogue ID="PrintDialogue1" runat="server" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="1" valign="top">
                    <table width="100%">
                        <uc2:BottomFooter ID="ucFooter" Title="Work Order Document Print List" runat="server" />
                    </table>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hidFileName" Value="" runat="server" />
    </form>
</body>
</html>
