// JScript File
function formatGrid()
{
    
    if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1))
    {}
    else
    {
      
        var strForm=document.form1.innerHTML;
          alert(strForm);
        document.form1.innerHTML=strForm.replace(/rules\=\"all\"/g,'');
    }
}
