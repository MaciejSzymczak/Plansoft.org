unit IntlFunc;

interface
uses WinProcs,SysUtils,Classes,Forms,StdCtrls,Menus,ExtCtrls,
     TabNotBk,DB,Tabs,ToolEdit, Controls, ComCtrls,
     Buttons, DBGrids, RxDBCtrl,Registry, Grids;

procedure SetCaptions(NrOkna:WORD;Okno:TForm);
function IntlMessageBox(Tekst,Tytul:WORD;Flags:WORD):Integer;
procedure SetCaptionsEx(DLL:STRING;NrOkna:WORD;Okno:TForm);
function IntlMessageBoxEx(DLL:STRING;Tekst,Tytul:WORD;Flags:WORD):Integer;
function IntlFmtMsgBoxEx(DLL:STRING;Tekst,Tytul:WORD;const TextArg,TytulArg:array of const;Flags:WORD):Integer;

implementation

uses TBDBRich, TBRichEd, AppProp;

procedure SetCaptionsAbstract(HInst:THandle;NrOkna:WORD;Okno:TForm);
var Buf,BufH:ARRAY[0..255] of Char;
    i,j:WORD;
    T,O:LongInt;
    C:TComponent;
    L,L1:ShortString;
    R:TRegistry;
begin
  R:=TRegistry.Create;
  R.RootKey:=HKEY_LOCAL_MACHINE;
  if R.OpenKey('SOFTWARE\KAMIL\LABO3000',FALSE) then begin
    try
      L:=R.ReadString('MainFont');
    except
      L:='MS SansSerif';
    end;
  end else L:='';
  R.Destroy;
  Okno.Font.Name:=L;
  if LoadString(HInst,63000+NrOkna,Buf,255)<>0 then
    Okno.Caption:=StrPas(Buf)
  else
    Okno.Caption:='';
  if Okno.ComponentCount<>0 then begin
    for i:=0 to Okno.ComponentCount-1 do begin
      C:=Okno.Components[i];
      T:=C.Tag mod 100000;
      O:=C.Tag div 100000;
      if T<>0 then begin
        if LoadString(HInst,T,Buf,255)=0 then
          Buf[0]:=#0;
        if LoadString(HInst,T+1,BufH,255)=0 then
          BufH[0]:=#0;
        case O of
          {TLabel}
          0:TLabel(C).Caption:=StrPas(Buf);
          {TButton}
          1:begin
            TButton(C).Caption:=StrPas(Buf);
            TButton(C).Hint:=StrPas(BufH);
          end;
          {TMenuItem}
          2:begin
            TMenuItem(C).Caption:=StrPas(Buf);
          end;
          {TEdit,TListBox,TComboBox}
          {i inne kontrolki, gdzie potrzebna jest sama podpowiedŸ}
          3:TControl(C).Hint:=StrPas(Buf);
          {TCheckBox}
          4:TCheckBox(C).Caption:=StrPas(Buf);
          {TRadioButton}
          5:TRadioButton(C).Caption:=StrPas(Buf);
          {TGroupBox}
          6:TGroupBox(C).Caption:=StrPas(Buf);
          {TRadioGroup}
          7:begin
            L:=StrPas(Buf);
            L1:=Copy(L,1,Pos(';',L)-1);
            Delete(L,1,Pos(';',L));
            TRadioGroup(C).Hint:=L;
            TRadioGroup(C).Caption:=L1+' ';
            j:=0;
            L:=StrPas(BufH);
            while Length(L)>0 do begin
              if Pos(';',L)<>0 then begin
                L1:=Copy(L,1,Pos(';',L)-1);
                Delete(L,1,Pos(';',L));
              end else begin
                L1:=L;
                L:=''
              end;
              TRadioGroup(C).Items[j]:=L1;
              Inc(j);
            end;
          end;
          {TTabbedNoteBook}
          8:begin
            j:=0;
            L:=StrPas(Buf);
            while Length(L)>0 do begin
              if Pos(';',L)<>0 then begin
                L1:=Copy(L,1,Pos(';',L)-1);
                Delete(L,1,Pos(';',L));
              end else begin
                L1:=L;
                L:=''
              end;
              TTabbedNotebook(C).Pages[j]:=L1;
              Inc(j);
            end;
          end;
          {TField}
          9:TField(C).DisplayLabel:=StrPas(Buf);
          {TNotebook}
          10:begin
            j:=0;
            L:=StrPas(Buf);
            while Length(L)>0 do begin
              if Pos(';',L)<>0 then begin
                L1:=Copy(L,1,Pos(';',L)-1);
                Delete(L,1,Pos(';',L));
              end else begin
                L1:=L;
                L:=''
              end;
              TNotebook(C).Pages[j]:=L1;
              Inc(j);
            end;
          end;
          {TDateEdit}
          11:begin
             TDateEdit(C).ButtonHint:=StrPas(Buf);
          end;
          {TToolButton}
          12:begin
             TToolButton(C).Caption:=StrPas(Buf);
             TToolButton(C).Hint:=StrPas(BufH);
          end;
          {TSpeedButton}
          13:begin
             TSpeedButton(C).Caption:=StrPas(Buf);
             TSpeedButton(C).Hint:=StrPas(BufH);
          end;
          {TTabSheet}
          14:begin
             TTabSheet(C).Caption:=StrPas(Buf);
             TTabSheet(C).Hint:=StrPas(BufH);
          end;
          {TDBGrid}
          15:begin
            j:=0;
            L:=StrPas(Buf);
            while Length(L)>0 do begin
              if Pos(';',L)<>0 then begin
                L1:=Copy(L,1,Pos(';',L)-1);
                Delete(L,1,Pos(';',L));
              end else begin
                L1:=L;
                L:=''
              end;
              TDBGrid(C).Columns[j].Title.Caption:=L1;
              Inc(j);
            end;
            TDBGrid(C).Hint:=StrPas(BufH);
          end;
          {TTabSet}
          16:begin
            j:=0;
            L:=StrPas(Buf);
            while Length(L)>0 do begin
              if Pos(';',L)<>0 then begin
                L1:=Copy(L,1,Pos(';',L)-1);
                Delete(L,1,Pos(';',L));
              end else begin
                L1:=L;
                L:=''
              end;
              TTabSet(C).Tabs[j]:=L1;
              Inc(j);
            end;
            TTabSet(C).Hint:=StrPas(BufH);
          end;
          {TDBDateEdit}
          17:begin
            TDBDateEdit(C).ButtonHint:=StrPas(Buf);
          end;
          {TTBDBRichEdit}
          18:begin
            TTBDBRichEdit(C).ToolsDialogCaption:=StrPas(Buf);
            TTBDBRichEdit(C).Hint:=StrPas(BufH);
          end;
          {TTBRichEdit}
          19:begin
            TTBRichEdit(C).ToolsDialogCaption:=StrPas(Buf);
            TTBRichEdit(C).Hint:=StrPas(BufH);
          end;
          {TPanel}
          20:begin
            TPanel(C).Caption:=StrPas(Buf);
            TPanel(C).Hint:=StrPas(BufH);
          end;
          {TGrid}
          21:begin
            j:=0;
            L:=StrPas(Buf);
            while Length(L)>0 do begin
              if Pos(';',L)<>0 then begin
                L1:=Copy(L,1,Pos(';',L)-1);
                Delete(L,1,Pos(';',L));
              end else begin
                L1:=L;
                L:=''
              end;
              TStringGrid(C).Cells[j,0]:=L1;
              Inc(j);
            end;
            TStringGrid(C).Hint:=StrPas(BufH);
          end;
          {THintProperties}
          22:THintProperties(C).Caption:=StrPas(Buf);
          {TPanel - hint}
          23:TPanel(C).Hint:=StrPas(Buf);
        end;
      end;
    end;
  end;
