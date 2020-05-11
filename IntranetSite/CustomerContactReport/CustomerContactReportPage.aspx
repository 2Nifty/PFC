<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerContactReportPage.aspx.cs"
    Inherits="CustomerContactReportPage" %>


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
        function PrintReport()
        {
            var hwnd,Url;
            
    Url =   "CustomerContactReportPreview.aspx?CustomerType=" + '<%= (Request.QueryString["CustomerType"] != null) ? Request.QueryString["CustomerType"].ToString().Trim() : "" %>' +
            "&Branch=" + '<%= (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "" %>' + 
            "&ContactType=" + '<%= (Request.QueryString["ContactType"] != null) ? Request.QueryString["ContactType"].ToString().Trim() : "" %>' +
            "&BuyingGroup="+ '<%= (Request.QueryString["BuyingGroup"] != null) ? Request.QueryString["BuyingGroup"].ToString().Trim() : "" %>' +
            "&BGName="+ document.getElementById("lblbuyingGrp").innerText +
            "&CustName="+ document.getElementById("lblCustomer").innerText +
            "&ContName="+ document.getElementById("lblContact").innerText +
            "&BrnName="+ document.getElementById("lblBranch").innerText +
            "&FilterDt="+ document.getElementById("lblFilterDt").innerText +
            "&Sort="+document.getElementById("hidSort").value;
            
          
            hwnd=window.open(Url,"CCReportPrint" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();
         
        }
         // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles(session)
       {
            var str=CustomerContactReportPage.DeleteExcel('CustomerContactReport '+session).value.toString();
            window.close();
       }
       function BindValue(sortExpression)
       {
            if(document.getElementById("hidSortExpression") !=null)
                document.getElementById("hidSortExpression").value= sortExpression;
            document.getElementById("btnSort").click();
       }
</script>     
</head>
<body>
    <form id="form1" runat="server">  
     <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top" colspan="2">
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top" colspan="2">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="PageHead" colspan="4" style="height: 40px">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                    <tr>
                                        <td class="Left5pxPadd BannerText" width="70%">
                                            Customer Contact Report
                                        </td>
                                        <td align="right" style="width: 30%; padding-right: 5px;">
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton runat="server" ID="ibtnExcelExport" ImageUrl="~/Common/Images/ExporttoExcel.gif"
                                                            ImageAlign="middle" OnClick="ibtnExcelExport_Click" />
                                                    </td>
                                                    <td>
                                                        <img style="cursor: hand" src="../common/images/Print.gif" id="btnPrint" onclick="javascript:PrintReport();" /></td>
                                                    <td>
                                                        <img align="right" onclick="Javascript:DeleteFiles('<%=Session["SessionID"].ToString() %>');"
                                                            src="Common/Images/Close.gif" style="cursor: hand; padding-right: 2px;" /></td>
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
                <td align=left>
                    <table cellpadding="1" cellspacing="0" width="100%">
                        <tr style="font-weight:bold;">
                            <td width="175px" align="right">
                                <asp:Label ID="lbl1" runat="server" Text="Branch :"></asp:Label></td>
                            <td width="175px" align="left">
                                <asp:Label ID="lblBranch" runat="server" Text=" "></asp:Label></td>
                            <td width="175px" align="right">
                                <asp:Label ID="lbl3" runat="server" Text="Contact Type:"></asp:Label></td>
                            <td width="175px" align="left">
                                <asp:Label ID="lblContact" runat="server" Text=" "></asp:Label></td>
                            <td width="175px" align="right">
                                <asp:Label ID="lbl2" runat="server" Text="Customer Type:"></asp:Label></td>
                            <td width="175px" align="left">
                                <asp:Label ID="lblCustomer" runat="server" Text=" "></asp:Label></td>
                            <td width="175px" align="right">
                                <asp:Label ID="lbl4" runat="server" Text="Buying Group:"></asp:Label></td>
                            <td width="175px" align="left">
                                <asp:Label ID="lblbuyingGrp" runat="server" Text=" "></asp:Label></td>
                            <td align="left" width="100">
                                <asp:Label ID="Label1" runat="server" Text="Filter Date:"></asp:Label></td>
                            <td align="left" width="100">
                                <asp:Label ID="lblFilterDt" runat="server" Text=" "></asp:Label>
                            </td>
                            <td width="*">
                                &nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="pnlDatagrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <div class="Sbar" id="div-datagrid" style="overflow-x: auto; overflow-y: auto; position: relative;
                                top: 0px; left: 0px; width: 1020px; height: 515px; border: 0px solid;">
                                <div id="PrintDG2">
                                    <asp:DataGrid ID="dgReport" UseAccessibleHeader=true Width="1640" runat="server" GridLines="both" BorderWidth="1px"  PageSize="19"
                                        ShowFooter="false" AllowSorting="true" AutoGenerateColumns="false" BorderColor="#DAEEEF"
                                        AllowPaging="true" PagerStyle-Visible="false" OnItemDataBound="dgReport_ItemDataBound" OnPageIndexChanged="dgReport_PageIndexChanged"
                                        OnSortCommand="dgReport_SortCommand">
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
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" DataField="Business Fax"
                                                SortExpression="Business Fax" ItemStyle-Wrap="false" ItemStyle-Width="100" HeaderStyle-Wrap="false">
                                            </asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" DataField="Business Phone"
                                                SortExpression="Business Phone" ItemStyle-Wrap="false" ItemStyle-Width="100"
                                                HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="Mobile Phone"
                                                DataField="Mobile Phone" SortExpression="Mobile Phone" ItemStyle-Wrap="false"
                                                ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="150" ItemStyle-HorizontalAlign="left" HeaderText="E-Mail Address"
                                                FooterStyle-HorizontalAlign="right" DataField="E-Mail Address" SortExpression="E-Mail Address"
                                                ItemStyle-Wrap="false" ItemStyle-Width="150" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="100" ItemStyle-HorizontalAlign="left" HeaderText="Buying Group"
                                                FooterStyle-HorizontalAlign="right" DataField="Buying Group" SortExpression="Buying Group"
                                                ItemStyle-Wrap="false" ItemStyle-Width="100" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="120" ItemStyle-HorizontalAlign="left" HeaderText="Customer Type"
                                                DataField="Customer Type" SortExpression="Customer Type" ItemStyle-Wrap="false"
                                                ItemStyle-Width="120" HeaderStyle-Wrap="false"></asp:BoundColumn>
                                            <asp:BoundColumn HeaderStyle-Width="120" ItemStyle-HorizontalAlign="left" HeaderText="Contact Type"
                                                DataField="Contact Type" SortExpression="Contact Type" ItemStyle-Wrap="false"
                                                ItemStyle-Width="120" HeaderStyle-Wrap="false"></asp:BoundColumn>
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
                            <uc3:pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged" />
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
    </form>
</body>
</html>
