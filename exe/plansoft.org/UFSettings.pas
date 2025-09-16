Unit UFSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, ComCtrls, inifiles, ucommon;

type
  TFSettings = class(TFormConfig)
    BottomPanel: TPanel;
    BCloseSettings: TBitBtn;
    PageControl: TPageControl;
    TabSheetL: TTabSheet;
    TabSheetG: TTabSheet;
    TabSheetR: TTabSheet;
    LDescGroup: TGroupBox;
    LD1: TComboBox;
    LD2: TComboBox;
    LD3: TComboBox;
    LD4: TComboBox;
    LD5: TComboBox;
    GDescGroup: TGroupBox;
    GD1: TComboBox;
    GD2: TComboBox;
    GD3: TComboBox;
    GD4: TComboBox;
    GD5: TComboBox;
    RDescGroup: TGroupBox;
    RD1: TComboBox;
    RD2: TComboBox;
    RD3: TComboBox;
    RD4: TComboBox;
    RD5: TComboBox;
    LCellSizes: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    LW: TEdit;
    LH: TEdit;
    GCellSizes: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    GW: TEdit;
    GH: TEdit;
    RCellSizes: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    RW: TEdit;
    RH: TEdit;
    BHtml: TBitBtn;
    LLShowLegend: TCheckBox;
    gGShowLegend: TCheckBox;
    rRShowLegend: TCheckBox;
    gheadergroup: TGroupBox;
    gfootergroup: TGroupBox;
    GHEADER: TMemo;
    GFOOTER: TMemo;
    BSave: TSpeedButton;
    Bload: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    lheadergroup: TGroupBox;
    LHEADER: TMemo;
    lfootergroup: TGroupBox;
    LFOOTER: TMemo;
    rheadergroup: TGroupBox;
    RHEADER: TMemo;
    rfootergroup: TGroupBox;
    RFOOTER: TMemo;
    Panel1: TPanel;
    Label7: TLabel;
    PaperSize: TComboBox;
    Label9: TLabel;
    LCELLSIZE: TEdit;
    GCELLSIZE: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    RCELLSIZE: TEdit;
    LS1: TEdit;
    LS2: TEdit;
    LS3: TEdit;
    LS4: TEdit;
    LS5: TEdit;
    LB1: TCheckBox;
    LB2: TCheckBox;
    LB3: TCheckBox;
    LB4: TCheckBox;
    LB5: TCheckBox;
    Label12: TLabel;
    Label13: TLabel;
    GS1: TEdit;
    GS2: TEdit;
    GS3: TEdit;
    GS4: TEdit;
    GS5: TEdit;
    GB5: TCheckBox;
    GB4: TCheckBox;
    GB3: TCheckBox;
    GB2: TCheckBox;
    GB1: TCheckBox;
    Label14: TLabel;
    RS1: TEdit;
    RS2: TEdit;
    RS3: TEdit;
    RS4: TEdit;
    RS5: TEdit;
    RB5: TCheckBox;
    RB4: TCheckBox;
    RB3: TCheckBox;
    RB2: TCheckBox;
    RB1: TCheckBox;
    tsAdvanced: TTabSheet;
    BWord: TBitBtn;
    LMaxLecturersInLegend: TLabel;
    LMaxLengthCALC_GROUPS: TLabel;
    LMaxLengthCreated_by: TLabel;
    LMaxLengthCALC_ROOMS: TLabel;
    LMaxLengthCALC_LECTURERS: TLabel;
    LCellWidthHour: TLabel;
    LCellWidthDay: TLabel;
    LCellWidthInLegend: TLabel;
    LMaxLengthSUB_abbreviation: TLabel;
    LMaxLengthOwner: TLabel;
    LMaxLengthFOR_abbreviation: TLabel;
    MaxLecturersInLegend: TEdit;
    CellWidthInLegend: TEdit;
    MaxLengthSUB_abbreviation: TEdit;
    MaxLengthOwner: TEdit;
    MaxLengthFOR_abbreviation: TEdit;
    MaxLengthCreated_by: TEdit;
    MaxLengthCALC_ROOMS: TEdit;
    MaxLengthCALC_LECTURERS: TEdit;
    MaxLengthCALC_GROUPS: TEdit;
    CellWidthHour: TEdit;
    CellWidthDay: TEdit;
    GViewTypeGroup: TGroupBox;
    GViewType: TComboBox;
    LViewTypeGroup: TGroupBox;
    LViewType: TComboBox;
    RViewTypeGroup: TGroupBox;
    RViewType: TComboBox;
    LRepeatMonthNames: TCheckBox;
    LHideEmptyRows: TCheckBox;
    GRepeatMonthNames: TCheckBox;
    GHideEmptyRows: TCheckBox;
    RRepeatMonthNames: TCheckBox;
    RHideEmptyRows: TCheckBox;
    MaxLengthDesc1: TEdit;
    Label20: TLabel;
    MaxLengthDesc2: TEdit;
    MaxLengthDesc3: TEdit;
    MaxLengthDesc4: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    LcomboSpan: TComboBox;
    LcomboSpanlabel: TLabel;
    GcomboSpan: TComboBox;
    GcomboSpanlabel: TLabel;
    RcomboSpan: TComboBox;
    RcomboSpanlabel: TLabel;
    lspanEmptyCells: TCheckBox;
    gspanEmptyCells: TCheckBox;
    rspanEmptyCells: TCheckBox;
    LTransposition: TCheckBox;
    GTransposition: TCheckBox;
    RTransposition: TCheckBox;
    LVerticalLines: TCheckBox;
    GVerticalLines: TCheckBox;
    RVerticalLines: TCheckBox;
    LAddCreationDate: TComboBox;
    GAddCreationDate: TComboBox;
    RAddCreationDate: TComboBox;
    Rnotes_before: TCheckBox;
    Rnotes_after: TCheckBox;
    Gnotes_before: TCheckBox;
    Gnotes_after: TCheckBox;
    Lnotes_before: TCheckBox;
    Lnotes_after: TCheckBox;
    lhelp: TSpeedButton;
    ghelp: TSpeedButton;
    rhelp: TSpeedButton;
    LPdfPrintOut: TCheckBox;
    GPdfPrintOut: TCheckBox;
    RPdfPrintOut: TCheckBox;
    lpdfg: TCheckBox;
    lpdfl: TCheckBox;
    lpdfo: TCheckBox;
    lpdfs: TCheckBox;
    gpdfg: TCheckBox;
    gpdfl: TCheckBox;
    gpdfo: TCheckBox;
    gpdfs: TCheckBox;
    rpdfg: TCheckBox;
    rpdfl: TCheckBox;
    rpdfo: TCheckBox;
    rpdfs: TCheckBox;
    LHideEmptyRowsB: TSpeedButton;
    GHideEmptyRowsB: TSpeedButton;
    RHideEmptyRowsB: TSpeedButton;
    llegendMode: TGroupBox;
    llegendAbbr: TCheckBox;
    llegendSummary: TCheckBox;
    glegendMode: TGroupBox;
    glegendAbbr: TCheckBox;
    glegendSummary: TCheckBox;
    rlegendMode: TGroupBox;
    rlegendAbbr: TCheckBox;
    rlegendSummary: TCheckBox;
    llegendECTS: TCheckBox;
    glegendECTS: TCheckBox;
    rlegendECTS: TCheckBox;
    WeeklyView: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BHtmlClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure BloadClick(Sender: TObject);
    procedure PaperSizeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure BWordClick(Sender: TObject);
    procedure LHideEmptyRowsClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BCloseSettingsClick(Sender: TObject);
    procedure lLegendModeClick(Sender: TObject);
    procedure LLShowLegendClick(Sender: TObject);
    procedure gGShowLegendClick(Sender: TObject);
    procedure rRShowLegendClick(Sender: TObject);
    procedure lhelpClick(Sender: TObject);
    procedure LPdfPrintOutClick(Sender: TObject);
    procedure LHideEmptyRowsBClick(Sender: TObject);
    procedure GHideEmptyRowsBClick(Sender: TObject);
    procedure RHideEmptyRowsBClick(Sender: TObject);
  private
    procedure showHideEditButton;
  public
    Path : String;
    LHideDows : string;
    GHideDows : string;
    RHideDows : string;

    Procedure Save(fileName : ShortString);
    Procedure Load(fileName : ShortString);

    Procedure SaveInRegistry;

    procedure HTML(Prog : String);
  end;

