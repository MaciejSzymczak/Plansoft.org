unit UFBrowseRES_PLA_HISTORY;

{ Historia zmian uprawnieñ planistów (tabela RES_PLA_HISTORY, triggery xxx_PLA_HIST_TRG)

  Trzy niezale¿ne filtry, które mo¿na ³¹czyæ:
    ESearch          - zasób, którego dotyczy zmiana (dowolna fraza, jak w oknach s³owników)
    EPlaSearch       - komu zmieniono uprawnienia (planista / autoryzacja)
    EChangedBySearch - kto zmieni³ (u¿ytkownik Oracle)
  W ka¿dym polu mo¿na podaæ kilka fraz oddzielonych przecinkiem.

  Wydajnoœæ:
  - frazy zasobu i planisty s¹ najpierw zamieniane na listê ID osobnym, lekkim zapytaniem,
    dziêki czemu g³ówne zapytanie korzysta z indeksów RESPLAHIST_RES_I / RESPLAHIST_PLA_I.
    Brak dopasowañ = 1=0 (historia w ogóle nie jest czytana).
    Ponad 1000 dopasowañ (limit listy IN w Oracle) = podzapytanie.
  - wynik zamiany jest zapamiêtywany, wiêc zmiana sortowania nie powtarza wyszukiwania.
  - sortowanie odbywa siê w podzapytaniu, a limit wierszy (ROWNUM w %CONDITIONALS) na zewn¹trz,
    wiêc siatka pokazuje rzeczywiœcie najnowsze zmiany, a nie przypadkowe 2000 wierszy. }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, OleServer, ExcelXP, DB, ADODB, ImgList,
  ExtCtrls, StrHlder, Menus, ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls,
  ComCtrls, Grids, DBGrids, Buttons;

type
  TIdFilterCache = record
    subquery : string;
    filter   : string;
  end;

  TFBrowseRES_PLA_HISTORY = class(TFBrowseParent)
    LPlaSearch: TLabel;
    EPlaSearch: TEdit;
    LChangedBySearch: TLabel;
    EChangedBySearch: TEdit;
    LHint: TLabel;
    procedure ExtraSearchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UprawClick(Sender: TObject);
  private
    resCache : TIdFilterCache;
    plaCache : TIdFilterCache;
    refocusEdit     : TEdit;
    refocusSelStart : integer;
    function idFilter(var cache : TIdFilterCache; columnName, subquery : string) : string;
    function resTypeDecode : string;
    procedure hideNeedlessButtons;
  public
   Function  CanEditIntegrity : Boolean;          override;
   Function  CanEditPermission : Boolean;         override;
   Function  CanInsert    : Boolean;              override;
   Function  canDelete    : Boolean;              override;
   Function  getSearchFilter : string;            override;
   function  getFindCaption : string;             override;
   Procedure CustomConditions;                    override;
   Procedure GetTableName;                        override;
   Procedure ShowModalAsBrowser(Filter : String); override;
   Procedure SetAccessForButtons;                 override;
   Procedure editClick;                           override;
  end;

var
  FBrowseRES_PLA_HISTORY: TFBrowseRES_PLA_HISTORY;

implementation

{$R *.dfm}

Uses UUtilityParent, DM, UFProgramSettings;

const
  // ORA-01795: maximum number of expressions in a list is 1000
  maxIdsInList = 1000;

  // autoryzacje (zak³adka "Autoryzacje" w oknie Uprawnienia), odpowiednik sql_LEC_SEARCH itd. z DM
  sql_ROL_SEARCH = '(xxmsz_tools.erasePolishChars(upper(planners.name||planners.attribs_01||planners.attribs_02||planners.attribs_03||planners.attribs_04||planners.attribs_05'+
       '||planners.attribs_06||planners.attribs_07||planners.attribs_08||planners.attribs_09||planners.attribs_10||planners.attribs_11||planners.attribs_12||planners.attribs_13'+
       '||planners.attribs_14||planners.attribs_15||''#''||planners.integration_id||''#'')) like ''%%%s%%'')';

  sql_PLA_SEARCH = '(xxmsz_tools.erasePolishChars(upper(planners.name)) like ''%%%s%%'')';

  sql_CHANGED_BY_SEARCH = '(h.last_updated_by like ''%%%s%%'')';

