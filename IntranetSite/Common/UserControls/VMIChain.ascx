<%@ Control Language="C#" AutoEventWireup="true" CodeFile="VMIChain.ascx.cs" Inherits="VMIChain" %>
<%@ OutputCache Duration="3600" VaryByparam = "none" %>

<TABLE class="HeaderBGColor" id="Table1" height="30" cellSpacing="0" cellPadding="0" width="100%">
	<TR>
		<TD vAlign="middle" align="left" colSpan="2" height="10"><asp:dropdownlist id="ddlChain" runat="server" CssClass="cnt" Width="130px" AutoPostBack="false" TabIndex="0" onchange="BindSelectedValue();"></asp:dropdownlist>
		<asp:CompareValidator ID="cmpChain" CssClass="Required" ControlToValidate="ddlChain" ErrorMessage="* Required" ValueToCompare="0" Operator="notEqual" Display="dynamic" runat="server"></asp:CompareValidator>
		<asp:HiddenField ID="hidChain" runat="server" Value=""/>
		</TD>
	</TR>
</TABLE>