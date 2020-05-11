﻿//  JScript File

var dtCh = "/";
var minYear = 1900;
var maxYear = 2100;

function OpenDatePicker(ctlId)
{
    //alert("datepicker");

    var _hidParentErrCtlId = document.getElementById(ctlId.replace("ibtnDatePicker","hidParentErrCtl"));
    if (_hidParentErrCtlId.value != "")
        document.getElementById(_hidParentErrCtlId.value).innerHTML = '';

    //Get the Site Url from Codebehind function        
    //var PageName = <%=GetSiteURL() %>;
    //var PageName = '../Common/DatePicker/DatePicker_ClientInterface.aspx';
    var PageName = 'Common/DatePicker/DatePicker_ClientInterface.aspx';
    var url = PageName  + '?txtID=' + ctlId;
    //alert(url);
    var hWnd=window.open(url, 'DatePicker', 'width=320,height=157,top='+((screen.height/2) - (310/2))+' ,left='+((screen.width/2) - (310/2))+'');
    hWnd.opener = self;	
    if (window.focus) {hWnd.focus()}
    return false;
}

function ValidateDate(txtDate, ctlId)
{
    //alert("ValidateDate");
    var _hidParentErrCtlId = document.getElementById(ctlId.replace("txtDatePicker","hidParentErrCtl"));
    
    if(txtDate!="")
    {
        txtDate = txtDate.replace(/-/g,'/');
        //alert(txtDate);
        if (isDate(txtDate.replace(/\s/g,'')) == false)
        {
            document.getElementById(ctlId).value = "";
            document.getElementById(ctlId).select();
            if (_hidParentErrCtlId.value != "")
            {
                document.getElementById(_hidParentErrCtlId.value).innerHTML = 'Valid date format is MM/DD/YYYY';
                document.getElementById(_hidParentErrCtlId.value).style.color = "red";
            }
            return false;
        }
        // If the date is good, call it again to get it back formatted
        document.getElementById(ctlId).value = isDate(txtDate.replace(/\s/g,''));
        if (_hidParentErrCtlId.value != "")
            document.getElementById(_hidParentErrCtlId.value).innerHTML = '';
        return true;
    }
    return false;
}

function isDate(dtStr)
{
	var daysInMonth = DaysArray(12);
	var pos1 = dtStr.indexOf(dtCh);
	
	// If slashes aren't there, add them
	if (pos1 == -1 )
	{
		dtStr = dtStr.substring(0,2) + dtCh + dtStr.substring(2,4) + dtCh + dtStr.substring(4);
		pos1 = dtStr.indexOf(dtCh);
	}
	
	var pos2 = dtStr.indexOf(dtCh,pos1+1);
	var strMonth = dtStr.substring(0,pos1);
	var strDay = dtStr.substring(pos1+1,pos2);
	var strYear = dtStr.substring(pos2+1);
	var curDate = new Date();
	var curYear = new String(curDate.getFullYear());

	if (strYear.length == 2 )
	{
        strYear = curYear.substring(0,2) + strYear;
		dtStr = dtStr.substring(0,6) + strYear;
	}
	
	strYr = strYear;
	if (strDay.charAt(0) == "0" && strDay.length > 1) strDay = strDay.substring(1);
	if (strMonth.charAt(0) == "0" && strMonth.length > 1) strMonth = strMonth.substring(1);
	for (var i = 1; i <= 3; i++)
		if (strYr.charAt(0) == "0" && strYr.length > 1) strYr = strYr.substring(1);

	month = parseInt(strMonth);
	day = parseInt(strDay);
	year = parseInt(strYr);
	if (pos1 == -1 || pos2 == -1)
	{
//		alert("The date format should be : mm/dd/yyyy");
		return false;
	}
	if (strMonth.length < 1 || month < 1 || month > 12)
	{
//		alert("Please enter a valid month");
		return false;
	}
	if (strDay.length < 1 || day < 1 || day > 31 || (month == 2 && day > daysInFebruary(year)) || day > daysInMonth[month])
	{
//		alert("Please enter a valid day");
		return false;
	}
	if (strYear.length != 4 || year == 0 || year < minYear || year > maxYear)
	{
//		alert("Please enter a valid year");
		return false;
	}
	if (dtStr.indexOf(dtCh,pos2+1) != -1 || isInteger(stripCharsInBag(dtStr, dtCh)) == false)
	{
//		alert("Please enter a valid date");
		return false;
	}
    return dtStr;
}

function DaysArray(n)
{
    for (var i = 1; i <= n; i++)
    {
		this[i] = 31;
		if (i == 4 || i == 6 || i == 9 || i == 11) this[i] = 30;
		if (i == 2) this[i] = 29;
    } 
    return this;
}

function daysInFebruary (year)
{
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}

function isInteger(s)
{
	var i;
    for (i = 0; i < s.length; i++)
    {
        // Check that current character is number
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}

function stripCharsInBag(s, bag)
{
	var i;
    var returnString = "";
    
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++)
    {
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}