// true, gdy pole nie zawiera ¿adnej frazy (puste albo same przecinki), zgodnie z buildFilter
function isBlankSearch(searchString : string) : boolean;
begin
  result := buildFilter('%s', searchString) = '0=0';
end;

{ TFBrowseRES_PLA_HISTORY }

function TFBrowseRES_PLA_HISTORY.canDelete: Boolean;
begin
 Result := False;
end;

function TFBrowseRES_PLA_HISTORY.CanEditIntegrity: Boolean;
begin
 Result := False;
end;

function TFBrowseRES_PLA_HISTORY.CanEditPermission: Boolean;
begin
 Result := False;
end;

function TFBrowseRES_PLA_HISTORY.CanInsert: Boolean;
begin
 Result := False;
end;

function TFBrowseRES_PLA_HISTORY.getFindCaption: string;
begin
 Result := 'Zasób';
end;

// getTableName z klasy bazowej bierze nazwê z pierwszego FROM, a tu jest nim podzapytanie
Procedure TFBrowseRES_PLA_HISTORY.GetTableName;
Begin
  Self.TableName := 'RES_PLA_HISTORY';
End;

Procedure TFBrowseRES_PLA_HISTORY.ShowModalAsBrowser(Filter : String);
begin
  if dmodule.dbgetSystemParam('RES_PLA_HISTORY','-') <> '+' then
    Info('Œledzenie historii zmian uprawnieñ jest wy³¹czone.'+CR+
         'Mo¿na je w³¹czyæ w oknie Ustawienia konfiguracyjne, w sekcji Ustawienia globalne.');
  inherited;
end;

// zamienia podzapytanie zwracaj¹ce ID na warunek dla kolumny columnName (patrz komentarz na pocz¹tku modu³u)
function TFBrowseRES_PLA_HISTORY.idFilter(var cache : TIdFilterCache; columnName, subquery : string) : string;
var ids : string;
    cnt : integer;
begin
  if cache.subquery = subquery then begin
    result := cache.filter;
    exit;
  end;

  ids := '';
  cnt := 0;
  dmodule.openSQL('select id from (' + subquery + ') where rownum <= ' + intToStr(maxIdsInList + 1));
  with dmodule.QWork do begin
    first;
    while not eof do begin
      ids := merge(ids, fieldByName('ID').AsString, ',');
      inc(cnt);
      next;
    end;
    close;
  end;

  if cnt = 0 then
    result := '1=0'
  else if cnt > maxIdsInList then
    result := columnName + ' in (' + subquery + ')'
  else
    result := columnName + ' in (' + ids + ')';

  cache.subquery := subquery;
  cache.filter   := result;
end;

// RES_ID jest unikalne we wszystkich tabelach zasobów i w PLANNERS (main_seq), wiêc wystarcza jedna lista ID
function TFBrowseRES_PLA_HISTORY.getSearchFilter: string;
begin
  if isBlankSearch(ESearch.Text) then begin
    result := '0=0';
    exit;
  end;

  result := idFilter(resCache, 'h.res_id',
              'select lecturers.id from lecturers, org_units where lecturers.orguni_id = org_units.id(+) and ' + buildFilter(sql_LEC_SEARCH, ESearch.Text)
  + ' union all select groups.id from groups, org_units where groups.orguni_id = org_units.id(+) and '      + buildFilter(sql_GRO_SEARCH, ESearch.Text)
  + ' union all select rooms.id from rooms, org_units where rooms.orguni_id = org_units.id(+) and '         + buildFilter(sql_ROM_SEARCH, ESearch.Text)
  + ' union all select subjects.id from subjects, org_units where subjects.orguni_id = org_units.id(+) and ' + buildFilter(sql_SUB_SEARCH, ESearch.Text)
  + ' union all select forms.id from forms where '     + buildFilter(sql_FOR_SEARCH, ESearch.Text)
  + ' union all select periods.id from periods where ' + buildFilter(sql_PER_SEARCH, ESearch.Text)
  + ' union all select planners.id from planners where planners.type in (''ROLE'',''EXTERNAL'') and ' + buildFilter(sql_ROL_SEARCH, ESearch.Text));
