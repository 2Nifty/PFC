<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RTSVendorUpload.aspx.cs" Inherits="RTSVendorUpload" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="~/Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>RTS Vendor Upload</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../ReadyToShip/Common/StyleSheet/RTS_Styles.css" rel="stylesheet" type="text/css" />
    <script language="javascript">
    <!--
        var HeaderRatio = 0.4;
        var DetailRatio = 0.6;
        function SetFileName(filename)
        {
            document.getElementById("SingleFileName").innerText = filename;
            //alert(filename);
        }  
        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //two states: selection of files and work vendor file
            //if ValidationPanelTop is not there, we are selecting files
            var HeaderPanel = document.getElementById("ValidationPanelTop");
            if (HeaderPanel == null)
            {
                // size for file selection
                //take out room for the header and bottom panel
                yh = yh - 70;
                var MainPanel = document.getElementById("FilePanel");
                MainPanel.style.height = yh;  
                var GridPanel = document.getElementById("FilesPanel");
                GridPanel.style.height = yh - 180;  
            }
            else
            {
                // size for work vendor file 
                yh = yh - 110;
                HeaderPanel.style.height = yh * HeaderRatio;  
                /*
                var EditPanel = document.getElementById("ValidationEditPanel");
                EditPanel.style.height = Math.max((yh * HeaderRatio) - 55, 10);  
                */
                var DetailPanel = document.getElementById("ValidationPanelBottom");
                DetailPanel.style.height = yh * DetailRatio;  
                DetailPanel.style.width = xw;  
                var DetailGridPanel = document.getElementById("ValidationGridView");
                DetailGridPanel.style.height = (yh * DetailRatio) - 55;  
                var DetailGridHeightHid = document.getElementById("DetailGridHeightHidden");
                DetailGridHeightHid.value = (yh * DetailRatio) - 55;
            }
        }
    
    -->
    </script>
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="MainForm" runat="server">
        <asp:SqlDataSource ID="GERRTSSqlData" runat="server"
         ConnectionString="<%$ ConnectionStrings:PFCReportsConnect %>"  
         SelectCommand="SELECT * FROM GERRTS WHERE (VendNo = ?) and (StatusCd >= '01') ORDER BY pGERRTSID" 
         DeleteCommand="DELETE FROM [GERRTS] WHERE [pGERRTSID] = ?" 
         InsertCommand="INSERT INTO [GERRTS] ([pGERRTSID], [VendNo], [PONo], [ItemNo], [GERRTSStatCd], [PalletCnt], [Qty], [QtyRemaining], [GrossWght], [PortofLading], [LocCd], [EntryID], [EntryDt], [ChangeID], [ChangeDt], [StatusCd]) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" ProviderName="<%$ ConnectionStrings:PFCReportsConnect.ProviderName %>" 
         UpdateCommand="UPDATE [GERRTS] SET [PONo] = ?, [ItemNo] = ?, [GERRTSStatCd] = ?, [PalletCnt] = ?, [Qty] = ?, [GrossWght] = ?, [PortofLading] = ? WHERE [pGERRTSID] = ?"
         >
            <SelectParameters>
                <asp:ControlParameter ControlID="VendorDDL" Name="selVend" PropertyName="SelectedValue" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="pGERRTSID" Type="Decimal" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="PONo" Type="String" />
                <asp:Parameter Name="ItemNo" Type="String" />
                <asp:Parameter Name="GERRTSStatCd" Type="String" />
                <asp:Parameter Name="PalletCnt" Type="String" />
                <asp:Parameter Name="Qty" Type="Int32" />
                <asp:Parameter Name="GrossWght" Type="Double" />
                <asp:Parameter Name="PortofLading" Type="String" />
                <asp:Parameter Name="pGERRTSID" Type="Decimal" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="pGERRTSID" Type="Decimal" />
                <asp:Parameter Name="VendNo" Type="String" />
                <asp:Parameter Name="PONo" Type="String" />
                <asp:Parameter Name="ItemNo" Type="String" />
                <asp:Parameter Name="GERRTSStatCd" Type="String" />
                <asp:Parameter Name="PalletCnt" Type="Int32" />
                <asp:Parameter Name="Qty" Type="Int32" />
                <asp:Parameter Name="QtyRemaining" Type="Int32" />
                <asp:Parameter Name="GrossWght" Type="Double" />
                <asp:Parameter Name="PortofLading" Type="String" />
                <asp:Parameter Name="LocCd" Type="String" />
                <asp:Parameter Name="EntryID" Type="String" />
                <asp:Parameter Name="EntryDt" Type="DateTime" />
                <asp:Parameter Name="ChangeID" Type="String" />
                <asp:Parameter Name="ChangeDt" Type="DateTime" />
                <asp:Parameter Name="StatusCd" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>        
        <asp:SqlDataSource ID="LocationDDLData" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnect %>"
            ProviderName="<%$ ConnectionStrings:PFCReportsConnect.ProviderName %>" 
            SelectCommand="SELECT [LocID], [LocName] FROM [LocMaster] ORDER BY [LocName]">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="ItemDDLData" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnect %>"
            ProviderName="<%$ ConnectionStrings:PFCReportsConnect.ProviderName %>" 
            SelectCommand="SELECT [LocID], [LocName] FROM [LocMaster] ORDER BY [LocName]">
        </asp:SqlDataSource>
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        
        <div>
         <uc1:Header ID="Header1" runat="server" />
           <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="middle" class="PageHead">
                       <span class="Left5pxPadd">
                       <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Vendor Upload"></asp:Label>
                       </span>
                </td>
                <td align="right" class="PageHead">
                <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="common/Images/close.jpg" 
                    PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
                &nbsp; &nbsp;
                <asp:HiddenField ID="UpdFunction" runat="server" />
                <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top" colspan="2">
                   <asp:Panel ID="FilePanel" runat="server" Height="500px" Width="100%">
                    <table cellspacing="0" width="100%">
                        <tr>
                            <td class="Left5pxPadd"><div class="readtxt"> Vendor to be uploaded</div>
                                <asp:DropDownList ID="VendorDDL" runat="server" DataTextField="ShortCode" DataValueField="ShortCode">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">
                                <div class="readtxt">Select file to upload
                                </div>
                                <input id="SingleFileSelector" type="file"  size="80" onchange="SetFileName(this.value);"/>
                                <asp:HiddenField ID="SingleFileName" runat="server" />
                                &nbsp; &nbsp;<asp:CheckBox ID="PalletPartnerCheckBox" runat="server" />
                                Pallet Partner File Upload
                                </td>
                        </tr>
                        <tr class="BluBg">
                            <td class="Left5pxPadd" valign="middle" >
                            <asp:ImageButton ID="OKButton" runat="server" ImageUrl="../Common/Images/ok.gif" OnClick="OKButton_Click" />
                                &nbsp; &nbsp;
                            <asp:ImageButton ID="DeleteVendorDataButton" runat="server" ImageUrl="../Common/Images/BtnDelete.gif" OnClick="DeleteVendorDataButton_Click" />
                            Vendor Data &nbsp; &nbsp;
                            <asp:ImageButton ID="ExcelExportButton" runat="server" ImageUrl="../Common/Images/ExporttoExcel.gif" OnClick="ExcelExportButton_Click" />
                                <asp:LinkButton ID="ShowExcelLink" PostBackUrl="" 
                                runat="server">ERROR: AppPref not set for RTS DIR</asp:LinkButton>
                                </td>
                        </tr>
                    </table>
                    <table width="100%" >
                        <tr>
                            <td class="Left5pxPadd"><div class="readtxt">Files in default folder
                                <asp:Label ID="DefaultDirLabel" runat="server" Text=""></asp:Label></div>
                                <asp:Panel ID="FilesPanel" runat="server" Height="300px" ScrollBars="Vertical">
                                <asp:GridView ID="VendorFilesGridView" runat="server" HeaderStyle-HorizontalAlign="Left" 
                                AutoGenerateColumns="false" AllowSorting="true" OnSorting="SortStepGrid"
                                OnRowEditing="UpdateFromGrid" BorderStyle="NotSet">
                                <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <Columns>
                                    <asp:CommandField ShowEditButton="True" EditText="UPLOAD" />
                                    <asp:BoundField DataField="Ready For Review" HeaderText="Ready For Review"  SortExpression="Ready For Review"/>
                                    <asp:BoundField DataField="Date Modified"  HeaderText="Date Modified" SortExpression="Date Modified"/>
                                    </Columns>
                                </asp:GridView>
                                </asp:Panel>
                           </td>
                        </tr>
                        <tr class="BluBg">
                            <td class="Left5pxPadd">
                                <asp:ImageButton ID="HelpButton" runat="server" ImageUrl="../Common/Images/help.gif" />
                                 &nbsp; &nbsp;
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    </asp:Panel>
                    <asp:Panel ID="ValidationPanelTop" runat="server" Height="100" Width="100%" ScrollBars="auto"
                     EnableViewState="true" BorderColor="black" BorderStyle="Solid" BorderWidth="1">
                        <table width="100%">
                            <tr>
                                <td><b> Validation for Vendor File
                                    <asp:Label ID="FileProcessed" runat="server" Text=""></asp:Label></b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="BadLinesGridView" runat="server" AutoGenerateColumns="false" 
                                    BorderColor="Black" BorderStyle="Solid" Width="98%">
                                    <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                     <Columns>
                                    <asp:BoundField DataField="Line" HeaderText="Line" />
                                    <asp:BoundField DataField="Problem" HeaderText="Problem" />
                                    <asp:BoundField DataField="OriginalLine"  HeaderText="OriginalLine" />
                                     </Columns>
                                   </asp:GridView>
                                </td>
                            </tr>
                         </table>
                        </asp:Panel>
                        <asp:Panel ID="ValidationEditPanel" runat="server" Height="265px" Width="100%" Visible="false">
                        <table cellspacing="0">
                                <tr>
                                    <td>Vendor                                
                                    <asp:HiddenField ID="HiddenGERID" runat="server" />
                                    </td>
                                    <td>
                                    <asp:DropDownList ID="VendorUpd" runat="server" DataTextField="ShortCode" DataValueField="ShortCode">
                                    </asp:DropDownList>
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                        <tr>
                            <td>Item
                            </td>
                            <td>  
                                <asp:TextBox ID="ItemUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>PO
                            </td>
                            <td>
                                <asp:TextBox ID="POUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Port of Lading
                            </td>
                            <td>
                                <asp:TextBox ID="PortUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Qty
                            </td>
                            <td>
                                <asp:TextBox ID="QtyUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Weight
                            </td>
                            <td>
                                <asp:TextBox ID="WeightUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="WeightValidator" runat="server" ErrorMessage="Weight is required" ControlToValidate="WeightUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Pallets
                            </td>
                            <td>
                                <asp:TextBox ID="PalletsUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="PalletsValidator" runat="server" ErrorMessage="Pallets is required (Zero [0] is OK)." ControlToValidate="PalletsUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>Code
                            </td>
                            <td>
                                <asp:TextBox ID="CodeUpd" runat="server" ReadOnly="true"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Location
                            </td>
                            <td>
                                <asp:DropDownList ID="LocUpd" runat="server"  DataSourceID="LocationDDLData" DataTextField="LocName"
                                 DataValueField="LocID">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>Mfg Plant
                            </td>
                            <td>
                                <asp:TextBox ID="MfgPlantUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr class="PageBg">
                            <td style="padding-left: 5px"> 
                            <asp:ImageButton ID="SaveButt" runat="server" ImageUrl="common/Images/accept.jpg"  OnClick="SaveButt_Click"/>
                            <asp:ImageButton ID="DoneButt" runat="server" ImageUrl="../Common/Images/done.gif" CausesValidation="False" OnClick="DoneButt_Click"/>
                           </td>
                            <td colspan="2"  style="padding-left: 5px">
                            
                                 <asp:Label ID="EditErrorLabel" runat="server" ForeColor="Red"></asp:Label>
                                <asp:Label ID="EditSuccessLabel" runat="server" ForeColor="ForestGreen"></asp:Label>
                           </td>
                        </tr>
                        </table>
                        </asp:Panel>
                        <asp:Panel ID="ValidationPanelBottom" runat="server" Height="450" Width="100%"  ScrollBars="auto"
                            BorderColor="black" BorderStyle="Solid" BorderWidth="1">
                        <table>
                           <tr>
                                <td>
                                    <asp:GridView ID="ValidationGridView" runat="server" AutoGenerateColumns="False" 
                                    DataSourceID="GERRTSSqlData" AllowSorting="True"  DataKeyNames="pGERRTSID"  
                                    OnRowDataBound="ValidationGridRowBound"  OnRowDeleted="GridDeletedHandler"
                                     OnSelectedIndexChanging="GridEditHandler" Width="900px"
                                     >
                                    <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                        <Columns>
                                            <asp:CommandField SelectText="Edit" ShowSelectButton="True" />
                                            <asp:CommandField ShowDeleteButton="True" />
                                            <asp:BoundField DataField="StatusCd" HeaderText="Status" ReadOnly="True" SortExpression="StatusCd">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="QtyRemaining" HeaderText="Line" SortExpression="QtyRemaining" ReadOnly="True">
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="VendNo" HeaderText="Vendor" SortExpression="VendNo" ReadOnly="True" 
                                             ItemStyle-HorizontalAlign="Center"/>
                                            <asp:BoundField DataField="PONo" HeaderText="PO #" SortExpression="PONo"  ReadOnly="True"
                                             ItemStyle-Width="100px" />
                                            <asp:BoundField DataField="ItemNo" HeaderText="Item #" SortExpression="ItemNo"  ReadOnly="True"
                                             ItemStyle-Width="100px" />
                                            <asp:BoundField DataField="PalletCnt" HeaderText="Pallets" SortExpression="PalletCnt" 
                                             DataFormatString="{0:G}" ReadOnly="True" ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Right" />
                                            <asp:BoundField DataField="Qty" HeaderText="Qty" SortExpression="Qty"  ReadOnly="True" DataFormatString="{0:N0}"
                                              ItemStyle-Width="60px" ItemStyle-HorizontalAlign="Right" />
                                            <asp:BoundField DataField="GrossWght" HeaderText="Gross Weight" SortExpression="GrossWght"  ReadOnly="True" DataFormatString="{0:N1}">
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="GERRTSStatCd" HeaderText="Code" SortExpression="GERRTSStatCd" ReadOnly="True"
                                             ItemStyle-HorizontalAlign="center"/>
                                            <asp:BoundField DataField="PortofLading" HeaderText="Port of Lading" SortExpression="PortofLading"  ReadOnly="True"/>
                                            <asp:BoundField DataField="LocCd" HeaderText="Loc" SortExpression="LocCd" ReadOnly="True">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="MfgPlant" HeaderText="Mfg" SortExpression="MfgPlant" ReadOnly="True"
                                             ItemStyle-Width="70px" ItemStyle-HorizontalAlign="Center" />
                                           <asp:BoundField DataField="pGERRTSID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                                                SortExpression="pGERRTSID" />
                                        </Columns>
                                    </asp:GridView>                                
                                    </td>
                                <td>
                                </td>
                                <td>
                                </td>
                            </tr>
                        </table>
                        </asp:Panel>
                        <asp:Panel ID="ValidationButtonPanel" runat="server" Height="35" Width="100%"  ScrollBars="auto"
                            BorderColor="black" BorderStyle="Solid" BorderWidth="1">
                        <table width="100%" cellpadding="0" cellspacing="0">
                            <tr class="PageBg">
                                <td class="Left5pxPadd" width="200px">
                                <asp:ImageButton ID="ValidationAcceptButton" runat="server" ImageUrl="Common/Images/accept.jpg" 
                                OnClick="ValidationAcceptButton_Click" />
                                <asp:ImageButton ID="ValidationDoneButton" runat="server" ImageUrl="../Common/Images/done.gif" 
                                CausesValidation="False" OnClick="ValidationDoneButt_Click"/>
                                </td>
                                <td class="Left5pxPadd" width="100px">
                                <asp:ImageButton ID="ValidationAddButton" runat="server" ImageUrl="../Common/Images/newadd.gif" 
                                OnClick="ValidationAddButton_Click" />
                                </td>
                                <td class="Left5pxPadd"> Record Filter 
                                    <asp:RadioButton ID="OrigRadioButton1" runat="server"  GroupName="OriginalFilter" Text="All" 
                                    OnCheckedChanged="OrigSet" AutoPostBack="true"/>
                                    <asp:RadioButton ID="OrigRadioButton2" runat="server"  GroupName="OriginalFilter"  Text="Good"
                                    OnCheckedChanged="OrigSet" AutoPostBack="true"/>
                                    <asp:RadioButton ID="OrigRadioButton3" runat="server"  GroupName="OriginalFilter"  Text="Warn"
                                    OnCheckedChanged="OrigSet" AutoPostBack="true"/>
                                    <asp:RadioButton ID="OrigRadioButton4" runat="server"  GroupName="OriginalFilter"  Text="Bad"
                                    OnCheckedChanged="OrigSet" AutoPostBack="true"/>
                                </td>
                            </tr>
                         </table>
                    </asp:Panel>
              </td></tr>
                </table>
        </div>
    </form>
</body>
</html>
