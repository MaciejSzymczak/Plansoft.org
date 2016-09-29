unit UFLogFileSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,
  dbtables, db, UUtilityParent, rxStrUtils, adodb;

type
  TFLogFileSettings = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLogFileSettings: TFLogFileSettings;

Type
TFormOfLogFile = Set of (form_numbering, form_DatabaseAlias, form_QueryName, form_SQL, form_Message);
TItem          = Record
                  Create        : Boolean;
                  Delete        : Boolean;
                  Form          : TFormOfLogFile;
                  FileName      : ShortString;
                  F             : TextFile;
                  CurrentNumber : Integer;
                 End;

TLogFile = Class (TObject)
            Data : Array[1..3] Of TItem; // 1=Accept 2=Discard 3=All
            _ImmadietelyShowErrors : Boolean;
            public
            Procedure SetSettings
             (CreateAccept, CreateDiscard, CreateAll : Boolean;        // Generuj odpowiedni plik ?
              DeleteAccept, DeleteDiscard, DeleteAll : Boolean;        // Usuñ plik, je¿eli ju¿ istnieje
              FormAccept,   FormDiscard,   FormAll   : TFormOfLogFile; // Forma pliku dziennika
              FileNameAccept,   FileNameDiscard,   FileNameAll : ShortString;     // Pliki
              Preview       : TEdit;                                  // TEdit lub nil
              Header        : String; AddTimeToHeader : Boolean;
              ImmadietelyShowErrors : Boolean);

            Function    SQL(Query : TADOQuery; SQL : String) : String;
            //Function    StartTransaction(Query : TADOQuery; SQL : String) : String;
            //Function    Commit(Query : TADOQuery; SQL : String) : String;
            //Function    Rollback(Query : TADOQuery; SQL : String) : String;
            destructor Destroy; override;

           End;


implementation

{$R *.DFM}

Procedure TLogFile.SetSettings;
Var t : Integer;
Begin
  Data[1].Create   := CreateAccept;
  Data[2].Create   := CreateDiscard;
  Data[3].Create   := CreateAll;
  Data[1].Delete   := DeleteAccept;
  Data[2].Delete   := DeleteDiscard;
  Data[3].Delete   := DeleteAll;
  Data[1].Form     := FormAccept;
  Data[2].Form     := FormDiscard;
  Data[3].Form     := FormAll;
  Data[1].FileName := FileNameAccept;
  Data[2].FileName := FileNameDiscard;
  Data[3].FileName := FileNameAll;
  _ImmadietelyShowErrors := ImmadietelyShowErrors;

 For t := 1 To 3 Do Begin
   If Data[t].Create Then Begin
    AssignFile(Data[t].F, Data[t].FileName);
    If Data[t].Delete Then ReWrite(Data[t].F) Else Append(Data[t].F);
    If Trim(Header)<>'' Then WriteLn(Data[t].F, Header);
    If AddTimeToHeader  Then WriteLn(Data[t].F, DateTimeToStr(Now));
    Data[t].CurrentNumber := 1;
   End;
 End;
End;

Function TLogFile.SQL(Query : TADOQuery; SQL : String) : String;
  Procedure WriteRoutine(t : Integer; ErrorMessage : String);
  Begin
   If Data[t].Create Then Begin
    if form_numbering     in Data[t].Form then Begin
      Write(Data[t].F, rxStrUtils.AddChar(' ',IntToStr(Data[t].CurrentNumber),9));
      Inc(Data[t].CurrentNumber);
    End;
    if form_DatabaseAlias in Data[t].Form then Write(Data[t].F, ' '+(query.Connection as tadoconnection).ConnectionString);
    if form_QueryName     in Data[t].Form then Write(Data[t].F, ' '+Query.Name);
    if form_SQL           in Data[t].Form then Write(Data[t].F, ' '+SQL);
    if form_Message       in Data[t].Form then Write(Data[t].F, ' '+ErrorMessage);
    WriteLn(Data[t].F);
   End;
  End;
Begin

 Query.SQL.Clear;
 Query.SQL.Add(SQL);
 try
  Query.Open;
 except
  on E:exception Do Begin
   If E.Message <> 'Error creating cursor handle' Then Begin
    If _ImmadietelyShowErrors Then SError(E.Message);
    WriteRoutine(2,E.Message);
    WriteRoutine(3,E.Message);
   End Else Begin
    WriteRoutine(1,E.Message);
    WriteRoutine(3,E.Message);
   End;
  End
  Else Begin
    WriteRoutine(2,'Nieznany rodzaj b³êdu');
    WriteRoutine(3,'Nieznany rodzaj b³êdu');
    //Raise;
  End;
 end;
End;

destructor TLogFile.Destroy;
Var t : Integer;
Begin
 For t := 1 To 3 Do If Data[t].Create Then CloseFile(Data[t].F);
 inherited Destroy;
End;

end.
