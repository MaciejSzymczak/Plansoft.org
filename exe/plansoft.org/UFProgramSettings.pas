unit UFProgramSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, UFMain, UUtilityParent,
  Grids, ValEdit, ComCtrls, autocreate;

type
  TFProgramSettings = class(TFormConfig)
    Panel1: TPanel;
    BZamknij: TBitBtn;
    Pages: TPageControl;
    TabSheet1: TTabSheet;
    TabNumbering: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    info: TEdit;
    MaxNumberOfSheets: TEdit;
    Label2: TLabel;
    Example: TLabel;
    BRunMonitor: TButton;
    SAdvanced: TTabSheet;
    TabSheet3: TTabSheet;
    profileType: TComboBox;
    Label3: TLabel;
    profileObjectNamePeriod: TEdit;
    profileObjectNamePeriods: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    profileObjectNameL: TEdit;
    profileObjectNameLs: TEdit;
    Label7: TLabel;
    profileObjectNameG: TEdit;
    profileObjectNameGs: TEdit;
    Label8: TLabel;
    profileObjectNameC1s: TEdit;
    profileObjectNameC1: TEdit;
    Label10: TLabel;
    profileObjectNameC2s: TEdit;
    profileObjectNameC2: TEdit;
    Label11: TLabel;
    profileObjectNameClasses: TEdit;
    profileObjectNameClass: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    profileObjectNamePlanner: TEdit;
    profileObjectNamePlanners: TEdit;
    Label9: TLabel;
    profileObjectNamePeriodacc: TEdit;
    profileObjectNameClassacc: TEdit;
    profileObjectNamePlanneracc: TEdit;
    profileObjectNameLacc: TEdit;
    profileObjectNameGacc: TEdit;
    profileObjectNameC1acc: TEdit;
    profileObjectNameC2acc: TEdit;
    Label14: TLabel;
    profileObjectNamePeriodgen: TEdit;
    profileObjectNameClassgen: TEdit;
    profileObjectNamePlannergen: TEdit;
    profileObjectNameLgen: TEdit;
    profileObjectNameGgen: TEdit;
    profileObjectNameC1gen: TEdit;
    profileObjectNameC2gen: TEdit;
    Button1: TButton;
    TabClassDesc: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    pClassDesc4GlobalPlural: TEdit;
    pClassDesc3GlobalPlural: TEdit;
    pClassDesc2GlobalPlural: TEdit;
    pClassDesc1GlobalPlural: TEdit;
    Label20: TLabel;
    BGrid: TBitBtn;
    Label21: TLabel;
    GroupBox1: TGroupBox;
    SQLLog: TCheckBox;
    GroupBox2: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    EditFontSize: TEdit;
    FontSize: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    tablefilterjs: TMemo;
    filtergridcss: TMemo;
    actbjs: TMemo;
    Label19: TLabel;
    pClassDesc1GlobalSingular: TEdit;
    pClassDesc2GlobalSingular: TEdit;
    pClassDesc3GlobalSingular: TEdit;
    pClassDesc4GlobalSingular: TEdit;
    SpeedButton1: TSpeedButton;
    CopyField1: TComboBox;
    Label31: TLabel;
    CopyField2: TComboBox;
    CopyField3: TComboBox;
    CopyField4: TComboBox;
    KillSessions: TCheckBox;
    procedure BRunMonitorClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MaxNumberOfSheetsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SQLLogClick(Sender: TObject);
    procedure profileTypeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PagesChange(Sender: TObject);
    procedure BGridClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure pClassDesc1GlobalSingularChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure loadConfiguration;
    function translateMessages     ( s : string  ) : string;
    function getClassDescPlural    ( i : integer ) : string;
    function getClassDescSingular  ( i : integer ) : string;
    procedure generateJsFiles;
  end;

var
  FProgramSettings: TFProgramSettings;

implementation

{$R *.dfm}

uses dm;

procedure TFProgramSettings.BRunMonitorClick(Sender: TObject);
begin
  inherited;
  UUtilityParent.ExecuteFile('MemoryStatus.exe','','',SW_SHOWNORMAL);
