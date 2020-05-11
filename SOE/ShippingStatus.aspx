<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShippingStatus.aspx.cs" Inherits="ShippingStatus" %>

<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc5" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shipment Status</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <script src="Common/JavaScript/Common.js"></script>
    <script type="text/javascript">
    function OpenTypeDialog(orderNo)
    {
   
        var orderType =window.open ("ShippingType.aspx?SONumber="+orderNo ,"OrderType",'height=380,width=380,scrollbars=no,status=no,top='+((screen.height/2) - (380/2))+',left='+((screen.width/2) - (380/2))+',resizable=NO',"");
        orderType.focus();        
    }
    
    function ValidateOrderNo()
    {
        if(event.keyCode<47 || event.keyCode>58 ) //|| event.keyCode!=87 || event.keyCode!=119 )
       
        event.keyCode=0;
    
   
    }
    // load Orders
    function LoadDetails()
    {
         return CallBtnClick('btnSetOrderType');
    }
    </script>
</head>
<body onclick="javascript:document.getElementById('lblMessage').innerText='';">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1"  AsyncPostBackTimeout ="360000" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="2" style="height: 100%"
            class="HeaderPanels">
            <tr>
                <td >
                 <asp:UpdatePanel ID="pnlSoEntry" runat="server" UpdateMode="conditional">
                   <ContentTemplate>
                    <table border="0" cellpadding="0" cellspacing="0"  width ="100%" >
                        <tr>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px" width="30%"  >
                                <table border="0" cellpadding="0" cellspacing="0"  >
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblSON0Caption" runat="server" Text="Sales Order Number :" Font-Bold="True"
                                                Width="130px"></asp:Label></td>
                                        <td>
                                            <asp:Button ID="btnBind" runat="server" Text="Button" style="display:none;" OnClick="btnBind_Click" />
                                            <asp:HiddenField ID="hidTableName" runat="server" />
                                             <asp:HiddenField ID="hidIsMultiple" runat="server" Value="false" />
                                            <asp:TextBox ID="txtSONumber" runat="server" CssClass="lbl_whitebox" Width="90px"
                                                AutoPostBack="true" OnTextChanged="txtSONumber_TextChanged" MaxLength ="10"  ></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                               width="35%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="50px">
                                            <asp:Label ID="lnkSoldTo" runat="server" CssClass="TabHead" Text="Sold To:" Font-Bold="True"
                                                Width="45px"></asp:Label></td>
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
                                                        <asp:Label ID="lblSold_State" runat="server" CssClass="lblColor"></asp:Label></td>
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
                                            <asp:Label ID="lblSold_Phone" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" class="SubHeaderPanels" style="padding-left: 4px; padding-top: 5px"
                                width="35%">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td width="55px">
                                            <asp:Label ID="lnkShipTo" runat="server" CssClass="TabHead" Text="Ship To:" Font-Bold="True"></asp:Label></td>
                                        <td> 
                                            <asp:Label ID="lblShip_Name" runat="server" CssClass="lblColor"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                           <asp:Label id="lblShipNum" runat ="server" CssClass ="lblColor" > </asp:Label> </td>
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
                                                        <asp:Label ID="lblShip_City" runat="server" CssClass="lblColor"></asp:Label>
                                                    </td>
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
                                    <tr>
                                        <td colspan="2" align="right" style="padding-right: 5px;">
                                            <asp:ImageButton ID="ibtnHelp" runat="server" ImageUrl="~/Common/Images/help.gif" />
                                        </td>
                                    </tr>
                                </table>
                                
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate>
                  </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;"
                    class="commandLine splitborder_t_v splitborder_b_v" >
                    <asp:UpdatePanel ID="upShipOrder" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table cellpadding="2" cellspacing="0" >
                                <tr>
                                    <td height="20">
                                        <asp:Label ID="Label1" runat="server" Text="Order No:" Font-Bold="True" Width="80px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblOrderNo" runat="server"  Width="80px"></asp:Label></td>
                                    <td style="width: 15px " class="commandLine splitborder_t_v splitborder_b_v" >
                                    </td>
                                    <td >
                                        <asp:Label ID="Label2" runat="server" Text="Invoice No:" Font-Bold="True" Width="100px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblInvoiceNo" runat="server"  Width="90px"></asp:Label>
                                    </td>
                                    <td style="width: 15px" class="commandLine splitborder_t_v splitborder_b_v" >
                                    </td>
                                    <td > 
                                        <asp:Label ID="Label11" runat="server" Text=" Minimum Charge:" Font-Bold="True" Width="100px"></asp:Label>
                                    </td>
                                    <td >
                                        <asp:Label ID="lblMinCharge" runat="server"  Width="90px"></asp:Label></td>
                                    <td style="width: 15px" class="commandLine splitborder_t_v splitborder_b_v" >
                                    </td>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Text="PrintDt:" Font-Bold="True" Width="60px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblPrintDt" runat="server"  Width="90px"></asp:Label></td>
                                    <td style="width: 70px" >
                                    &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td >
                                        <asp:Label ID="Label4" runat="server" Text=" Order Type:" Font-Bold="True" Width="80px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblOrderType" runat="server"  Width="80px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text="Master Order No:" Font-Bold="True" Width="100px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblMasterordNo" runat="server"  Width="90px"></asp:Label>
                                    </td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label6" runat="server" Text="Hold Reason:" Font-Bold="True" Width="100px"></asp:Label>
                                    </td>
                                    <td >
                                        <asp:Label ID="lblReason" runat="server"  Width="120px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label7" runat="server" Text="Reprints:" Font-Bold="True" Width="60px"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblReprints" runat="server"  Width="90px"></asp:Label></td>
                                    <td style="width: 70px">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label8" runat="server" Text="Order Date:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblOrderDt" runat="server"  Width="80px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label9" runat="server" Text="Carrier:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblCarrier" runat="server"  Width="150px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label10" runat="server" Text="Verify Method:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblVerify" runat="server"  Width="90px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Ref SO No:" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblRefSONo" runat="server" Width="90px"></asp:Label></td>
                                    <td style="width: 70px">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 74px" valign="top">
                                        <asp:Label ID="Label13" runat="server" Text="Ship Loc:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td valign="top">
                                        <asp:Label ID="lblShipLoc" runat="server" Width="80px"></asp:Label></td>
                                    <td style="width: 15px">
                                        &nbsp;</td>
                                    <td valign="top">
                                        <asp:Label ID="Label14" runat="server" Text="BOL/UPS:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td valign="top">
                                        <asp:Label ID="lblCarrierPro" runat="server"  Width="90px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td style="width: 15px">
                                    </td>
                                    <td valign="top">
                                        <asp:Label ID="Label24" runat="server" Font-Bold="True" Text="Orig Order No:" Width="80px"></asp:Label></td>
                                    <td valign="top">
                                        <asp:Label ID="lblOrgOrderNo" runat="server" Width="90px"></asp:Label></td>
                                    <td style="width: 70px">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="splitborder_b_v" height="25" style="width: 74px" valign="top">
                                    </td>
                                    <td class="splitborder_b_v" valign="top">
                                    </td>
                                    <td class="splitborder_b_v" style="width: 15px">
                                    </td>
                                    <td valign="top">
                                        <asp:Label ID="Label25" runat="server" Font-Bold="True" Text="Pro Number:" Width="100px"></asp:Label></td>
                                    <td valign="top">
                                        <asp:Label ID="lblProNo" runat="server" Width="90px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td style="width: 15px">
                                    </td>
                                    <td valign="top">
                                    </td>
                                    <td valign="top">
                                    </td>
                                    <td style="width: 70px">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="splitborder_t_v " style="width: 74px">
                                        <asp:Label ID="Label15" runat="server" Text="Ack Print Dt:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td class="splitborder_t_v ">
                                        <asp:Label ID="lblAckDt" runat="server"  Width="80px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="width: 15px">
                                        &nbsp;</td>
                                    <td class="splitborder_t_v ">
                                        <asp:Label ID="Label16" runat="server" Text="Begin Pick Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td class="splitborder_t_v ">
                                        <asp:Label ID="lblBeginDt" runat="server" Width="90px"></asp:Label></td>
                                    <td class="splitborder_t_v  " style="width: 15px">
                                    &nbsp;
                                    </td>
                                    <td class="splitborder_t_v  ">
                                        <asp:Label ID="Label17" runat="server" Text="Confirm Ship Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td class="splitborder_t_v ">
                                        <asp:Label ID="lblShipDt" runat="server"  Width="90px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="width: 15px">
                                     &nbsp;
                                    </td>
                                    <td class="splitborder_t_v ">
                                        <asp:Label ID="Label18" runat="server" Text="Invoice Dt:" Font-Bold="True" Width="60px"></asp:Label></td>
                                    <td class="splitborder_t_v ">
                                        <asp:Label ID="lblInvoiceDt" runat="server"  Width="90px"></asp:Label></td>
                                    <td class="splitborder_t_v " style="width: 70px">
                                     &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 74px">
                                        <asp:Label ID="Label19" runat="server" Text=" Suggested Dt:" Font-Bold="True" Width="80px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblSuggestDt" runat="server"  Width="80px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label20" runat="server" Text=" End Pick Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblEndPickDt" runat="server"  Width="90px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label21" runat="server" Text=" Shipped Dt:" Font-Bold="True" Width="100px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblShippedDt" runat="server"  Width="90px"></asp:Label></td>
                                    <td style="width: 15px">
                                    </td>
                                    <td>
                                        <asp:Label ID="Label22" runat="server" Text="A/R Dt:" Font-Bold="True" Width="60px"></asp:Label></td>
                                    <td>
                                        <asp:Label ID="lblARDt" runat="server"  Width="90px"></asp:Label></td>
                                    <td style="width: 70px">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width: 100px">
                                        <asp:Label ID="Label23" runat="server" Text="Shipping Instructions:" Font-Bold="True"
                                            Width="125px"></asp:Label></td>
                                                <td style="width: 100px">
                                                <asp:Label ID="lblShipInstructions" runat="server"  Width="90px"></asp:Label></td>
                                            </tr>
                                        </table>
                                        &nbsp; &nbsp;</td>
                                    <td colspan="6">
                                        </td>
                                    
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td class="commandLine splitborder_t_v splitborder_b_v" >
                    <table cellpadding="2" cellspacing="0" >
                        <tr>
                            <td>
                                <asp:UpdatePanel ID="upControlGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-dataGrid" style="overflow-x: hidden;
                                            overflow-y: auto; position: relative; top: 0px; left: 0px; height: 220px; border: 1px solid #88D2E9;
                                            width: 250px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                            scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                            scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                            <asp:GridView  UseAccessibleHeader="true" ID="gvControl" PagerSettings-Visible="false" GridLines=Both
                                                Width="99%" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true"
                                                AutoGenerateColumns="false"   OnSorting="gvControl_Sorting" OnRowCommand="gvControl_RowCommand" OnRowDataBound="gvControl_RowDataBound" ShowFooter="True">
                                                <HeaderStyle HorizontalAlign="Center" CssClass="GridHeads" Font-Overline=false Font-Bold="True" BackColor="#DFF3F9" Height="20px"   />
                                                <FooterStyle Font-Bold="True"  ForeColor="#003366" Height="20PX" CssClass="lightBlueBg" VerticalAlign="Middle" HorizontalAlign="Right" />
                                                <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="20px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="item" BackColor="White" Height="20px" BorderWidth="1px" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Carton" ItemStyle-HorizontalAlign=Center SortExpression="CartonNo">
                                                        <ItemTemplate>
                                                            <%--<asp:Label ID="lblControlId" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"pASNControlID") %>'></asp:Label>--%>
                                                            <asp:HiddenField ID="hidControlId" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"pASNControlID") %>' />
                                                            <asp:LinkButton ID="lnlASNNo" CausesValidation="false" Font-Underline="true" ForeColor="#006600"
                                                                Text='<%#DataBinder.Eval(Container.DataItem,"CartonNo") %>' Style="padding-left: 5px"
                                                                runat="server" CommandName="BindDetails" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"pASNControlID") %>'></asp:LinkButton>
                                                        </ItemTemplate>
                                                         <FooterStyle HorizontalAlign="Center" CssClass="Right5pxPadd" />
                                                        <ItemStyle Width="90px" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField HeaderText="EDI" DataField="EDIStatus" SortExpression="EDIStatus">
                                                        <ItemStyle HorizontalAlign="Left" Width="70px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Package Type" DataField="PackageType" SortExpression="PackageType">
                                                        <ItemStyle HorizontalAlign="Left" Width="120px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                </Columns>
                                                <PagerSettings Visible="False" />
                                            </asp:GridView>
                                            <input id="hidSortControl" type="hidden" name="Hidden1" runat="server">
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td>
                                <asp:UpdatePanel ID="upDetailGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div class="Sbar" oncontextmenu="Javascript:return false;" id="div-datagrid" style="overflow-x: hidden;
                                            overflow-y: auto; top: 0px; left: 0px; height: 220px; border: 1px solid #88D2E9;
                                            width: 700px; background-color: White; scrollbar-3dlight-color: white; scrollbar-arrow-color: #1D7E94;
                                            scrollbar-track-color: #ECF8FB; scrollbar-darkshadow-color: #9EDEEC; scrollbar-face-color: #9EDEEC;
                                            scrollbar-highlight-color: #E4F7FA; scrollbar-shadow-color: #1D7E94">
                                            <asp:GridView ShowFooter="True" BorderWidth=1  UseAccessibleHeader="true" ID="gvDetail" PagerSettings-Visible="false"
                                                Width="98%" runat="server" AllowPaging="false" ShowHeader="true" AllowSorting="true" GridLines=both
                                                AutoGenerateColumns="false" OnSorting="gvDetail_Sorting" OnRowDataBound="gvDetail_RowDataBound"  >
                                                <HeaderStyle HorizontalAlign="Center" CssClass="GridHead" Font-Bold="True" BackColor="#DFF3F9" Height="20px"   />
                                                <FooterStyle Font-Bold="True"  ForeColor="#003366" Height="20PX" CssClass="lightBlueBg" VerticalAlign="Middle" HorizontalAlign="Right" />
                                                <RowStyle CssClass="item" Wrap="False" BackColor="White" Height="20px" BorderWidth="1px" />
                                                <AlternatingRowStyle CssClass="item" BackColor="White" Height="20px" BorderWidth="1px" />
                                                <Columns>
                                                    <asp:BoundField HeaderText="Quantity" DataField="TotalQty" SortExpression="TotalQty">
                                                        <ItemStyle HorizontalAlign="Right" Width="50px" CssClass="Left5pxPadd" />
                                                        <FooterStyle HorizontalAlign="Right" CssClass="Right5pxPadd"  />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Item No" DataField="ItemNo" SortExpression="ItemNO">
                                                        <ItemStyle HorizontalAlign="Left" Width="100px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Description" DataField="ItemDesc" SortExpression="ItemDesc">
                                                        <ItemStyle HorizontalAlign="Left" Width="250px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Weight" DataField="TotalWeight" SortExpression="TotalWeight">
                                                        <ItemStyle HorizontalAlign="Right" Width="50px" CssClass="Left5pxPadd" />
                                                        <FooterStyle HorizontalAlign="Right" CssClass="Right5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="UM" DataField="SellUM" SortExpression="SellUM">
                                                        <ItemStyle HorizontalAlign="Left" Width="50px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:BoundField HeaderText="Tracking No" DataField="TrackingNo" SortExpression="TrackingNo">
                                                        <ItemStyle HorizontalAlign="Left" Width="110px" CssClass="Left5pxPadd" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Carrier" SortExpression="Carrier" Visible=false>
                                                        <ItemTemplate>
                                                            <asp:HiddenField ID="hidCarrier" runat="server" Value='<%#DataBinder.Eval(Container.DataItem,"Carrier") %>' />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>                                                                     
                                                </Columns>
                                                <PagerSettings Visible="False" />
                                            </asp:GridView>
                                            <input id="hidSortDetail" type="hidden" name="Hidden1" runat="server">
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
             <tr>
                <td align="right" width="100%" id="tdButton" class="commandLine splitborder_t_v splitborder_b_v"
                    style="height: 20px; background-position: -80px  left;">
                    <asp:UpdatePanel ID="upMessage" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding-left:5px;" align="left" width="89%">
                                        <asp:UpdateProgress ID="upPanel" runat="server" DynamicLayout="true">
                                            <ProgressTemplate>
                                                <span class="TabHead">Loading...</span></ProgressTemplate>
                                        </asp:UpdateProgress>
                                        <asp:Label ID="lblMessage" ForeColor="green" CssClass="Tabhead" runat="server" Text=""></asp:Label>
                                    </td>
                                    <td>
                                        <uc5:PrintDialogue ID="PrintDialogue1" runat="server"></uc5:PrintDialogue>
                                    </td>
                                    <td>
                                        <input type="hidden" id="hidPrintURL" runat="server" /></td>
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
                    <uc2:Footer ID="Footer1" Title="Shipment Status" runat="server"></uc2:Footer>
                </td>
            </tr>
        </table>
    </form>
   
</body>
</html>
