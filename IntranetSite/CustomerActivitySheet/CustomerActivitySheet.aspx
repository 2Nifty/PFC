<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerActivitySheet.aspx.cs" Inherits="CustomerActivitySheet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Customer Activity Sheet</title>
    <link href="../CustomerActivitySheet/Styles/Styles.css" rel="stylesheet" type="text/css" />
    <script>
    
    // Javascript function to get the page content from serverside function
    function GetCustomerData()
    {
        var strCustNo='<%=Request.QueryString["CustNo"] %>';
        var strMonth='<%=Request.QueryString["Month"] %>';
        var strYear='<%=Request.QueryString["Year"] %>';
        var strServer='<%=Request.ServerVariables["SERVER_NAME"] %>';
        alert(strServer);
        var strContent=CustomerActivitySheet.GetPage(strCustNo,strMonth,strYear,strServer).value.toString();
        alert(strContent);
        divContent.innerHTML=strContent;
    }
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2"><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="HeadeBG">
      <tr>
        <td width="62%" valign="middle" ><img src="Images/CASHeader.jpg" width="365" height="49"></td>
        <td width="38%" valign="middle"><div align="right"><img src="Images/PFCCAS.gif" width="294" height="15" hspace="10" vspace="5">
          </div></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td valign="top" class="LeftBg"><table width="100%" border="0" cellspacing="1" cellpadding="1">
      <tr>
        <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
            <tr>
              <td class="TabHeadBk"><table width="100%"  border="0" cellspacing="0" cellpadding="3">
                  <tr>
                    <td width="16"><img src="../common/Images/DragBullet.gif" width="8" height="23" hspace="4" onDrag="follow"></td>
                    <td width="217" class="TabHead"><strong>Customer Activity Sheets </strong></td>
                    </tr>
              </table></td>
            </tr>
            <tr>
              <td  valign="top" id="1TD" class="TabCntBk"><div align="left" class="10pxPadding">
                  <table width="180" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="1" class="Left5pxPadd"><strong><img src="Images/PageIcon.gif" width="11" height="15"></strong></td>
                      <td width="100%" class="Left5pxPadd"><a onclick="Javascript:GetCustomerData();" style="cursor:hand;"><strong>Customer Data </strong></a></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><strong><img src="Images/PageIcon.gif" width="11" height="15"></strong></td>
                      <td width="100%" class="Left5pxPadd"><strong>Pie Charts </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><strong><img src="Images/PageIcon.gif" width="11" height="15"></strong></td>
                      <td width="100%" class="Left5pxPadd"><strong>Top 5 Sales Categories </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><strong><img src="Images/PageIcon.gif" width="11" height="15"></strong></td>
                      <td width="100%" class="Left5pxPadd"><strong>Sales Category Details </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><img src="Images/PageIcon.gif" width="11" height="15"></td>
                      <td width="100%" class="Left5pxPadd"><strong>Customer Contact notes </strong></td>
                    </tr>
                  </table>
              </div></td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="BlueBorder">
            <tr>
              <td class="TabHeadBk"><table width="100%"  border="0" cellspacing="0" cellpadding="3">
                  <tr>
                    <td width="16"><img src="../common/Images/DragBullet.gif" width="8" height="23" hspace="4"></td>
                    <td width="216"><strong>Print / Export Options </strong></td>
                    </tr>
              </table></td>
            </tr>
            <tr>
              <td  valign="top" id="Td1" class="TabCntBk"><div align="left" class="10pxPadding">
                  <table width="180" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="Left5pxPadd"><input name="radiobutton" type="radio" value="radiobutton"></td>
                      <td width="100%" nowrap class="Left5pxPadd"><strong>All Customer Activity Sheets </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><input name="radiobutton" type="radio" value="radiobutton"></td>
                      <td width="100%" class="Left5pxPadd"><strong>Customer Data </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><input name="radiobutton" type="radio" value="radiobutton"></td>
                      <td width="100%" class="Left5pxPadd"><strong>Pie Charts </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><input name="radiobutton" type="radio" value="radiobutton"></td>
                      <td width="100%" class="Left5pxPadd"><strong>Top 5 Sales Categories </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><input name="radiobutton" type="radio" value="radiobutton"></td>
                      <td width="100%" class="Left5pxPadd"><strong>Sales Category Details </strong></td>
                    </tr>
                    <tr>
                      <td width="1" class="Left5pxPadd"><input name="radiobutton" type="radio" value="radiobutton"></td>
                      <td width="100%" class="Left5pxPadd"><strong>Customer Contact notes </strong></td>
                    </tr>
                    <tr>
                      <td class="Left5pxPadd">&nbsp;</td>
                      <td class="Left5pxPadd"><input name="imageField" type="image" src="Images/Btn_Print.jpg" width="70" height="23" >
                        &nbsp; <input name="imageField" type="image" src="Images/Btn_Export.jpg" width="70" height="23" ></td>
                    </tr>
                  </table>
              </div></td>
            </tr>
        </table></td>
      </tr>
    </table></td>
    <td width="100%" height="450" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="SheetWizard">
      <tr>
        <td class="PrintWizBk"><table border="0" cellspacing="0" cellpadding="0">
            <tr valign="middle">
              <td class="PrntWizHighlight"><table width="100%"  border="0" cellspacing="0" cellpadding="4">
                  <tr valign="middle">
                    <td><img src="images/sheets.jpg" width="14" height="17"></td>
                    <td class="SheetName"><strong>Customer Contact Notes</strong></td>
                  </tr>
              </table></td>
              <td><img src="Images/Btn_Prev.gif" width="21" height="21" hspace="5"></td>
              <td><img src="Images/Btn_Next.gif" width="21" height="21" hspace="5"></td>
              <td class="PrntWizHighlight"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                  <tr valign="middle">
                    <td><img src="Images/Printer.gif" width="17" height="18" hspace="5"></td>
                    <td><input name="radiobutton" type="radio" value="radiobutton"></td>
                    <td class="SheetName">Current Activity Sheet</td>
                    <td><input name="radiobutton" type="radio" value="radiobutton"></td>
                    <td class="SheetName">Current Page</td>
                    <td><img src="Images/Btn_Print.gif" width="51" height="16" hspace="5"></td>
                  </tr>
              </table></td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td class="DashBoardBk"><table width="700" height="580" border="0" cellpadding="0" cellspacing="0" class="SheetHolder">
          <tr>
            <td valign="top">
                <div id=divContent>
                
                </div>
            </td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
  <tr bgcolor="#DFF3F9">
    <td height="29" colspan="2" class="BluTopBord"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="23%" height="25" class="foottxt1">&nbsp;&nbsp;Copyright 2006 @ Porteous Fastener Co.,</td>
        <td width="11%" class="foottxt2">&nbsp;&nbsp;All Rights Reserved. </td>
        <td width="11%" class="foottxt2">Terms & Conditions.</td>
        <td width="42%" class="foottxt2">Best Viewed in 1024 x 768 &amp; above resolutions.</td>
        <td width="13%" class="foottxt1"><i>powered by Novantus</i></td>
      </tr>
    </table></td>
  </tr>
 
</table>

    </form>
</body>
</html>
