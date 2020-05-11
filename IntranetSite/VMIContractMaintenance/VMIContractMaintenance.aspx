<%@ Page Language="C#"  ValidateRequest="false" AutoEventWireup="true" CodeFile="VMIContractMaintenance.aspx.cs" MaintainScrollPositionOnPostback="true"   Inherits="VMIContractMaintenance" EnableEventValidation="false"%>
<%@ Register Src="../Common/UserControls/PhoneNumber.ascx" TagName="PhoneNumber" TagPrefix="uc3" %>
<%@ Register Src="../Common/UserControls/BottomFrame.ascx" TagName="BottomFrame" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/pager.ascx" TagName="pager" TagPrefix="uc1" %>
<%@ Register Src="../Common/UserControls/MessageDisplay.ascx" TagName="MessageDisplay" TagPrefix="uc5" %>
<%@ Register TagPrefix="uc2" TagName="ChainCode" Src="../Common/UserControls/VMIChain.ascx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<title>VMI Contract Maintenance</title>
<link href="../SalesAnalysisReport/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />    
<link href="../SalesAnalysisReport/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="Javascript/VMIScript.js"></script>
<script language="javascript" src="Javascript/ContextMenu.js"></script>
<script language="javascript">
var strDeleteFlag=false;
var deleteRowId='';
var strFocus =false;
var strShift =false;
var EAUdivHeight = "150px";

function BindSelectedValue()
{
   var ddlChain = document.getElementById("ChainCode_ddlChain");
   document.getElementById("hidChainValue").value= ddlChain.options[ddlChain.selectedIndex].value;
}

function controlFocus(nextCtrl)
{    
    document.getElementById(nextCtrl).focus();
}

function SetChainFocus()
{
    document.getElementById("ChainCode_ddlChain").focus();   
}


function BindRow()
{
    var mode='<%=Request.QueryString["mode"] %>';
    var str='';   
    if(mode=='add')
        AddNewRow(str);
    else 
    {
        str='<%=Request.QueryString["ChainName"]%>';
        EditData(str);
    }
}

function EditData(strGetData)
{
    var strTableValue=VMIContractMaintenance.BindEditData(strGetData,'<%=strContractNo %>','<%= Request.QueryString["ItemNo"] %>').value;
    strTableValue=strTableValue.split('~');
    
    if(strTableValue!="")
        for(var i=0;i<strTableValue.length;i++)
            AddEditRow(strTableValue[i]);   
            
    AddNewRow();
            
}

function SetFlag()
{
    strDeleteFlag=false;
}

function AddEditRow(strData)
{   
        
        // Insert new row into the table
        document.getElementById("dgReport").insertRow(document.getElementById("dgReport").rows.length);
        
        // Assign the css class and background color for the table row
        var tableRow=document.getElementById("dgReport").rows[document.getElementById("dgReport").rows.length-1];
        var id=document.getElementById("dgReport").rows.length-1;
        tableRow.className="GridItem";
        tableRow.style.backgroundColor="#F4FBFD";
         
        var ddlbranchcontrol = document.getElementById("hidBranchControl").value;
        ddlbranchcontrol = ddlbranchcontrol.replace("[BranchID]","txtBranch"+id);
        
        // Code to bind the cells in the table row
        var td1=document.createElement("TD");
        td1.innerHTML=ddlbranchcontrol;
        tableRow.appendChild(td1);
        
        var td2=document.createElement("TD");
        td2.innerHTML="<input type='text' style='text-align:right;width:60px;' id=txtLoc"+id+" onkeypress='Javascript:ValidateNumber();'  onblur='javascript:fillValues(this.id);' class=cnt value="+addCommas(strData.split(',')[1])+"  maxlength=10  onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'/>";
        tableRow.appendChild(td2);
        
        var td3=document.createElement("TD");
        td3.innerHTML="<input type='text' style='text-align:right;width:60px;' id=txtAnnualQty"+id+" onkeypress='Javascript:ValidateNumber();' onblur='javascript:commaValidation(this.value,this.id);' class=cnt  value="+addCommas(strData.split(',')[2])+" maxlength=10  onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'/>";
        tableRow.appendChild(td3);
        
        var td4=document.createElement("TD");
        td4.innerHTML="<input type='text' style='text-align:right;width:60px;' id=txtDay"+id+" onkeypress='Javascript:ValidateNumber();' onblur='javascript:commaValidation(this.value,this.id);' class=cnt  value="+addCommas(strData.split(',')[3])+" maxlength=10  onkeydown='if (event.keyCode==13) {getRow(this.id); event.keyCode=9; return event.keyCode  }'/>";
        tableRow.appendChild(td4);   
        
        //
        // Highlight combo value
        //
        var ddlBranchID = document.getElementById("txtBranch"+id);
        for (var i = 0; i < ddlBranchID.options.length; i++) 
        {           
           if(ddlBranchID.options[i].value == strData.split(',')[0])
                ddlBranchID.options[i].selected = true;
        }    
}

