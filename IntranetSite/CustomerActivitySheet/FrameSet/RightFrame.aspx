<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RightFrame.aspx.cs" Inherits="PFC.Intranet.CustomerActivity.treeViewMenuFrame" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Untitled Page</title>
    <script language="">
		//Toggles the "Dock Panel" to either Pinned or Docked State
		// updated - design team
		var _pinned = true;
		var theFrameSet;
		function adjustPanel()
		{
			theFrameSet = top.document.getElementById("frameSet2");

			if (_pinned){
				ShowNav_Panel()			
			}else{
				HideNav_Panel()				
			}
			_pinned = !_pinned;
		}
		function ShowNav_Panel(){
			theFrameSet.setAttribute("cols", "35, *");
			document.getElementById('ExportOption').style.display='none';
			document.getElementById('ActivitySheets').style.display='none';
			document.getElementById('adjustbtn').className="adjust_btnmin";
		}
		function HideNav_Panel(){
			theFrameSet.setAttribute("cols", "260, *");
			document.getElementById('ExportOption').style.display='block';				
			document.getElementById('ActivitySheets').style.display='block';
			document.getElementById('adjustbtn').className="adjust_btnmax";
		}	
		
		function ProcessReport(mode)
		{
		    var url='<%=customerDataPage %>'.replace('../','');
		 
		    if(document.getElementById("chkAll").checked==true)
		        url=url+','+'<%=pieChartPage %>'.replace('../','')+','+'<%=top5SalesPage %>'.replace('../','')+','+'<%=salesCategoryPage %>'.replace('../','')+','+'<%=customerNotesPage %>'.replace('../','');
		    else
		    {
		        if(document.getElementById("chkPieChart").checked==true)
		            url=url+','+'<%=pieChartPage %>'.replace('../','');
		        if(document.getElementById("chkTop5Sales").checked==true)
		            url=url+','+'<%=top5SalesPage %>'.replace('../','');
		        if(document.getElementById("chkSalesCat").checked==true)
		            url=url+','+'<%=salesCategoryPage %>'.replace('../','');
		        if(document.getElementById("chkNotes").checked==true)
		            url=url+','+'<%=customerNotesPage %>'.replace('../','');
		    }
		 
		    // replaces all the occurences of a character in a string
		    url=url.replace(/&/g,"~");
		    window.open("../Print_Export.aspx?mode="+mode+"&URL="+url,"" ,'height=10,width=10,scrollbars=no,status=no,top='+((screen.height/2) - (10/2))+',left='+((screen.width/2) - (10/2))+',resizable=YES',"");
		}
		
		  // Javascript Function To Call Server Side Function Using Ajax
       function DeleteFiles()
       {
            var session='<%=Session["SessionID"]%>';
           treeViewMenuFrame.DeleteExcel(session);
       }
		
