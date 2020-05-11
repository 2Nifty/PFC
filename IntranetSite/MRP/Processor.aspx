<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Processor.aspx.cs" Inherits="Processor" %>

<%----%>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="BottomFooter"
    TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script type="text/javascript">
    function SetHeight()
    { 
        var yh = document.documentElement.clientHeight;  
        var xw = document.documentElement.clientWidth;  
        //take out room for entry area, header and footer
        yh = yh - 158;
        // we resize the data grid
        if (document.getElementById("ResultPanel") != null)        
        {    
            var ResultPanel = $get("ResultPanel");
            ResultPanel.style.height = yh;  
            ResultPanel.style.width = xw - 5;  
            var ResultsGridHeightHid = $get("ResultsGridHeightHidden");
            ResultsGridHeightHid.value = yh - 85;
            var ResultsGridWidthHid = $get("ResultsGridWidthHidden");
            ResultsGridWidthHid.value = xw - 5;
        }
    }
    </script>

    <title>MRP Processor</title>
    <link href="../common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
</head>
<body onload="SetHeight();" onresize="SetHeight();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <uc1:header id="Header1" runat="server" /><%----%>
        <div>
            <asp:UpdatePanel ID="MainUpdatePanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="middle" class="PageHead">
                                <span class="Left5pxPadd">
                                    <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="MRP Processor"></asp:Label>
                                </span>
                            </td>
                        </tr>
                        <tr class="PageBg">
                            <td valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="left" valign="bottom">
                                            <table border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td class="Left5pxPadd" style="width: 50px;">
                                                        <asp:Label ID="TableFilterLabel" runat="server" Text="Process"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:DropDownList ID="ProcessDropDown" runat="server" DataTextField="ConfigName"
                                                            DataValueField="ConfigName">
                                                        </asp:DropDownList>
                                                        <input id="PrintHide" name="PrintHide" type="hidden" value="Print" />
                                                        <asp:HiddenField ID="PageFunc" runat="server" />
                                                        <asp:HiddenField ID="ProcessID" runat="server" />
                                                    </td>
                                                    <td align="right" style="width: 70px;">
                                                        <asp:ImageButton ID="RunButton" runat="server" ImageUrl="../common/Images/submit.gif"
                                                            CausesValidation="False" OnClick="RunButton_Click" />
                                                    </td>
                                                    <td class="PageBg" align="left">
                                                        <asp:Label ID="MessageLabel" runat="server"></asp:Label>&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="right">
                                            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="../common/Images/Close.gif"
                                                PostBackUrl="javascript:window.close();" CausesValidation="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" valign="bottom" colspan="2">
                                            <table border="0" cellspacing="0" cellpadding="0" style="width: 80%;">
                                                <tr>
                                                    <td>Include:
                                                        <asp:CheckBox ID="RTSBCheckBox" Text="RTSB" runat="server" />&nbsp;
                                                        <asp:CheckBox ID="OTWCheckBox" Text="OTW" runat="server" />&nbsp;&nbsp;&nbsp;
                                                    </td>
                                                    <td align="right">
                                                    Raw Material ROP Factor:
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="ChildROPTextBox" runat="server" Width="30px"></asp:TextBox>
                                                    </td>
                                                    <td align="right">
                                                        View Previous Results&nbsp;
                                                        <asp:HiddenField ID="HiddenID" runat="server" />
                                                    </td>
                                                    <td align="left">
                                                        <asp:DropDownList ID="PreviousDropDownList" runat="server" DataTextField="ProcessGlued"
                                                            DataValueField="ProcessID">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td align="right">
                                                        <asp:ImageButton ID="DisplayPreviosButt" runat="server" ImageUrl="../common/Images/ok.gif"
                                                            OnClick="DisplayPreviousButton_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">
                                <asp:UpdatePanel ID="RunStatUpdatePanel" runat="server" UpdateMode="Conditional">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="RunButton" />
                                        <asp:AsyncPostBackTrigger ControlID="MRPTimer" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <asp:Timer ID="MRPTimer" Interval="5000" runat="server" OnTick="MRPTimer_Tick" Enabled="false">
                                        </asp:Timer>
                                        <asp:Panel ID="RunStatPanel" runat="server" Height="400px" Width="100%" Visible="false">
                                            <asp:HiddenField ID="StatusCd" runat="server" />
                                            <asp:Label ID="ProcessLabel" runat="server" Text=""></asp:Label><br />
                                            <br />
                                            <asp:Label ID="ExecuteLabel" runat="server" Text=""></asp:Label><br />
                                            <br />
                                            <asp:Label ID="RunStatLabel" runat="server" Text=""></asp:Label><br />
                                            <br />
                                            <br />
                                            <asp:GridView ID="ExecuteGrid" runat="server" AutoGenerateColumns="false" Visible="false"
                                                CssClass="grid">
                                                <Columns>
                                                    <asp:BoundField DataField="Text1" HeaderText="Status" HeaderStyle-HorizontalAlign="Center"
                                                        ItemStyle-HorizontalAlign="left" ItemStyle-Width="300" ItemStyle-CssClass="Left5pxPadd" />
                                                    <asp:BoundField DataField="Text2" HeaderText="" SortExpression="VelocityCdDesc" ItemStyle-Width="200"
                                                        ItemStyle-HorizontalAlign="Left" ItemStyle-CssClass="Left5pxPadd" />
                                                    <asp:BoundField DataField="Text3" HeaderText="" ItemStyle-Width="200" ItemStyle-CssClass="Left5pxPadd"
                                                        ItemStyle-HorizontalAlign="Left" />
                                                </Columns>
                                            </asp:GridView>
                                        </asp:Panel>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                                <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                                    <ProgressTemplate>
                                        <b>Processing....... Please wait.</b><br />
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Panel ID="ResultPanel" runat="server" Height="600px" Width="100%" ScrollBars="Vertical"
                                    BorderWidth="0">
                                    <asp:UpdatePanel ID="ResultEditUpdatePanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <table class="BluBg" width="700px">
                                                <tr>
                                                    <td align="right">
                                                        Item
                                                    </td>
                                                    <td align="left">
                                                        <b>
                                                            <asp:Label ID="EditItemLabel" runat="server" Text=""></asp:Label></b>
                                                    </td>
                                                    <td align="right">
                                                        To Pack
                                                    </td>
                                                    <td align="left">
                                                        <asp:TextBox ID="EditToPackTextBox" runat="server" Width="60px" onfocus="this.select();"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="EditSaveButt" runat="server" ImageUrl="../common/Images/BtnSave.gif"
                                                            OnClick="EditSaveButt_Click" />
                                                        <asp:ImageButton ID="EditDoneButt" runat="server" ImageUrl="../common/Images/done.gif"
                                                            OnClick="EditDoneButt_Click" />
                                                        <asp:HiddenField ID="EditIDHidden" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <table cellspacing="0" cellpadding="2" border="0" width="98%">
                                        <tr>
                                            <td valign="top">
                                                <asp:HiddenField ID="ResultsGridHeightHidden" runat="server" />
                                                <asp:HiddenField ID="ResultsGridWidthHidden" runat="server" />
                                                <asp:HiddenField ID="DisableEdit" runat="server" />
                                                <asp:GridView ID="ResultsGrid" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                                                    AlternatingRowStyle-BackColor="#DCF3FB" OnSorting="SortResultsGrid" OnRowEditing="EditResultsGrid"
                                                    Width="800px" OnRowDataBound="ResultsGridView_RowDataBound">
                                                    <Columns>
                                                        <%--DataKeyNames="pADResultsID"
                                                    OnRowUpdating="Update_Command" DataSourceID="ResultsData"--%>
                                                        <asp:CommandField ShowEditButton="True" />
                                                        <asp:BoundField DataField="ItemNo" HeaderText="Item Number" ReadOnly="True" SortExpression="ItemNo"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100"
                                                            ItemStyle-Font-Bold="true" />
                                                        <asp:BoundField DataField="PackBranch" HeaderText="PB" ReadOnly="True" SortExpression="PackBranch"
                                                            HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="PackageVelocity" HeaderText="PVC" ItemStyle-HorizontalAlign="Center"
                                                            ReadOnly="True" SortExpression="PackageVelocity" />
                                                        <asp:BoundField DataField="NeedQty" HeaderText="Need" ReadOnly="True" SortExpression="NeedQty"
                                                            DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center"
                                                            ItemStyle-Width="40" />
                                                        <asp:BoundField DataField="QtyToPack" HeaderText="To Pack" SortExpression="QtyToPack"
                                                            ItemStyle-HorizontalAlign="right" ItemStyle-Font-Bold="true" DataFormatString="{0:N0}" />
                                                        <asp:BoundField DataField="PriorityCode" HeaderText="Priority" ItemStyle-HorizontalAlign="center"
                                                            ReadOnly="True" SortExpression="PriorityCode" />
                                                        <asp:BoundField DataField="ROPNeedFactor" HeaderText="Need Factor" ReadOnly="True"
                                                            SortExpression="ROPNeedFactor" ItemStyle-HorizontalAlign="Right" DataFormatString="{0:N2}" />
                                                        <asp:BoundField DataField="NeedAvl" HeaderText="Item Avl" ReadOnly="True" SortExpression="NeedAvl"
                                                            ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:N0}" />
                                                        <asp:BoundField DataField="ParentItemNo" HeaderText="Parent Item" ReadOnly="True"
                                                            SortExpression="ParentItemNo" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"
                                                            ItemStyle-Width="100" ItemStyle-Font-Bold="true" />
                                                        <asp:BoundField DataField="ParentAvl" HeaderText="Par. Avl" ReadOnly="True" SortExpression="ParentAvl"
                                                            ItemStyle-HorizontalAlign="Right" DataFormatString="{0:N0}" />
                                                        <asp:BoundField DataField="ParentToPack" HeaderText="Par. Pack" ReadOnly="True" SortExpression="ParentToPack"
                                                            DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" />
                                                        <asp:BoundField DataField="ParentROPProtectionFactor" HeaderText="Par. Factor" ReadOnly="True"
                                                            SortExpression="ParentROPProtectionFactor" ItemStyle-HorizontalAlign="Right"
                                                            DataFormatString="{0:N2}" />
                                                        <asp:BoundField DataField="ChildROP" DataFormatString="{0:N1}" HeaderText="Child ROP"
                                                            ItemStyle-HorizontalAlign="Right" ReadOnly="True" SortExpression="ChildROP" />
                                                        <asp:BoundField DataField="StepID" HeaderText="Step" ItemStyle-HorizontalAlign="Right"
                                                            ReadOnly="True" SortExpression="StepID" />
                                                        <asp:BoundField DataField="pResultID" HeaderText="ID" ItemStyle-HorizontalAlign="center"
                                                            ReadOnly="True" SortExpression="pResultID" />
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                            <td valign="top" align="left" style="width: 120px;">
                                                <asp:UpdatePanel ID="ExcelUpdatePanel" runat="server">
                                                    <ContentTemplate>
                                                        <div class="BluBg">
                                                            <center>
                                                                <br />
                                                                Show Excel Page<br />
                                                                <asp:ImageButton ID="ExcelButt" runat="server" ImageUrl="../common/Images/ok.gif"
                                                                    OnClick="ExcelExportButton_Click" />
                                                            </center>
                                                            <hr />
                                                            <center>
                                                                <br />
                                                                Show Hungry<br />
                                                                and Exceptions<br />
                                                                <asp:ImageButton ID="ShowHungryButt" runat="server" ImageUrl="../common/Images/ok.gif"
                                                                    OnClick="ShowHungryButton_Click" />
                                                            </center>
                                                            <hr />
                                                            Statistics<br />
                                                            <asp:GridView runat="server" ID="StatGrid" AlternatingRowStyle-BackColor="#DCF3FB"
                                                                AutoGenerateColumns="False">
                                                                <Columns>
                                                                    <asp:BoundField DataField="StatType" HeaderText="Stat" ReadOnly="True" SortExpression="StatType"
                                                                        HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="left" ItemStyle-Width="55px" />
                                                                    <asp:BoundField DataField="StatCount" DataFormatString="{0:N0}" HeaderText="Items"
                                                                        ItemStyle-HorizontalAlign="Right" ItemStyle-Width="55px" ReadOnly="True" SortExpression="StatCount" />
                                                                </Columns>
                                                            </asp:GridView>
                                                            <hr />
                                                            Show<br />
                                                            <asp:LinkButton ID="FedLinkButton" runat="server" OnClick="FedLinkButton_Click">Fed Items</asp:LinkButton><br />
                                                            <asp:LinkButton ID="HungryLinkButton" runat="server" OnClick="HungryLinkButtonn_Click">Hungry Items</asp:LinkButton><br />
                                                            <asp:LinkButton ID="NoLinkLinkButton" runat="server" OnClick="NoLinkLinkButton_Click">NoLink Items</asp:LinkButton><br />
                                                            <asp:LinkButton ID="NoNeedLinkButton" runat="server" OnClick="NoNeedLinkButton_Click">NoNeed Items</asp:LinkButton><br />
                                                        </div>
                                                    </ContentTemplate>
                                                    <Triggers>
                                                        <asp:PostBackTrigger ControlID="ExcelButt" />
                                                    </Triggers>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <uc2:bottomfooter id="BottomFrame2" footertitle="MRP Processor" runat="server" /><%----%>
    </form>
</body>
</html>