function AddNewRow()
{
    var currentID = document.getElementById("dgReport").rows.length-1;
    if(document.getElementById("dgReport").rows.length > 1)
    {
        if(document.getElementById("txtLoc" + currentID) &&  document.getElementById("txtBranch" + currentID) )
        {
            var currentRowtxtLocation = document.getElementById("txtLoc" + currentID);            
            if(currentRowtxtLocation.value == "" || document.getElementById("txtBranch" + currentID).selectedIndex == 0 )
            {
                event.keyCode = 0; 
                event.returnValue = false;
                return false;
            }
                
        }
    }
    
    // Insert new row into the table   
   document.getElementById("dgReport").insertRow(document.getElementById("dgReport").rows.length);
  
    // Assign the css class and background color for the table row
    var tableRow=document.getElementById("dgReport").rows[document.getElementById("dgReport").rows.length-1];
    var id=document.getElementById("dgReport").rows.length-1;
    tableRow.className="GridItem";
    tableRow.style.backgroundColor="#F4FBFD";

    var ddlbranchcontrol = document.getElementById("hidBranchControl").value;
    ddlbranchcontrol = ddlbranchcontrol.replace("[BranchID]","txtBranch"+id);
    
    // Code to bind the cells in the table row
    var td1=document.createElement("TD");
 
    td1.innerHTML= ddlbranchcontrol;
    tableRow.appendChild(td1);
    
    var td2=document.createElement("TD");
    td2.innerHTML="<input type='text' style='text-align:right;width:60px;'  onkeypress='Javascript:ValidateNumber();' onblur='javascript:fillValues(this.id);' class=cnt id=txtLoc"+id+"  maxlength=10  onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'/>";
    tableRow.appendChild(td2);
    
    var td3=document.createElement("TD");
    td3.innerHTML="<input type='text' style='text-align:right;width:60px;'  onkeypress='Javascript:ValidateNumber();' onblur='javascript:commaValidation(this.value,this.id);' onkeypress='Javascript:ValidateNumber();' class=cnt id=txtAnnualQty"+id+"  maxlength=10  onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'/>";
                    
    tableRow.appendChild(td3);
    
    var td4=document.createElement("TD");
    td4.innerHTML="<input type='text' style='text-align:right;width:60px;'  onkeypress='Javascript:ValidateNumber();' onblur='javascript:commaValidation(this.value,this.id);' class=cnt id=txtDay"+id+"  maxlength=10  onkeydown='if (event.keyCode==13) {getRow(this.id); event.keyCode=9; return event.keyCode }'/>";
    tableRow.appendChild(td4);
        
   
}

function getRow(ctlID)
{

      var strField=eval(ctlID.substring(ctlID.length-1,ctlID.length));          
      var strCmpField=strField+1;
      var strCtrl=document.getElementById(ctlID.replace(strField,strCmpField));
      if(strCtrl==null)
      {
            if(strDeleteFlag==false)
                AddNewRow();
            else
                strDeleteFlag=false;
       }
       
           
}

