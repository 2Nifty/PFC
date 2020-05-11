// JScript File

//BEGIN zItem
    function zItem(itemNo, itemCtl)
    {
        //alert ('zitem');
        var section = "";
        var completeItem = 0;
        event.keyCode = 0;

        if (itemNo.length >= 14)
        {
            //alert('>=14');
            //CheckItem(itemCtl);
            document.getElementById("btnHidSubmitItem").click();
            return false;
        }

        if (itemNo.length == 0)
        {
            return false;
        }
        
        switch(itemNo.split('-').length)
        {
            case 1:
                itemNo = "00000" + itemNo;
                itemNo = itemNo.substr(itemNo.length-5,5);
                $get(itemCtl).value=itemNo+"-";  
            break;
            case 2:
                if (itemNo.split('-')[0] == "00000")
                {
                    ClosePage();
                }
                section = "0000" + itemNo.split('-')[1];
                section = section.substr(section.length-4,4);
                $get(itemCtl).value=itemNo.split('-')[0]+"-"+section+"-";  
            break;
            case 3:
                section = "000" + itemNo.split('-')[2];
                section = section.substr(section.length-3,3);
                $get(itemCtl).value=itemNo.split('-')[0]+"-"+itemNo.split('-')[1]+"-"+section;  
                completeItem=1;
            break;
        }
    
        if (completeItem==1)
        {
            //alert('complete=1');
            //CheckItem(itemCtl);
            document.getElementById("btnHidSubmitItem").click();
        }
        return false;
    }
//END zItem

