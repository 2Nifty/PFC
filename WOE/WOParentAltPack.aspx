<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WOParentAltPack.aspx.cs" Inherits="WOParentAltPack" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/PrintDialogue.ascx" TagName="PrintDialogue" TagPrefix="uc4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Alt. Parent Pack</title>

    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .cnt {margin-left: 0px;}
    </style>

    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
    <script src="Common/Javascript/ContextMenu.js" type="text/javascript"></script>

    <script>
 /*       function ShowGridList(WorkSheetID,updField,listCtlID,gridCtlID)
        {
            //alert(WorkSheetID);
            document.getElementById("hidWorkSheetID").value = WorkSheetID;
            document.getElementById("hidUpdField").value = updField;
            document.getElementById("hidListControl").value = listCtlID;
            document.getElementById("hidCurControl").value = gridCtlID;

            var ddl
            ddl = document.getElementById('lstActionStatus');
            ddl.selectedIndex=-1;
            ddl = document.getElementById('lstPriorityCd');
            ddl.selectedIndex=-1;
            ddl = document.getElementById('lstWOBranch');
            ddl.selectedIndex=-1;

            HideToolTip();
            xstooltip_show(listCtlID, gridCtlID, 0, 0);
            return false;            
        }

        function GridListUpdate(updValue)
        {
            //alert(document.getElementById("hidWorkSheetID").value);
            //alert('New Value:' + updValue);
            //alert(document.getElementById("hidCurControl").value)
            //alert(document.getElementById("hidListControl").value)
            document.getElementById(document.getElementById("hidCurControl").value).innerHTML = updValue;
            document.getElementById(document.getElementById("hidListControl").value).style.display = 'none';
            WOWorkSheet.UpdateGridListValue(document.getElementById("hidWorkSheetID").value, document.getElementById("hidUpdField").value, updValue);
        }

        function ShowToolTip(event,strURL1,strURL2,strURL3,ctlID)
        {
            if(event.button==2)
            {
                URL1 = strURL1;
                URL2 = strURL2;
                URL3 = strURL3;
                xstooltip_show('divToolTip', ctlID, 0, 0);
                return false;
            }
        }

        function OpenURL1()
        {
            window.open(URL1,'CPR','height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (970/2))+',resizable=no',"");
            xstooltip_hide('divToolTip');
        }
          
        function OpenURL2()
        {
            window.open(URL2,'StockStatus','height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no');
            xstooltip_hide('divToolTip');
        }
        
        function OpenURL3()
        {
            window.open(URL3,'BOM','height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no');
            xstooltip_hide('divToolTip');
        }

//        function HideToolTip(ctlID)
//        {
//            if(ctlID=='imgDivClose')
//              xstooltip_hide('divToolTip');
//            else 
//            {
//                if(ctlID=='divToolTip')
//                    hid='true';
//                else 
//                    hid='';
//            }
//        }

        function HideToolTip()
        {
            if(document.getElementById('divToolTip')!=null)document.getElementById('divToolTip').style.display = 'none';
        }

        function HideLst()
        {
            if(document.getElementById('divActionStatusLst')!=null)document.getElementById('divActionStatusLst').style.display = 'none';
            if(document.getElementById('divPriorityCdLst')!=null)document.getElementById('divPriorityCdLst').style.display = 'none';
            if(document.getElementById('divWOBranchLst')!=null)document.getElementById('divWOBranchLst').style.display = 'none';
        }


        function SetCoord()
        {
            //alert('setcoord');
            document.getElementById('hidScroll').value = document.getElementById("divdatagrid").scrollLeft;
        }

        function ScrollIt()
        {
            //alert('scrollit' + document.getElementById("hidScroll").value);
            document.getElementById("divdatagrid").scrollLeft = document.getElementById("hidScroll").value;
        }


//        function NextCtl(ctlID)
//        {
//            if(event.keyCode == 9 || event.keyCode == 13)
//            {
//                alert(ctlID + '---' + event.keyCode);
//                document.getElementById(ctlID).focus();
//                WOWorkSheet.NextFocus().value;
//            }
//        }


        function ValidateDateChar()
        {
            if(event.keyCode != 47 && (event.keyCode<48 || event.keyCode>57))
                event.keyCode=0;
        }

        function CheckDt(ctlID)
        {
            if(event.keyCode == 9 || event.keyCode == 13)
            {
                if(ValidateDate(document.getElementById(ctlID).value,ctlID))
                {
                    event.keyCode = 13;
                }
                else
                {
                    event.keyCode = 13;
                    document.getElementById(ctlID).focus();
                    return false;
                }
            }
        }
*/
        function Close()
        {
            window.close();
        }

        function SetHeight()
        { 
            var yh = document.documentElement.clientHeight;  
            var xw = document.documentElement.clientWidth;  
            //take out room for bottom panel
            yh = yh - 100;
            // we resize differently according to quote recall or review quote
            if (document.getElementById("divdatagrid") != null)
            {
                var HeaderPanel = $get("divdatagrid");
                HeaderPanel.style.width = xw;  
                var DetailGridHeightHid = $get("hidDetailGridWidth");
                DetailGridHeightHid.value = xw;
            }
        }
    </script>
