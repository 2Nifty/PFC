<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostAnalysisPrompt.aspx.cs" Inherits="PFC.Intranet.CostAnalysisPrompt" %>
<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<title>Cost Analysis Prompt</title>
<link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />


<script language="javascript">


    function ViewReport()
    { //stole this part from Day Inventory report
    
        var showRestrictedVersion = (document.getElementById("chkBoxRestricted").checked == true ? "Restricted" : "ALL");
        var Url =   "CostAnalysisReport.aspx?StartDate=" + document.getElementById("hidStartDt").value + 
                    "&EndDate=" +document.getElementById("hidEndDt").value +
                    "&ReportVersion=" + showRestrictedVersion;
        
                
        var hwnd=window.open(Url,"CostAnalysisReport" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        hwnd.focus();            
        
    
//        if(document.getElementById("rdoWithExclusion").checked==true)
//        {  
//            var url="CostAnalysisReport.aspx?status=withExclusion";           
//        	var hWnd= window.open(url,"CostAnalysisReport" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
//            hWnd.opener = self;	
//	        if (window.focus) {hWnd.focus()}
//        }
//        else
//        {
//            var url="CostAnalysisReport.aspx?status=36MonthUsage";           
//        	var hWnd= window.open(url,"CostAnalysisReports" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
//            hWnd.opener = self;	
//	        if (window.focus) {hWnd.focus()}
//        }
            
    }
    
    function OpenReport()
    {
     if(event.keyCode==13)
        ViewReport();
    }
   
    function LoadHelp()
    {
        var hwin=window.open("../Help/HelpFrame.aspx?Name=DayInventoryReport",'DayHelp','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        hwin.focus();
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
                                                    Cost Analysis by Branch Date Filter</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    &nbsp;<img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr id="tdRange" runat="server">
                                                    <td colspan="2" style="width: 1348px; height: 20px">
                                                        <asp:UpdatePanel runat="server" ID="pnlDate">
                                                            <ContentTemplate>
                                                                <table>
                                                                    <tr>
                                                                        <td style="height: 12px; width: 165px;">
                                                                            <asp:Label ID="lblStartDt" runat="server" Text="Beginning Date" Width="93px" Font-Bold="True"
                                                                                ForeColor="Red"></asp:Label></td>
                                                                        <td>
                                                                            &nbsp;</td>
                                                                        <td>
                                                                            <asp:Label ID="lblEndDt" runat="server" Text="Ending Date" Width="67px" Font-Bold="True"
                                                                                ForeColor="Red"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 165px; height: 12px">
                                                                            <asp:Calendar ID="cldStartDt" runat="server" Visible="true" OnSelectionChanged="cldStartDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                            <input type="hidden" id="hidStartDt" runat="server" /></td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Calendar ID="cldEndDt" runat="server" Visible="true" OnSelectionChanged="cldEndDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                            <input type="hidden" id="hidEndDt" runat="server" /></td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                           </asp:UpdatePanel> 
                                                        <br />
                                                        <br /> 
                                                        <br />
                                                        <asp:UpdatePanel runat="server" ID="pnlRestrictedVer" UpdateMode="Conditional">
                                                                <ContentTemplate>
                                                                    <asp:CheckBox ID="chkBoxRestricted" runat="server" CssClass="boldText" Text=" Restricted Version" Width="165px" />&nbsp;
                                                                </ContentTemplate>
                                                         </asp:UpdatePanel>
                                                         </td> 
                                                        
                                                       <%-- <asp:CheckBoxList ID="chkBoxRestricted"  runat="server" Width="200px" CssClass="boldText" TabIndex="4"  OnCheckedChanged="chkBoxRestricted_CheckedChanged">
                                                            <asp:ListItem Text=" Restricted Version"></asp:ListItem>
                                                        </asp:CheckBoxList></td>--%>
                                                </tr>
                                               <%-- <td class="splitBorder_r_h Left2pxPadd Right2pxPadd" rowspan="2" style="width: 1379px">
                                                    <table class="blueBorder shadeBgDown">
                                                        <tr>
                                                            <td style="width: 999px">
                                                                <asp:CheckBoxList ID="chkListType"  runat="server" Width="200px" CssClass="boldText" TabIndex="4">
                                                                    <asp:ListItem Text=" Restricted version" ></asp:ListItem>                                                           
                                                                </asp:CheckBoxList></td>
                                                        </tr>
                                                    </table>
                                                </td>--%>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 100%" valign="top">
                            <asp:UpdatePanel runat="server" ID="pnlStatus">
                                <ContentTemplate>
                                    <asp:Label ID="lblError" runat="server" Font-Bold="True" ForeColor="Red" Text=""
                                        Visible="false" Width="67px"></asp:Label></td>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </tr>
                        <tr>
                            <td class="BluBg" style="">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
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
