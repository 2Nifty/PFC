<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ValidateRequest="false"
    CodeFile="DataEntry.aspx.cs" Inherits="DataEntry" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="NewFooter" TagPrefix="uc3" %>
<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Goods En Route V1.0.0</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css">
    <link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet"   type="text/css" />
    <link href="../GER/Common/StyleSheet/FreezeGrid.css" rel="stylesheet" type="text/css" />
   
    <style>
    .PageBg 
    {
	    background-color: #B3E2F0;
	    padding: 1px;
    }    
    </style>

    <script language="javascript" src="Common/Javascript/ger.js"></script>

    <script language="javascript" src="Common/Javascript/ContextMenu.js"></script>
    

    <script language="javascript">
    <!--
    var strDeleteFlag=false;
    var deleteRowId='';
    var ctlID='';
    var tabFlag = false;
    function ValidateHeader(e, buttonid)
    {
        document.getElementById("lblSuccessMessage").innerText = "";
        document.getElementById("hidFlag").value="InvoiceNo";
        
        document.getElementById("txtInvNo").value =   document.getElementById("txtInvNo").value.toUpperCase();
        var bt = document.getElementById(buttonid);
        
        if (bt)
        { 
           if(navigator.appName.indexOf("Netscape")>(-1))
           { 
                if(validateBOLHeaderItems())
                {
                    var e = document.createEvent("MouseEvents");
                    e.initEvent("click", true, true);
                    bt.dispatchEvent(e);
                    return false; 
                }
                 else
                 {
                    document.getElementById("BOLHeader_ddlOrder").focus();
                    document.getElementById("lblErrorMessage").innerText = "BOL Header incomplete";
                    return false;
                 }
                   
             } 
            if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1))
            { 
               if(validateBOLHeaderItems())
                {
                    bt.click(); 
                    return false; 
                }
                 else
                 {
                    document.getElementById("BOLHeader_ddlOrder").focus()
                    document.getElementById("lblErrorMessage").innerText = "BOL Header incomplete";
                    return false;
                 }
                 
            } 
        }
    } 
    
    function clickButton(e, buttonid)
    {
        document.getElementById("hidFlag").value="InvoiceCost";
        if(window.event.keyCode!=13)
        {
            if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0;
        }
        else
        {
    
            var bt = document.getElementById(buttonid); 
            if (bt)
            { 
                if(navigator.appName.indexOf("Netscape")>(-1)){ 
                    if (e.keyCode == 13)
                    { 
                         if(validateBOLHeaderItems())
                        {
                            var e = document.createEvent("MouseEvents");
                            e.initEvent("click", true, true);
                            bt.dispatchEvent(e);
                            return false;  
                      
                        }
                         else
                         {
                            document.getElementById("txtInvCost").focus();
                            document.getElementById("lblErrorMessage").innerText = "BOL Header incomplete";
                            return false;
                         }
                    } 
                } 
                if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1)){ 
                      if (event.keyCode == 13)
                      { 
                            if(validateBOLHeaderItems())
                            {
                                bt.click(); 
                                return false; 
                            }
                             else
                             {
                                document.getElementById("BOLHeader_ddlOrder").focus()
                                document.getElementById("lblErrorMessage").innerText = "BOL Header incomplete";
                                return false;
                             }
                      } 
                } 
            } 
    }  
}  
function clickItemButton(e, buttonid)
{   
    document.getElementById("hidFlag").value="Item";
    if(document.getElementById("txtItem").value == "")
            return false;
      var bt = document.getElementById(buttonid); 
      if (bt)
      { 
            if(navigator.appName.indexOf("Netscape")>(-1))
            {
                 var evObj = document.createEvent('MouseEvents');
                 evObj.initEvent( 'click', true, true );
                 bt.dispatchEvent(evObj);
                 return false;                  
            }          

            if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1))
            {
                        bt.click(); 
                       return false; 
            } 
      } 
}