function DeleteRow(rowId)
{

        var mode='<%=Request.QueryString["mode"]%>';
        
        if(mode=="edit")
        {
            var txtBrn=document.getElementById("txtBranch"+rowId).value;
            var txtLoc=document.getElementById("txtLoc"+rowId).value;
            VMIContractMaintenance.contractDetailDel(txtBrn,txtLoc,'<%=Request.QueryString["Contractno"]%>','<%=Request.QueryString["ItemNo"]%>','<%=Request.QueryString["ChainName"]%>');
        }
        
        document.getElementById("dgReport").deleteRow(rowId);
        var strCtrl="txtBranch,txtLoc,txtAnnualQty,txtDay";
        strCtrl=strCtrl.split(',');
        for(var i=rowId;i<document.getElementById("dgReport").rows.length;i++)
        {
            for(var j=0;j<strCtrl.length;j++)
            {
                
                var replace=strCtrl[j]+i;
                var strReplace=strCtrl[j]+(eval(i)+1); 
                var strCtrlValue='';
                
                if(j==0)
                    strCtrlValue=document.getElementById(strReplace).selectedIndex;
                else
                    strCtrlValue=document.getElementById(strReplace).value;
                    
                document.getElementById("dgReport").rows[i].cells[j].innerHTML=document.getElementById("dgReport").rows[i].cells[j].innerHTML.replace(strReplace,replace);
                
                if(j==0)
                    document.getElementById(replace).selectedIndex=strCtrlValue;
                else
                    document.getElementById(replace).value=strCtrlValue;
                
            }
        }
        
        if(document.getElementById("dgReport").rows.length ==2)
            AddNewRow();
       
}

function RowDelete()
{

    if(deleteRowId!='')
    {
        strDeleteFlag=true;
        DeleteRow(deleteRowId);
        deleteRowId='';
        document.getElementById("divToolTip").style.display='none';
       
    }
    else
        strDeleteFlag=false;
       
}

function validateFocus()
{
    document.getElementById("txtContract").focus();   
    
}

function addCommas(nStr) 
{

    nStr += '';
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ',' + '$2');
	}
	return x1 + x2;

}
function commaValidation(ctrlVal,ctrlID)
{
    if( ctrlVal != "")
    {
        var strVal=eval(ctrlVal.replace(/\,/g,"")).toFixed(0);
        document.getElementById(ctrlID).value=addCommas(strVal);
    }
}
function GridCalc()
{
    
    for(var i=2;i<document.getElementById("dgReport").rows.length;i++)
    {
        var strLoc = document.getElementById("txtLoc"+i);
        fillValues(strLoc.id);
    }
    document.getElementById("txtPrice").focus();
}
   
function fillValues(ctlID)
{
    if(document.getElementById(ctlID)!=null)
    {
        var strLoc = document.getElementById(ctlID).value.replace(/\,/g,"");
        document.getElementById(ctlID).value=((strLoc!='')?eval(strLoc).toFixed(1):"");
        document.getElementById(ctlID).value=addCommas(document.getElementById(ctlID).value);
        var strQtyVal=document.getElementById("txtQty").value.replace(/\,/g,"");
        document.getElementById(ctlID.replace("txtLoc","txtAnnualQty")).value=(strLoc*0.01*strQtyVal).toFixed(0);
        document.getElementById(ctlID.replace("txtLoc","txtAnnualQty")).value=addCommas(document.getElementById(ctlID.replace("txtLoc","txtAnnualQty")).value);
        
        var datediff = days_between(document.getElementById("txtStartDate").value  ,document.getElementById("txtEndDate").value );
        var contractQty = (strLoc*0.01*strQtyVal).toFixed(0);
        
        var Days_30 = ((contractQty/datediff)*30).toFixed(0) 
        if(Days_30 == "NaN" || Days_30== "Infinity")
            Days_30 = 0;
        document.getElementById(ctlID.replace("txtLoc","txtDay")).value= Days_30;
        document.getElementById(ctlID.replace("txtLoc","txtDay")).value=addCommas(document.getElementById(ctlID.replace("txtLoc","txtDay")).value);
        
        if(strFocus!=true)
        {
            document.getElementById(ctlID.replace("txtLoc","txtAnnualQty")).select();
            strFocus=false;
            strShift=false;
        } 
    }  
}

function ValidateGridFocus()
{
        
    if(window.event.keyCode==16 )
    {
      strShift =true;
    }    
    else if(strShift==true && window.event.keyCode==9)
    {
       strFocus =true;
       strShift=false;
    }  
    else
    {
        strShift =false;
        strFocus =false;
    }
               
}      
          