end;

// nazwy typów zasobów jak na zak³adkach okna Uprawnienia (konfigurowalne w Ustawieniach konfiguracyjnych)
function TFBrowseRES_PLA_HISTORY.resTypeDecode : string;
  function item(tableName, caption : string) : string;
  begin
    result := ', ''' + tableName + ''', ''' + EscapeApostrophes(caption) + '''';
  end;
begin
  with fprogramSettings do
    result := 'decode(h.table_name'
            + item('LEC_PLA', profileObjectNameL.Text)
            + item('GRO_PLA', profileObjectNameG.Text)
            + item('ROM_PLA', 'Zasób')
            + item('SUB_PLA', profileObjectNameC1.Text)
            + item('FOR_PLA', profileObjectNameC2.Text)
            + item('PER_PLA', profileObjectNamePeriod.Text)
            + item('ROL_PLA', 'Autoryzacja')
            + ', h.table_name)';
end;

Procedure TFBrowseRES_PLA_HISTORY.CustomConditions;
begin
  // BRefreshClick w klasie bazowej przenosi fokus na siatkê (oszczêdza tylko ESearch),
  // wiêc zapamiêtujê pole filtra i pozycjê kursora - przywraca je SetAccessForButtons
  refocusEdit := nil;
  if ActiveControl = EPlaSearch then refocusEdit := EPlaSearch
  else if ActiveControl = EChangedBySearch then refocusEdit := EChangedBySearch;
  if refocusEdit <> nil then refocusSelStart := refocusEdit.SelStart;

  DM.macros.setMacro(Query, 'RES_TYPE_DSP', resTypeDecode);

  if isBlankSearch(EPlaSearch.Text) then
    DM.macros.setMacro(Query, 'PLA_FILTER', '0=0')
  else
    DM.macros.setMacro(Query, 'PLA_FILTER', idFilter(plaCache, 'h.pla_id', 'select planners.id from planners where ' + buildFilter(sql_PLA_SEARCH, EPlaSearch.Text)));

  DM.macros.setMacro(Query, 'LUB_FILTER', buildFilter(sql_CHANGED_BY_SEARCH, EChangedBySearch.Text));
end;

// wywo³ywane na koñcu BRefreshClick, ju¿ po przeniesieniu fokusu na siatkê
Procedure TFBrowseRES_PLA_HISTORY.SetAccessForButtons;
begin
  inherited;
  if refocusEdit <> nil then begin
    ActiveControl := refocusEdit;
    refocusEdit.SelStart  := refocusSelStart;
    refocusEdit.SelLength := 0;
    refocusEdit := nil;
  end;
end;

// historii nie edytuje siê - tak¿e dwuklik i Enter w siatce
Procedure TFBrowseRES_PLA_HISTORY.editClick;
begin
end;

// Edytuj i Szukaj s¹ zbêdne; klasa bazowa przywraca widocznoœæ BEdit w UprawClick (wywo³ywanym te¿ z FormShow)
procedure TFBrowseRES_PLA_HISTORY.hideNeedlessButtons;
begin
  BEdit.Visible   := false;
  BSearch.Visible := false;
end;

procedure TFBrowseRES_PLA_HISTORY.FormShow(Sender: TObject);
begin
  inherited;
  hideNeedlessButtons;
end;

procedure TFBrowseRES_PLA_HISTORY.UprawClick(Sender: TObject);
begin
  inherited;
  hideNeedlessButtons;
end;

// odœwie¿enie z opóŸnieniem, tak jak przy wpisywaniu w ESearch (SearchTimer w klasie bazowej)
procedure TFBrowseRES_PLA_HISTORY.ExtraSearchChange(Sender: TObject);
begin
  SearchCounter := 3;
end;

end.
