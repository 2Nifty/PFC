<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PrintUtility.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Print Utility</title>
    <link href="Common/StyleSheet/SOEStyles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/fixFloat_IE6.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/utilityWndStyles.css" rel="stylesheet" type="text/css" />

    <script>
     function OpenPopup(val,CustNo)
    {
   
     var hwin=window.open("SelectContacts.aspx?Mode="+val+"&CustomerNo="+CustNo,"Contacts",'height=280,width=505,scrollbars=no,status=no,top='+((screen.height/2) - (280/2))+',left='+((screen.width/2) - (505/2))+',resizable=NO',"");
     hwin.focus();
     
    }
    // added by Slater 9/25/2009
    function OpenPreview(DocURL)
    {
     var pwin=window.open(DocURL,"Preview",'scrollbars=no,status=no,resizable=yes,scrollbars=yes',"");
    }
    // added by Slater 9/25/2009

    function PrintPopUP(url)
    {
    var hwin=window.open("CommonPrint.aspx?PageURL="+url,"LanscapePrint",'height=100,width=100,scrollbars=no,status=no,top='+((screen.height/2) - (280/2))+',left='+((screen.width/2) - (505/2))+',resizable=NO',"");
    hwin.focus();
   // hwin.print();
   // hwin.close();
    }
    
    function OpenHistory()
    {
        var hwinHistory =window.open("PrintUtilityHistory.aspx","History",'height=566,width=850,scrollbars=no,status=no,top='+((screen.height/2) - (580/2))+',left='+((screen.width/2) - (800/2))+',resizable=NO',"");
        hwinHistory.focus();
        
        return false;
    }
    
    function DisplayConverLetterFields()
    {
        
        if(document.getElementById("chkIncludeCover").checked)
        {
            document.getElementById("tblCoverLetter").style.display = "";            
            document.getElementById("trFaxToName").style.display = "";
            document.getElementById("txtFaxFromName").focus();
        }
        else
        {
            document.getElementById("tblCoverLetter").style.display = "none";     
            document.getElementById("trFaxToName").style.display = "none";                 
        }
    }
    
    function toPhoneFormat(isField)
    {
        var prefix='',firstThree = '',secondThree ='',thirdFour ='';
        var isPhone = isField.value;
        if (isPhone.length == 10)
        {
            firstThree = isPhone.substring(0,3);
            secondThree = isPhone.substring(3,6);
            thirdFour = isPhone.substring(6,10);
            isField.value = '('+firstThree+')' + secondThree + '-' + thirdFour
        }
        else if(isPhone.length == 11)
        {
            prefix = isPhone.substring(0,1);
            firstThree = isPhone.substring(1,4);
            secondThree = isPhone.substring(4,7);
            thirdFour = isPhone.substring(7,11);
            isField.value = prefix + '-' + firstThree+'-' + secondThree + '-' + thirdFour
        }
    }
    
    function limitText(limitField, limitNum) 
    {
	    if (limitField.value.length > limitNum) 
	    {
		    alert('Only 700 characters allowed.');
	    } 	
    }
    </script>

