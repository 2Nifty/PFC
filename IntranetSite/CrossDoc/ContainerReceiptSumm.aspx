<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ContainerReceiptSumm.aspx.cs" Inherits="ContainerRcptSumm" %>
<%@ Register Src="../Common/UserControls/HeaderImage.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/FooterImage2.ascx" TagName="Footer2" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script type="text/javascript">
        var XDocReceiptWindow;
        function pageUnload() 
        {
            if (XDocReceiptWindow != null) {XDocReceiptWindow.close();XDocReceiptWindow=null;}
        }
        function ClosePage()
        {
            window.close();	
        }

        function ConfirmReceipt(LineCtl, LPN, Loc, XDocContainer, URLArg)
        {
            if (LineCtl.parentNode.tagName == "TD")
            {
                var LineParent = LineCtl.parentNode.parentNode;
            }
            else
            {
                var LineParent = LineCtl.parentNode.parentNode.parentNode;
            }
            if (LineParent.childNodes[4].innerText == 'Processed')
            {
                alert('Receipt Already Processed');
            }
            else
            {

                var Confirmed = confirm("Confirm Receipt of LPN " + LPN);
                if (Confirmed)
                {
                    var status = ContainerRcptSumm.UpdDate(LPN).value;
                    //alert(status);
                    LineParent.childNodes[4].innerText = 'Processed';
                    if (XDocContainer!="")
                    {
                        if (XDocReceiptWindow != null) {XDocReceiptWindow.close();XDocReceiptWindow=null;}
                        //alert(LineParent.childNodes[2].innerText);
                        var DetailURL = 'ContainerReceiptDetail.aspx?LPNumber=' + LPN + '&Loc=' + Loc;
                        XDocReceiptWindow=window.open(DetailURL,'WhseXDocReceiptWin','height=750,width=800,toolbar=0,scrollbars=0,status=1,resizable=YES','');  
                        SetHeight(); 
                    }  
                    else
                    {
                        var PageTitle = "Receiving Report for LPN=" + LPN;
                        var Url = "../PrintUtility/PrintUtility.aspx?pageURL="+ URLArg +"&CustomerNumber=&SoeNo="+PageTitle+"&Mode=Print&FormName=RBReceiveReport";   
                        window.open(Url,"PrintUtility" ,'height=320,width=650,scrollbars=yes,status=no,top='+((screen.height/2) - (320/2))+',left='+((screen.width/2) - (650/2))+',resizable=No',"");
                    }
                }
            }
            return false;  
        }

        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            // size the grid
            var DetailGridPanel = $get("DetailGridPanel");
            if (DetailGridPanel != null)
            {
                DetailGridPanel.style.height = yh - 200;  
                DetailGridPanel.style.width = xw - 5;  
            }
            var BottomPanel = $get("BottomPanel");
            if (BottomPanel != null)
            {
                //BottomPanel.style.height = yh - 200;  
                BottomPanel.style.width = xw - 5;  
            }
            var SelectorPanel = $get("SelectorUpdatePanel");
            if (SelectorPanel != null)
            {
                SelectorUpdatePanel.style.height = yh - 100;  
                SelectorUpdatePanel.style.width = xw;  
            }
        }
        function FixHeader()
        { 
            var header = $get("userInfo");
            if (header != null)
            {
                //alert(header.firstChild.firstChild.tagName);
                header.firstChild.firstChild.style.width = '60%';
            }
        }
    </script>

    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <title>Container Receipt Summary</title>
