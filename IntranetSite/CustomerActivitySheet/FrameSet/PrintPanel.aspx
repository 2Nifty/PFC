<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PrintPanel.aspx.cs" Inherits="PFC.Intranet.CustomerActivity.PrintPanel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <link href="../Styles/Styles.css" rel="stylesheet" type="text/css" />
</head>
<script>

function DisplayReport(pageName,pageTitle)
{
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

function ProcessPrint()
{
var url='<%=strURL%>'.replace('../','');
    // replaces all the occurences of a character in a string
    url=url.replace(/&/g,"~");
    window.open("../Print_Export.aspx?mode=Print&URL="+url,"" ,'height=10,width=10,scrollbars=no,status=no,top='+((screen.height/2) - (10/2))+',left='+((screen.width/2) - (10/2))+',resizable=YES',"");
}
function GoNext()
{

    if(document.getElementById("hidPageID").value !="5")
    {
        if(document.getElementById("hidPageID").value == "4" )
        {		            
            DisplayReport('<%= customerNotesPage %>','Customer Contact Notes~5');
            document.getElementById("hidPageID").value = "5";
            parent.MenuFrame.leftForm.hidImage.value="img5";
            parent.MenuFrame.leftForm.img1.src="../images/customerdata.jpg";
            parent.MenuFrame.leftForm.img2.src="../images/piecharts.jpg";		
            parent.MenuFrame.leftForm.img3.src="../images/top5.jpg";
            parent.MenuFrame.leftForm.img4.src="../images/sales.jpg";
            parent.MenuFrame.leftForm.img5.src="../images/customercontactc.jpg";
        }		    
        else if(document.getElementById("hidPageID").value == "3" )
        {
            DisplayReport('<%= salesCategoryPage %>','Sales Category Detail~4');
            document.getElementById("hidPageID").value = "4";
            parent.MenuFrame.leftForm.hidImage.value="img4";
            parent.MenuFrame.leftForm.img4.src="../images/salesc.jpg";
            parent.MenuFrame.leftForm.img1.src="../images/customerdata.jpg";
            parent.MenuFrame.leftForm.img2.src=	"../images/piecharts.jpg";	
            parent.MenuFrame.leftForm.img3.src="../images/top5.jpg";
            parent.MenuFrame.leftForm.img5.src="../images/customercontact.jpg";
        }
        else if(document.getElementById("hidPageID").value == "2" )
        {
            DisplayReport('<%= top5SalesPage %>','Top 5 Sales Categories~3');
            document.getElementById("hidPageID").value = "3";
            parent.MenuFrame.leftForm.hidImage.value="img3";
            parent.MenuFrame.leftForm.img1.src="../images/customerdata.jpg";
            parent.MenuFrame.leftForm.img2.src="../images/piecharts.jpg";
            parent.MenuFrame.leftForm.img4.src="../images/sales.jpg";
            parent.MenuFrame.leftForm.img5.src="../images/customercontact.jpg";
            parent.MenuFrame.leftForm.img3.src="../images/top5c.jpg";
        }
        else if(document.getElementById("hidPageID").value == "1" )
        {
            DisplayReport('<%= pieChartPage %>','Pie Charts~2');
            document.getElementById("hidPageID").value = "2";
            parent.MenuFrame.leftForm.hidImage.value="img2";
            parent.MenuFrame.leftForm.img1.src="../images/customerdata.jpg";
            parent.MenuFrame.leftForm.img3.src="../images/top5.jpg";
            parent.MenuFrame.leftForm.img4.src="../images/sales.jpg";
            parent.MenuFrame.leftForm.img5.src="../images/customercontact.jpg";
            parent.MenuFrame.leftForm.img2.src="../images/piechartsc.jpg";
        }		                   
    }
    else
    return false;
}
function GoBack()
{

    if(document.getElementById("hidPageID").value !="1")
    {

        if(document.getElementById("hidPageID").value == "5" )
        {
            DisplayReport('<%= salesCategoryPage %>','Sales Category Detail~4');
            document.getElementById("hidPageID").value = "4";
            parent.MenuFrame.leftForm.hidImage.value="img4";
            parent.MenuFrame.leftForm.img4.src="../images/salesc.jpg";
            parent.MenuFrame.leftForm.img1.src="../images/customerdata.jpg";
            parent.MenuFrame.leftForm.img2.src=	"../images/piecharts.jpg";	
            parent.MenuFrame.leftForm.img3.src="../images/top5.jpg";
            parent.MenuFrame.leftForm.img5.src="../images/customercontact.jpg";
        }
        else if(document.getElementById("hidPageID").value == "4" )
        {
            DisplayReport('<%= top5SalesPage %>','Top 5 Sales Categories~3');
            document.getElementById("hidPageID").value = "3";
            parent.MenuFrame.leftForm.hidImage.value="img3";
            parent.MenuFrame.leftForm.img1.src="../images/customerdata.jpg";
            parent.MenuFrame.leftForm.img2.src="../images/piecharts.jpg";
            parent.MenuFrame.leftForm.img4.src="../images/sales.jpg";
            parent.MenuFrame.leftForm.img5.src="../images/customercontact.jpg";
            parent.MenuFrame.leftForm.img3.src="../images/top5c.jpg";
        }
        else if(document.getElementById("hidPageID").value == "3" )
        {
            DisplayReport('<%= pieChartPage %>','Pie Charts~2');
            document.getElementById("hidPageID").value = "2";

            parent.MenuFrame.leftForm.hidImage.value="img2";
            parent.MenuFrame.leftForm.img2.src="../images/piechartsc.jpg";
            parent.MenuFrame.leftForm.img1.src="../images/customerdata.jpg";
            parent.MenuFrame.leftForm.img3.src="../images/top5.jpg";
            parent.MenuFrame.leftForm.img4.src="../images/sales.jpg";
            parent.MenuFrame.leftForm.img5.src="../images/customercontact.jpg";
        }
        else if(document.getElementById("hidPageID").value == "2" )
        {
            DisplayReport('<%= customerDataPage %>','Customer Data~1');
            document.getElementById("hidPageID").value = "1";
            parent.MenuFrame.leftForm.hidImage.value="img1";
            parent.MenuFrame.leftForm.img2.src="../images/piecharts.jpg";
            parent.MenuFrame.leftForm.img3.src="../images/top5.jpg";
            parent.MenuFrame.leftForm.img4.src="../images/sales.jpg";
            parent.MenuFrame.leftForm.img5.src="../images/customercontact.jpg";
            parent.MenuFrame.leftForm.img1.src="../images/customerdatac.jpg";
        }	        
       
    }
    else
    return false;
}

function DisplayChart()
{
//    var strquery='<%=strQuery%>';
//    
//    var page=new Array();
//    page=strquery.split('&');
//    strquery ="";
//    for(var i=0;i<page.length;i++)
//    {
//        strquery +=page[i]+'~';        
//    }       
//    strquery =strquery.substring(0,strquery.length-1);
     var hWnd= window.open('../ChartSettings.aspx',"PopUpPage",'height=470,width=500,scrollbars=no,status=no,top='+((screen.height/2) - (480/2))+',left='+((screen.width/2) - (500/2))+',resizable=no');		
    hWnd.opener = self;	
	if (window.focus) {hWnd.focus()}
	
}
function LoadHelp()
{
window.open("../../Help/HelpFrame.aspx?Name=CAS",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
   
}
	

</script>
<body>
    <form id="form1" runat="server">
  
    <table id="tlbPrint" width=100% class="SheetWizard">
    <tr width="100%">
    <td class="PrintWizBk" width="100%">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tr valign="middle" width="100%">
              <td class="PrntWizHighlight"><table width="100%"  border="0" cellspacing="0" cellpadding="4">
                  <tr valign="middle">
                    <td><img src="../Images/sheets.jpg" width="14" height="17"></td>
                    <td class="SheetName" width=200><strong><%=strTitle%></strong></td>
                  </tr>
              </table></td>
              <td><img  alt="Move to previous activity sheet" style="cursor:hand" src="../Images/Btn_Prev.gif" width="21" height="21" hspace="5" onclick="GoBack();"></td>
              <td><img alt="Move to next activity sheet" style="cursor:hand" src="../Images/Btn_Next.gif" width="21" height="21" hspace="5" onclick="GoNext();"></td>
               <td class="PrntWizHighlight"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  <tr valign="middle" width="80%">
                 <td class="SheetName">&nbsp;&nbsp;Current Page</td>
                    <td><img src="../Images/Printer.gif" style="cursor:hand;" width="17" height="18" hspace="5" alt="Print Activity Sheet" onclick="ProcessPrint();" ></td>
                    <td class="SheetName">  &nbsp;&nbsp;  |&nbsp;&nbsp; Chart Display Setting</td>
                    <td> &nbsp;&nbsp;<img style="cursor:hand;" alt="Chart Display Setting"  src="../Images/graph.gif" onclick="DisplayChart();"   ></td>
                    <td class="SheetName"> &nbsp;&nbsp; |&nbsp;&nbsp;Help</td>
                    <td> &nbsp;&nbsp;<img style="cursor:hand;" alt="View Help" onclick="LoadHelp();" src="../Images/help.gif" ></td>
                    <td class="SheetName" > &nbsp;&nbsp;|&nbsp;&nbsp; Close</td>
                    <td> &nbsp;&nbsp;<img style="cursor:hand;" alt="Close Activity Sheet" onclick="javascript:parent.window.close();" style="cursor: hand" src="../Images/close1.jpg" ></td>
                  </tr>
              </table></td>
             
            </tr>
        </table></td>  
          <input type="hidden" id="hidPageID" value="1" runat="server" />
    </tr>
    </table>
  
    </form>
</body>
</html>
