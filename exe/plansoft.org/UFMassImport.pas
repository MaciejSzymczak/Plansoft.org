unit UFMassImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, OleServer, ExcelXP, UutilityParent,
  ComCtrls, db, ADODB;

type
  TFMassImport = class(TFormConfig)
    OpenDialog: TOpenDialog;
    ExcelApplication: TExcelApplication;
    PC: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    importType: TRadioGroup;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BTemplate: TBitBtn;
    chbTest: TCheckBox;
    BitBtn1: TBitBtn;
    procedure RunImport(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BTemplateClick(Sender: TObject);
    procedure importTypeClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    myQuery: TADOQuery;
  public
    { Public declarations }
  end;

var
  FMassImport: TFMassImport;

implementation

uses DM, UFMain, StrUtils;

{$R *.dfm}

procedure TFMassImport.RunImport(Sender: TObject);
var LCID : Integer;
    lineNum : integer;
    strLineNum : shortString;
    c_col1, c_col2, c_col3, c_col4, c_col5, c_col6, c_col7 : string;
    l_col1, l_col2, l_col3, l_col4, l_col5, l_col6, l_col7, l_colour, l_orguni_id, l_entire : string;
    translatedMessage : string;
    uniqueCheck : TMap;
    uniqueKey : shortString;
    uniqueCheckErrorFlag : boolean;
    uniqueCheckErrorMessage : string;

    function verifyHeader ( cols, expectedCols : string ) : boolean;
    begin
      if lowercase(cols) <> lowercase(expectedCols) then begin
        SError('Ups, czy na pewno u¿yto odpowiedni szablon pliku? Pierwszy wiersz powininen zawieraæ nag³ówek. '+cr + 'POWINNO BYÆ:'+ expectedCols+cr + 'JEST:'+ cols);
        result := false;
        exit;
      end;
      result := true;
    end;

    procedure addPermission( pObjectAlias : string );
    begin
      try
      //LEC_PLA
      DModule.SQL(myQuery, 'INSERT INTO '+pObjectAlias+'_PLA (ID, PLA_ID, '+pObjectAlias+'_ID) VALUES ('+pObjectAlias+'PLA_SEQ.NEXTVAL, '+UserID+',main_seq.currval)');
      if not isBlank(FMain.conrole.Text) then begin
        DModule.SQL(myQuery, 'INSERT INTO '+pObjectAlias+'_PLA (ID, PLA_ID, '+pObjectAlias+'_ID) VALUES ('+pObjectAlias+'PLA_SEQ.NEXTVAL, '+FMain.CONROLE.Text+',main_seq.currval)');
      end;

      Except
       on E:exception do begin
           if AnsiContainsText(E.Message, pObjectAlias+'PLA_'+pObjectAlias+'_FK') then exit;
         End;
      end;
    end;

begin
  if importType.ItemIndex = -1 then begin
    info ('Zaznacz jakie dane chcesz pobraæ');
    exit;
  end;

  myQuery := tadoquery.Create(self);
  dmodule.resetConnection(myQuery);

  if openDialog.Execute then begin
    LCID := GetUserDefaultLCID;
    ExcelApplication.Connect;
    ExcelApplication.Visible[LCID] := true;
    ExcelApplication.Workbooks.Open(opendialog.FileName,
                       EmptyParam, //UpdateLinks: OleVariant
                       EmptyParam, //ReadOnly: OleVariant
                       EmptyParam, //Format: OleVariant
                       EmptyParam, //Password: OleVariant
                       EmptyParam, //WriteResPassword: OleVariant
                       EmptyParam, //IgnoreReadOnlyRecommended: OleVariant
                       EmptyParam, //Orign: OleVariant
                       EmptyParam, //Delimiter: OleVariant
                       EmptyParam, //Editable: OleVariant
                       EmptyParam, //Notify: OleVariant
                       EmptyParam, //Converter: OleVariant
                       EmptyParam, //AddToMru: OleVariant
                       EmptyParam, //local
                       EmptyParam, //corruptload
                       LCID );
    lineNum := 1;
    strLineNum := intToStr ( LineNum );

    c_col1 := ExcelApplication.Range['A'+strLineNum,'A'+strLineNum].Value2;
    c_col2 := ExcelApplication.Range['B'+strLineNum,'B'+strLineNum].Value2;
    c_col3 := ExcelApplication.Range['C'+strLineNum,'C'+strLineNum].Value2;
    c_col4    := ExcelApplication.Range['D'+strLineNum,'D'+strLineNum].Value2;
    c_col5    := ExcelApplication.Range['E'+strLineNum,'E'+strLineNum].Value2;
    c_col6    := ExcelApplication.Range['F'+strLineNum,'F'+strLineNum].Value2;
    c_col7    := ExcelApplication.Range['G'+strLineNum,'G'+strLineNum].Value2;

    l_orguni_id    := dmodule.SingleValue('select min(id) from org_units');

    //check file header
    case importType.ItemIndex of
      0:if not verifyHeader ( c_col1+', '+c_col2+', '+c_col3+', '+c_col4+', '+c_col5+', '+c_col6+', '+c_col7, 'Skrót, Tytu³, Imiê, Nazwisko, Przedmioty, S³owa kluczowe, Integration Id'                                                  ) then exit;
      1:if not verifyHeader ( c_col1+', '+c_col2+', '+c_col3+', '+c_col4+', '+c_col5+', '+c_col6+', '+c_col7, 'Skrót, Nazwa, Liczba studentów, Typ grupy(stacjonarne/niestacjonarne/inne), Dodatkowy opis, S³owa kluczowe, Integration Id') then exit;
      2:if not verifyHeader ( c_col1+', '+c_col2+', '+c_col3+', '+c_col4+', '+c_col5+', '+c_col6,             'Sala, Budynek, Pojemnoœæ, Wyposa¿enie, S³owa kluczowe, Integration Id'                                                     ) then exit;
      3:if not verifyHeader ( c_col1+', '+c_col2+', '+c_col3+', '+c_col4+', '+c_col5,                         'Skrót, Nazwa, Kierunki, S³owa kluczowe, Integration Id'                                                                    ) then exit;
      4:if not verifyHeader ( c_col1+', '+c_col2+', '+c_col3+', '+c_col4,                                     'Skrót, Nazwa, Rodzaj (C=Forma zajêæ R=Forma rezeracji), Integration Id'                                                    ) then exit;
    end;

    uniqueCheck := Tmap.Create;
    uniqueCheck.init(false);
    uniqueCheckErrorFlag := false;
    uniqueCheckErrorMessage := '';

    repeat
      lineNum := lineNum + 1;
      strLineNum := intToStr ( LineNum );
      l_col1 := ExcelApplication.Range['A'+strLineNum,'A'+strLineNum].Value2;
      l_col2 := ExcelApplication.Range['B'+strLineNum,'B'+strLineNum].Value2;
      l_col3 := ExcelApplication.Range['C'+strLineNum,'C'+strLineNum].Value2;
      l_col4 := ExcelApplication.Range['D'+strLineNum,'D'+strLineNum].Value2;
      l_col5 := ExcelApplication.Range['E'+strLineNum,'E'+strLineNum].Value2;
      l_col6 := ExcelApplication.Range['F'+strLineNum,'F'+strLineNum].Value2;
      l_col7 := ExcelApplication.Range['G'+strLineNum,'G'+strLineNum].Value2;
      l_colour       := intToStr( getRandomColor );

      l_entire       := 'Rekord danych:' + cr+ cr + 'Wiersz:' +  strLineNum + cr;
      if c_col1 <> '' then l_entire := l_entire + c_col1 + ':'+ l_col1 + cr;
      if c_col2 <> '' then l_entire := l_entire + c_col2 + ':'+ l_col2 + cr;
      if c_col3 <> '' then l_entire := l_entire + c_col3 + ':'+ l_col3 + cr;
      if c_col4 <> '' then l_entire := l_entire + c_col4 + ':'+ l_col4 + cr;
      if c_col5 <> '' then l_entire := l_entire + c_col5 + ':'+ l_col5 + cr;
      if c_col6 <> '' then l_entire := l_entire + c_col6 + ':'+ l_col6 + cr;
      if c_col7 <> '' then l_entire := l_entire + c_col7 + ':'+ l_col7 + cr;
      l_entire := l_entire + cr +cr;

      case importType.ItemIndex of
        0: uniqueKey := l_col1;
        1: uniqueKey := l_col1;
        2: uniqueKey := l_col1+', '+l_col2;
        3: uniqueKey := l_col1;
        4: uniqueKey := l_col1;
      end;
      if ( uniqueCheck.getIndex(uniqueKey) <> -1 ) then begin
        uniqueCheckErrorMessage := merge( uniqueCheckErrorMessage, format('%s', [uniqueKey]), cr);
        uniqueCheckErrorFlag := true;
      end
      else begin
        uniqueCheck.addKeyValue(uniqueKey, uniqueKey);
        uniqueCheck.prepare;
      end;

      if l_col1 <> '' then begin
        try
          case importType.ItemIndex of
            0: begin
                 dmodule.SQL(myQuery,
                             'merge into lecturers m using dual on (Abbreviation = :abbreviation)'+
	                           ' when not matched then insert (id, abbreviation, title, first_name, last_name, colour, orguni_id, desc1, desc2, integration_id) values (main_seq.nextval, :abbreviation, :title, :first_name, :last_name, :colour, :orguni_id, :desc1, :desc2, :integration_id)'+
                             ' when matched then update set title=:title, first_name=:first_name, last_name=:last_name,  desc1=:desc1, desc2=:desc2, integration_id = :integration_id'
                           , 'abbreviation='+l_col1+';title='+l_col2+';first_name='+l_col3+';last_name='+l_col4+';colour='+l_colour+';orguni_id='+l_orguni_id+';desc1='+l_col5+';desc2='+l_col6+';integration_id='+l_col7);
                 addPermission ('LEC');
               end;
            1: begin
                 if (l_col4<>'STATIONARY') and (l_col4<>'EXTRAMURAL') and (l_col4<>'OTHER') then begin
                   SError('W kolumnie 3 dozwolone wartoœci to: "STATIONARY" lub "EXTRAMURAL" lub "OTHER". Wartoœci te oznaczaj¹ odpowiednio: stacjonarne, niestacjonarne, inne');
                 end;
                 dmodule.SQL(myQuery
                           , 'merge into groups m using dual on (Abbreviation = :abbreviation)'+
                             ' when not matched then insert (id, abbreviation, name, colour, group_type, number_of_peoples, desc1, desc2, integration_id ) values (main_seq.nextval, :abbreviation, :name, :colour, :group_type, :number_of_peoples, :desc1, :desc2, :integration_id)'+
                             ' when matched then update set name=:name, group_type=:group_type, number_of_peoples=:number_of_peoples, desc1=:desc1, desc2=:desc2, integration_id = :integration_id'
                           , 'abbreviation='+l_col1+';name='+l_col2+';colour='+l_colour+';group_type='+l_col4+';number_of_peoples='+l_col3+';desc1='+l_col5+';desc2='+l_col6+';integration_id='+l_col7);
                 addPermission ('GRO');
               end;
            2: begin
                 dmodule.SQL(myQuery
                            , 'merge into rooms m using dual on (name = :name and attribs_01 = :attribs_01)'+
	                            ' when not matched then insert (id, name, colour, rescat_id, attribs_01, attribn_01, desc1, desc2, integration_id) values (main_seq.nextval, :name, :colour, :rescat_id, :attribs_01, :attribn_01, :desc1, :desc2, :integration_id)'+
		                          ' when matched then update set attribn_01 = :attribn_01, desc1=:desc1, desc2=:desc2, integration_id = :integration_id'
                            , 'name='+l_col1+';colour='+l_colour+';rescat_id=1;attribs_01='+l_col2+';attribn_01='+l_col3+';desc1='+l_col4+';desc2='+l_col5+';integration_id='+l_col6);
                 addPermission ('ROM');
               end;
            3: begin
                 dmodule.SQL(myQuery
                           , 'merge into subjects m using dual on (Abbreviation = :abbreviation)'+
                             ' when not matched then insert (id, abbreviation, name, colour, desc1, desc2, integration_id) values (main_seq.nextval, :abbreviation, :name, :colour, :desc1, :desc2, :integration_id)'+
                             ' when matched then update set name=:name, desc1=:desc1, desc2=:desc2, integration_id = :integration_id'
                           , 'abbreviation='+l_col1+';name='+l_col2+';colour='+l_colour+';desc1='+l_col3+';desc2='+l_col4+';integration_id='+l_col5);
                 addPermission ('SUB');
               end;
            4: begin
                 if (l_col3<>'C') and (l_col3<>'R') then begin
                   SError('W kolumnie 3 dozwolone wartoœci to: "C" lub "R". C=rodzaj zajêcia. R=rodzaj rezerwacji');
                 end;
                 dmodule.SQL(myQuery
                           , 'merge into forms m using dual on (Abbreviation = :abbreviation)'+
                             ' when not matched then insert (id, abbreviation, name, kind, colour, integration_id) values (main_seq.nextval, :abbreviation, :name, :kind, :colour, :integration_id)'+
                             ' when matched then update set name=:name, kind=:kind, integration_id = :integration_id'
                           , 'abbreviation='+l_col1+';name='+l_col2+';kind='+l_col3+';colour='+l_colour+';integration_id='+l_col4);
                 addPermission ('FOR');
               end;
          end;
        except
        on E:exception Do Begin
          If Pos(sKeyViolation, E.Message)<>0 Then Begin
           if DBMap.get (E.Message, translatedMessage) then begin
             dmodule.RollbackTrans;
             SError(l_entire + translatedMessage);
             abort;
           end;
           dmodule.RollbackTrans;
           SError(l_entire + 'Taki rekord ju¿ wprowadzono. Komunikat z bazy danych: ' + E.Message);
           abort;
          End
          else begin
           dmodule.RollbackTrans;
           SError(l_entire + 'Komunikat z bazy danych: ' + E.Message);
           Abort;
          end;
        End
          Else begin
            dmodule.RollbackTrans;
            SError(l_entire + 'Wyst¹pi³ inny b³¹d');
          end;
        end;
      end;
    until l_col1 = '';

    uniqueCheck.Free;

    if (uniqueCheckErrorFlag) then begin
      uniqueCheckErrorMessage := 'Dane nie zosta³y zapisane, poniewa¿ ka¿dy rekord musi posiadaæ jednoznaczny skrót. Popraw proszê plik excel i spróbuj ponownie.'+cr+'Wartoœci wystêpuj¹ce w pliku wielokrotnie:'+cr+cr+uniqueCheckErrorMessage+cr+cr+'Aby u³atwiæ znalezienie rekordów do poprawienia, skopiowano ten komunikat do schowka.';
      Info( uniqueCheckErrorMessage );
      copyToClipboard( uniqueCheckErrorMessage );
      dmodule.RollbackTrans;
      Abort;
    end;

    if chbTest.Checked then begin
      dmodule.RollbackTrans;
      info('Rekordy s¹ prawid³owe, dane nie zosta³y zapisane w bazie danych (uruchomienie testowe).'+cr+cr+' Liczba zapisanych rekordów:' + intToStr(lineNum-2) );
    end
    else
    begin
      importType.ItemIndex := -1;
      PC.ActivePageIndex := 0;
      dmodule.CommitTrans;
      info('Rekordy zosta³y pomyœlnie zapisane.'+cr+cr+' Liczba zapisanych rekordów:' + intToStr(lineNum-2) );
    end;

    ExcelApplication.Disconnect;
    //ExcelApplication.Quit;
    //ExcelApplication.ActiveWorkbook.ActiveSheet.
  end;

end;

procedure TFMassImport.BitBtn2Click(Sender: TObject);
begin
chbTest.Checked := true;
RunImport(nil);
end;

procedure TFMassImport.BitBtn3Click(Sender: TObject);
begin
chbTest.Checked := false;
RunImport(nil);
end;

procedure TFMassImport.BTemplateClick(Sender: TObject);
begin
  case importType.ItemIndex of
   0: webBrowser('http://www.plansoft.org/wp-content/uploads/xlsx/wykladowcy.xlsx');
   1: webBrowser('http://www.plansoft.org/wp-content/uploads/xlsx/grupy.xlsx');
   2: webBrowser('http://www.plansoft.org/wp-content/uploads/xlsx/sale.xlsx');
   3: webBrowser('http://www.plansoft.org/wp-content/uploads/xlsx/przedmioty.xlsx');
   4: webBrowser('http://www.plansoft.org/wp-content/uploads/xlsx/formy_zajec.xlsx');
  end;
  PC.ActivePageIndex := 2;
end;

procedure TFMassImport.importTypeClick(Sender: TObject);
begin
  if importType.ItemIndex <> -1 then
      PC.ActivePageIndex := 1;
end;

procedure TFMassImport.BitBtn1Click(Sender: TObject);
begin
  PC.ActivePageIndex := 2;
end;

end.
