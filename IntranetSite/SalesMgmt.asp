<!--#INCLUDE file="adovbs.inc"-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<html>
<head id="Head1">
<title>Customer Sales Management</title>
<link href="Common/StyleSheet/Styles.css" rel="stylesheet" type="text/css" />

<SCRIPT language="VBScript">

	Sub SrchCust_OnClick
		Document.frmPage1.Submit
	End Sub

	Sub UpdCust_OnClick
		Document.frmPage2.SubmitPage2.Value = "Update"
		Document.frmPage2.Submit
	End Sub

	Sub CancelCust_OnClick
		Document.frmPage2.SubmitPage2.Value = "Cancel"
		Document.frmPage2.Submit
	End Sub

	Sub DoneCust_OnClick
		Document.frmPage3.Submit
	End Sub
</SCRIPT>

<%
	Set ERPConn = Server.CreateObject("ADODB.Connection")
	ERPConn.Provider = "sqloledb"
	ERPConn.Open Application("PFCERPConnectionString")

	Set ERPRecs = Server.CreateObject("ADODB.Recordset")
	ERPRecs.ActiveConnection = ERpConn

	Set SqlConn = Server.CreateObject("ADODB.Connection")
	SqlConn.Provider = "sqloledb"
	SqlConn.Open Application("SqlNV5Connection")

	Set SqlRecs = Server.CreateObject("ADODB.Recordset")
	SqlRecs.ActiveConnection = SqlConn

	Set CustRecs = Server.CreateObject("ADODB.Recordset")
	CustRecs.ActiveConnection = SqlConn

	Set SqlLogConn = Server.CreateObject("ADODB.Connection")
	SqlLogConn.Provider = "sqloledb"
	SqlLogConn.Open Application("SqlPFCRPTConnection")

	Set LogRecs = Server.CreateObject("ADODB.Recordset")
	LogRecs.ActiveConnection = SqlLogConn

	CustMsg = ""
%>
</head>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<% IF Request.Form("SubmitPage1") = "Submit" AND Request.Form("SubmitPage2") <> "Update" THEN
	CustMsg = ""
	Sel = "SELECT * FROM Porteous$Customer (NoLock) WHERE No_='" & Request.Form("iCustNo") & "'"
	CustRecs.Open Sel, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
	IF CustRecs.eof THEN
		CustMsg = "Invalid Customer"
	ELSE %>
		<body topmargin=0><TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 align=center>
		<col width=20%><col width=20%><col width=20%><col width=5%> <col width=25%>
		<TR>
			<TD colspan=5 height="97" valign="top" class="BannerBg"><div width=100% class="bannerImg"></div></TD>
		</TR>
		<TR>
			<TD class="PageHead" colspan=5><span id="lblParentMenuName" class="BannerText"><div class="LeftPadding">PFC Customer Sales Management Update: <%= CustRecs("No_")%> - <%= CustRecs("Name")%></div></span></TD>
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

<!--Inside Salesperson -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Inside Salesperson</TD>
			<% Sel = "SELECT * FROM Porteous$Salesperson_Purchaser (NoLock) where [Inside Sales] = 1 ORDER BY Code"
				SqlRecs.Open Sel, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF SqlRecs.eof THEN %>
					<TD>Salesperson Data Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iSalesperson name=iSalesperson>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("Code") %>"><%= SqlRecs("Code") %> - <%= SqlRecs("Name") %></OPTION>
							<% SqlRecs.MoveNext
						loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("Inside Salesperson")%></TD>
			<INPUT type="hidden" id=sSalesPerson name=sSalesPerson value="<%= CustRecs("Inside Salesperson")%>">
		</TR>

<!--Area Sales Manager -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Area Sales Manager</TD>
			<% Sel = "SELECT * FROM Porteous$Salesperson_Purchaser (NoLock) where [Code] BETWEEN '0000' AND '9999' AND [E-Mail] is not null AND [E-Mail] <> '' ORDER BY Code"
				SqlRecs.Open Sel, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF SqlRecs.eof THEN %>
					<TD>Salesperson Data Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iAreaMgr name=iAreaMgr>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("Code") %>"><%= SqlRecs("Code") %> - <%= SqlRecs("Name") %></OPTION>
							<% SqlRecs.MoveNext
						loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("Salesperson Code")%></TD>
			<INPUT type="hidden" id=sAreaMgr name=sAreaMgr value="<%= CustRecs("Salesperson Code")%>">
		</TR>