end;

procedure TFProgramSettings.FormCloseQuery(Sender: TObject;
var CanClose: Boolean);

    function isHour ( s : string ) : boolean;
    var h,m : integer;
    begin
    try
      if s <>'' then begin
        h := strtoint(copy(s,1,2));
        m := strtoint(copy(s,4,2));
        EncodeTime(h, m, 0, 0);
      end;
      result := true;
    Except
      serror ( sysutils.format('Wartoœæ "%s" nie jest godzin¹ w formacie gg:mm, np. 12:30', [s]) );
      result := false;
    end;
    end;

begin
  inherited;
  try
     canClose := true;
     setSystemParam('MaxNumberOfSheets', intToStr(strToint(MaxNumberOfSheets.Text)) );
     SetSystemParam('Form.DefaultEditFontSize',intToStr(strToint(EditFontSize.Text)));
     SetSystemParam('Form.DefaultFontSize'    ,intToStr(strToint(FontSize.Text)));
     SetSystemParam('KillSessions', BoolToStr(KillSessions.checked) );
  except
   SError('Maksymalna liczba buforowanych arkuszy musi byæ liczb¹. Rozmiary czcionek musz¹ byæ liczbami');
   canClose := false;
  end;

  SetSystemParam('profileType'               , intToStr( profileType.ItemIndex ) );

  SetSystemParam('profileObjectNameClass'    , profileObjectNameClass.Text);
  SetSystemParam('profileObjectNameClasses'  , profileObjectNameClasses.Text);
  SetSystemParam('profileObjectNameClassacc' , profileObjectNameClassacc.Text);
  SetSystemParam('profileObjectNameClassgen' , profileObjectNameClassgen.Text);

  dmodule.SQL('begin update resource_categories set name=:name, plural_name=:name_pl, name_accusative=:name_acc, name_genitive=:name_gen where id = :id; commit; end;', 'name='+profileObjectNamePeriod.Text+';name_pl='+profileObjectNamePeriods.Text+';name_acc='+profileObjectNamePeriodacc.Text+';name_gen='+profileObjectNamePeriodgen.Text+';id=-7');
  dmodule.SQL('begin update resource_categories set name=:name, plural_name=:name_pl, name_accusative=:name_acc, name_genitive=:name_gen where id = :id; commit; end;', 'name='+profileObjectNamePlanner.Text+';name_pl='+profileObjectNamePlanners.Text+';name_acc='+profileObjectNamePlanneracc.Text+';name_gen='+profileObjectNamePlannergen.Text+';id=-6');
  dmodule.SQL('begin update resource_categories set name=:name, plural_name=:name_pl, name_accusative=:name_acc, name_genitive=:name_gen where id = :id; commit; end;', 'name='+profileObjectNameG.Text+';name_pl='+profileObjectNameGs.Text+';name_acc='+profileObjectNameGacc.Text+';name_gen='+profileObjectNameGgen.Text+';id=-5');
  dmodule.SQL('begin update resource_categories set name=:name, plural_name=:name_pl, name_accusative=:name_acc, name_genitive=:name_gen where id = :id; commit; end;', 'name='+profileObjectNameL.Text+';name_pl='+profileObjectNameLs.Text+';name_acc='+profileObjectNameLacc.Text+';name_gen='+profileObjectNameLgen.Text+';id=-4');
  dmodule.SQL('begin update resource_categories set name=:name, plural_name=:name_pl, name_accusative=:name_acc, name_genitive=:name_gen where id = :id; commit; end;', 'name='+profileObjectNameC1.Text+';name_pl='+profileObjectNameC1s.Text+';name_acc='+profileObjectNameC1acc.Text+';name_gen='+profileObjectNameC1gen.Text+';id=-3');
  dmodule.SQL('begin update resource_categories set name=:name, plural_name=:name_pl, name_accusative=:name_acc, name_genitive=:name_gen where id = :id; commit; end;', 'name='+profileObjectNameC2.Text+';name_pl='+profileObjectNameC2s.Text+';name_acc='+profileObjectNameC2acc.Text+';name_gen='+profileObjectNameC2gen.Text+';id=-2');

  dmodule.dbsetSystemParam('CLASS_DESC1', pClassDesc1GlobalPlural.text);
  dmodule.dbsetSystemParam('CLASS_DESC2', pClassDesc2GlobalPlural.text);
  dmodule.dbsetSystemParam('CLASS_DESC3', pClassDesc3GlobalPlural.text);
  dmodule.dbsetSystemParam('CLASS_DESC4', pClassDesc4GlobalPlural.text);

  dmodule.dbsetSystemParam('CLASS_DESC1S', pClassDesc1GlobalSingular.text);
  dmodule.dbsetSystemParam('CLASS_DESC2S', pClassDesc2GlobalSingular.text);
  dmodule.dbsetSystemParam('CLASS_DESC3S', pClassDesc3GlobalSingular.text);
  dmodule.dbsetSystemParam('CLASS_DESC4S', pClassDesc4GlobalSingular.text);

  dmodule.dbsetSystemParam('COPY_FIELD1', IntToStr(CopyField1.itemIndex));
  dmodule.dbsetSystemParam('COPY_FIELD2', IntToStr(CopyField2.itemIndex));
  dmodule.dbsetSystemParam('COPY_FIELD3', IntToStr(CopyField3.itemIndex));
  dmodule.dbsetSystemParam('COPY_FIELD4', IntToStr(CopyField4.itemIndex));


