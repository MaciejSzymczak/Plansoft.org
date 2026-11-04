unit UFilteredCheckList;

// Lista wyboru wyk³adowców / grup / sal z polem "Dowolna fraza" (Zapisz rozk³ad zajêæ w Excel, Przesuñ rozk³ad zajêæ).
// Wyszukiwanie jak w oknach Wyk³adowcy, Grupy, Sale (DM.buildFilter z sql_LEC_SEARCH / sql_GRO_SEARCH / sql_ROM_SEARCH):
// fragment nazwy, skrótu, opisu, atrybutu, jednostki ..., bez rozró¿niania wielkoœci liter i polskich znaków,
// kilka fraz oddzielonych przecinkiem = dowolna z nich; lista odœwie¿a siê pó³ sekundy po wpisaniu.
// Zaznaczenia s¹ pamiêtane tak¿e dla pozycji ukrytych przez filtr (Selected); "Zaznacz wszystko" dotyczy pozycji widocznych.

interface

uses Classes, SysUtils, StdCtrls, CheckLst, ExtCtrls;

type
  TFilteredCheckList = class
  private
    FList       : TCheckListBox;
    FSearch     : TEdit;
    FSelector   : TCheckBox;
    FTimer      : TTimer;
    FSearchSQL  : string;  // np. sql_LEC_SEARCH
    FFilterFrom : string;  // zapytanie o identyfikatory, do którego jest dopisywany warunek wyszukiwania
    FIdColumn   : string;  // kolumna identyfikatora w zapytaniu listy
    FSQL        : string;
    FOrderBy    : string;
    FItems      : TStringList;  // wszystkie pozycje (bez filtra) w kolejnoœci listy; Objects = identyfikator
    FAll        : TStringList;  // identyfikatory wszystkich pozycji
    FChecked    : TStringList;  // identyfikatory zaznaczonych pozycji
    procedure searchChange(Sender : TObject);
    procedure timerTimer(Sender : TObject);
    procedure listClickCheck(Sender : TObject);
    procedure selectorClick(Sender : TObject);
    procedure setSelector(value : boolean);
    procedure showList;
    procedure updateCaption;
  public
    constructor Create(AList : TCheckListBox; ASearch : TEdit; ASelector : TCheckBox; const searchSQL, filterFrom, idColumn : string);
    destructor Destroy; override;
    // sql: SELECT nazwa, identyfikator ... WHERE ... (bez ORDER BY); checkAll: zaznacz wszystko,
    // w przeciwnym razie zostaj¹ zaznaczone te pozycje, które by³y zaznaczone i nadal s¹ na liœcie
    procedure Load(const sql, orderBy : string; checkAll : boolean);
    procedure Clear;
    procedure SetEnabled(value : boolean);
    property Selected : TStringList read FChecked;
  end;

implementation

uses DM;

constructor TFilteredCheckList.Create(AList : TCheckListBox; ASearch : TEdit; ASelector : TCheckBox; const searchSQL, filterFrom, idColumn : string);

  function sortedList : TStringList;
  begin
    result := TStringList.Create;
    result.Sorted := true;
    result.Duplicates := dupIgnore;
  end;

begin
  inherited Create;
  FList       := AList;
  FSearch     := ASearch;
  FSelector   := ASelector;
  FSearchSQL  := searchSQL;
  FFilterFrom := filterFrom;
  FIdColumn   := idColumn;
  FItems      := TStringList.Create;
  FAll        := sortedList;
  FChecked    := sortedList;
  FTimer := TTimer.Create(nil);
  FTimer.Enabled  := false;
  FTimer.Interval := 500;
  FTimer.OnTimer  := timerTimer;
  FSearch.OnChange    := searchChange;
  FList.OnClickCheck  := listClickCheck;
  FSelector.OnClick   := selectorClick;
  updateCaption;
end;

destructor TFilteredCheckList.Destroy;
begin
  FTimer.Free;
  FItems.Free;
  FAll.Free;
  FChecked.Free;
  inherited;
end;

