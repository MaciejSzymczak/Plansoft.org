�
 TPRINTDEMOFORM 0=  TPF0TPrintDemoFormPrintDemoFormLeft#Top� BorderIconsbiSystemMenu BorderStylebsSingleCaptionSynEdit printing demoClientHeight8ClientWidthFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style PositionpoScreenCenterOnCreate
FormCreatePixelsPerInch`
TextHeight TLabelLabel1LeftTopWidth6HeightCaptionFile to print:  TSpeedButtonSpeedButton1LeftTopWidthHeightCaption...OnClickSpeedButton1Click  TLabelLabel2LeftTop0Width&HeightCaptionHeader:  TLabelLabel3LeftTop� Width!HeightCaptionFooter:  TLabelLabel4LeftTop� WidthHeightCaptionTitle:  TLabelLabel5Left8Top� Width5HeightAutoSizeCaptionPrint date and time:WordWrap	  TEdit	eFileNameLeftXTopWidth�HeightTabOrder OnChangeeFileNameChange  TMemo
memoHeaderLeftXTop,Width�HeightIFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Style Lines.Strings $TITLE$$RIGHT$Printed $DATETIME$$LINE$ 
ParentFontTabOrder  TMemo
memoFooterLeftXTop� Width�HeightIFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Style Lines.Strings$LINE$#$CENTER$Page: $PAGENUM$/$PAGECOUNT$ 
ParentFontTabOrder  TButtonbtnPrintLeft�TopWidthKHeightCaptionPrintEnabledTabOrder
OnClickbtnPrintClick  TButtonbtnHeaderFontLeft	TopWidthxHeightCaptionHeader font...TabOrder	OnClickbtnHeaderFontClick  	TCheckBoxcbUseHighlighterLeft� Top� Width� HeightCaptionUse syntax highlighterState	cbCheckedTabOrder  	TCheckBoxcbPrintBlackAndWhiteLeftTop� Width� HeightCaptionPrint in black and white onlyTabOrder  	TCheckBoxcbPrintLineNumbersLeft@Top� WidthmHeightCaptionPrint line numbersTabOrder  	TCheckBox
cbWordWrapLeft�Top� WidthaHeightCaptionWrap long linesTabOrder  TEditeTitleLeftXTop� Width� HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Style 
ParentFontTabOrderTextSynEdit print demo  TEditePrintDateTimeLeftpTop� Width� HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Style 
ParentFontTabOrder  TButtonbtnFooterFontLeft� TopWidthxHeightCaptionFooter font...TabOrderOnClickbtnFooterFontClick  TOpenDialogdlgFileOpen
DefaultExtpasTitleFile to printLeft�Top4  
TSynPasSyn
SynPasSyn1Left8TopL  TPrintDialogdlgFilePrintOptions
poPageNums Left�Top4  TFontDialogdlgSelectFontFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MinFontSize MaxFontSize Left�Top4   