<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BranchInventoryOnHandPreview.aspx.cs"
    Inherits="PFC.Intranet.ITotalReports.BranchInventoryOnHandPreview" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc4" %>
  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head id="Head1" runat="server">
    <title>Branch Inventory On Hand - Preview</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
   <link href="../ITotal/Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
</head>
<body onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';"
    onload="javascript:print_header()">
    <form id="form1" runat="server">
        <table border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top" colspan="2">
                    <uc4:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top" colspan="2" style="height: 30px">
                    <table  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="100%" valign="top" colspan="2" style="height: 100%">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" colspan="4" style="height: 30px">
                                            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                <tr>
                                                    <td style="height: 30px" width="75%">
                                                        <div class="Left5pxPadd">
                                                            <span class="BannerText">Branch Inventory On Hand</span>
                                                        </div>
                                                    </td>
                                                    <td align="right">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="125">
                                                            <tr>
                                                                <td style="padding-right: 3px;">
                                                                    <img style="cursor: hand" src="../common/images/Print.gif" id="btnPrint" onclick="javascript:PrintReport();" /></td>
                                                                <td style="padding-right: 5px;">
                                                                    <img style="cursor: hand" src="../common/images/Close.gif" id="Img1" onclick="javascript:window.close();" /></td>
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
                            <td class="PageBg" style="height: 25px" id="PrintDG1">
                                    <table width="100%" border=0px cellpadding=0px cellspacing=0px>
                                        <tr>
                                            <td style="width: 60px">
                                                <span class="TabHead">Period :</span>
                                            </td>
                                            <td style="width: 280px">
                                                <span class="TabHead">
                                                    <%=Request.QueryString["Period"]%>
                                                </span>
                                            </td>
                                            <td style="width: 60px">
                                                <span class="TabHead">PkType :</span>
                                            </td>
                                            <td style="width: 280px">
                                                <span class="TabHead">
                                                    <%=Request.QueryString["PkgType"]%>
                                                </span>
                                            </td>
                                            <td style="width: 50px">
                                                
                                            </td>
                                            <td style="width: 50px">
                                                <span class="TabHead">
                                                  
                                                </span>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td align="right" width=150px style="padding-right: 20px;">
                                                <span class="TabHead">Run By :
                                                    <%=Session["UserName"]%>
                                                </span>
                                            </td>
                                            <td align="right" width=150px style="padding-right: 20px;">
                                                <span class="TabHead">Run Date :
                                                    <%=DateTime.Now.ToShortDateString()%>
                                                </span>
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                    </table>
                            </td>
                        </tr>
                        <tr>
                            <td  height="500px"  valign=top>
                                <div id="PrintDG2"  class="Sbar" style="overflow-x: scroll; overflow-y: auto; position: relative;
                                    top: 0px; left: 0px; height: 498px;width:915px; border: 0px solid;">                                
                                          <asp:GridView PagerSettings-Visible="false" OnRowDataBound="dvBIOnhand_RowDataBound" ID="dvBIOnhand"
                            runat="server" AllowPaging="false" ShowHeader="true" ShowFooter="true"  AllowSorting="false"  AutoGenerateColumns="false" >
                            <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                HorizontalAlign="Center" />
                            <RowStyle CssClass=" GridItem Left5pxPadd" BackColor="White" BorderColor="White" Height="20px"
                                HorizontalAlign="Left" />
                            <AlternatingRowStyle CssClass=" GridItem Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                HorizontalAlign="Left" />
                            <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                HorizontalAlign="Center" />
                             <EmptyDataRowStyle VerticalAlign="top" BorderWidth="0" CssClass="GridHead" BackColor="#DFF3F9"  
                                HorizontalAlign="Center" />
                            <Columns>
                                <asp:BoundField  HeaderText="Branch" DataField="BranchDesc" ItemStyle-CssClass="Left5pxPadd">
                                    <ItemStyle HorizontalAlign="Left" Width="150px"  />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle HorizontalAlign="center" Width="150px" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Qty" HtmlEncode="false" DataField="Qty" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="$ @ Avg Cost" HtmlEncode="false" DataField="DolAtAvgCost" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right"  Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="Weight" HtmlEncode="false" DataField="Weight" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="$/Lb" HtmlEncode="false" DataField="DolPerLb" DataFormatString="{0:#,##0.000}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>
                                   <asp:BoundField HeaderText="Branch $/Lb" HtmlEncode="false" DataField="" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:BoundField HeaderText="OTW $/Lb" HtmlEncode="false" DataField="" DataFormatString="{0:#,##0.0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="ThirtyDayUsageQty" DataFormatString="{0:#,##0.0}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="ThirtyDayUseQtyDolPerAvg" DataFormatString="{0:#,##0}">
                                    <ItemStyle HorizontalAlign="Right" Width="50px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>
                                <asp:BoundField HtmlEncode="false" DataField="ThirtyDayUseWgt" DataFormatString="{0:#,##0}" SortExpression="ThirtyDayUseWgt">
                                            <ItemStyle HorizontalAlign="Right" Width="50px" />
                                            <FooterStyle HorizontalAlign="Right" />
                                        </asp:BoundField> 
                                <asp:BoundField  HeaderText="Months On-Hand" HtmlEncode="false" DataField="MOH" DataFormatString="{0:#,##0.0}">
                                    <ItemStyle HorizontalAlign="Right" Width="70px" Wrap="False" />
                                    <FooterStyle HorizontalAlign="Right" />
                                    <HeaderStyle Wrap="False" HorizontalAlign="center" />
                                </asp:BoundField>                 
                            </Columns>
                      
                        </asp:GridView>
                                    <center>
                                        <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                            Visible="False"></asp:Label></center>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%" cellpadding="0" cellspacing="0" class="BluBg">
                                    <tr>
                                        <td width="50%" align="left">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <uc5:Footer ID="Footer1" Title="PFC I Total Report" runat="server" />
                            </td>
                        </tr>
                    </table>
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
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:450px;'colspan=3><h3>Branch Inventory On Hand</h3></td></tr>";
     prtContent = prtContent +"</table><br>"; 
      prtContent = prtContent + document.getElementById('PrintDG1').innerHTML;    
     prtContent = prtContent + document.getElementById('PrintDG2').innerHTML;     
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
    var table = document.getElementById("dvBIOnhand"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
}  
</script>

