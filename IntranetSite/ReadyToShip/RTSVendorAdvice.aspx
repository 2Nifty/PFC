<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RTSVendorAdvice.aspx.cs" Inherits="RTSVendorAdvice" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <script language="javascript">
    <!--
    function PrintAdvice()
    {   
        var prtContent = "<html><head><link href=Common/StyleSheet/Styles.css rel=stylesheet type=text/css /></head><body>";
            var WinPrint = window.open('','RTSAdvicePrint','left=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');        
            prtContent = prtContent + document.getElementById("Panel1").innerHTML ;
            prtContent = prtContent + "</body></html>";        
            WinPrint.document.write(prtContent);
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
            WinPrint.close();
            return false;
        
    }
    -->
    </script>

    <title>RTS Vendor Advice</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="AdvisableVendors" runat="server"
         ConnectionString="<%$ ConnectionStrings:PFCReportsConnect %>" 
         ProviderName="<%$ ConnectionStrings:PFCReportsConnect.ProviderName %>" 
         SelectCommand="SELECT distinct VendNo FROM [GERRTSAdvice] ORDER BY VendNo" 
        ></asp:SqlDataSource>
        <asp:SqlDataSource ID="AdviceData" runat="server"
         ConnectionString="<%$ ConnectionStrings:PFCReportsConnect %>" 
         ProviderName="<%$ ConnectionStrings:PFCReportsConnect.ProviderName %>" 
         SelectCommand="SELECT VendNo, PONo, ItemNo, Qty, round(Qty*GrossWght*0.453592,1) As KGWeight, PortofLading, LocCd, GERRTSStatCd, ShortCode, replace(MfgPlant,char(34), '') as MfgPlant FROM GERRTSAdvice left outer join LocMaster on GERRTSAdvice.LocCd = LocMaster.LocID WHERE (VendNo = ?) and Qty > 0 ORDER BY PortofLading, PONo, ItemNo" 
        >
            <SelectParameters>
                <asp:ControlParameter ControlID="VendorDropDownList" Name="@param1" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
    <div id="Container">
        <uc1:Header ID="Header1" runat="server" />
        <div id="Content">
             <table width="100%" cellspacing="0">
                <tr class="PageHead" >
                    <td class="BannerText" width="250px">
                    <div class="Left5pxPadd">Vendor Advice to Excel</div>
                    </td>
                    <td align="left">
                    <div >Vendor&nbsp; &nbsp;
                        <asp:DropDownList ID="VendorDropDownList" runat="server" DataSourceID="AdvisableVendors"
                          OnDataBound="VendDDL_LoadComplete"  OnSelectedIndexChanged="VendDDL_IndexChanged"  AutoPostBack="true"
                          DataTextField="VendNo" DataValueField="VendNo">
                        </asp:DropDownList>
                        <asp:Label ID="VendorNameLabel" runat="server" Text=""></asp:Label>
                    </div>
                    </td>
                    <td>
                    Exporting to <asp:Label ID="DefaultDirLabel" runat="server" Text=""></asp:Label>
                    </td>
                </tr>
             </table>
           <asp:Panel ID="Panel1" runat="server" Height="540px" Width="100%" ScrollBars="auto" BorderColor="black" BorderWidth="1">
           <table>
               <tr>
                   <td valign="top">
               <asp:GridView ID="AdviceGridView" runat="server" AutoGenerateColumns="False" DataSourceID="AdviceData">
                   <Columns>
                       <asp:BoundField DataField="VendNo" HeaderText="Vendor" SortExpression="VendNo" />
                       <asp:BoundField DataField="PONo" HeaderText="PO #" SortExpression="PONo" />
                       <asp:BoundField DataField="ItemNo" HeaderText="Part #" SortExpression="ItemNo" />
                       <asp:BoundField DataField="Qty" HeaderText="Quantity" SortExpression="AdviceQty" >
                           <ItemStyle HorizontalAlign="Center" />
                       </asp:BoundField>
                       <asp:BoundField DataField="KGWeight" HeaderText="Gross Weight (KG)" SortExpression="GrossWght" >
                           <ItemStyle HorizontalAlign="Center" />
                       </asp:BoundField>
                       <asp:BoundField DataField="PortofLading" HeaderText="Shipping Port" SortExpression="PortofLading" >
                           <ItemStyle HorizontalAlign="Center" />
                       </asp:BoundField>
                       <asp:BoundField DataField="GERRTSStatCd" HeaderText="Priority" SortExpression="GERRTSStatCd" >
                           <ItemStyle HorizontalAlign="Center"  />
                       </asp:BoundField>
                       <asp:BoundField DataField="ShortCode" HeaderText="PFC Loc" SortExpression="ShortCode" >
                           <ItemStyle HorizontalAlign="Center" />
                       </asp:BoundField>
                       <asp:BoundField DataField="MfgPlant" HeaderText="Mfg Plnt" SortExpression="MfgPlant" >
                           <ItemStyle HorizontalAlign="Center" />
                       </asp:BoundField>
                   </Columns>
               </asp:GridView>
                   </td>
                   <td valign="top">
                       <table width="350px" cellspacing="0" >
                            <tr>
                               <td colspan="3" class="BluTxt" align="center">Vendor Advice E-Mail
                               </td>
                           </tr>
                          <tr>
                               <td>To:
                               </td>
                               <td><asp:TextBox ID="VendorEMailTextBox" runat="server" Width="330px"></asp:TextBox>
                               </td>
                               <td>
                               </td>
                           </tr>
                           <tr>
                               <td>Cc:
                               </td>
                               <td>
                                   <asp:TextBox ID="EMailCCTextBox" runat="server" Width="330px"></asp:TextBox>
                               </td>
                               <td>
                               </td>
                           </tr>
                           <tr>
                               <td>From:
                               </td>
                               <td>
                                   <asp:TextBox ID="EMailFromTextBox" runat="server" Width="330px"></asp:TextBox>
                               </td>
                               <td>
                               </td>
                           </tr>
                           <tr>
                               <td>Subject:
                               </td>
                               <td><asp:TextBox ID="EMailSubjectTextBox"  runat="server" Width="330px"></asp:TextBox>
                               </td>
                               <td>
                               </td>
                           </tr>
                           <tr>
                               <td valign="top">Content:
                               </td>
                               <td><asp:TextBox Rows="20" TextMode="multiLine" ID="EMailBodyTextBox"  runat="server" Width="330px"></asp:TextBox>
                               </td>
                               <td>
                               </td>
                           </tr>
                           <tr class="BluBg">
                               <td colspan="2">Fill in the content of the e-mail. Press OK to send the e-mail. The data to the left will be attached in an Excel spreadsheet.
                                </td>
                               <td>
                               <asp:ImageButton ID="ExcelEMailButton" runat="server" ImageUrl="../Common/Images/ok.gif" OnClick="ExcelEMailButton_Click" CausesValidation="false" />
                               </td>
                           </tr>
                       </table>
                   </td>
               </tr>
           </table>           
           
            </asp:Panel>
            <table width="100%" cellspacing="0">
                <tr class="PageBg">
                    <td class="Left5pxPadd">
                    <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                    <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                    </td>
                    <td  align="right">
                    <asp:ImageButton ID="ExcelExportButton" runat="server" ImageUrl="../Common/Images/ExporttoExcel.gif" OnClick="ExcelExportButton_Click" />
                    </td>
                    <td  align="right" valign="top">
                    
                    
                    </td>
                    <td  align="left" valign="middle"></td>
                    <td  align="right">
                    <img id="Img1" runat="server" src="../Common/Images/print.gif" alt="Print"
                        onclick="javascript:PrintAdvice();" />
                    <asp:ImageButton ID="HelpButton" runat="server" ImageUrl="../Common/Images/help.gif" />
                    <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg" 
                                PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
                    &nbsp; &nbsp;
                    </td>
                </tr>
            </table>
            <table width="100%" cellspacing="0">
                <uc2:BottomFrame ID="BottomFrame1" runat="server" />
           </table>
        </div>
    </div>
    </form>
</body>
</html>