end;

procedure TFProgramSettings.MaxNumberOfSheetsChange(Sender: TObject);
begin
  inherited;
  try
  example.Caption :=
    'Przyk³adowy rozmiar bufora: 180 dni * 8 godz. * '+info.text+' * '+MaxNumberOfSheets.Text+' * 3 ( trzy osobne zestawy arkuszy dla '+profileObjectNameLgen.Text+', '+profileObjectNameGgen.text +' i zasobu) = ' +
       formatFloat('###,###,###,###,###',((180 * 8 * strToInt (info.text) * strToInt (MaxNumberOfSheets.Text) * 3) div (1024*1024))) + ' MB';
  except
    example.Caption := '<b³¹d>';
  end;
end;

procedure TFProgramSettings.FormShow(Sender: TObject);
begin
  inherited;
  EditFontSize.Text := GetSystemParam('Form.DefaultEditFontSize','8');
  FontSize.Text     := GetSystemParam('Form.DefaultFontSize','8');
  KillSessions.checked := StrToBool( GetSystemParam('KillSessions', '+' ) );
  MaxNumberOfSheetsChange(nil);
  activeControl := BZamknij;
end;



procedure TFProgramSettings.SQLLogClick(Sender: TObject);
begin
  inherited;
 if SQLLog.Checked then uutilityparent.info('W lokalizacji '+uutilityParent.ApplicationDocumentsPath + ' zostanie utworzony log SQL');
end;

