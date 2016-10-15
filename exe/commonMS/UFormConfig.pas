unit UFormConfig;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, Tabnotbk, Spin, StrHlder, dbtables, Db,
  RxQuery, RXLookup, ExtCtrls;

type
  TFormConfig = class(TForm)
    Status: TPanel;
    BUstawieniaFormularza: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BUstawieniaFormularzaClick(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
  public
    Procedure RefreshStatusPanel;
  end;

var
  FormConfig: TFormConfig;

Function  GetFileNameWithExtension(Form : TForm; Extension : ShortString) : ShortString;
Function  GetFormName(Form : TForm) : ShortString;
Procedure SaveFormConfiguration(Form : TForm);
Procedure LoadFormConfiguration(Form : TForm);
procedure setFontSize(Form : TForm);

implementation

{$R *.DFM}

Uses UUtilityParent, menus, ToolEdit, dbgrids,
     Tabs, DBChart, Chart, dm;

Function GetFileNameWithExtension(Form : TForm; Extension : ShortString) : ShortString;
Begin
 Result := UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.' + Form.Name + '.'+ Extension;
End;

Function GetFormName(Form : TForm) : ShortString;
Begin
 Result := Form.Name;
End;

function StringToRaw (buffer : string) : string;
begin
 result := replace(replace(buffer , chr(13), '<chr(13)>'), chr(10), '<chr(10)>');
end;

function RawToString (buffer : string) : string;
begin
 result := replace(replace(buffer , '<chr(13)>', chr(13)), '<chr(10)>', chr(10));
end;

Const BoolToChar : Array[False..True] Of ShortString = ('N','T');

Function CharToBool(S : ShortString) : Boolean;
Begin
 If S = 'N' Then Result := False Else Result := True;
End;

Procedure SaveFormConfiguration(Form : TForm);
Var TF : TextFile;
    FileName : ShortString;
    T        : Integer;
    L        : Integer;

Procedure WriteLnTStrings(Var TextF : TextFile; S : TStrings);
Begin
 WriteLn(TextF, S.CommaText);
End;

Begin
 FileName := GetFileNameWithExtension(Form,'cfg');
 try
 AssignFile(TF, FileName);
 ReWrite(TF);
 except
  CopyToClipboard(FileName);
  raise;
 end;
 If Form.WindowState = wsNormal Then WriteLn(TF, 'wsNormal') Else
   If Form.WindowState = wsMinimized Then WriteLn(TF, 'wsMinimized') Else
     WriteLn(TF, 'wsMaximized');
 //WriteLn(TF, Form.Caption);
 WriteLn(TF, Form.Left);
 WriteLn(TF, Form.Top);
 If Form.WindowState = wsMaximized Then Begin
  WriteLn(TF, -1);
  WriteLn(TF, -1);
 End Else Begin
  WriteLn(TF, Form.Width);
  WriteLn(TF, Form.Height);
 End;
 WriteLn(TF, Form.HelpFile);
 WriteLn(TF, Form.HelpContext);

 For T := 0 To Form.ComponentCount-1 Do
  Begin
   If Form.Components[T] is TLabel Then Begin
    WriteLn(TF, 'TLabel');
    WriteLn(TF, TLabel(Form.Components[T]).Name);
    //WriteLn(TF, replace(TLabel(Form.Components[T]).Caption,CR,'/newLine'));
   End Else
   If Form.Components[T] is TComboBox Then Begin
    WriteLn(TF, 'TComboBox');
    WriteLn(TF, TComboBox(Form.Components[T]).Name);
    WriteLn(TF, TComboBox(Form.Components[T]).ItemIndex);
   End Else
   If Form.Components[T] is TRxDBLookupCombo Then Begin
    WriteLn(TF, 'TRxDBLookupCombo');
    WriteLn(TF, TRxDBLookupCombo(Form.Components[T]).Name);
    WriteLn(TF, TRxDBLookupCombo(Form.Components[T]).DisplayEmpty);
   End Else
   If Form.Components[T] is TButton Then Begin
    WriteLn(TF, 'TButton\TBitBtn');
    WriteLn(TF, TButton(Form.Components[T]).Name);
    //WriteLn(TF, TButton(Form.Components[T]).Caption);
   End Else
   //If Form.Components[T] is TMenuItem Then Begin
   // WriteLn(TF, 'TMenuItem');
   // WriteLn(TF, TMenuItem(Form.Components[T]).Name);
   // WriteLn(TF, TMenuItem(Form.Components[T]).Caption);
   //End Else
   If Form.Components[T] is TCheckBox Then Begin
    //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj CHECKED
    If TCheckBox(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     WriteLn(TF, 'TCheckBoxWithChecked');
     WriteLn(TF, TCheckBox(Form.Components[T]).Name);
     //WriteLn(TF, TCheckBox(Form.Components[T]).Caption);
     WriteLn(TF, BoolToChar[TCheckBox(Form.Components[T]).Checked]);
    End
    Else Begin
     WriteLn(TF, 'TCheckBox');
     WriteLn(TF, TCheckBox(Form.Components[T]).Name);
     //WriteLn(TF, TCheckBox(Form.Components[T]).Caption);
    End;
   End Else
   If Form.Components[T] is TRadioButton Then Begin
    WriteLn(TF, 'TRadioButton');
    WriteLn(TF, TRadioButton(Form.Components[T]).Name);
    //WriteLn(TF, TRadioButton(Form.Components[T]).Caption);
   End Else
   If Form.Components[T] is TGroupBox Then Begin
    WriteLn(TF, 'TGroupBox');
    WriteLn(TF, TGroupBox(Form.Components[T]).Name);
    //WriteLn(TF, TGroupBox(Form.Components[T]).Caption);
   End Else
   If Form.Components[T] is TRadioGroup Then Begin
    WriteLn(TF, 'TRadioGroup');
    WriteLn(TF, TRadioGroup(Form.Components[T]).Name);
    //WriteLn(TF, TRadioGroup(Form.Components[T]).Caption);
    WriteLn(TF, TRadioGroup(Form.Components[T]).ItemIndex);
    WriteLnTStrings(TF, TRadioGroup(Form.Components[T]).Items);
   End Else
   If Form.Components[T] is TTabbedNoteBook Then Begin
    WriteLn(TF, 'TTabbedNoteBook');
    WriteLn(TF, TTabbedNoteBook(Form.Components[T]).Name);
    //WriteLnTStrings(TF, TTabbedNoteBook(Form.Components[T]).Pages);
   End Else
   If Form.Components[T] is TField Then Begin
    WriteLn(TF, 'TField');
    WriteLn(TF, TField(Form.Components[T]).Name);
    WriteLn(TF, TField(Form.Components[T]).DisplayLabel);
   End Else
   If Form.Components[T] is TNotebook Then Begin
    WriteLn(TF, 'TNotebook');
    WriteLn(TF, TNotebook(Form.Components[T]).Name);
    WriteLnTStrings(TF, TNotebook(Form.Components[T]).Pages);
   End Else
   If Form.Components[T] is TToolButton Then Begin
    WriteLn(TF, 'TToolButton');
    WriteLn(TF, TToolButton(Form.Components[T]).Name);
    //WriteLn(TF, TToolButton(Form.Components[T]).Caption);
   End Else
   If Form.Components[T] is TSpeedButton Then Begin
    WriteLn(TF, 'TSpeedButton');
    WriteLn(TF, TSpeedButton(Form.Components[T]).Name);
    //WriteLn(TF, TSpeedButton(Form.Components[T]).Caption);
   End Else
   If Form.Components[T] is TTabSheet Then Begin
    WriteLn(TF, 'TTabSheet');
    WriteLn(TF, TTabSheet(Form.Components[T]).Name);
    //WriteLn(TF, TTabSheet(Form.Components[T]).Caption);
   End Else
   If Form.Components[T] is TDBGrid Then Begin
     //Je¿eli w TAG jest zapalony bit 25 (licz¹c od 1), nie przechowuj GRIDA
    If NOT (TDBGrid(Form.Components[T]).Tag And 33554432 = 33554432) Then Begin
     WriteLn(TF, 'TDBGrid');
     WriteLn(TF, TDBGrid(Form.Components[T]).Name);
     WriteLn(TF, TDBGrid(Form.Components[T]).Columns.Count);
     For L := 0 To TDBGrid(Form.Components[T]).Columns.Count - 1 Do Begin
      //WriteLn(TF, TDBGrid(Form.Components[T]).Columns[L].Title.Caption);
     End;
    End;
   End Else
   If Form.Components[T] is TTabSet Then Begin
    WriteLn(TF, 'TTabSet');
    WriteLn(TF, TTabSet(Form.Components[T]).Name);
    WriteLnTStrings(TF, TTabSet(Form.Components[T]).Tabs);
    WriteLn(TF, TTabSet(Form.Components[T]).TabIndex);
   End Else
   {@@@If Form.Components[T] is TTBDBRichEdit Then Begin
    WriteLn(TF, 'TTBDBRichEdit');
    WriteLn(TF, TTBDBRichEdit(Form.Components[T]).Name);
    WriteLn(TF, TTBDBRichEdit(Form.Components[T]).ToolsDialogCaption);
   End Else}
   {@@@If Form.Components[T] is TTBRichEdit Then Begin
    WriteLn(TF, 'TTBRichEdit');
    WriteLn(TF, TTBRichEdit(Form.Components[T]).Name);
    WriteLn(TF, TTBRichEdit(Form.Components[T]).ToolsDialogCaption);
   End Else}
   If Form.Components[T] is TPanel Then Begin
    WriteLn(TF, 'TPanel');
    WriteLn(TF, TPanel(Form.Components[T]).Name);
    //WriteLn(TF, TPanel(Form.Components[T]).Caption);
   End Else
   {@@@If Form.Components[T] is THintProperties Then Begin
    WriteLn(TF, 'THintProperties');
    WriteLn(TF, THintProperties(Form.Components[T]).Name);
    WriteLn(TF, THintProperties(Form.Components[T]).Caption);
   End Else}
   If Form.Components[T] is TChart Then Begin
    WriteLn(TF, 'TChart');
    WriteLn(TF, TChart(Form.Components[T]).Name);
    WriteLnTStrings(TF, TChart(Form.Components[T]).Title.Text);
   End Else
   If Form.Components[T] is TDBChart Then Begin
    WriteLn(TF, 'TDBChart');
    WriteLn(TF, TDBChart(Form.Components[T]).Name);
    WriteLnTStrings(TF, TDBChart(Form.Components[T]).Title.Text);
   End Else
   If Form.Components[T] is TEdit Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj TEXT
    If TEdit(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     WriteLn(TF, 'TEdit');
     WriteLn(TF, TEdit(Form.Components[T]).Name);
     WriteLn(TF, TEdit(Form.Components[T]).Text);
    End;
   End Else
   If Form.Components[T] is TDateEdit Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj TEXT
    If TDateEdit(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     WriteLn(TF, 'TDateEditWithTEXT');
     WriteLn(TF, TDateEdit(Form.Components[T]).Name);
     WriteLn(TF, TDateEdit(Form.Components[T]).DialogTitle);
     WriteLn(TF, TDateEdit(Form.Components[T]).Text);
    End
    Else Begin
     WriteLn(TF, 'TDateEdit');
     WriteLn(TF, TDateEdit(Form.Components[T]).Name);
     WriteLn(TF, TDateEdit(Form.Components[T]).DialogTitle);
    End;
   End Else
   If Form.Components[T] is TSpinEdit Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj VALUE
    If TDateEdit(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     WriteLn(TF, 'TSpinEdit');
     WriteLn(TF, TSpinEdit(Form.Components[T]).Name);
     WriteLn(TF, TSpinEdit(Form.Components[T]).Value);
    End;
   End Else
   If Form.Components[T] is TMemo Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj LINES
    If TMemo(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     WriteLn(TF, 'TMemoLines');
     WriteLn(TF, TMemo(Form.Components[T]).Name);
     WriteLnTStrings(TF, TMemo(Form.Components[T]).Lines);
    End;
   End Else
   If Form.Components[T] is TStrHolder Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj STRINGS
    If TStrHolder(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     WriteLn(TF, 'TStrHolderLines');
     WriteLn(TF, TStrHolder(Form.Components[T]).Name);
     WriteLnTStrings(TF, TStrHolder(Form.Components[T]).Strings);
    End;
   End;

   If Form.Components[T] is TControl Then Begin
    WriteLn(TF, 'TControl');
    WriteLn(TF,TControl(Form.Components[T]).Name);
    WriteLn(TF, BoolToChar[TControl(Form.Components[T]).ShowHint]);
    WriteLn(TF, StringToRaw(TControl(Form.Components[T]).Hint));
   End;

  End;
 CloseFile(TF);
End;

Procedure LoadFormConfiguration(Form : TForm);
Var TF : TextFile;
    FileName : ShortString;
    T        : Integer;
    L        : Integer;
    MaxL     : Integer;
    QueryActive : Boolean;
    TempS       : ShortString;
    TempI       : Integer;
    p     : TNotifyEvent;

 Function GetString : ShortString;
 Var TempStr  : ShortString;
 Begin
  ReadLn(TF, TempStr);
  Result := TempStr;
 End;

 Function NazwaNieZgadzaSie(S1, S2 : ShortString) : Boolean;
 Begin
  If S1 <> S2 Then Begin
   //Info('Plik konfiguracyjny '+FileName+' jest uszkodzony. Nazwy nie zgadzaj¹ siê:'+S1+', '+S2+'. Plik zostanie zast¹piony poprawnym plikiem konfiguracyjnym');
   CloseFile(TF);
   Result := True
  End Else Result := False;
 End;

 Procedure ReadLnTStrings(Var TextF : TextFile; S : TStrings);
 Var  TempS : String;
 Begin
  ReadLn(TextF, TempS);
  S.CommaText := TempS;
 End;

Begin
 FileName := GetFileNameWithExtension(Form,'cfg');
 AssignFile(TF, FileName);

 If Not FileExists(FileName) Then Begin
  //Info('Brak pliku konfiguracyjnego '+FileName+' .Plik zostanie automatycznie utworzony');
  Exit;
 End;

 Reset(TF);

try
 TempS := GetString;

 If TempS = 'wsNormal' Then Form.WindowState := wsNormal Else
   If TempS = 'wsMinimized' Then Form.WindowState := wsMinimized Else
     Form.WindowState := wsMaximized;

 //Form.Caption     := GetString;
 Form.Left        := StrToInt(GetString);
 Form.Top         := StrToInt(GetString);
 TempI := StrToInt(GetString); If TempI > 160 Then Form.Width  := TempI;
 TempI := StrToInt(GetString); If TempI > 40  Then Form.Height := TempI;
 Form.HelpFile    := GetString;
 Form.HelpContext := StrToInt(GetString);

 For T := 0 To Form.ComponentCount-1 Do
  Begin

   If Form.Components[T] is TLabel Then Begin
    GetString;
    If NazwaNieZgadzaSie(TLabel(Form.Components[T]).Name,GetString) Then Exit;
    //TLabel(Form.Components[T]).Caption := replace(GetString,'/newLine',CR);
   End Else
   If Form.Components[T] is TComboBox Then Begin
    GetString;
    If NazwaNieZgadzaSie(TComboBox(Form.Components[T]).Name,GetString) Then Exit;
    P := TComboBox(Form.Components[T]).OnChange; TComboBox(Form.Components[T]).OnChange:= nil;
    TComboBox(Form.Components[T]).ItemIndex := StrToInt(GetString);
    TComboBox(Form.Components[T]).OnChange := p;
   End Else
   If Form.Components[T] is TRxDBLookupCombo Then Begin
    GetString;
    If NazwaNieZgadzaSie(TRxDBLookupCombo(Form.Components[T]).Name,GetString) Then Exit;
    TRxDBLookupCombo(Form.Components[T]).DisplayEmpty := GetString;
   End Else
   If Form.Components[T] is TButton Then Begin
    GetString;
    If NazwaNieZgadzaSie(TButton(Form.Components[T]).Name,GetString) Then Exit;
    //TButton(Form.Components[T]).Caption := GetString;
   End Else
   //If Form.Components[T] is TMenuItem Then Begin
   // GetString;
   // If NazwaNieZgadzaSie(TMenuItem(Form.Components[T]).Name,GetString) Then Exit;
   // TMenuItem(Form.Components[T]).Caption := GetString;
   //End Else
   If Form.Components[T] is TCheckBox Then Begin
    GetString;
    If NazwaNieZgadzaSie(TCheckBox(Form.Components[T]).Name,GetString) Then Exit;
    P := TCheckBox(Form.Components[T]).OnClick; TCheckBox(Form.Components[T]).OnClick:= nil;
    //TCheckBox(Form.Components[T]).Caption := GetString;
    //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj CHECKED
    If TCheckBox(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     TCheckBox(Form.Components[T]).Checked := CharToBool(GetString);
    End;
    TCheckBox(Form.Components[T]).OnClick := p;
   End Else
   If Form.Components[T] is TRadioButton Then Begin
    GetString;
    If NazwaNieZgadzaSie(TRadioButton(Form.Components[T]).Name,GetString) Then Exit;
    //TRadioButton(Form.Components[T]).Caption := GetString;
   End Else
   If Form.Components[T] is TGroupBox Then Begin
    GetString;
    If NazwaNieZgadzaSie(TGroupBox(Form.Components[T]).Name,GetString) Then Exit;
    //TGroupBox(Form.Components[T]).Caption := GetString;
   End Else
   If Form.Components[T] is TRadioGroup Then Begin
    GetString;
    If NazwaNieZgadzaSie(TRadioGroup(Form.Components[T]).Name,GetString) Then Exit;
    P := TRadioGroup(Form.Components[T]).OnClick; TRadioGroup(Form.Components[T]).OnClick:= nil;
    //TRadioGroup(Form.Components[T]).Caption := GetString;
    TRadioGroup(Form.Components[T]).ItemIndex := StrToInt(GetString);
    ReadLnTStrings(TF,TRadioGroup(Form.Components[T]).Items);
    TRadioGroup(Form.Components[T]).OnClick := p;
   End Else
   If Form.Components[T] is TTabbedNoteBook Then Begin
    GetString;
    If NazwaNieZgadzaSie(TTabbedNoteBook(Form.Components[T]).Name,GetString) Then Exit;
    //ReadLnTStrings(TF,TTabbedNoteBook(Form.Components[T]).Pages);
   End Else
   If Form.Components[T] is TField Then Begin
    GetString;
    If NazwaNieZgadzaSie(TField(Form.Components[T]).Name,GetString) Then Exit;
    TField(Form.Components[T]).DisplayLabel := GetString;
   End Else
   If Form.Components[T] is TNotebook Then Begin
    GetString;
    If NazwaNieZgadzaSie(TNotebook(Form.Components[T]).Name,GetString) Then Exit;
    ReadLnTStrings(TF,TNotebook(Form.Components[T]).Pages);
   End Else
   If Form.Components[T] is TToolButton Then Begin
    GetString;
    If NazwaNieZgadzaSie(TToolButton(Form.Components[T]).Name,GetString) Then Exit;
    //TToolButton(Form.Components[T]).Caption := GetString;
   End Else
   If Form.Components[T] is TSpeedButton Then Begin
    GetString;
    If NazwaNieZgadzaSie(TSpeedButton(Form.Components[T]).Name,GetString) Then Exit;
     //TSpeedButton(Form.Components[T]).Caption := GetString;
   End Else
   If Form.Components[T] is TTabSheet Then Begin
    GetString;
    If NazwaNieZgadzaSie(TTabSheet(Form.Components[T]).Name,GetString) Then Exit;
     //TTabSheet(Form.Components[T]).Caption := GetString;
   End Else
   If Form.Components[T] is TDBGrid Then Begin
    //Je¿eli w TAG jest zapalony bit 25 (licz¹c od 1), nie przechowuj GRIDA
    If NOT (TEdit(Form.Components[T]).Tag And 33554432 = 33554432) Then Begin
      GetString;
      If NazwaNieZgadzaSie(TDBGrid(Form.Components[T]).Name,GetString) Then Exit;
      MaxL := StrToInt(GetString) - 1;
      For L := 0 To MaxL Do Begin
       //Try If Assigned (TDBGrid(Form.Components[T]).Columns[L].Title) Then TDBGrid(Form.Components[T]).Columns[L].Title.Caption := GetString; Except GetString; End;
      End;
    End;
   End Else
   If Form.Components[T] is TTabSet Then Begin
    GetString;
    If NazwaNieZgadzaSie(TTabSet(Form.Components[T]).Name,GetString) Then Exit;
    ReadLnTStrings(TF,TTabSet(Form.Components[T]).Tabs);
    TTabSet(Form.Components[T]).TabIndex := StrToInt(GetString);
   End Else
   {@@@If Form.Components[T] is TTBDBRichEdit Then Begin
    GetString;
    If NazwaNieZgadzaSie(TTBDBRichEdit(Form.Components[T]).Name,GetString) Then Exit;
     TTBDBRichEdit(Form.Components[T]).ToolsDialogCaption := GetString;
   End Else}
   {@@@If Form.Components[T] is TTBRichEdit Then Begin
    GetString;
    If NazwaNieZgadzaSie(TTBRichEdit(Form.Components[T]).Name,GetString) Then Exit;
     TTBRichEdit(Form.Components[T]).ToolsDialogCaption := GetString;
   End Else}
   If Form.Components[T] is TPanel Then Begin
    GetString;
    If NazwaNieZgadzaSie(TPanel(Form.Components[T]).Name,GetString) Then Exit;
     //TPanel(Form.Components[T]).Caption := GetString;
   End Else
   {@@@If Form.Components[T] is THintProperties Then Begin
    GetString;
    If NazwaNieZgadzaSie(THintProperties(Form.Components[T]).Name,GetString) Then Exit;
     THintProperties(Form.Components[T]).Caption := GetString;
   End Else}
   If Form.Components[T] is TChart Then Begin
    GetString;
    If NazwaNieZgadzaSie(TChart(Form.Components[T]).Name,GetString) Then Exit;
    ReadLnTStrings(TF, TChart(Form.Components[T]).Title.Text);
   End;
  If Form.Components[T] is TDBChart Then Begin
    GetString;
    If NazwaNieZgadzaSie(TDBChart(Form.Components[T]).Name,GetString) Then Exit;
    ReadLnTStrings(TF, TDBChart(Form.Components[T]).Title.Text);
   End Else
   If Form.Components[T] is TEdit Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj TEXT
    If TEdit(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     GetString;
     If NazwaNieZgadzaSie(TEdit(Form.Components[T]).Name,GetString) Then Exit;
     TEdit(Form.Components[T]).Text := GetString;
    End;
   End Else
   If Form.Components[T] is TDateEdit Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj TEXT
    GetString;
    If NazwaNieZgadzaSie(TDateEdit(Form.Components[T]).Name,GetString) Then Exit;
     TDateEdit(Form.Components[T]).DialogTitle := GetString;
    If TDateEdit(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     TDateEdit(Form.Components[T]).Text := GetString;
    End;
   End Else
   If Form.Components[T] is TSpinEdit Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj VALUE
    If TDateEdit(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
    GetString;
    If NazwaNieZgadzaSie(TSpinEdit(Form.Components[T]).Name,GetString) Then Exit;
    TSpinEdit(Form.Components[T]).Value := StrToInt(GetString);
    End;
   End Else
   If Form.Components[T] is TMemo Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj LINES
    If TMemo(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     GetString;
     If NazwaNieZgadzaSie(TMemo(Form.Components[T]).Name,GetString) Then Exit;
     ReadLnTStrings(TF, TMemo(Form.Components[T]).Lines);
    End;
   End Else
   If Form.Components[T] is TStrHolder Then Begin
     //Je¿eli w TAG jest zapalony bit 26 (licz¹c od 1), przechowuj STRINGS
    If TStrHolder(Form.Components[T]).Tag And 67108864 = 67108864 Then Begin
     GetString;
     If NazwaNieZgadzaSie(TStrHolder(Form.Components[T]).Name,GetString) Then Exit;
     ReadLnTStrings(TF, TStrHolder(Form.Components[T]).Strings);
    End;
   End;

   If Form.Components[T] is TControl Then Begin
     GetString;
     If NazwaNieZgadzaSie(TControl(Form.Components[T]).Name,GetString) Then Exit;
     TControl(Form.Components[T]).ShowHint := CharToBool(GetString);
     TControl(Form.Components[T]).Hint := RawToString(GetString);
   End;

  End;
 CloseFile(TF);
except
  Info('Plik konfiguracyjny '+FileName+' jest uszkodzony. Plik zostanie zast¹piony poprawnym plikiem konfiguracyjnym. (Obiekt='+TControl(Form.Components[T]).Name+')');
  CloseFile(TF);
end;

End;

procedure TFormConfig.FormCreate(Sender: TObject);
begin
 If GetSystemParam(GetFormName(Self)) = 'Restore' Then Begin
  DeleteFile( GetFileNameWithExtension(Self,'cfg') );
  SetSystemParam(GetFormName(Self),'');
  Exit;
 End;

 LoadFormConfiguration(Self);
 setFontSize(self);
end;

procedure TFormConfig.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i, cavb : -255..255;
begin
 SaveFormConfiguration(Self);       
  if AlphaBlend=true then
  begin
    cavb:=AlphaBlendValue;

    i := cavb;
    if i <> 0 then
    repeat
      i := i - 2;
      if i < 0 then i := 0;
      AlphaBlendValue := i;
      Application.ProcessMessages;
    until i = 0;
    AlphaBlendValue := cavb;
  end;
end;

procedure TFormConfig.FormShow(Sender: TObject);
var
  i, cavb : 0..255;
begin
 RefreshStatusPanel;
  if AlphaBlend=true then
  begin
    cavb := AlphaBlendValue;
    i := 0;
    repeat
      i := i + 1;
      if i >255 then i := 255;
      AlphaBlendValue := i;
      Application.ProcessMessages;
    until i = 255;
    AlphaBlendValue := cavb;
  end;
end;

procedure TFormConfig.BUstawieniaFormularzaClick(Sender: TObject);
begin
  if not elementEnabled('"Tabela przestawna"','2015.05.08', false) then exit;

  If Question('Zostan¹ przywrócone ustawienia fabryczne formularza. Czy kontynuowaæ ?') = ID_YES Then Begin
   SetSystemParam(GetFormName(Self),'Restore');
   DeleteFile( GetFileNameWithExtension(Self,'cfg') );
   Info('Operacja powiod³a siê. Zamknij program i uruchom go ponownie');
  End;
 //SaveFormConfiguration(Self);
 //ExecuteFile('NotePad.exe',GetFileNameWithExtension(Self,'cfg'),'',SW_SHOWMAXIMIZED);
 //Info(sAfterEdit);
 LoadFormConfiguration(Self);
end;

Procedure TFormConfig.RefreshStatusPanel;
Begin
  Status.Caption := NazwaAplikacji + ' ('+self.Name+ ')     ' +User+ '    ';
End;

function TFormConfig.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
 Status.Visible := true;
end;

procedure setFontSize(Form : TForm);
var EditFontSize : integer;
    FontSize     : integer;
    t            : integer;
begin
 EditFontSize := StrToInt(GetSystemParam('Form.DefaultEditFontSize','8'));
 FontSize     := StrToInt(GetSystemParam('Form.DefaultFontSize','8'));

  For t := 0 To form.ComponentCount-1 Do
  Begin
   If form.Components[t] is tedit        Then (form.Components[t] as tedit).Font.Size        := EditFontSize;
   If form.Components[t] is TSpeedButton Then (form.Components[t] as TSpeedButton).Font.Size := FontSize;
   If form.Components[t] is TLabel       Then (form.Components[t] as TLabel).Font.Size       := FontSize;
   If form.Components[t] is tcombobox    Then (form.Components[t] as tcombobox).Font.Size    := FontSize;
   If form.Components[t] is tcheckbox    Then (form.Components[t] as tcheckbox).Font.Size    := FontSize;
   If form.Components[t] is tgroupbox    Then (form.Components[t] as tgroupbox).Font.Size    := FontSize;
   If form.Components[t] is tbutton    Then (form.Components[t] as tbutton).Font.Size    := FontSize;
   If form.Components[t] is tbitbtn    Then (form.Components[t] as tbitbtn).Font.Size    := FontSize;
   If form.Components[t] is ttabsheet    Then (form.Components[t] as ttabsheet).Font.Size    := FontSize;
   If form.Components[t] is tmemo    Then (form.Components[t] as tmemo).Font.Size    := FontSize;
  end;

end;

end.
