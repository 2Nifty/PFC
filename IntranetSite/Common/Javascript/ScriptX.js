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

