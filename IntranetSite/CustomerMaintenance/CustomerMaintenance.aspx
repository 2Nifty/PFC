<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerMaintenance.aspx.cs"
    Inherits="PFC.Intranet.Maintenance.CustomerMaster" EnableEventValidation="false" %>

<%@ Register Src="Common/UserControls/CreditInformation.ascx" TagName="CreditInformation"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/SalesInformation.ascx" TagName="SalesInformation"
    TagPrefix="uc7" %>
<%@ Register Src="Common/UserControls/ShippingInformation.ascx" TagName="ShippingInformation"
    TagPrefix="uc9" %>

<%@ Register Src="Common/UserControls/AddressInformation.ascx" TagName="AddressInformation"
    TagPrefix="uc8" %>
<%@ Register Src="Common/UserControls/customerLocations.ascx" TagName="Locations"
    TagPrefix="uc6" %>
<%@ Register Src="Common/UserControls/CustomerSearch.ascx" TagName="CustomerSearch" TagPrefix="uc4" %>

<%@ Register Src="Common/UserControls/customerHeader.ascx" TagName="CustomerHeader" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//ghEN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Maintenance</title>
    <link href="../CustomerMaintenance/Common/StyleSheet/Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/javascript/Common.js" type="text/javascript"></script>
   
 
