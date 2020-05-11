<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VMIContract.aspx.cs" Inherits="VMIContractMaintenancePrompt" %>
<%@ OutputCache Duration="3600" VaryByParam="None" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
<link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <script>
    function OpenCustomerContracts(mode)
    {
         var ddl = document.getElementById("ddlContract");
         var hidChain = document.getElementById("selectedContract");
         var hidItem = document.getElementById("selectedItem");
         var url="VMIContractMaintenance.aspx";
         
        if(mode=='edit')
        {
            if(document.form1.ddlChainName.value!='0' && ddl.options[ddl.selectedIndex].text !='' && hidChain.value!='--- Select ---' && hidItem.value!='--- Select ---')
            {
                url=url+"?mode="+mode+"&ChainName=" + document.form1.ddlChainName.value.replace('&','||')+"&Contractno="+hidChain.value.replace('&','||')+"&ItemNo="+hidItem.value.replace('&','||');
                window.location.href=url;
                
            }
            else if(hidChain.value=='--- Select ---')
            {
               document.getElementById("divMessage1").innerHTML="* Required";
               document.getElementById("divMessage").style.display='none';
               document.getElementById("divMessage2").style.display='block';
            }
            else if(hidItem.value=='--- Select ---')
            {
                document.getElementById("divMessage2").innerHTML="* Required";
                document.getElementById("divMessage").style.display='none';
                document.getElementById("divMessage1").style.display='none';
            }
           
            else
            {
                document.getElementById("divMessage").innerHTML="* Required";
                document.getElementById("divMessage1").innerHTML="* Required";
                document.getElementById("divMessage2").innerHTML="* Required";
            }
        }
        else
        {
            url=url+"?mode="+mode+"&ChainName=" + document.form1.ddlChainName.value.replace('&','||')+"&Contractno=0&ItemNo=0" ;
            window.location.href=url;
        }
    }
    function LoadHelp()
    {
        window.open("../Help/HelpFrame.aspx?Name=VMIContract",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");   
    }
    function ddlChain_selectedindexChange(ddlChain)
    {
        var chainValue=document.getElementById("selectedChain").value;
        var hidChain = document.getElementById("selectedContract");
        hidChain.value = ddlChain.options[ddlChain.selectedIndex].text
        var Chain=chainValue.split(" - ")[0];
        var ItemDetail = VMIContractMaintenancePrompt.GetItemNumbers(Chain,hidChain.value).value.toString();
        var itemNumber=ItemDetail.split("~");
        var ddlItem = document.getElementById("ddlItem");
        var hidItem = document.getElementById("selectedItem");
      
        //
        // Clear criteria dropdown
        //
       for (var i = ddlItem.options.length; i >= 0; i--) 
       {
            ddlItem.options[i] = null; 
        }
       
        ddlItem.options[0] = new Option("--- Select ---");
        for(var i=0;i<=itemNumber.length-1;i++)
        {
          if(itemNumber[i] != '')
              ddlItem.options[i+1] = new Option(itemNumber[i]);
         }
        
        hidItem.value = ddlItem.options[0].text;
        
    }
        
    function ddlContract_selectedindexChange(ddlContract)
    {
        var hidItem = document.getElementById("selectedItem");
        try
        {
        hidItem.value = ddlContract.options[ddlContract.selectedIndex].text
        }
        catch(e)
        {alert(e)}
    }
    function windowclose()
    {
        var url = '<%=Session["MenuItemDashboard"]%>';
        if(url == "")
        {
            window.location.href = '../SystemFrameSet/DashBoard.aspx';
        }
        else
        {
            window.location.href= '<%=Session["MenuItemDashboard"]%>';
            <%Session["MenuItemDashboard"] =""; %>
        }
    }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <table  width="100%">
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
                                                    VMI Contract Maintenance</div>
                                            </div>
                                        </td>
                                        <td class="PageHead" style="height: 40px">
                                            <div class="LeftPadding">
                                                <div align="right" class="BannerText" style="width:250px">
                                                    <img src="../Common/images/new.gif" id="btnNew" onclick="javascript:OpenCustomerContracts('add');"
                                                        style="cursor: hand" />
                                                    </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height=80>
                                            <table border="0" cellspacing="0" cellpadding="3" width="600">
                                             
                                                <tr>
                                                    <td style="width: 117px">
                                                        <span class="LeftPadding" style="width: 100px;">Chain Name</span></td>
                                                    <td style="width: 105px">
                                                    <asp:DropDownList id="ddlChainName" runat="server" CssClass="FormCtrl" Width="150px"  onchange="GetContracts(this)" OnSelectedIndexChanged="ddlChainName_SelectedIndexChanged"  ></asp:DropDownList>                                                    
                                                    </td>
                                                    <td><div  class="Required" style="color:Red;height:20px;" id=divMessage></div></td>
                                                </tr>
                                                 <tr>
                                                    <td style="width: 117px">
                                                        <span class="LeftPadding" style="width: 100px;">Existing Contracts</span></td>
                                                    <td style="width: 105px">
                                                    <select id="ddlContract" class="FormCtrl" style="width:150px" onchange="ddlChain_selectedindexChange(this)">
                                                            <option selected="selected">--- Select ---</option>
                                                        </select>
                                                    
                                                    </td>
                                                    <td><div  class="Required" style="color:Red;height:20px;" id=divMessage1></div></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 117px">
                                                        <span class="LeftPadding" style="width: 100px;">PFC Item #</span></td>
                                                    <td style="width: 105px">
                                                    <select id="ddlItem" class="FormCtrl" style="width:150px" onchange="ddlContract_selectedindexChange(this)">
                                                            <option selected="selected">--- Select ---</option>
                                                        </select>
                                                    
                                                    </td>
                                                    <td><div  class="Required" style="color:Red;height:20px;" id=divMessage2></div></td>
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
                                    <img id="btnOk" src="../common/images/next.gif" style="cursor: hand" onclick="Javascript:OpenCustomerContracts('edit');" />&nbsp;<img
                                        src="../Common/Images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                        </span>
                            </div><input type=hidden id="selectedChain" runat=server /><input type=hidden id="selectedContract" runat=server /><input type=hidden id="selectedItem" runat=server />
                        </td>
                        
                    </tr>
</body>
</html>
<script language="javascript" type="text/javascript">
  function GetContracts(ddlChain)
  { 
  
    var hidValue=document.getElementById("selectedChain");
    hidValue.value=ddlChain.options[ddlChain.selectedIndex].text
    
    var contractDetail = VMIContractMaintenancePrompt.GetContractNumbers(ddlChain.value).value.toString();
    
    var contractNumber=contractDetail.split("~");
    var ddlContract = document.getElementById("ddlContract");
    var hidChain = document.getElementById("selectedContract");
    //
    // Clear criteria dropdown
    //
    for (var i = ddlContract.options.length; i >= 0; i--) 
    {
        ddlContract.options[i] = null; 
    }
    ddlContract.options[0] = new Option("--- Select ---");
       
    for(var i=0;i<=contractNumber.length-1;i++)
    {
        if(contractNumber[i] != '')
            ddlContract.options[i+1] = new Option(contractNumber[i]);
    }
    
    //
    // Clear ItemNumber dropdown
    //
    var ddlItem = document.getElementById("ddlItem");
    for (var i = contractNumber.length; i >= 0; i--) 
    {
        ddlItem.options[i] = null; 
    }
    ddlItem.options[0] = new Option("--- Select ---");
    hidChain.value = document.form1.ddlContract.options[0].text;
    
  }
</script>