</script>
<link href="../Styles/Styles.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../Javascript/CASScripts.js"></script>
</head>
<body onunload="Javascript:DeleteFiles();">
    <form id="leftForm" runat="server">    
    <table align="center" height="100%" id="tlbleft">
    <tr>
     <td valign="top" height="100%" width=100% class="LeftBg">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td id="ActivitySheets">
        <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
            <tr>
              <td class="TabHeadBk" >
              <table width="100%"  border="0" cellspacing="0" cellpadding="3">
                  <tr>
                    <td style="width: 16px"><img src="../Images/DragBullet.gif" width="8" height="23" hspace="4" onDrag="follow"></td>
                    <td width="217" class="TabHead"><strong>Customer Activity Sheets </strong></td>
                    </tr>
              </table></td>
            </tr>
            <tr>
              <td  valign="top" align="center"  class="TabCntBk" style="padding-top:15px;padding-bottom:15px;"  >            
                
                    <table  width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
          <tr>
            <td  align="center" valign="top" class="btnpadding"><img style="cursor:hand " id="img1"  alt="View Customer Data"  onclick="javascript:DisplayReport('<%= customerDataPage %>','Customer Data~1',this);" onMouseOver="OnMouseOver(this);" onMouseOut="OnMouseOut(this);" src="../images/customerdatac.jpg"  height="24"></td>
          </tr>
          <tr>
            <td align="center" valign="top" class="btnpadding"><img style="cursor:hand " id="img2" alt="View Pie Chart" onclick="javascript:DisplayReport('<%= pieChartPage %>','Pie Charts~2',this);" onMouseOver="OnMouseOver(this);" onMouseOut="OnMouseOut(this);" src="../images/piecharts.jpg"  height="24"></td>
          </tr>
          <tr>
            <td align="center" valign="top" class="btnpadding"><img  style="cursor:hand " id="img3" alt="View Top 5 Sales Categories" onclick="javascript:DisplayReport('<%= top5SalesPage %>','Top 5 Sales Categories~3',this);" onMouseOver="OnMouseOver(this);" onMouseOut="OnMouseOut(this);" src="../images/top5.jpg"  height="24"></td>
          </tr>
          <tr>
            <td  align="center" valign="top" class="btnpadding"><img  style="cursor:hand " id="img4" alt="View Sales Category Detail" onclick="javascript:DisplayReport('<%= salesCategoryPage %>','Sales Category Detail~4',this);" onMouseOver="OnMouseOver(this);" onMouseOut="OnMouseOut(this);" src="../images/sales.jpg"  height="24"></td>
          </tr>
          <tr>
            <td  align="center" valign="top" class="btnpadding"><img style="cursor:hand " id="img5" alt="View Customer Contact Notes"  onclick="javascript:DisplayReport('<%= customerNotesPage %>','Customer Contact Notes~5',this);" onMouseOver="OnMouseOver(this);" onMouseOut="OnMouseOut(this);" src="../images/customercontact.jpg"  height="24"></td>
          </tr>
        </table>
                  
              </td>
            </tr>
        </table>
        
        </td>
      </tr>
      <tr>
        <td id="ExportOption">
        <table width="100%"  border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
            <tr>
              <td class="TabHeadBk" ><table width="100%"  border="0" cellspacing="0" cellpadding="3">
                  <tr>
                    <td width="16"><img src="../../Common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                    <td width="216" class=TabHead><strong>Print / Export Options </strong></td>
                    </tr>
              </table></td>
            </tr>
            <tr>
              <td  valign="top" id="Td1" class="TabCntBk"><div align="left" class="10pxPadding">
                  <table width="200" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="Left5pxPadd" valign="middle" style="height: 25px">
                          <asp:CheckBox ID="chkAll"  runat="server" Text="All Customer Activity Sheets" CssClass="TabHead" Width="200px" Checked="True" onclick="UnCheckOtherPrintOption();" /></td>
                    </tr>
                    <tr>
                     <td width="100%" class="TabHead" height=20px><strong>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; Customer Data </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd" >
                          <asp:CheckBox ID="chkPieChart" Checked=true runat="server" CssClass="TabHead" Text="Pie Charts" Width="200px" onclick="UnCheckAllOption();"/></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd" style="height: 25px" >
                          <asp:CheckBox ID="chkTop5Sales" Checked=true runat="server" CssClass="TabHead" Text="Top 5 Sales Categories" Width="200px" onclick="UnCheckAllOption();" /></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd">
                          <asp:CheckBox ID="chkSalesCat" Checked=true runat="server" CssClass="TabHead" Text="Sales Category Detail" Width="200px" onclick="UnCheckAllOption();"/></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd">
                          <asp:CheckBox ID="chkNotes" Checked=true runat="server" CssClass="TabHead" Text="Customer Contact Notes" Width="200px" onclick="UnCheckAllOption();"/></td>
                    </tr>
                    <tr>
                      <td class="Left5pxPadd">
                      <table>
                            <tr>
                                <td>
                                    &nbsp;<img ID="ImageButton1" style="cursor:hand" alt="Print Customer Activity Sheet"  src="../Images/Btn_Print.jpg" onclick="Javascript:ProcessReport('Print');" /></td>
                                <td>
                                    &nbsp;<img ID="ImageButton2" style="cursor:hand" alt="Export Customer Activity Sheet to PDF" src="../Images/Btn_Export.jpg" onclick="Javascript:ProcessReport('Export');"/></td>
                            </tr>
                      </table>
                      
                         </td>
                    </tr>
                  </table>
              </div></td>
            </tr>
        </table></td>
      </tr>
    </table>
    </td>
</tr>
</table>
<input type="hidden" id="hidImage" value="img1" runat="server"  />
</form>
</body>
</html>