<!-- Backorder -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Backorder</TD>
			<TD><SELECT id=iBackorder name=iBackorder>
				<OPTION value=''></OPTION>
				<OPTION value="0">(0)  7 - Cancel after 7 days</OPTION>
				<OPTION value="1">(1)  N - Ship & Cancel</OPTION>
				<OPTION value="2">(2)  Y - Backorder</OPTION>
				<OPTION value="3">(3) 14 - Cancel after 14 days</OPTION>
				<OPTION value="4">(4) 21 - Cancel after 21 days</OPTION>
			</SELECT></TD>
			<TD align=right><%= CustRecs("Backorder")%></TD>
			<INPUT type="hidden" id=sBackorder name=sBackorder value="<%= CustRecs("Backorder")%>">
		</TR>

<!-- Usage Location -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Usage Location</TD>
			<% Sel = "SELECT * FROM Porteous$Location (NoLock) ORDER BY Code"
			   SqlRecs.Open Sel, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
			   IF SqlRecs.eof THEN %>
					<TD>Location Data Bug. Call MIS.</TD>
			   <% ELSE %>
					<TD><SELECT id=iUsageLoc name=iUsageLoc>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("Code") %>"><%= SqlRecs("Code") %> - <%= SqlRecs("Name 2") %></OPTION>
							<% SqlRecs.MoveNext
						loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("Usage Location")%></TD>
			<INPUT type="hidden" id=sUsageLoc name=sUsageLoc value="<%= CustRecs("Usage Location")%>">
		</TR>

<!-- Shipping Location -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Shipping Location</TD>
			<% Sel = "SELECT * FROM Porteous$Location (NoLock) ORDER BY Code"
			   SqlRecs.Open Sel, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
			   IF SqlRecs.eof THEN %>
					<TD>Location Data Bug. Call MIS.</TD>
			   <% ELSE %>
					<TD><SELECT id=iShipLoc name=iShipLoc>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("Code") %>"><%= SqlRecs("Code") %> - <%= SqlRecs("Name 2") %></OPTION>
							<% SqlRecs.MoveNext
				    	loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("Shipping Location")%></TD>
			<INPUT type="hidden" id=sShipLoc name=sShipLoc value="<%= CustRecs("Shipping Location")%>">
		</TR>

<!-- Ship Agent Code -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Ship Agent Code</TD>
			<% SEL = "SELECT * from [Porteous$Shipping Agent] (NoLock) ORDER BY Code"
				SqlRecs.Open SEL, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF SqlRecs.eof THEN %>
					<TD>Shipping Agent Data Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iShipAgent name=iShipAgent>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("Code") %>"><%= SqlRecs("Code") %> - <%= SqlRecs("Name") %></OPTION>
							<% SqlRecs.MoveNext
						loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("Shipping Agent Code")%></TD>
			<INPUT type="hidden" id=sShipAgent name=sShipAgent value="<%= CustRecs("Shipping Agent Code")%>">
		</TR>

<!-- E-Ship Agent Service -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;E-Ship Agent Service</TD>
<!-- How can I filter this by the Shipping Agent selected above? -->
			<% IF iShipagent <> "" THEN
					SEL = "SELECT * FROM [Porteous$E-Ship Agent Service] (NoLock) WHERE [Shipping Agent Code]='"
					SEL = SEL & iShipAgent
					SEL = SEL & "'"
				ELSE
					SEL = "SELECT * FROM [Porteous$E-Ship Agent Service] (NoLock) ORDER BY [Shipping Agent Code]"
				END IF
				SqlRecs.Open SEL, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF SqlRecs.eof THEN %>
					<TD>Shipping Agent Services Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iShipAgentService name=iShipAgentService>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("Code") %>"><%= SqlRecs("Shipping Agent Code") %> - <%= SqlRecs("Description") %></OPTION>
							<% SqlRecs.MoveNext
						loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("E-Ship Agent Service")%></TD>
			<INPUT type="hidden" id=sShipAgentService name=sShipAgentService value="<%= CustRecs("E-Ship Agent Service")%>">
		</TR>