</head>
<body scroll="no" style="margin: 2px;">
    <form runat="server" id="form1">
        <asp:ScriptManager ID="scmPrintUtility" AsyncPostBackTimeout="360000" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="pnlButtons" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="wndContainer clearfix" style="width: 638px">
                    <div class="wndTitle">
                        <div class="wndControls">
                            <a href="#" style="display: block; background: #cc0000; border: 1px solid #990000;
                                width: 25px; text-align: center; line-height: 22px; cursor: pointer; color: #ffffff;
                                text-decoration: none;" onclick="javascript:window.opener.focus();parent.window.close();">
                                X</a>
                        </div>
                        Porteous Export Utility Window
                    </div>
                    <div class="wndBody">
                        <table cellpadding="0" cellspacing="0" border="0" style="padding-bottom: 5px; padding-left: 10px;"
                            width="100%">
                            <tr>
                                <td align="left" class="txtLogin">
                                    <asp:Label ID="lblCust" CssClass="BannerText" runat="server"></asp:Label>
                                </td>
                                <td align="right" style="width: 250px; padding-right: 10px;" valign="bottom">
                                    <strong>
                                        <asp:Label ID="lblSubject" runat="server"></asp:Label></strong>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" border="0" style="padding-left: 10px;" width="100%">
                            <tr>
                                <td>
                                    <asp:ImageButton ImageUrl="~/Common/Images/print_n.gif" ID="btnPrint" runat="server"
                                        OnClick="btnPrint_Click" />
                                    <asp:ImageButton ImageUrl="~/Common/Images/email_n.gif" ID="btnEmail" runat="server"
                                        OnClick="btnEmail_Click" />
                                    <asp:ImageButton ImageUrl="~/Common/Images/fax_n.gif" ID="btnFax" runat="server"
                                        OnClick="btnFax_Click" />
                                </td>
                                <td align="right" style="padding-right: 10px;">
                                    <asp:LinkButton ID="lnkHistory" OnClientClick="javascript:return OpenHistory();"
                                        CssClass="TabHead" Font-Bold="True" Text="View History" runat="server"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                        <asp:UpdatePanel ID="pnlPint" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 620px; height: 220px;" runat="server" id="tblPrinterPref" cellpadding="0"
                                    cellspacing="0" border="0" class="wndContent">
                                    <tr>
                                        <td style="width: 600px;" valign="top">
                                            <table runat="server" id="tblPrinterSetup" cellpadding="0" cellspacing="0" border="0"
                                                style="padding-top: 10px;">
                                                <tr>
                                                    <td colspan="2" style="padding-left: 10px;">
                                                        <asp:Label ID="Label2" runat="server" Text="Page Setup " Font-Bold="True"></asp:Label>
                                                        <asp:HiddenField ID="HidPageSetup" runat="server" />
                                                        <asp:HiddenField ID="hidPrinter" runat="server" />
                                                    </td>
                                                    <td colspan="2">
                                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 200px">
                                                            <tr>
                                                                <td>
                                                                    <asp:RadioButton ID="rdoPortrait" runat="server" OnCheckedChanged="rdoPortrait_CheckedChanged"
                                                                        AutoPostBack="True" Checked="True" Text="Portrait" GroupName="PageSetup" /></td>
                                                                <td>
                                                                    <asp:RadioButton ID="rdoLandscape" runat="server" OnCheckedChanged="rdoLandscape_CheckedChanged"
                                                                        AutoPostBack="True" Text="Landscape" GroupName="PageSetup" /></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr id="trDefault" runat="server">
                                                    <td>
                                                        <asp:RadioButton ID="rdoText" runat="server" OnCheckedChanged="rdoText_CheckedChanged"
                                                            AutoPostBack="True" Checked="True" GroupName="Print" /></td>
                                                    <td style="width: 80px; height: 27px;">
                                                        <asp:Label ID="Label5" runat="server" Text="Default Printer " Font-Bold="True"></asp:Label></td>
                                                    <td style="width: 100px" colspan="2">
                                                        <asp:TextBox ID="txtPrint" runat="server" Width="320px" CssClass="FormControls"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                            <table visible="false" id="tblPrint" runat="server" width="100%">
                                                <tr>
                                                    <td align="center">
                                                        <asp:ImageButton ImageUrl="~/Common/Images/PRINTImg.gif" ID="btnPrinter" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <table cellpadding="0" cellspacing="0" border="0" runat="server" id="tblPrinter">
                                                <tr>
                                                    <td>
                                                        <asp:RadioButton ID="rdoPrint" runat="server" OnCheckedChanged="rdoPrint_CheckedChanged"
                                                            AutoPostBack="True" GroupName="Print" /></td>
                                                    <td style="width: 80px; height: 27px;">
                                                        <asp:Label ID="Label7" runat="server" Text="Print Server " Width="80px" Font-Bold="True"></asp:Label></td>
                                                    <td style="width: 80px">
                                                        <asp:DropDownList ID="ddlPrinterServer" runat="server" Width="80px" OnSelectedIndexChanged="ddlPrinterServer_SelectedIndexChanged"
                                                            Enabled="False" CssClass="FormControls" AutoPostBack="True">
                                                        </asp:DropDownList></td>
                                                    <td style="width: 60px" align="right">
                                                        <asp:Label ID="Label8" runat="server" Text="Printer" Width="60px" Font-Bold="True"></asp:Label></td>
                                                    <td style="width: 100px">
                                                        <asp:DropDownList ID="ddlPrinterName" runat="server" Width="187px" Enabled="False"
                                                            CssClass="FormControls">
                                                        </asp:DropDownList></td>
                                                </tr>
                                            </table>
                                            <table cellpadding="0" cellspacing="0" border="0" style="padding-top: 10px;">
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <%-- Added by Slater --%>
                                                        <asp:ImageButton ImageUrl="~/Common/Images/PreviewDoc.gif" ID="btnPrintPreviewDoc"
                                                            runat="server" />
                                                        <asp:ImageButton ImageUrl="~/Common/Images/setdefaultprinterbig.gif" ID="btnDefaultPrinter"
                                                            runat="server" OnClick="btnDefaultPrinter_Click" />
                                                        <asp:ImageButton OnClick="btnPostPrint_Click1" ImageUrl="~/Common/Images/postrequest.gif"
                                                            CausesValidation="false" ID="btnPostPrint" runat="server" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <div align="center" id="divBannerPrint" class="MessageText" runat="server">
                                                            <asp:Label ForeColor="DarkGreen" ID="lblmsgPrint" runat="server"></asp:Label>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <table style="width: 620px; height: 220px;" runat="server" id="tblDefaultPrinter"
                                    cellpadding="0" cellspacing="0" border="0" class="wndContent">
                                    <tr>
                                        <td style="width: 600px; padding-top: 10 px" valign="top">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="height: 20px; padding-left: 10px">
                                                        <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Print Server " Width="80px"></asp:Label></td>
                                                    <td style="width: 100px; height: 20px;">
                                                        <asp:DropDownList ID="ddlDefaultPrintServer" runat="server" Width="80px" Enabled="False"
                                                            CssClass="FormControls" AutoPostBack="True" OnSelectedIndexChanged="ddlDefaultPrintServer_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td style="height: 20px;">
                                                        <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="Printer" Width="60px"></asp:Label></td>
                                                    <td style="height: 20px">
                                                        <asp:DropDownList ID="ddldefaultPrinter" runat="server" Width="187px" Enabled="False"
                                                            CssClass="FormControls">
                                                        </asp:DropDownList></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td>
                                                    </td>
                                                    <td style="padding-top: 10 px; padding-left: 20px" align="right">
                                                        <asp:ImageButton ID="ibtnSave" runat="server" ImageUrl="~/Common/Images/BtnSave.gif"
                                                            OnClick="ibtnSave_Click" />
                                                        <asp:ImageButton ID="btnCancel" ImageUrl="~/Common/Images/cancel.gif" runat="server"
                                                            OnClick="btnCancel_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdatePanel ID="pnlEmail" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 620px; height: 220px;" class="wndContent Sbar">
                                    <tr>
                                        <td style="width: 700px;" valign="top">
                                            <table>
                                                <tr>
                                                    <td style="width: 56px">
                                                        <asp:LinkButton ID="lnkEmail" CssClass="TabHead" Font-Bold="True" Text="Email To"
                                                            runat="server"></asp:LinkButton>
                                                        <%--<asp:Label ID="Label1" runat="server" Text="Email To" Width="46px"></asp:Label>--%>
                                                    </td>
                                                    <td style="width: 137px">
                                                        <asp:TextBox ID="txtEmailTo" runat="server" Width="373px" CssClass="FormControls"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 56px">
                                                        <asp:Label ID="Label3" runat="server" Text="Subject" Font-Bold="True"></asp:Label></td>
                                                    <td style="width: 137px">
                                                        <asp:TextBox ID="txtSubject" runat="server" Width="372px" CssClass="FormControls"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 56px">
                                                        <asp:Label ID="Label4" runat="server" Text="Comments" Font-Bold="True"></asp:Label></td>
                                                    <td style="width: 137px">
                                                        <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" Width="372px" Height="100px"
                                                            CssClass="FormControls"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <%-- Added by Slater --%>
                                                        <asp:ImageButton ImageUrl="~/Common/Images/PreviewDoc.gif" ID="btnEMailPreviewDoc"
                                                            runat="server" />
                                                        <asp:ImageButton ImageUrl="~/Common/Images/postrequest.gif" ID="btnPostEmail" CausesValidation="false"
                                                            runat="server" OnClick="btnPostEmail_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <div align="center" id="divBannerEmail" class="MessageText" runat="server">
                                                            <asp:Label ForeColor="DarkGreen" ID="lblmsgEmail" runat="server" Text=""></asp:Label>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdatePanel ID="pnlFax" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 620px; height: 220px;" class="wndContent Sbar">
                                    <tr>
                                        <td style="width: 700px;" valign="top" >
                                            <table width=100%>
                                                <tr>
                                                    <td style="height: 27px;">
                                                        <asp:LinkButton ID="lnkFax" runat="server" Text="Fax To Number:" CssClass="TabHead" Font-Bold="true"></asp:LinkButton>
                                                        <%--<asp:Label ID="Label6" runat="server" Text="Customer Fax No" Width="100px"></asp:Label>--%>
                                                    </td>
                                                    <td style=" height: 27px; width: 100px;">
                                                        <asp:TextBox ID="txtCustomerFaxNo" runat="server" Width="328px" CssClass="FormControls" onblur="javascript:toPhoneFormat(this);"></asp:TextBox></td>
                                                    <td style="height: 27px">
                                                        <asp:CheckBox ID="chkIncludeCover" runat="server" Text="Include Cover Letter" onclick="javascript:DisplayConverLetterFields();" Width="120px" /></td>
                                                </tr>
                                                <tr id="trFaxToName" style="display:none;">
                                                    <td style="height: 27px">
                                                        <asp:Label ID="lblFaxToCompTitle" runat="server" CssClass="TabHead" Font-Bold="True"
                                                            Text="Fax To Company:" Width="100px"></asp:Label></td>
                                                    <td style=" height: 27px">
                                                        <asp:TextBox ID="txtFaxToCompanyName" runat="server" CssClass="FormControls" onblur="javascript:toPhoneFormat(this);"
                                                            Width="328px"></asp:TextBox></td>
                                                    <td style="height: 27px">
                                                    </td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td style="width: 408px" align="right">
                                                        <%-- Added by Slater --%>
                                                        <asp:ImageButton ImageUrl="Common/Images/PreviewDoc.gif" ID="btnFAXPreviewDoc"
                                                            runat="server" Visible="False" />
                                                        <asp:ImageButton ID="btnPostFax" ImageUrl="Common/Images/postrequest.gif" runat="server"
                                                            CausesValidation="false" OnClick="btnPostFax_Click" />
                                                    </td>
                                                    <td align="right" style="width: 180px">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <table id="tblCoverLetter" border="0" cellpadding="0" cellspacing="0" runat=server>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:Label ID="Label9" runat="server" Font-Bold="True" Text="Fax From Information"></asp:Label></td>
                                                                <td style="padding-left: 10px; width: 100px">
                                                                    <asp:Label ID="Label13" runat="server" Font-Bold="True" Text="Notes/Comments:" Width="100px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label11" runat="server" Font-Bold="True" Text="Name:" Width="60px"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:TextBox ID="txtFaxFromName" runat="server" CssClass="FormControls" Width="120px"></asp:TextBox></td>
                                                                <td rowspan="3" style="padding-left: 10px; width: 100px">
                                                                    <asp:TextBox ID="txtFaxFromNotes" runat="server" CssClass="FormControls" Height="80px" TextMode="MultiLine"
                                                                        Width="330px" onKeyDown="limitText(this,700);" onKeyUp="limitText(this,700);"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label10" runat="server" Font-Bold="True" Text="Fax #"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:TextBox ID="txtFaxFromFaxNo" runat="server" CssClass="FormControls" onblur="javascript:toPhoneFormat(this);" Width="120px"></asp:TextBox></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label12" runat="server" Font-Bold="True" Text="Phone #"></asp:Label></td>
                                                                <td style="width: 100px">
                                                                    <asp:TextBox ID="txtFaxFromPhoneNo" runat="server" CssClass="FormControls" onblur="javascript:toPhoneFormat(this);" Width="120px"></asp:TextBox></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr>
                                                    <td style="width: 438px" align="right">
                                                        <div align="center" id="divBanner" class="MessageText" runat="server">
                                                            <asp:Label ForeColor="DarkGreen" ID="lblmsg" runat="server" Text=""></asp:Label>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>