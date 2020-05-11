<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PFCVision.aspx.cs" Inherits="SystemFrameSet_PFCVision" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>PFC Vision</title>
    <style>
    .HeaderText 
    {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 11px;
        color: #000066;
        padding-right: 25px;
        padding-left: 25px;
        padding-top: 5px;
        padding-bottom: 5px;
        
    }
    .Content
    {
        font-size: 11px;
	    color: #333333;
	    font-family: Arial, Helvetica, sans-serif;
	    padding-right: 25px;
        padding-left: 25px;
        padding-top: 10px;
        padding-bottom: 20px;
    }
    .bullet
    {
        padding-left: 50px;
    }
    .BlueBorder 
    {
	    border: 1px solid #4BBADE;
    }
    </style>
    <script>
        var MessageWindow;
        function CloseMessage()
        {
            if ((MessageWindow != null) && (!MessageWindow.closed)) 
            {
                MessageWindow.close();
                MessageWindow=null;
            }
        }
        function ShowMessage()
        {
            MessageWindow=window.open('PFCVisionMessage.aspx','VisionMessage','height='+ (screen.height - 35 )+',width='+ (screen.width - 10) +',toolbar=0,scrollbars=0,status=0,top=0,left=0,resizable=No','');    
        }
    </script>
</head>
<body style="margin:2px" onload="ShowMessage();">
    <form id="form1" runat="server" >
    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%" class="BlueBorder" id="TABLE1" >
        <tr>
            <td  valign="top"  style="background-image: url(../Common/Images/bannerbk.jpg);	background-repeat: repeat-x; height: 97px;"><div style="background-image: url(../Common/Images/FinalBanner.jpg);	background-repeat: no-repeat;	height: 97px;"></div></td>
        </tr>
        <tr>
            <td style="height: 19px" bgcolor="#f5f9fa">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td  align=left style="height: 33px">
                                <span class="HeaderText" ><b>Vision Statement</b></span>
                        </td>
                        <td align=right style="height: 33px;padding-right:10px">
                            <asp:ImageButton ID="btnClose" runat="server" ImageUrl="~/Common/Images/Close.gif"
                                OnClick="btnClose_Click" OnClientClick="CloseMessage();"/></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td height=25px><span class="Content">
                It’s all about reputation. We want everyone who comes in contact with our organization
                to say, “<font color=#cc0033><strong>That’s a helluva company!</strong></font>”</span></td>
        </tr>
        <tr>
            <td style="height: 25px" bgcolor="#f5f9fa">
                <span class="HeaderText" ><strong>Mission Statement</strong></span>
            </td>
        </tr>
        <tr>
            <td height=40px><span class="Content">
                We continually strive to be the leader in our industry by developing lasting relationships
                with our customers and suppliers.<br />
                &nbsp; &nbsp; &nbsp; &nbsp; Employees are family, and <font color=#cc0033><strong>First Class Service</strong></font>
                is our way of doing business.</span></td>
        </tr>
        <tr>
            <td  style="height: 25px" bgcolor="#f5f9fa"><span class="HeaderText" ><strong>Strategic Operating Principles</strong></span>
            </td>
        </tr>
        <tr>
            <td height=40px><span class="Content">
                We will always provide our customers with <font color=#cc0033><strong>First Class Service</strong></font>.
                <br />
                &nbsp; &nbsp; &nbsp; &nbsp;
                We will always treat customers, suppliers and each other with integrity and respect.
                </span>
            </td>
        </tr>
        <tr>
            <td >
                <table border="0" cellpadding="0" cellspacing="0" width=100%>
                    <tr>
                        <td bgcolor="#f5f9fa" style="height: 25px"><span class="HeaderText" ><strong>Core Operating Principles</strong></span>
                        </td>
                        <td bgcolor="#f5f9fa" style="height: 25px"><span class="HeaderText" ><strong>Strategic Directives</strong></span>
                        </td>
                    </tr>
                    <tr>
                        <td valign=top>
                            <span class="Content">
                            We are all part of “<font color=#cc0033><strong>Team PFC</strong></font>”. 
                            <br />
                                <li class="bullet">Always strive to foster better teamwork </li>
                                <li class="bullet"> Always look to promote from within </li> 
                                <li class="bullet">Always maintain a positive attitude </li>
                                <li class="bullet">Always communicate in an open, honest and compassionate manner </li>
                                <li class="bullet">Always keep your promises and commitments</li>
                                <li class="bullet">Always treat your customer as your best friend </li>
                                <li class="bullet">Always strive to understand and exceed your customer’s expectations </li>
                                <li class="bullet">Always take the opportunity to be your customer’s hero</li>
                                <li class="bullet">Remember, your attitude and behavior reflects on our reputation</li></span>
                        </td>
                        <td>
                        <span class="Content">
                People buy from people they like. 
                <li class="bullet">  Always strive for long term relationships with
                customers and suppliers </li>
                <li class="bullet">
                Keep our customers competitive by offering the right mix
                of products and services </li>
                <li class="bullet">
                Never fire a customer, always explore other possibilities</li>
                <li class="bullet">
                Make every customer profitable </li>
                <li class="bullet">
                Seek every opportunity to expand our business </li>
                <li class="bullet">
                Sell more to existing customers </li>
                <li class="bullet">
                Utilize available resources to increase profitability </li>
                <li class="bullet"style="color:Green;font-weight:bold;font-size: 15px">
                Invest in continuous improvement </li>
                <li class="bullet">
                Always strive for accuracy in all that you do</li> 
                <li class="bullet">
                Never ship product in an unacceptable condition </li>
               <li class="bullet">
                Streamline the product flow from our suppliers
                to our customers </li>
                <li class="bullet">
                Always hire quality people with the intention to promote from within</li>
                 </span>
                        </td>
                    </tr>
                </table>
                <br />
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
