<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftFrame.ascx.cs" Inherits="PFC.SOE.UserControls.LeftFrame" %>
<table class=LeftBg" cellspacing="0" cellpadding="0" height="100%">
<tr>
<td valign="top" class="LeftBg">
<table id="LeftMenuContainer" width="180" border="0" cellspacing="0" cellpadding="2">
      <tr>
        <td class="ShowHideBarBk" id="HideLabel"><div align="right">Click to 
			hide this menu</div></td>
        <td width="1" class="ShowHideBarBk"><div align="right" id="SHButton"><img ID="Hide" style="cursor:hand" src="Common/Images/HidButton.gif" width="22" height="21" onclick="ShowHide(this)" onload="ShowHide(this)"></div></td>
      </tr>
      <tr valign="top">   
        </tr>
    </table>
    <table id="LeftMenu" width="100%"  border="0" cellspacing="0" cellpadding="0">
       <tr valign="top">
           <td width="100%" valign="top" >            
               <asp:Menu Width="100%" ID="Menu1" runat="server" ItemWrap=true MaximumDynamicDisplayLevels=25 >               
                <StaticHoverStyle CssClass="leftMenuItemMo" />
                   <StaticMenuStyle CssClass="leftMenuItem" Height="25px" />
                   <StaticMenuItemStyle CssClass="leftMenuItemBorder" Height="25px" HorizontalPadding="20px" />
                   <Items>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(0);'>Comment Entry</div>" Value="Comment Entry" ></asp:MenuItem>                       
                       <asp:MenuItem Text="<div onclick='return OpenPopups(1);'>Enter Expenses</div>" Value="Enter Expenses"></asp:MenuItem>                       
                       <asp:MenuItem Text="<div onclick='return OpenPopups(2);'>Item Card</div>" Value="Item Card"></asp:MenuItem>                      
                       <asp:MenuItem Text="<div onclick='return OpenPopups(3);'>PO Recall</div>" Value="PO Recall"></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(4);'>Stock Check</div>" Value="Stock Check"></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(5);'>Vendor Price comparison</div>" Value="Vendor Price comparison" ></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(6);'>Vendor Card</div>" Value="Vendor Card"></asp:MenuItem>
                     
                    <%--   <asp:MenuItem Text="<div onclick='return OpenPopups(12);'>SO Line Change</div>" Value="SO Line Change"></asp:MenuItem>
                       <asp:MenuItem Text="<div onclick='return OpenPopups(15);'>Unit Quantity Calculator</div>" Value="Unit Quantity Calculator"></asp:MenuItem>                       --%>
                   </Items>
                   <StaticSelectedStyle />
                </asp:Menu>    
           </td>       
       </tr>		 
      </table>
</td>
</tr>
</table>

