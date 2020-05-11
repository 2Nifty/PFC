' VBScript File


Function ShowYesorNo(strMsg)
    Dim intBtnClick
    intBtnClick=msgbox(strMsg,vbyesno,"Vendor Maintenance")
    if ShowYesorNo=6 then 
        ShowYesorNo= true 
    else 
        ShowYesorNo= false
     end if
end Function

