<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerChainPrompt.aspx.cs"   Inherits="SystemFrameSet_PromptCustomerChain" %>
<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
<link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script>
    function OpenCustomerContracts()
    {
        var url="Contractlist.aspx";
        
        if(document.form1.ddlCustomerChainNo.value!="0")
        {   
            document.getElementById("divMessage").innerHTML="";
        	url=url+"?CustCatNo=" + document.form1.ddlCustomerChainNo.value.replace('&','||');
            var hWnd= window.open(url,"PromptCustomerChain" ,'height=490,width=550,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (550/2))+',resizable=no',"");
            hWnd.opener = self;	
	        if (window.focus) {hWnd.focus()}
	       
	        
        }
        else
            document.getElementById("divMessage").innerHTML="* Required";
    }
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=VendorManagement",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    } 
    function formatGrid()
    {
    } 
    </script>

</head>
<body>
    <form id="form1" runat="server" defaultfocus="txtCustomerNo">
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
                            <td width="100%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    VMI Management Reports</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="javascript:window.history.back();"
                                                        style="cursor: hand" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height=80>
                                            <table border="0" cellspacing="0" cellpadding="3" width="600">
                                             
                                                <tr>
                                                    <td style="width: 111px">
                                                        <span class="LeftPadding" style="width: 100px;">Chain Name</span></td>
                                                    <td style="width: 105px">
                                                    <asp:DropDownList id="ddlCustomerChainNo" runat="server" Width="150px" CssClass="FormCtrl" ></asp:DropDownList>
                                                    
                                                    </td>
                                                    <td><div  class="Required" style="color:Red;height:20px;" id=divMessage></div></td>
                                                </tr>
                                                
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    </form>
                    <tr>
                        <td class="BluBg" style="height: 27px">
                            <div class="LeftPadding">
                                <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <img id="btnOk" src="../common/images/viewReport.gif" style="cursor: hand" onclick="Javascript:OpenCustomerContracts();" />&nbsp;<img
                                        src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                        </span>
                            </div>
                        </td>
                        
                    </tr>
</body>
<script>formatGrid();</script>
</html>