<!-- Ship Method Code -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Ship Method Code</TD>
			<% SEL = "SELECT * FROM [Porteous$Shipment Method] (NoLock) ORDER BY Code"
				SqlRecs.Open SEL, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF SqlRecs.eof THEN %>
					<TD>Shipment Method Data Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iShipMethod name=iShipMethod>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("Code") %>"><%= SqlRecs("Code") %> - <%= SqlRecs("Description") %></OPTION>
							<% SqlRecs.MoveNext
						loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("Shipment Method Code")%></TD>
			<INPUT type="hidden" id=sShipMethod name=sShipMethod value="<%= CustRecs("Shipment Method Code")%>">
		</TR>

<!-- Free Freight -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Free Freight</TD>
			<TD><SELECT id=iFreeFreight name=iFreeFreight>
				<OPTION value=''></OPTION>
				<OPTION value="0">0 - No</OPTION>
				<OPTION value="1">1 - Yes</OPTION>
			</SELECT></TD>
			<TD align=right><%= CustRecs("Free Freight")%></TD>
			<INPUT type="hidden" id=sFreeFreight name=sFreeFreight value="<%= CustRecs("Free Freight")%>">
		</TR>

<!-- Ship Payment Type -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Ship Payment Type</TD>
			<TD><SELECT id=iSPayType name=iSPayType>
				<OPTION value=''></OPTION>
				<OPTION value="0">0 - Prepaid</OPTION>
				<OPTION value="1">1 - Third Party</OPTION>
				<OPTION value="2">2 - Freight Collect</OPTION>
				<OPTION value="3">3 - Consignee</OPTION>
			</SELECT></TD>
			<TD align=right><%= CustRecs("Shipping Payment Type")%></TD>
			<INPUT type="hidden" id=sSPayType name=sSPayType value="<%= CustRecs("Shipping Payment Type")%>">
		</TR>

<!-- Chain Name -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Chain Name</TD>
			<% SEL = "SELECT * FROM [Porteous$Chain Name] (NoLock) ORDER BY Code"
				SqlRecs.Open SEL, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF SqlRecs.eof THEN %>
					<TD>Chain Name Data Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iChainName name=iChainName>
						<OPTION value=''></OPTION>
						<% do while not SqlRecs.eof %>
							<OPTION value="<%= SqlRecs("Code") %>"><%= SqlRecs("Code") %> - <%= SqlRecs("Name") %></OPTION>
							<% SqlRecs.MoveNext
						loop
				END IF
				SqlRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("Chain Name")%></TD>
			<INPUT type="hidden" id=sChainName name=sChainName value="<%= CustRecs("Chain Name")%>">
		</TR>

<!-- Customer Price Code -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Customer Price Code</TD>
			<TD><input id="iPriceCode" name="iPriceCode" type="text" size="1" maxlength=1 /></TD>
			<TD align=right><%= CustRecs("Customer Price Code")%></TD>
			<INPUT type="hidden" id=sPriceCode name=sPriceCode value="<%= CustRecs("Customer Price Code")%>">
		</TR>

<!-- Invoice Sort Order -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Invoice Sort Order</TD>
			<% SEL = "SELECT SequenceNo AS SeqNo, CAST(SequenceNo AS VARCHAR(10)) + ' - ' + ListDtlDesc + ' (' + ListValue + ')' AS Descr FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID = fListMasterID WHERE ListName='InvoiceSortOrd' ORDER BY SeqNo"
				ERPRecs.Open SEL, ERPConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF ERPRecs.eof THEN %>
					<TD>ERP List Data Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iInvSortOrd name=iInvSortOrd>
						<OPTION value=''></OPTION>
						<% do while not ERPRecs.eof %>
							<OPTION value="<%= ERPRecs("SeqNo") %>"><%= ERPRecs("Descr") %></OPTION>
							<% ERPRecs.MoveNext
						loop
				END IF
				ERPRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("Invoice Detail Sort")%></TD>
			<INPUT type="hidden" id=sInvSortOrd name=sInvSortOrd value="<%= CustRecs("Invoice Detail Sort")%>">
		</TR>
		
