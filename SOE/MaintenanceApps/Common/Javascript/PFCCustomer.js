// JScript File to fetch the customer details
var txtCust=document.getElementById("CustDet_txtCustNo");
var hidCustNo=document.getElementById("CustDet_hidCust");

//
// Function to bind the customer no in the listbox
//
function ListCustomer(keyValue)
{
    var txtValue=document.getElementById("CustDet_txtCustNo").value+String.fromCharCode(keyValue);
    if(txtValue!="" && !IsNumeric(txtValue) && keyValue!=9)
        LoadCustNo(txtValue);
}
function OpenWorkSheet()
{
    if(document.getElementById("CustDet_txtCustNo").value !="")
    {
            var hwind = window.open("PriceWorksheet.aspx",'WorkSheet' ,'height=560,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (560/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
              hwind.focus();
    }
}
function GetCustomerDetail(custno)
{
       var Url = "CustomerList.aspx?Customer=" +document.getElementById("CustDet_txtCustNo").value;
         // 
          if (!window.showModalDialog) 
          window.showModalDialog(Url,'dialogWidth:714;dialogHeight:465;scrollbars=no;status=no;top='+((screen.height/2) - (500/2))+';left='+((screen.width/2) - (714/2))+';resizable=NO');
          else
          {
          var hwind = window.open(Url,'CustomerList' ,'height=450,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
          hwind.focus();
          }
         // 
          return false;
          
}
 

// Function to allow the numeric value only
function ValdateNumbers()
{
    if(event.keyCode == 13)
    {
        BindCustomerDetail(); 
         event.keyCode=0;
         return false;
        
        }
    else if(event.keyCode<47 || event.keyCode>58)
        event.keyCode=0;
}




function LoadDetail()
{   

    //document.getElementById("CustDet_lstCustDetails").style.display='none';
    if(document.getElementById("CustDet_hidCust").value=="" || document.getElementById("CustDet_hidCust").value!=document.getElementById("CustDet_txtCustNo").value)
    {
        document.getElementById("CustDet_hidCust").value=document.getElementById("CustDet_txtCustNo").value;
    
        if(document.getElementById("CustDet_txtCustNo").value.replace(/\s/g,'')!='')
            document.getElementById("lblMessage").innerHTML="";
    
        // Call the server side button click event
        if(document.getElementById("CustDet_txtCustNo").value.replace(/\s/g,'')!="" && IsNumeric(document.getElementById("CustDet_txtCustNo").value))
        {
            CallBtnClick('CustDet_btnLoadCustomer');
            return false;
        }
    }
   
    if(document.getElementById("CustDet_txtCustNo").value.replace(/\s/g,'')!='' && !(IsNumeric(document.getElementById("CustDet_txtCustNo").value)))
    {
         // Call the server side function to get the Customerlist details
         var custList= OrderEntry.GetCustList(document.getElementById("CustDet_txtCustNo").value).value;
         if(parseInt(custList)>100)
         {
            document.getElementById("CustDet_txtCustNo").focus();
            alert('Entered value is too small to retrieve the customer name.please enter additional characters');
            return false;
          }            
          var Url = "CustomerList.aspx?CustName=" +document.getElementById("CustDet_txtCustNo").value;
          window.open(Url,'CustomerList' ,'height=450,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (645/2))+',resizable=NO,scrollbars=YES','');
          return false;
          document.getElementById("CustDet_txtSONumber").focus();
    }
     
     
}