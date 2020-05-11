<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WODocNoPrompt.aspx.cs"  Inherits="PFC.WOE.WOPrintingPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>WO Printing</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">
    function ViewReport()
    {
        var custType = "";
        var reportType = "";
        
        if(document.getElementById("rdoDocRange").checked)
        {  
            reportType = "docrange";
            if((document.getElementById("txtDocNoStart").value == "" || document.getElementById("txtDocNoEnd").value == "" ) )
            {
                alert('Invalid document # range.');
                return 
            }
        }        
        else if(document.getElementById("rdoDocList").checked)
        {
            if(document.getElementById("txtDocNoList").value == "")
            {
                alert('Invalid document number.');
                return
            }
            reportType = "doclist"   
        }
        
        var hwnd, Url;

        Url = "WOList.aspx" +
              "?ReportType=" + reportType + 
              "&CustType=" + custType + 
              "&DocStNo=" + document.getElementById("txtDocNoStart").value + 
              "&DocEndNo=" + document.getElementById("txtDocNoEnd").value +
              "&DocList="+ document.getElementById("txtDocNoList").value;
              
        hwnd=window.open(Url,"WOListreport" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        hwnd.focus();
    }
    
    
    function SetReportMode(reportType)
    {
        if(reportType == 'docrange')
        {
            document.getElementById("rdoDocRange").checked = true;
            document.getElementById("txtDocNoList").value = ''; 
        }
        else
        {
            document.getElementById("rdoDocList").checked = true;
            document.getElementById("txtDocNoStart").value = '';
            document.getElementById("txtDocNoEnd").value = '';  
        }
        
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
                                                    Print From Document List</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px; width: 275px;">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    &nbsp;</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3">
                                                <tr id="tdRange" runat="server">
                                                    <td colspan="1" style="width: 560px; height: 20px">
                                                        <table border="0" cellpadding="5" cellspacing="0" style="width: 200px;">
                                                             <tr>
                                                                <td>
                                                                    <asp:RadioButton ID="rdoDocRange" runat="server" GroupName="ReportType"
                                                                        Text="Document # Range" Width="111px"  onclick="SetReportMode('docrange');"/></td>
                                                                <td colspan="3">
                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td style="width: 100px">
                                                                                <asp:TextBox ID="txtDocNoStart" runat="server" CssClass="FormCtrl" MaxLength="20" Width="80px" onclick="SetReportMode('docrange');"></asp:TextBox></td>
                                                                            <td style="width: 27px">
                                                                                <strong>To </strong>
                                                                            </td>
                                                                            <td style="width: 100px">
                                                                                <asp:TextBox ID="txtDocNoEnd" runat="server" CssClass="FormCtrl" MaxLength="20" Width="80px" onclick="SetReportMode('docrange');"></asp:TextBox></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px">
                                                                </td>
                                                                <td colspan="3">
                                                                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="OR"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:RadioButton ID="rdoDocList" runat="server" GroupName="ReportType" Text="Document List" onclick="SetReportMode('doclist');"
                                                                        Width="111px" /></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox ID="txtDocNoList" runat="server" CssClass="FormCtrl" MaxLength="20" Width="202px" Height="70px" TextMode="MultiLine" onclick="SetReportMode('doclist');"></asp:TextBox></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
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
                                        <img id="Img1" src="../Common/Images/submit.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;&nbsp;
                                                    <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" /></span></div>
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
