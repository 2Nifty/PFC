<!--#INCLUDE file="adovbs.inc"-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<html>
<head id="Head1">
<title>Category Group Description Maintenance</title>
<link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<SCRIPT language="VBScript">
	Sub SrchCat_OnClick
		Document.frmPage1.Submit
	End Sub

	Sub UpdCat_OnClick
		Document.frmPage2.SubmitPage2.Value = "Update"
		Document.frmPage2.Submit
	End Sub

	Sub CancelCat_OnClick
		Document.frmPage2.SubmitPage2.Value = "Cancel"
		Document.frmPage2.Submit
	End Sub

	Sub DoneCat_OnClick
		Document.frmPage3.Submit
	End Sub
</SCRIPT>

<%
	Set SqlConn = Server.CreateObject("ADODB.Connection")
	SqlConn.Provider = "sqloledb"
	SqlConn.Open Application("SqlPFCRPTConnection")

	Set CatRecs = Server.CreateObject("ADODB.Recordset")
	CatRecs.ActiveConnection = SqlConn

	Set SqlRecs = Server.CreateObject("ADODB.Recordset")
	SqlRecs.ActiveConnection = SqlConn

	CatMsg = ""
%>
</head>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<% IF Request.Form("SubmitPage1") = "Submit" AND Request.Form("SubmitPage2") <> "Update" THEN
	CatMsg = ""
	Sel = "SELECT * FROM CAS_CatGrpDesc WHERE Category='" & Request.Form("iCatNo") & "'"
	CatRecs.Open Sel, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
	IF CatRecs.eof THEN
		CatMsg = "Invalid Category"
	ELSE %>
		<body topmargin=0><TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 align=center>
		<col width=20%><col width=20%><col width=20%><col width=5%> <col width=25%>
		<TR>
			<TD colspan=5 height="97" valign="top" class="BannerBg"><div width=100% class="bannerImg"></div></TD>
		</TR>
		<TR>
			<TD class="PageHead" colspan=5><span id="lblParentMenuName" class="BannerText"><div class="LeftPadding">PFC Category Group Description Maintenence: <%= CatRecs("Category")%></div></span></TD>
		</TR>
		<TR><TD colspan=5><br></TD></TR>
		<!-- Display database fields and prompt for changes -->
		<TR><form method="post" name="frmPage2">
			<TD colspan=3 align=right><b>Current Values</b></TD>
			<TD></TD>
			<TD rowspan=41 valign=top>
<!--			HELP BUTTON

				<span class=notice>The Tab key will move you from field to field. DO NOT USE THE ENTER KEY! Shift-Tab
				will move you backwards through the fields.</span><P>
				Fill out the form for Sales Management Data.
-->
			</TD>
		</TR>

<!--Group Number & Description-->
		<TR>
			<TD>&nbsp&nbsp&nbspGroup</TD>

			<% Sel = "SELECT DISTINCT GroupNo, Description FROM CAS_CatGrpDesc ORDER BY GroupNo"
				SqlRecs.Open Sel, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF SqlRecs.eof THEN %>
					<TD>Category Group Data Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iCatGroup name=iCatGroup>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("GroupNo") %>"><%= SqlRecs("GroupNo") %> - <%= SqlRecs("Description") %></OPTION>
							<% SqlRecs.MoveNext
						loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CatRecs("GroupNo")%> - <%= CatRecs("Description") %></TD>
			<INPUT type="hidden" id=sCatGroup name=sCatGroup value="<%= CatRecs("GroupNo")%>">
			<INPUT type="hidden" id=sCatDesc name=sCatDesc value="<%= CatRecs("Description")%>">
		</TR>

<!--Months Buy Factor -->
		<TR>
			<TD>&nbsp&nbsp&nbspMonths Buy Factor</TD>
			<TD align=right><INPUT type="text" id=iCatFactor name=iCatFactor></TD>
			<TD align=right><%= CatRecs("MonthsBuyFactor")%></TD>
			<INPUT type="hidden" id=sCatFactor name=sCatFactor value="<%= CatRecs("MonthsBuyFactor")%>">
		</TR>

		<TR>
			<TD>
				<INPUT type="hidden" id=iCatNo name=iCatNo value="<%= Request.Form("iCatNo")%>">
				<INPUT type="hidden" value="Update" id="SubmitPage2" name="SubmitPage2">
			</TD>
		</TR></form>

	<TR>
		<TD class="BluBg" colspan=5>
			<div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle">
				<img id="UpdCat" name="UpdCat" src="Common\Images\update.gif" style="cursor:hand" />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<img id="CancelCat" name="CancelCat" src="Common\Images\cancel.gif" style="cursor:hand" />
			</span></div>
		</TD>
	</TR>
	</body>
	<% END IF %>
