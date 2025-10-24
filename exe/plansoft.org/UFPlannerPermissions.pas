unit UFPlannerPermissions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, Grids, ComCtrls, Menus;

type
  TFPlannerPermissions = class(TFormConfig)
    Panel1: TPanel;
    BOK: TBitBtn;
    DeleteClass: TSpeedButton;
    AddClass: TSpeedButton;
    mainPage: TPageControl;
    LGrid: TStringGrid;
    GGrid: TStringGrid;
    RGrid: TStringGrid;
    PopupMenu: TPopupMenu;
    Zmie1: TMenuItem;
    TabSheetL: TTabSheet;
    TabSheetG: TTabSheet;
    TabSheetR: TTabSheet;
    TabSheetSUB: TTabSheet;
    TabSheetFOR: TTabSheet;
    TabSheetROL: TTabSheet;
    ROLGrid: TStringGrid;
    SUBGrid: TStringGrid;
    FORGrid: TStringGrid;
    invertClass: TSpeedButton;
    MarkSymbol: TRadioGroup;
    Dugieopisy1: TMenuItem;
    Krtkieopisy1: TMenuItem;
    DescLen: TRadioGroup;
    Panel2: TPanel;
    FindPane: TGroupBox;
    Szukaj: TLabel;
    Label1: TLabel;
    Psearch: TEdit;
    RowSearch: TEdit;
    brefresh: TBitBtn;
    Label7: TLabel;
    Brefresh2: TBitBtn;
    btransfer: TBitBtn;
    tmp: TEdit;
    TabSheetPer: TTabSheet;
    PERGrid: TStringGrid;
    Label2: TLabel;
    ORGUNI_ID_VALUE: TEdit;
    ORGUNI_ID: TEdit;
    BitBtnCLEARROLE: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure AddClassClick(Sender: TObject);
    procedure DeleteClassClick(Sender: TObject);
    procedure LGridDblClick(Sender: TObject);
    procedure LGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure invertClassClick(Sender: TObject);
    procedure MarkSymbolClick(Sender: TObject);
    procedure Krtkieopisy1Click(Sender: TObject);
    procedure Dugieopisy1Click(Sender: TObject);
    procedure DescLenClick(Sender: TObject);
    procedure brefreshClick(Sender: TObject);
    procedure chRefreshClick(Sender: TObject);
    procedure RowSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btransferClick(Sender: TObject);
    procedure LGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SUBGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FORGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ROLGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure ORGUNI_IDChange(Sender: TObject);
    procedure BitBtnCLEARROLEClick(Sender: TObject);
  private
    LChanged   : boolean;
    PERChanged : boolean;
    GChanged   : boolean;
    RChanged   : boolean;
    SUBChanged : boolean;
    FORChanged : boolean;
    ROLChanged : boolean;
    SQLStatements : string;
    SQLStatementsCnt : Integer;
    Procedure LoadGrid;
    Procedure InvertSelection(Grid: TStringGrid; Var Flag : Boolean);
    procedure addSelection(Grid: TStringGrid; Var Flag : Boolean);
    procedure deleteSelection(Grid: TStringGrid; Var Flag : Boolean);
    procedure runSQL;
    Procedure SaveCellGrid(Grid: TStringGrid; Descriptor : String; Var Flag : Boolean; Col, Row : integer);
    function getRowSearch : string;
    function getPSearch : string;
  public
    { Public declarations }
  end;

var
  FPlannerPermissions: TFPlannerPermissions;

Procedure ShowModal;

implementation

uses DM, ufmain, UUtilityParent, UFProgramSettings, UFTransfer,
  UFFloatingMessage, UFLookupWindow, UProgress;

{$R *.DFM}

Var
    LECS    : Array[1..MaxAllLecturers] Of Record ID: Integer; NAME : String; End;
    PERS    : Array[1..maxPeriods]      Of Record ID: Integer; NAME : String; End;
    GROS    : Array[1..MaxAllGroups]    Of Record ID: Integer; NAME : String; End;
    ROMS    : Array[1..MaxAllRooms]     Of Record ID: Integer; NAME : String; End;
    ROLS    : Array[1..MaxAllRoles]     Of Record ID: Integer; NAME : String; End;
    SUBS    : Array[1..MaxAllSubjects]  Of Record ID: Integer; NAME : String; End;
    FORS    : Array[1..MaxAllForms]     Of Record ID: Integer; NAME : String; End;
    PLAS    : Array[1..MaxAllPlanners]  Of Record ID: Integer; NAME : String; End;

Function IDtoX(ID : Integer) : Integer;
Var x : Integer;
Begin x := 1;  While (PLAS[x].ID <> ID) and (x <= MaxAllPlanners-1) Do inc(x);  if x = MaxAllPlanners then result := -1 else Result := x; End;

Function LEC_IDtoY(ID : Integer) : Integer;
Var y : Integer;
Begin
  y := 1;
  While (LECS[y].ID <> ID) and (y < MaxAllLecturers) Do
    inc(y);
  if y = MaxAllLecturers-1 then result := -1 else Result := y;
