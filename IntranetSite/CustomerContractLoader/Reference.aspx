<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reference.aspx.cs" Inherits="Reference" EnableEventValidation="false" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc4" %>
<%@ Register Src="Common/UserControls/ItemControl.ascx" TagName="ItemControl" TagPrefix="uc2" %>
<%@ Register Src="Common/UserControls/ItemFamily.ascx" TagName="ItemFamily" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Customer Contract Loader</title>
    <link href="Common/StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="Common/JavaScript/QuoteSystem.js"></script>
    <script type="text/javascript" src="Common/JavaScript/ItemBuilder.js"></script>
    <script type="text/javascript" src="Common/JavaScript/WidthAdjust.js"></script>
    <script src="~/MaintenanceApps/Common/Javascript/Common.js" type="text/javascript"></script>

    <script type="text/javascript">
    
    var offX = 5;
    var offY = 10;
    function ToolTip(Item,evt)
    {	   
	    document.getElementById("ToolTip").style.top = evt.clientY+offY;
	    document.getElementById("ToolTip").style.left = evt.clientX+offX;
	    if(evt.type == "mouseover")
	    {
		    document.getElementById("ToolTip").innerText = Item.alt;
		    document.getElementById("ToolTip").style.display = 'block';
	    }
	    if(evt.type == "mouseout")
	    {
		    document.getElementById("ToolTip").style.display = 'none';
	    }
    }
   
    function ConvertKeyPress(txtCustNo)
    {
        if (event.keyCode==40) 
        {
            event.keyCode=9; 
            return event.keyCode 
        }

        if(event.keyCode == 38) 
        {
            var r = txtCustNo.match(/[\d\.]+/g);            
            var currentControlID = r[0];            
            var newControlID = parseInt(r[0],10) - 1;           
                      
            if(newControlID >0)
            {   
                var tempControlID = "";
                if(newControlID.toString().length ==1)
                    tempControlID = '0' + newControlID.toString();
                    
                previousTxtID = txtCustNo.replace(currentControlID,tempControlID)
                
                // If the previous control is label then find the next textbox
                if(document.getElementById(previousTxtID) == null)
                {
                    for(var i = newControlID; i>0; i--)
                    {
                        tempControlID = i;
                        if(i.toString().length == 1)
                            tempControlID ='0' + tempControlID; 
                        
                        previousTxtID = txtCustNo.replace(currentControlID,tempControlID)
                        if(document.getElementById(previousTxtID))
                        {
                            break;
                        }
                    }
                }
                
                if(document.getElementById(previousTxtID))
                    document.getElementById(previousTxtID).focus();                                
            }     
        }            
    }
    
//     function zItem(itemNo)
//        {
//            document.getElementById("hidAltSellStkUMQty").value = "1";
//            itemNo = document.getElementById("Item").value;
//            
//            document.getElementById("txtAltSellPrice").innerText = "";
//        }
    
    </script>

    <script language='JavaScript' type="text/javascript">
    function SubmitForm()
	{	
	        var filepath=document.getElementById('uplXRefFile').value;	        
	        var SPOS=filepath.lastIndexOf(".")	
            var ln=filepath.length;	
	        var ftype=filepath.substring(SPOS+1,ln)
	        var fileType;

	        if(document.form1.rdo[0].checked==true) fileType='xls';
	        if(document.form1.rdo[1].checked==true) fileType='txt';
       // alert(fileType);
	        if(ftype == fileType )
	        { 
	            if(Reference.IsFileExist(filepath).value =="true")
	                return true;
	            else 
	                alert("Invalid file path");
	        }            
	        else
	        {	     
	        alert ("Please select ."+fileType+" file");	      
	        return false;
	        }
	}
    </script>

    <script language='JavaScript' type="text/javascript">
    
    function CheckAll( checkAllBox )  
    {
        var frm = document.form1; 
        var ChkState=checkAllBox.checked;   
        for(i=0;i< frm.length;i++)   
        {                        
             e=frm.elements[i];    
             if(e.type=='checkbox' && e.name.indexOf('Id') != -1)
             e.checked= ChkState ; 
        }
    }

    function CheckChanged() 
    {
        var frm = document.form1;
        var boolAllChecked;
        boolAllChecked=true; 
        for(i=0;i< frm.length;i++)
        { 
            e=frm.elements[i];
            if ( e.type=='checkbox' && e.name.indexOf('Id') != -1 )
            if(e.checked== false)
            { 
                boolAllChecked=false;
                break; 
            } 
        }
        for(i=0;i< frm.length;i++)
        {
            e=frm.elements[i];
            if ( e.type=='checkbox' && e.name.indexOf('checkAll') != -1 )
            {
                if( boolAllChecked==false)
                    e.checked= false ;
                else
                    e.checked= true;
                break;
            }
        }
    }
    
    function ClearMessages()
    {
//        if(document.getElementById("lblFileMessage") != null)
//        {
//            document.getElementById("lblFileMessage").innerText = "";
//        }
//        if(document.getElementById("lblErrorMsg") != null)
//        {
//            document.getElementById("lblErrorMsg").innerText = "";
//        }

        if(document.getElementById("lblStatus") != null)
            document.getElementById("lblStatus").innerText = "";
    }
    </script>

