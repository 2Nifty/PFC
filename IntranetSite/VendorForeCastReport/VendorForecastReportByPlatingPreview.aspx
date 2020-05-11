
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VendorForecastReportByPlatingPreview.aspx.cs"
    Inherits="CustomerSalesAnalysis" %>

<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Vendor Forecast Report Print Preview</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
    function PrintReport()
    {
        var printStyle = "<style type='text/css' media='print,screen'>";
        printStyle += "th { font-family:Arial;color:black;background-color:lightgrey;}";
        printStyle += "thead { display:table-header-group;}";
        printStyle += "tbody {display:table-row-group;}";
        printStyle += "</style>";
        
        var prtContent = "<html><head><link href=StyleSheet/ReportStyles.css rel=stylesheet type=text/css />"+ printStyle+"</head><body >"
        var WinPrint = window.open('','','letf=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0')
        
        prtContent = prtContent + document.getElementById("PrintDG1").innerHTML +"<table border='0'>" + document.getElementById("dgCategory").innerHTML + "</table>";
        prtContent = prtContent + "</body></html>";
        
        WinPrint.document.write(prtContent);
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();
        
        return false;
    }
    function print_header() 
    { 
        var CategoryGridName = document.getElementById("hidGridNames").value.split(',');            
        for (var i=0;i<= document.getElementById("hidGridNames").value.split(',').length - 1;i++)
        {
            var table = document.getElementById(CategoryGridName[i]); // the id of your DataGrid
            var str = table.outerHTML; 
            str = str.replace(/<TBODY>/i, ""); 
            str = str.replace(/<TR/i, "<THEAD style='display:table-header-group;'><TR"); 
            str = str.replace(/<\/TR>/i, "</TR></THEAD><TBODY>"); 
            table.outerHTML = str; 
        }
    } 
    
    </script>