var
  FSettings: TFSettings;

implementation

uses UFMain, UUtilityParent, UFWWWGenerator, UFProgramSettings, DM,
  UFSalectDaysOfWeek;

{$R *.DFM}

procedure TFSettings.FormCreate(Sender: TObject);
var exePath : string;
begin
  inherited;
  LHideDows := '+++++++';
  GHideDows := '+++++++';
  RHideDows := '+++++++';

  exePath := GetD +'\';
  Path := uutilityParent.ApplicationDocumentsPath;

  if not fileExists (path+'A3') and fileExists(exePath+'A3') then
    copyFile(PAnsiChar(exePath+'A3'), PAnsiChar(path+'A3'), false);
  if not fileExists (path+'A4') and fileExists(exePath+'A4') then
    copyFile(PAnsiChar(exePath+'A4'), PAnsiChar(path+'A4'), false);

end;

procedure TFSettings.HTML(Prog : String);
var ColoringIndex : shortString;
    tmpFileName   : shortString;
    pdfFileName   : shortString;
    presId : String; presType : String;
begin
  FWWWGenerator := TFWWWGenerator.Create(Application);

  tmpFileName :=  uutilityParent.ApplicationDocumentsPath + 'temp.htm';
  pdfFileName :=  uutilityParent.ApplicationDocumentsPath + 'temp.pdf';
  if fileexists( tmpFileName ) then
   if not deletefile( tmpFileName ) then begin
     info ('Nie mo¿na utworzyæ dokumentu, poniewa¿ dokument jest aktualnie u¿ywany przez inny program. Zamknij inne programy i spróbuj ponownie');
     exit;
   end;

  case FMain.TabViewType.TabIndex of
   0: begin presId:=ExtractWord(1,FMain.conlecturer.Text,[';']); presType:='LEC'; end;
   1: begin presId:=ExtractWord(1,FMain.congroup.Text,[';']);    presType:='GRO'; end;
   2: begin presId:=ExtractWord(1,FMain.conResCat0.Text,[';']); presType:='ROM'; end;
   3: begin presId:=ExtractWord(1,FMain.conResCat1.Text,[';']); presType:='ROM'; end;
  end;

  //If PageControl.ActivePage = TabSheetL Then
    If FMain.TabViewType.TabIndex = 0 Then Begin
      ColoringIndex := getCode(LViewType);
      fwwwGenerator.CalendarToHTML(FMain.conPeriod.Text, presId,'LEC',getCode(LD1), getCode(LD2), getCode(LD3), getCode(LD4), getCode(LD5), LHEADER.Lines, LFOOTER.Lines, llShowLegend.Checked,
            iif(llegendECTS.checked,1,0)*4 + iif(llegendAbbr.checked,1,0)*2 + iif(llegendSummary.checked,1,0)*1
          , lAddCreationDate.itemindex, ColoringIndex, LW.Text, LH.Text, LCELLSIZE.Text, LS1.Text, LS2.Text, LS3.Text, LS4.Text, LS5.Text, LB1.Checked, LB2.Checked, LB3.Checked, LB4.Checked, LB5.Checked, tmpFileName , LRepeatMonthNames.Checked, LHideEmptyRows.Checked, LHideDows, LcomboSpan.itemIndex, lspanEmptyCells.checked, ltransposition.checked, lVerticalLines.checked, Lnotes_before.checked, Lnotes_after.checked, LPdfprintOut.checked, lpdfg.checked,lpdfl.checked,lpdfo.checked,lpdfs.checked, weeklyView.Checked );
      if LPdfprintOut.checked then tmpFileName := pdfFileName;
    End;
    //Else Info('Aby wykonaæ dokument wybierz na formularzu g³ównym kalendarz '+fprogramSettings.profileObjectNameLgen.Text );

  //If PageControl.ActivePage = TabSheetG Then
    If FMain.TabViewType.TabIndex = 1 Then Begin
      ColoringIndex := getCode(GViewType);
      fwwwGenerator.CalendarToHTML(FMain.conPeriod.Text, presId,'GRO',getCode(GD1), getCode(GD2), getCode(GD3), getCode(GD4), getCode(GD5), GHEADER.Lines, GFOOTER.Lines, gGShowLegend.Checked,
            iif(glegendECTS.checked,1,0)*4 + iif(glegendAbbr.checked,1,0)*2 + iif(glegendSummary.checked,1,0)*1,gAddCreationDate.itemindex
          , ColoringIndex, GW.Text, GH.Text, GCELLSIZE.Text, GS1.Text, GS2.Text, GS3.Text, GS4.Text, GS5.Text, GB1.Checked, GB2.Checked, GB3.Checked, GB4.Checked, GB5.Checked, tmpFileName , GRepeatMonthNames.Checked, GHideEmptyRows.Checked, GHideDows, GcomboSpan.itemIndex, gspanEmptyCells.checked , gtransposition.checked, gVerticalLines.checked, gnotes_before.checked, gnotes_after.checked, GPdfprintOut.checked, gpdfg.checked, gpdfl.checked, gpdfo.checked, gpdfs.checked, weeklyView.Checked);
      if GPdfprintOut.checked then tmpFileName := pdfFileName;
    End;
    //Else Info('Aby wykonaæ dokument wybierz na formularzu g³ównym kalendarz '+fprogramSettings.profileObjectNameGgen.Text);

  //If PageControl.ActivePage = TabSheetR Then
    If (FMain.TabViewType.TabIndex = 2) or (FMain.TabViewType.TabIndex = 3) Then Begin
      ColoringIndex := getCode(RViewType);
      fwwwGenerator.CalendarToHTML(FMain.conPeriod.Text, presId,'ROM',getCode(RD1), getCode(RD2), getCode(RD3), getCode(RD4), getCode(RD5), RHEADER.Lines, RFOOTER.Lines, rRShowLegend.Checked,
            iif(rlegendECTS.checked,1,0)*4 + iif(rlegendAbbr.checked,1,0)*2 + iif(rlegendSummary.checked,1,0)*1
          , rAddCreationDate.itemindex, ColoringIndex, RW.Text, RH.Text, RCELLSIZE.Text, RS1.Text, RS2.Text, RS3.Text, RS4.Text, RS5.Text, RB1.Checked, RB2.Checked, RB3.Checked, RB4.Checked, RB5.Checked, tmpFileName , RRepeatMonthNames.Checked, RHideEmptyRows.Checked, RHideDows, RcomboSpan.itemIndex, rspanEmptyCells.checked, rtransposition.checked, rVerticalLines.checked, rnotes_before.checked, rnotes_after.checked, RPdfprintOut.checked, rpdfg.checked, rpdfl.checked, rpdfo.checked, rpdfs.checked, weeklyView.Checked);
      if RPdfprintOut.checked then tmpFileName := pdfFileName;
    End;
    //Else Info('Aby wykonaæ dokument wybierz na formularzu g³ównym kalendarz zasobu');

   if fileExists(tmpFileName) then begin
       If isBlank(Prog)
           Then UUTilityParent.ExecuteFile( tmpFileName ,'','',SW_SHOWMAXIMIZED)
           Else begin
             if tmpFileName=pdfFileName then begin
                 info ('Dokumentu w formacie pdf nie mo¿na edytowaæ, zostanie uruchomiony podgl¹d dokumentu');
                 UUTilityParent.ExecuteFile( tmpFileName ,'','',SW_SHOWMAXIMIZED);
             end
             else
                 UUTilityParent.ExecuteFile(Prog, tmpFileName ,'',SW_SHOWMAXIMIZED);
           End;
   end;

  FWWWGenerator.Free;
