// JScript File

function validateFocus()
{
    document.getElementById("txtContract").focus();
    
    
}

// Javascript Function To Call Server Side Function Using Ajax
function ValidatePFCItem()
{
    var str=VMIContractMaintenance.ValidatePFCItem(document.getElementById("txtPFCItemNo").value).value.toString();
    document.getElementById("txtDesc").value=str.split("~")[0];
    
    if(str.split("~")[1]=="false")
    {
        alert("Invalid Item #");
        document.getElementById("txtPFCItemNo").value="";
        document.getElementById("txtPFCItemNo").focus();
    }
}

function SetFocus(ctrlId)
{   
    var newCtrlID=ctrlId.replace("txtLoc","txtAnnualQty");
    document.getElementById(newCtrlID).focus();    
}
  
function GetSaveData()
{
    var strSaveData='';
    for(var i=2;i<dgReport.rows.length;i++)
    {
        strSaveData+=document.getElementById("txtBranch"+i).value+","+
                    document.getElementById("txtLoc"+i).value+","+
                    document.getElementById("txtAnnualQty"+i).value+","+
                    document.getElementById("txtDay"+i).value+"~";
    }
    strSaveData=((strSaveData.indexOf('~')!=-1)?strSaveData.substring(0,strSaveData.length-1):strSaveData);
    document.getElementById('hidSaveData').value=strSaveData;
    
}
    
function ValidateNumber()
{
    
     if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0;
}  


function TextFocus()
{
   var rowFocus=dgReport.rows[1].cells[0].focus();  
}

function roundNumber(number,decimal_points,ctrl)
{
	if(!decimal_points) return Math.round(number.replace(/\,/g,""));
	if(number == 0) {
		var decimals = "";
		for(var i=0;i<decimal_points;i++) decimals += "0";
		return "0."+decimals;
	}

	var exponent = Math.pow(10,decimal_points);
	var num = Math.round((number.replace(/\,/g,"") * exponent)).toString();
	ctrl.value= num.slice(0,-1*decimal_points) + "." + num.slice(-1*decimal_points);
}

function ShowToolTip(event,ctlID)
{
    if(event.button==2)
    {
        deleteRowId=ctlID.substring(ctlID.length-1,ctlID.length);
        xstooltip_show('divToolTip',ctlID,289, 49);
        return false;
    }
}

function Hide()
{
    if(event.button!=2)
            xstooltip_hide('divToolTip');
}

function SetVal(ctlID)
{
    if(ctlID=='imgDivClose')
      xstooltip_hide('divToolTip');
    else 
    {
        if(ctlID=='divToolTip')
            hid='true';
        else 
            hid='';
    }
}