</head>
<body onload="SetHeight();FixHeader();" onresize="SetHeight();" >
    <asp:SqlDataSource ID="LocationCodes" runat="server" ConnectionString="<%$ ConnectionStrings:PFCERPConnectionString %>"  
        SelectCommand="select LocID as Code, LocID+' - '+LocName as Name from [LocMaster] with (NOLOCK) where ShipMethCd like @LocFilter order by LocID" >
        <SelectParameters>
        <asp:ControlParameter ControlID="LocFilter" Name="LocFilter" PropertyName="Value" DefaultValue="%" />
        </SelectParameters>
        </asp:SqlDataSource>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="LPNSummScriptManager" runat="server" EnablePartialRendering="true" />
    <div>
        <asp:UpdatePanel ID="MainUpdatePanel1" runat="server">
        <ContentTemplate>
        <table width="100%" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td>
                    <uc1:Header id="Pageheader" runat="server">
                    </uc1:Header>
                <asp:HiddenField ID="LocFilter" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="PageHead" style="height: 40px" width="75%">
                    <div class="LeftPadding" >
                        <div align="left" class="BannerText">
                            Warehouse Container Receiving</div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="SelectorUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td rowspan="3" class="Left2pxPadd">
                            <div class="readtxt Left2pxPadd"><b>Beginning&nbsp;Date</b></div>
                                <asp:Calendar CssClass="Left2pxPadd" ID="BegDate" BorderWidth="1px" BorderStyle="Solid" BorderColor="Gray" runat="server"></asp:Calendar>
                            </td>
                            <td rowspan="3" class="10pxPadding">
                            <div class="readtxt Left2pxPadd"><b>Ending&nbsp;Date</b></div>
                                <asp:Calendar CssClass="Left2pxPadd" ID="EndDate" BorderWidth="1px" BorderStyle="Solid" BorderColor="Gray" runat="server"></asp:Calendar>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;<b>To Location</b>&nbsp;&nbsp;&nbsp;&nbsp; 
                            </td>
                            <td>
                                <asp:DropDownList ID="LocationDropDownList" runat="server" DataTextField="Name" DataValueField="Code"
                                DataSourceID="LocationCodes">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;&nbsp;&nbsp;<b>LPN</b>&nbsp;&nbsp;&nbsp;&nbsp; 
                            </td>
                            <td>
                                <asp:TextBox ID="LPNBeg" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;&nbsp;&nbsp;<b>BOL</b>&nbsp;&nbsp;&nbsp;&nbsp; 
                            </td>
                            <td>
                                <asp:TextBox ID="BOLBeg" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg" style="" colspan="2">
                                <div class="LeftPadding">
                                    <span class="LeftPadding" style="vertical-align: middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:ImageButton id="SearchSubmit" src="../Common/Images/submit.gif" style="cursor: hand" 
                                        runat="server" OnClick="SearchSubmit_Click" />&nbsp;&nbsp;
                                        <img src="../Common/images/close.gif" onclick="javascript:ClosePage();" style="cursor: hand" /></span></div>
                            </td>
                            <td class="BluBg" colspan="2">
                                <asp:UpdateProgress ID="SelectorUpdateProgress" runat="server">
                                <ProgressTemplate>
                                Searching .......
                                </ProgressTemplate>
                                </asp:UpdateProgress>
                          </td>
                        </tr>
                    </table>
                    </ContentTemplate></asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:UpdatePanel ID="SearchUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <table cellspacing="0" cellpadding="1" border="0" width="100%">
                        <tr>
                            <td style="width: 135px; padding-left: 10px;"><b>LPN</b>
                            </td>
                            <td style="width: 115px; padding-left: 10px;">&nbsp;
                            </td>
                            <td style="width: 115px; padding-left: 10px;"><b>Rcpt. Loc.</b> 
                            </td>
                            <td style="width: 105px; padding-left: 10px;"><b>LPN Date</b>
                            </td>
                            <td style="width: 105px; padding-left: 10px;"><b>Status</b>
                            </td>
                            <td rowspan="2" valign="middle" align="right">
                            <asp:ImageButton id="FindSubmit" name="FindSubmit" OnClick="FindSubmit_Click" AlternateText="Show Unprocessed LPNs"
                                    runat="server" ImageUrl="../Common/Images/ShowButton.gif" CausesValidation="false" />
                            <asp:ImageButton id="RefreshSubmit" ImageUrl="../Common/Images/submit.gif" style="display: none" 
                            runat="server" OnClick="RefreshSubmit_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:TextBox ID="txtContainer" runat="server" Width="125px"></asp:TextBox>
                            </td>
                            <td align="center">
                                &nbsp;
                            </td>
                            <td align="center"> 
                                <asp:TextBox ID="txtToLoc" runat="server" Width="105px"></asp:TextBox>
                            </td>
                            <td align="center">
                                <asp:TextBox ID="txtLPNDate" runat="server" Width="95px"></asp:TextBox>
                            </td>
                            <td align="center">
                                <asp:TextBox ID="txtStatus" runat="server" Width="95px"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    </ContentTemplate></asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Panel ID="DetailGridPanel" runat="server"  ScrollBars="both" Height="500px" Width="980px">
                        <asp:HiddenField ID="DetailGridHeightHidden" runat="server" />
                        <asp:HiddenField ID="DetailGridWidthHidden" runat="server" />
                        <asp:HiddenField ID="SortHidden" runat="server" />
                    <asp:UpdatePanel ID="DetailUpdatePanel" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <asp:GridView ID="XDocGridView" runat="server" HeaderStyle-CssClass="GridHead"  AutoGenerateColumns="false"
                    RowStyle-BackColor="#FFFFFF" RowStyle-CssClass="Left5pxPadd" AllowSorting="true" OnSorting="SortDetailGrid"
                    OnRowDataBound="DetailRowBound"
                    >
                    <AlternatingRowStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                    <Columns>
                        <asp:BoundField DataField="LPNNo" HeaderText="LPN" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="120px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="LPNNo" />
                         <asp:TemplateField ItemStyle-Width="120" HeaderText="Action" HeaderStyle-HorizontalAlign="Center"
                            ItemStyle-HorizontalAlign="center"  ItemStyle-CssClass="Left5pxPadd rightBorder"  SortExpression="ContainerNo">
                            <ItemTemplate>
                                <asp:LinkButton ID="ReceiptLink" runat="server" Text='' 
                                 CausesValidation="false" />
                                <asp:HiddenField ID="hidItemNo" runat="server" Value='<%# Eval("ContainerNo")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ToLocation" HeaderText="Rcpt. Loc." ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="110px" HeaderStyle-HorizontalAlign="Center"
                            SortExpression="ToLocation" />
                        <asp:BoundField DataField="DateCreate" HeaderText="LPN Date" ItemStyle-HorizontalAlign="center" 
                            DataFormatString="{0:MM/dd/yyyy}" ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="100px" 
                            SortExpression="DateCreate" HeaderStyle-HorizontalAlign="Center"/>
                        <asp:BoundField DataField="RcptStatus" HeaderText="Status" ItemStyle-HorizontalAlign="center" 
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-Width="100px" 
                            SortExpression="RcptStatus" HeaderStyle-HorizontalAlign="Center"/>
                        <asp:BoundField DataField="LockUser" HeaderStyle-HorizontalAlign="Center" HeaderText="Lock"
                            ItemStyle-CssClass="Left5pxPadd rightBorder" ItemStyle-HorizontalAlign="center"
                            ItemStyle-Width="70px" SortExpression="LockUser" />
                    </Columns>
                    </asp:GridView>
                    </ContentTemplate></asp:UpdatePanel>
                    </asp:Panel>
               </td>
            </tr>
            <tr>
                <td class="blueBorder" colspan="2" valign="top">
                    <%--Pager Panel--%>
                    <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table class="BluBg" id="Table1" height="1" cellspacing="0" cellpadding="0" width="100%"
                                border="0">
                                <tr>
                                    <td colspan="2" height="8px">
                                        <table id="Table2" cellspacing="0" height="1" cellpadding="0" width="100%" border="0">
                                            <tr>
                                                <td width="10%" height="8px">
                                                    <table id="Table3" cellspacing="0" cellpadding="2" width="40%" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:ImageButton ID="ibtnFirst" runat="server" ImageUrl="../Common/Images/PageFirst.jpg"
                                                                    OnClick="ibtnFirst_Click" /></td>
                                                            <td>
                                                                <asp:ImageButton ID="ibtnPrevious" runat="server" ImageUrl="../Common/Images/PagePrev.jpg"
                                                                    OnClick="ibtnPrevious_Click" /></td>
                                                            <td>
                                                                <div class="TabHead">
                                                                    <strong>&nbsp;&nbsp;&nbsp;GoTo</strong></div>
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlPages" runat="server" AutoPostBack="True" CssClass="PageCombo"
                                                                    Width="50px" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged">
                                                                </asp:DropDownList></td>
                                                            <td>
                                                                <asp:ImageButton ID="btnNext" runat="server" ImageUrl="../Common/Images/PageNext.jpg"
                                                                    OnClick="btnNext_Click" /></td>
                                                            <td>
                                                                <asp:ImageButton ID="btnLast" runat="server" ImageUrl="../Common/Images/PageLast.jpg"
                                                                    OnClick="btnLast_Click" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td align="center">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td width="40%" align="left">
                                                                <table id="Table6" cellspacing="0" cellpadding="0" border="0" height="1">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td align="center">
                                                                                <asp:Label ID="lblPage" runat="server" CssClass="TabHead">Page(s):</asp:Label></td>
                                                                            <td align="center" style="width: 9px" class="LeftPadding">
                                                                                <asp:Label ID="lblCurrentPage" runat="server" CssClass="TabHead">1</asp:Label></td>
                                                                            <td align="center" class="LeftPadding">
                                                                                <asp:Label ID="lblOf" runat="server" CssClass="TabHead">of</asp:Label></td>
                                                                            <td align="center" class="LeftPadding">
                                                                                <asp:Label ID="lblTotalPage" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                            <td width="60%" align="right">
                                                                <table id="TblPagerRecord" cellspacing="0" cellpadding="0" border="0" height="1">
                                                                    <tr>
                                                                        <td style="height: 17px">
                                                                            <asp:Label ID="lblRecords" runat="server" CssClass="TabHead">Record(s):</asp:Label></td>
                                                                        <td style="height: 17px" class="LeftPadding">
                                                                            <asp:Label ID="lblCurrentPageRecCount" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                        <td style="height: 17px" class="LeftPadding">
                                                                            <asp:Label ID="Label1" runat="server" CssClass="TabHead">-</asp:Label></td>
                                                                        <td style="height: 17px" class="LeftPadding">
                                                                            <asp:Label ID="lblCurrentTotalRec" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                        <td style="height: 17px" class="LeftPadding">
                                                                            <asp:Label ID="lblOf1" runat="server" CssClass="TabHead">of</asp:Label></td>
                                                                        <td style="height: 17px" class="LeftPadding">
                                                                            <asp:Label ID="lblTotalNoOfRec" runat="server" CssClass="TabHead">100</asp:Label></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td align="right" width="35%">
                                                    <table id="Table4" height="0%" cellspacing="0" cellpadding="2" border="0">
                                                        <tr>
                                                            <td align="right" class="Left2pxPadd">
                                                                <asp:Label ID="lblGotoPAge" runat="server" CssClass="TabHead">Go to Page # :</asp:Label></td>
                                                            <td class="Left2pxPadd">
                                                                <asp:TextBox ID="txtGotoPage" onkeypress="javascript:if(event.keyCode==13){if(this.value!=''){document.getElementById('btnGo').click();return false;}}"
                                                                    runat="server" CssClass="FormControls" Width="25px">0</asp:TextBox></td>
                                                            <td class="Left2pxPadd">
                                                                <asp:ImageButton ID="btnGo" runat="server" ImageUrl="~/Common/Images/Go.gif" OnClick="btnGo_Click" /></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <%--End Pager Panel--%>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <asp:Panel ID="BottomPanel" runat="server">
                    <table width="100%">
                        <tr>
                            <td align="left">&nbsp;&nbsp;&nbsp;
                            <asp:UpdatePanel ID="MessageUpdatePanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red"></asp:Label>&nbsp;
                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen"></asp:Label>
                            </ContentTemplate></asp:UpdatePanel>
                            </td>
                            <td>&nbsp;
                            </td>
                            <td align="right">
                                <asp:ImageButton ID="GridCloseButton" ImageUrl="../Common/Images/close.gif" runat="server" OnClick="GridClose_Click" /></td>
                        </tr>
                    </table>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer2 id="PageFooter2" runat="server">
                    </uc2:Footer2>
                </td>
            </tr>
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    </form>
</body>
</html>