end;

procedure TFSettings.BHtmlClick(Sender: TObject);
begin
  inherited;
  SaveInRegistry;
  html('');
end;

Procedure TFSettings.Save(fileName : ShortString);
Var IniFile : TIniFile;
begin
  deleteFile(fileName);
  IniFile := TIniFile.Create(fileName);

  With IniFile Do Begin
   WriteString('L','D1Code'     ,getCode(LD1));
   WriteString('L','D2Code'     ,getCode(LD2));
   WriteString('L','D3Code'     ,getCode(LD3));
   WriteString('L','D4Code'     ,getCode(LD4));
   WriteString('L','D5Code'     ,getCode(LD5));

   Writestring('L','LS1',LS1.Text);
   Writestring('L','LS2',LS2.Text);
   Writestring('L','LS3',LS3.Text);
   Writestring('L','LS4',LS4.Text);
   Writestring('L','LS5',LS5.Text);
   writeBool('L','LB1', LB1.Checked);
   writeBool('L','LB2', LB2.Checked);
   writeBool('L','LB3', LB3.Checked);
   writeBool('L','LB4', LB4.Checked);
   writeBool('L','LB5', LB5.Checked);
   writeBool('L','Lnotes_before', Lnotes_before.Checked);
   writeBool('L','Lnotes_after', Lnotes_after.Checked);
   writeBool('L','LPdfprintOut', LPdfprintOut.Checked);
   writeBool('L','lpdfg', lpdfg.Checked);
   writeBool('L','lpdfl', lpdfl.Checked);
   writeBool('L','lpdfo', lpdfo.Checked);
   writeBool('L','lpdfs', lpdfs.Checked);
   WriteString ('L','ViewTypeCode'  ,getCode(LViewType));
   WriteString ('L','W'         ,LW.Text);
   WriteString ('L','H'         ,LH.Text);
   WriteString ('L','CELLSIZE'  ,LCELLSIZE.Text);
   WriteBool   ('L','ShowLegend',llShowLegend.Checked);
   WriteBool   ('L','RepeatMonthNames',LRepeatMonthNames.Checked);
   WriteBool   ('L','HideEmptyRows',LHideEmptyRows.Checked);
   WriteString ('L', 'HideDows', LHideDows);
   WriteBool('L','Transposite',LTransposition.Checked);
   WriteBool('L','VerticalLines',lVerticalLines.Checked);
   WriteBool   ('L','spanEmptyCells',lspanEmptyCells.checked);
   WriteString ('L','ComboSpan',intToStr(LComboSpan.itemIndex));
   WriteString ('L','LegendMode', intToStr(
                                     iif(llegendECTS.checked,1,0)*4
                                   + iif(llegendAbbr.checked,1,0)*2
                                   + iif(llegendSummary.checked,1,0)*1
                                     ));
   WriteInteger('L','AddCreationDate',lAddCreationDate.itemindex);
   WriteString ('L','HEADER'    ,SearchAndReplace(LHEADER.Lines.CommaText,'"','^') );
   WriteString ('L','FOOTER'    ,SearchAndReplace(LFOOTER.Lines.CommaText,'"','^'));



   WriteString ('G', 'HideDows', GHideDows);
   WriteString('G','D1Code'     ,getCode(GD1));
   WriteString('G','D2Code'     ,getCode(GD2));
   WriteString('G','D3Code'     ,getCode(GD3));
   WriteString('G','D4Code'     ,getCode(GD4));
   WriteString('G','D5Code'     ,getCode(GD5));
   Writestring('G','GS1',GS1.Text);
   Writestring('G','GS2',GS2.Text);
   Writestring('G','GS3',GS3.Text);
   Writestring('G','GS4',GS4.Text);
   Writestring('G','GS5',GS5.Text);
   writeBool('G','GB1', GB1.Checked);
   writeBool('G','GB2', GB2.Checked);
   writeBool('G','GB3', GB3.Checked);
   writeBool('G','GB4', GB4.Checked);
   writeBool('G','GB5', GB5.Checked);
   writeBool('G','Gnotes_before', Gnotes_before.Checked);
   writeBool('G','Gnotes_after', Gnotes_after.Checked);
   writeBool('G','GPdfprintOut', GPdfprintOut.Checked);
   writeBool('G','gpdfg', gpdfg.Checked);
   writeBool('G','gpdfl', gpdfl.Checked);
   writeBool('G','gpdfo', gpdfo.Checked);
   writeBool('G','gpdfs', gpdfs.Checked);
   WriteString ('G','ViewTypeCode'  ,getCode(GViewType));
   WriteString ('G','W'         ,GW.Text);
   WriteString ('G','H'         ,GH.Text);
   WriteString ('G','CELLSIZE'  ,GCELLSIZE.Text);
   WriteBool   ('G','ShowLegend',gGShowLegend.Checked);
   WriteBool   ('G','RepeatMonthNames',GRepeatMonthNames.Checked);
   WriteBool   ('G','HideEmptyRows',GHideEmptyRows.Checked);
   WriteBool('G','Transposite',GTransposition.Checked);
   WriteBool('G','VerticalLines',gVerticalLines.Checked);
   WriteBool   ('G','spanEmptyCells',gspanEmptyCells.checked);
   WriteString ('G','ComboSpan',intToStr(GComboSpan.itemIndex));
   WriteString ('G','LegendMode',intToStr(
        iif(glegendECTS.checked,1,0)*4
      + iif(glegendAbbr.checked,1,0)*2
      + iif(glegendSummary.checked,1,0)*1
   ));
   WriteInteger('G','AddCreationDate',gAddCreationDate.itemindex);
   WriteString ('G','HEADER'    ,SearchAndReplace(GHEADER.Lines.CommaText,'"','^'));
   WriteString ('G','FOOTER'    ,SearchAndReplace(GFOOTER.Lines.CommaText,'"','^'));


   WriteString('R', 'HideDows', RHideDows);
   WriteString('R','D1Code'     ,getCode(RD1));
   WriteString('R','D2Code'     ,getCode(RD2));
   WriteString('R','D3Code'     ,getCode(RD3));
   WriteString('R','D4Code'     ,getCode(RD4));
   WriteString('R','D5Code'     ,getCode(RD5));

   Writestring('R','RS1',RS1.Text);
   Writestring('R','RS2',RS2.Text);
   Writestring('R','RS3',RS3.Text);
   Writestring('R','RS4',RS4.Text);
   Writestring('R','RS5',RS5.Text);
   writeBool('R','RB1', RB1.Checked);
   writeBool('R','RB2', RB2.Checked);
   writeBool('R','RB3', RB3.Checked);
   writeBool('R','RB4', RB4.Checked);
   writeBool('R','RB5', RB5.Checked);
   writeBool('R','Rnotes_before', Gnotes_before.Checked);
   writeBool('R','Rnotes_after', Gnotes_after.Checked);
   writeBool('R','RPdfprintOut', RPdfprintOut.Checked);

   WriteString ('R','ViewTypeCode'  ,getCode(RViewType));
   WriteString ('R','W'         ,RW.Text);
   WriteString ('R','H'         ,RH.Text);
   WriteString ('R','CELLSIZE'  ,RCELLSIZE.Text);
   WriteBool   ('R','ShowLegend',rRShowLegend.Checked);
   WriteBool   ('R','RepeatMonthNames',RRepeatMonthNames.Checked);
   WriteBool   ('R','HideEmptyRows',RHideEmptyRows.Checked);
   WriteBool   ('R','Transposite',RTransposition.Checked);
   WriteBool   ('R','VerticalLines',rVerticalLines.Checked);
   WriteBool   ('R','spanEmptyCells',rspanEmptyCells.checked);
   WriteString ('R','ComboSpan',intToStr(RComboSpan.itemIndex));
   WriteString ('R','LegendMode',intToStr(
      iif(rlegendECTS.checked,1,0)*4
     +iif(rlegendAbbr.checked,1,0)*2
     +iif(rlegendSummary.checked,1,0)*1
   ));
   WriteInteger('R','AddCreationDate',rAddCreationDate.itemindex);
   WriteString ('R','HEADER'    ,SearchAndReplace(RHEADER.Lines.CommaText,'"','^'));
   WriteString ('R','FOOTER'    ,SearchAndReplace(RFOOTER.Lines.CommaText,'"','^'));
  End;

