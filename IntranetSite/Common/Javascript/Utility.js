// Global Variables
var allCookies;
var appName = location.href.split("/")[3];

function SaveScreenPosition(screenCode)
{
    var newPos = screenCode + "|" + (window.screenLeft-4) + "|" + (window.screenTop-23) + "|" + (document.documentElement.clientWidth) + "|" + (document.documentElement.clientHeight) + "+";
    allCookies = document.cookie;
    var posCookie = "";
    var cookiePos = allCookies.indexOf(appName);    
    var cookieExpire=new Date();
    cookieExpire.setDate(cookieExpire.getDate()+5);    
    // see if the cookie exists for the user
    if (cookiePos != -1) 
    {
        // cookie is here, see if the screen code is already set
        posCookie = allCookies.substring(cookiePos);        
        var screenPos = posCookie.indexOf(screenCode);
        
        
        if (screenPos != -1)
        {
            //remove the value for the passed screen code
            var searchString = screenCode + '\\|-?\\d+\\|-?\\d+\\|\\d+\\|\\d+\\+';
            var searchPattern = new RegExp(searchString);                        
            posCookie = posCookie.replace(searchPattern, newPos);                                  
        }
        else
        {
            //add the current screen position to the screen position values
            posCookie = posCookie.substring(0,appName.length) + newPos + posCookie.substring(appName.length) ;
        }        
    }
    else
    {
        // create a new cookie
        posCookie = appName + newPos;
    }
    posCookie = posCookie + ";expires=" + cookieExpire.toGMTString();    
    document.cookie = posCookie;        
}
function GetScreenPosition(screenCode)
{
   
    // position the window
    allCookies = document.cookie;       
    var pos = allCookies.indexOf(appName);    
    if (pos != -1) 
    {
        pos = allCookies.indexOf(screenCode+"|");        
    }
    if (pos != -1) 
    {
        // extract left, top, width, height
        var posValues = allCookies.substring(pos);
        posValues = posValues.substring(posValues.indexOf("|")+1,posValues.indexOf("+"));        
        return posValues.split("|");
    }
    else
        return null;
}

function MoveToLastStoredPosition(screenCode, pageHandle)
{   
    var winPos = GetScreenPosition(screenCode);        
    pageHandle.moveTo(winPos[0],winPos[1])    
}

function OpenAtPosition(screenCode, url, windowOptions, defWidth, defHeight)
{
    var winPos = GetScreenPosition(screenCode);     
    if (winPos != null)
    {
        windowOptions += ",top=" + winPos[1] + ",left=" + winPos[0] + ",height=" + winPos[3] + ",width=" + winPos[2];     
    }
    else
    {
        windowOptions += ",top=" + ((screen.height/2) - (defHeight/2)) + ",left=" + ((screen.width/2) - (defWidth/2)) + ",height=" + defHeight + ",width=" + defWidth;
    }
    return window.open(url,screenCode,windowOptions,'')
}

function OpenMutipleInstanceAtPosition(screenCode, url, windowOptions, defWidth, defHeight, InstanceCd)
{
    var winPos = GetScreenPosition(screenCode);
    if (winPos != null)
    {
        windowOptions += ",top=" + winPos[1] + ",left=" + winPos[0] + ",height=" + winPos[3] + ",width=" + winPos[2];        
    }
    else
    {
        windowOptions += ",top=" + ((screen.height/2) - (defHeight/2))  + ",left=" + ((screen.width/2) - (defWidth/2)) + ",height=" + defHeight + ",width=" + defWidth;
    }
    return window.open(url,InstanceCd,windowOptions,'')
}

// On page unload save the page position to cookie
window.onbeforeunload = function() 
{
    var _arrPageURL = location.href.split("/");
    var _screenCode = _arrPageURL[_arrPageURL.length -1].split(".")[0];    
    SaveScreenPosition(_screenCode);    
}
