<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowPartImage.aspx.cs" Inherits="ShowPartImage" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script>
        function ClosePage()
        {
            window.close();	
        }
        function LoadRefData()
        {
            // process once
            if (document.getElementById('HasProcessed').value != '1') 
            {
                document.getElementById('HasProcessed').value = '1';
                // set the fields
                document.getElementById('ItemNoTextBox').value = 
                    window.opener.parent.document.getElementById('InternalItemLabel').innerText;
                document.getElementById('DescriptionTextBox').value = 
                    window.opener.parent.document.getElementById('ItemDescLabel').innerText;
                // show the data
                document.form1.ShowImage.click();
            }
        }


        function GreetUser() 
        {
        // get the username from the textbox 
        var username = 'Slater'; 
        ShowPartImage.GreetUser(username,GreetUser_CallBack); 
        }

        function GreetUser_CallBack(response) 
        {
        alert(response.value); 
        }
    </script>
    <title>Item Image</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
</head>
<body style="margin: 0px" bgcolor="#ECF9FB" onload="LoadRefData();">
    <form id="form1" runat="server">
    <div>
        <table width="900px">
            <tr>
                <td>
                 <table width="890px" style="border:1px solid #88D2E9; ">
                    <tr class="bold">
                        <td align="right"><div  style="color:Blue;" >Item #</div>
                        </td>
                        <td>
                            <asp:TextBox CssClass="lbl_whitebox" ID="ItemNoTextBox" runat="server" Text="" Width="100px"
                             ></asp:TextBox>&nbsp;
                        </td>
                        <td align="right"><div  style="color:Blue;" >Description:</div>
                        </td>
                        <td>
                            <asp:TextBox CssClass="lbl_whitebox" ID="DescriptionTextBox" runat="server" Text=" " Width="250px"
                            ></asp:TextBox>
                        </td>
                        <td align="right">
                        <img src="Common/Images/close.gif" style="cursor: hand" onclick="ClosePage();">&nbsp;&nbsp;
                        <asp:HiddenField ID="HasProcessed" runat="server" />
                        </td>
                    </tr>
                </table>
               </td>
            </tr>
            <tr>
                <td>
                    <asp:Panel ID="ImagePanel" runat="server" Height="300px" Width="890px" style="border:1px solid #88D2E9; background-color:#FFFFFF" 
                    >
                    <br /><br />
                    <asp:Table ID="HeadTable" runat="server">
                    <asp:TableRow>
                    <asp:TableCell HorizontalAlign="Center">
                            <asp:Image ID="HeadImage" runat="server" Height="75px"/>
                    </asp:TableCell>
                    <asp:TableCell>
                            <asp:Image ID="BodyImage" runat="server" Height="75px"/>
                    </asp:TableCell>
                    </asp:TableRow>
                    </asp:Table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                    <asp:Button ID="ShowImage" runat="server"  OnClick="ShowImage_Click"  style="display:none;" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
