unit UFBrowseTT_RESCAT_COMBINATIONS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, DB, ADODB, ImgList, ExtCtrls, StrHlder, Menus,
  ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls, ComCtrls, Grids, DBGrids,
  Buttons, OleServer, ExcelXP;
                                                                             
type
  TFBrowseTT_RESCAT_COMBINATIONS = class(TFBrowseParent)
    ListBoxAll: TListBox;
    ListBoxSelected: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    BAddList: TBitBtn;
    BDelList: TBitBtn;
    Splitter1: TSplitter;
    Panel2: TPanel;
    PanelDetails: TPanel;
    GDetails: TRxDBGrid;
    Panel4: TPanel;
    AddParent: TBitBtn;
    DelParent: TBitBtn;
    DSDetails: TDataSource;
    QDetails: TADOQuery;
    procedure BAddListClick(Sender: TObject);
    procedure BDelListClick(Sender: TObject);
    procedure ListBoxAllDblClick(Sender: TObject);
    procedure ListBoxSelectedDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure DelParentClick(Sender: TObject);
    procedure AddParentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure refreshDetails;
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues;         override;
    Procedure BeforeEdit;            override;
    Procedure AfterPost;             override;
  end;

var
  FBrowseTT_RESCAT_COMBINATIONS: TFBrowseTT_RESCAT_COMBINATIONS;

implementation

uses DM, uutilityparent, autocreate, uFDatabaseError, UFProgramSettings;

{$R *.dfm}


procedure TFBrowseTT_RESCAT_COMBINATIONS.FormShow(Sender: TObject);
begin
  inherited;
  ListBoxAll.Clear;
  with dmodule do begin
    openSQL ( 'select weight, name from resource_categories order by name');
    while not QWork.EOF do begin
      ListBoxAll.AddItem( QWork.FieldByName('name').AsString ,  tobject(QWork.FieldByName('weight').AsInteger) );
      QWork.Next;
    end;
  end;
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.BAddListClick(Sender: TObject);
begin
  if ListBoxAll.ItemIndex = -1 then begin
    showMessage ('Wska¿ kategoriê zasobu do dodania');
    exit;
  end;
  ListBoxSelected.AddItem( ListBoxAll.Items[ListBoxAll.ItemIndex], ListBoxAll.Items.Objects[ListBoxAll.ItemIndex]  );
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.BDelListClick(Sender: TObject);
begin
  ListBoxSelected.DeleteSelected;
end;

function TFBrowseTT_RESCAT_COMBINATIONS.CheckRecord: Boolean;
var t, combination_number, cardinality : integer;
  procedure FreeObjects(const strings: TStrings) ;
  var
    idx : integer;
  begin
    for idx := 0 to Pred(strings.Count) do
    begin
      strings.Objects[idx].Free;
      strings.Objects[idx] := nil;
    end;
  end;
Begin
  With UUtilityParent.CheckValid Do Begin
    Init(Self);
    //RestrictEmpty([FOR_ID, ORGUNI_ID, FORMULA_TYPE, FORMULA, DATE_FROM ]);
    //addError('Nie mo¿na zapisac rekordu');
    Result := ShowMessage;
  End;

  combination_number := 0;
  cardinality        := 0;
  for t := 0 to ListBoxSelected.Items.Count -1 do begin
    combination_number := combination_number + Integer((  ListBoxSelected.Items.Objects[t]  ));
    cardinality := cardinality + 1;
  end;

  //FreeObjects( ListBoxSelected.Items );

  Query['COMBINATION_NUMBER'] := combination_number;
  Query['CARDINALITY']        := cardinality;
End;

procedure TFBrowseTT_RESCAT_COMBINATIONS.DefaultValues;
begin
  Query['ID']                 := DModule.SingleValue('SELECT TT_SEQ.NEXTVAL FROM DUAL');
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.ListBoxAllDblClick(
  Sender: TObject);
