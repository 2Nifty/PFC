<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillToAddressExport.aspx.cs" Inherits="BillTo" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/novapopupdatepicker.ascx" TagName="novapopupdatepicker" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/SubHeader.ascx" TagName="CEHeader" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>SOE- Bill To Information</title>
    <link href="http://206.72.71.194/SOE/Common/StyleSheet/printstyles.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="Common/JavaScript/Common.js"></script>
    
    <script>
    function callTaxExempt(custNo)
{
    var Url = "TaxExempt.aspx?CustomerNumber="+ custNo ;
    window.open(Url,"TaxExempt" ,'height=460,width=710,scrollbars=no,status=no,top='+((screen.height/2) - (320/2))+',left='+((screen.width/2) - (650/2))+',resizable=No',"");
}
    </script> 
</head>
<body>
    <form id="form1" runat="server">
        <table class="PageBg" border="0" cellpadding="0" cellspacing="0" >
            <tr>
                <td bgcolor="white" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px;
                    padding-top: 0px">
                    <asp:Image ID="imglogo" runat="server" ImageUrl="http://206.72.71.194/SOE/Common/Images/PFC_logo.gif" /></td>
            </tr>
            <tr>
                <td style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; padding-top: 5px">
                </td>
            </tr>
            <tr>
                <td style="padding: 0px;">
                    <table border="0" cellpadding="3" cellspacing="0" width="100%" height="20px">
                        <tr>
                            <td style=" padding-left: 8px;">
                                <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Sales Order Number"
                                    ></asp:Label></td>
                            <td style="width: 100px; " align="left">
                                <asp:Label ID="lblSONumber" runat="server" Font-Bold="False" CssClass="lblBluebox"
                                     Width="50px"></asp:Label>
                               
                            </td>
                            <td >
                                <asp:Label ID="Label18" runat="server" Font-Bold="True" Text="Customer Number" ></asp:Label></td>
                            <td style="width: 50px; padding-left: 0px;" align="left">
                                <asp:Label ID="lblCustNo" runat="server" Font-Bold="False" CssClass="lblBluebox"
                                    Width="50px"></asp:Label>
                            </td>
                            <td width = "20%">&nbsp;
                            </td>
                            
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td  class="PageBg" style="padding-bottom: 5px; padding-left: 5px; padding-right: 5px;">
                    <table height="5px" border="0" cellpadding="3" cellspacing="0" width="100%">
                        <tr>
                            <td colspan="2">
                                <input id="hidpCustContactID" type="hidden" name="hidContactID" runat="server">
                                <input id="hidfCustAddrID" type="hidden" name="hidContactID" runat="server"></td>
                            <td>
                            </td>
                            <td colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 5px;">
                                    <tr>
                                        <td align="center">
                                            <hr color="#003366" />
                                        </td>
                                        <td align="center" width="50px">
                                            <asp:Label ID="Label6" runat="server" Text="Address" Font-Bold="True" Width="55px"></asp:Label></td>
                                        <td align="center">
                                            <hr align="center" color="#003366" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="75px">
                            </td>
                            <td colspan="2">
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 300px;">
                                    <tr>
                                        <td align="center">
                                            <hr color="#003366" />
                                        </td>
                                        <td align="center" width="50px">
                                            <asp:Label ID="Label7" runat="server" Font-Bold="True" Text="Contact"></asp:Label></td>
                                        <td align="center">
                                            <hr align="center" color="#003366" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="Name" Font-Bold="True" Width="60px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblName" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Name" Width="70px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblContactName" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Address 1" Width="59px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblAddress1" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Job Title" Width="70px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblContactJobTitle" runat="server" Font-Bold="False" Width="170px"
                                    CssClass="lblBluebox"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label8" runat="server" Font-Bold="True" Text="Address 2" Width="60px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblAddress2" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="Department" Width="70px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblContactDepart" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="City / State" Width="59px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblCity" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label><asp:Label
                                    Style="padding-left: 5px" ID="lblState" runat="server" Font-Bold="False" Width="50px"
                                    CssClass="lblBluebox"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label14" runat="server" Font-Bold="True" Text="Phone / Ext" Width="70px"></asp:Label></td>
                            <td>
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblContactPhoneNo" runat="server" Font-Bold="False" Width="108px"
                                                CssClass="lblBluebox"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblContactExt" runat="server" Font-Bold="False" Width="50px" CssClass="lblBluebox"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Postcode" Width="59px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblPostcode" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label17" runat="server" Font-Bold="True" Text="Fax No" Width="70px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblContactFax" runat="server" Font-Bold="False" Width="108px" CssClass="lblBluebox"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Country" Width="59px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblCountry" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label16" runat="server" Font-Bold="True" Text="Mobile No" Width="70px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblContactMob" runat="server" Font-Bold="False" Width="108px" CssClass="lblBluebox"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Phone" Width="59px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblPhone" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                            <td>
                            </td>
                            <td>
                                <asp:Label ID="Label15" runat="server" Font-Bold="True" Text="Email" Width="70px"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblContactEmail" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="border-collapse: collapse;">
                    <table border="0" cellpadding="3" cellspacing="0" width="100%">
                        <tr>
                            <td width="30%">
                            </td>
                            <td width="30%" align="center">
                                <table border="0" cellpadding="3" cellspacing="0">
                                    <tr>
                                        <td width="40px" align="center">
                                            <hr color="#003366" />
                                        </td>
                                        <td align="center" width="80px">
                                            <asp:Label ID="Label23" runat="server" Text="Credit & Sales" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td width="40px" align="center">
                                            <hr color="#003366" />
                                        </td>
                                    </tr>
                                </table>
                                <td width="10%">
                                </td>
                            <td width="15" align="right">
                            </td>
                            <td width="15" align="right">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="5">
                                <table height="5px" border="0" cellpadding="3" cellspacing="0" width="100%">
                                    <tr>
                                        <td colspan="2">
                                            <input id="Hidden1" type="hidden" name="hidContactID" runat="server">
                                            <input id="Hidden2" type="hidden" name="hidContactID" runat="server"></td>
                                        <td>
                                        </td>
                                        <td colspan="2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label21" runat="server" Text="Tax Code" Font-Bold="True" Width="75px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblTaxCode" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label24" runat="server" Font-Bold="True" Text="Credit App" Width="70px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblCreditApp" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label26" runat="server" Font-Bold="True" Text="Tax status" Width="75px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblTaxStatus" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label28" runat="server" Font-Bold="True" Text="Credit Limit" Width="70px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblCreditLimit" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label30" runat="server" Font-Bold="True" Text="Terms" Width="75px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblTerms" runat="server" Font-Bold="False" Width="170px" CssClass="lblBluebox"></asp:Label></td>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label32" runat="server" Font-Bold="True" Text="Review /Date" Width="70px"></asp:Label></td>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblRvw" runat="server" Font-Bold="False" Width="108px" CssClass="lblBluebox"></asp:Label></td>
                                                    <td>
                                                        <asp:Label ID="lblRvwDt" runat="server" Font-Bold="False" Width="50px" CssClass="lblBluebox"></asp:Label></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label34" runat="server" Font-Bold="True" Text="Price Code" Width="75px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblPriceCode" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label37" runat="server" Font-Bold="True" Text="Invoice Instr" Width="70px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblinvinstr" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label40" runat="server" Font-Bold="True" Text="Sales Rep" Width="75px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblSalesRep" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label42" runat="server" Font-Bold="True" Text="Invoice Copies" Width="80px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblInvCopies" runat="server" Font-Bold="False" Width="108px" CssClass="lblBluebox"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label44" runat="server" Font-Bold="True" Text="Contract No" Width="75px"></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblContractno" runat="server" Font-Bold="False" Width="105px" CssClass="lblBluebox"></asp:Label></td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
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
