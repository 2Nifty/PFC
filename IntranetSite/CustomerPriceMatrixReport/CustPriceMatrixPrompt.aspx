<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustPriceMatrixPrompt.aspx.cs"
    Inherits="PFC.Intranet.CustPriceMatrixPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Matrix Prompt</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">

    function ViewReport()
    {
        var territoryCd =document.form1.ddlTerritory.value ;            
        var territoryDesc = document.form1.ddlTerritory.options[document.form1.ddlTerritory.selectedIndex].text;    
        
        var outSideRep =document.form1.ddlOutsideRep.value ;            
        var outSideRepDesc = document.form1.ddlOutsideRep.options[document.form1.ddlOutsideRep.selectedIndex].text;  
        
        var inSideRep =document.form1.ddlInsideRep.value ;            
        var inSideRepDesc = document.form1.ddlInsideRep.options[document.form1.ddlInsideRep.selectedIndex].text;  
        
        var regionCd =document.form1.ddlRegion.value ;            
        var regionDesc = document.form1.ddlRegion.options[document.form1.ddlRegion.selectedIndex].text;  
         
        var buyGrpCd =document.form1.ddlBuyGrp.value ;            
        var buyGrpDesc = document.form1.ddlBuyGrp.options[document.form1.ddlBuyGrp.selectedIndex].text;  
        
        if( (territoryCd != "" &&  outSideRep == "" &&  inSideRep == "" && regionCd == "" && buyGrpCd == "") ||
            (territoryCd == "" &&  outSideRep != "" &&  inSideRep == "" && regionCd == "" && buyGrpCd == "") ||
            (territoryCd == "" &&  outSideRep == "" &&  inSideRep != "" && regionCd == "" && buyGrpCd == "") ||
            (territoryCd == "" &&  outSideRep == "" &&  inSideRep == "" && regionCd != "" && buyGrpCd == "") ||
            (territoryCd == "" &&  outSideRep == "" &&  inSideRep == "" && regionCd == "" && buyGrpCd != "") )
        {
            var Url =   "CustPriceMatrixReport.aspx?" +
                        "territoryCd=" + territoryCd +  "&territoryDesc=" + territoryDesc +
                        "&outSideRep=" + outSideRep + "&outSideRepDesc=" + outSideRepDesc + 
                        "&inSideRep=" + inSideRep + "&inSideRepDesc=" +  inSideRepDesc + 
                        "&regionCd=" + regionCd + "&regionDesc=" +  regionDesc +
                        "&buyGrpCd=" + buyGrpCd + "&buyGrpDesc=" +  buyGrpDesc ;
        
            var hwnd=window.open(Url,"CustPriceMatrixRpt" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();         
        }
        else
        {
            alert('Please select only one filter for this report');
        }       
    }
    
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=InvoiceReport",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
    }
    </script>

</head>
<body scroll="auto">
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="top">
                                <uc1:PageHeader ID="PageHeader1" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="height: 100%;">
                                <asp:ScriptManager runat="server" ID="scmPostBack">
                                </asp:ScriptManager>
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Customer Price Matrix Report</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            &nbsp;<table border="0" cellpadding="5" cellspacing="0" style="width: 200px;">
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label2" runat="server" Text="Territory:" Font-Bold="True"></asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList ID="ddlTerritory" runat="server" CssClass="FormCtrl" Width="200px">
                                                                    </asp:DropDownList></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Outside Sales Rep:" Width="108px"></asp:Label></td>
                                                                <td colspan="3"><asp:DropDownList ID="ddlOutsideRep" runat="server" CssClass="FormCtrl" Width="200px">
                                                                </asp:DropDownList></td>
                                                            </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Inside Sales Rep:" Width="106px"></asp:Label></td>
                                                    <td colspan="3">
                                                        <asp:DropDownList ID="ddlInsideRep" runat="server" CssClass="FormCtrl" Width="200px">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Region:"></asp:Label></td>
                                                    <td colspan="3">
                                                        <asp:DropDownList ID="ddlRegion" runat="server" CssClass="FormCtrl" Width="200px">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Buying Group:"></asp:Label></td>
                                                    <td colspan="3">
                                                        <asp:DropDownList ID="ddlBuyGrp" runat="server" CssClass="FormCtrl" Width="200px">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                        </table>
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg" style="">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <img id="Img1" src="../common/images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;<img
                                            src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />&nbsp;
                                    </span>
                                </div>
                            </td>
                            <td class="BluBg">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
