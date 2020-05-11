Set objEmail = CreateObject("CDO.Message")
objEmail.From = "script@company.com"
objEmail.To = "don@company.com"
objEmail.Subject = "Script Finished" 
objEmail.Textbody = "ADSI Update Script Finished."
objEmail.Send