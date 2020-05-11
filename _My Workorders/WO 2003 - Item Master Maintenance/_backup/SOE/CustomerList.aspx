<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerList.aspx.cs" Inherits="CustomerList" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Sales Order Entry V1.0.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Customer Card</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/PFCCustomer.js"></script>

    <script type="text/javascript">
   
    function CloseChild()
    {
        if (window.opener.closed)
            window.close()
        setTimeout("CloseChild()",10000)
   }
   
    CloseChild()
    function BindCustomer(customerno)
    {
       var _fName = document.getElementById("hidfname").value;
        switch (_fName) 
        {
            case 'ItemMaint':  // refresh ItemMaintenance page (IntranetSite)
            window.opener.document.getElementById("txtCustNo").value=customerno; 
            break;
            case 'sHistory':  // refresh Sales histroy page 
                window.opener.document.getElementById("hidCust").value=customerno; 
                window.opener.document.getElementById("txtCustNumber").value=customerno; 
                window.opener.document.getElementById("txtCustNumber").focus(); 
                CallBtnClick("btnLoadCustomer"); 
                break; 
            case 'SOFind':  // refresh SOFind page           
            window.opener.document.getElementById("txtCustomerNumber").value=customerno; 
            CallBtnClick("btnCustomer");          
            break;
            case 'Pending':  // refresh PendingOrderQuote page           
            window.opener.document.getElementById("txtCustomerNumber").value=customerno;
            CallBtnClick("btnCustNo");
            break;  
            case 'SOPrice':  // refresh Price Worksheet page           
            window.opener.document.getElementById("CustNoTextBox").value=customerno; 
            CallBtnClick("CustNoSubmit");          
            break; 
            case 'QuoteRecall':  // refresh Quote Recall page           
            window.opener.document.getElementById("CustNoTextBox").value=customerno; 
            CallBtnClick("CustNoSubmit");          
            break; 
            default:  //// refresh Main order Entry form 
                window.opener.document.getElementById("CustDet_hidCust").value=customerno; 
                window.opener.document.getElementById("CustDet_txtCustNo").value=customerno; 
                window.opener.document.getElementById("CustDet_txtCustNo").focus(); 
                window.opener.document.getElementById("CustDet_txtCustNo").blur(); 
                //window.opener.document.getElementById("CustDet_txtSONumber").focus(); 
                CallBtnClick("CustDet_btnLoadCustomer"); 
        } 
      
       window.close();
    
    }
    function CallBtnClick(id)
    {
        var btnBind=window.opener.document.getElementById(id);
       
        if (typeof btnBind == 'object')
        { 
            btnBind.click();
            return false; 
        } 
        return;
    }
    //onfocusout="javascript:self.focus();
    function CallSearchBtnClick()
    {
  
        var btnBind=document.getElementById("ibtnCustSearch");
       
        if (typeof btnBind == 'object')
        { 
            btnBind.click();
            return false; 
        } 
        return;
    }
    function SetCustNameFocus()
    {
        document.getElementById("txtCustName").focus();
    }
    </script>

