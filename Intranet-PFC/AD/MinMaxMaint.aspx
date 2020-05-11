<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MinMaxMaint.aspx.vb" Inherits="MinMaxMaint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>AD MinMax Maintenance    
    </title>
    <link href="StyleSheet/Styles.css" rel="stylesheet"  type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <asp:SqlDataSource ID="MinMaxNames" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>" 
        SelectCommand="SELECT DISTINCT MinMaxCode FROM ADMinMax ORDER BY MinMaxCode" ></asp:SqlDataSource>
    <div>
        <table width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="middle" class="PageHead" colspan="2">
                       <span class="Left5pxPadd">
                       <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Auto Distribution Min/Max Maintenance"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr><td valign="top" colspan="2">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="50" class="PageBg" align="right">
                    <asp:Label ID="TableFilterLabel" runat="server" Text="Min/Max"></asp:Label>
                    </td>
                    <td width="100" class="PageBg" align="left">
                        <asp:DropDownList ID="MinMaxFilter" runat="server" DataSourceID="MinMaxNames" DataTextField="MinMaxCode" DataValueField="MinMaxCode" >
                        </asp:DropDownList>
                        <input id="PrintHide" name="PrintHide" type="hidden"  value="Print"/>
                        <asp:HiddenField ID="PageFunc" runat="server" />
                    </td>
                    <td class="PageBg">
                        <asp:ImageButton ID="FindButt" runat="server" ImageUrl="Images/search.gif" CausesValidation="False"/>
                         <asp:ImageButton ID="AddButt" runat="server" ImageUrl="Images/newadd.gif" CausesValidation="False"/>
                       <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                        <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label>
                    </td>
                    <td align="right" class="PageBg" valign="bottom">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                        <td style="padding-left: 5px">
                            <img id="Img1" runat="server" src="Images/Print.gif" alt="Print"
                                onclick="javascript:PrintPage();" />
                            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="Images/Close.gif" 
                                PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
                        </td>
                        </tr>
                    </table>
                    </td>
                    </tr>
                </table>
                </td>
            </tr>
            <tr><td colspan="2">
                     <table cellspacing="0" width="100%">
                        <tr class="Left5pxPadd"><td colspan="3" class="redtitle2">Min/Max Data</td></tr>
                        <tr>
                            <td class="Left5pxPadd">Min/Max Code<asp:HiddenField ID="UpdFunction" runat="server" />
                                <asp:HiddenField ID="HiddenID" runat="server" /></td>
                            <td>
                                <asp:TextBox ID="MinMaxUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="MinMaxValidator" runat="server" ErrorMessage="Min/Max code is required" 
                                ControlToValidate="MinMaxUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                       <tr>
                            <td class="Left5pxPadd">SVC Range</td>
                            <td>
                                <asp:TextBox ID="SVCUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="SVCValidator" runat="server" ErrorMessage="A range of SVCs is required." 
                                ControlToValidate="SVCUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                         <tr>
                            <td class="Left5pxPadd">Is Hub? (1=Yes,0=No)</td>
                            <td>
                                <asp:TextBox ID="IsHubBox" runat="server"></asp:TextBox>
                            </td>
                            <td><asp:RequiredFieldValidator ID="IsHubValidator" runat="server" ErrorMessage="Required. 0 or 1." 
                                ControlToValidate="IsHubBox"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                          <tr>
                            <td class="Left5pxPadd">Minimum Factor</td>
                            <td>
                                <asp:TextBox ID="MinFactorBox" runat="server"></asp:TextBox>
                            </td>
                            <td><asp:RequiredFieldValidator ID="MinFactorValidator" runat="server" ErrorMessage="Required. " 
                                ControlToValidate="MinFactorBox"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                         <tr>
                            <td class="Left5pxPadd">Maximum Factor</td>
                            <td>
                                <asp:TextBox ID="MaxFactorBox" runat="server"></asp:TextBox>
                            </td>
                            <td><asp:RequiredFieldValidator ID="MaxFactorValidator" runat="server" ErrorMessage="Required. " 
                                ControlToValidate="MaxFactorBox"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                       <tr class="PageBg">
                            <td  class="Left5pxPadd"> 
                            <asp:ImageButton ID="SaveButt" runat="server" ImageUrl="Images/accept.jpg" />
                            </td>
                            <td colspan="2"  style="padding-left: 5px">
                            Accept will save your changes.
                            </td>
                        </tr>
                        <tr ><td colspan="3"><hr /></td></tr>
                     </table>
                </td>
            </tr>
            <tr>
            <td align="left" class="LeftPadding" >
            <asp:GridView CssClass="PageBg" ID="DependentGrid" runat="server" AllowSorting="false" AutoGenerateColumns="false"
            >
            <Columns>
            <asp:BoundField DataField="StepCode" HeaderText="Used By Step" ReadOnly="True" HeaderStyle-HorizontalAlign="Center" 
            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100" />
            </Columns>
            </asp:GridView><br />
            </td></tr>
            <tr>
            <td class="Left5pxPadd">
            <asp:GridView ID="MinMaxGrid" runat="server" AllowSorting="false" AutoGenerateColumns="false"
            DataKeyNames="pADMinMaxID" OnRowEditing="EditHandler" OnRowDeleting="DeleteHandler">
            <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            <asp:BoundField DataField="MinMaxCode" HeaderText="Code" ReadOnly="True" SortExpression="StepIsHub" HeaderStyle-HorizontalAlign="Center" 
            ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100" />
            <asp:BoundField DataField="SVCRange" HeaderText="SVCs" ReadOnly="True" SortExpression="Branches"  ItemStyle-VerticalAlign="Middle"
             ItemStyle-Width="50" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
            <asp:BoundField DataField="IsHub" HeaderText="Is Hub" ReadOnly="True" SortExpression="MinMaxCode" ItemStyle-HorizontalAlign="Center" 
            HeaderStyle-HorizontalAlign="Center" />
            <asp:BoundField DataField="MinFactor" HeaderText="Min" ReadOnly="True" SortExpression="DetailRecID" ItemStyle-HorizontalAlign="Center" 
            HeaderStyle-HorizontalAlign="Center"  ItemStyle-Width="50"/>
            <asp:BoundField DataField="MaxFactor" HeaderText="Max" ReadOnly="True" SortExpression="MinMaxCode" ItemStyle-HorizontalAlign="Center" 
            HeaderStyle-HorizontalAlign="Center"  ItemStyle-Width="50"/>
            <asp:BoundField DataField="pADMinMaxID" HeaderText="ID" ReadOnly="True" SortExpression="DetailRecID" ItemStyle-HorizontalAlign="Center" 
            HeaderStyle-HorizontalAlign="Center" />
            </Columns>
            </asp:GridView>
            </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
