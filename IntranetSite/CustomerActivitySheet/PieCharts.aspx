<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PieCharts.aspx.cs" Inherits="PFC.Intranet.CustomerActivity.PieCharts" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register TagPrefix="dotnet" Namespace="dotnetCHARTING" Assembly="dotnetCHARTING" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Pie Charts</title>
    <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
    <style>
        BODY.page {page-break-before: always}   
    </style>
</head>
<body scroll="yes" >
    <form id="form1" runat="server">
        <div id=SheetContainer~|>
            <table id="master" class=DashBoardBk width=100% style="page-break-after:always">
                <tr>
                <td valign=top>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="SheetHolder">
                  <tr>
                    <td valign=top>
                    <table border="0" width="100%" align="center" cellpadding="1" cellspacing="1" class="PageBorder">
                                <tr>
                                    <td colspan="2">
                                        <table width="100%" border="0" cellpadding="2" cellspacing="2" class="SheetHead">
                                            <tr>
                                                <td class="redhead">
                                                    Run Date:
                                                    <%=DateTime.Now.ToString() %>
                                                </td>
                                                <td class="redhead">
                                                    <div align="left">
                                                      C.A.S  &nbsp;PIE CHARTS YTD by PKG GROUP & ORDER TYPE</div>
                                                </td>
                                                <td class="redhead">
                                                    PAGE 2</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table style="width: 100%">
                                            <tr>
                                                <td >
                                                      <div align="left" class="BlackBold">
                                                        <strong>Customer # &nbsp;<%=Request.QueryString["CustNo"].Trim().Replace("||","&")%> &nbsp;&nbsp; <asp:Label ID="lblCustName" runat="server" CssClass="BlackBold"></asp:Label> </strong>
                                                    </div>
                                                </td>
                                                <td style="width: 70px">
                                                    <div class="BlackBold">
                                                        <%=Request.QueryString["MonthName"].Trim()%>
                                                        '<%=Request.QueryString["Year"].Trim()%>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                 <tr class="SheetHead">
                                    <td  class="redhead" align="center" width="50%" >
                                       ORDER TYPE
                                    </td>
                                     <td  class="redhead" align="center">
                                       PKG GROUP
                                    </td>
                                </tr>
                                <tr>
                                    <td width="100%" colspan="2">
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <table width="100%" class="PageBorder">
                                                        <tr class="SheetHead">
                                                            <td class="redhead" align="center">
                                                                SALES </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%">
                                                                <dotnet:Chart ID="chOrderTypeSales" Width="330" Height="200" runat="server" Use3D="true"
                                                                    ImageFormat="Jpg">
                                                                </dotnet:Chart>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td >
                                                    <table width="100%" class="PageBorder">
                                                        <tr class="SheetHead">
                                                            <td class="redhead"  align="center">
                                                                SALES </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%">
                                                                <dotnet:Chart ID="chpkgSales" Width="330" Height="200" runat="server" Use3D="true"
                                                                    ImageFormat="Jpg">
                                                                </dotnet:Chart>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" class="PageBorder">
                                                        <tr class="SheetHead">
                                                            <td class="redhead"  align="center">
                                                                POUNDS </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%">
                                                                <dotnet:Chart ID="chOrderTypePounds" Width="330" Height="200" runat="server" Use3D="true"
                                                                    ImageFormat="Jpg">
                                                                </dotnet:Chart>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td >
                                                    <table width="100%" class="PageBorder">
                                                        <tr class="SheetHead">
                                                            <td class="redhead"  align="center">
                                                                POUNDS</td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%">
                                                                <dotnet:Chart ID="chpkgPounds" Width="330" Height="200" runat="server" Use3D="true"
                                                                    ImageFormat="Jpg">
                                                                </dotnet:Chart>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" class="PageBorder">
                                                        <tr class="SheetHead">
                                                            <td class="redhead"  align="center">
                                                                GM %</td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%" style="height: 205px">
                                                                <dotnet:Chart ID="chOrderTypeGM" Width="330" Height="200" runat="server" Use3D="true"
                                                                    ImageFormat="Jpg">
                                                                </dotnet:Chart>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>
                                                    <table width="100%" class="PageBorder">
                                                        <tr class="SheetHead">
                                                            <td class="redhead"  align="center">
                                                                GM % </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="100%">
                                                                <dotnet:Chart ID="chpkgGM" Width="330" Height="200" runat="server" Use3D="true" ImageFormat="Jpg">
                                                                </dotnet:Chart>
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
                     </table>
                      </td>
                     </tr>
                     </table>
                     
                     
                        </div>
                    
    </form>
</body>
</html>
