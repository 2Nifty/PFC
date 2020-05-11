<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SalesHistoryExport.aspx.cs"
    Inherits="SoldToAddressExport" %>

<%@ Register Src="Common/UserControls/PrintHeader.ascx" TagName="PrintHeader" TagPrefix="uc5" %>

<%@ Register Src="Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc4" %>

<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker"
    TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="CEHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SOE- Sold To Information</title>
    <%= PFC.SOE.DataAccessLayer.Global.PrintStyleSheet %>
    
</head>
<body>
    <form id="form1" runat="server">
        <table class="PageBg"  border="0" cellpadding="0" cellspacing="0" style="height: 100%">
            <tr>
                <td bgcolor="white" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px; height:70px;
                    padding-top: 0px">
                    <uc5:PrintHeader ID="PrintHeader1" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; padding-top: 5px">
                </td>
            </tr>

            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0" width="100% ">
                        <tr>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px;"
                                width="35% ">
                               
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="40%"><asp:Label ID="lblCuctN0Caption" runat="server" Text="Customer No:" Font-Bold="True"  ></asp:Label></td>
                                                <td align="left" width="60%">
                                                    <asp:label ID="txtCustNumber" runat="server" CssClass="lbl_whitebox" Width="80px" ></asp:label>
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
                                                              <asp:label ID="Label1" Font-Bold="True" runat="server" Text="Month" /></td>
                                                            <td align="center" >
                                                                <asp:label ID="Label2" Font-Bold="True" runat="server" Text="Year" /></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:label ID="Label3" Font-Bold="True" runat="server" Text="Period Start" /></td>
                                                            <td style="width: 57px">
                                                                <asp:Label ID="lblStMonth" Font-Bold="True" runat="server" Text =""/>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblStYear" Font-Bold="True" runat="server" Text =""/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 100px">
                                                                <asp:label ID="Label4" Font-Bold="True" runat="server" Text="Period End" /></td>
                                                            <td style="width: 57px">
                                                              <asp:Label ID="lblEndMonth" Font-Bold="True" runat="server" Text =""/>
                                                            </td>
                                                            <td>
                                                            <asp:Label ID="lblEndYear" Font-Bold="True" runat="server" Text =""/>
                                                                
                                                            </td>
                                                            <td rowspan="3" valign="bottom" style="padding-left: 10px; padding-top: 5px;">
                                                             
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                              
                            </td>
                            <td valign="top" class="SubHeaderPanels" width="33%" style="padding-left: 4px; padding-top: 5px">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="50px">
                                            <asp:Label ID="lnkSoldTo"  runat="server" CssClass="TabHead" 
                                            Text="Sold To:" Font-Bold="True" Width="45px" /></td>
                                        <td>
                                            <asp:Label ID="lblSold_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSoldCustNum" runat="server" CssClass="lblbox"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblSold_Contact" runat="server" CssClass="lblColor"></asp:Label></td>
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
                                                        <asp:Label ID="lblSoldCom" runat="server" CssClass="lblColor" Text=",&nbsp;"></asp:Label></td>
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
                                    <tr><td></td><td></td></tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSalesRep" runat="server" Text="Sales Rep:"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblSalesRepdisp" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                width="32%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="55px">
                                            <asp:Label ID="lnkShipTo" runat="server" CssClass="TabHead"   Text="Ship To:" Font-Bold="True"></asp:Label></td>
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
                                            
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
       
            <tr>
                <td valign=top  >
                                <asp:DataGrid ID="dgSalesHistory" BackColor="#f4fbfd" AllowPaging="false" runat="server"  Width ="1050px"
                                    AutoGenerateColumns="false" PagerStyle-Visible="false" 
                                    BorderWidth="1" AllowSorting="false" GridLines="both" ShowFooter="false" >
                                    <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" BackColor="#dff3f9" Height ="20px" />
                                    <FooterStyle HorizontalAlign="right" CssClass="GridHead" BackColor="#dff3f9" />
                                    <ItemStyle CssClass="item"  Wrap="false" Height ="15px" />
                                    <AlternatingItemStyle CssClass="itemShade"  />
                                    <Columns>
                                        <asp:BoundColumn HeaderText="Item No" HeaderStyle-CssClass="GridHead" DataField="ItemNo" ItemStyle-Width="120px" SortExpression="ItemNo" ItemStyle-Wrap="false">
                                        </asp:BoundColumn>
                                        <asp:BoundColumn  HeaderText="Description" DataField="ItemDesc" SortExpression="ItemDesc"
                                            HeaderStyle-CssClass="GridHead" ItemStyle-Width="250px" ItemStyle-Wrap="false"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Customer Item No" DataField="CustomerItemNo" SortExpression="CustomerItemNo"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" ItemStyle-Width="73px"></asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Base UM" DataField="BaseUM" FooterStyle-CssClass="GridHead"
                                            HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem" HeaderStyle-Wrap="false"
                                            SortExpression="BaseUM" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="50px">
                                        </asp:BoundColumn>
                                        
                                        <asp:BoundColumn HeaderText="Period Sales $" DataFormatString="{0:#,##0}" DataField="PeriodSales"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" ItemStyle-Width="90px" SortExpression="PeriodSales"
                                            ItemStyle-HorizontalAlign="Right"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Period Avg Qty" DataFormatString="{0:#,##0}" DataField="PeriodAvgQty"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="PeriodAvgQty" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="75px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="30 Day Usage" DataFormatString="{0:0.0}" DataField="30DayUsage"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="false" SortExpression="30DayUsage" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="90px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="30 Day Usage Lb" DataFormatString="{0:#,##0}" DataField="30DayUsageLb"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="false" SortExpression="30DayUsageLb" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="90px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Latest Price" DataFormatString="{0:0.00}" DataField="LatestSalesPrice"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="false" SortExpression="LatestSalesPrice" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="90px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Latest Price Per Lb$" DataField="Latest Price Per Lb $" DataFormatString="{0:#,##0}"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="Latest Price Per Lb $" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="75px"></asp:BoundColumn>
                                    <%--
                                        <asp:BoundColumn HeaderText="Latest Cost Per Lb$" DataField="Latest Cost Per Lb $" DataFormatString="{0:#,##0}"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="Latest Cost Per Lb $" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="75px"></asp:BoundColumn>
                                    
                                        <asp:BoundColumn HeaderText="Latest Gp Per Lb$" DataField="Lastest GP Per Lb $" DataFormatString="{0:#,##0}"
                                            FooterStyle-CssClass="GridHead" HeaderStyle-CssClass="GridHead" ItemStyle-CssClass="GridItem"
                                            HeaderStyle-Wrap="true" SortExpression="Lastest GP Per Lb $" ItemStyle-HorizontalAlign="Right"
                                            ItemStyle-Width="75px"></asp:BoundColumn>--%>
                                    </Columns>
                                </asp:DataGrid>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server" />
                                <asp:Label ID="lblMsg" ForeColor="Red" CssClass="Tabhead" style="text-align:right;font-size:10px;vertical-align:middle;height:25px" runat="server" Width="491px"></asp:Label>
                          
                </td>
            </tr>


            <tr>
                <td class="lightBg" style="border-collapse: collapse;">
                    <div class="blueBorder">
                            </div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
