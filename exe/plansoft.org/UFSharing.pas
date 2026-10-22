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
    EFilter: TEdit;
    procedure ChangeAllClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BAdvClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckListBoxClickCheck(Sender: TObject);
    procedure EFilterChange(Sender: TObject);
  private
    presourceType, presourceId : string;
    currentUserOrroleID : integer;
    // zaznaczenia wszystkich pozycji Fmain.MapPlanners - CheckListBox pokazuje tylko pozycje pasuj¹ce do filtra
    checked    : array of boolean;
    // visibleIdx[i] = indeks w Fmain.MapPlanners pozycji CheckListBox.Items[i]
    visibleIdx : array of integer;
    procedure saveVisibleChecks;
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
 for t := 0 to FSharing.CheckListBox.Count - 1 do begin
   if FSharing.CheckListBox.ItemEnabled[t] then
       FSharing.CheckListBox.Checked[t] := ChangeAll.Checked;
 end;
 saveVisibleChecks;
end;

procedure TFSharing.BitBtn1Click(Sender: TObject);
var t : integer;
    key : shortString;
begin
   for t := 0 to Fmain.MapPlanners.cnt - 1 do begin
     key := Fmain.MapPlanners.map[t].key;
     checked[t] := (key=UUtilityParent.UserID) or (key=FMain.CONROLE.Text);
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
     if checked[t] then
         sqlStatement := sqlStatement + 'INSERT INTO '+resourceType+'_PLA (ID, PLA_ID, '+resourceType+'_ID) VALUES ('+resourceType+'PLA_SEQ.NEXTVAL, '+Fmain.MapPlanners.map[t].key+','+resourceId+');'+cr;
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

procedure TFSharing.saveVisibleChecks;
var t : integer;
begin
  for t := 0 to CheckListBox.Count - 1 do
    checked[visibleIdx[t]] := CheckListBox.Checked[t];
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
        CheckListBox.Checked[i] := checked[t];
        SetLength(visibleIdx, i + 1);
        visibleIdx[i] := t;
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
       dmodule.loadMap('select pla_id,''FOUND'' from '+resourceType+'_PLA where '+resourceType+'_ID in ('+resourceId+')' ,tmp, false);
   end;

   currentUserOrroleID := -1;
   SetLength(checked, Fmain.MapPlanners.cnt);
   for t := 0 to Fmain.MapPlanners.cnt - 1 do begin
     checked[t] := false;
     if cruid = 'I' then checked[t] := true;
     if cruid = 'U' then checked[t] := tmp.getValue(Fmain.MapPlanners.map[t].key)='FOUND';
     if Fmain.MapPlanners.map[t].key = fmain.getUserOrRoleID then begin
         currentUserOrroleID := t;
         checked[t] := true;
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
     checked[t] := (key=UUtilityParent.UserID) or (StrUtils.AnsiContainsText(roles,'#'+key));
   end;
   applyFilter;
end;

procedure TFSharing.CheckListBoxClickCheck(Sender: TObject);
var t : integer;
begin
  t := CheckListBox.ItemIndex;
  if t < 0 then exit;
  saveVisibleChecks;
  if (visibleIdx[t] = currentUserOrroleID) then
      Warning.Visible :=  not CheckListBox.Checked[t];
end;

end.