End;

Function PER_IDtoY(ID : Integer) : Integer;
Var y : Integer;
Begin
  y := 1;
  While (PERS[y].ID <> ID) and (y < maxPeriods) Do
    inc(y);
  if y = maxPeriods-1 then result := -1 else Result := y;
End;

Function GRO_IDtoY(ID : Integer) : Integer;
Var y : Integer;
Begin  y := 1; While (GROS[y].ID <> ID) and (y < MaxAllGroups-1) Do inc(y); if y = MaxAllGroups then result := -1 else Result := y; End;

Function ROM_IDtoY(ID : Integer) : Integer;
Var y : Integer;
Begin  y := 1; While (ROMS[y].ID <> ID) and (y < MaxAllRooms-1)  Do inc(y); if y = MaxAllRooms then result := -1 else Result := y; End;

Function ROL_IDtoY(ID : Integer) : Integer;
Var y : Integer;
Begin  y := 1; While (ROLS[y].ID <> ID) and (y< MaxAllRoles-1) Do inc(y); if y = MaxAllRoles then result := -1 else Result := y; End;

Function SUB_IDtoY(ID : Integer) : Integer;
Var y : Integer;
Begin  y := 1; While (SUBS[y].ID <> ID) and (y< MaxAllSubjects-1) Do inc(y); if y = MaxAllSubjects then result := -1 else Result := y; End;

Function FOR_IDtoY(ID : Integer) : Integer;
Var y : Integer;
Begin  y := 1; While (FORS[y].ID <> ID) and (y< MaxAllForms-1) Do inc(y); if y = MaxAllForms then result := -1 else Result := y; End;

Procedure TFPlannerPermissions.SaveCellGrid(Grid: TStringGrid; Descriptor : String; Var Flag : Boolean; Col, Row : integer);
Var x, y : Integer;
    S    : String;
begin
  If Not Flag Then Exit;

  dmodule.CommitTrans;
  Panel1.Caption := 'Zapisywanie. Komórka nr (' + intToStr(col) + ',' + intToStr(row) + '). Proszê czekaæ...';
  //
  x := col;
  y := row;
       If Descriptor = 'LEC' Then S := 'DELETE FROM '+Descriptor+'_PLA WHERE PLA_ID='+IntToStr(PLAS[x].ID)+' AND '+Descriptor+'_ID='+IntToStr(LECS[y].ID)+'';
       If Descriptor = 'PER' Then S := 'DELETE FROM '+Descriptor+'_PLA WHERE PLA_ID='+IntToStr(PLAS[x].ID)+' AND '+Descriptor+'_ID='+IntToStr(PERS[y].ID)+'';
       If Descriptor = 'GRO' Then S := 'DELETE FROM '+Descriptor+'_PLA WHERE PLA_ID='+IntToStr(PLAS[x].ID)+' AND '+Descriptor+'_ID='+IntToStr(GROS[y].ID)+'';
       If Descriptor = 'ROM' Then S := 'DELETE FROM '+Descriptor+'_PLA WHERE PLA_ID='+IntToStr(PLAS[x].ID)+' AND '+Descriptor+'_ID='+IntToStr(ROMS[y].ID)+'';
       If Descriptor = 'ROL' Then S := 'DELETE FROM '+Descriptor+'_PLA WHERE PLA_ID='+IntToStr(PLAS[x].ID)+' AND '+Descriptor+'_ID='+IntToStr(ROLS[y].ID)+'';
       If Descriptor = 'SUB' Then S := 'DELETE FROM '+Descriptor+'_PLA WHERE PLA_ID='+IntToStr(PLAS[x].ID)+' AND '+Descriptor+'_ID='+IntToStr(SUBS[y].ID)+'';
       If Descriptor = 'FOR' Then S := 'DELETE FROM '+Descriptor+'_PLA WHERE PLA_ID='+IntToStr(PLAS[x].ID)+' AND '+Descriptor+'_ID='+IntToStr(FORS[y].ID)+'';
       SQLStatements := SQLStatements + S + '; ';

     If Grid.Cells[x,y] <> '' Then Begin
       If Descriptor = 'LEC' Then S := 'INSERT INTO '+Descriptor+'_PLA (ID, PLA_ID, '+Descriptor+'_ID) VALUES ('+Descriptor+'PLA_SEQ.NEXTVAL,'+IntToStr(PLAS[x].ID)+','+IntToStr(LECS[y].ID)+')';
       If Descriptor = 'PER' Then S := 'INSERT INTO '+Descriptor+'_PLA (ID, PLA_ID, '+Descriptor+'_ID) VALUES ('+Descriptor+'PLA_SEQ.NEXTVAL,'+IntToStr(PLAS[x].ID)+','+IntToStr(PERS[y].ID)+')';
       If Descriptor = 'GRO' Then S := 'INSERT INTO '+Descriptor+'_PLA (ID, PLA_ID, '+Descriptor+'_ID) VALUES ('+Descriptor+'PLA_SEQ.NEXTVAL,'+IntToStr(PLAS[x].ID)+','+IntToStr(GROS[y].ID)+')';
       If Descriptor = 'ROM' Then S := 'INSERT INTO '+Descriptor+'_PLA (ID, PLA_ID, '+Descriptor+'_ID) VALUES ('+Descriptor+'PLA_SEQ.NEXTVAL,'+IntToStr(PLAS[x].ID)+','+IntToStr(ROMS[y].ID)+')';
       If Descriptor = 'ROL' Then S := 'INSERT INTO '+Descriptor+'_PLA (ID, PLA_ID, '+Descriptor+'_ID) VALUES ('+Descriptor+'PLA_SEQ.NEXTVAL,'+IntToStr(PLAS[x].ID)+','+IntToStr(ROLS[y].ID)+')';
       If Descriptor = 'SUB' Then S := 'INSERT INTO '+Descriptor+'_PLA (ID, PLA_ID, '+Descriptor+'_ID) VALUES ('+Descriptor+'PLA_SEQ.NEXTVAL,'+IntToStr(PLAS[x].ID)+','+IntToStr(SUBS[y].ID)+')';
       If Descriptor = 'FOR' Then S := 'INSERT INTO '+Descriptor+'_PLA (ID, PLA_ID, '+Descriptor+'_ID) VALUES ('+Descriptor+'PLA_SEQ.NEXTVAL,'+IntToStr(PLAS[x].ID)+','+IntToStr(FORS[y].ID)+')';
       //DModule.SQL(S);
       SQLStatements := SQLStatements + S + '; ';
       SQLStatementsCnt := SQLStatementsCnt +1;
     End;
  if SQLStatementsCnt = 150 then runSQL;
