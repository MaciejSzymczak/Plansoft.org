unit UFBrowseParent;

interface

// 2013.01.27 ShowModalAsBrowser is virtual now
//            FindFirstVisibleColumns

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, DBCtrls, ExtCtrls, Menus, dbTables,
  Placemnt, Db, RxQuery, UFormConfig, StrHlder,
  RxDBComb, UFReadString, ComCtrls, UFDatabaseError, MaxMin,
  UFlex, ToolEdit, ImgList, adodb, Mask, OleServer,
  TlHelp32, variants, ActiveX, ExcelXP;

  const maxFlexs = 15;

type
  TFBrowseParent = class(TFormConfig)
    PMenu: TPopupMenu;
    PPAdd: TMenuItem;
    PPEdit: TMenuItem;
    PPDelete: TMenuItem;
    Source: TDataSource;
    PPSelect: TMenuItem;
    PPCancel: TMenuItem;
    N1: TMenuItem;
    HolderSortOrder: TStrHolder;
    GridLayout: TStrHolder;
    PPSearch: TMenuItem;
    PPCopy: TMenuItem;
    Komunikaty: TStrHolder;
    ConditionsWhereClause: TStrHolder;
    AvailColumnsWhereClause: TStrHolder;
    Others: TStrHolder;
    MainPage: TPageControl;
    Browse: TTabSheet;
    Update: TTabSheet;
    TopPanel: TPanel;
    Upraw: TSpeedButton;
    LabelSortOrder: TLabel;
    BFilter: TSpeedButton;
    LAdvancedFilter: TLabel;
    LFind: TLabel;
    BNext: TBitBtn;
    BPrev: TBitBtn;
    BFirst: TBitBtn;
    BLast: TBitBtn;
    ComboSortOrder: TComboBox;
    EFilter: TEdit;
    ESearch: TEdit;
    BCancelSearch: TBitBtn;
    Grid: TRxDBGrid;
    BottomPanel: TPanel;
    BClose: TBitBtn;
    BAdd: TBitBtn;
    BEdit: TBitBtn;
    BDelete: TBitBtn;
    BSelect: TBitBtn;
    BCancel: TBitBtn;
    BDeleteAll: TBitBtn;
    BSearch: TBitBtn;
    BCopy: TBitBtn;
    Panel: TPanel;
    UpdPanel: TPanel;
    BUpdCancel: TBitBtn;
    BUpdOK: TBitBtn;
    Messages: TStrHolder;
    BUpdApply: TBitBtn;
    BUpdChild1: TBitBtn;
    BUpdChild2: TBitBtn;
    BUpdChild3: TBitBtn;
    CustomPanel: TPanel;
    N2: TMenuItem;
    m1: TMenuItem;
    m2: TMenuItem;
    m3: TMenuItem;
    m4: TMenuItem;
    BOleExport: TBitBtn;
    BUpdChild4: TBitBtn;
    BUpdChild5: TBitBtn;
    StatusBar: TStatusBar;
    Panel1: TPanel;
    ShowPanel: TSpeedButton;
    BCountRecords: TBitBtn;
    BShowRecords: TSpeedButton;
    SearchTimer: TTimer;
    m5: TMenuItem;
    m6: TMenuItem;
    N3: TMenuItem;
    PPChild1: TMenuItem;
    PPChild2: TMenuItem;
    PPChild3: TMenuItem;
    PPChild4: TMenuItem;
    PPChild5: TMenuItem;
    SecondRatePanel: TPanel;
    BChild5: TBitBtn;
    BChild4: TBitBtn;
    BChild3: TBitBtn;
    BChild2: TBitBtn;
    BChild1: TBitBtn;
    BShowChildsPanel: TSpeedButton;
    BUpdNew: TBitBtn;
    BUpdNext: TBitBtn;
    BUpdPrev: TBitBtn;
    BDiagnosticsModule: TBitBtn;
    BExecuteCalc: TBitBtn;
    BUpdCopy: TBitBtn;
    FlexPanel: TPanel;
    ATTRIBS_01: TDBEdit;
    ATTRIBS_02: TDBEdit;
    ATTRIBS_03: TDBEdit;
    ATTRIBS_04: TDBEdit;
    ATTRIBS_05: TDBEdit;
    ATTRIBS_06: TDBEdit;
    ATTRIBS_07: TDBEdit;
    ATTRIBS_08: TDBEdit;
    ATTRIBS_09: TDBEdit;
    ATTRIBS_10: TDBEdit;
    ATTRIBS_11: TDBEdit;
    ATTRIBS_12: TDBEdit;
    ATTRIBS_13: TDBEdit;
    ATTRIBS_14: TDBEdit;
    ATTRIBS_15: TDBEdit;
    ATTRIBN_01: TDBEdit;
    ATTRIBN_02: TDBEdit;
    ATTRIBN_03: TDBEdit;
    ATTRIBN_04: TDBEdit;
    ATTRIBN_05: TDBEdit;
    ATTRIBN_06: TDBEdit;
    ATTRIBN_07: TDBEdit;
    ATTRIBN_08: TDBEdit;
    ATTRIBN_09: TDBEdit;
    ATTRIBN_10: TDBEdit;
    ATTRIBN_11: TDBEdit;
    ATTRIBN_12: TDBEdit;
    ATTRIBN_13: TDBEdit;
    ATTRIBN_14: TDBEdit;
    ATTRIBN_15: TDBEdit;
    ATTRIBD_01: TDBDateEdit;
    ATTRIBD_02: TDBDateEdit;
    ATTRIBD_03: TDBDateEdit;
    ATTRIBD_06: TDBDateEdit;
    ATTRIBD_05: TDBDateEdit;
    ATTRIBD_04: TDBDateEdit;
    ATTRIBD_09: TDBDateEdit;
    ATTRIBD_08: TDBDateEdit;
    ATTRIBD_07: TDBDateEdit;
    ATTRIBD_12: TDBDateEdit;
    ATTRIBD_11: TDBDateEdit;
    ATTRIBD_10: TDBDateEdit;
    ATTRIBD_15: TDBDateEdit;
    ATTRIBD_14: TDBDateEdit;
    ATTRIBD_13: TDBDateEdit;
    LATTRIBS_01: TStaticText;
    LATTRIBS_02: TStaticText;
    LATTRIBS_03: TStaticText;
    LATTRIBS_04: TStaticText;
    LATTRIBS_05: TStaticText;
    LATTRIBS_06: TStaticText;
    LATTRIBS_07: TStaticText;
    LATTRIBS_08: TStaticText;
    LATTRIBS_09: TStaticText;
    LATTRIBS_10: TStaticText;
    LATTRIBS_11: TStaticText;
    LATTRIBS_12: TStaticText;
    LATTRIBS_13: TStaticText;
    LATTRIBS_14: TStaticText;
    LATTRIBS_15: TStaticText;
    LATTRIBN_01: TStaticText;
    LATTRIBN_02: TStaticText;
    LATTRIBN_03: TStaticText;
    LATTRIBN_04: TStaticText;
    LATTRIBN_05: TStaticText;
    LATTRIBN_06: TStaticText;
    LATTRIBN_07: TStaticText;
    LATTRIBN_08: TStaticText;
    LATTRIBN_09: TStaticText;
    LATTRIBN_10: TStaticText;
    LATTRIBN_11: TStaticText;
    LATTRIBN_12: TStaticText;
    LATTRIBN_13: TStaticText;
    LATTRIBN_14: TStaticText;
    LATTRIBN_15: TStaticText;
    LATTRIBD_01: TStaticText;
    LATTRIBD_02: TStaticText;
    LATTRIBD_03: TStaticText;
    LATTRIBD_04: TStaticText;
    LATTRIBD_05: TStaticText;
    LATTRIBD_06: TStaticText;
    LATTRIBD_07: TStaticText;
    LATTRIBD_08: TStaticText;
    LATTRIBD_09: TStaticText;
    LATTRIBD_10: TStaticText;
    LATTRIBD_11: TStaticText;
    LATTRIBD_12: TStaticText;
    LATTRIBD_13: TStaticText;
    LATTRIBD_14: TStaticText;
    LATTRIBD_15: TStaticText;
    FlexDelete: TSpeedButton;
    FlexAdd: TSpeedButton;
    FlexMore: TSpeedButton;
    FlexToolbar: TShape;
    BFlexDesignMode: TSpeedButton;
    flexPopup: TPopupMenu;
    Przywrdomylnepooeniewszystkichatrybutw1: TMenuItem;
    Zaawansowanakonfiguracjaatrybutw1: TMenuItem;
    Wyjdztrybuprojetowaniaatrybutw1: TMenuItem;
    PanelAlphabet: TPanel;
    AlphaShow: TSpeedButton;
    AlphaA: TSpeedButton;
    AlphaB: TSpeedButton;
    AlphaC: TSpeedButton;
    AlphaD: TSpeedButton;
    AlphaE: TSpeedButton;
    AlphaF: TSpeedButton;
    AlphaG: TSpeedButton;
    AlphaH: TSpeedButton;
    AlphaI: TSpeedButton;
    AlphaJ: TSpeedButton;
    AlphaK: TSpeedButton;
    AlphaL: TSpeedButton;
    AlphaM: TSpeedButton;
    AlphaN: TSpeedButton;
    AlphaQ: TSpeedButton;
    AlphaP: TSpeedButton;
    AlphaR: TSpeedButton;
    AlphaS: TSpeedButton;
    AlphaT: TSpeedButton;
    AlphaU: TSpeedButton;
    AlphaV: TSpeedButton;
    AlphaW: TSpeedButton;
    AlphaX: TSpeedButton;
    AlphaY: TSpeedButton;
    AlphaZ: TSpeedButton;
    AlphaO: TSpeedButton;
    AlphaAll: TSpeedButton;
    ImageList: TImageList;
    Query: TADOQuery;
    ExcelApplication1: TExcelApplication;
    ppexport: TPopupMenu;
    ExportEasy: TMenuItem;
    ExportHtml: TMenuItem;
    EksportujdoExcela1: TMenuItem;
    BConfigure: TBitBtn;
    BRefresh: TBitBtn;
    BCrossCombination: TSpeedButton;
    bexportpopup: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure BAddClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridDblClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure BSelectClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BPrintModuleClick(Sender: TObject);
    procedure BDeleteAllClick(Sender: TObject);
    procedure BConfigureClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UprawClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BFirstClick(Sender: TObject);
    procedure BPrevClick(Sender: TObject);
    procedure BNextClick(Sender: TObject);
    procedure BLastClick(Sender: TObject);
    procedure ComboSortOrderChange(Sender: TObject);
    procedure BSearchClick(Sender: TObject);
    procedure PPSearchClick(Sender: TObject);
    procedure BCopyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BFilterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BCountRecordsClick(Sender: TObject);
    procedure BCancelSearchClick(Sender: TObject);
    procedure ShowPanelClick(Sender: TObject);
    procedure BUpdCancelClick(Sender: TObject);
    procedure ESearchChange(Sender: TObject);
    procedure BUpdApplyClick(Sender: TObject);
    procedure PPCopyClick(Sender: TObject);
    procedure BGraphModuleClick(Sender: TObject);
    procedure BSummariesModuleClick(Sender: TObject);
    procedure BOleExportClick(Sender: TObject);
    procedure BShowRecordsClick(Sender: TObject);
    procedure GridTitleClick(Column: TColumn);
    procedure SearchTimerTimer(Sender: TObject);
    procedure BCrossCombinationClick(Sender: TObject);
    procedure m5Click(Sender: TObject);
    procedure m6Click(Sender: TObject);
    procedure PPSecondRate1Click(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure BUpdChild3Click(Sender: TObject);
    procedure BUpdChild4Click(Sender: TObject);
    procedure BShowChildsPanelClick(Sender: TObject);
    procedure BUpdNewClick(Sender: TObject);
    procedure BUpdNewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BUpdNextClick(Sender: TObject);
    procedure BUpdPrevClick(Sender: TObject);
    procedure BInternetBrowserExportClick(Sender: TObject);
    procedure BExecuteCalcClick(Sender: TObject);
    procedure BDiagnosticsModuleClick(Sender: TObject);
    procedure BUpdOKClick(Sender: TObject);
    procedure BUpdCopyClick(Sender: TObject);
    procedure BUpdChild5Click(Sender: TObject);
    procedure FlexAddClick(Sender: TObject);
    procedure LATTRIBS_01MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FlexMoreClick(Sender: TObject);
    procedure FlexDeleteClick(Sender: TObject);
    procedure FlexPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BFlexDesignModeClick(Sender: TObject);
    procedure Zaawansowanakonfiguracjaatrybutw1Click(Sender: TObject);
    procedure Przywrdomylnepooeniewszystkichatrybutw1Click(
      Sender: TObject);
    procedure Wyjdztrybuprojetowaniaatrybutw1Click(Sender: TObject);
    procedure AlphaShowClick(Sender: TObject);
    procedure AlphaAClick(Sender: TObject);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure PPSelectClick(Sender: TObject);
    procedure QueryBeforeClose(DataSet: TDataSet);
    procedure TopPanelDblClick(Sender: TObject);
    procedure bexportpopupClick(Sender: TObject);
    procedure ExportEasyClick(Sender: TObject);
    procedure ExportHtmlClick(Sender: TObject);
    procedure EksportujdoExcela1Click(Sender: TObject);
    procedure EFilterClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
   Bookmark        : String[30];
   HotKeys         : Array[1..20] Of Word;
   TempSQL         : String;
   TempWindowState : TWindowState;
   TempWidth       : Integer;
   TempHeight      : Integer;
   TempLeft        : Integer;
   TempTop         : Integer;
   PRE_UPPERCASE   : String[20];
   POST_UPPERCASE  : String[20];
   GridRelayoutRequired : boolean;

   Procedure ApplyGridLayout;
   procedure UpdateStaticLayout;
   Procedure FindWindow(S : String);
   Procedure RefreshHotKeys;
   Function  getColumnCaption(FieldName : ShortString) : ShortString;
   Function  GetFieldType(Field : TField) : ShortString;
   procedure LockNotUpdatable;
   procedure UnLockNotUpdatable;
   function  UpdApplyAndClose : boolean;
   function  getOrderByClause : String;
  public
   Mode            : Integer;
   MR              : Integer;
   ID             : ShortString; // wartoœæ klucza g³ównego
   KeyField       : ShortString; // nazwa klucza g³ównego (domyœlenie = ID)
   TableName      : ShortString;
   CopiedRecordId : ShortString; // gdy CurrOperation = ACopy, CopiedRecord = ID kopiowanego rekordu
   FirstControl   : TWinControl;
   SingleMode     : Boolean; {True = call by ShowModalAsSingle; otherwise False}
   //DatabaseODBC : TDatabase;
   CurrOperation : Integer;
   not_updatable_columns : Record A : Array[0..100] Of TWinControl; C : Integer; End;
   not_updatable_labels :  Record A : Array[0..100] Of TLabel;      C : Integer; End;
   SearchCounter   : Integer;
   CanRefresh      : Boolean;

   //used by flex mechanizm
   attribs  : array[1..maxFlexs] of record l: tStaticText; c: tdbedit;     cpos : tpoint; lpos : tpoint; custom_name : string[30]; sql_check_message : string[240]; sql_check_procedure : string[240]; sql_default_value : string[240]; required : string[1]; system_flag : string[1]; end;
   attribn  : array[1..maxFlexs] of record l: tStaticText; c: tdbedit;     cpos : tpoint; lpos : tpoint; custom_name : string[30]; sql_check_message : string[240]; sql_check_procedure : string[240]; sql_default_value : string[240]; required : string[1]; system_flag : string[1]; end;
   attribd  : array[1..maxFlexs] of record l: tStaticText; c: tdbdateedit; cpos : tpoint; lpos : tpoint; custom_name : string[30]; sql_check_message : string[240]; sql_check_procedure : string[240]; sql_default_value : string[240]; required : string[1]; system_flag : string[1]; end;

   flexCurrentFieldName : shortString;

   flexEnabled  : boolean;
   flexModified : boolean;        //flag, whether fields were moved by mouse
   flexContextName : shortString; //do not change it. use following functions instead
   procedure flexSetContextNameInListView; virtual; //do not reference to query.fields in this procedure. Query might me inactive !
   procedure flexSetContextNameInFormView; virtual; //it is possible and desired to reference to query.fields
   procedure flexInitialize;
   procedure flexSynchronize;  //delete not used flexes, update flex captions, insert lack flexes, reset flex dependent settings
   procedure flexRefreshListView;
   procedure flexRefreshFormView;
   procedure flexSaveFormView;
   procedure flexDefaultValues ( const fieldName : shortString = '');
   function  flexCheckRecord : boolean;
   procedure flexGetAttribute ( fname : string; var systemFlag : shortString );

   function  DecodeFieldName(FieldName : ShortString): ShortString; // used to prefix field name by table name, for instance: NAME -> T.NAME
                                                                    // prevents from ambiguous field name error
   Function  execute(aCurrOperation : Integer; aID : ShortString) : TModalResult; virtual;
   Procedure setAccessForButtons;           virtual;
   Procedure addClick;                      Virtual;
   Procedure editClick;                     Virtual;
   Procedure copyClick;	            	      Virtual;
   Procedure deleteClick;                   Virtual;
   Procedure deleteAllClick;                Virtual;
   Function  canShow      : Boolean;        virtual;
   Function  canEditIntegrity  : Boolean;   Virtual;
   Function  canEditPermission : Boolean;   Virtual;
   Function  canInsert    : Boolean;        Virtual;
   Function  canDelete    : Boolean;        Virtual;
   Function  canConfigure : Boolean;        Virtual;
   Function  checkRecord  : Boolean;        Virtual;
   Procedure defaultValues;                 virtual;

   Procedure beforeDelete;                  Virtual; // variable ID is valid and can be used
   Procedure afterDelete;                   Virtual; // variable ID is valid and can be used
   Procedure beforeEdit;                    virtual; // CurrOperation in [AINSERT, ACOPY, AEDIT]
   Procedure beforePost;                    virtual;
   Procedure afterPost;                     virtual;
   Procedure afterCloseDetails;             virtual;

   Procedure customConditions;              virtual;
   Procedure getTableName;                  virtual;
   Function  getSearchFilter : string;      virtual;
   function  getFindCaption : string;       virtual;

   Procedure ShowModalAsBrowser(Filter : String); virtual;
   // Struktura Filter zgodna z zawartoœci¹ UstawieniaFiltra
   // Gdy Filter = '' - brak wymuszenia filtra (wówczas obowi¹zuje dotychczasowy filtr)
   Function  ShowModalAsSelect(Var aID : ShortString) : TModalResult;
   Function  ShowModalAsMultiSelect(Var aIDs : String) : TModalResult; //Klucze zwracane s¹ w postaci "1,2,3, ... ,n". U¿yj funkcji WordCount oraz ExtractWord do ich odczytania w pêtli
   Function  ShowModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
   Procedure CreateAvailColumnsWhereClause(S : TStrings);
   Procedure PrepareColumnsForExports(S : TStrings);
   procedure SetNotUpdatable(COLS : Array of TWinControl; LBLS : Array of TLabel);
   Procedure copyRecord(FromID : String; FillNotEmptyFields : Boolean);
   function  UpdApplyClick : Boolean;
   procedure errorMessage(aAction : Integer; P : Pointer; ErrorMessage : String);
   Function  PrepareQueryOnDetailsForm : TModalResult;
   procedure SwitchQueryToGrid;
   Procedure SwitchQueryToDetails;
   Procedure SwitchFormToGrid;
   Procedure SwitchFormToDetails;
   Procedure ExportToHtml(aGrid : TDBGrid );
   function findFirstVisibleColumn : integer;
   Procedure CreateGridLayout;
  end;

var
  FBrowseParent: TFBrowseParent;


implementation

uses DM, DBUtils, UUtilityParent, UFModuleConfigure,
  UFModuleFilter, UFModuleCrossCombination, UFFlexNewAttribute, autocreate, rxStrUtils,
  UFProgramSettings;

{$R *.DFM}

Const MinWidth  = 433+60+80;
      MinHeight = 306;

//obsolete
//------------------------------------------------------------------
//Function DisconectDBMemos(Self : TForm; Source : TDataSource) : TWinControl;
//Var T : Integer;
//Begin
//   Result := Nil;
//   For t := 0 To Self.ComponentCount - 1 Do Begin
//    If (Self.Components[t] is TDBMemo) And (TDBMemo(Self.Components[t]).Tag <> 1)Then
//     If TDBMemo(Self.Components[t]).DataSource = Source Then Begin
//      TDBMemo(Self.Components[t]).DataSource := Nil;
//     End;
//    If (Self.Components[t] is TDBRichEdit) And (TDBRichEdit(Self.Components[t]).Tag <> 1)Then
//     If TDBRichEdit(Self.Components[t]).DataSource = Source Then Begin
//      TDBRichEdit(Self.Components[t]).DataSource := Nil;
//     End;
//   End;
//End;

//------------------------------------------------------------------
//Function ConectDBMemos(Self : TForm; Source : TDataSource) : TWinControl;
//Var T : Integer;
//Begin
//   Result := Nil;
//
//   For t := 0 To Self.ComponentCount - 1 Do Begin
//    If (Self.Components[t] is TDBMemo) And (TDBMemo(Self.Components[t]).Tag <> 1)Then
//     If TDBMemo(Self.Components[t]).DataSource = Nil Then Begin
//      TDBMemo(Self.Components[t]).DataSource := Source;
//     End;
//    If (Self.Components[t] is TDBRichEdit) And (TDBRichEdit(Self.Components[t]).Tag <> 1)Then
//     If TDBRichEdit(Self.Components[t]).DataSource = Nil Then Begin
//      TDBRichEdit(Self.Components[t]).DataSource := Source;
//     End;
//   End;
//End;

//------------------------------------------------------------------
Function TFBrowseParent.canDelete : Boolean;
Begin
 Result := True;
End;

//------------------------------------------------------------------
Function  TFBrowseParent.canShow   : Boolean;
Begin
 Result := True;
End;

//------------------------------------------------------------------
Function TFBrowseParent.canEditIntegrity : Boolean;
Begin
 Result := True;
End;

//------------------------------------------------------------------
Function TFBrowseParent.canEditPermission : Boolean;
Begin
 Result := True;
End;

//------------------------------------------------------------------
Function TFBrowseParent.canInsert : Boolean;
Begin
 Result := True;
End;

//------------------------------------------------------------------
Function TFBrowseParent.canConfigure : Boolean;
Begin
 Result := True;
End;

//------------------------------------------------------------------
function TFBrowseParent.flexCheckRecord : boolean;
var t : integer;
    errorFlag : shortstring;
begin
 With UUtilityParent.CheckValid Do Begin
   Init(Self);

   for t := 1 to maxFlexs do begin
       if  attribs[ t].c.Visible then begin
         //required
         if attribs[ t].required = '+' then
           if attribs[ t].c.Text = '' then
             addError ( upperCase( attribs[ t].l.caption ) + ' musi zostaæ uzupe³nione' );
         //formula
         if attribs[ t].sql_check_message <> '' then begin
            //info ( attribs[ t].sql_check_procedure );
            //info ( 'current='+attribs[ t].c.Text );
            errorFlag :=
              dmodule.SingleValue(attribs[ t].sql_check_procedure
                                 ,'current='+attribs[ t].c.Text +';'+
                                  'current='+attribs[ t].c.Text +';'+
                                  'current='+attribs[ t].c.Text +';'+
                                  'current='+attribs[ t].c.Text +';'+
                                  'current='+attribs[ t].c.Text +';'+
                                  'current='+attribs[ t].c.Text +';'+
                                  'current='+attribs[ t].c.Text +';'+
                                  'current='+attribs[ t].c.Text
                                 ); // dla ka¿dego parametru
                                    // wyszukaj element najpierw po attr_name, potem po custom_name, potem po FIELD_NAME
                                    //   gdy parametr jest data to .asDateTime !!
            if errorFlag = 'ERROR' then addError ( upperCase( attribs[ t].l.caption ) + ' : '+ attribs[ t].sql_check_message );
         end;
       end;

       if  attribn[ t].c.Visible then begin
         //required
         if attribn[ t].required = '+' then
           if attribn[ t].c.Text = '' then
             addError ( upperCase( attribn[ t].l.caption ) + ' musi zostaæ uzupe³nione' );
         //formula
         if attribn[ t].sql_check_message <> '' then begin
            errorFlag :=
              dmodule.SingleValue(attribn[ t].sql_check_procedure
                                 ,'current='+attribn[ t].c.Text
                                 );
            if errorFlag = 'ERROR' then addError ( upperCase( attribn[ t].l.caption ) + ' : '+ attribn[ t].sql_check_message );
         end;
       end;

       if  attribd[ t].c.Visible then begin
         //required
         if attribd[ t].required = '+' then
           if attribd[ t].c.Date = 0 then
             addError ( upperCase( attribd[ t].l.caption ) + ' musi zostaæ uzupe³nione' );
         //date format
         if attribd[ t].c.Date = 0 then
           Try attribd[ t].c.CheckValidDate;  Except addError( upperCase( attribd[ t].l.caption ) + ' jest b³êdna. WprowadŸ prawid³ow¹ datê' ); End;
         //formula
         if attribd[ t].sql_check_message <> '' then begin
            errorFlag :=
              dmodule.SingleValueParamDateTime(attribd[ t].sql_check_procedure
                                 ,'current',  attribd[ t].c.date
                                 );
            if errorFlag = 'ERROR' then addError ( upperCase( attribd[ t].l.caption ) + ' : '+ attribd[ t].sql_check_message );
         end;
       end;

   end;
   Result := ShowMessage;
 End;
end;


//------------------------------------------------------------------
Function  TFBrowseParent.checkRecord : Boolean;
Begin
 Result := True;
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.getTableName;
Var L : String;
    i,j : Integer;
Begin
  L:=UpperCase(DelRSpace(ReplaceStr(Query.SQL.Text,#13+#10,' ')));
  L:= ReplaceStr(L,',',' ');
  i:=Pos(' FROM ',L);
  L:=Copy(L,i+6,65535);
  L:=Trim(L);
  j:=pos(' ',L);
  if j<>0 then L:=Copy(L,1,j-1);

  Self.TableName := L;
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.addClick;
Begin
 If Not CanInsert Then Begin
  Warning(Komunikaty.Strings[2]);
  Exit;
 End;
 Execute(AInsert,'');
End;

//------------------------------------------------------------------
function isFlex ( FieldName : string ) : boolean;
begin
 result := subStr(upperCase( FieldName ),1,6) = 'ATTRIB';
end;


//------------------------------------------------------------------
procedure TFBrowseParent.flexInitialize;
var t : integer;
  function getFlexEnabled : boolean;
  var L : Integer;
  begin
   for L:=0 To Grid.Columns.Count - 1 Do begin
      if isFlex ( Grid.Columns[L].FieldName ) then begin
        result := true;
        exit;
      end;
   end;
   result := false;
  end;
begin
   flexEnabled     := getFlexEnabled;

   BFlexDesignMode.Visible := flexEnabled;
   flexContextName := 'DEFAULT';
   flexModified    := false;

   if not flexEnabled then
   begin
    //info ('flex not enabled');
    exit;
   end
   else
   begin
    //info ('flex enabled');
   end;

   attribs[ 1].c:= ATTRIBS_01;
   attribs[ 2].c:= ATTRIBS_02;
   attribs[ 3].c:= ATTRIBS_03;
   attribs[ 4].c:= ATTRIBS_04;
   attribs[ 5].c:= ATTRIBS_05;
   attribs[ 6].c:= ATTRIBS_06;
   attribs[ 7].c:= ATTRIBS_07;
   attribs[ 8].c:= ATTRIBS_08;
   attribs[ 9].c:= ATTRIBS_09;
   attribs[10].c:= ATTRIBS_10;
   attribs[11].c:= ATTRIBS_11;
   attribs[12].c:= ATTRIBS_12;
   attribs[13].c:= ATTRIBS_13;
   attribs[14].c:= ATTRIBS_14;
   attribs[15].c:= ATTRIBS_15;
   attribd[ 1].c:= ATTRIBD_01;
   attribd[ 2].c:= ATTRIBD_02;
   attribd[ 3].c:= ATTRIBD_03;
   attribd[ 4].c:= ATTRIBD_04;
   attribd[ 5].c:= ATTRIBD_05;
   attribd[ 6].c:= ATTRIBD_06;
   attribd[ 7].c:= ATTRIBD_07;
   attribd[ 8].c:= ATTRIBD_08;
   attribd[ 9].c:= ATTRIBD_09;
   attribd[10].c:= ATTRIBD_10;
   attribd[11].c:= ATTRIBD_11;
   attribd[12].c:= ATTRIBD_12;
   attribd[13].c:= ATTRIBD_13;
   attribd[14].c:= ATTRIBD_14;
   attribd[15].c:= ATTRIBD_15;
   attribn[ 1].c:= ATTRIBN_01;
   attribn[ 2].c:= ATTRIBN_02;
   attribn[ 3].c:= ATTRIBN_03;
   attribn[ 4].c:= ATTRIBN_04;
   attribn[ 5].c:= ATTRIBN_05;
   attribn[ 6].c:= ATTRIBN_06;
   attribn[ 7].c:= ATTRIBN_07;
   attribn[ 8].c:= ATTRIBN_08;
   attribn[ 9].c:= ATTRIBN_09;
   attribn[10].c:= ATTRIBN_10;
   attribn[11].c:= ATTRIBN_11;
   attribn[12].c:= ATTRIBN_12;
   attribn[13].c:= ATTRIBN_13;
   attribn[14].c:= ATTRIBN_14;
   attribn[15].c:= ATTRIBN_15;

   attribs[ 1].l:=lATTRIBS_01;
   attribs[ 2].l:=lATTRIBS_02;
   attribs[ 3].l:=lATTRIBS_03;
   attribs[ 4].l:=lATTRIBS_04;
   attribs[ 5].l:=lATTRIBS_05;
   attribs[ 6].l:=lATTRIBS_06;
   attribs[ 7].l:=lATTRIBS_07;
   attribs[ 8].l:=lATTRIBS_08;
   attribs[ 9].l:=lATTRIBS_09;
   attribs[10].l:=lATTRIBS_10;
   attribs[11].l:=lATTRIBS_11;
   attribs[12].l:=lATTRIBS_12;
   attribs[13].l:=lATTRIBS_13;
   attribs[14].l:=lATTRIBS_14;
   attribs[15].l:=lATTRIBS_15;
   attribd[ 1].l:=lATTRIBD_01;
   attribd[ 2].l:=lATTRIBD_02;
   attribd[ 3].l:=lATTRIBD_03;
   attribd[ 4].l:=lATTRIBD_04;
   attribd[ 5].l:=lATTRIBD_05;
   attribd[ 6].l:=lATTRIBD_06;
   attribd[ 7].l:=lATTRIBD_07;
   attribd[ 8].l:=lATTRIBD_08;
   attribd[ 9].l:=lATTRIBD_09;
   attribd[10].l:=lATTRIBD_10;
   attribd[11].l:=lATTRIBD_11;
   attribd[12].l:=lATTRIBD_12;
   attribd[13].l:=lATTRIBD_13;
   attribd[14].l:=lATTRIBD_14;
   attribd[15].l:=lATTRIBD_15;
   attribn[ 1].l:=lATTRIBN_01;
   attribn[ 2].l:=lATTRIBN_02;
   attribn[ 3].l:=lATTRIBN_03;
   attribn[ 4].l:=lATTRIBN_04;
   attribn[ 5].l:=lATTRIBN_05;
   attribn[ 6].l:=lATTRIBN_06;
   attribn[ 7].l:=lATTRIBN_07;
   attribn[ 8].l:=lATTRIBN_08;
   attribn[ 9].l:=lATTRIBN_09;
   attribn[10].l:=lATTRIBN_10;
   attribn[11].l:=lATTRIBN_11;
   attribn[12].l:=lATTRIBN_12;
   attribn[13].l:=lATTRIBN_13;
   attribn[14].l:=lATTRIBN_14;
   attribn[15].l:=lATTRIBN_15;

   for t := 1 to maxFlexs do begin
     attribs[ t].cpos.x := attribs[ t].c.Left;
     attribs[ t].cpos.y := attribs[ t].c.Top;
     attribs[ t].lpos.x := attribs[ t].l.Left;
     attribs[ t].lpos.y := attribs[ t].l.Top;
     attribn[ t].cpos.x := attribn[ t].c.Left;
     attribn[ t].cpos.y := attribn[ t].c.Top;
     attribn[ t].lpos.x := attribn[ t].l.Left;
     attribn[ t].lpos.y := attribn[ t].l.Top;
     attribd[ t].cpos.x := attribd[ t].c.Left;
     attribd[ t].cpos.y := attribd[ t].c.Top;
     attribd[ t].lpos.x := attribd[ t].l.Left;
     attribd[ t].lpos.y := attribd[ t].l.Top;
   end;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.flexRefreshFormView;
  var  t : integer;
       q : tadoquery;
  //---------------------------------------
  function lpad(t : integer) : string;
  begin
   if t <=9 then result := '0'+inttostr(t);
   if t > 9 then result := inttostr(t);
  end;
  //---------------------------------------
  procedure setButtonPositions;
  var t : integer;
      maxTop : integer;
  begin
   maxTop := 0;
   for t := 1 to maxFlexs do begin
     if  attribs[ t].c.Visible then maxTop := max( maxTop, attribs[ t].c.Top);
     if  attribn[ t].c.Visible then maxTop := max( maxTop, attribn[ t].c.Top);
     if  attribd[ t].c.Visible then maxTop := max( maxTop, attribd[ t].c.Top);
   end;
   FlexToolbar.Top := maxTop    +26;
   FlexAdd.Top     := maxTop +3 +26;
   FlexMore.Top    := maxTop +3 +26;
  end;
begin
  if flexModified then flexSaveFormView;
  flexSetContextNameInFormView;

  if (not flexEnabled) or (flexContextName = '')
  then begin
    flexPanel.Visible := false;
    exit;
  end;

  for t:= 1 to maxFlexs do begin
    attribs[t].c.Visible := false;
    attribn[t].c.Visible := false;
    attribd[t].c.Visible := false;
    attribs[t].l.Visible := false;
    attribn[t].l.Visible := false;
    attribd[t].l.Visible := false;
  end;

  q := tadoquery.Create(self);
  dmodule.openSQL(q,'select attr_name'      +
                           ',custom_name'        +
                           ',caption'            +
                           ',width'              +
                           ',label_pos_x'        +
                           ',label_pos_y'        +
                           ',field_pos_x'        +
                           ',field_pos_y'        +
                           ',sql_check_message'  +
                           ',sql_check_procedure'+
                           ',sql_default_value'  +
                           ',required '          +
                           ',system_flag '       +
                    'from flex_col_usage where  form_name = :form_name and context_name = :context_name'
                    ,'context_name='+self.flexContextName+';form_name='+self.name);
  q.First;
  if not q.Eof then
  begin
    for t := 1 to maxFlexs do begin
      attribs[t].c.DataField  := 'ATTRIBS_'+lpad(t);
      attribd[t].c.DataField  := 'ATTRIBD_'+lpad(t);
      attribn[t].c.DataField  := 'ATTRIBN_'+lpad(t);
      attribs[t].c.DataSource := source;
      attribd[t].c.DataSource := source;
      attribn[t].c.DataSource := source;
    end;
  end;

  while not q.Eof do begin
    //info ( q.FieldByName('caption').AsString );
    for t:= 1 to maxFlexs do begin
      if attribs[t].c.DataField = q.FieldByName('attr_name').AsString then begin
         attribs[t].c.Visible := true;
         attribs[t].c.Width := q.FieldByName('width').AsInteger;
         attribs[t].l.Visible := true;
         attribs[t].l.Caption := q.FieldByName('caption').AsString;
         attribs[t].c.hint    := iif ( q.FieldByName('sql_check_message').AsString = '','','Warunek poprawnoœci: ' + q.FieldByName('sql_check_message').AsString);

         if q.FieldByName('required').AsString = '+'
           then attribs[t].l.Font.Color := clRed
           else attribs[t].l.Font.Color := clWindowText;
        if q.FieldByName('label_pos_x').AsString <> '' then  attribs[t].l.Left := q.FieldByName('label_pos_x').AsInteger;
        if q.FieldByName('label_pos_y').AsString <> '' then  attribs[t].l.Top  := q.FieldByName('label_pos_y').AsInteger;
        if q.FieldByName('field_pos_x').AsString <> '' then  attribs[t].c.Left := q.FieldByName('field_pos_x').AsInteger;
        if q.FieldByName('field_pos_y').AsString <> '' then  attribs[t].c.Top  := q.FieldByName('field_pos_y').AsInteger;
        attribs[t].sql_check_message   := q.FieldByName('sql_check_message').AsString;
        attribs[t].sql_check_procedure := q.FieldByName('sql_check_procedure').AsString;
        attribs[t].sql_default_value   := q.FieldByName('sql_default_value').AsString;
        attribs[t].required            := q.FieldByName('required').AsString;
        attribs[t].custom_name         := q.FieldByName('custom_name').AsString;
        attribs[t].system_flag         := q.FieldByName('system_flag').AsString;
      end;
    end;
    for t:= 1 to maxFlexs do begin
      if attribn[t].c.DataField = q.FieldByName('attr_name').AsString then begin
         attribn[t].c.Visible := true;
         attribn[t].c.Width := q.FieldByName('width').AsInteger;
         attribn[t].l.Visible := true;
         attribn[t].l.Caption := q.FieldByName('caption').AsString;
         attribn[t].c.hint    := iif ( q.FieldByName('sql_check_message').AsString = '','','Warunek poprawnoœci: ' + q.FieldByName('sql_check_message').AsString);

         if q.FieldByName('required').AsString = '+'
           then attribn[t].l.Font.Color := clRed
           else attribn[t].l.Font.Color := clWindowText;
        if q.FieldByName('label_pos_x').AsString <> '' then  attribn[t].l.Left := q.FieldByName('label_pos_x').AsInteger;
        if q.FieldByName('label_pos_y').AsString <> '' then  attribn[t].l.Top  := q.FieldByName('label_pos_y').AsInteger;
        if q.FieldByName('field_pos_x').AsString <> '' then  attribn[t].c.Left := q.FieldByName('field_pos_x').AsInteger;
        if q.FieldByName('field_pos_y').AsString <> '' then  attribn[t].c.Top  := q.FieldByName('field_pos_y').AsInteger;
        attribn[t].sql_check_message   := q.FieldByName('sql_check_message').AsString;
        attribn[t].sql_check_procedure := q.FieldByName('sql_check_procedure').AsString;
        attribn[t].sql_default_value   := q.FieldByName('sql_default_value').AsString;
        attribn[t].required            := q.FieldByName('required').AsString;
        attribn[t].custom_name         := q.FieldByName('custom_name').AsString;
        attribn[t].system_flag         := q.FieldByName('system_flag').AsString;
      end;
    end;
    for t:= 1 to maxFlexs do begin
      if attribd[t].c.DataField = q.FieldByName('attr_name').AsString then begin
         attribd[t].c.Visible := true;
         attribd[t].c.Width := q.FieldByName('width').AsInteger;
         attribd[t].l.Caption := q.FieldByName('caption').AsString;
         attribd[t].c.hint    := iif ( q.FieldByName('sql_check_message').AsString = '','','Warunek poprawnoœci: ' + q.FieldByName('sql_check_message').AsString);

         attribd[t].l.Visible := true;
         if q.FieldByName('required').AsString = '+'
           then attribd[t].l.Font.Color := clRed
           else attribd[t].l.Font.Color := clWindowText;
        if q.FieldByName('label_pos_x').AsString <> '' then  attribd[t].l.Left := q.FieldByName('label_pos_x').AsInteger;
        if q.FieldByName('label_pos_y').AsString <> '' then  attribd[t].l.Top  := q.FieldByName('label_pos_y').AsInteger;
        if q.FieldByName('field_pos_x').AsString <> '' then  attribd[t].c.Left := q.FieldByName('field_pos_x').AsInteger;
        if q.FieldByName('field_pos_y').AsString <> '' then  attribd[t].c.Top  := q.FieldByName('field_pos_y').AsInteger;
        attribd[t].sql_check_message   := q.FieldByName('sql_check_message').AsString;
        attribd[t].sql_check_procedure := q.FieldByName('sql_check_procedure').AsString;
        attribd[t].sql_default_value   := q.FieldByName('sql_default_value').AsString;
        attribd[t].required            := q.FieldByName('required').AsString;
        attribd[t].custom_name         := q.FieldByName('custom_name').AsString;
        attribd[t].system_flag         := q.FieldByName('system_flag').AsString;
      end;
    end;
    q.Next;
  end;
  q.Free;

  flexPanel.Visible := true;
  flexadd.Visible     := BFlexDesignMode.Down;
  FlexMore.Visible    := BFlexDesignMode.Down;
  FlexToolbar.Visible := BFlexDesignMode.Down;
  if BFlexDesignMode.Down then setButtonPositions;
end;


//------------------------------------------------------------------
procedure TFBrowseParent.flexSaveFormView;
  var  t : integer;
       q : tadoquery;
begin
  q := tadoquery.Create(self);

  for t := 1 to maxFlexs do begin
    dmodule.sql(q, 'update flex_col_usage set label_pos_x=:label_pos_x,label_pos_y=:label_pos_y,field_pos_x=:field_pos_x,field_pos_y=:field_pos_y where form_name = :form_name and context_name = :context_name and attr_name = :attr_name'
    ,'context_name='    + self.flexContextName       +
    ';form_name='       + self.name                  +
    ';attr_name='  + attribn[t].c.DataField     +
    ';field_pos_x='     + inttostr(attribn[t].c.Left)+
    ';field_pos_y='     + inttostr(attribn[t].c.Top) +
    ';label_pos_x='     + inttostr(attribn[t].l.Left)+
    ';label_pos_y='     + inttostr(attribn[t].l.Top)
    );
    dmodule.sql(q, 'update flex_col_usage set label_pos_x=:label_pos_x,label_pos_y=:label_pos_y,field_pos_x=:field_pos_x,field_pos_y=:field_pos_y where form_name = :form_name and context_name = :context_name and attr_name = :attr_name'
    ,'context_name='    + self.flexContextName       +
    ';form_name='       + self.name                  +
    ';attr_name='  + attribs[t].c.DataField     +
    ';field_pos_x='     + inttostr(attribs[t].c.Left)+
    ';field_pos_y='     + inttostr(attribs[t].c.Top) +
    ';label_pos_x='     + inttostr(attribs[t].l.Left)+
    ';label_pos_y='     + inttostr(attribs[t].l.Top)
    );
    dmodule.sql(q, 'update flex_col_usage set label_pos_x=:label_pos_x,label_pos_y=:label_pos_y,field_pos_x=:field_pos_x,field_pos_y=:field_pos_y where form_name = :form_name and context_name = :context_name and attr_name = :attr_name'
    ,'context_name='    + self.flexContextName       +
    ';form_name='       + self.name                  +
    ';attr_name='  + attribd[t].c.DataField     +
    ';field_pos_x='     + inttostr(attribd[t].c.Left)+
    ';field_pos_y='     + inttostr(attribd[t].c.Top) +
    ';label_pos_x='     + inttostr(attribd[t].l.Left)+
    ';label_pos_y='     + inttostr(attribd[t].l.Top)
    );
  end;
  q.Free;
  flexModified := false;
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.editClick;
Begin
 If Not BEdit.Enabled Then Exit;
 If Not CanEditPermission Then Begin
  Warning(Komunikaty.Strings[1]);
  Exit;
 End;

 Execute(AEdit,'');
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.beforeDelete;
Begin
End;


//------------------------------------------------------------------
Procedure TFBrowseParent.deleteClick;
Var t : Integer;
    //aIDs : String;
  //--------------------------
  Procedure DeleteRecord(aID : String);
  Begin
      ID := aID;
      Try BeforeDelete; Except Info(Komunikaty.Strings[26]); End;
      Try
       DModule.SQL('DELETE FROM '+TableName+' WHERE '+KeyField+'='+ID);
       Try AfterDelete; Except Info(Komunikaty.Strings[27]); End;
      Except
       on E:exception do Begin
         errorMessage(ADelete, Self, E.Message);
       End Else SError(Komunikaty.Strings[14]);
      End;
  End;
  //--------------------------
Begin
  id := Query.FieldByName(KeyField).AsString;
  //
  If Not BDelete.Enabled Then Exit;
  If Not CanDelete Then Begin
    Warning(Komunikaty.Strings[3]);
    Exit;
  End;
  If Question(Komunikaty.Strings[8]) = idYes Then Begin
   If Grid.SelectedRows.Count = 0 Then
     Execute(ADelete,'')
   Else Begin
     //aIDs := '';
     For t := 0 To Grid.SelectedRows.Count - 1 Do Begin
      Query.Bookmark := Grid.SelectedRows.Items[t];
      //2013.11.02 execute beforeDelete and afterDelete for each record( Bulk delete is not permitted )
      //If aIDs <> '' Then aIDs :=  aIDs + ',';
      //aIDs := aIDs + Query.FieldByName(KeyField).AsString;
      DeleteRecord( Query.FieldByName(KeyField).AsString );
     End;
     //DModule.SQL('DELETE FROM '+TableName+' WHERE '+KeyField+' IN ('+aIDs+')');
   End;
   BRefreshClick(nil);
  End;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bAddClick(Sender: TObject);
begin
 AddClick;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bEditClick(Sender: TObject);
begin
 EditClick;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bDeleteClick(Sender: TObject);
begin
 deleteClick;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bDeleteAllClick(Sender: TObject);
begin
 DeleteAllClick;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.formResize(Sender: TObject);
Var MaxMinH, MaxMinW, MinH, MinW : Integer;

begin
 BUpdCancel.Left    := UpdPanel.Width - 65*1;
 BUpdOK.Left        := UpdPanel.Width - 65*2;
 BUpdApply.Left     := UpdPanel.Width - 65*3;
 BUpdNew.Left       := UpdPanel.Width - 65*4+33;
 BUpdCopy.Left      := UpdPanel.Width - 65*4;

 BUpdNext.Left      := UpdPanel.Width - 65*5 + 33;
 BUpdPrev.Left      := UpdPanel.Width - 65*5;

 BUpdChild1.Left := UpdPanel.Width - 65*5 - 80*1;
 BUpdChild2.Left := UpdPanel.Width - 65*5 - 80*2;
 BUpdChild3.Left := UpdPanel.Width - 65*5 - 80*3;
 BUpdChild4.Left := UpdPanel.Width - 65*5 - 80*3;
 BUpdChild5.Left := UpdPanel.Width - 65*5 - 80*3;


 MinH := StrToInt(Others.Strings.Values['MIN_HEIGHT']);
 MinW := StrToInt(Others.Strings.Values['MIN_WIDTH']);

 MaxMinH := Max(MinH,MinHeight );
 MaxMinW := Max(MinW,MinWidth);

 If Width  < MaxMinW Then Width  := MaxMinW;
 If Height < MaxMinH Then Height := MaxMinH;

 If Mode = 0 Then Begin
   BClose.Left   := BottomPanel.Width - 80*1;
   BSearch.Left    := BottomPanel.Width - 80*2;
   BDeleteAll.Left := BottomPanel.Width - 80*3;
   BDelete.Left    := BottomPanel.Width - 80*4;
   BAdd.Left       := BottomPanel.Width - 80*5;
   BCopy.Left      := BottomPanel.Width - 80*6;
   BEdit.Left      := BottomPanel.Width - 80*7;
 End Else
 Begin
   BCancel.Left    := BottomPanel.Width - 1*80;
   BSelect.Left    := BottomPanel.Width - 2*80;
   BSearch.Left    := BottomPanel.Width - 80*3;
   BAdd.Left       := BottomPanel.Width - 80*4;
 End;
end;

//------------------------------------------------------------------
 function TFBrowseParent.findFirstVisibleColumn : integer;
 var t : integer;
 begin
   for t := 0 to grid.Columns.Count -1 do
     if Grid.Columns[t].Visible then begin
       result := t;
       exit;
     end;
   result := 0;
 end;

//------------------------------------------------------------------
Procedure TFBrowseParent.findWindow(S : String);
Begin
If UFReadString.ReadString(Grid.Columns[findFirstVisibleColumn].Title.Caption, S, #0) = mrOK Then Begin
  //try
    ESearch.Text := S;
    //Others.Strings.Values['SearchSQL']   := PRE_UPPERCASE + DecodeFieldName(Grid.Columns[findFirstVisibleColumn].FieldName) +POST_UPPERCASE+' LIKE ' + PRE_UPPERCASE + ''''+S+ GetSystemParam('ANY_CHARS')+'''' + POST_UPPERCASE;
    //BRefreshClick(nil);
  //except
  //  Info(Komunikaty.Strings[5]);
  //  ESearch.Text := '';
  //  Others.Strings.Values['SearchSQL']   := '0=0';
  //  BRefreshClick(nil);
  //end;
End;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.formKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If MainPage.ActivePage = Browse Then Begin
   If Key  = HotKeys[1] Then BAddClick(nil) Else
   If Key  = HotKeys[2] Then BEditClick(nil) Else
   If (Key = HotKeys[3]) And (ActiveControl <> ESearch) Then DeleteClick Else
   If (Key = HotKeys[5]) And (ActiveControl <> ESearch) Then BCancelSearchClick(nil) Else
   If Key  = HotKeys[4] Then BFilterClick(nil)
   Else
   If ActiveControl = Grid Then Begin
    If Char(Key) in ['a'..'z', 'A'..'Z','1'..'9','0'] Then Begin
      FindWindow(Char(Key));
    End;
  End;
 End Else Begin //Update
   If Key = 13 Then Begin
     If (Not (ActiveControl is TCustomMemo)) Then BUpdOKClick(nil);
   End;
   If Key = 27 Then BUpdCancelClick(nil);
 End;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.gridDblClick(Sender: TObject);
begin
 If Mode = 0 Then BEditClick(nil)
             Else BSelectClick(nil);
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.setAccessForButtons;
Var F : Boolean;
Begin
 F := Not Query.IsEmpty;

 BAdd.Enabled               := Query.Active;
 PPAdd.Enabled              := Query.Active;
 BEdit.Enabled              := F;
 BCopy.Enabled              := F;
 BDelete.Enabled            := F;
 BDeleteAll.Enabled         := F;
 PPEdit.Enabled             := F;
 PPCopy.Enabled             := F;
 PPDelete.Enabled           := F;
 BSelect.Enabled            := F;
 BSearch.Enabled            := F;
 PPSearch.Enabled           := F;
 BFirst.Enabled             := F;
 BPrev.Enabled              := F;
 BNext.Enabled              := F;
 BLast.Enabled              := F;
 BOleExport.Enabled         := F;
 BCrossCombination.Enabled  := F;
 BCountRecords.Enabled      := F;
 m1.Enabled                 := F;
 m2.Enabled                 := F;
 m3.Enabled                 := F;
 m4.Enabled                 := F;
 m5.Enabled                 := F;
 m6.Enabled                 := F;
End;

//Zmienne wykorzystywane w procedure TFBrowseParent.BRefreshClick(Sender: TObject);
//Umieszczone na zewn¹trz implementacji klasy ze wzglêdu na oszczêdnoœci zasobów
Var ServerStartTime, ClientStartTime, StopTime, ClientTime, ServerTime, TotalTime : TDateTime;
    CT, ST, TT : String;

  Function TFBrowseParent.getOrderByClause : String;
  Var   SortOrder  : ShortString;
        L : Integer;
  Begin
    SortOrder := '';
    For L :=0 To HolderSortOrder.Strings.Count - 1 Do Begin
     If ComboSortOrder.Items[ComboSortOrder.ItemIndex] = ExtractWord(2,HolderSortOrder.Strings[L],['|']) Then Begin
        SortOrder := DecodeFieldName(ExtractWord(1,HolderSortOrder.Strings[L],['|']));
        Break;
     End;
    End;
    Result := SortOrder;
  End;

  procedure TFBrowseParent.flexRefreshListView;
  var t,l : integer;
      attrName, fcaption, fwidth, contextName : string;
  begin
    for t:= 0 to grid.FieldCount-1 do begin
     if copy(grid.Fields[t].FieldName,1,6) = 'ATTRIB' then begin
       grid.columns[t].Visible := false;
     end;
    end;

    for l := 0 to GridLayout.Strings.Count - 1 do
    begin
      //  GridLayout.Strings structure is      : attr_name|caption|width|CATEGORY:context_name
      contextName := extractWord(4, GridLayout.Strings[l],['|']);
      if contextName = 'CATEGORY:'+self.flexContextName then
      begin
        attrName    := extractWord(1, GridLayout.Strings[l],['|']);
        fcaption    := extractWord(2, GridLayout.Strings[l],['|']);
        fwidth      := extractWord(3, GridLayout.Strings[l],['|']);
        for t:= 0 to grid.FieldCount-1 do begin
          if grid.Fields[t].FieldName = attrName then begin
              if isFlex ( Grid.Columns[t].FieldName ) then {do not show hidden columns}
                grid.columns[t].Visible := true;
              grid.columns[t].Title.Caption := fcaption;
              grid.columns[t].Width := strToInt( fwidth );
          end;
        end;
      end;
    end;
    {
    dmodule.openSQL(q, 'select attr_name'             +
                              ',caption'                   +
                              ',width'                     +
                              ',show_in_list'              +
                              ',show_in_order_by'          +
                          ' from flex_col_usage '          +
                          ' where  0=0'                    +
                            ' and  form_name = :form_name '+
                            ' and context_name = :context_name'
                     ,'context_name='+self.flexContextName+';form_name='+self.name);
    q.First;
    while not q.Eof do begin
      for t:= 0 to grid.FieldCount-1 do begin
        if grid.Fields[t].FieldName = q.FieldByName('attr_name').AsString then begin
          if q.FieldByName('show_in_list').AsString='+' then begin
            grid.columns[t].Visible := true;
            grid.columns[t].Title.Caption := q.FieldByName('caption').AsString;
            grid.columns[t].Width := q.FieldByName('width').AsInteger;
          end;
        end;
      end;
      q.Next;
    end;
    q.free;}

  end;

//------------------------------------------------------------------
procedure TFBrowseParent.bRefreshClick(Sender: TObject);
  //----------------------------------
  procedure setWhereClause;
  Var whereClause : String;
  Begin
   Try
     whereClause := ConditionsWhereClause.Strings.Values['SQL.Category:'+flexContextName];

     if whereClause = '' then begin
       initializeFilerSettings ( ConditionsWhereClause.strings, flexContextName ) ;
       whereClause := ConditionsWhereClause.Strings.Values['SQL.Category:'+flexContextName];
     end;

     whereClause := '(' + whereClause;

     {
      //jesli nie ma makra %TOPRECORDS, to wstawiam je. makra moze nie byc, poniewaz pojawilo sie dopiero 2003.01
     try
       Query.MacroByName('TOPRECORDS').AsString :=  ' ';
     Except
       L:=UpperCase(Query.SQL.Text);
       i:=Pos('SELECT ',L);
       Query.SQL.Text := Copy(Query.SQL.Text,1,7)+'%TOPRECORDS '+Copy(Query.SQL.Text,i+7,65000);
       Query.MacroByName('TOPRECORDS').AsString :=  ' ';
     End;
     }

     If dm.DModule.getDBType = 'ORACLE' Then whereClause := whereClause + ' AND ROWNUM <= '+Others.Strings.Values['MaxNumerOfRecordsInGrid']+')'
                                        Else whereClause := whereClause +')';

     If dm.DModule.getDBType = 'Access' Then
       dm.macros.setMacro( Query, 'TOPRECORDS', ' TOP '+Others.Strings.Values['MaxNumerOfRecordsInGrid']+' ')
     else
       dm.macros.setMacro( Query, 'TOPRECORDS', '');


     dm.macros.setMacro( Query, 'CONDITIONALS', whereClause);
     StatusBar.Panels[0].Text:= 'maks. '+Others.Strings.Values['MaxNumerOfRecordsInGrid'];
     EFilter.Text := ConditionsWhereClause.Strings.Values['Notes.Category:'+flexContextName];
     EFilter.Visible := (EFilter.Text<>'-') and (EFilter.Text<>'Wszystkie');
     LAdvancedFilter.Visible := (EFilter.Text<>'-') and (EFilter.Text<>'Wszystkie');
     BFilter.Visible := True;
     if LAdvancedFilter.Visible then
        TopPanel.Height := 81
     else
        TopPanel.Height := 57;

   Except
     EFilter.Visible := False;
     LAdvancedFilter.Visible := False;
     BFilter.Visible := False;
   End;
  End;
  //----------------------------------
  Procedure SetSearch;
  Begin
   dm.macros.setMacro( Query, 'Search', NVL(Others.Strings.Values['SearchSQL'],'0=0'));
  End;

  Procedure ComboSortOrderChange;
  Var   SortOrder  : ShortString;
  Begin
    SortOrder := getOrderByClause;
    If SortOrder = '' Then Warning('Nie znaleziono wartoœci SortOrder') Else SortOrder := 'ORDER BY '+SortOrder;
    Try
     dm.macros.setMacro(Query, 'SortOrder', SortOrder);
    Except
     Query.SQL.Add('%SortOrder');
     dm.macros.setMacro( Query, 'SortOrder', SortOrder);
    End;
  End;
  //-------------------
  Procedure ApplyComboSortOrder;
  Var L : Integer;
  Begin
   // porz¹dek wyœwietlania
   LabelSortOrder.Visible := HolderSortOrder.Strings.Count > 0;
   ComboSortOrder.Visible := HolderSortOrder.Strings.Count > 0;
   ComboSortOrder.Items.Clear;

   If HolderSortOrder.Strings.Count > 0 Then Begin
    For L :=0 To HolderSortOrder.Strings.Count - 1 Do Begin
     // add items from current flex + defaults
     if (ExtractWord(3,HolderSortOrder.Strings[L],['|']) = 'CATEGORY:DEFAULT') or
        (ExtractWord(3,HolderSortOrder.Strings[L],['|']) = 'CATEGORY:'+flexContextName) then
            ComboSortOrder.Items.Add(ExtractWord(2,HolderSortOrder.Strings[L],['|']));
    End;
    ComboSortOrder.ItemIndex := StrToInt(nvl(Others.Strings.Values['ComboSortOrderItemIndex.Category:'+flexContextName],'-1'));
    If ComboSortOrder.ItemIndex = -1 Then ComboSortOrder.ItemIndex := 0;
   End;
  End;
  //-------------------

/////////////////////////////////////////////////
begin
 If Not CanRefresh Then Exit;

 if flexEnabled then begin
   flexSetContextNameInListView;
   GridRelayoutRequired := true;
 end;

 ApplyComboSortOrder;

 Query.Close;
 SetSearch;
 setWhereClause;
 If HolderSortOrder.Strings.Count > 0 Then ComboSortOrderChange
 Else Try dm.macros.setMacro( Query, 'SORTORDER', ''); Except End;

 CustomConditions;
 Try
   ServerStartTime := Now;
   Query.Close;
   Query.Open;

   //it is required query.active before flexRefreshListView
   if flexEnabled then flexRefreshListView;
   //is has to be after flexRefreshListView
   if GridRelayoutRequired then begin
     ApplyGridLayout;
     GridRelayoutRequired := false;
   end;

   ClientStartTime := Now;
   If ExactlyLocate(Query,KeyField,Bookmark,StrToInt(Others.Strings.Values['MaxFetches'])) = False Then
   If Others.Strings.Values['ShowInfoIfMaxFetches']='True' Then Info(Komunikaty.Strings[13]);
   StopTime := Now;
   ClientTime := (StopTime - ClientStartTime) *60*60*24;
   ServerTime := (ClientStartTime - ServerStartTime) *60*60*24;
   TotalTime := (ClientTime + ServerTime);
   Str(ClientTime:1:2,CT);
   Str(ServerTime:1:2,ST);
   Str(TotalTime:1:2,TT);
   StatusBar.Panels[1].Text :=  TT+' ('+ST+'+'+CT+') sek.';
   If TotalTime > 7 Then Begin
    If GetSystemParam('DISPL_KOM001') <> DateToStr(Date) Then Begin

      DModule.InsertIntoEventLog('KON','KOM-001',Application.Title + '.' + Self.Name,TT,'','','','',CurrentUserName);
      Warning(
      'Komunikat KOM-001'+CR+
      'Czas odpowiedzi systemu wynosi '+TT+' [sekundy]. Powoduje to dyskomfort pracy.'+CR+
      'Aby zmniejszyæ czas odpowiedzi systemu nale¿y zmniejszyæ liczbê wyœwietlanych danych:'+CR+
      ' 1) Wywo³aj modu³ filtrowania;'+CR+
      ' 2) U¿yj przycisku Szukaj.'+CR+
      'Je¿eli po zastosowaniu powy¿szych wskazówek czas odpowiedzi systemu bêdzie nadal zbyt d³ugi nale¿y zg³osiæ problem administratorowi w celu identyfikacji problemu'+
      ' (np. nieoptymalna praca serwera, problemy z sieci¹, zbyt wolny komputer, na którym pracujesz).'+CR+''+CR+
      'Je¿eli problem nie zostanie usuniêty, ten komunikat bêdzie wyœwietlany na tym komputerze raz dziennie.');
      SetSystemParam('DISPL_KOM001',DateToStr(Date));
    End;
   End;

 Except
  on E:exception do Begin
    errorMessage(AOpen, Self, E.Message);
    StatusBar.Panels[1].Text := '';
  End Else SError(Komunikaty.Strings[14]);
 End;
 StatusBar.Panels[2].Text :=  '';

 If ActiveControl <> ESearch Then Try
   if (Grid.Visible) and (Grid.Enabled) then
     ActiveControl := Grid;
 Except {Gdy Update} End;
 SetAccessForButtons;
 LFind.Caption := getFindCaption;
end;

function TFBrowseParent.getFindCaption : string;
begin
 result := Grid.Columns[findFirstVisibleColumn].Title.Caption;
end;

procedure TFBrowseParent.bSelectClick(Sender: TObject);
begin
 If Not BSelect.Enabled Then Exit;
 ID := Query.FieldByName(KeyField).AsString;
 MR := mrOK;
 Close;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bCancelClick(Sender: TObject);
begin
 MR := mrCancel;
 Close;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bPrintModuleClick(Sender: TObject);
begin
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.deleteAllClick;
Begin
  If Not BDeleteAll.Enabled Then Exit;
  If Question(Komunikaty.Strings[9]) = idYes Then Begin
    Query.DisableControls;
    Query.Last;

    Query.First;
    While Not Query.EOF Do Begin
     If CanDelete Then Begin
      Execute(ADelete,'');
     End Else Begin
       Warning(Komunikaty.Strings[3]);
       Break;
     End;
    End;
    Query.EnableControls;
    BRefreshClick(nil);
  End;
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.applyGridLayout;
Var L : Integer;
    colNum : integer;
    FieldName, Title,Width : ShortString;
    NK         : Integer;
    Temp       : TColumn;
  //-------------------------
  Function ColNo(FieldName : ShortString) : Integer;
  Var L : Integer;
  Begin
   For L:=0 To Grid.Columns.Count - 1 Do Begin
    If Grid.Columns[L].FieldName = FieldName Then Begin Result := L; Exit; End;
   End;
   Result := -1;
  End;
  //-------------------------
begin
 Temp := Nil;

 colNum := 0;
 For L:=0 To GridLayout.Strings.Count - 1 Do Begin
  if (ExtractWord(4,GridLayout.Strings[L],['|']) = 'CATEGORY:DEFAULT')
     or
     (ExtractWord(4,GridLayout.Strings[L],['|']) = 'CATEGORY:'+flexContextName)
  then
  begin
   FieldName   := ExtractWord(1,GridLayout.Strings[L],['|']);
   Title       := ExtractWord(2,GridLayout.Strings[L],['|']);
   Width       := ExtractWord(3,GridLayout.Strings[L],['|']);

   NK := ColNo(FieldName);
   If NK = -1 Then Begin
    Warning('Nie ma pola FIELDNAME='+FieldName);
    Exit;
   End;

   Try
    StrToInt(Width);
   Except
    Warning('Szerokoœæ pola musi byæ liczb¹. FIELDNAME='+FieldName);
    Exit;
   End;

   Grid.Columns[NK].Title.Caption := Title;
   Grid.Columns[NK].Width := StrToInt(Width);

   If colNum <> NK Then Begin
    If Temp = Nil Then Temp := TColumn.Create(nil);
    Temp.Assign(Grid.Columns[colNum]);
    Grid.Columns[colNum].Assign(Grid.Columns[NK]);
    Grid.Columns[NK].Assign(Temp);
   end;
   inc ( colNum );
  end;
 end;

 If Temp <> Nil Then Temp.Free;
end;


//------------------------------------------------------------------
procedure TFBrowseParent.updateStaticLayout;
Begin
 If Others.Strings.Values['FormCaption'] = '' Then Others.Strings.Values['FormCaption'] := Self.Caption
 Else Self.Caption := Others.Strings.Values['FormCaption'];

 If Not SingleMode Then Begin
  PPEdit.Caption   := BEdit.Caption;
  PPAdd.Caption    := BAdd.Caption;
  PPCopy.Caption   := BCopy.Caption;
  PPdelete.Caption := BDelete.Caption;
  PPSelect.Caption := BSelect.Caption;
  PPCancel.Caption := BCancel.Caption;
  PPSearch.Caption := BSearch.Caption;
  M1.Caption       := BFilter.Hint;
 End;
 GridRelayoutRequired := true;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bConfigureClick(Sender: TObject);
begin
 If not CanConfigure Then Begin
  Warning(Komunikaty.Strings[4]);
  Exit;
 End;

 UFModuleConfigure.Create ( flexContextName );
 If Sender = Grid Then FModuleConfigure.Page.ActivePage := FModuleConfigure.TabLista;

 With FModuleConfigure Do Begin
  SQL.Lines.Add(Query.SQL.Text);
  FormCaption.Text           := Self.Others.Strings.Values['FormCaption'];
  GridHint.Text              := Self.Grid.Hint;
  EdytujE.Text               := Self.BEdit.Caption;
  DodajE.Text                := Self.BAdd.Caption;
  KopiujE.Text               := Self.BCopy.Caption;
  UsunE.Text                 := Self.BDelete.Caption;
  UsunAllE.Text              := Self.BDeleteAll.Caption;
  ZamknijE.Text              := Self.BClose.Caption;
  SzukajE.Text               := Self.BSearch.Caption;
  WybierzE.Text              := Self.BSelect.Caption;
  AnulujE.Text               := Self.BCancel.Caption;
  EdytujHint.Text            := Self.BEdit.Hint;
  DodajHint.Text             := Self.BAdd.Hint;
  KopiujHint.Text            := Self.BCopy.Hint;
  UsunHint.Text              := Self.BDelete.Hint;
  UsunAllHint.Text           := Self.BDeleteAll.Hint;
  ZamknijHint.Text           := Self.BClose.Hint;
  SzukajHint.Text            := Self.BSearch.Hint;
  WybierzHint.Text           := Self.BSelect.Hint;
  AnulujHint.Text            := Self.BCancel.Hint;
  TFirst.Text                := Self.BFirst.Hint;
  TPrev.Text                 := Self.BPrev.Hint;
  TNext.Text                 := Self.BNext.Hint;
  TLast.Text                 := Self.BLast.Hint;
  Odswiez.Text               := Self.BRefresh.Hint;
  Configure.Text             := Self.BConfigure.Hint;
  EUpraw.Text                := Self.Upraw.Hint;
  EFiltr.Text                := Self.BFilter.Hint;
  EOleExport.Text            := Self.BOleExport.Hint;
  ECrossCombination.Text     := Self.BCrossCombination.Hint;
  LPrzyklad.Font.Assign(Self.Grid.Font);
  GridLayout.Lines.Assign(Self.GridLayout.Strings);
  SortOrder.Lines.Assign(Self.HolderSortOrder.Strings);
  BrakUprawnien.Lines.Assign(Self.Komunikaty.Strings);
  Others.Lines.Assign(Self.Others.Strings);
  AvailColumnsWhereClause.Lines.Assign(Self.AvailColumnsWhereClause.Strings);
  LLKryterium.Text := LKryterium.Caption;
  HKFiltrowanie.HotKey := StrToInt(Self.Others.Strings.Values['ChangeFilterHotKey']);

  //HKDodaj.HotKey  := StrToInt(Others.Strings.Values['InsertHotKey']);
  //HKEdytuj.HotKey := StrToInt(Others.Strings.Values['EditHotKey']);
  //HKUsun.HotKey   := StrToInt(Others.Strings.Values['DeleteHotKey']);

 If ShowModal = mrOK Then Begin
  Self.Others.Strings.Assign(Others.Lines);
  Self.Others.Strings.Values['FormCaption'] := FormCaption.Text;
  Self.Others.Strings.Values['ChangeFilterHotKey'] := IntToStr(HKFiltrowanie.HotKey);
  Self.Grid.Hint                  := GridHint.Text;
  Self.BEdit.Caption              := EdytujE.Text;
  Self.BAdd.Caption               := DodajE.Text;
  Self.BCopy.Caption              := KopiujE.Text;
  Self.BDelete.Caption            := UsunE.Text;
  Self.BDeleteAll.Caption         := UsunAllE.Text;
  Self.BClose.Caption             := ZamknijE.Text;
  Self.BSearch.Caption            := SzukajE.Text;
  Self.BSelect.Caption            := WybierzE.Text;
  Self.BCancel.Caption            := AnulujE.Text;
  Self.BEdit.Hint                 := EdytujHint.Text;
  Self.BAdd.Hint                  := DodajHint.Text;
  Self.BCopy.Hint                 := KopiujHint.Text;
  Self.BDelete.Hint               := UsunHint.Text;
  Self.BDeleteAll.Hint            := UsunAllHint.Text;
  Self.BClose.Hint                := ZamknijHint.Text;
  Self.BSearch.Hint               := SzukajHint.Text;
  Self.BSelect.Hint               := WybierzHint.Text;
  Self.BCancel.Hint               := AnulujHint.Text;
  Self.BFirst.Hint                := TFirst.Text;
  Self.BPrev.Hint                 := TPrev.Text;
  Self.BNext.Hint                 := TNext.Text;
  Self.BLast.Hint                 := TLast.Text;
  Self.BFilter.Hint               := EFiltr.Text;
  Self.BOleExport.Hint            := EOleExport.Text;
  Self.BCrossCombination.Hint     := ECrossCombination.Text;

  Self.BRefresh.Hint              := Odswiez.Text;
  Self.BConfigure.Hint            := Configure.Text;
  Self.Upraw.Hint                 := EUpraw.Text;

  Self.Grid.Font.Assign(LPrzyklad.Font);
  Self.GridLayout.Strings.Assign(GridLayout.Lines);
  Self.HolderSortOrder.Strings.Assign(SortOrder.Lines);
  Self.Komunikaty.Strings.Assign(BrakUprawnien.Lines);
  Self.AvailColumnsWhereClause.Strings.Assign(AvailColumnsWhereClause.Lines);
  LKryterium.Caption := LLKryterium.Text;
  flexSynchronize;

  ConditionsWhereClause.Strings.Clear;
  ApplyGridLayout;
  UpdateStaticLayout;
  BRefreshClick(nil);
  RefreshHotKeys;
 End;
 End;

 UFModuleConfigure.Free;
end;


//------------------------------------------------------------------
procedure TFBrowseParent.formActivate(Sender: TObject);
begin
 If Mode = 1 Then If Trim(ID)<>'' Then
  If ExactlyLocate(Query,KeyField,ID,StrToInt(Others.Strings.Values['MaxFetches'])) = False Then
   If Others.Strings.Values['ShowInfoIfMaxFetches']='True' Then Info(Komunikaty.Strings[13]);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.uprawClick(Sender: TObject);
begin
 BConfigure.Visible := ((Not Upraw.Down) Or  CanConfigure);

 If Mode = 0 Then Begin
   BClose.Visible    := True;
   BDelete.Visible   := True And ((Not Upraw.Down) Or CanDelete);
   BDeleteAll.Visible:= True And ((Not Upraw.Down) Or CanDelete);
   BAdd.Visible      := True And ((Not Upraw.Down) Or CanInsert);
   BCopy.Visible     := True And ((Not Upraw.Down) Or CanInsert);
   BEdit.Visible     := True And ((Not Upraw.Down) Or CanEditPermission);
   BCancel.Visible   := False;
   BSelect.Visible   := False;
   PPSelect.Visible  := False;
   PPCancel.Visible  := False;
   N1.Visible        := False;
 End Else
 Begin
   BClose.Visible    := False;
   BDelete.Visible   := False;
   BDeleteAll.Visible:= False;
   BAdd.Visible      := True;
   BCopy.Visible     := False;
   BEdit.Visible     := False;
   BCancel.Visible   := True;
   BSelect.Visible   := True;
   PPSelect.Visible  := True;
   PPCancel.Visible  := True;
   N1.Visible        := True;
 End;
end;


//------------------------------------------------------------------
procedure TFBrowseParent.flexDefaultValues;
var t : integer;
begin
 for t := 1 to maxFlexs do begin
   if fieldName = '' then begin
     if  attribs[ t].c.Visible                                        then if attribs[ t].sql_default_value <>'' then Query[attribs[ t].c.name] := DModule.SingleValue( attribs[ t].sql_default_value );
     if  attribn[ t].c.Visible                                        then if attribn[ t].sql_default_value <>'' then Query[attribn[ t].c.name] := DModule.SingleValue( attribn[ t].sql_default_value );
     if  attribd[ t].c.Visible                                        then if attribd[ t].sql_default_value <>'' then Query[attribd[ t].c.name] := DModule.SingleValue( attribd[ t].sql_default_value );
   end else begin
     if  (attribs[ t].c.Visible) and (fieldName = attribs[ t].c.name) then if attribs[ t].sql_default_value <>'' then Query[attribs[ t].c.name] := DModule.SingleValue( attribs[ t].sql_default_value );
     if  (attribn[ t].c.Visible) and (fieldName = attribn[ t].c.name) then if attribn[ t].sql_default_value <>'' then Query[attribn[ t].c.name] := DModule.SingleValue( attribn[ t].sql_default_value );
     if  (attribd[ t].c.Visible) and (fieldName = attribd[ t].c.name) then if attribd[ t].sql_default_value <>'' then Query[attribd[ t].c.name] := DModule.SingleValue( attribd[ t].sql_default_value );
   end;
 end;
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.defaultValues;
Begin
 if flexEnabled then flexDefaultValues;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.flexSynchronize;
var q : tadoquery;
    lineToAdd : string;
    flexChanges : boolean;
    currentAttributeList : record
                            cnt : integer;
                            d : array of record
                                     attrName : string[30];
                                     contextName : string[255];
                                    end;
                           end;
  //--------------------------------------
  procedure FlexUpdateCaption ( s : tstrings;
                                fieldNamePos: integer;   categoryNamePos: integer;   captionPos  : integer;
                                fieldName   : string;    categoryName   : string;    captionName : string   );
  var t : integer;
      l : integer;
      tmpStr : string;
  begin

  for t := 0 to S.count - 1 do begin
   if (extractWord(fieldNamePos,s[t],['|']) = fieldName) and (extractWord(categoryNamePos,s[t],['|']) = categoryName) then begin
     //replace captionPos-th token
     tmpStr := '';
     for l := 1 to wordCount(s[t],['|']) do
     begin
      if l <> captionPos then
        tmpStr := merge(tmpStr, extractWord(l,s[t],['|']),'|')
      else
        tmpStr := merge(tmpStr, captionName ,'|');
     end;
     if (s[t] <> tmpStr) then begin
       s[t] := tmpStr;
       flexChanges := true;
     End;
     //info('flexChanges: UPDATE:'+fieldName+'.'+categoryName );
     exit;
   end;
  end;
  end;
  //--------------------------------------
    function getFlexType (attrName : string ) : string;
    begin
     if subStr(upperCase( attrName ),1,7) = 'ATTRIBS' then begin result := 'ftString';  exit; end;
     if subStr(upperCase( attrName ),1,7) = 'ATTRIBD' then begin result := 'ftDate';    exit; end;
     if subStr(upperCase( attrName ),1,7) = 'ATTRIBN' then begin result := 'ftInteger'; exit; end;
     result := 'ftOther';
    end;
  //--------------------------------------
  function FlexIsAdded ( s : tstrings; fieldNamePos: integer; categoryNamePos: integer; fieldName : string; categoryName : string ) : boolean;
  var t : integer;
  begin
  result := false;
  for t := 0 to S.count - 1 do
   if (extractWord(fieldNamePos,s[t],['|']) = fieldName) and (extractWord(categoryNamePos,s[t],['|']) = categoryName) then begin
     result := true;
     exit;
   end;
  end;
  //--------------------------------------
  function flexExists ( fieldNamePos: integer;   categoryNamePos: integer; str : string) : boolean;
  var t : integer;
      contextName , attrName : string;
  begin
    attrName     := extractWord(fieldNamePos   ,str,['|']);
    contextName  := extractWord(categoryNamePos,str,['|']);
    for t := 0 to currentAttributeList.cnt - 1 do
    begin
     if ('CATEGORY:'+currentAttributeList.d[t].contextName = contextName)
        and
        (
          (currentAttributeList.d[t].attrName = attrName)
          or
          (DecodeFieldName(currentAttributeList.d[t].attrName) = attrName)
        )
     then begin
      result := true;
      exit;
     end;
     result := false;
    end;
  end;
  //--------------------------------------
  procedure deleteObsoleteFlex ( s: tstrings; attrNamePos, contextNamePos : integer );
  var t : integer;
  begin
    for t := 0 to S.count - 1 do begin
     if isFlex( extractWord(attrNamePos, s[t], ['|']) ) then
     if not flexExists(attrNamePos, contextNamePos, S[t]) then begin
       flexChanges := true;
       //info('flexChanges: DELETE ' + s[t]);
       S.Delete(t);
       exit;
     end;
    end;
  end;
  //--------------------------------------
begin
  AvailColumnsWhereClause.Sorted := false; //avoids error in FlexUpdateCaption procedure
  CreateAvailColumnsWhereClause(AvailColumnsWhereClause.Strings);
  flexChanges := false;
  q := tadoquery.Create(self);
  currentAttributeList.cnt := 0;
  setLength(currentAttributeList.d,0);
  //all contexts
  dmodule.openSQL(q, 'select attr_name'                  +
                            ',caption'                   +
                            ',width'                     +
                            ',show_in_list'              +
                            ',show_in_order_by'          +
                            ',show_in_where'             +
                            ',context_name'              +
                        ' from flex_col_usage '          +
                        ' where  0=0'                    +
                          ' and  form_name = :form_name '
                   ,'form_name='+self.name);
  q.First;
  while not q.Eof do begin
    //update flex captions
    //  GridLayout.Strings structure is      : attr_name|caption|width|CATEGORY:context_name
    //  HolderSortOrder.strings structure is : attr_name|caption|CATEGORY:context_name
    //  AvailColumnsWhereClause.Strings is   : caption|attr_name|fieldType|CATEGORY:context_name
    FlexUpdateCaption( GridLayout.Strings             ,1,4,2, q.FieldByName('attr_name').AsString , 'CATEGORY:'+q.FieldByName('context_name').AsString, q.FieldByName('caption').AsString  );
    FlexUpdateCaption( HolderSortOrder.strings        ,1,3,2, q.FieldByName('attr_name').AsString , 'CATEGORY:'+q.FieldByName('context_name').AsString, q.FieldByName('caption').AsString  );
    FlexUpdateCaption( AvailColumnsWhereClause.Strings,2,4,1, q.FieldByName('attr_name').AsString , 'CATEGORY:'+q.FieldByName('context_name').AsString, q.FieldByName('caption').AsString  );
    //insert lack flexes
    if q.FieldByName('show_in_list').AsString='+' then begin
      if not FlexIsAdded(GridLayout.Strings, 1, 4, q.FieldByName('attr_name').AsString, 'CATEGORY:'+q.FieldByName('context_name').AsString) then begin
        lineToAdd := q.FieldByName('attr_name').AsString + '|' +
                     q.FieldByName('caption').AsString   + '|' +
                     q.FieldByName('width').AsString     + '|' +
                    'CATEGORY:'+q.FieldByName('context_name').AsString;
        GridLayout.Strings.Add( lineToAdd );
        flexChanges := true;
        //info('flexChanges: INSERT.select ' + lineToAdd);
      end;
    end;
    if q.FieldByName('show_in_order_by').AsString='+' then begin
      if not FlexIsAdded(HolderSortOrder.Strings, 1, 3, q.FieldByName('attr_name').AsString, 'CATEGORY:'+q.FieldByName('context_name').AsString) then begin
        lineToAdd := q.FieldByName('attr_name').AsString + '|' + q.FieldByName('caption').AsString + '|CATEGORY:'+q.FieldByName('context_name').AsString;
        HolderSortOrder.Strings.Add( lineToAdd );
        flexChanges := true;
        //info('flexChanges: INSERT.order ' + lineToAdd);
      end;
    end;
    if q.FieldByName('show_in_where').AsString='+' then begin
      if not FlexIsAdded(AvailColumnsWhereClause.Strings, 2, 4, DecodeFieldName(q.FieldByName('attr_name').AsString), 'CATEGORY:'+q.FieldByName('context_name').AsString) then begin
        lineToAdd  :=
                 q.FieldByName('caption').AsString+'|'+
                 DecodeFieldName(q.FieldByName('attr_name').AsString) +'|'+
                 getFlexType( q.FieldByName('attr_name').AsString ) +
                 '|CATEGORY:' + q.FieldByName('context_name').AsString;
        AvailColumnsWhereClause.Strings.Add( LineToAdd );
        flexChanges := true;
        //info('flexChanges: INSERT.where ' + lineToAdd);
      end;
    end;
    currentAttributeList.cnt := currentAttributeList.cnt + 1;
    setLength(currentAttributeList.d,currentAttributeList.cnt);
    currentAttributeList.d[currentAttributeList.cnt-1].attrName    := q.FieldByName('attr_name').AsString;
    currentAttributeList.d[currentAttributeList.cnt-1].contextName := q.FieldByName('context_name').AsString;
    q.Next;
  end;
  q.free;

  AvailColumnsWhereClause.Sorted := true;

  //delete not used flexes
  deleteObsoleteFlex( GridLayout.Strings             ,1,4);
  deleteObsoleteFlex( HolderSortOrder.strings        ,1,3);
  deleteObsoleteFlex( AvailColumnsWhereClause.Strings,2,4);

  if flexChanges then begin
    //reset flex dependent settings
    Others.Strings.Values['OLEEXPORTCOLUMNS.Category:'+flexContextName] := '';
    ConditionsWhereClause.Strings.Clear;
  end;
end;


Procedure TFBrowseParent.CreateGridLayout;
Var L : Integer;
begin
 If GridLayout.Strings.Count = 0 Then
 For L:=0 To Grid.Columns.Count - 1 Do Begin
    if not isFlex ( Grid.Columns[L].FieldName ) then
      GridLayout.Strings.Add(
        Grid.Columns[L].FieldName + '|' +
        Grid.Columns[L].Title.Caption + '|' +
        IntToStr(Grid.Columns[L].Width) +
        '|CATEGORY:DEFAULT' );
 End;
end;


//------------------------------------------------------------------
procedure TFBrowseParent.formCreate(Sender: TObject);
  //-------------------------
  Function GetFirstControl : TWinControl;
  Var T : Integer;
  Begin
     Result := Nil;
     For t := 0 To Update.ControlCount - 1 Do
      If (Update.Controls[t] is TWinControl) Then
       If TWinControl(Update.Controls[t]).TabOrder = 0 Then Begin
         Result := TWinControl(Update.Controls[t]);
         Break;
       End;
     not_updatable_columns.C := -1;
     not_updatable_labels.C := -1;
  End;
  //-------------------------
  Procedure OpenLookups;
  Var T : Integer;
  Begin
     For t := 0 To Self.ComponentCount - 1 Do
      If (Self.Components[t] is TADOQuery) Then
       If Self.Components[t].Name <> 'Query' Then (Self.Components[t] As TADOQuery).Open;
  End;
  //-------------------------
  //adds standard sort orders, compare with FlexCreateSortOrder;
  Procedure CreateSortOrder;
  Var L : Integer;
  begin
   inherited;
   If HolderSortOrder.Strings.Count = 0 Then
     For L:=0 To Grid.Columns.Count - 1 Do Begin
      if not isFlex ( Grid.Columns[L].FieldName )
        then HolderSortOrder.Strings.Add( Grid.Columns[L].FieldName + '|' + Grid.Columns[L].Title.Caption + '|CATEGORY:DEFAULT' );
     End
   else
     // to be compatible with prior version
     for L := 0 to HolderSortOrder.Strings.Count - 1 do
       if wordCount( HolderSortOrder.Strings[L] , ['|'] ) = 2 then begin
         HolderSortOrder.Strings[L] := HolderSortOrder.Strings[L] + '|CATEGORY:DEFAULT';
       end;
  end;


Var GRID_FONT_PITCH : ShortString;
    GRID_FONT_STYLE : Integer;
begin
 flexInitialize;
 CanRefresh := False;
 SearchCounter  := 0;
 inherited;
 BookMark := '';
 PRE_UPPERCASE    := GetSystemParam('PRE_UPPERCASE');
 POST_UPPERCASE   := GetSystemParam('POST_UPPERCASE');
 //Zczytanie minimalnych rozmiarów okna przy pierwszym uruchomieniu
 If StrToInt(Others.Strings.Values['MIN_HEIGHT']) = -1 Then Others.Strings.Values['MIN_HEIGHT'] := IntToStr(Height);
 If StrToInt(Others.Strings.Values['MIN_WIDTH']) = -1 Then Others.Strings.Values['MIN_WIDTH'] := IntToStr(Width);
 If StrToInt(Others.Strings.Values['LEFT']) = -1 Then Others.Strings.Values['LEFT'] := IntToStr(Left);
 If StrToInt(Others.Strings.Values['TOP']) = -1 Then Others.Strings.Values['TOP'] := IntToStr(Top);

 If Others.Strings.Values['UprawDown'] = 'True' Then Upraw.Down := True
                                                Else Upraw.Down := False;
 If Others.Strings.Values['PanelDown'] = 'True' Then ShowPanel.Down := True
                                                Else ShowPanel.Down := False;
 If Others.Strings.Values['SecondRatePanelDown'] = 'True' Then BShowChildsPanel.Down := True
                                                          Else BShowChildsPanel.Down := False;
 Grid.Font.Charset := StrToInt(Others.Strings.Values['GRID_FONT_CHARSET']);
 Grid.Font.Color   := StrToInt(Others.Strings.Values['GRID_FONT_COLOR']);
 Grid.Font.Height  := StrToInt(Others.Strings.Values['GRID_FONT_HEIGHT']);
 Grid.Font.Name    := Others.Strings.Values['GRID_FONT_NAME'];
 GRID_FONT_PITCH := Others.Strings.Values['GRID_FONT_PITCH'];
 If  GRID_FONT_PITCH = 'fpDefault' Then Grid.Font.Pitch := fpDefault Else
  If  GRID_FONT_PITCH = 'fpVariable' Then Grid.Font.Pitch := fpVariable Else
    Grid.Font.Pitch := fpFixed;
 Grid.Font.Size  := StrToInt(Others.Strings.Values['GRID_FONT_SIZE']);

 GRID_FONT_STYLE := StrToInt(Others.Strings.Values['GRID_FONT_STYLE']);

 If (GRID_FONT_STYLE AND 1) = 1 Then Grid.Font.Style := Grid.Font.Style + [fsBold];
 If (GRID_FONT_STYLE AND 2) = 2 Then Grid.Font.Style := Grid.Font.Style + [fsItalic];
 If (GRID_FONT_STYLE AND 4) = 4 Then Grid.Font.Style := Grid.Font.Style + [fsUnderline];
 If (GRID_FONT_STYLE AND 8) = 8 Then Grid.Font.Style := Grid.Font.Style + [fsStrikeOut];

 CreateSortOrder;
 CreateGridLayout;
 KeyField := Others.Strings.Values['KEYFIELD'];
 GetTableName;

 If Query.Active   Then Info('Query nie powinno byæ aktywne !');

 OpenLookups;

 CanRefresh := True;
 UpdateStaticLayout;

 UprawClick(nil);
 ShowPanelClick(nil);
 RefreshHotKeys;

 FirstControl := GetFirstControl;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bFirstClick(Sender: TObject);
begin Query.First; end;

//------------------------------------------------------------------
procedure TFBrowseParent.bPrevClick(Sender: TObject);
begin Query.Prior; end;

//------------------------------------------------------------------
procedure TFBrowseParent.bNextClick(Sender: TObject);
begin Query.Next; end;

//------------------------------------------------------------------
procedure TFBrowseParent.bLastClick(Sender: TObject);
begin Query.Last; end;

//------------------------------------------------------------------
procedure TFBrowseParent.comboSortOrderChange(Sender: TObject);
begin
 If ComboSortOrder.ItemIndex <> -1 Then Others.Strings.Values['ComboSortOrderItemIndex.Category:'+flexContextName] := IntToStr(ComboSortOrder.ItemIndex);
 BRefreshClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bSearchClick(Sender: TObject);
begin
  inherited;
  ActiveControl := Grid;
  FindWindow('');
end;

//------------------------------------------------------------------
procedure TFBrowseParent.pPSearchClick(Sender: TObject);
begin
  inherited;
  BSearchClick(nil);
end;


//------------------------------------------------------------------
Procedure TFBrowseParent.showModalAsBrowser(Filter : String);
var t, t2: integer;
Begin
 if not strIsEmpty(filter) then ESearch.Text := '';
 If Not DModule.ADOConnection.Connected Then Begin
  SError(Komunikaty.Strings[15]);
  Exit;
 End;
 If Not CanShow Then Begin
  Warning(Komunikaty.Strings[0]);
  Exit;
 End;
 If Visible Then Begin
  Info(Komunikaty.Strings[23]);
  Exit;
 End;

 if flexEnabled then flexSynchronize;

 //Grid.Options := Grid.Options + [dgMultiSelect];
 Grid.Options := Grid.Options + [dgIndicator];

 Browse.TabVisible   := True;
 Update.TabVisible   := Not Browse.TabVisible;
 MainPage.ActivePage := Browse;
 Browse.Caption      := Komunikaty.Strings[16];

 SingleMode := False;
 Mode := 0; //=browser

 If Filter <> '' Then Begin
   ConditionsWhereClause.Strings.Text := Filter;
   initializeFilerSettings ( ConditionsWhereClause.strings, flexContextName );

   If ConditionsWhereClause.Strings.Values['SQL.Category:'+flexContextName] = '0=0' Then Begin

     // if user set column names instead of coumn index, correct it
     for t2 := 0 to ConditionsWhereClause.Strings.Count - 1 Do Begin
      try
        StrToInt(ExtractWord(1,ConditionsWhereClause.Strings[t2],['|']));
        // if index then do nothing ...
      except
        // ... else convert text to index
         for t  := 0 to AvailColumnsWhereClause.Strings.Count -1 Do Begin
          If  ExtractWord(1,ConditionsWhereClause.Strings[t2],['|']) = ExtractWord(2,AvailColumnsWhereClause.Strings[t],['|']) then
            ConditionsWhereClause.Strings[t2] :=
                   inttostr(t) + '|' +
                   ExtractWord(2,ConditionsWhereClause.Strings[t2],['|']) + '|' +
                   ExtractWord(3,ConditionsWhereClause.Strings[t2],['|']) + '|' +
                   ExtractWord(4,ConditionsWhereClause.Strings[t2],['|']) + '|' +
                   ExtractWord(5,ConditionsWhereClause.Strings[t2],['|']) + '|' +
                   ExtractWord(6,ConditionsWhereClause.Strings[t2],['|']) + '|' +
                   ExtractWord(7,ConditionsWhereClause.Strings[t2],['|']);
                   // just in case I added 7 values (5 is enough)
         end;
      end;
     End;

     //function sets SQL i NOTES parameters
     UFModuleFilter.GetSQLAndNotes(ConditionsWhereClause.Strings, AvailColumnsWhereClause.Strings, flexContextName);
   End;
 End;

 BRefreshClick(nil);
 ShowModal;

 //Grid.Options := Grid.Options - [dgMultiSelect];
 Grid.Options := Grid.Options - [dgIndicator];

 // to aviod "Nie mo¿na zmieniæ w³aœciwoœci ActiveConnection obiektu Recordset, którego Ÿród³em jest obiekt Command"
 // error occured during closing aplication
 Query.Close;
End;

//------------------------------------------------------------------
Function TFBrowseParent.showModalAsSelect(Var aID : ShortString) : TModalResult;
Begin
 If Not DModule.ADOConnection.Connected Then Begin
  SError(Komunikaty.Strings[15]);
  result := mrCancel;
  Exit;
 End;

 If Not CanShow Then Begin
  Warning(Komunikaty.Strings[0]);
  result := mrCancel;
  Exit;
 End;

 If Visible Then Begin
  Info(Komunikaty.Strings[23]);
  Result := mrCancel;
  Exit;
 End;

 if flexEnabled then flexSynchronize;

 Browse.TabVisible   := True;
 Update.TabVisible   := Not Browse.TabVisible;
 MainPage.ActivePage := Browse;
 Browse.Caption      := Komunikaty.Strings[17];

 SingleMode := False;
 Mode := 1; //=select
 ID := aID;
 BRefreshClick(nil);

 MR := mrCancel;
 ShowModal;

 Result := MR;
 aID := ID;

 // to aviod "Nie mo¿na zmieniæ w³aœciwoœci ActiveConnection obiektu Recordset, którego Ÿród³em jest obiekt Command"
 // error occured during closing aplication
 Query.Close;
End;

//------------------------------------------------------------------
Function TFBrowseParent.showModalAsMultiSelect(Var aIDs : String) : TModalResult;
Var t : Integer;
Begin
 If Not DModule.ADOConnection.Connected Then Begin
  SError(Komunikaty.Strings[15]);
  result := mrCancel;
  Exit;
 End;

 If Not CanShow Then Begin
  Warning(Komunikaty.Strings[0]);
  result := mrCancel;
  Exit;
 End;

 If Visible Then Begin
  Info(Komunikaty.Strings[23]);
  Result := mrCancel;
  Exit;
 End;

 if flexEnabled then flexSynchronize;

 Browse.TabVisible   := True;
 Update.TabVisible   := Not Browse.TabVisible;
 MainPage.ActivePage := Browse;
 Browse.Caption      := Komunikaty.Strings[28];

 SingleMode := False;
 Mode := 1; //=select
 ID := '';
 BRefreshClick(nil);
 Grid.Options := Grid.Options + [dgMultiSelect];
 Grid.Options := Grid.Options + [dgIndicator];
 MR := mrCancel;
 ShowModal;

 if Grid.SelectedRows.Count = 0
  then aIDs := ID;

 For t := 0 To Grid.SelectedRows.Count - 1 Do Begin
  Query.Bookmark := Grid.SelectedRows.Items[t];
  If aIDs <> '' Then aIDs :=  aIDs + ',';
  aIDs := aIDs + Query.FieldByName(KeyField).AsString;
 End;

 Grid.Options := Grid.Options - [dgMultiSelect];
 Grid.Options := Grid.Options - [dgIndicator];
 Result := MR;

 // to aviod "Nie mo¿na zmieniæ w³aœciwoœci ActiveConnection obiektu Recordset, którego Ÿród³em jest obiekt Command"
 // error occured during closing aplication
 dmodule.resetConnection ( Query ); 
End;

//------------------------------------------------------------------
Function TFBrowseParent.showModalAsSingleRecord(Action : Integer; Var ID : ShortString) : TModalResult;
Begin
 SingleMode := True;
 // to aviod "obiect was open"
 dmodule.resetConnection(Query);
 flexRefreshFormView;
 Execute(Action, id);

 // to aviod "Nie mo¿na zmieniæ w³aœciwoœci ActiveConnection obiektu Recordset, którego Ÿród³em jest obiekt Command"
 // error occured on close aplication
 dmodule.resetConnection(Query);
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bCopyClick(Sender: TObject);
begin
  inherited;
 CopyClick;
end;

Procedure TFBrowseParent.copyClick;
Begin
  If Not CanInsert Then Begin
  Warning(Komunikaty.Strings[2]);
  Exit;
 End;
 Execute(ACopy,'');
End;

//------------------------------------------------------------------
procedure TFBrowseParent.formShow(Sender: TObject);
begin
 inherited;
 PPChild1.Visible := BUpdChild1.Visible;
 PPChild2.Visible := BUpdChild2.Visible;
 PPChild3.Visible := BUpdChild3.Visible;
 PPChild4.Visible := BUpdChild4.Visible;
 PPChild5.Visible := BUpdChild5.Visible;

 N3.Visible := PPChild1.Visible Or PPChild2.Visible Or PPChild3.Visible Or PPChild4.Visible Or PPChild5.Visible;

 PPChild1.Caption := Komunikaty.Strings[29] + BUpdChild1.Caption;
 PPChild2.Caption := Komunikaty.Strings[29] + BUpdChild2.Caption;
 PPChild3.Caption := Komunikaty.Strings[29] + BUpdChild3.Caption;
 PPChild4.Caption := Komunikaty.Strings[29] + BUpdChild4.Caption;
 PPChild5.Caption := Komunikaty.Strings[29] + BUpdChild5.Caption;

 BChild1.Visible := BUpdChild1.Visible;
 BChild2.Visible := BUpdChild2.Visible;
 BChild3.Visible := BUpdChild3.Visible;
 BChild4.Visible := BUpdChild4.Visible;
 BChild5.Visible := BUpdChild5.Visible;

 BShowChildsPanel.Enabled := BChild1.Visible Or BChild2.Visible Or BChild3.Visible Or BChild4.Visible Or BChild5.Visible;
 BShowRecords.Enabled     := (DM.DModule.GetDBType = 'ORACLE') or (DM.DModule.GetDBType = 'Access');

 BChild1.Caption := BUpdChild1.Caption;
 BChild2.Caption := BUpdChild2.Caption;
 BChild3.Caption := BUpdChild3.Caption;
 BChild4.Caption := BUpdChild4.Caption;
 BChild5.Caption := BUpdChild5.Caption;

 BShowChildsPanelClick(nil);

 FormResize(nil);
 UprawClick(nil);
end;


//------------------------------------------------------------------
Function TFBrowseParent.getColumnCaption(FieldName : ShortString) : ShortString;
Var L : Integer;
Begin
 For L:=0 To Grid.Columns.Count - 1 Do Begin
  If (Grid.Columns[L].FieldName = FieldName) and (Grid.Columns[L].Visible) Then Begin Result := Grid.Columns[L].Title.Caption; Exit; End;
 End;
 Result := 'z' + Komunikaty.Strings[21] + FieldName;
End;

//------------------------------------------------------------------
Function TFBrowseParent.getFieldType(Field : TField) : ShortString;
Begin
 Case Field.DataType Of
  ftInteger     : Result := 'ftInteger';
  ftSmallint    : Result := 'ftInteger';
  ftWord        : Result := 'ftInteger';
  ftString      : Result := 'ftString';
  ftWideString  : Result := 'ftString';
  ftBCD         : Result := 'ftFloat';
  ftFloat       : Result := 'ftFloat';
  ftDate        : Result := 'ftDate';
  ftDateTime    : Result := 'ftDate';
  Else        Result := 'ftOther';
 End;
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.createAvailColumnsWhereClause(S : TStrings);
Var t : Integer;
Begin
  If S.Count = 0 Then Begin
   If Not Query.Active Then BRefreshClick(nil);
   For t := 0 To Query.FieldCount -1 Do begin
      if not isFlex ( Query.Fields[t].FieldName )
       then S.Add(getColumnCaption(Query.Fields[t].FieldName)+'|'+DecodeFieldName(Query.Fields[t].FieldName)+'|'+GetFieldType(Query.Fields[t]) + '|CATEGORY:DEFAULT' );
   end;
  End
  else
  begin
    // to be compatible with prior version
    for t := 0 to S.Count - 1 do
      if wordCount( S[t] , ['|'] ) = 3 then begin
        S[t] := S[t] + '|CATEGORY:DEFAULT';
      end;
  end;
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.prepareColumnsForExports(S : TStrings);
  Var t : Integer;
  function flexInUse ( FieldName : string; fieldCaption : string ) : boolean;
  begin
   result := (subStr(upperCase(FieldName),1,6) = 'ATTRIB') and (subStr(upperCase(fieldCaption),1,6) <> 'ATTRIB');
  end;
Begin
   For t := 0 To Query.FieldCount -1 Do
     //if not FlexIsAdded(S, 2, 4, Query.Fields[t].FieldName, 'CATEGORY:'+flexContextName) then
     if flexInUse ( Query.Fields[t].FieldName, getColumnCaption(Query.Fields[t].FieldName) )
        or
        (not isFlex (Query.Fields[t].FieldName))
     then
        S.Add(getColumnCaption(Query.Fields[t].FieldName)+'|'+Query.Fields[t].FieldName+'|'+GetFieldType(Query.Fields[t])+'|CATEGORY:'+flexContextName);
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bFilterClick(Sender: TObject);
 // TFieldType = (ftUnknown, ftBoolean, ftFloat,
 // ftCurrency, ftBCD, ftDate, ftTime, ftDateTime, ftBytes, ftVarBytes,ftAutoInc, ftBlob,
 // ftMemo, ftGraphic, ftFmtMemo, ftParadoxOle, ftDBaseOle, ftTypedBinary,ftCursor);
begin
  inherited;
  initializeFilerSettings ( ConditionsWhereClause.strings, flexContextName );
  AvailColumnsWhereClause.Sorted := false;
  CreateAvailColumnsWhereClause(AvailColumnsWhereClause.Strings);
  AvailColumnsWhereClause.Sorted := true;

  If UFModuleFilter.ShowModal(ConditionsWhereClause.Strings, AvailColumnsWhereClause.Strings, flexContextName) = mrOK Then
    BRefreshClick(Nil);
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.refreshHotKeys;
Begin
 HotKeys[1] := StrToInt(Others.Strings.Values['InsertHotKey']);
 HotKeys[2] := StrToInt(Others.Strings.Values['EditHotKey']);
 HotKeys[3] := StrToInt(Others.Strings.Values['DeleteHotKey']);
 HotKeys[4] := StrToInt(Others.Strings.Values['ChangeFilterHotKey']);
 HotKeys[5] := StrToInt(Others.Strings.Values['ClearSearchHotKey']);
End;

//------------------------------------------------------------------
procedure TFBrowseParent.formClose(Sender: TObject;
  var Action: TCloseAction);
Var GRID_FONT_STYLE : Integer;
begin
  // dodane bo problem z zamknieciem okna faktury przez krzyzyk
  IF (not SingleMode) and (MainPage.ActivePage = Update) then BUpdCancelClick(nil);

  if DModule.ADOConnection.InTransaction then
    DModule.CommitTrans;

  if singleMode then begin
   inherited;
   exit;
  end;

  If ComboSortOrder.ItemIndex <> -1 Then Others.Strings.Values['ComboSortOrderItemIndex.Category:'+flexContextName] := IntToStr(ComboSortOrder.ItemIndex);
  If MainPage.ActivePage = Update Then Begin
   WindowState         := TempWindowState;
   Width               := TempWidth;
   Height              := TempHeight;
   BorderStyle         := bsSizeable;
   Top                 := TempTop;
   Left                := TempLeft;

   SwitchQueryToGrid;
  End;

  If Upraw.Down Then Others.Strings.Values['UprawDown'] := 'True'
                Else Others.Strings.Values['UprawDown'] := 'False';
  If BShowChildsPanel.Down Then Others.Strings.Values['SecondRatePanelDown'] := 'True'
                           Else Others.Strings.Values['SecondRatePanelDown'] := 'False';
  If ShowPanel.Down        Then Others.Strings.Values['PanelDown'] := 'True'
                           Else Others.Strings.Values['PanelDown'] := 'False';

 Others.Strings.Values['GRID_FONT_CHARSET'] := IntToStr(Grid.Font.Charset);
 Others.Strings.Values['GRID_FONT_COLOR']   := IntToStr(Grid.Font.Color);
 Others.Strings.Values['GRID_FONT_HEIGHT']  := IntToStr(Grid.Font.Height);
 Others.Strings.Values['GRID_FONT_NAME']    := Grid.Font.Name;

 If Grid.Font.Pitch = fpDefault Then Others.Strings.Values['GRID_FONT_PITCH'] := 'fpDefault' Else
   If Grid.Font.Pitch = fpVariable Then Others.Strings.Values['GRID_FONT_PITCH'] := 'fpVariable' Else
     Others.Strings.Values['GRID_FONT_PITCH'] := 'fpFixed';

 Others.Strings.Values['GRID_FONT_SIZE'] := IntToStr(Grid.Font.Size);

 GRID_FONT_STYLE := 0;
 If fsBold in Grid.Font.Style      Then GRID_FONT_STYLE := GRID_FONT_STYLE + 1;
 If fsItalic in Grid.Font.Style    Then GRID_FONT_STYLE := GRID_FONT_STYLE + 2;
 If fsUnderline in Grid.Font.Style Then GRID_FONT_STYLE := GRID_FONT_STYLE + 4;
 If fsStrikeOut in Grid.Font.Style Then GRID_FONT_STYLE := GRID_FONT_STYLE + 8;
 Others.Strings.Values['GRID_FONT_STYLE'] := IntToStr(GRID_FONT_STYLE);

 inherited;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.BCountRecordsClick(Sender: TObject);
Var Licznik : Integer;
begin
  inherited;
  If Not Query.Active Then Exit;
  Query.DisableControls;
  Query.First;
  Licznik := 0;
  While Not Query.EOF Do Begin
   Query.Next;
   Inc(Licznik);
   If Licznik = 10001 Then
     If Question(Komunikaty.Strings[11]) = idNo Then Begin
      Query.EnableControls;
      StatusBar.Panels[2].Text := '';
      Exit;
     End;
  End;
  Query.EnableControls;
  If StrToInt(Others.Strings.Values['MaxNumerOfRecordsInGrid']) = Licznik Then
    StatusBar.Panels[2].Text:= Komunikaty.Strings[6] + ' >= '+ IntToStr(Licznik) + '. '+Komunikaty.Strings[28]
  else
    StatusBar.Panels[2].Text:= Komunikaty.Strings[6] + ' = '+ IntToStr(Licznik);
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bCancelSearchClick(Sender: TObject);
begin
  inherited;
    Others.Strings.Values['SearchSQL']   := '0=0';
    ESearch.Text := '';
    AlphaAll.Down := true;
    BRefreshClick(nil);
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.copyRecord(FromID : String; FillNotEmptyFields : Boolean);
Var T : Integer;
    HelpTable : Array[0..500] Of record FieldName : String; Value : String; End;
    //Count : Integer;

    Function GetValue(FN : String): string;
    Var i : Integer;
    Begin
     Result := '';
     For i := 0 To 500 Do
      If HelpTable[i].FieldName = FN Then Begin Result := HelpTable[i].Value; Break; End;
    End;

Begin
 With DModule Do Begin
  openSQL('SELECT * FROM '+TableName+' WHERE '+KeyField+'='+FromID);

  For T := 0 To QWork.FieldCount-1 Do Begin
   HelpTable[t].FieldName := QWork.Fields[T].FieldName;
   HelpTable[t].Value     := QWork.Fields[T].AsString;
   //info( QWork.Fields[T].FieldName + ' ' + QWork.Fields[T].AsString );
  End;
  //Count := QWork.FieldCount-1;

  For T := 0 To Query.FieldCount-1 Do Begin
     {try
       Info('copy: walue:'+GetValue(Query.Fields[T].FieldName)+' field='+Query.Fields[T].FieldName);
     except
       info('error: '+Query.Fields[T].FieldName);
       info('error: '+QWork.Fields[T].FieldName)
     end;
     info('dalej');}
     If Query.Fields[T].FieldName <> KeyField Then Begin
       If (Trim(Query.Fields[T].AsString) <> '') Then Begin
        If FillNotEmptyFields Then try Query.Fields[T].AsString := GetValue(Query.Fields[T].FieldName); {QWork.FieldByName(Query.Fields[T].FieldName).AsString;} Except end
       End Else
        try
          //info(Query.Fields[T].FieldName + '=' + GetValue(Query.Fields[T].FieldName));
          Query.Fields[T].AsString := GetValue(Query.Fields[T].FieldName);
        except end;
     End;
  End;
  QWork.Close;
 End;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.showPanelClick(Sender: TObject);
begin
  inherited;
  TopPanel.Visible := ShowPanel.Down;
end;

Function TFBrowseParent.prepareQueryOnDetailsForm : TModalResult;
Begin
 Result := mrOK;
Try
 UnLockComponents(Update);

 CopiedRecordId := '';

 With DModule Do
 Case CurrOperation of
  AInsert:Begin
           Query.SQL.Clear;
           Query.SQL.Add('SELECT * FROM '+TableName+' WHERE '+KeyField+'=0');

           Try
            Query.Open;
           Except
            on E:exception do Begin
              errorMessage(AOpen, Self, E.Message);
              Result := mrAbort;
              Exit;
            End Else SError(Komunikaty.Strings[14]);
           End;

           Try
            Query.Insert; DefaultValues;
           Except
            on E:exception do Begin
              errorMessage(AInsert, Self, E.Message);
              Result := mrAbort;
              Exit;
            End Else SError(Komunikaty.Strings[14]);
           End;
          End;
  ACopy  :Begin
            Query.SQL.Clear;
            Query.SQL.Add('SELECT * FROM '+TableName+' WHERE '+KeyField+'=0');
            Try
             Query.Open;
            Except
             on E:exception do Begin
               errorMessage(AOpen, Self, E.Message);
               Result := mrAbort;
               Exit;
             End Else SError(Komunikaty.Strings[14]);
            End;

            CopiedRecordId := ID;
            try
             //Query.Insert clears ID
             Query.Insert;
            Except
             on E:exception do Begin
               errorMessage(AInsert, Self, E.Message);
               Result := mrAbort;
               Exit;
             End Else SError(Komunikaty.Strings[14]);
            End;

            CopyRecord(CopiedRecordId, True);
            DefaultValues;
          End;
  AEdit  :Begin
            Query.SQL.Clear;
            Query.SQL.Add('SELECT * FROM '+TableName+' WHERE '+KeyField+'='+ID);
            Try
             Query.Open;
            Except
             on E:exception do Begin
               errorMessage(AOpen, Self, E.Message);
               Result := mrAbort;
               Exit;
             End Else SError(Komunikaty.Strings[14]);
            End;
            If Result = mrAbort Then Exit;

            Try
              If Not Query.IsEmpty Then Begin
                Query.Edit;
                If Not CanEditIntegrity Then LockComponents(Update);
              End
              Else Begin
                Warning(Komunikaty.Strings[7]);
                Result := mrAbort;
                Exit;
              End;
            Except
             on E:exception do Begin
               errorMessage(AEdit, Self, E.Message);
               Result := mrAbort;
               Exit;
             End Else SError(Komunikaty.Strings[14]);
            End;
            End;
  Else SError('UFUpd: Action poza zakresem'); End;

 Case CurrOperation Of
  AInsert : Update.Caption := Komunikaty.Strings[18];
  ACopy   : Update.Caption := Komunikaty.Strings[19];
  AEdit   : Update.Caption := Komunikaty.Strings[20];
 End;

 If CurrOperation = AEdit Then Begin
  BUpdChild1.Enabled := True;
  BUpdChild2.Enabled := True;
  BUpdChild3.Enabled := True;
  BUpdChild4.Enabled := True;
  BUpdChild5.Enabled := True;
  LockNotUpdatable;
 End
 Else Begin
  BUpdChild1.Enabled := False;
  BUpdChild2.Enabled := False;
  BUpdChild3.Enabled := False;
  BUpdChild4.Enabled := False;
  BUpdChild5.Enabled := False;
  UnLockNotUpdatable;
 End;

 BeforeEdit;

Except
//inne nie obs³u¿one wyj¹tki - chyba przypadek niemo¿liwy
SError('Nieznany b³¹d !');
Result := mrAbort;
End;
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.switchQueryToDetails;
Begin
  TempSQL           := Query.SQL.Text;
  //Query.RequestLive := True;
End;

//------------------------------------------------------------------
Function TFBrowseParent.execute(aCurrOperation : Integer; aID : ShortString): TModalResult;
  var del_id : string;
  //--------------------------
  Procedure DeleteRecord(aID : String);
  Begin
      ID := aID;
      Try BeforeDelete; Except Info(Komunikaty.Strings[26]); End;
      Try
       DModule.SQL('DELETE FROM '+TableName+' WHERE '+KeyField+'='+ID);
       Try AfterDelete; Except Info(Komunikaty.Strings[27]); End;
      Except
       on E:exception do Begin
         errorMessage(ADelete, Self, E.Message);
       End Else SError(Komunikaty.Strings[14]);
      End;
  End;
  //--------------------------
Begin
  CurrOperation := aCurrOperation;

  With DModule Do Begin
   If CurrOperation <> AInsert Then begin
       if aId<>'' then begin
             id := aId;
         del_id := aId;
       end else begin
             id := Query.FieldByName(KeyField).AsString;
         del_id := Query.FieldByName(KeyField).AsString;
       end;
   end;
   If CurrOperation = ADelete  Then  Begin
     Query.Next;  // not for visual effect only, it changes records in loop delete all
     DeleteRecord(del_id);
     Exit;
   End;
  End;

  Query.Close;
  SwitchQueryToDetails;
  Result  := PrepareQueryOnDetailsForm;

  If Result <> mrAbort Then Begin
   SwitchFormToDetails;
  End
  Else Begin
   SwitchQueryToGrid;
   BRefreshClick(nil);
  End;
  flexRefreshFormView;
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.switchFormToGrid;
Begin
 If CanRefresh Then Begin
    Others.Strings.Values['LEFT'] := IntToStr(Left);
    Others.Strings.Values['TOP'] := IntToStr(Top);
    Hide;
    Browse.TabVisible   := True;
    Update.TabVisible   := Not Browse.TabVisible;
    MainPage.ActivePage := Browse;
    WindowState         := TempWindowState;
    Width               := TempWidth;
    Height              := TempHeight;
    BorderStyle         := bsSizeable;
    Top                 := TempTop;
    Left                := TempLeft;
    FormResize(nil);
    Show;
    BRefreshClick(nil);
 End;
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.switchFormToDetails;
Begin
 If CanRefresh Then Begin
   Hide;
   Browse.TabVisible   := False;
   Update.TabVisible   := Not Browse.TabVisible;
   TempWindowState := WindowState;
   TempWidth       := Width;
   TempHeight      := Height;
   TempTop         := Top;
   TempLeft        := Left;
   Width           := StrToInt(Others.Strings.Values['MIN_WIDTH']);
   Height          := StrToInt(Others.Strings.Values['MIN_HEIGHT']);
   Left            := StrToInt(Others.Strings.Values['LEFT']);
   Top             := StrToInt(Others.Strings.Values['TOP']);

   BorderStyle     := bsDialog;

   MainPage.ActivePage := Update;

   FormResize(nil);

   BUpdPrev.Visible := not SingleMode;
   BUpdNext.Visible := not SingleMode;
   BUpdCopy.Visible := not SingleMode;
   BUpdNew.Visible := not SingleMode;
   BUpdApply.Visible := not SingleMode;

   If Not SingleMode   Then Self.Show;
   If SingleMode       Then Self.ShowModal;

 End;
 Try ActiveControl := FirstControl; Except End;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdCancelClick(Sender: TObject);
begin
  inherited;
  ActiveControl := BUpdCancel;
  //important statement ! - it fires different events associated with activecontrol for example "OnExit" Event for TDBEdit

  Try Query.Cancel; Except {W szczególnym przypadku mo¿e wyst¹piæ Record/Key deleted} End;
  AfterCloseDetails;

  If SingleMode Then Close Else
  Begin
    SwitchQueryToGrid;
    SwitchFormToGrid;
  End;
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.switchQueryToGrid;
Begin
 Query.SQL.Text    := TempSQL;
 //Query.RequestLive := False;
End;

function TFBrowseParent.updApplyAndClose : boolean;
var translatedMessage : string;
Begin
  Result := False;
  If (ActiveControl <> BUpdNew) And (ActiveControl <> BUpdApply) And (ActiveControl <> BUpdOK) Then FirstControl := ActiveControl;
  //important statement ! - it fires different events associated with activecontrol for example "OnExit" Event for TDBEdit
 ActiveControl := BUpdOK;

  If Not CheckRecord Then Exit;
  if flexEnabled then
    if not FlexCheckRecord Then Exit;

  try
   If (Query.State = dsEdit) Or (Query.State = dsInsert) Then Begin
     Try BeforePost; Except on e:exception do begin Info(Komunikaty.Strings[24]+' '+E.Message); abort; end; End;
     Query.Post;
     Try AfterPost; Except on e:exception do begin Info(Komunikaty.Strings[25]+' '+E.Message); abort; end; End;
   End;
  except
   on E:exception Do Begin
     If Pos(sKeyViolation, E.Message)<>0 Then Begin
      if DBMap.get (E.Message, translatedMessage) then begin SError(translatedMessage); abort; end;
      If Question(Komunikaty.Strings[10]) = idYes Then Begin
         errorMessage(APost, Self, E.Message);
         Abort;
      End Else Abort;
     End
     else begin
       errorMessage(APost, Self, E.Message);
       Abort;
     end;
   End
   Else SError(Komunikaty.Strings[14]);
  end;
  AfterCloseDetails;

  If CurrOperation in [AInsert,ACopy] Then Begin
    ID := Query.FieldByName(KeyField).AsString; // Jeœli edytowano rekord, to ID siê nie zmieni.
    Bookmark := Query.FieldByName(KeyField).AsString;
  End;

  If SingleMode Then Close Else
  Begin
   SwitchQueryToGrid;
   SwitchFormToGrid;
  End;
  Result := True;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdOKClick(Sender: TObject);
begin
  inherited;
  UpdApplyAndClose;
end;

//------------------------------------------------------------------
function TFBrowseParent.decodeFieldName(FieldName : ShortString): ShortString;
begin
 Result := Others.Strings.Values['ALIAS:'+FieldName];
 If Result = '' Then Result := FieldName;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.eSearchChange(Sender: TObject);
begin
  inherited;
  SearchCounter := 3;
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.beforeEdit;
Begin
End;

//------------------------------------------------------------------
function TFBrowseParent.updApplyClick : Boolean;
var translatedMessage : string;
Begin
  Result := False;
  If (ActiveControl <> BUpdNew) And (ActiveControl <> BUpdApply) And (ActiveControl <> BUpdOK) Then FirstControl := ActiveControl;
  //important statement ! - it fires different events associated with activecontrol for example TDBEdit.OnExit
  ActiveControl := BUpdApply;

  If Not CheckRecord Then Exit;
  if flexEnabled then
    if not FlexCheckRecord Then Exit;

  try
   If (Query.State = dsEdit) Or (Query.State = dsInsert) Then Begin
     Try BeforePost; Except Info(Komunikaty.Strings[24]); End;
     Query.Post;
     Try AfterPost; Except on e:exception do Info(Komunikaty.Strings[25]+' '+E.Message); End;
   End;
  except
   on E:exception Do Begin
     If Pos(sKeyViolation, E.Message)<>0 Then Begin
      if DBMap.get (E.Message, translatedMessage) then begin SError(translatedMessage); abort; end;
      If Question(Komunikaty.Strings[10]) = idYes Then Begin
         errorMessage(APost, Self, E.Message);
         Abort;
      End Else Abort;
     End
     else begin
       errorMessage(APost, Self, E.Message);
       Abort;
     end;
   End
   Else SError(Komunikaty.Strings[14]);
  end;
  AfterCloseDetails;

  If CurrOperation in [AInsert,ACopy] Then Begin
   ID := Query.FieldByName(KeyField).AsString; // Jeœli edytowano rekord, to ID siê nie zmieni.
   Bookmark := Query.FieldByName(KeyField).AsString;
   CurrOperation   := AEdit;
  End;

  If PrepareQueryOnDetailsForm = mrAbort Then
    If SingleMode Then Close Else
    Begin
      SwitchQueryToGrid;
      SwitchFormToGrid;
      Exit;
    End;

  Result := True;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdApplyClick(Sender: TObject);
begin
  If UpdApplyClick Then {};
end;

procedure TFBrowseParent.pPCopyClick(Sender: TObject);
begin
  BCopyClick(nil);
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.customConditions;
Begin
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.beforePost;
Begin
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.afterPost;
Begin
End;

//------------------------------------------------------------------
Procedure TFBrowseParent.afterDelete;
Begin
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bGraphModuleClick(Sender: TObject);
begin
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bSummariesModuleClick(Sender: TObject);
begin
end;


//------------------------------------------------------------------
procedure TFBrowseParent.bOleExportClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 ppexport.Popup(Point.X,Point.Y);
end;


//------------------------------------------------------------------
procedure TFBrowseParent.bShowRecordsClick(Sender: TObject);
Var MaxNumerOfRecordsInGrid : ShortString;
begin
  inherited;
  MaxNumerOfRecordsInGrid := Others.Strings.Values['MaxNumerOfRecordsInGrid'];
  MaxNumerOfRecordsInGrid := InputBox('Pytanie', 'Ile maks. rekordów wyœwietlaæ w siatce ?',MaxNumerOfRecordsInGrid);
  Try
   StrToInt(MaxNumerOfRecordsInGrid);
   Others.Strings.Values['MaxNumerOfRecordsInGrid'] := MaxNumerOfRecordsInGrid;
   BRefreshClick(nil);
  Except
   SError('Podana wartoœæ nie jest liczb¹.     Maksymaln¹ liczb¹ rekordów wyœwietlanych w siatce jest wci¹¿ '+Others.Strings.Values['MaxNumerOfRecordsInGrid']);
  End;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.gridTitleClick(Column: TColumn);
begin
  inherited;
  BConfigureClick(grid);
end;


//------------------------------------------------------------------
function TFBrowseParent.getSearchFilter: string;
begin
  result := PRE_UPPERCASE + DecodeFieldName(Grid.Columns[findFirstVisibleColumn].FieldName)+POST_UPPERCASE+' LIKE ' + PRE_UPPERCASE + ''''+trim(ESearch.Text)+ GetSystemParam('ANY_CHARS')+'''' + POST_UPPERCASE;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.searchTimerTimer(Sender: TObject);
begin
  inherited;
  If Not Self.Active Then Exit;
  If MainPage.ActivePage <> Browse Then Exit;
  If SearchCounter > 0 Then SearchCounter := SearchCounter - 1;
  If SearchCounter = 1 Then Begin

   try
     if trim(ESearch.Text) = '' then
       Others.Strings.Values['SearchSQL']   := '0=0'
     else
       Others.Strings.Values['SearchSQL']   := getSearchFilter;
     BRefreshClick(nil);
   except
     Info(Komunikaty.Strings[5]);
     ESearch.Text := '';
     Others.Strings.Values['SearchSQL']   := '0=0';
     BRefreshClick(nil);
   end;
  End;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bCrossCombinationClick(Sender: TObject);
var    DefinitionOfColumns : TStrings;
begin
  inherited;
  DefinitionOfColumns := TStringList.Create;
  PrepareColumnsForExports(DefinitionOfColumns);
  UFModuleCrossCombination.ShowModal(Query,DefinitionOfColumns, GetFileNameWithExtension(Self, 'scr'));
  DefinitionOfColumns.Free;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.m5Click(Sender: TObject);
begin
  inherited;
  BCrossCombinationClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.m6Click(Sender: TObject);
begin
ExportEasyClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.ppSecondRate1Click(Sender: TObject);
begin
  inherited;
  BUpdChild1Click(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdChild1Click(Sender: TObject);
begin
 If MainPage.ActivePage <> Update Then BEditClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdChild2Click(Sender: TObject);
begin
 If MainPage.ActivePage <> Update Then BEditClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdChild3Click(Sender: TObject);
begin
 If MainPage.ActivePage <> Update Then BEditClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdChild4Click(Sender: TObject);
begin
 If MainPage.ActivePage <> Update Then BEditClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bShowChildsPanelClick(Sender: TObject);
begin
  inherited;
  SecondRatePanel.Visible := BShowChildsPanel.Down And BShowChildsPanel.Enabled;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.setNotUpdatable(COLS : Array of TWinControl; LBLS : Array of TLabel);
Var T : Integer;
begin
   For t:= 0 To High(COLS) do not_updatable_columns.A[t] := COLS[t];
   not_updatable_columns.C := High(COLS);
   For t:= 0 To High(LBLS) do not_updatable_labels.A [t] := LBLS[t];
   not_updatable_labels.C := High(LBLS);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.lockNotUpdatable;
Var t : Integer;
Begin
 For t := 0 To not_updatable_columns.C Do
  TWinControl(not_updatable_columns.A[t]).Enabled := False;

 For t := 0 To not_updatable_labels.C Do
  TLabel(not_updatable_labels.A[t]).Color := $008080AA;

End;

//------------------------------------------------------------------
procedure TFBrowseParent.unLockNotUpdatable;
Var t : Integer;
Begin
 For t := 0 To not_updatable_columns.C Do
  TWinControl(not_updatable_columns.A[t]).Enabled := True;

 For t := 0 To not_updatable_labels.C Do
  TLabel(not_updatable_labels.A[t]).Color := clBtnFace;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdNewClick(Sender: TObject);
begin
  inherited;
 CanRefresh := False;
 If UpdApplyAndClose Then BAddClick(nil);
 CanRefresh := True;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdNewMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  If (ActiveControl <> BUpdCopy) And (ActiveControl <> BUpdNew) And (ActiveControl <> BUpdApply) And (ActiveControl <> BUpdOK) Then FirstControl := ActiveControl;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdNextClick(Sender: TObject);
begin
  inherited;
  If UpdApplyAndClose Then Begin
    BNextClick(nil);
    BEditClick(nil);
  End;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdPrevClick(Sender: TObject);
begin
  inherited;
  If UpdApplyAndClose Then Begin
    BPrevClick(nil);
    BEditClick(nil);
  End;
end;

//------------------------------------------------------------------
Procedure TFBrowseParent.afterCloseDetails;
Begin
  if flexModified then flexSaveFormView;
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bInternetBrowserExportClick(Sender: TObject);
Begin
End;

//------------------------------------------------------------------
procedure TFBrowseParent.bExecuteCalcClick(Sender: TObject);
begin
  inherited;
  UUTilityParent.ExecuteFileAndWait('calc.exe');
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bDiagnosticsModuleClick(Sender: TObject);
begin
  inherited;
  ExecuteFileAndWait('trickSQL\trickSQL.exe');
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdCopyClick(Sender: TObject);
begin
  inherited;
 If UpdApplyAndClose Then BCopyClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bUpdChild5Click(Sender: TObject);
begin
 If MainPage.ActivePage <> Update Then BEditClick(nil);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.flexSetContextNameInListView;
begin
end;

//------------------------------------------------------------------
procedure TFBrowseParent.flexSetContextNameInFormView;
begin
end;

//------------------------------------------------------------------
procedure TFBrowseParent.FlexAddClick(Sender: TObject);
var fieldNo              : shortString;
    fieldType            : shortstring;
    fieldCaption         : shortString;
    fieldwidth           : shortString;
    fieldsqlDefaultValue : shortString;
    fieldRequired        : shortString;

    function getXY ( fieldType : shortString; fieldNo : shortString; labelOrControl : shortString; XorY : shortString ) : integer;
    var point : tpoint;
    begin
      if labelOrControl = 'L' then begin
        if fieldType = 'S' then point := attribs[ strtoint(fieldNo)].lpos;
        if fieldType = 'N' then point := attribn[ strtoint(fieldNo)].lpos;
        if fieldType = 'D' then point := attribd[ strtoint(fieldNo)].lpos;
      end;
      if labelOrControl = 'C' then begin
        if fieldType = 'S' then point := attribs[ strtoint(fieldNo)].cpos;
        if fieldType = 'N' then point := attribn[ strtoint(fieldNo)].cpos;
        if fieldType = 'D' then point := attribd[ strtoint(fieldNo)].cpos;
      end;
      if XorY = 'X' then result := point.x else result := point.Y;
    end;


begin
  if FFlexNewAttribute = nil then Application.CreateForm(TFFlexNewAttribute, FFlexNewAttribute);
  if FFlexNewAttribute.showModal = mrOK then begin
    with FFlexNewAttribute do begin
     fieldCaption := eFieldCaption.Text;
     case eFieldType.itemIndex of
      0: begin
           fieldType := 'S';
         end;
      1: begin
           fieldType := 'N';
         end;
      2: begin
           fieldType := 'D';
         end;
     end;
     fieldWidth           := eFieldWidth.Text;
     fieldsqlDefaultValue := getSqlDefaultValue;
     fieldRequired        := iif(ERequired.Checked,'+','-');
    end;
  end
  else exit;
  fieldNo :=
    dmodule.SingleValue('select planner_utils.flexGetFieldName (:max_flex_num, :form_name, :context_name , :field_type ) from dual'
                       ,'form_name='+self.name+';context_name='+self.flexContextName+';max_flex_num='+inttostr(maxFlexs)+';field_type='+fieldType
                        );

  if fieldNo = '' then begin
    info ('Nie ma ju¿ wolnych pozycji do zapisania nowego atrybutu. SprawdŸ, czy wszystkie atrybuty, które u¿ywasz s¹ na pewno potrzebne');
    exit;
  end;

  dmodule.SQL('insert into flex_col_usage (id, form_name, context_name, attr_name, custom_name, caption, width,label_pos_x,label_pos_y,field_pos_x,field_pos_y, sql_default_value, required, sql_check_message, sql_check_procedure)'+
              ' values (flex_col_usage_seq.nextval, :form_name, :context_name, :attr_name, :custom_name, :caption, :width, :label_pos_x,:label_pos_y,:field_pos_x,:field_pos_y,:sql_default_value, :required, :sql_check_message, :sql_check_procedure)'
             ,'form_name='      + self.name+
              ';context_name='  + self.flexContextName+
              ';attr_name='+ 'ATTRIB'+fieldType+'_'+fieldNo+      //column from table name
              ';custom_name='   + 'CHANGE_ME_ATTRIB'+fieldType+'_'+fieldNo+  //your custom name
              ';caption='       + searchAndReplace ( fieldCaption , '=', '!chr(61)') +
              ';width='         + fieldwidth+
              //';label_pos_x='+inttostr( tcontrol ( self.FindComponent('LATTRIB'+fieldType+'_'+fieldNo) ).Left )+
              //';label_pos_y='+inttostr( tcontrol ( self.FindComponent('LATTRIB'+fieldType+'_'+fieldNo) ).Top  )+
              //';field_pos_x='+inttostr( tcontrol ( self.FindComponent( 'ATTRIB'+fieldType+'_'+fieldNo) ).Left )+
              //';field_pos_y='+inttostr( tcontrol ( self.FindComponent( 'ATTRIB'+fieldType+'_'+fieldNo) ).Top  )
              ';label_pos_x='+inttostr( getXY ( fieldType,fieldNo,'L','X')  )+
              ';label_pos_y='+inttostr( getXY ( fieldType,fieldNo,'L','Y')  )+
              ';field_pos_x='+inttostr( getXY ( fieldType,fieldNo,'C','X')  )+
              ';field_pos_y='+inttostr( getXY ( fieldType,fieldNo,'C','Y')  )+
              ';sql_default_value='+ searchAndReplace( fieldsqlDefaultValue , '=', '!chr(61)') +
              ';required='+ fieldRequired +
              ';sql_check_message='+ searchAndReplace ( FFlexNewAttribute.sql_check_message.Text , '=', '!chr(61)') +
              ';sql_check_procedure='+ searchAndReplace( FFlexNewAttribute.sql_check_procedure.Text , '=', '!chr(61)')
             );

  flexRefreshFormView;
  flexDefaultValues ('ATTRIB'+fieldType+'_'+fieldNo);

  // since opperation was sucessfull revert form to default values
  with FFlexNewAttribute do begin
    eFieldCaption.Text := '';
    EDefaultValue.Text := '';
    ERequired.Checked  := false;
  end;

  flexSynchronize;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.flexGetAttribute ( fname : string; var systemFlag : shortString );
begin
  //LATTRIBS_01 or ATTRIBS_01
  if copy(fname,1,1)='L' then fname := copy(fname,2,65000);
  //ATTRIBS_01
  if copy(fname,7,1) = 'S' then begin systemFlag := attribs[ strToInt(copy(fname,9,2)) ].system_flag; exit; end;
  if copy(fname,7,1) = 'N' then begin systemFlag := attribn[ strToInt(copy(fname,9,2)) ].system_flag; exit; end;
  if copy(fname,7,1) = 'D' then begin systemFlag := attribd[ strToInt(copy(fname,9,2)) ].system_flag; exit; end;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.LATTRIBS_01MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  var SystemFlag : string[1];
begin
  inherited;
  if not BFlexDesignMode.Down then exit;
  FlexDelete.Visible := false;

  flexGetAttribute ( TControl(Sender).name , SystemFlag );
  if SystemFlag = '+' then exit; //system fields are frozen

  ReleaseCapture;
  TControl(Sender).Perform(WM_SysCommand, $F012, 0);
  flexModified := true;

  if not (TControl(Sender) is tStaticText) then begin
   FlexDelete.Left := TControl(Sender).Left + TControl(Sender).Width;
   FlexDelete.Top := TControl(Sender).Top;
   FlexDelete.Visible := true;
   Flexdelete.Enabled := SystemFlag = '-'; //one cannot delete system fields
   FlexCurrentFieldName := TControl(Sender).name;
  end;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.flexMoreClick(Sender: TObject);
var point : tpoint;
    btn   : tspeedbutton;
begin
 btn := sender as tspeedbutton;
 Point.x:= 0;
 Point.y:= btn.Height;
 Point:=btn.ClientToScreen(Point);
 flexPopup.Popup(Point.X,Point.Y);
end;

//------------------------------------------------------------------
procedure TFBrowseParent.flexDeleteClick(Sender: TObject);
   procedure FlexDeleteFromStrings ( s : tstrings; fieldNamePos: integer; categoryNamePos: integer; fieldName : string; categoryName : string );
   var t : integer;
   begin
   for t := 0 to S.count - 1 do begin
    if (extractWord(fieldNamePos,s[t],['|']) = fieldName) and (extractWord(categoryNamePos,s[t],['|']) = categoryName) then begin
      s.Delete(t);
      exit;
    end;
   end;
   end;
begin
  if question('Czy na pewno chcesz usun¹æ ten atrybut ?') <> id_yes then exit;
  dmodule.SQL('delete from flex_col_usage where form_name=:form_name and context_name=:context_name and attr_name=:attr_name'
             ,'form_name='+self.name+
              ';context_name='+self.flexContextName+
              ';attr_name='+self.FlexCurrentFieldName);
  flexRefreshFormView;
  FlexDelete.Visible := false;

  flexSynchronize;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.flexPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
   FlexDelete.Visible := false;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.bFlexDesignModeClick(Sender: TObject);
begin
  If not editFlex Then Begin
   Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach "Modu³ atrybuty"');
   Exit;
  End;
  flexRefreshFormView;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.zaawansowanakonfiguracjaatrybutw1Click(
  Sender: TObject);
begin
  FLEX_COL_USAGEShowModalAsBrowser;
  flexRefreshFormView;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.przywrdomylnepooeniewszystkichatrybutw1Click(
  Sender: TObject);
var t : integer;
    systemFlag : string[1];
begin
  if question('Czy na pewno chcesz przwróciæ domyœlne po³o¿enie dla wszystkich elementów ?') <> id_yes then exit;
   for t := 1 to maxFlexs do begin
     flexGetAttribute ( attribs[ t].c.name , systemFlag ); //do not move system attributes
     if systemFlag = '-' then begin
       attribs[ t].c.Left := attribs[ t].cpos.x;
       attribs[ t].c.Top  := attribs[ t].cpos.y;
       attribs[ t].l.Left := attribs[ t].lpos.x;
     attribs[ t].l.Top  := attribs[ t].lpos.y;
     end;
     flexGetAttribute ( attribn[ t].c.name , systemFlag );
     if systemFlag = '-' then begin
       attribn[ t].c.Left := attribn[ t].cpos.x;
       attribn[ t].c.Top  := attribn[ t].cpos.y;
       attribn[ t].l.Left := attribn[ t].lpos.x;
       attribn[ t].l.Top  := attribn[ t].lpos.y;
     end;
     flexGetAttribute ( attribd[ t].c.name , systemFlag );
     if systemFlag = '-' then begin
       attribd[ t].c.Left := attribd[ t].cpos.x;
       attribd[ t].c.Top  := attribd[ t].cpos.y;
       attribd[ t].l.Left := attribd[ t].lpos.x;
       attribd[ t].l.Top  := attribd[ t].lpos.y;
     end;
   end;
   flexModified := true;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.Wyjdztrybuprojetowaniaatrybutw1Click(
  Sender: TObject);
begin
  BFlexDesignMode.Down := not BFlexDesignMode.Down;
  flexRefreshFormView;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.AlphaShowClick(Sender: TObject);
begin
 if AlphaShow.Down then begin PanelAlphabet.Width := 641; AlphaShow.Caption := '<<'; end
                   else begin PanelAlphabet.Width := 20;  AlphaShow.Caption := '>>'; end;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.AlphaAClick(Sender: TObject);
begin
  inherited;
  //if (sender as tspeedButton).caption = '*' then begin SearchCounter := 0; BCancelSearchClick(nil); exit; end;
  ESearch.Text := iif ( (sender as tspeedButton).caption='*','',(sender as tspeedButton).caption);
  SearchCounter := 2;
  SearchTimerTimer(nil); //refresh immediate
end;

//------------------------------------------------------------------
procedure TFBrowseParent.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
   //Grid.Canvas.Brush.Color := clBlack;
   //Grid.Canvas.FillRect(Rect);
   //Grid.Canvas.Pen.Color := clGreen;
   //Grid.Canvas.TextOut( Rect.Left, Rect.Top, QUERY.FieldByName(Column.FieldName).AsString );
 // inherited;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.PPSelectClick(Sender: TObject);
begin
 If Not BSelect.Enabled Then Exit;

 if dgMultiSelect in Grid.Options then
   grid.SelectedRows.CurrentRowSelected := not grid.SelectedRows.CurrentRowSelected
 else
 begin
  ID := Query.FieldByName(KeyField).AsString;
  MR := mrOK;
  Close;
 end;
end;

//------------------------------------------------------------------
procedure TFBrowseParent.QueryBeforeClose(DataSet: TDataSet);
begin
 //If Query.RequestLive = False Then
   Bookmark := Query.FieldByName(KeyField).AsString;
end;

procedure TFBrowseParent.errorMessage(aAction: Integer; P: Pointer; ErrorMessage: String);
var translatedMessage : string;
begin
    if DBMap.get (ErrorMessage, translatedMessage)
    then SError(translatedMessage)
    else UFDatabaseError.ShowModal(aAction, P, ErrorMessage);
end;

procedure TFBrowseParent.TopPanelDblClick(Sender: TObject);
begin
  inherited;
  info ( Status.Caption );
end;

Procedure TFBrowseParent.ExportToHtml(aGrid : TDBGrid );
    var FileName : string;
        F : TextFile;
        aQuery : TADOQuery;

    Procedure doExport;
    var LineNumber : Integer;
        LineString : string;
        t : integer;
        index : integer;
        rangeTo : string;
        headers : array of String;
        {------------------------------------}
        procedure flush(tag : string);
        var t : integer;
        begin
          Writeln(f, '<tr>');
          for t := 0 to index-1 do begin
              writeLn(f, '<'+tag+'>'+headers[t]+'</'+tag+'>');
          end;
          Writeln(f, '</tr>');
        end;
    begin
          DeleteFile( FileName );

          AssignFile(F, FileName);
          ReWrite(F);

          Writeln(f, '<HTML>');
          Writeln(f, '<HEAD>');
          Writeln(f, '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">');
          Writeln(f, '<TITLE>Plansoft.org - eksport danych</TITLE>');
          Writeln(f, '<style type="text/css" media="screen">');
          Writeln(f, '@import "filtergrid.css";');
          Writeln(f, 'h2{ margin-top: 50px; }');
          Writeln(f, '.mytable{');
          Writeln(f, '	width:100%; font-size:12px;');
          Writeln(f, '	border:1px solid #ccc;');
          Writeln(f, '}');
          Writeln(f, 'th{ background-color:#003366; color:#FFF; padding:2px; border:1px solid #ccc; }');
          Writeln(f, 'td{ padding:2px; border-bottom:1px solid #ccc; border-right:1px solid #ccc; }');
          Writeln(f, '</style>');
          Writeln(f, '<script language="javascript" type="text/javascript" src="actb.js"></script>');
          Writeln(f, '<script language="javascript" type="text/javascript" src="tablefilter.js"></script>');
          Writeln(f, '</HEAD>');
          Writeln(f, '<BODY>');

          WriteLn(F, '<TABLE ID="mytable">');

              index := 0;
              for t := 0 to agrid.Columns.Count-1 do
                if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                    inc ( index );
                end;
              setlength(headers, index);

              index := 0;
              for t := 0 to agrid.Columns.Count-1 do
                if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                    headers[index] := agrid.Columns[t].Title.Caption;
                    inc ( index );
                end;
              flush('th');

              LineNumber := 1;
              aQuery.First;
              While not aQuery.Eof do
              begin
                Inc(lineNumber);

                index := 0;
                for t := 0 to agrid.Columns.Count-1 do
                  if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                  if aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).IsNull then
                    headers[index] := ''
                  else
                    Case aGrid.Columns.Items[t].Field.DataType of
                      //ftUnknown    : ;
                      ftString     : headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                      //ftSmallint   : ;
                      //ftInteger    : ;
                      //ftWord       : ;
                      //ftBoolean    : ;
                      //ftFloat      : ;
                      //ftCurrency   : ;
                      //ftBCD        : ;
                      //ftDate       : ;
                      //ftTime       : ;
                      ftDateTime   : headers[index] := FormatDateTime('yyyy-mm-dd', aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value );
                      //ftBytes      : ;
                      //ftVarBytes   : ;
                      //ftAutoInc    : ;
                      //ftBlob       : ;
                      //ftMemo       : ;
                      //ftGraphic    : ;
                      //ftFmtMemo    : ;
                      //ftParadoxOle : ;
                      //ftDBaseOle   : ;
                      //ftTypedBinary: ;
                      //ftCursor     : ;
                      //ftFixedChar  : ;
                      ftWideString : headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                      //ftLargeint   : ;
                      //ftADT        : ;
                      //ftArray      : ;
                      //ftReference  : ;
                      //ftDataSet    : ;
                      //ftOraBlob    : ;
                      //ftOraClob    : ;
                      //ftVariant    : ;
                      //ftInterface  : ;
                      //ftIDispatch  : ;
                      //ftGuid       : ;
                      //ftTimeStamp  : ;
                      else headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                     End;
                  inc(index);
                  end;

                LineString := IntToStr(LineNumber);
                flush('td');
                aQuery.Next;
              end;
              LineString := IntToStr(LineNumber);

     WriteLn(F, '</TABLE>');

     Writeln(f, '<script language="javascript" type="text/javascript">');
     Writeln(f, '//<![CDATA[');

     Writeln(f, '	var table2_Props = 	{');
     Writeln(f, '		sort_select: true,');
     Writeln(f, '		loader: true,');
     Writeln(f, '		col_0: "select",');
     Writeln(f, '		on_change: true,');
     Writeln(f, '		display_all_text: " [ Wszystkie ] ",');
     Writeln(f, '		rows_counter: true,');
     Writeln(f, '		btn_reset: true,');
     Writeln(f, '		rows_counter_text: "Liczba wierszy: ",');
     Writeln(f, '		alternate_rows: true,');
     Writeln(f, '		btn_reset_text: "Czyœæ filtr",');
     //Writeln(f, '		col_width: ["220px",null,"280px"]');
     Writeln(f, '		};');

     Writeln(f, '	setFilterGrid( "mytable",table2_Props );');
     Writeln(f, '//]]>');
     Writeln(f, '</script>');

     Writeln(f, '</BODY></HTML>');
     CloseFile(F);

     ExecuteFile(FileName,'','',SW_SHOWMAXIMIZED);
    end;

Begin
 FProgramSettings.generateJsFiles;
 FileName:= uutilityParent.ApplicationDocumentsPath + '\temp.html';
 aQuery  := TADOQuery( aGrid.DataSource.DataSet );

 If Not aQuery.Active Then Begin
  Exit;
 End;

 aQuery.DisableControls;
 doExport;
 aQuery.EnableControls;
End;


procedure TFBrowseParent.bexportpopupClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 PMenu.Popup(Point.X,Point.Y);
end;

procedure TFBrowseParent.ExportEasyClick(Sender: TObject);
begin
 if not elementEnabled('"Prosty eksport do Excela"','2014.02.01', false) then exit;
 Dmodule.ExportToExcel(grid);
end;

procedure TFBrowseParent.ExportHtmlClick(Sender: TObject);
begin
 if not elementEnabled('"Prosty eksport do pliku"','2014.03.15', false) then exit;
 ExportToHTML(grid);
end;

procedure TFBrowseParent.EksportujdoExcela1Click(Sender: TObject);
begin
ExporthtmlClick(nil);
end;


procedure TFBrowseParent.EFilterClick(Sender: TObject);
begin
  bFilterClick(nil);
end;

procedure TFBrowseParent.SpeedButton1Click(Sender: TObject);
var s1,s2,s3,s4,s5 : string;
begin
  try s1 := query.FieldByName('creation_date').AsString;    except s1:=''; end;
  try s2 := query.FieldByName('created_by').AsString;       except s2:=''; end;
  try s3 := query.FieldByName('last_update_date').AsString; except s3:=''; end;
  try s4 := query.FieldByName('last_updated_by').AsString;  except s4:=''; end;
  s5 :=   'Utworzono:'+#9+#9  +  s1  +#13+#10+
  'Utworzy³:'+#9+#9+ s2 +#13+#10+
  'Zaktualizowano:'+#9+#9 +s3 +#13+#10+
  'Zaktualizowa³:'+#9+#9  + s4;

  info(s5);
end;

End.