end;

procedure TFSettings.BSaveClick(Sender: TObject);
begin
 If SaveDialog1.Execute Then Save(SaveDialog1.Filename);
end;

Procedure TFSettings.Load(fileName : ShortString);
    Var IniFile : TIniFile;
        tmp     : integer;
        ViewTypeCode : shortString;

    procedure setCombo ( pcombobox : tcombobox; p1,p2,p3 : shortString );
      var tmp     : integer;
          tmp2    : shortstring;
    begin
     // for previous version compapibility
     tmp  := IniFile.ReadInteger(p1,p2, -100);
     case tmp of
      0: tmp2 := 'L';
      1: tmp2 := 'G';
      2: tmp2 := 'ALL_RES';
      3: tmp2 := 'S';
      4: tmp2 := 'F';
      5: tmp2 := 'SF';
      6: tmp2 := 'OWNER';
      7: tmp2 := 'CREATED_BY';
      8: tmp2 := 'NONE';
      9: tmp2 := 'DESC1';
     10: tmp2 := 'DESC2';
     11: tmp2 := 'DESC3';
     12: tmp2 := 'DESC4';
      else tmp2 := iniFile.ReadString(p1,p3, 'NONE');
     end;
     pcombobox.ItemIndex     := getItemIndex ( pcombobox,  tmp2);
    end;