</head>
<body bgcolor="#ECF9FB" onclick="ClearMessages()">
    <form id="form1" defaultbutton="btnVerify" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering="true">
        </asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table1">
            <tr>
                <td>
                    <uc4:Header ID="Header1" runat="server" />
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="table2">
                        <tr valign="top">
                            <td style="width: 100%">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td id="5TD" style="height: 92px" width="100%">
                                            <table class="BorderAll" width="100%" border="0" cellpadding="0" cellspacing="0"
                                                style="padding: 2px;">
                                                <tr>
                                                    <td style="border-right: 1px solid #7ecfe7;" height="528px" width="20%" valign="top"
                                                        align="left" id="TDFamily">
                                                        <table>
                                                            <tr>
                                                                <td style="width: 262px">
                                                                    <table class="BorderAll" id="LeftMenu" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td style="padding-top: 5px; border-bottom: 1px solid #7ecfe7; height: 20px;" bgcolor="#B8E3F3"
                                                                                width="200">
                                                                                <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="Contract Information"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:210px; height: 14px;">
                                                                                            Contract:</td>
                                                                                        <td style="height: 14px">                                                                                          
                                                                                            <asp:Label ID="lblCustomerName" runat="server" Font-Bold="True" Width="125px">Contract:</asp:Label>
                                                                                            
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>  
                                                                         <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:210px;">
                                                                                            # of Items on Contract:</td>
                                                                                        <td>                                                                                          
                                                                                            <asp:Label ID="lblnoItemsOnContract" runat="server" Font-Bold="True" Width="125px">Contract:</asp:Label>
                                                                                            
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>                                                                          
                                                                       <%-- <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:210px;">
                                                                                            Contract GM%:</td>
                                                                                        <td>                                                                                          
                                                                                            <asp:Label ID="Label6" runat="server" Font-Bold="True" Width="125px">0</asp:Label>
                                                                                            
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr> 
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:210px;">
                                                                                            Contract Avg Lbs:</td>
                                                                                        <td>                                                                                          
                                                                                            <asp:Label ID="lblCity" runat="server" Font-Bold="True" Width="125px">0</asp:Label>
                                                                                            
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>   
                                                                         <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:210px; height: 14px;">
                                                                                            Orders On Contract:</td>
                                                                                        <td style="height: 14px">                                                                                          
                                                                                            <asp:Label ID="lblState" runat="server" Font-Bold="True" Width="125px">0</asp:Label>
                                                                                            
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>  --%> 
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:200px; height: 14px;">
                                                                                            Contract Threshold:</td>
                                                                                        <td style="height: 14px">                                                                                          
                                                                                            <asp:Label ID="Label7" runat="server" Font-Bold="True" Width="125px">0</asp:Label>
                                                                                            
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>   
                                                                        <%--<tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:210px;">
                                                                                            Below Cost Lbs:</td>
                                                                                        <td>                                                                                          
                                                                                            <asp:Label ID="lblPostCd" runat="server" Font-Bold="True" Width="125px">0</asp:Label>
                                                                                            
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr> --%> 
                                                                      <%--  <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:200px;">
                                                                                            Show Below Cost Item(s):</td>
                                                                                        <td>&nbsp;<asp:CheckBox ID="CheckBox1" runat="server" Width="100px" /></td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>  --%> 
                                                                        <%--<tr>
                                                                            <td style="width:50px;">
                                                                            Contractt:</td>
                                                                        
                                                                            <td width="50px" style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblCustomerName" runat="server" Font-Bold="True" Width="140px">Contract:</asp:Label>
                                                                            </td>
                                                                        </tr>--%>
                                                                        <%--<tr>
                                                                            <td width="50px" style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblnoItemsOnContract" runat="server" Text="# of Items on Contract%" Font-Bold="True" Width="240px"></asp:Label>
                                                                            </td>
                                                                        </tr>--%>
                                                                       <%-- <tr>
                                                                            <td width="50px" style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="Label7" runat="server" Text="Contract GM%" Font-Bold="True" Width="240px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="50px" style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblCity" runat="server" Text="Contract Avg Lbs" Font-Bold="True" Width="240px"></asp:Label>
                                                                            </td>
                                                                        </tr>                                                                       
                                                                        <tr>
                                                                            <td width="50px" style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblPostCd" runat="server" Text="Orders On Contract" Font-Bold="True" Width="240px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="50px" style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="Label6" runat="server" Text="Contract Threshold" Font-Bold="True" Width="240px"></asp:Label>
                                                                            </td>
                                                                        </tr> 
                                                                        <tr>
                                                                            <td width="50px" style="padding-top: 5px;" class="gridHeader">
                                                                                <asp:Label ID="lblState" runat="server" Text="Below Cost Lbs" Font-Bold="True" Width="240px"></asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td width="100px" class="gridHeader">
                                                                               <asp:CheckBox ID="CheckBox2" runat="server" Text="Below Cost Items"  Font-Bold="True" AutoPostBack="True" TextAlign="Left" ToolTip="Show Below Cost Items"  />
                                                                            </td>
                                                                        </tr>    --%>                                                                   
                                                                    </table>
                                                                    </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 500px">
                                                                    <table class="BorderAll" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td style="padding-top: 5px; border-bottom: 1px solid #7ecfe7;" bgcolor="#B8E3F3">
                                                                                <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="Upload Proposed Contract File"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label5" runat="server" CssClass="FormControls" Text="Upload Method"
                                                                                    Font-Bold="True" Width="95px"></asp:Label>
                                                                                <asp:RadioButton ID="rdoRealTime" runat="server" AutoPostBack="true" CssClass="FormControls" Text="Realtime"
                                                                                    GroupName="rdo2" Font-Bold="True" Width="70px" Visible="False" />
                                                                                <asp:RadioButton ID="rdoBatch" runat="server" AutoPostBack="true" CssClass="FormControls" Text="Batch"
                                                                                    GroupName="rdo2" Font-Bold="True" Checked="True" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label ID="Label1" runat="server" CssClass="FormControls" Text="Source File Type"
                                                                                    Font-Bold="True" Width="95px"></asp:Label>
                                                                                <asp:RadioButton ID="rdoExcel" runat="server" AutoPostBack="true" Checked="true"
                                                                                    CssClass="FormControls" Text="Excel File" GroupName="rdo" Font-Bold="True" Width="70px" />
                                                                                <asp:RadioButton ID="rdoText" runat="server" AutoPostBack="true" CssClass="FormControls"
                                                                                    Text="Text File" GroupName="rdo" Font-Bold="True" Visible="False" />
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="width: 240px">
                                                                                <asp:FileUpload ID="uplXRefFile" CssClass="formCtrl" runat="server" Width="235px" /></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td style="width: 190px">
                                                                                <table>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:Button Width="75px" ID="btnVerify" CssClass="frmBtn" runat="server" Text="Verify"
                                                                                                OnClick="btnVerify_Click" />
                                                                                            <asp:Button Width="75px" ID="btnUpload" CssClass="frmBtn" runat="server" Text="Upload"
                                                                                                OnClick="btnUpload_Click" Visible="false" />&nbsp;&nbsp;&nbsp;
                                                                                            <asp:Button Width="75px" ID="btnClose" CssClass="frmBtn" runat="server" Text="Close"
                                                                                                OnClick="btnClose_Click" />
                                                                                            <asp:Button Width="75px" ID="btnCancel" CssClass="frmBtn" runat="server" Text="Cancel"
                                                                                                OnClick="btnCancel_Click" Visible="false" /></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="center" style="padding-top: 5px;">
                                                                                            <asp:Button Width="75px" ID="btnExport" CssClass="frmBtn" runat="server" Text="Excel Export"
                                                                                                OnClick="btnExport_Click" />&nbsp;&nbsp;&nbsp;
                                                                                            <asp:Button Width="75px" ID="btnHelp" CssClass="frmBtn" runat="server" Text="Help"
                                                                                                OnClick="btnHelp_Click" /></td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                       <%-- <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:95px;">
                                                                                            Prices are per Alt:</td>
                                                                                        <td>
                                                                                            <asp:CheckBox ID="chkPerAlt" runat="server" Checked="True" OnCheckedChanged="CheckBox2_CheckedChanged" />
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>  --%>
                                                                        <tr>
                                                                            <td style="padding-top: 5px;" class="gridHeader">
                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr>
                                                                                        <td style="width:95px;">
                                                                                            Price Method:</td>
                                                                                        <td>
                                                                                            <asp:DropDownList ID="ddlAliasType" runat="server" >
                                                                                                <asp:ListItem Value="P">P-Contract</asp:ListItem>
                                                                                                <%--<asp:ListItem Value="C">C-Contract</asp:ListItem>--%>
                                                                                            </asp:DropDownList>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>                                                                                                                        
                                                                    </table>
                                                                   <%-- <br />
                                                                    \\Pfcfiles\userdb\Application Help Desk\WorkOrders Out\PeteArreola\WO2713_CustomerContractLoader<br />--%>
                                                                </td>
                                                            </tr>
                                                            <tr style="height:333px;"><td>&nbsp;</td></tr>
                                                            <tr>
                                                                <td style="height:22px; padding-left:15px;" class="PagerBk leftpad">
                                                                    <asp:UpdatePanel ID="pnlStatus" UpdateMode="Always" runat="server">
                                                                        <ContentTemplate>
                                                                            <asp:Label Font-Bold="True" ForeColor="Green" ID="lblStatus" runat="server" />
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>                                                              
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td width="100%" valign="top" id="TDItem" runat="server">
                                                        <table width="100%" border="0" style="height:530px;" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td style="margin: 0px;" valign="top">
                                                                    <asp:UpdatePanel ID="ControlPanel" UpdateMode="Always" runat="server">
                                                                        <ContentTemplate>
                                                                            <div id="divFilterItem" runat="server" style="height: 640px; width: 100%;">
                                                                                <asp:DataGrid CssClass="grid" AutoGenerateColumns="False" GridLines="None"
                                                                                    AllowPaging="True" PageSize="23" Width="100%" ID="dgCrossReference"
                                                                                    runat="server">
                                                                                    <HeaderStyle CssClass="gridHeader" Height="20px" HorizontalAlign="Center" />
                                                                                    <ItemStyle CssClass="GridItem" Height="20px" />
                                                                                    <AlternatingItemStyle CssClass="zebra" Height="20px" />
                                                                                    <Columns>
                                                                                        <asp:TemplateColumn HeaderText="PFC Item #">
                                                                                            <ItemTemplate>
                                                                                                <asp:Label Width="100px" ID="lblItem" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"Item") %>'></asp:Label>
                                                                                            </ItemTemplate>
                                                                                            <ItemStyle Width="100px" />
                                                                                        </asp:TemplateColumn>                                                                                                      
                                                                                        
                                                                                        <asp:BoundColumn DataField="AltSellPrice" HeaderText="Proposed Contract Price per Alt">
                                                                                            <ItemStyle Width="90px" />
                                                                                        </asp:BoundColumn>
                                                                                                                                                                                                                                                                        
                                                                                      <%--    <asp:BoundColumn DataField="STKSellPrice" HeaderText="Current Contract Price per Unit">
                                                                                            <ItemStyle Width="90px" />
                                                                                        </asp:BoundColumn>--%>
                                                                                        
                                                                                     <%--   <asp:BoundColumn DataField="STKSellPrice" HeaderText="Proposed Contract Price per Unit">
                                                                                            <ItemStyle Width="90px" />
                                                                                        </asp:BoundColumn>--%>
                                                                                        
                                                                                         <%-- <asp:BoundColumn DataField="AltSellPrice" HeaderText="Current GM%">
                                                                                            <ItemStyle Width="65px" />
                                                                                        </asp:BoundColumn>
                                                                                        
                                                                                        <asp:BoundColumn DataField="AltSellPrice" HeaderText="Proposed GM%">
                                                                                            <ItemStyle Width="65px" />
                                                                                        </asp:BoundColumn>
                                                                                        
                                                                                        <asp:BoundColumn DataField="AltSellPrice" HeaderText="Avg Cont Price">
                                                                                            <ItemStyle Width="65px" />
                                                                                        </asp:BoundColumn>
                                                                                        
                                                                                        <asp:BoundColumn DataField="AltSellPrice" HeaderText="Avg Non Cont Price">
                                                                                            <ItemStyle Width="65px" />
                                                                                        </asp:BoundColumn>
                                                                                        
                                                                                        <asp:BoundColumn DataField="AltSellPrice" HeaderText="# of Custs">
                                                                                            <ItemStyle Width="65px" />
                                                                                        </asp:BoundColumn>
                                                                                        
                                                                                        <asp:BoundColumn DataField="AltSellPrice" HeaderText="Cust Usage lbs">
                                                                                            <ItemStyle Width="65px" />
                                                                                        </asp:BoundColumn>
                                                                                        
                                                                                        <asp:BoundColumn DataField="AltSellPrice" HeaderText="Corp Usage lbs">
                                                                                            <ItemStyle Width="65px" />
                                                                                        </asp:BoundColumn>
                                                                                        
                                                                                        <asp:BoundColumn DataField="AltSellPrice" HeaderText="Corp Avail lbs">
                                                                                            <ItemStyle Width="65px" />
                                                                                        </asp:BoundColumn>--%>

                                                                                        <asp:BoundColumn></asp:BoundColumn>
                                                                                    </Columns>
                                                                                    <PagerStyle Visible="False" />
                                                                                </asp:DataGrid>
                                                                                 <%--   *****  Hidden Fields  *****   --%>
                                                                                <asp:HiddenField ID="hidAltSellStkUMQty" runat="server" Value="1" />
                                                                            </div>
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="bottom" align="center" visible="false" id="tblPager" runat="server" class="PagerBk"
                                                                    style="width: 100%">
                                                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 225px;" runat="server" id="Table3">
                                                                        <tr>
                                                                            <td>
                                                                                <asp:ImageButton ID="lnkFirsPage" ImageUrl="~/ItemBuilder/Common/Images/btnlasto.jpg"
                                                                                    OnCommand="lnkFirstPage_Command" runat="server" />
                                                                            </td>
                                                                            <td style="padding-left: 5px;">
                                                                                <asp:ImageButton ID="lnlPreviousPage" ImageUrl="~/ItemBuilder/Common/Images/btnbacko.jpg"
                                                                                    OnCommand="lnkPreviousPage_Command" runat="server" />
                                                                            </td>
                                                                            <td style="padding-left: 5px;">
                                                                                <asp:Label ID="Label2" Text="Page" Font-Bold="true" runat="server" />
                                                                            </td>
                                                                            <td style="padding-left: 3px;">
                                                                                <asp:DropDownList Visible="true" ID="ddlFilterPage" CssClass="formCtrl" Width="60"
                                                                                    Height="20px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlFilterPage_SelectedIndexChanged">
                                                                                </asp:DropDownList>
                                                                            </td>
                                                                            <td style="padding-left: 5px;">
                                                                                <asp:ImageButton ID="lnkNextPage" ImageUrl="~/ItemBuilder/Common/Images/btnforwardo.jpg"
                                                                                    OnCommand="lnkNextPage_Command" runat="server" />
                                                                            </td>
                                                                            <td style="padding-left: 5px;">
                                                                                <asp:ImageButton ID="lnkLastPage" ImageUrl="~/ItemBuilder/Common/Images/btnfirsto.jpg"
                                                                                    OnCommand="lnkLastPage_Command" runat="server" />
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
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hidXRefSec" runat="server" />
        <asp:HiddenField ID="hidSubItemSec" runat="server" />
        <asp:HiddenField ID="hidAliasType" runat="server" />
    </form>
</body>
</html>
