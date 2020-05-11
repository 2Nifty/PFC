exec [pIMLabelCNV]



DECLARE @FileName varchar(50),
        @bcpCommand varchar(2000)

SET @FileName = '\\Pfcsqlp\PWWCNV\Inventor\INVMAS.PC_NEW'

SET @bcpCommand = 'bcp "exec [pIMLabelCNV]" queryout "'
SET @bcpCommand = @bcpCommand + @FileName + '" -U pfcnormal -P pfcnormal -c'

print @FileName
print @bcpCommand

EXEC master..xp_cmdshell @bcpCommand
