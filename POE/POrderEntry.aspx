<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="POrderEntry.aspx.cs"
    Inherits="OrderEntryPage" %>

<%@ Register Src="Common/UserControls/CommonLink.ascx" TagName="CommonLink" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue"
    TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script src="Common/JavaScript/Common.js"></script>

    <%--   <script src="Common/JavaScript/ContextMenu.js"></script>

    <script src="Common/JavaScript/ItemBuilder.js"></script>


    <script src="Common/JavaScript/PFCCustomer.js"></script>

    <script src="Common/JavaScript/PFCItemDetail.js"></script>
    <script src="Common/JavaScript/shortcut.js"></script>--%>

    <script>
    function DeleteConfirmation()
    {
       var soid=document.getElementById("CustDet_txtSONumber").value;
       if(soid !="")
       {
          if(confirm('Are you sure you want to delete Order '+document.getElementById("CustDet_txtSONumber").value +'?'))
          {
           var orderType =window.open ("DeleteReason.aspx" ,"Delete",'height=140,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
            orderType.focus();           
          }
          else
          {
            return false;
          } 
       }
       else
          return false; 
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
    
    function OpenCarrierWindow(object)
    {   
        if(object !=null)
        {
         if(document.getElementById("hidLineCount").value!="" &&  document.getElementById("hidLineCount").value!="0")
         {
            if(ShowYesorNo('Changing the header Carrier will change the carriers for each line. Do you want to proceed?'))
            {                     
                ctrlID= object.id;
                document.getElementById("hidCurrentControl").value = object.id.split('_')[0];
                document.getElementById("btnGet").click();
            }
         
         }else 
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
    function UpdateCarrierValue(object)
    {
 
     if(object !=null)
        {  
            if(object.value != document.getElementById(object.id.replace('lblValue','hidMode')).value)
            { 
            if(document.getElementById("hidLineCount").value!="" &&  document.getElementById("hidLineCount").value!="0")
         {
             if(ShowYesorNo('Changing the header Carrier will change the carriers for each line. Do you want to proceed?'))
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
             document.getElementById("tblGrid").style.height="420px";
             document.getElementById("divdatagrid").style.height="420px";
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
             document.getElementById("tblGrid").style.height="240px";
             document.getElementById("divdatagrid").style.height="240px";
             //document.getElementById("ibtnHideheader").src="Common/Images/expand.gif";
        }
        return false;
    }
    
    // Enable Search function
    function ShowSearch(id)
    {
        if(document.getElementById(id).style.display !="none")
        {
            document.getElementById(id).style.display="none";
            document.getElementById("divdatagrid").style.height=((document.getElementById("TDItem").style.display!='none')?"230px":"300px"); 
            document.getElementById("tblGrid").style.height=document.getElementById("divdatagrid").style.height;  
        }
        else
        {
        
            if(document.getElementById("TDItem").style.display!='none' && document.getElementById("TDFamily").style.display!='none')
                document.getElementById("divdatagrid").style.height=((document.getElementById("TDItem").style.display!='none')?"230px":"300px"); 
            else
                document.getElementById("divdatagrid").style.height=((document.getElementById("TDItem")!=null && document.getElementById("TDItem").style.display!='none')?"220px":"300px"); 
                
            document.getElementById("tblGrid").style.height=document.getElementById("divdatagrid").style.height;
            document.getElementById(id).style.display=""; 
        
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
    }
    
    // load Orders
    function LoadOrder(SOEid)
    {
    
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
 
        var preValue=document.getElementById('CustDet_hidPreviousValue').value;
        if(preValue!=SOEid)
        { 
       
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
    // Load Order
    function LoadOrderDetails(orderNUmber)
    {
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
 
        var itemDetail=OrderEntryPage.CheckAvailability(document.getElementById("txtINo1").value,qty).value;
        if(itemDetail =="" || document.getElementById("hidSubType").value >"50")
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
    
    // Update PO
    function LoadPO(POvalue)
    {
        if(document.getElementById("CustDet_txtCustNo").value!="" &&document.getElementById("CustDet_txtSONumber").value!="" && document.getElementById("hidIsReadOnly").value=="false")
        { 
            if(POvalue!="")
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
    
    // Open Customer look up
    function LoadCustomerLookup(_custNo)
    {   
        var Url = "CustomerList.aspx?Customer=" + _custNo;
        window.open(Url,'CustomerList' ,'height=450,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
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
            var makeOrder =window.open("MakeOrder.aspx?OrderNo="+document.getElementById('CustDet_txtSONumber').value ,"MakeOrder",'height=200,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
            makeOrder.focus();  
        }   
    }
    
    function ExpenseOnlyOrder()
    {
        if(ShowYesorNo("No lines on this order, would you like to proceed?"))
        {
            var makeOrder =window.open("MakeOrder.aspx?OrderNo="+document.getElementById('CustDet_txtSONumber').value ,"MakeOrder",'height=200,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
            makeOrder.focus(); 
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
            if(parent.bodyFrame.form1.document.getElementById("txtPO").value !="")
            {  
                popUp=window.open ("EnterExpenses.aspx?PONumber=" + parent.bodyFrame.form1.document.getElementById("txtPO").value,"EnterExpenses",'height=470,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                popUp.focus();
            }
            else
                alert("Enter PO Number");
            
        }
        
        function LoadComment()
        {
            if(parent.bodyFrame.form1.document.getElementById("txtPO").value !="")
            { 
                var itemno = '';
                var lineNo = '';
                //
                // If user selected any item fromm the grid pass it to comments page
                //
                if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
                {
                    var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
                    lineNo = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','hidLineNumber')).value;
                    itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
                }
                       
                popUp=window.open ("CommentEntry.aspx?PONumber="+parent.bodyFrame.form1.document.getElementById("txtPO").value+"&InvoiceDate="+parent.bodyFrame.form1.document.getElementById("txtInvDate").innerHTML+"&ItemNo=" + itemno +"&LineNo=" +lineNo,"Maximize",'height=590,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (590/2))+',left='+((screen.width/2) - (714/2))+',resizable=No',"");
                popUp.focus();
            }
            else
                alert("Enter PO Number");
        }
        
        function OpenPriceWorkSheet()
        {
            if(event.keyCode==107)
            {
                var itemNo=document.getElementById("txtINo1").value;
                OrderEntryPage.CreateItemSession(itemNo);
                OpenWorkSheet();
                //document.getElementById("txtINo1").value = "";
                return false;
            }
            else
            {
            MenuShortCuts();
            }
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
    </script>

    <title>Order Entry</title>
</head>
<body bgcolor="#ECF9FB" onkeydown="javascript:return OpenPriceWorkSheet();" scroll="no"
    onclick="Javascript:document.getElementById('divToolTip').style.display='none';document.getElementById('divTool').style.display='none';document.getElementById('divDelete').style.display='none';if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';document.getElementById('lblMessage').innerText='';"
    onload="javascript:document.getElementById('CustDet_txtCustNo').focus();if(window.opener!=null)window.opener.close();">
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager ID="SMOrderEntry" runat="server" EnablePartialRendering="true">
            </asp:ScriptManager>
            <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%">
                <tr>
                    <td>
                        <uc1:Header ID="CustDet" runat="server"></uc1:Header>
                    </td>
                    <td rowspan="2" valign="top" class="lightBg" id="tdUsage" style="padding-left: 2px">
                        <asp:UpdatePanel ID="pnlSOSummary" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table border="0" cellpadding="0" cellspacing="2" style="height: 100%; line-height: 19px">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSalesHead" runat="server" Text="Total Cost:" Font-Bold="True"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblSales" runat="server" CssClass="lblbox" Text="195.34"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label3" runat="server" CssClass="TabHead" Font-Bold="True" Text="Total Weight:"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblTotalWeight" runat="server" CssClass="lblbox" Text="25.34"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label2" runat="server" CssClass="TabHead" Font-Bold="True" Text="Order Status:"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblOrdSts" runat="server" CssClass="lblbox"   Text="Entry"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Ship Status:"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblWhs" runat="server" CssClass="lblbox" Text="Unreleased"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="PO Status:"></asp:Label></td>
                                        <td>
                                            <asp:DropDownList CssClass="lbl_whitebox" ID="DropDownList2" Height="20" Width="50"
                                                runat="server">
                                                <asp:ListItem Text="04" Value="04"></asp:ListItem>
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="lnbtnExpense" runat="server" Font-Underline="false" Font-Bold="True"
                                                OnClientClick="javascript:LoadExpense();" Text="Expenses"></asp:LinkButton></td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:LinkButton ID="lnbtnComments" runat="server" Font-Underline="false" Font-Bold="True"
                                                OnClientClick="javascript:LoadComment();" Text="Comments"></asp:LinkButton></td>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                                <asp:Button ID="btnCheckExpComment" runat="server" OnClick="btnCheckExpComment_Click"
                                    Style="display: none" Text="" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="lightBg" id="tdPODet" height="90px">
                        <asp:UpdatePanel UpdateMode="Conditional" ID="pnlPoDetails" runat="server">
                            <ContentTemplate>
                                <asp:Panel ID="pnlink" runat="server"  >
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;">
                                        <tr>
                                            <td style="padding-left: 4px">
                                                <asp:Label ID="Label4" runat="server" Text="PO #" Font-Bold="True"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox MaxLength="20" CssClass="lbl_whitebox" Width="60px" ID="txtPO" onfocus="javascript:this.select();" runat="server" AutoPostBack=true OnTextChanged="txtPO_TextChanged"></asp:TextBox>
                                            </td>
                                            <uc4:CommonLink ID="ucShipFrom" runat="server" Text="" ColumnNames="LOCID as Code,LOCID + ' - ' + [LocName] as Name"
                                                ContentWidth="50" LinkText="Ref Type" />
                                            <uc4:CommonLink ID="ucOrderType" ContentWidth="50" runat="server" LinkText="References"
                                                Text="" />
                                            <uc4:CommonLink ID="ucCarrierCode" runat="server" LinkText="Buyer " ContentWidth="50" />
                                            <uc4:CommonLink ID="ucFreightCode" ContentWidth="50" runat="server" LinkText="Entry ID" />
                                        </tr>
                                        <tr id="trPoDet">
                                            <td>
                                                &nbsp;<asp:Label ID="lblReqDateCaption" Text="Confirming" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td colspan=3>
                                                 <asp:TextBox MaxLength="20" CssClass="lbl_whitebox" Width="248px" ID="TextBox6" runat="server"></asp:TextBox>
                                                <%--<uc6:Orderdatepicker ID="dtqBranchReqDate" Name="BranchReqDt" runat="server" />--%>
                                            </td>
                                            <uc4:CommonLink ID="CommonLink1" ContentWidth="50" runat="server" LinkText="Carrier"
                                                Text="" />
                                            <uc4:CommonLink ID="CommonLink2" runat="server" LinkText="Ship Method " ContentWidth="50" />
                                            <uc4:CommonLink ID="CommonLink3" ContentWidth="50" runat="server" LinkText="Terms" />
                                        </tr>
                                        <tr id="trCodeDet">
                                            <td style="padding-left: 3px;padding-top:5px;">
                                                <asp:Label ID="lblShipDtCaption" Text="Schd Rcpt Dt:" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                               <asp:Label ID="Label7" Width="40px" runat="server"></asp:Label>
                                            </td>
                                            <td style="padding-left: 3px">
                                                <asp:Label ID="lblCapInvDate" Text="Schd Ship Dt:" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="txtInvDate" Width="40px" runat="server"></asp:Label>
                                            </td>
                                            <td style="padding-left: 4px">
                                                <asp:Label ID="Label6" Text="PO Print Dt" Width="70" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="Label10" Width="40px" runat="server"></asp:Label>
                                            </td>
                                            <td style="padding-left: 4px">
                                                <asp:Label ID="Label8" Text="Delete Dt" Width="60" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                               <asp:Label ID="Label11" Width="40px" runat="server"></asp:Label>
                                            </td>
                                            <td style="padding-left: 4px">
                                                <asp:Label ID="Label12" Text="Complete Dt" Width="70" Font-Bold="True" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                               <asp:Label ID="Label13" Width="40px" runat="server"></asp:Label>
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
                                            <%--      <uc1:ItemFamily ID="UCItemFamily" runat="server" OnItemClick="UpdateItemLookup" />--%>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                                <td valign="top" width="100%">
                                    <table cellpadding="0" border="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td valign="top" id="TDItem" runat="server" style="display: none;">
                                                <asp:UpdatePanel UpdateMode="Conditional" ID="ControlPanel" runat="server">
                                                    <ContentTemplate>
                                                        <%-- <uc2:ItemControl ID="UCItemLookup" OnPackageChange="ItemControl_OnPackageChange"
                                                            OnChange="ItemControl_OnChange" runat="server" />--%>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="#ECF9FB" width="100%">
                                                <div class="Sbar" oncontextmenu="Javascript:return false;" id="divdatagrid" style="overflow-x: auto;
                                                    overflow-y: auto; position: relative; top: 0px; left: 0px; height: 260px; width: 982px;
                                                    border: 0px solid; vertical-align: top;" runat="server">
                                                    <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlQuoteDetail">
                                                        <ContentTemplate>
                                                            <table id="tblSearch" bgcolor="#ECF9FB" border="0" style="display: none;" width="1040px"
                                                                cellpadding="0" cellspacing="0">
                                                                <tr class='lock' bgcolor="#ECF9FB">
                                                                    <th class="lock" width="85px" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_Item" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"
                                                                            runat="server"></asp:TextBox>
                                                                    </th>
                                                                    <th class="lock" width="85px" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_PFCITem" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"
                                                                            runat="server"></asp:TextBox>
                                                                    </th>
                                                                    <th class="lock" width="155px" align="center">
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
                                                                    <th class="locks" width="40px" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_LocCode" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </th>
                                                                    <th class="locks" width="55px" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="90%" ID="txt_ExtAmt" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </th>
                                                                    <th class="locks" width="70px" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="90%" ID="txt_ExtWt" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </th>
                                                                    <th class="locks" width="75px" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="90%" ID="txt_SE" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </th>
                                                                    <th class="locks" width="65px" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="90%" ID="txt_UPrice" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </th>
                                                                    <th class="locks" width="160px" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_LocaName" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </th>
                                                                    <%--<td class="" width="50" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="90%" ID="txt_quote" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </td>--%>
                                                                    <th class="locks" width="100" id="tdDelete" runat="server" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="80%" ID="txtDelDate" runat="server" onkeypress="javascript:if(event.keyCode==13){CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </th>
                                                                    <th class="locks" align="center">
                                                                        <asp:TextBox CssClass="Searchcnt" Width="95%" ID="txt_Remark" runat="server" onkeypress="javascript:if(event.keyCode==13){return CallBtnClick('btnSearch');}"></asp:TextBox>
                                                                    </th>
                                                                </tr>
                                                            </table>
                                                            <asp:DataGrid ID="dgNewQuote" UseAccessibleHeader="true" BackColor="#ECF9FB" BorderColor="#9AB8C3"
                                                                Style="border-collapse: collapse; vertical-align: top; width: 130%;" AllowPaging="false"
                                                                runat="server" AutoGenerateColumns="false" PagerStyle-Visible="false" BorderWidth="0"
                                                                AllowSorting="True" GridLines="Both" OnSortCommand="dgNewQuote_SortCommand" ShowFooter="false"
                                                                OnItemDataBound="dgNewQuote_ItemDataBound">
                                                                <HeaderStyle HorizontalAlign="Right" CssClass="GridHead" Font-Bold="true" BackColor="#DFF3F9" />
                                                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                                                <ItemStyle CssClass="item" VerticalAlign="top" BackColor="#FFFFFF" Height="25px"
                                                                    BorderWidth="1px" />
                                                                <AlternatingItemStyle CssClass="item" VerticalAlign="top" BackColor="#ECF9FB" Height="25px"
                                                                    BorderWidth="1px" />
                                                                <Columns>
                                                                     
                                                                    <asp:TemplateColumn ItemStyle-Width="90px" HeaderText="PFC Item #" HeaderStyle-BorderColor="#9AB8C3"
                                                                        HeaderStyle-BorderWidth="1" SortExpression="CusItemNo" ItemStyle-Wrap="false"
                                                                        ItemStyle-HorizontalAlign="right">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblCustItem" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>                                                                             
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="90px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn ItemStyle-Width="150px" SortExpression="ItemNo" HeaderStyle-BorderColor="#9AB8C3"
                                                                        HeaderStyle-BorderWidth="1" HeaderText="Vendor Item #" ItemStyle-HorizontalAlign="left">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblPFCItemNo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="150px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn ItemStyle-Width="170px" SortExpression="ItemDsc" HeaderStyle-BorderColor="#9AB8C3"
                                                                        HeaderStyle-BorderWidth="1" HeaderText="Description" ItemStyle-HorizontalAlign="left">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDescription" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="170px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn ItemStyle-Width="50px" SortExpression="QtyOrdered" HeaderStyle-BorderColor="#9AB8C3"
                                                                        HeaderStyle-BorderWidth="1" HeaderText="Order Qty" ItemStyle-HorizontalAlign="right">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="txtQty" Width="50px" runat="server" onfocus="javascript:this.select();document.getElementById('hidGridCurControl').value=this.id;"
                                                                                Style="text-align: right;" onblur="Javascript:SetReqValue(this.value,this.id);"
                                                                                Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>' />
                                                                         
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="50px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn SortExpression="SellStkQty" HeaderStyle-BorderColor="#9AB8C3"
                                                                        HeaderStyle-BorderWidth="1" ItemStyle-Width="50px" HeaderText="Cost/UM"
                                                                        ItemStyle-HorizontalAlign="left">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblBaseUOMQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                            /
                                                                            <asp:Label ID="lblBaseUOM" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="50px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        SortExpression="QtyAvail1" HeaderText="Extended Cost" ItemStyle-Width="50px">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblAvailQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                            <asp:HiddenField ID="hidAvailableQty" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'>
                                                                            </asp:HiddenField>
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Right" />
                                                                        <HeaderStyle HorizontalAlign="Center" Width="50px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        SortExpression="ReceivedQty" HeaderText="Extended Weight" ItemStyle-Width="50px">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblReceivedQty" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Right" />
                                                                        <HeaderStyle HorizontalAlign="Center" Width="50px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        HeaderText="Ship Loc" SortExpression="NetUnitPrice" ItemStyle-Width="70px">
                                                                        <ItemTemplate>
                                                                           <asp:Label ID="lblReceivedQtyd" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                            <%--<asp:Label ID="lblUnitPrice" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"NetUnitPrice") %>'></asp:Label>--%>
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Right" />
                                                                        <HeaderStyle HorizontalAlign="Center" Width="70px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn SortExpression="AltPricePerUOM" HeaderStyle-BorderColor="#9AB8C3"
                                                                        HeaderStyle-BorderWidth="1" ItemStyle-Width="50px" HeaderText="Schd Rcpt Dt" ItemStyle-HorizontalAlign="left">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblAltPricePerUOM" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Center" />
                                                                        <HeaderStyle HorizontalAlign="Center" Width="50px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        HeaderText="Schd Ship Dt" SortExpression="QtyAvailLoc1" ItemStyle-Width="30px" ItemStyle-HorizontalAlign="Right">
                                                                        <ItemTemplate>
                                                                            &nbsp;&nbsp;<asp:Label ID="lblLocCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>                                                                           
                                                                             
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="40px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        HeaderText="Status" SortExpression="" ItemStyle-HorizontalAlign="left">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblLocCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>                                                                           
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="80px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        HeaderText="Base Qty/UOM" SortExpression="" ItemStyle-HorizontalAlign="left">
                                                                        <ItemTemplate>
                                                                              <asp:Label ID="lblLocCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>                                                                           
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="80px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        HeaderText="Super Eqv" SortExpression="AlternateUM" ItemStyle-HorizontalAlign="left">
                                                                        <ItemTemplate>
                                                                             <asp:Label ID="lblLocCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>                                                                           
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Center" Width="80px" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        ItemStyle-HorizontalAlign="right" HeaderText="Transit Days" HeaderStyle-HorizontalAlign="Center"
                                                                        SortExpression="NetUnitPrice" ItemStyle-Width="70px">
                                                                        <ItemTemplate>
                                                                           <asp:Label ID="lblLocCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>                                                                           
                                                                        </ItemTemplate>
                                                                    </asp:TemplateColumn>
                                                                    <asp:TemplateColumn HeaderStyle-BorderColor="#9AB8C3" HeaderStyle-BorderWidth="1"
                                                                        HeaderText="Line No" SortExpression="ExtendedNetWght">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblLocCode" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"CustItemNo") %>'></asp:Label>                                                                           
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Right" />
                                                                        <HeaderStyle HorizontalAlign="Center" Width="70px" />
                                                                    </asp:TemplateColumn>
                                                                    
                                                                    <asp:BoundColumn></asp:BoundColumn>
                                                                </Columns>
                                                                <PagerStyle Visible="False" />
                                                            </asp:DataGrid>
                                                            <%--<center><asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found" Visible="False"></asp:Label></center>--%>
                                                            <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                                            <asp:HiddenField ID="hidDelete" runat="server" />
                                                            <asp:HiddenField ID="hidLineNo" runat="server" />
                                                            <asp:HiddenField ID="hidLineCount" runat="server" />
                                                            <asp:Button ID="btnGetGrid" runat="server" Style="display: none;" OnClick="btnGetGrid_Click"
                                                                CausesValidation="false" />
                                                            <asp:Button ID="btnDelete" runat="server" Style="display: none;" CausesValidation="false"
                                                                OnClick="btnDelete_Click" />
                                                            <asp:Button ID="btnSearch" runat="server" Style="display: none;" CausesValidation="false"
                                                                OnClick="btnSearch_Click" />
                                                            <asp:Button ID="btnGrid" runat="server" Style="display: none;" CausesValidation="false"
                                                                OnClick="btnGrid_Click" />
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </div>
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
                                            <table id="tblItem" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td colspan="12">
                                                        <table cellpadding="0" cellspacing="0" id="trItemText">
                                                            <tr id="trItem">
                                                                <td height="20px" width="100" valign="top" class="TabHead " style="padding-left: 5px;">
                                                                    <strong>Item Number</strong></td>
                                                                <td class="TabHead " width="60" valign="top" style="padding-left: 5px;">
                                                                    <strong>Order Qty</strong></td>
                                                                <td class="TabHead " width="55" valign="top" style="padding-left: 5px;">
                                                                    <strong>Unit Cost</strong></td>
                                                                <td class="TabHead" width="70" valign="top" style="padding-left: 5px;">
                                                                    Cost UM
                                                                </td>
                                                                <td class="TabHead " width="60" valign="top" style="padding-left: 5px;">
                                                                    <a href="#" style="text-decoration: none;" class="TabHead" id="lnkUnitPrice"><strong>
                                                                        Price/Lb</strong></a></td>
                                                                <td class="TabHead " width="100" valign="top" style="padding-left: 5px;">
                                                                    <strong>Line Note</strong></td>
                                                                <td class="TabHead " width="180" valign="top" style="padding-left: 5px;" rowspan="2">
                                                                    <table>
                                                                        <tr>
                                                                            <td colspan="3" align="center" height="10px">
                                                                                Item Cost</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td height="10px" style="padding-left: 10px;">
                                                                                Average</td>
                                                                            <td height="10px" style="padding-left: 10px;">
                                                                                Standard</td>
                                                                            <td height="10px" style="padding-left: 10px;">
                                                                                Replacement</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td height="10px" style="padding-left: 10px;">
                                                                                <asp:TextBox ID="TextBox3" CssClass="txtBox small50px" runat="server" MaxLength="10"></asp:TextBox></td>
                                                                            <td height="10px" style="padding-left: 10px;">
                                                                                <asp:TextBox ID="TextBox4" CssClass="txtBox small50px" runat="server" MaxLength="10"></asp:TextBox></td>
                                                                            <td height="10px" style="padding-left: 10px;">
                                                                                <asp:TextBox ID="TextBox5" CssClass="txtBox small50px" runat="server" MaxLength="10"></asp:TextBox></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox AutoCompleteType="Disabled" ID="txtINo1" MaxLength="30" runat="server"
                                                                        onfocus="javascript:this.select();" CssClass="txtBox wide120px" Width="90px"></asp:TextBox>
                                                                    <asp:HiddenField runat="server" ID="hidItem" />
                                                                </td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox ID="txtReqQty" CssClass="txtBox small50px" runat="server" MaxLength="10"></asp:TextBox></td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:TextBox ID="TextBox1" CssClass="txtBox small50px" runat="server" MaxLength="10"></asp:TextBox>
                                                                </td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:Label ID="lblSellQty" CssClass="txtBox small50px" runat="server" Text=""></asp:Label></td>
                                                                <td style="padding-left: 3px">
                                                                    <asp:Label ID="Label9" CssClass="txtBox small50px" runat="server" Text=""></asp:Label>
                                                                </td>
                                                                <td style="padding-left: 5px">
                                                                    <asp:TextBox ID="TextBox2" CssClass="txtBox small50px" runat="server" MaxLength="10"></asp:TextBox>
                                                                    <asp:Label ID="lblPriceOrgin" CssClass="txtBox small50px" runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="5" style="height: 20px" class="splitborder_b_v">
                                                                    &nbsp;<asp:Label ID="lblDesription" runat="server" Text=""></asp:Label></td>
                                                                <td class="splitborder_b_v">
                                                                    &nbsp;<asp:Label ID="lblBuom" runat="server" Text=""></asp:Label></td>
                                                                <td class="splitborder_b_v">
                                                                    &nbsp;<asp:Label ID="lblSupEquiv" runat="server" Text=""></asp:Label></td>
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
                                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                                        </asp:UpdateProgress>
                                                        <asp:UpdatePanel ID="pnlProgress" runat="server" UpdateMode="conditional">
                                                            <ContentTemplate>
                                                                <asp:Label ID="lblMessage" ForeColor="red" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                    <td height="20px" align="right" colspan="2" width="35%" id="tdButton" style="padding-right: 3px;"
                                                        class="splitborder_t_v splitborder_b_v">
                                                        <asp:ImageButton ID="ibtnHideheader" ImageUrl="Common/Images/TV.gif" ToolTip="Clike here to Show/Hide Header"
                                                            runat="server" OnClientClick="javascript:return HideHeader('trItemText');" />
                                                        <asp:ImageButton ID="ibtnDeletedItem" ImageUrl="~/Common/Images/expand.gif" OnClientClick="javascript:SetGridHeight('ItemFamily');"
                                                            ToolTip="Click here to Show Deleted Item" OnClick="ibtnExband_Click" runat="server" />
                                                        <img src="Common/Images/search.gif" id="imgSearch" onclick="javascript:return ShowSearch('tblSearch');"
                                                            alt="Click here to Show/Hide search" />
                                                        <%-- <asp:ImageButton ID="ibtnQuoteWeight" ImageUrl="~/Common/Images/truck.jpg" Width=18px OnClientClick="javascript:OpenQuoteWeightForm();"
                                                            ToolTip="Show Customer Scheduled to Ship Weight"  runat="server" />  
                                                            <asp:ImageButton ID="ibtnFind" ImageUrl="~/Common/Images/find.gif" Width=18px Height=18px OnClientClick="javascript:return OpenSOFind();"
                                                            ToolTip="Click here to view SO Find Screen"  runat="server" />   --%>
                                                    </td>
                                                    <td colspan="2" class="splitborder_t_v splitborder_b_v">
                                                        <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                                            <ContentTemplate>
                                                                <uc5:PrintDialogue ID="PrintDialogue1" runat="server"></uc5:PrintDialogue>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="12" valign="middle" align="right" class="splitborder_t_v splitborder_b_v">
                                            <asp:Button ID="btnItemNo" name="btnItemNo" OnClick="btnItemNo_Click" runat="server"
                                                Text="Button" Style="display: none;" />
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
                                            <asp:ImageButton ID="imgShowItemBuilder" ImageUrl="~/Common/Images/showitembuilder.gif"
                                                runat="server" AlternateText="Show Item Builder" OnClick="imgShowItemBuilder_Click"
                                                OnClientClick="Javascript:document.getElementById('TDFamily').style.display='';SetGridHeight('ItemFamily');return true;" /><asp:ImageButton
                                                    ID="ibtnHide" ImageUrl="~/Common/Images/hideitembuilder.gif" runat="server" AlternateText="Hide Item Builder"
                                                    OnClick="ibtnHide_Click" OnClientClick="Javascript:document.getElementById('TDFamily').style.display='none';SetGridHeight('ItemFamily');return true;"
                                                    Visible="false" />
                                            <asp:ImageButton ID="ibtnClear" Style="display: none;" CausesValidation="false" ImageUrl="~/Common/Images/save.jpg"
                                                runat="server" OnClick="ibtnClear_Click" />
                                            <asp:ImageButton ID="btnOrderDelete" Style="display: none;" ImageUrl="~/Common/Images/btnDelete.gif"
                                                runat="server" AlternateText="Delete Order" OnClick="btnOrderDelete_Click" />
                                            <img id="ibtnDelete" runat="server" src="Common/Images/btnDelete.gif" alt="Delete Order"
                                                onclick="javascript:DeleteConfirmation();" />
                                            <asp:ImageButton ID="imgMakeQuotation" Style="display: none;" ImageUrl="~/Common/Images/submit.gif"
                                                runat="server" AlternateText="Make Quote" OnClick="imgMakeQuotation_Click" OnClientClick="Javscript:return ValidateQuoteDet();" />
                                            <img src="Common/Images/makeorder.gif" id="imgMO" runat="server" onclick="javascript:OpenMakeOrderType();" />
                                            <asp:ImageButton ID="imgMakeOreder" runat="server" Style="display: none;" AlternateText="Make Order"
                                                ImageUrl="~/Common/Images/makeorder.gif" OnClick="imgMakeOreder_Click" />
                                            <asp:HiddenField ID="hidShowHide" runat="server" />
                                            <asp:ImageButton ID="imgHelp" runat="server" CausesValidation="false" AlternateText="Help"
                                                ImageUrl="~/Common/Images/help.gif" />
                                            <img id="ibtnClose" src="Common/Images/Close.gif" onclick="javascript:parent.window.close();" />
                                            <asp:HiddenField ID="hidFocus" runat="server" />
                                            <asp:HiddenField ID="hidIsReadOnly" Value="false" runat="server" />
                                            <asp:HiddenField ID="hidCommandLineReadOnly" Value="false" runat="server" />
                                            <asp:HiddenField ID="hidExpenseReadOnly" Value="false" runat="server" />
                                            <asp:HiddenField ID="hidMOrderType" runat="server" />
                                            <asp:HiddenField ID="hidisDifferentUser" runat="server" />
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
        <div id="divDelete" class="MarkItUp_ContextMenu_MenuTable" style="display: none;
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
                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:return CallBtnClick('btnDelete');">
                                    <strong>Delete</strong></td>
                            </tr>
                            <tr class="MarkItUp_ContextMenu_MenuItem" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'"
                                onmouseover="this.className='GridHead'">
                                <td class="" width="20">
                                    <img src="Common/Images/cancelrequest.gif" /></td>
                                <td align="left" class="" style="cursor: hand;" onclick="Javascript:document.getElementById('divDelete').style.display='none';document.getElementById(hidRowID.value).style.fontWeight='normal';">
                                    <strong>Cancel</strong><input type="hidden" value="" id="hidRowID" /></td>
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

</body>
</html>
