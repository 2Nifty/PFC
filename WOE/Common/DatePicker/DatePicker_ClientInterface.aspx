<!--********************************************************************************************
 * Project				:	Umbrella.NET
 * File					:	DatePicker_ClientInterface.aspx
 * File Type			:	ASPX
 * Description			:	
 * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 16 August '05		Ver-1			Sathishvaran		Created
 *********************************************************************************************-->

<%@ Page Language="c#" AutoEventWireup="false" CodeFile="DatePicker_ClientInterface.aspx.cs"
    Inherits="Umbrella_CodePro_ScreenBuilder_DatePicker_ClientInterface" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>Date Picker</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="../StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        BODY (FONT-SIZE: 11px; FONT-FAMILY: Arial, Helvetica, sans-serif}
        TD {FONT-SIZE: 11px; FONT-FAMILY: Arial, Helvetica, sans-serif}
        TH {FONT-SIZE: 11px; FONT-FAMILY: Arial, Helvetica, sans-serif}
        .calBk {BACKGROUND-POSITION: left top; BACKGROUND-IMAGE: url(../../Common/Images/calBk.jpg); BACKGROUND-REPEAT: repeat-x; BACKGROUND-COLOR: #ffffff}
        .rightBorder {	BORDER-RIGHT: #d3e9fe 1px solid }
        .GreenBorder{border: 1px solid #b3e2f0;}
    </style>
</head>

<body bottommargin="2" leftmargin="2" topmargin="2" rightmargin="2">
    <form id="frmFrame" runat="server">
        <table class="calBk" cellspacing="2" cellpadding="2" width="211" border="0">
            <tr>
                <td class="rightBorder" valign="top" height="1" rowspan="4">
                    <table class="GreenBorder" width="192" align="center" bgcolor="#ffffff">
                        <tr>
                            <td height="1">
                                <asp:Calendar ID="calender" runat="server" OnSelectionChanged="Calender_SelectionChanged"
                                    Width="192px" Font-Size="10pt" Height="136px" Font-Names="Verdana" BorderColor="#b3e2f5">
                                        <TodayDayStyle Font-Bold="True" ForeColor="DodgerBlue" BorderStyle="None" BorderColor="Transparent"
                                            BackColor="AliceBlue"></TodayDayStyle>
                                        <SelectorStyle ForeColor="#b3e2f0" BackColor="AliceBlue"></SelectorStyle>
                                        <DayStyle Font-Size="7pt" Width="22px"></DayStyle>
                                        <DayHeaderStyle Font-Size="7pt" Font-Bold="True" Height="10px" CssClass="TableHead"
                                            BackColor="Transparent"></DayHeaderStyle>
                                        <TitleStyle Font-Size="7pt" Font-Names="Verdana" BorderColor="Transparent" CssClass="GridHead"
                                            BackColor="#b3e2f0"></TitleStyle>
                                </asp:Calendar>
                            </td>
                        </tr>
                    </table>
                </td>
                <td class="GreenBorder" height="0">
                    <asp:DropDownList ID="ddlMonth" runat="server" OnSelectedIndexChanged="ddlMonth_SelectedIndexChanged"
                        CssClass="cnt" AutoPostBack="True" Width="80px">
                            <asp:ListItem Value="1">January</asp:ListItem>
                            <asp:ListItem Value="2">February</asp:ListItem>
                            <asp:ListItem Value="3">March</asp:ListItem>
                            <asp:ListItem Value="4">April</asp:ListItem>
                            <asp:ListItem Value="5">May</asp:ListItem>
                            <asp:ListItem Value="6">June</asp:ListItem>
                            <asp:ListItem Value="7">July</asp:ListItem>
                            <asp:ListItem Value="8">August</asp:ListItem>
                            <asp:ListItem Value="9">September</asp:ListItem>
                            <asp:ListItem Value="10">October</asp:ListItem>
                            <asp:ListItem Value="11">November</asp:ListItem>
                            <asp:ListItem Value="12">December</asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td class="GreenBorder" height="-1">
                    <asp:DropDownList ID="ddlYear" runat="server" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged"
                        AutoPostBack="True" CssClass="cnt" Width="80px">
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td class="GreenBorder" height="0">
                    <asp:TextBox ID="txtHour" runat="server" Width="20px" CssClass="cnt"></asp:TextBox>
                    <asp:TextBox ID="txtMinutes" runat="server" Width="20px" CssClass="cnt"></asp:TextBox>
                    <asp:TextBox ID="txtSeconds" runat="server" Width="20px" CssClass="cnt"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="GreenBorder" height="0" valign="top">
                    <asp:RadioButtonList ID="rdoNoon" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Value="AM">am</asp:ListItem>
                        <asp:ListItem Value="PM">pm</asp:ListItem>
                    </asp:RadioButtonList></td>
            </tr>
        </table>
        <input type="hidden" id="hidTime" value="" runat="server" />
        <input type="hidden" id="hidDate" value="" runat="server" />
    </form>

    <script>
        function show()
        {
            var Digital = new Date()
            var hours = Digital.getHours()
            var minutes = Digital.getMinutes()
            var seconds = Digital.getSeconds()
            var curr_date = Digital.getDate();
            var curr_month = Digital.getMonth();
            var curr_year = Digital.getFullYear();
            
            //var timeZone=Digital.getTimezoneOffset()
            var dn = "AM" 
            
            if (hours > 12)
            {
                dn = "PM"
                hours = hours - 12
            }
            
            if (hours == 0) hours = 12
            if (minutes <= 9) minutes = "0" + minutes
            if (seconds <= 9) seconds = "0" + seconds
           
            alert(curr_month);
        }
</script>
</body>
</html>