procedure TFProgramSettings.profileTypeChange(Sender: TObject);
begin
  inherited;

  case profileType.ItemIndex of
   0:begin
     profileObjectNamePeriod.Text   := 'Semestr';
     profileObjectNamePeriods.Text  := 'Semestry';
     profileObjectNamePeriodacc.Text:= 'semestr';
     profileObjectNamePeriodgen.Text:= 'semestru';
     profileObjectNameClass.Text    := 'Zajêcie';
     profileObjectNameClasses.Text  := 'Zajêcia';
     profileObjectNameClassacc.Text := 'zajêcie';
     profileObjectNameClassgen.Text := 'zajêcia';
     profileObjectNamePlanner.Text  := 'Planista';
     profileObjectNamePlanners.Text := 'Planiœci';
     profileObjectNamePlanneracc.Text:= 'planistê';
     profileObjectNamePlannergen.Text:= 'planisty';
     profileObjectNameL.Text        := 'Wyk³adowca';
     profileObjectNameLs.Text       := 'Wyk³adowcy';
     profileObjectNameLacc.Text     := 'wyk³adowcê';
     profileObjectNameLgen.Text     := 'wyk³adowcy';
     profileObjectNameG.Text        := 'Grupa';
     profileObjectNameGs.Text       := 'Grupy';
     profileObjectNameGacc.Text     := 'grupê';
     profileObjectNameGgen.Text     := 'grupy';
     profileObjectNameC1.Text       := 'Przedmiot';
     profileObjectNameC1s.Text      := 'Przedmioty';
     profileObjectNameC1acc.Text    := 'przedmiot';
     profileObjectNameC1gen.Text    := 'przedmiotu';
     profileObjectNameC2.Text       := 'Forma';
     profileObjectNameC2s.Text      := 'Formy';
     profileObjectNameC2acc.Text    := 'formê';
     profileObjectNameC2gen.Text    := 'formy';
     end;
   1:begin
     profileObjectNamePeriod.Text    := 'Okres';
     profileObjectNamePeriods.Text   := 'Okresy';
     profileObjectNamePeriodacc.Text := 'okres';
     profileObjectNamePeriodgen.Text := 'okresu';
     profileObjectNameClass.Text     := 'Wizyta';
     profileObjectNameClasses.Text   := 'Wizyty';
     profileObjectNameClassacc.Text  := 'wizytê';
     profileObjectNameClassgen.Text  := 'wizyty';
     profileObjectNamePlanner.Text   := 'Recepcjonista';
     profileObjectNamePlanners.Text  := 'Recepcjoniœci';
     profileObjectNamePlanneracc.Text:= 'recepcjonistê';
     profileObjectNamePlannergen.Text:= 'recepcjonisty';
     profileObjectNameL.Text         := 'Lekarz';
     profileObjectNameLs.Text        := 'Lekarze';
     profileObjectNameLacc.Text      := 'lekarza';
     profileObjectNameLgen.Text      := 'lekarza';
     profileObjectNameG.Text         := 'Pacjent';
     profileObjectNameGs.Text        := 'Pacjenci';
     profileObjectNameGacc.Text      := 'pacjenta';
     profileObjectNameGgen.Text      := 'pacjenta';
     profileObjectNameC1.Text        := 'Cel wizyty';
     profileObjectNameC1s.Text       := 'Cele wizyt';
     profileObjectNameC1acc.Text     := 'cel wizyty';
     profileObjectNameC1gen.Text     := 'celu wizyty';
     profileObjectNameC2.Text        := 'Klas. dodatkowa';
     profileObjectNameC2s.Text       := 'Klas. dodatkowe';
     profileObjectNameC2acc.Text     := 'Klas. dodatkow¹';
     profileObjectNameC2gen.Text     := 'Klas. dodatkowej';
     end;
   2:begin
     profileObjectNamePeriod.Text    := 'okres';
     profileObjectNamePeriods.Text   := 'okresy';
     profileObjectNamePeriodacc.Text := 'okres';
     profileObjectNamePeriodgen.Text := 'okresu';
     profileObjectNameClass.Text     := 'praca';
     profileObjectNameClasses.Text   := 'prace';
     profileObjectNameClassacc.Text  := 'pracê';
     profileObjectNameClassgen.Text  := 'pracy';
     profileObjectNamePlanner.Text   := 'pracownik';
     profileObjectNamePlanners.Text  := 'pracownicy';
     profileObjectNamePlanneracc.Text:= 'pracownika';
     profileObjectNamePlannergen.Text:= 'pracownika';
     profileObjectNameL.Text         := 'pracownik';
     profileObjectNameLs.Text        := 'pracownicy';
     profileObjectNameLacc.Text      := 'pracownika';
     profileObjectNameLgen.Text      := 'pracownika';
     profileObjectNameG.Text         := 'stanowisko';
     profileObjectNameGs.Text        := 'stanowiska';
     profileObjectNameGacc.Text      := 'stanowisko';
     profileObjectNameGgen.Text      := 'stanowiska';
     profileObjectNameC1.Text        := 'status';
     profileObjectNameC1s.Text       := 'statusy';
     profileObjectNameC1acc.Text     := 'status';
     profileObjectNameC1gen.Text     := 'statusu';
     profileObjectNameC2.Text        := 'zadanie';
     profileObjectNameC2s.Text       := 'zadania';
     profileObjectNameC2acc.Text     := 'zadanie';
     profileObjectNameC2gen.Text     := 'zadania';
     end;
   3:begin uutilityparent.info('Teraz mo¿esz wprowadziæ samodzielnie nazwy, które bêd¹ wyœwietlane na formularzach'); end;
  end;

  {
  }

