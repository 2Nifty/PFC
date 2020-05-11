<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="OrderEntry.aspx.cs"
    Inherits="OrderEntryPage" %>

<%@ Register Src="Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/CommonLink.ascx" TagName="CommonLink" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/OrderEntrydatepicker.ascx" TagName="Orderdatepicker"
    TagPrefix="uc6" %>
<%@ Register Src="Common/UserControls/ItemControl.ascx" TagName="ItemControl" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/ItemFamily.ascx" TagName="ItemFamily" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js"></script>

    <script src="Common/JavaScript/ContextMenu.js"></script>

    <script src="Common/JavaScript/ItemBuilder.js"></script>

    <script src="Common/JavaScript/PFCCustomer.js"></script>

    <script src="Common/JavaScript/PFCItemDetail.js"></script>

    <script src="Common/JavaScript/shortcut.js"></script>

    <script src="Common/JavaScript/OrderEntry.js"></script>

    <script>
    function DeleteConfirmation()
    {
       var soid=document.getElementById("CustDet_txtSONumber").value;
       if(soid !="")
       {
//          if(confirm('Are you sure you want to delete Order '+document.getElementById("CustDet_txtSONumber").value +'?'))
//          {
            var orderType =window.open ("DeleteReason.aspx" ,"Delete",'height=140,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
            orderType.focus();           
//          }
//          else
//          {
//            return false;
//          } 
       }
       else
          return false; 
    }
    
    function OpenOrderTypeUpdate()
    {
        var orderType =window.open ("PendingOrderSubType.aspx" ,"PendingOrderSubType",'height=230,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (230/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
         orderType.focus();
    }
    
    // Grid line Qty update
    function SetReqValue(ctlValue,ctlId)
    {
     
        var strQty=ctlValue;
        if(document.getElementById(ctlId.replace("txtQty","hidReqQty")).value != ctlValue)
        {
            var strCtlID=ctlId;            
            
            var strItemNo=document.getElementById(ctlId.replace("txtQty","lblPFCItemNo")).innerHTML;
            var strPrice=document.getElementById(ctlId.replace("txtQty","txtUnitPrice")).value;
            var strID=document.getElementById (strCtlID.replace("txtQty","lblQuoteNo")).innerHTML ;
            var strGrossWt=document.getElementById(ctlId.replace("txtQty","hidGrossWt")).value;
            var strLoc=document.getElementById(ctlId.replace("txtQty","lblLocCode")).innerHTML;
            var strBaseUOMQty=document.getElementById(ctlId.replace("txtQty","lblBaseUOMQty")).innerHTML;
            var lineNumber=document.getElementById(ctlId.replace("txtQty","hidLineNumber")).value;            
            var itemDetail=OrderEntryPage.GridCheckAvailability(strItemNo,strQty,strLoc).value;
            var qtyShipped = document.getElementById(ctlId.replace("txtQty","hidQtyShipped")).value;            
            
            if(strLoc != '')
            {
                if(itemDetail =="" || document.getElementById("hidSubType").value >"50") //For RGA order
                {
                   UpdateReqQty(strID,strQty,strPrice,strItemNo,strLoc,strBaseUOMQty,lineNumber,ctlId,qtyShipped); 
                }
                else if(itemDetail =="NoStock")
                {
                    if(ShowYesorNo('Requested Quantity not available.Do you want to continue?'))
                    {
                        UpdateReqQty(strID,strQty,strPrice,strItemNo,strLoc,strBaseUOMQty,lineNumber,ctlId,qtyShipped);
                    } 
                    else
                    {
                        document.getElementById(ctlId).focus();
                        document.getElementById(ctlId).select();
                    }         
                }
                else
                {
         
                    document.getElementById('lblMessage').innerText =itemDetail;
                    document.getElementById(ctlId).focus();
                    document.getElementById(ctlId).select();
                } 
            }
            else
            {
                alert('Invalid Location. Please delete this line and reenter.');
                document.getElementById(ctlId).value = document.getElementById(ctlId.replace("txtQty","hidReqQty")).value
            }
        }
    }
    
    function UpdateItemValue(ctlId,mode)
    { 
        var strCd=document.getElementById(ctlId).value;        
        var strID=document.getElementById(ctlId.replace("ddlCarrier","lblQuoteNo").replace("ddlFreight","lblQuoteNo")).innerHTML;
        OrderEntryPage.UpdateItemValue(strID,strCd,mode); 
    }
    
    // Grid line Qty update
    function UpdateReqQty(strID,strQty,strPrice,strItemNo,strLoc,strBaseUOMQty,lineNumber,ctlId,qtyShipped)
    {
            var status = OrderEntryPage.UpdateReqQty(strID,strQty,strPrice,strItemNo,strLoc,strBaseUOMQty,lineNumber,qtyShipped,'QTY').value;       
            if(status =="")
            {
                document.getElementById('hidGridCurControl').value=ctlId;
                CallBtnClick('btnGrid');
            }
            else
            {
                alert(status);
                document.getElementById(ctlId).focus();
                document.getElementById(ctlId).select();
            }
    }
    
    // Grid line sell price update
    function UpdateUnitPrice(ctlValue,ctlId)
    {    
       
         if(document.getElementById(ctlId.replace("txtSellPrice","hidPrice")).value != ctlValue)
        {          
            var strQty=document.getElementById(ctlId.replace("txtSellPrice","txtQty")).value;   
            var pSODetailID=document.getElementById(ctlId.replace("txtSellPrice","lblQuoteNo")).innerHTML;   
            var strItemNo=document.getElementById(ctlId.replace("txtSellPrice","lblPFCItemNo")).innerHTML;
            var strLoc=document.getElementById(ctlId.replace("txtSellPrice","lblLocCode")).innerHTML;
            var strBaseUOMQty=document.getElementById(ctlId.replace("txtSellPrice","lblBaseUOMQty")).innerHTML;
            var lineNumber=document.getElementById(ctlId.replace("txtSellPrice","hidLineNumber")).value;
            var status = OrderEntryPage.UpdateReqQty(pSODetailID,strQty,ctlValue,strItemNo,strLoc,strBaseUOMQty,lineNumber,'','PRICE').value;
             if(status =="")
            {
            document.getElementById('hidGridCurControl').value=ctlId.replace("txtSellPrice","txtQty");
            CallBtnClick('btnGrid');
            }
            else
            {
                alert(status);
                document.getElementById(ctlId).focus();
                document.getElementById(ctlId).select();
            }
        }
    }
    var ctrlID;
    // function for open list control for common link control
    function OpenWindow(object)
    {
        if(document.getElementById("pnlink").disabled)
            return false;
            
        if(object !=null)
        {
            ctrlID= object.id;
            document.getElementById("hidCurrentControl").value = object.id.split('_')[0];
            document.getElementById("btnGet").click();
        }
        else        
            document.getElementById("hidCurrentControl").value = "";
            
        return false;            
    }
    
    function OpenLineHeaderWindow(object,mode)
    {   
        if(document.getElementById("pnlink").disabled)
            return false;
            
        if(object !=null)
        {            
            if( document.getElementById("hidLineCount").value!="" 
                && document.getElementById("hidLineCount").value!="0"
                && document.getElementById('pnlink').disabled == false)
                
            {
                if(ShowYesorNo('Changing the header '+mode+' will change the '+mode+' for each line. Do you want to proceed?'))
                {                     
                    ctrlID= object.id;
                    document.getElementById("hidCurrentControl").value = object.id.split('_')[0];
                    document.getElementById("btnGet").click();
                }
             
            }
            else 
            {
                ctrlID= object.id;
                document.getElementById("hidCurrentControl").value = object.id.split('_')[0];
                document.getElementById("btnGet").click();
            }
        }
        else        
            document.getElementById("hidCurrentControl").value = "";
            
        return false;            
    }
    
    // Update entered value in common link control textbox
    function UpdateValue(object)
    {
        if(object !=null)
        { 
            if( object.id.split('_')[0] == "ucShipFrom" && object.value == '')
            {
                alert("Invalid Ship From");
                object.focus();
                return false;
            }           
            
            if(object.value != document.getElementById(object.id.replace('lblValue','hidMode')).value)
            {               
                document.getElementById(object.id.replace('lblValue','hidMode')).value=object.value;
                ctrlID= object.id;
                document.getElementById("hidCurrentControl").value = object.id.split('_')[0];
                
                document.getElementById("btnUpdateValue").click();               
            }
        }
        else  
            document.getElementById("hidCurrentControl").value = "";
        return false; 
    }
    
    // Update entered value in common link control textbox
    function UpdateLineHeaderValue(object,mode)
    {
        if(object !=null)
        {  
            if( object.id.split('_')[0] == "ucCarrierCode" && object.value == '')
            {
                alert("Invalid Carrier Cd.");
                object.focus();
                return false;
            }
            else if( object.id.split('_')[0] == "ucFreightCode" && object.value == '')
            {
                alert("Invalid Freight Cd.");                
                object.focus();                
                return false;
            }
            
            if(object.value != document.getElementById(object.id.replace('lblValue','hidMode')).value)
            { 
                if(document.getElementById("hidLineCount").value!="" &&  document.getElementById("hidLineCount").value!="0")
                {
                    if(ShowYesorNo('Changing the header '+mode+' will change the '+mode+' for each line. Do you want to proceed?'))
                    {   
                        document.getElementById(object.id.replace('lblValue','hidMode')).value =object.value;
                        ctrlID= object.id;
                        document.getElementById("hidCurrentControl").value = object.id.split('_')[0];
                        document.getElementById("btnUpdateValue").click();
                    }
                }
                else
                {
                    document.getElementById(object.id.replace('lblValue','hidMode')).value =object.value;
                    ctrlID= object.id;
                    document.getElementById("hidCurrentControl").value = object.id.split('_')[0];
                    document.getElementById("btnUpdateValue").click();
                }
            }
        }
        else        
            document.getElementById("hidCurrentControl").value = "";
        return false; 
    }
    
    //PO Validation
    function POAlert()
    {
        alert("Please Enter PO Number");
        document.getElementById("txtPO").focus(); 
        document.getElementById("txtPO").select(); 
    }
    
    // Tool tip function
    function ShowToolTip()
    {
        xstooltip_show('divToolTip',ctrlID,289, 49);
        return false;       
    }
    
    // Tool tip function
    function Hide()
    {
        xstooltip_hide('divToolTip');           
    }
    
    // Show grid header search textbox
    function HideHeader(id)
    {
        if(document.getElementById("trItemText").style.display !="none")
        {
            
             document.getElementById("tdUsage").style.display="none";
             document.getElementById("trPoDet").style.display="none";
             document.getElementById("tdPODet").style.display="none";
             document.getElementById("trItemText").style.display="none";
             document.getElementById("tdButton").style.width="100%";
             document.getElementById("tblGrid").style.height="400px";
             document.getElementById("divdatagrid").style.height="400px";
             //document.getElementById("ibtnHideheader").src="Common/Images/expt.gif";
             document.getElementById("trCodeDet").style.display="none";
        }
        else
        {
             document.getElementById("tdUsage").style.display="";
             document.getElementById("trCodeDet").style.display="";
             document.getElementById("tdPODet").style.display="";
             document.getElementById("trPoDet").style.display="";
             document.getElementById("trItemText").style.display="";
             document.getElementById("tdButton").style.width="35%";
             document.getElementById("tblGrid").style.height="230px";
             document.getElementById("divdatagrid").style.height="230px";
             //document.getElementById("ibtnHideheader").src="Common/Images/expand.gif";
        }
        return false;
    }
    
    // Enable Search function
    function ShowSearch(id)
    {
        var height = document.getElementById("divdatagrid").style.height.replace('px','');
        
        if(document.getElementById(id).style.display !="none")
        {
            document.getElementById(id).style.display="none";
            document.getElementById("divdatagrid").style.height=Number(height)+Number(20);            
        }
        else
        {   
            document.getElementById("divdatagrid").style.height= Number(height)-Number(20);
            document.getElementById(id).style.display="";  
            document.getElementById("txt_Item").select();   
            document.getElementById("txt_Item").focus();   
        }     
    }
    
    // load Orders
    function LoadDetails()
    {
        var userStatus=OrderEntryPage.CheckUserLogin(SOEid).value;
        if(userStatus =="true")
        {
            return CallBtnClick('btnSetOrderType');
        }
        else
        {
           if(ShowYesorNo('This Order created by different user. Do you want to change this order?'))
            { 
                document.getElementById("hidisDifferentUser").value="true";
                CallBtnClick('CustDet_btnLoadAll'); 
            }
            else
                CallBtnClick('ibtnClear');
        }
        
        setTimeout('SetGridHeight("Common")',1000); 
    }
    
    // load Orders
    function LoadOrder(SOEid)
    {
        document.getElementById("CustDet_hidSOFindSOid").value = SOEid;
         var itemDetail=OrderEntryPage.CheckOrderLock(SOEid).value;
         
          if((itemDetail!=null || itemDetail!='undefined') && itemDetail != null)
         { 
            if(itemDetail[1]=="L")
            {
            
                if(ShowYesorNo('Order '+SOEid+' locked by '+itemDetail[0] +' Would you like to query?'))
                {
                    CallBtnClick('CustDet_btnLoadAll'); 
                }
            }
            else
            {                
                var userStatus=OrderEntryPage.CheckUserLogin(SOEid).value;                  
                if(userStatus =="true")
                {
                CallBtnClick('CustDet_btnLoadAll'); 
                }
                else
                {
                   if(ShowYesorNo('This Order created by different user. Do you want to change this order?'))
                    { 
                     document.getElementById("hidisDifferentUser").value="true";
                        CallBtnClick('CustDet_btnLoadAll'); 
                    }
                    else
                        CallBtnClick('ibtnClear');
                }                
            }            
         }
    }
    
    // load Orders
     function LoadDetails(SOEid)
    {
        // save to hidden valur, because not able to change the SO textbox viewstate value using javascript
        // Hidden value used in Header.ascx load event            
        document.getElementById("CustDet_hidSOFindSOid").value = SOEid;
            
        var preValue=document.getElementById('CustDet_hidPreviousValue').value;
        
        if(preValue!=SOEid)
        { 
            DoUnload();
            
            var itemDetail=OrderEntryPage.CheckLock(SOEid).value;
            if((itemDetail!=null || itemDetail!='undefined') && itemDetail != null)
            { 
                if(itemDetail[0]=="Multiple")
                {
                    OpenOrderTypeDialog(SOEid);
                }
                else if(itemDetail[0]=="Single")
                {
                    if(itemDetail[2]=="L")
                    {
                
                        if(ShowYesorNo('Order '+SOEid+' locked by '+itemDetail[1] +' Would you like to query?' ))
                        {
                            var userStatus=OrderEntryPage.CheckUserLogin(SOEid).value;
                            if(userStatus =="true")
                            {
                                CallBtnClick('CustDet_btnLoadAll'); 
                            }
                            else
                            {
                                if(ShowYesorNo('This Order created by different user. Do you want to change this order?'))
                                { 
                                    document.getElementById("hidisDifferentUser").value="true";
                                    CallBtnClick('CustDet_btnLoadAll'); 
                                }
                                else
                                    CallBtnClick('ibtnClear');
                            }
                    } 
                    else
                    {
                        document.getElementById('CustDet_txtSONumber').focus();
                        document.getElementById('CustDet_txtSONumber').select();    
                    }            
                }
                else
                {
                    var userStatus=OrderEntryPage.CheckUserLogin(SOEid).value;
                    if(userStatus =="true")
                    {
                    CallBtnClick('btnSetOrderType');
                    }
                    else
                    {
               
                       if(ShowYesorNo('This Order created by different user. Do you want to change this order?'))
                        { 
                            document.getElementById("hidisDifferentUser").value="true";
                            CallBtnClick('btnSetOrderType'); 
                        }
                        else
                            CallBtnClick('ibtnClear');
                    }
                }
            }
            else 
                document.getElementById("lblMessage").innerText="Invalid Sales Order Number";
                }
      }
       
      return false;
    }
   
    function temp()
    {
        self.focus();
                
        //document.getElementById("lblSalesHead").focus(); 
        setTimeout('LoadDetails(document.getElementById("CustDet_txtSONumber").value)',5000);
        
    }
    // Load Order
    function LoadOrderDetails(orderNUmber)
    {
        document.getElementById("CustDet_hidSOFindSOid").value = orderNUmber;
        return CallBtnClick('CustDet_btnLoadAll');
    }
        
    // Open multiple Orders
    function OpenOrderTypeDialog(orderNo)
    {
        var orderType =window.open ("OrderType.aspx?OrderNo="+orderNo ,"OrderType",'height=380,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
        orderType.focus();        
    }
    
    // Check Qty availability
    function CheckAvailability(qty)
    {
        document.getElementById("hidCmdSourceControl").value = "Qty"; // Based  on this value the cursor focus will varies in the cmd line
        
        var itemDetail=OrderEntryPage.CheckAvailability(document.getElementById("txtINo1").value,qty,document.getElementById("txtCmdShipLoc").value).value;
        if(itemDetail =="" || document.getElementById("hidSubType").value >50)
        {
            CallBtnClick("btnQtyUpdate");
        }
        else if(itemDetail =="NoStock")
        { 
            if(ShowYesorNo('Requested Quantity not available.Do you want to continue?'))
            {
                CallBtnClick("btnQtyUpdate");
            }
            else
            { 
 
                CallBtnClick("btnClearItem"); 
            }
        }
        else
        {
            document.getElementById('lblMessage').innerText =itemDetail;
            document.getElementById("txtReqQty").focus();
            document.getElementById("txtReqQty").select();
        }
    } 
    
    // Method called when ship loc modified in command line
    function CheckAvailabilityByLocation(qty)
    {
        document.getElementById("hidCmdSourceControl").value = "Location"; // Based  on this value the cursor focus will varies in the cmd line
        
        if((document.getElementById("hidOrgShipLoc").value != document.getElementById("txtCmdShipLoc").value) && document.getElementById("txtINo1").value!= "" && qty != "")
        {
            var itemDetail=OrderEntryPage.CheckAvailability(document.getElementById("txtINo1").value,qty,document.getElementById("txtCmdShipLoc").value).value;
            if(itemDetail =="" || document.getElementById("hidSubType").value >50)
            {
                document.getElementById("hidOrgShipLoc").value = document.getElementById("txtCmdShipLoc").value;
                CallBtnClick("btnQtyUpdate");                
            }
            else if(itemDetail =="NoStock")
            { 
                if(ShowYesorNo('Requested Quantity not available.Do you want to continue?'))
                {
                    document.getElementById("hidOrgShipLoc").value = document.getElementById("txtCmdShipLoc").value;
                    CallBtnClick("btnQtyUpdate");                    
                }
                else
                { 
                    CallBtnClick("btnClearItem"); 
                }
            }
            else
            {
                document.getElementById('lblMessage').innerText =itemDetail;
                document.getElementById("txtReqQty").focus();
                document.getElementById("txtReqQty").select();
            }
        }
        else // if user press tab or enter key without changing the location
        {
            if(event.keyCode == 9)
                document.getElementById("txtQuoteRemark").focus();
            else if(event.keyCode == 13)
                CallBtnClick('btnPriceUpdate'); 
        }      
    } 
    
    // Update PO
    function LoadPO(POvalue)
    {   
        if(document.getElementById("CustDet_txtCustNo").value!="" &&document.getElementById("CustDet_txtSONumber").value!="")
        { 
            if(POvalue.trim()!="" || document.getElementById("hidPORequired").value == "false")
            {
                 // Call the server side function to insert the PO # in SOE Header table
                 OrderEntryPage.UpdatePONum(POvalue,document.getElementById("CustDet_txtSONumber").value).value;
            } 
            else
            {
                alert("Please Enter PO Number");
                document.getElementById('txtPO').focus();
            }     
        }        
    }
    
    // Update Certs Required
    function LoadCert(CertChkBox)
    {   
        if(document.getElementById("CustDet_txtCustNo").value!="" &&document.getElementById("CustDet_txtSONumber").value!="")
        { 
            // Call the server side function to update the Cert indicator in SOE Header table
            OrderEntryPage.UpdateCert(CertChkBox.checked,document.getElementById("CustDet_txtSONumber").value).value;
        }        
    }
    
    // Open Customer look up
    function LoadCustomerLookup(_custNo)
    {   
        var Url = "CustomerList.aspx?Customer=" + _custNo;
        window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
    }
    
    // Open Order type pop up while click on Make order button
    function OpenMakeOrderType()
    {
        if(document.getElementById("hidSubType").value=="52")
        {
            ExpenseOnlyOrder();
        }
        else
        {
            var _subTypeValue = parseInt(document.getElementById("hidSubType").value);
            if( _subTypeValue >= 51 && _subTypeValue<=98) // Don't Open the Order Type pop-up for these kind of orders
            {
                document.getElementById("hidMOrderType").value = "";
                CallBtnClick("imgMakeOreder");
            }            
            else
            {
                var makeOrder =window.open("MakeOrder.aspx?OrderNo="+document.getElementById('CustDet_txtSONumber').value ,"MakeOrder",'height=200,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
                makeOrder.focus();  
            }
        }   
    }
    
    function ExpenseOnlyOrder()
    {
        if(ShowYesorNo("No lines on this order, would you like to proceed?"))
        {
            document.getElementById("hidMOrderType").value = "";
            CallBtnClick("imgMakeOreder");            
        }
        else
        {
            CallBtnClick("ibtnClear");
        }
    }
    </script>

    <script>
        function LoadExpense()
        {
            if(document.getElementById("hidExpenseReadOnly").value =="false")
            {
                 if(parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value !="")
                {  
                    popUp=window.open ("EnterExpenses.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value,"EnterExpenses",'height=470,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
                }
                 else
                    alert("Enter SO Number");
            }
            else
               alert("This Order is not editable."); 
        }
        
        function LoadComment()
        {
            if(parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value !="")
            { 
                var itemno = '';
                var lineNo = '';
                //
                // If user selected any item fromm the grid pass it to comments page
                //
                
                if(parent.bodyFrame.form1.document.getElementById('hidShowLineComments').value == 'true' && parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
                {
                    var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
                    lineNo = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','hidLineNumber')).value;
                    itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
                    parent.bodyFrame.form1.document.getElementById('hidShowLineComments').value = 'false';                                       
                }
                       
                popUp=window.open ("CommentEntry.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value+"&InvoiceDate="+parent.bodyFrame.form1.document.getElementById("txtInvDate").innerHTML+"&ItemNo=" + itemno +"&LineNo=" +lineNo,"Maximize",'height=590,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (590/2))+',left='+((screen.width/2) - (714/2))+',resizable=YES',"");
                popUp.focus();
            }
            else
                alert("Enter SO Number");
        }
        
        function OpenPriceWorkSheet()
        {
            if(event.keyCode==107)
            {
                var itemNo=document.getElementById("txtINo1").value;
                OrderEntryPage.CreateItemSession(itemNo);
                OpenWorkSheet();
                  document.getElementById("txtINo1").value = "";
                return false;
            }
            else
            {
            MenuShortCuts();
            }
        }
       
       function ShowPromoCd()
        {
            if(document.getElementById("hidExpenseReadOnly").value =="false")
            {
                 if(parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value !="")
                {  
                    popUp=window.open ("PromotionCode.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value,"EnterExpenses",'height=120,width=314,scrollbars=no,status=no,top='+((screen.height/2) - (200/2))+',left='+((screen.width/2) - (300/2))+',resizable=NO',"");
                    popUp.focus();
                }
                 else
                    alert("Enter SO Number");
            }
            else
               alert("This Order is not editable."); 
        }
    </script>

    <script language="vbscript">
    Function ShowYesorNo(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbyesno,"Sales Order Entry")
    if intBtnClick=6 then 
        ShowYesorNo= true 
    else 
        ShowYesorNo= false
     end if
    end Function
    </script>

    <script type="text/javascript">
    function OpenOrganisationComments(obj)
    { 
        var custno=document.getElementById(obj.id.replace('lblCustomerCaption','txtCustNo')).value; 
        var Org= window.open('MaintenanceApps/OrganisationStandardComments.aspx?CustNumber='+custno ,'OSC','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');				    
        Org.focus();
        return false;
    }
    function OpenSOFind()
    {
        var popUp=window.open("SOFind.aspx","SOFind",'height=600,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (590/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
        return false;
    }

    //Invoice 

    function AvailInvoice(orderNo)
    {
    var hwin=window.open('AvailableInvoice.aspx?OrderNo='+orderNo,'AvailableInvoice','height=350,width=400,toolbar=0,scrollbars=0,status=0,resizable=YES,top='+((screen.height/2) - (350/2))+',left='+((screen.width/2) - (400/2)));
    hwin.focus();
    }
    
    function GetInvoice(InvoiceNo)
    {
    var popup= window.open("GetInvoice.aspx?InvoiceNo="+InvoiceNo+"&CustomerNo=","Invoice",'height=727,width=890,toolbar=0,scrollbars=no,status=0,resizable=YES,top='+((screen.height/2) - (730/2))+',left='+((screen.width/2) - (890/2))+'','');
    popup.focus();
    }
    
    //Shipper 
    // Added by Slater for WO1540
    function AvailShipper(orderNo)
    {
    var hwin=window.open('AvailableShipper.aspx?OrderNo='+orderNo,'AvailableShipper','height=350,width=400,toolbar=0,scrollbars=0,status=0,resizable=YES,top='+((screen.height/2) - (350/2))+',left='+((screen.width/2) - (400/2)));
    hwin.focus();
    }
    
    function RemoveHold()
    {   
        var freightCd = document.getElementById("ucFreightCode_lblValue").value;        
        var _isPromptNeeded = OrderEntryPage.CheckForFreightCdPrompt(freightCd).value;
        
        if( _isPromptNeeded == true &&
            ShowYesorNo("Are Prepay and Add charges needed?"))
        {
            // don't remove the hold & expense page
            LoadExpense();
            return;
        }   
        
        CallBtnClick('btnRemoveHI');
    }
    </script>

    <title>Order Entry</title>
</head>
<body bgcolor="#ECF9FB" onkeydown="javascript:return OpenPriceWorkSheet();" onclick="Javascript:ClearControls();"
    scroll="no" onload="javascript:document.getElementById('CustDet_txtCustNo').focus();if(window.opener!=null)window.opener.close();" onunload="doUnload()">
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager ID="SMOrderEntry" AsyncPostBackTimeout="360000" runat="server"
                EnablePartialRendering="true">
            </asp:ScriptManager>
            <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%">
                <tr>
                    <td valign="top">
                        <uc1:Header ID="CustDet" runat="server"></uc1:Header>
                    </td>
                    <td rowspan="2" valign="top" class="lightBg" id="tdUsage" style="padding-left: 2px;
                        width: 190px;">
                        <asp:UpdatePanel ID="pnlSOSummary" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table border="0" cellpadding="0" cellspacing="2" width="90%" style="height: 100%;
                                    line-height: 19px">
                                    <tr height="25">
                                        <uc4:CommonLink ID="lnkUsageInfo" runat="server" Text="" ColumnNames="LOCID as Code,LOCID + ' - ' + [LocName] as Name"
                                            ContentWidth="40" LinkText="Usage From" TableName="LocMaster" ISDefault="false"
                                            IsLineEditable="true" TextField="Name" ValueField="Code" WhereClause=" UsageLocInd='A' OR UsageLocInd='I' " />
                                        <td>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 2px; width: 90px;">
                                            <asp:Label ID="lblSalesHead" runat="server" CssClass="TabHead" Text="Total Sales $:"
                                                Font-Bold="True"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:Label ID="lblSales" runat="server" CssClass="lblbox" Text=""></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 2px;">
                                            <asp:Label ID="lblGp" runat="server" CssClass="TabHead" Font-Bold="True" Text="Total Gp$/Lb:"></asp:Label></td>
                                        <td style="height: 14px;" colspan="2">
                                            <asp:Label ID="lblTotGPLb" runat="server" CssClass="lblbox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 2px;">
                                            <asp:Label ID="Label3" runat="server" CssClass="TabHead" Font-Bold="True" Text="Total Weight:"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:Label ID="lblTotalWeight" runat="server" CssClass="lblbox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 3px;">
                                            <asp:Label ID="lnkOrderStsCaption" runat="server" Font-Bold="True" Text="Ord Status:"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:HyperLink ID="lblOrdSts" runat="server" CssClass="lblbox" Font-Bold="true" Text=""></asp:HyperLink>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 3px;">
                                            <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="WH Status:"></asp:Label></td>
                                        <td colspan="2">
                                            <asp:Label ID="lblWhs" runat="server" CssClass="lblbox" Text=""></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 3px;">
                                            <asp:LinkButton ID="lnbtnExpense" runat="server" Font-Underline="false" Font-Bold="True"
                                                OnClientClick="javascript:LoadExpense();" Text="Expenses"></asp:LinkButton>
                                        </td>
                                        <td colspan="2">
                                            <asp:LinkButton ID="lnbtnComments" runat="server" Font-Underline="false" Font-Bold="True"
                                                OnClientClick="javascript:LoadComment();" Text="Comments"></asp:LinkButton>
                                            <asp:Button ID="btnCheckExpComment" runat="server" OnClick="btnCheckExpComment_Click"
                                                Style="display: none" Text="" /></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 2px;">
                                            <asp:LinkButton ID="lnbtnTax" runat="server" Font-Underline="false" Font-Bold="True"
                                                OnClientClick="javascript:return false; alert('Under Construction')" Text="Taxes"></asp:LinkButton></td>
                                        <td colspan="2">
                                            <asp:LinkButton ID="lnkPromoCd" runat="server" Font-Bold="True" Font-Underline="false"
                                                OnClientClick="javascript:ShowPromoCd();" Text="Promo Code" Visible=false></asp:LinkButton>
                                            <asp:Button ID="btnCheckPromoCode" runat="server" OnClick="btnCheckPromoCode_Click"
                                                Style="display: none" Text="" /></td>
                                    </tr>
                                    <tr>
                                        <uc4:CommonLink ID="ucSODocSort" runat="server" Text="" ColumnNames="ListValue as 'Code',ListValue +' - '+ListDtlDesc as 'Name'"
                                            ContentWidth="40" LinkText="SO Doc Sort" TableName="listmaster,listdetail" ISDefault="false"
                                            TextField="Name" ValueField="Code" WhereClause="listmaster.pListMasterID =listdetail.fListMasterID and listmaster.ListName='SODocSortInd' order by listdetail.ListValue" />
                                        <td width="20" align="right">
                                            <img src="Common/Images/icodollar.gif" style="cursor: hand;" onclick="javascript:OpenWorkSheet();" /></td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="lightBg" id="tdPODet" height="80px" valign="top">
                        <asp:UpdatePanel UpdateMode="Conditional" ID="pnlPoDetails" runat="server">
                            <ContentTemplate>
                                <asp:Panel ID="pnlink" runat="server" DefaultButton="btnClick">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;" oncontextmenu="javascript:return false;">
                                        <tr>
                                            <td style="padding-left: 4px">
                                                <asp:Label ID="Label4" runat="server" Text="PO #" Font-Bold="True"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox MaxLength="20" CssClass="lbl_whitebox" Width="60px" ID="txtPO" runat="server"
                                                    onblur="javascript:LoadPO(this.value);"></asp:TextBox>
                                            </td>
                                            <uc4:CommonLink ID="ucShipFrom" runat="server" Text="" ColumnNames="LOCID as Code,LOCID + ' - ' + [LocName] as Name"
                                                ContentWidth="40" LinkText="Ship From" TableName="LocMaster" ISDefault="false"
                                                TextField="Name" ValueField="Code" WhereClause="MaintainIMQtyInd='Y'" />
                                            <uc4:CommonLink ID="ucOrderType" runat="server" LinkText="Order Type" Text="" ContentWidth="40"
                                                ISDefault="false" TableName="listmaster,listdetail" ColumnNames="ListValue as 'Value',ListValue +' - '+convert(varchar(10),SequenceNo)+' - '+ListDtlDesc as 'Code',ListValue +' - '+ListDtlDesc as 'Name'"
                                                TextField="Name" ValueField="Code" WhereClause="listmaster.pListMasterID =listdetail.fListMasterID and listmaster.ListName='SOEOrderTypes' order by listdetail.ListValue" />
                                            <uc4:CommonLink ID="ucCarrierCode" runat="server" ColumnNames="TableCd as Code,TableCd+' - '+ShortDsc as Name"
                                                LinkText="Carrier Cd" ContentWidth="40" TableName="[Tables]" ISDefault="false"
                                                IsLineEditable="true" TextField="Name" ValueField="Code" WhereClause="TableType='CAR' and SOApp='Y'" />
                                            <uc4:CommonLink ID="ucFreightCode" ContentWidth="40" ISDefault="false" TextField="Name"
                                                TableName="Tables" ValueField="Code" ColumnNames="TableCd as Code,TableCd+' - '+ShortDsc as Name"
                                                WhereClause="TableType='FGHT' and SOApp='Y'" runat="server" LinkText="Freight Cd"
                                                IsLineEditable="true" />
                                        </tr>
                                        <tr id="trPoDet">
                                            <td>
                                                &nbsp;<asp:Label ID="lblReqDateCaption" Text="Cust Req Dt" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <uc6:Orderdatepicker ID="dtpReqdShipDate" Name="CustReqDt" runat="server" />
                                            </td>
                                            <td>
                                                &nbsp;<asp:Label ID="Label7" Text="Branch Req Dt" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <uc6:Orderdatepicker ID="dtqBranchReqDate" Name="BranchReqDt" runat="server" />
                                            </td>
                                            <uc4:CommonLink ID="ucExpedite" ContentWidth="60" ISDefault="false" runat="server"
                                                ColumnNames="TableCd as Code,TableCd+' - '+ShortDsc as Name" WhereClause="TableType='EXPD' and SOApp='Y'"
                                                LinkText="Expedite Cd" TableName="Tables" TextField="Name" ValueField="Code" />
                                            <uc4:CommonLink ID="ucPriorityCode" ContentWidth="40" ISDefault="false" runat="server"
                                                ColumnNames="TableCd as Code,TableCd+' - '+ShortDsc as Name" WhereClause="TableType='PRI'  and SOApp='Y'"
                                                LinkText="Priority Cd" TableName="Tables" TextField="Name" ValueField="Code" />
                                            <uc4:CommonLink ID="ucReasonCd" IsOpenItem="true" ContentWidth="40" ISDefault="false"
                                                runat="server" ColumnNames="TableCd as Code,TableCd+' - '+ ShortDsc as Name"
                                                WhereClause="TableType='REAS'  and SOApp='Y'" LinkText="Reason Cd" TableName="Tables"
                                                TextField="Name" ValueField="Code" />
                                        </tr>
                                        <tr id="trCodeDet">
                                            <td style="padding-left: 3px">
                                                <asp:Label ID="lblShipDtCaption" Text="Sch Ship Dt:" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <uc6:Orderdatepicker ID="dtqShdate" Name="SchShipDt" OnBubbleClick="btnRefereshGrid_Click"
                                                    runat="server" />
                                            </td>
                                            <td style="padding-left: 3px">
                                                <asp:Label ID="lblCapInvDate" Text="Invoice Date:" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="txtInvDate" Width="40px" runat="server"></asp:Label>
                                            </td>
                                            <td style="padding-left: 4px">
                                                <asp:Label ID="Label6" Text="Entry ID:" Width="50" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                &nbsp;<asp:Label ID="lblEntId" Width="40px" runat="server"></asp:Label>
                                            </td>
                                            <td style="padding-left: 4px">
                                                <asp:Label ID="Label8" Text="Change ID:" Width="60" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                &nbsp;<asp:Label ID="lblChangeID" Width="40px" runat="server"></asp:Label>
                                            </td>
                                            <td colspan="2">
                                                <asp:Button ID="btnClick" runat="server" Style="display: none;" OnClientClick="javascript:return false;" />
                                                <asp:HiddenField ID="hidShippedDate" Value="" runat="server" />
                                                <asp:HiddenField ID="hidShowWorkSheet" Value="false" runat="server" />
                                                <asp:HiddenField ID="hidSubType" Value="false" runat="server" />
                                                <asp:HiddenField ID="hidHoldDt" Value="false" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-left: 3px; padding-top: 2px;">
                                                <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Ref SO No:"></asp:Label></td>
                                            <td style="padding-top: 2px;">
                                                <asp:Label ID="lblRefNo" runat="server" Font-Bold="True"></asp:Label></td>
                                            <td style="padding-left: 3px">
                                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Certs Req'd:"></asp:Label></td>
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="CertsReqdCheckBox" runat="server" onClick="javascript:LoadCert(this);"
                                                    onfocusout="javascript:document.getElementById('txtINo1').focus();document.getElementById('txtINo1').select();" />
                                            </td>
                                            <td colspan="3" style="padding-left: 4px; padding-top: 2px;">
                                                <asp:Label ID="lblTOOrderType" runat="server" Font-Bold="True" ForeColor="#CC0000"
                                                    Text=""></asp:Label></td>
                                            <td>
                                            </td>
                                            <td colspan="2">
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" width="100%">
                        <table cellpadding="0" cellspacing="0" id="tblGrid" height="height: 320px" width="100%">
                            <tr>
                                <td valign="top" align="left" id="TDFamily" runat="server" style="display: none;">
                                    <asp:UpdatePanel UpdateMode="Conditional" ID="FamilyPanel" runat="server">
                                        <ContentTemplate>
                                            <uc1:ItemFamily ID="UCItemFamily" runat="server" OnItemClick="UpdateItemLookup" />
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td valign="top" width="100%">
                                    <table cellpadding="0" border="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td valign="top" id="TDItem" runat="server" style="display: none;">
                                                <asp:UpdatePanel UpdateMode="Conditional" ID="ControlPanel" runat="server">
                                                    <ContentTemplate>
                                                        <uc2:ItemControl ID="UCItemLookup" OnPackageChange="ItemControl_OnPackageChange"
                                                            OnChange="ItemControl_OnChange" runat="server" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="#ECF9FB" width="100%">
                                                <table cellpadding="0" border="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td>
                                                            <asp:UpdatePanel UpdateMode="Conditional" runat="server" ID="pnlSearchBar">
                                                                <ContentTemplate>
                                                                    <div class="Sbar" oncontextmenu="Javascript:return false;" id="divdatagrid" style="overflow-x: auto;
                                                                        overflow-y: auto; position: relative; top: 0px; left: 0px; height: 250px; width: 982px;
                                                                        border: 0px solid; vertical-align: top;" runat="server">
                                                                        <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlQuoteDetail">
                                                                            <ContentTemplate>
                                                                                <table id="tblSearch" style="display: none;" bgcolor="#ECF9FB" border="0" width="130%"
                                                                                    cellpadding="0" cellspacing="0">
                                                                                    <tr class='lock' bgcolor="#ECF9FB">
                                                                                        <th class="lock" width="90px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_Item" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"
                                                                                                runat="server"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="lock" width="110px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_PFCITem" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"
                                                                                                runat="server"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="lock" width="140px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_Desc" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="50px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_Qty" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="50px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_BaseUOM" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="50px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_AvQty" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="70px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_UPrice" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="40px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_SellUnit" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="40px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_LocCode" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="100px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_CarrierCd" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="100px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_FreightCd" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="70px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_ExtAmt" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="70px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_ExtWt" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="75px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="90%" ID="txt_SE" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" width="100px" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_LocaName" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <%--<td class="" width="50" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="90%" ID="txt_quote" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </td>--%>
                                                                                        <th class="locks" width="100" id="tdDelete" runat="server" align="center">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="80%" ID="txtDelDate" runat="server" onkeypress="javascript:if(event.keyCode==13){CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                        <th class="locks" align="center" width="100px">
                                                                                            <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_Remark" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                                        </th>
                                                                                    </tr>
                                                                                </table>
                                                                                <asp:DataGrid ID="dgNewQuote" UseAccessibleHeader="true" BackColor="#ECF9FB" BorderColor="#9AB8C3"
                                                                                    Style="border-collapse: collapse; vertical-align: top; width: 130%;" AllowPaging="true"
                                                                                    PageSize="10" PagerStyle-Visible="false" runat="server" AutoGenerateColumns="false"
                                                                                    BorderWidth="0" AllowSorting="True" GridLines="Both" OnSortCommand="dgNewQuote_SortCommand"
                                                                                    ShowFooter="false" OnItemDataBound="dgNewQuote_ItemDataBound">
                                                                                    <HeaderStyle HorizontalAlign="Right" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9" />
                                                                                    <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                                                                    <ItemStyle CssClass="item" VerticalAlign="Top" BackColor="White" Height="25px" BorderWidth="1px" />
                                                                                    <AlternatingItemStyle CssClass="item" VerticalAlign="Top" BackColor="#ECF9FB" Height="25px"
                                                                                        BorderWidth="1px" />
                                                                                    <Columns>
                                                                                        <asp:TemplateColumn>
                                                                                            <ItemTemplate>
                                                                                                <asp:CheckBox ID="chkSelect" onclick="CheckSelectAll(this.checked,this.id);" runat="server" />
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle BorderColor="#9AB8C3" BorderWidth="1px" HorizontalAlign="Center" />
                                                                                            <ItemStyle HorizontalAlign="Center" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Customer Item #" SortExpression="CusItemNo">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblCustItem" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                                                <asp:HiddenField ID="hidTotAvailableQty" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"QtyAvail1") %>' />
                                                                                                <asp:HiddenField ID="hidItemValue" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"NetUnitPrice") %>' />
                                                                                                <asp:HiddenField ID="hidUnitPrice" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"NetUnitPrice") %>' />
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="90px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Right" Width="90px" Wrap="False" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn SortExpression="ItemNo" HeaderText="Item #">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblPFCItemNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ItemNo") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="150px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Left" Width="150px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn SortExpression="ItemDsc" HeaderText="Description">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblDescription" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ItemDsc") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="170px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Left" Width="170px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn SortExpression="QtyOrdered" HeaderText="Req'd Qty">
                                                                                            <ItemTemplate>
                                                                                                <asp:TextBox ID="txtQty" Width="50px" runat="server" onfocus="javascript:this.select();document.getElementById('hidGridCurControl').value=this.id;document.getElementById('hidShowLineComments').value='true';"
                                                                                                    Style="text-align: right;" onblur="Javascript:SetReqValue(this.value,this.id);"
                                                                                                    Text='<%#DataBinder.Eval(Container.DataItem,"QtyOrdered") %>' />
                                                                                                <asp:HiddenField ID="hidId" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"pSODetailID")%>' />
                                                                                                <asp:HiddenField ID="hidReqQty" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"QtyOrdered") %>' />
                                                                                                <asp:HiddenField ID="hidQtyShipped" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"ReceivedQty") %>' />
                                                                                                <asp:HiddenField ID="hidPreviousValue" runat="server" Value="" />
                                                                                                <asp:HiddenField ID="hidLineNumber" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"LineNumber") %>' />
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="50px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Right" Width="50px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn SortExpression="SellStkQty" HeaderText="Base Qty/UOM">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblBaseUOMQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"SellStkQty") %>'></asp:Label>
                                                                                                /
                                                                                                <asp:Label ID="lblBaseUOM" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"SellStkUM") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="50px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Left" Width="50px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn SortExpression="QtyAvail1" HeaderText="Avail. Qty">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblAvailQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"QtyAvail1") %>'></asp:Label>
                                                                                                <asp:HiddenField ID="hidAvailableQty" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"QtyAvail1") %>'>
                                                                                                </asp:HiddenField>
                                                                                            </ItemTemplate>
                                                                                            <ItemStyle HorizontalAlign="Right" Width="50px" />
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="50px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn SortExpression="ReceivedQty" HeaderText="Received Qty">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblReceivedQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ReceivedQty") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <ItemStyle HorizontalAlign="Right" Width="50px" />
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="50px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Sell Price" SortExpression="NetUnitPrice">
                                                                                            <ItemTemplate>
                                                                                                <asp:HiddenField ID="hidPrice" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"AlternatePrice") %>' />
                                                                                                <asp:TextBox ID="txtUnitPrice" Width="50px" runat="server" onfocus="javascript:document.getElementById('hidGridCurControl').value=this.id.replace('txtUnitPrice','txtQty');"
                                                                                                    onblur="Javascript:UpdateUnitPrice(this.value,this.id);" Style="direction: rtl;
                                                                                                    display: none;" Text='<%#DataBinder.Eval(Container.DataItem,"NetUnitPrice") %>'></asp:TextBox>
                                                                                                <asp:TextBox ID="txtSellPrice" Width="50px" runat="server" onfocus="javascript:this.select();document.getElementById('hidGridCurControl').value=this.id.replace('txtSellPrice','txtQty');"
                                                                                                    onblur="Javascript:UpdateUnitPrice(this.value,this.id);" Style="direction: rtl;"
                                                                                                    Text='<%#DataBinder.Eval(Container.DataItem,"AlternatePrice") %>'></asp:TextBox>
                                                                                                <%--<asp:Label ID="lblUnitPrice" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"NetUnitPrice") %>'></asp:Label>--%>
                                                                                            </ItemTemplate>
                                                                                            <ItemStyle HorizontalAlign="Right" Width="70px" />
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="70px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn SortExpression="AltPricePerUOM" HeaderText="Sell Unit">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblAltPricePerUOM" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"AltPricePerUOM") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <ItemStyle HorizontalAlign="Center" Width="50px" />
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="50px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn SortExpression="LinePriceInd" HeaderText="PI">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblLinePriceInd" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"LinePriceInd") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <ItemStyle HorizontalAlign="Center" Width="25px" />
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="25px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Loc" SortExpression="IMLocID">
                                                                                            <ItemTemplate>
                                                                                                &nbsp;&nbsp;
                                                                                                <asp:LinkButton ID="lblLocCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"IMLocID") %>'
                                                                                                    ToolTip='<%#DataBinder.Eval(Container.DataItem,"IMLocID")%>'></asp:LinkButton>
                                                                                                <asp:HiddenField ID="hidLocationCode" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"IMLocID") %>'>
                                                                                                </asp:HiddenField>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="40px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Right" Width="30px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Carrier Code">
                                                                                            <ItemTemplate>
                                                                                                &nbsp;&nbsp;<asp:LinkButton ID="dglnkCarrierCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CarrierCd") %>'
                                                                                                    ToolTip='<%#DataBinder.Eval(Container.DataItem,"CarrierCd")%>'></asp:LinkButton>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="80px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Left" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Freight Cd">
                                                                                            <ItemTemplate>
                                                                                                &nbsp;&nbsp;<asp:LinkButton ID="dglnkFreightCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"FreightCd") %>'
                                                                                                    ToolTip='<%#DataBinder.Eval(Container.DataItem,"FreightCd") %>'></asp:LinkButton>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="80px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Left" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Price/UOM" SortExpression="AlternateUM">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblAltUnitPrice" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"NetUnitPrice")+"/"+DataBinder.Eval(Container.DataItem,"AlternateUM") %>'></asp:Label>
                                                                                                <asp:Label ID="lblAlternateUM" runat="server" Visible="false" Text='<%#DataBinder.Eval(Container.DataItem,"AlternateUM") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="80px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle HorizontalAlign="Left" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Extended Amount" SortExpression="NetUnitPrice">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblExtAmount" runat="server" Text='<%#string.Format("{0:####,###,##0.00}",DataBinder.Eval(Container,"DataItem.ExtendedPrice")) %>' />
                                                                                                <asp:HiddenField ID="hidExtAmount" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ExtendedPrice") %>' />
                                                                                                <asp:HiddenField ID="hidGrossWt" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.NetWght") %>' />
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle BorderColor="#9AB8C3" BorderWidth="1px" HorizontalAlign="Center" />
                                                                                            <ItemStyle HorizontalAlign="Right" Width="70px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Extended Weight" SortExpression="ExtendedNetWght">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblExtWt" runat="server" Text='<%#string.Format("{0:####,###,##0.00}",DataBinder.Eval(Container,"DataItem.ExtendedNetWght")) %>' />
                                                                                                <asp:HiddenField ID="hidExtWt" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.ExtendedNetWght") %>' />
                                                                                            </ItemTemplate>
                                                                                            <ItemStyle HorizontalAlign="Right" />
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="70px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Super Equival" SortExpression="AlternateUMQty">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblSuperEquivalent" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"AlternateUMQty") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="80px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle Width="60px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Quote #" SortExpression="pSODetailID">
                                                                                            <ItemTemplate>
                                                                                                &nbsp;&nbsp;<asp:Label ID="lblQuoteNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"pSODetailID") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="50px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle Width="50px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Location Name" SortExpression="IMLoc">
                                                                                            <ItemTemplate>
                                                                                                &nbsp;&nbsp;<asp:Label ID="lblLocName" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"IMLoc") %>'></asp:Label>
                                                                                                <asp:HiddenField ID="hidLocationName" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"IMLoc") %>'>
                                                                                                </asp:HiddenField>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="180px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle Width="170px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Deleted Date" SortExpression="DeleteDt">
                                                                                            <ItemTemplate>
                                                                                                &nbsp;&nbsp;<asp:Label ID="lblDelDate" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DeleteDt")%>'></asp:Label>
                                                                                                <asp:HiddenField ID="hidDelFlag" runat="server" Value=""></asp:HiddenField>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="70px" BorderColor="#9AB8C3" BorderWidth="1px" />
                                                                                            <ItemStyle Width="100px" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Line Note" SortExpression="Remark">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblQuoteRemark" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"Remark") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Wrap="False" Width="120px" BorderColor="#9AB8C3"
                                                                                                BorderWidth="1px" />
                                                                                            <ItemStyle Width="120px" Wrap="False" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:TemplateColumn HeaderText="Sch Ship Dt" SortExpression="RqstdShipDt">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label ID="lblRqstdShipDt" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"RqstdShipDt") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle HorizontalAlign="Center" Wrap="False" Width="100px" BorderColor="#9AB8C3"
                                                                                                BorderWidth="1px" />
                                                                                            <ItemStyle Width="100px" Wrap="False" />
                                                                                        </asp:TemplateColumn>
                                                                                        <asp:BoundColumn></asp:BoundColumn>
                                                                                    </Columns>
                                                                                    <PagerStyle HorizontalAlign="Left" Mode="NumericPages" />
                                                                                </asp:DataGrid>
                                                                                <%--<center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found" Visible="False"></asp:Label></center>--%>
                                                                                <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                                                                <asp:HiddenField ID="hidDelete" runat="server" />
                                                                                <asp:HiddenField ID="hidLineNo" runat="server" />
                                                                                <asp:HiddenField ID="hidLineCount" runat="server" />
                                                                                <asp:HiddenField ID="hidfSOdetailID" runat="server" />
                                                                                <asp:Button ID="btnGetGrid" runat="server" Style="display: none;" OnClick="btnGetGrid_Click"
                                                                                    CausesValidation="false" />
                                                                                <asp:Button ID="btnRefereshGrid" runat="server" Style="display: none;" OnClick="btnRefereshGrid_Click"
                                                                                    CausesValidation="false" />
                                                                                <asp:Button ID="btnDelete" runat="server" Style="display: none;" CausesValidation="false"
                                                                                    OnClick="btnDelete_Click" />
                                                                                <asp:Button ID="btnRemoveHI" runat="server" Style="display: none;" CausesValidation="false"
                                                                                    OnClick="btnRemoveHI_Click" />
                                                                                <asp:Button ID="btnSearch" runat="server" Style="display: none;" CausesValidation="false"
                                                                                    OnClick="btnSearch_Click" />
                                                                                <asp:Button ID="btnGrid" runat="server" Style="display: none;" CausesValidation="false"
                                                                                    OnClick="btnGrid_Click" />
                                                                                <asp:Button ID="btnGridUpdate" runat="server" Style="display: none;" OnClick="btnGridUpdate_Click"
                                                                                    CausesValidation="false" />
                                                                            </ContentTemplate>
                                                                        </asp:UpdatePanel>
                                                                    </div>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="lightBg">
                                                            <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                                                                <ContentTemplate>
                                                                    <uc3:Pager ID="gridPager" Visible="false" runat="server" OnBubbleClick="Pager_PageChanged" />
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" id="commandLine">
                        <asp:UpdatePanel ID="pnlLineDtl" runat="server" UpdateMode="conditional">
                            <ContentTemplate>
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td colspan="10">
                                            <table id="tblItem" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td colspan="12">
                                                        <table cellpadding="0" cellspacing="0" border="0" width="100%" id="trItemText">
                                                            <tr id="trItem">
                                                                <td height="20px" width="90" valign="top" class="TabHead " style="padding-left: 5px;">
                                                                    <strong>Item Number</strong></td>
                                                                <td class="TabHead " width="60" valign="top">
                                                                    <strong>Requested Qty</strong></td>
                                                                <td class="TabHead " width="55" valign="top" style="padding-left: 5px;">
                                                                    <strong>Available Qty</strong></td>
                                                                <td class="TabHead" width="50" valign="top" style="padding-left: 5px;">
                                                                    Sell Qty
                                                                </td>
                                                                <td class="TabHead " width="60" valign="top" style="padding-left: 5px;">
                                                                    <a href="#" onclick="javascript:OpenWorkSheet();" title="Click here to open pricing work sheet"
                                                                        style="text-decoration: none;" class="TabHead" id="lnkUnitPrice"><strong>Sell Price</strong></a></td>
                                                                <td class="TabHead" width="40" valign="top" style="padding-left: 5px;">
                                                                    Sell Unit
                                                                </td>
                                                                <td class="TabHead " width="40" valign="top">
                                                                    <strong>Price Origin</strong></td>
                                                                <td class="TabHead " style="padding-left: 5px" valign="top" width="40">
                                                                    Ship From</td>
                                                                <td class="TabHead " width="60" valign="top" style="padding-left: 5px;">
                                                                    <strong>Margin %</strong></td>
                                                                <td class="TabHead " width="60" valign="top">
                                                                    <strong>Price/Lb</strong></td>
                                                                <td class="TabHead " width="80" valign="top">
                                                                    <strong>Line Note</strong></td>
                                                                <td class="TabHead " width="50" valign="top">
                                                                    <strong>Exclude Usage&nbsp;&nbsp;</strong></td>
                                                                <td class="TabHead" width="30" valign="top">
                                                                    Cert
                                                                </td>
                                                                <td class="TabHead" width="60" valign="top" style="padding-left: 5px;">
                                                                    Price / Unit
                                                                </td>
                                                                <td class="TabHead" width="60" valign="top">
                                                                    Total Pieces
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox AutoCompleteType="Disabled" ID="txtINo1" MaxLength="30" runat="server"
                                                                        onfocus="javascript:this.select();" CssClass="txtBox wide120px" onkeydown="javascript:javascript:if(event.keyCode==9){GetItemDetail(event)};"
                                                                        onkeypress="javascript:GetItemDetail(event);" Width="80px"></asp:TextBox>
                                                                    <asp:HiddenField runat="server" ID="hidItem" />
                                                                    <asp:Button ID="btnPFCItem" runat="server" OnClick="btnPFCItem_Click" Style="display: none"
                                                                        Text="" />
                                                                    <asp:Button ID="btnCustItem" runat="server" OnClick="btnCustItem_Click" Style="display: none"
                                                                        Text="" />
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtReqQty" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9){CheckAvailability(this.value);return false;}"
                                                                        onkeypress="javascript:if(event.keyCode==13)CheckAvailability(this.value);" CssClass="txtBox small50px"
                                                                        runat="server" MaxLength="10"></asp:TextBox></td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:Label ID="txtAvQty" CssClass="txtBox small50px" runat="server"></asp:Label><asp:HiddenField
                                                                        ID="hidTotalAvQty" runat="server" />
                                                                </td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblSellQty" CssClass="txtBox small50px" runat="server" Text=""></asp:Label></td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox ID="txtUnitPrice" Style="display: none;" onfocus="javascript:this.select();"
                                                                        onkeypress="javascript:if(event.keyCode==13){CallBtnClick('btnPriceUpdate'); return false;}"
                                                                        onkeydown="javascript:if(event.keyCode==9){CallBtnClick('btnPriceChange');  return false;}"
                                                                        CssClass="txtBox small50px" runat="server" MaxLength="9"></asp:TextBox>
                                                                    <asp:TextBox ID="txtSellPrice" onfocus="javascript:this.select();" onkeypress="javascript:if(event.keyCode==13){document.getElementById('chkExcludeUsage').focus(); if(document.getElementById('hidStartProc').value ==0){document.getElementById('hidStartProc').value=1; CallBtnClick('btnPriceUpdate'); return false;}}"
                                                                        onkeydown="javascript:if(event.keyCode==9){CallBtnClick('btnPriceChange');  return false;}"
                                                                        CssClass="txtBox small50px" runat="server" MaxLength="9"></asp:TextBox>
                                                                    <asp:HiddenField ID="hidStartProc" runat="server" Value="0" />
                                                                </td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblAltPUOM" CssClass="txtBox small50px" runat="server" Text=""></asp:Label></td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblPriceOrgin" CssClass="txtBox small50px" runat="server"></asp:Label>
                                                                </td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox ID="txtCmdShipLoc" Width="30px" runat="server" CssClass="txtBox small50px"
                                                                        MaxLength="9" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==9){CheckAvailabilityByLocation(document.getElementById('txtReqQty').value); return false;}else{ValdateNumber();}"
                                                                        onkeypress="javascript:if(event.keyCode==13){CheckAvailabilityByLocation(document.getElementById('txtReqQty').value); return false;}else{ValdateNumber();}"></asp:TextBox>
                                                                </td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="txtMarginPct" CssClass="txtBox small50px" runat="server"></asp:Label>
                                                                </td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:Label ID="txtPriceLb" CssClass="txtBox small50px" runat="server"></asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox ID="txtQuoteRemark" onfocus="javascript:this.select();" onkeydown="javascript:if(event.keyCode==13){if(document.getElementById('hidStartProc').value ==0){document.getElementById('hidStartProc').value=1; CallBtnClick('imgMakeQuotation');}}"
                                                                        CssClass="txtBox wide120px" runat="server" Width="70px"></asp:TextBox></td>
                                                                <td>
                                                                    <asp:CheckBox ID="chkExcludeUsage" CssClass="cnt" runat="server" onkeydown="javascript:if(event.keyCode==13){if(document.getElementById('hidStartProc').value ==0){document.getElementById('hidStartProc').value=1; CallBtnClick('imgMakeQuotation');}}" /></td>
                                                                <td>
                                                                    <asp:CheckBox ID="chkItemCert" CssClass="cnt" runat="server" onkeydown="javascript:if(event.keyCode==13){if(document.getElementById('hidStartProc').value ==0){document.getElementById('hidStartProc').value=1; CallBtnClick('imgMakeQuotation');}}" /></td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblPriceUOM" CssClass="txtBox small50px" runat="server" Text=""></asp:Label></td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblAltQty" CssClass="txtBox small50px" runat="server" Text=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="5" style="height: 20px" class="splitborder_b_v">
                                                                    &nbsp;<asp:Label ID="lblDesription" runat="server" Text=""></asp:Label></td>
                                                                <td class="splitborder_b_v">
                                                                    &nbsp;<asp:Label ID="lblBuom" runat="server" Text=""></asp:Label></td>
                                                                <td class="splitborder_b_v">
                                                                    &nbsp;<asp:Label ID="lblSupEquiv" runat="server" Text=""></asp:Label></td>
                                                                <td class="splitborder_b_v" colspan="1">
                                                                </td>
                                                                <td colspan="5" class="splitborder_b_v">
                                                                    <asp:HiddenField ID="hidQty" runat="server" />
                                                                    <asp:HiddenField ID="hidAltQty" runat="server" />
                                                                    <asp:HiddenField ID="hidItemWeight" runat="server" />
                                                                    <asp:HiddenField ID="hidAvgCost" runat="server" />
                                                                    <asp:HiddenField ID="hidCrossref" runat="server" />
                                                                    <asp:HiddenField ID="hidCrossDesc" runat="server" />
                                                                    <asp:HiddenField ID="hidQtyToSell" runat="server" />
                                                                    <asp:HiddenField ID="hidStdCost" runat="server" />
                                                                    <asp:HiddenField ID="hidListPrice" runat="server" />
                                                                    <asp:HiddenField ID="hidReplacement" runat="server" />
                                                                    <asp:HiddenField ID="hidWorkNetWeight" runat="server" />
                                                                    <asp:HiddenField ID="hidWorkItemWeight" runat="server" />
                                                                    <asp:HiddenField ID="hidTotAmt" runat="server" />
                                                                    <asp:HiddenField ID="hidTotCost" runat="server" />
                                                                    <asp:HiddenField ID="hidTotWeight" runat="server" />
                                                                    <asp:HiddenField ID="hidTotNetWeight" runat="server" />
                                                                    <asp:HiddenField ID="hidSellPrice" runat="server" />
                                                                    <asp:HiddenField ID="hidOECost" runat="server" />
                                                                    <asp:HiddenField ID="hidPORequired" Value="true" runat="server" />
                                                                    <asp:HiddenField ID="hidOrgShipLoc" runat="server" />
                                                                    <asp:HiddenField ID="hidCmdSourceControl" runat="server" />
                                                                    <asp:HiddenField ID="hidCertsReqd" runat="server" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="9" class="splitborder_t_v splitborder_b_v">
                                                        &nbsp;
                                                        <asp:UpdateProgress ID="upPanel" runat="server">
                                                            <ProgressTemplate>
                                                                <asp:Label ID="lblProgress" CssClass="TabHead" runat="server" Text="Loading..."></asp:Label>
                                                                <%--<span class="TabHead"> Loading...</span>--%>
                                                            </ProgressTemplate>
                                                        </asp:UpdateProgress>
                                                        <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                                            <ContentTemplate>
                                                                <asp:Label ID="lblMessage" ForeColor="red" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td height="20px" align="right" colspan="5" width="35%" id="tdButton" style="padding-right: 15px;"
                                                        class="splitborder_t_v splitborder_b_v">
                                                        <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 2px">
                                                            <tr>
                                                                <td>
                                                                    <%-- Added by Slater for Packing Slip processing --%>
                                                                    <asp:ImageButton ID="ibtnPackSlip" ImageUrl="~/Common/Images/lighting.gif" OnClick="ibtnPackSlip_Click"
                                                                        ToolTip="Click here to process Packing List document" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <img id="Img1" src="Common/Images/ExcelIcon.jpg" style="padding-left: 5px; padding-right: 3px;
                                                                        width: 20px; height: 20px;" alt="Click here to export to excel" onclick="javascript:return CallBtnClick('btnExport');" />
                                                                </td>
                                                                <td>
                                                                    <%-- Added by Slater for Shipper processing --%>
                                                                    <asp:ImageButton ID="ibtnShipper" ImageUrl="~/Common/Images/Shipper.jpg" OnClick="ibtnShipper_Click"
                                                                        ToolTip="Click here to process Shipper document" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnInvoice" ImageUrl="~/Common/Images/InvoiceIcon.gif" OnClick="ibtnInvoice_Click"
                                                                        ToolTip="Click here to Open Invoice" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnHideheader" ImageUrl="Common/Images/TV.gif" ToolTip="Clike here to Show/Hide Header"
                                                                        runat="server" OnClientClick="javascript:return HideHeader('trItemText');" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnDeletedItem" ImageUrl="~/Common/Images/expand.gif" OnClientClick="javascript:SetGridHeight('ItemFamily');"
                                                                        ToolTip="Click here to Show Deleted Item" OnClick="ibtnExband_Click" runat="server" />
                                                                </td>
                                                                <td>
                                                                    <img src="Common/Images/search.gif" id="imgSearch" onclick="javascript:return ShowSearch('tblSearch');"
                                                                        alt="Click here to Show/Hide search" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnQuoteWeight" ImageUrl="~/Common/Images/truck.jpg" Width="18px"
                                                                        OnClientClick="javascript:OpenQuoteWeightForm();" ToolTip="Show Customer Scheduled to Ship Weight"
                                                                        runat="server" />
                                                                </td>
                                                                <td style="padding-left: 4px">
                                                                    <asp:ImageButton ID="ibtnFind" ImageUrl="~/Common/Images/find.gif" Width="18px" Height="18px"
                                                                        OnClientClick="javascript:return OpenSOFind();" ToolTip="Click here to view SO Find Screen"
                                                                        runat="server" />
                                                                </td>
                                                                <td>
                                                                    <asp:ImageButton ID="ibtnCompetitor" ImageUrl="~/Common/Images/vsred.gif" OnClientClick="javascript:OpenCompetitorSheet();"
                                                                        ToolTip="View Competitor Price" runat="server" />
                                                                </td>
                                                                <td style="padding-left: 4px">
                                                                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                                                        <ContentTemplate>
                                                                            <uc5:PrintDialogue ID="PrintDialogue1" EnableFax="true" runat="server"></uc5:PrintDialogue>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" class="splitborder_t_v splitborder_b_v" colspan="12" style="padding-right: 15px"
                                            valign="middle">
                                            <asp:Button CausesValidation="false" ID="btnClose" name="btnClose" OnClick="btnClose_Click"
                                                runat="server" Text="Button" Style="display: none;" />
                                            <asp:Button ID="btnQtyUpdate" name="btnQtyUpdate" OnClick="btnQtyUpdate_TextChanged"
                                                runat="server" Text="Button" Style="display: none;" />
                                            <asp:Button ID="btnPriceChange" name="btnPriceChange" OnClick="txtSellPrice_TextChanged"
                                                runat="server" Text="Button" Style="display: none;" />
                                            <asp:Button ID="btnClearItem" name="btnClearItem" OnClick="btnClearItem_TextChanged"
                                                runat="server" Text="Button" Style="display: none;" />
                                            <asp:Button ID="btnPriceUpdate" name="btnPriceUpdate" OnClick="btnPriceUpdate_Click"
                                                runat="server" Text="Button" Style="display: none;" />
                                            <asp:Button ID="btnItemNo" name="btnItemNo" OnClick="btnItemNo_Click" runat="server"
                                                Text="Button" Style="display: none;" />
                                            <asp:ImageButton ID="ibtnClear" Style="display: none;" CausesValidation="false" ImageUrl="~/Common/Images/save.jpg"
                                                runat="server" OnClick="ibtnClear_Click" />
                                            <asp:ImageButton ID="btnOrderDelete" Style="display: none;" ImageUrl="~/Common/Images/btnDelete.gif"
                                                runat="server" AlternateText="Delete Order" OnClick="btnOrderDelete_Click" />
                                            <asp:ImageButton ID="imgMakeQuotation" Style="display: none;" ImageUrl="~/Common/Images/submit.gif"
                                                runat="server" AlternateText="Make Quote" OnClick="imgMakeQuotation_Click" OnClientClick="Javscript:return ValidateQuoteDet();" />
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton ID="btnRefresh" runat="server" Style="padding-left: 5px;"
                                                            AlternateText="Reload sales order lines." ImageUrl="~/Common/Images/Refresh.gif" OnClick="btnRefresh_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton Style="padding-left: 5px;" ID="imgShowItemBuilder" ImageUrl="~/Common/Images/showitembuilder.gif"
                                                            runat="server" AlternateText="Show Item Builder" OnClick="imgShowItemBuilder_Click"
                                                            OnClientClick="Javascript:document.getElementById('TDFamily').style.display='';return true;" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="ibtnHide" Style="padding-left: 5px;" ImageUrl="~/Common/Images/hideitembuilder.gif"
                                                            runat="server" AlternateText="Hide Item Builder" OnClick="ibtnHide_Click" OnClientClick="Javascript:document.getElementById('TDFamily').style.display='none';SetGridHeight('Common');return true;"
                                                            Visible="false" />
                                                    </td>
                                                    <td>
                                                        <img id="ibtnDelete" style="padding-left: 5px;" runat="server" src="Common/Images/btnDelete.gif"
                                                            alt="Delete Order" onclick="javascript:DeleteConfirmation();" />
                                                    </td>
                                                    <td>
                                                        <img src="Common/Images/makeorder.gif" style="padding-left: 5px;" id="imgMO" runat="server"
                                                            onclick="javascript:this.style.display='none';OpenMakeOrderType();" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="imgMakeOreder" runat="server" Style="display: none; padding-left: 5px;"
                                                            AlternateText="Make Order" ImageUrl="~/Common/Images/makeorder.gif" OnClick="imgMakeOreder_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="imgConfirmShpmt" Style="padding-left: 5px;" runat="server" Visible="false"
                                                            AlternateText="Confirm Shipment" ImageUrl="~/Common/Images/ConfirmShipment.gif"
                                                            OnClientClick="javascript:this.style.display='none';" OnClick="imgConfirmShpmt_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="imgRelease" Style="padding-left: 5px;" runat="server" AlternateText="Release Order"
                                                            OnClientClick="javascript:this.style.display='none';" ImageUrl="~/Common/Images/release.gif"
                                                            OnClick="imgRelease_Click" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="imgHelp" Style="padding-left: 5px;" runat="server" CausesValidation="false"
                                                            AlternateText="Help" ImageUrl="~/Common/Images/help.gif" />
                                                    </td>
                                                    <td>
                                                        <img id="ibtnClose" src="Common/Images/Close.gif" style="padding-left: 5px; padding-right: 3px;"
                                                            onclick="javascript:return CallBtnClick('ibtnClear');" />
                                                        <asp:HiddenField ID="hidFocus" runat="server" />
                                                        <asp:HiddenField ID="hidIsReadOnly" Value="false" runat="server" />
                                                        <asp:HiddenField ID="hidCommandLineReadOnly" Value="false" runat="server" />
                                                        <asp:HiddenField ID="hidExpenseReadOnly" Value="false" runat="server" />
                                                        <asp:HiddenField ID="hidMOrderType" runat="server" />
                                                        <asp:HiddenField ID="hidisDifferentUser" runat="server" />
                                                        <asp:HiddenField ID="hidShowHide" runat="server" />
                                                    </td>
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
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <table border="0" cellpadding="0" cellspacing="0" width="100">
            <tr>
                <td class="txtBlue" style="height: 14px" width="90%">
                </td>
            </tr>
        </table>
        <asp:Button ID="btnExport" name="btnExportExcel" OnClick="ibtnExportExcel_Click"
            runat="server" Text="Excel Export" Style="display: none;" />
        <div id="divDelete" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
            word-break: keep-all; position: absolute;">
            <table border="0" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline">
                <tr>
                    <td style="width: 100px;">
                        <table border="0" cellspacing="0" width="100%">
                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                onmouseover="this.className='GridHead'">
                                <td>
                                    <div id="divSplitItem" style="width: 70px;" runat="server">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <img src="Common/Images/SplitIcon.png" style="width: 18px; height: 18px; padding-right: 5px;" />
                                                </td>
                                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:return OpenSplitLineWindow();">
                                                    <asp:Label ID="lblSplitItemDesc" Width="55px" runat="server" Text="Split Line" Font-Bold="true"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                onmouseover="this.className='GridHead'">
                                <td style="width: 5px;">
                                    <div id="divDeleteItemMenu" style="width: 70px;" runat="server">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <img src="Common/Images/delete.jpg" style="padding-right: 8px;" />
                                                </td>
                                                <td align="left" class="" style="cursor: hand; width: 60px;" onclick="Javascript:return CallBtnClick('btnDelete');">
                                                    <strong>Delete</strong></td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                onmouseover="this.className='GridHead'">
                                <td style="width: 5px;">
                                    <div id="divCancelMenu" style="width: 70px;" runat="server">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <img src="Common/Images/cancelrequest.gif" style="padding-right: 8px;"/>
                                                </td>
                                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:document.getElementById('divDelete').style.display='none';document.getElementById(hidRowID.value).style.fontWeight='normal';">
                                                    <strong>Cancel</strong><input type="hidden" value="" id="hidRowID" /></td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divHoldInvoice" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
            word-break: keep-all; position: absolute;">
            <table border="0" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline"
                width="100">
                <tr>
                    <td>
                        <table border="0" cellspacing="0" width="100">
                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                onmouseover="this.className='GridHead'">
                                <td class="" width="20">
                                    <img src="Common/Images/delete.jpg" /></td>
                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:return RemoveHold();">
                                    <strong>Remove Hold</strong></td>
                            </tr>
                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                onmouseover="this.className='GridHead'">
                                <td class="" width="20">
                                    <img src="Common/Images/cancelrequest.gif" /></td>
                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:document.getElementById('divHoldInvoice').style.display='none';">
                                    <strong>Cancel</strong><input type="hidden" value="" id="Hidden1" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <asp:UpdatePanel ID="upContext" runat="server">
            <ContentTemplate>
                <div runat="server" id="divToolTip" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
                    word-break: keep-all; position: absolute">
                    <table border="0" bordercolor="#000099" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline"
                        width="20%">
                        <tr>
                            <td class="bgmsgboxtile">
                            </td>
                        </tr>
                        <tr>
                            <td class="bgtxtbox">
                                <table border="0" cellspacing="0" width="100%">
                                    <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                        onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'">
                                        <td>
                                            <asp:ListBox ID="lstCommon" runat="server" AutoPostBack="true" CssClass="cnt Sbar"
                                                OnSelectedIndexChanged="lstCommon_SelectedIndexChanged" Width="200px"></asp:ListBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnUpdateValue" runat="server" OnClick="btnUpdateValue_Click" Style="display: none"
                                                Text="" />
                                            <asp:Button ID="btnGet" runat="server" OnClick="btnGet_Click" Style="display: none"
                                                Text="" /><asp:Button ID="btnSetOrderType" runat="server" CausesValidation="false"
                                                    OnClick="btnSetOrderType_Click" Style="display: none" Text="" />
                                            <asp:HiddenField ID="hidCurrentControl" runat="server" Value="" />
                                            <asp:HiddenField ID="hidGridCurControl" runat="server" Value="" />
                                            <asp:HiddenField ID="hidShowLineComments" runat="server" Value="" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <div runat="server" id="divGridContextMenu" class="MarkItUp_ContextMenu_MenuTable"
                    style="display: none; word-break: keep-all; position: absolute">
                    <table border="0" bordercolor="#000099" cellpadding="0" cellspacing="0" class="MarkItUp_ContextMenu_Outline"
                        width="20%">
                        <tr>
                            <td class="bgmsgboxtile">
                            </td>
                        </tr>
                        <tr>
                            <td class="bgtxtbox">
                                <table border="0" cellspacing="0" width="100%">
                                    <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                        onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'">
                                        <td>
                                            <asp:ListBox ID="lstGridContextMenu" runat="server" AutoPostBack="true" CssClass="cnt Sbar"
                                                OnSelectedIndexChanged="lstGridContextMenu_SelectedIndexChanged" Width="200px"></asp:ListBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td class="txtBlue" style="height: 14px" width="90%">
                </td>
            </tr>
        </table>
    </form>

    <script>
        // parent.menuFrame.location.href=parent.menuFrame.location.href;
        SetGridHeight('Common');        
    </script>

    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(startRequest);
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);

        function startRequest(sender, e) {        
        //disable button during the AJAX call
        if(document.getElementById('pnlink').disabled == true)
            return false;
        else    
            document.getElementById('pnlink').disabled = true;        
        }
        function endRequest(sender, e) {
        //re-enable button once the AJAX call has completed
        document.getElementById('pnlink').disabled = false;       
        }
    </script>

</body>
</html>
