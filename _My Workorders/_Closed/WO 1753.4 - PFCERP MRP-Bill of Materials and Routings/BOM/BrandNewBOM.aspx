<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1" runat="server">

    <title>GridView Data Manipulation</title>

</head>

<body>

    <form id="form1" runat="server">

    <div>

        <table cellpadding="0" cellspacing="0">

            <tr>

                <td style="width: 100px; height: 19px;">

                    Company ID</td>

                <td style="width: 100px; height: 19px;">

                    Company</td>

                <td style="width: 100px; height: 19px;">

                    Name</td>

                <td style="width: 100px; height: 19px;">

                    Title</td>

                <td style="width: 100px; height: 19px;">

                    Address</td>

                <td style="width: 100px; height: 19px;">

                    Country</td>

            </tr>

            <tr>

                <td style="width: 100px">

                    <asp:TextBox ID="TextBox1" runat="server"/></td>

                <td style="width: 100px">

                    <asp:TextBox ID="TextBox2" runat="server"/></td>

                <td style="width: 100px">

                    <asp:TextBox ID="TextBox3" runat="server"/></td>

                <td style="width: 100px">

                    <asp:TextBox ID="TextBox4" runat="server"/></td>

                <td style="width: 100px">

                    <asp:TextBox ID="TextBox5" runat="server"/></td>

                <td style="width: 100px">

                    <asp:TextBox ID="TextBox6" runat="server"/></td>

                <td style="width: 100px">

                    <asp:Button ID="Button1" runat="server" Text="Add New" OnClick="Button1_Click" /></td>

            </tr>

        </table>

        

        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" ShowFooter="true">

        <Columns>

            <asp:BoundField DataField="CustomerID" HeaderText="ID" ReadOnly="true"/>

            <asp:BoundField DataField="CompanyName" HeaderText="Company"/>

            <asp:BoundField DataField="ContactName" HeaderText="Name"/>

            <asp:BoundField DataField="ContactTitle" HeaderText="Title" />

            <asp:BoundField DataField="Address" HeaderText="Address"/>

            <asp:BoundField DataField="Country" HeaderText="Country"/>

        </Columns>

        </asp:GridView>

    </div>

    </form>

</body>

</html>