procedure TFilteredCheckList.Load(const sql, orderBy : string; checkAll : boolean);
var i : integer;
begin
  FSQL     := sql;
  FOrderBy := orderBy;
  FItems.Clear;
  FAll.Clear;
  DModule.OpenSQL(sql + orderBy);
  while not DModule.QWork.Eof do begin
    FItems.AddObject(DModule.QWork.Fields[0].AsString, pointer(DModule.QWork.Fields[1].AsInteger));
    FAll.Add(DModule.QWork.Fields[1].AsString);
    DModule.QWork.Next;
  end;
  if checkAll then FChecked.Assign(FAll)
  else
    for i := FChecked.Count - 1 downto 0 do
      if FAll.IndexOf(FChecked[i]) < 0 then FChecked.Delete(i);
  setSelector(checkAll);
  showList;
end;

procedure TFilteredCheckList.Clear;
begin
  FSQL := '';
  FItems.Clear;
  FAll.Clear;
  FChecked.Clear;
  setSelector(false);
  showList;
end;

procedure TFilteredCheckList.SetEnabled(value : boolean);
begin
  FList.Enabled     := value;
  FSearch.Enabled   := value;
  FSelector.Enabled := value;
end;

// zmiana stanu pola "Zaznacz wszystko" bez zaznaczania pozycji listy
procedure TFilteredCheckList.setSelector(value : boolean);
begin
  FSelector.OnClick := nil;
  try
    FSelector.Checked := value;
  finally
    FSelector.OnClick := selectorClick;
  end;
end;

procedure TFilteredCheckList.showList;

  procedure add(const name : string; id : integer);
  var i : integer;
  begin
    i := FList.Items.AddObject(name, pointer(id));
    FList.Checked[i] := FChecked.IndexOf(IntToStr(id)) >= 0;
  end;

var i : integer;
begin
  FList.Items.BeginUpdate;
  try
    FList.Items.Clear;
    if Trim(FSearch.Text) = '' then begin
      for i := 0 to FItems.Count - 1 do add(FItems[i], integer(FItems.Objects[i]));
    end else if FSQL <> '' then begin
      // warunek wyszukiwania zawiera znaki % - bez Format
      DModule.OpenSQL(FSQL + ' AND ' + FIdColumn + ' IN (' + FFilterFrom + ' AND ' + buildFilter(FSearchSQL, FSearch.Text) + ')' + FOrderBy);
      while not DModule.QWork.Eof do begin
        add(DModule.QWork.Fields[0].AsString, DModule.QWork.Fields[1].AsInteger);
        DModule.QWork.Next;
      end;
    end;
  finally
    FList.Items.EndUpdate;
  end;
  updateCaption;
end;

procedure TFilteredCheckList.updateCaption;
begin
  FSelector.Caption := 'Zaznacz wszystko (zaznaczono: ' + IntToStr(FChecked.Count) + ' z ' + IntToStr(FAll.Count) + ')';
end;

procedure TFilteredCheckList.searchChange(Sender : TObject);
begin
  FTimer.Enabled := false;
  FTimer.Enabled := true;
end;

procedure TFilteredCheckList.timerTimer(Sender : TObject);
begin
  FTimer.Enabled := false;
  showList;
end;

procedure TFilteredCheckList.listClickCheck(Sender : TObject);
var i : integer;
begin
  for i := 0 to FList.Count - 1 do
    if FList.Checked[i] then FChecked.Add(IntToStr(integer(FList.Items.Objects[i])))
    else if FChecked.IndexOf(IntToStr(integer(FList.Items.Objects[i]))) >= 0 then
      FChecked.Delete(FChecked.IndexOf(IntToStr(integer(FList.Items.Objects[i]))));
  updateCaption;
end;

procedure TFilteredCheckList.selectorClick(Sender : TObject);
var i : integer;
begin
  FList.Items.BeginUpdate;
  try
    for i := 0 to FList.Count - 1 do FList.Checked[i] := FSelector.Checked;
  finally
    FList.Items.EndUpdate;
  end;
  listClickCheck(nil);
end;

end.
