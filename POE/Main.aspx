<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Main Page</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />

    <script>
    function OpenPopup(formName)
    {
      var popUp;
         switch(formName)
        {
        case 0:
          popUp=window.open ("EnterExpenses.aspx?PONumber=","EnterExpenses",'height=470,width=714,scrollbars=no,status=no,top='+((screen.height/2) - (500/2))+',left='+((screen.width/2) - (714/2))+',resizable=NO',"");
         popUp.focus(); 
        break;
        case 1:
         window.open("Frame.aspx",'POrder','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
         window.opener=top; 
         window.open('','_parent','');
         window.close(); 
        break;
       }
    }
    </script>

</head>
<body onload="javascript:OpenPopup(1);">
    <form id="form1" runat="server">
       <%-- <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div>
            <table cellpadding="0" cellspacing="0" border="0" style="padding-bottom: 5px; padding-left: 10px;"
                width="100%">
                <tr style="font-weight: bold;">
                    <td align="Center">
                        <asp:Label ID="lblCust" CssClass="BannerText" runat="server" Text ="Purchase Order Entry"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:LinkButton ID="lnkExpenses" CssClass="TabHead" Font-Bold="True" Text="Enter Expenses"
                            runat="server"></asp:LinkButton>
                    </td>
                </tr>
            </table>
        </div>--%>
    </form>
</body>
</html>