begin
  BAddListClick(nil);
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.ListBoxSelectedDblClick(
  Sender: TObject);
begin
 BDelListClick(nil);
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.BeforeEdit;
begin
 // CurrOperation mo¿e przyjmowaæ wartoœci {AINSERT, ACOPY, AEDIT}
 ListBoxSelected.Clear;
 if CurrOperation <> AINSERT then
 with dmodule do begin
   opensql(
    'select (select name from resource_categories where id = rescat_id) name '+cr+
    '      ,(select weight from resource_categories where id = rescat_id) weight '+cr+
    '  from tt_rescat_combinations_dtl '+cr+
    '  where rescat_comb_id = ' + id +cr+
    'order by id');
   qwork.First;
   while not qwork.Eof do begin
     ListBoxSelected.AddItem(  qwork.fieldbyname('name').AsString , tobject(QWork.FieldByName('weight').AsInteger) );
     qwork.Next;
   end;
 end;
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.AfterPost;
var vId            : shortString;
    t              : integer;
    vResCatWeights : shortString;
    q              : tadoquery;
begin
  vResCatWeights:= '';
  vId := Query['ID'];
  for t := 0 to ListBoxSelected.Items.Count -1 do begin
    vResCatWeights := merge( vResCatWeights , inttoStr(Integer((  ListBoxSelected.Items.Objects[t]  ))), ',');
  end;
  q := nil;
  dmodule.createQuery(q);
  dmodule.sql(q, 'begin tt_planner.populate_rescat_comb_dtl(:id, :ResCatWeights); end;'
             ,'id='+vId+';ResCatWeights='+vResCatWeights
             );

end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.refreshDetails;
begin
  QDetails.Close;
  If Query.IsEmpty Then Begin
    QDetails.Parameters.paramByName('rescat_comb_id').value   := '-1';
  End Else Begin
    ID := NVL(Query.FieldByName('ID').AsString,'-1');
    QDetails.Parameters.paramByName('rescat_comb_id').value  := ID;
  End;
  QDetails.Open;
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.QueryAfterScroll(
  DataSet: TDataSet);
begin
 refreshDetails;
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.DelParentClick(Sender: TObject);
var id : shortString;
begin
 id := qdetails.FieldByName('id').AsString;
 if id = '' then begin info('Brak danych do usuniêcia'); exit; end;
 if question ('Czy na pewno chcesz wy³¹czyæ regu³e dla wskazanego planisty ?') = id_yes
 then begin
  dmodule.SQL('delete from tt_pla where id = '  + id );
  refreshDetails;
 end;
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.AddParentClick(Sender: TObject);
Var keyValue : ShortString;
    translatedMessage : string;
    //-------------------------------
    procedure errorMessage(aAction: Integer; P: Pointer; ErrorMessage: String);
    var translatedMessage : string;
    begin
        if DBMap.get (ErrorMessage, translatedMessage)
        then SError(translatedMessage)
        else UFDatabaseError.ShowModal(aAction, P, ErrorMessage);
    end;
begin
  keyValue := '';
  If PLANNERSShowModalAsSelect(KeyValue) = mrOK Then begin
       try
       dmodule.sql('begin insert into tt_pla (id, pla_id, rescat_comb_id) values (tt_seq.nextval, :pla_id, :rescat_comb_id ); end;'
                  ,'pla_id='+keyValue+';rescat_comb_id='+Id
                  );
       except
        on E:exception Do Begin
           if DBMap.get (E.Message, translatedMessage) then begin SError(translatedMessage); abort; end;
           errorMessage(APost, Self, E.Message);
           Abort;
          End
       end;

    refreshDetails;
  end;
end;

procedure TFBrowseTT_RESCAT_COMBINATIONS.FormCreate(Sender: TObject);
begin
  with fprogramSettings do begin
    GDetails.Columns[0].Title.caption := profileObjectNamePlanner.Text;
  end;

  inherited;
end;

end.
