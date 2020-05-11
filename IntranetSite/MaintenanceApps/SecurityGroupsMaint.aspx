<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SecurityGroupsMaint.aspx.cs" Inherits="PFC.Intranet.Maintenance.SecurityGroupsMaint" %>

<%@ Register Src="Common/UserControls/Header.ascx" TagName="Header" TagPrefix="uc1" %>
<%@ Register Src="Common/UserControls/Footer.ascx" TagName="BottomFooter" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Security Groups Maintenance</title>
    <link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />
    <link href="Common/StyleSheet/DHTMLPopUpMenu.css" rel="stylesheet" type="text/css" />
    <script src="Common/Javascript/Common.js" type="text/javascript"></script>
    
    <style type="text/css">

    </style>
    
    <script>
    
        function LoadHelp()
        {
            window.open('SecurityGroupsMaintHelp.htm','Help','height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES',"");
        }
    
        function Close(session)
        {
            window.close();
        }
    
        function Unload()
        {
           SecurityGroupsMaint.ReleaseLock().value;
        }
    
    </script>

</head>
<body onunload="javascript:Unload();">
    <form id="frmSecGroups" runat="server">
        <asp:ScriptManager runat="server" ID="smSecGroups"></asp:ScriptManager>

        <table cellpadding="0" border="0" cellspacing="0" width="100%" style="border-collapse: collapse;" id="mainTable">
            <tr>
                <td id="tdHeaders">
                    <uc1:Header ID="HeaderID" runat="server" />
                </td>
            </tr>
            <tr class="PageHead shadeBgDown">
                <td class="Left2pxPadd DarkBluTxt boldText blueBorder shadeBgDown">
                    <asp:UpdatePanel ID="pnlTop" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                <tr>
                                    <td align="right" style="padding-right: 5px;">
                                        <asp:ImageButton ID="btnAdd" CausesValidation="false" runat="server" ImageUrl="common/Images/newAdd.gif" OnClick="btnAdd_Click" />
                                        <img src="../Common/images/help.gif" onclick="LoadHelp();" style="cursor: hand" />
                                        <img id="imgClose" src="Common/images/close.jpg" style="cursor:hand" onclick="javascript:Close('<%=Session["SessionID"].ToString() %>');" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                        <tr>
                            <td class="lightBlueBg smallBanText" style="padding-left: 5px; color: black;" width="30%">
                                Security Groups
                            </td>
                            <td class="lightBlueBg smallBanText" style="padding-left: 5px;" width="70%">
                                Security Group Information
                            </td>
                        </tr>
                        <tr>
                            <td style="border-right: solid 1px #c9c6c6;">
                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                    <tr>
                                        <td valign="top">
                                            <asp:Panel ID="pnlSearch" DefaultButton="btnSearch" runat="server">
                                                <table cellpadding="0" cellspacing="0" border="0" class="Search BlueBorder" width="100%">
                                                    <tr>
                                                        <td class="Left2pxPadd">
                                                            <asp:DropDownList ID="ddlSearch" runat="server" Width="120px" CssClass="FormCtrl">
                                                                <asp:ListItem Text="Group Name" Selected="True" Value="Group"></asp:ListItem>
                                                                <asp:ListItem Text="Application" Value="App"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtSearch" runat="server" Width="120px" MaxLength="40" CssClass="FormCtrl"></asp:TextBox>
                                                        </td>
                                                        <td>
                                                            <asp:ImageButton runat="server" ID="btnSearch" ImageUrl="common/images/lens.gif"
                                                                ImageAlign="Left" OnClick="btnSearch_Click" CausesValidation="false" Width="20px" />
                                                        </td>
                                                    </tr>
                                                    <asp:HiddenField ID="hidWhere" runat ="server" />
                                                </table>
                                            </asp:Panel>
                                        </td>                                    
                                    </tr>
                                    <tr>
                                        <td valign="top" class="BlueBorder">
                                            <asp:UpdatePanel ID="pnlTree" UpdateMode="conditional" runat="server">
                                                <ContentTemplate>
                                                    <table id="tblTree" border="0" cellspacing="0" cellpadding="0">
                                                        <tr valign="top">
                                                            <td valign="top">
                                                                <div style="overflow-y: auto; overflow-x: auto; height: 465px; position: relative; width: 300px" class="Sbar">
                                                                    <asp:TreeView ID="tvGroups" runat="server" ExpandDepth="0" ExpandImageToolTip="Expand" CollapseImageToolTip="Collapse" OnSelectedNodeChanged="tvGroups_SelectedNodeChanged" >
                                                                        <RootNodeStyle CssClass=" DarkBluTxt boldText LeafStyle" />
                                                                        <HoverNodeStyle BackColor="#E0F0FF " />
                                                                        <LeafNodeStyle CssClass="Left2pxPadd DarkBluTxt boldText LeafStyle" VerticalPadding="2px" />
                                                                        <ParentNodeStyle CssClass=" DarkBluTxt boldText" ImageUrl="common/images/folder.gif" />
                                                                        <SelectedNodeStyle BackColor="#FFFFFF" />
                                                                    </asp:TreeView>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="Search BlueBorder">
                                            <asp:UpdatePanel ID="pnlSearchResult" UpdateMode="conditional" runat="server">
                                                <ContentTemplate>
                                                    <table cellpadding="0" cellspacing="0" border="0" class="Search">
                                                        <tr>
                                                            <td class="Left2pxPadd DarkBluTxt boldText" width="90px">
                                                                Search Results:
                                                            </td>
                                                            <td align="left">
                                                                <asp:Label ID="lblSearch" runat="server" Font-Bold="true" ForeColor="red" Width="150px"></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td valign="top" style="padding-top: 50px; padding-left: 50px">
                                <asp:UpdatePanel ID="pnlInfo" runat="server">
                                    <ContentTemplate>
                                        <asp:UpdatePanel ID="pnlGroupInfo" UpdateMode="conditional" runat="server">
                                            <ContentTemplate>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td class="DarkBluTxt boldText" width="100px">
                                                            Group ID
                                                        </td>
                                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                            <asp:Label ID="lblGroupID" runat="server" Text=""></asp:Label>
                                                        </td>                                 
                                                    </tr>
                                                    <tr><td>&nbsp</td></tr>
                                                    <tr>
                                                        <td class="DarkBluTxt boldText">
                                                            Group Name
                                                        </td>
                                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                            <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtName" MaxLength="30" Width="300px" OnFocus="javascript:this.select();" OnTextChanged="txtName_TextChanged"></asp:TextBox>
                                                        </td>                                 
                                                    </tr>
                                                    <tr><td>&nbsp</td></tr>
                                                    <tr>
                                                        <td class="DarkBluTxt boldText">
                                                            Application
                                                        </td>
                                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                            <asp:DropDownList ID="ddlSecApp" Height="20px" CssClass="FormCtrl" runat="server"></asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr><td>&nbsp</td></tr>
                                                    <tr>
                                                        <td class="DarkBluTxt boldText">
                                                            Description
                                                        </td>
                                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                            <asp:TextBox CssClass="FormCtrl" runat="server" ID="txtDesc" MaxLength="100" Width="300px" OnFocus="javascript:this.select();"></asp:TextBox>
                                                        </td>                                 
                                                    </tr>
                                                    <tr><td>&nbsp</td></tr>
                                                    <tr>
                                                        <td class="DarkBluTxt boldText" valign="top">
                                                            Comments
                                                        </td>
                                                        <td class="splitBorder_r_h Left2pxPadd Right2pxPadd">
                                                            <asp:TextBox  CssClass="FormCtrl Sbar" ID="txtComments" TextMode="MultiLine" runat="server"
                                                                Height="60px" Width="300px" MaxLength="80" OnFocus="javascript:this.select();"></asp:TextBox>
                                                        </td>                                 
                                                    </tr>
                                                    <asp:HiddenField ID="hidMode" runat ="server" />
                                                    <asp:HiddenField ID="hidDupCheck" runat ="server" />
                                                    <asp:HiddenField ID="hidRecID" runat ="server" />
                                                    <asp:HiddenField ID="hidFocus" runat="server" />
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr class="PageHead shadeBgDown">
                <td class="Left2pxPadd DarkBluTxt boldText blueBorder shadeBgDown">
                    <asp:UpdatePanel ID="pnlBottom" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <table width="100%">
                                <tr>
                                    <td width="30%">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:UpdatePanel ID="pnlStatus" runat="server" UpdateMode="conditional">
                                                        <ContentTemplate>
                                                            <asp:Label ID="lblMessage" Style="padding-left: 5px" ForeColor="red" Font-Bold="true"
                                                                runat="server" Text=""></asp:Label>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                                <td>
                                                    <asp:UpdateProgress ID="pnlProgress" runat="server" DynamicLayout="false">
                                                        <ProgressTemplate>
                                                            <span style="padding-left: 5px; font-weight: bold;">Loading...</span>
                                                        </ProgressTemplate>
                                                    </asp:UpdateProgress>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="padding-left: 5px;">
                                        <asp:ImageButton ID="btnDel" CausesValidation="true" runat="server" ImageUrl="common/Images/BtnDelete.gif" OnClick="btnDel_Click"
                                            OnClientClick="javascript:if(confirm('Are you sure you want to delete?')==true){document.getElementById('hidDelConf').value = 'true';} else {document.getElementById('hidDelConf').value = 'false';}" />
                                    </td>
                                    <td align="right" style="padding-right: 5px;">
                                        <asp:ImageButton ID="btnSave" CausesValidation="true" runat="server" ImageUrl="common/Images/BtnSave.gif" OnClick="btnSave_Click" />
                                        <asp:ImageButton ID="btnCancel" CausesValidation="false" runat="server" ImageUrl="common/Images/cancel.png" OnClick="btnCancel_Click" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>
                    <uc2:BottomFooter ID="BottomFooterID" Title="Security Groups Maintenance" runat="server" />
                </td>
            </tr>
            <asp:HiddenField ID="hidSecurity" runat ="server" />
            <asp:HiddenField ID="hidDelConf" runat ="server" />
            <%--<asp:HiddenField ID="hidFocus" runat="server" />--%>
        </table>
    </form>
</body>
</html>
