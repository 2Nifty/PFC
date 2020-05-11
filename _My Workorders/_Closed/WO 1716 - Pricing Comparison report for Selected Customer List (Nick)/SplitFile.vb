'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************

Function Main()
Dim Query, OutFile, ColCount, Detail, RootFile, TAB

TAB = Chr(9)

Set OutCnx = CreateObject("ADODB.Connection")
Set fso = CreateObject("Scripting.FileSystemObject")

OutCnx.Provider = "sqloledb"
OutCnx.ConnectionString = "server=PFCERPDB;uid=PfcNormal;pwd=pfcnormal;"
OutCnx.CommandTimeout = 0
OutCnx.Open
OutCnx.DefaultDatabase = "PERP"
Query = "SELECT * FROM tSalesatSellvsatWebPrice"
Set OutRec = OutCnx.execute(Query)

RootFile = OutRec.Fields("ReportID").value
OutFile = "\\pfcfiles\Data\" & Rootfile & ".txt"
Set CSVFile = fso.createtextfile(OutFile)
CSVFile.writeline Header

'Read loop
do while not OutRec.eof
	if RootFile <> OutRec.Fields("ReportID") then
		CSVFile.close
		Set CSVFile = nothing
		RootFile = OutRec.Fields("ReportID").value
		OutFile = "\\pfcfiles\Data\" & RootFile & ".txt"
		Set CSVFile = fso.createtextfile(OutFile)
	end if	

	for ColCount = 0 to OutRec.fields.count -1
		if ColCount <> OutRec.fields.count -1 then
			Detail = Detail & OutRec.fields(ColCount).value & Chr(9)
		else
			Detail = Detail & OutRec.fields(ColCount).value
		end if
	next
	CSVFile.writeline Detail
	Detail = ""
	OutRec.movenext
loop

CSVFile.close
Set CSVFile = nothing

Set fso = nothing

OutRec.close
Set OutRec = nothing

OutCnx.close
Set OutCnx = nothing

Main = DTSTaskExecResult_Success

End Function
