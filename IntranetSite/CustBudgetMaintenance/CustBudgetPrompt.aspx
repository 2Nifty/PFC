<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustBudgetPrompt.aspx.cs"
    Inherits="PFC.Intranet.CustBudgetPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Matrix Prompt</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">

    function ViewReport()
    {
        var branchCd =document.form1.ddlBranch.value ;            
        var branchDesc = document.form1.ddlBranch.options[document.form1.ddlBranch.selectedIndex].text;    
        
        var salesRepNo =document.form1.ddlSalesPerson.value ;            
        var salesRepDesc = document.form1.ddlSalesPerson.options[document.form1.ddlSalesPerson.selectedIndex].text;  
        
        var chainCd =document.form1.ddlChain.value ;            
        var chainDesc = document.form1.ddlChain.options[document.form1.ddlChain.selectedIndex].text;  
        
        var custNo = document.getElementById("txtCustNo").value;            
        
        var sortType = (document.getElementById("rdoSalesDol").checked == true ? "SalesDol" : "CustNo");
        
        var showFSNL = (document.getElementById("chkFSNL").checked == true ? "" : "FSNL");
        
        var Url = "CustBudgetReport.aspx?SortType=" + sortType;
        var windHeight = "710";
                
        if(custNo != "")
        {
            Url +=  "&CustNo=" + custNo +
                    "&BranchCd=&BranchDesc=" + 
                    "&SalesRepNo=&SalesRepDesc=" +  
                    "&ChainCd=&ChainDesc=" +
                    "&ShowFSNL=" + showFSNL +
                    "&SummaryReportType=SALESREP";            
        }
        else if(chainCd != "")
        {
            Url +=  "&CustNo=" + 
                    "&BranchCd=&BranchDesc=" + 
                    "&SalesRepNo=&SalesRepDesc=" +  
                    "&ChainCd="+ chainCd +"&ChainDesc=" + chainDesc.replace('&','~') +
                    "&ShowFSNL=" + showFSNL +
                    "&SummaryReportType=CHAIN";
        }
        else if(branchCd != "" && salesRepNo != "")
        {
            Url +=  "&CustNo=" + 
                    "&BranchCd="+ branchCd + "&BranchDesc=" + branchDesc +
                    "&SalesRepNo="+ salesRepNo +"&SalesRepDesc=" + salesRepDesc.replace('&','~') +
                    "&ChainCd=&ChainDesc="+
                    "&ShowFSNL=" + showFSNL +
                    "&SummaryReportType=SALESREP";
        }
        else if(branchCd != "")
        {
            Url +=  "&CustNo=" + 
                    "&BranchCd="+ branchCd + "&BranchDesc=" + branchDesc +
                    "&SalesRepNo=&SalesRepDesc=" +
                    "&ChainCd=&ChainDesc=" +
                    "&ShowFSNL=" + showFSNL +
                    "&SummaryReportType=BRANCH";
        }
        else
        {
            alert("Invalid Filter Selection.");
            return false;
        }
        
        var hwnd=window.open(Url,"CustBudgetRpt" ,'height=' + windHeight + ',width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (parseInt(windHeight)/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        hwnd.focus();         
    }
    
    function ViewBranchReport()
    {
        var hwnd=window.open("BranchBudgetReport.aspx","CustBudgetALLRpt" ,'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        hwnd.focus();   
    }
    
    function ClearControls()
    {
        document.getElementById("txtCustNo").value = "";
        
        document.form1.ddlChain.options[0].selected = true;
    }
    
    </script>

    <style>
    .FormCtrl 
    {
	    background-color: #f8f8f8;
	    border: 1px solid #cccccc;
	    font-family: Arial, Helvetica, sans-serif;
	    font-size: 11px;
	    color: #000000;
	    width: 100px;
	    height: 22px;
    }
    </style>
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
                                                    Customer Sales Forecast Maintenance Filter Menu</div>
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
                                            <table border="0" cellpadding="5" cellspacing="0" style="width: 200px;">
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label2" runat="server" Text="Branch:" Font-Bold="True"></asp:Label></td>
                                                    <td colspan="3">
                                                        <asp:UpdatePanel ID="pnlBranch" UpdateMode="conditional" runat="server">
                                                            <ContentTemplate>
                                                                <asp:DropDownList ID="ddlBranch" runat="server" onchange="javascript:ClearControls();" CssClass="FormCtrl" Width="200px" AutoPostBack="True" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                                                                </asp:DropDownList>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Sales Person:" Width="85px"></asp:Label></td>
                                                    <td colspan="3">
                                                        <asp:UpdatePanel ID="pnlSalesPerson" UpdateMode="conditional" runat="server">
                                                            <ContentTemplate>
                                                                <asp:DropDownList ID="ddlSalesPerson" runat="server" CssClass="FormCtrl" Width="200px">
                                                                </asp:DropDownList>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                    </td>
                                                    <td colspan="3">
                                                        <strong>OR</strong></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Chain:" Width="80px"></asp:Label></td>
                                                    <td colspan="3">
                                                        <asp:DropDownList ID="ddlChain" runat="server" CssClass="FormCtrl" Width="200px">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                    </td>
                                                    <td colspan="3">
                                                        <strong>OR</strong></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Customer:"></asp:Label></td>
                                                    <td colspan="3">
                                                        <asp:TextBox ID="txtCustNo" runat="server" CssClass="FormCtrl" Height=16px Width="195px"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Report Sort:"></asp:Label></td>
                                                    <td colspan="3">
                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td style="width: 200px">
                                                                    <asp:RadioButton ID="rdoSalesDol" runat="server" Text="Sales $" GroupName="Sort" Checked="True" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:RadioButton ID="rdoCustNo" runat="server" Text="Customer Number" GroupName="Sort" /></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100px">
                                                        <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Show Fastenal:"></asp:Label></td>
                                                    <td colspan="3">
                                                        <asp:CheckBox ID="chkFSNL" runat="server" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg" style="padding-left:60px;padding-top:3px;">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">
                                        <img id="Img1" src="../Common/Images/submit.gif" style="cursor: hand" onclick="javascript:ViewReport();" runat=server />&nbsp;
                                        <img id="btnAllBranch" src="../Common/Images/AllReport.gif" style="cursor: hand" onclick="javascript:ViewBranchReport();" runat=server />&nbsp;
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
