var ctlDiameter;
var ctlLength;
var strProduct;   
var strCategory; 
var strDiameter;
var strLength;
var strPlating;     
var strPackage; 


function LoadItemValue(Package)
{
     ctlDiameter   = document.getElementById(Package.id.replace("ddlPackage" ,"ddlDiameter"));
     ctlLength     = document.getElementById(Package.id.replace("ddlPackage" ,"ddlLength"));
     strProduct    = document.getElementById(Package.id.replace("ddlPackage" ,"ddlProductLine")).value;   
     strCategory   = document.getElementById(Package.id.replace("ddlPackage" ,"ddlCategory")).value; 
     strDiameter   = (ctlDiameter.selectedIndex != 0)?ctlDiameter.options[ctlDiameter.selectedIndex].text:"";
     strLength     = (ctlLength.selectedIndex != 0)?ctlLength.options[ctlLength.selectedIndex].text:"";    
     strPlating    = document.getElementById(Package.id.replace("ddlPackage" ,"ddlPlating")).value;     
     strPackage    = Package.value; 
}


function GetItemLookup(ctlButton)
{
    document.getElementById("divProductLine").style.display="none";
    document.getElementById("divCategory").style.display="none";
    document.getElementById("divDiameter").style.display="none";
    document.getElementById("divLength").style.display="none";
    document.getElementById("divPlating").style.display="none";
    document.getElementById("divPackage").style.display="none";
    
    strProduct="";
    strDiameter   = ""; 
    strLength     = ""; 
    strPlating    = "";     
    strPackage    = "";
    strCategory= ""; 
    
     if(document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlProductLine")) !=null)
        strProduct    = document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlProductLine")).value;
     
    if(strProduct !="")
    {
         if(document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlDiameter")) !=null)
         {
            ctlDiameter   = document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlDiameter"));
            strDiameter   = ctlDiameter.value; 
         }
          
         if(document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlLength")) !=null)
         {
           ctlLength     = document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlLength"));
           strLength     = ctlLength.value; 
         }         
         
         if(document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlCategory")) !=null)   
            strCategory   = document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlCategory")).value; 
         
         if(document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlPlating")) !=null)   
            strPlating    = document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlPlating")).value;  
            
         if(document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlPackage")) !=null)   
                strPackage    = document.getElementById(ctlButton.id.replace("btnGetItem" ,"ddlPackage")).value;

          strCategory   = (strCategory =="")?"All":strCategory;   
          strDiameter   = (strDiameter =="")?"All":strDiameter; 
          strLength     = (strLength =="")?"All":strLength; 
          strPlating    = (strPlating =="")?"All":strPlating;     
          strPackage    = (strPackage =="")?"All":strPackage; 
 
          var Url = "ItemLookup.aspx?ItemProductLine=" +strProduct + "&ItemCategory=" + strCategory + "&ItemDiameter=" + strDiameter + "&ItemLength=" + strLength +"&ItemPlating=" + strPlating + "&ItemPackage=" + strPackage +"";
          window.open(Url,'ItemLookup' ,'height=650,width=665,scrollbars=no,status=no,top='+((screen.height/2) - (650/2))+',left='+((screen.width/2) - (645/2))+',resizable=NO,scrollbars=YES','');
          return false;
      }
}

function ShowHide(SHMode)
{

    if (SHMode.id == "Show")
     {
		document.getElementById("HideLabel").style.display = "block";
		document.getElementById("LeftMenu").style.display = "block";
		document.getElementById("LeftMenuContainer").style.width = "200";
		document.getElementById("divItemFamily").style.height="250";		
		document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='Common/Images/HidButton.gif' width='22' height='21' onclick='ShowHide(this)'>";			    
		document.getElementById("hidShowHide").value="Show";
		
		
		document.getElementById("divdatagrid").style.height="250";
	}
	if (SHMode.id == "Hide") 
	{
		document.getElementById("HideLabel").style.display = "none";
		document.getElementById("LeftMenu").style.display = "none";
		document.getElementById("LeftMenuContainer").style.width = "1";
		document.getElementById("divItemFamily").style.height="250";
		document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='Common/Images/ShowButton.gif' width='22' height='21' onclick='ShowHide(this)'>";	
		document.getElementById("hidShowHide").value="Hide";
		
		
		document.getElementById("divdatagrid").style.height="250";
			
	}
	//SetDefaultHeight();
	SetGridHeight('Common');
}


function LoadSideBar()
{
     if(document.getElementById("hidShowHide")!= null && document.getElementById("hidShowHide").value =="Hide")  
            ShowHide(document.getElementById("Hide")); 
}

//
// Function to Preform action on Enter Keypress Event in passcode page
//
function ClickButton()
{ 
    var bt = document.getElementById("btnSubmit"); 
    if (typeof bt == 'object')
    { 
        if (e.keyCode == 13)
        {
            bt.focus();
            bt.click(); 
            return false; 
        } 
        
    } 
} 

 function ShowItemControl(ShowItem)
 {
        var Container =document.getElementById("PageContainer"); 
        if(Container != null)
        {      
            if (ShowItem.id == "ShowItem") 
                if(Container.contentWindow.document.getElementById('frNewQuote')!=null)
                { 
             
	                 Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("TDFamily").style.display = "block";
	                 Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("txtQuantity").focus();
	                 Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("txtItemNo").focus();
		             document.getElementById("ShowTag").innerHTML = "<img ID='HideItem' style='cursor:hand' src='Common/Images/HideType.gif' onclick='ShowItemControl(this)'>";		    	    		
		         }
	        
	        if (ShowItem.id == "HideItem") 
	            if(Container.contentWindow.document.getElementById('frNewQuote')!=null)
                { 
                    Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("TDFamily").style.display = "none";
	                Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("TDItem").style.display = "none";
	                document.getElementById("ShowTag").innerHTML = "<img ID='ShowItem' style='cursor:hand' src='Common/Images/Showtype.gif' onclick='ShowItemControl(this)'>";            				
	            }
	    }	 
 }
    
    
function OnDropDownClick(ctrlID)
{
    if(document.getElementById(ctrlID))
    {
        var ddlCurrent=document.getElementById(ctrlID);
        if(ddlCurrent.value!="")
        {
            
            if(document.getElementById(ctrlID.replace('ddl','hid')).value=='1')
            {
                document.getElementById(ctrlID.replace('ddl','hid')).value='0';
                document.getElementById("UCItemLookup_hidControlName").value=ctrlID+"`"+ddlCurrent.options[ddlCurrent.selectedIndex].value;
                var btnBind=document.getElementById("UCItemLookup_btnPost");
                document.getElementById(ctrlID.replace('UCItemLookup_ddl','div')).style.display='none';
               
               if (typeof btnBind == 'object'){
                     btnBind.click(); return false; }
            }
            else
                document.getElementById(ctrlID.replace('UCItemLookup_ddl','div')).style.display='none';
       }
       else
            document.getElementById(ctrlID.replace('UCItemLookup_ddl','div')).style.display='none';
    }
}    

function HideUserControl()
{
    if(document.getElementById("UCItemLookup_hidResetFlag")!=null && document.getElementById("UCItemLookup_hidResetFlag").value.replace(/\s/g,'')=='Reset')
       return true;
       
    document.getElementById("TDItem").style.display='none';
    if(document.getElementById("TDItem").style.display=='none')
        document.getElementById("divdatagrid").style.height='240';
       
    if(document.getElementById("Show"))
        ShowHide(document.getElementById("Show"));
     
     if(document.getElementById("Hide"))  
        document.getElementById("Hide").focus(); 
}