function ShowToolTip(e,ctlIDVal)
{
    var list=document.getElementById("hidList").value;
    if (list != null)
    {
       if(list !="Processed")
        {
            if(navigator.appName == 'Microsoft Internet Explorer' && event.button==2)
            {
                ctlID= ctlIDVal;
                //xstooltip_show('divToolTip',ctlID,289, 49);
                xstooltip_showTest('divToolTip', ctlID, e) 
                return false;
            }
            if ((navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox') && e.which==3)
            {
                ctlID= ctlIDVal;
                xstooltip_show('divToolTip',ctlID,289, 49);
                return false;
            }
         }
      }
} 

function delayTime(e)
{    
    if(navigator.appName == 'Microsoft Internet Explorer' && event.keyCode == 122)
            setTimeout(" SetEAUDivHeight()",300);
    if ((navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox') && e.which==122)
        setTimeout(" SetEAUDivHeight()",300);

}

function SetEAUDivHeight()
{   
//alert(document.getElementById('tdFooter').clientHeight);
//    var divHeight =  document.documentElement.clientHeight - ( document.getElementById('tdHeaderSection1').clientHeight + document.getElementById('tdHeaderSection2').clientHeight + document.getElementById('tdFooter').clientHeight+12);
//    document.getElementById("div-datagrid").style.height =divHeight+"px";
   
}

//
// control the grid height
//

function Changeheight(count,gridname)
{
     SetEAUDivHeight();
    if(count >= 15)
        document.getElementById(gridname).style.width="98%";
    else
         document.getElementById(gridname).style.width="100%";
}

function SetControlFocus()
{
    
    var Flag=document.getElementById("hidFlag").value;
    switch(Flag)
    {
        case "InvoiceCost":
            document.getElementById("txtItem").focus();
             document.getElementById("txtItem").select();
            break;
        case "Item":
            if(document.getElementById("lblErrorMessage").innerText!="")
            {
                document.getElementById("txtItem").focus();
                 document.getElementById("txtItem").select();
            }
            else
            {
               
                document.getElementById("txtInvQty").focus();
                 document.getElementById("txtInvQty").select();
            }
             break;
        case "Radio":             
          
            document.getElementById("txtInvQty").focus();
             document.getElementById("txtInvQty").select();
            break;
        case "List":
            document.getElementById("txtInvNo").focus();
             document.getElementById("txtInvNo").select();
            break;
        case "InvoiceNo":
            if(tabFlag = true && document.getElementById("txtDate").value != "")
            {                
                tabFlag = false;                
                document.getElementById("txtContainer").focus();                
                document.getElementById("txtContainer").select();  
            }
            else
            {           
                document.getElementById("txtDate").focus();
                 document.getElementById("txtDate").select(); 
            }            
            break;
        default:
            break;
    }
    document.getElementById("hidFlag").value="";
   
}

function ClearMessages()
{
        if(document.getElementById("lblSuccessMessage") != null)
        {
            document.getElementById("lblSuccessMessage").innerText = "";
        }
        if(document.getElementById("lblErrorMessage") != null)
        {
            document.getElementById("lblErrorMessage").innerText = "";
        }
}

function SetFlag(strFlag)
{
    document.getElementById("hidFlag").value=strFlag;
    return true;
}

function PrintGER()
{   
        var prtContent = "<html><head><link href=Common/StyleSheet/Styles.css rel=stylesheet type=text/css /></head><body>";
        var WinPrint = window.open('','','left=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');        
        prtContent = prtContent + document.getElementById("tdHeaderSection2").innerHTML ;
        prtContent = prtContent + document.getElementById("div-datagrid").innerHTML ;
        prtContent = prtContent + "</body></html>";        
        WinPrint.document.write(prtContent);
        WinPrint.document.close();
        WinPrint.focus();
        WinPrint.print();
        WinPrint.close();
        return false;
    
}

    function ConvertToUpper(ctlID)
    {
        document.getElementById(ctlID).value =   document.getElementById(ctlID).value.toUpperCase();
    }  
    
-->
    </script>

</head>
<body onkeypress="delayTime(event);" onfocus="javascript:SetControlFocus();" onclick="ClearMessages()">
    <form id="form1" runat="server" onclick="hideDiv();">
        <asp:ScriptManager ID="MyScript" EnablePartialRendering="true" runat="server">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <uc1:Header ID="BOLHeader" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top" width="100%">
                    <div id="div1-datagrid" style="vertical-align: top; position: relative; top: 0px;
                        left: 0px; height: 390px; width: 100%; border: 0px solid;">
                        <!-- Bill Entry Table  hidden -->
                       
                        <asp:UpdatePanel UpdateMode="Conditional" ID="plBillLoad" runat="server" RenderMode="inline">
                            <contenttemplate>
                             <div class="Sbar" id="div-datagrid" style="overflow-x:auto; overflow-y:auto; position:relative; top:0px;
                                    left: 0px; width: 100%; height: 390px; border: 0px solid;" >
                                <asp:DataGrid ID="dgBillLoad" Width="100%"  UseAccessibleHeader="true" AutoGenerateColumns="False" BorderColor="#DAEEEF"
                                    runat="server" BorderWidth="1px" AllowSorting="True" OnSortCommand="dgBillLoad_SortCommand" 
                                    OnItemDataBound="dgBillLoad_ItemDataBound" OnItemCommand="dgBillLoad_ItemCommand" CellPadding="0" BorderStyle=Solid>
                                    <HeaderStyle CssClass="GridHead" BackColor="#B6E6F4" BorderColor="#DAEEEF" />
                                    <ItemStyle CssClass="Left5pxPadd" BackColor="White" BorderColor="White" HorizontalAlign="Left" />
                                    <AlternatingItemStyle CssClass="Left5pxPadd" BackColor="#DCF3FB" BorderColor="#DAEEEF"
                                        HorizontalAlign="Left" />
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Invoice #" SortExpression="VendInvNo">
                                            <ItemTemplate>
                                                <asp:Label ID="lblInv" CssClass="cntnopadding" oncontextmenu="return false"
                                                    onmousedown="javascript:ShowToolTip(event,this.id)" Style="border: none; background-color: Transparent;
                                                    word-wrap: normal;" runat="server"><a style="color:Black;" id="Inv" onclick="bindCmdLine('<%# GetText(Container)%>')"><%#DataBinder.Eval(Container,"DataItem.VendInvNo")%></a></asp:Label>
                                                <asp:Button ID="btnInv" CausesValidation="false" runat="server" CssClass="Button"
                                                    CommandName="Delete" Text="Delete" Style="display: none;" />
                                                <asp:Label ID="lblInv1" CssClass="cntnopadding" runat="server" Visible="false" Text='<%#DataBinder.Eval(Container,"DataItem.VendInvNo")%>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle Width="60px" Wrap="False" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Date" SortExpression="VendInvDt">
                                            <ItemTemplate>
                                                <asp:Label ID="lblVendInvDt" Style="border: none; background-color: Transparent;
                                                    word-wrap: normal;" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.VendInvDt")%>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle Width="60px" Wrap="False" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Container #" SortExpression="ContainerNo">
                                            <ItemTemplate>
                                                <asp:Label ID="lblContainerNo" Style="border: none; background-color: Transparent;
                                                    word-wrap: normal;" runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.ContainerNo")%>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle Width="100px" Wrap="False" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="PO #" SortExpression="PFCPONo">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPFCPONo" Style="border: none; background-color: Transparent; word-wrap: normal;"
                                                    runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.PFCPONo")%>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle Width="60px" Wrap="False" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Item #" SortExpression="PFCItemNo">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPFCItemNo" Style="border: none; background-color: Transparent;" 
                                                     runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.PFCItemNo")%>' Width="130px" ></asp:Label>
                                                    <asp:HiddenField ID="hidPFCPOLineNo" runat="server" Value='<%#DataBinder.Eval(Container, "DataItem.PFCPOLineNo")%>'/>
                                            </ItemTemplate>
                                            <ItemStyle Width="130px" Wrap="False" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="PO Qty" SortExpression="POQty">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPOQty" Style="border: none; background-color: Transparent; word-wrap: normal;"
                                                    runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.POQty")%>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Right" Width="60px" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Invoice Qty" SortExpression="RcptQty">
                                            <ItemTemplate>
                                                <asp:TextBox Width="75" ID="txtInvQty" CssClass="cntnopadding" runat="server" Style="text-align: right;"
                                                    Text='<%#DataBinder.Eval(Container,"DataItem.RcptQty")%>' TabIndex="1" onkeydown='if (event.keyCode==13) {updateInvoiceQty(this.id,this.value);event.keyCode=9; return event.keyCode }'
                                                    onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"></asp:TextBox></ItemTemplate>
                                            <ItemStyle HorizontalAlign="Right" Width="80px" />
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="POCost_UOM" SortExpression="POCost_UOM" HeaderText="PO Cost/UOM">
                                            <ItemStyle Width="80px" HorizontalAlign="Right" />
                                        </asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="Invoice Cost" SortExpression="UOPOPerAlt">
                                            <ItemTemplate>
                                                <asp:TextBox Width="75" ID="txtInvCost" CssClass="cntnopadding" runat="server" Style="text-align: right;"
                                                    Text='<%#DataBinder.Eval(Container,"DataItem.UOPOPerAlt")%>' TabIndex="1" onkeydown='if (event.keyCode==13) {updateInvoiceCost(this.id,this.value);event.keyCode=9; return event.keyCode }'
                                                    onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"></asp:TextBox>
                                                <asp:HiddenField ID="hidBOL" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.BOLNo")%>' />
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Right" Width="80px" />
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="ExtLandAdder" SortExpression="ExtLandAdder" HeaderText="Landed Cost">
                                            <ItemStyle HorizontalAlign="Right" Width="80px" />
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="LandVsPOPct" SortExpression="LandVsPOPct" HeaderText="Land %">
                                            <ItemStyle HorizontalAlign="Right" Width="40px" />
                                        </asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="Ext Amt" SortExpression="UOMatlAmt">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUOMatlAmt" Style="border: none; background-color: Transparent; word-wrap: normal;"
                                                    runat="server" Text='<%#DataBinder.Eval(Container, "DataItem.UOMatlAmt", "{0,-10:##,##0.00}")%>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Right" Width="40px" />
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn>
                                            <ItemStyle HorizontalAlign="Right"  />
                                        </asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <asp:DataGrid ID="dgContainerCost" Width="100%" runat="server" GridLines="both" BorderWidth="1px"
                                    AutoGenerateColumns="false" BorderColor="#DAEEEF" OnItemDataBound="dgContainerCost_ItemDataBound">
                                    <HeaderStyle CssClass="GridHead" BackColor="#B6E6F4" BorderColor="#DAEEEF" />
                                    <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Container #" ItemStyle-Width="80px">
                                            <ItemTemplate>
                                                <asp:Label ID="lblContainer" runat="server" Width="75" CssClass="cntnopadding" Text='<%#DataBinder.Eval(Container,"DataItem.ContainerNo")%>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Purch.Ord" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtPurch" runat="server" Width="75" CssClass="cntnopadding" Style="text-align: right;"
                                                    Text='<%# FormatToDecimal(Container,"ContPOCost","2")%>' onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'
                                                    onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"></asp:TextBox></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Invoice" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtInvoice" runat="server" Width="75" CssClass="cntnopadding" Style="text-align: right;"
                                                    Text='<%# FormatToDecimal(Container,"ContInvCost","2")%>' onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'
                                                    onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"></asp:TextBox></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Total weight" ItemStyle-Width="50px">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtWeight" runat="server" Width="75" CssClass="cntnopadding" Style="text-align: right;"
                                                    Text='<%# FormatToDecimal(Container,"ContWeight","2")%>' onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'
                                                    onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"></asp:TextBox></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn>
                                            <HeaderTemplate>
                                                <asp:ImageButton ID="imgContBack" ImageUrl="~/Common/Images/back.jpg" runat="server"
                                                    OnClick="imgContBack_Click" /></HeaderTemplate>
                                            <HeaderStyle HorizontalAlign="Right" />
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <asp:DataGrid ID="dgCharges"  Width="100%" runat="server" GridLines="both" BorderWidth="1px"
                                    AutoGenerateColumns="false" BorderColor="#DAEEEF" OnItemDataBound="dgCharges_ItemDataBound">
                                    <HeaderStyle CssClass="GridHead" BackColor="#B6E6F4" BorderColor="#DAEEEF" />
                                    <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Charge Type" HeaderStyle-Width="100px" ItemStyle-Width="100px">
                                            <ItemTemplate>
                                                <input type="hidden" id="ChargesID" value='<%#DataBinder.Eval(Container,"DataItem.pGERChrgDtlID")%>'
                                                    runat="server" />
                                                <asp:Label ID="lblType" runat="server" CssClass="cntnopadding" Width="75" Text='<%#DataBinder.Eval(Container,"DataItem.ChargeType")%>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Line Amount" HeaderStyle-Width="80px" ItemStyle-Width="80px">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtLineAmt" runat="server" CssClass="cntnopadding" Style="text-align: right;"
                                                    Width="85" Text='<%# FormatToDecimal(Container,"UOAmt","2")%>' 
                                                    onkeydown=' if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'
                                                    onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0">
                                                    </asp:TextBox>
                                             </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Remarks" HeaderStyle-Width="200px" ItemStyle-Width="200px">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtRemark" runat="server" CssClass="cntnopadding" Width="200" Text='<%#DataBinder.Eval(Container,"DataItem.Remarks")%>'
                                                    onkeydown=' if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'
                                                    onblur="UpdateChargesRemarks(this.id,this.value);">
                                                    </asp:TextBox></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn>
                                            <HeaderTemplate>
                                                <asp:ImageButton ID="imgChrgBack" ImageUrl="~/Common/Images/back.jpg" runat="server"
                                                    OnClick="imgChrgBack_Click" /></HeaderTemplate>
                                            <HeaderStyle HorizontalAlign="Right" />
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <asp:DataGrid ID="dgItemLookUp"  AutoGenerateColumns="false" runat="server" GridLines="both"
                                    BorderWidth="1px" BorderColor="#DAEEEF" OnItemDataBound="dgItemLookUp_ItemDataBound">
                                    <HeaderStyle CssClass="GridHead" BackColor="#B6E6F4" BorderColor="#DAEEEF" />
                                    <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" />
                                    <AlternatingItemStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF" />
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Select">
                                            <ItemTemplate>
                                                <asp:RadioButton ID="rdoSelect" runat="server" AutoPostBack="true" OnCheckedChanged="rdoSelect_CheckedChanged" onclick="Javascript:SetFlag('Radio');">
                                                </asp:RadioButton></ItemTemplate>
                                            <ItemStyle Width="1%" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="PO #">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtPO" runat="server" Width="75" CssClass="cntnopadding" Text='<%#DataBinder.Eval(Container,"DataItem.Document No_")%>'></asp:TextBox></ItemTemplate>
                                            <ItemStyle Width="1%" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Line No">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtLineNo" runat="server" Width="75" CssClass="cntnopadding" Text='<%#DataBinder.Eval(Container,"DataItem.Line No_")%>'></asp:TextBox></ItemTemplate>
                                            <ItemStyle Width="1%" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Location">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtLocNo" runat="server" Width="50" CssClass="cntnopadding" Text='<%#DataBinder.Eval(Container,"DataItem.Location Code")%>'></asp:TextBox></ItemTemplate>
                                            <ItemStyle Width="1%" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Item No">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtItemNo" runat="server" Width="80" CssClass="cntnopadding" Text='<%#DataBinder.Eval(Container,"DataItem.No_")%>'></asp:TextBox></ItemTemplate>
                                            <ItemStyle Width="1%" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Qty Open">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtQty" runat="server" Width="75" CssClass="cntnopadding" Style="text-align: right;"
                                                    Text='<%#DataBinder.Eval(Container,"DataItem.Outstanding Quantity")%>' onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'
                                                    onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"></asp:TextBox></ItemTemplate>
                                            <ItemStyle Width="1%" />
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn>
                                            <ItemStyle Width="10%" />
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>                               
                                <asp:DataGrid ID="dgList" UseAccessibleHeader="true" AutoGenerateColumns="false" 
                                        runat="server" GridLines="both" BorderWidth="1px" BorderColor="#DAEEEF" OnItemCommand="dgList_ItemCommand"
                                        OnItemDataBound="dgList_ItemDataBound">
                                        <HeaderStyle CssClass="locked" BackColor="#B6E6F4" BorderColor="#DAEEEF" />
                                        <ItemStyle CssClass="GridItem" BackColor="White" BorderColor="White" Height="20px" />
                                        <AlternatingItemStyle CssClass="GridItem" BackColor="#DCF3FB" BorderColor="#DAEEEF"
                                            Height="20px" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="BOL Number">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblNo" runat="server" Width="150" CssClass="cntnopadding" Text='<%#DataBinder.Eval(Container,"DataItem.BOLNo")%>'></asp:Label>
                                                    <asp:HiddenField ID="hidID" runat="server" Value='<%#DataBinder.Eval(Container,"DataItem.pGERHdrID")%>' />
                                                </ItemTemplate>
                                                <ItemStyle Height="10px" Width="150px" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderText="Processed Date">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDate" runat="server" Width="75" CssClass="cntnopadding" Text='<%#DataBinder.Eval(Container,"DataItem.ProcDt")%>'></asp:Label></ItemTemplate>
                                                <ItemStyle Width="1%" />
                                                <HeaderStyle Wrap="False" Height="7%" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderText="Status">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="lnkStatus" runat="server" Width="75" CssClass="cntnopadding" OnClientClick="Javascript:SetFlag('List');" Text='<%#DataBinder.Eval(Container,"DataItem.StatusCd")%>' CommandName="List" /></ItemTemplate>
                                                <ItemStyle Width="1%" />
                                                <HeaderStyle Height="7%" />
                                            </asp:TemplateColumn>

                                            <asp:TemplateColumn HeaderText="Actions">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblNoAction" CssClass="cntnopadding" runat="server" Visible="false" Text="None" Font-Bold="true"></asp:Label>
                                                    <asp:LinkButton ID="lnkDelete" CssClass="cntnopadding" Font-Underline="true" ForeColor="#cc0000" CausesValidation="false"
                                                        Style="padding-left: 5px" OnClientClick="javascript:if(confirm('Are you sure you want to delete?')==true){document.getElementById('hidDelConf').value = 'true';} else {document.getElementById('hidDelConf').value = 'false';}"
                                                        CommandName="Delete" CommandArgument='<%#DataBinder.Eval(Container,"DataItem.BOLNo")%>'
                                                        runat="server" Text="Delete"></asp:LinkButton>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Width="1%" />
                                                <HeaderStyle Wrap="False" Height="7%" />
                                            </asp:TemplateColumn>

                                            <asp:TemplateColumn>
                                                <HeaderTemplate>
                                                    <asp:ImageButton ID="imgLstBack" ImageUrl="~/Common/Images/back.jpg" runat="server"
                                                        OnClick="imgLstBack_Click" /></HeaderTemplate>
                                                <HeaderStyle HorizontalAlign="Right" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                    </asp:DataGrid>
                                </div>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                <asp:HiddenField ID="hidList" Value="" runat="server" />
                                <asp:Button ID="btnList" runat="server" Style="display: none" OnClick="btnList_Click" />
                                <asp:Button ID="btnUpdate" runat="server" Style="display: none" OnClick="btnUpdate_Click" />
                                <asp:HiddenField ID="hidFlag" runat="server"/>
                                <asp:HiddenField ID="hidDelConf" runat="server" />
                            </contenttemplate>
                        </asp:UpdatePanel>
                        
                    </div>
                </td>
            </tr>
            <tr>
                <td id="tdBottom">
                    <asp:UpdatePanel UpdateMode="Conditional" ID="FamilyPanel" runat="server">
                        <contenttemplate>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="PageBg">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td class="splitBorder TabHead" align="center">
                                                                <asp:Label ID="Label2" runat="server" Width="92px">Invoice #</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center">
                                                                <asp:Label ID="Label1" runat="server" Width="28px">Date</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center">
                                                                <asp:Label ID="Label3" runat="server" Width="70px">Container #</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center">
                                                                <asp:Label ID="Label4" runat="server" Width="27px">PO #</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center">
                                                                <asp:Label ID="Label5" runat="server" Width="35px">Item #</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center" style="width: 15%;">
                                                                <asp:Label ID="Label6" runat="server" Width="52px">PO Line</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center" style="width: 10%;">
                                                                <asp:Label ID="Label7" runat="server" Width="52px">PO Qty</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center">
                                                                <asp:Label ID="Label8" runat="server" Width="39px">Inv Qty</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center" style="width: 15%;">
                                                                <asp:Label ID="Label9" runat="server" Width="52px">PO Cost</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center" style="width: 10%;">
                                                                <asp:Label ID="Label10" runat="server" Width="17px">UOM</asp:Label></td>
                                                            <td class="splitBorder TabHead" align="center">
                                                                <asp:Label ID="Label11" runat="server" Width="49px">Inv Cost</asp:Label></td>
                                                            <td style="width: 100%" class="splitBorder TabHead">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 60px" class="splitBorder TabHead">
                                                                <asp:TextBox CssClass="cntnopadding" Width="100px" ID="txtInvNo" runat="server" MaxLength="20" onblur="return ValidateHeader(event,'btnInvNo');" onkeydown=' if (event.keyCode==9) {tabFlag = true; if(document.getElementById("txtDate").value!=""){document.getElementById("txtDate").focus()}}'/>
                                                                <asp:Button ID="btnInvNo" Style="display: none;" runat="server" OnClick="btnInvNo_Click" />
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <asp:TextBox CssClass="cntnopadding" Width="60px" ID="txtDate" runat="server" MaxLength="10"
                                                                    onblur="javascript:ValidateDate(this.value,this.id);" /></td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <asp:TextBox CssClass="cntnopadding" Width="80px" ID="txtContainer" runat="server" onblur="ConvertToUpper('txtContainer')"
                                                                    MaxLength="20" /></td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <asp:TextBox CssClass="cntnopadding" Width="80px" ID="txtPO" runat="server" MaxLength="20" onblur="ConvertToUpper('txtPO')"/></td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <asp:TextBox CssClass="cntnopadding" Width="80px" ID="txtItem" runat="server" MaxLength="20"
                                                                    onkeydown='if (event.keyCode==8 && document.getElementById("txtItem").value=="") {document.getElementById("txtPO").select()}'
                                                                    onblur="return clickItemButton(event,'btnItem')" />
                                                                <asp:Button ID="btnItem" Style="display: none;"
                                                                        runat="server" OnClick="btnItem_Click" /></td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <div class="lblboxnopadding" style="width: 80px; padding-left: 5px">
                                                                    <asp:Label ID="lblLine" runat="server"></asp:Label></div>
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <div class="lblboxnopadding" style="width: 80px; padding-left: 5px">
                                                                    <asp:Label ID="lblQty" runat="server"></asp:Label></div>
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <asp:TextBox CssClass="cntnopadding" Width="80px" ID="txtInvQty" runat="server" MaxLength="20"
                                                                    onkeypress="if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0"
                                                                    onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }' onblur="javascript:this.value=addCommas(this.value);" />
                                                                 <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="Only numeric values allowed"
                                        ControlToValidate="txtInvQty"  ValidationExpression="[0-9,]+$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator>  
                                                                    </td>
                                                            <td style="width: 100px" class="splitBorder TabHead" align="left">
                                                                <div class="lblboxnopadding" style="width: 80px; padding-left: 5px">
                                                                    <asp:Label ID="lblPOCost" runat="server"></asp:Label></div>
                                                            </td>
                                                            <td style="width: 60px" class="splitBorder TabHead">
                                                                <div class="lblboxnopadding" style="width: 60px; padding-left: 5px">
                                                                    <asp:Label ID="lblUOM" runat="server"></asp:Label></div>
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <asp:TextBox CssClass="cntnopadding" Width="80px" ID="txtInvCost" runat="server"
                                                                    MaxLength="20" onkeypress="return clickButton(event,'btnInvCost');" onblur="javascript:roundNumber(this.value,2,this);this.value=addCommas(this.value);" />
                                                                    <asp:Button ID="btnInvCost" Style="display: none;" runat="server" OnClick="btnInvCost_Click" />
                                                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Only numeric values allowed"
                                                                            ControlToValidate="txtInvCost"  ValidationExpression="[0-9.,]+$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator> 
                                                                        </td>
                                                            <td style="width: 100%" class="splitBorder TabHead">
                                                                &nbsp;<asp:Button ID="btnMore" runat="server" Style="display: none;" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                           <td style="width: 100px" class="splitBorder TabHead">
                                                                &nbsp;<asp:HiddenField id="hidPFCLocNo" runat="server" Value=""/>
                                                                <asp:HiddenField id="hidPayTo" runat="server" Value=""/>
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                &nbsp;<asp:HiddenField id="hidBaseUOM" runat="server" Value=""/>
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                &nbsp;<asp:HiddenField id="hidPCSPerAlt" runat="server" Value=""/>
                                                            </td>
                                                            <td style="width: 100px" class="splitBorder TabHead">
                                                                <asp:HiddenField id="hidItemNetWght" runat="server" Value=""/>
                                                                 <div class="lblboxnopadding" style="width: 99%; padding-left: 5px">
                                                                 <asp:Label ID="lblPOLineLoc" runat="server"></asp:Label>
                                                                </div>
                                                           </td>
                                                            <td class="splitBorder TabHead" colspan="7">
                                                                <div class="lblboxnopadding" style="width: 99%; padding-left: 5px">
                                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                        <tr>
                                                                            <td align="left">
                                                                                <asp:Label ID="lblDesc" runat="server"></asp:Label></td>
                                                                            <td align="right" style="padding-right: 10px;">
                                                                                <asp:UpdateProgress ID="upPanel" runat="server">
                                                                                    <ProgressTemplate>
                                                                                        <span class="TabHead">Loading...</span></ProgressTemplate>
                                                                                </asp:UpdateProgress>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                            <td style="width: 100%" class="splitBorder TabHead">
                                                                &nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="PageBg">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td align="left" class="splitBorder TabHead">
                                                                <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                                                                <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label></td>
                                                            <td align="right" class="splitBorder TabHead" valign="bottom">
                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                         <td style="padding-left: 5px">
                                                                         <img style="cursor:hand;" src="common/Images/Print.gif" onclick="javascript:return PrintGER();" />
                                                                            </td>
                                                                       <td style="padding-left: 5px">
                                                                            <asp:ImageButton ID="btnRefresh" runat="server" ImageUrl="common/Images/refresh.jpg"
                                                                                OnClick="btnRefresh_Click" />
                                                                            <asp:HiddenField ID="HiddenPassedBOL" Value="" runat="server" /></td>
                                                                        <td style="padding-left: 5px">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                        <td style="padding-left: 5px">
                                                                            <asp:ImageButton ID="btnAccept" runat="server" ImageUrl="common/Images/accept.jpg"
                                                                                OnClick="btnAccept_Click" /></td>
                                                                        <td style="padding-left: 5px">
                                                                            <asp:ImageButton ID="btnCharges" runat="server" ImageUrl="common/Images/charges.jpg"
                                                                                OnClick="btnCharges_Click" /></td>
                                                                        <td style="padding-left: 5px">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                        <td style="padding-left: 5px">
                                                                            <asp:ImageButton ID="btnProcess" runat="server" ImageUrl="common/Images/process.jpg"
                                                                                OnClick="btnProcess_Click" /></td>
                                                                        <td style="padding-left: 5px">
                                                                            <asp:CheckBox ID="chkProcessNow" runat="server"></asp:CheckBox>Process Now</td> 
                                                                        <td style="padding-left: 5px">&nbsp;&nbsp;&nbsp;</td>
                                                                        <td style="padding-left: 5px">
                                                                           <img src="common/Images/close.jpg" style="cursor:hand" onclick="javascript: parent.window.close();">
                                                                           </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </contenttemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc3:NewFooter ID="Footer" runat="server" />
                </td>
            </tr>
        </table>
        <div id="divToolTip" class="MarkItUp_ContextMenu_MenuTable" style="display: none;position:absolute;
            word-break: keep-all;" onmouseup='return false;'>
            <table width="125" border="0" cellpadding="0" cellspacing="0" bordercolor="#000099"
                class="MarkItUp_ContextMenu_Outline">
                <tr>
                    <td class="bgtxtbox">
                        <table width="100%" border="0" cellspacing="0">
                            <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="RowDelete();"
                                onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class="MarkItUp_ContextMenu_MenuItem">
                                <td valign="middle" style="width: 10%">
                                    <img src="../SalesAnalysisReport/Images/icorowdelete.gif" /></td>
                                <td width="90%" valign="middle">
                                    <div id="divCAS" style="vertical-align: middle;" class="MarkItUp_ContextMenu_MenuItem"
                                        onclick="RowDelete();">
                                        Delete</div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>

<script>
setTimeout("SetEAUDivHeight()",300);
window.parent.document.getElementById("Progress").style.display='none';
</script>

</html>
