<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReceiveReport.aspx.cs" Inherits="WarehouseMgmt_ReceiveReport" %>

<%@ Register Src="~/WarehouseMgmt/Common/UserControl/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/WarehouseMgmt/Common/UserControl/Footer.ascx" TagName="Footer"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Warehouse Receiving Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function PrintReport(url)
    {
         
        var hwin=window.open('ReceiveReportPreview.aspx?'+url, 'ReceiveReportPreview', 'height=625,width=730,scrollbars=yes,status=no,top='+((screen.height/2) - (625/2))+',left='+((screen.width/2) - (730/2))+',resizable=No',"");
        hwin.focus();
    }
    
    function DeleteFiles(session)
       {
           WarehouseMgmt_ReceiveReport.DeleteExcel('ReceiveReport'+session).value
            parent.window.close();
           
       }
    </script>

</head>
<body scroll=no onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" colspan="2">
                    <uc1:Header ID="ucHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead"  style="height: 30px">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="40%" >
                                            Warehouse Receiving Report
                                        </td>
                                        <td  style="padding-right: 5px;" align="right" width="60%">
                                            <table border="0" cellpadding="3" cellspacing="0" >
                                                <tr>
                                                    <td >
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/WarehouseMgmt/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td >
                                                        <img style="cursor: hand ;vertical-align:bottom;" src="../common/images/Print.gif" id="btnPrint" onclick="javascript:PrintReport();" />
                                                    </td>
                                                    <td >
                                                        <img align="right" src="Common/Images/help.gif" style="cursor: hand;" />
                                                    </td>
                                                    <td>
                                                        <img align="right" src="Common/Images/Close.gif" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            style="cursor: hand; padding-right: 2px;" />
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
            <tr id="trHead" class="PageBg">
                <td class="LeftPadding TabHead" style="height: 10px" colspan="2" id="PrintDG1">
                    <asp:UpdatePanel ID="pnlBranch" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <table border="0" cellpadding="0" cellspacing="0" width=100%>
                                <tr>
                                    <td colspan="2" style="width: 40px">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                        <asp:Label ID="Label1" CssClass="TabHead" runat="server" Text="Whse:" Width="40px" Height="20px"></asp:Label></td>
                                                <td>
                                        <asp:Label ID="lblWhse" CssClass="TabHead" runat="server" Width="120px" Height="20px"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 50px">
                                        </td>
                                    <td colspan="2">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 100px">
                                        <asp:Label ID="Label4" CssClass="TabHead" runat="server" Text="Bill of Lading Number:" Width="120px" Height="20px"></asp:Label></td>
                                                <td style="width: 100px">
                                        <asp:Label ID="lblBOLNo" CssClass="TabHead" runat="server" Width="60px" Height="20px"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 170px">
                                    </td>
                                  
                                    <td>
                                        <asp:Label ID="Label2" CssClass="TabHead" runat="server" Text="Run By:" Width="45px" Height="20px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblRunBy" CssClass="TabHead" runat="server" Width="70px" Height="20px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label5" CssClass="TabHead" runat="server" Text="Run Date:" Width="55px" Height="20px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblRunDate" CssClass="TabHead" runat="server" Width="60px" Height="20px"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label3" CssClass="TabHead" runat="server" Text="Container Number:" Width="105px" Height="20px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblContainerNo" CssClass="TabHead" runat="server" Width="130px" Height="20px"></asp:Label></td>
                                    <td>
                                    </td>
                                    <td>
                                        </td>
                                    <td><table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 100px">
                                        <asp:Label ID="Label6" CssClass="TabHead" runat="server" Text="Document Number:" Width="110px" Height="20px"></asp:Label></td>
                                                <td style="width: 100px">
                                        <asp:Label ID="lblDocumentNo" CssClass="TabHead" runat="server" Width="60px" Height="20px"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 480px; width: 958px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" PageSize="17"
                                    Width="950px" ID="gvReport" runat="server" AllowPaging="false" ShowHeader="true"
                                    ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false" OnSorting="gvReport_Sorting">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                        Height="19px" HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:BoundField HeaderText="License Plate #" DataField="LPN" SortExpression="LPN"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="140px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle HorizontalAlign="center" Width="140px" />
                                        </asp:BoundField>
                                         <asp:BoundField HeaderText="Container #" DataField="ContainerNo" SortExpression="ContainerNo" 
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="150px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle HorizontalAlign="center" Width="150px" />
                                        </asp:BoundField>
                                         <asp:BoundField HeaderText="Bill of Padding #" DataField="BolNo" SortExpression="BolNo"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="110px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle HorizontalAlign="center" Width="110px" />
                                        </asp:BoundField>
                                         <asp:BoundField HeaderText="Document #" DataField="DocumentNo" SortExpression="DocumentNo"
                                            ItemStyle-CssClass="Left5pxPadd">
                                            <ItemStyle HorizontalAlign="Left" Width="120px" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle HorizontalAlign="center" Width="120px" />
                                        </asp:BoundField>
                                        
                                        <asp:BoundField HtmlEncode="false" HeaderText="WHSE" DataField="WHSE" SortExpression="WHSE">
                                            <ItemStyle HorizontalAlign="Center" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="ItemNo" HeaderText="ItemNo" SortExpression="ItemNo">
                                            <ItemStyle HorizontalAlign="Left" Width="120px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Left" Width="120px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="QtyUOM" HeaderText="Qty/UOM" SortExpression="QtyUOM">
                                            <ItemStyle HorizontalAlign="Left" Width="60px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="" HeaderText="Qty Rcvd">
                                            <ItemStyle HorizontalAlign="Center" Width="70px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="BinLoc" HeaderText="Bin Location" SortExpression="BinLoc">
                                            <ItemStyle HorizontalAlign="Center" Width="100px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="true" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField HtmlEncode="false" DataField="LPNDate" HeaderText="LPNDate" SortExpression="LPNDate"
                                            DataFormatString="{0:MM/dd/yyyy}">
                                            <ItemStyle HorizontalAlign="Left" Width="100px" Wrap="False" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle Wrap="False" HorizontalAlign="Center" />
                                        </asp:BoundField>
                                    </Columns>
                                </asp:GridView>
                                <div align="center">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                        Visible="False"></asp:Label></div>
                                <input type="hidden" runat="server" id="hidSortExpression" />
                                <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" />
                                <input type="hidden" runat="server" id="hidSort" />
                            </div>
                            <%--<div id="divPager" runat="server">
                                <uc3:pager ID="dvPager" runat="server" />
                            </div>--%>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="BluBg buttonBar" colspan="2" height="20px" style="border-top: solid 1px #DAEEEF">
                    <table cellpadding="0" cellspacing="0" style="padding-top: 1px;">
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                            <td>
                                <asp:HiddenField runat=server ID="hidFileName" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="border-top: #daeeef 1px solid">
                    <uc2:Footer ID="Footer1" runat="server" Title="Warehouse Receiving Report" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