end;

{}

function TFPlannerPermissions.getRowSearch : string;
begin
 result :=  RowSearch.text;
end;

function TFPlannerPermissions.getPSearch : string;
begin
 result :=  psearch.text;
end;

procedure TFPlannerPermissions.LoadGrid;
Var x, y : Integer;

  Procedure LoadCells(Descriptor : String; Grid : TStringGrid; sqlWhereClause : string);
  Var x, y : Integer;
  Begin
   fmain.wlog ('FplannerPermissions.LoadCells : Begin');
   For y := 1 To Grid.RowCount Do  For x := 1 To Grid.ColCount Do Grid.Cells[x,y] := '';
   With DModule Do Begin
    fmain.wlog ('FplannerPermissions.LoadCells : from '+Descriptor);
    OPENSQL('select * from '+Descriptor+'_pla where pla_id in ('+   'select id from planners where type  <> ''EXTERNAL'' and '+iif(editSharing,'0=0','(Id='+UserID+' or (TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+')))')+' and upper(name) like upper(''%'+getpSearch+'%'')'   +') and '+sqlWhereClause);

    QWork.First;
    While Not QWork.EOF Do Begin

     fmain.wlog ('FplannerPermissions.LoadCells.XXX_IDtoY Start');
     If Descriptor = 'LEC' Then begin y:= LEC_IDtoY(QWork.FieldByName('LEC_ID').AsInteger); end;
     If Descriptor = 'PER' Then begin y:= PER_IDtoY(QWork.FieldByName('PER_ID').AsInteger); end;
     If Descriptor = 'GRO' Then begin y:= GRO_IDtoY(QWork.FieldByName('GRO_ID').AsInteger); end;
     If Descriptor = 'ROM' Then begin y:= ROM_IDtoY(QWork.FieldByName('ROM_ID').AsInteger); end;
     If Descriptor = 'ROL' Then begin y:= ROL_IDtoY(QWork.FieldByName('ROL_ID').AsInteger); end;
     If Descriptor = 'SUB' Then begin y:= SUB_IDtoY(QWork.FieldByName('SUB_ID').AsInteger); end;
     If Descriptor = 'FOR' Then begin y:= FOR_IDtoY(QWork.FieldByName('FOR_ID').AsInteger); end;
     fmain.wlog ('FplannerPermissions.LoadCells.XXX_IDtoY End');

     if y <> -1 then begin
       x := IDtoX(QWork.FieldByName('PLA_ID').AsInteger);
       if x <> -1 then
         Grid.Cells[x, y] := '+';
     end;

     QWork.Next;
    End;
   End;
   fmain.wlog ('FplannerPermissions.LoadCells : End');
  End;

  procedure dispLog(progress : integer; text : String);
  Begin
    fmain.wlog (text);
    FProgress.ProgressBar.Position :=  round(progress *  FProgress.ProgressBar.Max / 20);
    FProgress.Refresh;
  end;