</head>
<body bottommargin="0" onload="javascript:print_header()">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" runat="server" id="BodyTable">
            <tr>
                <td colspan="2">
                    <table width="100%"  style="height: 590px" border="0" cellspacing="0" cellpadding="0">
                        
                        <tr>
                            <td colspan="2" valign="middle" class="PageHead">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                                    <tr>
                                        <td valign=middle><div align="left" class="LeftPadding"></div>
                                            </td>                                              
                                        <td valign=middle  align="right">
                                            <img style="cursor:hand;" src="../common/images/print.gif" onclick="PrintReport()" />
                                            <img style="cursor:hand" src="../common/images/close.gif" onclick="javascript:window.parent.close();" id="imgClose"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                        <div id="PrintDG1">
                                        <table border=0px cellpadding=0px cellspacing=0px width=100%>
                                        <tr>
                                        <td><div align=left style="font-size: 16px;font-weight: bold;color: #3A3A56;">Vendor Forecast Report</div> </td>
                                        <td align=right valign=bottom style="padding-right:5px">
                                        <TABLE cellSpacing=0 cellPadding=2 border=0><TBODY>
                                        <TR>
                                        <TD><asp:Label id="Label2" runat="server" Text="Run Date :" CssClass="TabHead"></asp:Label></TD>
                                        <TD><asp:Label id="lblRunDate" runat="server" CssClass="TabHead"></asp:Label></TD>                                        
                                        </TR>
                                             <tr>
                                                <td align=left>
                                                    <asp:Label ID="lblMultiplierCaption" runat="server" CssClass="TabHead" Text="Report #"></asp:Label></td>
                                                <td  align=left>
                                                    <asp:Label ID="lblMultiplier" runat="server" CssClass="TabHead"></asp:Label></td>
                                            </tr>
                                        </TBODY></TABLE>
                                        </td>
                                        </tr>
                                        </table>
                                        </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="left" class="PageBg">
                            </td>
                        </tr>
                        <tr>
                            <td align="center" bgcolor="#EFF9FC" colspan="2">
                                <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                    Visible="False"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="BluBordAll" width="100%" border="0" cellspacing="0" cellpadding="0" >
                                    <tr>
                                        <td valign="top" width="100%" >
                                            <div class="Sbar" id="divdatagrid" style="overflow: auto; position: relative; top: 0px; left: 0px;
                                                width: 760px; height: 630px; border: 0px solid;">
                                                <asp:DataGrid ShowFooter="True" PageSize="1" BorderWidth=0px ShowHeader=False PagerStyle-Visible=true  ID=dgCategory  AllowPaging=False AutoGenerateColumns=False  runat=server OnItemDataBound="dgCategory_ItemDataBound1" OnPageIndexChanged="dgCategory_PageIndexChanged" BorderStyle="None" GridLines="None" >
                                                <Columns>
                                                    <asp:TemplateColumn>
                                                        <ItemTemplate >
                                                            <table cellpadding="0" border="0" cellspacing=0 width=100%>
                                                                <tr bgcolor="#f4fbfd"><td colspan=2 height=5></td></tr>
                                                                <tr bgcolor="#f4fbfd">
                                                                    <td width=2% class=TabHead height=18>Category :&nbsp;</td>
                                                                    <td class="normaltxt" style="width: 98%">
                                                                        <asp:Label ID="lblCategory" runat=server Text='<%#DataBinder.Eval(Container,"DataItem.Category")%>'></asp:Label>&nbsp;&nbsp;<asp:Label ID="Label1" runat=server Text='<%#DataBinder.Eval(Container,"DataItem.CategoryDesc")%>'></asp:Label>
                                                                        <asp:HiddenField ID="hidForeCastUSG" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ForeCastUSG")%>' />
                                                                        <asp:HiddenField ID="hidUSGUOM" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.USGUOM")%>' />
                                                                        <asp:HiddenField ID="hidUSGLBS" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.USGLBS")%>' />
                                                                        <asp:HiddenField ID="hidUSGKGS" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.USGKGS")%>' />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">   
                                                                    <asp:DataGrid border="1" ShowFooter="True" BorderWidth=1px AllowPaging=false ID=dgCategoryDetail Width=100%  AutoGenerateColumns=False  runat=server OnPageIndexChanged="dgCategory_PageIndexChanged" OnItemDataBound="dgCategoryDetail_ItemDataBound" BorderStyle="None" GridLines="None" >
                                                                    <HeaderStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                                    <ItemStyle CssClass="GridItem" BorderStyle=Solid Wrap=False BackColor="#F4FBFD" />
                                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" BackColor="#DFF3F9" />
                                                                    <AlternatingItemStyle CssClass="GridItem"  BackColor="White" />                                            
                                                                        <Columns>
                                                                            <asp:BoundColumn HeaderText="Item #"  DataField="Itemno"  SortExpression="Itemno">
                                                                                <ItemStyle CssClass="GridItem" Width="125px" HorizontalAlign="left" />
                                                                                <FooterStyle CssClass="GridHead" />
                                                                                <HeaderStyle CssClass="GridHead" HorizontalAlign="Center" Wrap="False" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="Size" DataField="Size" SortExpression="Size">
                                                                                <ItemStyle CssClass="GridItem" Width="100px" HorizontalAlign="Left" Wrap="False" />
                                                                                <FooterStyle CssClass="GridHead" />
                                                                                <HeaderStyle CssClass="GridHead" HorizontalAlign="Center" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="Category Description" DataField="CategoryDesc" SortExpression="CategoryDesc">
                                                                                <ItemStyle CssClass="GridItem" Width="140px" HorizontalAlign="Left" Wrap="False" />
                                                                                <FooterStyle CssClass="GridHead" />
                                                                                <HeaderStyle CssClass="GridHead" HorizontalAlign="Center" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="Plating" DataField="Plate" SortExpression="Plate">
                                                                                <ItemStyle CssClass="GridItem" Width="35px" HorizontalAlign="Left" Wrap="False" />
                                                                                <FooterStyle CssClass="GridHead" />
                                                                                <HeaderStyle CssClass="GridHead" HorizontalAlign="Center" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="Forecasted Usage" DataFormatString="{0:#,##0}" DataField="ForecastUsg" SortExpression="ForecastUsg">
                                                                                <ItemStyle CssClass="GridItem" Width="60px" HorizontalAlign="Right" Wrap="False" />
                                                                                <FooterStyle CssClass="GridHead" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="Usg Pieces" DataField="USGUOM" DataFormatString="{0:#,##0}" SortExpression="USGUOM">
                                                                                <ItemStyle CssClass="GridItem" width="60px" HorizontalAlign="Right" Wrap="False" />
                                                                                <FooterStyle CssClass="GridHead" />
                                                                                <HeaderStyle CssClass="GridHead" HorizontalAlign="Left" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn HeaderText="Usg Pounds" DataField="USGLBS" DataFormatString="{0:#,##0}" SortExpression="USGLBS">
                                                                                <ItemStyle CssClass="GridItem" width="65px" HorizontalAlign="Right" Wrap="False" />
                                                                                <FooterStyle CssClass="GridHead" />
                                                                                <HeaderStyle CssClass="GridHead" HorizontalAlign="Left" />
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="USGKGS" HeaderText="Usg Kgs" DataFormatString="{0:#,##0}" SortExpression="USGKGS">
                                                                                <ItemStyle CssClass="GridItem" width="55px" HorizontalAlign="Right" Wrap="False" />
                                                                                <FooterStyle CssClass="GridHead" />
                                                                                <HeaderStyle CssClass="GridHead" HorizontalAlign="Left" />
                                                                            </asp:BoundColumn>                                                                                               
                                                                        </Columns>
                                                                    </asp:DataGrid>                                                                 
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="765px" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle ForeColor="#C00000" HorizontalAlign="Right" VerticalAlign="Middle" Mode="NumericPages" />
                                                </asp:DataGrid>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--<tr>
                            <td colspan="2">
                                <table width="100%" id="tblPager" runat="SERVER">
                                    <tr>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>--%>
                    </table>
                    <input type=hidden runat=server id=hidSort/>
                    <input type=hidden runat=server id=hidGridNames/>
                    <asp:HiddenField ID="hidReport" runat="server" />
                    <asp:HiddenField ID="hidVersion" runat="server"/>                    
                </td>
            </tr>
        </table>
    </form>
    <%--<script language="javascript">
    window.parent.document.getElementById("Progress").style.display='none';</script>--%>
</body>
</html>
