unit UFSharing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, CheckLst, Buttons, ExtCtrls, UUtilityParent,UFPlannerPermissions, StrUtils;
                                                                              
type
  TFSharing = class(TFormConfig)
    CheckListBox: TCheckListBox;
    Panel1: TPanel;
    BOK: TBitBtn;
    BCancel: TBitBtn;
    Panel2: TPanel;
    ChangeAll: TCheckBox;
    BitBtn1: TBitBtn;
    BAdv: TBitBtn;
    BitBtn2: TBitBtn;
    Warning: TLabel;
    LFilter: TLabel;
    LLegend: TLabel;
    EFilter: TEdit;
    procedure ChangeAllClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BAdvClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckListBoxClickCheck(Sender: TObject);
    procedure EFilterChange(Sender: TObject);
    procedure CheckListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    presourceType, presourceId : string;
    currentUserOrroleID : integer;
    // dostêp wszystkich pozycji Fmain.MapPlanners: '' = brak, 'E' = edycja, 'R' = tylko odczyt (jak w oknie Uprawnienia,
    // xxx_PLA.ACCESS_TYPE) - CheckListBox pokazuje tylko pozycje pasuj¹ce do filtra
    access     : array of string;
    // visibleIdx[i] = indeks w Fmain.MapPlanners pozycji CheckListBox.Items[i]
    visibleIdx : array of integer;
    procedure showAccess(i : integer);
    procedure applyFilter;
    procedure executeAll(resourceType, resourceIds : string);
  public
    procedure init(cruid, resourceType, resourceId, resourceDsp : string);
    procedure executeSQL(resourceType, resourceId : string);
  end;

var
  FSharing: TFSharing;

implementation

uses UFMain, DM;

{$R *.dfm}

procedure TFSharing.ChangeAllClick(Sender: TObject);
var t : integer;
begin
 for t := 0 to CheckListBox.Count - 1 do
   if CheckListBox.ItemEnabled[t] then begin
     if ChangeAll.Checked then access[visibleIdx[t]] := 'E'
                          else access[visibleIdx[t]] := '';
     showAccess(t);
   end;
end;

procedure TFSharing.BitBtn1Click(Sender: TObject);
var t : integer;
    key : shortString;
begin
   for t := 0 to Fmain.MapPlanners.cnt - 1 do begin
     key := Fmain.MapPlanners.map[t].key;
     if (key=UUtilityParent.UserID) or (key=FMain.CONROLE.Text) then access[t] := 'E' else access[t] := '';
   end;
   applyFilter;
end;