<script language="javascript">
function btnSaveClick(addressSave)
{
    if(document.getElementById(addressSave.replace('btnSave','txtCustNo')).value.replace(/\s/g,'') != "" &&  document.getElementById(addressSave.replace('btnSave','txtAddress1')).value.replace(/\s/g,'')  != "" )
        {  
            return true;
        }
        else
        {
            alert("Customer Number and Address Name are mandatory");
            return false;
        }
        
//    var sdiv=false;
//    sdiv=CheckProgress("txtCustNo~spCustNo,txtAddress1~spAddress1");
//    alert(sdiv);
//    return sdiv;
}
function CheckProgress(strCheck)
{
    
    var bRequired=false;   
    if(strCheck!="")
    {
        var arrCheck=strCheck.split(",");
        
        var nCount=0;
        for(nCount=0;nCount<arrCheck.length;nCount++)
        {
           
           
            var arrControl=arrCheck[nCount].split("~");
           
            var sControlName=arrControl[0];
            var sRequired=arrControl[1];
            var sVal=document.getElementById(sControlName).value;
          
            var sReq=document.getElementById(sRequired);
            if(sVal==null || sVal=="" )
            { 
                bRequired=true;
                sReq.innerHTML="* ";
                sReq.style.display="block";
            }
            else
            {
                sReq.style.display="none";
            }
        }
    }
    if(bRequired==false)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function ValidateNumber()
{
//    if(event.keyCode<47 || event.keyCode>58)
    if(event.keyCode != 46 && (event.keyCode<48 || event.keyCode>57))
        event.keyCode=0;
}
function BindDetails(ctrlValue,type,mode)
{       

if(mode=='Edit' && type=='SH')
{
    document.getElementById("hidType").value=type;
    document.getElementById("hidAddressID").value=ctrlValue.split('~')[0];
    document.getElementById("hidCustomerID").value=ctrlValue.split('~')[1];
    document.getElementById("hidMode").value=mode;
}
else
{
    document.getElementById("hidType").value=type;
    document.getElementById("hidCustomerID").value=ctrlValue;              
    document.getElementById("hidMode").value=mode;
} 
document.getElementById("btnBindDetail").click();
return false;         
} 

function CheckLock(ctrlID)
{
var txtcust=document.getElementById(ctrlID.replace('btnSearch','txtCustomer'));
var Lock="";
if(txtcust.value!="")
{

    try
    {
        var value = eval(txtcust.value);
    }
    catch(e)
    {
        return true;
    }
    
    Lock=CustomerMaster.CheckCustomer(txtcust.value).value;
}
else
{
    alert("Please Enter Customer Number");
    return false;
}

 if(Lock !='')
   {
    var length =Lock.split('~').length;
    if(length!='0' || Lock=='' )
    {
        if(Lock.split('~')[1]=='L')
        {
            if(ShowYesorNo('Customer '+Lock.split('~')[2]+' locked by '+Lock.split('~')[0] +' Would you like to query?' ))
                return true;
            else
                return false;
        
        }     
        else if(Lock.split('~')[1]=='SL')
        {
      
           return true;
           }
    }
}
else
  { 
     document.getElementById("hidAddMode").value="Search";     
      document.getElementById(ctrlID.replace('btnSearch','btnAdd')).click();
    return false;
  }             
}

 function LoadCustomerLookup(_custNo,_control)
{   
    var Url = "CustomerList.aspx?ctrlName="+_control+"&Customer=" + _custNo;
    window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (465/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
}

function AddNewCustomer(btnadd)
{

var msg="";               
if(document.getElementById(btnadd.replace('btnAdd','txtCustomer')).value!='')
{ 
   if(document.getElementById("hidAddMode").value != 'Search')
      msg='Do you want to create new Customer?';  
   else
      msg='Customer does not exist! would you like to create a new Customer?';                
       
   if(ShowYesorNo(msg))
   {
   if(document.getElementById("hidAddMode").value!="Search")
   {
    var txtcust=document.getElementById(btnadd.replace('btnAdd','txtCustomer'));
    var Lock="";
    if(txtcust.value!="")
        Lock=CustomerMaster.CheckCustomer(txtcust.value).value;      
    if(Lock=='')
        return true;
    else
    {
    document.getElementById(btnadd.replace('btnAdd','txtCustomer')).focus();
    document.getElementById(btnadd.replace('btnAdd','txtCustomer')).select();
        alert("Customer Number already exist");
        return false;
    }    
   }
   else               
     return true;
     }
   else
     return false;
}
else
return false;
 
}

function LoadHelp()
{
window.open("../Help/HelpFrame.aspx?Name=Customermaintenace",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
}
         
function CloseWindow()
{ 
 window.open("Release.aspx",'Release','height=5,width=5,scrollbars=no,location=no,status=no,top=0,left=0,resizable=no',"");
}
 
</script>
    
<script language=vbscript>
    Function ShowYesorNo(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbyesno,"Customer Maintenance")
    if intBtnClick=6 then 
        ShowYesorNo= true 
    else 
        ShowYesorNo= false
     end if
    end Function
</script>

</head>
<body   onclick="javascript:document.getElementById('lblMessage').innerText='';" onunload="javascript:CloseWindow();"  onmouseup="Hide();" onload="javascript:if(document.getElementById('divSearch')!=null)document.getElementById('divSearch').style.display = 'none';"  onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" AsyncPostBackTimeout="360000"  EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" >
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;" >
                    <asp:UpdatePanel ID="pnlSearchCustomer"  runat="server" UpdateMode="conditional">
                        <ContentTemplate>  
                            <input type=hidden id="hidAddMode"  />                      
                            <uc4:CustomerSearch ID="ucSearchCustomer" runat="server"></uc4:CustomerSearch>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td >
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                        <tr>
                            <td valign="top" colspan="2" class="blueBorder shadeBgDown">
                                <asp:UpdatePanel ID="pnHeaderDetails" runat="server"  UpdateMode="conditional">
                                    <ContentTemplate>
                                        <uc3:CustomerHeader ID="ucCustomerHeader" runat="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td width="22%" valign="top">
                                <asp:UpdatePanel ID="pnlLocationDetails" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                    <div  style="width:220px;" ><uc6:Locations ID="ucLocation" runat="server" /></div>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td width="78%" valign="top" style="border-collapse: collapse;">
                                <asp:UpdatePanel ID="pnlAddressInformation" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div id="divLink" runat=server>                                          
                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                <tr runat="server" id="tblLink">
                                                    <td class="lightBlueBg" style="padding-left: 20px;" colspan="2" height="25" nowrap="nowrap">
                                                        <table class="DarkBluTxt boldText">
                                                            <tr>
                                                                <td style="width:60px;">
                                                                    <asp:LinkButton ID="lnkAddress" runat="server" CausesValidation="false" CommandArgument="Address" OnClick="lnkOptions_Click">Address</asp:LinkButton></td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkCredit" runat="server" CausesValidation="false" CommandArgument="Credit" OnClick="lnkOptions_Click">Credit</asp:LinkButton></td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkSales" runat="server" CausesValidation="false" CommandArgument="Sales" OnClick="lnkOptions_Click">&nbsp;&nbsp;&nbsp;Sales</asp:LinkButton></td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkShipping" runat="server" CausesValidation="false" CommandArgument="Shipping" OnClick="lnkOptions_Click">&nbsp;&nbsp;&nbsp;Shipping</asp:LinkButton></td>
                                                            
                                                                 <td>
                                                                    <asp:Button ID="btnBindDetail" runat="server" CausesValidation="false" style="display:none;" Text="bindDetail" OnClick="btnBindDetail_Click"></asp:Button></td>
                                                                    <td style="display:none;">
                                                                        <asp:HiddenField ID="hidCustomerID" runat="server" />
                                                                        <asp:HiddenField ID="hidAddressID" runat="server" />
                                                                        <asp:HiddenField ID="hidType" runat="server" />
                                                                        <asp:HiddenField ID="hidMode" runat="server" />
                                                                    </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                       <div style="overflow-y:auto;overflow-x:hidden;height:401px;position:relative;width:790px;" class="Sbar">
                                       <table cellpadding=0 cellspacing=0 width=99%><tr><td><div id="divAddressInfo" runat="Server">
                                            <uc8:AddressInformation ID="ucAddressInfo" runat="server" />
                                        </div>
                                        <div id="divCredit" runat="Server" style="display:none;height:100%;">
                                            <uc5:CreditInformation ID="ucCredit" runat="server" />
                                        </div>
                                        <div id="divSales" runat="Server" style="display:none;">
                                            <uc7:SalesInformation ID="ucSales" runat="server" />
                                        </div>
                                        <div id="divShipping" runat="Server" style="display:none;height:100%;">
                                            <uc9:ShippingInformation ID="ucShipping" runat="server" />
                                        </div></td></tr></table> </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>  
                    </table>
                </td>
            </tr>
             <tr>
                <td  class="BluBg buttonBar" colspan="1" height="20px">
                    <asp:UpdateProgress ID="upPanel" runat="server" DisplayAfter=1>
                        <ProgressTemplate>
                            <span style="padding-left: 5px" class="boldText">Loading...</span>                         
                        </ProgressTemplate>
                    </asp:UpdateProgress><asp:UpdatePanel ID="pnlMessage"  runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="green" Font-Bold="true"
                                runat="server" Text=""></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel></td>
            </tr>
            <tr>
                <td >
                    <uc2:BottomFooter ID="BottomFrame2" Title="Customer Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
