// JScript File

var keyCoded=0;
var pressCount=0;
 function MenuShortCuts()
{ 
    if(pressCount==0 && window.event.keyCode==106)
    { 
        keyCoded = window.event.keyCode;
        event.keyCode=0;
        pressCount=1;
        return false;
    }
    else if(pressCount ==1 && (window.event.keyCode >=96 && window.event.keyCode <106))   
    {
        var kCode = window.event.keyCode;
       event.keyCode=0;
        pressCount=0;
        switch(kCode)
        {
             case 96:
                if(parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value !="")
                {
                    popUp=window.open ("CommentEntry.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value+"&InvoiceDate="+parent.bodyFrame.form1.document.getElementById("txtInvDate").innerHTML,"Maximize",'height=590,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (590/2))+',left='+((screen.width/2) - (714/2))+',resizable=YES',"");
                    popUp.focus();
                }
                break;
             case 97:
                if(parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value !="")
                {
                    var hwnd=window.open('http://208.29.238.26/intranetsite/CustomerMaintenance/CustomerMaintenance.aspx?Mode=Query&CustomerNumber='+parent.bodyFrame.form1.document.getElementById("CustDet_txtCustNo").value ,'CustomerMaintenance','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
			        hwnd.focus();
			    }
			    else
                    alert("Enter Customer Number");
                break; 
             case 98:
                 var hwnd=window.open('http://208.29.238.26/intranetsite/CustomerContact/Customercontact.aspx' ,'CustomerMaintenance','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	
			     hwnd.focus();
                 break;
             case 99:
                if(parent.bodyFrame.form1.document.getElementById("hidExpenseReadOnly").value =="false")
             {        
                if(parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value !="" )
                {
                    popUp=window.open ("EnterExpenses.aspx?SONumber="+parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value+"&InvoiceDate="+parent.bodyFrame.form1.document.getElementById("txtInvDate").innerHTML,"EnterExpenses",'height=470,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                    popUp.focus();
                }
                else
                    alert("Enter SO Number");
             }
             else
                alert("This Order is not editable."); 
                break;
             case 100:
                 popUp=window.open ("SOFind.aspx","SOFind",'height=600,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (590/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                popUp.focus();
                break;
             case 101:
                var itemno = "";
                var shipfrom = "";
                if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
                {
                    var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
                    itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
                    shipfrom = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblLocCode')).innerText;
                        
                }
                var queryString="ItemNumber="+itemno+"&ShipLoc="+shipfrom;
                popUp=window.open ("ItemCard.aspx?"+queryString,"Maximize",'height=380,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                popUp.focus();
                break;
             case 102:
                   if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
                 {
                var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
                var itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
                var shipfrom = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblLocCode')).innerText;
                var reqQty = parent.bodyFrame.form1.document.getElementById(ctrlId).value;
                var altQty = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','txtQty')).value;
                var avaQty = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblAvailQty')).innerText;
               
                var queryString="ItemNumber="+itemno+"&ShipLoc="+shipfrom+"&RequestedQty="+reqQty+"&AltQty="+altQty+"&AvailableQty="+avaQty
             
                popUp=window.open ("PackingAndPlating.aspx?"+queryString,"PackingAndPlating",'height=450,width=400,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (400/2))+',resizable=NO',"");
                popUp.focus();
                 }
                 else
                 {
                  popUp=window.open ("PackingAndPlating.aspx","PackingAndPlating",'height=450,width=400,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (400/2))+',resizable=NO',"");
                    popUp.focus();
                 }
                break;
             case 103:
                   popUp=window.open ("PendingOrdersAndQuotes.aspx","Maximize",'height=470,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (470/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
                popUp.focus();
                break;
             case 104:
                 var itemno = "";
                var shipfrom = "";
                if(parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value !="")
                {
                    var ctrlId=parent.bodyFrame.form1.document.getElementById('hidGridCurControl').value;
                    itemno = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblPFCItemNo')).innerText;
                    shipfrom = parent.bodyFrame.form1.document.getElementById(ctrlId.replace('txtQty','lblLocCode')).innerText;
                        
                }
                var queryString="ItemNumber="+itemno+"&ShipLoc="+shipfrom;
                popUp=window.open ("StockCheck.aspx?"+queryString,"Maximize",'height=650,width=850,scrollbars=no,status=no,top='+((screen.height/2) - (650/2))+',left='+((screen.width/2) - (850/2))+',resizable=NO',"");
                popUp.focus();
                break;
             case 105:
                  var orderno=parent.bodyFrame.form1.document.getElementById("CustDet_txtSONumber").value.replace('W','').replace('w','');           
                popUp=window.open ("SoRecall/ProgressBar.aspx?destPage=SORecall.aspx?DocNo="+orderno+"~DocType=S" ,'SORecall','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');
                popUp.focus();
                break;
        }
         return false;
    } 
}

