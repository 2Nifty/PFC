 var ctlDiameter;
        var ctlLength;
        var strProduct;   
        var strCategory; 
        var strDiameter;
        var strLength;
        var strPlating;     
        var strPackage; 
//        
//function OpenPrint(mode)
//{
//var Url = 'Print.aspx?SessionID=<%=Session["SessionID"].ToString()%>';
//        window.open(Url,"QuotePrint" ,'height=600,width=1020,scrollbars=yes,status=no,top='+((screen.height/2) - (600/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
//}

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
      
//        var strItem =ItemControl.GetItem(strItemFamily,strProduct,strCategory,strDiameter,strLength,strPlating,strPackage).value.toString();
//        document.getElementById("txtItemNo").value=strItem;
   
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

    if (SHMode.id == "Show") {
		document.getElementById("HideLabel").style.display = "block";
		document.getElementById("LeftMenu").style.display = "block";
		document.getElementById("LeftMenuContainer").style.width = "200";
		document.getElementById("SHButton").innerHTML = "<img ID='Hide' style='cursor:hand' src='Common/Images/HidButton.gif' width='22' height='21' onclick='ShowHide(this)'>";			    
		document.getElementById("hidShowHide").value="Show";

	}
	if (SHMode.id == "Hide") 
	{
		document.getElementById("HideLabel").style.display = "none";
		document.getElementById("LeftMenu").style.display = "none";
		document.getElementById("LeftMenuContainer").style.width = "10";
		document.getElementById("SHButton").innerHTML = "<img ID='Show' style='cursor:hand' src='Common/Images/ShowButton.gif' width='22' height='21' onclick='ShowHide(this)'>";	
		document.getElementById("hidShowHide").value="Hide";
		//document.getElementById('div-datagrid').style.width=screen.width-60;
			
	}	
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
   
    if (typeof bt == 'object'){ 
        if(navigator.appName.indexOf("Netscape")>(-1)){ 
                if (e.keyCode == 13){ 
                 bt.focus();
                    bt.click(); 
                    return false; 
                } 
        } 
        if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1)){ 
                if (event.keyCode == 13){
                 bt.focus(); 
                    bt.click(); 
                    return false; 
         } 
        } 
    } 
} 

 function ShowItemControl(ShowItem)
        {

        var Container =document.getElementById("PageContainer"); 
        if(Container != null)
        {      
            if (ShowItem.id == "ShowItem") 
            {       
              if(Container.contentWindow.document.getElementById('frNewQuote')!=null)
             { 
             
	         Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("TDFamily").style.display = "block";
	       //  Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("TDItem").style.display = "block";	   
	         //Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("txtQuantity").focus();
	         Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("txtCustItemNo").focus();
	        // Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("divdatagrid").style.height ="264px";
	        // Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("divdatagrid").style.width="75%";

	         
		     document.getElementById("ShowTag").innerHTML = "<img ID='HideItem' style='cursor:hand' src='Common/Images/HideType.gif' onclick='ShowItemControl(this)'>";		    	    		
		     }
	        }
	        if (ShowItem.id == "HideItem") 
	        {
	        if(Container.contentWindow.document.getElementById('frNewQuote')!=null)
                { 
              Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("TDFamily").style.display = "none";
	         Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("TDItem").style.display = "none";
//	           Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("divdatagrid").style.height ="325px";
	          document.getElementById("ShowTag").innerHTML = "<img ID='ShowItem' style='cursor:hand' src='Common/Images/Showtype.gif' onclick='ShowItemControl(this)'>";            				
Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("hidTDItemDisplay").value = 'hide';
	         //Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("divdatagrid").style.width="100%";
	          Container.contentWindow.document.getElementById('frNewQuote').document.getElementById("hidTDItemDisplay").value = 'hide';

	          }
	        }	
	    }	 
}
        