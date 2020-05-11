// JScript File
function BindOrderEntryForm(soNumber)
{
    var txtSONumber = window.opener.parent.bodyFrame.document.getElementById("CustDet_txtSONumber"); 
    window.opener.parent.bodyFrame.document.getElementById("CustDet_hidPreviousValue").value = "";          
    txtSONumber.value = soNumber;
    window.opener.parent.bodyFrame.LoadDetails(txtSONumber.value);
    window.close();
    txtSONumber.focus(); 
    return false;
}

function BindEntryForm(soNumber)
{
    var txtSONumber = window.opener.parent.bodyFrame.document.getElementById("CustDet_txtSONumber"); 
    window.opener.parent.bodyFrame.document.getElementById("CustDet_hidPreviousValue").value = "";          
    txtSONumber.value = soNumber;
    window.opener.parent.bodyFrame.LoadDetails(txtSONumber.value);
    window.focus();
    return false;
}