// Javascript Function To Call Server Side Function Using Ajax
function ValidatePFCItem()
{
    var str=VMIContractMaintenance.ValidatePFCItem(document.getElementById("txtPFCItemNo").value).value.toString();
    document.getElementById("lblDesc").innerHTML=str.split("~")[0];
    document.getElementById("hidDescription").value = str.split("~")[0];
    if(str.split("~")[1]=="false")
    {
            alert("Invalid Item #");
            document.getElementById("txtPFCItemNo").value="";
            document.getElementById("txtPFCItemNo").focus();
            //document.form1.txtPFCItemNo.focus();
            
    }
    
}

function SetFocus(ctrlId)
{
    var newCtrlID=ctrlId.replace("txtLoc","txtAnnualQty");
    document.getElementById(newCtrlID).focus();
}
  
function GetSaveData()
{
    var strSaveData='';
    for(var i=2;i<document.getElementById("dgReport").rows.length;i++)
    {
        strSaveData+=document.getElementById("txtBranch"+i).value+"#"+
                    document.getElementById("txtLoc"+i).value+"#"+
                    document.getElementById("txtAnnualQty"+i).value+"#"+
                    document.getElementById("txtDay"+i).value+"~";
    }
    strSaveData=((strSaveData.indexOf('~')!=-1)?strSaveData.substring(0,strSaveData.length-1):strSaveData);
    document.getElementById('hidSaveData').value=strSaveData;    
}
    

function ValidateNumber()
{
    
     if (window.event.keyCode < 45 || window.event.keyCode > 58) window.event.keyCode = 0;
}  


function TextFocus()
{
   document.getElementById("txtBranch2").focus();
}

