<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerSalesAnalysisUserPrompt.aspx.cs"
    Inherits="PFC.Intranet.CustomerSalesAnalysisUserPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Sales Analysis User Prompt</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

    <script language="javascript">

function ValidateNumber()
{
     if (window.event.keyCode < 47 || window.event.keyCode > 58) 
      window.event.keyCode = 0;
}

function CheckLength(sender,args)
{
    var validCtl=document.getElementById("csvLength");
    var fromCategory=document.getElementById("txtCatFrom");
    var toCategory=document.getElementById("txtCatTo");
    if(fromCategory.value.length==0&&toCategory.value.length==0)
        args.IsValid=true;
    else
       if(fromCategory.value.length==5&&toCategory.value.length==5)
            args.IsValid=true;
        else
        {
            args.IsValid=false;
            validCtl.innerHTML="Check the from and to category it should be 5 digits";
        }
}
function LoadHelp()
{
 window.open("../Help/HelpFrame.aspx?Name=CustomerSales",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
   
}
function ViewReport()
{
    var msg=document.getElementById("Label1");
    msg.style.display='none';
    msg.innerHTML="";
    var salesRep=document.form1.ddlRep.options[document.form1.ddlRep.selectedIndex].text.replace("'","|");
    var zipFrom=document.getElementById("txtZipFrom").value;
    var zipTo=document.getElementById("txtZipTo").value;
    var Url = "CustomerSalesAnalysis.aspx?Month=" + document.form1.ddlMonth.value + "~Year=" + document.form1.ddlYear.value + "~Branch=" + document.form1.ddlBranch.value + "~Chain=" +  document.form1.ddlChain.options[document.form1.ddlChain.selectedIndex].text.replace('&','`') + "~CustNo=" + document.form1.txtCustNo.value+"~MonthName="+document.form1.ddlMonth.options[document.form1.ddlMonth.selectedIndex].text+"~BranchName="+document.form1.ddlBranch.options[document.form1.ddlBranch.selectedIndex].text+"~SalesRep="+salesRep+"~ZipFrom="+document.form1.txtZipFrom.value+"~ZipTo="+document.form1.txtZipTo.value+ "~OrdType=" + document.form1.ddlOrdType.value;
    Url = "ProgressBar.aspx?destPage="+Url;
    
    if(zipTo!='' && zipFrom!='')
    {
        if(zipFrom>zipTo)
            alert("Zip from must be less than zip thru");
        else
            window.open(Url,"CustomerSalesAnalysis" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
    }
    else
       window.open(Url,"CustomerSalesAnalysis" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO',"");
    //window.open(Url,"CustomerSalesAnalysis" ,'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
}

function ViewCAS()
{
    
    document.getElementById("lblStatus").innerText = '';
    var Url = "../CustomerActivitySheet/FrameSet/CASFrameSet.aspx?Month=" + document.getElementById("ddlMonth").value + "&Year=" + document.getElementById("ddlYear").value + "&Branch=" + document.getElementById("ddlBranch").value + "&Chain=" +  document.getElementById("ddlChain").options[document.getElementById("ddlChain").selectedIndex].text.replace('&','||')  + "&CustNo=" + document.getElementById("txtCustNo").value.replace('&','||') +"&MonthName="+document.getElementById("ddlMonth").options[document.getElementById("ddlMonth").selectedIndex].text+"&BranchName="+document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].text+"&SalesRep="+document.getElementById("ddlRep").options[document.getElementById("ddlRep").selectedIndex].text;
    
    if(document.getElementById("txtCustNo").value!="")
    {
      var strBranch='';      
      if(document.getElementById("ddlBranch").selectedIndex =='0')
        strBranch = "0";
      else
        strBranch = document.getElementById("ddlBranch").value;
         
        Url = "../CustomerActivitySheet/FrameSet/CASFrameSet.aspx?Month=" + document.getElementById("ddlMonth").value + "&Year=" + document.getElementById("ddlYear").value + "&Branch=" + strBranch + "&Chain=" +  document.getElementById("ddlChain").options[document.getElementById("ddlChain").selectedIndex].text.replace('&','||')   + "&CustNo=" + document.getElementById("txtCustNo").value.replace('&','||') +"&MonthName="+document.getElementById("ddlMonth").options[document.getElementById("ddlMonth").selectedIndex].text+"&BranchName="+document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].text+"&SalesRep="+document.getElementById("ddlRep").options[document.getElementById("ddlRep").selectedIndex].text;    
        
        if(IsNumeric(document.form1.txtCustNo.value))
            window.open(Url,"CustomerActivitySheet" ,'height=700,width=965,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=NO',"");
        else
            OpenAlertBox();
    }
    else
    {
            var strChainvalue=document.getElementById("ddlChain").value;
            var curMonth=document.getElementById("ddlMonth").value;
            var curYear=document.getElementById("ddlYear").value;
            
            if(strChainvalue!='0')
            {
                var strCustNo=CustomerSalesAnalysisUserPrompt.GetCustomerNumber(strChainvalue,curMonth,curYear).value;
                if(strCustNo != null)
                    strCustNo=strCustNo.toString(); 
                else
                    strCustNo=""; 
                Url = "../CustomerActivitySheet/FrameSet/CASFrameSet.aspx?Month=" + document.getElementById("ddlMonth").value + "&Year=" + document.getElementById("ddlYear").value + "&Branch=0 &Chain=" +  document.getElementById("ddlChain").options[document.getElementById("ddlChain").selectedIndex].text.replace('&','||')  + "&CustNo=" + strCustNo.replace('&','||')  +"&MonthName="+document.getElementById("ddlMonth").options[document.getElementById("ddlMonth").selectedIndex].text+"&BranchName="+document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].text+"&SalesRep="+document.getElementById("ddlRep").options[document.getElementById("ddlRep").selectedIndex].text+"&CASMode=Chain";
                window.open(Url,"CustomerActivitySheet" ,'height=700,width=965,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=NO',"");
                   
            }
            else
                OpenAlertBox();
    }
        
}  
    function OpenAlertBox()
    {
         var strBranch="";
         if(document.getElementById("ddlBranch").selectedIndex =='0')
            strBranch = "0";
         else
            strBranch = document.getElementById("ddlBranch").value;
        
        var Url = "../CustomerActivitySheet/FrameSet/CASFrameSet.aspx?Month=" + document.getElementById("ddlMonth").value + "&Year=" +document.getElementById("ddlYear").value + "&Branch=" + strBranch + "&Chain=" +  document.getElementById("ddlChain").options[document.getElementById("ddlChain").selectedIndex].text.replace('&','||')  + "&MonthName="+document.getElementById("ddlMonth").options[document.getElementById("ddlMonth").selectedIndex].text+"&BranchName="+document.getElementById("ddlBranch").options[document.getElementById("ddlBranch").selectedIndex].text+"&SalesRep="+document.getElementById("ddlRep").options[document.getElementById("ddlRep").selectedIndex].text;
        Url=Url.replace(/&/g,"~");
        window.open("../CustomerActivitySheet/CustomerNoConfirm.aspx?Url="+Url,"" ,'height=180,width=355,scrollbars=no,status=no,titlebar=no,toolbar=no,menubar=no,top='+((screen.height/2) - (180/2))+',left='+((screen.width/2) - (355/2))+',resizable=NO',"");
    }




 function IsNumeric(strString)
{
   var strValidChars = "0123456789";
   var strChar;
   var blnResult = true;

   if (strString.length != 6) return false;

    //  test strString consists of valid characters listed above
    for (i = 0; i < strString.length && blnResult == true; i++)
    {
      strChar = strString.charAt(i);
      if (strValidChars.indexOf(strChar) == -1){blnResult = false;}
    }
   return blnResult;
}