end;

procedure TFProgramSettings.Button1Click(Sender: TObject);
begin
  SetSystemParam('FBrowseCLASSES','Restore');
  uutilityparent.info ('Aby wszystkie zmiany zosta³y zastosowane, nale¿y teraz uruchomiæ skrypt SQL. a nastêpnie uruchomiæ program ponownie. '+cr+'Szczegó³y w instrukcji instalacji.');
  {
  if profileType.ItemIndex = 0 then begin
    dmodule.SQL('begin update resource_categories set name = :name where id = :id; commit; end;', 'name=Sala;id=1');
    dmodule.SQL('begin update resource_categories set name = :name where id = :id; commit; end;', 'name=Rzutnik;id=2');
  end else begin
    dmodule.SQL('begin update resource_categories set name = :name where id = :id; commit; end;', 'name=Gabinet;id=1');
    dmodule.SQL('begin update resource_categories set name = :name where id = :id; commit; end;', 'name=RTG;id=2');
  end;
  }
end;

procedure TFProgramSettings.loadConfiguration;
begin

  pClassDesc1GlobalPlural.text := dmodule.dbgetSystemParam('CLASS_DESC1');
  pClassDesc2GlobalPlural.text := dmodule.dbgetSystemParam('CLASS_DESC2');
  pClassDesc3GlobalPlural.text := dmodule.dbgetSystemParam('CLASS_DESC3');
  pClassDesc4GlobalPlural.text := dmodule.dbgetSystemParam('CLASS_DESC4');

  pClassDesc1GlobalSingular.text := dmodule.dbgetSystemParam('CLASS_DESC1S');
  pClassDesc2GlobalSingular.text := dmodule.dbgetSystemParam('CLASS_DESC2S');
  pClassDesc3GlobalSingular.text := dmodule.dbgetSystemParam('CLASS_DESC3S');
  pClassDesc4GlobalSingular.text := dmodule.dbgetSystemParam('CLASS_DESC4S');

  CopyField1.itemIndex := strToInt(dmodule.dbgetSystemParam('COPY_FIELD1','-1'));
  CopyField2.itemIndex := strToInt(dmodule.dbgetSystemParam('COPY_FIELD2','-1'));
  CopyField3.itemIndex := strToInt(dmodule.dbgetSystemParam('COPY_FIELD3','-1'));
  CopyField4.itemIndex := strToInt(dmodule.dbgetSystemParam('COPY_FIELD4','-1'));


  info.Text := intToStr( sizeOf (TClass_) );
  MaxNumberOfSheets.Text := GetSystemParam('MaxNumberOfSheets','60');

  profileType.ItemIndex           := strToInt ( GetSystemParam('profileType'   , '0') );

  with dmodule do begin
      openSQL('select id, name, plural_name, name_accusative, name_genitive from resource_categories where id in (-2,-3,-4,-5,-6,-7) order by id');
      Qwork.First;
      //showmessage( 'teraz ' +  QWork.fieldByName('ID').AsString );
      profileObjectNamePeriod.Text    := QWork.fieldByName('NAME').AsString;
      profileObjectNamePeriods.Text   := QWork.fieldByName('PLURAL_NAME').AsString;
      profileObjectNamePeriodacc.Text := QWork.fieldByName('NAME_ACCUSATIVE').AsString;
      profileObjectNamePeriodgen.Text := QWork.fieldByName('NAME_GENITIVE').AsString;
      dmodule.QWork.Next;
      //showmessage('teraz ' +  QWork.fieldByName('ID').AsString );
      profileObjectNamePlanner.Text   := QWork.fieldByName('NAME').AsString;
      profileObjectNamePlanners.Text  := QWork.fieldByName('PLURAL_NAME').AsString;
      profileObjectNamePlanneracc.Text:= QWork.fieldByName('NAME_ACCUSATIVE').AsString;
      profileObjectNamePlannergen.Text:= QWork.fieldByName('NAME_GENITIVE').AsString;
      dmodule.QWork.Next;
      //showmessage('teraz ' +  QWork.fieldByName('ID').AsString );
      profileObjectNameG.Text         := QWork.fieldByName('NAME').AsString;
      profileObjectNameGs.Text        := QWork.fieldByName('PLURAL_NAME').AsString;
      profileObjectNameGacc.Text      := QWork.fieldByName('NAME_ACCUSATIVE').AsString;
      profileObjectNameGgen.Text      := QWork.fieldByName('NAME_GENITIVE').AsString;
      dmodule.QWork.Next;
      //showmessage('teraz ' +  QWork.fieldByName('ID').AsString );
      profileObjectNameL.Text         := QWork.fieldByName('NAME').AsString;
      profileObjectNameLs.Text        := QWork.fieldByName('PLURAL_NAME').AsString;
      profileObjectNameLacc.Text      := QWork.fieldByName('NAME_ACCUSATIVE').AsString;
      profileObjectNameLgen.Text      := QWork.fieldByName('NAME_GENITIVE').AsString;
      dmodule.QWork.Next;
      profileObjectNameC1.Text        := QWork.fieldByName('NAME').AsString;
      profileObjectNameC1s.Text       := QWork.fieldByName('PLURAL_NAME').AsString;
      profileObjectNameC1acc.Text     := QWork.fieldByName('NAME_ACCUSATIVE').AsString;
      profileObjectNameC1gen.Text     := QWork.fieldByName('NAME_GENITIVE').AsString;
      dmodule.QWork.Next;
      profileObjectNameC2.Text        := QWork.fieldByName('NAME').AsString;
      profileObjectNameC2s.Text       := QWork.fieldByName('PLURAL_NAME').AsString;
      profileObjectNameC2acc.Text     := QWork.fieldByName('NAME_ACCUSATIVE').AsString;
      profileObjectNameC2gen.Text     := QWork.fieldByName('NAME_GENITIVE').AsString;
  end;

  //no data in table resource_categories ? set default data.
  if profileObjectNamePeriodgen.Text = '' then profileTypeChange(nil);

  profileObjectNameClass.Text     := GetSystemParam('profileObjectNameClass'   , 'Zajêcie');
  profileObjectNameClasses.Text   := GetSystemParam('profileObjectNameClasses' , 'zajêcia');
  profileObjectNameClassacc.Text  := GetSystemParam('profileObjectNameClassacc', 'zajêcie');
  profileObjectNameClassgen.Text  := GetSystemParam('profileObjectNameClassgen', 'zajêcia');