begin
  IniFile := TIniFile.Create(fileName);

  With IniFile Do Begin
   setCombo (LD1, 'L', 'D1', 'D1Code');
   setCombo (LD2, 'L', 'D2', 'D2Code');
   setCombo (LD3, 'L', 'D3', 'D3Code');
   setCombo (LD4, 'L', 'D4', 'D4Code');
   setCombo (LD5, 'L', 'D5', 'D5Code');

   // for previous version compapibility
   tmp  := ReadInteger('L','ViewType'  , -100);
   case tmp of
     0: ViewTypeCode := 'L';
     1: ViewTypeCode := 'G';
     2: ViewTypeCode := 'ALL_RES';
     3: ViewTypeCode := 'S';
     4: ViewTypeCode := 'F';
     5: ViewTypeCode := 'OWNER';
     6: ViewTypeCode := 'CREATED_BY';
     7: ViewTypeCode := 'CLASS';
     8: ViewTypeCode := 'NONE';
     9: ViewTypeCode := 'DESC1';
    10: ViewTypeCode := 'DESC2';
    11: ViewTypeCode := 'DESC3';
    12: ViewTypeCode := 'DESC4';
    else ViewTypeCode := ReadString('L','ViewTypeCode'  , 'L');
   end;
   LViewType.ItemIndex     := getItemIndex ( LViewType,  ViewTypeCode);

   LW.Text                   := ReadString ('L','W'         ,'15');
   LH.Text                   := ReadString ('L','H'         ,'10');
   LCELLSIZE.Text            := ReadString ('L','CELLSIZE'  ,'10');
   llShowLegend.Checked      := ReadBool('L','ShowLegend',False);
   LLShowLegendClick(llShowLegend);
   LRepeatMonthNames.Checked := ReadBool('L','RepeatMonthNames',False);
   LHideEmptyRows.Checked    := ReadBool('L','HideEmptyRows',False);
   LHideDows := ReadString ('L', 'HideDows', '+++++++');
   GHideDows := ReadString ('G', 'HideDows', '+++++++');
   RHideDows := ReadString ('R', 'HideDows', '+++++++');

   Ltransposition.Checked      := ReadBool('L','Transposite',False);
   lVerticalLines.Checked    := ReadBool('L','VerticalLines',False);
   lspanEmptyCells.checked    := ReadBool('L','spanEmptyCells',False);
   LCombospan.itemIndex      := strToInt(ReadString('L','ComboSpan','0'));

   llegendAbbr.checked     := (strToInt(ReadString('L','LegendMode','0')) and 2) = 2;
   llegendSummary.checked  := (strToInt(ReadString('L','LegendMode','0')) and 1) = 1;
   llegendECTS.checked     := (strToInt(ReadString('L','LegendMode','1')) and 4) = 4;
   glegendAbbr.checked     := (strToInt(ReadString('G','LegendMode','0')) and 2) = 2;
   glegendSummary.checked  := (strToInt(ReadString('G','LegendMode','0')) and 1) = 1;
   glegendECTS.checked     := (strToInt(ReadString('G','LegendMode','1')) and 4) = 4;
   rlegendAbbr.checked     := (strToInt(ReadString('R','LegendMode','0')) and 2) = 2;
   rlegendSummary.checked  := (strToInt(ReadString('R','LegendMode','0')) and 1) = 1;
   rlegendECTS.checked     := (strToInt(ReadString('R','LegendMode','1')) and 4) = 4;

   lAddCreationDate.itemindex  := ReadInteger('L','AddCreationDate',0);
   LHEADER.Lines.CommaText   := SearchAndReplace(ReadString ('L','HEADER',''),'^','"');
   LFOOTER.Lines.CommaText   := SearchAndReplace(ReadString ('L','FOOTER',''),'^','"');

   LS1.Text := readString('L','LS1',LS1.Text);
   LS2.Text := readString('L','LS2',LS2.Text);
   LS3.Text := readString('L','LS3',LS3.Text);
   LS4.Text := readString('L','LS4',LS4.Text);
   LS5.Text := readString('L','LS5',LS5.Text);
   LB1.Checked := readBool('L','LB1', LB1.Checked);
   LB2.Checked := readBool('L','LB2', LB2.Checked);
   LB3.Checked := readBool('L','LB3', LB3.Checked);
   LB4.Checked := readBool('L','LB4', LB4.Checked);
   LB5.Checked := readBool('L','LB5', LB5.Checked);
   Lnotes_before.Checked := readBool('L','Lnotes_before', true);
   Lnotes_after.Checked  := readBool('L','Lnotes_after', true);
   LPdfprintOut.Checked  := readBool('L','LPdfprintOut', true);
   lpdfg.Checked  := readBool('L','lpdfg', false);
   lpdfl.Checked  := readBool('L','lpdfl', false);
   lpdfo.Checked  := readBool('L','lpdfo', false);
   lpdfs.Checked  := readBool('L','lpdfs', false);

   setCombo (GD1, 'G', 'D1', 'D1Code');
   setCombo (GD2, 'G', 'D2', 'D2Code');
   setCombo (GD3, 'G', 'D3', 'D3Code');
   setCombo (GD4, 'G', 'D4', 'D4Code');
   setCombo (GD5, 'G', 'D5', 'D5Code');

   // for previous version compapibility
   tmp  := ReadInteger('G','ViewType'  , -100);
   case tmp of
     0: ViewTypeCode := 'L';
     1: ViewTypeCode := 'G';
     2: ViewTypeCode := 'ALL_RES';
     3: ViewTypeCode := 'S';
     4: ViewTypeCode := 'F';
     5: ViewTypeCode := 'OWNER';
     6: ViewTypeCode := 'CREATED_BY';
     7: ViewTypeCode := 'CLASS';
     8: ViewTypeCode := 'NONE';
     9: ViewTypeCode := 'DESC1';
    10: ViewTypeCode := 'DESC2';
    11: ViewTypeCode := 'DESC3';
    12: ViewTypeCode := 'DESC4';
    else ViewTypeCode := ReadString('G','ViewTypeCode'  , 'G');
   end;
   GViewType.ItemIndex     := getItemIndex ( GViewType,  ViewTypeCode);

   GW.Text                   := ReadString ('G','W'         ,'15');
   GH.Text                   := ReadString ('G','H'         ,'10');
   GCELLSIZE.Text            := ReadString ('G','CELLSIZE'  ,'10');
   gGShowLegend.Checked      := ReadBool   ('G','ShowLegend',False);
   ggShowLegendClick(ggShowLegend);
   GRepeatMonthNames.Checked := ReadBool('G','RepeatMonthNames',False);
   GHideEmptyRows.Checked    := ReadBool('G','HideEmptyRows',False);
   Gtransposition.Checked    := ReadBool('G','Transposite',False);
   gVerticalLines.Checked    := ReadBool('G','VerticalLines',False);
   gspanEmptyCells.checked   := ReadBool('G','spanEmptyCells',False);
   GCombospan.itemIndex      := strToInt(ReadString('G','ComboSpan','0'));
   gAddCreationDate.itemindex  := ReadInteger('G','AddCreationDate',0);
   GHEADER.Lines.CommaText   := SearchAndReplace(ReadString ('G','HEADER',''),'^','"');
   GFOOTER.Lines.CommaText   := SearchAndReplace(ReadString ('G','FOOTER',''),'^','"');

   GS1.Text := readString('G','GS1',GS1.Text);
   GS2.Text := readString('G','GS2',GS2.Text);
   GS3.Text := readString('G','GS3',GS3.Text);
   GS4.Text := readString('G','GS4',GS4.Text);
   GS5.Text := readString('G','GS5',GS5.Text);
   GB1.Checked := readBool('G','GB1', GB1.Checked);
   GB2.Checked := readBool('G','GB2', GB2.Checked);
   GB3.Checked := readBool('G','GB3', GB3.Checked);
   GB4.Checked := readBool('G','GB4', GB4.Checked);
   GB5.Checked := readBool('G','GB5', GB5.Checked);
   Gnotes_before.Checked := readBool('G','Gnotes_before', true);
   Gnotes_after.Checked  := readBool('G','Gnotes_after', true);
   GPdfprintOut.Checked  := readBool('G','GPdfprintOut', true);
   gpdfg.Checked  := readBool('G','gpdfg', false);
   gpdfl.Checked  := readBool('G','gpdfl', false);
   gpdfo.Checked  := readBool('G','gpdfo', false);
   gpdfs.Checked  := readBool('G','gpdfs', false);

   setCombo (RD1, 'R', 'D1', 'D1Code');
   setCombo (RD2, 'R', 'D2', 'D2Code');
   setCombo (RD3, 'R', 'D3', 'D3Code');
   setCombo (RD4, 'R', 'D4', 'D4Code');
   setCombo (RD5, 'R', 'D5', 'D5Code');

   // for previous version compapibility
   tmp  := ReadInteger('R','ViewType'  , -100);
   case tmp of
     0: ViewTypeCode := 'L';
     1: ViewTypeCode := 'G';
     2: ViewTypeCode := 'ALL_RES';
     3: ViewTypeCode := 'S';
     4: ViewTypeCode := 'F';
     5: ViewTypeCode := 'OWNER';
     6: ViewTypeCode := 'CREATED_BY';
     7: ViewTypeCode := 'CLASS';
     8: ViewTypeCode := 'NONE';
     9: ViewTypeCode := 'DESC1';
    10: ViewTypeCode := 'DESC2';
    11: ViewTypeCode := 'DESC3';
    12: ViewTypeCode := 'DESC4';
    else ViewTypeCode := ReadString('R','ViewTypeCode'  , 'R');
   end;
   RViewType.ItemIndex     := getItemIndex ( RViewType,  ViewTypeCode);

   RW.Text                   := ReadString ('R','W'         ,'15');
   RH.Text                   := ReadString ('R','H'         ,'10');
   RCELLSIZE.Text            := ReadString ('R','CELLSIZE'  ,'10');
   rRShowLegend.Checked      := ReadBool   ('R','ShowLegend',False);
   rrShowLegendClick(rrShowLegend);
   RRepeatMonthNames.Checked := ReadBool('R','RepeatMonthNames',False);
   RHideEmptyRows.Checked    := ReadBool('R','HideEmptyRows',False);
   Rtransposition.Checked    := ReadBool('R','Transposite',False);
   rVerticalLines.Checked    := ReadBool('R','VerticalLines',False);
   rspanEmptyCells.checked   := ReadBool('R','spanEmptyCells',False);
   RCombospan.itemIndex      := strToInt(ReadString('R','ComboSpan','0'));
   rAddCreationDate.itemindex  := ReadInteger('R','AddCreationDate',0);
   RHEADER.Lines.CommaText   := SearchAndReplace(ReadString ('R','HEADER',''),'^','"');
   RFOOTER.Lines.CommaText   := SearchAndReplace(ReadString ('R','FOOTER',''),'^','"');

   RS1.Text := readString('R','RS1',RS1.Text);
   RS2.Text := readString('R','RS2',RS2.Text);
   RS3.Text := readString('R','RS3',RS3.Text);
   RS4.Text := readString('R','RS4',RS4.Text);
   RS5.Text := readString('R','RS5',RS5.Text);
   RB1.Checked := readBool('R','RB1', RB1.Checked);
   RB2.Checked := readBool('R','RB2', RB2.Checked);
   RB3.Checked := readBool('R','RB3', RB3.Checked);
   RB4.Checked := readBool('R','RB4', RB4.Checked);
   RB5.Checked := readBool('R','RB5', RB5.Checked);
   Rnotes_before.Checked := readBool('R','Rnotes_before', true);
   Rnotes_after.Checked  := readBool('R','Rnotes_after', true);
   RPdfprintOut.Checked  := readBool('R','RPdfprintOut', true);
   rpdfg.Checked  := readBool('R','rpdfg', false);
   rpdfl.Checked  := readBool('R','rpdfl', false);
   rpdfo.Checked  := readBool('R','rpdfo', false);
   rpdfs.Checked  := readBool('R','rpdfs', false);

  End;

