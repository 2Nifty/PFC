<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VendorMaintenance.aspx.cs"
    Inherits="PFC.Intranet.VendorMaintenance.VendorMaintenance" EnableEventValidation="false" %>

<%@ Register Src="Common/UserControls/AddressInformation.ascx" TagName="AddressInformation"
    TagPrefix="uc8" %>
<%@ Register Src="Common/UserControls/AddressEntry.ascx" TagName="AddressEntry" TagPrefix="uc7" %>
<%@ Register Src="Common/UserControls/VendorLocations.ascx" TagName="VendorLocations"
    TagPrefix="uc6" %>
<%@ Register Src="Common/UserControls/VendorDetails.ascx" TagName="VendorDetails"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/VendorSearch.ascx" TagName="VendorSearch" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/VendorHeader.ascx" TagName="VendorHeader" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//ghEN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vendor Maintenance</title>
    <link href="../VendorMaintenance/Common/StyleSheet/VM_Styles.css" rel="stylesheet"
        type="text/css" />

    <script src="Common/javascript/Common.js" type="text/javascript"></script>
   

    <script language=javascript>
        function BindDetails(ctrlValue,type,mode)
        {
       
            var btnBind=document.getElementById('ucLocationNavigator_btnBindDetails');
            var hidType=document.getElementById('ucLocationNavigator_hidType');
            var hidBuy=document.getElementById('ucLocationNavigator_hidBuy');
            var hidShip=document.getElementById('ucLocationNavigator_hidShip');
            var hidMode=document.getElementById('ucLocationNavigator_hidMode');
            
            if(type=='BF')
            {
                hidType.value="BF";
                hidBuy.value=ctrlValue;
                hidShip.value="";
                hidMode.value=mode;
            }
            else
            {
            
            if(mode=='Edit' && type=='SF')
            {
                hidType.value='SF';
                hidBuy.value=ctrlValue.split('~')[0];
                hidShip.value=ctrlValue.split('~')[1];
                hidMode.value=mode;
            }
            else
            {
                hidType.value='SF';
                hidBuy.value=ctrlValue;
                hidShip.value=0;
                hidMode.value=mode;
            }
            }
            btnBind.click();
            
            return false;         
        } 
        
        function CheckLock(ctrlID)
        {
            
            var txtVend=document.getElementById(ctrlID.replace('btnSearch','txtVendor'));
            var Lock="";
            if(txtVend.value!="")
                Lock=VendorMaintenance.CheckLock(txtVend.value,document.getElementById(ctrlID.replace('btnSearch','hidSearchMode')).value).value;
            else
                return false;
                
            var length =Lock.split('~').length;
            if(length!='0')
            {
                if(Lock.split('~')[1]=='L')
                {
                    if(ShowYesorNo('Vendor '+Lock.split('~')[2]+' locked by '+Lock.split('~')[0] +' Would you like to query?' ))
                        return true;
                    else
                        return false;
                
                }     
                else if(Lock.split('~')[1]=='SL')
                   return true;
            }
            
              if(document.getElementById(ctrlID.replace('btnSearch','hidSearchMode')).value=="Vendor")
              {
                document.getElementById("hidVenType").value='Invalid';
                document.getElementById(ctrlID.replace('btnSearch','btnAdd')).click();
                return false;
              }
              else
                return false;
         }
        
        
        function DeleteVendor(obj)
        {
            var vendorID=document.getElementById("ucVendorInfo_lblVendNo").innerText;
            if(ShowYesorNo('Do you want to delete vendor# '+ vendorID + '?'))
            {
                VendorMaintenance.DeleteVendor(document.getElementById(obj.id.replace("ibtnDelete","hidVendor")).value);
                return true;
             }
             else             
                 return false;
        }
        
        function PromptNewVendor(ctrldID)
        {
            var vendValue=document.getElementById(ctrldID.replace('btnAdd','txtVendor')).value.replace(/\s/g,'');
            if(vendValue!='')
            {
                if(IsNumeric(vendValue))
                {
                    var vendorExist= VendorMaintenance.CheckVendor(vendValue).value;
                    if(vendorExist.replace(/\s/g)!="")
                    {
                        alert('Vendor number already exists!');
                        return false;
                    }
                    else
                    {
                         var msg=((document.getElementById("hidVenType").value.replace(/\s/g,'')=='Invalid')?'Vendor does not exist! would you like to create a new vendor?':'Do you want to create new a vendor?');
                        document.getElementById("hidVenType").value="";
                        if(ShowYesorNo(msg))
                            return true;
                        else
                            return false;
                    }
                }
                else
                {
                    alert('Invalid vendor number!');
                    return false;
                }
            }
            else
            {
//                    alert('Invalid data!');
//                    document.getElementById(ctrldID.replace('btnAdd','txtVendor')).focus();
//                    return false;
return true;
            }
        }
        
        function LoadHelp()
        {
            window.open("../Help/HelpFrame.aspx?Name=vendormaintenace",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");

        }
        
    </script>
    
    <script language=vbscript>
    Function ShowYesorNo(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbyesno,"Vendor Maintenance")
    if intBtnClick=6 then 
        ShowYesorNo= true 
    else 
        ShowYesorNo= false
     end if
    end Function
    </script>

</head>
<body  onmouseup="Hide();" onload="javascript:if(document.getElementById('divSearch')!=null)document.getElementById('divSearch').style.display = 'none';" onunload="Javascript:ReleaseLock();" onmouseout="javascript:if(document.getElementById('Tooltip')!=null)document.getElementById('Tooltip').style.display = 'none';">
    <form id="form1" runat="server"  >
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" width="100%" id="mainTable">
            <tr>
                <td height="5%" id="tdHeader" >
                    <uc1:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="padding-top: 1px;" >
                    <asp:UpdatePanel ID="pnlSearchVendor" runat="server" UpdateMode="conditional">
                        <ContentTemplate>                        
                            <uc4:VendorSearch ID="ucSearchVendor" runat="server"></uc4:VendorSearch>
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
                                        <uc3:VendorHeader ID="ucVendorInfo" runat="server" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td width="22%" valign="top">
                                <asp:UpdatePanel ID="pnlLocationDetails" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                    <div  style="width:220px;" ><uc6:VendorLocations ID="ucLocationNavigator" runat="server" /></div>                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td width="78%" valign="top" style="border-collapse: collapse;">
                                <asp:UpdatePanel  ID="pnlAddressInformation" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>   
                                    <div id="divAddressInfo" runat="Server"><uc8:AddressInformation ID="ucAddressInfo" runat="server" />     </div>                                  
                                         <div  id="divAddressEntry" runat="Server"><uc7:AddressEntry ID="ucAddressEntry" runat="server" /></div>                           
                                        <div  id="divVendorEntry" runat="Server"><uc5:VendorDetails ID="ucVendorEntry" runat="server" /> </div>                                                                                                       
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>  
                    </table>
                </td>
            </tr>
             <tr>
                <td  class="BluBg buttonBar" colspan="1" height="20px">
                    <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout=false>
                        <ProgressTemplate>
                            <span style="padding-left: 5px" class="boldText">Loading...</span>                         
                        </ProgressTemplate>
                    </asp:UpdateProgress><asp:UpdatePanel ID="pnlProgress"  runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                runat="server" Text=""></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel></td>
            </tr>
            <tr>
                <td >
                    <uc2:BottomFooter ID="BottomFrame2" Title="Vendor Maintenance" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
