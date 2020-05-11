<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="SelectedSKUAnalysisPrompt.aspx.cs" Inherits="SelectedSKUAnalysisPrompt" %>

<%@ Register Src="../Common/UserControls/PageHeader.ascx" TagName="PageHeader" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Selected SKU Analysis Filters</title>
    <link href="../Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="../Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript" src="../Common/javascript/ContextMenu.js"></script>

    <script language="javascript" type="text/javascript">
        function LoadHelp()
        {
            window.open("../Help/HelpFrame.aspx?Name=SelectedSKU",'Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no',"");
        }
    </script>

    <script language="javascript" type="text/javascript">
    //Text input validation
        function ValidateNum() //This allows only 0 thru 9
        {
            if (event.keyCode<48 || event.keyCode>57)
                event.keyCode=0;
        }

        function ValidateNum1() //This allows only 0 thru 9 plus comma (as list delimiter)
        {
            if (event.keyCode != 44 && (event.keyCode<48 || event.keyCode>57))
                event.keyCode=0;
        }

        function ValidateNum2() //This allows only 0 thru 9 plus question mark & asterik (as wildcard)
        {
            if (event.keyCode != 42 && event.keyCode != 63 && (event.keyCode<48 || event.keyCode>57))
                event.keyCode=0;
        }

        function ValidateDateNum() //This allows only 0 thru 9 plus dash [-] or slash [/] (as date delimiter)
        {
            if (event.keyCode != 45 && event.keyCode != 47 && (event.keyCode<48 || event.keyCode>57))
                event.keyCode=0;
        }

        function ValidateAlpha() //This allows only A thru Z (upper & lowercase) plus comma (as list delimiter)
        {
            if (event.keyCode != 44 && (event.keyCode<65 || event.keyCode>122 || (event.keyCode<97 && event.keyCode>90)))
                event.keyCode=0;
        }
    </script>

    <script language="javascript" type="text/javascript">
    //ViewReport: Parse all of the selection parameters, create the URL and display the report
        function ViewReport()
        {
            var URL;
            var ddlIndex;
            var selectedText;

            //------------------------//
            //  Build Location param  //
            //------------------------//
            var strLoc;
            var endLoc;
            var locList;
            if (document.frmMain.chkLocList.checked == true)
            {   //Set strLoc & endLoc to '~' and parse the locList 
                strLoc = '~';
                endLoc = '~';
                locList = document.frmMain.txtLocList.value.replace(/'/gi, "").replace(/\"/gi, "");
                if (isNullOrEmpty(locList) == true)
                {
                    alert('Please enter your list of Locations');
                    return false;
                }
            }
            else
            {   //Set the locList to '~' and parse strLoc & endLoc
                locList = '~';
                strLoc = document.frmMain.ddlStrLoc.value;
                ddlIndex = document.frmMain.ddlStrLoc.selectedIndex;
                selectedText = document.frmMain.ddlStrLoc.options[ddlIndex].text;
                //if (selectedText.toUpperCase().indexOf("ALL") > 0)
                if (strLoc == "ALL")
                {   //ALL locations selected
                    strLoc = '0';
                    endLoc = '9999999999';
                }
                else
                {
                    if (strLoc == '00')
                    {   //Corporate Summary of all locations
                        strLoc = '00';
                        endLoc = '00';
                    }
                    else
                    {   //IF endLoc is blank, make it equal strLoc
                        endLoc = document.frmMain.ddlEndLoc.value; 
                        ddlIndex = document.frmMain.ddlEndLoc.selectedIndex;
                        selectedText = document.frmMain.ddlEndLoc.options[ddlIndex].text;
                        if (selectedText.toUpperCase() == '')
                            endLoc = strLoc;
                    }
                }
            }
            //Validate endLoc is greater than/equal to strLoc
            if (endLoc < strLoc)
            {
                alert ('End Location must be greater than/equal to Starting Location');
                return false;
            }
            //alert ('strLoc='+strLoc+' : endLoc='+endLoc+' : locList=' +locList);
            //--------------------------------------------------------------------

            //------------------------//
            //  Build Category param  //
            //------------------------//
            var strCat;
            var endCat;
            var catList;
            if (document.frmMain.chkCatList.checked == true)
            {   //Set strCat & endCat to '~' and parse the catList
                strCat = '~';
                endCat = '~';
                catList = document.frmMain.txtCatList.value.replace(/'/gi, "").replace(/\"/gi, "");
                if (isNullOrEmpty(catList) == true)
                {
                    alert('Please enter your list of Categories');
                    return false;
                }
            }
            else
            {   //Set the catList to '~' and parse strCat & endCat
                catList = '~';
                strCat = document.frmMain.txtStrCat.value;
                if (isNullOrEmpty(strCat) == true)
                {   //ALL categories selected
                    strCat = '00000';
                    endCat = '99999';
                }
                else
                {   //IF endCat is blank, make it equal strCat
                    endCat = document.frmMain.txtEndCat.value;
                    if (isNullOrEmpty(endCat) == true)
                        endCat = strCat;
                }
            }
            //Validate endCat is greater than/equal to strCat
            if (endCat < strCat)
            {
                alert('End Category must be greater than/equal to Starting Category');
                return false;
            }
            //alert ('strCat='+strCat+' : endCat='+endCat+' : CatList=' +catList);
            //--------------------------------------------------------------------

            //--------------------//
            //  Build Size param  //
            //--------------------//
            var strSize;
            var endSize;
            var sizeList;
            if (document.frmMain.chkSizeList.checked == true)
            {   //Set strSize & endSize to ALL and parse the sizeList
                strSize = '~';
                endSize = '~';
                sizeList = document.frmMain.txtSizeList.value.replace(/'/gi, "").replace(/\"/gi, "");
                if (isNullOrEmpty(sizeList) == true)
                {
                    alert('Please enter your list of Sizes');
                    return false;
                }
            }
            else
            {   //Set the sizeList to '~' and parse strSize & endSize
                sizeList = '~';
                strSize = document.frmMain.txtStrSize.value;
                if (isNullOrEmpty(strSize) == true)
                {   //ALL sizes selected
                    strSize = '0000';
                    endSize = '9999';
                }
                else
                {   //IF endSize is blank, make it equal strSize
                    endSize = document.frmMain.txtEndSize.value;
                    if (isNullOrEmpty(endSize) == true)
                        endSize = strSize;
                }
            }
            //Validate endSize is greater than/equal to strSize
            if (endSize < strSize)
            {
                alert('End Size must be greater than/equal to Starting Size');
                return false;
            }
            //alert ('strSize='+strSize+' : endSize='+endSize+' : SizeList=' +sizeList);
            //--------------------------------------------------------------------------

            //------------------------//
            //  Build Variance param  //
            //------------------------//
            var strVar;
            var endVar;
            var varList;
            if (document.frmMain.chkVarList.checked == true)
            {   //Set strVar & endVar to ALL and parse the varList
                strVar = '~';
                endVar = '~';
                varList = document.frmMain.txtVarList.value.replace(/'/gi, "").replace(/\"/gi, "");
                if (isNullOrEmpty(varList) == true)
                {
                    alert('Please enter your list of Variances');
                    return false;
                }
            }
            else
            {   //Set the varList to '~' and parse strVar & endVar
                varList = '~';
                strVar = document.frmMain.txtStrVar.value.replace("*", "?");
                if (isNullOrEmpty(strVar) == true)
                {   //ALL variances selected
                    strVar = '000';
                    endVar = '999';
                }
                else
                {
                    if (strVar.indexOf('?') > 0)
                    {   //IF strVar contains wildcard, set endVar equal strVar
                        endVar = strVar;
                    }
                    else
                    {   //IF endVar is blank, make it equal strVar
                        endVar = document.frmMain.txtEndVar.value;
                        if (isNullOrEmpty(endVar) == true)
                            endVar = strVar;
                    }
                }
            }
            //Validate endVar is greater than/equal to strVar
            if (endVar < strVar)
            {
                alert('End Variance must be greater than/equal to Starting Variance');
                return false;
            }
            //alert ('strVar='+strVar+' : endVar='+endVar+' : VarList=' +varList);
            //--------------------------------------------------------------------

            //-------------------//
            //  Build CFV param  //
            //-------------------//
            var strCFV;
            var endCFV;
            var CFVList;
            if (document.frmMain.chkCFVList.checked == true)
            {   //Set strCFV & endCFV to ALL and parse the CFVList
                strCFV = '~';
                endCFV = '~';
                CFVList = document.frmMain.txtCFVList.value.replace(/'/gi, "").replace(/\"/gi, "");
                if (isNullOrEmpty(CFVList) == true)
                {
                    alert('Please enter your list of CFVs');
                    return false;
                }
            }
            else
            {   //Set the CFVList to '~' and parse strCFV & endCFV
                CFVList = '~';
                strCFV = document.frmMain.ddlStrCFV.value; 
                ddlIndex = document.frmMain.ddlStrCFV.selectedIndex;
                selectedText = document.frmMain.ddlStrCFV.options[ddlIndex].text; 
                //if (selectedText.toUpperCase().indexOf("ALL") > 0 || strCFV == "")
                if (strCFV == "ALL" || strCFV == "")
                {   //ALL CFVs selected
                    strCFV = 'A';
                    endCFV = 'z';
                }
                else
                {   //IF endCFV is blank, make it equal strCFV
                    endCFV = document.frmMain.ddlEndCFV.value; 
                    ddlIndex = document.frmMain.ddlEndCFV.selectedIndex;
                    selectedText = document.frmMain.ddlEndCFV.options[ddlIndex].text;
                    if (selectedText == "")
                        endCFV = strCFV;
                }
            }
            //Validate endCFV is greater than/equal to strCFV
            if (endCFV < strCFV)
            {
                alert('End CFV must be greater than/equal to Starting CFV');
                return false;
            }
            //alert ('strCFV='+strCFV+' : endCFV='+endCFV+' : CFVList=' +CFVList);
            //--------------------------------------------------------------------

            //-------------------//
            //  Build SVC param  //
            //-------------------//
            var strSVC;
            var endSVC;
            var SVCList;
            if (document.frmMain.chkSVCList.checked == true)
            {   //Set strSVC & endSVC to ALL and parse the SVCList
                strSVC = '~';
                endSVC = '~';
                SVCList = document.frmMain.txtSVCList.value.replace(/'/gi, "").replace(/\"/gi, "");
                if (isNullOrEmpty(SVCList) == true)
                {
                    alert('Please enter your list of SVCs');
                    return false;
                }
            }
            else
            {   //Set the SVCList to '~' and parse strSVC & endSVC
                SVCList = '~';
                strSVC = document.frmMain.ddlStrSVC.value; 
                ddlIndex = document.frmMain.ddlStrSVC.selectedIndex;
                selectedText = document.frmMain.ddlStrSVC.options[ddlIndex].text;    
                //if (selectedText.toUpperCase().indexOf("ALL") > 0 || strSVC == "")
                if (strSVC == "ALL" || strSVC == "")
                {   //ALL SVCs selected
                    strSVC = 'A';
                    endSVC = 'z';
                }
                else
                {   //IF endSVC is blank, make it equal strSVC
                    endSVC = document.frmMain.ddlEndSVC.value; 
                    ddlIndex = document.frmMain.ddlEndSVC.selectedIndex;
                    selectedText = document.frmMain.ddlEndSVC.options[ddlIndex].text;
                    if (selectedText == "")
                        endSVC = strSVC;
                }
            }
            //Validate endSVC is greater than/equal to strSVC
            if (endSVC < strSVC)
            {
                alert('End SVC must be greater than/equal to Starting SVC');
                return false;
            }
            //alert ('strSVC='+strSVC+' : endSVC='+endSVC+' : SVCList=' +SVCList);
            //--------------------------------------------------------------------

            //-------------------//
            //  Build Web param  //
            //-------------------//
            var webFlag;
            var strWeb;
            var endWeb;

            webFlag = document.frmMain.ddlWeb.value; 
            ddlIndex = document.frmMain.ddlWeb.selectedIndex;
            selectedText = document.frmMain.ddlWeb.options[ddlIndex].text;
            if (webFlag.toUpperCase() == "A" || webFlag == "")
            {
                webFlag = 'A';
                strWeb = '0';
                endWeb = 'z';
            }
            if (webFlag.toUpperCase() == "E")
            {
                webFlag = 'E';
                strWeb = '1';
                endWeb = '1';
            }
            if (webFlag.toUpperCase() == "NE")
            {
                webFlag = 'NE';
                strWeb = '0';
                endWeb = '0';
            }
            //alert ('webFlag='+webFlag);
            //--------------------------------------------------------------------

            //--------------------//
            //  Build Date param  //
            //--------------------//
            var ctlDt = 'AFTER';
            var strDt = document.frmMain.txtStrDt.value;
            var endDt = document.frmMain.txtEndDt.value;
            var radioButtons = document.getElementsByName('rdoDateCtl');
            //Which radio button was selected
            for (var x = 0; x < radioButtons.length; x ++)
                if (radioButtons[x].checked) ctlDt = radioButtons[x].value;
            if (isNullOrEmpty(strDt) == true && isNullOrEmpty(endDt) == true)
            {
                strDt = '01/01/1970';
                endDt = '12/31/2120';
            }
            else
            {
                if (ctlDt == 'AFTER')
                {   //AFTER: On or after Start Date
                    if (isNullOrEmpty(strDt) == true)
                    {   //strDt can not be empty
                        alert('Please enter a Start Date');
                        return false;
                    }
                    endDt = '12/31/2120';
                }
                if (ctlDt == 'BEFORE')
                {   //BEFORE: On or before End Date
                    if (isNullOrEmpty(endDt) == true)
                    {   //endDt can not be empty
                        alert('Please enter an End Date');
                        return false;
                    }
                    strDt = '01/01/1970';
                }
                if (ctlDt == 'BETWEEN')
                {   //BETWEEN: Between Start & End Date
                    if (isNullOrEmpty(strDt) == true || isNullOrEmpty(endDt) == true)
                    {   //strDt & endDt can not be empty
                        alert('Please enter a Start & End Date');
                        return false;
                    }
                }
            }
            //Validate endDt is greater than/equal to strDt
            if (endDt < strDt)
            {
                alert('End Date must be greater than/equal to Starting Date');
                return false;
            }
            //alert ('strDt='+strDt+' : endDt='+endDt+' : DateCtl='+ctlDt);
            //-----------------------------------------
            
            //-----------------//
            //  Build the URL  //
            //-----------------//
            URL = "SelectedSKUAnalysis.aspx" +
                  "?StrLoc=" + strLoc +
                  "&EndLoc=" + endLoc +
                  "&LocList=" + locList +
                  "&StrCat=" + strCat +
                  "&EndCat=" + endCat +
                  "&CatList=" + catList +
                  "&StrSize=" + strSize +
                  "&EndSize=" + endSize +
                  "&SizeList=" + sizeList +
                  "&StrVar=" + strVar +
                  "&EndVar=" + endVar +
                  "&VarList=" + varList +
                  "&StrCFV=" + strCFV +
                  "&EndCFV=" + endCFV +
                  "&CFVList=" + CFVList +
                  "&StrSVC=" + strSVC +
                  "&EndSVC=" + endSVC +
                  "&SVCList=" + SVCList +
                  "&strWeb=" + strWeb +
                  "&endWeb=" + endWeb +
                  "&StrDt=" + strDt +
                  "&EndDt=" + endDt +
                  "&DateCtl=" + ctlDt;

            //alert(URL);
            var hwnd;
            hwnd = window.open(URL, "SelectedSKUAnalysis", 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+', left='+((screen.width/2) - (1020/2))+', resizable=no',"");
            hwnd.focus();
        }

        function isNullOrEmpty(value)
        {
            var isNullOrEmpty = true;
            if (value)
            {
                if (typeof (value) == 'string')
                {
                    if (value.length > 0) isNullOrEmpty = false;
                }
            }
            return isNullOrEmpty;
        }
    </script>

</head>
<body>
    <form id="frmMain" runat="server">
    <asp:ScriptManager ID="smSKU" EnablePartialRendering="true" runat="server"></asp:ScriptManager>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="100%" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td valign="middle">
                                <%--Banner & Title Header--%>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td valign="top" colspan="3">
                                            <uc1:PageHeader ID="PageHeader1" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="PageHead" style="height: 40px;">
                                            <table width="850px">
                                                <tr>
                                                    <td>
                                                        <div class="LeftPadding BannerText" align="left">
                                                            Selected SKU Analysis Report</div>
                                                    </td>
                                                    <td align="right" valign="middle">
                                                        <img id="btnSubmitTop" src="../common/images/submit.gif" style="cursor: hand" onclick="javascript:ViewReport();" />&nbsp;&nbsp;
                                                        <img src="../Common/images/help.gif" onclick="javascript:LoadHelp();" style="cursor: hand" />&nbsp;&nbsp;
                                                        <img src="../Common/images/close.gif" onclick="javascript:history.back();" style="cursor: hand" />&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle">
                                <%--User Prompts--%>
                                <table width="700px" border="0" cellspacing="0" cellpadding="3" class="LeftPadding" style="padding-top:5px; padding-bottom:5px;">
                                    <tr>
                                        <td>
                                            <%--Start & End Location--%>
                                            <asp:UpdatePanel runat="server" ID="pnlLoc" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table>
                                                        <col style="width:100px;" />
                                                        <col style="width:135px;" />
                                                        <col style="width:65px;" />
                                                        <col style="width:250px;" />
                                                        <tr>
                                                            <td class="TabHead">
                                                                Start Location
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlStrLoc" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                            </td>
                                                            <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                or
                                                            </td>
                                                            <td class="TabHead">
                                                                <asp:CheckBox ID="chkLocList" runat="server" AutoPostBack="true" OnCheckedChanged="chkLocList_CheckedChanged" />&nbsp;Location List
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="TabHead">
                                                                End Location
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlEndLoc" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtLocList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtLocList"
                                                                    ToolTip="Comma delimited list of Branch Numbers" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum1();" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <%--Start & End Category--%>
                                            <asp:UpdatePanel runat="server" ID="pnlCat" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table>
                                                        <col style="width:100px;" />
                                                        <col style="width:135px;" />
                                                        <col style="width:65px;" />
                                                        <col style="width:200px;" />
                                                        <tr>
                                                            <td class="TabHead">
                                                                Start Category
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtStrCat" runat="server" MaxLength="5" CssClass="FormCtrl2" Text="txtStrCat"
                                                                    OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                            </td>
                                                            <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                or
                                                            </td>
                                                            <td class="TabHead">
                                                                <asp:CheckBox ID="chkCatList" runat="server" AutoPostBack="true" OnCheckedChanged="chkCatList_CheckedChanged" />&nbsp;Category List
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="TabHead">
                                                                End Category
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtEndCat" runat="server" MaxLength="5" CssClass="FormCtrl2" Text="txtEndCat"
                                                                    OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtCatList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtCatList"
                                                                    ToolTip="Comma delimited list of Categories" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum1();" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <%--Start & End Size--%>
                                            <asp:UpdatePanel runat="server" ID="pnlSize" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table>
                                                        <col style="width:100px;" />
                                                        <col style="width:135px;" />
                                                        <col style="width:65px;" />
                                                        <col style="width:200px;" />
                                                        <tr>
                                                            <td class="TabHead">
                                                                Start Size
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtStrSize" runat="server" MaxLength="4" CssClass="FormCtrl2" Text="txtStrSize"
                                                                    OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                            </td>
                                                            <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                or
                                                            </td>
                                                            <td class="TabHead">
                                                                <asp:CheckBox ID="chkSizeList" runat="server" AutoPostBack="true" OnCheckedChanged="chkSizeList_CheckedChanged" />&nbsp;Size List
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="TabHead">
                                                                End Size
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtEndSize" runat="server" MaxLength="4" CssClass="FormCtrl2" Text="txtEndSize"
                                                                    OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtSizeList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtSizeList"
                                                                    ToolTip="Comma delimited list of Sizes" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum1();" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <%--Start & End Variance--%>
                                            <asp:UpdatePanel runat="server" ID="pnlVar" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table>
                                                        <col style="width:100px;" />
                                                        <col style="width:135px;" />
                                                        <col style="width:65px;" />
                                                        <col style="width:200px;" />
                                                        <tr>
                                                            <td class="TabHead">
                                                                Start Variance
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtStrVar" runat="server" MaxLength="3" CssClass="FormCtrl2" Text="txtStrvar"
                                                                    OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum2();" />
                                                            </td>
                                                            <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                or
                                                            </td>
                                                            <td class="TabHead">
                                                                <asp:CheckBox ID="chkVarList" runat="server" AutoPostBack="true" OnCheckedChanged="chkVarList_CheckedChanged" />&nbsp;Variance List
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="TabHead">
                                                                End Variance
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtEndVar" runat="server" MaxLength="3" CssClass="FormCtrl2" Text="txtEndVar"
                                                                    OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum();" />
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtVarList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtVarList"
                                                                    ToolTip="Comma delimited list of Variances" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateNum1();" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <%--Start & End Corp Fixed Velocity--%>
                                            <asp:UpdatePanel runat="server" ID="pnlCFV" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table>
                                                        <col style="width:100px;" />
                                                        <col style="width:135px;" />
                                                        <col style="width:65px;" />
                                                        <col style="width:200px;" />
                                                        <tr>
                                                            <td class="TabHead">
                                                                Start CFV
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlStrCFV" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                            </td>
                                                            <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                or
                                                            </td>
                                                            <td class="TabHead">
                                                                <asp:CheckBox ID="chkCFVList" runat="server" AutoPostBack="true" OnCheckedChanged="chkCFVList_CheckedChanged" />&nbsp;CFV List
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="TabHead">
                                                                End CFV
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlEndCFV" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtCFVList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtCFVList"
                                                                    ToolTip="Comma delimited list of CFVs" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateAlpha();" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <%--Start & End Sales Velocity Code--%>
                                            <asp:UpdatePanel runat="server" ID="pnlSVC" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table>
                                                        <col style="width:100px;" />
                                                        <col style="width:135px;" />
                                                        <col style="width:65px;" />
                                                        <col style="width:200px;" />
                                                        <tr>
                                                            <td class="TabHead">
                                                                Start SVC
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlStrSVC" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                            </td>
                                                            <td align="center" valign="middle" rowspan="2" class="TabHead">
                                                                or
                                                            </td>
                                                            <td class="TabHead">
                                                                <asp:CheckBox ID="chkSVCList" runat="server" AutoPostBack="true" OnCheckedChanged="chkSVCList_CheckedChanged" />&nbsp;SVC List
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="TabHead">
                                                                End SVC
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlEndSVC" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtSVCList" runat="server" MaxLength="3000" CssClass="FormCtrl2" Enabled="false" Width="350px" Text="txtSVCList"
                                                                    ToolTip="Comma delimited list of CFVs" OnFocus="javascript:this.select();" onkeypress="javascript:ValidateAlpha();" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <%--Web Enabled--%>
                                            <asp:UpdatePanel runat="server" ID="pnlWeb" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table>
                                                        <col style="width:100px;" />
                                                        <col style="width:135px;" />
                                                        <col style="width:65px;" />
                                                        <col style="width:200px;" />
                                                        <tr>
                                                            <td class="TabHead">
                                                                Web Filter
                                                            </td>
                                                            <td>
                                                                <asp:DropDownList ID="ddlWeb" CssClass="FormCtrl2" Width="125px" Height="20px" runat="server" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>


                                    <tr>
                                        <td>
                                            <%--Start & End Setup Date--%>
                                            <asp:UpdatePanel runat="server" ID="pnlDate" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table>
                                                        <col style="width:100px;" />
                                                        <col style="width:135px;" />
                                                        <col style="width:65px;" />
                                                        <col style="width:200px;" />
                                                        <tr>
                                                            <td valign="top" class="TabHead">
                                                                Start Setup Date
                                                            </td>
                                                            <td valign="top">
                                                                <asp:UpdatePanel ID="pnlStartDt" runat="server" UpdateMode="conditional">
                                                                    <ContentTemplate>
                                                                        <asp:TextBox ID="txtStrDt" runat="server" AutoPostBack="true" MaxLength="10" CssClass="FormCtrl2" OnTextChanged="txtStrDt_TextChanged" onkeypress="javascript:ValidateDateNum();" Text="txtStrDt" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                            <td valign="top">
                                                                <asp:ImageButton runat="server" ID="ibtnStartDt" ImageUrl="../Common/Images/datepicker.gif" OnClick="ibtnStartDt_Click" Enabled="true" />
                                                            </td>
                                                            <td>
                                                                <asp:UpdatePanel ID="pnlStartPick" runat="server" UpdateMode="conditional">
                                                                    <ContentTemplate>
                                                                        <asp:Calendar ID="cldStartDt" runat="server" Visible="false" OnSelectionChanged="cldStartDt_SelectionChanged" Width="150px" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" class="TabHead">
                                                                End Setup Date
                                                            </td>
                                                            <td valign="top" class="TabHead">
                                                                <asp:UpdatePanel ID="pnlEndDt" runat="server" UpdateMode="conditional">
                                                                    <ContentTemplate>
                                                                        <asp:TextBox ID="txtEndDt" runat="server" AutoPostBack="true" MaxLength="10" CssClass="FormCtrl2" OnTextChanged="txtEndDt_TextChanged" onkeypress="javascript:ValidateDateNum();" Text="txtEndDt" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                            <td valign="top">
                                                                <asp:ImageButton runat="server" ID="ibtnEndDt" ImageUrl="../Common/Images/datepicker.gif" OnClick="ibtnEndDt_Click" Enabled="true" />
                                                            </td>
                                                            <td>
                                                                <asp:UpdatePanel ID="pnlEndPick" runat="server" UpdateMode="conditional">
                                                                    <ContentTemplate>
                                                                        <asp:Calendar ID="cldEndDt" runat="server" Visible="false" OnSelectionChanged="cldEndDt_SelectionChanged" Width="150px" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                &nbsp;
                                                            </td>
                                                            <td valign="top" colspan="3" class="TabHead">
                                                                <asp:UpdatePanel ID="pnlDateParam" runat="server" UpdateMode="conditional">
                                                                    <ContentTemplate>
                                                                        <asp:RadioButtonList id="rdoDateCtl" runat="server">
                                                                           <asp:ListItem Selected="True" Text="On or after Start Date" Value="AFTER" />
                                                                           <asp:ListItem Text="On or before End Date" Value="BEFORE" />
                                                                           <asp:ListItem Text="Between Start & End Date" Value="BETWEEN" />
                                                                        </asp:RadioButtonList>
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="lightBlueBg buttonBar" style="border-top:solid 1px #CDECF6" height="20px">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:UpdateProgress ID="pnlProgress" runat="server" DisplayAfter="1" DynamicLayout="false">
                                                <ProgressTemplate>
                                                    <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                                </ProgressTemplate>
                                            </asp:UpdateProgress>
                                        </td>
                                        <td>
                                            <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                                <ContentTemplate>
                                                    <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                        runat="server" Width="500px" Text=""></asp:Label>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="BluBg" style="height: 30px;">
                                <table width="682px">
                                    <tr>
                                        <td align="right" valign="middle">
                                            <img id="btnSubmitBtm" src="../common/images/submit.gif" style="cursor: hand; vertical-align:middle;" onclick="javascript:ViewReport();" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hidURL" runat="server" />
        <asp:HiddenField ID="hidSecurity" runat="server" />
    </form>
</body>
</html>
