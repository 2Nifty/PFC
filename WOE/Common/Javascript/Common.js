function OpenPrintDialog(PrintDialogURL, PageURL, Mode, Title, PageSetup, CustNo, EnableEmail, EnableFax, FormName)
{
    var Url =   PrintDialogURL + 
                "?pageURL=" + PageURL + 
                "&Mode=" + Mode + 
                "&Title=" + Title + 
                "&PageSetup=" + PageSetup + 
                "&CustomerNumber=" + CustNo + 
                "&EnableEmail=" + EnableEmail + 
                "&EnableFax=" + EnableFax + 
                "&FormName=" + FormName;
                
    window.open(Url,"PrintUtility" ,'height=300,width=650,scrollbars=yes,status=no,top='+((screen.height/2) - (320/2))+',left='+((screen.width/2) - (650/2))+',resizable=No',"");
}

// Function to allow the numeric value only
function ValidateNumber()
{
    if(event.keyCode<48 || event.keyCode>57)
        event.keyCode=0;
}

//-------------------------------------------
// Verify Valid Date
var dtCh= "/";
var minYear=1900;
var maxYear=2100;

function ValidateDate(txtDate,txtID)
{
    if(txtDate!="")
    {
        if (isDate(txtDate.replace(/\s/g,''))==false)
        {
            document.getElementById(txtID).value="";
            document.getElementById(txtID).focus()
            return false
        }
        //If the date is good, call it again to get it back formatted
        document.getElementById(txtID).value=isDate(txtDate.replace(/\s/g,''))
        return true
    }
}

function isDate(dtStr)
{
    var daysInMonth = DaysArray(12)
    var pos1=dtStr.indexOf(dtCh)
    //If slashes aren't there, add them
    if (pos1==-1 )
    {
        dtStr=dtStr.substring(0,2) + dtCh + dtStr.substring(2,4) + dtCh + dtStr.substring(4)
        pos1=dtStr.indexOf(dtCh)
    }
    var pos2=dtStr.indexOf(dtCh,pos1+1)
    var strMonth=dtStr.substring(0,pos1)
    var strDay=dtStr.substring(pos1+1,pos2)
    var strYear=dtStr.substring(pos2+1)
    var curDate = new Date()
    var curYear = new String(curDate.getFullYear())
    if (strYear.length == 2 )
    {
        strYear=curYear.substring(0,2) + strYear
        dtStr=dtStr.substring(0,6) + strYear
    }
    strYr=strYear
    if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
    if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
    for (var i = 1; i <= 3; i++)
    {
        if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)

    }
    month=parseInt(strMonth)
    day=parseInt(strDay)
    year=parseInt(strYr)
    if (pos1==-1 || pos2==-1)
    {
        alert("The date format should be : mm/dd/yyyy")
        return false
    }
    if (strMonth.length<1 || month<1 || month>12)
    {
        alert("Please enter a valid month")
        return false
    }
    if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month])
    {
        alert("Please enter a valid day")
        return false
    }
    if (strYear.length != 4 || year==0 || year<minYear || year>maxYear)
    {
        alert("Please enter a valid year ")
        return false
    }
    if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false)
    {
        alert("Please enter a valid date")
        return false
    }
    return dtStr
}

function DaysArray(n)
{
    for (var i = 1; i <= n; i++)
    {
        this[i] = 31
        if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
        if (i==2) {this[i] = 29}
    } 
    return this
}

function daysInFebruary (year)
{
    //February has 29 days in any year evenly divisible by four,
    //EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}

function isInteger(s)
{
    var i;
    for (i = 0; i < s.length; i++)
    {   
        //Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    //All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag)
{
    var i;
    var returnString = "";
    //Search through string's characters one by one.
    //If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++)
    {   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}
// End Verify Valid Date
//-------------------------------------------

function ZItem(itemNo, itemCtl)
{
    if(itemNo!="")
    {
        var section="";
        var completeItem=0;
       
        switch(itemNo.split('-').length)
        {
        case 1:
            event.keyCode=0;
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            document.getElementById(itemCtl).value=itemNo+"-"; 
            return ;
            break;
        case 2:
            event.keyCode=0;
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            document.getElementById(itemCtl).value=itemNo.split('-')[0]+"-"+section+"-";  
            return ;
            break;
        case 3:
            event.keyCode=0;
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            document.getElementById(itemCtl).value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
            completeItem=1;
            break;
        }
        if (completeItem==1)
        {
            if (document.getElementById('hidItemNo') != null)
                document.getElementById('hidItemNo').value = document.getElementById(itemCtl).value;
            if (document.getElementById('hidItemCtl') != null)
                document.getElementById('hidItemCtl').value = itemCtl;
            //alert(document.getElementById('hidItemNo').value + ' --- ' + document.getElementById('hidItemCtl').value);
            document.form1.btnPFCItem.click();
        }
    }    
}