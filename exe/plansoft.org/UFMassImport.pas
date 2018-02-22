unit UFMassImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, OleServer, ExcelXP, UutilityParent;

type
  TFMassImport = class(TFormConfig)
    OpenDialog: TOpenDialog;
    ExcelApplication: TExcelApplication;
    importType: TRadioGroup;
    Memo1: TMemo;
    chbTest: TCheckBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMassImport: TFMassImport;

implementation

uses DM, UFMain;

{$R *.dfm}

procedure TFMassImport.BitBtn1Click(Sender: TObject);
var LCID : Integer;
    lineNum : integer;
    strLineNum : shortString;
    c_col1, c_col2, c_col3, c_col4 : string;
    l_col1, l_col2, l_col3, l_col4, l_colour, l_orguni_id, l_entire : string;
    translatedMessage : string;

    function verifyHeader ( cols, expectedCols : string ) : boolean;
    begin
      if cols <> expectedCols then begin
        SError('B��dny nag��wek pliku. W kom�rkach A1, B1, C1 i D1 powinny odpowiednio znajdowa� si� nag��wki: ' + expectedCols + cr+' W wierszu 2 oraz w kolejnych powinny znajdowa� si� dane do pobrania zgodnie z nag��wkiem pliku');
        result := false;
        exit;
      end;
      result := true;
    end;

    procedure addPermission( pObjectAlias : string );
    begin
      //LEC_PLA
      DModule.SQL('INSERT INTO '+pObjectAlias+'_PLA (ID, PLA_ID, '+pObjectAlias+'_ID) VALUES ('+pObjectAlias+'PLA_SEQ.NEXTVAL, '+UserID+',main_seq.currval)');
      if not isBlank(FMain.conrole.Text) then begin
        DModule.SQL('INSERT INTO '+pObjectAlias+'_PLA (ID, PLA_ID, '+pObjectAlias+'_ID) VALUES ('+pObjectAlias+'PLA_SEQ.NEXTVAL, '+FMain.CONROLE.Text+',main_seq.currval)');
      end;
    end;

