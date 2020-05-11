//Method used to filter the alphabet characters on keypress
function ValidateNumber(){if (window.event.keyCode < 47 || window.event.keyCode > 58) window.event.keyCode = 0;}

//Method used to validate the from data and thro data
function CheckValidData(strDestination)
{
    if(strDestination =="category")
    {
        var iRangeType = parseInt(document.getElementById("hidCategoryRangeType").value);
        if(iRangeType == 2)
        {
            var CategoryFrom = document.getElementById("txtCategoryFrom");
            var CategoryThro = document.getElementById("txtCategoryThro");
            return CheckRange(CategoryFrom,CategoryThro);
        }
    }
    else if(strDestination == "variance")
    {
        var iRangeType = parseInt(document.getElementById("hidVarianceRangeType").value);
        if(iRangeType == 2)
        {
            var VarianceFrom = document.getElementById("txtVarianceFrom");
            var VarianceThro = document.getElementById("txtVarianceThro");
            return CheckRange(VarianceFrom,VarianceThro);
        }
    }
    else
    {
        var iRangeType = parseInt(document.getElementById("hidPlatingRangeType").value);
        if(iRangeType == 2)
        {
            var VarianceFrom = document.getElementById("txtPlatingTypeFrom");
            var VarianceThro = document.getElementById("txtPlatingTypeThro");
            return CheckRange(VarianceFrom,VarianceThro);
        }
    }
}

//Method used to check the from to range values
function CheckRange(objFrom,objThro)
{
    var iFrom = 0;
    var iThro = 0;
    if(objFrom.value !="")iFrom= parseInt(objFrom.value);
    if(objThro.value !="")iThro = parseInt(objThro.value);
    if(iFrom!=0 && iThro !=0)
    {
        if(iFrom>=iThro)
            return false;
    }
    return true;
}

//Method used to display the report screen
function ViewReport()
{
    VendorForeCastPrompt.PersistInputCriteria();
}

////Method used to show vendor forecast report screen
//function ShowReport()
//{
//    var ddlMultiplier = document.getElementById("ddlMultiplier");
//    VendorForeCastPrompt.WriteMultiplier(ddlMultiplier.value);
//    window.open("VendorForeCastReport.aspx", 'popupwindow', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES');
//}