function bindChain(ddlChain)
{
    var Chain=CustomerSalesAnalysisUserPrompt.GetChain().value.toString();
     var ChainValue=Chain.split("~");
       
        //
        // Clear criteria dropdown
        //
       for (var i = ddlChain.options.length; i >= 0; i--) 
       {
            ddlChain.options[i] = null; 
        }
       
        ddlChain.options[0] = new Option("All");
        for(var i=0;i<=ChainValue.length-1;i++)
        {
          if(ChainValue[i] != '')
              ddlChain.options[i+1] = new Option(ChainValue[i]);
         }
       
}

    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
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
                            <td width="100%" height="100%" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                    <tr>
                                        <td class="PageHead" style="height: 40px" width="75%">
                                            <div class="LeftPadding">
                                                <div align="left" class="BannerText">
                                                    Customer Sales Analysis Report</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText">
                                                    <img src="../Common/images/close.gif" onclick="javascript:window.location.href='ReportsDashBoard.aspx';"
                                                        style="cursor: hand" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="3" width="600">
                                                <tr>
                                                    <td>
                                                        <span class="LeftPadding">Period</span></td>
                                                    <td colspan="2">
                                                        <table>
                                                            <tr>
                                                                <td>
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
                                                                    </asp:DropDownList></td>
                                                                <td>
                                                                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="FormCtrl" Width="60px">
                                                                    </asp:DropDownList></td>
                                                                <td>
                                                                    <asp:Label CssClass="TabHead" Style="display: none;" ID="Label1" runat="server" ForeColor="Red"
                                                                        Width="300px"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <tr>
                                                        <td>
                                                            <span class="LeftPadding">Order Type</span></td>
                                                        <td colspan="2">
                                                            <asp:DropDownList ID="ddlOrdType" runat="server" CssClass="FormCtrl" Width="190px">
                                                                <asp:ListItem Text="ALL" Value="ALL"></asp:ListItem>
                                                                <asp:ListItem Text="Mill" Value="Mill"></asp:ListItem>
                                                                <asp:ListItem Text="Warehouse" Value="Non-Mill"></asp:ListItem>
                                                            </asp:DropDownList></td>
                                                    </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:UpdatePanel ID="upanel" runat="server" UpdateMode="conditional">
                                                            <ContentTemplate>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                        <td>
                                                                            <span class="LeftPadding">Branch</span></td>
                                                                        <td>
                                                                            <asp:DropDownList ID="ddlBranch" runat="server" CssClass="FormCtrl" Width="190px"
                                                                                AutoPostBack="true" OnSelectedIndexChanged="ddlBranch_SelectedIndexChanged">
                                                                            </asp:DropDownList></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 93px; padding-top: 5px;">
                                                                            <span class="LeftPadding">Sales Rep</span></td>
                                                                        <td style="padding-top: 5px;">
                                                                            <asp:DropDownList ID="ddlRep" runat="server" CssClass="FormCtrl" Width="190px">
                                                                            </asp:DropDownList></td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span class="LeftPadding">Chain</span></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlChain" onchange="javascript:document.getElementById('lblStatus').innerText='';"
                                                            runat="server" CssClass="FormCtrl" Width="190px">
                                                        </asp:DropDownList></td>
                                                    <td colspan="2">
                                                        <asp:Label Width="250" CssClass="TabHead" ForeColor="red" ID="lblStatus" runat="server"
                                                            Text=""></asp:Label></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span class="LeftPadding" style="width: 100px;">Customer #</span></td>
                                                    <td colspan="2">
                                                        <asp:TextBox ID="txtCustNo" runat="server" MaxLength="20" CssClass="FormCtrl" Width="184px"></asp:TextBox>
                                                        <asp:Label ID="lblCustno" runat="server" Text="" CssClass="Required"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span class="LeftPadding">Zip</span>
                                                    </td>
                                                    <td colspan="1">
                                                        <asp:TextBox ID="txtZipFrom" runat="server" CssClass="FormCtrl" MaxLength="20" Width="184px"></asp:TextBox></td>
                                                    <td colspan="1" width="20px">
                                                        Thru
                                                    </td>
                                                    <td colspan="1">
                                                        <asp:TextBox ID="txtZipTo" runat="server" CssClass="FormCtrl" MaxLength="20" Width="184px"></asp:TextBox></td>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>

    <script>
    document.getElementById("lblStatus").innerText="";
  
    </script>

    <tr>
        <td class="BluBg">
            <div class="LeftPadding">
                <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <img id="Img1" src="../common/images/viewReport.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;<img
                        src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                    <img id="Img2" alt="View Customer Activity Sheet" src="../customeractivitysheet/images/btn_cas.gif"
                        style="cursor: hand" onclick="javascript:ViewCAS();" />
                </span>
            </div>
        </td>
        <td class="BluBg">
        </td>
    </tr>
</body>
</html>
