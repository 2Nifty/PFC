<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DayInventoryReport.aspx.cs"
    Inherits="DayInventoryReport_DayInventoryReport" %>

<%@ Register Src="~/Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>365 Day Inventory Report</title>
    <link href="~/Common/StyleSheet/Styles.css" type="text/css" rel="stylesheet">

    <script>
    function OpenCategoryDetail()
    { 
       
        if(document.getElementById("rdoWithExclusion").checked==true)
        {  
            var url="DayReport.aspx?status=withExclusion";           
        	var hWnd= window.open(url,"DayReport" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hWnd.opener = self;	
	        if (window.focus) {hWnd.focus()}
	       
        }
        else if(document.getElementById("rdoWithoutExclusion").checked==true)
        {
            var url="DayReport.aspx?status=withoutExclusion";           
        	var hWnd= window.open(url,"DayReports" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hWnd.opener = self;	
	        if (window.focus) {hWnd.focus()}
        }
        else
        {
            var url="DayReport.aspx?status=36MonthUsage";           
        	var hWnd= window.open(url,"DayReports" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hWnd.opener = self;	
	        if (window.focus) {hWnd.focus()}
        }
            
    }
    function LoadHelp()
    {
        var hwin=window.open("../Help/HelpFrame.aspx?Name=DayInventoryReport",'DayHelp','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        hwin.focus();
    } 
    function OpenReport()
    {
     if(event.keyCode==13)
        OpenCategoryDetail();
    
    }
    
    </script>

</head>
<body onkeypress="javascript:OpenReport();" bottommargin="0" leftmargin="0" topmargin="0"
    rightmargin="0" scroll="yes">
    <form id="form1" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top">
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td class="PageHead" style="height: 40px" width="75%">
                                <div class="Left5pxPadd">
                                    <div align="left" class="BannerText">
                                        <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text=""></asp:Label></div>
                                </div>
                            </td>
                            <td class="PageHead" style="height: 40px">
                                <div class="Left5pxPadd">
                                    <div align="right" class="BannerText">
                                        <img src="Common/images/buttons/close.gif" onclick="javascript:window.history.back();"
                                            style="cursor: hand" /></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table border="0" cellspacing="0" cellpadding="3" width="600">
                                    <tr>
                                        <td valign="top">
                                            <div class="Left5pxPadd">
                                                <asp:RadioButton ID="rdoWithExclusion" TabIndex="0" runat="server" Checked="true"
                                                    Text="365 Day Inventory Report with Exclusions" GroupName="DayReport" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <div class="Left5pxPadd">
                                                <asp:RadioButton ID="rdoWithoutExclusion" runat="server" Text="365 Day Inventory Report with NO Exclusions"
                                                    GroupName="DayReport" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <div class="Left5pxPadd">
                                                <asp:RadioButton ID="rdoMonthUsage" runat="server" Text="365 Day Inventory Report with NO Exclusions - Using 36 Month Usage"
                                                    GroupName="DayReport" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg" style="height: 27px">
                    <div class="LeftPadding">
                        <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <img id="btnOk" src="common/images/buttons/viewReport.gif" style="cursor: hand" onclick="Javascript:OpenCategoryDetail();" />&nbsp;<img
                                src="Common/Images/buttons/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                        </span>
                    </div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
