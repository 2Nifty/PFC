// Worksheet functions
var allCookies;

function SetScreenPos(screenCode)
{
    var newPos = screenCode + "|" + (window.screenLeft-4) + "|" + (window.screenTop-23) + "|" + (document.documentElement.clientWidth) + "|" + (document.documentElement.clientHeight) + "+";
    allCookies = document.cookie;
    var posCookie = "";
    var cookiePos = allCookies.indexOf("SOEWinPos=");
    var cookieExpire=new Date();
    cookieExpire.setDate(cookieExpire.getDate()+5);
    //cookieExpire.setFullYear(cookieExpire.getFullYear() + 5);
    // see if the cookie exists for the user
    if (cookiePos != -1) 
    {
        // cookie is here, see if the screen code is already set
        posCookie = allCookies.substring(cookiePos);
        var screenPos = posCookie.indexOf(screenCode);
        //alert(screenPos);
        //alert("Before "+posCookie);
        if (screenPos != -1)
        {
            //remove the value for the passed screen code
            var searchString = screenCode + '\\|\\d+\\|\\d+\\|\\d+\\|\\d+\\+';
            var searchPattern = new RegExp(searchString);
            posCookie = posCookie.replace(searchPattern, newPos);
            //alert(searchString);
        }
        else
        {
            //add the current screen position to the screen position values
            posCookie = posCookie.substring(0,10) + newPos + posCookie.substring(10) ;
        }
        //alert("After "+posCookie);
   }
    else
    {
        // create a new cookie
        posCookie = "SOEWinPos=" + newPos;
    }
    posCookie = posCookie + ";expires=" + cookieExpire.toGMTString();
    //alert(newPos);
    //alert(posCookie);
    document.cookie = posCookie;
    //document.cookie = "SOEWinPos=PkgPlt|100|0|800|800+";
}
function GetScreenPos(screenCode)
{
    // position the window
    allCookies = document.cookie;
    //alert(allCookies);
    var pos = allCookies.indexOf("SOEWinPos=");
    if (pos != -1) {pos = allCookies.indexOf(screenCode+"|");}
    if (pos != -1) 
    {
        // extract left, top, width, height
        var posValues = allCookies.substring(pos);
        posValues = posValues.substring(posValues.indexOf("|")+1,posValues.indexOf("+"));
        //window.resizeTo(parseInt(posValues.split("|")[2]),parseInt(posValues.split("|")[3]));
        //window.moveTo(parseInt(posValues.split("|")[0]),parseInt(posValues.split("|")[1]));
        return posValues.split("|");
    }
    else
        return null;
}
function OpenAtPos(screenCode, url, windowOptions, defX, defY, defWidth, defHeight)
{
    var winPos = GetScreenPos(screenCode);
    if (winPos != null)
    {
        windowOptions += ",top=" + winPos[1] + ",left=" + winPos[0] + ",height=" + winPos[3] + ",width=" + winPos[2];
        //alert(windowOptions);
    }
    else
    {
        windowOptions += ",top=" + defY + ",left=" + defX + ",height=" + defHeight + ",width=" + defWidth;
    }
    return window.open(url,screenCode,windowOptions,'')
}