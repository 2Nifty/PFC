<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommerceSalesAnalysisUserPrompt.aspx.cs"
    Inherits="PFC.Intranet.eCommerceSalesAnalysisUserPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>eCommerce Sales Analysis User Prompt</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script language="javascript">


    function ViewReport()
    {
        var branchID =document.form1.ddlBranch.value ;    
        var w = document.form1.ddlBranch.selectedIndex;
        var selected_text = document.form1.ddlBranch.options[w].text;
        
        if(selected_text.toUpperCase() == "ALL")
            branchID = "";
            
        var repNo =document.form1.ddlCSR.value ;        
        var repName = document.form1.ddlCSR.options[document.form1.ddlCSR.selectedIndex].text;
                
        if (document.getElementById("PeriodByMonth").checked== true)
        {
            var Url =   "eCommerceQuote2OrderAnalysis.aspx?Month=" + document.form1.ddlMonth.value + 
                        "&Year=" + document.form1.ddlYear.value + "&Branch=" + branchID + 
                        "&CustNo=" + document.form1.txtCustNo.value+
                        "&StartDate=&EndDate=&MonthName="+document.getElementById("ddlMonth").options[document.getElementById("ddlMonth").selectedIndex].text + 
                        "&BranchName="+selected_text + 
                        "&RepNo=" + repNo + "&RepName=" + repName + 
                        "&PriceCdCtl=" + document.getElementById("chkPriceCd").checked;
        }
        else
        {
            var Url =   "eCommerceQuote2OrderAnalysis.aspx?Month=&Year=&Branch=" + branchID + 
                        "&CustNo=" + document.form1.txtCustNo.value + 
                        "&StartDate="+document.form1.txtstartDt.value+ 
                        "&EndDate=" + document.form1.txtEndDt.value+
                        "&MonthName=&BranchName="+selected_text + 
                        "&RepNo=" + repNo + "&RepName=" + repName + 
                        "&PriceCdCtl=" + document.getElementById("chkPriceCd").checked;
        }
        
        if (document.getElementById("PeriodByMonth").checked== true || (document.form1.txtstartDt.value !="" && document.form1.txtEndDt.value  !=""))
        {
            var hwnd=window.open(Url,"eCommerceSalesAnalysis" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();
        }   
    }
    
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=eCommerce",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
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
                                <asp:UpdatePanel runat="server" ID="upPostBack">
                                    <ContentTemplate>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                            <tr>
                                                <td class="PageHead" style="height: 40px" width="75%">
                                                    <div class="LeftPadding">
                                                        <div align="left" class="BannerText">
                                                            eCommerce Sales Analysis Report</div>
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
                                                    <table border="0" cellspacing="0" cellpadding="3" width="100%">
                                                        <tr>
                                                            <td style="width: 104px; height: 25px;">
                                                                <span class="LeftPadding">Select</span></td>
                                                            <td colspan="2" style="width: 560px; height: 25px;">
                                                                <asp:RadioButton ID="PeriodByMonth" runat="server" Text="Period By Month" GroupName="Option"
                                                                    Checked="True" AutoPostBack="True" OnCheckedChanged="PeriodByMonth_CheckedChanged"
                                                                    Width="115px" />
                                                                <asp:RadioButton ID="PeriodByDate" runat="server" Text="Period By Date Range" GroupName="Option"
                                                                    AutoPostBack="True" OnCheckedChanged="PeriodByDate_CheckedChanged" Width="132px" /></td>
                                                        </tr>
                                                        <tr id="tdPeriod" runat="server">
                                                            <td style="width: 104px; height: 20px">
                                                                <span class="LeftPadding">
                                                                    <asp:Label ID="lblPeriod" runat="server" Text="Period" Width="65px" Height="20px"></asp:Label></span>
                                                            </td>
                                                            <td colspan="2" style="width: 560px; height: 20px">
                                                                <table>
                                                                    <tr>
                                                                        <td style="height: 12px; width: 115px;">
                                                                            <asp:DropDownList ID="ddlMonth" runat="server" CssClass="FormCtrl" Width="124px">
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
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                        <td style="width: 150px; height: 12px;">
                                                                            <asp:DropDownList ID="ddlYear" runat="server" CssClass="FormCtrl" Width="60px">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr id="tdRange" runat="server">
                                                            <td style="width: 104px; height: 20px; padding-top: 10px" valign="top">
                                                                <span class="LeftPadding">
                                                                    <asp:Label ID="lblStartDt" runat="server" Text="Start Date" Width="67px" Visible="true"></asp:Label>
                                                                </span>
                                                            </td>
                                                            <td colspan="2" style="width: 560px; height: 20px">
                                                                <table>
                                                                    <tr>
                                                                        <td style="height: 12px; width: 165px;">
                                                                            <asp:TextBox AutoPostBack="true" ID="txtstartDt" runat="server" Width="100px" CssClass="FormCtrl"
                                                                                OnTextChanged="txtstartDt_TextChanged"></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="ibtnStartDt" ImageUrl="Images/datepicker.gif"
                                                                                OnClick="ibtnStartDt_Click" Enabled="true" />
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label ID="lblEndDt" runat="server" Text="End Date" Width="67px" Visible="true"></asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:TextBox AutoPostBack="true" ID="txtEndDt" Width="100px" runat="server" CssClass="FormCtrl"
                                                                                OnTextChanged="txtEndDt_TextChanged"></asp:TextBox>
                                                                            <asp:ImageButton runat="server" ID="ibtnEndDt" ImageUrl="Images/datepicker.gif" OnClick="ibtnEndDt_Click"
                                                                                Enabled="true" />
                                                                        </td>
                                                                        <td style="width: 100px">
                                                                            <asp:Label ID="lblError" runat="server" Text="" ForeColor="red"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 165px; height: 12px">
                                                                            <asp:Calendar ID="cldStartDt" runat="server" Visible="true" OnSelectionChanged="cldStartDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                        </td>
                                                                        <td>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Calendar ID="cldEndDt" runat="server" Visible="true" OnSelectionChanged="cldEndDt_SelectionChanged"
                                                                                Width="150px"></asp:Calendar>
                                                                        </td>
                                                                        <td style="width: 3px">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 104px; height: 20px">
                                                                <span class="LeftPadding">Branch</span></td>
                                                            <td colspan="2" style="width: 560px; height: 20px">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="190px"
                                                                                AutoPostBack="True" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                                                                            </asp:DropDownList>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 104px; height: 20px">
                                                                <span class="LeftPadding">CSR Name:</span></td>
                                                            <td colspan="2" style="width: 560px; height: 20px; padding-left: 5px;">
                                                                <asp:DropDownList ID="ddlCSR" runat="server" CssClass="FormCtrl" Width="190px" AutoPostBack="false">
                                                                </asp:DropDownList></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 104px; height: 20px">
                                                                <span class="LeftPadding">Customer #</span></td>
                                                            <td colspan="2" style="width: 560px; height: 20px">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:TextBox ID="txtCustNo" runat="server" MaxLength="20" CssClass="FormCtrl" Width="184px"></asp:TextBox><asp:Label
                                                                                ID="lblCustno" runat="server" Text="" CssClass="Required"></asp:Label></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td style="width: 115px; height: 20px">
                                                                <span class="LeftPadding">Include PriceCd 'X':</span></td>
                                                            <td colspan="2" style="width: 560px; height: 20px; padding-left: 5px;">
                                                                <asp:CheckBox ID="chkPriceCd" runat="server" /> </td>
                                                        </tr>

                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
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