<% END IF %>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<% IF (Request.Form("SubmitPage1") <> "Submit" AND Request.Form("SubmitPage2") <> "Update") OR (CatMsg <> "") THEN %>
	<BODY topmargin=0><TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 align=center>
	<col width=5%><col width=10%><col width=20%><col width=5%><col width=25%>
	<TR>
		<TD colspan=5 height="97" valign="top" class="BannerBg"><div class="bannerImg"></div></TD>
	</TR>
	<TR>
		<TD class="PageHead" colspan=5><span id="lblParentMenuName" class="BannerText"><div class="LeftPadding">PFC Category Group Description Maintenence</div></span></TD>
	</TR>
	<TR><form method="post" name="frmPage1">
<!--		<TD>Hello <%= request.ServerVariables("local_addr") %></TD> -->
	</TR>
	<TR>
		<TD><div class="LeftPadding">Category Number</div></TD>
		<TD>
			<INPUT type="hidden" value="1" id=UpdCat name=UpdCat>
			<INPUT type="hidden" value="Submit" id="SubmitPage1" name="SubmitPage1">
			<INPUT type="text" name="iCatNo" />

		</TD>
		<TD><%= CatMsg %></TD>
	</TR></form>

	<TR>
		<TD class="BluBg" colspan=5>
			<div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle">
				<img id="SrchCat" name="SrchCat" src="Common/Images/next.gif" style="cursor:hand" />
			</span></div>
		</TD>
	</TR>

	</TABLE>
	</BODY>
<% END IF %>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<!--Update the NV Database Fields -->
<%
	IF (Request.Form("SubmitPage2")="Update") THEN

		UpdFlg = "FALSE"

		Upd = "UPDATE CAS_CatGrpDesc SET "

<!--Group Number & Description-->
		IF Request.Form("iCatGroup") <> "" THEN
			Upd = Upd & "[GroupNo]='" &  Request.Form("iCatGroup") & "'"
			Sel = "SELECT Description FROM CAS_CatGrpDesc WHERE GroupNo='" & Request.Form("iCatGroup") & "'"
<!--		Response.Write Sel -->
			SqlRecs.Open Sel, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
			IF NOT SqlRecs.eof THEN
				UPD = UPD & ", [Description]='" & SqlRecs("Description") & "'"
			END IF
			SqlRecs.close
			UpdFlg = "TRUE"
		END IF

<!--Months Buy Factor -->
		IF Request.Form("iCatFactor") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[MonthsBuyFactor]='" &  Request.Form("iCatFactor") & "'"
			UpdFlg = "TRUE"
		END IF

		IF UpdFlg = "TRUE" THEN
			Upd = Upd & " WHERE Category='" & Request.Form("iCatNo") & "'"
<!--		Response.Write UPD -->
			CatRecs.Open UPD, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
<!-- Insert a log record in PFCReports -->

			Ins = "INSERT INTO CatGroupDescChangeLog (CategoryNo,oldCatGroupNo,newCatGroupNo,oldMthBuyFactor,newMthBuyFactor,ChangeID,ChangeDt) "
			Ins = Ins & "VALUES ('"
			Ins = Ins & Request.Form("iCatNo")
			Ins = Ins & "','"
			Ins = Ins & Request.Form("sCatGroup")
			Ins = Ins & "','"
			Ins = Ins & Request.Form("iCatGroup")
			Ins = Ins & "','"
			Ins = Ins & Request.Form("sCatFactor")
			Ins = Ins & "','"
			Ins = Ins & Request.Form("iCatFactor")
			Ins = Ins & "','"
			Ins = Ins & Request.ServerVariables("local_addr")
			Ins = Ins & "','"
			Ins = Ins & NOW
			Ins = Ins & "')"

<!--		Response.Write Ins -->
			SqlRecs.Open Ins, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
		END IF
%>
		<TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 align=center>
		<col width=20%><col width=20%><col width=20%><col width=5%> <col width=25%>
		<TR>
			<TD colspan=5 height="97"  valign="top" class="BannerBg"><div class="bannerImg"></div></TD>
		</TR>
		<TR>
			<TD class="PageHead" colspan=5>
				<FORM method="post" name="frmPage3">
					<INPUT type="hidden" value="0" id=UpdCat name=UpdCat>
					<INPUT type="hidden" value="Continue" id=SubmitPage3 name=SubmitPage3>
				</FORM>
				<span id="lblParentMenuName" class="BannerText">
				<div class="LeftPadding">
					<% IF UpdFlg = "TRUE" THEN %>
						Category Desc Updated: <%= Request.Form("iCatNo") %>
					<% ELSE %>
						Nothing to update: <%= Request.Form("iCatNo") %>
					<% End IF %>
				</div>
				<div align="right">
					<img id="DoneCat" name="DoneCat" src="Common\Images\done.gif" style="cursor:hand" />
				</div>
				</span>
			</TD>
		</TR>
		</TABLE>
<%	END IF %>

</table>
</html>