end;


procedure TFSettings.BloadClick(Sender: TObject);
begin
  inherited;
 If OpenDialog1.Execute Then begin
   Load(OpenDialog1.Filename);
   self.Caption := 'Drukuj: ' + OpenDialog1.Filename;
 end;
end;

procedure TFSettings.PaperSizeChange(Sender: TObject);
begin
  inherited;
  Case PaperSize.ItemIndex Of
   0:Begin Save(Path+'A3'); Load(Path+'A4'); End;
   1:Begin Save(Path+'A4'); Load(Path+'A3'); End;
  End;
end;

procedure TFSettings.FormShow(Sender: TObject);
begin
  inherited;
  MaxLecturersInLegend.Text      := GetSystemParam('MaxLecturersInLegend','1000');         // maksymalna liczba wyk³adowców przy jednym przedmiocie w legendzie.
  MaxLengthCALC_GROUPS.Text      := GetSystemParam('MaxLengthCALC_GROUPS','1000');         // maksymalna liczba znaków w pojedynczej komórce oznaczaj¹ca grupê
  MaxLengthCALC_LECTURERS.Text   := GetSystemParam('MaxLengthCALC_LECTURERS','1000');      // jw. Dla wyk³adowcy
  MaxLengthCALC_ROOMS.Text       := GetSystemParam('MaxLengthCALC_ROOMS','1000');          // jw dla sali
  MaxLengthCreated_by.Text       := GetSystemParam('MaxLengthCreated_by','1000');          // jw dla "utworzono przez"
  MaxLengthFOR_abbreviation.Text := GetSystemParam('MaxLengthFOR_abbreviation','1000');    // jw. Dla formy zajêæ
  MaxLengthOwner.Text            := GetSystemParam('MaxLengthOwner','1000');               // jw. Dla "w³aœciciel zajêcia"
  MaxLengthSUB_abbreviation.Text := GetSystemParam('MaxLengthSUB_abbreviation','1000');    // jw. Dla przedmiotu
  CellWidthInLegend.Text         := GetSystemParam('CellWidthInLegend','100');            // szerokoœæ legendy w pikselach (punktach ekranu)
  CellWidthDay.Text              := GetSystemParam('CellWidthDay','');                 // szerokoœæ pierwszej kolumny (dzieñ tygodnia) w pikselach
  CellWidthHour.Text             := GetSystemParam('CellWidthHour','');                // szerokoœæ drugiej kolumny (godziny) w pikselach
  MaxLengthDesc1.Text      := GetSystemParam('MaxLengthDesc1','1000');  // Maksymalna d³ugoœæ opisu w znakach
  MaxLengthDesc2.Text      := GetSystemParam('MaxLengthDesc2','1000');  // Maksymalna d³ugoœæ opisu w znakach
  MaxLengthDesc3.Text      := GetSystemParam('MaxLengthDesc3','1000');  // Maksymalna d³ugoœæ opisu w znakach
  MaxLengthDesc4.Text      := GetSystemParam('MaxLengthDesc4','1000');  // Maksymalna d³ugoœæ opisu w znakach

  If PaperSize.ItemIndex = -1 Then PaperSize.ItemIndex := 0;

  Case PaperSize.ItemIndex Of
   0:Begin Load(Path+'A4'); End;
   1:Begin Load(Path+'A3'); End;
  End;

  showHideEditButton;