end;

function TFProgramSettings.translateMessages(s: string): string;
begin
  s := replace(s, '%L.'         , fprogramsettings.profileObjectNameL.Text);
  s := replace(s, '%Ls.'        , fprogramsettings.profileObjectNameLs.Text);
  s := replace(s, '%Lacc.'      , fprogramsettings.profileObjectNameLacc.Text);
  s := replace(s, '%Lgen.'      , fprogramsettings.profileObjectNameLgen.Text);
  s := replace(s, '%G.'         , fprogramsettings.profileObjectNameG.Text);
  s := replace(s, '%Gs.'        , fprogramsettings.profileObjectNameGs.Text);
  s := replace(s, '%Gacc.'      , fprogramsettings.profileObjectNameGacc.Text);
  s := replace(s, '%Ggen.'      , fprogramsettings.profileObjectNameGgen.Text);
  s := replace(s, '%C1.'        , fprogramsettings.profileObjectNameC1.Text);
  s := replace(s, '%C1s.'       , fprogramsettings.profileObjectNameC1s.Text);
  s := replace(s, '%C1acc.'     , fprogramsettings.profileObjectNameC1acc.Text);
  s := replace(s, '%C1gen.'     , fprogramsettings.profileObjectNameC1gen.Text);
  s := replace(s, '%C2.'        , fprogramsettings.profileObjectNameC2.Text);
  s := replace(s, '%C2s.'       , fprogramsettings.profileObjectNameC2s.Text);
  s := replace(s, '%C2acc.'     , fprogramsettings.profileObjectNameC2acc.Text);
  s := replace(s, '%C2gen.'     , fprogramsettings.profileObjectNameC2gen.Text);
  s := replace(s, '%PERIOD.'    , fprogramsettings.profileObjectNamePeriod.Text);
  s := replace(s, '%PERIODs.'   , fprogramsettings.profileObjectNamePeriods.Text);
  s := replace(s, '%PERIODacc.' , fprogramsettings.profileObjectNamePeriodacc.Text);
  s := replace(s, '%PERIODgen.' , fprogramsettings.profileObjectNamePeriodgen.Text);
  s := replace(s, '%PLANNER.'   , fprogramsettings.profileObjectNamePlanner.Text);
  s := replace(s, '%PLANNERs.'  , fprogramsettings.profileObjectNamePlanners.Text);
  s := replace(s, '%PLANNERacc.', fprogramsettings.profileObjectNamePlanneracc.Text);
  s := replace(s, '%PLANNERgen.', fprogramsettings.profileObjectNamePlannergen.Text);
  s := replace(s, '%CLASS.'     , fprogramsettings.profileObjectNameClass.Text);
  s := replace(s, '%CLASSes.'   , fprogramsettings.profileObjectNameClasses.Text);
  s := replace(s, '%CLASSacc.'  , fprogramsettings.profileObjectNameClassacc.Text);
  s := replace(s, '%CLASSgen.'  , fprogramsettings.profileObjectNameClassgen.Text);
  result := s;