end;

procedure SetCaptions(NrOkna:WORD;Okno:TForm);
begin
  SetCaptionsAbstract(HInstance,NrOkna,Okno);
end;

procedure SetCaptionsEx(DLL:STRING;NrOkna:WORD;Okno:TForm);
var L:ShortString;
    Lib:THandle;
    R:TRegistry;
begin
  R:=TRegistry.Create;
  R.RootKey:=HKEY_LOCAL_MACHINE;
  if R.OpenKey('SOFTWARE\KAMIL\LABO3000',FALSE) then begin
    try
      L:=R.ReadString('StringsPath');
    except
      L:='';
    end;
  end else L:='';
  R.Destroy;
  L:=L+DLL+#0;
  Lib:=LoadLibrary(@L[1]);
  if Lib<32 then begin
    MessageBox(0,'Cannot load library !!!',@L[1],MB_OK);
    exit;
  end;
  try
    SetCaptionsAbstract(Lib,NrOkna,Okno);
  finally
    FreeLibrary(Lib);
  end;
end;

function IntlMessageBoxEx(DLL:STRING;Tekst,Tytul:WORD;Flags:WORD):Integer;
var ST,S:ARRAY[0..255] of CHAR;
    Lib:THandle;
    L:ShortString;
    R:TRegistry;
begin
  R:=TRegistry.Create;
  R.RootKey:=HKEY_LOCAL_MACHINE;
  if R.OpenKey('SOFTWARE\KAMIL\LABO3000',FALSE) then begin
    try
      L:=R.ReadString('StringsPath');
    except
      L:='';
    end;
  end else L:='';
  R.Destroy;
  L:=L+DLL+#0;
  Result:=IDCANCEL;
  Lib:=LoadLibrary(@L[1]);
  if Lib<32 then begin
    MessageBox(0,'cannot load library !!!',@L[1],MB_OK);
    exit;
  end;
  LoadString(Lib,Tytul,ST,255);
  LoadString(Lib,Tekst,S,255);
  FreeLibrary(Lib);
  Result:=MessageBox(0,S,ST,Flags);
end;

function IntlFmtMsgBoxEx(DLL:STRING;Tekst,Tytul:WORD;const TextArg,TytulArg:array of const;
                         Flags:WORD):Integer;
var ST,S,ST1,S1:ARRAY[0..255] of CHAR;
    Lib:THandle;
    L:ShortString;
    R:TRegistry;
begin
  R:=TRegistry.Create;
  R.RootKey:=HKEY_LOCAL_MACHINE;
  if R.OpenKey('SOFTWARE\KAMIL\LABO3000',FALSE) then begin
    try
      L:=R.ReadString('StringsPath');
    except
      L:='';
    end;
  end else L:='';
  R.Destroy;
  L:=L+DLL+#0;
  Result:=IDCANCEL;
  Lib:=LoadLibrary(@L[1]);
  if Lib<32 then begin
    MessageBox(0,'cannot load library !!!',@L[1],MB_OK);
    exit;
  end;
  LoadString(Lib,Tytul,ST,255);
  LoadString(Lib,Tekst,S,255);
  FreeLibrary(Lib);
  StrFmt(ST1,ST,TytulArg);
  StrFmt(S1,S,TextArg);
  Result:=MessageBox(0,S1,ST1,Flags);
end;

function IntlMessageBox(Tekst,Tytul:WORD;Flags:WORD):Integer;
var ST,S:ARRAY[0..255] of CHAR;
begin
  LoadString(HInstance,Tytul,ST,255);
  LoadString(HInstance,Tekst,S,255);
  IntlMessageBox:=MessageBox(0,S,ST,Flags);
end;

end.
