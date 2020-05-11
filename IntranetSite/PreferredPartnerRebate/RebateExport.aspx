<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RebateExport.aspx.cs" Inherits="RebateExport" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/PreferredPartnerRebate/Common/UserControls/MinFooter.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Rebate </title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script>
    
     function GetCustName()
    {
    var name=document.getElementById("ddlChainCust").value;
    
    document.getElementById("lblCustName").innerText =name;
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr class="lightBlueBg" style="padding-top: 1px;">
                <td id="tdHeader" style="padding-top: 1px; width: 1253px;">
                    <uc1:Header ID="Header1" runat="server"></uc1:Header>
                </td>
            </tr>
            <tr>
                <td align="right" class="PageHead">
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
            <tr>
                <td style="padding-top: 1px;" id="PrintDG1">
                    <asp:Panel ID="Panel1" runat="server">
                        <table style="width: 100%" class="blueBorder lightBlueBg" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <asp:UpdatePanel ID="upnlEntry" runat="server" UpdateMode="conditional">
                                        <ContentTemplate>
                                            <table   >
                                                <tr>
                                                    <td class="Left2pxPadd " style="padding-left: 30px" colspan="3">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px" width=100px>
                                                        <asp:Label ID="Label1" runat="server" Height="16px" Text="Program Name:" Width="90px" Font-Bold="true" ></asp:Label>
                                                    </td>
                                                    <td style="width: 300px; padding-left :-10px" colspan="2" class="Left2pxPadd DarkBluTxt boldText" >
                                                        <asp:Label ID="lblProgram" runat="server" Height="16px" Width="400px" ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                        <asp:Label ID="Label2" runat="server" Height="16px" Width="90px" Text="Chain/Cust#:" Font-Bold="true"></asp:Label>
                                                    </td>
                                                    <td style="width: 100px; height: 26px;padding-left:-20px" class="Left2pxPadd DarkBluTxt boldText" >
                                                        <asp:Label ID="lblChainCustNo" runat="server" Height="16px" Width="100px"></asp:Label>
                                                    </td>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                         <asp:Label ID="Label3" runat="server" Height="16px" Width="50px" Text="Name:" Font-Bold ="true"  ></asp:Label>
                                                        <asp:Label ID="lblCustName" runat="server" Height="16px" Width="250px" ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;">
                                                        <asp:Label ID="Label4" runat="server" Height="16px" Text="Start Date:" Width="100px" Font-Bold="true"></asp:Label>
                                                    </td>
                                                    <td style="width: 150px;" colspan="2" class="Left2pxPadd DarkBluTxt boldText" >
                                                        <asp:Label ID="lblStartDate" runat="server" Height="16px" Width="100px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="Left2pxPadd DarkBluTxt boldText" style="padding-left: 10px;" valign="top">
                                                        <asp:Label ID="Label5" runat="server" Height="16px" Text="End Date:" Width="111px" Font-Bold="true"></asp:Label>
                                                    </td>
                                                    <td style="width: 150px;" colspan="2" class="Left2pxPadd DarkBluTxt boldText" >
                                                        <asp:Label ID="lblEndDate" runat="server" Height="16px" Width="100px"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td id="PrintDG2">
                    <asp:UpdatePanel ID="upnlGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding-top: 1px; height: 7px;" colspan="2">
                                    <div id="div-datagrid" oncontextmenu="Javascript:return false;" class="Sbar" style="overflow-x: hidden;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 285px; width: 800px;
                                            border: 0px solid;" align="left">
                                        <asp:DataGrid UseAccessibleHeader="true" ID="gvRebate" Width="785px" runat="server"
                                            AllowPaging="false" ShowHeader="true" AllowSorting="false" AutoGenerateColumns="false"
                                            OnItemDataBound="gvRebate_ItemDataBound" ShowFooter="True">
                                            <HeaderStyle CssClass="GridHead" Wrap="false" BackColor="#DFF3F9" BorderColor="#DAEEEF"
                                                Height="20px" HorizontalAlign="Center" />
                                           <FooterStyle CssClass="lightBlueBg" Font-Bold="true" ForeColor="#003366" VerticalAlign="Middle"
                                                    HorizontalAlign="Right" />
                                            <ItemStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" Height="20px" BorderWidth="1px" />
                                            <AlternatingItemStyle CssClass="itemShade" BackColor="#ECF9FB" Height="20px" BorderWidth="1px" />
                                            <Columns>
                                                <asp:TemplateColumn HeaderText="Category" SortExpression="Category">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblCategory" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.Category") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="100px" />
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderText="Description" SortExpression="Description">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblDescription" runat="server" Text ='<%# DataBinder.Eval(Container,"DataItem.Description") %>' ></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="285px" />
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderText="History $" SortExpression="SalesHistory">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblHistory" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.SalesHistory","{0:#,##0.00}" ) %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="100px" HorizontalAlign ="Right"  />
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderText="BaseLine $">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblBaseLine" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.SalesBaseline","{0:#,##0.00}") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="100px" HorizontalAlign ="Right" />
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderText="Goal $">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblGoal" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.SalesGoal" ,"{0:#,##0.00}") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="100px" HorizontalAlign ="Right" />
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderText="Rebate %">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblRebate" runat="server" Text='<%# DataBinder.Eval(Container,"DataItem.RebatePct","{0:#,##0.00}" ) %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="100px" HorizontalAlign ="Right" />
                                                </asp:TemplateColumn>
                                            </Columns>
                                        </asp:DataGrid>
                                        <input type="hidden" id="hidSort" runat="server" tabindex="12" />
                                         </div>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
            <td style ="padding-left :10px">
             <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                                
            </td>
            </tr>
            <tr>
                <td style="width: 1253px">
                    <uc2:Footer ID="Footer1" runat="server" Title="Preferred Partner Rebate" />
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
     prtContent=prtContent+"<table cellspacing=0 cellpadding=0 width='100%'><tr><td style='width:450px;'colspan=3><h3>Preferred Partner Rebate</h3></td></tr>";
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
     window.close();
}
 function print_header() 
{ 
    var table = document.getElementById("gvRebate"); // the id of your DataGrid
    var str = table.outerHTML; 
    str = str.replace(/<TBODY>/g, ""); 
    str = str.replace(/<TR/g, "<THEAD style='display:table-header-group;'><TR"); 
    str = str.replace(/<\/TR>/g, "</TR></THEAD><TBODY>"); 
    table.outerHTML = str; 
}  
</script>

