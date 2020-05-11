<!--#INCLUDE file="adovbs.inc"-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head id="Head1">
<title>Standard Cost Update</title>
<link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<SCRIPT LANGUAGE='VBScript'>
	Sub CostUpdate_OnClick
		Document.form1.Submit
	End Sub
</SCRIPT>

<%
	Set SqlConn = Server.CreateObject("ADODB.Connection")
	SqlConn.Provider = "sqloledb"
	SqlConn.Open Application("SqlNVConnection")

	Set SqlRecs = Server.CreateObject("ADODB.Recordset")
	SqlRecs.ActiveConnection = SqlConn
%>

</head>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<% IF (Request.Form("SubmitDTS") = "Submit") THEN %>

<body topmargin=0>
	 <TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 align=center>
	 <col width=20%><col width=20%><col width=20%><col width=5%> <col width=25%>
	  <TR>
		<TD colspan=5 height="97" valign="top" class="BannerBg"><div width=100% class="bannerImg"></div></TD>
	  </TR>
	  <TR>
		<TD class="PageHead" colspan=5><span id="lblParentMenuName" class="BannerText"><div class="LeftPadding">PFC Standard Cost Update</div></span></TD>
	  </TR>
	  <TR>
		<TD class="LeftPadding" colspan=5><br><big>Standard Cost updated</big><br><br></TD>
	  </TR>

<%
	Upd = "UPDATE [Porteous$Stockkeeping Unit] SET [Standard Cost] = [Unit Cost] WHERE (SUBSTRING([Item No_], 12, 1) = '4') OR (SUBSTRING([Item No_], 12, 1) = '6') OR (SUBSTRING([Item No_], 12, 1) = '7') OR (SUBSTRING([Item No_], 12, 1) = '8') OR (SUBSTRING([Item No_], 12, 1) = '9') AND ([Unit Cost] <> '0')"

	<!--	Response.Write UPD -->
	SQLRecs.Open UPD, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
%>

	  <TR><form method="post" name="form1">
		<TD class="LeftPadding" colspan=5>
		<INPUT type="hidden" value="" id="SubmitDTS" name="SubmitDTS"></TD>
	  </TR></form>
	  <TR>
		<TD class="BluBg" colspan=5>
			<div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle">
				<img id="CostUpdate" name="CostUpdate" src="Common/Images/done.gif" style="cursor:hand" />
			</span></div>
		</TD>
	  </TR>

	 </TABLE>
</body>

<% ELSE %>
<body topmargin=0>
	 <TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 align=center>
	 <col width=20%><col width=20%><col width=20%><col width=5%> <col width=25%>
	  <TR>
		<TD colspan=5 height="97" valign="top" class="BannerBg"><div width=100% class="bannerImg"></div></TD>
	  </TR>
	  <TR>
		<TD class="PageHead" colspan=5><span id="lblParentMenuName" class="BannerText"><div class="LeftPadding">PFC Standard Cost Update</div></span></TD>
	  </TR>
	  <TR><form method="post" name="form1">
		<TD class="LeftPadding" colspan=5>
		<p><br><big>This process updates Standard Cost for Package Items (items ending in 4??, 6??, 7??, 8??, or 9??)<br>
		   Standard Cost is set to equal Unit Cost for all items where Unit Cost is not zero.<br><br>
		   Press the <i>Next Button</i> to execute the update.  The process may take a few minutes.</big><br><br></p>
		<INPUT type="hidden" value="Submit" id="SubmitDTS" name="SubmitDTS"></TD>
	  </TR></form>
	  <TR>
		<TD class="BluBg" colspan=5>
			<div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<img id="CostUpdate" name="CostUpdate" src="Common/Images/next.gif" style="cursor:hand" />
			</span></div>
		</TD>
	  </TR>
	 </TABLE>
</body>
<%END IF%>
</html>