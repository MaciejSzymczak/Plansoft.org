unit UFPackManyFiles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, ToolEdit, ExtCtrls, Db, DBTables, Grids, DBGrids, FileUtil, ShellApi,
  UUtilityParent, ComCtrls, Placemnt;

type
  TFPackManyFiles = class(TForm)
    PackPath: TEdit;
    Activity: TStatusBar;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    OpenDialog: TOpenDialog;
    Panel1: TPanel;
    BitBtn2: TBitBtn;
    StartDirectory: TDirectoryEdit;
    Memo2: TMemo;
    FormStorage: TFormStorage;
    Image1: TImage;
    CloseWindow: TCheckBox;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPackManyFiles: TFPackManyFiles;

implementation

{$R *.DFM}

Var Licznik : Integer;

Const modePackFiles           = 1;
      modeDeleteFiles         = 2;

Var LogFile : TextFile;

Procedure Tree(Path : String; Mode : Integer);
Var   SearchRec : TSearchRec;
      Found     : Integer;
      Function ExtractFN(S : ShortString) : ShortString;
      Begin
       Result := Copy(S, 1, Length(S) - 4);
      End;
      Function PathToDir(S : ShortString) : ShortString;
      Begin
       Result := Copy(S, 1, Length(S) - 1);
      End;
Begin
  Found := FindFirst(Path + '*.*', faAnyFile, SearchRec);
  while Found = 0 do
  begin
    If (SearchRec.Name <> '.') And (SearchRec.Name <> '..') Then Begin
     Licznik := Licznik + 1;

     If SearchRec.Attr = faDirectory Then Begin
      Tree(Path + SearchRec.Name + '\', Mode);
     End
     Else Begin
      Case Mode Of
       modePackFiles:
        If UpperCase(ExtractFileExt(SearchRec.Name)) <> '.RAR' Then Begin
         ChDir(PathToDir(Path));
         WriteLn(LogFile,FPackManyFiles.PackPath.Text+' m "'+Path+ExtractFN(UUtilityParent.GetMSDosFileName(Path+SearchRec.Name))+'" "'+Path+SearchRec.Name+'"');
         ExecuteFileAndWait(FPackManyFiles.PackPath.Text+' m "'+Path+ExtractFN(UUtilityParent.GetMSDosFileName(Path+SearchRec.Name))+'" "'+Path+SearchRec.Name+'"');
        End;
       modeDeleteFiles:
        //If UpperCase(ExtractFileExt(SearchRec.Name)) <> '.RAR' Then Begin
        // DeleteFile(Path+SearchRec.Name);
        //End;
       End;

      Licznik := Licznik + 1;
     End;
    End;
    Found := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
End;

procedure TFPackManyFiles.BitBtn1Click(Sender: TObject);
Var StartPath : String;
begin
 If Not FileExists(PackPath.Text) Then Begin
  SError('Nie odnaleziono pliku WinRar na œzie¿ce:'+PackPath.Text+ '. ProwadŸ prawid³ow¹ œcie¿kê dostêpu do programu WinRAR95.exe');
  Exit;
 End;

 If Trim(StartDirectory.Text)= '' Then Begin
  ShowMessage('Nale¿y wybraæ folder z plikami');
  Exit;
 End;
 If StartDirectory.Text[Length(StartDirectory.Text)] <> '\'
 Then StartPath := StartDirectory.Text + '\'
 Else StartPath := StartDirectory.Text;

 AssignFile(LogFile, 'c:\PackManyFiles.log');
 If Not FileExists('c:\PackManyFiles.log') Then ReWrite(LogFile)
 Else Append(LogFile);
 WriteLn(LogFile, 'Rozpoczecie :'+DateTimeToStr(Now()));

  Licznik := 0;
  Activity.SimpleText := 'Pakowanie plików'; Activity.Refresh;
  Tree(StartPath,modePackFiles);
  Activity.SimpleText := 'Usuwanie plików innych ni¿ RAR'; Activity.Refresh;
  Tree(StartPath,modeDeleteFiles);
  Activity.SimpleText := 'OK'; Activity.Refresh;

 WriteLn(LogFile, 'Zakoñczenie :'+DateTimeToStr(Now()));
 WriteLn(LogFile, '---------------------------------------------------------');
 CloseFile(LogFile);
 If CloseWindow.Checked Then Close Else Info('Pliki zosta³y skompresowane');
end;

procedure TFPackManyFiles.SpeedButton1Click(Sender: TObject);
begin
 OpenDialog.FileName := PackPath.Text;
 If OpenDialog.Execute Then PackPath.Text := OpenDialog.FileName;
end;

procedure TFPackManyFiles.FormCreate(Sender: TObject);
begin
 StartDirectory.Text := ParamStr(1);
end;

end.
