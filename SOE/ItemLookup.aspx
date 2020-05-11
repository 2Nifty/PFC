<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemLookup.aspx.cs" Inherits="ItemLookup" %>

<%@ Register Src="Common/UserControls/Footer.ascx" TagName="Footer" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Item Lookup</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <style>
    tr.popupHead td 
    {
        background:#DFF3F9;
        border-bottom:2px solid #B3E2F0;
        padding:5px;color:#cc0000 !important;
        font-size:18px;
    }
    </style>
</head>

<script>

// Define the ctrl id in varaiables
var strCtrlPrefix="dgItemLookup_ctl";
var strCtrlSuffix="_chkSelect";

function SelectItem(ctlID)
{
    var strItemNo=document.getElementById(ctlID).innerHTML;
     if(strItemNo=='')
                alert('Select item');
            else
            {
                if(window.opener.document.getElementById("UCItemLookup_hidResetFlag")!=null)
                    window.opener.document.getElementById("UCItemLookup_hidResetFlag").value="Reset";
                 
                window.opener.document.getElementById("txtINo1").value=strItemNo;
                window.opener.document.getElementById("btnItemNo").click();
                window.close();
           }
}

function WSSelectItem(ctlID)
{
    var strItemNo=document.getElementById(ctlID).innerHTML;
     if(strItemNo=='')
                alert('Select item');
            else
            {
                if(window.opener.document.getElementById("UCItemLookup_hidResetFlag")!=null)
                    window.opener.document.getElementById("UCItemLookup_hidResetFlag").value="Reset";
                 
                window.opener.document.getElementById("CustomerItemTextBox").value=strItemNo;
                window.opener.document.getElementById("ItemSubmit").click();
                window.close();
           }
}
function BindValue()
{
       var strItemNo = document.getElementById("hidItem").value;
 
            if(strItemNo=='')
                alert('Select item');
            else
            {
                if(window.opener.document.getElementById("UCItemLookup_hidResetFlag")!=null)
                    window.opener.document.getElementById("UCItemLookup_hidResetFlag").value="Reset";
                 
                window.opener.document.getElementById("txtINo1").value=strItemNo;
                window.opener.document.getElementById("txtINo1").focus();
                window.opener.document.getElementById("txtReqQty").focus();
                window.close();
           }
 
}

function SelectAll(chkState)
{
    
    var SelectAll=document.getElementById(strCtrlPrefix+"02"+"_chkSelectAll");
    SelectAll.parentElement.title=((chkState)?"Clear All":"Check All");
    
    for(var i=3;;i++)
    {
        // Get the form Control
        var checkCtrl=document.getElementById(strCtrlPrefix+((i.toString().length==1)?"0"+i:i)+strCtrlSuffix);
         
        // Check or uncheck the checkbox in the datagrid
        if(checkCtrl == null || checkCtrl == 'undefined') 
            break;
        else
        {
            var strItemNo=document.getElementById(checkCtrl.id.replace("chkSelect","lblItemNo")).innerHTML;
            checkCtrl.checked=chkState;
            ItemLookup.GetItemDetail(chkState,strItemNo);
        }
          
    }
}

function CheckDetail(chkState,ctlID)
{
    var strItemNo=document.getElementById(ctlID.replace("chkSelect","lblItemNo")).innerHTML;
    ItemLookup.GetItemDetail(chkState,strItemNo);
}

function CheckSelectAll(chkState,ctlID)
{
    
    var checkAll=chkState;
    
    var SelectAll=document.getElementById(strCtrlPrefix+"02"+"_chkSelectAll");
    
    for(var i=3;;i++)
    {
        // Get the form Control
        var checkCtrl=document.getElementById(strCtrlPrefix+((i.toString().length==1)?"0"+i:i)+strCtrlSuffix);
        
        // Check or uncheck the checkbox in the datagrid
        if(checkCtrl == null || checkCtrl == 'undefined') 
            break;
        else
        {
            if(checkCtrl.checked==chkState)
                checkAll=checkCtrl.checked;
            else
            {
                checkAll=false;
                break;
            }
        }
    }
    
    // Check the select all check box
    SelectAll.checked=checkAll;
}

function ToggleSelectAll()
{
    var checkAll=true;
    var SelectAll=document.getElementById(strCtrlPrefix+"02"+"_chkSelectAll");
   
    for(var i=3;;i++)
    {
        // Get the form Control
        var checkCtrl=document.getElementById(strCtrlPrefix+((i.toString().length==1)?"0"+i:i)+strCtrlSuffix);
        
        // Check or uncheck the checkbox in the datagrid
        if(checkCtrl == null || checkCtrl == 'undefined') 
            break;
        else
        {
            if(checkCtrl.checked!=checkAll)
            {
                checkAll=false;
                break;
            }
        }
    }
    if(SelectAll != null)
    {
        // Check the select all check box
        SelectAll.checked=checkAll;
        SelectAll.parentElement.title=((SelectAll.checked)?"Clear All":"Check All");
    }
}

function ToggleCheck(chkState)
{
    document.getElementById(strCtrlPrefix+"02"+"_chkSelectAll").checked=((chkState=='True')?true:false);
    SelectAll(document.getElementById(strCtrlPrefix+"02"+"_chkSelectAll").checked);
}
function ResetCtl()
{
     if(window.document.getElementById("hidValueCount") !=null && window.document.getElementById("hidValueCount").value!="true")
     {
            if(window.opener.document.getElementById("UCItemLookup_hidResetFlag")!=null)
                    window.opener.document.getElementById("UCItemLookup_hidResetFlag").value="Reset";
     }
 
    var btnBind=window.opener.document.getElementById("UCItemLookup_ibtnReset");
   if (typeof btnBind == 'object')
   {   
         btnBind.click();
         window.opener.document.getElementById("txtINo1").focus();
         window.close();
         return false; 
   } 
}
</script>