procedure TFSharing.executeSQL(resourceType, resourceId : string);
 var t : integer;
 var sqlStatement : string;
 begin
   sqlStatement := 'begin'+cr;
   sqlStatement := sqlStatement + 'delete from '+resourceType+'_PLA where '+resourceType+'_ID='+resourceId +';'+ cr;
   for t := 0 to Fmain.MapPlanners.cnt - 1 do
     if access[t] <> '' then
         sqlStatement := sqlStatement + 'INSERT INTO '+resourceType+'_PLA (ID, PLA_ID, '+resourceType+'_ID, ACCESS_TYPE) VALUES ('+resourceType+'PLA_SEQ.NEXTVAL, '+Fmain.MapPlanners.map[t].key+','+resourceId+','''+access[t]+''');'+cr;
   sqlStatement := sqlStatement + 'commit;'+cr+'end;';
   DModule.SQL(sqlStatement);
 end;

// resourceId: jedno ID albo kilka ID oddzielonych przecinkami (np. tygodnie utworzone przyciskiem "Utwórz tygodnie")
procedure TFSharing.executeAll(resourceType, resourceIds : string);
 var t : integer;
 begin
   for t := 1 to wordCount(resourceIds, [',']) do
     executeSQL(resourceType, trim(ExtractWord(t, resourceIds, [','])));
 end;

// stan pola wyboru pozycji i listy: brak = puste, E = zaznaczone, R = wyszarzone (opis: kolorowe E / R przy nazwie)
procedure TFSharing.showAccess(i : integer);
begin
  if access[visibleIdx[i]] = 'E' then CheckListBox.State[i] := cbChecked
  else if access[visibleIdx[i]] = 'R' then CheckListBox.State[i] := cbGrayed
  else CheckListBox.State[i] := cbUnchecked;
  CheckListBox.Invalidate;
end;

// E na zielono, R na niebiesko - tak jak w oknie Uprawnienia (TFPlannerPermissions)
procedure TFSharing.CheckListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var a : string;
    box : TRect;
    oldBrush, oldFont : TColor;
begin
  with CheckListBox.Canvas do begin
    FillRect(Rect);
    a := '';
    if (Index >= 0) and (Index <= High(visibleIdx)) then a := access[visibleIdx[Index]];
    box := Classes.Rect(Rect.Left + 2, Rect.Top + 1, Rect.Left + 18, Rect.Bottom - 1);
    if a <> '' then begin
      oldBrush := Brush.Color;
      oldFont  := Font.Color;
      if a = 'E' then Brush.Color := clGreen else Brush.Color := clBlue;
      Font.Color := clWhite;
      FillRect(box);
      TextOut(box.Left + 4, box.Top, a);
      Brush.Color := oldBrush;
      Font.Color  := oldFont;
    end;
    TextOut(Rect.Left + 22, Rect.Top + 1, CheckListBox.Items[Index]);
  end;
end;

// filtr po nazwie: pusty = wszystkie pozycje
procedure TFSharing.applyFilter;
var t, i : integer;
    f    : string;
begin
  f := trim(EFilter.Text);
  CheckListBox.Items.BeginUpdate;
  try
    CheckListBox.Clear;
    SetLength(visibleIdx, 0);
    for t := 0 to Fmain.MapPlanners.cnt - 1 do
      if (f = '') or AnsiContainsText(Fmain.MapPlanners.map[t].value, f) then begin
        i := CheckListBox.Items.Add(Fmain.MapPlanners.map[t].value);
        SetLength(visibleIdx, i + 1);
        visibleIdx[i] := t;
        showAccess(i);
      end;
  finally
    CheckListBox.Items.EndUpdate;
  end;
end;

procedure TFSharing.EFilterChange(Sender: TObject);
begin
  applyFilter;
end;

procedure TFSharing.init(cruid, resourceType, resourceId, resourceDsp : string);

 var t : integer;
     tmp : tmap;

begin
  if EditObjPermisions=false then begin
    SError('Nie posiadasz uprawnieñ do uruchomienia funkcji Uprawnienia');
    exit;
  end;

   if cruid = 'U' then begin
       if (Fmain.MapPlanners.cnt=1) then begin SError('Najpierw utwórz autoryzacje lub u¿ytkownika, którym chcesz udostêpniæ rekordy'); exit; end;
   end;

   presourceType := resourceType;
   presourceId := resourceId;
   FSharing.Caption :='Wspó³dzielenie dla: '+ resourceDsp;
   BCancel.Enabled := cruid = 'U';

   if cruid = 'U' then begin
       tmp := Tmap.Create;
       dmodule.loadMap('select pla_id, max(nvl(access_type,''E'')) from '+resourceType+'_PLA where '+resourceType+'_ID in ('+resourceId+') group by pla_id' ,tmp, false);
   end;

   currentUserOrroleID := -1;
   SetLength(access, Fmain.MapPlanners.cnt);
   for t := 0 to Fmain.MapPlanners.cnt - 1 do begin
     access[t] := '';
     if cruid = 'I' then access[t] := 'E';
     if cruid = 'U' then access[t] := tmp.getValue(Fmain.MapPlanners.map[t].key, '');
     if Fmain.MapPlanners.map[t].key = fmain.getUserOrRoleID then begin
         currentUserOrroleID := t;
         if access[t] = '' then access[t] := 'E';
     end;
   end;
   if cruid = 'U' then
       tmp.Free;
   EFilter.Text := '';
   applyFilter;

   if DModule.SingleValue('SELECT NVL(MAX(ACCESS_TYPE),''E'') FROM '+resourceType+'_PLA WHERE '+resourceType+'_ID in ('+resourceId+') AND PLA_ID='+FMain.getUserOrRoleID) = 'R' then begin
     CheckListBox.Enabled := false;
     ChangeAll.Enabled := false;
     BitBtn1.Enabled := false;
     BitBtn2.Enabled := false;
     BAdv.Enabled := false;
     BOK.Enabled := false;
   end;

   if (Fmain.MapPlanners.cnt=1) or (FSharing.showModal = mrOK) then begin
     if DModule.SingleValue('SELECT NVL(MAX(ACCESS_TYPE),''E'') FROM '+resourceType+'_PLA WHERE '+resourceType+'_ID in ('+resourceId+') AND PLA_ID='+FMain.getUserOrRoleID) <> 'R' then
       executeAll(resourceType, resourceId);
   end;

end;

procedure TFSharing.BAdvClick(Sender: TObject);
begin
  executeAll(presourceType, presourceId);
  UFPlannerPermissions.ShowModal;
  Close;
end;

procedure TFSharing.BitBtn2Click(Sender: TObject);
var t : integer;
    key : shortString;
    roles : string;
begin
   roles := '';
   With dmodule do begin
     openSql('select id from PLANNERS WHERE (TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+'))');
     While Not QWork.EOF Do Begin
       roles := roles + '#'+qwork.Fields[0].AsString;
       QWork.next;
     End;
   End;

   for t := 0 to Fmain.MapPlanners.cnt - 1 do begin
     key := Fmain.MapPlanners.map[t].key;
     if (key=UUtilityParent.UserID) or (StrUtils.AnsiContainsText(roles,'#'+key)) then begin
       if access[t] = '' then access[t] := 'E'; // zachowaj R
     end else access[t] := '';
   end;
   applyFilter;
end;

// klikniêcie pola wyboru: brak -> E -> R -> brak (jak w oknie Uprawnienia). Pole wyboru zmienia siê samo
// (cbUnchecked -> cbGrayed -> cbChecked) - pozycja, której stan nie zgadza siê z access, to ta klikniêta
procedure TFSharing.CheckListBoxClickCheck(Sender: TObject);
var t : integer;
    a : string;
begin
  for t := 0 to CheckListBox.Count - 1 do begin
    a := access[visibleIdx[t]];
    if ((a = 'E') and (CheckListBox.State[t] <> cbChecked)) or
       ((a = 'R') and (CheckListBox.State[t] <> cbGrayed)) or
       ((a = '')  and (CheckListBox.State[t] <> cbUnchecked)) then begin
      if a = '' then a := 'E' else if a = 'E' then a := 'R' else a := '';
      access[visibleIdx[t]] := a;
      showAccess(t);
      if visibleIdx[t] = currentUserOrroleID then Warning.Visible := a = '';
    end;
  end;
end;

end.
