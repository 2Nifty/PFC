// JScript File

// Function to allow the numeric value only with single dot
function ValdateNumberWithDot(value)
{
    if(event.keyCode == 13)
        event.keyCode = 9;
    else if(event.keyCode<46 || event.keyCode>58)
        event.keyCode=0;
        
    if(event.keyCode==46 && value.indexOf('.')!=-1)
         event.keyCode=0;
            
}


// function to convert values in to 2 decimal places
function TwoDP(X)
{ 
    var D, C, T // X >= 0
    with (Math) 
    { 
        D = floor(X) ;
         C = round(100*(X-D)) ; 
         T = C%10 
    }
    return D + "." + (C-T)/100 + T;
}