function ShowToolTip(e,ctlID)
{
    
    if(navigator.appName == 'Microsoft Internet Explorer' && event.button==2)
    {
        // check whether selected row id was more then 10 or not
      
       deleteRowId=ctlID.substring(ctlID.length-2,ctlID.length);
       if(!parseInt(deleteRowId))       
       {
            deleteRowId=ctlID.substring(ctlID.length-1,ctlID.length);
          
       }
       //deleteRowId=ctlID.substring(ctlID.length-1,ctlID.length);
       xstooltip_show('divToolTip',ctlID,289, 49);
       return false;
    }
    if ((navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox') && e.which==3)
    {
         // check whether selected row id was more then 10 or not
       deleteRowId=ctlID.substring(ctlID.length-2,ctlID.length);
       if(!parseInt(deleteRowId))       
       {
            deleteRowId=ctlID.substring(ctlID.length-1,ctlID.length);
           
       }
       //deleteRowId=ctlID.substring(ctlID.length-1,ctlID.length);
       xstooltip_show('divToolTip',ctlID,289, 49);
       return false;
    }
}

function Hide(e)
{
   

       if ((navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox') && e.which==1){
            xstooltip_hide('divToolTip');}
       
       if(navigator.appName == 'Microsoft Internet Explorer' && event.button!=2){
                xstooltip_hide('divToolTip'); }
}

function SetVal(ctlID)
{
    if(ctlID=='imgDivClose')
      xstooltip_hide('divToolTip');
    else 
    {
        if(ctlID=='divToolTip')
            hid='true';
        else 
            hid='';
    }
}

function validateDate(sender,args) 
{
   
        var objValue=args.Value;
        var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
        if ((objValue.match(RegExPattern)) && (objValue!='')) 
            args.IsValid=true;
        else 
            args.IsValid=false;
   
}

function SetEAUDivHeight()
{   
    var divHeight =  document.documentElement.clientHeight - ( document.getElementById('tlbcontent').clientHeight + document.getElementById('tdHeader').clientHeight + document.getElementById('tdFooter').clientHeight + 5);
    document.getElementById("div-datagrid").style.height =divHeight+"px";        
}

function days_between(date1, date2) {
    
    // Convert to date formate
    date1 = new Date(date1);
    date2 = new Date(date2);
    
    // The number of milliseconds in one day
    var ONE_DAY = 1000 * 60 * 60 * 24

    // Convert both dates to milliseconds
    var date1_ms = date1.getTime()
    var date2_ms = date2.getTime()

    // Calculate the difference in milliseconds
    var difference_ms = Math.abs(date1_ms - date2_ms)
    
    // Convert back to days and return
    return Math.round(difference_ms/ONE_DAY)

}
function delayTime(e)
{    
    if(navigator.appName == 'Microsoft Internet Explorer' && event.keyCode == 122)
            setTimeout(" SetEAUDivHeight()",300);
    if ((navigator.appName == 'Netscape' || navigator.appName =='Mozilla Firefox') && e.which==122)
        setTimeout(" SetEAUDivHeight()",300);
    if(document.getElementById("msgText") != null)
        document.getElementById("msgText").innerText = "";
}

</script>

<style>
.PageHead {
	background-color: #EFF9FC;
	border-bottom-width: 2px;
	border-bottom-style: solid;
	border-bottom-color: #BCE6F2;
	font-size: 10px;
	font-weight: bold;
	color: #3A3A56;
	height: 30px;
}

.BannerText {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 20px;
	font-weight:normal;
	color: #CC0000;
	padding-right: 10px;
	padding-bottom: 3px;
}


.PageBg {
	background-color: #B3E2F0;
	padding: 1px;
}
</style>
</head>
<body style="overflow:hidden;"  scroll="no" onload="javascript:BindRow();SetChainFocus();" onmouseup="Hide(event);" onkeyup="delayTime(event);">
    <form id="form1" name="form1" runat="server" defaultbutton="btnSave">      
        <table cellpadding="0" cellspacing="0" id="master" class="DashBoardBk" width="100%">           
            <tr>
                <td class="PageHead" id="tdHeader">
                    <div align="left"  class="BannerText">VMI Contract Maintenance</div>
                </td>
                <td class="PageHead" align="right">
                    &nbsp;</td>
            </tr>
            <tr><td align="center" style="width: 894px"></td></tr>
            <tr>
                <td valign="middle" colspan="2">
                    <table  width="100%" cellpadding="0" cellspacing="1">
                        <tr>
                            <td class="PageBg">
                                <table cellspacing="0" id="tlbcontent" cellpadding="2" align="left" width="100%">
                                    <tr>
                                        <td class="splitBorder TabHead" style="width: 102px;">
                                            <asp:Label ID="Label2" runat="server" Width="70px">Chain Name </asp:Label></td>
                                        <td align="left" style="width: 206px; " class="splitBorder TabHead">
                                          <uc2:ChainCode ID="ChainCode"  runat="server"/>
                                           </td>
                                        <td class="splitBorder TabHead" style="width: 137px;">
                                            <strong>Price Per UOM</strong>
                                        </td>
                                        <td align="left" class="splitBorder TabHead" colspan="3">
                                            <asp:TextBox CssClass="cnt" ID="txtPrice" runat="server" TabIndex="9" onblur="roundNumber(this.value,2,this);this.value=addCommas(this.value);"/>&nbsp;&nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="Only numeric values allowed"
                                              ControlToValidate="txtPrice"  ValidationExpression="[0-9.,]+$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="splitBorder TabHead" style="width: 102px;">
                                            <asp:Label ID="Label3" runat="server" Width="70px">Contract #</asp:Label></td>
                                        <td align="left" style="width: 206px;" class="splitBorder TabHead">
                                            <asp:TextBox CssClass="cnt" ID="txtContract" runat="server" onblur="javascript:controlFocus('txtStartDate');"  MaxLength="25" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtContract"
                                                CssClass="Required" ErrorMessage="* Required" Display="Dynamic"></asp:RequiredFieldValidator></td>
                                        <td class="splitBorder TabHead" style="width: 137px;">
                                            <strong>Expected GP %</strong></td>
                                        <td align="left" class="splitBorder TabHead" colspan="3">
                                            <asp:TextBox CssClass="cnt" ID="txtGp" runat="server" TabIndex="10" onblur="javascript:roundNumber(this.value,1,this)"/>                                           
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Invalid Data"
                                              ControlToValidate="txtGp"  ValidationExpression="[0-9.]+$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator><asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="txtGp"
                                                ErrorMessage="Enter Value between 0 to 100" MaximumValue="100" MinimumValue="0" Type="Double" Display="Dynamic"  CssClass="Required"></asp:RangeValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" class="splitBorder TabHead" style="width: 102px">
                                            <strong>
                                            </strong>
                                                <asp:Label ID="Label4" runat="server" Width="70px">Start Date </asp:Label></td>
                                        <td align="left" style="width: 206px" class="splitBorder TabHead">
                                            <asp:TextBox CssClass="cnt" ID="txtStartDate" runat="server" TabIndex="1"/>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ErrorMessage="Invalid Date"
                                              ControlToValidate="txtStartDate"  ValidationExpression="^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator>                                            
                                            <asp:CustomValidator ID="CustomValidator1" runat="server" ClientValidationFunction="validateDate"
                                                ControlToValidate="txtStartDate" ErrorMessage="Valid Date Format is MM/DD/YYYY" CssClass="Required" Display="Dynamic"></asp:CustomValidator>
                                        </td>
                                        <td height="1" class="splitBorder TabHead" style="width: 137px">
                                            <asp:Label ID="Label7" runat="server" Width="75px">Vendor Code </asp:Label></td>
                                        <td align="left" class="splitBorder TabHead" colspan="3">
                                            <asp:TextBox CssClass="cnt" ID="txtVendor" runat="server" MaxLength="25" TabIndex="11"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="splitBorder TabHead" style="width: 102px; ">
                                            <asp:Label ID="Label5" runat="server" Width="70px">End Date </asp:Label></td>
                                        <td align="left" style="width: 206px;" class="splitBorder TabHead">
                                            <asp:TextBox CssClass="cnt" ID="txtEndDate" runat="server" TabIndex="2" />
                                            <asp:CompareValidator ID="cvDate"  runat="server" ControlToCompare="txtStartDate"
                                                ControlToValidate="txtEndDate" CssClass="Required" Display="Dynamic" ErrorMessage="End date should  be greater than start date"
                                                Operator="GreaterThanEqual" Type="Date"></asp:CompareValidator>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" ErrorMessage="Invalid Date"
                                              ControlToValidate="txtEndDate"  ValidationExpression="^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator>
                                            <asp:CustomValidator ID="CustomValidator2" runat="server" ClientValidationFunction="validateDate"
                                                ControlToValidate="txtEndDate" CssClass="Required" Display="Dynamic" ErrorMessage="Valid Date Format is MM/DD/YYYY"></asp:CustomValidator>
                                        </td>
                                        <td class="splitBorder TabHead" style="width: 137px;">
                                            <strong>
                                            </strong>
                                            <asp:Label ID="Label12" runat="server" Width="98px">PFC Sales Person</asp:Label></td>
                                        <td align="left" class="splitBorder TabHead" colspan="3">
                                            <asp:TextBox CssClass="cnt" ID="txtSales" runat="server" MaxLength="50" TabIndex="12"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" class="splitBorder TabHead" style="width: 102px">
                                            <strong>PFC Item #</strong>
                                        </td>
                                        <td align="left" class="splitBorder TabHead" colspan="5">
                                            <asp:TextBox CssClass="cnt" ID="txtPFCItemNo" runat="server"  onblur="javascript:ValidatePFCItem();"  MaxLength="20" TabIndex="3"/>
                                            <asp:RequiredFieldValidator ID="ReqFieldValidator2" runat="server" ControlToValidate="txtPFCItemNo"
                                                CssClass="Required" ErrorMessage="* Required" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:Label CssClass="cnt" ID="lblDesc" runat="server" Width="345px"/></td>
                                    </tr>
                                    <tr>
                                        <td height="1" class="splitBorder TabHead" style="width: 102px">
                                            <strong>Cross Ref #</strong>
                                        </td>
                                        <td align="left" style="width: 206px" class="splitBorder TabHead">
                                            <asp:TextBox CssClass="cnt" ID="txtRefNo" runat="server" MaxLength="50" TabIndex="4"/>
                                        </td>
                                        <td height="1" class="splitBorder TabHead" style="width: 137px">
                                            <strong></strong>
                                            <asp:Label ID="Label14" runat="server" Width="98px">Contact Name</asp:Label></td>
                                        <td align="left" class="splitBorder TabHead" style="width: 192px">
                                            <asp:TextBox CssClass="cnt" ID="txtContact" runat="server" MaxLength="50" TabIndex="13"/>
                                        </td>
                                        <td align="left" class="splitBorder TabHead" style="width: 98px" >
                                            Phone</td>
                                        <td align="left" class="splitBorder TabHead">
                                            <uc3:PhoneNumber ID="ucPhone" runat="server"  />
                                        </td>
                                        
                                        
                                    </tr>
                                    <tr>
                                        <td height="1" class="splitBorder TabHead" style="width: 102px">
                                            <strong>Substitute #</strong>
                                        </td>
                                        <td align="left" class="splitBorder TabHead" style="width: 206px">
                                            <asp:TextBox CssClass="cnt" ID="txtSubItemNo" runat="server" MaxLength="20" TabIndex="5"/>
                                        </td>
                                        <td height="1" class="splitBorder TabHead" style="width: 137px">
                                            <strong></strong>
                                            <asp:Label ID="Label16" runat="server" Width="98px">Order Method</asp:Label></td>
                                        <td align="left" class="splitBorder TabHead" style="width: 192px">
                                            <asp:DropDownList Width="133px" CssClass="cnt" ID="ddlOrder" runat="server" TabIndex="14">
                                            <asp:ListItem  selected="True" Value="0">--- Select ---</asp:ListItem>
                                            <asp:ListItem Value="Fax">Fax</asp:ListItem>
                                            <asp:ListItem Value="Phone">Phone</asp:ListItem>
                                             <asp:ListItem Value="EDI">EDI</asp:ListItem>
                                             <asp:ListItem Value="E-Commerce">E-Commerce</asp:ListItem>
                                             <asp:ListItem Value="Web Site">Web Site</asp:ListItem>
                                            </asp:DropDownList>
                                           
                                        </td>
                                        <td align="left" class="splitBorder TabHead" style="width: 98px" >
                                            <asp:Label ID="lblStat" runat="server">Closed</asp:Label></td>
                                        <td align="left" class="splitBorder TabHead">
                                        <div id="divCheck">
                                            <asp:CheckBox CssClass="cnt" ID="chkStatus"  runat="server" TabIndex="18" /></div></td>
                                    </tr>
                                    <tr>
                                        <td height="1" class="splitBorder TabHead" style="width: 102px">
                                            <strong>Contract Qty</strong>
                                        </td>
                                        <td align="left" class="splitBorder TabHead">
                                            <asp:TextBox CssClass="cnt" ID="txtQty" runat="server" TabIndex="6" onblur="this.value=addCommas(this.value);GridCalc();" onkeydown="if (event.keyCode==13) {GridCalc(); }" MaxLength="12" />                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ErrorMessage="Only numeric values allowed"
                                              ControlToValidate="txtQty"  ValidationExpression="[0-9,]+$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator>
                                        </td>
                                        <td height="1" class="splitBorder TabHead" style="width: 137px" >
                                            <strong></strong>
                                            <asp:Label ID="Label18" runat="server" Width="98px">Month Factor </asp:Label></td>
                                        <td align="left" class="splitBorder TabHead"  >
                                            <asp:TextBox CssClass="cnt" ID="txtMonth" runat="server" TabIndex="15"  onblur="javascript:roundNumber(this.value,1,this);this.value=addCommas(this.value);"/>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ErrorMessage="Only numeric values allowed"
                                              ControlToValidate="txtMonth"  ValidationExpression="[0-9.,]+$" Display="Dynamic" CssClass="Required"></asp:RegularExpressionValidator>
                                        </td>                                        
                                        <td align="left" class="splitBorder TabHead" style="width: 98px" >
                                            <asp:Label ID="Label1" runat="server" Width="97px">Customer PO#</asp:Label></td>
                                        <td align="left" class="splitBorder TabHead">
                                            <asp:TextBox CssClass="cnt" ID="txtCustomerPO"  runat="server" TabIndex="19" MaxLength="20" onblur=TextFocus();/></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" width="100%" colspan="2" >   
                                    <table cellpadding="0" cellspacing="0" width="100%">                                    
                                    <tr>
                                    <td>
                                    <div class="Sbar" id="div-datagrid" style="overflow:auto;position: relative; top: 0px; left: 0px; height: 150px; width:100%; border: 0px solid;">
                                    <table id=dgReport oncontextmenu="return false" style='z-index:100' cellpadding=0 cellspacing=0  width=420px class="BluBordAll" bgcolor=#f4fbfd rules=all border=1 bordercolor="#d4d0c8" >
                                        <tr>
                                        <th colspan=5>
                                        <div class="PageBg splitBorder" align="center"><strong>Estimated Annual Usage(EAU)</strong></div>
                                        </th>
                                        </tr>
                                        <tr align=center class=GridHead bgcolor=#DFF3F9>
                                            <th tabindex="0">Location</th>
                                            <th>Location %</th>
                                            <th>Contract Qty</th>
                                            <th>30 Day</th>                                           
                                        </tr>
                                    </table>
                                    </div>              
                                    <center>
                                        <asp:Label ID="lblStatus" runat="server" CssClass="redtitle" Text="No Records Found"  Visible="False"></asp:Label></center></td></tr>
                                    </table>  
                            </td>
                        </tr>
                        <tr>
                            <td id="tdFooter" colspan="2" valign="top" width="100%" class="PageBg splitBorder" >
                                <table style="width: 100%;" >
                                    <tr>
                                        <td>
                                            <asp:Label ID="msgText" runat="server" Font-Bold="True"></asp:Label></td>
                                        <td align="right" >
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:ImageButton id="btnSave" style="cursor: hand" OnClientClick="javascript:GetSaveData();"  ImageUrl="~/Common/Images/update.jpg" runat="server" OnClick="btnSave_Click" /></td>
                                                   <td>
                                                        <asp:ImageButton id="btnNext" style="cursor: hand"   ImageUrl="~/Common/Images/nextitem.jpg" runat="server" CausesValidation=false OnClick="btnNext_Click"/></td>
                                                    <td>
                                                        <asp:ImageButton id="ibtnAddItem" style="cursor: hand" OnClientClick="javascript:GetSaveData();" ImageUrl="~/Common/Images/Additem.jpg" runat="server" OnClick="ibtnAddItem_Click" /></td>
                                                    <td>
                                                        <img style="cursor: hand" src="../common/images/close.gif" id="imgClose" onclick="Javascript:window.location.href='VMIContract.aspx';" hspace="2"/></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <input type="hidden" runat="server" id="hidSort" />
                    <asp:HiddenField runat="server" id="hidSaveData" />
                    <div id="divToolTip" class=MarkItUp_ContextMenu_MenuTable style="display:none;word-break:keep-all;" onmousedown="SetVal(this.id)" onmouseup='return false;'>
                        <table width="125"  border="0" cellpadding=0 cellspacing=0 bordercolor=#000099 class="MarkItUp_ContextMenu_Outline">
                              <tr>
                                <td class="bgtxtbox">
                                    <table width=100% border=0 cellspacing=0>
                                        <tr onmouseover="this.className='MarkItUp_ContextMenu_MenuItemBar_Over'" onclick="RowDelete();" onmouseout="this.className='MarkItUp_ContextMenu_MenuItem'" class=MarkItUp_ContextMenu_MenuItem>
                                            <td  valign=middle style="width: 10%"><img src= "../SalesAnalysisReport/Images/icorowdelete.gif" /></td>
                                            <td width=90% valign=middle>
                                                <div id=divCAS  style="vertical-align:middle;" class=MarkItUp_ContextMenu_MenuItem onclick="RowDelete();">Delete</div>
                                            </td>
                                        </tr>                                    
                                    </table>
                                </td>
                              </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
      <input type=hidden id="hidBranchControl" runat=server />
      <input type=hidden id="hidDescription" runat=server />
      <input type=hidden id="hidChainValue" runat=server />
    </form>
</body>
<script>
setTimeout("SetEAUDivHeight()",300);
var ddlChain = document.getElementById("ChainCode_ddlChain");
var hidChainValue=document.getElementById("hidChainValue").value;
for(var i=0;i<ddlChain.options.length;i++)
{
    if(ddlChain.options[i].value==hidChainValue)
    {
        ddlChain.options[i].selected = true;
        break;
    }
}
</script>
</html>
