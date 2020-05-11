<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="VendorForeCastPrompt.aspx.cs" Inherits="VendorForeCastPrompt" %>

<%@ Register Src="../Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Vendor Forecast Report</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/VendorForeCast.css" rel="stylesheet" type="text/css" />
    <script src="Javascript/VendorForecastReport.js" language="javascript"> </script>
</head>
<script language="javascript">
function LoadHelp()
{
window.open("../Help/HelpFrame.aspx?Name=vendorforecast",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
}
</script>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="MyScript" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
    <div>
        
        <table border="0px">
            <tr>
                <td>
                    <img src="Images/FinalBanner.jpg" /></td>
            </tr>
            <tr>
                <td class="PageHead">
                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                        <tr>
                            <td width="90%">
                                <div align="left" class="LeftPadding BannerText">Vendor Forecast Report</div>
                            </td>    
                            <td align ="center">
                                <img src="../Common/Images/Close.gif" style="cursor:hand;" onclick="window.history.back();" />
                            </td>
                        </tr>
                    </table>
                </td>
                
            </tr>
            <tr>
                <td class="table">
                    <table width="100%" cellspacing="0" cellpadding="0px" >
                        <tr>
                            <td class="table">
                                <table border="0" cellpadding="0" cellspacing="5">
                                    <tr>
                                        <td class="txtHead" width="40">
                                <asp:Label ID="Label5" runat="server" Text="Multiplier"></asp:Label></td>
                                        <td >
                                            <asp:TextBox CssClass="cnt" MaxLength="4" onkeypress="ValidateNumber()" ID="txtMultiplier" runat="server" Width="80px">100</asp:TextBox>
                                            <asp:Label ID="Label2" runat="server" Text="  %" Font-Bold="True"></asp:Label>
                                <%--<asp:DropDownList ID="ddlMultiplier" runat="server" CssClass="cnt" Width="88px">
                                </asp:DropDownList>--%></td>
                                        <td>
                                         <asp:RequiredFieldValidator ID="rfvMultiplier" ControlToValidate="txtMultiplier" runat="server" ErrorMessage="* Required"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <!-- Category Information -->
                        <tr>
                            <td class="table" style="height: 28px">
                            <asp:UpdatePanel ID="updatePanel"  RenderMode=Inline  runat="server">
                            <ContentTemplate>
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td style="width:70px" class="txtHead" valign="top">
                                            <asp:Label ID="Label11" runat="server" Text="Category " Width="70px"></asp:Label>
                                        </td>
                                        
                                        <td height="120px" style="width: 100px">
                                            <table border=0 cellpadding=0 cellspacing=0>
                                                <tr>
                                                    <td>
                                                        <asp:ListBox ID="lstCategory" runat="server" SelectionMode=Multiple CssClass="listcontrol" Width="220px" Height="70px">
                                                        <asp:ListItem Selected="True" Value="0">All</asp:ListItem>
                                                        </asp:ListBox>
                                                    </td>
                                                 </tr>
                                                 <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnCategoryEdit" ImageUrl="~/VendorForeCastReport/Images/btnedit.jpg" runat="server" ImageAlign="middle" OnClick="ibtnCategoryEdit_Click" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnCategoryDelete" ImageUrl="~/VendorForeCastReport/Images/btnremove.jpg" runat="server" ImageAlign="middle" OnClick="ibtnCategoryDelete_Click" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnCategoryReset" ImageUrl="~/VendorForeCastReport/Images/btnreset.jpg" runat="server" ImageAlign="middle" OnClick="ibtnCategoryReset_Click" />
                                                                </td>
                                                            </tr>
                                                        </table>    
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        
                                        <td  class="tablepadding" >
                                            <input type="hidden" runat="server" id="hidCategoryRangeType" />
                                            <div id="divCategory" runat="server">
                                                <table cellpadding="0" width="400" style="height:110px;" cellspacing="0" class="insidepadding">
                                                    <tr>
                                                        <td>
                                                            <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td height="26" bgcolor="#c6e9f4" class="lblbox">
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr>
                                                                                <td width="89%" align="left" class="txtLables">Edit Category information </td>
                                                                                <td width="9%">&nbsp;</td>
                                                                                <td width="2%" align="center" valign="middle">
                                                                                    <asp:ImageButton ImageUrl="~/VendorForeCastReport/Images/closesmall.gif" ID="ibtnCategoryClose" runat="server" ImageAlign="middle" OnClick="ibtnCategoryEdit_Click" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    
                                                    <tr>
                                                        <td>
                                                            <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td style="width:100px;" align="left"  class="txtLables">
                                                                        Entry Type </td>
                                                                    <td align="left"  class="txtLables">
                                                                        <asp:RadioButtonList ID="rdlCategoryRangeType" RepeatDirection="Horizontal" Width="150px" runat="server" OnSelectedIndexChanged="rdlCategoryRangeType_SelectedIndexChanged" AutoPostBack="True" >
                                                                            <asp:ListItem Text="Single" Value="1"></asp:ListItem>
                                                                            <asp:ListItem Text="Range" Value="2"></asp:ListItem>
                                                                        </asp:RadioButtonList>
                                                                    </td>
                                                                </tr>
                                
                                                                <tr>
                                                                    <td align="left" class="txtLables">Enter Category</td>
                                                                    <td align="left" class="txtLables">
                                                                        <table cellpadding="0" cellspacing="5px">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:TextBox MaxLength="5" onkeypress="ValidateNumber()" ID="txtCategoryFrom" Width="80px" runat="server" CssClass="formcontrol"></asp:TextBox>
                                                                                </td>
                                                                                <td align="left"  class="txtLables">
                                                                                    <div id="divCategoryThro" runat="server">
                                                                                        <table cellpadding="0">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="lblCategoryThru" runat="server" Text="Thru"></asp:Label></td>
                                                                                                <td>    
                                                                                                    <asp:TextBox  MaxLength="5" onkeypress="ValidateNumber()" ID="txtCategoryThro" Width="80px" runat="server" CssClass="formcontrol"></asp:TextBox>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>    
                                                                                </td>
                                                                                <td>
                                                                                    <asp:ImageButton ID="ibtCategoryAdd" ImageUrl="~/VendorForeCastReport/Images/btnadd.jpg" OnClientClick="return CheckValidData('category')" runat="server" ImageAlign="middle" OnClick="ibtCategoryAdd_Click" />            
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
                                        </td>
                                    </tr>
                                </table>
                                </ContentTemplate>                                
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <!-- End Category Information -->
                        <!-- Variance Information -->
                        <tr>
                            <td class="table">
                                <asp:UpdatePanel ID="upVariance" RenderMode=Inline runat="server">
                                <ContentTemplate>
                                <table border="0" cellpadding="0"  cellspacing="0" width="100%">
                                    <tr>
                                        <td style="width: 70px" class="txtHead" valign="top" >
                                            <asp:Label ID="Label1" runat="server" Text="Variance" Width="70px"></asp:Label>
                                        </td>
                                        
                                        <td height="120px" style="width: 100px">
                                            <table border=0 cellpadding=0 cellspacing=0>
                                                <tr>
                                                    <td >
                                                        <asp:ListBox ID="lstVariance" runat="server"  SelectionMode=Multiple CssClass="listcontrol" Width="220px" Height="70px">
                                                        <asp:ListItem Selected="True" Value="0">All</asp:ListItem>
                                                        </asp:ListBox>
                                                    </td>
                                                 </tr>
                                                 <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnEditVarient" ImageUrl="~/VendorForeCastReport/Images/btnedit.jpg" runat="server" ImageAlign="middle" OnClick="ibtnEditVarient_Click" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnVarianceDelete" ImageUrl="~/VendorForeCastReport/Images/btnremove.jpg" runat="server" ImageAlign="middle" OnClick="ibtnVarianceDelete_Click" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnVarianceReset" ImageUrl="~/VendorForeCastReport/Images/btnreset.jpg" runat="server" ImageAlign="middle" OnClick="ibtnVarianceReset_Click" />
                                                                </td>
                                                            </tr>
                                                        </table>    
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        
                                        <td  class="tablepadding" >
                                            <input type="hidden" runat="server" id="hidVarianceRangeType" />
                                            <div id="divVariance" runat="server" >
                                                <table cellpadding="0" width="400" style="height:110px;"  cellspacing="0" class="insidepadding">
                                                    <tr>
                                                        <td>
                                                            <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td bgcolor="#c6e9f4" class="lblbox" style="height: 15px">
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr>
                                                                                <td width="89%" align="left" class="txtLables">Edit Variance information </td>
                                                                                <td width="9%">&nbsp;</td>
                                                                                <td align="center" valign="middle" style="width: 1%">
                                                                                    <asp:ImageButton ImageUrl="~/VendorForeCastReport/Images/closesmall.gif" ID="ibtnVarianceCloce" runat="server" ImageAlign="middle" OnClick="ibtnEditVarient_Click" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    
                                                    <tr>
                                                        <td>
                                                            <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td style="width:100px" align="left"  class="txtLables">
                                                                        Entry Type </td>
                                                                    <td align="left"  class="txtLables">
                                                                        <asp:RadioButtonList AutoPostBack="true" ID="rdlVarianceRangeType" RepeatDirection="Horizontal" Width="150px" runat="server" OnSelectedIndexChanged="rdlVarianceRangeType_SelectedIndexChanged">
                                                                            <asp:ListItem Text="Single" Value="1"></asp:ListItem>
                                                                            <asp:ListItem Text="Range" Value="2"></asp:ListItem>
                                                                        </asp:RadioButtonList>
                                                                    </td>
                                                                </tr>
                                
                                                                <tr>
                                                                    <td align="left" class="txtLables">Enter Variance</td>
                                                                    <td align="left" class="txtLables">
                                                                        <table cellpadding="0" cellspacing="5px">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:TextBox MaxLength="2" onkeypress="ValidateNumber()" ID="txtVarianceFrom" Width="80px" runat="server" CssClass="formcontrol"></asp:TextBox>
                                                                                </td>
                                                                                <td align="left"  class="txtLables">
                                                                                    <div id="divVarianceThro" runat="server">
                                                                                        <table cellpadding="0">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="lblVarianceThru" runat="server" Text="Thru"></asp:Label></td>
                                                                                                <td>    
                                                                                                    <asp:TextBox MaxLength="2" onkeypress="ValidateNumber()" ID="txtVarianceThro" Width="80px" runat="server" CssClass="formcontrol"></asp:TextBox>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:ImageButton ID="ibtnVarianceAdd" OnClientClick="return CheckValidData('varaince')" ImageUrl="~/VendorForeCastReport/Images/btnadd.jpg" runat="server" ImageAlign="middle" OnClick="ibtnVarianceAdd_Click" />            
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
                                        </td>
                                    </tr>
                                </table>
                                </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <!-- End Variance Information -->
                        <!-- Plating Type Iformation -->
                        <tr>
                            <td class="table">
                                <asp:UpdatePanel ID="upPlatingType"  RenderMode=Inline  runat="server">
                                <ContentTemplate>
                                <table border="0" cellpadding="0"  cellspacing="0" width="100%">
                                    <tr>
                                        <td class="txtHead" style="width:70px" valign="top">
                                            <asp:Label ID="Label3" runat="server" Text="Plating Type" Width="70px"></asp:Label>
                                        </td>
                                        
                                        <td height="120px" style="width: 100px">
                                            <table border=0 cellpadding=0 cellspacing=0>
                                                <tr>
                                                    <td>
                                                        <asp:ListBox ID="lstPlatingType" runat="server"  SelectionMode=Multiple CssClass="listcontrol" Width="220px" Height="70px">
                                                        <asp:ListItem Selected="True" Value="0">All</asp:ListItem>
                                                        </asp:ListBox>
                                                    </td>
                                                 </tr>
                                                 <tr>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnPlatingTypeEdit" ImageUrl="~/VendorForeCastReport/Images/btnedit.jpg" runat="server" ImageAlign="middle" OnClick="ibtnPlatingTypeEdit_Click" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnPlatingTypeDelete" ImageUrl="~/VendorForeCastReport/Images/btnremove.jpg" runat="server" ImageAlign="middle" OnClick="ibtnPlatingTypeDelete_Click" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnPlatingTypeReset" ImageUrl="~/VendorForeCastReport/Images/btnreset.jpg" runat="server" ImageAlign="middle" OnClick="ibtnPlatingTypeReset_Click" />
                                                                </td>
                                                            </tr>
                                                        </table>    
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        
                                        <td class="tablepadding" >
                                            <input type="hidden" runat="server" id="hidPlatingRangeType" />
                                            <div id="divPlatingType" runat="server" >
                                                <table cellpadding="0" width="400" style="height:110px;" cellspacing="0" class="insidepadding">
                                                    <tr>
                                                        <td>
                                                            <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td height="26" bgcolor="#c6e9f4" class="lblbox">
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr>
                                                                                <td width="89%" align="left" class="txtLables">Edit Plating Type Information </td>
                                                                                <td width="9%">&nbsp;</td>
                                                                                <td align="center" valign="middle" style="width: 2%">
                                                                                    <asp:ImageButton ImageUrl="~/VendorForeCastReport/Images/closesmall.gif" ID="ibtPlatingTypeClose" runat="server" ImageAlign="middle" OnClick="ibtnPlatingTypeEdit_Click" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    
                                                    <tr>
                                                        <td>
                                                            <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td style="width:100px" align="left"  class="txtLables">
                                                                        Entry Type </td>
                                                                    <td align="left"  class="txtLables">
                                                                        <asp:RadioButtonList AutoPostBack="true" ID="rdlPlatingType" RepeatDirection="Horizontal" Width="150px" runat="server" OnSelectedIndexChanged="rdlPlatingType_SelectedIndexChanged">
                                                                            <asp:ListItem Text="Single" Value="1"></asp:ListItem>
                                                                            <asp:ListItem Text="Range" Value="2"></asp:ListItem>
                                                                        </asp:RadioButtonList>
                                                                    </td>
                                                                </tr>
                                
                                                                <tr>
                                                                    <td align="left" class="txtLables">Enter Plating Type</td>
                                                                    <td align="left" class="txtLables">
                                                                        <table cellpadding="0" cellspacing="5px">
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:TextBox MaxLength="1" onkeypress="ValidateNumber()" ID="txtPlatingTypeFrom" Width="60px" runat="server" CssClass="formcontrol"></asp:TextBox>
                                                                                </td>
                                                                                <td align="left"  class="txtLables">
                                                                                    <div id="divPlatingThro" runat="server">
                                                                                        <table cellpadding="0">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="lblPlatingThru" runat="server" Text="Thru"></asp:Label></td>
                                                                                                <td>    
                                                                                                    <asp:TextBox MaxLength="1" onkeypress="ValidateNumber()" ID="txtPlatingTypeThro" Width="60px" runat="server" CssClass="formcontrol"></asp:TextBox>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:ImageButton ID="ibtnPlatingTypeAdd" OnClientClick="return CheckValidData('platingtype')" ImageUrl="~/VendorForeCastReport/Images/btnadd.jpg" runat="server" ImageAlign="middle" OnClick="ibtnPlatingTypeAdd_Click" />            
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
                                        </td>
                                    </tr>
                                </table>
                                </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <!-- End Plating Type Information -->
                        <!-- Location -->
                        <!-- End Location -->
                        <tr>
                            <td>
                                <table border="0" cellpadding="0" cellspacing="5">
                                    <tr>
                                        <td class="txtHead" width="50" >
                                            <asp:Label ID="Label10" runat="server" Text="Sort"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlSort" runat="server" CssClass="cnt" Width="88px">
                                                <asp:ListItem Selected="True">Plating</asp:ListItem>
                                                <asp:ListItem>Item</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="background-color: #EFF9FC;padding-left:45px; border-bottom-width: 2px;border-bottom-style: solid;border-bottom-color: #BCE6F2;" >
                                <div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle"><asp:UpdatePanel ID="upViewReport"  RenderMode=Inline  runat="server">
                                <ContentTemplate>
                                    &nbsp;
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td style="width: 100px">
                                            <asp:ImageButton ID="ibtnViewReport" ImageUrl="~/Common/Images/viewReport.gif" runat="server" OnClick="ibtnViewReport_Click" /></td>
                                            <td style="width: 100px">
                                            <img src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor:hand; display: block;"  /></td>
                                        </tr>
                                    </table>&nbsp;
                                </ContentTemplate>
                                </asp:UpdatePanel>
                                    </span></div>
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
