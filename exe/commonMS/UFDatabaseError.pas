unit UFDatabaseError;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, UFormConfig, StrHlder, UUtilityParent;

type
  TFDatabaseError = class(TFormConfig)
    Memo: TMemo;
    BZaawansowane: TBitBtn;
    Image1: TImage;
    bZamknij: TBitBtn;
    Error: TMemo;
    SQL: TMemo;
    Zalecenia: TMemo;
    Messages: TStrHolder;
    BNaprawAutomatycznie: TBitBtn;
    procedure BZaawansowaneClick(Sender: TObject);
    procedure bZamknijClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BNaprawAutomatycznieClick(Sender: TObject);
  private
    { Private declarations }
  public
   _P : Pointer
end;

var
  FDatabaseError: TFDatabaseError;

Procedure ShowModal(aAction : Integer; P : Pointer; ErrorMessage : String);

implementation

{$R *.DFM}

Uses UFBrowseParent, DM;

Procedure ShowModal(aAction : Integer; P : Pointer; ErrorMessage : String);
Var  _MEMO, _ZALECENIA : String;
     B : TFBrowseParent;
Begin
  B := P;
  With FDatabaseError Do Begin
   FDatabaseError := TFDatabaseError.Create(Application);
   _P := P;
   //BNaprawAutomatycznie.Visible := Action = AOpen;

   Case aAction Of
    AOpen  : Begin _MEMO := Messages.Strings[0];   _ZALECENIA := Messages.Strings[1]; End;
    ADelete: Begin _MEMO := Messages.Strings[2];   _ZALECENIA := Messages.Strings[3]; End;
    AInsert: Begin _MEMO := Messages.Strings[4];   _ZALECENIA := Messages.Strings[5]; End;
    AEdit  : Begin _MEMO := Messages.Strings[6];   _ZALECENIA := Messages.Strings[7]; End;
    APost  :  Begin _MEMO := Messages.Strings[8];  _ZALECENIA := Messages.Strings[9]; End;
    Else ShowMessage('UFDatabaseError.ShowModal: Action za zakresem');
   End;

   Caption := GetFileNameWithExtension(B,'');
   Memo.Lines.Clear;
   Memo.Lines.Add(_MEMO);
   Error.Lines.Clear;
   Error.Lines.Add(ErrorMessage);
   SQL.Lines.Clear;
   SQL.Lines.Text := B.Query.SQL.Text;
   Zalecenia.Lines.Clear;
   Zalecenia.Lines.Add(_ZALECENIA);
   DModule.InsertIntoEventLog(user,ActionNames[aAction]+'_ERROR',Application.Title + '.' + B.Name,'',_MEMO,ErrorMessage,_ZALECENIA,B.Query.SQL.Text,User);
   ShowModal;
   Free;
  End;
End;

procedure TFDatabaseError.BZaawansowaneClick(Sender: TObject);
begin
 Height := 460;
 BZaawansowane.Enabled := False;
end;

procedure TFDatabaseError.BZamknijClick(Sender: TObject);
begin
 Close;
end;


procedure TFDatabaseError.FormCreate(Sender: TObject);
begin
 Inherited;
 Top    := 100;
 Height := 205+19+20;
end;

procedure TFDatabaseError.BNaprawAutomatycznieClick(Sender: TObject);
begin
  inherited;
  If Question(Messages.Strings[10]) = ID_YES Then Begin
   SetSystemParam(GetFormName(_P),'Restore');
   Info(Messages.Strings[11]);
  End;
end;

End.
