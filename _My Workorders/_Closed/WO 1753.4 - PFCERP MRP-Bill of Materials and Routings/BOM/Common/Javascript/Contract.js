// JScript File

function roundMoney(ctrlVal,ctrlID)
{
    if(ctrlVal!=null && ctrlVal!="")
    {
         var strVal=eval(ctrlVal.replace(/\,/g,"")).toFixed(2);
         document.getElementById(ctrlID).value=addCommas(strVal);
    }
} 

//
// round the numbers
//

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

  
//
// add the commas
//
    
function addCommas(nStr) 
{
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
	    x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;

}