<!-- Sales Territory -->
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;Sales Territory</TD>
			<% SEL = "SELECT SequenceNo AS SeqNo, ListValue AS Value, ListValue + ' - ' + ListDtlDesc AS Descr FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID = fListMasterID WHERE ListName='SalesTerritory' ORDER BY SeqNo"
				ERPRecs.Open SEL, ERPConn, adOpenStatic, adLockReadOnly, AdCmdtext
				IF ERPRecs.eof THEN %>
					<TD>ERP List Data Bug. Call MIS.</TD>
				<% ELSE %>
					<TD><SELECT id=iSlsTerr name=iSlsTerr>
						<OPTION value=''></OPTION>
						<% do while not ERPRecs.eof %>
							<OPTION value="<%= ERPRecs("Value") %>"><%= ERPRecs("Descr") %></OPTION>
							<% ERPRecs.MoveNext
						loop
				END IF
				ERPRecs.close %>
					</SELECT></TD>
			<TD align=right><%= CustRecs("SalesTerritory")%></TD>
			<INPUT type="hidden" id=sSlsTerr name=sSlsTerr value="<%= CustRecs("SalesTerritory")%>">
		</TR>
		
		<TR>
			<TD>
				<INPUT type="hidden" id=iCustNo name=iCustNo value="<%= Request.Form("iCustNo")%>">
				<INPUT type="hidden" id=iCustName name=iCustName value="<%= CustRecs("Name")%>">
				<INPUT type="hidden" id="SubmitPage2" name="SubmitPage2" value="Update">
			</TD>
		</TR></form>

	<TR>
		<TD class="BluBg" colspan=5>
			<div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle">
				<img id="UpdCust" name="UpdCust" src="Common\Images\update.gif" style="cursor:hand" />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<img id="CancelCust" name="CancelCust" src="Common\Images\cancel.gif" style="cursor:hand" />
			</span></div>
		</TD>
	</TR>
	</body>
	<% END IF %>
<% END IF %>

<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

<% IF (Request.Form("SubmitPage1") <> "Submit" AND Request.Form("SubmitPage2") <> "Update") OR (CustMsg <> "") THEN %>
	<BODY topmargin=0><TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 align=center>
	<col width=5%><col width=10%><col width=20%><col width=5%><col width=25%>
	<TR>
		<TD colspan=5 height="97" valign="top" class="BannerBg"><div class="bannerImg"></div></TD>
	</TR>
	<TR>
		<TD class="PageHead" colspan=5><span id="lblParentMenuName" class="BannerText"><div class="LeftPadding">PFC Customer Sales Management Update</div></span></TD>
	</TR>
	<TR><form method="post" name="frmPage1">
<!--		<TD>Hello <%= request.ServerVariables("local_addr") %></TD> -->
	</TR>
	<TR>
		<TD><div class="LeftPadding">Customer Number</div></TD>
		<TD>
			<INPUT type="hidden" value="1" id=UpdCust name=UpdCust>
			<INPUT type="hidden" value="Submit" id="SubmitPage1" name="SubmitPage1">
			<INPUT type="text" name="iCustNo" />

		</TD>
		<TD><%= CustMsg %></TD>
	</TR></form>

	<TR>
		<TD class="BluBg" colspan=5>
			<div class="LeftPadding"><span class="LeftPadding" style="vertical-align:middle">
				<img id="SrchCust" name="SrchCust" src="Common/Images/next.gif" style="cursor:hand" />
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

		Upd = "UPDATE Porteous$Customer SET "

		IF Request.Form("iSalesperson") <> "" THEN
			Upd = Upd & "[Inside Salesperson]='" &  Request.Form("iSalesperson") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iAreaMgr") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Salesperson Code]='" &  Request.Form("iAreaMgr") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iBackorder") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Backorder]='" &  Request.Form("iBackorder") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iUsageLoc") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Usage Location]='" &  Request.Form("iUsageLoc") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iShipLoc") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Shipping Location]='" &  Request.Form("iShipLoc") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iShipAgent") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Shipping Agent Code]='" &  Request.Form("iShipAgent") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iShipAgentService") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[E-Ship Agent Service]='" &  Request.Form("iShipAgentService") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iShipMethod") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Shipment Method Code]='" &  Request.Form("iShipMethod") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iFreeFreight") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Free Freight]='" &  Request.Form("iFreeFreight") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iPayType") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Shipping Payment Type]='" &  Request.Form("iPayType") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iChainName") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Chain Name]='" &  Request.Form("iChainName") & "'"
			UpdFlg = "TRUE"
		END IF

		IF Request.Form("iPriceCode") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Customer Price Code]='" &  UCase(Request.Form("iPriceCode")) & "'"
			UpdFlg = "TRUE"
		END IF

	    IF Request.Form("iInvSortOrd") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[Invoice Detail Sort]='" &  Request.Form("iInvSortOrd") & "'"
			UpdFlg = "TRUE"
		END IF

	    IF Request.Form("iSlsTerr") <> "" THEN
			IF UpdFlg = "TRUE" THEN
				UPD = UPD & ", "
			END IF
			Upd = Upd & "[SalesTerritory]='" &  Request.Form("iSlsTerr") & "'"
			UpdFlg = "TRUE"
		END IF

		IF UpdFlg = "TRUE" THEN
            Upd = Upd & ", [Last Date Modified]=CAST(DATEPART(yyyy,GetDate()) as varchar(4)) + '-' + CAST(DATEPART(mm,GetDate()) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,GetDate()) AS varchar(2))"
            Upd = Upd & ", [Last Modified By]='" & UCase(Request.QueryString("User")) & "'"
			Upd = Upd & " WHERE No_='" & Request.Form("iCustNo") & "'"