end;

procedure TFSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  saveInRegistry;

  Case PaperSize.ItemIndex Of
   0:Begin Save(Path+'A4'); End;
   1:Begin Save(Path+'A3'); End;
  End;

end;

procedure TFSettings.BitBtn1Click(Sender: TObject);
begin
  inherited;
  UUTilityParent.ExecuteFile('regedit.exe','','',SW_SHOWMAXIMIZED)
end;

procedure TFSettings.BWordClick(Sender: TObject);
begin
  inherited;
  SaveInRegistry;
  HTML('Winword.exe');
end;


procedure TFSettings.LHideEmptyRowsClick(Sender: TObject);
begin
   if (Sender as tcheckbox).Checked then
     if not elementEnabled('"Ukrywanie pustych wierszy"','2012.02.29', false) then begin
     (Sender as tcheckbox).Checked := false;
     exit;
     end;
end;

procedure TFSettings.SaveInRegistry;
begin
  setSystemParam('MaxLecturersInLegend',MaxLecturersInLegend.Text);            // maksymalna liczba wyk³adowców przy jednym przedmiocie w legendzie.
  setSystemParam('MaxLengthCALC_GROUPS',MaxLengthCALC_GROUPS.Text);            // maksymalna liczba znaków w pojedynczej komórce oznaczaj¹ca grupê
  setSystemParam('MaxLengthCALC_LECTURERS',MaxLengthCALC_LECTURERS.Text);      // jw. Dla wyk³adowcy
  setSystemParam('MaxLengthCALC_ROOMS',MaxLengthCALC_ROOMS.Text);              // jw dla sali
  setSystemParam('MaxLengthCreated_by',MaxLengthCreated_by.Text);              // jw dla "utworzono przez"
  setSystemParam('MaxLengthFOR_abbreviation',MaxLengthFOR_abbreviation.Text);  // jw. Dla formy zajêæ
  setSystemParam('MaxLengthOwner',MaxLengthOwner.Text);                        // jw. Dla "w³aœciciel zajêcia"
  setSystemParam('MaxLengthSUB_abbreviation',MaxLengthSUB_abbreviation.Text);  // jw. Dla przedmiotu
  setSystemParam('CellWidthInLegend',CellWidthInLegend.Text);                  // szerokoœæ legendy w pikselach (punktach ekranu)
  setSystemParam('CellWidthDay',CellWidthDay.Text);                            // szerokoœæ pierwszej kolumny (dzieñ tygodnia) w pikselach
  setSystemParam('CellWidthHour',CellWidthHour.Text);                          // szerokoœæ drugiej kolumny (godziny) w pikselach

  setSystemParam('MaxLengthDesc1',MaxLengthDesc1.Text);            // Maksymalna d³ugoœæ opisu w znakach
  setSystemParam('MaxLengthDesc2',MaxLengthDesc2.Text);            // Maksymalna d³ugoœæ opisu w znakach
  setSystemParam('MaxLengthDesc3',MaxLengthDesc3.Text);            // Maksymalna d³ugoœæ opisu w znakach
  setSystemParam('MaxLengthDesc4',MaxLengthDesc4.Text);            // Maksymalna d³ugoœæ opisu w znakach