begin
  if not mainPage.Visible then exit;
  FProgress.Show;
  dispLog (1,'FplannerPermissions : planners');



  With DModule Do Begin
   OPENSQL('select * from planners where type  <> ''EXTERNAL'' and '+iif(editSharing,'0=0','(Id='+UserID+' or (TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+')))')+' and upper(name) like upper(''%'+getpSearch+'%'') ORDER BY TYPE DESC, NAME');
   //info (  inttostr(QWork.RecordCount+1) );
   LGrid.ColCount   := QWork.RecordCount+1;
   PERGrid.ColCount := QWork.RecordCount+1;
   GGrid.ColCount   := QWork.RecordCount+1;
   RGrid.ColCount   := QWork.RecordCount+1;
   ROLGrid.ColCount := QWork.RecordCount+1;
   SUBGrid.ColCount := QWork.RecordCount+1;
   FORGrid.ColCount := QWork.RecordCount+1;
   x := 1;
   QWork.First;
   While Not QWork.EOF Do Begin
    PLAS[x].ID   := QWork.FieldByName('ID').AsInteger;
    PLAS[x].NAME := QWork.FieldByName('NAME').AsString;

    QWork.Next;
    inc(x);
   End;

   dispLog (2,'FplannerPermissions : planners2');
   //zmniejszenie liczby wierszy dla ostatniej siatki
   OPENSQL('SELECT * FROM PLANNERS WHERE type  <> ''EXTERNAL'' and '+iif(editSharing,'0=0','(Id='+UserID+' or (TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+')))')+' and upper(name) like upper(''%'+getpSearch+'%'') and TYPE = ''USER''');
   ROLGrid.ColCount := QWork.RecordCount+1;

   dispLog (3,'FplannerPermissions : LECTURERS');
   OPENSQL2('SELECT LECTURERS.ID, '+sql_LECNAMEORG+' NAME FROM LECTURERS, ORG_UNITS where ORGUNI_ID=ORG_UNITS.ID and LECTURERS.id>0 and ORGUNI_ID=nvl('+ORGUNI_ID.text+',ORGUNI_ID) and '+buildFilter(sql_LEC_SEARCH, getRowSearch)+' ORDER BY LAST_NAME, FIRST_NAME');
   LGrid.RowCount := QWork2.RecordCount+1;
   y := 1;
   QWork2.First;
   While Not QWork2.EOF Do Begin
    LECS[y].ID := QWork2.Fields[0].AsInteger;
    LECS[y].NAME := QWork2.Fields[1].AsString;
    LGrid.Cells[0,y] := QWork2.Fields[1].AsString;
    QWork2.Next;
    inc(y);
   End;

    dispLog (4,'FplannerPermissions : PERIODS');
   OPENSQL2('SELECT PERIODS.ID, '+sql_PERNAME+' NAME FROM PERIODS where '+buildFilter(sql_PER_SEARCH, getRowSearch)+' ORDER BY NAME');
   PERGrid.RowCount := QWork2.RecordCount+1;
   y := 1;
   QWork2.First;
   While Not QWork2.EOF Do Begin
    PERS[y].ID := QWork2.Fields[0].AsInteger;
    PERS[y].NAME := QWork2.Fields[1].AsString;
    PERGrid.Cells[0,y] := QWork2.Fields[1].AsString;
    QWork2.Next;
    inc(y);
   End;

   dispLog (5, 'FplannerPermissions : GROUPS');
   OPENSQL2('SELECT GROUPS.ID, '+sql_GRONAMEORG+' NAME FROM GROUPS, ORG_UNITS where ORGUNI_ID=ORG_UNITS.ID and GROUPS.id>0 and ORGUNI_ID=nvl('+ORGUNI_ID.text+',ORGUNI_ID) and '+buildFilter(sql_GRO_SEARCH, getRowSearch)+' ORDER BY '+sql_GRONAME);
   GGrid.RowCount := QWork2.RecordCount+1;
   y := 1;
   QWork2.First;
   While Not QWork2.EOF Do Begin
    GROS[y].ID := QWork2.Fields[0].AsInteger;
    GROS[y].NAME := QWork2.Fields[1].AsString;
    GGrid.Cells[0,y] := QWork2.Fields[1].AsString;
    QWork2.Next;
    inc(y);
   End;

   dispLog (6, 'FplannerPermissions : ROOMS');
   OPENSQL2('SELECT rooms.ID, '+sql_ResCat0NAMEROMORG+' FROM ROOMS, ORG_UNITS where ORGUNI_ID=ORG_UNITS.ID and rooms.id>0 and ORGUNI_ID=nvl('+ORGUNI_ID.text+',ORGUNI_ID) and '+buildFilter(sql_ROM_SEARCH, getRowSearch)+' ORDER BY '+sql_ResCat0NAMEROMORG);
   RGrid.RowCount := QWork2.RecordCount+1;
   y := 1;
   QWork2.First;
   While Not QWork2.EOF Do Begin
    ROMS[y].ID := QWork2.Fields[0].AsInteger;
    ROMS[y].NAME := QWork2.Fields[1].AsString;
    RGrid.Cells[0,y] := QWork2.Fields[1].AsString;
    QWork2.Next;
    inc(y);
   End;

   dispLog (7, 'FplannerPermissions : SUBJECTS');
   OPENSQL2('SELECT SUBJECTS.ID, '+sql_SUBNAMEORG+' FROM SUBJECTS, ORG_UNITS  where ORGUNI_ID=ORG_UNITS.ID and SUBJECTS.id>0 and ORGUNI_ID=nvl('+ORGUNI_ID.text+',ORGUNI_ID) and '+buildFilter(sql_SUB_SEARCH, getRowSearch)+' ORDER BY '+sql_SUBNAMEORG);
   SubGrid.RowCount := QWork2.RecordCount+1;
   y := 1;
   QWork2.First;
   While Not QWork2.EOF Do Begin
    SUBS[y].ID   := QWork2.Fields[0].AsInteger;
    SUBS[y].NAME := QWork2.Fields[1].AsString;
    SUBGrid.Cells[0,y] := QWork2.Fields[1].AsString;
    QWork2.Next;
    inc(y);
   End;


   dispLog(8, 'FplannerPermissions : FORMS');
   OPENSQL2('SELECT ID, '+sql_FORNAME+' FROM FORMS where id>0 and '+buildFilter(sql_FOR_SEARCH, getRowSearch)+' ORDER BY '+sql_FORNAME);
   FORGrid.RowCount := QWork2.RecordCount+1;
   y := 1;
   QWork2.First;
   While Not QWork2.EOF Do Begin
    FORS[y].ID := QWork2.Fields[0].AsInteger;
    FORS[y].NAME := QWork2.Fields[1].AsString;
    FORGrid.Cells[0,y] := QWork2.Fields[1].AsString;
    QWork2.Next;
    inc(y);
   End;

   dispLog(9,'FplannerPermissions : PLANNERS');
   OPENSQL2('SELECT ID, '+sql_PLANAME+' NAME FROM PLANNERS WHERE type  <> ''EXTERNAL'' and '+iif(editSharing,'0=0','(Id='+UserID+' or (TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+')))')+' and TYPE in(''ROLE'',''EXTERNAL'') and upper(name) like upper(''%'+getRowSearch+'%'') ORDER BY '+sql_PLANAME);
   ROLGrid.RowCount := QWork2.RecordCount+1;
   y := 1;
   QWork2.First;
   While Not QWork2.EOF Do Begin
    ROLS[y].ID := QWork2.Fields[0].AsInteger;
    ROLS[y].NAME := QWork2.Fields[1].AsString;
    RolGrid.Cells[0,y] := QWork2.Fields[1].AsString;
    QWork2.Next;
    inc(y);
   End;

  End;

  dispLog (10, 'FplannerPermissions : before LoadCells');
  LoadCells('LEC', LGrid  ,'lec_id in (SELECT LECTURERS.ID FROM LECTURERS , ORG_UNITS where ORGUNI_ID=ORG_UNITS.ID and LECTURERS.id>0 and ORGUNI_ID=nvl('+ORGUNI_ID.text+',ORGUNI_ID) and '+buildFilter(sql_LEC_SEARCH, getRowSearch)+')');
  dispLog (11, 'FplannerPermissions : before LoadCells');
  LoadCells('PER', PERGrid,'per_id in (SELECT ID FROM PERIODS   where id>0 and '+buildFilter(sql_PER_SEARCH, getRowSearch)+')');
  dispLog (12, 'FplannerPermissions : before LoadCells');
  LoadCells('GRO', GGrid  ,'gro_id in (SELECT GROUPS.ID FROM GROUPS, ORG_UNITS where ORGUNI_ID=ORG_UNITS.ID and GROUPS.id>0 and ORGUNI_ID=nvl('+ORGUNI_ID.text+',ORGUNI_ID) and '+buildFilter(sql_GRO_SEARCH, getRowSearch)+')');
  dispLog (13, 'FplannerPermissions : before LoadCells');
  LoadCells('ROM', RGrid  ,'rom_id in (SELECT ROOMS.ID FROM ROOMS, ORG_UNITS where ORGUNI_ID=ORG_UNITS.ID and rooms.id>0 and ORGUNI_ID=nvl('+ORGUNI_ID.text+',ORGUNI_ID) and '+buildFilter(sql_ROM_SEARCH, getRowSearch)+')');
  dispLog (14, 'FplannerPermissions : before LoadCells');
  LoadCells('ROL', ROLGrid,'rol_id in (SELECT ID FROM PLANNERS  WHERE id>0 and type  <> ''EXTERNAL'' and '+iif(editSharing,'0=0','(Id='+UserID+' or (TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+')))')+' and  TYPE in(''ROLE'',''EXTERNAL'') and upper(name) like upper(''%'+getRowSearch+'%''))');
  dispLog (15, 'FplannerPermissions : before LoadCells');
  LoadCells('SUB', SUBGrid,'sub_id in (SELECT SUBJECTS.ID FROM SUBJECTS, ORG_UNITS  where ORGUNI_ID=ORG_UNITS.ID and SUBJECTS.id>0 and ORGUNI_ID=nvl('+ORGUNI_ID.text+',ORGUNI_ID) and '+buildFilter(sql_SUB_SEARCH, getRowSearch)+')');
  dispLog (16, 'FplannerPermissions : before LoadCells');
  LoadCells('FOR', FORGrid,'for_id in (SELECT ID FROM FORMS     where id>0 and '+buildFilter(sql_FOR_SEARCH, getRowSearch)+')');
  dispLog (19,'FplannerPermissions : after LoadCells');

  LChanged := False;
  PERChanged := False;
  GChanged := False;
  RChanged := False;
  ROLChanged := False;
  SUBChanged := False;
  FORChanged := False;

  Krtkieopisy1Click(nil);
  dispLog (20,'FplannerPermissions : done');
  FProgress.Hide;
end;

procedure TFPlannerPermissions.FormShow(Sender: TObject);
begin
 inherited;

 with fprogramsettings do begin
  TabSheetL.caption   := profileObjectNameLs.Text;
  TabSheetG.caption   := profileObjectNameGs.Text;
  TabSheetSub.caption := profileObjectNameC1.Text;
  TabSheetFor.caption := profileObjectNameC2.Text;
 end;

 FindPane.Enabled := true;
 //Psearch.Text := CurrentUserName;
 LoadGrid;
end;

procedure TFPlannerPermissions.InvertSelection(Grid: TStringGrid; Var Flag : Boolean);
Var xp, yp : Integer;
begin
  inherited;
  Flag := True;
  SQLStatements := '';
  SQLStatementsCnt := 0;
  with Grid Do
   For xp:=Selection.Left To Selection.Right Do begin
   For yp:=Selection.Top To Selection.Bottom Do begin
     If Cells[xp, yp] = '' Then Cells[xp, yp] := '+' Else Cells[xp, yp] := '';
       if upperCase(grid.Name) = 'LGRID'   then SaveCellGrid(LGrid,   'LEC',LCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'PERGRID' then SaveCellGrid(PERGrid, 'PER',PERCHANGED,xp, yp);
       if upperCase(grid.Name) = 'GGRID'   then SaveCellGrid(GGrid,   'GRO',GCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'RGRID'   then SaveCellGrid(RGrid,   'ROM',RCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'ROLGRID' then SaveCellGrid(ROLGrid, 'ROL',ROLCHANGED,xp, yp);
       if upperCase(grid.Name) = 'SUBGRID' then SaveCellGrid(SUBGrid, 'SUB',SUBCHANGED,xp, yp);
       if upperCase(grid.Name) = 'FORGRID' then SaveCellGrid(FORGrid, 'FOR',FORCHANGED,xp, yp);
     end;
     RunSQL;
  end;
end;

procedure TFPlannerPermissions.addSelection(Grid: TStringGrid; Var Flag : Boolean);
Var xp, yp : Integer;
begin
  inherited;
  Flag := True;
  SQLStatements := '';
  SQLStatementsCnt := 0;
  with Grid Do
   For xp:=Selection.Left To Selection.Right Do Begin
   For yp:=Selection.Top To Selection.Bottom Do begin
       Cells[xp, yp] := '+';
       if upperCase(grid.Name) = 'LGRID'   then SaveCellGrid(LGrid,   'LEC',LCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'PERGRID' then SaveCellGrid(PERGrid, 'PER',PERCHANGED,xp, yp);
       if upperCase(grid.Name) = 'GGRID'   then SaveCellGrid(GGrid,   'GRO',GCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'RGRID'   then SaveCellGrid(RGrid,   'ROM',RCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'SUBGRID' then SaveCellGrid(SUBGrid, 'SUB',SUBCHANGED,xp, yp);
       if upperCase(grid.Name) = 'FORGRID' then SaveCellGrid(FORGrid, 'FOR',FORCHANGED,xp, yp);
       if upperCase(grid.Name) = 'ROLGRID' then SaveCellGrid(ROLGrid, 'ROL',ROLCHANGED,xp, yp);
     end;
     runSQL;
   End;
end;

procedure TFPlannerPermissions.DeleteSelection(Grid: TStringGrid; Var Flag : Boolean);
Var xp, yp : Integer;
begin
  inherited;
  Flag := True;
  SQLStatements := '';
  SQLStatementsCnt := 0;
  with Grid Do
   For xp:=Selection.Left To Selection.Right Do begin
   For yp:=Selection.Top To Selection.Bottom Do begin
       Cells[xp, yp] := '';
       if upperCase(grid.Name) = 'LGRID'   then SaveCellGrid(LGrid,   'LEC',LCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'PERGRID' then SaveCellGrid(PERGrid, 'PER',PERCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'GGRID'   then SaveCellGrid(GGrid,   'GRO',GCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'RGRID'   then SaveCellGrid(RGrid,   'ROM',RCHANGED  ,xp, yp);
       if upperCase(grid.Name) = 'ROLGRID' then SaveCellGrid(ROLGrid, 'ROL',ROLCHANGED,xp, yp);
       if upperCase(grid.Name) = 'SUBGRID' then SaveCellGrid(SUBGrid, 'SUB',SUBCHANGED,xp, yp);
       if upperCase(grid.Name) = 'FORGRID' then SaveCellGrid(FORGrid, 'FOR',FORCHANGED,xp, yp);
     end;
     RunSQL;
   end;
end;


procedure TFPlannerPermissions.AddClassClick(Sender: TObject);
begin
  inherited;
 If mainPage.ActivePage = TabSheetL      Then addSelection(LGrid,   LChanged);
 If mainPage.ActivePage = TabSheetPER    Then addSelection(PERGrid, PERChanged);
 If mainPage.ActivePage = TabSheetG      Then addSelection(GGrid,   GChanged);
 If mainPage.ActivePage = TabSheetR      Then addSelection(RGrid,   RChanged);
 If mainPage.ActivePage = TabSheetSub    Then addSelection(SubGrid, SubChanged);
 If mainPage.ActivePage = TabSheetFor    Then addSelection(ForGrid, ForChanged);
 If mainPage.ActivePage = TabSheetRol    Then addSelection(ROLGrid, ROLChanged);
end;

procedure TFPlannerPermissions.DeleteClassClick(Sender: TObject);
begin
  inherited;
 If mainPage.ActivePage = TabSheetL    Then deleteSelection(LGrid,   LChanged);
 If mainPage.ActivePage = TabSheetPER  Then deleteSelection(PERGrid, PERChanged);
 If mainPage.ActivePage = TabSheetG    Then deleteSelection(GGrid,   GChanged);
 If mainPage.ActivePage = TabSheetR    Then deleteSelection(RGrid,   RChanged);
 If mainPage.ActivePage = TabSheetSub  Then deleteSelection(SubGrid, SubChanged);
 If mainPage.ActivePage = TabSheetFor  Then deleteSelection(ForGrid, ForChanged);
 If mainPage.ActivePage = TabSheetROL  Then deleteSelection(ROLGrid, ROLChanged);
end;

procedure TFPlannerPermissions.LGridDblClick(Sender: TObject);
begin
  inherited;
  invertClassClick(nil);
end;

procedure TFPlannerPermissions.LGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 inherited;
 If Key in [45, 13, 46, 32] Then Begin
  invertClassClick(nil);
 End;
end;

procedure TFPlannerPermissions.LGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
Var Name : String;
    t    : Integer;

  procedure DrawBusy(DrawGrid : TStringGrid ;Var Rect : TRect);
  begin
   if MarkSymbol.ItemIndex = 1 then begin
     DrawGrid.Canvas.Brush.Color := clBlack;
     DrawGrid.Canvas.rectangle(Rect.Left+1, Rect.Top+1, Rect.Right-1, Rect.Bottom-1);
   end;
  end;

begin
  inherited;
  If (ARow = 0) And (ACol<>0) Then Begin
    Name := PLAS[ACol].NAME;
    For t := 1 To Length(Name) Do (Sender as TStringGrid).Canvas.TextOut(Rect.Left+2,Rect.Top+12*(t-1),Name[t]);
  End;

  if (Sender as TStringGrid).Cells [ACol, ARow] = '+' then
    DrawBusy ((Sender as TStringGrid), Rect );



end;

Procedure ShowModal;
Begin
 If Not Assigned(FPlannerPermissions) Then FPlannerPermissions := TFPlannerPermissions.Create(Application);
 FPlannerPermissions.btransfer.enabled := editSharing;
 FPlannerPermissions.ShowModal;
 If Assigned(FPlannerPermissions) Then FPlannerPermissions.Free;
 FPlannerPermissions := Nil;
End;

procedure TFPlannerPermissions.invertClassClick(Sender: TObject);
begin
  inherited;
 If mainPage.ActivePage = TabSheetL    Then InvertSelection(LGrid,   LChanged);
 If mainPage.ActivePage = TabSheetPER  Then InvertSelection(PERGrid, PERChanged);
 If mainPage.ActivePage = TabSheetG    Then InvertSelection(GGrid,   GChanged);
 If mainPage.ActivePage = TabSheetR    Then InvertSelection(RGrid,   RChanged);
 If mainPage.ActivePage = TabSheetSUB  Then InvertSelection(SubGrid, SubChanged);
 If mainPage.ActivePage = TabSheetFOR  Then InvertSelection(ForGrid, ForChanged);
 If mainPage.ActivePage = TabSheetROL  Then InvertSelection(ROLGrid, ROLChanged);
end;

procedure TFPlannerPermissions.MarkSymbolClick(Sender: TObject);
begin
  inherited;
  hide;
  show;
end;

procedure TFPlannerPermissions.Krtkieopisy1Click(Sender: TObject);
begin
  inherited;
  LGrid.RowHeights[0] := 200;
  LGrid.ColWidths[0]  := 300;
  PERGrid.RowHeights[0] := 200;
  PERGrid.ColWidths[0]  := 300;
  GGrid.RowHeights[0] := 200;
  GGrid.ColWidths[0]  := 300;
  RGrid.RowHeights[0] := 200;
  RGrid.ColWidths[0]  := 300;
  SubGrid.RowHeights[0] := 200;
  SubGrid.ColWidths[0]  := 300;
  ForGrid.RowHeights[0] := 200;
  ForGrid.ColWidths[0]  := 300;
  ROLGrid.RowHeights[0] := 200;
  ROLGrid.ColWidths[0]  := 300;
end;

procedure TFPlannerPermissions.Dugieopisy1Click(Sender: TObject);
begin
  inherited;
  LGrid.RowHeights[0] := 400;
  LGrid.ColWidths[0]  := 600;
  PERGrid.RowHeights[0] := 400;
  PERGrid.ColWidths[0]  := 600;
  GGrid.RowHeights[0] := 400;
  GGrid.ColWidths[0]  := 600;
  RGrid.RowHeights[0] := 400;
  RGrid.ColWidths[0]  := 600;
  SubGrid.RowHeights[0] := 400;
  SubGrid.ColWidths[0]  := 600;
  ForGrid.RowHeights[0] := 400;
  ForGrid.ColWidths[0]  := 600;
  ROLGrid.RowHeights[0] := 400;
  ROLGrid.ColWidths[0]  := 600;
end;

procedure TFPlannerPermissions.DescLenClick(Sender: TObject);
begin
  inherited;
  if DescLen.ItemIndex = 0 then  Krtkieopisy1Click(nil) else Dugieopisy1Click(nil);
end;

procedure TFPlannerPermissions.brefreshClick(Sender: TObject);
begin
  inherited;
  if tmp.text<>'' then begin
      RowSearch.Text := tmp.text;
      tmp.text := '';
  end;
  Brefresh2.Visible := false;
  tmp.Visible := false;
  mainPage.Visible := true;
  LoadGrid;
end;

procedure TFPlannerPermissions.chRefreshClick(Sender: TObject);
begin
  inherited;
  brefreshClick(nil);
end;

procedure TFPlannerPermissions.RowSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
 if key = 13 then  brefreshClick(nil);
end;

procedure TFPlannerPermissions.btransferClick(Sender: TObject);
begin
  UFTransfer.showmodal;
end;

procedure TFPlannerPermissions.LGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  inherited;
  LGrid.MouseToCell(X, Y, Col, Row); // Convert mouse coordinates to cell indices

  if (Col = 0) or (Row = 0) then // Check if inside valid grid range
  begin
     FFloatingMessage.showModal('Skopiowano do schowka:' +cr+ LGrid.Cells[Col, Row]);
  end;
end;

procedure TFPlannerPermissions.GGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  inherited;
  GGrid.MouseToCell(X, Y, Col, Row); // Convert mouse coordinates to cell indices

  if (Col = 0) or (Row = 0) then // Check if inside valid grid range
  begin
     FFloatingMessage.showModal('Skopiowano do schowka:' +cr+ GGrid.Cells[Col, Row]);
  end;
end;

procedure TFPlannerPermissions.RGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  inherited;
  RGrid.MouseToCell(X, Y, Col, Row); // Convert mouse coordinates to cell indices

  if (Col = 0) or (Row = 0) then // Check if inside valid grid range
  begin
     FFloatingMessage.showModal('Skopiowano do schowka:' +cr+ RGrid.Cells[Col, Row]);
  end;
end;

procedure TFPlannerPermissions.SUBGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  inherited;
  SUBGrid.MouseToCell(X, Y, Col, Row); // Convert mouse coordinates to cell indices

  if (Col = 0) or (Row = 0) then // Check if inside valid grid range
  begin
     FFloatingMessage.showModal('Skopiowano do schowka:' +cr+ SUBGrid.Cells[Col, Row]);
  end;
end;

procedure TFPlannerPermissions.FORGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  inherited;
  ForGrid.MouseToCell(X, Y, Col, Row); // Convert mouse coordinates to cell indices

  if (Col = 0) or (Row = 0) then // Check if inside valid grid range
  begin
     FFloatingMessage.showModal('Skopiowano do schowka:' +cr+ ForGrid.Cells[Col, Row]);
  end;
end;

procedure TFPlannerPermissions.ROLGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  inherited;
  RolGrid.MouseToCell(X, Y, Col, Row); // Convert mouse coordinates to cell indices

  if (Col = 0) or (Row = 0) then // Check if inside valid grid range
  begin
     FFloatingMessage.showModal('Skopiowano do schowka:' +cr+ RolGrid.Cells[Col, Row]);
  end;
end;

procedure TFPlannerPermissions.runSQL;
begin
if SQLStatements <> '' then begin
       Self.Refresh;
       SQLStatements := 'Begin '+SQLStatements+' commit; end;';
       DModule.SQL(SQLStatements);
       SQLStatements := '';
       SQLStatementsCnt := 0;
       dmodule.CommitTrans;
       Panel1.Caption := '';
     end;
end;

procedure TFPlannerPermissions.ORGUNI_ID_VALUEClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ORGUNI_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then ORGUNI_ID.Text := ID;
end;

procedure TFPlannerPermissions.ORGUNI_IDChange(Sender: TObject);
begin
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

procedure TFPlannerPermissions.BitBtnCLEARROLEClick(Sender: TObject);
begin
  ORGUNI_ID.Text := 'NULL';
end;

end.
