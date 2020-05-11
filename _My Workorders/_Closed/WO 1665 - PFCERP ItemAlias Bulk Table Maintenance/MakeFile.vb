'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************

Function Main()
Dim ExcQuery, EmailQuery, ExcFile, ColCount, Header, Detail, User, Email

Set ExcCnx = CreateObject("ADODB.Connection")
Set EmailCnx = CreateObject("ADODB.Connection")
Set fso = CreateObject("Scripting.FileSystemObject")

ExcCnx.Provider = "sqloledb"
ExcCnx.ConnectionString = "server=PFCDEVDB;uid=PfcNormal;pwd=pfcnormal;"
ExcCnx.CommandTimeout = 0
ExcCnx.Open
ExcCnx.DefaultDatabase = "DEVPERP"
ExcQuery = "SELECT ExcReason AS Error, ItemNo AS Item, AliasItemNo AS XRef, AliasWhseNo, AliasDesc, AliasType, "
ExcQuery = ExcQuery + "UOM, CustBinLoc, CustClassCd, CustomerUPC, OrganizationNo, EntryID, EntryDt FROM tItemAliasUploadExceptions"
Set ExcRec = ExcCnx.execute(ExcQuery)

EmailCnx.Provider = "sqloledb"
EmailCnx.ConnectionString = "server=PFCDEVDB;uid=PfcNormal;pwd=pfcnormal;"
EmailCnx.CommandTimeout = 0
EmailCnx.Open
EmailCnx.DefaultDatabase = "DEVPERP"

'Makefile - http://dev-notes.com/code.php?q=18
'Column Headers
for ColCount = 0 to ExcRec.fields.count -3
	if ColCount <> ExcRec.fields.count -3 then
		Header = Header + """" & ExcRec.fields(ColCount).name & ""","
	else
		Header = Header + """" & ExcRec.fields(ColCount).name & """"
	end if
next

User = ExcRec.Fields("EntryID").value
ExcFile = "\\pfcfiles\Userdb\" & User & "test.csv"
Set CSVFile = fso.createtextfile(ExcFile)
CSVFile.writeline Header

EmailQuery = "SELECT UserName, EmailAddress FROM SecurityUsers WHERE UserName='" & User & "'"
Set EmailRec = EmailCnx.execute(EmailQuery)
Email = EmailRec.fields("EmailAddress").value

'Read loop
do while not ExcRec.eof
	if User <> ExcRec.Fields("EntryID") then
		CSVFile.close
		Set CSVFile = nothing
		Set objEmail = CreateObject("CDO.Message")
		objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "pfcexch" 
		objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		objEmail.Configuration.Fields.Update
		objEmail.From = "it_ops@porteousfastener"
		objEmail.To = Email
		objEmail.Subject = "ItemAlias Batch Exceptions"
		objEmail.Textbody = "Attached please find a list of exceptions from your ItemAlias Upload Batch."
		objEmail.AddAttachment ExcFile
		objEmail.Send
		fso.DeleteFile ExcFile, True
		User = ExcRec.Fields("EntryID").value
		ExcFile = "\\pfcfiles\Userdb\" & User & "test.csv"
		Set CSVFile = fso.createtextfile(ExcFile)
		CSVFile.writeline Header
		EmailQuery = "SELECT UserName, EmailAddress FROM SecurityUsers WHERE UserName='" & User & "'"
		Set EmailRec = EmailCnx.execute(EmailQuery)
		Email = EmailRec.fields("EmailAddress").value
	end if	
	
	
	for ColCount = 0 to ExcRec.fields.count -3
		if ColCount <> ExcRec.fields.count -3 then
			Detail = Detail + """" & ExcRec.fields(ColCount).value & ""","
		else
			Detail = Detail + """" & ExcRec.fields(ColCount).value & """"
		end if
	next
	CSVFile.writeline Detail
	Detail = ""
	ExcRec.movenext
loop

CSVFile.close
Set CSVFile = nothing

Set objEmail = CreateObject("CDO.Message")
objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "pfcexch" 
objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
objEmail.Configuration.Fields.Update
objEmail.From = "it_ops@porteousfastener"
objEmail.To = Email
objEmail.Subject = "ItemAlias Batch Exceptions"
objEmail.Textbody = "Attached please find a list of exceptions from your ItemAlias Upload Batch."
objEmail.AddAttachment ExcFile
objEmail.Send
fso.DeleteFile ExcFile, True

Set fso = nothing

ExcRec.close
Set ExcRec = nothing

EmailRec.close
Set EmailRec = nothing

ExcCnx.close
Set ExcCnx = nothing

EmailCnx.close
Set EmailCnx = nothing

Main = DTSTaskExecResult_Success

End Function
