<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ExcelTop.aspx.vb" Inherits="ExcelTop" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>ExcelTop</title>
<link href="StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
                <table cellspacing=0 width=100% cellpadding="2">
                   <tr>
                        <td class="PageHead" style="height: 40px" width=75%>
                            <div class="LeftPadding"><div align="left" class="BannerText">Standard Cost Creator Excel Export</div>
                            </div>
                        </td>
                        <td class="PageHead"  style="height: 40px" >
            <div class="LeftPadding"><div align="right" class="BannerText" >
                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="images/close.gif" />
             </div></div></td>
                    </tr>
         </table>
    
    </div>
    </form>
</body>
</html>
