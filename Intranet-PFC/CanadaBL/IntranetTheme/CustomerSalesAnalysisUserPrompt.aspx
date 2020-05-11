<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerSalesAnalysisUserPrompt.aspx.cs" Inherits="PFC.Intranet.CustomerSalesAnalysisUserPrompt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Sales Analysis User Prompt</title>
    <link href="../../Test/IntranetTheme/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="top" class="BannerBg"><div class="BannerImg"></div></td>
                        </tr>
                        <tr>
                            <td width="100%" height="100%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width=75%>
                                            <div class="LeftPadding"><div align="left" class="BannerText">Customer Sales Analysis Report</div>
                                            </div>
                                        </td>
                                        <td class="PageHead"  style="height: 40px" >
                            <div class="LeftPadding"><div align="right" class="BannerText" > <img src="images/buttons/close.gif" onclick="javascript:window.location.href='ReportsDashBoard.aspx';" style="cursor:hand"/></div></div></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3" width="600">
                                                <tr>
                                                    <td ><span class="LeftPadding" >Period</span></td>
                                                    <td colspan="2" >
                                                        <table>
                                                            <tr>
                                                                <td >
                                                                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="FormControls" Width="124px">
                                                                        <asp:ListItem Text="January" Value="01"></asp:ListItem>
                                                                        <asp:ListItem Text="February" Value="02"></asp:ListItem>
                                                                        <asp:ListItem Text="March" Value="03"></asp:ListItem>
                                                                        <asp:ListItem Text="April" Value="04"></asp:ListItem>
                                                                        <asp:ListItem Text="May" Value="05"></asp:ListItem>
                                                                        <asp:ListItem Text="June" Value="06"></asp:ListItem>
                                                                        <asp:ListItem Text="July" Value="07"></asp:ListItem>
                                                                        <asp:ListItem Text="August" Value="08"></asp:ListItem>
                                                                        <asp:ListItem Text="September" Value="09"></asp:ListItem>
                                                                        <asp:ListItem Text="October" Value="10"></asp:ListItem>
                                                                        <asp:ListItem Text="November" Value="11"></asp:ListItem>
                                                                        <asp:ListItem Text="December" Value="12"></asp:ListItem>
                                                                    </asp:DropDownList></td>
                                                                <td >
                                                                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="FormControls" Width="60px">
                                                                    </asp:DropDownList></td>
                                                                <td >
                                                                    <asp:Label CssClass="Required" style="display:none;" ID="Label1" runat="server" ForeColor="Red" Width="300px"></asp:Label>
                                                                    </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <tr>
                                                        <td>
                                                            <span class="LeftPadding">Branch</span></td>
                                                        <td colspan="2" >
                                                            <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormControls" Width="190px" AutoPostBack=true>
                                                            </asp:DropDownList></td>
                                                    </tr>
                                                    
                                                    <tr>
                                                        <td style="width: 670px"><span class="LeftPadding" style="width:100px">Sales Rep</span></td>
                                                        <td colspan="3" >
                                                            <asp:DropDownList ID="ddlRep" runat="server" CssClass="FormControls" Width="190px">
                                                            </asp:DropDownList></td> 
                                                    </tr>
                                                <tr>
                                                    <td  >
                                                        <span class="LeftPadding">Chain</span></td>
                                                    <td><asp:DropDownList ID="ddlChain" runat="server" CssClass="FormControls" Width="190px">
                                                    </asp:DropDownList></td>
                                                     <td colspan="2"><asp:Label Width="250px" CssClass="Required" ForeColor="Red" ID="lblStatus" runat="server"></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td >
                                                        <span class="LeftPadding" style="width:100px;">Customer #</span></td>
                                                    <td colspan="2" >
                                                        <asp:TextBox ID="txtCustNo" runat="server" MaxLength="20" CssClass="FormControls" Width="184px"></asp:TextBox>
                                                        <asp:Label ID="lblCustno" runat="server" Text=""  CssClass="Required" ></asp:Label> 
                                                        
                                                        </td>
                                                        
                                                </tr>
                                                <tr>
                                                    
                                                    <td ><span class="LeftPadding">Zip</span>
                                                    </td>
                                                    <td colspan="1">
                                                        <asp:TextBox ID="txtZipFrom" runat="server" CssClass="FormControls" MaxLength="20" Width="184px" ></asp:TextBox></td>
                                                    <td colspan="1" width="20px" >Thru
                                                    </td>
                                                    <td colspan="1">
                                                        <asp:TextBox ID="txtZipTo" runat="server" CssClass="FormControls" MaxLength="20" Width="184px" ></asp:TextBox></td>
                                                    </td>
                                                </tr>
                                            </table>
                                </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    
        
        
        
    <tr>
        <td>
        </td>
    </tr>
                                    <tr>
                                        <td  class="BluBg">
                                            <div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <img id=Img1  src="images/buttons/viewReport.gif" style="cursor:hand" onclick="javascript:ViewReport();" />&nbsp;<img src="images/buttons/help.gif" onclick="LoadHelp();" style="cursor:hand"  />&nbsp;
                                            
                                            </span></div></td>
                                    </tr>
                                    
        </form>                            
</body>
</html>
