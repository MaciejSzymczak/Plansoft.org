unit UFDatabaseError;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, UFormConfig, StrHlder, UUtilityParent;

type
  TFDatabaseError = class(TFormConfig)
    bZamknij: TBitBtn;
    Error: TMemo;
    Messages: TStrHolder;
    fileName: TLabel;
    procedure bZamknijClick(Sender: TObject);
    procedure BNaprawAutomatycznieClick(Sender: TObject);
  private
    { Private declarations }
  public
end;

var
  FDatabaseError: TFDatabaseError;

Procedure ShowModal(aAction : Integer; P : Pointer; ErrorMessage : String);

implementation

{$R *.DFM}

Uses UFBrowseParent, DM;

Procedure ShowModal(aAction : Integer; P : Pointer; ErrorMessage : String);
Var B : TFBrowseParent;
    StartPos : integer;
    EndPos : integer;
Begin
  B := P;
  With FDatabaseError Do Begin
   FDatabaseError := TFDatabaseError.Create(Application);
   Error.Lines.Clear;

   StartPos := Pos('ORA-20000',ErrorMessage);
   if StartPos > 0 then begin
     StartPos := StartPos + 10;
     EndPos := Pos('ORA-06512',ErrorMessage);
     if EndPos = 0 then EndPos := Pos('.',ErrorMessage);
     ErrorMessage :=    Copy(ErrorMessage, StartPos, EndPos-StartPos);
   end;

   Error.Lines.Add(ErrorMessage);
   fileName.Caption := GetFileNameWithExtension(B,'');
   ShowModal;
   Free;
  End;
End;



procedure TFDatabaseError.BZamknijClick(Sender: TObject);
begin
 Close;
end;


procedure TFDatabaseError.BNaprawAutomatycznieClick(Sender: TObject);
begin
  inherited;
  If Question(Messages.Strings[10]) = ID_YES Then Begin
   //SetSystemParam(GetFormName(_P),'Restore');
   Info(Messages.Strings[11]);
  End;
end;

End.