end;

procedure TFSettings.BitBtn2Click(Sender: TObject);
begin
  SaveInRegistry;
  info('Zmiany zosta³y zapisane');
end;

procedure TFSettings.BCloseSettingsClick(Sender: TObject);
begin
  {now execute TFSettings.FormClose}
end;

procedure TFSettings.lLegendModeClick(Sender: TObject);
begin
  if (sender is tradiogroup) then begin
      if (sender as tradiogroup).itemIndex = 1 then
         if not elementEnabled('"Forma zajêæ w legendzie"','2013.06.20', true) then
             (sender as tradiogroup).itemIndex := 0;
  end;
  showHideEditButton;
end;

procedure TFSettings.LLShowLegendClick(Sender: TObject);
begin
 lLegendMode.Visible := (sender as tcheckbox).Checked and (sender as tcheckbox).visible;
end;

procedure TFSettings.gGShowLegendClick(Sender: TObject);
begin
 gLegendMode.Visible := (sender as tcheckbox).Checked and (sender as tcheckbox).visible;
end;

procedure TFSettings.rRShowLegendClick(Sender: TObject);
begin
 rLegendMode.Visible := (sender as tcheckbox).Checked and (sender as tcheckbox).visible;
end;

procedure TFSettings.lhelpClick(Sender: TObject);
begin
  info(
    'Przy definiowaniu nag³ówka i stopki strony mo¿na u¿ywaæ znaczników HTML.'+cr+
  'Mo¿na tak¿e u¿ywaæ symboli: %PERIOD, %LECTURER, %GROUP, %ROOM'
 );

end;

procedure TFSettings.LPdfPrintOutClick(Sender: TObject);
begin
   if (Sender as tcheckbox).Checked then
     if not elementEnabled('"wydruk pdf"','2016.02.17', false) then begin
     (Sender as tcheckbox).Checked := false;
     exit;
     end;

    showHideEditButton;

    lpdfg.visible      := LPdfPrintOut.Checked;
    lpdfl.visible      := LPdfPrintOut.Checked;
    lpdfo.visible      := LPdfPrintOut.Checked;
    lpdfs.visible      := LPdfPrintOut.Checked;

    gpdfg.visible      := gPdfPrintOut.Checked;
    gpdfl.visible      := gPdfPrintOut.Checked;
    gpdfo.visible      := GPdfPrintOut.Checked;
    gpdfs.visible      := gPdfPrintOut.Checked;

    rpdfg.visible      := rPdfPrintOut.Checked;
    rpdfl.visible      := rPdfPrintOut.Checked;
    rpdfo.visible      := rPdfPrintOut.Checked;
    rpdfs.visible      := rPdfPrintOut.Checked;
end;

procedure TFSettings.LHideEmptyRowsBClick(Sender: TObject);
begin
  if FSelectDaysOfWeek = nil then Application.CreateForm(TFSelectDaysOfWeek, FSelectDaysOfWeek);
  FSelectDaysOfWeek.showModalWithDefaults(LHideDows);
  LHideEmptyRows.Checked := LHideDows <> '-------';
end;

procedure TFSettings.GHideEmptyRowsBClick(Sender: TObject);
begin
  if FSelectDaysOfWeek = nil then Application.CreateForm(TFSelectDaysOfWeek, FSelectDaysOfWeek);
  FSelectDaysOfWeek.showModalWithDefaults(GHideDows);
  GHideEmptyRows.Checked := GHideDows <> '-------';
end;

procedure TFSettings.RHideEmptyRowsBClick(Sender: TObject);
begin
  if FSelectDaysOfWeek = nil then Application.CreateForm(TFSelectDaysOfWeek, FSelectDaysOfWeek);
  FSelectDaysOfWeek.showModalWithDefaults(RHideDows);
  RHideEmptyRows.Checked := RHideDows <> '-------';
end;

procedure TFSettings.showHideEditButton;
begin
 BWord.Enabled :=
      ((PageControl.TabIndex=0) and (LPdfPrintOut.Checked=false))
   or ((PageControl.TabIndex=1) and (GPdfPrintOut.Checked=false))
   or ((PageControl.TabIndex=2) and (RPdfPrintOut.Checked=false));
end;

end.