<!--		Response.Write UPD -->
			CustRecs.Open UPD, SqlConn, adOpenStatic, adLockReadOnly, AdCmdtext

<!-- Insert a log record in PFCReports -->
			YYYY = Year(Date)

			IF Month(Date) < 10 THEN
				MM = "0" & Month(Date)
			ELSE
				MM = Month(Date)
			END IF

			IF Day(Date) < 10 THEN
				DD = "0" & Day(Date)
			ELSE
				DD = Day(Date)
			END IF

			IF Hour(Time) < 10 THEN
				HH = "0" & Hour(Time)
			ELSE
				HH = Hour(Time)
			END IF

			IF Minute(Time) < 10 THEN
				MN = "0" & Minute(Time)
			ELSE
				MN = Minute(Time)
			END IF

			IF Second(Time) < 10 THEN
				SS = "0" & Second(Time)
			ELSE
				SS = Second(Time)
			END IF

			Ins = "INSERT INTO CustSM_ChangeLog VALUES ('"
			Ins = Ins & YYYY & MM & DD & HH & MN & SS
			Ins = Ins & "', '"
			Ins = Ins & Request.ServerVariables("local_addr")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iCustNo")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sSalesperson")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iSalesperson")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sBackorder")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iBackorder")
			Ins = Ins & "', 'n/a', 'n/a', 'n/a', 'n/a', '"
			Ins = Ins & Request.Form("sUsageLoc")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iUsageLoc")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sShipLoc")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iShipLoc")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sShipAgent")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iShipAgent")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sShipAgentService")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iShipAgentService")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sShipMethod")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iShipMethod")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sFreeFreight")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iFreeFreight")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sPayType")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iPayType")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sChainName")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iChainName")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("sPriceCode")
			Ins = Ins & "', '"
			Ins = Ins & Request.Form("iPriceCode")
			Ins = Ins & "')"
<!--		Response.Write Ins -->
			LogRecs.Open Ins, SqlLogConn, adOpenStatic, adLockReadOnly, AdCmdtext
		END IF
%>
		<br><br>
		<TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=1 align=center>
		<col width=20%><col width=20%><col width=20%><col width=5%> <col width=25%>
		<TR>
			<TD colspan=5 height="97"  valign="top" class="BannerBg"><div class="bannerImg"></div></TD>
		</TR>
		<TR>
			<TD class="PageHead" colspan=5>
				<FORM method="post" name="frmPage3">
					<INPUT type="hidden" value="0" id=UpdCust name=UpdCust>
					<INPUT type="hidden" value="Continue" id=SubmitPage3 name=SubmitPage3>
				</FORM>
				<span id="lblParentMenuName" class="BannerText">
				<div class="LeftPadding">
					<% IF UpdFlg = "TRUE" THEN %>
						Customer Updated: <%= Request.Form("iCustNo") %> - <%= Request.Form("iCustName")%>
					<% ELSE %>
						Nothing to update: <%= Request.Form("iCustNo") %> - <%= Request.Form("iCustName")%>
					<% End IF %>
				</div>
				<div align="right">
					<img id="DoneCust" name="DoneCust" src="Common\Images\done.gif" style="cursor:hand" />
				</div>
				</span>
			</TD>
		</TR>
		</TABLE>
<%	END IF %>

</table>
</html>