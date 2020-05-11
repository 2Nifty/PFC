function SetPrintSettings(isPortrait, lMargin, tMargin, rMargin, bMargin) 
{
  // ScriptX control
  factory.printing.SetMarginMeasure(2); // measure margins in inches
  factory.printing.collate = true;
  factory.printing.header = "";
  factory.printing.footer = "";
  factory.printing.portrait = isPortrait;
  factory.printing.leftMargin = lMargin;
  factory.printing.topMargin = tMargin;
  factory.printing.rightMargin = rMargin;
  factory.printing.bottomMargin = bMargin;
}

/*function window.onload() {
  if ( !factory.object ) {
    alert("MeadCo's ScriptX Control is not properly installed!");
    navigate("scriptx-install-error.htm");
    return;
  }
  if ( !secmgr.object ) {
    alert("MeadCo's Security Manager Control is not properly installed!");
    navigate("secmgr-install-error.htm");
    return;
  }
  if ( !secmgr.validLicense ) {
    alert("The MeadCo Publishing License is invalid or has been declined by the user!");
    navigate("license-error.htm");
    return;
  }
  alert("Ready to script MeadCo's ScriptX!")
}*/