<body>
    <form id="form1" runat="server">
        <table width="645" border="0" cellpadding="0" cellspacing="" class="BorderAll">
            <tr>
                <td valign="top">
                    <table width="645" cellspacing="0" cellpadding="3">
                        <tr class="popupHead">
                            <td valign="middle">
                                Item Lookup</td>
                            <td class="topBg" align="right">
                                <%--<img src="./Common/images/ok.gif" alt="Click OK to accept selected items" id="imgOk"
                                    style="cursor: hand;" onclick="BindValue();">--%>
                                <img src="./Common/images/close.gif" alt="Click to Close Item Lookup" id="imgClose"
                                    style="cursor: hand;" onclick="javascript:window.close();">
                            </td>
                        </tr>
                       <%-- <tr class="PageBg">
                            <td class="GridHead" valign="middle" colspan="2">
                                <asp:Label Style="cursor: hand;" onclick="Javascript:ToggleCheck('True');" ID="lblCheckAll"
                                    runat="server" Font-Underline="True" ForeColor="Black" Text="Check All" ToolTip="Check All"></asp:Label>&nbsp;
                                <asp:Label Style="cursor: hand;" onclick="Javascript:ToggleCheck('False');" ID="lblClearAll"
                                    runat="server" Font-Underline="True" ForeColor="Black" Text="Clear All" ToolTip="Clear All"></asp:Label></td>
                        </tr>--%>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="center" valign="top">
                    <asp:Label ID="lblStatusFlag" Visible="false" runat="server" Text="No Records Found"
                        CssClass="Required"></asp:Label></td>
            </tr>
            <tr>
                <td width="100%" valign="top" align="Left">
                    <asp:DataGrid ID="dgItemLookup" AllowPaging="true" runat="server" AutoGenerateColumns="false"
                        PagerStyle-Visible="false" BorderWidth="1" AllowSorting="true" GridLines="both"
                        ShowFooter="false" OnSortCommand="dgItemLookup_SortCommand" OnItemDataBound="dgItemLookup_ItemDataBound">
                        <HeaderStyle HorizontalAlign="center" CssClass="GridHead" BackColor="#dff3f9" />
                        <FooterStyle HorizontalAlign="Right" CssClass="GridHead" />
                        <ItemStyle CssClass="item" Wrap="False" BackColor="#FFFFFF" />
                        <AlternatingItemStyle CssClass="itemShade" BackColor="#f4fbfd" />
                        <Columns>
                           <%-- <asp:TemplateColumn HeaderStyle-HorizontalAlign="center" ItemStyle-Width="70" HeaderText="Select"
                                HeaderStyle-CssClass="GridHead" ItemStyle-HorizontalAlign="center">
                               
                                <ItemTemplate>
                                   <%-- <asp:CheckBox ID="chkSelect" onclick="javascript:CheckDetail(this.checked,this.id);CheckSelectAll(this.checked,this.id);"
                                        runat="server" />
                                        <asp:RadioButton ID="rdoSelect" runat="server" AutoPostBack="True" OnCheckedChanged="SelectCheck" GroupName="sen"  />
                                    <asp:HiddenField ID="hidSelect" Value='<%#DataBinder.Eval(Container, "DataItem.Select") %>'
                                        runat="server" />
                                </ItemTemplate>
                            </asp:TemplateColumn>--%>
                            <asp:TemplateColumn ItemStyle-Width="100" HeaderText="Item #" SortExpression="ItemNo"
                                ItemStyle-HorizontalAlign="Left">
                                <ItemTemplate>
                                    <%--<asp:Label ID="lblItemNo" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ItemNo")%>'></asp:Label>--%>
                                    <asp:LinkButton ID ="lnkItem" runat="server"  Text='<%# DataBinder.Eval(Container, "DataItem.ItemNo").ToString().Trim()%>' />
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="290" HeaderText="Item Description" SortExpression="Description"
                                ItemStyle-HorizontalAlign="Left">
                                <ItemTemplate>
                                    <asp:Label ID="lbl2" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Description")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="70" HeaderText="Base UOM" SortExpression="BaseUOM">
                                <ItemTemplate>
                                    <asp:Label ID="lbl3" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.BaseUOM")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn ItemStyle-Width="80"  HeaderText="Piece Quantity" SortExpression="Quantity"
                                ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Label ID="lbl5" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Quantity")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderText="Weight" ItemStyle-Width="100" SortExpression="Weight"
                                ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Label ID="lbl6" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Weight")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                    </asp:DataGrid>
                     <asp:HiddenField ID="hidItem" runat="server" />
                </td>
            </tr>
            <tr>
                <td width="100%">
                    <table width="100%">
                        <tr>
                            <td class="PageBg">
                                <uc1:pager ID="gridPager" runat="server" OnBubbleClick="Pager_PageChanged"></uc1:pager>
                                <input id="hidSort" type="hidden" name="Hidden1" runat="server">
                                <input id="hidCtlName" type="hidden" value="" name="hidCtlName" runat="server" />
                                <input id="hidItemValue" type="hidden" value="" name="hidCtlName" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <%--<td>
           <uc2:Footer ID="Footer1" runat="server" />
        
       </td>--%>
            </tr>
            <input id="hidValueCount" type="hidden" runat="server" />
        </table>
    </form>
</body>
</html>

<script>ToggleSelectAll()</script>

