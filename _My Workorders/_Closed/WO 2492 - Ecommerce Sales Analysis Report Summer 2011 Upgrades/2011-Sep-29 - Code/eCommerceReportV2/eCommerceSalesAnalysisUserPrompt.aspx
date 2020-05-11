<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eCommerceSalesAnalysisUserPrompt.aspx.cs" Inherits="eCommerceSalesAnalysisUserPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title>eCommerce Sales Analysis User Prompt</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    
    <script language="javascript" type="text/javascript">
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=eCommerce",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
    }

    function ViewReport()
    {
        var branchID =document.form1.ddlBranch.value ;    
        var w = document.form1.ddlBranch.selectedIndex;
        var selected_text = document.form1.ddlBranch.options[w].text;
        
        if(selected_text.toUpperCase() == "ALL")
            branchID = "";
            
        var repNo =document.form1.ddlCSR.value ;        
        var repName = document.form1.ddlCSR.options[document.form1.ddlCSR.selectedIndex].text;
                
        if (document.getElementById("rdoByMthPer").checked== true)
        {
            var Url =   "eCommerceSalesAnalysisCustRpt.aspx?Month=" + document.form1.ddlMonth.value + 
                        "&Year=" + document.form1.ddlYear.value + "&Branch=" + branchID + 
                        "&CustNo=" + document.form1.txtCustNo.value+
                        "&StartDate=&EndDate=&MonthName="+document.getElementById("ddlMonth").options[document.getElementById("ddlMonth").selectedIndex].text + 
                        "&BranchName="+selected_text + 
                        "&OrdSrc="+ document.form1.ddlOrderSource.value +
                        "&RepNo=" + repNo + "&RepName=" + repName + 
                        "&PriceCdCtl=" + document.getElementById("chkPriceCd").checked +
                        "&ItemNotOrd=" + document.getElementById("chkItemNotOrd").checked;
        }
        else
        {
            var Url =   "eCommerceSalesAnalysisCustRpt.aspx?Month=&Year=&Branch=" + branchID + 
                        "&CustNo=" + document.form1.txtCustNo.value + 
                        "&StartDate="+document.form1.txtstartDt.value+ 
                        "&EndDate=" + document.form1.txtEndDt.value+
                        "&MonthName=&BranchName="+selected_text + 
                        "&OrdSrc="+ document.form1.ddlOrderSource.value +
                        "&RepNo=" + repNo + "&RepName=" + repName + 
                        "&PriceCdCtl=" + document.getElementById("chkPriceCd").checked +
                        "&ItemNotOrd=" + document.getElementById("chkItemNotOrd").checked;
        }
        
        if (document.getElementById("rdoByMthPer").checked== true || (document.form1.txtstartDt.value !="" && document.form1.txtEndDt.value  !=""))
        {
            var hwnd=window.open(Url,"eCommerceSalesAnalysisCust" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
            hwnd.focus();
        }   
    }
</script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server" ID="smEcommRpt" />
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="top">
                    <uc1:PageHeader ID="PageHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top" style="height: 100%;">
                    <asp:UpdatePanel runat="server" ID="upEcommRpt">
                        <ContentTemplate>
                            <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                <tr>
                                    <td class="PageHead" style="height: 40px; width: 350px;">
                                        <div class="LeftPadding">
                                            <div align="left" class="BannerText">
                                                eCommerce Sales Analysis Report</div>
                                        </div>
                                    </td>
                                    <td class="PageHead" style="height: 40px; width: 350px;">
                                        <div align="right" class="LeftPadding BannerText">
                                            <img id="Img1" src="../common/images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;
                                            <img id="imgHelpBtn" src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />&nbsp;
                                            <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <table border="0" cellspacing="0" cellpadding="5" width="1010px">
                                <col width="155px" />
                                <col width="230px" />
                                <col width="75px" />
                                <col width="550px" />
                                <tr>
                                    <td class="LeftPadding">
                                        Select Dates
                                    </td>
                                    <td>
                                        <asp:RadioButton ID="rdoByMthPer" runat="server" Text="By Period" GroupName="Option"
                                            Checked="True" AutoPostBack="True" OnCheckedChanged="rdoByMthPer_CheckedChanged"
                                            TabIndex="1" />&nbsp;&nbsp;&nbsp;
                                        <asp:RadioButton ID="rdoByRange" runat="server" Text="By Date Range" GroupName="Option"
                                            AutoPostBack="True" OnCheckedChanged="rdoByRange_CheckedChanged" TabIndex="2" />
                                    </td>
                                </tr>
                                <tr id="trrdoByMthPer" runat="server">
                                    <td class="LeftPadding">
                                        Period
                                    </td>
                                    <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                            <tr>
                                                <td>
                                                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="FormCtrl" Width="125px"
                                                        Height="20px" TabIndex="3">
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
                                                    </asp:DropDownList>&nbsp;
                                                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="FormCtrl" Width="60px" Height="20px"
                                                        TabIndex="4" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr id="trByRange" runat="server">
                                    <td class="LeftPadding" style="vertical-align: top; padding-top: 10px;">
                                        Start Date
                                    </td>
                                    <td colspan="3">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:TextBox AutoPostBack="true" ID="txtstartDt" runat="server" Width="100px" CssClass="FormCtrl"
                                                        OnTextChanged="txtstartDt_TextChanged" TabIndex="3" />
                                                    <asp:ImageButton runat="server" ID="ibtnStartDt" ImageUrl="Images/datepicker.gif"
                                                        OnClick="ibtnStartDt_Click" Enabled="true" />
                                                </td>
                                                <td style="width: 70px;">
                                                    End Date
                                                </td>
                                                <td>
                                                    <asp:TextBox AutoPostBack="true" ID="txtEndDt" Width="100px" runat="server" CssClass="FormCtrl"
                                                        OnTextChanged="txtEndDt_TextChanged" TabIndex="4" />
                                                    <asp:ImageButton runat="server" ID="ibtnEndDt" ImageUrl="Images/datepicker.gif" OnClick="ibtnEndDt_Click" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblError" runat="server" Text="" ForeColor="red" Width="100px" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Calendar ID="cldStartDt" runat="server" Visible="true" OnSelectionChanged="cldStartDt_SelectionChanged"
                                                        Width="150px" />
                                                </td>
                                                <td />
                                                <td>
                                                    <asp:Calendar ID="cldEndDt" runat="server" Visible="true" OnSelectionChanged="cldEndDt_SelectionChanged"
                                                        Width="150px" />
                                                </td>
                                                <td style="width: 3px" />
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LeftPadding">
                                        Branch
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="190px"
                                            Height="20px" AutoPostBack="True" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged" TabIndex="5" />
                                    </td>
                                    <td>
                                        Order Source</td>
                                    <td>
                                        <asp:DropDownList ID="ddlOrderSource" runat="server" CssClass="FormCtrl" Width="150px" Height="20px" TabIndex="6" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LeftPadding">
                                        CSR Name
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlCSR" runat="server" CssClass="FormCtrl" Width="190px" Height="20px"  TabIndex="7" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LeftPadding">
                                        Customer #
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCustNo" runat="server" MaxLength="20" CssClass="FormCtrl" Width="185px" TabIndex="8" Height="20px" />
                                        <asp:Label ID="lblCustno" runat="server" CssClass="Required" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LeftPadding">
                                        Include PriceCd 'X'
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkPriceCd" runat="server" TabIndex="9" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LeftPadding">
                                        Show Only Items Not Ordered
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkItemNotOrd" runat="server" TabIndex="10" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
