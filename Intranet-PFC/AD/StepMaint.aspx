<%@ Page Language="VB" AutoEventWireup="false" CodeFile="StepMaint.aspx.vb" Inherits="StepMaint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>AD Step Maintenance</title>
    <link href="StyleSheet/Styles.css" rel="stylesheet"  type="text/css" />
</head>
<body>
    <form id="MainForm" runat="server">
        <div>
    <asp:SqlDataSource ID="StepNames" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>" 
        SelectCommand="SELECT DISTINCT StepCode FROM ADStepConfig ORDER BY StepCode" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="MinMaxNames" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>" 
        SelectCommand="SELECT DISTINCT MinMaxCode FROM ADMinMax ORDER BY MinMaxCode" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="BranchNames" runat="server" ConnectionString="<%$ ConnectionStrings:PFCReportsConnectionString %>" 
        SelectCommand="SELECT distinct rtrim(Branch) as Branch, Branch + ' - ' + BranchName as BranchDesc FROM KPIBranches ORDER BY Branch" ></asp:SqlDataSource>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="MasterUpdatePanel" runat="server"><ContentTemplate>
        <table width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td valign="middle" class="PageHead" colspan="2">
                       <span class="Left5pxPadd">
                       <asp:Label ID="lblParentMenuName" CssClass="BannerText" runat="server" Text="Auto Distribution Step Maintenance"></asp:Label>
                       </span>
                </td>
            </tr>
            <tr><td valign="top" colspan="2">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="50" class="PageBg" align="right">
                    <asp:Label ID="TableFilterLabel" runat="server" Text="Step"></asp:Label>
                    </td>
                    <td width="100" class="PageBg" align="left">
                        <asp:DropDownList ID="StepFilter" runat="server" DataSourceID="StepNames" DataTextField="StepCode" DataValueField="StepCode" >
                        </asp:DropDownList>
                        <input id="PrintHide" name="PrintHide" type="hidden"  value="Print"/>
                        <asp:HiddenField ID="PageFunc" runat="server" />
                    </td>
                    <td class="PageBg">
                        <asp:ImageButton ID="FindButt" runat="server" ImageUrl="Images/search.gif" CausesValidation="False"/>
                         <asp:ImageButton ID="AddButt" runat="server" ImageUrl="Images/newadd.gif" CausesValidation="False"/>
                       <asp:Label ID="lblErrorMessage" runat="server" CssClass="txtError"></asp:Label>
                        <asp:Label ID="lblSuccessMessage" runat="server" ForeColor="ForestGreen" Width="240px"></asp:Label>
                    </td>
                    <td align="right" class="PageBg" valign="bottom">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                        <td style="padding-left: 5px">
                            <img id="Img1" runat="server" src="Images/Print.gif" alt="Print"
                                onclick="javascript:PrintPage();" />
                            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="Images/Close.gif" 
                                PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
                        </td>
                        </tr>
                    </table>
                    </td>
                    </tr>
                </table>
                </td>
            </tr>
            <tr><td rowspan="8" valign="top" width="300">
                <asp:Panel ID="TreePanel" runat="server" Height="400px" Width="325px" BorderColor="black" BorderWidth="1" ScrollBars="Auto" Visible="false">
                    <asp:UpdatePanel ID="TreeUpdatePanel" runat="server"><ContentTemplate>
                    <table width="100%" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="redtitle2">Step Used in Process(es)
                        </td>
                    </tr>
                    <tr>
                        <td class="Left5pxPadd">
                            <asp:GridView CssClass="PageBg" ID="DependentGrid" runat="server" AutoGenerateColumns="false"  Width="80%" Visible="true" ShowHeader="false">
                                <Columns>
                                <asp:BoundField DataField="ProcessCode" ReadOnly="True" 
                                ItemStyle-HorizontalAlign="Center" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr ><td ><hr /></td></tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td class="redtitle2">Step Configuration
                        </td>
                    </tr>
                    <tr>
                        <td class="tree" >
                            <div class="Left5pxPadd">
                        <asp:TreeView ID="TreeView1" runat="server" ShowExpandCollapse="false">
                        </asp:TreeView>
                            </div>
                        </td>
                    </tr>
                     <tr>
                        <td class="Left5pxPadd">
                        <asp:ImageButton ID="DeleteButt" runat="server" ImageUrl="Images/BtnDelete.gif" CausesValidation="False" AlternateText="Delete"/>
                        </td>
                    </tr>
               </table>
                </ContentTemplate></asp:UpdatePanel>
                </asp:Panel>
                </td>
               <td align="left">
                <asp:Panel ID="StepDetailPanel" runat="server" Height="400px" Width="500" BorderColor="black" BorderWidth="1" Visible="false">
                <asp:UpdatePanel ID="StepUpdatePanel" runat="server"><ContentTemplate>
                    <table cellspacing="0" width="100%">
                        <tr class="Left5pxPadd"><td colspan="3" class="redtitle2">Step Header</td></tr>
                        <tr>
                            <td class="Left5pxPadd">Step<asp:HiddenField ID="UpdFunction" runat="server" />
                                <asp:HiddenField ID="HiddenID" runat="server" /></td>
                            <td>
                                <asp:TextBox ID="StepUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="StepValidator" runat="server" ErrorMessage="StepName is required" ControlToValidate="StepUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                         <tr>
                            <td class="Left5pxPadd">Supply HUB</td>
                            <td>
                                <asp:TextBox id="SupplyBranches" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="BranchValidator" runat="server" ErrorMessage="A Branch Number is required." 
                                ControlToValidate="SupplyBranches"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                       <tr>
                            <td class="Left5pxPadd">CFVC Range</td>
                            <td>
                                <asp:TextBox ID="CFVCUpd" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="CFVCValidator" runat="server" ErrorMessage="A range of CFVCs is required." 
                                ControlToValidate="CFVCUpd"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">ROP Multiplier</td>
                            <td>
                                <asp:TextBox ID="ROPMultiplier" runat="server"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="ROPValidator" runat="server" ErrorMessage="An ROP multiplier is required (1=No Chnage)." 
                                ControlToValidate="ROPMultiplier"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                       <tr class="PageBg">
                            <td  class="Left5pxPadd"> 
                            <asp:ImageButton ID="SaveButt" runat="server" ImageUrl="Images/accept.jpg" />
                            </td>
                            <td style="padding-left: 5px">
                            Accept will save your changes.
                            </td>
                            <td style="padding-left: 5px">
                                <asp:Label ID="ConfigStat" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr ><td colspan="3"><hr /></td></tr>
                     </table>
                    <table cellspacing="0" width="100%">
                        <tr  class="Left5pxPadd">
                            <td colspan="3" class="redtitle2">                               
                            Detail for 
                                <asp:Label ID="MasterLabel" runat="server" Text=""></asp:Label>
                        <asp:HiddenField ID="DetailFunc" runat="server" />
                           </td>
                        </tr>
                        <tr><td class="Left5pxPadd" colspan="3" >
                                <asp:GridView ID="StepDetailGrid" runat="server" AllowSorting="True" AutoGenerateColumns="False" 
                                DataKeyNames="DetailRecID" OnRowEditing="StepDetailEditHandler" OnRowDeleting="StepDetailDeleteHandler"
                                OnSorting="SortStepDetailGrid">
                                <Columns>
                                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                                <asp:BoundField DataField="StepIsHub" HeaderText="Hub" ReadOnly="True" SortExpression="StepIsHub" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="Branches" HeaderText="Branch List" ReadOnly="True" SortExpression="Branches"  ItemStyle-VerticalAlign="Middle"
                                 ItemStyle-Width="300" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left"  ItemStyle-CssClass="Left2pxPadd"/>
                                <asp:BoundField DataField="MinMaxCode" HeaderText="MinMax Code" ReadOnly="True" SortExpression="MinMaxCode" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                <asp:BoundField DataField="DetailRecID" HeaderText="ID" ReadOnly="True" SortExpression="DetailRecID" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                                </Columns>
                                </asp:GridView>
                        </td>
                        </tr>
                        <tr>
                            <td class="Left5pxPadd">
                                Is Hub: 
                            </td>
                            <td valign="top">
                                <asp:TextBox ID="StepIsHubBox" runat="server" Width="50"></asp:TextBox>
                            </td>                     
                            <td>
                            </td>
                        </tr>
                        <tr><td class="Left5pxPadd">Branches:
                        </td><td><asp:TextBox ID="DetailBranches" runat="server" Width="250"></asp:TextBox>
                        </td><td>
                        </td>
                        </tr>
                        <tr><td class="Left5pxPadd">MinMax:
                        </td><td><asp:DropDownList ID="MinMaxDropDownList" runat="server" DataSourceID="MinMaxNames" 
                             DataTextField="MinMaxCode" DataValueField="MinMaxCode">
                                </asp:DropDownList>
                        </td><td>
                        </td>
                        </tr>
                        <tr class="PageBg">
                        <td class="Left5pxPadd"> 
                         <asp:ImageButton ID="DetailAddButt" runat="server" ImageUrl="Images/newadd.gif" OnClick="DetailAddButt_Click" />
                        <asp:ImageButton ID="DetailSaveButt" runat="server" ImageUrl="Images/accept.jpg" OnClick="DetailSaveButt_Click" />
                       <asp:HiddenField ID="HiddenStepDetailID" runat="server" />
                        </td>
                        <td colspan="2">
                            <asp:Label ID="DetailStat" runat="server" Text="" ForeColor="ForestGreen" ></asp:Label>
                       </td>
                        </tr>
                    </table>
                </ContentTemplate></asp:UpdatePanel>
                </asp:Panel>
            </td></tr>
            <tr><td>
            </td></tr>
        </table>
    </ContentTemplate></asp:UpdatePanel>    
    </div>
    </form>
</body>
</html>
