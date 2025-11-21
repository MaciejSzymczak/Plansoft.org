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
    procedure ChangeAllClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BAdvClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckListBoxClickCheck(Sender: TObject);
  private
    presourceType, presourceId : string;
    currentUserOrroleID : integer;
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
end;

procedure TFSharing.BitBtn1Click(Sender: TObject);
var t : integer;
    key : shortString;
begin
   for t := 0 to Fmain.MapPlanners.cnt - 1 do begin
     key := Fmain.MapPlanners.map[t].key;
     FSharing.CheckListBox.Checked[t] := (key=UUtilityParent.UserID) or (key=FMain.CONROLE.Text);
   end;
end;

procedure TFSharing.executeSQL(resourceType, resourceId : string);
 var t : integer;
 var sqlStatement : string;
 begin
   sqlStatement := 'begin'+cr;
   sqlStatement := sqlStatement + 'delete from '+resourceType+'_PLA where '+resourceType+'_ID='+resourceId +';'+ cr;
   for t := 0 to Fmain.MapPlanners.cnt - 1 do
     if FSharing.CheckListBox.Checked[t] then
         sqlStatement := sqlStatement + 'INSERT INTO '+resourceType+'_PLA (ID, PLA_ID, '+resourceType+'_ID) VALUES ('+resourceType+'PLA_SEQ.NEXTVAL, '+Fmain.MapPlanners.map[t].key+','+resourceId+');'+cr;
   sqlStatement := sqlStatement + 'commit;'+cr+'end;';
   DModule.SQL(sqlStatement);
 end;

procedure TFSharing.init(cruid, resourceType, resourceId, resourceDsp : string);

 var t : integer;
     tmp : tmap;

begin
  if EditObjPermisions=false then begin
    info('Nie posiadasz uprawnieñ do uruchomienia funkcji Uprawnienia');
    exit;
  end;

   if cruid = 'U' then begin
       if (Fmain.MapPlanners.cnt=1) then begin info('Najpierw utwórz autoryzacje lub u¿ytkownika, którym chcesz udostêpniæ rekordy'); exit; end;
   end;

   presourceType := resourceType;
   presourceId := resourceId;
   FSharing.Caption :='Wspó³dzielenie dla: '+ resourceDsp;
   BCancel.Enabled := cruid = 'U';

   if cruid = 'U' then begin
       tmp := Tmap.Create;
       dmodule.loadMap('select pla_id,''FOUND'' from '+resourceType+'_PLA where '+resourceType+'_ID='+resourceId ,tmp, false);
   end;

   FSharing.CheckListBox.Clear;
   for t := 0 to Fmain.MapPlanners.cnt - 1 do begin
     FSharing.CheckListBox.Items.Add(Fmain.MapPlanners.map[t].value);
     if cruid = 'I' then FSharing.CheckListBox.Checked[t] := true;
     if cruid = 'U' then FSharing.CheckListBox.Checked[t] := tmp.getValue(Fmain.MapPlanners.map[t].key)='FOUND';
     if Fmain.MapPlanners.map[t].key = fmain.getUserOrRoleID then begin
         currentUserOrroleID := t;
     //    FSharing.CheckListBox.ItemEnabled[t] := false;
         FSharing.CheckListBox.Checked[t] := true;
     end;
   end;
   if cruid = 'U' then
       tmp.Free;

   if (Fmain.MapPlanners.cnt=1) or (FSharing.showModal = mrOK) then begin
     executeSQL(resourceType, resourceId);
   end;

end;

procedure TFSharing.BAdvClick(Sender: TObject);
begin
  executeSQL(presourceType, presourceId);
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
     FSharing.CheckListBox.Checked[t] := (key=UUtilityParent.UserID) or (StrUtils.AnsiContainsText(roles,'#'+key));
   end;
end;

procedure TFSharing.CheckListBoxClickCheck(Sender: TObject);
var t : integer;
begin
  t := CheckListBox.ItemIndex;
  if (t = currentUserOrroleID) then
      Warning.Visible :=  ((t = currentUserOrroleID) and (not CheckListBox.Checked[t]));
end;

end.