begin
  if importType.ItemIndex = -1 then begin
    info ('Zaznacz jakie dane chcesz pobra�');
    exit;
  end;

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

    l_orguni_id    := dmodule.SingleValue('select min(id) from org_units');

    //check file header
    case importType.ItemIndex of
      0:if not verifyHeader ( c_col1+', '+c_col2+', '+c_col3+', '+c_col4, 'Skr�t, Tytu�, Imi�, Nazwisko'                                   ) then exit;
      1:if not verifyHeader ( c_col1+', '+c_col2+', '+c_col3+', '+c_col4, 'Skr�t, Nazwa, Liczba student�w, Typ grupy(stacjonarne/niestacjonarne/inne)') then exit;
      2:if not verifyHeader ( c_col1+', '+c_col2,                         'Sala, Budynek'                                                  ) then exit;
      3:if not verifyHeader ( c_col1+', '+c_col2,                         'Skr�t, Nazwa'                                                   ) then exit;
      4:if not verifyHeader ( c_col1+', '+c_col2+', '+c_col3,             'Skr�t, Nazwa, Rodzaj( F=Forma zaj�� R=Forma rezeracji)'         ) then exit;
    end;

    repeat
      lineNum := lineNum + 1;
      strLineNum := intToStr ( LineNum );
      l_col1 := ExcelApplication.Range['A'+strLineNum,'A'+strLineNum].Value2;
      l_col2 := ExcelApplication.Range['B'+strLineNum,'B'+strLineNum].Value2;
      l_col3 := ExcelApplication.Range['C'+strLineNum,'C'+strLineNum].Value2;
      l_col4 := ExcelApplication.Range['D'+strLineNum,'D'+strLineNum].Value2;
      l_colour       := intToStr( Random(256) + 256*Random(256) + 256*256*Random(256) );

      l_entire       := 'Rekord danych:' + cr+ cr + 'Wiersz:' +  strLineNum + cr;
      if c_col1 <> '' then l_entire := l_entire + c_col1 + ':'+ l_col1 + cr;
      if c_col2 <> '' then l_entire := l_entire + c_col2 + ':'+ l_col2 + cr;
      if c_col3 <> '' then l_entire := l_entire + c_col3 + ':'+ l_col3 + cr;
      if c_col4 <> '' then l_entire := l_entire + c_col4 + ':'+ l_col4 + cr;
      l_entire := l_entire + cr +cr;

      if l_col1 <> '' then begin
        try
          case importType.ItemIndex of
            0: begin
                 dmodule.SQL('insert into lecturers (id, abbreviation, title, first_name, last_name, colour, orguni_id) values (main_seq.nextval, :abbreviation, :title, :first_name, :last_name, :colour, :orguni_id)'
                           , 'abbreviation='+l_col1+';title='+l_col2+';first_name='+l_col3+';last_name='+l_col4+';colour='+l_colour+';orguni_id='+l_orguni_id);
                 addPermission ('LEC');
               end;
            1: begin
                 if (l_col4<>'STATIONARY') and (l_col4<>'EXTRAMURAL') and (l_col4<>'OTHER') then begin
                   SError('W kolumnie 3 dozwolone warto�ci to: "STATIONARY" lub "EXTRAMURAL" lub "OTHER". Warto�ci te oznaczaj� odpowiednio: stacjonarne, niestacjonarne, inne');
                 end;
                 dmodule.SQL('insert into groups (id, abbreviation, name, colour, group_type, number_of_peoples ) values (main_seq.nextval, :abbreviation, :name, :colour, :group_type, :number_of_peoples)'
                           , 'abbreviation='+l_col1+';name='+l_col2+';colour='+l_colour+';group_type='+l_col4+';number_of_peoples='+l_col3);
                 addPermission ('GRO');
               end;
            2: begin
                 dmodule.SQL('insert into rooms (id, name, colour, rescat_id, attribs_01) values (main_seq.nextval, :name, :colour, :rescat_id, :attribs_01)'
                            , 'name='+l_col1+';colour='+l_colour+';rescat_id=1;attribs_01='+l_col2);
                 addPermission ('ROM');
               end;
            3: begin
                 dmodule.SQL('insert into subjects (id, abbreviation, name, colour) values (main_seq.nextval, :abbreviation, :name, :colour )'
                           , 'abbreviation='+l_col1+';name='+l_col2+';colour='+l_colour);
                 addPermission ('SUB');
               end;
            4: begin
                 if (l_col3<>'C') and (l_col3<>'R') then begin
                   SError('W kolumnie 3 dozwolone warto�ci to: "C" lub "R". C=rodzaj zaj�cia. R=rodzaj rezerwacji');
                 end;
                 dmodule.SQL('insert into forms (id, abbreviation, name, kind, colour) values (main_seq.nextval, :abbreviation, :name, :kind, :colour)'
                           , 'abbreviation='+l_col1+';name='+l_col2+';kind='+l_col3+';colour='+l_colour);
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
           SError(l_entire + 'Taki rekord ju� wprowadzono. Komunikat z bazy danych: ' + E.Message);
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
            SError(l_entire + 'Wyst�pi� inny b��d');
          end;
        end;
      end;
    until l_col1 = '';

    if chbTest.Checked then begin
      dmodule.RollbackTrans;
      info('Rekordy s� prawid�owe, dane nie zosta�y zapisane w bazie danych (uruchomienie testowe).'+cr+cr+' Liczba zapisanych rekord�w:' + intToStr(lineNum-2) );
    end
    else
    begin
      dmodule.CommitTrans;
      info('Rekordy zosta�y pomy�lnie zapisane.'+cr+cr+' Liczba zapisanych rekord�w:' + intToStr(lineNum-2) );
    end;

    ExcelApplication.Disconnect;
    //ExcelApplication.Quit;
    //ExcelApplication.ActiveWorkbook.ActiveSheet.
  end;

end;

procedure TFMassImport.BitBtn2Click(Sender: TObject);
begin
 close;
end;

end.