<script>
 function PrintReport()
{
     var prtContent = "<html><head><link href='common/StyleSheet/styles.css' rel='stylesheet' type='text/css' /></head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:450px;'colspan=3><h3>Warehouse Receive Report </h3></td></tr>";
     prtContent = prtContent +"</table><br>"; 
     prtContent = prtContent + document.getElementById('PrintDG1').innerHTML;    
     prtContent = prtContent + document.getElementById('div-datagrid').innerHTML;     
     prtContent = prtContent + "</body></html>";
     var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
     prtContent = prtContent.replace(/BORDER-COLLAPSE: collapse;/i,"border-collapse:separate;");
     prtContent = prtContent.replace(/BORDER-LEFT: #c9c6c6 1px solid;/i,"BORDER-LEFT: #c9c6c6 0px solid;");
     prtContent = prtContent.replace(/BORDER-RIGHT: #c9c6c6 1px solid;/i,"BORDER-RIGHT: #c9c6c6 0px solid;");
     prtContent = prtContent.replace(/BORDER-TOP: #c9c6c6 1px solid;/i,"BORDER-TOP: #c9c6c6 0px solid;");
     prtContent = prtContent.replace(/BORDER-BOTTOM: #c9c6c6 1px solid;/i,"BORDER-BOTTOM: #c9c6c6 0px solid;");
     WinPrint.document.write(prtContent);
     WinPrint.document.close();
     WinPrint.focus();
     WinPrint.print();
     WinPrint.close();     
}
 function print_header() 
{ 
    var table = document.getElementById("gvReport"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
}  
</script>