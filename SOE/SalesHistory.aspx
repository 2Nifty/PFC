<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesHistory.aspx.cs" Inherits="SalesHistory" %>

<%@ Register Src="Common/UserControls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>SOE-SalesHistory</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
   <%-- <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />--%>
    <script src="Common/JavaScript/Common.js"></script>
    <script>                
        // Open Customer look up
        function LoadCustomerLookup(_custNo)
        {   
            var Url = "CustomerList.aspx?ctrlName=sHistory&Customer=" + _custNo;
            window.open(Url,'CustomerList' ,'height=485,width=855,scrollbars=no,status=no,top='+((screen.height/2) - (450/2))+',left='+((screen.width/2) - (855/2))+',resizable=NO,scrollbars=YES','');
        }
        
        // -------------------------------------------------------------------------   
        function OpenSoldToForm()
        {
            popUp=window.open ("SoldToAddress.aspx?SONumber="+document.getElementById("hidSoNumber").value +"&Mode=Recall&CustNo=" + document.getElementById("hidCust").value  ,"SoldToForm",'height=340,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (340/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
            popUp.focus();            
        }
        
        // -------------------------------------------------------------------------  
        function OpenShipToForm()
        {
            popUp=window.open ("OneTimeShipToContact.aspx?SONumber="+document.getElementById("hidSoNumber").value +"&Mode=Recall&CustNo=" + document.getElementById("hidCust").value ,"SoldToForm",'height=365,width=715,scrollbars=no,status=no,top='+((screen.height/2) - (365/2))+',left='+((screen.width/2) - (715/2))+',resizable=NO',"");
            popUp.focus();
        }
        // -------------------------------------------------------------------------  
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1"  AsyncPostBackTimeout ="360000" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" style="width: 100%; height: 100%"
            class="HeaderPanels">
            <tr>
                <td>
                 <asp:UpdatePanel ID="pnlcustEntry" runat="server" UpdateMode="conditional">
                   <ContentTemplate>
                    <table border="0" cellpadding="0" cellspacing="0" width="100% ">
                        <tr>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px;"
                                width="35% ">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="40%"><asp:Label ID="lblCuctN0Caption" runat="server" Text="Customer No:" Font-Bold="True"  ></asp:Label></td>
                                                <td align="left" width="60%">
                                                    <asp:TextBox ID="txtCustNumber" runat="server" CssClass="lbl_whitebox" Width="80px"
                                                        AutoPostBack="True" OnTextChanged="txtCustNumber_TextChanged"></asp:TextBox>
                                                    
                                                    <asp:Button ID="btnLoadCustomer" runat="server" OnClick="btnLoadCustomer_Click" Style="display: none"
                                                        Text="Sold To" />
                                                    <asp:HiddenField ID="hidCust" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <table width="100%" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td>
                                                            </td>
                                                            <td style="width: 57px" align="center" >
                                                              <asp:label Font-Bold="True" runat="server" ID="lblMonthCaption" Text="Month" /></td>
                                                            <td align="center" >
                                                                <asp:label Font-Bold="True" runat="server" ID="lblYearCpation" Text="Year" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:label Font-Bold="True" runat="server" Text="Period Start" ID="lblPeriodStCpation" /></td>
                                                            <td style="width: 57px">
                                                                <asp:DropDownList ID="ddlStMonth"  Height="20" CssClass="lbl_whitebox" runat="server" Width="49px">
                                                                    <asp:ListItem>1</asp:ListItem>
                                                                    <asp:ListItem>2</asp:ListItem>
                                                                    <asp:ListItem>3</asp:ListItem>
                                                                    <asp:ListItem>4</asp:ListItem>
                                                                    <asp:ListItem>5</asp:ListItem>
                                                                    <asp:ListItem>6</asp:ListItem>
                                                                    <asp:ListItem>7</asp:ListItem>
                                                                    <asp:ListItem>8</asp:ListItem>
                                                                    <asp:ListItem>9</asp:ListItem>
                                                                    <asp:ListItem>10</asp:ListItem>
                                                                    <asp:ListItem>11</asp:ListItem>
                                                                    <asp:ListItem>12</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlStYear"  Height="20" CssClass="lbl_whitebox" runat="server" Width="55px">
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 100px">
                                                                <asp:label Font-Bold="True" runat="server" Text="Period End"  ID="lblPeriodEdCpation" /></td>
                                                            <td style="width: 57px">
                                                                <asp:DropDownList ID="ddlEndMonth"  Height="20" CssClass="lbl_whitebox" runat="server" Width="49px">
                                                                    <asp:ListItem>1</asp:ListItem>
                                                                    <asp:ListItem>2</asp:ListItem>
                                                                    <asp:ListItem>3</asp:ListItem>
                                                                    <asp:ListItem>4</asp:ListItem>
                                                                    <asp:ListItem>5</asp:ListItem>
                                                                    <asp:ListItem>6</asp:ListItem>
                                                                    <asp:ListItem>7</asp:ListItem>
                                                                    <asp:ListItem>8</asp:ListItem>
                                                                    <asp:ListItem>9</asp:ListItem>
                                                                    <asp:ListItem>10</asp:ListItem>
                                                                    <asp:ListItem>11</asp:ListItem>
                                                                    <asp:ListItem>12</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlEndYear" Height="20" CssClass="lbl_whitebox" runat="server" Width="55px">
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td rowspan="3" valign="bottom" style="padding-left: 10px; padding-top: 5px;">
                                                                <asp:ImageButton ID="ibtnHeaderFind" runat="server" ImageUrl="~/Common/Images/ShowButton.gif"
                                                                    OnClick="ibtnHeaderFind_Click" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                              
                            </td>
                            <td valign="top" class="SubHeaderPanels" width="33%" style="padding-left: 4px; padding-top: 5px">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="20px" style="width:20px">
                                            <asp:LinkButton ID="lnkSoldTo"  runat="server" CssClass="TabHead" OnClientClick="Javascript:OpenSoldToForm();return false;"
                                            Text="Sold To:" Font-Bold="True" Width="45px" /></td>
                                        <td>
                                            <asp:Label ID="lblSold_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSoldCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblSold_Address" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblSold_City" runat="server" CssClass="lblColor"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblSoldCom" runat="server" CssClass="lblColor" Text=""></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblSold_Territory" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblSold_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblSoldCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblSold_Phone" runat="server" CssClass="lblColor"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr><td height=10px></td><td></td></tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSalesRep" runat="server" CssClass="TabHead" Text="Sales Rep:"></asp:Label>
                                        </td>
                                        <td style="padding-left:3px"> 
                                            <asp:Label ID="lblSalesRepdisp" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                width="32%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="55px">
                                            <asp:LinkButton ID="lnkShipTo" runat="server" CssClass="TabHead"  OnClientClick="Javascript:OpenShipToForm();return false;" Text="Ship To:" Font-Bold="True"></asp:LinkButton></td>
                                        <td>
                                            <asp:Label ID="lblShip_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblShipCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblShip_Contact" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblShip_City" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblShipCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblShip_State" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblShip_Pincode" runat="server" CssClass="lblColor"></asp:Label></td>
                                                    <td>
                                                        &nbsp;<asp:Label ID="lblShipCountry" runat="server" CssClass="lblColor"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblShip_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr><td></td><td></td></tr>
                                    <tr>
                                        <td colspan="2" align="right" style="padding-right: 5px;">
                                            <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="~/Common/Images/help.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <asp:HiddenField ID="hidSoNumber" runat="server" />
                   </ContentTemplate>
                  </asp:UpdatePanel>                  
                </td>                
            </tr>       
            <tr>
                <td valign=top>
                    <asp:UpdatePanel ID="upSalesHistoryGrid" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                             <div id="div-datagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px;
                                    left: 0px; width: 790px; height: 240px; border: 0px solid; color:White">
                                <asp:DataGrid ID="dgSalesHistory" BackColor="#f4fbfd" AllowPaging="true" runat="server"  Width ="770px"
                                    AutoGenerateColumns="false" PagerStyle-Visible="false" OnItemDataBound="dgSalesHistory_ItemDataBound"
                                    BorderWidth="0" AllowSorting="true" GridLines="both" ShowFooter="false" OnSortCommand="dgSalesHistory__SortCommand"  OnPageIndexChanged="dgSalesHistory_PageIndexChanged">
                                    <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold=true BackColor="#dff3f9" Height ="20px" />
                                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                    <ItemStyle CssClass="GridItem" BackColor="#f4fbfd" Wrap="false" Height ="16px" />
                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#FFFFFF" />
                                    <Columns>
                                        <asp:BoundColumn HeaderText="Item No"  DataField="ItemNo" ItemStyle-Width="120px" SortExpression="ItemNo" ItemStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn  HeaderText="Description" DataField="ItemDesc" SortExpression="ItemDesc"
                                            ItemStyle-Width="270px" ItemStyle-Wrap="false"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Customer Item No" DataField="CustomerItemNo" SortExpression="CustomerItemNo"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" ItemStyle-Width="73px"></asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Base UM" DataField="BaseUM" FooterStyle-CssClass="GridHead"
                                            HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem" HeaderStyle-Wrap="true"
                                            SortExpression="BaseUM" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="40px">
                                        </asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Period Sales $" DataFormatString="{0:#,##0}" DataField="PeriodSales"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" ItemStyle-Width="60px" SortExpression="PeriodSales"
                                            ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Period Avg Qty" DataFormatString="{0:#,##0}" DataField="PeriodAvgQty"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="PeriodAvgQty" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="60px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="30 Day Usage" DataFormatString="{0:#,##0}" DataField="30DayUsage"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="30DayUsage" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="50px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="30 Day Usage Lb" DataFormatString="{0:#,##0}" DataField="30DayUsageLb"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="30DayUsageLb" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="60px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Latest Price" DataFormatString="{0:0.00}" DataField="LatestSalesPrice"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="LatestSalesPrice" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="60px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Latest Price Per Lb$" DataField="Latest Price Per Lb $" DataFormatString="{0:#,##0.0}"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="Latest Price Per Lb $" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="100px"></asp:BoundColumn>
                                    <%--
                                        <asp:BoundColumn HeaderText="Latest Cost Per Lb$" DataField="Latest Cost Per Lb $" DataFormatString="{0:#,##0.0}"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="Latest Cost Per Lb $" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="85px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Latest Gp Per Lb$" DataField="Lastest GP Per Lb $" DataFormatString="{0:#,##0.0}"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="Lastest GP Per Lb $" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="75px"></asp:BoundColumn>--%>
                                    </Columns>
                                </asp:DataGrid>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server" />
                                <asp:Label ID="lblMsg" ForeColor="Red" Font-Bold=true  style="text-align:right;font-size:12px;vertical-align:middle;height:25px" runat="server" Width="491px"></asp:Label>
                            </div>
                            <uc1:Pager ID="Pager1" runat="server" OnBubbleClick="Pager_PageChanged"/>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <asp:UpdatePanel ID="upMessage" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="left" width="89%">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="true">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td><uc5:PrintDialogue id="PrintDialogue1" runat="server"></uc5:PrintDialogue></td>
                                    <td><input type="hidden" id="hidPrintURL" runat="server" /></td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td align="right" style="padding-right: 5px;">
                    <img src="Common/Images/Close.gif" style="cursor: hand;" id="ibtnClose" onclick="javascript:window.close();" /></td>
                <td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Sales History" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
