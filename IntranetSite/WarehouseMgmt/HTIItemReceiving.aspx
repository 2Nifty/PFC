<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HTIItemReceiving.aspx.cs" Inherits="WarehouseMgmt_HTIItemReceiving" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>

<%@ Register Src="~/WarehouseMgmt/Common/UserControl/Header.ascx" TagName="Header"
    TagPrefix="uc1" %>
<%@ Register Src="~/WarehouseMgmt/Common/UserControl/Footer.ascx" TagName="Footer"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HTI Unreceived Product</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    function PrintReport(url)
    {
         
        var hwin=window.open('ReceiveReportPreview.aspx?'+url, 'ReceiveReportPreview', 'height=625,width=730,scrollbars=yes,status=no,top='+((screen.height/2) - (625/2))+',left='+((screen.width/2) - (730/2))+',resizable=No',"");
        hwin.focus();
    }
    
    function DeleteFiles(session)
    {
       WarehouseMgmt_HTIItemReceiving.DeleteExcel('HTIUnReceivedItemsReport'+session).value
        parent.window.close();
       
    }
    
    var strCtrlPrefix="gvReport_ctl0";
    var strCtrlSuffix="_chkSelect";
    function SelectAll(chkState)
    {
              
        var SelectAll=document.getElementById("gvReport_ctl01_chkSelectAll");        
        SelectAll.parentElement.title=((chkState)?"Clear All":"Check All");
        
        for(var i=2;;i++)
        {
            if (i > 9)
              strCtrlPrefix="gvReport_ctl";
            else
              strCtrlPrefix="gvReport_ctl0";
              
            
            // Get the form Control
            var checkCtrl=document.getElementById(strCtrlPrefix+i+strCtrlSuffix);
            
            // Check or uncheck the checkbox in the datagrid
            if(checkCtrl == null || checkCtrl == 'undefined') 
                break;
            else
            {
                checkCtrl.checked=chkState;
                var result = SaveItemToSession(checkCtrl.id);                
            }
              
        }
    }
    
    function SaveItemToSession(checkBoxId)
    {
         var _checkBox  = document.getElementById(checkBoxId);
         var _hidBinLabel = document.getElementById(checkBoxId.replace("_chkSelect","_hidBinLabel")); 
         var _hidLocId = document.getElementById(checkBoxId.replace("_chkSelect","_hidLocId")); 
         
         WarehouseMgmt_HTIItemReceiving.StoreItemInSession(  _checkBox.checked, 
                                            _hidBinLabel.value,
                                            _hidLocId.value); 
                                            
        return true;        
         
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
                                            HTI Unreceived Items</td>
                                        <td  style="padding-right: 5px;" align="right" width="60%">
                                            <table border="0" cellpadding="3" cellspacing="0" >
                                                <tr>
                                                    <td >
                                                        <asp:ImageButton runat="server" ID="ibtnComplete" ImageUrl="~/Common/Images/MarkAsComp.gif"
                                                            ImageAlign="middle" OnClick="ibtnComplete_Click" /></td>
                                                    <td >
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/WarehouseMgmt/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" /></td>
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
            <tr>
                <td align="left" valign="top">
                    <asp:UpdatePanel ID="upnlGrid" UpdateMode="conditional" runat="server">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; height: 540px; width: 958px; border: 0px solid;">
                                <asp:GridView UseAccessibleHeader="true" PagerSettings-Visible="false" PageSize="17" 
                                    Width="350px" ID="gvReport" runat="server" AllowPaging="true" ShowHeader="true"
                                    ShowFooter="true" AllowSorting="true" AutoGenerateColumns="false" OnSorting="gvReport_Sorting">
                                    <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <RowStyle CssClass="Left5pxPadd GridItem " BackColor="White" BorderColor="White"
                                        Height="19px" HorizontalAlign="Left" />
                                    <AlternatingRowStyle CssClass="Left5pxPadd GridItem " BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="19px"
                                        HorizontalAlign="Center" />
                                    <EmptyDataRowStyle VerticalAlign="Top" BorderWidth="0px" CssClass="GridHead" BackColor="#DFF3F9"
                                        HorizontalAlign="Center" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Select">
                                            <HeaderTemplate>
                                                <asp:CheckBox ID="chkSelectAll" ToolTip="Click to select all bins" onclick="Javascript:SelectAll(this.checked);"
                                                    runat="server"></asp:CheckBox></HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" onclick="javascript:SaveItemToSession(this.id);"
                                                    runat="server" />
                                                <asp:HiddenField ID="hidBinLabel" runat=server Value='<%# DataBinder.Eval(Container,"DataItem.BinLabel") %>' />
                                                <asp:HiddenField ID="hidLocId" runat=server Value='<%# DataBinder.Eval(Container,"DataItem.Location") %>' />
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" Width="30px" />
                                            <HeaderStyle HorizontalAlign="Center" Width="30px" />
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="Bin Label" DataField="BinLabel" SortExpression="BinLabel">
                                            <ItemStyle HorizontalAlign="Left" Width="140px" CssClass="Left5pxPadd" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle HorizontalAlign="Center" Width="140px" />
                                        </asp:BoundField>
                                         <asp:BoundField HeaderText="Loc Name" DataField="LocDesc" SortExpression="LocDesc">
                                            <ItemStyle HorizontalAlign="Left" Width="150px" CssClass="Left5pxPadd" />
                                            <FooterStyle HorizontalAlign="Left" />
                                            <HeaderStyle HorizontalAlign="Center" Width="150px" />
                                        </asp:BoundField>                                         
                                    </Columns>
                                    <PagerSettings Visible="False" />
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
                <td align="left" valign="top">
                    <uc3:pager ID="gridPager" runat="server" OnBubbleClick="Pager_PageChanged"  />
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
                            <td>
                                                        </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="border-top: #daeeef 1px solid">
                    <uc2:Footer ID="Footer1" runat="server" Title="HTI Unreceived Product" />
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