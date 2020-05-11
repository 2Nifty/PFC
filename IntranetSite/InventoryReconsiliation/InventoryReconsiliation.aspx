<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InventoryReconsiliation.aspx.cs"
    Inherits="InventoryReconsiliation_InventoryReconsiliation" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="../MaintenanceApps/Common/UserControls/Header.ascx" TagName="Header"
    TagPrefix="uc4" %>
<%--<%@ Register Src="~/InventoryReconsiliation/Common/UserControls/Header.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Inventory Reconciliation Report</title>
    <link href="../MaintenanceApps/Common/StyleSheet/LM_Styles.css" rel="stylesheet"
        type="text/css" />
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
    //Javascript function to Show the preview page
    function PrintReport()
    {
        var hWnd= window.open("InventoryReconsiliationPreview.aspx?Sort="+document.getElementById("hidSort").value,"InventoryReconsiliation" ,'height=710,width=780,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (780/2))+',resizable=YES',"");
        hWnd.opener = self;if (window.focus) {hWnd.focus();}
    }

    // Javascript Function To Call Server Side Function
    function DeleteFiles()
    {
        var str=InventoryReconsiliation_InventoryReconsiliation.DeleteExcel('InventoryReconsiliation'+'<%=Session["SessionID"].ToString()%>').value.toString();
           parent.window.close();
    }
    function BindValue(sortExpression)
    {
       
        if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value= sortExpression;
        document.getElementById("btnSort").click();
    }
      function LoadHelp()
        {
            window.open("../Help/HelpFrame.aspx?Name=inventoryreconciliation",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");

        }
    </script>

</head>
<body  onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="vertical-align:top;">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px; height: 30px;">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" style="height: 100%">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="lightBlueBg" style="height: 36px" colspan="">
                                            <asp:Label ID="lblHeading" runat="server" Text=" Inventory Reconciliation Report"
                                                CssClass="BanText" Width="284px"></asp:Label></td>
                                        <td align="right" style="width: 70px; padding-right: 5px; height: 36px;"  class="lightBlueBg" colspan="3">
                                            <table border="0" cellpadding="0" cellspacing="0" width="350" align="right">
                                                <tr>
                                                    <td style="width: 100px; height: 26px;">
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    <td style="width: 100px; height: 26px;">
                                                        <img align="right" onclick="javascript:PrintReport();" src="../Common/Images/Print.gif"
                                                            style="cursor: hand" /></td>
                                                    <td style="width: 100px; height: 26px">
                                                        <img src="../InventoryReconsiliation/Common/Images/Buttons/help.gif" onclick="javascript:LoadHelp();" /></td>
                                                    <td style="width: 100px; height: 26px;">
                                                        <img align="right" onclick="Javascript:DeleteFiles();" src="Common/Images/Buttons/Close.gif"
                                                            style="cursor: hand" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr id="trHead" class="PageBg">
                            <td class="LeftPadding TabHead" style="height: 15px" valign="top">
                                <asp:Label ID="lblBranch" runat="server"  Width="304px"></asp:Label></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td  >
                    <asp:UpdatePanel ID="pnldgrid" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 490px; border: 0px solid;">
                                <div id="PrintDG2">
                                    <asp:DataGrid ID="dgReconsiliation"  Width="100%" PageSize="17" runat="server" GridLines="both"
                                        BorderWidth="1px" AllowSorting="true" AutoGenerateColumns="false" ShowFooter="true"
                                        BorderColor="#DAEEEF" AllowPaging="true" PagerStyle-Visible="false" OnSortCommand="dgReconsiliation_SortCommand"
                                        OnItemDataBound="dgReconsiliation_ItemDataBound" OnPageIndexChanged="dgReconsiliation_PageIndexChanged">
                                       <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                <ItemStyle CssClass="Left5pxPadd GridItem" BackColor="White" BorderColor="White"
                                    Height="20px" HorizontalAlign="Left" />
                                <AlternatingItemStyle CssClass="Left5pxPadd GridItem" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                    HorizontalAlign="Left" />
                                <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                    HorizontalAlign="Center" />
                                        <Columns>
                                            <asp:BoundColumn HeaderText="Item"  DataField="ItemNo" SortExpression="ItemNo">
                                                <ItemStyle HorizontalAlign="Left" Width="100px" Wrap="False" />
                                                <HeaderStyle Width="100px" Wrap="False" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Description" DataField="ItemDesc" SortExpression="ItemDesc">
                                                <ItemStyle HorizontalAlign="Left" Width="280px" Wrap="False" />
                                                <FooterStyle HorizontalAlign="Right" />
                                                <HeaderStyle Width="280px" Wrap="False" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="UOM" DataField="UOM" SortExpression="UOM">
                                                <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                                                <FooterStyle HorizontalAlign="Right" />
                                                <HeaderStyle Width="70px" Wrap="False" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="WMS Qty" DataFormatString="{0:#,##0}" DataField="Qty" SortExpression="Qty">
                                                <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                                <FooterStyle HorizontalAlign="Right" />
                                                <HeaderStyle Width="70px" Wrap="False" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="ERP Qty" DataFormatString="{0:#,##0}" DataField="BookedQty" SortExpression="BookedQty">
                                                <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                                <FooterStyle HorizontalAlign="Right" />
                                                <HeaderStyle Width="70px" Wrap="False" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Variance " DataFormatString="{0:#,##0}"  DataField="variance" SortExpression="variance">
                                                <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                                <FooterStyle HorizontalAlign="Right" />
                                                <HeaderStyle Width="70px" Wrap="False" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Super UOM"  ItemStyle-Width="60" ItemStyle-HorizontalAlign=center  DataField="SuperEquiv" SortExpression="SuperEquiv">                                                
                                                <FooterStyle HorizontalAlign="Right" />                                               
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Equivelant Qty  " DataFormatString="{0:#,##0}"   ItemStyle-Width="60" ItemStyle-HorizontalAlign=right HeaderStyle-Width="120px"  DataField="SuperEquivQty" SortExpression="SuperEquivQty">                                               
                                                <FooterStyle HorizontalAlign="Right" />                                                
                                            </asp:BoundColumn>
                                            <asp:BoundColumn></asp:BoundColumn>
                                        </Columns>
                                        <PagerStyle Visible="False" />
                                    </asp:DataGrid>
                                </div>
                            </div>
                                <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                                <input type="hidden" runat="server" id="hidSortExpression" /> 
                                <input type="hidden" runat="server" id="hidSort" />
                                <asp:Button ID="btnSort" runat="server" Text="" style="display:none;" OnClick="btnSort_Click" />   
                            <uc3:pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />                         
                            
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>            
            <tr> <td  class="lightBlueBg" style="vertical-align:top;margin-top:1px;" height="20px">              
           <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout=false>
                        <ProgressTemplate>
                            <span style="padding-left: 5px;font-weight:bold;" >Loading...</span>                         
                        </ProgressTemplate>
                    </asp:UpdateProgress> 
             </td></tr>
            <tr>               
                <td style="vertical-align:top;">
                    <uc2:Footer ID="Footer1" runat="server" Title="Inventory Reconciliation Report" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
