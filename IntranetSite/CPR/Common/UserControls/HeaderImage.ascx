<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HeaderImage.ascx.cs" Inherits="Common_UserControls_HeaderImage" %>
<%@ OutputCache Duration="3600" VaryByparam = "none" %>
        <div id="userInfo" style="color:#ffffff;"  class="HeaderImagebg">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" >
        <col width="25%" /><col width="50%" /><col width="25%" />
        <tr>
            <td>
            <asp:RadioButton ID="LongReport" GroupName="GridLength"  Text="Long" runat="server" OnCheckedChanged="Report_CheckedChanged" 
                AutoPostBack="true" />
            <asp:RadioButton ID="ShortReport"  GroupName="GridLength"  Text="Short" runat="server"  OnCheckedChanged="Report_CheckedChanged" 
                AutoPostBack="true" />

            </td>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" >
                    <tr >
                        
                        <td align="right">                        
                            <asp:Image ID="imgHeaderLeft" runat=server ImageUrl="~/Common/Images/userinfo_left.gif" Width="11" Height="25" />
                        </td>
                        <td class="userinfobg" style="padding-right:5px">
                            <asp:Image ID="lblDate" runat=server ImageUrl="~/Common/Images/clock.gif" ></asp:Image>
                        </td>
                        <td class="userinfobg" style="padding-left:1px">                        
                            <asp:Label ID="lblUserInfo" runat="server"></asp:Label>
                        </td>
                        <td align="left">
                         <asp:Image ID="Image1" runat=server ImageUrl="~/Common/Images/userinfo_right.gif" Width="11" Height="25" />
                         </td>
                    </tr>
                </table>
            </td>
            <td>
            <asp:ImageButton ID="CloseButton" runat="server" ImageUrl="~/Common/Images/Close.gif" 
                PostBackUrl="javascript:window.close();"  CausesValidation="false"/>
            <img id="Img1" runat="server" src="~/Common/Images/print.gif" alt="Print"
                onclick="javascript:PrintCPR();" />
            </td>
        </tr>
        </table>
        </div>
