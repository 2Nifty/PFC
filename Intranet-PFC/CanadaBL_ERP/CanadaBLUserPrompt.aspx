<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CanadaBLUserPrompt.aspx.vb" Inherits="_CanadaBLUserPrompt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Canada Bill Of Lading User Prompt</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<script language="javascript">

function ViewReport()
    {
        if (document.form1.txtBLNo.value == "")
            alert('Please enter a Bill of Lading #');
        else
        {
            var Url = "CanadaBLSummaryRpt.aspx?BLNo=" + document.form1.txtBLNo.value;
/*          Url = "ProgressBar.aspx?destPage="+Url;   */
            window.open(Url,'CanadaBLSummaryRpt','height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }
    }
    
function LoadHelp()
    {
    window.open('../CanadaBL/Help.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
    }

function Done()
    {
    parent.history.go(-1);;
    }

</script>
</head>
<body>
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="5" height="97" valign="top" class="BannerBg">
                                <div width="100%" class="bannerImg">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="100%" height="100%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Process Canada Bill Of Lading</div>
                                            </div>
                                        </td>
<!--
                                        <td class="PageHead" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="images/close.gif" onclick="javascript:Done();"
                                                        style="cursor: hand" /></div>
                                            </div>
                                        </td>
-->
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3" width="600">
                                                <tr>
                                                    <td>
                                                        <span class="LeftPadding" style="width: 100px;">Bill of Lading #</span></td>
                                                    <td colspan="2">
                                                        <asp:TextBox ID="txtBLNo" runat="server" MaxLength="20" CssClass="FormCtrl" Width="184px"></asp:TextBox>
                                                        <asp:Label ID="lblBLNo" runat="server" Text="" CssClass="Required"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <img id="Img1" src="images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;
                                        <img src="Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
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
