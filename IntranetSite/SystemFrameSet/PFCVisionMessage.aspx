<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Message</title>
    <style>
    .Line1 
    {
        font-family: Times New Roman, Georgia, serif;
        font-size: 30px;
        color: #000066;
        padding-right: 25px;
        padding-left: 25px;
        padding-top: 15px;
        padding-bottom: 0px;
        
    }
    .Line2
    {
        font-size: 16px;
	    color: #CC0000;
	    font-family: Arial, Helvetica, sans-serif;
	    font-weight: bold;
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
</head>
<body style="margin: 2px">
    <form id="form1" runat="server">
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%;"
            class="BlueBorder" id="TABLE1">
            <tr>
                <td valign="top" style="background-image: url(../Common/Images/bannerbk.jpg); background-repeat: repeat-x;
                    height: 97px;">
                    <div style="background-image: url(../Common/Images/FinalBanner.jpg); background-repeat: no-repeat;
                        height: 97px;">
                    </div>
                </td>
            </tr>
            <tr>
                <td style="height: 19px" bgcolor="#f5f9fa" valign="bottom">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr>
                            <td align="left" style="height: 33px" valign="bottom">
                                &nbsp;
                            </td>
                            <td align="right" style="height: 33px; padding-right: 10px">
                                <asp:ImageButton ID="btnClose" runat="server" ImageUrl="~/Common/Images/Close.gif"
                                    OnClientClick="javascript:window.close();" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" style="padding-top: 50px;">
                    <span class="Line1">Attitudes are contagious - is yours worth catching?</span><br />
                    <span class="Line1"></span>
                    <br />
                    <span class="Line1"></span>
                    <br />
                    <%--         
                    <span class="Line1"></span><br/>
                    <span class="Line1">***Welcome New Team Member to the PFC Family***</span> 
                    <span class="Line1"></span><br/>
                    <span class="Line1"></span><br/>
                    <span class="Line1">Betty Chen  – Taiwan - Administration</span>
                    <span class="Line1"></span><br/>
                    <span class="Line1">Brian Sullivan – New Jersey  - CSR</span>
                    <span class="Line1"></span><br/>
                     --%>
            </tr>
            <tr>
                <td>
                    <span class="Line1"></span>
                </td>
            </tr>
            <tr>
                <td height="40px">
                    &nbsp;
                </td>
            </tr>
            <%--<tr>
                <td style="height: 25px" bgcolor="#f5f9fa">
                    <span class="HeaderText"><strong>Strategic Operating Principles</strong></span>
                </td>
            </tr>
            <tr>
                <td height="40px">
                    <span class="Content">We will always provide our customers with <font color="#CC0000">
                        <strong>First Class Service</strong></font>.
                        <br />
                        &nbsp; &nbsp; &nbsp; &nbsp; We will always treat customers, suppliers and each other
                        with integrity and respect. </span>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td bgcolor="#f5f9fa" style="height: 25px">
                                <span class="HeaderText"><strong>Core Operating Principles</strong></span>
                            </td>
                            <td bgcolor="#f5f9fa" style="height: 25px">
                                <span class="HeaderText"><strong>Strategic Directives</strong></span>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <span class="Content">We are all part of “<font color="#CC0000"><strong>Team PFC</strong></font>”.
                                    <br />
                                    <li class="bullet">Always strive to foster better teamwork </li>
                                    <li class="bullet">Always look to promote from within </li>
                                    <li class="bullet">Always maintain a positive attitude </li>
                                    <li class="bullet">Always communicate in an open, honest and compassionate manner </li>
                                    <li class="bullet">Always keep your promises and commitments</li>
                                    <li class="bullet">Always treat your customer as your best friend </li>
                                    <li class="bullet">Always strive to understand and exceed your customer’s expectations
                                    </li>
                                    <li class="bullet">Always take the opportunity to be your customer’s hero</li>
                                    <li class="bullet">Remember, your attitude and behavior reflects on our reputation</li>
                                </span>
                            </td>
                            <td>
                                <span class="Content">People buy from people they like.
                                    <li class="bullet">Always strive for long term relationships with customers and suppliers
                                    </li>
                                    <li class="bullet">Keep our customers competitive by offering the right mix of products
                                        and services </li>
                                    <li class="bullet">Never fire a customer, always explore other possibilities</li>
                                    <li class="bullet">Make every customer profitable </li>
                                    <li class="bullet">Seek every opportunity to expand our business </li>
                                    <li class="bullet">Sell more to existing customers </li>
                                    <li class="bullet">Utilize available resources to increase profitability </li>
                                    <li class="bullet">Invest in continuous improvement </li>
                                    <li class="bullet">Always strive for accuracy in all that you do</li>
                                    <li class="bullet">Never ship product in an unacceptable condition </li>
                                    <li class="bullet">Streamline the product flow from our suppliers to our customers </li>
                                    <li class="bullet">Always hire quality people with the intention to promote from within</li>
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
--%>
        </table>
    </form>
</body>
</html>