</head>
<body onload="javascript:SetCustNameFocus();"  bgcolor="#ECF9FB" scroll="no" style="margin: 3px" >
    <form id="form1" runat="server" >
    <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlCustomerSearch" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <div>
                <asp:Panel  ID="container" runat="server" DefaultButton="ibtnCustSearch">
                    <table width="100%" cellpadding="0" cellspacing="0" class="splitBorder" style="border:1px solid #88D2E9;">
                <tr>
                    <td class="splitBorder" style="vertical-align:middle;">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border:1px solid #88D2E9;height:30px;">
                            <tr>
                                <td style="width: 100px">
                                <asp:Label ID="lblCuctomerCaption" runat="server" Text="Customer Name:" Font-Bold="True"
                                                        Width="98px"></asp:Label>
                                </td>
                                <td style="width: 100px">
                                    <asp:TextBox ID="txtCustName" runat="server" Width="130px" onkeypress="javascript:if(event.keyCode==13){CallSearchBtnClick();}" >
                                    </asp:TextBox><asp:RequiredFieldValidator style="padding-left:10px;" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCustName"
                                        ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator></td>
                                <td style="width: 100px; padding-left: 10px;">
                                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Customer Sell-To City:" Width="125px"></asp:Label></td>
                                <td style="width: 100px">
                                    <asp:TextBox ID="txtCustCity" runat="server" Width="110px" onkeypress="javascript:if(event.keyCode==13){CallSearchBtnClick();}" ></asp:TextBox></td>
                                <td style="width: 100px; padding-left: 10px;">
                                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Customer Sell-To State:" Width="135px"></asp:Label></td>
                                <td style="width: 100px">
                                    <asp:TextBox ID="txtCustState" runat="server" Width="90px" onkeypress="javascript:if(event.keyCode==13){CallSearchBtnClick();}" ></asp:TextBox></td>
                                <td style="width: 100px; padding-left: 10px;">
                                    <asp:ImageButton ID="ibtnCustSearch" runat="server" ImageUrl="~/Common/Images/btnSearch.gif" OnClick="ibtnCustSearch_Click"  /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="splitBorder" style="padding-top:20px;" align="center">
                        <asp:Label ID="lblMessage" ForeColor="Red" Font-Bold="True" CssClass="Tabhead" runat="server" style="padding-top:20px;"
                            Visible="False"></asp:Label></td>
                </tr>
                <tr>
                    <td class="splitBorder">
                        <div id="divdatagrid" class="Sbar" style="overflow: auto; position: relative; top: 0px;
                                    left: 0px; width: 850px; height: 360px; border: 0px solid; color:White">
                            <asp:DataGrid  ID="dgCustomerList" BorderColor="#9AB8C3" runat="server" BorderWidth="0" Width="1040px"
                                 GridLines="both" AutoGenerateColumns="False"  OnItemDataBound="dgCustomerList_ItemDataBound" OnSortCommand="dgCustomerList_SortCommand"
                                AllowSorting="True" TabIndex="-1">
                                <HeaderStyle HorizontalAlign="Center" Height="25px" CssClass="GridHead" BorderColor="#DAEEEF"
                                    Font-Bold="True" BackColor="#DFF3F9" />
                                <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                                <ItemStyle CssClass="item" BorderColor="#DAEEEF" Wrap="False" BackColor="White"
                                    Height="20px" BorderWidth="1px" />
                                <AlternatingItemStyle BorderColor="#DAEEEF" CssClass="itemShade" BackColor="#ECF9FB"
                                    Height="20px" BorderWidth="1px" />
                                <Columns>
                                    <asp:BoundColumn DataField="pCustomerAddressID" HeaderText="pCustomerAddressID">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="1%" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="CustNo" HeaderText="No" >
                                        <HeaderStyle BorderWidth="1px" CssClass="locked" />
                                        <ItemStyle BorderWidth="1px" CssClass="locked link" Font-Underline="True" Width="50px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="EDIStoreNo" HeaderText="Store">
                                        <HeaderStyle BorderWidth="1px" CssClass="locked link" />
                                        <ItemStyle BorderWidth="1px" CssClass="locked" Width="50px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="CustName" HeaderText="Customer Name">
                                        <HeaderStyle BorderWidth="1px" CssClass="locked link" />
                                        <ItemStyle BorderWidth="1px" CssClass="locked" Width="250px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="Email" HeaderText="Email">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="150px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="AddrLine1" HeaderText="Address 1">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="170px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="City" HeaderText="City">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="80px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="State" HeaderText="State">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="50px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="PostCd" HeaderText="PostCode">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="50px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="Country" HeaderText="Country">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="50px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="CustShipLocation" HeaderText="Sales Loc">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="140px" />
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="CreditInd"  HeaderText="CreditInd" Visible="False">
                                        <HeaderStyle BorderWidth="1px" />
                                        <ItemStyle BorderWidth="1px" Width="50px" />
                                    </asp:BoundColumn>                                        
                                </Columns>
                            </asp:DataGrid>
                            <input id="hidSort" type="hidden" runat="server" />
                            <input id="hidfname" type="hidden" runat="server" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="background: url(common/images/commandlineBg.jpg) left -80px;
                        padding-right: 10px">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="splitborder_t_v splitborder_b_v" align="right" width="100%" id="td1" style="padding-top:5px;" valign="middle">
                                    <img src="Common/Images/close.gif" style="cursor: hand;" onclick="javascript:window.close();" id="img3" alt="Close" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                <td>
                    <uc2:Footer ID="Footer1" Title="Customer Selection" runat="server"></uc2:Footer>
                </td>
            </tr>
            </table>
                </asp:Panel>
        </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
    <script> self.focus(); </script>
</body>
</html>
