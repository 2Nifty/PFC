<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetCerts.aspx.cs" Inherits="GetCerts" %>

<%@ Register Src="~/UserControls/Top.ascx" TagName="Top" TagPrefix="uc1" %>
<%@ Register Src="~/UserControls/Bottom.ascx" TagName="Bottom" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GetCert.aspx</title>
    <link href="StyleSheet/styles.css" rel="stylesheet" type="text/css" />

    <script>
        function GetEnlargeImage(itemNumber,pfcLotNumber,mfgLotNumber)
        {
            var queryString="ItemNo="+itemNumber +"&PFCLotNo="+ pfcLotNumber  +"&MfgLotNo="+mfgLotNumber +"&ImgType=Single" ;
            var hwin;
            hwin=window.open("GetCertsImg.aspx?"+queryString,"GetEnlargeImage",'height=710,width=690,toolbar=0,scrollbars=no,status=0,resizable=YES,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (690/2))+'','');
            hwin.focus();
        }
        
         function GetXMLImage(itemNumber,pfcLotNumber,mfgLotNumber)
        {            
            var queryString="ItemNo="+ itemNumber +"&PFCLotNo="+ pfcLotNumber  +"&MfgLotNo="+mfgLotNumber +"&ImgType=Multiple" ;
            var hwin;
            hwin=window.open("GetCertsImg.aspx?"+queryString,"GetEnlargeImage",'height=710,width=690,toolbar=0,scrollbars=no,status=0,resizable=YES,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (690/2))+'','');
            hwin.focus();
            
        }
        function FillItem(itemNo)
{
    if(itemNo!="")
    {
        var section="";
        var completeItem=0;
        switch(itemNo.split('-').length)
        {
        case 1:
           
            event.keyCode=0;
            itemNo = "00000" + itemNo;
            itemNo = itemNo.substr(itemNo.length-5,5);
            document.getElementById("txtItemNumber").value=itemNo+"-"; 
            return false;
            break;
        case 2:
            // close if they are entering an empty part
            if (itemNo.split('-')[0] == "00000") {ClosePage()};
            event.keyCode=0;
            section = "0000" + itemNo.split('-')[1];
            section = section.substr(section.length-4,4);
            document.getElementById("txtItemNumber").value=itemNo.split('-')[0]+"-"+section+"-";  
            return false;
            break;
        case 3:
            event.keyCode=0;
            section = "000" + itemNo.split('-')[2];
            section = section.substr(section.length-3,3);
            document.getElementById("txtItemNumber").value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;            
            document.getElementById("txtMfgLotNo").focus();
            return true;
            break;
        default:
            document.getElementById("txtMfgLotNo").focus();  
            return true;   
        }          
    }
   
}
    </script>

    <script language="JavaScript" type="text/javascript">
    <!--
    // -----------------------------------------------------------------------------
    // Globals
    // Major version of Flash required
    var requiredMajorVersion = 8;
    // Minor version of Flash required
    var requiredMinorVersion = 0;
    // Revision of Flash required
    var requiredRevision = 0;
    // the version of javascript supported
    var jsVersion = 1.0;
    // -----------------------------------------------------------------------------
    // -->
    </script>

    <script language="VBScript" type="text/vbscript">
    <!-- // Visual basic helper required to detect Flash Player ActiveX control version information
    Function VBGetSwfVer(i)
      on error resume next
      Dim swControl, swVersion
      swVersion = 0
      
      set swControl = CreateObject("ShockwaveFlash.ShockwaveFlash." + CStr(i))
      if (IsObject(swControl)) then
        swVersion = swControl.GetVariable("$version")
      end if
      VBGetSwfVer = swVersion
    End Function
    // -->
    </script>

    <script language="JavaScript1.1" type="text/javascript">
    <!-- // Detect Client Browser type
    var isIE  = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
    var isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1) ? true : false;
    var isOpera = (navigator.userAgent.indexOf("Opera") != -1) ? true : false;
    jsVersion = 1.1;
    

 
    // -->
    </script>

    <script src="Javascript/ActiveContent.js"></script>

    <link href="../StyleSheet/styles.css" rel="stylesheet" type="text/css" />
    <link href="../StyleSheet/styles.css" rel="stylesheet" type="text/css" />
    <link href="StyleSheet/styles.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="form1" runat="server">
        <asp:ScriptManager ID="MyScript" runat="server" EnablePartialRendering ="true" ></asp:ScriptManager>
        <table cellpadding="0" cellspacing="0" align="Center" id="mainTable">
            <tr>
                <td valign="top">
                    <uc1:Top ID="Top1" runat="server" />
                </td>
            </tr>
            <tr class="content">
                <td>
                    <table cellpadding="0" cellspacing="0" width="970px" style="padding: 0px; margin: 0px;"
                        border="0" class="container">
                        <tr>
                            <td colspan="2" style="padding: 10px; padding-bottom: 0px;">
                                <img src="images/Userlibrary/registrationBanner.gif" alt="User Registration" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="copy">
                                    <h3 class="redTxt">
                                        PFC Certification Request</h3>
                                    <table cellpadding="3" cellspacing="0" border="0">
                                        <tr>
                                            <td colspan="2">
                                                <p>
                                                    <strong>Please fill in the PFC Item Number and Manufacturers Lot Number below to retrieve
                                                        the certification image.This
                                                        <br />
                                                        information can be obtained from the PFC Label affixed to the Product Carton. </strong>
                                                </p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="rightContent">
                                                <asp:Panel ID="Panel2"   runat="server">
                                                
                                                    <table cellpadding="2" cellspacing="0" width="50%">
                                                        <tr>
                                                            <td style="width: 15px; height: 15px" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Label CssClass="frmLbl" ID="lblItemNo" runat="server" Text="PFC Part No:" Width="100px" Font-Bold="True"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox CssClass="txtCtrl" TabIndex="1" ID="txtItemNumber" runat="server" AutoCompleteType="Disabled" MaxLength="20"
                                                                    Width="220px"  
                                                                        onkeypress="javascript:if(event.keyCode==9 || event.keyCode==13)FillItem(this.value);"></asp:TextBox>
                                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtItemNumber"
                                                                    Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator>
                                                                        </td>
                                                            <td>
                                                                
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 15px; height: 10px" colspan="2">
                                                                <asp:Label ID="Label1" runat="server" CssClass="frmLbl" Font-Bold="True" Text="PFC Lot No:"
                                                                    Width="99px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:TextBox ID="txtPFCLotNo" runat="server" AutoCompleteType="Disabled" CssClass="txtCtrl"
                                                                    MaxLength="20" onkeypress="javascript:if(event.keyCode==9 || event.keyCode==13)FillItem(this.value);"
                                                                    TabIndex="1" Width="220px"></asp:TextBox></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Label CssClass="frmLbl" ID="lblLotNo" runat="server" Text="MFG Lot No:" Width="94px" Font-Bold="True"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox CssClass="txtCtrl" ID="txtMfgLotNo" runat="server"  MaxLength="14" AutoCompleteType="Disabled"
                                                                    Width="220px" TabIndex ="2"></asp:TextBox>
                                                                     <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtMfgLotNo" 
                                                                    Display="Dynamic" ErrorMessage="*Required" Width="52px"></asp:RequiredFieldValidator>
                                                                    </td>
                                                            <td>
                                                               </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 15px; height: 10px" colspan="2">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" style="height: 26px">
                                                            <asp:Button UseSubmitBehavior="true" TabIndex="3" ID="btnSubmit"  CausesValidation="True" runat="server" CssClass="frmBtn" Text="Submit" OnClick="btnSubmit_Click" />
                                                               <%--<asp:ImageButton ID="btnSubmit" TabIndex ="0" CssClass="frmBtn" ImageUrl="~/images/UserLibrary/btn_sumbit.jpg"
                                                            runat="server" CausesValidation="True" OnClick="btnSubmit_Click"   />--%>
                                                 
                                                            </td>
                                                        </tr>
                                                    </table>
                                                   
                                                </asp:Panel>
                                            </td>
                                            <td style="width: 250px">
                                                <asp:Panel ID="CertsAssit" runat="server" Visible="false" >
                                                
                                                    <table cellpadding="2" cellspacing="0" width="100%" >
                                                        <tr>
                                                            <td style="width: 15px; height: 15px">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 15px; height: 15px">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="redTxt" style="font-weight: bold;">
                                                                Very sorry.We were unable to find a matching certification.Please                                                                
                                                                check the your information and try your search again or click the
                                                                "Certs Assistance" button Below.
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 15px; height: 15px">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="redhead" style="height: 18px">
                                                                <asp:ImageButton ID="btnCertsAssist" ImageUrl="~/images/UserLibrary/btn_certsassist.jpg"
                                                                runat="server" CausesValidation="True" OnClick="btnCertsAssist_Click" />
                                                   
                                                            </td>
                                                        </tr>
                                                         <tr>
                                                            <td class="redTxt" style="font-weight: bold;">
                                                                The "Certs assistance" button will send an email to PFC with your
                                                                information using your e-mail address.
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                            <td style="height:25px; width: 213px;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td  class="redTxt" style="font-weight: bold;">
                                                Example: PFC Label</td>
                                            <td style="width: 213px">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Image ID="Image1" runat="server" ImageUrl="~/images/250-175.gif" /></td>
                                            <td style="width: 213px">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:HyperLink ID="hplEnlarge" Target="_blank" runat="server">
                                                    <asp:Image ID="imgCerts" Width="500px" Visible="False" runat="server" Style="cursor: hand;" />
                                                </asp:HyperLink>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:UpdateProgress ID="upProgress" runat="server">
                                                    <ProgressTemplate>
                                                        <asp:Label ID="progress" runat="server" Text="Loading..." Width="80px"></asp:Label>
                                                    </ProgressTemplate>
                                                </asp:UpdateProgress>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" class="footer">
                    <uc2:Bottom ID="Bottom1" runat="server" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
