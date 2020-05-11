// Function to allow the numeric value only
function ValdateNumber()
{

    if(event.keyCode<47 || event.keyCode>58)
        event.keyCode=0;
}

function CheckMasterRequiredField()
{
    var txtListName=document.getElementById('txtListName').value;
    
    if(txtListName.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}
function CheckDetailRequiredField()
{
    var txtListName=document.getElementById('txtItem').value;
    
    if(txtListName.replace(/\s/g,'')!='')
        return true;
    else
    {
        alert("' * ' Marked fields are mandatory")
        return false;
    }
}
function ShowDetail(ctrlID)
{
xstooltip_show('divToolTips',ctrlID);
return false;
}

function xstooltip_show(tooltipId, parentId) 
{ 

    it = document.getElementById(tooltipId); 

    // need to fixate default size (MSIE problem) 
    img = document.getElementById(parentId); 
     
    x = xstooltip_findPosX(img); 
    y = xstooltip_findPosY(img); 
    
    if(y<469)
        it.style.top =  (y+15) + 'px'; 
    else
        it.style.top =  (y-50) + 'px'; 
        
    it.style.left =(x+10)+ 'px';

    // Show the tag in the position
      it.style.display = '';
 
}
function xstooltip_findPosY(obj) 
{
    var curtop = 0;
    if (obj.offsetParent) 
    {
        while (obj.offsetParent) 
        {
            curtop += obj.offsetTop
            obj = obj.offsetParent;
        }
    }
    else if (obj.y)
        curtop += obj.y;
    return curtop;
}


function xstooltip_findPosX(obj) 
{
  var curleft = 0;
  if (obj.offsetParent) 
  {
    while (obj.offsetParent) 
        {
            curleft += obj.offsetLeft
            obj = obj.offsetParent;
        }
    }
    else if (obj.x)
        curleft += obj.x;
    return curleft;
}

 function CheckMandatory()
{
    if( document.getElementById("txtCode").value.replace(/\s/g,'') != "" &&  document.getElementById("txtDescription").value.replace(/\s/g,'')  != "" &&  document.getElementById("txtVendorID").value.replace(/\s/g,'')  != "" &&  document.getElementById("txtVendorNo").value.replace(/\s/g,'')  != "")
        return true;
    
    alert("' * ' Marked fields are mandatory");
    return false;
        
} 
    
/* Sales Forecasting Update Methods*/

// Method to update any quoter pct value changed in grid items
function UpdateCategoryQuoterValue(txtAddPct,qtr)
{
    if( txtAddPct.originalText != txtAddPct.value)
    {    
   // alert('DB');   
        var txtQPerc ;
        var txtQForecast;
        var mode;
        switch (qtr)
        {
            case 1:
                txtQPerc='txtQ1Perc';
                txtQForecast='txtQ1Forecast';
                mode ='Q1';
            break;
            case 2:
                txtQPerc='txtQ2Perc';
                txtQForecast='txtQ2Forecast';
                mode ='Q2';
            break;
            case 3:
                txtQPerc='txtQ3Perc';
                txtQForecast='txtQ3Forecast';
                mode ='Q3';
            break;
            case 4:
                txtQPerc='txtQ4Perc';
                txtQForecast='txtQ4Forecast';
                mode ='Q4';
            break;
            default : txtQPerc='txtQ1Perc';
        }        

        var newPct = txtAddPct.value;
        var catNo = document.getElementById(txtAddPct.id.replace(txtQPerc,'hidCatNo')).innerText; 
        
        var arrHeader = SalesForeCasting.UpdateQuoter1Values(catNo,newPct,mode).value    
        
        if(arrHeader)
        {
            // Update Header values
            document.getElementById("Q1ForecastTotal").innerText = arrHeader[0];    
            document.getElementById("Q2ForecastTotal").innerText = arrHeader[1];
            document.getElementById("Q3ForecastTotal").innerText = arrHeader[2];
            document.getElementById("Q4ForecastTotal").innerText = arrHeader[3];
            document.getElementById("AnnualForecastTotal").innerText = arrHeader[4];    
            
            document.getElementById("Q1AddTotal").value = arrHeader[5]; 
            document.getElementById("Q2AddTotal").value = arrHeader[6]; 
            document.getElementById("Q3AddTotal").value = arrHeader[7]; 
            document.getElementById("Q4AddTotal").value = arrHeader[8]; 
            document.getElementById("AddAnnualTotal").value = arrHeader[9]; 
            document.getElementById("lblDiffTotal").innerText = arrHeader[10]; 
            document.getElementById("AddAnnualTotal").originalText = arrHeader[9]; 
                document.getElementById("hidAnnuTot").value = arrHeader[9]; 
            // Update Grid Row values
            document.getElementById(txtAddPct.id.replace(txtQPerc,txtQForecast)).value = arrHeader[11];
            document.getElementById(txtAddPct.id.replace(txtQPerc,'txtAnnPerc')).value = arrHeader[12];
            document.getElementById(txtAddPct.id.replace(txtQPerc,"dglblAnnualForecastlbs")).innerText = arrHeader[13];
            document.getElementById(txtAddPct.id.replace(txtQPerc,"dglblPctDiff")).innerText = arrHeader[14]; 
            
            // Update the Origianl vale attribut to avoid update on annual pct field onblur event
            document.getElementById(txtAddPct.id.replace(txtQPerc,'txtAnnPerc')).originalText =arrHeader[12];
            txtAddPct.originalText = txtAddPct.value;
            document.getElementById(txtAddPct.id.replace(txtQPerc,txtQForecast)).originalText = arrHeader[11];          
            window.opener.location.reload();
            
        }
        else
        {
             DisplayError();
        }
    }
}

// Method to update value, when user change any annual total pct value
function UpdateCategoryAnnualValue(txtAnnPerc)
{
    //alert('originalText: ' + txtAnnPerc.originalText + ' New text: ' + txtAnnPerc.value);
    if( txtAnnPerc.originalText != txtAnnPerc.value)
    {
        document.getElementById(txtAnnPerc.id.replace('txtAnnPerc','txtQ1Perc')).value = txtAnnPerc.value; 
        document.getElementById(txtAnnPerc.id.replace('txtAnnPerc','txtQ2Perc')).value = txtAnnPerc.value;
        document.getElementById(txtAnnPerc.id.replace('txtAnnPerc','txtQ3Perc')).value = txtAnnPerc.value;
        document.getElementById(txtAnnPerc.id.replace('txtAnnPerc','txtQ4Perc')).value = txtAnnPerc.value;
        UpdateCategoryQuoterValue(document.getElementById(txtAnnPerc.id.replace('txtAnnPerc','txtQ1Perc')),1);
        UpdateCategoryQuoterValue(document.getElementById(txtAnnPerc.id.replace('txtAnnPerc','txtQ2Perc')),2);
        UpdateCategoryQuoterValue(document.getElementById(txtAnnPerc.id.replace('txtAnnPerc','txtQ3Perc')),3);
        UpdateCategoryQuoterValue(document.getElementById(txtAnnPerc.id.replace('txtAnnPerc','txtQ4Perc')),4); 
         window.opener.location.reload();
    }
}

// Method to update any forecast value changed in grid items
function UpdateQuoterForecastValue(txtForecastAmt,qtr)
{
    if( txtForecastAmt.originalText != txtForecastAmt.value)
    {
        var txtQPerc ;
        var txtQForecast;
        var mode;
        switch (qtr)
        {
            case 1:
                txtQPerc='txtQ1Perc';
                txtQForecast='txtQ1Forecast';
                mode ='Q1';
            break;
            case 2:
                txtQPerc='txtQ2Perc';
                txtQForecast='txtQ2Forecast';
                mode ='Q2';
            break;
            case 3:
                txtQPerc='txtQ3Perc';
                txtQForecast='txtQ3Forecast';
                mode ='Q3';
            break;
            case 4:
                txtQPerc='txtQ4Perc';
                txtQForecast='txtQ4Forecast';
                mode ='Q4';
            break;
            default : txtQPerc='txtQ1Perc';
        }
        
        var newForeCastAmt = txtForecastAmt.value;
        var catNo = document.getElementById(txtForecastAmt.id.replace(txtQForecast,'hidCatNo')).innerText;     
        var arrHeader = SalesForeCasting.UpdateQuoterForecastValues(catNo,newForeCastAmt,mode).value         
        
        if(arrHeader)
        {
            // Update Header values
            document.getElementById("Q1ForecastTotal").innerText = arrHeader[0];
             
            document.getElementById("Q2ForecastTotal").innerText = arrHeader[1];
            document.getElementById("Q3ForecastTotal").innerText = arrHeader[2];
            document.getElementById("Q4ForecastTotal").innerText = arrHeader[3];           
            document.getElementById("AnnualForecastTotal").innerText = arrHeader[4];    
           
            document.getElementById("Q1AddTotal").value = arrHeader[5]; 
            document.getElementById("Q2AddTotal").value = arrHeader[6]; 
            document.getElementById("Q3AddTotal").value = arrHeader[7]; 
            document.getElementById("Q4AddTotal").value = arrHeader[8]; 
            document.getElementById("AddAnnualTotal").value = arrHeader[9]; 
             document.getElementById("hidAnnuTot").value = arrHeader[9]; 
            
            document.getElementById("lblDiffTotal").innerText = arrHeader[10];             
            
            // Update Grid Row values    
            document.getElementById(txtForecastAmt.id.replace(txtQForecast,'txtAnnPerc')).value = arrHeader[12];
            document.getElementById(txtForecastAmt.id.replace(txtQForecast,"dglblAnnualForecastlbs")).innerText = arrHeader[13];
            document.getElementById(txtForecastAmt.id.replace(txtQForecast,"dglblPctDiff")).innerText = arrHeader[14];
            document.getElementById(txtForecastAmt.id.replace(txtQForecast,txtQPerc)).value = arrHeader[15];
            
            // Update the Origianl vale attribut to avoid update on annual pct field onblur event
            document.getElementById(txtForecastAmt.id.replace(txtQForecast,txtQPerc)).originalText = arrHeader[15];
            document.getElementById(txtForecastAmt.id.replace(txtQForecast,'txtAnnPerc')).originalText = arrHeader[12];
            txtForecastAmt.originalText = txtForecastAmt.value;
             window.opener.location.reload();
        }
        else
            DisplayError();
    }
}

function DisplayError()
{
    alert("Database connection failed");
}

