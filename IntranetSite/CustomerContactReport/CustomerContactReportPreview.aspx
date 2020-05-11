<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerContactReportPreview.aspx.cs"
    Inherits="CustomerContactReportPreview" %>


<%@ Register Src="~/Common/UserControls/pager.ascx" TagName="pager"  TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Contact Report</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
<script>
 //Javascript function to Show the preview page
       
</script>     
</head>
 <body onload="javascript:print_header()">
    <form id="form1" runat="server">  
     <div id="pagePrint">
     <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td class="Left5pxPadd BannerText" width="90%">
                                                <asp:Label Text="Customer Contact Report" Style="word-wrap: normal" ID="lblReportCap"
                                                    runat="server" Width="350px"></asp:Label>
                                            </td>
                                            <td valign="middle" align="right">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="right" width="70%" style="padding: 5px;">
                                                            <img onclick="javascript:PrintReport();" src="../Common/Images/Print.gif" style="cursor: hand"
                                                                id="IMG1" /></td>
                                                        <td align="left" width="30%">
                                                            <img src="../Common/Images/Close.gif" style="cursor: hand" onclick="javascript:window.close();" /></td>
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
                <td>
                    <table cellpadding="1" cellspacing="0" width="100%" border=0>
                        <tr style="font-weight:bold;">
                            <td width="50px" align="left">
                                <asp:Label CssClass="TabHead" ID="lbl1" runat="server" Text="Branch :"></asp:Label></td>
                            <td width="200" align="left">
                                <asp:Label  CssClass="TabHead" ID="lblBranch" runat="server" Text=""></asp:Label></td>
                            <td width="105px" align="right">
                                <asp:Label CssClass="TabHead"  ID="lbl3" runat="server" Text="Contact Type:" Width="80px"></asp:Label></td>
                            <td width="155px" align="left">
                                <asp:Label CssClass="TabHead"  ID="lblContact" runat="server" Text=""></asp:Label></td>
                            <td width="125px" align="right">
                                <asp:Label CssClass="TabHead"  ID="lbl2" runat="server" Text="Customer Type:" Width="100px"></asp:Label></td>
                            <td width="155px" align="left" >
                                <asp:Label CssClass="TabHead"  ID="lblCustomer" runat="server" Text=""></asp:Label></td>
                            <td width="105px" align="right">
                                <asp:Label CssClass="TabHead"  ID="lbl4" runat="server" Text="Buying Group:" Width="80px"></asp:Label></td>
                            <td width="155px" align="left">
                                <asp:Label CssClass="TabHead"  ID="lblbuyingGrp" runat="server" Text=""></asp:Label></td>
                            <td align="left" width="60">
                                <asp:Label ID="Label1" runat="server" CssClass="TabHead" Text="Filter Date:" Width="60px"></asp:Label></td>
                            <td align="left" width="155">
                                <asp:Label ID="lblFilterDt" runat="server" CssClass="TabHead"></asp:Label></td>
                            <td class="TabHead"  style="width: 130px">Run By :<%= Session["UserName"]%>
                            </td>
                            <td class="TabHead"  style="width: 170px">Run Date :<%=DateTime.Now.ToShortDateString()%></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td  >
                    <asp:UpdatePanel ID="pnlDatagrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; width: 1020px; height: 515px; border: 0px solid;">
                                <div id="PrintDG2">
                                    <asp:DataGrid ID="dgReport" UseAccessibleHeader=true Width="1250" runat="server" GridLines="both" BorderWidth="1px"  
                                        ShowFooter="false" AllowSorting="false" AutoGenerateColumns="false" BorderColor="#DAEEEF"
                                        AllowPaging="false" PagerStyle-Visible="false" OnItemDataBound="dgReport_ItemDataBound" >
                                        <HeaderStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                            HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridItem Left5pxPadd" BackColor="White" BorderColor="White"
                                            Height="20px" HorizontalAlign="Left" />
                                        <AlternatingItemStyle CssClass="GridItem Left5pxPadd" BackColor="#F4FBFD" BorderColor="#DAEEEF"
                                            HorizontalAlign="Left" />
                                        <FooterStyle CssClass="GridHead" BackColor="#DFF3F9" BorderColor="#DAEEEF" Height="20px"
                                            HorizontalAlign="Center" />
                                        <Columns>
                                            <asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="center" HeaderText="Branch #"
                                                DataField="Branch #" SortExpression="Branch #" ItemStyle-Wrap="false" ItemStyle-Width="50"
                                                HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="125" ItemStyle-HorizontalAlign="left" HeaderText="Name"
                                                DataField="Name" SortExpression="Name" ItemStyle-Wrap="false" ItemStyle-Width="125"
                                                HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="175" ItemStyle-HorizontalAlign="left" HeaderText="Company"
                                                DataField="Company" SortExpression="Company" ItemStyle-Wrap="false" ItemStyle-Width="175"
                                                HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderText="Cust #" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center"
                                                ItemStyle-HorizontalAlign="center" DataField="Cust #" SortExpression="Cust #"
                                                ItemStyle-Wrap="false" ItemStyle-Width="50" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="150" ItemStyle-HorizontalAlign="left" HeaderText="Job Title"
                                                FooterStyle-HorizontalAlign="right" DataField="Job Title" SortExpression="Job Title"
                                                ItemStyle-Wrap="false" ItemStyle-Width="150" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="left" DataField="Business Fax"
                                                SortExpression="Business Fax" ItemStyle-Wrap="false" ItemStyle-Width="80" HeaderStyle-Wrap="false">
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="80" ItemStyle-HorizontalAlign="left" DataField="Business Phone"
                                                SortExpression="Business Phone" ItemStyle-Wrap="false" ItemStyle-Width="80"
                                                HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="Mobile Phone"
                                                DataField="Mobile Phone" SortExpression="Mobile Phone" ItemStyle-Wrap="false"
                                                ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="E-Mail Address"
                                                FooterStyle-HorizontalAlign="right" DataField="E-Mail Address" SortExpression="E-Mail Address"
                                                ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="Buying Group"
                                                FooterStyle-HorizontalAlign="right" DataField="Buying Group" SortExpression="Buying Group"
                                                ItemStyle-Wrap="false" ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="Customer Type"
                                                DataField="Customer Type" SortExpression="Customer Type" ItemStyle-Wrap="false"
                                                ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="Contact Type"
                                                DataField="Contact Type" SortExpression="Contact Type" ItemStyle-Wrap="false"
                                                ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="300" ItemStyle-HorizontalAlign="left" HeaderText="Address"
                                                DataField="Address" SortExpression="Address"
                                                ItemStyle-Wrap="false" ItemStyle-Width="300" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="left" HeaderText="Allow Marketing"
                                                DataField="AllowMarketingEmailInd" SortExpression="AllowMarketingEmailInd"
                                                ItemStyle-Wrap="false" ItemStyle-Width="50" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="left" HeaderText="Contact #"
                                                DataField="ContactId" SortExpression="ContactId" ItemStyle-Wrap="false" ItemStyle-Width="50"
                                                HeaderStyle-Wrap="false"></asp:BoundColumn>
                                        </Columns>
                                    </asp:DataGrid>
                                    <center>
                                        <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"
                                            Visible="False"></asp:Label></center>
                                </div>
                            </div>
                            <asp:Button ID="btnSort" runat="server" Text="" Style="display: none;" OnClick="btnSort_Click" />
                            
                            <asp:HiddenField ID="hidFileName" Value="" runat="server" />
                            <input type="hidden" runat="server" id="hidSort" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFrame ID="BottomFrame1" runat="server" />
                    <input type="hidden" runat="server" id="hidSortExpression" />
                </td>
            </tr>
        </table>
        </div>
    </form>
</body>
</html>
<script>
 function PrintReport()
{
     var prtContent = "<html><head><link href='Common/StyleSheet/Styles.css' rel='stylesheet' type='text/css' /></head><body>"
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:350px;'colspan=3><h3>Customer Contact Report</h3></td></tr>";
     prtContent = prtContent +"</table><br>"; 
     prtContent = prtContent + document.getElementById('trHead').innerHTML;  
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
     window.close();
}
 function print_header() 
{ 
    var table = document.getElementById("dgReport"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
} 
</script>