<script>
 
 function OpenPopups(formName)
 {
    var popUp;
    if(parent.bodyFrame.form1.document.getElementById("txtPO").value !="")
    {
        switch(formName)
        {
        case 0:
           popUp=window.open ("CommentEntry.aspx?PONumber="+parent.bodyFrame.form1.document.getElementById("txtPO").value+"&UserName="+'<%= Request.QueryString["UserName"].ToString().Trim() %>',"POCommentEntry",'height=550,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
         popUp.focus();    
        break;
        case 1:
                 popUp=window.open ("EnterExpenses.aspx?PONumber="+parent.bodyFrame.form1.document.getElementById("txtPO").value+"&UserName="+'<%= Request.QueryString["UserName"].ToString().Trim() %>',"POEnterExpenses",'height=470,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
         popUp.focus();    
        break; 
        case 3:
                 popUp=window.open ("PORecall.aspx?PONumber="+parent.bodyFrame.form1.document.getElementById("txtPO").value,"PORecall",'height=620,width=857,scrollbars=no,status=no,top='+((screen.height/2) - (650/2))+',left='+((screen.width/2) - (857/2))+',resizable=NO',"");
         popUp.focus();    
        break;
        }
    }
    else
    {
        alert("Enter PO Number");
        parent.bodyFrame.form1.document.getElementById("txtPO").focus(); 
    }
    return false;
 }

// 
//    function OpenPopups(formName)
//    {
//        var popUp;
//         switch(formName)
//        {
//            case 0:
//            if(parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value !="")
//            {
//                popUp=window.open ("CommentEntry.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value+"&InvoiceDate="+parent.bodyFrame.form1.document.getElementById("txtInvDate").innerHTML,"Maximize",'height=590,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (590/2))+',left='+((screen.width/2) - (714/2))+',resizable=YES',"");
//                popUp.focus();
//            }
//            else
//            alert("Enter SO Number");
////                popUp=window.open ("Common/TempPages/Comment Entry.htm","mywindow",'height=532,width=700,scrollbars=no,status=no,top='+((screen.height/2) - (535/2))+',left='+((screen.width/2) - (700/2))+',resizable=YES',"");     
////                popUp.focus();
//            break;
//            case 1:
//            if(parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value !="")
//            {
//                //var hwnd=window.open('http://208.29.238.26/intranetsite/CustomerMaintenance/CustomerMaintenance.aspx?Mode=Query&CustomerNumber='+parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value ,'CustomerMaintenance','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
//                var hwnd=window.open('http://10.1.36.34/intranetsite/CustomerMaintenance/CustomerMaintenance.aspx?Mode=Query&CustomerNumber='+parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value ,'CustomerMaintenance','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
//			    hwnd.focus();
//			}
//			  else
//            alert("Enter Customer Number");
//            break;
//            case 2:
//                popUp=window.open ("Common/TempPages/Job Information.htm","ShippingMarks",'height=239,width=564,scrollbars=no,status=no,top='+((screen.height/2) - (245/2))+',left='+((screen.width/2) - (563/2))+',resizable=YES',"");   
//                popUp.focus();
//            break;
//            case 3:
//                var hwnd=window.open('http://10.1.36.34/intranetsite/CustomerContact/Customercontact.aspx' ,'CustomerMaintenance','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
//			    hwnd.focus();
//            break;
//            case 4:
//             //if(parent.bodyFrame.form1.document.getElementById("hidIsReadOnly").value =="false" && parent.bodyFrame.form1.document.getElementById("CustDet_hidTableName").value=="SOHeader")
//             if(parent.bodyFrame.form1.document.getElementById("hidIsReadOnly").value =="false")
//             {  
//                if(parent.bodyFrame.form1.document.getElementById("hidShippedDate").value =="")
//                {
//                    if(parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value !="")
//                    {
//                     popUp=window.open ("ShippingMarks.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value,"ShippingMarks",'height=465,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO,modal=yes',"");
//                    }
//                    else
//                        alert("Enter SO Number"); 
//                }
//                else
//                    alert("This Order is not editable."); 
//             }
//             else
//                alert("This Order is not editable."); 
//            break;
//            case 5:    
//             if(parent.bodyFrame.form1.document.getElementById("hidExpenseReadOnly").value =="false")
//             {        
//                if(parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value !="" )
//                {
//                    popUp=window.open ("EnterExpenses.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value+"&InvoiceDate="+parent.bodyFrame.form1.document.getElementById("txtInvDate").innerHTML,"EnterExpenses",'height=470,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
//                    popUp.focus();
//                }
//                else
//                    alert("Enter SO Number");
//             }
//             else
//                alert("This Order is not editable."); 
//                break;
//            case 6:                   
//                popUp=window.open ("SOFind.aspx","SOFind",'height=600,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (590/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
//                popUp.focus();
//                break;
//             case 7:
//                popUp=window.open ("Common/TempPages/Freight Estimator.htm","Maximize",'height=371,width=712,scrollbars=no,status=no,top='+((screen.height/2) - (371/2))+',left='+((screen.width/2) - (716/2))+',resizable=YES',"");
//                popUp.focus();
//                break;
//            case 8: // Pending Order & Quotes
//                popUp=window.open ("PendingOrdersAndQuotes.aspx","Maximize",'height=470,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (470/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
//                popUp.focus();
//                break;
//             case 9:
//                var itemno = "";
//                var shipfrom = "";
//                if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
//                {
//                    var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
//                    itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
//                    shipfrom = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblLocCode')).innerText;                        
//                }
//                var queryString="ItemNo="+itemno;
//                popUp=window.open ("StockStatus.aspx?"+queryString,"Maximize",'height=560,width=1100,scrollbars=no,status=no,top='+((screen.height/2) - (560/2))+',left='+((screen.width/2) - (1100/2))+',resizable=NO',"");
//                popUp.focus();
//                break;
//           
//             case 10:
//                popUp=window.open ("Common/TempPages/PO Recall.htm","Maximize",'height=622,width=801,scrollbars=no,status=no,top='+((screen.height/2) - (623/2))+',left='+((screen.width/2) - (800/2))+',resizable=YES',"");
//                popUp.focus();
//                break;
//             case 11:
//                case 11:
//                
//                    popUp=window.open ("ShippingStatus.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value,"ShipmentStatus",'height=610,width=870,scrollbars=no,status=no,top='+((screen.height/2) - (610/2))+',left='+((screen.width/2) - (870/2))+',resizable=NO',"");
//                    popUp.focus();
//                                  
//               break;
//             case 12:
//                popUp=window.open ("Common/TempPages/SO Line Change.htm","Maximize",'height=620,width=799,scrollbars=no,status=no,top='+((screen.height/2) - (620/2))+',left='+((screen.width/2) - (799/2))+',resizable=YES',"");
//                popUp.focus();
//                break;
//             case 13:
//                popUp=window.open ("Common/TempPages/Shipment Planning.html","ShipmentPlanning",'height=369,width=713,scrollbars=no,status=no,top='+((screen.height/2) - (372/2))+',left='+((screen.width/2) - (714/2))+',resizable=YES',"");
//                popUp.focus();
//                break;
//             case 14:
//                 if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
//                 {
//                var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
//                var itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
//                var shipfrom = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblLocCode')).innerText;
//                var reqQty = parent.bodyFrame.form1.document.getElementById(ctrlId).value;
//                var altQty = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','txtQty')).value;
//                var avaQty = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblAvailQty')).innerText;
//               
//                var queryString="ItemNumber="+itemno+"&ShipLoc="+shipfrom+"&RequestedQty="+reqQty+"&AltQty="+altQty+"&AvailableQty="+avaQty
//             
//                popUp=window.open ("PackingAndPlating.aspx?"+queryString,"PackingAndPlating",'height=450,width=400,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (400/2))+',resizable=NO',"");
//                popUp.focus();
//                 }
//                 else
//                 {
//                  popUp=window.open ("PackingAndPlating.aspx","PackingAndPlating",'height=450,width=400,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (400/2))+',resizable=NO',"");
//                    popUp.focus();
//                 }
//                break;
//             case 15:
//                popUp=window.open ("Common/TempPages/UnitQuantity.htm","UnitQuantity",'height=393,width=374,scrollbars=no,status=no,top='+((screen.height/2) - (393/2))+',left='+((screen.width/2) - (374/2))+',resizable=NO',"");
//                popUp.focus();
//                break;
//             case 16:
//                popUp=window.open ("Common/TempPages/TimePhase.htm","PackingAndPlating",'height=396,width=711,scrollbars=no,status=no,top='+((screen.height/2) - (396/2))+',left='+((screen.width/2) - (711/2))+',resizable=NO',"");
//                popUp.focus();
//                break;
//            case 17:
//                var orderno=parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value.replace('W','').replace('w','');           
//                popUp=window.open ("SoRecall/ProgressBar.aspx?destPage=SORecall.aspx?DocNo="+orderno+"~DocType=S" ,'SORecall','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');
//                popUp.focus();
//                break;
//            case 18:
//                popUp=window.open ("Common/TempPages/ItemHistory.htm","ItemHistory",'height=625,width=775,scrollbars=no,status=no,top='+((screen.height/2) - (625/2))+',left='+((screen.width/2) - (775/2))+',resizable=YES',"");
//                popUp.focus();
//                break;
//            case 19:
//                popUp=window.open ("Common/TempPages/VendorCard.htm","VendorCard",'height=390,width=710,scrollbars=no,status=no,top='+((screen.height/2) - (390/2))+',left='+((screen.width/2) - (710/2))+',resizable=YES',"");
//                popUp.focus();
//                break;
//            case 20:
//                var itemno = "";
//                var shipfrom = "";
//                if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
//                {
//                    var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
//                    itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
//                    shipfrom = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblLocCode')).innerText;
//                        
//                }
//                var queryString="ItemNumber="+itemno+"&ShipLoc="+shipfrom;
//                popUp=window.open ("ItemCard.aspx?"+queryString,"Maximize",'height=380,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
//                popUp.focus();
//                break;
//            case 21:   
//                popUp=window.open ("salesHistory.aspx?CustomerNumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value+"&SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value,"SalesHistory",'height=450,width=800,scrollbars=no,status=no,top='+((screen.height/2) - (400/2))+',left='+((screen.width/2) - (800/2))+',resizable=NO',"");
//                popUp.focus();                
//                break;
//            case 22:  
//                window.open('PriceWorksheet.aspx?QuickQuote=1','QuickQuote','height=560,width=1000,toolbar=0,scrollbars=0,status=0,resizable=YES,top='+((screen.height/2) - (560/2))+',left='+((screen.width/2) - (1000/2)))
//                break;
//            case 23:  
//                popUp= window.open('CreditRGA.aspx?QuickQuote=1','QuickQuote','height=560,width=1000,toolbar=0,scrollbars=0,status=0,resizable=YES,top='+((screen.height/2) - (560/2))+',left='+((screen.width/2) - (1000/2)))
//                popUp.focus();
//                break;
//        }
//        if(popUp !="undefined")
//            
//        return false;
//    }    
</script>