end;

function TFProgramSettings.getClassDescPlural(i: integer): string;
begin
 case i of
   1: result := pClassDesc1GlobalPlural.text;
   2: result := pClassDesc2GlobalPlural.text;
   3: result := pClassDesc3GlobalPlural.text;
   4: result := pClassDesc4GlobalPlural.text;
  end;
end;

function TFProgramSettings.getClassDescSingular(i: integer): string;
begin
 case i of
   1: result := pClassDesc1GlobalSingular.text;
   2: result := pClassDesc2GlobalSingular.text;
   3: result := pClassDesc3GlobalSingular.text;
   4: result := pClassDesc4GlobalSingular.text;
  end;
end;


procedure TFProgramSettings.PagesChange(Sender: TObject);
begin
  if Pages.ActivePage = TabClassDesc then begin
    if not elementEnabled('"Komentarze dla zajêæ"','2012.06.21', false) then Pages.ActivePage := TabNumbering;
  end;
end;

procedure TFProgramSettings.BGridClick(Sender: TObject);
begin
  autocreate.GRIDSShowModalAsBrowser;
end;

procedure TFProgramSettings.generateJsFiles;
var tmpFile : textfile;
begin
  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'actb.js');
  rewrite(tmpFile);
  writeln(tmpFile, actbjs.lines.Text );
  closeFile(tmpFile);

  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'filtergrid.css');
  rewrite(tmpFile);
  writeln(tmpFile, filtergridcss.lines.Text );
  closeFile(tmpFile);

  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'tablefilter.js');
  rewrite(tmpFile);
  writeln(tmpFile, tablefilterjs.lines.Text );
  closeFile(tmpFile);
end;

procedure TFProgramSettings.SpeedButton1Click(Sender: TObject);
begin
  showmessage('Ta etykieta pojawi siê w raportach, w sekcji wyk³adowca');
end;

procedure TFProgramSettings.pClassDesc1GlobalSingularChange(
  Sender: TObject);
begin
  if not elementEnabled('"Planowanie zajêæ równoleg³ych"','2015.10.17', false) then begin
   (Sender as TEdit).Text :='';
   exit;
  end;
end;

end.