</head>

<body onresize="SetHeight();">
    <form id="form1" runat="server" >
        <asp:ScriptManager runat="server" ID="smWorkSheet"></asp:ScriptManager>
        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse:collapse;" id="tblMain">
            <tr>
                <td height="5%" id="tdHeaders">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg" style="border-top:solid 1px #88D2E9; padding-top:1px; border-bottom:solid 1px #88D2E9; padding-bottom:1px;" width="100%">
                    <span class="BanText" style="padding-left:5px; color:#CC0000">Alternate Parent Item Pack Opportunities</span>
                </td>
            </tr>
            <tr>
                <td style="padding-top:0px; padding-left:0px;" width="100%">
                    <asp:UpdatePanel ID="pnlFilter" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td style="padding-top:5px; padding-bottom:5px; border-bottom:solid 1px #88D2E9;">
                                        <table>
                                            <tr>
                                                <td style="width:75px" class="Left2pxPadd boldText">Action Status</td>
                                                <td class="Left2pxPadd Right2pxPadd">
                                                    <asp:DropDownList Width="175" ID="ddlActionStatus" Height="20px" TabIndex="1" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                                </td>
                                                <td style="width:43px" class="Left2pxPadd boldText">User ID</td>
                                                <td class="Left2pxPadd Right2pxPadd">
                                                    <asp:DropDownList Width="150" ID="ddlEntryID" Height="20px" TabIndex="1" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                                </td>
                                                <td style="width:60px" class="Left2pxPadd boldText" align="center">Category</td>
                                                <td style="width:60px" class="Left2pxPadd boldText" align="center">Size</td>
                                                <td style="width:60px" class="Left2pxPadd boldText" align="center">Variance</td>
                                            </tr>
                                            <tr>
                                                <td style="width:75px" class="Left2pxPadd boldText">Priority Code</td>
                                                <td class="Left2pxPadd Right2pxPadd">
                                                    <asp:DropDownList Width="175" ID="ddlPriorityCd" Height="20px" TabIndex="2" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                                </td>
                                                <td style="width:43px" class="Left2pxPadd boldText">Branch</td>
                                                <td class="Left2pxPadd Right2pxPadd">
                                                    <asp:DropDownList Width="150" ID="ddlBranch" Height="20px" TabIndex="3" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtCat" Width="50px" MaxLength="5" TabIndex="4" AutoPostBack="true"
                                                        OnFocus="javascript:this.select();" OnTextChanged="txtCat_TextChanged" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtSize" Width="40px" MaxLength="4" TabIndex="5" AutoPostBack="true"
                                                        OnFocus="javascript:this.select();" OnTextChanged="txtSize_TextChanged" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td class="Left2pxPadd Right2pxPadd" align="center">
                                                    <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtVar" Width="30px" MaxLength="3" TabIndex="6" AutoPostBack="true"
                                                        OnFocus="javascript:this.select();" OnTextChanged="txtVar_TextChanged" onkeydown="javascript:if(event.keyCode == 13) event.keyCode=9;"></asp:TextBox>
                                                </td>
                                                <td >
                                                    <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="Common/images/Submit.gif" TabIndex="7"
                                                        CausesValidation="false" OnClick="btnSubmit_Click" />&nbsp;&nbsp;
                                                </td>
                                                <td align="right" style="width: 33%">
                                                    <asp:ImageButton ID="btnCancel" runat="server" ImageUrl="Common/images/cancel.gif" TabIndex="9"
                                                        CausesValidation="false" OnClick="btnCancel_Click" />&nbsp;&nbsp;
                                                    <img id="btnClose" src="Common/images/close.gif" style="cursor:hand" onclick="javascript:Close();" alt="close" />
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
                <td height="473px" valign="top">
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td valign="top">
                                <asp:UpdatePanel ID="pnlWSGrid" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <div runat="server" id="divWSGrid" visible="true">
                                            <div id="divdatagrid" class="Sbar" align="left" runat="server" onscroll="SetCoord()"
                                                style="overflow:auto; width:1020px; position:relative; top:0px; left:0px; height:473px; border:0px solid; vertical-align:top; overflow-y:scroll;">
                                                    <asp:DataGrid ID="dgWorkSheet" Width="1135px" runat="server" BorderWidth="1px" BorderColor="#DAEEEF" CssClass="grid"
                                                        Style="height:auto;" UseAccessibleHeader="True" AutoGenerateColumns="False" AllowSorting="True" PagerStyle-Visible="false"
                                                        OnSortCommand="dgWorkSheet_SortCommand" AllowPaging="True" PageSize="17">
                                                            <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                            <ItemStyle CssClass="GridItem" />
                                                            <AlternatingItemStyle CssClass="zebra" />
                                                            <FooterStyle CssClass="lightBlueBg" HorizontalAlign="Right" />
                                                            <Columns>
                                                                <asp:BoundColumn HeaderText="Usage Velocity" DataField="UsageVelocityCd" SortExpression="UsageVelocityCd">
                                                                    <HeaderStyle Width="50px" />
                                                                    <ItemStyle Width="50px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                                <asp:BoundColumn HeaderText="Action Status" DataField="ActionStatus" SortExpression="ActionStatus">
                                                                    <HeaderStyle Width="100px" />
                                                                    <ItemStyle Width="100px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                                <asp:BoundColumn HeaderText="Priority Code" DataField="PriorityCd" SortExpression="PriorityCd">
                                                                    <HeaderStyle Width="60px" />
                                                                    <ItemStyle Width="60px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                                <asp:BoundColumn HeaderText="Finished Item No" DataField="FinishedItemNo" SortExpression="FinishedItemNo">
                                                                    <HeaderStyle Width="115px" />
                                                                    <ItemStyle Width="115px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                                <asp:BoundColumn HeaderText="Description" DataField="Description" SortExpression="Description">
                                                                    <HeaderStyle Width="350px" />
                                                                    <ItemStyle Width="350px" HorizontalAlign="Left" Wrap="False" />
                                                                </asp:BoundColumn>
                                                                    
                                                                <asp:BoundColumn HeaderText="Action Qty" DataField="ActionQty" SortExpression="ActionQty" DataFormatString="{0:N0}">
                                                                    <HeaderStyle Width="55px" />
                                                                    <ItemStyle Width="55px" HorizontalAlign="Right" Wrap="False" />
                                                                </asp:BoundColumn>
                                                                    
                                                                <asp:BoundColumn HeaderText="Parent Item No" DataField="ParentItemNo" SortExpression="ParentItemNo">
                                                                    <HeaderStyle Width="115px" />
                                                                    <ItemStyle Width="115px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                                <asp:BoundColumn HeaderText="Alt. Item No" DataField="AltItem" SortExpression="AltItem">
                                                                    <HeaderStyle Width="115px" />
                                                                    <ItemStyle Width="115px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                                <asp:BoundColumn HeaderText="Alt. Qty" DataField="AltItemQty" SortExpression="AltItemQty">
                                                                    <HeaderStyle Width="55px" />
                                                                    <ItemStyle Width="55px" HorizontalAlign="Right" Wrap="False" />
                                                                </asp:BoundColumn>
                                                                    
                                                                <asp:BoundColumn HeaderText="Branch" DataField="WOBranch" SortExpression="WOBranch">
                                                                    <HeaderStyle Width="50px" />
                                                                    <ItemStyle Width="50px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                                <asp:BoundColumn HeaderText="Due Date" DataField="WODueDt" SortExpression="WODueDt" DataFormatString="{0:MM/dd/yyyy}">
                                                                    <HeaderStyle Width="60px" />
                                                                    <ItemStyle Width="60px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                                <asp:BoundColumn HeaderText="Type" DataField="Type" SortExpression="Type">
                                                                    <HeaderStyle Width="50px" />
                                                                    <ItemStyle Width="50px" HorizontalAlign="Right" Wrap="False" />
                                                                </asp:BoundColumn>
                                                                    
                                                                <asp:BoundColumn HeaderText="Accept Action Date" DataField="AcceptActionDt" SortExpression="AcceptActionDt" DataFormatString="{0:MM/dd/yyyy}">
                                                                    <HeaderStyle Width="85px" />
                                                                    <ItemStyle Width="85px" HorizontalAlign="Center" Wrap="False" />
                                                                </asp:BoundColumn>

                                                            </Columns>
                                                        <PagerStyle Visible="False" />
                                                    </asp:DataGrid>
                                                <asp:HiddenField ID="hidDetailGridWidth" runat="server" />
                                                <asp:HiddenField ID="hidItemCtl" runat="server" />
                                                <asp:HiddenField ID="hidRowCount" runat="server" />
                                                <asp:HiddenField ID="hidPreviewURL" runat="server" />
                                                <input type="hidden" id="hidSort" runat="server" />
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="lightBlueBg buttonBar" height="20px">
                    <table>
                        <tr>
                            <td>
                                <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
                                    <ProgressTemplate>
                                        <span style="padding-left:5px; font-weight:bold;">Loading...</span>
                                    </ProgressTemplate>
                                </asp:UpdateProgress>
                            </td>
                            <td>
                                <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                    <ContentTemplate>
                                        <asp:Label ID="lblMessage" Style="padding-left:5px" ForeColor="red" Font-Bold="true"
                                            runat="server" Width="300px" Text=""></asp:Label>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                            <td style="padding-left:4px" align="right" width="64%">
                                <asp:UpdatePanel UpdateMode="conditional" runat="server" ID="pnlExport">
                                    <ContentTemplate>
                                        <uc4:PrintDialogue ID="PrintDialogue1" PageTitle="WorkOrderWorkSheet" PageSetup="L" EnableFax="true" EnableEmail="true" runat="server"></uc4:PrintDialogue>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="BluBg">
                    <asp:UpdatePanel ID="pnlPager" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <table width="100%" id="tPager" runat="server" style="height:32px;">
                                <tr>
                                    <td>
                                        <uc3:pager ID="Pager1" OnBubbleClick="PageChanged" runat="server" Visible="true" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:Footer ID="BottomFooterID" Title="Manufacturers Resource Planning WorkSheet" runat="server" />
                </td>
            </tr>
        </table>

        <asp:HiddenField ID="hidSecurity" runat="server" />
        <asp:HiddenField ID="hidWorkSheetID" runat="server" Value="" />
        <asp:HiddenField ID="hidUpdField" runat="server" Value="" />
        <asp:HiddenField ID="hidListControl" runat="server" Value="" />
        <asp:HiddenField ID="hidCurControl" runat="server" Value="" />
        <input type="hidden" id="hidScroll" runat="server" value="0"/>
      
    </form>
</body>
</html>
