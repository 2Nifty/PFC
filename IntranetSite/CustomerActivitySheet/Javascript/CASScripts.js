// JScript File


 function DisplayReport(pageName,pageTitle,img)
    {
     Setbackgroud(img);
       parent.bodyframe.location.href = pageName;  
      
        pageName =pageName.replace('&','~');
        var page=new Array();
        page=pageName.split('&');
        pageName ="";
        for(var i=0;i<page.length;i++)
        {
            pageName +=page[i]+'~';        
        }       
       pageName =pageName.substring(0,pageName.length-1);
       parent.mainmenus.location.href = "PrintPanel.aspx?PageURL="+pageName+"&pageTitle="+pageTitle;      
    }
    
      
  //
  // Function to uncheck all the print option (if all option is selected by the user)
  //
  function UnCheckOtherPrintOption()
  {
     var chkState=(document.getElementById("chkAll").checked==true)? true:false;
     document.getElementById("chkPieChart").checked=chkState;
     document.getElementById("chkTop5Sales").checked= chkState;
     document.getElementById("chkSalesCat").checked= chkState;
     document.getElementById("chkNotes").checked= chkState;   
  }
  
  function UnCheckAllOption()
  {
    var chk=(document.getElementById("chkPieChart").checked== true && document.getElementById("chkTop5Sales").checked== true && document.getElementById("chkSalesCat").checked==true && document.getElementById("chkNotes").checked==true)?true:false;
    document.getElementById("chkAll").checked=chk;
  }
  
   function Setbackgroud(imgbg)
  {
    switch (imgbg.id){
		case "img1": 			
		 imgbg.src = "../images/customerdatac.jpg";
		 document.getElementById("img2").src="../images/piecharts.jpg";
		 document.getElementById("img3").src="../images/top5.jpg";
		 document.getElementById("img4").src="../images/sales.jpg";
		 document.getElementById("img5").src="../images/customercontact.jpg";
		 document.getElementById("hidImage").value="img1";
		    
		break;
		case "img2": 					
			 imgbg.src = "../images/piechartsc.jpg";
		 document.getElementById("img1").src="../images/customerdata.jpg";
		 document.getElementById("img3").src="../images/top5.jpg";
		 document.getElementById("img4").src="../images/sales.jpg";
		 document.getElementById("img5").src="../images/customercontact.jpg";
		 document.getElementById("hidImage").value="img2";
		break;
		case "img3": 		
			 imgbg.src = "../images/top5c.jpg";
			 
		 document.getElementById("img1").src="../images/customerdata.jpg";
		 document.getElementById("img2").src="../images/piecharts.jpg";
		 document.getElementById("img4").src="../images/sales.jpg";
		 document.getElementById("img5").src="../images/customercontact.jpg";
		 document.getElementById("hidImage").value="img3";
		break;
		case "img4": 
		 imgbg.src = "../images/salesc.jpg";
		 document.getElementById("img1").src="../images/customerdata.jpg";
		 document.getElementById("img2").src=	"../images/piecharts.jpg";	
		 document.getElementById("img3").src="../images/top5.jpg";
		 document.getElementById("img5").src="../images/customercontact.jpg";
		 document.getElementById("hidImage").value="img4";
		break;
		case "img5": 
		 imgbg.src = "../images/customercontactc.jpg";
			
		 document.getElementById("img1").src="../images/customerdata.jpg";
		 document.getElementById("img2").src="../images/piecharts.jpg";		
		 document.getElementById("img3").src="../images/top5.jpg";
		 document.getElementById("img4").src="../images/sales.jpg";
		 document.getElementById("hidImage").value="img5";
		break;
		default : alert("Out of range");	
		}
   
  
  }
  function OnMouseOver(imgmOver)  
  {
     if( imgmOver.id != document.getElementById("hidImage").value)
      {
         switch (imgmOver.id)
         {
		    case "img1":     					
		     imgmOver.src = "../images/customerdatao.jpg";    		    
		    break;
		    case "img2": 					
			     imgmOver.src = "../images/piechartso.jpg";		    
		    break;
		    case "img3": 		
			     imgmOver.src = "../images/top5o.jpg";			     
		    break;
		    case "img4": 
		     imgmOver.src = "../images/saleso.jpg";		   
		    break;
		    case "img5": 
		     imgmOver.src = "../images/customercontacto.jpg";
		    break;
		    default : alert("Out of range");	
		    }
		}   
  }
  function OnMouseOut(imgmOut)
  { 
     if( imgmOut.id != document.getElementById("hidImage").value)
      {
         switch (imgmOut.id)
         {
		    case "img1":     					
		     imgmOut.src = "../images/customerdata.jpg";    		    
		    break;
		    case "img2": 					
			     imgmOut.src = "../images/piecharts.jpg";		    
		    break;
		    case "img3": 		
			     imgmOut.src = "../images/top5.jpg";			     
		    break;
		    case "img4": 
		     imgmOut.src = "../images/sales.jpg";		   
		    break;
		    case "img5": 
		     imgmOut.src = "../images/customercontact.jpg";
		    break;
		    default : alert("Out of range");	
		    }
		}   
  
  }
   