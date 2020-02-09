unit UFMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, ExtCtrls, StdCtrls, Buttons, ComCtrls, StrHlder,
  UCommon, DM, UFReadString, Menus, UFInfo, Tabs, Mask, DBCtrls, Grids,
  ToolEdit, db, UFDatabaseLogin,
  WSDLBind, XMLSchema, ImgList, UrlMon, adodb, UFKPI, ShellAPI,
  DBGrids, UUtilityParent, DateUtils, XPMan;

var dGeneralDebug : string;

const
  clMove        =  1;
  clCopy        =  2;
  clDeleteLec   =  3;
  clDeleteGro   =  4;
  clDeleteRes   =  5;
  clDeleteOwner = 23;
  clAttachLec   =  6;
  clAttachGro   =  7;
  clAttachRes   =  8;
  clAttachOwner = 22;
  clChangeSub   =  9;
  clChangeFor   = 10;
  clChangeOwner = 11;
  clChangeCColor= 12;
  clDeleteSub   = 13;
  clChangeDesc1 = 14;
  clChangeDesc2 = 15;
  clChangeDesc3 = 16;
  clChangeDesc4 = 17;
  clDeleteDesc1 = 18;
  clDeleteDesc2 = 19;
  clDeleteDesc3 = 20;
  clDeleteDesc4 = 21;

  C_RIGHT       = 1;
  C_LEFT        = 2;
  C_FLOATING    = 3;

  calReserved = -9999;
  calConfineOk= -9999;
// info ( intToStr(sizeOf(TClass_)) );
Type TClass_    = Record
                  id              : integer;
                  day             : TTimeStamp;
                  hour            : integer;
                  fill            : integer;
                  sub_id          : integer;
                  sub_abbreviation: string[30];
                  sub_name        : string[100];
                  sub_colour      : integer;
                  for_colour      : integer;
                  owner_colour    : integer;
                  creator_colour  : integer;
                  class_colour    : integer;
                  for_id          : integer;
                  for_abbreviation: string[30];
                  for_name        : string[30];
                  for_kind        : string[1];
                  calc_lecturers  : string; 
                  calc_groups     : string;
                  calc_rooms      : string;
                  calc_lec_ids    : string;
                  calc_gro_ids    : string;
                  calc_rom_ids    : string;
                  calc_rescat_ids : string;
                  created_by      : string[30];
                  owner           : string[255];
                  desc1           : string[255];
                  desc2           : string[255];
                  desc3           : string[255];
                  desc4           : string[255];
                 End;

Type TClassBy = procedure     (DAY1, DAY2 : String; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);

type TClassByChildCache = Class
                     Count    : Integer;
                     FirstDay : Integer;
                     MaxHours : integer;
                     // Data[0] - 1 dzieñ semestru, Data[1]- drugi itd.
                     Data : Array Of  //day
                             Array Of //hour
                               Record
                                Class_        : TClass_;
                                Status        : Integer;
                                Valid         : Boolean;
                               End;
                     dPER_ID : Integer;
                     dchildId : String;
                     d_SQL : String;
                     dHighData : integer;
                     dinitDone : String;
                     dResetByCLA_IDDone : String;
                     dResetByDayDone : String;
                     d_GetClassByDone : String;
                     dLastError : string;
                     private
                      //Procedure Add(TS : TTimeStamp; Zajecia: Integer; Var Status : Integer; Var Class_ : TClass_);
                      Procedure ccLoadPeriod(PER_ID : Integer; childId : String; _SQL : String; pres_type: string);
                      Procedure ccGetClass(TS : TTimeStamp; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_; ClassBy : TClassBy);
                     public
                      Procedure ResetByCLA_ID(CLA_ID : Integer; pday : ttimestamp; phour : integer);
                      Procedure ResetByDay(TS : TTimeStamp; Zajecia: Integer);
                   End;

type TClassByLecturerCaches
                           = class
                               maxLength : integer;
                               position  : integer;
                               PER_ID: Integer;
                               data : Array of record
                                 Cache : TClassByChildCache;
                                 childId : string;
                               end;

                               procedure init;
                               Procedure LgetClass(TS : TTimeStamp; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
                               Procedure loadPeriod(aPER_ID: Integer; childId : String; reloadFromDatabase : boolean);
                               Procedure resetByCLA_ID(CLA_ID : Integer; pday : ttimestamp; phour : integer);
                               Procedure resetByDay(TS : TTimeStamp; Zajecia: Integer);
                             end;

type TClassByGroupCaches = class
                               maxLength : integer;
                               position  : integer;
                               PER_ID: Integer;
                               data : Array of record
                                 GCache : TClassByChildCache;
                                 childId : string;
                               end;
                               procedure init;
                               Procedure getClass(TS : TTimeStamp; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
                               Procedure loadPeriod(aPER_ID: Integer; childId : String; reloadFromDatabase : boolean);
                               Procedure resetByCLA_ID(CLA_ID : Integer; pday : ttimestamp; phour : integer);
                               Procedure resetByDay(TS : TTimeStamp; Zajecia: Integer);
                             end;

type TClassByResCaches = class
                               maxLength : integer;
                               position  : integer;
                               PER_ID: Integer;
                               data : Array of record
                                 Cache : TClassByChildCache;
                                 childId : string;
                               end;
                               procedure init;
                               Procedure getClass(TS : TTimeStamp; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
                               Procedure loadPeriod(aPER_ID: Integer; childId : String; reloadFromDatabase : boolean);
                               Procedure resetByCLA_ID(CLA_ID : Integer; pday : ttimestamp; phour : integer);
                               Procedure resetByDay(TS : TTimeStamp; Zajecia: Integer);
                             end;
     TReservationsCache = Class
                     Count    : Integer;
                     FirstDay : Integer;
                     maxHours : integer;
                     // Data[0] - 1 dzieñ semestru, Data[1]- drugi itd.
                     Storage : Array Of Array Of String;

                     public
                      Procedure ReservationsCacheLoadPeriod(PER_ID : String);
                      Function IsReserved(TS: TTimeStamp; Zajecia : Integer) : String;
                      Procedure Invert(TS: TTimeStamp; Zajecia: Integer);

                     private
                      Procedure Init(aFirstDay, aCount, aMaxHours : Integer);
                   End;
     TotherCalendar = Class
                     Count    : Integer;
                     FirstDay : Integer;
                     maxHours : integer;
                     resId    : String;
                     // Data[0] - 1 dzieñ semestru, Data[1]- drugi itd.
                     Data : Array  Of
                             Array Of Integer;

                     private
                      Procedure LoadPeriod(PER_ID : String; presId : String);
                     public
                      Function getRatio(TS: TTimeStamp; Zajecia : Integer) : Integer;
                      Procedure setRatio(TS: TTimeStamp; Zajecia: Integer; ratio: integer);
                      Procedure Init(aFirstDay, aCount, aMaxHours : Integer);
                      Procedure Invert(TS: TTimeStamp; Zajecia: Integer);
                   End;

Type
     tBusyClassesCache = Class
                     Count    : Integer;
                     FirstDay : Integer;
                     Valid    : Boolean;
                     maxHours : integer;
                     // Data[0] - 1 dzieñ semestru, Data[1]- drugi itd.
                     global : Array Of
                             Array Of
                               Record
                                isBusy  : Boolean;
                                busyCnt : integer;
                                claIds  : string;
                               End;
                     ratio : Array Of
                             Array Of
                               Record
                                ratio        : integer;
                               End;
                     public
                      Procedure _LoadPeriod(PER_ID : Integer);
                      Procedure Init(aFirstDay, aCount, aMaxHours : Integer);
                      Procedure ClearCache;
                      procedure IsBusy(TS : TTimeStamp; Zajecia: Integer; var out_isbusy : boolean; var out_busycnt : integer; var out_ratio : integer; var out_claIds : string);
                      procedure SetRatio(TS: TTimeStamp; Zajecia: Integer; pratio : integer; pres_id : integer);
                      //Procedure ResetByCLA_ID(CLA_ID : Integer);
                      //Procedure ResetByDay(TS : TTimeStamp; Zajecia: Integer);
                   End;


TNodeInfo = class
  public
    Id: string;
  end;

type
  TFMain = class(TFormConfig)
    Holder: TStrHolder;
    BottomPanel: TPanel;
    MainPanel: TPanel;
    Temp: TStrHolder;
    MM: TMainMenu;
    Pomoc1: TMenuItem;
    Tkaninyinformacje1: TMenuItem;
    Plik1: TMenuItem;
    Zamknij1: TMenuItem;
    TopPanel: TPanel;
    LeftPanel: TPanel;
    TabViewType: TTabSet;
    StatusBar: TStatusBar;
    ConGroup: TEdit;
    CONGROUP_value: TEdit;
    conResCat0: TEdit;
    conResCat0_value: TEdit;
    LprofileObjectNameC1: TLabel;
    ConSubject: TEdit;
    CONSUBJECT_value: TEdit;
    Sowniki1: TMenuItem;
    mmprofileObjectNameR1s: TMenuItem;
    mmprofileObjectNameR2s: TMenuItem;
    RESOURCES: TMenuItem;
    mmprofileObjectNameC1s: TMenuItem;
    mmprofileObjectNameC2s: TMenuItem;
    mmprofileObjectNamePeriods: TMenuItem;
    Legend: TSpeedButton;
    bconflictspopup: TSpeedButton;
    zoomIn: TSpeedButton;
    zoomOut: TSpeedButton;
    Normal: TSpeedButton;
    bReports: TSpeedButton;
    BAddClass: TSpeedButton;
    BRefresh: TSpeedButton;
    Cofnij1: TMenuItem;
    Zapisz1: TMenuItem;
    N1: TMenuItem;
    BDeleteClass: TSpeedButton;
    BEditClass: TSpeedButton;
    N2: TMenuItem;
    Ustawieniaprogramu1: TMenuItem;
    mmprofileObjectNamePlanners: TMenuItem;
    Narzdzia1: TMenuItem;
    Uprawnieniadoobiektw1: TMenuItem;
    BLogin: TSpeedButton;
    Edycja1: TMenuItem;
    N3: TMenuItem;
    Odwiepolanadmiarowe1: TMenuItem;
    bwww: TSpeedButton;
    ConLecturer: TEdit;
    CONLECTURER_value: TEdit;
    ShowFreeTermsL: TCheckBox;
    ShowAllAnyL: TComboBox;
    LprofileObjectNamePeriod: TLabel;
    conPeriod: TEdit;
    conPeriod_VALUE: TEdit;
    ShowFreeTermsG: TCheckBox;
    ShowAllAnyG: TComboBox;
    ShowFreeTermsR: TCheckBox;
    ShowAllAnyResCat0: TComboBox;
    ValidL: TBitBtn;
    ValidG: TBitBtn;
    ValidR: TBitBtn;
    rorL: TBitBtn;
    rorG: TBitBtn;
    rorR: TBitBtn;
    LprofileObjectNameC2: TLabel;
    CONFORM: TEdit;
    CONFORM_VALUE: TEdit;
    RespectCompletions: TCheckBox;
    BViewByWeek: TSpeedButton;
    BViewByCrossTable: TSpeedButton;
    Widok1: TMenuItem;
    Ukadtygodniowy1: TMenuItem;
    Ukadtabelikrzyowej1: TMenuItem;
    N5: TMenuItem;
    mmplanL: TMenuItem;
    mmplanG: TMenuItem;
    mmplanR: TMenuItem;
    Czysty1: TMenuItem;
    Ustawieniaprogramu2: TMenuItem;
    N7: TMenuItem;
    Kategoriezasobw1: TMenuItem;
    Pobierzdanezpliku1: TMenuItem;
    Zapiszdanedopliku1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Legenda1: TMenuItem;
    Narzdzia2: TMenuItem;
    N4: TMenuItem;
    Statystyki1: TMenuItem;
    Penyprzegld1: TMenuItem;
    UtwrzwitrynWWW1: TMenuItem;
    Zalogujponownie1: TMenuItem;
    N10: TMenuItem;
    Dodaj2: TMenuItem;
    Zmie1: TMenuItem;
    Usu2: TMenuItem;
    N11: TMenuItem;
    Odwie1: TMenuItem;
    mmfreeLGR: TMenuItem;
    mmfreeLG: TMenuItem;
    mmfreeLR: TMenuItem;
    mmfreeGR: TMenuItem;
    mmfreeFooter: TMenuItem;
    powiksz1: TMenuItem;
    pomniejsz1: TMenuItem;
    N13: TMenuItem;
    LCONROLE_VALUE: TLabel;
    conRole: TEdit;
    conRole_VALUE: TEdit;
    MORG_UNITS: TMenuItem;
    FormFormulas: TMenuItem;
    Ustawieniakonfiguracyjne1: TMenuItem;
    N6: TMenuItem;
    mmconsolidation: TMenuItem;
    N14: TMenuItem;
    MMDiagram: TMenuItem;
    AutoSaver: TTimer;
    bmoveUp: TSpeedButton;
    bmoveDown: TSpeedButton;
    bmoveright: TSpeedButton;
    bmoveLeft: TSpeedButton;
    Zestawywarto1: TMenuItem;
    Listywarto1: TMenuItem;
    N18: TMenuItem;
    Zmiehas1: TMenuItem;
    Shape8a: TShape;
    Shape7a: TShape;
    Shape4a: TShape;
    Shape3a: TShape;
    Shape2a: TShape;
    Shape1a: TShape;
    bcopyarea: TSpeedButton;
    bcutarea: TSpeedButton;
    bpastearea: TSpeedButton;
    bclearselection: TSpeedButton;
    Shape9a: TShape;
    BFullScreen: TSpeedButton;
    Timer1: TTimer;
    DelPopup: TPopupMenu;
    ppDelete: TMenuItem;
    ppminusL: TMenuItem;
    ppminusG: TMenuItem;
    ppminusR: TMenuItem;
    EditPopup: TPopupMenu;
    MenuItem1: TMenuItem;
    ppaddL: TMenuItem;
    ppAddG: TMenuItem;
    ppAddR: TMenuItem;
    beditpopup: TSpeedButton;
    ppchangeS: TMenuItem;
    ppchangeF: TMenuItem;
    cmdattachLec: TMenuItem;
    N21: TMenuItem;
    N19: TMenuItem;
    N22: TMenuItem;
    N110: TMenuItem;
    N23: TMenuItem;
    Wszystkich1: TMenuItem;
    Wybranego1: TMenuItem;
    Wszystkie1: TMenuItem;
    Wybran1: TMenuItem;
    Wszystkir1: TMenuItem;
    Wybrany1: TMenuItem;
    ppChangeO: TMenuItem;
    ppminusS: TMenuItem;
    N15: TMenuItem;
    Kopiowaniegrupowe1: TMenuItem;
    mmpurge: TMenuItem;
    Atrybuty1: TMenuItem;
    N16: TMenuItem;
    ConflictsPopup: TPopupMenu;
    LGRpp: TMenuItem;
    LGpp: TMenuItem;
    LRpp: TMenuItem;
    GRpp: TMenuItem;
    ImageList: TImageList;
    FavouritePopup: TPopupMenu;
    N100Zdecydowanienieplanujwtymterminie1: TMenuItem;
    N100Zdecydowanieplanujwtymterminie1: TMenuItem;
    N000Terminneutrealny1: TMenuItem;
    N050Raczejnieplanujwtymterminie1: TMenuItem;
    N050Planujwtymterminie1: TMenuItem;
    FavIL: TImageList;
    Zdecydowanienieplanuj1: TMenuItem;
    Zdecydowanieplanuj1: TMenuItem;
    Nieplanuj1: TMenuItem;
    Lepiejplanuj1: TMenuItem;
    N17: TMenuItem;
    FavOff: TMenuItem;
    FavSelected: TMenuItem;
    FavAll: TMenuItem;
    Przej1: TMenuItem;
    Sprawddostpneaktualizacje1: TMenuItem;
    lecpopup: TPopupMenu;
    Wybierz1: TMenuItem;
    Dodaj1: TMenuItem;
    gropopup: TPopupMenu;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    respopup: TPopupMenu;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    ppchangeClass: TMenuItem;
    ColorDialog: TColorDialog;
    conResCat1: TEdit;
    conResCat1_value: TEdit;
    rorResCat1: TBitBtn;
    ShowFreeTermsResCat1: TCheckBox;
    ShowAllAnyResCat1: TComboBox;
    ValidResCat1: TBitBtn;
    ResCat1popup: TPopupMenu;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    Wicej1: TMenuItem;
    BRescat1: TSpeedButton;
    BRescat0: TSpeedButton;
    LprofileObjectNameL: TSpeedButton;
    LprofileObjectNameG: TSpeedButton;
    lshowAvail: TLabel;
    Shape1: TShape;
    gridFont: TFontDialog;
    pRightDockPanel: TPanel;
    VSplitter: TSplitter;
    Splitter1: TSplitter;
    pLeftDockPanel: TPanel;
    Kombinacjezasobw1: TMenuItem;
    Dozwolonekombinacjetypwzasobw1: TMenuItem;
    massImport: TMenuItem;
    Rejestracaus1: TMenuItem;
    XPManifest1: TXPManifest;
    BCopy: TSpeedButton;
    BPaste: TSpeedButton;
    Finanse1: TMenuItem;
    Osobyfizyczneiprawne1: TMenuItem;
    Partiedokumentw1: TMenuItem;
    Fakturyrachunkip1: TMenuItem;
    Liniedokumentw1: TMenuItem;
    Konfiguracja1: TMenuItem;
    EksportujdoGoogleKalendarz1: TMenuItem;
    Siatkagodzinowa1: TMenuItem;
    bdelpopup: TSpeedButton;
    BitBtnPER: TSpeedButton;
    selectl: TSpeedButton;
    selectg: TSpeedButton;
    selectr: TSpeedButton;
    selectResCat1: TSpeedButton;
    BitBtnROLE: TSpeedButton;
    BitBtnSUB: TSpeedButton;
    BitBtnFORM: TSpeedButton;
    BClearS: TSpeedButton;
    BitBtnCLEARROLE: TSpeedButton;
    BSelectComb: TSpeedButton;
    Listazajchistoriazmian1: TMenuItem;
    BTraceHistory: TSpeedButton;
    Wydrukiwukadzietygodnia1: TMenuItem;
    Zajciawgprzedmiotwukadtygodniowy1: TMenuItem;
    Zajciawgwykadowcwukadtygodniowy1: TMenuItem;
    Zajciawggrupukadtygodniowy1: TMenuItem;
    Zajciawgzasobwukadtygodniowy1: TMenuItem;
    Zajciawgformukadtygodniowy1: TMenuItem;
    Przedmiotyvswykladowcy1: TMenuItem;
    Przedmiotyvsgrupy1: TMenuItem;
    Przedmiotyvssale1: TMenuItem;
    Wykladowcyvsgrupy1: TMenuItem;
    Wykladowcyvssale1: TMenuItem;
    Grupyvssale1: TMenuItem;
    Innatabelaprzestawna1: TMenuItem;
    Kadyprzedmiotwoddzielnejtabeli1: TMenuItem;
    Jednatabeladlawszystkich1: TMenuItem;
    Kadywykadowcawoddzielnejtabeli1: TMenuItem;
    Kadagrupawoddzielnejtabeli1: TMenuItem;
    Kadyzasbwoddzielnejtabeli1: TMenuItem;
    Kadaformawoddzielnejtabeli1: TMenuItem;
    Jednatabeladlawszystkich2: TMenuItem;
    v1: TMenuItem;
    Jednatabeladlawszystkich3: TMenuItem;
    Jednatabeladlawszystkich4: TMenuItem;
    DBUpdates: TMemo;
    Wskanikiefektywnoci1: TMenuItem;
    Label2: TLabel;
    bthpopup: TSpeedButton;
    thPopup: TPopupMenu;
    MenuItem2: TMenuItem;
    MapaGooglezzasobami1: TMenuItem;
    GoogleMapEasy: TMenuItem;
    GoogleMapAdv: TMenuItem;
    SearchPanel: TPanel;
    TreeView1: TTreeView;
    Panel1: TPanel;
    SearchMenu: TEdit;
    SwitchMenu: TSpeedButton;
    FastQuery: TADOQuery;
    FastQueryString: TMemo;
    Splitter2: TSplitter;
    Penyekran1: TMenuItem;
    BFastSearchNew: TSpeedButton;
    pSearchMenuadd: TPopupMenu;
    Nowywykadowca1: TMenuItem;
    Nowagrupa1: TMenuItem;
    Nowyzasb1: TMenuItem;
    Nowyprzedmiot1: TMenuItem;
    Nowysemestr1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    BCloseApp: TSpeedButton;
    RefreshAfterOnShow: TTimer;
    Cdesc1: TMenuItem;
    Cdesc2: TMenuItem;
    Cdesc3: TMenuItem;
    Cdesc4: TMenuItem;
    Ddesc1: TMenuItem;
    Ddesc2: TMenuItem;
    Ddesc3: TMenuItem;
    Ddesc4: TMenuItem;
    FillPopup: TPopupMenu;
    FillAddIfEmpty: TMenuItem;
    FillAdd: TMenuItem;
    FillDelete: TMenuItem;
    Listzajzaznaczoneterminy1: TMenuItem;
    reportsPopup: TPopupMenu;
    Raportowaniezaawansowane1: TMenuItem;
    abelaprzestawna1: TMenuItem;
    wwwPopup: TPopupMenu;
    Utwrzwitrynwww2: TMenuItem;
    Szybkipodgld1: TMenuItem;
    EksportujdoGoogleKalendarz2: TMenuItem;
    WskanikiefektywnociwykresyGoogle1: TMenuItem;
    N12: TMenuItem;
    MapaGooglezzasobami3: TMenuItem;
    fastQueryGenericString: TMemo;
    gridPanel: TPanel;
    filterPanel: TPanel;
    Filter: TEdit;
    Grid: TDrawGrid;
    CustomPeriod: TComboBox;
    refreshFilter: TTimer;
    Generatorslajdw1: TMenuItem;
    Preferowaneterminy1: TMenuItem;
    N20: TMenuItem;
    Lista1: TMenuItem;
    DrawSuppressionS: TCheckBox;
    DrawSuppressionF: TCheckBox;
    Kalendarze1: TMenuItem;
    CalViewPanel: TPanel;
    LCal: TLabel;
    CALID_VALUE: TEdit;
    CALID: TEdit;
    L4: TLabel;
    tt_notes: TMemo;
    BShowCellLayout: TSpeedButton;
    PanelRecentlyUsed: TPanel;
    Splitter3: TSplitter;
    Panel2: TPanel;
    TreeRecentlyused: TTreeView;
    recentlyUsedQuery: TMemo;
    TreeMode: TComboBox;
    mostlyUsedQuery: TMemo;
    TopCntQuery: TMemo;
    TopCntPeriodQuery: TMemo;
    TreeModeCleanup: TSpeedButton;
    ppAddO: TMenuItem;
    ppminusO: TMenuItem;
    Przywr1: TMenuItem;
    Odczwybranego1: TMenuItem;
    Przywrckomunikaty1: TMenuItem;
    recreateDependencies: TMenuItem;
    ReservationType: TEdit;
    LabelReservationType: TLabel;
    Preview: TSpeedButton;
    procedure Tkaninyinformacje1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BDICTLECClick(Sender: TObject);
    procedure BDICTGROClick(Sender: TObject);
    procedure BDICTSUBClick(Sender: TObject);
    procedure BDICTFORClick(Sender: TObject);
    procedure BDICTPERClick(Sender: TObject);
    procedure ConLecturerChange(Sender: TObject);
    procedure ConGroupChange(Sender: TObject);
    procedure conResCat0Change(Sender: TObject);
    procedure ConSubjectChange(Sender: TObject);
    procedure conPeriodChange(Sender: TObject);
    procedure zoomInClick(Sender: TObject);
    procedure zoomOutClick(Sender: TObject);
    procedure NormalClick(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BAddClassClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure Cofnij1Click(Sender: TObject);
    procedure Zapisz1Click(Sender: TObject);
    procedure GridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TabViewTypeClick(Sender: TObject);
    procedure BDeleteClassClick(Sender: TObject);
    procedure Rodzajerezerwacji1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LegendClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BEditClassClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure D1Change(Sender: TObject);
    procedure Ustawieniaprogramu1Click(Sender: TObject);
    procedure mmprofileObjectNamePlannersClick(Sender: TObject);
    procedure Uprawnieniadoobiektw1Click(Sender: TObject);
    procedure BLoginClick(Sender: TObject);
    procedure Odwiepolanadmiarowe1Click(Sender: TObject);
    procedure Zamknij1Click(Sender: TObject);
    procedure ValidLClick(Sender: TObject);
    procedure ValidGClick(Sender: TObject);
    procedure ValidRClick(Sender: TObject);
    procedure CONLECTURER_valueExit(Sender: TObject);
    procedure CONGROUP_valueExit(Sender: TObject);
    procedure conResCat0_valueExit(Sender: TObject);
    procedure ShowFreeTermsLClick(Sender: TObject);
    procedure CONLECTURER_valueEnter(Sender: TObject);
    procedure CONGROUP_valueEnter(Sender: TObject);
    procedure conResCat0_valueEnter(Sender: TObject);
    procedure rorLClick(Sender: TObject);
    procedure rorGClick(Sender: TObject);
    procedure rorRClick(Sender: TObject);
    procedure ConFormChange(Sender: TObject);
    procedure CONLECTURER_valueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CONGROUP_valueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure conResCat0_valueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Ukadtygodniowy1Click(Sender: TObject);
    procedure Ukadtabelikrzyowej1Click(Sender: TObject);
    procedure mmplanLClick(Sender: TObject);
    procedure mmplanGClick(Sender: TObject);
    procedure mmplanRClick(Sender: TObject);
    procedure Czysty1Click(Sender: TObject);
    procedure BViewByWeekClick(Sender: TObject);
    procedure BViewByCrossTableClick(Sender: TObject);
    procedure Ustawieniaprogramu2Click(Sender: TObject);
    procedure Kategoriezasobw1Click(Sender: TObject);
    procedure RESOURCESClick(Sender: TObject);
    procedure Pobierzdanezpliku1Click(Sender: TObject);
    procedure Zapiszdanedopliku1Click(Sender: TObject);
    procedure Legenda1Click(Sender: TObject);
    procedure Statystyki1Click(Sender: TObject);
    procedure Penyprzegld1Click(Sender: TObject);
    procedure UtwrzwitrynWWW1Click(Sender: TObject);
    procedure Zalogujponownie1Click(Sender: TObject);
    procedure Dodaj2Click(Sender: TObject);
    procedure Zmie1Click(Sender: TObject);
    procedure Usu2Click(Sender: TObject);
    procedure mmfreeLGRClick(
      Sender: TObject);
    procedure mmfreeLGClick(Sender: TObject);
    procedure mmfreeLRClick(Sender: TObject);
    procedure mmfreeGRClick(Sender: TObject);
    procedure powiksz1Click(Sender: TObject);
    procedure pomniejsz1Click(Sender: TObject);
    procedure CONLECTURER_valueDblClick(Sender: TObject);
    procedure CONGROUP_valueDblClick(Sender: TObject);
    procedure conResCat0_valueDblClick(Sender: TObject);
    procedure CONSUBJECT_valueDblClick(Sender: TObject);
    procedure ConForm_VALUEDblClick(Sender: TObject);
    procedure conRoleChange(Sender: TObject);
    procedure conPeriod_VALUEDblClick(Sender: TObject);
    procedure conRole_VALUEDblClick(Sender: TObject);
    procedure MORG_UNITSClick(Sender: TObject);
    procedure FormFormulasClick(Sender: TObject);
    procedure Ustawieniakonfiguracyjne1Click(Sender: TObject);
    procedure mmconsolidationClick(Sender: TObject);
    procedure MMDiagramClick(Sender: TObject);
    procedure AutoSaverTimer(Sender: TObject);
    procedure bmoveUpClick(Sender: TObject);
    procedure bmoveDownClick(Sender: TObject);
    procedure bmoveLeftClick(Sender: TObject);
    procedure bmoverightClick(Sender: TObject);
    procedure Zestawywarto1Click(Sender: TObject);
    procedure Listywarto1Click(Sender: TObject);
    procedure Zmiehas1Click(Sender: TObject);
    procedure BAddClassMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TimerShapesEngineTimer(Sender: TObject);
    procedure BViewByWeekMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure bconflictspopupMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure zoomInMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BIMPMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure bmoveLeftMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bcopyareaClick(Sender: TObject);
    procedure bcutareaClick(Sender: TObject);
    procedure bpasteareaClick(Sender: TObject);
    procedure bclearselectionClick(Sender: TObject);
    procedure bcopyareaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure BFullScreenClick(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure ppDeleteClick(Sender: TObject);
    procedure bdelpopupClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure ppchangeSClick(Sender: TObject);
    procedure ppchangeFClick(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure cmdattachLecClick(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N110Click(Sender: TObject);
    procedure Wszystkich1Click(Sender: TObject);
    procedure Wybranego1Click(Sender: TObject);
    procedure Wszystkie1Click(Sender: TObject);
    procedure Wybran1Click(Sender: TObject);
    procedure Wszystkir1Click(Sender: TObject);
    procedure Wybrany1Click(Sender: TObject);
    procedure ppChangeOClick(Sender: TObject);
    procedure ppminusSClick(Sender: TObject);
    procedure Kopiowaniegrupowe1Click(Sender: TObject);
    procedure mmpurgeClick(Sender: TObject);
    procedure Atrybuty1Click(Sender: TObject);
    procedure LegendMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LGRppClick(
      Sender: TObject);
    procedure LGppClick(Sender: TObject);
    procedure LRppClick(Sender: TObject);
    procedure GRppClick(Sender: TObject);
    procedure GridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N100Zdecydowanienieplanujwtymterminie1Click(Sender: TObject);
    procedure N100Zdecydowanieplanujwtymterminie1Click(Sender: TObject);
    procedure N000Terminneutrealny1Click(Sender: TObject);
    procedure N050Raczejnieplanujwtymterminie1Click(Sender: TObject);
    procedure N050Planujwtymterminie1Click(Sender: TObject);
    procedure Zdecydowanienieplanuj1Click(Sender: TObject);
    procedure Nieplanuj1Click(Sender: TObject);
    procedure Lepiejplanuj1Click(Sender: TObject);
    procedure Zdecydowanieplanuj1Click(Sender: TObject);
    procedure FavSelectedClick(Sender: TObject);
    procedure FavOffClick(Sender: TObject);
    procedure FavAllClick(Sender: TObject);
    procedure Przej1Click(Sender: TObject);
    procedure Sprawddostpneaktualizacje1Click(Sender: TObject);
    procedure Wybierz1Click(Sender: TObject);
    procedure Dodaj1Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure ppchangeClassClick(Sender: TObject);
    procedure conResCat1Change(Sender: TObject);
    procedure conResCat1_valueDblClick(Sender: TObject);
    procedure conResCat1_valueEnter(Sender: TObject);
    procedure conResCat1_valueExit(Sender: TObject);
    procedure ValidResCat1Click(Sender: TObject);
    procedure conResCat1_valueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure rorResCat1Click(Sender: TObject);
    procedure Wicej1Click(Sender: TObject);
    procedure BRescat1Click(Sender: TObject);
    procedure ForceCellHeightClick(Sender: TObject);
    procedure BRescat0Click(Sender: TObject);
    procedure gridFontApply(Sender: TObject; Wnd: HWND);
    procedure ForcedCellHeightChange(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure GridMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure GridMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure pRightDockPanelUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure pRightDockPanelDockDrop(Sender: TObject; Source: TDragDockObject;
      X, Y: Integer);
    procedure pRightDockPanelResize(Sender: TObject);
    procedure Kombinacjezasobw1Click(Sender: TObject);
    procedure Dozwolonekombinacjetypwzasobw1Click(Sender: TObject);
    procedure ColoringChange(Sender: TObject);
    procedure massImportClick(Sender: TObject);
    procedure Rejestracaus1Click(Sender: TObject);
    procedure BCopyClick(Sender: TObject);
    procedure BPasteClick(Sender: TObject);
    procedure BCellResetClick(Sender: TObject);
    procedure BCellFontClick(Sender: TObject);
    procedure Osobyfizyczneiprawne1Click(Sender: TObject);
    procedure Partiedokumentw1Click(Sender: TObject);
    procedure Fakturyrachunkip1Click(Sender: TObject);
    procedure Liniedokumentw1Click(Sender: TObject);
    procedure Konfiguracja1Click(Sender: TObject);
    procedure EksportujdoGoogleKalendarz1Click(Sender: TObject);
    procedure Siatkagodzinowa1Click(Sender: TObject);
    procedure BitBtnPERClick(Sender: TObject);
    procedure BitBtnROLEClick(Sender: TObject);
    procedure BitBtnSUBClick(Sender: TObject);
    procedure BitBtnFORMClick(Sender: TObject);
    procedure BClearSClick(Sender: TObject);
    procedure BitBtnCLEARROLEClick(Sender: TObject);
    procedure BSelectCombClick(Sender: TObject);
    procedure Listazajchistoriazmian1Click(Sender: TObject);
    procedure BTraceHistoryClick(Sender: TObject);
    procedure Przedmiotyvswykladowcy1Click(Sender: TObject);
    procedure Przedmiotyvsgrupy1Click(Sender: TObject);
    procedure Przedmiotyvssale1Click(Sender: TObject);
    procedure Wykladowcyvsgrupy1Click(Sender: TObject);
    procedure Wykladowcyvssale1Click(Sender: TObject);
    procedure Grupyvssale1Click(Sender: TObject);
    procedure Kadyprzedmiotwoddzielnejtabeli1Click(Sender: TObject);
    procedure Jednatabeladlawszystkich1Click(Sender: TObject);
    procedure Kadywykadowcawoddzielnejtabeli1Click(Sender: TObject);
    procedure Jednatabeladlawszystkich2Click(Sender: TObject);
    procedure Kadagrupawoddzielnejtabeli1Click(Sender: TObject);
    procedure v1Click(Sender: TObject);
    procedure Kadyzasbwoddzielnejtabeli1Click(Sender: TObject);
    procedure Jednatabeladlawszystkich3Click(Sender: TObject);
    procedure Kadaformawoddzielnejtabeli1Click(Sender: TObject);
    procedure Jednatabeladlawszystkich4Click(Sender: TObject);
    procedure Innatabelaprzestawna1Click(Sender: TObject);
    procedure Wskanikiefektywnoci1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure GoogleMapEasyClick(Sender: TObject);
    procedure GoogleMapAdvClick(Sender: TObject);
    procedure CONLECTURER_valueClick(Sender: TObject);
    procedure CONGROUP_valueClick(Sender: TObject);
    procedure conResCat0_valueClick(Sender: TObject);
    procedure conResCat1_valueClick(Sender: TObject);
    procedure CONSUBJECT_valueClick(Sender: TObject);
    procedure CONFORM_VALUEClick(Sender: TObject);
    procedure selectlClick(Sender: TObject);
    procedure selectgClick(Sender: TObject);
    procedure selectrClick(Sender: TObject);
    procedure selectResCat1Click(Sender: TObject);
    procedure CONPERIOD_VALUEClick(Sender: TObject);
    procedure CONROLE_VALUEClick(Sender: TObject);
    procedure SearchMenuChange(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure SwitchMenuClick(Sender: TObject);
    procedure Penyekran1Click(Sender: TObject);
    procedure BFastSearchNewClick(Sender: TObject);
    procedure Nowywykadowca1Click(Sender: TObject);
    procedure Nowagrupa1Click(Sender: TObject);
    procedure Nowyprzedmiot1Click(Sender: TObject);
    procedure Nowysemestr1Click(Sender: TObject);
    procedure Nowyzasb1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BCloseAppClick(Sender: TObject);
    procedure RefreshAfterOnShowTimer(Sender: TObject);
    procedure Cdesc1Click(Sender: TObject);
    procedure Cdesc2Click(Sender: TObject);
    procedure Cdesc3Click(Sender: TObject);
    procedure Cdesc4Click(Sender: TObject);
    procedure Ddesc1Click(Sender: TObject);
    procedure Ddesc2Click(Sender: TObject);
    procedure Ddesc3Click(Sender: TObject);
    procedure Ddesc4Click(Sender: TObject);
    procedure Listzajzaznaczoneterminy1Click(Sender: TObject);
    procedure abelaprzestawna1Click(Sender: TObject);
    procedure Raportowaniezaawansowane1Click(Sender: TObject);
    procedure Utwrzwitrynwww2Click(Sender: TObject);
    procedure EksportujdoGoogleKalendarz2Click(Sender: TObject);
    procedure WskanikiefektywnociwykresyGoogle1Click(Sender: TObject);
    procedure MapaGooglezzasobami3Click(Sender: TObject);
    procedure FilterChange(Sender: TObject);
    procedure CustomPeriodChange(Sender: TObject);
    procedure refreshFilterTimer(Sender: TObject);
    procedure Generatorslajdw1Click(Sender: TObject);
    procedure Preferowaneterminy1Click(Sender: TObject);
    procedure Lista1Click(Sender: TObject);
    procedure DrawSuppressionSClick(Sender: TObject);
    procedure Kalendarze1Click(Sender: TObject);
    procedure CALID_VALUEClick(Sender: TObject);
    procedure CALIDChange(Sender: TObject);
    procedure TabViewTypeChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure LeftPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LeftPanelClick(Sender: TObject);
    procedure GridClick(Sender: TObject);
    procedure TreeModeChange(Sender: TObject);
    procedure SearchMenuClick(Sender: TObject);
    procedure SearchMenuExit(Sender: TObject);
    procedure TreeModeCleanupClick(Sender: TObject);
    procedure BShowCellLayoutClick(Sender: TObject);
    procedure BShowCellLayoutMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure BAddClassDblClick(Sender: TObject);
    procedure ppAddOClick(Sender: TObject);
    procedure Przywr1Click(Sender: TObject);
    procedure Odczwybranego1Click(Sender: TObject);
    procedure Przywrckomunikaty1Click(Sender: TObject);
    procedure recreateDependenciesClick(Sender: TObject);
    procedure PreviewClick(Sender: TObject);
  private
    CanShow   : boolean;
    resizeMode: boolean;
    timerShapes : integer;
    GridSelectionLeft : integer;
    GridSelectionRight : integer;
    GridSelectionTop : integer;
    GridSelectionBottom : integer;
    GridSelectionMode   : integer;
    StartUp : boolean;
    dockingPanel  : integer;
    SearchCounter   : Integer;
    userLogged : boolean;
    ignoreEvents : boolean;
    Procedure start;
    Procedure stop;
    Procedure refreshGrid;
    procedure setPeriod;
    Procedure fillPanel(Col, Row: Integer);
    Procedure setVisibles;
    Function  getClassByRowCol(Col, Row: Integer; Var Class_ : TClass_ ) : Integer;
    Function  logon : Boolean;
    procedure refreshPanels;
    procedure setActiveShape( no : integer);
    //procedure UpdateSoftware;
    procedure _selectl (clearList : boolean);
    procedure _selectg (clearList : boolean);
    procedure _selectr (clearList : boolean);
    procedure _selectResCat1 (clearList : boolean);
    procedure onpResCatId1Change;
    procedure onpResCatId0Change;
    procedure saveFormSettings;
    procedure loadFormSettings;
    procedure GenerateWWW(pgentype : integer);
    procedure commandLineWwwGenerator (inifilename : string);
    procedure commandLineGrouping     (inifilename : string);
    Procedure addDBItemsItemsToTreeView(aTreeview: TTreeview; aFilter : string);
    procedure updateLeftPanel;
  public
    MapLecNames : TMap;
    MapLecColors : TMap;
    MapGroColors : TMap;
    MapRomColors : TMap;
    MapPlanners  : TMap;
    MapPlannerSupervisors : TMap;
    silentMode : boolean;
    AObjectId : integer;
    classForEdition : integer;

    disableFurtherActivities : boolean;
    currSelectedArea : string[50]; //user by procedure set_tmp_selected_dates
    //
    ClassByLecturerCaches : tClassByLecturerCaches;
    ClassByGroupCaches    : tClassByGroupCaches;
    ClassByRoomCaches     : tClassByResCaches;
    ClassByResCat1Caches  : tClassByResCaches;
    ReservationsCache     : tReservationsCache;
    otherCalendar         : tOtherCalendar;
    confineCalendar       : tOtherCalendar;
    BusyClassesCache      : tBusyClassesCache;
    //
    trackHistoryInstalled : boolean;
    MouseOverLeftPanel : boolean;
    AutoSaveCounterDown : integer;
    procedure setHistoryEnabled;
    function  getCurrentObjectId : integer;
    function  getCurrentObjectType : string;

    procedure refreshLegend;
    Procedure buildCalendar(triggeredObject : String);
    procedure buildMenu;
    function  getUserOrRoleID : string;

    procedure insertClasses;
    procedure invertReservations;
    procedure invertOtherCalendar;
    procedure SetRatio ( pratio : integer);
    procedure set_tmp_selected_dates;


    //Operacje grupowe
      //funkcje generyczne
    function  modifyClass   (col, row, deltaX, deltaY : integer;
                             operation : integer;
                             keyValue : shortString;                // applies to clAttach* only
                             keyValueDsp : shortString;
                             var succesFlag : boolean;              // succesFlag = false means modification was not allowed, but go on
                             const exitIfAnyExists : boolean = true // applies to clAttach* only
                             ) : boolean;                           // result = false means error
    procedure modifyClasses ( deltaX, deltaY : integer;  // applies to clMove, clCopy, clPaste
                              operation : integer;
                              keyValue : shortString;
                              keyValueDsp : shortString;
                              const exitIfAnyExists : boolean = true  );
      //funkcje szczegolowe ( korzystaja z funkcji generycznych )
    procedure copyArea;
    procedure cutArea;
    procedure pasteArea;
    procedure clearSelection;
    procedure deleteLecFromSelection (unplugAll : boolean);
    procedure deleteGroFromSelection (unplugAll : boolean);
    procedure deleteResFromSelection (unplugAll : boolean);
    procedure deleteOwnerFromSelection (unplugAll : boolean);
    procedure attachLec (exitIfAnyExists : boolean);
    procedure attachGro (exitIfAnyExists : boolean);
    procedure attachRes (exitIfAnyExists : boolean);
    procedure attachOwner;
    procedure changeSub;
    procedure changeFor;
    procedure changeOwner;
    procedure changeCColor;
    procedure changeDesc(i : integer);
    procedure deleteSubFromSelection;
    procedure deleteDescFromSelection(i : integer);
    procedure showAvailableTerms;
    procedure setupFillButton;
    procedure showClasses(ignoreLgr, selectedDatesOnly : boolean);
    function getWhereFastFilter(filter, tableName : string) : string;
    Procedure refreshRecentlyUsed(aFilter : string);
    procedure UpsertRecentlyUsed(presId : String; presType : String);
    procedure AddClassToGrid(firstResourceFlag : boolean);
    procedure OpenFGrouping(resourceType : String; resourceId : String);
  end;

var
  FMain: TFMain;
  // passing parameters via procedure worked sometimes badly !
  dummyTS : TTimeStamp;
  dummyHour : Integer;

Procedure DBGetClassByLecturer(DAY1, DAY2 : String; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
Procedure DBGetClassByGroup   (DAY1, DAY2 : String; Zajecia: Integer; GRO_ID        : String; Var Status : Integer; Var Class_ : TClass_);
Procedure DBGetClassByRoom    (DAY1, DAY2 : String; Zajecia: Integer; ROM_ID        : String; Var Status : Integer; Var Class_ : TClass_);

var
    TS : TTimeStamp;
    Zajecia : Integer;
    HOURS_PER_DAY         : integer;

implementation

{$R *.DFM}

Uses AutoCreate, UFDetails,
  UFShowConflicts, UFLegend, UFGrouping, UFSettings, UFPlannerPermissions,
  UFWWWGenerator, UFExp, UFImp, UFLookupWindow,
  UFProgramSettings, UFChangePassword, UFToolWindow,
  UFCopyClasses, UFPurgeData, UFprogressBar, UUtilities, UFTTCheckResults,
  UFTTCombinations, UFMassImport, UFAbolitionTime, inifiles, UFMatrix,
  UFGoogleMap, UFDatesSelector, UFSlideshowGenerator, UFActionTree,
  UFCellLayout, UFListOrganizer;

var dummy : string;


{ -------------------------------------------------------------------------------------------------------------------------------------------- }


Procedure tBusyClassesCache.Init;
Var t: Integer;
Begin
  MaxHours := aMaxHours;
  SetLength(global, aCount);       // inicjuje dlugosc tabeli dynamicznej ...
  SetLength(ratio, aCount);       // inicjuje dlugosc tabeli dynamicznej ...
  for t := 0 to aCount -1 do begin  // ... i to samo dla kazdej tabeli zagniezdzonej
    setLength(global[t], MaxHours+1);
    setLength(ratio[t], MaxHours+1);
  end;

  FirstDay := aFirstDay;
  Count    := aCount;

 {For t := 0 To Count-1 Do
  For t2 := 1 To MaxHours Do
    Data[t][t2].Valid := False;  }
 Valid := False;
End;

procedure tBusyClassesCache.IsBusy(TS : TTimeStamp; Zajecia: Integer; var out_isbusy : boolean; var out_busyCnt : integer; var out_ratio : integer; var out_claIds : string);
Var t1 : Integer;
Begin
 If Not Valid then
   _LoadPeriod( StrToInt(NVL(FMain.conPeriod.text,'-1')));

 t1 := TS.Date - FirstDay;
 out_isbusy  := global[t1][Zajecia].isBusy;
 out_busyCnt := global[t1][Zajecia].busyCnt;
 out_ratio   := ratio[t1][Zajecia].ratio;
 out_claIds  := global[t1][Zajecia].claids;
End;


procedure tBusyClassesCache._LoadPeriod(PER_ID: Integer);
Var t : Integer;
    DateFrom, DateTo : String;
    X, Y : Integer;
    LecCond, GroCond, RomCond, ResCat1Cond : String;
    NotLec, NotGro, NotRom : String;
    Operator, comment1, comment2 : String;
    ids : string;
    SQLstmt : string;
    firstDay : integer;
    periodClause : string;

Var L1, L2 : Integer;
begin
  If (PER_ID = 0) Or (PER_ID = -1) Then Info('(PER_ID = 0) Or (PER_ID = -1)');

  With DModule Do Begin
   Dmodule.SingleValue(CustomdateRange('SELECT TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD''), date_to-date_from, DATE_FROM, HOURS_PER_DAY FROM PERIODS WHERE ID='+IntToStr(PER_ID)));
   DateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
   DateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';
   Count    :=  QWork.Fields[2].AsInteger+1;
   //info (  IntToStr(PER_ID) +'#'+ QWork.Fields[2].AsString ) ;
   firstDay := DateTimeToTimeStamp(QWork.Fields[3].AsDateTime).Date;
   periodClause := format('DAY BETWEEN %s AND %s', [DateFrom, DateTo]);

   Init(firstDay, Count, QWork.FieldByName('HOURS_PER_DAY').AsInteger);

   FirstDay := DateTimeToTimeStamp(QWork.Fields[3].AsDateTime).Date;

   For L1 := 0 To Count -1 Do Begin
     For L2 := 1 To MaxHours Do Begin
       global[L1][L2].isBusy := False;
       global[L1][L2].busyCnt:= 0;
       ratio[L1][L2].ratio   := 0;
       global[L1][L2].claIds := '';
      End;
   End;
  //0 wolny termin dla wszystkich     => dopelnienie:  zajety dla ktoregokolwiek = zajety w1 or zajety w2 or ...
  //1 wolny termin dla któregokolwiek => dopelnienie: zajety termin dla wszystkich= zajety w1 and  zajety w2 and ...
  with FMain Do Begin

    LecCond := '';
    if ShowAllAnyL.ItemIndex = 0 then Operator := ' OR ' else Operator := ' AND ';
    If (not ShowFreeTermsL.Checked) or (WordCount(FMain.ConLecturer.Text,[';']) = 0) Then {}
    else
      for t := 1 To WordCount(FMain.ConLecturer.Text,[';']) Do
        LecCond:= Merge(LecCond, 'lec_id='+ExtractWord(t,FMain.ConLecturer.Text,[';']), Operator);

    GroCond := '';
    if ShowAllAnyG.ItemIndex = 0 then Operator := ' OR ' else Operator := ' AND ';
    If (not ShowFreeTermsG.Checked) or (WordCount(FMain.ConGroup.Text,[';']) = 0) Then {}
    else
      for t := 1 To WordCount(FMain.ConGroup.Text,[';']) Do
        GroCond:= Merge(GroCond, 'gro_id='+ExtractWord(t,FMain.ConGroup.Text,[';']), Operator); // ten zapis oznacza: prawda gdy group ma zaplanowane rekordy w tym terminie

    RomCond := '';
    if ShowAllAnyResCat0.ItemIndex = 0 then Operator := ' OR ' else Operator := ' AND ';
    If (not ShowFreeTermsR.Checked) or (WordCount(FMain.conResCat0.Text,[';']) = 0) Then {}
    else
      for t := 1 To WordCount(FMain.conResCat0.Text,[';']) Do
        RomCond:= Merge(RomCond, 'rom_id='+ExtractWord(t,FMain.conResCat0.Text,[';']), Operator); // ten zapis oznacza: prawda gdy room ma zaplanowane rekordy w tym terminie

    ResCat1Cond := '';
    if ShowAllAnyResCat1.ItemIndex = 0 then Operator := ' OR ' else Operator := ' AND ';
    If (not ShowFreeTermsResCat1.Checked) or (WordCount(FMain.CONResCat1.Text,[';']) = 0) Then {}
    else
      for t := 1 To WordCount(FMain.CONResCat1.Text,[';']) Do
        ResCat1Cond:= Merge(ResCat1Cond, 'rom_id='+ExtractWord(t,FMain.ConResCat1.Text,[';']), Operator); // ten zapis oznacza: prawda gdy ResCat1 ma zaplanowane rekordy w tym terminie

  End;

   NotLec    := '';
   NotGro    := '';
   NotRom    := '';
  if FMain.RespectCompletions.Checked then begin
   comment1 := '--';
   comment2 := '--';
   for t := 1 To WordCount(FMain.ConLecturer.Text,[';']) Do
     NotLec:= Merge(NotLec, 'lec_id<>'+ExtractWord(t,FMain.ConLecturer.Text,[';']), ' and ');
   for t := 1 To WordCount(FMain.ConGroup.Text,[';']) Do
     NotGro:= Merge(NotGro, 'gro_id<>'+ExtractWord(t,FMain.ConGroup.Text,[';']), ' and ');
   for t := 1 To WordCount(FMain.conResCat0.Text,[';']) Do
     NotRom:= Merge(NotRom, 'rom_id<>'+ExtractWord(t,FMain.conResCat0.Text,[';']), ' and ');
   for t := 1 To WordCount(FMain.CONResCat1.Text,[';']) Do
     NotRom:= Merge(NotRom, 'rom_id<>'+ExtractWord(t,FMain.CONResCat1.Text,[';']) , ' and ');
  end else begin
   comment1  := '/*';
   comment2  := '*/';
   //variables have no meaning, statement will be commented
  end;

  SQLstmt :=
   'select classes.id, calc_lecturers, calc_groups, calc_rooms, sub.name sub_name, form.name for_name, day, hour, count(1) cnt'+cr+
   iif(LecCond='',',0 cntL'    ,',(select count(1) from lec_cla where cla_id=classes.id and no_conflict_flag is null and '+periodClause+' and ('+LecCond+')) cntL')+cr+
   iif(GroCond='',',0 cntG'    ,',(select count(1) from gro_cla where cla_id=classes.id and no_conflict_flag is null and '+periodClause+' and ('+GroCond+')) cntG')+cr+
   iif(RomCond='',',0 cntR'    ,',(select count(1) from rom_cla where cla_id=classes.id and no_conflict_flag is null and '+periodClause+' and ('+RomCond+'))  cntR')+cr+
   iif(ResCat1Cond='',',0 cntR2',',(select count(1) from rom_cla where cla_id=classes.id and no_conflict_flag is null and '+periodClause+' and ('+ResCat1Cond+')) cntR2')+cr+
   'from   classes, subjects sub, forms form'+cr+
   'where sub_id=sub.id(+) and for_id=form.id(+) and classes.id in'+cr+
   '('+cr+
   'select -1 from dual'+cr+
   iif(LecCond='',''    ,'union select cla_id from lec_cla where no_conflict_flag is null and '+periodClause+' and ('+LecCond+')'+cr)+
   iif(GroCond='',''    ,'union select cla_id from gro_cla where no_conflict_flag is null and '+periodClause+' and ('+GroCond+')'+cr)+
   iif(RomCond='',''    ,'union select cla_id from rom_cla where no_conflict_flag is null and '+periodClause+' and ('+RomCond+')'+cr)+
   iif(ResCat1Cond='','','union select cla_id from rom_cla where no_conflict_flag is null and '+periodClause+' and ('+ResCat1Cond+')'+cr)+
   ')'+cr+
   // i nie jest uzupe³nieniem
   comment1+cr+
   'and classes.id in'+cr+
   '('+cr+
   'select id from classes where '+periodClause+' and (sub_id<>'+NVL(FMain.ConSubject.Text,'-1')+' or for_id<>'+NVL(FMain.ConForm.Text,'-1')+' or owner<>'''+CurrentUserName+''')'+cr+
   iif(NotLec='','','union select cla_id from lec_cla where no_conflict_flag is null and '+periodClause+' and '+NotLec+cr)+
   iif(NotGro='','','union select cla_id from gro_cla where no_conflict_flag is null and '+periodClause+' and '+NotGro+cr)+
   iif(NotRom='','','union select cla_id from rom_cla where no_conflict_flag is null and '+periodClause+' and '+NotRom+cr)+
   ')'+cr+
   comment2+cr
   +' group by classes.id, calc_lecturers, calc_groups, calc_rooms, sub.name, form.name, day, hour';

   //copyToClipboard(SQLstmt);
   openSQL ( SQLstmt );

    While Not QWork.EOF Do Begin
     X := DateTimeToTimeStamp(QWork.FieldByName('DAY').AsDateTime).Date;
     Y := QWork.FieldByName('HOUR').AsInteger;

     t := X-FirstDay;

     if  (t < 0) or (t >high(global)) then
         SError('Wyst¹pi³o zdarzenie "1 Liczba dni poza zakresem". Zg³oœ problem serwisowi, lub usuñ b³êdne rekordy za pomoc¹ formularza Lista zajêæ '+
         't='+inttostr(t)+
         ' high(global)='+inttostr(high(global))+
         ' X='+inttostr(x)+
         ' FirstDay='+inttostr(FirstDay)
         ) else
     if  (y < 1) or (y >MaxHours) then //Warning('Zaplanowana liczba godzin ( wartoœæ '+inttostr(y)+') jest wiêksza, ni¿ liczba godzin zdefiniowana dla semestru. Powoduje to, ¿e czêœæ zaplanowanych rekordow nie pojawia siê na ekranie. Mo¿liwe rozwi¹zania problemu: ' + '1. Zwiêksz liczbê godzin w definicji dla semestru lub 2. Usuñ b³êdne rekordy za pomoc¹ formularza Lista Zajêæ lub 3. Przeka¿ opis problemu serwisowi')
     else begin
       global[t][y].isBusy := True;
       global[t][y].busyCnt := global[t][y].busyCnt + QWork.FieldByName('cnt').AsInteger;
       global[t][y].claIds  := merge(global[t][y].claIds,
           '['+iif(QWork.FieldByName('cntL').AsInteger>0,'W','')+
           iif(QWork.FieldByName('cntG').AsInteger>0,'G','')+
           iif(QWork.FieldByName('cntR').AsInteger>0,'S','')+
           iif(QWork.FieldByName('cntr2').AsInteger>0,'Z','')+'] '+
           QWork.FieldByName('sub_name').AsString+' '+
           ' ('+QWork.FieldByName('for_name').AsString+' '+
           ')    '+fprogramsettings.profileObjectNameLs.text+':'+QWork.FieldByName('calc_lecturers').AsString+' '+
           '    '+fprogramsettings.profileObjectNameGs.text+':'+QWork.FieldByName('calc_groups').AsString+' '+
           '    Zasoby:'+QWork.FieldByName('calc_rooms').AsString,cr);
     end;

     QWork.Next;
    End;

    if not fmain.FavOff.Checked then
    begin
    ids :=  merge(
              merge( replace(FMain.ConLecturer.Text,';',',') , replace(FMain.ConGroup.Text,';',','), ',')
             ,replace(FMain.conResCat0.Text,';',',')
             ,','
            );
    if ids <> '' then begin
      openSQL (
       'select day, hour, min(ratio) ratio '+ //get worst ratio
         'from res_hints '+
         'where '+periodClause + ' '+
           'and res_id in ('+ids+') '+
           iif( (fmain.FavSelected.Checked )and (fmain.getCurrentObjectId <>-1), ' and res_id='+ intToStr(fmain.getCurrentObjectId) + ' ','')+
       'group by day, hour ');
      While Not QWork.EOF Do Begin
       X := DateTimeToTimeStamp(QWork.FieldByName('DAY').AsDateTime).Date;
       Y := QWork.FieldByName('HOUR').AsInteger;
       t := X-FirstDay;
       if  (t < 0) or (t >high(ratio)) then SError('Wyst¹pi³o zdarzenie "2 Liczba dni poza zakresem". Zg³oœ problem serwisowi, lub usuñ b³êdne rekordy za pomoc¹ formularza Lista Zajêæ') else
       if  (y < 1) or (y >MaxHours) then //Warning('Zaplanowana liczba godzin ( wartoœæ '+inttostr(y)+') jest wiêksza, ni¿ liczba godzin zdefiniowana dla semestru. Powoduje to, ¿e czêœæ zaplanowanych rekordów nie pojawia siê na ekranie. Mo¿liwe rozwi¹zania problemu: ' + '1. Zwiêksz liczbê godzin w definicji dla semestru lub 2. Usuñ b³êdne rekordy za pomoc¹ formularza Lista Zajêæ lub 3. Przeka¿ opis problemu serwisowi')
       else begin
         ratio[t][y].ratio := QWork.FieldByName('ratio').AsInteger;
       end;
       QWork.Next;
      End;
    end;
    end;


  End;
  Valid := True;
end;

procedure TBusyClassesCache.setRatio(TS: TTimeStamp; Zajecia: Integer; pratio : integer; pres_id : integer);
Var t1 : Integer;
begin
 t1 := TS.Date - FirstDay;
 DModule.SQL('delete from res_hints where day= '+TSDateToOracle(TS)+' and hour='+IntToStr(Zajecia)+' and res_id = ' + inttostr(pres_id) );
 if pratio <> 0 then
   DModule.SQL('insert into res_hints (id, day, hour, ratio, res_id, res_type) values (hint_seq.nextval,'+TSDateToOracle(TS)+','+IntToStr(Zajecia)+','+inttostr(pratio)+','+inttostr(pres_id)+', ''X'')');

 ratio[t1][Zajecia].ratio := pratio; //this is not correct value, it does not include other objects. cache rehresh is required
end;

Procedure tBusyClassesCache.ClearCache;
Begin
 Valid := False;
End;

Function QWorkToClass : TClass_;
Var Class_ : TClass_;
Begin
   //@@@ komuniat o bledzie, gdy rozmiar pola przekracza rozmiar rekordu
   Class_.ID                 := DModule.QWork.FieldByName('ID').AsInteger;
   Class_.DAY                := dateTimeToTimeStamp ( DModule.QWork.FieldByName('DAY').asDateTime );
   Class_.HOUR               := DModule.QWork.FieldByName('HOUR').AsInteger;
   Class_.FILL               := DModule.QWork.FieldByName('FILL').AsInteger;
   Class_.SUB_ID             := DModule.QWork.FieldByName('SUB_ID').AsInteger;
   Class_.FOR_ID             := DModule.QWork.FieldByName('FOR_ID').AsInteger;
   Class_.FOR_KIND           := DModule.QWork.FieldByName('FOR_KIND').AsString;
   CLASS_.SUB_abbreviation   := DModule.QWork.FieldByName('SUB_abbreviation').AsString;
   CLASS_.SUB_NAME           := DModule.QWork.FieldByName('SUB_NAME').AsString;
   CLASS_.SUB_COLOUR         := DModule.QWork.FieldByName('SUB_COLOUR').AsInteger;
   CLASS_.FOR_COLOUR         := DModule.QWork.FieldByName('FOR_COLOUR').AsInteger;
   CLASS_.OWNER_COLOUR       := DModule.QWork.FieldByName('OWNER_COLOUR').AsInteger;
   CLASS_.CREATOR_COLOUR     := DModule.QWork.FieldByName('CREATOR_COLOUR').AsInteger;
   CLASS_.CLASS_COLOUR       := DModule.QWork.FieldByName('CLASS_COLOUR').AsInteger;
   CLASS_.DESC1              := DModule.QWork.FieldByName('DESC1').AsString;
   CLASS_.DESC2              := DModule.QWork.FieldByName('DESC2').AsString;
   CLASS_.DESC3              := DModule.QWork.FieldByName('DESC3').AsString;
   CLASS_.DESC4              := DModule.QWork.FieldByName('DESC4').AsString;
   //CLASS_.SUB_DESC1        := DModule.QWork.FieldByName('SUB_DESC1').AsString;
   //CLASS_.SUB_DESC2        := DModule.QWork.FieldByName('SUB_DESC2').AsString;
   CLASS_.FOR_abbreviation   := DModule.QWork.FieldByName('FOR_abbreviation').AsString;
   CLASS_.FOR_NAME           := DModule.QWork.FieldByName('FOR_NAME').AsString;
   //CLASS_.FOR_DESC1        := DModule.QWork.FieldByName('FOR_DESC1').AsString;
   //CLASS_.FOR_DESC2        := DModule.QWork.FieldByName('FOR_DESC2').AsString;
   CLASS_.CALC_LECTURERS     := DModule.QWork.FieldByName('CALC_LECTURERS').AsString;
   CLASS_.CALC_GROUPS        := DModule.QWork.FieldByName('CALC_GROUPS').AsString;
   CLASS_.CALC_ROOMS         := DModule.QWork.FieldByName('CALC_ROOMS').AsString;
   CLASS_.CALC_LEC_IDS       := DModule.QWork.FieldByName('CALC_LEC_IDS').AsString;
   CLASS_.CALC_GRO_IDS       := DModule.QWork.FieldByName('CALC_GRO_IDS').AsString;
   CLASS_.CALC_ROM_IDS       := DModule.QWork.FieldByName('CALC_ROM_IDS').AsString;
   CLASS_.CALC_RESCAT_IDS    := DModule.QWork.FieldByName('CALC_RESCAT_IDS').AsString;
   CLASS_.Created_by         := DModule.QWork.FieldByName('Created_by').AsString;
   CLASS_.Owner              := DModule.QWork.FieldByName('Owner').AsString;

   Result := Class_;
End;

Procedure DBGetClassByLecturer(DAY1, DAY2 : String; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
var d1, d2 : string;
Begin
   //DModule.SingleValue(
   //'SELECT count(*) c '+
   //'FROM CLASSES CLA ');
   //info ( DModule.QWork.fieldByName('c').AsString);

   d1 := copy(day1,10,10);
   d2 := copy(day2,10,10);

   if d1<>d2 then
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR, FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR,CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4, '+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     LEC_CLA, '+
   '     subjects SUB,'+
   '     FORMS FRM,'+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE LEC_CLA.CLA_ID = CLA.ID AND SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      LEC_CLA.LEC_ID =:lec AND no_conflict_flag is null and '+
   '      CLA.DAY BETWEEN TO_DATE(:day1,''YYYY/MM/DD'') AND TO_DATE(:day2,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';day2='+d2+';hour='+IntToStr(Zajecia)+';lec='+ExtractWord(1,childId,[';']))
   else
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR, FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR,CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4, '+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     LEC_CLA, '+
   '     subjects SUB,'+
   '     FORMS FRM,'+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE LEC_CLA.CLA_ID = CLA.ID AND SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      LEC_CLA.LEC_ID =:lec AND no_conflict_flag is null and '+
   '      CLA.DAY =TO_DATE(:day1,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';hour='+IntToStr(Zajecia)+';lec='+ExtractWord(1,childId,[';']));

   Class_ := QWorkToClass;

   Case DModule.QWork.RecordCount Of
    0: Status := ClassNotFound;
    1: Status := ClassFound;
   Else begin
     Status := ClassError;
     //copyToClipboard('Wyslij te informacje na email soft@home.pl: DBGetClassByLecturer: DAY1='+DAY1+' DAY2='+DAY2+' Zajecia='+intToStr(Zajecia)+'childId='+childId);
   end;
   End;
End;

Procedure DBGetClassByGroup(DAY1, DAY2 : String; Zajecia: Integer; GRO_ID : String; Var Status : Integer; Var Class_ : TClass_);
var d1, d2 : string;
Begin
   d1 := copy(day1,10,10);
   d2 := copy(day2,10,10);

   if d1<>d2 then
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     GRO_CLA,'+
   '     subjects SUB,'+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE GRO_CLA.CLA_ID = CLA.ID AND  SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      GRO_CLA.GRO_ID =:gro AND no_conflict_flag is null and '+
   '      CLA.DAY BETWEEN TO_DATE(:day1,''YYYY/MM/DD'') AND TO_DATE(:day2,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';day2='+d2+';hour='+IntToStr(Zajecia)+';gro='+ExtractWord(1,GRO_ID,[';']))
   else
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     GRO_CLA,'+
   '     subjects SUB,'+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE GRO_CLA.CLA_ID = CLA.ID AND  SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      GRO_CLA.GRO_ID =:gro AND no_conflict_flag is null and '+
   '      CLA.DAY =TO_DATE(:day1,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';hour='+IntToStr(Zajecia)+';gro='+ExtractWord(1,GRO_ID,[';']));

   Class_ := QWorkToClass;

   Case DModule.QWork.RecordCount Of
    0: Status := ClassNotFound;
    1: Status := ClassFound;
   Else begin
     Status := ClassError;
     //copyToClipboard('Wyslij te informacje na email soft@home.pl: DBGetClassByGroup: DAY1='+DAY1+' DAY2='+DAY2+' Zajecia='+intToStr(Zajecia)+'GRO_ID='+GRO_ID);
   end;
   End;
End;

Procedure DBGetClassByRoom(DAY1, DAY2 : String; Zajecia: Integer; ROM_ID : String; Var Status : Integer; Var Class_ : TClass_);
var d1, d2 : string;
Begin
   d1 := copy(day1,10,10);
   d2 := copy(day2,10,10);

   if d1<>d2 then
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     ROM_CLA,'+
   '     subjects SUB,'+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE ROM_CLA.CLA_ID = CLA.ID AND SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      ROM_CLA.ROM_ID=:rom AND no_conflict_flag is null and '+
   '      CLA.DAY BETWEEN TO_DATE(:day1,''YYYY/MM/DD'') AND TO_DATE(:day2,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';day2='+d2+';hour='+IntToStr(Zajecia)+';rom='+ExtractWord(1,ROM_ID,[';']))
   else
   DModule.SingleValue(
   'SELECT CLA.*,'+
          'SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
          'FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     ROM_CLA,'+
   '     subjects SUB,'+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE ROM_CLA.CLA_ID = CLA.ID AND SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND'+
   '      ROM_CLA.ROM_ID=:rom AND no_conflict_flag is null and '+
   '      CLA.DAY =TO_DATE(:day1,''YYYY/MM/DD'') AND CLA.HOUR = :hour ORDER BY CLA.DAY','day1='+d1+';hour='+IntToStr(Zajecia)+';rom='+ExtractWord(1,ROM_ID,[';']));

   Class_ := QWorkToClass;

   Case DModule.QWork.RecordCount Of
    0: Status := ClassNotFound;
    1: Status := ClassFound;
   Else begin
     Status := ClassError;
     //copyToClipboard('Wyslij te informacje na email soft@home.pl: DBGetClassByRoom: DAY1='+DAY1+' DAY2='+DAY2+' Zajecia='+intToStr(Zajecia)+'ROM_ID='+ROM_ID);
   end;
   End;
End;

Procedure TClassByChildCache.ResetByCLA_ID(CLA_ID : Integer; pday : ttimestamp; phour : integer);
Var t, t2 : Integer;
Begin
 For t := 0 To Count-1 Do
   For t2 := 1 To MaxHours Do
    If (Data[t][t2].Class_.ID = CLA_ID) and (Data[t][t2].Class_.hour =phour) and (Data[t][t2].Class_.day.Date=pday.Date) Then
      Begin
       Data[t][t2].Valid := False; Exit;
      End;

 dResetByCLA_IDDone:='Y';
End;

procedure TClassByChildCache.ResetByDay(TS: TTimeStamp; Zajecia: Integer);
Var t : Integer;
Begin
 dResetByDayDone := 'Y';

 t := TS.Date - FirstDay;
 If t <= Count-1 Then begin
    Data[t][Zajecia].Valid := False; Exit; end
 else
    //info ('???');
end;

// // // // // //

Function SuccStatus(Status : Integer) : Integer;
Begin
 Case Status Of
  ClassNotFound: Result := ClassFound;
  ClassFound   : Result := ClassError;
  ClassError   : Result := ClassError;
 Else Result := ClassError;
 End
End;

Procedure TClassByChildCache.ccGetClass(ts : TTimeStamp; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_; ClassBy : TClassBy);
Var t1, t2, X, Y, L1 : Integer;
    DAY1, DAY2 : String;
    Day  : TTimeStamp;

Begin
 if (dinitDone<>'Y') then begin
   SError('Internal error. You must call TClassByChildCache.init before you call TClassByChildCache._GetClassBy.'+cr+
   ' ts.date='+intToStr(ts.date)+cr+
   ' firstDay='+intToStr(firstDay)+cr+
   ' t1='+intToStr(t1)+cr+
   ' high(data)='+ inttostr(high(data))+cr+
   ' Zajecia=' + intToStr(zajecia)+cr+
   ' MaxHours=' + intToStr(MaxHours)+cr+
   ' ChildId=' + childId+cr+
   ' dPER_ID=' + inttostr(dPER_ID)+cr+
   ' dchildId=' + dchildId+cr+
   ' d_SQL=' + d_SQL+cr+
   ' dHighData=' + inttostr(dHighData)+cr+
   ' dinitDone=' + dinitDone+cr+
   ' dResetByCLA_IDDone=' + dResetByCLA_IDDone+cr+
   ' dResetByDayDone=' + dResetByDayDone+cr+
   ' d_GetClassByDone=' + d_GetClassByDone);
   Exit; //fatal error
 end;

 t1 := TS.Date - FirstDay;

 dLastError := '';
 if (t1 > high(data)) or (Zajecia > MaxHours) then begin
   dLastError := 'Przepraszamy! Przytrzymaj naciœniêty przycisk Esc, ¿eby pozbyæ siê tego komunikatu, a nastêpnie naciœnij przycisk odœwie¿. Zg³oœ ten problem serwisowi technicznemu.'+cr+
   ' ts.date='+intToStr(ts.date)+cr+
   ' firstDay='+intToStr(firstDay)+cr+
   ' t1='+intToStr(t1)+cr+
   ' high(data)='+ inttostr(high(data))+cr+
   ' Zajecia=' + intToStr(zajecia)+cr+
   ' MaxHours=' + intToStr(MaxHours)+cr+
   ' ChildId=' + childId+cr+
   ' dPER_ID=' + inttostr(dPER_ID)+cr+
   ' dchildId=' + dchildId+cr+
   ' d_SQL=' + d_SQL+cr+
   ' dHighData=' + inttostr(dHighData)+cr+
   ' dinitDone=' + dinitDone+cr+
   ' dResetByCLA_IDDone=' + dResetByCLA_IDDone+cr+
   ' dResetByDayDone=' + dResetByDayDone+cr+
   ' d_GetClassByDone=' + d_GetClassByDone;
   Exit; //fatal error
 end;

 d_GetClassByDone := 'Y';

 If Data[t1][Zajecia].Valid Then Begin
   Status := Data[t1][Zajecia].Status;
   Class_ := Data[t1][Zajecia].Class_;
   Exit;
 End;

 Day := TS;
 DAY1 := TSDateToOracle(Day);
 Day.Date := Day.Date + 7*10;
 DAY2 := TSDateToOracle(Day);

 t2 := Day.Date - FirstDay;

  With DModule Do Begin
   For L1 := t1 To t2 Do Begin
     if (L1 <= high(data)) and (Zajecia <= maxHours) then begin // do not perform operation out of the cache buffer
       Data[L1][Zajecia].Valid  := True;
       Data[L1][Zajecia].Status := ClassNotFound;
     end;
   End;

  ClassBy(DAY1, DAY2 ,Zajecia,childId,Status,Class_);

  While Not QWork.EOF Do Begin
   X := DateTimeToTimeStamp(QWork.FieldByName('DAY').AsDateTime).Date;
   Y := QWork.FieldByName('HOUR').AsInteger;

   t1 := X-FirstDay;

   if (t1 <= high(data)) and (y <= maxHours) then begin // do not perform operation out of the cache buffer
     Data[t1][y].Status := SuccStatus(Data[t1][y].Status);
     Data[t1][y].Class_ := QWorkToClass;
   end;

   QWork.Next;
  End;
  End;

 t1 := TS.Date - FirstDay;
 If Data[t1][Zajecia].Valid Then Begin
     Status := Data[t1][Zajecia].Status;
     Class_ := Data[t1][Zajecia].Class_;
     Exit;
 End;
 Info('Sytuacja niemo¿liwa! Zajecia='+IntToStr(Zajecia)+' TS.Date='+DateTimeToStr(TimeStampToDateTime(TS)));
End;

{****************************************************************************}
{********* MAIN PART  ******************* ********** ************************}
{****************************************************************************}


procedure TClassByLecturerCaches.init;
begin
  maxLength :=  0;
  position  :=  0;
  PER_ID    := -1;
end;

procedure TClassByLecturerCaches.LGetClass(TS : TTimeStamp; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
var t : integer;
begin
 childId := ExtractWord(1,childId,[';']); // get first from the list

 //2018.02.22
 if childId='' then begin
     Status := ClassNotFound;
     Exit;
 end;

 {
 //Turn off the cache - tests only
 setLength(Data, 1);
 Data[1 - 1].Cache := TClassByLecturerCache.create;
 Data[1 - 1].Cache.LoadPeriod(PER_ID, childId);
 Data[1 - 1].childId := childId;
 Data[1 - 1].Cache.GetClass(TS,Zajecia,childId,Status,Class_);
 Data[1 - 1].Cache.free;
 Data[1 - 1].childId := '-1';
 exit;
 }

 for t := 0 to maxLength - 1 do begin
   if Data[t].childId = childId then begin
     Data[t].Cache.ccGetClass(TS,Zajecia,childId,Status,Class_,DBGetClassByLecturer);
     exit;
   end;
 end;

 if maxLength <= strToInt ( GetSystemParam('MaxNumberOfSheets','50') ) then begin
   inc (maxLength);
   setLength(Data, maxLength);
   position := maxLength;
 end else begin
   position := position + 1;
   if position > strToInt ( GetSystemParam('MaxNumberOfSheets','50') ) then position := 1;
   Data[position - 1].Cache.Free;
 end;

 Data[position - 1].Cache := TClassByChildCache.create;
 Data[position - 1].Cache.ccLoadPeriod(PER_ID,  childId, 'SELECT CLA_ID FROM LEC_CLA WHERE LEC_ID in ','L');
 Data[position - 1].childId := childId;
 Data[position - 1].Cache.ccGetClass(TS,Zajecia,childId,Status,Class_,DBGetClassByLecturer);
end;

procedure TClassByLecturerCaches.LoadPeriod(aPER_ID: Integer; childId : String; reloadFromDatabase : boolean);
var t : integer;
begin
 //free used memory
 if (reloadFromDatabase) or (PER_ID <> aPER_ID) then
  for t := 0 to maxLength -1 do
    if assigned(Data[t].Cache) then
      if Data[t].Cache is TObject then
        try Data[t].Cache.free; except end;

 if reloadFromDatabase then maxLength := 0;
 if PER_ID <> aPER_ID then maxLength :=  0; // czysc cache gdy zmienil sie semestr
 PER_ID := aPER_ID;
end;

procedure TClassByLecturerCaches.ResetByCLA_ID(CLA_ID : Integer; pday : ttimestamp; phour : integer);
var t : integer;
begin
 for t := 0 to maxLength - 1 do begin
   Data[t].Cache.ResetByCLA_ID(CLA_ID,pday,phour);
 end;
end;

procedure TClassByLecturerCaches.ResetByDay(TS : TTimeStamp; Zajecia: Integer);
var t : integer;
begin
 for t := 0 to maxLength - 1 do begin
   Data[t].Cache.ResetByDay(TS,Zajecia);
 end;
end;

procedure TClassByGroupCaches.init;
begin
  maxLength :=  0;
  position  :=  0;
  PER_ID    := -1;
end;

procedure TClassByGroupCaches.GetClass(TS : TTimeStamp; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
var t : integer;
begin
 dGeneralDebug := '';
 childId := ExtractWord(1,childId,[';']); // get first from the list

 //2018.02.22
 if childId='' then begin
     Status := ClassNotFound;
     Exit;
 end;

 for t := 0 to maxLength - 1 do begin
   if Data[t].childId = childId then begin
     Data[t].GCache.ccGetClass(TS,Zajecia,childId,Status,Class_,DBGetClassByGroup);
     exit;
   end;
 end;

 if maxLength <= strToInt ( GetSystemParam('MaxNumberOfSheets','50') ) then begin
   inc (maxLength);
   setLength(Data, maxLength);
   position := maxLength;
 end else begin
   position := position + 1;
   if position > strToInt ( GetSystemParam('MaxNumberOfSheets','50') ) then position := 1;
   Data[position - 1].GCache.Free;
 end;

   dGeneralDebug := 'TClassByGroupCaches.GetClass '+inttostr(position)+' PER_ID='+inttostr(PER_ID)+' conPeriod.Text='+fmain.conPeriod.Text;
   Data[position - 1].GCache := TClassByChildCache.create;
   Data[position - 1].GCache.ccLoadPeriod(PER_ID,  childId, 'SELECT CLA_ID FROM GRO_CLA WHERE GRO_ID in ','G');
   Data[position - 1].childId := childId;
   Data[position - 1].GCache.ccGetClass(TS,Zajecia,childId,Status,Class_,DBGetClassByGroup);
end;

procedure TClassByGroupCaches.LoadPeriod(aPER_ID: Integer; childId : String; reloadFromDatabase : boolean);
var t : integer;
begin
 //free used memory
 if (reloadFromDatabase) or (PER_ID <> aPER_ID) then
  for t := 0 to maxLength -1 do
    if assigned(Data[t].GCache) then
      if Data[t].GCache is TObject then
        try Data[t].GCache.free; except end;

 if reloadFromDatabase then maxLength := 0;
 if PER_ID <> aPER_ID then maxLength :=  0; // czysc cache gdy zmienil sie semestr
 PER_ID := aPER_ID;
end;

procedure TClassByGroupCaches.ResetByCLA_ID(CLA_ID : Integer; pday : ttimestamp; phour : integer);
var t : integer;
begin
 for t := 0 to maxLength - 1 do begin
   Data[t].GCache.ResetByCLA_ID(CLA_ID,pday,phour);
 end;
end;

procedure TClassByGroupCaches.ResetByDay(TS : TTimeStamp; Zajecia: Integer);
var t : integer;
begin
 for t := 0 to maxLength - 1 do begin
   Data[t].GCache.ResetByDay(TS,Zajecia);
 end;
end;


//////////////////////////////////////////////////
procedure TClassByResCaches.init;
begin
  maxLength :=  0;
  position  :=  0;
  PER_ID    := -1;
end;

procedure TClassByResCaches.GetClass(TS : TTimeStamp; Zajecia: Integer; childId : String; Var Status : Integer; Var Class_ : TClass_);
var t : integer;
begin
 childId := ExtractWord(1,childId,[';']); // get first from the list

 //2018.02.22
 if childId='' then begin
     Status := ClassNotFound;
     Exit;
 end;

 for t := 0 to maxLength - 1 do begin
   if Data[t].childId = childId then begin
     Data[t].Cache.ccGetClass(TS,Zajecia,childId,Status,Class_,DBGetClassByRoom);
     exit;
   end;
 end;

 if maxLength <= strToInt ( GetSystemParam('MaxNumberOfSheets','50') ) then begin
   inc (maxLength);
   setLength(Data, maxLength);
   position := maxLength;
 end else begin
   position := position + 1;
   if position > strToInt ( GetSystemParam('MaxNumberOfSheets','50') ) then position := 1;
   Data[position - 1].Cache.Free;
 end;

   Data[position - 1].Cache := TClassByChildCache.create;
   Data[position - 1].Cache.ccLoadPeriod(PER_ID,  childId, 'SELECT CLA_ID FROM ROM_CLA WHERE ROM_ID in ','R');
   Data[position - 1].childId := childId;
   Data[position - 1].Cache.ccGetClass(TS,Zajecia,childId,Status,Class_,DBGetClassByRoom);
end;

procedure TClassByResCaches.LoadPeriod(aPER_ID: Integer; childId : String; reloadFromDatabase : boolean);
var t : integer;
begin
 //free used memory
 if (reloadFromDatabase) or (PER_ID <> aPER_ID) then
  for t := 0 to maxLength -1 do
    if assigned(Data[t].Cache) then
      if Data[t].Cache is TObject then
        try Data[t].Cache.free; except end;

 if reloadFromDatabase then maxLength := 0;
 if PER_ID <> aPER_ID then maxLength :=  0; // czysc cache gdy zmienil sie semestr
 PER_ID := aPER_ID;
end;

procedure TClassByResCaches.ResetByCLA_ID(CLA_ID : Integer; pday : ttimestamp; phour : integer);
var t : integer;
begin
 for t := 0 to maxLength - 1 do begin
   Data[t].Cache.ResetByCLA_ID(CLA_ID,pday,phour);
 end;
end;

procedure TClassByResCaches.ResetByDay(TS : TTimeStamp; Zajecia: Integer);
var t : integer;
begin
 for t := 0 to maxLength - 1 do begin
   Data[t].Cache.ResetByDay(TS,Zajecia);
 end;
end;

Procedure TFMain.Start;
Begin
 If GetSystemParam('SAVERESOURCES') = 'No' Then Begin
  //AutoCreate.LECTURERSCreate;
 End;
End;

Procedure TFMain.Stop;
Begin
  AutoCreate.LECTURERSFree;
End;

procedure TFMain.Tkaninyinformacje1Click(Sender: TObject);
begin
  inherited;
  UFInfo.ShowModal;
end;

procedure TFMain.FormCreate(Sender: TObject);
  procedure init;
  begin
   ClassByLecturerCaches := TClassByLecturerCaches.create;
   ClassByGroupCaches    := TClassByGroupCaches.create;
   ClassByRoomCaches     := TClassByResCaches.create;
   ClassByResCat1Caches  := TClassByResCaches.create;
   ReservationsCache     := tReservationsCache.Create;
   otherCalendar         := totherCalendar.Create;
   confineCalendar       := totherCalendar.Create;
   otherCalendar.count :=0;
   confineCalendar.Count :=0;
   BusyClassesCache      := tBusyClassesCache.create;

   ClassByLecturerCaches.init;
   ClassByGroupCaches.init;
   ClassByRoomCaches.init;
   ClassByResCat1Caches.init;

  end;
begin
  silentMode := false;
  MapLecNames := Tmap.Create;
  MapLecColors:= Tmap.Create;
  MapGroColors:= Tmap.Create;
  MapRomColors:= Tmap.Create;
  MapPlanners := Tmap.Create;
  MapPlannerSupervisors := Tmap.Create;

  ignoreEvents := false;
  userLogged := false;
  disableFurtherActivities := false;
  StartUp := true;

  GridSelectionLeft   := -1;
  GridSelectionRight  := -1;
  GridSelectionTop    := -1;
  GridSelectionBottom := -1;
  gridSelectionMode   := clNone;

  timerShapes := 2;
  init;

 CanShow := False;
 resizeMode := false;
 inherited;
 //UUtilities.OpisujKolumneZajec.internalCreate;
end;

procedure TFMain.BDICTLECClick(Sender: TObject);
begin
  LECTURERSShowModalAsBrowser('');
  BuildCalendar('L');
end;

procedure TFMain.BDICTGROClick(Sender: TObject);
begin
  GROUPSShowModalAsBrowser('');
  BuildCalendar('G');
end;

procedure TFMain.BDICTSUBClick(Sender: TObject);
begin
  SUBJECTSShowModalAsBrowser('');
  BuildCalendar('S');
end;

procedure TFMain.BDICTFORClick(Sender: TObject);
begin
  FORMSShowModalAsBrowser('');
  BuildCalendar('F');
end;

procedure TFMain.BDICTPERClick(Sender: TObject);
begin
  PERIODSShowModalAsBrowser;
  setPeriod;
end;

function min ( i1, i2 : integer ) : integer;
begin
 if i1 < i2 then result := i1 else result := i2;
end;

procedure TFMain.RefreshGrid;
 Procedure SetButtons(V : Boolean);
 Begin
  GridPanel.Visible := V;
  filterPanel.Visible := BViewByCrossTable.Down;
  Legend.Visible := V;
  bAddClass.Visible := V;
  bAddClass.Enabled := canInsert;
  bmoveLeft.Enabled := canInsert and canDelete;
  bmoveUp.Enabled := canInsert and canDelete;
  bmoveDown.Enabled := canInsert and canDelete;
  bmoveright.Enabled := canInsert and canDelete;
  bcutarea.Enabled := canDelete;
  bpastearea.Enabled := canInsert;
  bcopyarea.Enabled := canInsert or canDelete;
  bclearselection.Enabled := canInsert or canDelete;

  bEditClass.Visible := V;
  bDeleteClass.Visible := V;
  bDeleteClass.Enabled := canDelete;
  bdelpopup.Visible := V;
  beditpopup.Visible := V;
  bRefresh.Visible := V;
  bcopyarea.Visible := V;
  bcutarea.Visible := V;
  bpastearea.Visible := V;
  bclearselection.Visible := V;
  bconflictspopup.Visible := V;
  zoomIn.Visible := V;
  zoomOut.Visible := V;
  bwww.Visible := V;
  BViewByWeek.Visible := V;
  BViewByCrossTable.Visible := V;
  bmoveDown.Visible := v;
  bmoveUp.Visible := v;
  bmoveLeft.Visible := v;
  bmoveRight.Visible := v;
  Shape1a.Visible := v;
  Shape2a.Visible := v;
  Shape3a.Visible := v;
  Shape4a.Visible := v;
  Shape7a.Visible := v;
  Shape8a.Visible := v;
  Shape9a.Visible := v;
 End;

 var fontHeightInPixels : integer;

begin
   grid.Canvas.Font.Assign( gridFont.Font );
   if FcellLayout.ForceCellWidth.Checked then
     Grid.DefaultColWidth := FcellLayout.ForcedCellWidth.Position
   else begin
     Grid.DefaultColWidth := grid.Canvas.TextWidth('11-12')+2;
     FcellLayout.ForcedCellWidth.Position := Grid.DefaultColWidth;
   end;

   if FcellLayout.ForceCellHeight.Checked then
     Grid.DefaultRowHeight := FcellLayout.ForcedCellHeight.Position
   else
   begin
     fontHeightInPixels := grid.Canvas.TextHeight('X');
     Grid.DefaultRowHeight := fontHeightInPixels * 1;
     If getCode(FcellLayout.D2) <> 'NONE' Then Grid.DefaultRowHeight := fontHeightInPixels * 2;
     If getCode(FcellLayout.D3) <> 'NONE' Then Grid.DefaultRowHeight := fontHeightInPixels * 3;
     If getCode(FcellLayout.D4) <> 'NONE' Then Grid.DefaultRowHeight := fontHeightInPixels * 4;
     If getCode(FcellLayout.D5) <> 'NONE' Then Grid.DefaultRowHeight := fontHeightInPixels * 5;
     If getCode(FcellLayout.D6) <> 'NONE' Then Grid.DefaultRowHeight := fontHeightInPixels * 6;
     If getCode(FcellLayout.D7) <> 'NONE' Then Grid.DefaultRowHeight := fontHeightInPixels * 7;
     If getCode(FcellLayout.D8) <> 'NONE' Then Grid.DefaultRowHeight := fontHeightInPixels * 8;
     FcellLayout.ForcedCellHeight.Position := Grid.DefaultRowHeight;
   end;

  if BViewByCrossTable.Down then begin
    grid.ColWidths[0] := 200;
    grid.FixedRows    := min (Grid.RowCount -1 , 2);
    grid.FixedCols    := 1;
  end else begin
    grid.ColWidths[0] := Grid.ColWidths[1];
    grid.FixedRows    := 0;
    //aviod error "Fixed column count must be less than column count"
    if grid.ColCount >=2 then
      grid.FixedCols    := 2;
  end;

 LprofileObjectNameL.Font.Style   := LprofileObjectNameL.Font.Style - [fsBold];
 LprofileObjectNameG.Font.Style   := LprofileObjectNameG.Font.Style - [fsBold];
 BRescat0.Font.Style := BRescat0.Font.Style - [fsBold];
 BRescat1.Font.Style := BRescat1.Font.Style - [fsBold];

 If TabViewType.TabIndex = 0 Then LprofileObjectNameL.Font.Style   := LprofileObjectNameL.Font.Style + [fsBold];;
 If TabViewType.TabIndex = 1 Then LprofileObjectNameG.Font.Style   := LprofileObjectNameG.Font.Style + [fsBold];
 If TabViewType.TabIndex = 2 Then BRescat0.Font.Style := BRescat0.Font.Style + [fsBold];
 If TabViewType.TabIndex = 3 Then BRescat1.Font.Style := BRescat1.Font.Style + [fsBold];

 If isBlank(conPeriod.Text)                                    Then Begin SetButtons(False); Exit; End;
 If TabViewType.TabIndex = -1                                Then Begin SetButtons(False); Exit; End;
 If (TabViewType.TabIndex = 0) And (isBlank(ConLecturer.Text)) Then Begin SetButtons(False); Exit; End;
 If (TabViewType.TabIndex = 1) And (isBlank(ConGroup.Text))    Then Begin SetButtons(False); Exit; End;
 If (TabViewType.TabIndex = 2) And (isBlank(conResCat0.Text))  Then Begin SetButtons(False); Exit; End;
 If (TabViewType.TabIndex = 3) And (isBlank(CONResCat1.Text))  Then Begin SetButtons(False); Exit; End;
 SetButtons(True);

 Grid.Refresh;
end;

Procedure TFMain.BuildCalendar (triggeredObject : String);
var  colCnt, rowCnt : integer;

Begin
  if not canShow Then exit;
  Cursor := crHourGlass;

  if instr('L#G#R',triggeredObject)<>0 then
  if not BViewByCrossTable.Down then begin
    Case TabViewType.TabIndex Of
      0:With DModule do UpsertRecentlyUsed(ExtractWord(1, ConLecturer.Text,  [';']),'L');
      1:With DModule do UpsertRecentlyUsed(ExtractWord(1, ConGroup.Text,  [';']),'G');
      2:With DModule do UpsertRecentlyUsed(ExtractWord(1, conResCat0.Text,  [';']),'R');
      3:With DModule do UpsertRecentlyUsed(ExtractWord(1, conResCat1.Text,  [';']),'R');
    end;
  end;

  refreshPanels;

  If isBlank(conPeriod.TEXT) Then begin
    GridPanel.Visible := False;
    Exit;
  End;

  If Dmodule.SingleValue('SELECT COUNT(1) FROM PERIODS WHERE ID='+conPeriod.TEXT) <> '1' Then Begin
    conPeriod.TEXT := '';
    Exit;
  End;

  TabViewType.Tabs[0] := iif( BViewByWeek.down,  fprogramsettings.profileObjectNameL.text+' '+ExtractWord(1, ConLecturer_value.Text,  [';'])  , fprogramsettings.profileObjectNameLs.text);
  TabViewType.Tabs[1] := iif( BViewByWeek.down,  fprogramsettings.profileObjectNameG.text+' '+ExtractWord(1, ConGroup_value.Text   ,  [';']) , fprogramsettings.profileObjectNameGs.text);
  TabViewType.Tabs[2] := iif( BViewByWeek.down,  dmodule.pResCatName0+' '+ExtractWord(1, conResCat0_value.Text ,  [';'])                      , dmodule.pResCatName0 );
  TabViewType.Tabs[3] := iif( BViewByWeek.down,  dmodule.pResCatName1+' '+ExtractWord(1, CONResCat1_value.Text ,  [';'])                      , dmodule.pResCatName1);

  convertGrid.setupGrid (conPeriod.text, BViewByWeek.Down, TabViewType.TabIndex, filter.text, colCnt, rowCnt);
  Grid.ColCount := colCnt;
  Grid.RowCount := rowCnt;

  RefreshGrid;
  Cursor := crDefault;
End;

procedure TFMain.ConLecturerChange(Sender: TObject);
begin
  BusyClassesCache.ClearCache;
  If CanShow Then Begin
   ConLecturer_value.Text := FChange(ConLecturer.text, sql_LECDESC);
   //DModule.RefreshLookupEdit(Self, TControl(Sender).Name,sql_LECNAME,'LECTURERS','');
   ClassByLecturerCaches.LoadPeriod(StringToInt(conPeriod.Text), ConLecturer.Text, bool_NOTreloadFromDatbase);
   BuildCalendar('L');
  End;
  ShowAllAnyL.Visible       := ShowFreeTermsL.Checked;
end;

procedure TFMain.ConGroupChange(Sender: TObject);
begin
  BusyClassesCache.ClearCache;
  If CanShow Then Begin
   ConGroup_value.Text := FChange(ConGroup.text, sql_GRODESC);
   //DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME||''(''||abbreviation||'')''','GROUPS','');
   ClassByGroupCaches.LoadPeriod(StringToInt(conPeriod.Text), ConGroup.Text, bool_NOTreloadFromDatbase);
   BuildCalendar('G');
  End;
  ShowAllAnyG.Visible       := ShowFreeTermsG.Checked;

end;

procedure TFMain.conResCat0Change(Sender: TObject);
begin
  BusyClassesCache.ClearCache;
  If CanShow Then Begin
   conResCat0_value.Text := FChange(conResCat0.text,sql_ResCat0DESC);
   //DModule.RefreshLookupEdit(Self, TControl(Sender).Name,sql_ROMNAME,'ROOMS','');
   ClassByRoomCaches.LoadPeriod(StringToInt(conPeriod.Text), conResCat0.Text, bool_NOTreloadFromDatbase);
   BuildCalendar('R');
  End;
  ShowAllAnyResCat0.Visible       := ShowFreeTermsR.Checked;

end;

procedure TFMain.ConSubjectChange(Sender: TObject);
begin
  BusyClassesCache.ClearCache;
  If CanShow Then begin
   DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME||''(''||abbreviation||'')''','SUBJECTS','');
   UpsertRecentlyUsed(ExtractWord(1, TEdit(Sender).Text,  [';']),'S');
   BuildCalendar('S');
  end;
end;

//very similar to conPeriodChange but does not call  UpsertRecentlyUsed
procedure TFMain.setPeriod;
begin
  If CanShow Then Begin
   if isBlank(conPeriod.Text) then exit;
   SetVisibles;
   If (Not isBlank(conPeriod.Text) and (confineCalendarId<>'')) Then confineCalendar.LoadPeriod(conPeriod.Text,confineCalendarId);
   BRefreshClick(nil);
  End;
end;

procedure TFMain.conPeriodChange(Sender: TObject);
begin
  If CanShow Then Begin
   if isBlank(conPeriod.Text) then exit;
   DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PERIODS','');
   SetVisibles;
   If (Not isBlank(conPeriod.Text) and (confineCalendarId<>'')) Then confineCalendar.LoadPeriod(conPeriod.Text,confineCalendarId);
   UpsertRecentlyUsed(ExtractWord(1, conPeriod.text,  [';']),'P');  //TEdit(Sender).Text
   BRefreshClick(nil);
  End;
end;

Procedure TFMain.SetVisibles;
Begin
  LprofileObjectNameL.Visible    := not isBlank(conPeriod.Text);
  ConLecturer_value.Visible      := not isBlank(conPeriod.Text);
  SelectL.Visible                := not isBlank(conPeriod.Text);
  LprofileObjectNameG.Visible    := not isBlank(conPeriod.Text);
  ConGroup_value.Visible         := not isBlank(conPeriod.Text);
  SelectG.Visible                := not isBlank(conPeriod.Text);
  BRescat0.Visible               := not isBlank(conPeriod.Text);
  conResCat0_value.Visible       := not isBlank(conPeriod.Text);
  SelectR.Visible                := not isBlank(conPeriod.Text);
  LprofileObjectNameC1.Visible   := not isBlank(conPeriod.Text);
  ConSubject_value.Visible       := not isBlank(conPeriod.Text);
  //BitBtnSUB.Visible              := not isBlank(conPeriod.Text);
  FcellLayout.Coloring.Visible     := not isBlank(conPeriod.Text);
  FcellLayout.selectFill.Visible   := not isBlank(conPeriod.Text);
  FcellLayout.DESCRIPTIONS.Visible := not isBlank(conPeriod.Text);
End;

procedure TFMain.zoomInClick(Sender: TObject);
begin
 gridFont.Font.Size := gridFont.Font.Size + 1;
 RefreshGrid;
end;

procedure TFMain.zoomOutClick(Sender: TObject);
begin
 If gridFont.Font.Size > 1  Then
  Begin
    gridFont.Font.Size := gridFont.Font.Size - 1;
    RefreshGrid;
  End;
end;

procedure TFMain.NormalClick(Sender: TObject);
begin
 If getCode(FcellLayout.D1) = 'NONE' Then Begin FcellLayout.D1.ItemIndex := FcellLayout.D2.ItemIndex; FcellLayout.D2.ItemIndex := getItemIndex(FcellLayout.D2, 'NONE'); End;
 If getCode(FcellLayout.D2) = 'NONE' Then Begin FcellLayout.D2.ItemIndex := FcellLayout.D3.ItemIndex; FcellLayout.D3.ItemIndex := getItemIndex(FcellLayout.D3, 'NONE'); End;
 If getCode(FcellLayout.D3) = 'NONE' Then Begin FcellLayout.D3.ItemIndex := FcellLayout.D4.ItemIndex; FcellLayout.D4.ItemIndex := getItemIndex(FcellLayout.D4, 'NONE'); End;
 If getCode(FcellLayout.D4) = 'NONE' Then Begin FcellLayout.D4.ItemIndex := FcellLayout.D5.ItemIndex; FcellLayout.D5.ItemIndex := getItemIndex(FcellLayout.D5, 'NONE'); End;
 If getCode(FcellLayout.D5) = 'NONE' Then Begin FcellLayout.D5.ItemIndex := FcellLayout.D6.ItemIndex; FcellLayout.D6.ItemIndex := getItemIndex(FcellLayout.D6, 'NONE'); End;
 If getCode(FcellLayout.D6) = 'NONE' Then Begin FcellLayout.D6.ItemIndex := FcellLayout.D7.ItemIndex; FcellLayout.D7.ItemIndex := getItemIndex(FcellLayout.D7, 'NONE'); End;
 If getCode(FcellLayout.D7) = 'NONE' Then Begin FcellLayout.D7.ItemIndex := FcellLayout.D8.ItemIndex; FcellLayout.D8.ItemIndex := getItemIndex(FcellLayout.D8, 'NONE'); End;

 FcellLayout.D2.Visible := FcellLayout.D1.ItemIndex <> getItemIndex(FcellLayout.D1, 'NONE');
 FcellLayout.D3.Visible := FcellLayout.D2.ItemIndex <> getItemIndex(FcellLayout.D2, 'NONE');
 FcellLayout.D4.Visible := FcellLayout.D3.ItemIndex <> getItemIndex(FcellLayout.D3, 'NONE');
 FcellLayout.D5.Visible := FcellLayout.D4.ItemIndex <> getItemIndex(FcellLayout.D4, 'NONE');
 FcellLayout.D6.Visible := FcellLayout.D5.ItemIndex <> getItemIndex(FcellLayout.D5, 'NONE');
 FcellLayout.D7.Visible := FcellLayout.D6.ItemIndex <> getItemIndex(FcellLayout.D6, 'NONE');
 FcellLayout.D8.Visible := FcellLayout.D7.ItemIndex <> getItemIndex(FcellLayout.D7, 'NONE');

 //Grid.DefaultColWidth := 28;
 If CanShow Then Begin
   RefreshGrid;
 End;
end;

procedure TFMain.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
	Var Class_ : TClass_;
	fontHeightInPixels : integer;
	code               : shortString;
    originalRect : trect;

	Procedure DrawStriped(Var Rect : TRect; text : string);
	Var t : Integer;
      RWidth, RHeight : integer;
	Begin
	 t:=Rect.Left;
	 grid.Canvas.Pen.Color := clBlack;

	 While t<=Rect.Right Do
	  Begin
	   grid.Canvas.MoveTo(t,Rect.Top);
	   grid.Canvas.LineTo(t,Rect.Bottom);
	   t := t + 5;
	  End;

   if text = 'HOLIDAY' then text := '';
	 grid.Canvas.Font.Color := clBlack;
	 RWidth := Rect.right - Rect.Left;
	 RHeight := Rect.Bottom - Rect.top;
	 grid.Canvas.TextOut(
	   Rect.Left+RWidth div 2-3
	 , Rect.Top+RHeight div 2-6
	 , text );

	End;

	Procedure HighLight(Var Rect : TRect);
	Begin
	 grid.Canvas.Pen.Color := clGray;
   grid.Canvas.Brush.Color := clGray;
   //orig := Grid.Canvas.Pen.Mode;
   //Grid.Canvas.Pen.Mode  := pmXor;
   grid.Canvas.Rectangle(Rect);
   //Grid.Canvas.Pen.Mode := orig;
	End;

	Procedure DrawCross(Var Rect : TRect);
	Begin
	 grid.Canvas.Pen.Color := clBlack;
	 grid.Canvas.MoveTo(Rect.Left,Rect.Top);
	 grid.Canvas.LineTo(Rect.Right,Rect.Bottom);
	 grid.Canvas.MoveTo(Rect.Right,Rect.Top);
	 grid.Canvas.LineTo(Rect.Left,Rect.Bottom);
	End;

	Procedure DrawEdge(Var Rect : TRect; edgeNo : integer; lineWidth : integer);
	Begin
		 {    3
		  	-----
		   |     |
		 1 |     |2
		   |     |
	  		-----
			  4    }

		 case edgeNo of
		   1:begin
			  grid.Canvas.MoveTo(Rect.Left,Rect.Top);  grid.Canvas.LineTo(Rect.Left,Rect.Bottom);
			  grid.Canvas.MoveTo(Rect.Left+lineWidth,Rect.Top);  grid.Canvas.LineTo(Rect.Left+lineWidth,Rect.Bottom);
			 end;
		   2:begin
			  grid.Canvas.MoveTo(Rect.right,Rect.Top);  grid.Canvas.LineTo(Rect.right,Rect.Bottom);
			  grid.Canvas.MoveTo(Rect.right-lineWidth,Rect.Top);  grid.Canvas.LineTo(Rect.right-lineWidth,Rect.Bottom);
			 end;
		   3:begin
			  grid.Canvas.MoveTo(Rect.Left,Rect.Top);  grid.Canvas.LineTo(Rect.right,Rect.top);
			  grid.Canvas.MoveTo(Rect.Left,Rect.Top+lineWidth);  grid.Canvas.LineTo(Rect.right,Rect.top+lineWidth);
			 end;
		   4:begin
			  grid.Canvas.MoveTo(Rect.Left,Rect.bottom);  grid.Canvas.LineTo(Rect.right,Rect.bottom);
			  grid.Canvas.MoveTo(Rect.Left,Rect.bottom-lineWidth);  grid.Canvas.LineTo(Rect.right,Rect.bottom-lineWidth);
			 end;
		 end;
	End;


	procedure DrawTriangle(var Rect : TRect; ratio : integer);
	var t : integer;
	begin
	 if ratio < 0 then grid.Canvas.Pen.Color := clred
				  else grid.Canvas.Pen.Color := clgreen;

	 for t:= 1 to round (abs(ratio) / 100)  do begin
	   grid.Canvas.MoveTo(rect.left+t+1,rect.Top+1);
	   grid.Canvas.LineTo(rect.left+1,rect.Top+t+1);
	 end;
	end;

	procedure DrawBusy(Var Rect : TRect; busyCnt : integer);
	Var RWidth : integer;
		RHeight: integer;

	begin
	 grid.Canvas.Pen.Color := clred;
	 grid.Canvas.Brush.Color := clRed;
	 RWidth := Rect.right - Rect.Left;
	 RHeight := Rect.Bottom - Rect.top;
	 grid.Canvas.Ellipse(
		  (Rect.Left+RWidth div 2-6)
		, (Rect.Top+RHeight  div  2-6)
		, (Rect.Right-RWidth  div 2+6)
		, (Rect.Bottom-RHeight  div 2+6)
	 );
	 if busyCnt > 1 then begin
	   grid.Canvas.Font.Color := clWhite;
	   grid.Canvas.TextOut(
		   Rect.Left+RWidth div 2-3
		 , Rect.Top+RHeight div 2-6
		 , intToStr(busyCnt) );
	 end;
	end;

	Procedure DrawError(Var Rect : TRect);
	Begin
	 grid.Canvas.Pen.Color := clRed;
	 grid.Canvas.MoveTo(Rect.Left,Rect.Top);
	 grid.Canvas.LineTo(Rect.Right,Rect.Bottom);
	 grid.Canvas.MoveTo(Rect.Right,Rect.Top);
	 grid.Canvas.LineTo(Rect.Left,Rect.Bottom);
	End;

	Procedure DrawReservation(Rez : String; Var Rect : TRect);
	Var t : Integer;
	Begin
	 t:=Rect.Top;
	 grid.Canvas.Pen.Color := clSilver;

	 While t<=Rect.Bottom Do
	  Begin
	   grid.Canvas.MoveTo(Rect.Left,t);
	   grid.Canvas.LineTo(Rect.Right,t);
	   t := t + 5;
	  End;
	 grid.Canvas.TextOut(Rect.Left, Rect.Top, Rez);
	End;

	Procedure DrawAlert(var Rect : TRect);
	Begin
	 Grid.Canvas.Font.Color := clRed;
	 Grid.Canvas.Font.Style := Grid.Canvas.Font.Style + [fsBold];
	 Grid.Canvas.TextOut(Rect.Left , Rect.Top, '????');
	 Grid.Canvas.Font.Color := clBlack;
	 Grid.Canvas.Font.Style := Grid.Canvas.Font.Style - [fsBold];
	End;

    Procedure DrawRect;

                 //------------------------------------------------------
                 Procedure Generic (Counter : Integer; Colors : TColors);
                     Var w, t : Integer;
                         Top, Left : Integer;
                         ComboBoxes : Array[1..8] Of TComboBox;
                         colR, colG, colB : ShortString;

                     procedure ColorToRGB(I : Integer);
                     Var s: ShortString;
                     Begin
                      s := IntToHex(I,6);
                      colB := Copy(S,1,2);
                      colG := Copy(S,3,2);
                      colR := Copy(S,5,2);
                     End;

                     procedure TextoutResource ( t : integer);
                     Var resourceList : string;
                     begin
                      if code = 'ALL_RES' then resourceList := Class_.CALC_ROOMS
                                          else resourceList := ucommon.getResourcesByType(code, Class_.CALC_RESCAT_IDS, Class_.CALC_ROOMS );
                      Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), resourceList );
                     end;


                 Begin // Generic
                   Grid.Canvas.Brush.Color := clWhite;
                   Grid.Canvas.FillRect(rect);
                   // for reservation show always form regardless of view settings
                   If Class_.FOR_KIND = 'R' Then Begin
                     Rect.Top    := Rect.Top    + 1;
                     Rect.Left   := Rect.Left   + 1;
                     DrawReservation(Class_.FOR_abbreviation, Rect);
                     Exit;
                   End;

                   // for non reservations do:
                   Top := Rect.Top+1; Left := Rect.Left;
                   Grid.Canvas.Brush.Color := clWhite;
                   If Counter > 0 Then
                   Begin
                     If getCode(FcellLayout.Coloring)  <> 'NONE' Then Begin
                       Rect.Top    := Rect.Top    + 1;
                       Rect.Left   := Rect.Left   + 1;
                       Rect.Bottom := Rect.Top + Round((Rect.Bottom - Rect.Top) * Class_.FILL/100);
                       W := (Rect.Right - Rect.Left) div Counter;
                       For t:=0 To Counter-1 Do Begin
                           Rect.Right := Rect.Left + W;
                           Grid.Canvas.Brush.Color := Colors[t];
                           //
                           ColorToRGB ( Colors[t] );
                           if (colR < '80') and ( colG < '80') and ( colB < '80')
                             then Grid.Canvas.Font.Color := clWhite
                             else Grid.Canvas.Font.Color := clBlack;
                           //
                           Grid.Canvas.FillRect(Rect);
                           Rect.Left := Rect.Left + W;
                       End;
                     End;
                   End
                   Else DrawAlert(Rect);

                   Grid.Canvas.Pen.Color := clWhite;

                   //Grid.Canvas.Font.Size := -7;
                   ComboBoxes[1] := FcellLayout.D1;
                   ComboBoxes[2] := FcellLayout.D2;
                   ComboBoxes[3] := FcellLayout.D3;
                   ComboBoxes[4] := FcellLayout.D4;
                   ComboBoxes[5] := FcellLayout.D5;
                   ComboBoxes[6] := FcellLayout.D6;
                   ComboBoxes[7] := FcellLayout.D7;
                   ComboBoxes[8] := FcellLayout.D8;

                   fontHeightInPixels := grid.Canvas.TextHeight('X');

                   For t := 1 To 5 Do begin
                     code := getCode(ComboBoxes[t]);
                     if  code= 'L'          then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.CALC_LECTURERS )                                  else
                     if  code= 'G'          then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.CALC_GROUPS )                                     else
                     if  code= 'S'          then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.SUB_abbreviation )                                else
                     if  code= 'F'          then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.FOR_abbreviation )                                else
                     if  code= 'SF'         then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.SUB_abbreviation+'('+Class_.FOR_abbreviation+')') else
                     if  code= 'OWNER'      then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.Owner )                                           else
                     if  code= 'CREATED_BY' then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.Created_by )                                      else
                     if  code= 'NONE'       then {}                                                                                                                 else
                     if  code= 'DESC1'      then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.desc1 )                                           else
                     if  code= 'DESC2'      then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.desc2 )                                           else
                     if  code= 'DESC3'      then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.desc3 )                                           else
                     if  code= 'DESC4'      then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.desc4 )                                           else
                     if  code= 'ALL_RES'    then Grid.Canvas.TextOut(Left, Top+((T-1)*fontHeightInPixels), Class_.CALC_ROOMS )
                     else TextOutResource (t);
                   end;
                 End; // Generic

                 Var Colors : TColors;

                 //------------------------------------------------------
                 procedure DrawL;
                 Var Count,t : Integer;
                  begin
                   Count := WordCount(Class_.CALC_LEC_IDS, [';']);
                   For t := 1 To Count Do Colors[t-1] := dmodule.LecturerGetColour(ExtractWord(t,Class_.CALC_LEC_IDS, [';']));
                   Generic(Count, Colors);
                  end;

                 //------------------------------------------------------
                 procedure DrawG;
                 Var Count,t : Integer;
                  begin
                   Count := WordCount(Class_.CALC_GRO_IDS, [';']);
                   For t := 1 To Count Do  begin
                     Colors[t-1] := dmodule.GroupGetColour(ExtractWord(t,Class_.CALC_GRO_IDS, [';']));
                   end;
                   Generic(Count, Colors);
                  end;

                 //------------------------------------------------------
                 procedure DrawR;
                 Var Count,t : Integer;
                     resourceIdList : string;
                 begin
                   if code = 'ALL_RES' then resourceIdList := Class_.CALC_ROM_IDS
                                       else resourceIdList := ucommon.getResourcesByType(code, Class_.CALC_RESCAT_IDS, Class_.CALC_ROM_IDS );
                   Count := WordCount(resourceIdList, [';']);
                   For t := 1 To Count Do Colors[t-1] := dmodule.RoomGetColour(ExtractWord(t,resourceIdList, [';']));
                   Generic(Count, Colors);
                 end;

                 //------------------------------------------------------
                 procedure DrawDesc;
                 begin
                   if code = 'DESC1' then begin if not isBlank(Class_.desc1) then Colors[0] := clRed else Colors[0] := clSilver; end;
                   if code = 'DESC2' then begin if not isBlank(Class_.desc2) then Colors[0] := clRed else Colors[0] := clSilver; end;
                   if code = 'DESC3' then begin if not isBlank(Class_.desc3) then Colors[0] := clRed else Colors[0] := clSilver; end;
                   if code = 'DESC4' then begin if not isBlank(Class_.desc4) then Colors[0] := clRed else Colors[0] := clSilver; end;
                   Generic(1, Colors);
                 end;

                 //------------------------------------------------------
                 procedure DrawS;
                  begin
                   Colors[0] := Class_.SUB_COLOUR;
                   Generic(1, Colors);
                  end;

                 //------------------------------------------------------
                 procedure DrawF;
                  begin
                   Colors[0] := Class_.FOR_COLOUR;
                   Generic(1, Colors);
                  end;

                 //------------------------------------------------------
                 procedure DrawOwner;
                  begin
                   Colors[0] := Class_.OWNER_COLOUR;
                   Generic(1, Colors);
                  end;

                 //------------------------------------------------------
                 procedure DrawCreatedBy;
                  begin
                   Colors[0] := Class_.CREATOR_COLOUR;
                   Generic(1, Colors);
                  end;

                 //------------------------------------------------------
                 procedure DrawClass;
                 begin
                   Colors[0] := Class_.CLASS_COLOUR;
                   Generic(1, Colors);
                 end;

                 //------------------------------------------------------
                 procedure DrawEmpty;
                 begin
                   Generic(1, Colors);
                 end;

                 //------------------------------------------------------
                 Procedure DrawSuppressionH(Var Rect : TRect);
                 Var t : Integer;
                 Begin
                  t:=Rect.Top;
                  Grid.Canvas.Pen.Color := clWhite;

                  While t<=Rect.Bottom Do
                   Begin
                    Grid.Canvas.MoveTo(Rect.Left,t);
                    Grid.Canvas.LineTo(Rect.Right,t);
                    t := t + 3;
                   End;
                 End;

                 //------------------------------------------------------
                 Procedure DrawSuppressionV(Var Rect : TRect);
                 Var t : Integer;
                 Begin
                  t:=Rect.Left;
                  Grid.Canvas.Pen.Color := clWhite;

                  While t<=Rect.Right Do
                   Begin
                    Grid.Canvas.MoveTo(t,Rect.top);
                    Grid.Canvas.LineTo(t,Rect.bottom);
                    t := t + 3;
                   End;
                 End;

    //draw rect
    Begin
      code := getCode(FcellLayout.Coloring);
      if code = 'L'          then DrawL         else
      if code = 'G'          then DrawG         else
      if code = 'S'          then DrawS         else
      if code = 'F'          then DrawF         else
      if code = 'OWNER'      then DrawOwner     else
      if code = 'CREATED_BY' then DrawCreatedBy else
      if code = 'CLASS'      then DrawClass     else
      if code = 'DESC1'      then DrawDesc{red color for description} else
      if code = 'DESC2'      then DrawDesc{red color for description} else
      if code = 'DESC3'      then DrawDesc{red color for description} else
      if code = 'DESC4'      then DrawDesc{red color for description} else
      if code = 'NONE'       then DrawEmpty     else
      if code = 'ALL_RES'    then DrawR         else DrawR;

      if DrawSuppressionS.Checked then
      if not isBlank(CONSUBJECT.Text) then
          if (intToStr(class_.sub_id) <> CONSUBJECT.Text) then begin
              DrawSuppressionH(originalRect);
              DrawSuppressionV(originalRect);
          end;

      if DrawSuppressionF.Checked then
      if not isBlank(CONFORM.Text) then
          if (intToStr(class_.for_id) <> CONFORM.Text) then begin
              DrawSuppressionH(originalRect);
              DrawSuppressionV(originalRect);
          end;

    //draw rect
    End;

  Var Status : Integer;

	 Procedure BusyClasses;
	  var out_isbusy  : boolean;
		  out_busyCnt : integer;
		  out_claIds : string;
		  out_ratio   : integer;
	 Begin
     out_ratio := 0;
	   if ShowFreeTermsL.Checked or ShowFreeTermsG.Checked or ShowFreeTermsR.Checked or ShowFreeTermsResCat1.Checked or ( (FavSelected.Checked) or (FavAll.Checked) ) then begin
     	   BusyClassesCache.IsBusy(TS, Zajecia, out_isbusy, out_busyCnt, out_ratio, out_claids);
		     if out_isbusy Then DrawBusy(Rect, out_busyCnt);
     end;
	   if (out_ratio <> 0) and ( (FavSelected.Checked) or (FavAll.Checked) ) then DrawTriangle(Rect, out_ratio);
	 End;

	 function iif( c : boolean; w1 : string; w2 : string) : string;
	 begin
	  if c then result := w1 else result := w2;
	 end;

	 Procedure drawReservationsCalendar;
   var resType : string;
	 Begin
    resType := ReservationsCache.IsReserved(TS, Zajecia);
	  If resType<>'' Then DrawStriped(Rect, resType);
    If (confineCalendarId<>'') then
      If confineCalendar.getRatio(TS, Zajecia)<>calConfineOk then DrawCross(Rect);
	 End;

	 Procedure drawOtherCalendar;
   Var ratio : integer;
	 Begin
    ratio :=OtherCalendar.getRatio(TS, Zajecia);
	  If ratio=calReserved
      Then DrawStriped(Rect,'')
	    else
        if ratio<>0
        Then DrawTriangle(Rect, ratio);
	 End;

//----------------------GridDrawCell
begin
   grid.Canvas.Font.Assign( gridFont.Font );

   originalRect :=  Rect;
   If Not CanShow Then Exit;

   If isBlank(conPeriod.Text) Then Begin
      GridPanel.Visible := False;
      Exit;
   End;

   Case convertGrid.ColRowToDate(AObjectId, TS, Zajecia, ACol, ARow) Of
    //ConvDayOfWeek:   If Zajecia=0 Then Grid.Canvas.TextOut(1+Rect.Left,1+Rect.Top,NumToDayOfWeek(ARow div (ConvertDateColRow.MaxIloscGodzin+1))+DateTimeToStr(TimeStampToDateTime(TS)));
    ConvDayOfWeek   :if TS.Date<>-1 then if Zajecia=0 then Grid.Canvas.TextOut(1+Rect.Left,1+Rect.Top,ShortDayNames[DayOfWeek(TimeStampToDateTime(TS))]);
    ConvNumeryZajec :if Zajecia<>0 then Grid.Canvas.TextOut(1+Rect.Left,1+Rect.Top,OpisujKolumneZajec.Str(Zajecia));
    convOutOfRange  :begin Grid.Canvas.Brush.Color := clMenu; Grid.Canvas.FillRect(Rect); DrawCross(Rect); End;
    ConvHeader      :begin Grid.Canvas.Brush.Color := clMenu; Grid.Canvas.FillRect(Rect); Grid.Canvas.TextOut(1+Rect.Left,1+Rect.Top,GetDate(TS.Date)); End;
    ConvClass:
     Begin
      If TabViewType.TabIndex<4 Then BusyClasses;

      Case TabViewType.TabIndex Of
       0: Begin ClassByLecturerCaches.LGetClass(TS, Zajecia, iif(AObjectId = -1, ConLecturer.Text, intToStr(AObjectId)), Status, Class_);drawReservationsCalendar; End;
       1: Begin ClassByGroupCaches.GetClass   (TS, Zajecia, iif(AObjectId = -1, ExtractWord(1,ConGroup.Text   ,[';']), intToStr(AObjectId)), Status, Class_); drawReservationsCalendar;
          End;
       2: Begin ClassByRoomCaches.GetClass    (TS, Zajecia, iif(AObjectId = -1, ExtractWord(1,conResCat0.Text ,[';']), intToStr(AObjectId)), Status, Class_); drawReservationsCalendar; End;
       3: Begin ClassByResCat1Caches.GetClass (TS, Zajecia, iif(AObjectId = -1, ExtractWord(1,CONResCat1.Text ,[';']), intToStr(AObjectId)), Status, Class_); drawReservationsCalendar; End;
       4: drawReservationsCalendar;
       5: drawOtherCalendar;
      End;

      If (TabViewType.TabIndex = 0) or (TabViewType.TabIndex = 1) or (TabViewType.TabIndex = 2) or (TabViewType.TabIndex = 3)
      Then
      Case Status Of
       ClassNotFound : Begin End;
       ClassFound    : DrawRect;
       ClassError    : DrawError(Rect);
      End;
     End;
    crossTableViewObjNames : Grid.Canvas.TextOut(1+Rect.Left,1+Rect.Top, convertGrid.convertManyObjects.currentObjName );
    crossTableViewDayOfWeek:
      if TS.Date<>-1 then begin
        if Zajecia=1 then Grid.Canvas.TextOut(1+Rect.Left,1+Rect.Top,GetDate(TS.Date));
        if Zajecia=2 then Grid.Canvas.TextOut(1+Rect.Left,1+Rect.Top,ShortDayNames[DayOfWeek(TimeStampToDateTime(TS))]);
      end;
   End;

   //show selection
   if (acol >= GridSelectionLeft) and (acol <= GridSelectionRight) and (arow >= GridSelectionTop) and (arow <= GridSelectionBottom) then
   begin
    Grid.Canvas.Pen.Color := GridSelectionMode;
    Grid.Canvas.Pen.Style := psDot; //psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame
    //Grid.Canvas.Pen.Mode  :=  pmBlack;    //pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, pmMergePenNot, pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotMerge, pmMask, pmNotMask, pmXor, pmNotXor

    if acol = GridSelectionLeft   then begin DrawEdge(originalRect,1,1); end;
    if acol = GridSelectionRight  then begin DrawEdge(originalRect,2,1); end;
    if arow = GridSelectionTop    then begin DrawEdge(originalRect,3,1); end;
    if arow = GridSelectionBottom then begin DrawEdge(originalRect,4,1); end;
    Grid.Canvas.Pen.Style := psSolid;
   end;

   if (gdSelected in state) then
   begin
    if GetAsyncKeyState(VK_LBUTTON)=0 then begin
      Grid.Canvas.Pen.Color := clBlack;
      Grid.Canvas.Pen.Style := psSolid; //psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame
      //Grid.Canvas.Pen.Mode  :=  pmXor;    //pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, pmMergePenNot, pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotMerge, pmMask, pmNotMask, pmXor, pmNotXor

      if acol = Grid.Selection.Left   then begin DrawEdge(originalRect,1,2); end;
      if acol = Grid.Selection.Right  then begin DrawEdge(originalRect,2,2); end;
      if arow = Grid.Selection.Top    then begin DrawEdge(originalRect,3,2); end;
      if arow = Grid.Selection.Bottom then begin DrawEdge(originalRect,4,2); end;
      Grid.Canvas.Pen.Style := psSolid;
    end else begin
      if  (Grid.Selection.Left<>Grid.Selection.Right) or (Grid.Selection.Top<>Grid.Selection.Bottom) then
          HighLight(originalRect);
    end;
   end;

   //if (gdFocused in state) then   label1.Caption := 'focused' else label1.Caption := '' ;
   //if (gdFixed in state) then   label5.Caption := 'fixed' else label5.Caption := '' ;




end;

Procedure TFMain.insertClasses;

 function AddClass(currentPattern : string) : boolean;
 var t : Integer;
     PLecturers, PGroups, PRooms : TPointers;
     PLecturersWithChilds, PGroupsWithChilds, PRoomsWithChilds : TPointers;
     value : String;
     L, G, R, Created_by, _Owner : string;
     LwithChildsAndParents, GwithChildsAndParents, RwithChildsAndParents  : string;
     pdesc1, pdesc2, pdesc3, pdesc4  : string;
     S, FormId, Fill, colour  : integer;
     checkResult                 : shortString;
     resourceList                : string;
     ttCombIds                   : string;
     currentPatternId            : string;
 Begin
    For t := 1 To maxInClass Do Begin
      PLecturers[t] :=0;
      PGroups[t] :=0;
      PRooms[t] :=0;
    End;

    For t := 1 To maxInClass Do Begin
      PLecturersWithChilds[t] :=0;
      PGroupsWithChilds[t] :=0;
      PRoomsWithChilds[t] :=0;
    End;

    With FDetails Do Begin
     GetValues(L, G, R, S, FormId, Fill, colour, created_by, _Owner, pdesc1, pdesc2, pdesc3, pdesc4 );

     if currentPattern<>'1' then
       if DBMap.get (currentPattern, currentPatternId)
         then FormId := strToInt(currentPatternId)
         else info('U¿yty kod jest nieprawid³owy:'+currentPattern);

     For t := 1 To WordCount(L,[';']) Do Begin
      value := ExtractWord(t, L, [';']);
      PLecturers[t] := StrToInt(Value)
     End;

     For t := 1 To WordCount(G,[';']) Do Begin
      value := ExtractWord(t, G, [';']);
      PGroups[t] := StrToInt(Value)
     End;

     For t := 1 To WordCount(R,[';']) Do Begin
      value := ExtractWord(t, R, [';']);
      PRooms[t] := StrToInt(Value)
     End;

     //add dependency records: childs and parents
     LWithChildsAndParents := L;
     For t := 1 To WordCount(L,[';']) Do Begin
       value := ExtractWord(t, L, [';']);
       LWithChildsAndParents := getChildsAndParents(value, LWithChildsAndParents, false, false);
     End;
     For t := 1 To WordCount(LWithChildsAndParents,[';']) Do Begin
      value := ExtractWord(t, LWithChildsAndParents, [';']);
      PLecturersWithChilds[t] := StrToInt(Value)
     End;

     GWithChildsAndParents := G;
     For t := 1 To WordCount(G,[';']) Do Begin
       value := ExtractWord(t, G, [';']);
       GWithChildsAndParents := getChildsAndParents(value, GWithChildsAndParents, false, false);
     End;
     For t := 1 To WordCount(GWithChildsAndParents,[';']) Do Begin
      value := ExtractWord(t, GWithChildsAndParents, [';']);
      PGroupsWithChilds[t] := StrToInt(Value)
     End;

     RWithChildsAndParents := R;
     For t := 1 To WordCount(R,[';']) Do Begin
       value := ExtractWord(t, R, [';']);
       RWithChildsAndParents := getChildsAndParents(value, RWithChildsAndParents, false, false);
     End;
     For t := 1 To WordCount(RWithChildsAndParents,[';']) Do Begin
      value := ExtractWord(t, RWithChildsAndParents, [';']);
      PRoomsWithChilds[t] := StrToInt(Value)
     End;

     resourceList := replace(
        iif(CONPERIOD.Text='','',CONPERIOD.Text+',')+
        iif(L='','',L+',')+
        iif(G='','',G+',')+
        iif(R='','',R+',')+
        iif(S=0,'',intToStr(S)+',')+
        intToStr(FormId)+','+
        UserID // =in this context user=owner.
                        // Not "getUserOrRoleID" - class belongs to user, but not to his role
     ,';',','
     );
     //
     if wordCount(resourceList,[','])>=16 then
       info('Ze wzglêdu na liczbê wybranych zasobów (>=16), sprawdzenie dostêpnych kombinacji zasobów nie zostanie zostanie przeprowadzone, gdy¿ zajê³oby to zbyt wiele czasu', showOnceaday)
     else
     begin
       dmodule.sql('begin tt_planner.verify (:p_pla_id, :p_res_ids, :p_auto_fix ); end;'
                  ,'p_pla_id='+getUserOrRoleId+';p_res_ids='+resourceList+';p_auto_fix=N'
                  );
       checkResult := dmodule.SingleValue('select count(1) from tt_check_results where found_tt is null');
       // there are not allowed combinations
       if checkResult <> '0' then begin
         with FTTCheckResults do begin
           numberOfColumns := length( resourceList ) - length( replace(resourceList, ',','') ) + 1;
           p_res_ids    := resourceList;
           if showmodal = mrcancel then exit;
           // autofix problem
           dmodule.sql('begin tt_planner.verify (:p_pla_id, :p_res_ids, :p_auto_fix ); end;'
                      ,'p_pla_id='+getUserOrRoleId+';p_res_ids='+resourceList+';p_auto_fix=Y'
                      );
         end;
       end;
     end;

     with dmodule do begin
       openSQL('select found_tt from tt_check_results where found_tt is not null');
       while not qwork.eof do begin
         ttCombIds := merge(ttCombIds, qwork.fieldByName('found_tt').AsString, ',');
         qwork.Next;
       end;
     end;

     // passing parameters sometimes failed !
     TS      := UFmain.dummyTS;
     Zajecia := UFmain.dummyHour;
     checkConflicts.ConflictsReport(
       TS
     , Zajecia
     , FDetails.currentClassId
     , PLecturers
     , PGroups
     , PRooms
     , PLecturersWithChilds
     , PGroupsWithChilds
     , PRoomsWithChilds
     , S
     , FormId
     , 0
     , fill
     , colour
     , Created_by
     , _Owner
     , pdesc1
     , pdesc2
     , pdesc3
     , pdesc4);
    End;

    result := false;
    If Not checkConflicts.Empty Then
    begin
      checkConflicts.GetDesc(fShowConflicts.SGNewClass, fShowConflicts.SGConflicts, fShowConflicts.infoDeleteForbiden);
      if fShowConflicts.ShowModal <> mrCancel Then
      begin
        checkConflicts.Insert ( ttCombIds );
        result := true;
      end;
    end
    else begin
      checkConflicts.Insert ( ttCombIds );
      result := true;
    End;
 End;

Var xp, yp           : Integer;
    classesCount     : integer;
    pattern          : shortString;
    patternLen       : integer;
    classesToAdd     : integer;
    calendarSelected : boolean;
    addedFlag        : boolean;

    procedure processPattern (x0,xp : integer);
     var currentPattern : string;
         canInsertClass : boolean;
    begin
      // passing parameters via procedure worked sometimes badly !
      UFmain.dummyTS.time := TS.time;
      UFmain.dummyTS.date := TS.date;
      UFmain.dummyHour    := Zajecia;
      currentPattern := pattern[((xp-x0) mod patternLen)+1];

      if calendarSelected then
       canInsertClass := not (otherCalendar.getRatio(TS, Zajecia)=calReserved)
      else canInsertClass := true;

      if (confineCalendarId <> '') and (canInsertClass) then begin
         canInsertClass := (confineCalendar.getRatio(TS, Zajecia)=calConfineOk);
         if not canInsertClass then info('Nie mo¿esz planowaæ zajêæ w zaznaczonym terminie');
      end;

      //info( inttostr( OtherCalendar.getRatio(TS, Zajecia)) );
      //info( inttostr( calReserved) );

      addedFlag := false;
      if (currentPattern<>'0') and (canInsertClass) then begin
        addedFlag := AddClass(currentPattern);
      end;

      if (addedFlag)
          //!
          or (FDetails.CCounter.ItemIndex=1) then begin
        inc(classesCount);
        //info(inttostr(xp));
      end;

      {
      easier to understand version:
        xp     = 01 23 45 67
        modulo2= 01 01 01 01
                 01 01 01 01  <-- even

        xp     = 012 345 678
        modulo3= 012 012 012
                 101 101 101
      end;
      }
    end;

//-------------------------------- insertClasses ------------------------------------------------------
begin
 If FDetails.ShowModal = mrOK Then Begin

    calendarSelected := fdetails.CALID.Text<>'-1';
    if calendarSelected then
    if fdetails.CALID.Text <> fmain.CALID.Text then begin
      ignoreEvents := true;
      fmain.CALID.Text :=  fdetails.CALID.Text;
      ignoreEvents := false;
      DModule.RefreshLookupEdit(Self, 'CALID','NAME','ROOMS','');
      If Not isBlank(conPeriod.Text) Then otherCalendar.LoadPeriod(conPeriod.Text,CALID.Text);
      //now the OtherCalendar.IsReserved(TS, Zajecia) is available
    end;

    pattern := extractWord(1,FDetails.CPattern.Text,[' ']);
    patternLen := length(pattern);

    With Grid Do
    Begin
      dmodule.CommitTrans;

      classesCount := 0;
      if FDetails.CCounter.ItemIndex=0 then classesToAdd := (Selection.Bottom-Selection.Top+1)*(Selection.Right-Selection.Left+1);
      if FDetails.CCounter.ItemIndex=1 then classesToAdd := patternLen * (Selection.Bottom-Selection.Top+1);
      if FDetails.CCounter.ItemIndex>1 then classesToAdd := FDetails.CCounter.ItemIndex-1;

      For xp:=Selection.Left To Selection.Right Do
       For yp:=Selection.Top To Selection.Bottom Do
          if classesCount < classesToAdd then
            If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,xp,yp)=ConvClass Then begin
              processPattern(Selection.Left,xp);
            end;

      Refresh;

      if classesCount<classesToAdd then info('Nie mo¿na dodaæ wszystkich zajêæ:'+inttostr(classesToAdd)+'. Dodano zajêæ: '+inttostr(classesCount)+cr+'Aby zaznaczyæ inny obszar i spróbowaæ ponownie, wybierz polecenie Cofnij');

    End;
 End;
end;

procedure TFMain.AddClassToGrid(firstResourceFlag : boolean);
begin
 If TabViewType.TabIndex = 4 Then Begin InvertReservations; Exit; End;
 If TabViewType.TabIndex = 5 Then Begin InvertOtherCalendar; Exit; End;

 With FDetails Do Begin

   Zajecia := -1;
   if (Grid.Selection.Left=Grid.Selection.Right) and (Grid.Selection.Top=Grid.Selection.Bottom) then
     If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,Grid.Selection.Left,Grid.Selection.Top) <>ConvClass Then Zajecia := -1;

   FDetails.SetValues(
     TS
   , Zajecia
   , -1
   , iif(canEditL,  iif(firstResourceFlag, ExtractWord(1, ConLecturer.Text,  [';']), ConLecturer.Text), '')
   , iif(canEditG,  iif(firstResourceFlag, ExtractWord(1, ConGroup.Text,  [';']), ConGroup.Text), '')
   , iif(canEditR,  iif(firstResourceFlag, ExtractWord(1, merge ( conResCat0.Text, conResCat1.Text, ';'),  [';']), merge ( conResCat0.Text, conResCat1.Text, ';')), '')
   //resource types
   , merge(
       repeatString(dmodule.pResCatId0, wordCount(conResCat0.Text,[';']) ,';' )
      ,repeatString(dmodule.pResCatId1, wordCount(conResCat1.Text,[';']) ,';' )
      ,';'
     )
   , iif(canEditS, strToInt(iif(ConSubject.Text='','0',ConSubject.Text)),0)
   , iif(canEditF, strToInt(iif(ConForm.Text=''   ,'0',ConForm.Text)),0)
   , 100
   , 0
   , dmodule.SingleValue('select kind from forms where id='+nvl(ConForm.Text,'-1'))
   , TabViewType.TabIndex
   , CurrentUserName
   , CurrentUserName
   , '','','',''
   );

 End;

 InsertClasses;
 refreshPanels;
end;

procedure TFMain.BAddClassClick(Sender: TObject);
begin
  AddClassToGrid(gFirstResourceFlag);
end;

procedure TFMain.refreshPanels;
begin
 //Refresh recently used
 refreshRecentlyUsed('');
 //Refresh Legend
 if FLegend.Visible then
   if (FLegend.FLegendTabs.ActivePage = FLegend.TabSheetCOUNTER) or (FLegend.FLegendTabs.ActivePage = FLegend.TabSheetTimetableNotes) then
     FLegend.BRefreshClick(nil);
end;

procedure TFMain.BRefreshClick(Sender: TObject);
var pCol, pRow : integer;
begin
  //pCol := grid.Col;
  //pRow := grid.Row;

  //grid.ColCount:=1;
  //grid.rowCount:=1;
  ValidLClick(nil);
  ValidGClick(nil);
  ValidRClick(nil);

  If (Not isBlank(ConLecturer.Text)) And (Not isBlank(conPeriod.Text)) Then ClassByLecturerCaches.LoadPeriod(StringToInt(conPeriod.Text), ConLecturer.Text, bool_reloadFromDatbase);
  If (Not isBlank(ConGroup.Text))    And (Not isBlank(conPeriod.Text)) Then ClassByGroupCaches.LoadPeriod(StringToInt(conPeriod.Text), ConGroup.Text, bool_reloadFromDatbase);
  If (Not isBlank(conResCat0.Text))  And (Not isBlank(conPeriod.Text)) Then ClassByRoomCaches.LoadPeriod(StringToInt(conPeriod.Text), conResCat0.Text, bool_reloadFromDatbase);
  If (Not isBlank(conResCat1.Text))  And (Not isBlank(conPeriod.Text)) Then ClassByResCat1Caches.LoadPeriod(StringToInt(conPeriod.Text), CONResCat1.Text, bool_reloadFromDatbase);
  If                                    Not isBlank(conPeriod.Text)  Then ReservationsCache.ReservationsCacheLoadPeriod(conPeriod.Text);
  If                                    Not isBlank(conPeriod.Text)  Then OtherCalendar.LoadPeriod(conPeriod.Text,CALID.Text);
  BusyClassesCache.ClearCache;

  OpisujKolumneZajec.internalCreate;
  BuildCalendar('X');

  //grid.Col := pCol;
  //grid.Row := pRow;

end;

procedure TFMain.Cofnij1Click(Sender: TObject);
begin
  Dmodule.RollbackTrans;
  BRefreshClick(nil);
  RefreshGrid;
  //
  AutoSaveCounterDown := -1;
  StatusBar.Panels[0].Text:=''; //saved
end;

procedure TFMain.Zapisz1Click(Sender: TObject);
begin
  dmodule.CommitTrans;
  AutoSaveCounterDown := -1;
  StatusBar.Panels[0].Text:=''; //saved
end;

Var PrevCol, PrevRow : Integer;

Procedure TFMain.FillPanel(Col, Row: Integer);
var drawDone : boolean;

    function LecToNames (lec_ids : string; substitute : string) : string;
    var t : integer;
        id : string;
    begin
      result := '';
      for t :=1 to WordCount(lec_ids,[';']) do begin
        id := ExtractWord(t,lec_ids,[';']);
        result := merge(result, MapLecNames.getValue(id),'; ');
      end;
    end;

    Procedure DrawP(Class_ : TClass_);
     var point : tpoint;
         rect  : trect;
    Begin
       drawDone := true;
       StatusBar.Panels[1].Text := Class_.CALC_LECTURERS;
       StatusBar.Panels[2].Text := Class_.CALC_GROUPS;
       StatusBar.Panels[3].Text := Class_.CALC_ROOMS;

       StatusBar.Panels[4].Text :=Class_.SUB_NAME;
       StatusBar.Panels[5].Text :=Class_.FOR_NAME;
       StatusBar.Panels[6].Text :=Class_.Owner;

       HideBaloonHint;
       //FBalloon.left := 10000;
       rect := grid.CellRect(col + 1,row + 1);
       point.X := rect.Left + grid.Left+SearchPanel.Width;
       point.Y := rect.Top + grid.top + iif(LeftPanel.Visible,LeftPanel.Height,0) + iif(TopPanel.Visible,TopPanel.Height,0);
       point := fmain.ClientToScreen(point);

       uutilityparent.ShowBaloonHint(Point, self.Handle,
       CenterString( Class_.SUB_NAME + ' ('+ Class_.FOR_NAME +')', 97) ,
       fprogramsettings.profileObjectNameLs.text+':  '        + LecToNames (Class_.calc_lec_ids, Class_.CALC_LECTURERS) + cr+
       fprogramsettings.profileObjectNameGs.text+':             '  + Class_.CALC_GROUPS +  cr+
       dmodule.pResCatName0+':          ' + ucommon.getResourcesByType(dmodule.pResCatId0, Class_.CALC_RESCAT_IDS, Class_.CALC_ROOMS ) + cr+
       dmodule.pResCatName1+':          ' + ucommon.getResourcesByType(dmodule.pResCatId1, Class_.CALC_RESCAT_IDS, Class_.CALC_ROOMS ) + cr+
       //fprogramsettings.profileObjectNameC1s.text+':       '    + Class_.sub_name +  cr+
       //fprogramsettings.profileObjectNameC2.text+':             '  + Class_.for_name +  cr+
       'W³aœciciel:       '   + Class_.Owner+
       //
       iif( ((FProgramSettings.getClassDescPlural(1) <> '') and (Class_.desc1 <> ''))
         or ((FProgramSettings.getClassDescPlural(2) <> '') and (Class_.desc2 <> ''))
         or ((FProgramSettings.getClassDescPlural(3) <> '') and (Class_.desc3 <> ''))
         or ((FProgramSettings.getClassDescPlural(4) <> '') and (Class_.desc4 <> '')) , cr+cr+'--------------'+cr, '') +
       iif((FProgramSettings.getClassDescPlural(1) <> '') and (Class_.desc1 <> ''), FProgramSettings.getClassDescPlural(1) + ': ' + Class_.desc1 + cr, '') +
       iif((FProgramSettings.getClassDescPlural(2) <> '') and (Class_.desc2 <> ''), FProgramSettings.getClassDescPlural(2) + ': ' + Class_.desc2 + cr, '') +
       iif((FProgramSettings.getClassDescPlural(3) <> '') and (Class_.desc3 <> ''), FProgramSettings.getClassDescPlural(3) + ': ' + Class_.desc3 + cr, '') +
       iif((FProgramSettings.getClassDescPlural(4) <> '') and (Class_.desc4 <> ''), FProgramSettings.getClassDescPlural(4) + ': ' + Class_.desc4 + cr, '')
       , 1 );
    End;

    Procedure drawFreeText(s : string);
     var point : tpoint;
         rect  : trect;
    Begin
       HideBaloonHint;
       rect := grid.CellRect(col + 1,row + 1);
       point.X := rect.Left + grid.Left+SearchPanel.Width;
       point.Y := rect.Top + grid.top + iif(LeftPanel.Visible,LeftPanel.Height,0) + iif(TopPanel.Visible,TopPanel.Height,0);
       point := fmain.ClientToScreen(point);

       uutilityparent.ShowBaloonHint(Point, self.Handle,
        'Kolizje',s
       , 1 );
    End;

    Procedure ClearPanel;
    Begin
      HideBaloonHint;
      //FBalloon.left := 10000;
      StatusBar.Panels[1].Text := '';
      StatusBar.Panels[2].Text := '';
      StatusBar.Panels[3].Text := '';
      StatusBar.Panels[4].Text := '';
      StatusBar.Panels[5].Text := '';
      StatusBar.Panels[6].Text := '';
    End;

  Var Class_ : TClass_;
      Status : Integer;
 Procedure LecturerPanel;
 Begin
   ClassByLecturerCaches.LGetClass(TS, Zajecia, iif(AObjectId = -1, ConLecturer.Text, intToStr(AObjectId)), Status, Class_);
   Case Status Of
    ClassNotFound : ClearPanel;
    ClassFound    : DrawP(Class_);
    ClassError    : ClearPanel;
   End;
   //StatusBar1.Panels[0].Text := inttostr(ts.Date)+' '+ inttostr(zajecia) ;
 End;

 Procedure GroupPanel;
 Begin
   ClassByGroupCaches.GetClass(TS, Zajecia, iif(AObjectId = -1, ConGroup.Text, intToStr(AObjectId)), Status, Class_);
   Case Status Of
    ClassNotFound : ClearPanel;
    ClassFound    : DrawP(Class_);
    ClassError    : ClearPanel;
   End;
 End;

 Procedure RoomPanel;
 Begin
   ClassByRoomCaches.GetClass(TS, Zajecia, iif(AObjectId = -1, conResCat0.Text, intToStr(AObjectId)), Status, Class_);
   Case Status Of
    ClassNotFound : ClearPanel;
    ClassFound    : DrawP(Class_);
    ClassError    : ClearPanel;
   End;
 End;

 Procedure ResPanel;
 Begin
   ClassByResCat1Caches.GetClass(TS, Zajecia, iif(AObjectId = -1, CONResCat1.Text, intToStr(AObjectId)), Status, Class_);
   Case Status Of
    ClassNotFound : ClearPanel;
    ClassFound    : DrawP(Class_);
    ClassError    : ClearPanel;
   End;
 End;

 procedure drawBusy;
 	  var out_isbusy  : boolean;
		  out_busyCnt : integer;
		  out_claIds : string;
		  out_ratio   : integer;
 begin
	   if ShowFreeTermsL.Checked or ShowFreeTermsG.Checked or ShowFreeTermsR.Checked or ShowFreeTermsResCat1.Checked then begin
	      BusyClassesCache.IsBusy(TS, Zajecia, out_isbusy, out_busyCnt, out_ratio, out_claids);
        if out_isbusy Then DrawFreeText(out_claids);
     end;
 end;

begin
 drawDone := false;
 If (PrevCol <> Col) Or (PrevRow <> Row) Then Begin
 PrevCol :=  Col;
 PrevRow := Row;

 If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,Col,Row) = ConvClass Then begin
      Case TabViewType.TabIndex Of
       0: LecturerPanel;
       1: GroupPanel;
       2: RoomPanel;
       3: ResPanel;
       4: ClearPanel;
       5: ClearPanel;
      End;
      if not drawDone then
          If TabViewType.TabIndex<4 Then
              drawBusy;
     end
     Else
      ClearPanel;
 End;
end;

procedure TFMain.GridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Var Col, Row   : Integer;
    distance1  : integer;
    distance3  : integer;
    distance   : real;
    xabs, yabs : integer;
    cursorPos       : TPoint;

begin
 FCellLayout.hideCellLayout(false);
  //“A call to an OS function failed” problem
 //Use cursorPos.Y instead of Mouse.CursorPos.Y
 GetCursorPos(cursorPos);

 xabs := cursorPos.x;
 yabs := cursorPos.y;

 {    3
    -----
   |     |
 1 |     |2
   |     |
    -----
      4    }

  if ( (xabs >= ftoolwindow.Left) and ( xabs <= (ftoolwindow.Left + ftoolwindow.width) ) )
     and
     ( (yabs >= ftoolwindow.top) and ( yabs <= (ftoolwindow.top + ftoolwindow.height) ) )
  then
  begin
    distance := 0;
  end
  else
  begin
    distance1 := ftoolwindow.Left - xabs;
    if distance1 < 0 then
      distance1 := xabs - (ftoolwindow.Left + ftoolwindow.width);
    if distance1 < 0 then distance1 := 0;

    distance3 := ftoolwindow.top - yabs;
    if distance3 < 0 then
    distance3 := yabs - (ftoolwindow.top + ftoolwindow.height );
    if distance3 < 0 then distance3 := 0;

    distance := distance1 + distance3;

    if distance > 255 then distance := 255;
    if distance > 200 then  ftoolwindow.hide;
  end;

  if distance > 255 / 5 then distance := 255 / 5;
  ftoolwindow.AlphaBlendValue := 255 - round(distance*5);
  //self.Caption := inttostr(distance1);

 Grid.MouseToCell(X, Y, Col, Row);
 FillPanel(Col, Row);
end;

procedure TFMain.TabViewTypeClick(Sender: TObject);
var triggredObject : string[10];
begin
 if not userLogged then exit;
 if (CALID.text='-1') and (TabViewType.TabIndex=5) then CALID_VALUEClick(nil);
 UpdateLeftPanel;
 if TabViewType.TabIndex = 0 then triggredObject := 'L';
 if TabViewType.TabIndex = 1 then triggredObject := 'G';
 if TabViewType.TabIndex = 2 then triggredObject := 'R';

 BuildCalendar(triggredObject);
end;

procedure TFMain.BDeleteClassClick(Sender: TObject);
Var xp, yp  : Integer;
    Class_ : TClass_;
    Status : Integer;

begin
 If TabViewType.TabIndex = 4 Then Begin InvertReservations; Exit; End;
 If TabViewType.TabIndex = 5 Then Begin InvertOtherCalendar; Exit; End;

 If TabViewType.TabIndex = -1 Then Begin
  SError( Format('Jeœli chcesz usun¹æ %s, wybierz kalendarz %s, %s lub zasobu', [fprogramsettings.profileObjectNameClass.text, fprogramsettings.profileObjectNameLgen.text, fprogramsettings.profileObjectNameGgen.text]) );
  Exit;
 End;

    With Grid Do
     Begin
      dmodule.CommitTrans;
      For xp:=Selection.Left To Selection.Right Do
       For yp:=Selection.Top To Selection.Bottom Do
          If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,xp,yp)=ConvClass Then Begin
           Case TabViewType.TabIndex Of
            0: ClassByLecturerCaches.LGetClass(TS, Zajecia, iif(AObjectId = -1, ConLecturer.Text, intToStr(AObjectId)), Status, Class_);
            1: ClassByGroupCaches.GetClass(TS, Zajecia, iif(AObjectId = -1, ConGroup.Text, intToStr(AObjectId)), Status, Class_);
            2: ClassByRoomCaches.GetClass(TS, Zajecia, iif(AObjectId = -1, conResCat0.Text, intToStr(AObjectId)), Status, Class_);
            3: ClassByResCat1Caches.GetClass(TS, Zajecia, iif(AObjectId = -1, CONResCat1.Text, intToStr(AObjectId)), Status, Class_);
           End;
           Case Status Of
            ClassNotFound : Begin End;
            ClassFound    : DeleteClass(Class_,-1);
            ClassError    : DeleteClass(Class_,-1);
           End;
          End;
      Refresh;
     End;
  refreshPanels;
end;

procedure TFMain.Rodzajerezerwacji1Click(Sender: TObject);
begin
  inherited;
  RESERVATIONS_KINDSShowModalAsBrowser;
  BuildCalendar('X');
end;

procedure TFMain.showClasses(ignoreLgr, selectedDatesOnly : boolean);
var l,g,r : shortString;
begin
  l := '';
  g := '';
  r := '';
  if ignoreLgr=false then
    Case TabViewType.TabIndex of
     0: l := ExtractWord(1, ConLecturer.Text,  [';']);
     1: g := ExtractWord(1, ConGroup.Text   ,  [';']);
     2: r := ExtractWord(1, conResCat0.Text ,  [';']);
     3: r := ExtractWord(1, conResCat1.Text ,  [';'])
    end;

  AutoCreate.CLASSESShowModalAsBrowser('CLASSES',l,g,r, CONPERIOD.Text,'','','',selectedDatesOnly);
end;

procedure TFMain.LegendClick(Sender: TObject);
var currentDockingPanel : tpanel;
begin
 If Legend.Down  Then
 begin
   case dockingPanel of
    C_RIGHT   : currentDockingPanel := fmain.pRightDockPanel;
    C_LEFT    : currentDockingPanel := fmain.pLeftDockPanel;
    C_FLOATING: currentDockingPanel := nil;
    else begin
      dockingPanel := C_RIGHT;
      currentDockingPanel := fmain.pRightDockPanel;
    end;
   end;

   if dockingPanel <> C_FLOATING then begin
     FLegend.Width  := strToInt( getSystemParam('FLegend.Width' ,'400' ) );
     flegend.ManualDock(currentDockingPanel);
   end;
   fLegend.Show;
   if dockingPanel <> C_FLOATING then
     currentDockingPanel.DockManager.ResetBounds(true);
 end
 else
 begin
   if FLegend.Visible then
       FLegend.Close;
   //with flegend do
   //  ManualFloat(rect(Left,Top,Left+UndockWidth,Top + undockHeight ));
 end;

 Legenda1.Checked := Legend.Down;
end;

procedure TClassByChildCache.ccLoadPeriod(PER_ID: Integer; childId: String; _SQL: String; pres_type: string);
Var t : Integer;
    DateFrom, DateTo : String;
    X, Y : Integer;
    L1, L2 : Integer;
    aMaxHours : Integer;
    pcleanUpMode : shortstring;

    Procedure internalInit (aFirstDay, aCount, aMaxHours : Integer);
    Var t, t2 : Integer;
    Begin
      MaxHours := aMaxHours;
      SetLength(Data, aCount);       // inicjuje dlugosc tabeli dynamicznej ...
      for t := 0 to aCount -1 do     // ... i to samo dla kazdej tabeli zagniezdzonej
        setLength(Data[t], MaxHours+1);

      FirstDay := aFirstDay;
      Count    := aCount;

     For t := 0 To Count-1 Do
      For t2 := 1 To MaxHours Do
        Data[t][t2].Valid := False;
    End;

begin
  dInitDone := 'In progress per_id='+inttostr(PER_ID)+' childId='+childId;

  If (PER_ID = 0) Or (PER_ID = -1) Then Exit;
  If (childId = '0') Or (childId = '-1') or (isBlank(childId)) Then Exit;


  pcleanUpMode := iif(fmain.recreateDependencies.Checked,'+','-');

  with dmodule.QWork do begin
    SQL.Clear;
    SQL.Add(
	  'begin '+ cr+
	  ' planner_utils.insert_dependency_classes (:pres_id, :pres_type, :pper_id, :pcleanUpMode); '+ cr+
	  'end;'
	  );
    parameters.ParamByName('pres_id').value    := childId;
    parameters.ParamByName('pres_type').value  := pres_type;
    parameters.ParamByName('pper_id').value    := PER_ID;
    parameters.ParamByName('pcleanUpMode').value:= pcleanUpMode;

    execSQL;
  end;

  dPER_ID := PER_ID;
  dchildId := childId;
  d_SQL := _SQL;

  With DModule Do Begin
   Dmodule.SingleValue(CustomdateRange('SELECT TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD''), date_to-date_from, DATE_FROM, HOURS_PER_DAY FROM PERIODS WHERE ID='+IntToStr(PER_ID)));
   DateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
   DateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';
   Count    :=  QWork.Fields[2].AsInteger+1;

   FirstDay := DateTimeToTimeStamp(QWork.Fields[3].AsDateTime).Date;
   aMaxHours := QWork.Fields[4].AsInteger;

   internalInit (FirstDay, Count, aMaxHours);

   For L1 := 0 To Count -1 Do Begin
     For L2 := 1 To MaxHours Do Begin
       Data[L1][L2].Valid  := True;
       Data[L1][L2].Status := ClassNotFound;
      End;
   End;

  OPENSQL(
   'SELECT CLA.*, '+
   '       SUB.abbreviation SUB_abbreviation,SUB.NAME SUB_NAME,SUB.COLOUR SUB_COLOUR,FRM.COLOUR FOR_COLOUR, OWNER.COLOUR OWNER_COLOUR, CREATOR.COLOUR CREATOR_COLOUR, CLA.COLOUR CLASS_COLOUR, CLA.DESC1, CLA.DESC2, CLA.DESC3, CLA.DESC4,'+
   '       FRM.abbreviation FOR_abbreviation,FRM.NAME FOR_NAME,FRM.KIND FOR_KIND '+
   'FROM CLASSES CLA, '+
   '     subjects SUB, '+
   '     FORMS FRM, '+
   '     PLANNERS OWNER, '+
   '     PLANNERS CREATOR '+
   'WHERE SUB.ID (+)= CLA.SUB_ID AND OWNER.NAME (+)= CLA.OWNER AND CREATOR.NAME (+)= CLA.CREATED_BY AND CLA.FOR_ID = FRM.ID AND '+
   '      CLA.DAY BETWEEN '+DateFrom+' AND '+DateTo+' AND '+
   '      CLA.ID IN ('+_SQL+'('+ExtractWord(1,childId,[';'])+')) ');

  While Not QWork.EOF Do Begin
   X := DateTimeToTimeStamp(QWork.FieldByName('DAY').AsDateTime).Date;
   Y := QWork.FieldByName('HOUR').AsInteger;

   t := X-FirstDay;

   if  (t < 0) or (t >high(data)) then SError('Wyst¹pi³o zdarzenie "3 Liczba dni poza zakresem". Zg³oœ problem serwisowi, lub usuñ b³êdne rekordy za pomoc¹ formularza Lista Zajêæ') else
   if  (y < 1) or (y >MaxHours) then //Warning('Zaplanowana liczba godzin ( wartoœæ '+inttostr(y)+') jest wiêksza, ni¿ liczba godzin zdefiniowana dla semestru. Powoduje to, ¿e czêœæ zaplanowanych rekordów nie pojawia siê na ekranie. Mo¿liwe rozwi¹zania problemu: '+'1. Zwiêksz liczbê godzin w definicji dla semestru lub 2. Usuñ b³êdne rekordy za pomoc¹ formularza Lista Zajêæ lub 3. Przeka¿ opis problemu serwisowi')
   else begin
     //dGeneralDebug := 'Status='+inttostr(Data[t][y].Status) + 'day='+ dateToYYYYMMDD_HHMMSSMI(QWork.FieldByName('DAY').AsDateTime) +'hour='+ QWork.FieldByName('HOUR').AsString + ' ' + qwork.SQL.Text; //@@@@
     Data[t][y].Status := SuccStatus(Data[t][y].Status);
     //if (Data[t][y].Status=classError) then begin
     // info('@@@@ ERROR4 ' + dGeneralDebug);
     // fmain.Memo1.Lines.Text := dGeneralDebug;
     // copyToClipboard('@@@@ ERROR4 ' + dGeneralDebug);
     // end;
     Data[t][y].Class_ := QWorkToClass;
   end;

   QWork.Next;
  End;
  End;

  dHighData := high(data);
  dInitDone := 'Y';
end;

procedure TFMain.buildMenu;
 var item : tMenuItem;
     lVisible : boolean;

     Procedure synchronizeComboboxColor( pcombobox : TComboBox);
     Var j    : integer;
         tmp  : integer;
     begin
       tmp := pcombobox.ItemIndex;
       with pcombobox.Items do
       begin
         for j := 0 to Count - 1 do
         begin
           if assigned(Objects[j]) then begin
             TString(Objects[j]).Free;
             Objects[j] := nil;
           end;
         end;
         Clear;
         AddObject(fprogramSettings.profileObjectNameL.Text, TString.Create('L')         );
         AddObject(fprogramSettings.profileObjectNameG.Text, TString.Create('G')         );
         //
         dmodule.QWork.first;
         while not dmodule.QWork.Eof do begin
          AddObject(dmodule.QWork.fieldByName('NAME').AsString ,  TString.Create(  dmodule.QWork.fieldByName('ID').AsString  )  );
          dmodule.QWork.Next;
         end;
         //
         AddObject(fprogramSettings.profileObjectNameC1.Text, TString.Create('S')         );
         AddObject(fprogramSettings.profileObjectNameC2.Text, TString.Create('F')         );
         AddObject('W³aœciciel', TString.Create('OWNER')     );
         AddObject('Utworzy³'  , TString.Create('CREATED_BY'));
         AddObject(fprogramSettings.profileObjectNameClass.Text , TString.Create('CLASS')     );
         //red color for description
         if not isBlank(FProgramSettings.getClassDescPlural(1)) then AddObject(FProgramSettings.getClassDescPlural(1), TString.Create('DESC1') );
         if not isBlank(FProgramSettings.getClassDescPlural(2)) then AddObject(FProgramSettings.getClassDescPlural(2), TString.Create('DESC2') );
         if not isBlank(FProgramSettings.getClassDescPlural(3)) then AddObject(FProgramSettings.getClassDescPlural(3), TString.Create('DESC3') );
         if not isBlank(FProgramSettings.getClassDescPlural(4)) then AddObject(FProgramSettings.getClassDescPlural(4), TString.Create('DESC4') );
         AddObject('Zasoby - wszystkie', TString.Create('ALL_RES')      );
         AddObject('Brak'      , TString.Create('NONE')      );
       end;

       if tmp+1 > pcombobox.Items.Count then pcombobox.ItemIndex := -1
                                        else pcombobox.ItemIndex := tmp;
     end;

     Procedure synchronizeComboboxDesc( pcombobox : TComboBox);
     Var j    : integer;
         tmp  : integer;
     begin
       tmp := pcombobox.ItemIndex;
       with pcombobox.Items do
       begin
         for j := 0 to Count - 1 do
         begin
           if assigned(Objects[j]) then begin
             TString(Objects[j]).Free;
             Objects[j] := nil;
           end;
         end;
         Clear;

         AddObject(fprogramSettings.profileObjectNameL.Text, TString.Create('L')         );
         AddObject(fprogramSettings.profileObjectNameG.Text, TString.Create('G')         );
         //
         dmodule.QWork.first;
         while not dmodule.QWork.Eof do begin
          AddObject(dmodule.QWork.fieldByName('NAME').AsString ,  TString.Create(  dmodule.QWork.fieldByName('ID').AsString  )  );
          dmodule.QWork.Next;
         end;
         //
         AddObject(fprogramSettings.profileObjectNameC1.Text, TString.Create('S')         );
         AddObject(fprogramSettings.profileObjectNameC2.Text, TString.Create('F')         );
         AddObject(fprogramSettings.profileObjectNameC1.Text+'+'+fprogramSettings.profileObjectNameC2.Text, TString.Create('SF')        );
         AddObject('Utworzy³'          , TString.Create('CREATED_BY'));
         AddObject('W³aœciciel'        , TString.Create('OWNER')     );
         AddObject('Zasoby - wszystkie', TString.Create('ALL_RES')   );
         AddObject('Brak'              , TString.Create('NONE')      );
         if not isBlank(FProgramSettings.getClassDescPlural(1)) then AddObject(FProgramSettings.getClassDescPlural(1), TString.Create('DESC1') );
         if not isBlank(FProgramSettings.getClassDescPlural(2)) then AddObject(FProgramSettings.getClassDescPlural(2), TString.Create('DESC2') );
         if not isBlank(FProgramSettings.getClassDescPlural(3)) then AddObject(FProgramSettings.getClassDescPlural(3), TString.Create('DESC3') );
         if not isBlank(FProgramSettings.getClassDescPlural(4)) then AddObject(FProgramSettings.getClassDescPlural(4), TString.Create('DESC4') );
       end;

       if tmp+1 > pcombobox.Items.Count then pcombobox.ItemIndex := -1
                                        else pcombobox.ItemIndex := tmp;
     end;

begin
 if MM.Items[3].Caption <> '&S³owniki' then begin
  SError('B³¹d w procedurze buildMenu. Jest:"'+MM.Items[3].Caption+'". Powinno byæ:"&S³owniki". Zg³oœ problem asyœcie technicznej');
 end;

 // usuñ pozycje menu ( je¿eli s¹ )
 While MM.Items[3].Count > 12 do
   MM.Items[3].Delete(MM.Items[3].count-1);

 With DModule do begin
   // select custom categories only
   openSQL('select * from resource_categories where id > 0 order by name');
   while not QWork.Eof do begin
    item := tMenuItem.Create(self);
    item.Caption := QWork.fieldByName('NAME').AsString;
    item.Tag := QWork.fieldByName('ID').AsInteger;
    item.OnClick := RESOURCESClick;
    MM.Items[3].Add(item);
    QWork.Next;
   end;
 end;
 synchronizeComboboxColor ( FcellLayout.Coloring );
 synchronizeComboboxColor ( FSettings.LViewType );
 synchronizeComboboxColor ( FSettings.GViewType );
 synchronizeComboboxColor ( FSettings.RViewType );

 synchronizeComboboxDesc ( FcellLayout.D1 );
 synchronizeComboboxDesc ( FcellLayout.D2 );
 synchronizeComboboxDesc ( FcellLayout.D3 );
 synchronizeComboboxDesc ( FcellLayout.D4 );
 synchronizeComboboxDesc ( FcellLayout.D5 );
 synchronizeComboboxDesc ( FcellLayout.D6 );
 synchronizeComboboxDesc ( FcellLayout.D7 );
 synchronizeComboboxDesc ( FcellLayout.D8 );

 with FSettings do begin
 synchronizeComboboxDesc ( LD1 );
 synchronizeComboboxDesc ( LD2 );
 synchronizeComboboxDesc ( LD3 );
 synchronizeComboboxDesc ( LD4 );
 synchronizeComboboxDesc ( LD5 );
 synchronizeComboboxDesc ( GD1 );
 synchronizeComboboxDesc ( GD2 );
 synchronizeComboboxDesc ( GD3 );
 synchronizeComboboxDesc ( GD4 );
 synchronizeComboboxDesc ( GD5 );
 synchronizeComboboxDesc ( RD1 );
 synchronizeComboboxDesc ( RD2 );
 synchronizeComboboxDesc ( RD3 );
 synchronizeComboboxDesc ( RD4 );
 synchronizeComboboxDesc ( RD5 );
 end;

 with fprogramsettings do begin
   //pulpit
   LprofileObjectNamePeriod.Caption := profileObjectNamePeriod.Text;
   LprofileObjectNameL.caption    := profileObjectNameL.Text;
   LprofileObjectNameG.caption    := profileObjectNameG.Text;
   LprofileObjectNameC1.caption     := profileObjectNameC1.Text;
   LprofileObjectNameC2.caption     := profileObjectNameC2.Text;
   //main menu
   mmprofileObjectNameR1s.Caption      := profileObjectNameLs.Text;
   mmprofileObjectNameR2s.Caption      := profileObjectNameGs.Text;
   mmprofileObjectNameC1s.Caption      := profileObjectNameC1s.Text;
   mmprofileObjectNameC2s.Caption      := profileObjectNameC2s.Text + ' / rezerwacje';
   mmprofileObjectNamePeriods.Caption  := profileObjectNamePeriods.Text;
   mmprofileObjectNamePlanners.Caption := profileObjectNamePlanners.Text;

   cdesc1.Visible := FProgramSettings.getClassDescPlural(1)<>'';
   cdesc2.Visible := FProgramSettings.getClassDescPlural(2)<>'';
   cdesc3.Visible := FProgramSettings.getClassDescPlural(3)<>'';
   cdesc4.Visible := FProgramSettings.getClassDescPlural(4)<>'';
   ddesc1.Visible := FProgramSettings.getClassDescPlural(1)<>'';
   ddesc2.Visible := FProgramSettings.getClassDescPlural(2)<>'';
   ddesc3.Visible := FProgramSettings.getClassDescPlural(3)<>'';
   ddesc4.Visible := FProgramSettings.getClassDescPlural(4)<>'';

   Cdesc1.Caption := 'Zmieñ '+FProgramSettings.getClassDescPlural(1);
   Cdesc2.Caption := 'Zmieñ '+FProgramSettings.getClassDescPlural(2);
   Cdesc3.Caption := 'Zmieñ '+FProgramSettings.getClassDescPlural(3);
   Cdesc4.Caption := 'Zmieñ '+FProgramSettings.getClassDescPlural(4);
   ddesc1.Caption := 'Usuñ '+FProgramSettings.getClassDescPlural(1);
   ddesc2.Caption := 'Usuñ '+FProgramSettings.getClassDescPlural(2);
   ddesc3.Caption := 'Usuñ '+FProgramSettings.getClassDescPlural(3);
   ddesc4.Caption := 'Usuñ '+FProgramSettings.getClassDescPlural(4);


   //hardcoding
   lVisible := profileType.ItemIndex = 0;
   mmplanL.Visible      := lVisible;
   mmplanG.Visible      := lVisible;
   mmplanR.Visible      := lVisible;
   mmfreeLGR.Visible    := lVisible;
   mmfreeGR.Visible     := lVisible;
   mmfreeLR.Visible     := lVisible;
   mmfreeLG.Visible     := lVisible;
   mmfreeFooter.Visible := lVisible;
   mmconsolidation.Visible := lVisible;
   mmpurge.Visible      := lVisible;
   FormFormulas.Visible := lVisible;
   massImport.Visible   := lVisible;
   MMDiagram.Visible    := lVisible;
   N14.Visible          := lVisible;

   //legend
   with FLegend do begin
     TabsheetL.caption     := profileObjectNameLs.Text;
     TabsheetG.caption     := profileObjectNameGs.Text;
     TabsheetS.caption     := profileObjectNameC1s.Text;
     groupByForm.Caption   := profileObjectNameC2s.Text;
     groupByDesc1.Caption  := getClassDescPlural(1);
     groupByDesc2.Caption  := getClassDescPlural(2);
     groupByDesc3.Caption  := getClassDescPlural(3);
     groupByDesc4.Caption  := getClassDescPlural(4);
     groupByLDesc1.Caption := getClassDescSingular(1);
     groupByLDesc2.Caption := getClassDescSingular(2);
     groupByLDesc3.Caption := getClassDescSingular(3);
     groupByLDesc4.Caption := getClassDescSingular(4);
     groupByL.Caption      := profileObjectNameL.Text;
     SelectedSubOnly.caption           := 'Tylko wybrany: '+ profileObjectNameC1.Text;
   end;

   //main window toolbar: 3mm
   ppaddL.Caption       := 'Do³¹cz '+ profileObjectNameLacc.Text;
   ppAddG.Caption       := 'Do³¹cz '+ profileObjectNameGacc.Text;
   ppchangeS.Caption    := 'Zmieñ ' + profileObjectNameC1acc.Text;
   ppchangeF.Caption    := 'Zmieñ ' + profileObjectNameC2acc.Text;
   ppchangeClass.Caption:= 'Zmieñ ' + profileObjectNameClassacc.Text;
   ppminusL.Caption     := 'Od³¹cz '+ profileObjectNameLacc.Text;
   ppminusG.Caption     := 'Od³¹cz '+ profileObjectNameGacc.Text;
   ppminusS.Caption     := 'Od³¹cz '+ profileObjectNameC1acc.Text;
   LGRpp.Caption        := 'WGZ:  Poka¿ dostêpne terminy dla :'+ profileObjectNameLgen.Text + ',' + profileObjectNameGgen.Text + ', Zasobu';
   LGpp.Caption         := 'WGZ:  Poka¿ dostêpne terminy dla :'+ profileObjectNameLgen.Text + ',' + profileObjectNameGgen.Text;
   LRpp.Caption         := 'WGZ:  Poka¿ dostêpne terminy dla :'+ profileObjectNameLgen.Text + ', Zasobu';
   GRpp.Caption         := 'WGZ:  Poka¿ dostêpne terminy dla :'+ profileObjectNameGgen.Text + ', Zasobu';

   //main window baloon hints          10min
   BAddClass.hint    := 'Dodaj ' + profileObjectNameClasses.Text + ' lub rezerwacje';
   BEditClass.hint   := 'Edytuj '+ profileObjectNameClasses.Text;
   BDeleteClass.hint := 'Usuñ '  + profileObjectNameClasses.Text;
   //main window texts

   //class details  +texts
   with fdetails do
   begin
     TSClasses.Caption := profileObjectNameClass.Text;
     LL1.Caption       := profileObjectNameLs.Text;
     LG1.Caption       := profileObjectNameGs.Text;
     LS1.Caption       := profileObjectNameC1.Text;
     LF1.Caption       := profileObjectNameC2.Text;
     LL2.Caption       := profileObjectNameLs.Text;
     LG2.Caption       := profileObjectNameGs.Text;
     LF2.Caption       := profileObjectNameC2.Text;
     //
     SelectL1.Hint     := 'Wybierz ' + profileObjectNameLacc.Text;
     SelectL2.Hint     := 'Wybierz ' + profileObjectNameLacc.Text;
     SelectG1.Hint     := 'Wybierz ' + profileObjectNameGacc.Text;
     SelectG2.Hint     := 'Wybierz ' + profileObjectNameGacc.Text;
     SelectS1.Hint     := 'Wybierz ' + profileObjectNameC1acc.Text;
     SelectF1.Hint     := 'Wybierz ' + profileObjectNameC2acc.Text;
     SelectF2.Hint     := 'Wybierz ' + profileObjectNameC2acc.Text;
     //
     L_value1.Hint     := ansiUpperCase( profileObjectNameL.Text );
     L_value2.Hint     := ansiUpperCase( profileObjectNameL.Text );
     G_value1.Hint     := ansiUpperCase( profileObjectNameG.Text );
     G_value2.Hint     := ansiUpperCase( profileObjectNameG.Text );
     S_value1.Hint     := ansiUpperCase( profileObjectNameC1.Text );
     F_value1.Hint     := ansiUpperCase( profileObjectNameC2.Text );
     //
     //Lhint1.caption    := format('Aby usun¹æ %s, %s lub zasób z listy zaznacz pole i ',[profileObjectNameLacc.Text, profileObjectNameGacc.Text]);
     //Lhint2.Caption    := lhint1.Caption;
     //
     rgReservationFor.Items.Clear;
     rgReservationFor.Items.Add(profileObjectNameLgen.Text);
     rgReservationFor.Items.Add(profileObjectNameGgen.Text);
     rgReservationFor.Items.Add(dmodule.pResCatName0); //@@@form
     rgReservationFor.Items.Add(dmodule.pResCatName1);
   end;

   //prints
   with FSettings do begin
     TabSheetL.Caption := profileObjectNameLs.Text;
     TabSheetG.Caption := profileObjectNameGs.Text;
     //
     LMaxLengthCALC_GROUPS.Caption      := format('Maksymalna d³ugoœæ nazwy %s w komórce w znakach', [profileObjectNameGgen.Text]);
     LMaxLengthCALC_LECTURERS.Caption   := format('jw. dla %s', [profileObjectNameLgen.Text]);
     LMaxLengthSUB_abbreviation.Caption := format('jw. dla %s', [profileObjectNameC1gen.Text]);
     LMaxLengthFOR_abbreviation.Caption := format('jw. dla %s', [profileObjectNameC2gen.Text]);
     LMaxLecturersInLegend.Caption      := format('Legenda: %s - maksymalna liczba przy jednym %s', [profileObjectNameLs.Text, profileObjectNameC1gen.Text]);
   end;

   with fShowConflicts do begin
     PanelNew.Caption           := format('%s - nowe', [profileObjectNameClass.Text]);
     PanelIs.Caption            := format('%s - istniej¹ce', [profileObjectNameClasses.Text]);
     infoDeleteForbiden.Caption := format('Nie powiedzie siê usuniêcie %s, poniewa¿ w³aœcicielem tych danych jest inny %s', [profileObjectNameClassgen.Text, profileObjectNamePlanner.Text]);
     BDelete.Caption            := format('Usuñ istniej¹ce %s a nastêpnie dopisz nowe', [profileObjectNameClasses.Text]);

     SGNewClass.Cells[0,0] := 'Data';
     SGNewClass.Cells[1,0] := 'Blok';
     SGNewClass.Cells[2,0] := profileObjectNameLs.Text;
     SGNewClass.Cells[3,0] := profileObjectNameGs.Text;
     SGNewClass.Cells[4,0] := 'Zasoby';
     SGNewClass.Cells[5,0] := profileObjectNameC1.Text;
     SGNewClass.Cells[6,0] := profileObjectNameC2.Text + '/ rezerwacja';
     SGNewClass.Cells[7,0] := 'W³aœciel';

     SGConflicts.Cells[0,0] := 'Data';
     SGConflicts.Cells[1,0] := 'Blok';
     SGConflicts.Cells[2,0] := profileObjectNameLs.Text;
     SGConflicts.Cells[3,0] := profileObjectNameGs.Text;
     SGConflicts.Cells[4,0] := 'Zasoby';
     SGConflicts.Cells[5,0] := profileObjectNameC1.Text;
     SGConflicts.Cells[6,0] := profileObjectNameC2.Text + '/ rezerwacja';
     SGConflicts.Cells[7,0] := 'W³aœciel';
     SGConflicts.Cells[8,0] := 'Przyczyna';
   end;
   //uprawnienia do obj +texts
   // dict windows - details + rzutnik +hints
   // classes       +texts
     //po zmienie profilu programu trzeba wymusic wyzerowanie opisow w plikach konfig, w innym razie w oknie classes pozostaja stare etykiety
     //sortorder captions
   //FWWWGenerator - filters
   // FGrouping: group stats +texts
   //  texts
   //kopiuj rozklad - detail +texts
   //lock
     //scalaj  +texts
     //massImport
     //delete archive +texts
   //typy ograniczen / ograniczenia  +texts

   // ->
   // clear db
   // default forms, subjects
   // problem z pesel
   // movie
 end;
end;

procedure TFMain.commandLineGrouping     (inifilename : string);
var exportMethod : shortstring;
    filename     : tfilename;
begin
  silentMode := true;
  with FGrouping do begin
    show;
    LoadFromIni( inifilename );
    BRefreshClick(BRefresh);

    exportMethod := uutilityparent.LoadFromIni(inifilename , 'grouping', 'exportMethod','');
    filename     := uutilityparent.LoadFromIni(inifilename , 'grouping', 'filename','');

    if exportMethod = 'txt'                            then SaveAsTxt( filename );
    if exportMethod = 'html'                           then SaveAsHtml( filename );
    if exportMethod = 'csv'                            then SaveAsCsv( filename );
    if exportMethod = 'LEC_UTILIZATION_SEPARATE_LINE'  then generateReport (LEC_UTILIZATION, true,  true, filename);
    if exportMethod = 'LEC_UTILIZATION'                then generateReport (LEC_UTILIZATION, false, true, filename);
    if exportMethod = 'STUDENTHOURS_SEPARATE_LINE'     then generateReport (STUDENTHOURS,    true,  true, filename);
    if exportMethod = 'STUDENTHOURS'                   then generateReport (STUDENTHOURS,    false, true, filename);

  end;
end;

procedure TFMain.commandLineWwwGenerator ( inifilename : string );
var  iniFile : tinifile;
     pperiodName, pRoleName     : string[255];
     pgentype                   : integer;
     pdefaultFolder             : string ;
     pAddText                   : string ;
     pDoNotGenerateTableOfCon   : boolean;
     pGoogleUser                : string ;
     pGooglePassword            : string ;
     pGoogleSavePassword        : boolean;
     pGroups                    : boolean;
     pResources                 : boolean;
     pLecturers                 : boolean;
     pPrintSettingsFileName     : string;

     periodId, roleId           : string[255];
begin
 iniFile := TIniFile.Create( inifilename );

 With iniFile do begin
   pPeriodName              := ReadString ('wwwgenerator','PeriodName','');     //'2013.PS-ISE--2';
   pGenType                 := ReadInteger('wwwgenerator','GenType',0);         //0; //0=www 1=google cal
   pDefaultFolder           := ReadString ('wwwgenerator','DefaultFolder','');
   pAddText                 := ReadString ('wwwgenerator','AddText','');
   pDoNotGenerateTableOfCon := ReadBool   ('wwwgenerator','DoNotGenerateTableOfCon',false);
   pGoogleUser              := ReadString ('wwwgenerator','GoogleUser','');
   pGooglePassword          := ReadString ('wwwgenerator','GooglePassword','');
   pGoogleSavePassword      := ReadBool   ('wwwgenerator','GoogleSavePassword',false);
   pRoleName                := ReadString ('wwwgenerator','RoleName','');
   pGroups                  := ReadBool   ('wwwgenerator','Groups',true);
   pResources               := ReadBool   ('wwwgenerator','Resources',true);
   pLecturers               := ReadBool   ('wwwgenerator','Lecturers',true);
   pPrintSettingsFileName   := ReadString ('wwwgenerator','PrintSettingsFileName','');
 end;

 iniFile.Free;

 silentMode := true;

 periodId := dmodule.SingleValue('SELECT ID FROM PERIODS  WHERE NAME =:NAME','NAME='+pperiodName);
 if proleName <> ''
   then roleId := dmodule.SingleValue('SELECT ID FROM PLANNERS WHERE NAME =:NAME','NAME='+proleName)
   else roleId := '';

 conPeriod.Text := periodid;
 conRole.text   := RoleId;
 setPeriod;

 FWWWGenerator  := TFWWWGenerator.Create(Application);
 with FWWWGenerator do begin
     currentPeriod.Text               := periodid;
     genType.ItemIndex                := pgenType;
     defaultFolder                    := pdefaultFolder;
     addText.Text                     := pAddText;
     DoNotGenerateTableOfCon.Checked  := pDoNotGenerateTableOfCon;
     Groups.Checked                   := pGroups;
     Resources.Checked                := pResources;
     Lecturers.Checked                := pLecturers;
     Show;
     with fsettings do begin
       Show;
       if pPrintSettingsFileName <> '' then Load(pPrintSettingsFileName);
       BOKClick(nil);
     end;

     BCreateClick(nil);
     Free;
 end;
end;

Function TFMain.Logon : Boolean;
Var aUserName, aPassword, aDBName : ShortString;
    loginParamsDelivered : boolean;
    gProvider : string;

      procedure commandLineProcessing;
         var
            paramString : string;
            Command     : string;
            arguments   : string;
            initype     : string;
            iniFile     : TIniFile;
      begin
        paramString := paramStr(4);
        command     := upperCase(ExtractWord(1,paramString,['=']));
        arguments   := extractWord(2,paramString,['=']);

        if not(command = 'INIFILE') then exit;

        if extractFileName( arguments ) = arguments then
          arguments :=  uutilityParent.ApplicationDocumentsPath + arguments;

        if not fileExists( arguments ) then
         arguments := ApplicationDir + '\' + extractFileName( arguments );

        if not fileExists( arguments ) then begin
          info('Nie mo¿na wykonaæ przetwarzania w tle, poniewa¿ plik ini nie zosta³ odnaleziony: ' + extractFileName( arguments ));
          exit;
        end;

        iniFile := TIniFile.Create(arguments);
        initype := iniFile.ReadString ('initype','initype','');
        iniFile.Free;

        //@@@todo
        // documentation
        //    export sql
        //    export history
        //    export dictionaries

        if initype = 'wwwgenerator' then
        begin
          commandLineWwwGenerator ( arguments );
          close;
        end;

        if initype = 'grouping' then
        begin
          commandLineGrouping(  arguments );
          close;
        end;
      end;

  function decryptPassword (p : string) : string;
  var decryptedPassword : string;
  begin
    decryptedPassword := uutilityparent.DecryptShortString(1, p, 'SoftwareFactory');
    if copy(decryptedPassword, 1, 9) = 'PASSWORD:'
      then result :=  copy(decryptedPassword, 10, 500)
      else result := p;
  end;

  procedure autoUpdate;
  var LastAutoUpdateDate : string;
      extentionSql, extentionName, extentionDate : string;
      updateFound : boolean;
      i : integer;
      function executeUpdate : boolean;
      begin
          try
          dmodule.sql(extentionSql);
          dmodule.dbsetSystemParam('Extention_installed:'+extentionName+' '+extentionDate,'INSTALLED');
          dmodule.dbsetSystemParam('LastAutoUpdateDate',extentionDate);
          result := true;
          except
             on E:exception do Begin
             dmodule.dbsetSystemParam('Extention_installed:'+extentionName,extentionDate+'FAILED');
             copyToClipboard( extentionSql );
             info ('Wyst¹pi³ b³¹d podczas instalacji rozszerzenia: '+extentionName+'. Mo¿esz kontynuowaæ prace, ale zaleca siê zg³oszenie tego problemu administratorowi systemu'+#13#10#13#10#13#10+E.message);
             result := false;
             end;
          end;
      end;
      procedure getNextUpdate;
      begin
        while (i <> DBUpdates.Lines.Count-1) and (DBUpdates.lines[i]<>'### EXTENTION BEGIN') do inc(i);
        if i= DBUpdates.Lines.Count-1 then begin
            updateFound := false;
            exit;
        end;
        extentionName := Copy(DBUpdates.lines[i+1],20,200);
        extentionDate := Copy(DBUpdates.lines[i+2],10,200);
        i := i + 3;
        extentionSql := '';
        while DBUpdates.lines[i]<>'### EXTENTION END' do begin
            if extentionSql <> '' then extentionSql := extentionSql + #13#10;
            extentionSql := extentionSql + DBUpdates.lines[i];
            inc(i);
        end;
      end;
  begin
      i := 0;
      updateFound    := true;
      LastAutoUpdateDate := dmodule.dbgetSystemParam('LastAutoUpdateDate','1000-01-01');
      getNextUpdate;
      repeat
          if extentionDate > LastAutoUpdateDate then begin
              if ansiUpperCase(userName)<>'PLANNER' then begin
                   info ('Musisz wykonaæ aktualizacjê programu. Aby uruchomiæ aktualizacjê programu musisz zalogowaæ siê na konto u¿ytkownika PLANNER');
                  exit;
              end;
              if not ExecuteUpdate then exit;
          end;
          getNextUpdate;
      until updateFound=false;
  end;

begin
  inherited;
  //configuration must be loaded before login otherwise on unsecceussful login configuration would be lost
  LoadFormConfiguration(FCellLayout);

  gProvider         := GetSystemParam('Provider', 'OraOLEDB.Oracle.1');
  CanShow           := False;
  GridPanel.Visible := False;

  DModule.CloseDBConnection;

  Result    := False;
  aUserName := nvl(getSystemParam('LoginUserName'),'PLANNER');
  aPassword := getSystemParam('LoginPassword');
  aDBName   := nvl(getSystemParam('LoginDataBaseName'),'XE');

  loginParamsDelivered := false;

  if (paramStr(1) <> '') and (paramStr(2) <> '') and (paramStr(3) <> '') and (StartUp) then
  begin
    aUserName := paramStr(1);
    aPassword := decryptPassword( paramStr(2) );
    aDBName   := nvl(paramStr(3), aDBName);
    loginParamsDelivered := true;
  end;

  if not loginParamsDelivered then
    If Login(aDBName, aUserName, aPassword) = mrOK Then begin
      loginParamsDelivered := true;
      setSystemParam('LoginDataBaseName', aDBName);
      setSystemParam('LoginUserName', aUserName);
    end;

  StartUp := false;

  if loginParamsDelivered then
  Begin
   if upperCase(aDBName) = 'WAT'  then aDBName := 'planner.wat.edu.pl:1522/planner';
   if upperCase(aDBName) = 'DOK'  then aDBName := 'prddokplanner.wat.edu.pl:1521/xe';
   if upperCase(aDBName) = 'XE'   then aDBName := '127.0.0.1:1521/xe';

   DM.UserName  := aUserName;
   DM.Password  := aPassword;
   DM.DBname    := aDBName;
   DModule.ADOConnection.ConnectionString := 'Provider='+gProvider+';Password='+aPassword+';Persist Security Info=True;User ID='+aUserName+';Data Source='+aDBName;
                                            //Provider=OraOLEDB.Oracle.1;Password=4154;Persist Security Info=True;User ID=planner;Data Source=planner.wat.edu.pl:1522/planner

   Try
     //dmodule.ADOConnection.Attributes :=  dmodule.ADOConnection.Attributes + [xaCommitRetaining];
     //dmodule.ADOConnection.Attributes :=  dmodule.ADOConnection.Attributes + [xaAbortRetaining];
     dmodule.ADOConnection.Open;
     dmodule.ADOConnection.BeginTrans;
   Except
    on E:EDatabaseError do SError('Nie powiod³o siê zalogowanie z powodu nastêpuj¹cego b³êdu:'+CR+E.Message);
    on E:exception      do SError('Nie powiod³o siê zalogowanie z powodu nastêpuj¹cego b³êdu:'+CR+E.Message);
   End;
  End;

  Result :=  DModule.ADOConnection.Connected;
  If Not Result Then Exit;

  //set the role
  DModule.SQL(DModule.AdditionalPerrmisions.Strings[0]);

  If Not Assigned(FLegend) Then FLegend := TFLegend.Create(Application);
  dmodule.pResCatId0 := nvl( getSystemParam('RESOURCE_CATEGORY_ID0')  , dmodule.dbgetSystemParam('RESOURCE_CATEGORY_ID0'));
  dmodule.pResCatId1 := nvl( getSystemParam('RESOURCE_CATEGORY_ID1')  , dmodule.dbgetSystemParam('RESOURCE_CATEGORY_ID1'));

  //set abolition time = sysdate
  with dmodule do
  if dbgetSystemParam('PLANOWANIE.LICENCE_FOR') <> 'Wersja demonstracyjna' then begin
    if dbgetSystemParam('FIRST_LOGON_FLAG','Y')='Y' then begin
      //dbEncSetSystemParam('ABOLITION_TIME', currentYear + '.' + currentMonth + '.' + currentDay );
      dbEncSetSystemParam('ABOLITION_TIME', '2012.01.30' );
      dbSetSystemParam('FIRST_LOGON_FLAG','N');
    end;
  end;

  dmodule.pAbolitionTime := dmodule.dbEncGetSystemParam( 'ABOLITION_TIME' ) ;

  onpResCatId0Change;
  onpResCatId1Change;

  fprogramSettings.loadConfiguration;

  buildMenu;

  If  0=StrToInt(DModule.SingleValue2('select count(1) from SYS.DBA_ROLE_PRIVS WHERE GRANTEE=USER AND GRANTED_ROLE=''PLA_PERMISSION''')) Then Begin
    Info('Nie masz uprawnieñ do korzystania z aplikacji - brak nadanych uprawnieñ');
    Result := False;
    Exit;
  End;

  autoUpdate;
  setHistoryEnabled;

  //if dmodule.SingleValue('select count(*) from grids') = '0' then uutilities.importPreviousGridSettings;

  Try
    CurrentUserName  := DModule.SingleValue('SELECT NAME, ID, IS_ADMIN,EDIT_ORG_UNITS, EDIT_FLEX, LOG_CHANGES, MANY_SUBJECTS_FLAG, CAL_ID, EDIT_RESERVATIONS, edit_sharing, Can_Edit_L, Can_Edit_G, '+'Can_Edit_R, Can_Edit_S, Can_Edit_F, Can_Delete, Can_Insert, Can_Edit_O, Can_Edit_D, first_Resource_Flag FROM PLANNERS WHERE NAME=USER');
    UserID           := DModule.QWork.Fields[1].AsString;
    isAdmin          := DModule.QWork.Fields[2].AsString = '+';
    EditOrgUnits     := DModule.QWork.Fields[3].AsString = '+';
    EditFlex         := DModule.QWork.Fields[4].AsString = '+';
    LogChanges       := DModule.QWork.Fields[5].AsString = '+';
    manySubjectsFlag := DModule.QWork.Fields[6].AsString = '+';
    confineCalendarId:= DModule.QWork.Fields[7].AsString;
    editReservations := DModule.QWork.Fields[8].AsString = '+';
    editSharing      := DModule.QWork.Fields[9].AsString = '+';
    CanEditL      := DModule.QWork.Fields[10].AsString = '+';
    CanEditG      := DModule.QWork.Fields[11].AsString = '+';
    CanEditR      := DModule.QWork.Fields[12].AsString = '+';
    CanEditS      := DModule.QWork.Fields[13].AsString = '+';
    CanEditF      := DModule.QWork.Fields[14].AsString = '+';
    CanDelete     := DModule.QWork.Fields[15].AsString = '+';
    CanInsert     := DModule.QWork.Fields[16].AsString = '+';
    CanEditO      := DModule.QWork.Fields[17].AsString = '+';
    CanEditD      := DModule.QWork.Fields[18].AsString = '+';
    CanEditAll  := CanEditL and CanEditG and CanEditR and CanEditS and CanEditF and CanEditO and CanEditD;
    gFirstResourceFlag := DModule.QWork.Fields[19].AsString = '+';

    ppaddL.Enabled := canEditL;
    ppminusL.Enabled := canEditL;
    ppAddG.Enabled := canEditG;
    ppminusG.Enabled := canEditG;
    ppAddR.Enabled := canEditR;
    ppminusR.Enabled := canEditR;
    ppchangeS.Enabled := canEditS;
    ppminusS.Enabled := canEditS;
    ppchangeF.Enabled := canEditF;

    ppDelete.Enabled := canDelete;
    bdelpopup.Enabled := canDelete or CanEditL or CanEditG or CanEditR or CanEditS or CanEditF or CanEditO or CanEditD;

    ppAddO.Enabled := canEditO;
    ppChangeO.Enabled := canEditO;
    ppchangeClass.Enabled := canEditAll;
    Cdesc1.Enabled := canEditD;
    Cdesc2.Enabled := canEditD;
    Cdesc3.Enabled := canEditD;
    Cdesc4.Enabled := canEditD;
    ppminusO.Enabled := canEditO;
    Ddesc1.Enabled := canEditD;
    Ddesc2.Enabled := canEditD;
    Ddesc3.Enabled := canEditD;
    Ddesc4.Enabled := canEditD;

  Except CurrentUserName := ''; SError('Wyst¹pi³ b³¹d krytyczny podczas wykonywania zapytania SELECT NAME FROM PLANNERS WHERE NAME=USER'); raise; End;

  dmodule.loadMap('select id,NVL(COLOUR,0) from lecturers', MapLecColors, true);
  dmodule.loadMap('select id,NVL(COLOUR,0) from groups', MapGroColors, true);
  dmodule.loadMap('select id,NVL(COLOUR,0) from rooms', MapRomColors, true);
  //
  dmodule.loadMap('select lpad(id,10,''0''), last_name||'' ''||first_name from lecturers order by id', MapLecNames, true);
  dmodule.loadMap('select id, decode(type,''USER'','''',''ROLE'',''Autoryzacja:'',''Zewn.'') || name from planners where (id in (select rol_id from ROL_PLA where pla_id = '+UserID+')) or ('+iif(editSharing,'0=0',' name='''+CurrentUserName+'''')+') order by decode(type,''USER'','''',''ROLE'',''Autoryzacja:'',''Zewn.'') || name', MapPlanners, false);
  dmodule.loadMap('select name,(select name from planners x where id=planners.parent_id) from planners', MapPlannerSupervisors, true);

  if not isBlank(confineCalendarId) then begin
    Kalendarze1.Enabled := false;
    TabViewType.Tabs[5]:='';
    flegend.notes_before.ReadOnly := true;
    flegend.notes_after.ReadOnly := true;
    flegend.internal_notes.ReadOnly := true;
  end else begin
    TabViewType.Tabs[5]:='Kalendarz szczególny';
    Kalendarze1.Enabled := true;
    flegend.notes_before.ReadOnly := false;
    flegend.notes_after.ReadOnly := false;
    flegend.internal_notes.ReadOnly := false;
  end;


  If isBlank(CurrentUserName) Then Begin
    Info('Nie masz uprawnieñ do korzystania z aplikacji - brak informacji w tabeli PLANNERS');
    Result := False;
    Exit;
  End;

  If FcellLayout.D1.ItemIndex = -1 Then FcellLayout.D1.ItemIndex := getItemIndex(FcellLayout.D1, 'NONE');
  If FcellLayout.D2.ItemIndex = -1 Then FcellLayout.D2.ItemIndex := getItemIndex(FcellLayout.D2, 'NONE');
  If FcellLayout.D3.ItemIndex = -1 Then FcellLayout.D3.ItemIndex := getItemIndex(FcellLayout.D3, 'NONE');
  If FcellLayout.D4.ItemIndex = -1 Then FcellLayout.D4.ItemIndex := getItemIndex(FcellLayout.D4, 'NONE');
  If FcellLayout.D5.ItemIndex = -1 Then FcellLayout.D5.ItemIndex := getItemIndex(FcellLayout.D5, 'NONE');
  If FcellLayout.D6.ItemIndex = -1 Then FcellLayout.D6.ItemIndex := getItemIndex(FcellLayout.D6, 'NONE');
  If FcellLayout.D7.ItemIndex = -1 Then FcellLayout.D7.ItemIndex := getItemIndex(FcellLayout.D7, 'NONE');
  If FcellLayout.D8.ItemIndex = -1 Then FcellLayout.D8.ItemIndex := getItemIndex(FcellLayout.D8, 'NONE');

  //load DB Messages
  DBMap.init;

  CanShow := True;
  //ConFormChange(nil);
  NormalClick(nil);
  Start;

  //rebuild comboboxes in  FCellLayout
  fmain.D1Change(FCellLayout.D1);

  commandLineProcessing;

  try
  if dmodule.SingleValue('select planner_utils.killSessions from dual')='Y' then
     if not silentMode then info('Aby unikn¹æ blokad skasowano z serwera Twoje poprzednie sesje');
  except
    on E:exception  do
      info('Brak zainstalowanego sk³adnika do kasowania poprzednich sesji.'+cr+'Dostawca pomo¿e w rozwi¹zaniu problemu, zadzwoñ pod numer +48 604224658.'+cr+'Problem nie jest krytyczny, mo¿esz kontynuowaæ pracê.');
  End;

  if not silentMode then begin
      Timer1.Enabled := True;
      //TimerShapesEngine.Enabled := True;
      AutoSaveCounterDown := -1;
      AutoSaver.Enabled := True;
  end;
end;


procedure TFMain.copyArea;
begin
  gridSelectionLeft   := grid.Selection.Left;
  gridSelectionRight  := grid.Selection.Right;
  gridSelectionTop    := grid.Selection.Top;
  gridSelectionBottom := grid.Selection.Bottom;
  gridSelectionMode   := clGreen;
  Grid.Refresh;
end;

procedure TFMain.cutArea;
begin
  gridSelectionLeft   := grid.Selection.Left;
  gridSelectionRight  := grid.Selection.Right;
  gridSelectionTop    := grid.Selection.Top;
  gridSelectionBottom := grid.Selection.Bottom;
  gridSelectionMode   := clRed;
  Grid.Refresh;

end;

procedure TFMain.pasteArea;
  var dx, dy : integer;
      myRect: TGridRect;
begin
	dx := grid.Selection.Left - gridSelectionLeft;
	dy := grid.Selection.Top - gridSelectionTop;
	//clear selection
	myRect.Left   := gridSelectionLeft;
	myRect.Right  := gridSelectionRight;
	myRect.Top    := gridSelectionTop;
	myRect.Bottom := gridSelectionBottom;
	grid.Selection        := myRect;
	if gridSelectionMode = clRed then begin
	 //clear selection
	 gridSelectionLeft   := -1;
	 gridSelectionRight  := -1;
	 gridSelectionTop    := -1;
	 gridSelectionBottom := -1;
	end;
	//move
	modifyClasses ( dx, dy, iif(gridSelectionMode = clRed,clMove,clCopy),'','');
end;

procedure TFMain.clearSelection;
begin
  gridSelectionLeft   := -1;
  gridSelectionRight  := -1;
  gridSelectionTop    := -1;
  gridSelectionBottom := -1;
  grid.Refresh;
end;

procedure TFMain.deleteLecFromSelection;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  if TabViewType.TabIndex = 0 then
   if question(
       format('Wybrano polecenie od³¹czenia. Spowoduje to, ¿e %s znikn¹ z bie¿acego arkusza, o ile bie¿¹cy: %s zostanie od³¹czony. Czy kontynuowaæ ?', [fprogramsettings.profileObjectNameClasses.Text, fprogramsettings.profileObjectNameL.Text ])
      ) <> id_yes then exit;
  keyValue := '';
  if not unplugAll then begin
    If LECTURERSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
      for t := 1 to wordCount(KeyValues, [',']) do begin
        KeyValue := extractWord(t,KeyValues, [',']);
        modifyClasses(0,0,clDeleteLec,keyValue,'');
        if not elementEnabled('"Operacje grupowe-wiele zasobów"','2018.07.07', false) then exit;
      end;
    end;
  end else
    modifyClasses(0,0,clDeleteLec,'' {keyValue},'');

  grid.Refresh;
end;

procedure TFMain.deleteGroFromSelection;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  if TabViewType.TabIndex = 1 then
   if question(
       format('Wybrano polecenie od³¹czenia. Spowoduje to, ¿e %s znikn¹ z bie¿acego arkusza, o ile bie¿¹cy: %s zostanie od³¹czony. Czy kontynuowaæ ?', [fprogramsettings.profileObjectNameClasses.Text, fprogramsettings.profileObjectNameG.Text ])
   ) <> id_yes then exit;

  keyValue := '';
  if not unplugAll then begin
    If GROUPSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then begin
      for t := 1 to wordCount(KeyValues, [',']) do begin
        KeyValue := extractWord(t,KeyValues, [',']);
        modifyClasses(0,0,clDeleteGro,keyValue,'');
        if not elementEnabled('"Operacje grupowe-wiele zasobów"','2018.07.07', false) then exit;
      end;
    end;
  end else
    modifyClasses(0,0,clDeleteGro,''{keyValue},'');

  grid.Refresh;
end;

procedure TFMain.deleteResFromSelection;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  if TabViewType.TabIndex = 2 then
   if question(
       format('Wybrano polecenie od³¹czenia. Spowoduje to, ¿e %s znikn¹ z bie¿acego arkusza, o ile bie¿¹cy zasób zostanie od³¹czony. Czy kontynuowaæ ?', [fprogramsettings.profileObjectNameClasses.Text])
   ) <> id_yes then exit;

  keyValue := '';
  if not unplugAll then begin
    If ROOMSShowModalAsMultiSelect(dmodule.pResCatId0,'',KeyValue,'0=0','') = mrOK Then begin
      for t := 1 to wordCount(KeyValues, [',']) do begin
        KeyValue := extractWord(t,KeyValues, [',']);
        modifyClasses(0,0,clDeleteRes,keyValue,'');
        if not elementEnabled('"Operacje grupowe-wiele zasobów"','2018.07.07', false) then exit;
      end;
    end;
  end else
     modifyClasses(0,0,clDeleteRes,'' {keyValue},'');

  grid.Refresh;
end;

procedure TFMain.deleteOwnerFromSelection;
var keyValue : shortString;
begin
  keyValue := '';
  if not unplugAll then begin
    If PLANNERSShowModalAsSelect(KeyValue) <> mrOK Then exit;
    KeyValue := DModule.SingleValue('SELECT NAME FROM PLANNERS WHERE ID='+KeyValue);
  end;

  modifyClasses(0,0,clDeleteOwner,keyValue,'');
  grid.Refresh;
end;

procedure TFMain.deleteSubFromSelection;
begin
  modifyClasses(0,0,clDeleteSub,'','');
  grid.Refresh;
end;

procedure TFMain.deleteDescFromSelection(i : integer);
begin
  modifyClasses(0,0,clDeleteDesc1+i-1,'','');
  grid.Refresh;
end;

procedure TFMain.attachLec;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If LECTURERSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
    for t := 1 to wordCount(KeyValues, [',']) do begin
      KeyValue := extractWord(t,KeyValues, [',']);
      modifyClasses(0,0,clAttachLec,KeyValue,'', exitIfAnyExists);
      if not elementEnabled('"Operacje grupowe-wiele zasobów"','2018.07.07', false) then exit;
    end;
    grid.Refresh;
  end;
end;

procedure TFMain.attachGro;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If GROUPSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then
  Begin
    for t := 1 to wordCount(KeyValues, [',']) do begin
      KeyValue := extractWord(t,KeyValues, [',']);
      modifyClasses(0,0,clAttachGro,KeyValue,'', exitIfAnyExists);
      if not elementEnabled('"Operacje grupowe-wiele zasobów"','2018.07.07', false) then exit;
    end;
    grid.Refresh;
  end;
end;

procedure TFMain.attachRes;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If ROOMSShowModalAsMultiSelect(dmodule.pResCatId0,'',KeyValues,'0=0','') = mrOK Then
  Begin
    for t := 1 to wordCount(KeyValues, [',']) do begin
      KeyValue := extractWord(t,KeyValues, [',']);
      modifyClasses(0,0,clAttachRes,KeyValue,'', exitIfAnyExists);
      if not elementEnabled('"Operacje grupowe-wiele zasobów"','2018.07.07', false) then exit;
    end;
    grid.Refresh;
  end;
end;

procedure TFMain.attachOwner;
Var KeyValue : ShortString;
begin
  KeyValue := '';
  If PLANNERSShowModalAsSelect(KeyValue) = mrOK Then
  Begin
    KeyValue := DModule.SingleValue('SELECT NAME FROM PLANNERS WHERE ID='+KeyValue);
    modifyClasses(0,0,clAttachOwner,KeyValue,'', false);
    grid.Refresh;
  end;
end;

procedure TFMain.changeSub;
Var KeyValue, KeyValueDsp : ShortString;
begin
  KeyValue := '';
  If SUBJECTSShowModalAsSelect(KeyValue,'') = mrOK Then
  Begin
    KeyValueDsp := dmodule.SingleValue('select name from subjects where id='+keyValue);
    modifyClasses(0,0,clChangeSub,KeyValue,KeyValueDsp);
    grid.Refresh;
  end;
end;

procedure TFMain.changeFor;
Var KeyValue, KeyValueDsp : ShortString;
begin
  KeyValue := '';
  If FORMSShowModalAsSelect(KeyValue,'') = mrOK Then
  Begin
    KeyValueDsp := dmodule.SingleValue('select name||''(''||abbreviation||'')'' from forms where id='+keyValue);
    modifyClasses(0,0,clChangeFor,KeyValue,KeyValueDsp);
    grid.Refresh;
  end;
end;

procedure TFMain.changeOwner;
Var KeyValue : ShortString;
begin
  KeyValue := '';

  If PLANNERSShowModalAsSelect(KeyValue) = mrOK Then
  Begin
    keyValue := DModule.SingleValue('SELECT NAME FROM PLANNERS WHERE ID='+KeyValue);
    modifyClasses(0,0,clChangeOwner,KeyValue,'');
    grid.Refresh;
  end;
end;

procedure TFMain.changeCColor;
Var keyValue : ShortString;
begin
  KeyValue := '';

  If ColorDialog.Execute Then
  Begin
    keyValue := intToStr ( ColorDialog.Color );
    modifyClasses(0,0,clChangeCColor,keyValue,'');
    grid.Refresh;
  end;
end;

procedure TFMain.changeDesc(i : integer);
Var KeyValue : ShortString;
begin
  KeyValue := '';
  If FIN_LOOKUP_VALUESShowModalAsMultiselectExt(FProgramSettings.getClassDescPlural(i),KeyValue) = mrOK Then
  Begin
    modifyClasses(0,0,clChangeDesc1+i-1,KeyValue,'');
    grid.Refresh;
  end;
end;


procedure TFMain.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
 Case Key Of
  45:if canInsert then bAddClassClick(nil);
  13:GridDblClick(nil);
  32:begin
       FMain.set_tmp_selected_dates;
       showClasses(true,true);
     end;
  46:if canDelete then BDeleteClassClick(nil);
  {c}67:if ssCtrl in Shift then copyArea;
  {x}88:if ssCtrl in Shift then cutArea;
  {v}86:if ssCtrl in Shift then pasteArea;
 End;
end;

Function TFMain.GetClassByRowCol(Col, Row: Integer; Var Class_ : TClass_ ) : Integer;
Var  Status : Integer;
Begin
 If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,Col,Row) = ConvClass Then Begin
      Case TabViewType.TabIndex Of
       0: ClassByLecturerCaches.LGetClass(TS, Zajecia, iif(AObjectId = -1, ConLecturer.Text, intToStr(AObjectId)), Status, Class_);
       1: ClassByGroupCaches.GetClass   (TS, Zajecia, iif(AObjectId = -1, ConGroup.Text,    intToStr(AObjectId)), Status, Class_);
       2: ClassByRoomCaches.GetClass    (TS, Zajecia, iif(AObjectId = -1, conResCat0.Text,  intToStr(AObjectId)), Status, Class_);
       3: ClassByResCat1Caches.GetClass (TS, Zajecia, iif(AObjectId = -1, CONResCat1.Text,  intToStr(AObjectId)), Status, Class_);
      End;
      Result := Status;
 End Else Result := ClassNotFound;
end;

procedure TFMain.BEditClassClick(Sender: TObject);
 Var Class_ : TClass_;
begin
 ftoolwindow.Hide;
 fcellLayout.Hide;
 If TabViewType.TabIndex = 4 Then Begin InvertReservations; Exit; End;
 If TabViewType.TabIndex = 5 Then Begin InvertOtherCalendar; Exit; End;

 If GetClassByRowCol(Grid.Col, Grid.Row, Class_) = ClassFound Then Begin
   if Class_.owner ='AUTO' then begin
      FMain.set_tmp_selected_dates;
      classForEdition := -1;
      showClasses(false,true);
      if (classForEdition <> -1) then begin
        convertGrid.ColRowToDate(AObjectId, TS,Zajecia,Grid.Selection.Left,Grid.Selection.Top);

        dmodule.SingleValue('select * from classes, forms where forms.id = for_id and classes.id='+inttostr(classForEdition));
        with dmodule.QWork do begin
          FDetails.SetValues(
              TS
            , Zajecia
            , classForEdition
            , fieldByName('CALC_LEC_IDS').AsString
            , fieldByName('CALC_GRO_IDS').AsString
            , fieldByName('CALC_ROM_IDS').AsString
            , fieldByName('calc_rescat_ids').AsString
            , fieldByName('SUB_ID').AsInteger
            , fieldByName('FOR_ID').AsInteger
            , fieldByName('Fill').AsInteger
            , fieldByName('colour').AsInteger
            , fieldByName('KIND').AsString
            , TabViewType.TabIndex
            , fieldByName('Created_by').AsString
            , fieldByName('Owner').AsString
            , fieldByName('desc1').AsString
            , fieldByName('desc2').AsString
            , fieldByName('desc3').AsString
            , fieldByName('desc4').AsString
          );
        end;
        InsertClasses;
      end;
      BRefreshClick(nil);
   end
   else
   begin
     Zajecia := -1;
     if (Grid.Selection.Left=Grid.Selection.Right) and (Grid.Selection.Top=Grid.Selection.Bottom) then
       If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,Grid.Selection.Left,Grid.Selection.Top) <>ConvClass Then Zajecia := -1;

     FDetails.SetValues(
         TS
       , Zajecia
       //Pass currentClassId ONLY if one cell is selected. currentClassId does not make sense for the block of classes
       //currentClassId decides if use can edit the class
       , iif((Grid.Selection.Left=Grid.Selection.Right) and (Grid.Selection.Top=Grid.Selection.Bottom),Class_.id,-1)
       , Class_.CALC_LEC_IDS
       , Class_.CALC_GRO_IDS
       , Class_.CALC_ROM_IDS
       , Class_.calc_rescat_ids
       , Class_.SUB_ID
       , Class_.FOR_ID
       , Class_.Fill
       , Class_.class_colour
       , Class_.FOR_KIND
       , TabViewType.TabIndex
       , Class_.Created_by
       , Class_.Owner
       , Class_.desc1
       , Class_.desc2
       , Class_.desc3
       , Class_.desc4
     );
     InsertClasses;
   end;
 End Else Begin Info('W siatce zaznacz komórkê do edycji'); End;
 refreshPanels;
end;

procedure TFMain.GridDblClick(Sender: TObject);
Var Class_ : TClass_;
begin
  If TabViewType.TabIndex = 4 Then begin InvertReservations; exit; end;
  If TabViewType.TabIndex = 5 Then begin InvertOtherCalendar; exit; end;
  If GetClassByRowCol(Grid.Col, Grid.Row, Class_) = ClassFound
      Then bEditClassClick(nil)
      Else if canInsert then Fmain.AddClassToGrid(gFirstResourceFlag);
end;

procedure TFMain.refreshLegend;
var CONDL, CONDG, CONDR : String;
begin
 StatusBar.Panels[7].Text := '(' + inttostr(grid.Selection.Top) + ':' + inttostr(grid.Selection.Left) + ')    Suma: ' + inttostr ( (grid.Selection.Right - grid.Selection.Left + 1) * (grid.Selection.bottom - grid.Selection.top + 1) );
 if not flegend.Visible then exit;

 if FLegend.FLegendTabs.ActivePage <> FLegend.TabSheetCOUNTER then
 if (FLegend.FindMode.ItemIndex > 0 ) and FLegend.Visible then begin
   //if convertGrid.ColRowToDate(AObjectId, TS,Zajecia,aCol,aRow) = ConvClass then begin
     GetEnabledLGR(ConLecturer.Text, ConGroup.Text, conResCat0.Text, ConSubject.Text, ConForm.Text, CurrentUserName , FLegend.FindMode.ItemIndex = 2, CONDL, CONDG, CONDR, '1');
     FLegend.SetWheres(CONDL, CONDG, CONDR);
   //end else begin
   //  FLegend.SetWheres('LECTURERS.ID IN (-1)','GROUPS.ID IN (-1)','ROOMS.ID IN (-1)');
   //end;
 end Else begin
   FLegend.SetWheres('0=0', '0=0', '0=0');
 end;
end;

procedure TFMain.GridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ACol = 0 then ACol := Grid.Col;
  if ARow = 0 then ARow := Grid.Row;
  FillPanel(ACol, ARow);
end;

procedure TFMain.D1Change(Sender: TObject);
begin
  NormalClick(nil);
end;

procedure TFMain.Ustawieniaprogramu1Click(Sender: TObject);
begin
  FLegend.SaveTimeTableNotes;
  dmodule.CommitTrans;
  With FSettings Do Begin
   Case TabViewType.TabIndex Of
    0: PageControl.ActivePage := TabSheetL;
    1: PageControl.ActivePage := TabSheetG;
    2: PageControl.ActivePage := TabSheetR;
    3: PageControl.ActivePage := TabSheetR;
   End;
   BOK.Caption   := 'Anuluj';
   ShowModal;
  End;
end;

procedure TFMain.GenerateWWW(pgentype : integer);
Begin
 dmodule.CommitTrans;
 FWWWGenerator := TFWWWGenerator.Create(Application);
 FWWWGenerator.currentPeriod.Text := conPeriod.Text;
 FWWWGenerator.genType.ItemIndex := pgenType;
 FWWWGenerator.ShowModal;
 FWWWGenerator.Free;
End;


procedure TFMain.mmprofileObjectNamePlannersClick(Sender: TObject);
begin
 PLANNERSShowModalAsBrowser;
 setHistoryEnabled;
end;

{ TReservationsCache }

procedure TReservationsCache.Init;
Var t, t2 : Integer;
Begin
  MaxHours := aMaxHours;
  SetLength(Storage, aCount, MaxHours+1); 
  FirstDay := aFirstDay;
  Count    := aCount;

 For t := 0 To Count-1 Do
  For t2 := 1 To MaxHours Do
    Storage[t][t2] := '';
End;


procedure TReservationsCache.ReservationsCacheLoadPeriod(PER_ID: String);
Var t : Integer;
    DateFrom, DateTo : String;
    X, Y : Integer;
    firstDay : integer;

Var L1, L2 : Integer;
begin
  With DModule Do Begin
   Dmodule.SingleValue(CustomdateRange('SELECT TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD''), date_to-date_from, DATE_FROM, HOURS_PER_DAY FROM PERIODS WHERE ID='+PER_ID));
   DateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
   DateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';
   Count    :=  QWork.Fields[2].AsInteger+1;

   firstDay := DateTimeToTimeStamp(QWork.Fields[3].AsDateTime).Date;

   Init(firstDay, Count, QWork.FieldByName('HOURS_PER_DAY').AsInteger);

   FirstDay := DateTimeToTimeStamp(QWork.Fields[3].AsDateTime).Date;

   For L1 := 0 To Count -1 Do Begin
     For L2 := 1 To MaxHours Do Begin
       Storage[L1][L2] := '';
      End;
   End;

  OPENSQL(
   'SELECT DAY, HOUR, TYPE '+
     'FROM RESERVATIONS '+
    'WHERE DAY BETWEEN '+DateFrom+' AND '+DateTo);

  While Not QWork.EOF Do Begin
   X := DateTimeToTimeStamp(QWork.FieldByName('DAY').AsDateTime).Date;
   Y := QWork.FieldByName('HOUR').AsInteger;
   t := X-FirstDay;
   if t > Count    then SError('Wyst¹pi³o zdarzenie t > Count. Zg³oœ problem asyœcie technicznej');
   if y<=maxHours then
     Storage[t][y] := QWork.FieldByName('TYPE').AsString;

   QWork.Next;
  End;
  End;
end;

Function TReservationsCache.IsReserved(TS: TTimeStamp; Zajecia : Integer) : String;
Var t1 : Integer;
begin
 t1 := TS.Date - FirstDay;
 Result := Storage[t1][Zajecia];
end;

procedure TReservationsCache.Invert(TS: TTimeStamp; Zajecia: Integer);
Var t1 : Integer;
begin
 t1 := TS.Date - FirstDay;
 If Storage[t1][Zajecia]<>''
   Then Begin
     DModule.SQL('DELETE FROM RESERVATIONS WHERE DAY= '+TSDateToOracle(TS)+' AND HOUR='+IntToStr(Zajecia));
     Storage[t1][Zajecia] := '';
   end Else begin
     DModule.SQL('INSERT INTO RESERVATIONS (ID, DAY, HOUR, TYPE) VALUES (RES_SEQ.NextVal,'+TSDateToOracle(TS)+','+IntToStr(Zajecia)+', '''+nvl(fmain.ReservationType.Text,'HOLIDAY')+''')');
     Storage[t1][Zajecia] := nvl(fmain.ReservationType.Text,'HOLIDAY');
   end;
end;


{ totherCalendar }

procedure totherCalendar.Init;
Var t, t2 : Integer;
Begin
  MaxHours := aMaxHours;
  SetLength(Data, aCount);       // inicjuje dlugosc tabeli dynamicznej ...
  for t := 0 to aCount -1 do     // ... i to samo dla kazdej tabeli zagniezdzonej
    setLength(Data[t], MaxHours+1);

  FirstDay := aFirstDay;
  Count    := aCount;

 For t := 0 To Count-1 Do
  For t2 := 1 To MaxHours Do
    Data[t][t2] := 0;
End;


procedure totherCalendar.LoadPeriod(PER_ID: String; presId: string);
Var t : Integer;
    DateFrom, DateTo : String;
    X, Y : Integer;
    firstDay : integer;
    ratio : integer;

Var L1, L2 : Integer;
begin
  resId := presId;
  With DModule Do Begin
   Dmodule.SingleValue(CustomdateRange('SELECT TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD''), date_to-date_from, DATE_FROM, HOURS_PER_DAY FROM PERIODS WHERE ID='+PER_ID));
   DateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
   DateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';
   Count    :=  QWork.Fields[2].AsInteger+1;

   firstDay := DateTimeToTimeStamp(QWork.Fields[3].AsDateTime).Date;

   Init(firstDay, Count, QWork.FieldByName('HOURS_PER_DAY').AsInteger);

   FirstDay := DateTimeToTimeStamp(QWork.Fields[3].AsDateTime).Date;

   For L1 := 0 To Count -1 Do Begin
     For L2 := 1 To MaxHours Do Begin
       Data[L1][L2] := 0;
      End;
   End;

  OPENSQL(
   'SELECT DAY, HOUR, RATIO, case when ratio>0 then ''PLUS'' else ''MINUS'' end SIGN '+
     'FROM res_hints '+
    'WHERE DAY BETWEEN '+DateFrom+' AND '+DateTo+' and res_id='+resId);

  While Not QWork.EOF Do Begin
   X := DateTimeToTimeStamp(QWork.FieldByName('DAY').AsDateTime).Date;
   Y := QWork.FieldByName('HOUR').AsInteger;

   t := X-FirstDay;

   if t > Count    then SError('Wyst¹pi³o zdarzenie t > Count. Zg³oœ problem asyœcie technicznej');

   if y > MaxHours then begin
     //Warning('Zarezerwowana liczba godzin ( wartoœæ '+inttostr(y)+') jest wiêksza, ni¿ liczba godzin zdefiniowana dla semestru. Powoduje to, ¿e czêœæ zaplanowanych rekordów nie pojawia siê na ekranie. Mo¿liwe rozwi¹zania problemu: ' + '1. Zwiêksz liczbê godzin w definicji dla semestru lub 2. Usuñ b³êdne rekordy za pomoc¹ formularza Lista Zajêæ lub 3. Przeka¿ opis problemu serwisowi');
     //komunikat jest prawdziwy, ale nie trzeba go wyswietlac, to ze rezerwacje nie pojawiaja sie nie ma zadnych konsekwencji
   end else begin
     ratio := QWork.FieldByName('RATIO').AsInteger;
     //workaround for the bug
     if (QWork.FieldByName('SIGN').AsString='MINUS') and (ratio>0) then ratio := -ratio;
     Data[t][y] := ratio;
   end;

   QWork.Next;
  End;
  End;
end;

Function totherCalendar.getRatio(TS: TTimeStamp; Zajecia : Integer) : Integer;
Var t1 : Integer;
begin
 t1 := TS.Date - FirstDay;
 if (t1<0) or (t1 >= count) then begin
   result := 0;
   Exit;
 end;
 Result := Data[t1][Zajecia];
end;

procedure totherCalendar.setRatio(TS: TTimeStamp; Zajecia: Integer; ratio: integer);
Var t1 : Integer;
begin
 t1 := TS.Date - FirstDay;
 If Data[t1][Zajecia]<>0 then
     DModule.SQL('DELETE FROM res_hints WHERE DAY= '+TSDateToOracle(TS)+' AND HOUR='+IntToStr(Zajecia)+' and res_id='+resId);

 Data[t1][Zajecia] := ratio;
 If ratio<>0 then begin
   DModule.SQL('INSERT INTO res_hints (ID, DAY, HOUR, RATIO, RES_ID) VALUES (hint_seq.NextVal,'+TSDateToOracle(TS)+','+IntToStr(Zajecia)+','+inttostr(ratio)+','+resId+')');
 end;
end;

procedure totherCalendar.Invert(TS: TTimeStamp; Zajecia: Integer);
Var t1 : Integer;
begin
 t1 := TS.Date - FirstDay;
 If Data[t1][Zajecia]<>0 Then begin Data[t1][Zajecia] := 0;           DModule.SQL('DELETE FROM res_hints WHERE DAY= '+TSDateToOracle(TS)+' AND HOUR='+IntToStr(Zajecia)+' and res_id='+resId); end
                         Else begin Data[t1][Zajecia] := calReserved; DModule.SQL('INSERT INTO res_hints (ID, DAY, HOUR, RATIO, RES_ID) VALUES (hint_seq.NextVal,'+TSDateToOracle(TS)+','+IntToStr(Zajecia)+','+intToStr(calReserved)+','+resId+')') end;
end;

procedure TFMain.InvertReservations;
Var xp, yp : Integer;
    operationDisabled : boolean;
begin
  if not editReservations then begin
    info ('Nie masz uprawnieñ do modyfikacji dni wolnych');
    exit;
  end;
  dmodule.CommitTrans;
  With Grid Do
  Begin
   For xp:=Selection.Left To Selection.Right Do
    For yp:=Selection.Top To Selection.Bottom Do
       If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,xp,yp)=ConvClass Then begin
          operationDisabled := false;
          If (confineCalendarId<>'') then
              If confineCalendar.getRatio(TS, Zajecia)<>calConfineOk then begin
                  //info ('Nie mo¿na tutaj planowaæ zajêæ');
                  operationDisabled := true;
              End;
         if not operationDisabled then ReservationsCache.Invert(TS, Zajecia);
       End;
   dmodule.CommitTrans;
   Refresh;
  End;
end;

procedure TFMain.InvertOtherCalendar;
Var xp, yp : Integer;
begin
  if CALID.text='-1' then begin
    info('Najpierw wybierz kaledarz, na którym chesz wprowadzaæ zmiany');
    CALID_VALUEClick(nil);
    exit;
  end;

  dmodule.CommitTrans;
  With Grid Do
  Begin
   For xp:=Selection.Left To Selection.Right Do
    For yp:=Selection.Top To Selection.Bottom Do
       If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,xp,yp)=ConvClass Then otherCalendar.Invert(TS, Zajecia);
   dmodule.CommitTrans;
   Refresh;
  End;
end;

procedure TFMain.SetRatio ( pratio : integer ) ;
Var xp, yp : Integer;
    ignore : boolean;
begin
  dmodule.CommitTrans;
  With Grid Do
  Begin
   For xp:=Selection.Left To Selection.Right Do
    For yp:=Selection.Top To Selection.Bottom Do begin
      convertGrid.ColRowToDate(AObjectId, TS,Zajecia,xp,yp);
      AObjectId := -1;
      Case TabViewType.TabIndex Of
       0: AObjectId := iif(AObjectId = -1, strtoint(ExtractWord(1,ConLecturer.Text,[';'])), AObjectId);
       1: AObjectId := iif(AObjectId = -1, strtoint(ExtractWord(1,ConGroup.Text   ,[';'])), AObjectId);
       2: AObjectId := iif(AObjectId = -1, strtoint(ExtractWord(1,conResCat0.Text ,[';'])), AObjectId);
       3: AObjectId := iif(AObjectId = -1, strtoint(ExtractWord(1,CONResCat1.Text ,[';'])), AObjectId);
       5: AObjectId := StrToInt(CALID.text);
      end;

      Ignore := false;
      If (confineCalendarId<>'') then
        If confineCalendar.getRatio(TS, Zajecia)<>calConfineOk then begin
          info('Czynnoœæ zosta³a wy³¹czona, skontaktuj siê z Planist¹ lub Administratorem systemu');
          ignore:=true;
        End;

      if not ignore then
        if AObjectId <> -1 then
            if TabViewType.TabIndex = 5
              then otherCalendar.setRatio(TS, Zajecia, pratio)
              else BusyClassesCache.SetRatio(TS, Zajecia, pratio, AObjectId);
    end;

    dmodule.CommitTrans;
    BusyClassesCache.clearCache;
    Refresh;
  End;
end;


procedure TFMain.Uprawnieniadoobiektw1Click(Sender: TObject);
begin
  inherited;
  UFPlannerPermissions.ShowModal;
end;

procedure TFMain.BLoginClick(Sender: TObject);
var  db_version_info  : string[255];
     app_version_info : string[255];
begin
 dmodule.CommitTrans;
 If Logon Then
 Begin
   UnLockFormComponents(Self);
   try
    app_version_info  := '5.0';
    db_version_info := dmodule.dbGetSystemParam('PLANOWANIE.VERSION_INFO');
    if db_version_info <> app_version_info then begin
      //info('Na tym komputerze jest zainstalowana nieaktualne oprogramowanie.'+CR+'Wersja oprogramowania na tym komputerze to '+app_version_info+'.'+CR+'Wersja oprogramowania na serwerze to ' + db_version_info + cr + cr + 'Program pobierze teraz i zainstaluje aktualizacjê.'+cr+'Pobieranie aktualizacji mo¿e potrwaæ od kilku sekund do kilkunastu minut, czas ten zale¿y od jakoœci po³¹czenia z Internetem');
      info('Na tym komputerze jest zainstalowana nieaktualne oprogramowanie.'+CR+'Wersja oprogramowania na tym komputerze to '+app_version_info+'.'+CR+'Wersja oprogramowania na serwerze to ' + db_version_info + cr + cr + 'Uruchom program Aktualizacja w celu pobrania nowej wersji');
    end;
   except
    on E:exception do begin
      SError('Wykryto niezgodnoœæ pomiêdzy wersj¹ aplikacji a wersj¹ schematu w bazie danych.'+CR+'Zg³oœ problem serwisowi technicznemu.'+CR+'Wersja aplikacji to '+app_version_info+'.'+CR+'Wersja bazy danych nie zosta³a okreœlona:' +cr + e.message );
      //dmodule.CloseDBConnection;
      //Halt;
    end;
   end;

   BitBtnCLEARROLE.Visible := not isBlank(conRole.Text);
   loadFormSettings;

   Self.Menu := MM;

   //default values in case of the lgr was is not selected (first call after the upgrade)                             
   if conLecturer.Text='' then conLecturer.Text := dmodule.SingleValue('Select max(id) from lecturers where id in (select lec_id from lec_pla where pla_id = '+UserID+')');
   if conGroup.Text=''    then conGroup.Text    := dmodule.SingleValue('Select max(id) from groups where id in (select gro_id from gro_pla where pla_id = '+UserID+')');
   if conResCat0.Text=''  then conResCat0.Text  := dmodule.SingleValue('Select max(id) from rooms where rescat_id='+dmodule.pResCatId0+' and id in (select rom_id from rom_pla where pla_id = '+UserID+')');
   if conResCat1.Text=''  then conResCat1.Text  := dmodule.SingleValue('Select max(id) from rooms where rescat_id='+dmodule.pResCatId1+' and id in (select rom_id from rom_pla where pla_id = '+UserID+')');
   if conPeriod.Text=''   then conPeriod.Text   := dmodule.SingleValue('Select max(id) from periods');

   If Not isBlank(conPeriod.Text) Then setPeriod;
   RefreshGrid;
   //BIMP.Enabled := False;
   //BEXP.Enabled := False;
 End
 Else Begin
   LockFormComponents(Self,[MainPanel, LeftPanel, BLogin, TopPanel]); Self.Menu := nil;
   //BIMP.Enabled := True;
   //BEXP.Enabled := True;
 End;
end;

procedure TFMain.Odwiepolanadmiarowe1Click(Sender: TObject);
begin
  inherited;
 If not isAdmin Then Begin
  Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora');
  Exit;
 End;

 DModule.SQL('BEGIN PLANNER_UTILS.UPDATE_LGRS; END;');
 BRefreshClick(nil);
 Info('Pola zosta³y odœwie¿one');
end;

procedure TFMain.Zamknij1Click(Sender: TObject);
begin
 Close;
end;

procedure TFMain._selectl;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If LECTURERSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
   if clearList then ConLecturer.Text := '';
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(ConLecturer.Text, [';'], KeyValue)
     Then Info('Nie mo¿na wybraæ ponownie tego samego elementu:' + fprogramsettings.profileObjectNameL.Text)
     Else begin
       TabViewType.TabIndex := 0;
       //ConLecturer.Text := getChildsAndParents(KeyValue, ConLecturer.Text, true);
       ConLecturer.Text := Merge(KeyValue, ConLecturer.Text, ';');
     end;
   end;
  End;
end;

procedure TFMain._selectg;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
    resultString : string;
begin
  KeyValue := '';
  If GROUPSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
   if clearList then ConGroup.Text := '';
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(ConGroup.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego elementu:' + fprogramsettings.profileObjectNameG.Text)
      Else begin
        TabViewType.TabIndex := 1;
        //ConGroup.Text := getChildsAndParents(KeyValue, ConGroup.Text, true);
        ConGroup.Text := Merge(KeyValue, ConGroup.Text, ';');
      end;
   end;
  End;
end;

procedure TFMain._selectResCat1 (clearList : boolean);
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If ROOMSShowModalAsMultiSelect(dmodule.pResCatId1,'',KeyValues,'0=0','') = mrOK Then  Begin
   if clearList then conResCat1.Text := '';
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If existsValue(conResCat1.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else begin
        TabViewType.TabIndex := 3;
        //conResCat1.Text := getChildsAndParents(KeyValue, conResCat1.Text, true);
        conResCat1.Text := Merge(KeyValue, conResCat1.Text, ';');
      end;
   end;
  End;
end;

procedure TFMain._selectr;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  If ROOMSShowModalAsMultiSelect(dmodule.pResCatId0,'',KeyValues,'0=0','') = mrOK Then  Begin
   if clearList then conResCat0.Text := '';
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(conResCat0.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else begin
        TabViewType.TabIndex := 2;
        //conResCat0.Text := getChildsAndParents(KeyValue, conResCat0.Text, true);
        conResCat0.Text := Merge(KeyValue, conResCat0.Text, ';');
      end;
   end;
  End;
end;


procedure TFMain.ValidLClick(Sender: TObject);
Var Values, IDs : String;
begin
 Values := ConLecturer_value.Text;
 ValidValues('LECTURERS',Values,sql_LECNAME,IDs);
 ConLecturer_value.Text := Values;
 ConLecturer.Text := IDs;
end;

procedure TFMain.ValidGClick(Sender: TObject);
Var Values, IDs : String;
begin
 Values := ConGroup_value.Text;
 ValidValues('GROUPS',Values,sql_GRONAME,IDs);
 ConGroup_value.Text := Values;
 ConGroup.Text := IDs;
end;

procedure TFMain.ValidRClick(Sender: TObject);
Var Values, IDs : String;
begin
 Values := conResCat0_value.Text;
 ValidValues('ROOMS',Values,sql_ResCat0NAME,IDs);
 conResCat0_value.Text := Values;
 conResCat0.Text := IDs;
end;

procedure TFMain.CONLECTURER_valueExit(Sender: TObject);
begin
  inherited;
  ValidLClick(nil);
end;

procedure TFMain.CONGROUP_valueExit(Sender: TObject);
begin
  inherited;
  ValidGClick(nil);
end;

procedure TFMain.conResCat0_valueExit(Sender: TObject);
begin
  inherited;
  ValidRClick(nil);
end;

procedure TFMain.ShowFreeTermsLClick(Sender: TObject);
begin
  ShowAllAnyL.Visible       := ShowFreeTermsL.Checked;
  ShowAllAnyG.Visible       := ShowFreeTermsG.Checked;
  ShowAllAnyResCat0.Visible := ShowFreeTermsR.Checked;
  ShowAllAnyResCat1.Visible := ShowFreeTermsResCat1.Checked;

  RespectCompletions.Visible := ShowFreeTermsL.Checked or ShowFreeTermsG.Checked or ShowFreeTermsR.Checked or ShowFreeTermsResCat1.Checked;

  If not CanShow Then exit;
  BusyClassesCache.ClearCache;
  RefreshGrid;
end;

procedure TFMain.CONLECTURER_valueEnter(Sender: TObject);
begin
  TabViewType.TabIndex := 0;
end;

procedure TFMain.CONGROUP_valueEnter(Sender: TObject);
begin
  TabViewType.TabIndex := 1;
end;

procedure TFMain.conResCat0_valueEnter(Sender: TObject);
begin
  TabViewType.TabIndex := 2;
end;


procedure TFMain.rorLClick(Sender: TObject);
begin
  if StrToBool( GetSystemParam('Rotate', '-' ) ) then begin
    CONLECTURER.Text := LROR(CONLECTURER.Text,';');
    exit;
  end;

  TabViewType.TabIndex := 0;
  CanShow := False;
  ValidLClick(nil);
  CanShow := True;
  if FListOrganizer.showList('L', Sender, ConLecturer.Text, CONLECTURER_value.Text,';') = mrOK then
    ConLecturer.Text :=  replace(FListOrganizer.lbIds.Items.CommaText,',',';');
   //ConLecturer.Text := LROR(ConLecturer.Text,';')
end;

procedure TFMain.rorGClick(Sender: TObject);
begin
  if StrToBool( GetSystemParam('Rotate', '-' ) ) then begin
    CONGROUP.Text := LROR(CONGROUP.Text,';');
    exit;
  end;

  TabViewType.TabIndex := 1;
  CanShow := False;
  ValidGClick(nil);
  CanShow := True;
  if FListOrganizer.showList('G', Sender, ConGroup.Text, CONGroup_value.Text,';') = mrOK then
    ConGroup.Text :=  replace(FListOrganizer.lbIds.Items.CommaText,',',';');
  //ConGroup.Text := LROR(ConGroup.Text,';')
end;

procedure TFMain.rorRClick(Sender: TObject);
begin
  if StrToBool( GetSystemParam('Rotate', '-' ) ) then begin
     conResCat0.Text := LROR(conResCat0.Text,';');
    exit;
  end;

  TabViewType.TabIndex := 2;
  CanShow := False;
  ValidRClick(nil);
  CanShow := True;
  if FListOrganizer.showList('R', Sender, conResCat0.Text, conResCat0_value.Text,';') = mrOK then
    conResCat0.Text :=  replace(FListOrganizer.lbIds.Items.CommaText,',',';');
  //conResCat0.Text := LROR(conResCat0.Text,';')
end;

procedure TFMain.ConFormChange(Sender: TObject);
begin
  BusyClassesCache.ClearCache;
  if canshow then begin
      ConForm_value.Text := FChange(ConForm.text, sql_FORDESC );
      UpsertRecentlyUsed(ExtractWord(1, TEdit(Sender).Text,  [';']),'F');
      BuildCalendar('F');
  End;
end;

procedure TFMain.CONLECTURER_valueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
    if Key = 40 Then ActiveControl := ConGroup_value;
end;

procedure TFMain.CONGROUP_valueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
    if Key = 40 Then ActiveControl := conResCat0_value;
    if Key = 38 Then ActiveControl := ConLecturer_value;
end;

procedure TFMain.conResCat0_valueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = 38 Then ActiveControl := ConGroup_value;
  if Key = 40 Then ActiveControl := CONResCat1_value;
end;

procedure TFMain.Ukadtygodniowy1Click(Sender: TObject);
begin
  inherited;
  BViewByWeek.Down := true;
  BViewByWeekClick(sender);
end;

procedure TFMain.Ukadtabelikrzyowej1Click(Sender: TObject);
begin
  inherited;
  BViewByCrossTable.Down := true;
  BViewByCrossTableClick(sender);
end;

procedure TFMain.mmplanLClick(Sender: TObject);
begin
  inherited;
  TabViewType.TabIndex := 0;
end;

procedure TFMain.mmplanGClick(Sender: TObject);
begin
  inherited;
  TabViewType.TabIndex := 0;
end;

procedure TFMain.mmplanRClick(Sender: TObject);
begin
  inherited;
  TabViewType.TabIndex := 2;
end;

procedure TFMain.Czysty1Click(Sender: TObject);
begin
  TabViewType.TabIndex := 4;
end;

procedure TFMain.BViewByWeekClick(Sender: TObject);
begin
  Preview.Enabled := true;
  dmodule.dateRange:='';
  setPeriod;
end;

procedure TFMain.BViewByCrossTableClick(Sender: TObject);
begin
  Preview.Enabled := false;
  dmodule.dateRange:='TODAY:+0:+0';
  CustomPeriod.ItemIndex:=2;
  setPeriod;
end;

procedure TFMain.Ustawieniaprogramu2Click(Sender: TObject);
begin
  inherited;
  FProgramSettings.ShowModal;
  BRefreshClick(nil);
end;

procedure TFMain.Kategoriezasobw1Click(Sender: TObject);
begin
  RESOURCE_CATEGORIESShowModalAsBrowser;
  buildMenu;
  BuildCalendar('X');
end;

procedure TFMain.RESOURCESClick(Sender: TObject);
begin
  ROOMSShowModalAsBrowser( intToStr(tMenuItem(sender).tag),'' );
  BuildCalendar('X');
end;

procedure TFMain.Pobierzdanezpliku1Click(Sender: TObject);
begin
  CanShow := False;
  GridPanel.Visible := False;
  dmodule.CloseDBConnection;
  LockFormComponents(Self,[MainPanel, LeftPanel, BLogin, TopPanel]); Self.Menu := nil;
  if FImp = nil then Application.CreateForm(TFImp, FImp);
  FIMP.ShowModal;
end;

procedure TFMain.Zapiszdanedopliku1Click(Sender: TObject);
begin
   If uppercase(dm.UserName) <> 'PLANNER' Then Begin
    Info('Ten modu³ mo¿e byæ uruchamiany tylko przez u¿ytkownika administracyjnego PLANNER');
    Exit;
   End;

  CanShow := False;
  GridPanel.Visible := False;
  dmodule.CloseDBConnection;
  LockFormComponents(Self,[MainPanel, LeftPanel, BLogin, TopPanel]); Self.Menu := nil;
  if FExp = nil then Application.CreateForm(TFExp, FExp);
  FEXP.ShowModal;
end;

procedure TFMain.Legenda1Click(Sender: TObject);
begin
  Legend.Down := not Legend.Down;
  LegendClick(nil);
end;

procedure TFMain.Statystyki1Click(Sender: TObject);
begin
  Raportowaniezaawansowane1Click(nil);
end;

procedure TFMain.Penyprzegld1Click(Sender: TObject);
begin
  FMain.set_tmp_selected_dates;
  showClasses(false,false);
end;

procedure TFMain.UtwrzwitrynWWW1Click(Sender: TObject);
begin
  GenerateWWW(0);
end;

procedure TFMain.Zalogujponownie1Click(Sender: TObject);
begin
  BLoginClick(nil);
end;

procedure TFMain.Dodaj2Click(Sender: TObject);
begin
  bAddClassClick(nil);
end;

procedure TFMain.Zmie1Click(Sender: TObject);
begin
  bEditClassClick(nil);
end;

procedure TFMain.Usu2Click(Sender: TObject);
begin
  BDeleteClassClick(nil);
end;

procedure TFMain.mmfreeLGRClick(
  Sender: TObject);
begin
  LGRppClick(nil);
end;

procedure TFMain.mmfreeLGClick(Sender: TObject);
begin
  LGppClick(nil);
end;

procedure TFMain.mmfreeLRClick(Sender: TObject);
begin
  LRppClick(nil);
end;

procedure TFMain.mmfreeGRClick(Sender: TObject);
begin
  GRppClick(nil);
end;

procedure TFMain.powiksz1Click(Sender: TObject);
begin
  zoomInClick(nil);
end;

procedure TFMain.pomniejsz1Click(Sender: TObject);
begin
  zoomOutClick(nil);
end;

procedure TFMain.CONLECTURER_valueDblClick(Sender: TObject);
begin
 CONLECTURER.Text := LROR(CONLECTURER.Text,';');
end;

procedure TFMain.CONGROUP_valueDblClick(Sender: TObject);
begin
 CONGROUP.Text := LROR(CONGROUP.Text,';');
end;

procedure TFMain.conResCat0_valueDblClick(Sender: TObject);
begin
 conResCat0.Text := LROR(conResCat0.Text,';');
end;

procedure TFMain.CONSUBJECT_valueDblClick(Sender: TObject);
begin
  BitBtnSUBClick(nil);
end;

procedure TFMain.ConForm_valueDblClick(Sender: TObject);
begin
  BitBtnFORMClick(nil);
end;

procedure TFMain.conRoleChange(Sender: TObject);
begin
  If CanShow Then Begin
   if isBlank(conRole.Text) then begin conRole_value.Text := ''; exit; end;
   BitBtnCLEARROLE.Visible := not isBlank(conRole.Text);
   DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PLANNERS','');
  End;
end;

procedure TFMain.conPeriod_valueDblClick(Sender: TObject);
begin
  BitBtnPERClick(nil);
end;

procedure  TFMain.conRole_valueDblClick(Sender: TObject);
begin
  BitBtnROLEClick(nil);
end;

function TFMain.getUserOrRoleID : string;
begin
 result := NVL(conRole.text, UserID)
end;

procedure TFMain.MORG_UNITSClick(Sender: TObject);
begin
  ORG_UNITSShowModalAsBrowser;
end;

procedure TFMain.FormFormulasClick(Sender: TObject);
begin
  FORM_FORMULASShowModalAsBrowser;
end;

procedure TFMain.Ustawieniakonfiguracyjne1Click(Sender: TObject);
begin
  FProgramSettings.ShowModal;
  buildMenu;
  BRefreshClick(nil);
end;

procedure TFMain.mmconsolidationClick(Sender: TObject);
begin
  if not isBlank(confineCalendarId) then begin
    info('Scalanie danych zosta³o zablokowane. Skontaktuj siê z Planist¹ lub Administratorem systemu');
    exit;
  end;

  GridPanel.Visible := false;
  CONSOLIDATIONShowModalAsBrowser(-1);
  BRefreshClick(nil);
end;

procedure TFMain.MMDiagramClick(Sender: TObject);
begin
  FDataDiagramShowModalAsBrowser;
end;

procedure TFMain.AutoSaverTimer(Sender: TObject);
begin
  If AutoSaveCounterDown >= 0 then  AutoSaveCounterDown := AutoSaveCounterDown -1;
  if AutoSaveCounterDown <> -1 then StatusBar.Panels[0].Text:='Nie zapisane ' + inttostr(AutoSaveCounterDown); 
  if AutoSaveCounterDown <> 0 then exit;
  If (DModule.ADOConnection.Connected) and (DModule.ADOConnection.InTransaction) Then Begin
    dmodule.CommitTrans;
    StatusBar.Panels[0].Text:=''; //saved 
  end;
end;


function TFMain.modifyClass;
	function internalModifyClass : boolean;
	 var newTS : TTimeStamp;
		 newZajecia : Integer;
		 oldclass, newClass : TClass_;
		 pttCombIds         : string;
		 cellStatus         : integer;
		 calendarSelected   : boolean;

	   // unplugValue('1;2;3;4','4') --> '1;2;3'
	   // unplugValue('1;2;3;4','3') --> '1;2;4'
	   // unplugValue('1;2;3;4','1') --> '2;3;4'
	   function unplugValue ( tokens : string; token : string) : string;
	   begin
		 //unplug specific
		 tokens := replace(tokens,token,'');
		 tokens := replace(tokens,';;',';');
		 //cut last ; is exists
		 if substr(tokens, length(tokens), 1 ) = ';' then
		   tokens := substr(tokens, 1, length(tokens) -1 );
		 //cut first ; is exists
		 if substr(tokens, 1, 1 ) = ';' then
		   tokens := substr(tokens, 2, length(tokens) -1 );
		 result := tokens;
	   end;

	   function copyValue(newVal : string; allowFlag : boolean; desc : string) : string;
	   begin
		 result := desc;
		 if allowFlag then begin
		 if wordCount(desc,[','])=1 then begin
		   result := newVal;
		 end else info('Przedmiotu lub formy w przypadku zajêæ równoleg³ych nie mo¿na w ten sposób zmieniaæ');
		 end;
	   end;


	begin
	  result := false;
	  If convertGrid.ColRowToDate(AObjectId, newTS,newZajecia,Col,Row) <> ConvClass Then
	  begin
	   //info ('Zaznacz rekord, który zamierzasz przesun¹æ');
	   // skoro komorka nie zawiera zajecia do przesuniecia, to po prostu zignoruj ten fakt
	   result := true;
	   exit;
	  end;

	  If GetClassByRowCol(Col, Row, oldClass) <> ClassFound Then
	  begin
	   // skoro nie ma zajecia to przesuwania, to po prostu zignoruj ten fakt
	   result := true;
	   exit;
	  end;

	  //do not check combinations. just use old ones
	  pttCombIds := dmodule.SingleValue('select tt_planner.get_tt_cla ( :id ) from dual', 'id=' + intToStr(oldClass.id) );

	  repeat
		  col := col + deltaX;
		  row := row + deltaY;
		  cellStatus := convertGrid.ColRowToDate(AObjectId, newTS,newZajecia,Col,Row);
	  until  (cellStatus = ConvClass) or (cellStatus = convOutOfRange);

	  If (cellStatus = convOutOfRange) or (newZajecia < 0) //bug in convertGrid.ColRowToDate
	  Then
	  begin
	   info ('Nie mo¿na przesun¹æ tej komórki poza obszar planowania');
	   exit;
	  end;

	  newClass      := oldClass;

	  If (confineCalendarId<>'') then
		  If confineCalendar.getRatio(newTS, newZajecia)<>calConfineOk then begin
			  info ('Nie mo¿na tutaj planowaæ zajêæ');
			  exit;
		  End;

	  calendarSelected := fdetails.CALID.Text<>'-1';
	  if calendarSelected then
	   if  otherCalendar.getRatio(TS, Zajecia)=calReserved then begin
			  info ('Nie mo¿na tutaj planowaæ zajêæ ze wzglêdu na wybrany kalendarz szczególny');
			  exit;
		  End;

	  succesFlag := false;
	  case operation of
	   //move, copy is in mode: all or nothing
	   clMove: begin
				 newClass.hour := newZajecia;
				 newClass.day  := newTS;
				 if uutilities.isOwnerSupervisor(newClass.owner) then
					 //leave original owner if current user is his supervisor (this will save edit permissions for original owner)
					 else newClass.owner := upperCase(CurrentUserName);
				 if not canInsertClass ( newClass, newClass.id, dummy ) then begin info(dummy); exit; end;
         if not deleteClass ( oldClass, -1 ) then exit;
				 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
			   end;
	   clCopy: begin
				 newClass.hour := newZajecia;
				 newClass.day  := newTS;
				 if uutilities.isOwnerSupervisor(newClass.owner) then
					 //leave original owner if current user is his supervisor (this will save edit permissions for original owner)
					 else newClass.owner := upperCase(CurrentUserName);
				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				 if not planner_utils_insert_classes ( newClass, pttCombIds ) then exit;
			   end;
	   //following operations are in mode: single class level
	   clDeleteLec:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.calc_lec_ids := ''
				 else
				 begin
				   //unplug specific
				   newClass.calc_lec_ids := unplugValue(newClass.calc_lec_ids,keyValue);
				 end;
				 // omit cell if operation is not allowed
				 if not deleteClass ( oldClass, oldClass.id ) then exit;
				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				 succesFlag := true;
			   end;
	   clDeleteOwner:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.owner := newClass.created_by
				 else
				 begin
				   //unplug specific
				   newClass.owner := unplugValue(newClass.owner,keyValue);
           if newClass.owner = '' then newClass.owner := newClass.created_by;
				 end;
				 // omit cell if operation is not allowed
				 if not deleteClass ( oldClass, oldClass.id ) then exit;
				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				 succesFlag := true;
			   end;
	   clDeleteGro:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.calc_gro_ids := ''
				 else
				 begin
				   //unplug specific
				   newClass.calc_gro_ids := unplugValue(newClass.calc_gro_ids,keyValue);
				 end;
				 // omit cell if operation is not allowed
				 if not deleteClass ( oldClass, oldClass.id ) then exit;
				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				 succesFlag := true;
			   end;
	   clDeleteRes:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.calc_rom_ids := ''
				 else
				 begin
				   //unplug specific
				   newClass.calc_rom_ids := unplugValue(newClass.calc_rom_ids,keyValue);
				 end;
				 // omit cell if operation is not allowed
				   if not deleteClass ( oldClass, oldClass.id ) then exit;
  				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				   if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				   succesFlag := true;
			   end;
	   clDeleteSub:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.sub_id := 0;
				 //else
				 //begin
				 //  //unplug specific
				 //  newClass.calc_lec_ids := unplugValue(newClass.calc_lec_ids,keyValue);
				 //end;
				 // omit cell if operation is not allowed
				   if not deleteClass ( oldClass, oldClass.id ) then exit;
  				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				   if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				   succesFlag := true;
			   end;
	   clDeleteDesc1:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.desc1 := '';
				 //else
				 //begin
				 //  //unplug specific
				 //  newClass.calc_lec_ids := unplugValue(newClass.calc_lec_ids,keyValue);
				 //end;
				 // omit cell if operation is not allowed
				   if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				   if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				   succesFlag := true;
			   end;
	   clDeleteDesc2:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.desc2 := '';
				 //else
				 //begin
				 //  //unplug specific
				 //  newClass.calc_lec_ids := unplugValue(newClass.calc_lec_ids,keyValue);
				 //end;
				 // omit cell if operation is not allowed
				   if not deleteClass ( oldClass, oldClass.id ) then exit;
  				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				   if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				   succesFlag := true;
			   end;
	   clDeleteDesc3:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.desc3 := '';
				 //else
				 //begin
				 //  //unplug specific
				 //  newClass.calc_lec_ids := unplugValue(newClass.calc_lec_ids,keyValue);
				 //end;
				 // omit cell if operation is not allowed
				   if not deleteClass ( oldClass, oldClass.id ) then exit;
  				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				   if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				   succesFlag := true;
			   end;
	   clDeleteDesc4:
			   begin
				 if keyValue = '' then
				   //unplug all
				   newClass.desc4 := '';
				 //else
				 //begin
				 //  //unplug specific
				 //  newClass.calc_lec_ids := unplugValue(newClass.calc_lec_ids,keyValue);
				 //end;
				 // omit cell if operation is not allowed
				   if not deleteClass ( oldClass, oldClass.id ) then exit;
  				 if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
				   if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
				   succesFlag := true;
			   end;
	   clAttachLec:
			   begin
				 // nie dodawaj obiektu jezeli inny obiekt juz jest
				 if exitIfAnyExists then
				   if newClass.calc_lec_ids <> '' then begin result := true; exit; end;
				 //nie dodawaj obiektu jezeli ten obiekt juz jest
				 If not existsValue(newClass.calc_lec_ids, [';'], keyValue) then
				 begin
				   newClass.calc_lec_ids := merge(newClass.calc_lec_ids, keyValue,';');
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass, newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clAttachGro:
			   begin
				 // nie dodawaj obiektu jezeli inny obiekt juz jest
				 if exitIfAnyExists then
				   if newClass.calc_gro_ids <> '' then begin result := true; exit; end;
				 //nie dodawaj obiektu jezeli ten obiekt juz jest
				 if not existsValue(newClass.calc_gro_ids, [';'], keyValue) then
				 begin
				   newClass.calc_gro_ids := merge(newClass.calc_gro_ids,keyValue,';');
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clAttachRes:
			   begin
				 // nie dodawaj obiektu jezeli inny obiekt juz jest
				 if exitIfAnyExists then
				   if newClass.calc_rom_ids <> '' then begin result := true; exit; end;
				 //nie dodawaj obiektu jezeli ten obiekt juz jest
				 if not existsValue(newClass.calc_rom_ids, [';'], keyValue) then
				 begin
				   newClass.calc_rom_ids := merge(newClass.calc_rom_ids,keyValue,';');
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clAttachOwner:
			   begin
				 If not existsValue(newClass.owner, [';'], keyValue) then
				 begin
				   newClass.owner := merge(newClass.owner, keyValue,';');
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clChangeSub:
			   begin
				 //nie zmieniaj obiektu jezeli juz jest
				 if not (newClass.sub_id = strtoint(keyValue)) then
				 begin
				   newClass.sub_id := strtoint(keyValue);
				   newClass.desc1 := copyValue(keyValueDsp, Fprogramsettings.CopyField1.itemindex=2 {2=subject}, newClass.desc1);
				   newClass.desc2 := copyValue(keyValueDsp, Fprogramsettings.CopyField2.itemindex=2            , newClass.desc2);
				   newClass.desc3 := copyValue(keyValueDsp, Fprogramsettings.CopyField3.itemindex=2            , newClass.desc3);
				   newClass.desc4 := copyValue(keyValueDsp, Fprogramsettings.CopyField4.itemindex=2            , newClass.desc4);
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clChangeFor:
			   begin
				 //nie zmieniaj obiektu jezeli juz jest
				 if not (newClass.for_id = strtoint(keyValue)) then
				 begin
				   newClass.for_id := strtoint(keyValue);
				   newClass.desc1 := copyValue(keyValueDsp, Fprogramsettings.CopyField1.itemindex=3 {3=form}, newClass.desc1);
				   newClass.desc2 := copyValue(keyValueDsp, Fprogramsettings.CopyField2.itemindex=3         , newClass.desc2);
				   newClass.desc3 := copyValue(keyValueDsp, Fprogramsettings.CopyField3.itemindex=3         , newClass.desc3);
				   newClass.desc4 := copyValue(keyValueDsp, Fprogramsettings.CopyField4.itemindex=3         , newClass.desc4);
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clChangeOwner:
			   begin
				 //nie zmieniaj obiektu jezeli juz jest
				 if not (newClass.owner =  keyValue) then
				 begin
				   newClass.owner := keyValue;
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clChangeCColor:
			   begin
				 //nie zmieniaj obiektu jezeli juz jest
				 if not (newClass.class_colour =  StrToInt(keyValue) ) then
				 begin
				   newClass.class_colour := strToInt(keyValue);
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clChangeDesc1:
			   begin
				 //nie zmieniaj obiektu jezeli juz jest
				 if not (newClass.desc1 =  keyValue) then
				 begin
				   newClass.desc1 := keyValue;
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clChangeDesc2:
			   begin
				 //nie zmieniaj obiektu jezeli juz jest
				 if not (newClass.desc2 =  keyValue) then
				 begin
				   newClass.desc2 := keyValue;
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clChangeDesc3:
			   begin
				 //nie zmieniaj obiektu jezeli juz jest
				 if not (newClass.desc3 =  keyValue) then
				 begin
				   newClass.desc3 := keyValue;
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	   clChangeDesc4:
			   begin
				 //nie zmieniaj obiektu jezeli juz jest
				 if not (newClass.desc4 =  keyValue) then
				 begin
				   newClass.desc4 := keyValue;
				   // omit cell if operation is not allowed
					 if not deleteClass ( oldClass, oldClass.id ) then exit;
				   if not canInsertClass ( newClass,newClass.id, dummy ) then begin info(dummy); exit; end;
					 if not planner_utils_insert_classes ( newClass, pttCombIds, newClass.id ) then exit;
					 succesFlag := true;
				 end;
			   end;
	  end;

	  //sprawdzenie, czy mozna zaplanowac zajecie  - niepotrzebne, bo ewentualny komunikat o bledzie zwroci procedura insertClass
	  //if not canInsertClass ( newClass ) then
	  //begin
	  //  info ('Nie mo¿na przesun¹æ rekordu za wzglêdu na konflikt z innymi zaplanowanymi rekordami');
	  //  exit;
	  //end;

	  //grid.Col :=  grid.Col + deltaX;
	  //grid.row :=  grid.row + deltaY;
	  result := true;
	end;

begin
 if not internalModifyClass then begin
   result := false;
   Cofnij1Click(nil);
 end else begin
   result := true;
 end;
end;


procedure TFMain.modifyClasses;
  procedure moveSelection ( deltaX, deltaY : integer );
  var myRect: TGridRect;
  begin
    myRect         := Grid.Selection;
    myRect.Left    := myRect.Left + deltaX;
    myRect.Top     := myRect.Top + deltaY;
    myRect.Right   := myRect.Right + deltaX;
    myRect.Bottom  := myRect.Bottom + deltaY;
    Grid.Selection := myRect;
  end;

  var xp, yp : integer;
      xstart, xend, ystart, yend, dx, dy : integer;
      cellsSucceed    : integer;
      cellsNotSucceed : integer;
      successFlag     : boolean;

begin
  cellsSucceed := 0;
  cellsNotSucceed := 0;

  dmodule.CommitTrans;

  With grid do begin
   if deltaX > 0 then dx := -1 else dx := 1;
   if deltaY > 0 then dy := -1 else dy := 1;

   if dx > 0 then begin
     xstart := Selection.Left;
     xend   := Selection.right;
   end else begin
     xstart := Selection.right;
     xend   := Selection.left;
   end;

   if dy > 0 then begin
     ystart := Selection.Top;
     yend   := Selection.bottom;
   end else begin
     ystart := Selection.bottom;
     yend   := Selection.top;
   end;

  end;

  xstart := xstart - dx;
  ystart := ystart - dy;

  yp := ystart;
  repeat
    yp := yp + dy;
    xp := xstart;
    repeat
     xp := xp + dx;
     if not modifyClass ( xp , yp , deltaX, deltaY, operation, keyValue, keyValueDsp, successFlag,exitIfAnyExists ) then exit;
     if successFlag then cellsSucceed    := cellsSucceed +1
                    else cellsNotSucceed := cellsNotSucceed +1;
    until xp = xend;
  until yp = yend;

  moveSelection ( deltaX, deltaY);

  //odswiezenie zawartosci siatki
  grid.Refresh;

  {
  case operation of
    clDeleteLec    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clDeleteGro    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clDeleteRes    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clDeleteSub    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clDeleteDesc1    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clDeleteDesc2    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clDeleteDesc3    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clDeleteDesc4    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clAttachLec    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clAttachGro    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clAttachRes    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clChangeSub    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clChangeFor    : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clChangeOwner  : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clChangeCColor : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clChangeDesc1 : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clChangeDesc2 : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clChangeDesc3 : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
    clChangeDesc4 : info('Zrobione. '+cr+'Zmian: ' + inttostr(cellsSucceed) + cr +cr + 'Komórki bez zmian: ' + inttostr(cellsNotSucceed) );
  end;
  }
end;

procedure TFMain.bmoveUpClick(Sender: TObject);
begin
  modifyClasses ( 0, -1, clMove,'','' );
end;

procedure TFMain.bmoveDownClick(Sender: TObject);
begin
  inherited;
  modifyClasses ( 0, +1, clMove,'','' );
end;

procedure TFMain.bmoveLeftClick(Sender: TObject);
begin
  modifyClasses ( -1, 0, clMove,'','' );
end;

procedure TFMain.bmoverightClick(Sender: TObject);
begin
  modifyClasses ( +1, 0, clMove,'','' );
end;

procedure TFMain.Zestawywarto1Click(Sender: TObject);
begin
  inherited;
  VALUE_SETSShowModalAsBrowser;
end;

procedure TFMain.Listywarto1Click(Sender: TObject);
begin
  inherited;
  LOOKUPSShowModalAsBrowser('');
end;

procedure TFMain.Zmiehas1Click(Sender: TObject);
begin
   Application.CreateForm(TFChangePassword, FChangePassword);
   if fchangepassword.showmodal = mrOK then begin
    dmodule.SQL('alter user '+DM.UserName+' identified by "'+fchangepassword.ENewPassword.Text+'"');
    info ('Has³o dla u¿ytkownika '+DM.UserName+' zosta³o poprawnie zmienione. Stare has³o utraci³o wa¿noœæ, zapamiêtaj nowe has³o');
   end;
   fchangepassword.Free;
   fchangepassword := nil;
end;

procedure TFMain.BAddClassMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  setActiveShape(1);
end;

procedure TFMain.setActiveShape( no : integer);
 var s : array [1..9] of tshape;
     t : integer;
begin
 s[ 1] := Shape1a;
 s[ 2] := Shape2a;
 s[ 3] := Shape3a;
 s[ 4] := Shape4a;
 s[ 5] := Shape4a; //dummy value- currently not used
 s[ 6] := Shape4a; //dummy value- currently not used
 s[ 7] := Shape7a;
 s[ 8] := Shape8a;
 s[ 9] := Shape9a;

 if no <> 0 then begin
   s[no].Pen.Style := psDot;
   s[no].Pen.Color := clBlack;
 end;
 for t := 1 to 9 do
   if t <> no then begin
     s[t].Pen.Style := psSolid;
     s[t].Pen.Color := clSilver;
   end;
 timerShapes := 9;
end;


procedure TFMain.TimerShapesEngineTimer(Sender: TObject);
var trace : string;
begin
try
  trace := '';
  If timerShapes > 0 Then timerShapes := timerShapes - 1;
  trace := '1';
  If timerShapes = 1 Then Begin
    trace := '2';
    setActiveShape(0);
    trace := '3';
  end;
except
  info ('B³¹d wewnêtrzny: Shape ' + trace);
end;
end;

procedure TFMain.BViewByWeekMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  setActiveShape(2);
end;

procedure TFMain.bconflictspopupMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  setActiveShape(3);
end;

procedure TFMain.zoomInMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  setActiveShape(4);
end;

procedure TFMain.BIMPMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  setActiveShape(7);
end;

procedure TFMain.bmoveLeftMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  setActiveShape(8);
end;

procedure TFMain.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 refreshLegend;

 with grid.Selection  Do
 // at least 2 cells selected
 if (Left <> Right) or (Top <> Bottom) or (mbRight = Button) then begin
   ftoolwindow.showtoolwindow;
 end;
end;

procedure TFMain.bcopyareaClick(Sender: TObject);
begin
  CopyArea;
end;

procedure TFMain.bcutareaClick(Sender: TObject);
begin
  CutArea;
end;

procedure TFMain.bpasteareaClick(Sender: TObject);
begin
  PasteArea;
end;

procedure TFMain.bclearselectionClick(Sender: TObject);
begin
  clearSelection;
end;

procedure TFMain.bcopyareaMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  setActiveShape(9);
end;

procedure TFMain.FormShow(Sender: TObject);

 procedure x;
 var
   lf : TLogFont;
   tf : TFont;
 begin
   with FcellLayout.Image1.Canvas do begin
     Font.Name := 'Arial';
     Font.Size := 8;
     tf := TFont.Create;
     try
       tf.Assign(Font);
       GetObject(tf.Handle, sizeof(lf), @lf);
       lf.lfEscapement := 900;
       lf.lfOrientation := 450;
       tf.Handle := CreateFontIndirect(lf);
       Font.Assign(tf);
     finally
       tf.Free;
     end;
     TextOut(0, FcellLayout.image1.Height, 'Chcê ustaliæ wysokoœæ');
   end;
 end;

begin
  dockingPanel := strToInt( getSystemParam('FLegend.dockingPanel', inttostr(C_RIGHT) ));
  x;
  if resizeMode then exit;
  ShowFreeTermsLClick(nil);
  BLoginClick(nil);
  if not DModule.ADOConnection.Connected then exit;
  ForceCellHeightClick(nil);

  RefreshAfterOnShow.Enabled := true;
  setupFillButton;
end;

procedure TFMain.RefreshAfterOnShowTimer(Sender: TObject);
begin
 RefreshAfterOnShow.Enabled := false;
 SwitchMenu.Down  := (getSystemParam('SwitchMenu.Down')='+') or (getSystemParam('SwitchMenu.Down')='');
 Legend.Down      := (getSystemParam('Legend.Down')='+') or (getSystemParam('Legend.Down')='');
 BFullScreen.down := (getSystemParam('BFullScreen.down')='+') or (getSystemParam('BFullScreen.down')='');

 SwitchMenuClick(nil);
 LegendClick(nil);
 Penyekran1Click(nil);
 updateLeftPanel;
 userLogged := true;
end;

procedure TFMain.BFullScreenClick(Sender: TObject);
begin
 if BFullScreen.Down then
 begin
   resizeMode := true;
   fmain.BorderStyle := bsNone;
   fmain.WindowState := wsMaximized;
   resizeMode := false;
   BCloseApp.Visible := true;
 end
 else
 begin
   resizeMode := true;
   fmain.BorderStyle := bsSizeable;
   //fmain.WindowState := wsNormal;
   resizeMode := false;
   BCloseApp.Visible := false;
 end;
end;

procedure TFMain.GridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FToolWindow.hide;
end;

procedure TFMain.Timer1Timer(Sender: TObject);
var offset : integer;
    trace : string;
    cursorPos       : TPoint;
begin
     //“A call to an OS function failed” problem
     //Use cursorPos.Y instead of Mouse.CursorPos.Y
     //more: http://stackoverflow.com/questions/983738/call-to-tmouse-getcursorpos-sometimes-fails-with-a-call-to-an-os-function-faile
     GetCursorPos(cursorPos);
try
  if disableFurtherActivities then exit;
  // hide toolbar and ballon when application is not active or main form is not active
  trace := '1.';
  if (not application.Active) or ( (application.Active) and (not application.MainForm.Active ) )  then begin
    trace := '2.';
    hideBaloonHint;
    trace := '3.';
    if not ftoolWindow.Active then
      ftoolWindow.Hide;
    trace := '4.';
    if not fCellLayout.Active then
      fCellLayout.Hide;
    trace := '5.';
  end;

  trace := '6.';
  if BFullScreen.Down then offset := 0 else offset := 20;
  trace := '7.';
except
 on e:exception do begin
  disableFurtherActivities := true;
  info ('B³¹d wewnêtrzny: Ballon hint ' + trace + e.message);
 end;
end;
end;

procedure TFMain.ppDeleteClick(Sender: TObject);
begin
  BDeleteClassClick(nil);
end;

procedure TFMain.bdelpopupClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 if btn.Name = 'bdelpopup'       then fmain.DelPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'beditpopup'      then fmain.EditPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'bconflictspopup' then fmain.ConflictsPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'bfavpopup'       then fmain.FavouritePopup.Popup(Point.X,Point.Y);
 if btn.Name = 'bthpopup'        then fmain.thPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'bReports'        then fmain.reportsPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'bwww'            then fmain.wwwPopup.Popup(Point.X,Point.Y);

 if btn.Name = 'selectl'       then fmain.lecpopup.Popup(Point.X,Point.Y);
 if btn.Name = 'selectg'       then fmain.gropopup.Popup(Point.X,Point.Y);
 if btn.Name = 'selectr'       then fmain.respopup.Popup(Point.X,Point.Y);
 if btn.Name = 'selectResCat1' then fmain.ResCat1popup.Popup(Point.X,Point.Y);
 if btn.Name = 'selectFill'    then begin
     fmain.FillPopup.Popup(Point.X,Point.Y);
 end;
end;

procedure TFMain.MenuItem1Click(Sender: TObject);
begin
 bEditClassClick(nil);
end;

procedure TFMain.ppchangeSClick(Sender: TObject);
begin
  changeSub;
end;

procedure TFMain.ppchangeFClick(Sender: TObject);
begin
  changeFor;
end;

procedure TFMain.ppChangeOClick(Sender: TObject);
begin
  changeOwner;
end;

procedure TFMain.ppchangeClassClick(Sender: TObject);
begin
  changeCColor;
end;

procedure TFMain.N21Click(Sender: TObject);
begin
  attachLec(false);
end;

procedure TFMain.N22Click(Sender: TObject);
begin
  attachGro(false);
end;

procedure TFMain.N23Click(Sender: TObject);
begin
  attachRes(false);
end;

procedure TFMain.cmdattachLecClick(Sender: TObject);
begin
  inherited;
  attachLec(true);
end;

procedure TFMain.N19Click(Sender: TObject);
begin
  inherited;
  attachGro(true);
end;

procedure TFMain.N110Click(Sender: TObject);
begin
  attachRes(true);
end;

procedure TFMain.Wszystkich1Click(Sender: TObject);
begin
  deleteLecFromSelection(true);
end;

procedure TFMain.Wybranego1Click(Sender: TObject);
begin
  deleteLecFromSelection(false);
end;

procedure TFMain.Wszystkie1Click(Sender: TObject);
begin
  deleteGroFromSelection(true);
end;

procedure TFMain.Wybran1Click(Sender: TObject);
begin
  deleteGroFromSelection(false);
end;

procedure TFMain.Wszystkir1Click(Sender: TObject);
begin
  deleteResFromSelection(true);
end;

procedure TFMain.Wybrany1Click(Sender: TObject);
begin
  deleteResFromSelection(false);
end;

procedure TFMain.ppminusSClick(Sender: TObject);
begin
  deleteSubFromSelection;
end;

procedure tfmain.showAvailableTerms;
 var col, row : integer;
     newTS : TTimeStamp;
     newZajecia : Integer;
     myclass    : TClass_;

begin

  With Grid.Selection Do begin
   if (Left <> Right) or (top <> bottom) then
   begin
     info ('Wska¿ pojedyncz¹ komórkê');
     exit;
   end;
   col := left;
   row := top;
  end;

  If convertGrid.ColRowToDate(AObjectId, newTS,newZajecia,Col,Row) <> ConvClass Then
  begin
   info ( format('Zaznacz %s',[fprogramsettings.profileObjectNameClassacc.text]) );
   exit;
  end;

  If GetClassByRowCol(Grid.Col, Grid.Row, myClass) <> ClassFound Then
  begin
   info ( format('Zaznacz %s',[fprogramsettings.profileObjectNameClassacc.text]) );
   exit;
  end;

  canShow := false;
  ConLecturer.Text := getChildsAndParents(myClass.calc_lec_ids, '', true, false);
  ConGroup.Text := getChildsAndParents(myClass.calc_gro_ids, '', true, false);
  conResCat0.Text := getChildsAndParents(myClass.calc_rom_ids, '', true, false);

  ConSubject.Text        := inttostr(myClass.sub_id);
  ConForm.Text           := inttostr(myClass.for_id);
  ConLecturer_value.Text := FChange(ConLecturer.text, sql_LECDESC);
  ConGroup_value.Text    := FChange(ConGroup.text  , sql_GRODESC);
  conResCat0_value.Text  := FChange(conResCat0.text, sql_ResCat0DESC);
  conResCat1_value.Text  := FChange(conResCat1.text, sql_RESCAT1DESC);
  canShow := true;

  LGRppClick(nil);
end;

procedure TFMain.Kopiowaniegrupowe1Click(Sender: TObject);
begin
  if not isBlank(confineCalendarId) then begin
    info('Kopiowanie rozk³adów zosta³o zablokowane. Skontaktuj siê z Planist¹ lub Administratorem systemu');
    exit;
  end;

  if FCopyClasses = nil then Application.CreateForm(TFCopyClasses, FCopyClasses);
  if FCopyClasses.showModal = mrOK then BRefreshClick(nil);
end;

procedure TFMain.mmpurgeClick(Sender: TObject);
begin
 if FPurgeData = nil then Application.CreateForm(TFPurgeData, FPurgeData);
 if fpurgedata.showmodal = mrOK then BRefreshClick(nil);
end;

procedure TFMain.Atrybuty1Click(Sender: TObject);
begin
  FLEX_COL_USAGEShowModalAsBrowser;
end;

procedure TFMain.LegendMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  setActiveShape(7);
end;

procedure TFMain.LGRppClick(
  Sender: TObject);
begin
  ValidLClick(nil);
  ValidGClick(nil);
  ValidRClick(nil);

  CanShow := False;
  ShowFreeTermsL.Checked := true;
  ShowFreeTermsG.Checked := true;
  ShowFreeTermsR.Checked := true;
  ShowFreeTermsResCat1.Checked := false;
  ShowAllAnyL.ItemIndex  := 0;
  ShowAllAnyG.ItemIndex  := 0;
  ShowAllAnyResCat0.ItemIndex  := 0;
  ShowAllAnyResCat1.ItemIndex  := 0;
  CanShow := True;
  ShowFreeTermsLClick(nil);
end;

procedure TFMain.LGppClick(Sender: TObject);
begin
  ValidLClick(nil);
  ValidGClick(nil);
  ValidRClick(nil);

  CanShow := False;
  ShowFreeTermsL.Checked := true;
  ShowFreeTermsG.Checked := true;
  ShowFreeTermsR.Checked := false;
  ShowFreeTermsResCat1.Checked := false;
  ShowAllAnyL.ItemIndex  := 0;
  ShowAllAnyG.ItemIndex  := 0;
  //ShowAllAnyR.ItemIndex  := 0;
  //ShowAllAnyResCat1.ItemIndex  := 0;
  CanShow := True;
  ShowFreeTermsLClick(nil);
end;

procedure TFMain.LRppClick(Sender: TObject);
begin
  ValidLClick(nil);
  ValidGClick(nil);
  ValidRClick(nil);

  CanShow := False;
  ShowFreeTermsL.Checked := true;
  ShowFreeTermsG.Checked := false;
  ShowFreeTermsR.Checked := true;
  ShowFreeTermsResCat1.Checked := false;
  ShowAllAnyL.ItemIndex  := 0;
  //ShowAllAnyG.ItemIndex  := 0;
  ShowAllAnyResCat0.ItemIndex  := 0;
  //ShowAllAnyResCat1.ItemIndex  := 0;
  CanShow := True;
  ShowFreeTermsLClick(nil);
end;

procedure TFMain.GRppClick(Sender: TObject);
begin
  ValidLClick(nil);
  ValidGClick(nil);
  ValidRClick(nil);

  CanShow := False;
  ShowFreeTermsL.Checked := false;
  ShowFreeTermsG.Checked := true;
  ShowFreeTermsR.Checked := true;
  ShowFreeTermsResCat1.Checked := false;
  //ShowAllAnyL.ItemIndex  := 0;
  ShowAllAnyG.ItemIndex  := 0;
  ShowAllAnyResCat0.ItemIndex  := 0;
  //ShowAllAnyResCat1.ItemIndex  := 0;
  CanShow := True;
  ShowFreeTermsLClick(nil);
end;

procedure TFMain.set_tmp_selected_dates;
Var xp, yp  : Integer;
    TS      : TTimeStamp;
    Zajecia : Integer;
    sqlText : string;
    function getSelectedAreaDesc : string;
    begin
      with grid do
        result := inttoStr(Selection.Left)+'-'+inttoStr(Selection.Right)+':'+inttoStr(Selection.Top)+'-'+inttoStr(Selection.Bottom);
    end;
begin
    if currSelectedArea = getSelectedAreaDesc then exit;
    sqlText :=
     'begin ' + cr +
     '  delete from tmp_selected_dates where sessionid = userenv(''SESSIONID'') or created < sysdate - 7; '  + cr;
    With grid Do
    For xp:=Selection.Left To Selection.Right Do
     For yp:=Selection.Top To Selection.Bottom Do
      If convertGrid.ColRowToDate(AObjectId, TS,Zajecia,xp,yp)=ConvClass Then begin
        sqlText := sqlText +  '  insert into tmp_selected_dates (day,hour) values (:DAY, :HOUR); '  + cr;
        sqlText := replace(sqlText,':DAY' , uutilityParent.DateTimeToOracle( TimeStampTodateTime(TS) )  );
        sqlText := replace(sqlText,':HOUR', intToStr(Zajecia)                                           );
      end;
    sqlText := sqlText +  '  select count(1) into planner_utils.classes_selected_count from tmp_selected_dates where sessionid = userenv(''SESSIONID'');' + cr;
    sqlText := sqlText +  'end;';
    //info ( sqlText );
    dmodule.SQL( sqlText );
    currSelectedArea := getSelectedAreaDesc;
end;


procedure TFMain.GridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  refreshLegend;
end;

procedure TFMain.N100Zdecydowanienieplanujwtymterminie1Click(
  Sender: TObject);
begin
  setRatio(-300);
end;

procedure TFMain.N100Zdecydowanieplanujwtymterminie1Click(Sender: TObject);
begin
  setRatio(+750);
end;

procedure TFMain.N000Terminneutrealny1Click(Sender: TObject);
begin
  setRatio(0);
end;

procedure TFMain.N050Raczejnieplanujwtymterminie1Click(Sender: TObject);
begin
  setRatio(-500);
end;

procedure TFMain.N050Planujwtymterminie1Click(Sender: TObject);
begin
  setRatio(+500);
end;

procedure TFMain.Zdecydowanienieplanuj1Click(Sender: TObject);
begin
  setRatio(-999);
end;

procedure TFMain.Nieplanuj1Click(Sender: TObject);
begin
  setRatio(-750);
end;

procedure TFMain.Lepiejplanuj1Click(Sender: TObject);
begin
  setRatio(+300);
end;

procedure TFMain.Zdecydowanieplanuj1Click(Sender: TObject);
begin
  setRatio(+999);
end;

procedure TFMain.FavSelectedClick(
  Sender: TObject);
begin
  FavSelected.Checked := true;
  BRefreshClick(nil);
end;

procedure TFMain.FavOffClick(Sender: TObject);
begin
  FavOff.Checked := true;
  BRefreshClick(nil);
end;

procedure TFMain.FavAllClick(Sender: TObject);
begin
  inherited;
  FavAll.Checked := true;
  BRefreshClick(nil);
end;

function TFMain.getCurrentObjectId : integer;
 var res : integer;
begin
  if BViewByCrossTable.Down then begin result := -1; exit; end;
  res := -1;
  Case TabViewType.TabIndex Of
   0: res := strtoint(nvl(ExtractWord(1,ConLecturer.Text,[';']),'-1'));
   1: res := strtoint(nvl(ExtractWord(1,ConGroup.Text   ,[';']),'-1'));
   2: res := strtoint(nvl(ExtractWord(1,conResCat0.Text ,[';']),'-1'));
   3: res := strtoint(nvl(ExtractWord(1,CONResCat1.Text ,[';']),'-1'));
  end;
  result := res;
end;

function TFMain.getCurrentObjectType : string;
 var res : string;
begin
  if BViewByCrossTable.Down then begin result := '**none**'; exit; end;
  res := '**none**';
  Case TabViewType.TabIndex Of
   0: res := 'lecturers';
   1: res := 'groups';
   2: res := 'rooms';
   3: res := 'rooms';
  end;
  result := res;
end;


procedure TFMain.Przej1Click(Sender: TObject);
begin
  inherited;
  webBrowser('http://www.plansoft.org');
end;

procedure TFMain.Sprawddostpneaktualizacje1Click(Sender: TObject);
begin
  inherited;
  webBrowser('http://www.plansoft.org');
end;

procedure TFMain.Wybierz1Click(Sender: TObject);
begin
  inherited;
  _selectL (true);
end;

procedure TFMain.Dodaj1Click(Sender: TObject);
begin
  _selectL (false);
end;

procedure TFMain.MenuItem5Click(Sender: TObject);
begin
  _selectG (true);
end;

procedure TFMain.MenuItem6Click(Sender: TObject);
begin
  _selectG (false);
end;

procedure TFMain.MenuItem7Click(Sender: TObject);
begin
  _selectR (true);
end;

procedure TFMain.MenuItem8Click(Sender: TObject);
begin
  _selectR (false);
end;


procedure TFMain.conResCat1Change(Sender: TObject);
begin
  BusyClassesCache.ClearCache;
  If CanShow Then Begin
   conResCat1_value.Text:= FChange(conResCat1.text, sql_ResCat1DESC);
   ClassByResCat1Caches.LoadPeriod(StringToInt(conPeriod.Text), conResCat1.Text, bool_NOTreloadFromDatbase);
   BuildCalendar('R');
  End;
  ShowAllAnyResCat1.Visible := ShowFreeTermsResCat1.Checked;
end;

procedure TFMain.conResCat1_valueDblClick(Sender: TObject);
begin
 conResCat1.Text := LROR(conResCat1.Text,';');
end;

procedure TFMain.conResCat1_valueEnter(Sender: TObject);
begin
  TabViewType.TabIndex := 3;
end;

procedure TFMain.conResCat1_valueExit(Sender: TObject);
begin
 ValidResCat1Click(nil);
end;

procedure TFMain.ValidResCat1Click(Sender: TObject);
Var Values, IDs : String;
begin
 Values := CONResCat1_value.Text;
 ValidValues('ROOMS',Values,sql_ResCat1NAME,IDs);
 CONResCat1_value.Text := Values;
 CONResCat1.Text := IDs;
end;

procedure TFMain.conResCat1_valueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 38 Then ActiveControl := conResCat0_value;
end;

procedure TFMain.MenuItem9Click(Sender: TObject);
begin
  _selectResCat1 (true);
end;

procedure TFMain.MenuItem10Click(Sender: TObject);
begin
  _selectResCat1 ( false );
end;

procedure TFMain.rorResCat1Click(Sender: TObject);
begin
  if StrToBool( GetSystemParam('Rotate', '-' ) ) then begin
    conResCat1.Text := LROR(conResCat1.Text,';');
    exit;
  end;

  TabViewType.TabIndex := 3;
  CanShow := False;
  ValidResCat1Click(nil);
  CanShow := True;
  if FListOrganizer.showList('R2', Sender, CONResCat1.Text, CONResCat1_value.Text,';') = mrOK then
    CONResCat1.Text :=  replace(FListOrganizer.lbIds.Items.CommaText,',',';');
 // CONResCat1.Text := LROR(CONResCat1.Text,';')
end;

procedure TFMain.Wicej1Click(Sender: TObject);
begin
  inherited;
  info('Je¿eli szukaj innej kombinacji, ni¿ te, które znajduj¹ siê na liœcie, po prostu zaznacz odpowiednie pola wyboru oznaczone etykiet¹ "poka¿ dostêpne"');
end;


procedure TFMain.onpResCatId0Change;
begin
 if dmodule.pResCatId0 <> '' then begin
   dmodule.pResCatName0 := dmodule.SingleValue('select name from resource_categories where id ='+dmodule.pResCatId0);
   BRescat0.Caption := dmodule.pResCatName0;
 end;
end;

procedure TFMain.onpResCatId1Change;
begin
 if dmodule.pResCatId1 <> '' then begin
   dmodule.pResCatName1 := dmodule.SingleValue('select name from resource_categories where id ='+dmodule.pResCatId1);
   BRescat1.Caption := dmodule.pResCatName1;
 end;
end;


procedure SetTextAngle( F:Tfont; angle: Word);
var
  LogRec: TLOGFONT;
begin
  GetObject(f.Handle,SizeOf(LogRec),Addr(LogRec));
  LogRec.lfEscapement := angle;
  f.Handle := CreateFontIndirect(LogRec);
end;


procedure TFMain.ForceCellHeightClick(Sender: TObject);
begin
 FcellLayout.ForcedCellHeight.Visible := FcellLayout.ForceCellHeight.Checked;
 FcellLayout.ForcedCellWidth.Visible  := FcellLayout.ForceCellWidth.Checked;
 refreshGrid;
end;

procedure TFMain.BRescat1Click(Sender: TObject);
Var ID : ShortString;
begin
  ID := dmodule.pResCatId1;
  setSystemParam('ResCatSettings:'+dmodule.pResCatId1+':'+CurrentUserName, conResCat1.Text);
  If AutoCreate.RESOURCE_CATEGORIESShowModalAsSelect(ID) = mrOK Then begin
    dmodule.pResCatId1 := ID;
    onpResCatId1Change;
  end;
  conResCat1.Text := getSystemParam('ResCatSettings:'+dmodule.pResCatId1+':'+CurrentUserName);
end;

procedure TFMain.BRescat0Click(Sender: TObject);
Var ID : ShortString;
begin
  ID := dmodule.pResCatId0;
  setSystemParam('ResCatSettings:'+dmodule.pResCatId0+':'+CurrentUserName, conResCat0.Text);
  If AutoCreate.RESOURCE_CATEGORIESShowModalAsSelect(ID) = mrOK Then begin
    dmodule.pResCatId0 := ID;
    onpResCatId0Change;
  end;
  conResCat0.Text := getSystemParam('ResCatSettings:'+dmodule.pResCatId0+':'+CurrentUserName);
end;

procedure TFMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  ftoolwindow.Hide;
  fcellLayout.Hide;
  if silentMode then begin
    canClose := true;
    exit;
  end;
  self.AlphaBlend := true;
  self.AlphaBlendValue := 200;
    If Question('Zakoñczyæ dzia³anie aplikacji?') = ID_NO Then begin
      CanClose := False;
      self.AlphaBlendValue := 255;
    end;

    //CanClose and form was actually open
    if (CanClose) and (userLogged) then begin
      setSystemParam('SwitchMenu.Down', BoolToStr(SwitchMenu.Down));
      setSystemParam('Legend.Down', BoolToStr(Legend.Down));
      setSystemParam('BFullScreen.down', BoolToStr(BFullScreen.down));
    end;

end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //save user from long queries
  if TreeMode.ItemIndex > 1 then TreeMode.ItemIndex := 0;

  inherited;

 if assigned(flegend) then
   if flegend.Visible then FLegend.saveFormSettings;
 FLegend.SaveTimeTableNotes;

 saveFormSettings;
 DModule.CloseDBConnection;
 FcellLayout.Close;
 Stop;
end;

procedure TFMain.gridFontApply(Sender: TObject; Wnd: HWND);
begin
 refreshGrid;
end;

procedure TFMain.ForcedCellHeightChange(Sender: TObject);
begin
  refreshGrid;
end;

procedure TFMain.Image1Click(Sender: TObject);
begin
 FcellLayout.ForceCellHeight.Checked := not FcellLayout.ForceCellHeight.Checked;
end;

procedure TFMain.saveFormSettings;
begin
 SetSystemParam('gridFont.Size', inttostr(gridFont.Font.Size) );
 SetSystemParam('gridFont.Name', gridFont.Font.name);

 SetSystemParam('ForceCellWidth', BoolToStr(FcellLayout.ForceCellWidth.Checked) );
 SetSystemParam('ForceCellHeight', BoolToStr(FcellLayout.ForceCellHeight.Checked) );

 SetSystemParam('ForcedCellHeight', intToStr(FcellLayout.ForcedCellHeight.position) );
 SetSystemParam('ForcedCellWidth', intToStr(FcellLayout.ForcedCellWidth.position) );
 setSystemParam('RESOURCE_CATEGORY_ID1', dmodule.pResCatId1);
 setSystemParam('RESOURCE_CATEGORY_ID0', dmodule.pResCatId0);
end;

procedure TFMain.loadFormSettings;
begin
  gridFont.Font.Size          := strToInt( getSystemParam('gridFont.Size',  inttostr(grid.Canvas.Font.size)  ) );
  gridFont.Font.Name          :=           getSystemParam('gridFont.Name',  grid.Canvas.Font.name  );

  FcellLayout.ForceCellHeight.checked  := StrToBool( getSystemParam('ForceCellWidth','-') );
  FcellLayout.ForceCellWidth.checked   := StrToBool( getSystemParam('ForceCellHeight','-') );

  FcellLayout.ForcedCellHeight.position := strToInt( getSystemParam('ForcedCellHeight','5') );
  FcellLayout.ForcedCellWidth.position := strToInt( getSystemParam('ForcedCellWidth','5') );
end;

procedure TFMain.GridMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
 if ssCtrl in Shift then zoomOutClick(self) else inherited;
end;

procedure TFMain.GridMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
 if ssCtrl in Shift then zoomInClick(self) else inherited;
end;

procedure TFMain.pRightDockPanelUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
  (Sender as TPanel).Width := 1;
  fLegend.Status.show;
  fLegend.bClose.show;
  dockingPanel := C_FLOATING;
  setSystemParam('FLegend.dockingPanel', intToStr(dockingPanel) );
end;

procedure TFMain.pRightDockPanelDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  (Sender as TPanel).Width := flegend.UndockWidth;
  fLegend.Status.hide;
  fLegend.bClose.Hide;
  dockingPanel := (Sender as TPanel).tag;
  setSystemParam('FLegend.dockingPanel', intToStr(dockingPanel) );
end;

procedure TFMain.pRightDockPanelResize(Sender: TObject);
begin
  //do not save width when panel is hidden
  if (Sender as TPanel).Width > 10 then begin
    setSystemParam('FLegend.Width' ,intToStr (  (Sender as TPanel).Width  ) );
    flegend.UndockWidth := (Sender as TPanel).Width;
  end;
end;

procedure TFMain.Kombinacjezasobw1Click(Sender: TObject);
begin
  TT_COMBINATIONSShowModalAsBrowser;
  //FTTCombinations.showModal;
end;

procedure TFMain.Dozwolonekombinacjetypwzasobw1Click(Sender: TObject);
begin
 TT_RESCAT_COMBINATIONSShowModalAsBrowser;
end;

procedure TFMain.setupFillButton;
Var code : string;
begin
  FcellLayout.selectFill.Visible := true;
  code := getCode(FcellLayout.Coloring);
  if code = 'L'          then begin
     FillAddIfEmpty.Visible := true;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=cmdAttachLecClick;
     FillAdd.OnClick :=N21Click;
     FillDelete.OnClick:=Wszystkich1Click;
  end
  else
  if code = 'G'          then  begin
     FillAddIfEmpty.Visible := true;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=N19Click;
     FillAdd.OnClick :=N22Click;
     FillDelete.OnClick:=Wszystkie1Click;
  end
  else
  if code = 'S'          then  begin
     FillAddIfEmpty.Visible := false;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=nil;
     FillAdd.OnClick :=ppchangeSClick;
     FillDelete.OnClick:=ppminusSClick;
  end
  else
  if code = 'F'          then  begin
     FillAddIfEmpty.Visible := false;
     FillAdd.Visible := true;
     FillDelete.Visible := false;
     FillAddIfEmpty.OnClick:=nil;
     FillAdd.OnClick :=ppchangeFClick;
     FillDelete.OnClick:=nil;
  end
  else
  if code = 'OWNER'      then  begin
     FillAddIfEmpty.Visible := false;
     FillAdd.Visible := true;
     FillDelete.Visible := false;
     FillAddIfEmpty.OnClick:=nil;
     FillAdd.OnClick :=ppChangeOClick;
     FillDelete.OnClick:=nil;
  end
  else
  if code = 'CREATED_BY' then  begin
    FcellLayout.selectFill.Visible := false;
  end
  else
  if code = 'CLASS'      then  begin
     FillAddIfEmpty.Visible := false;
     FillAdd.Visible := true;
     FillDelete.Visible := false;
     FillAddIfEmpty.OnClick:=nil;
     FillAdd.OnClick :=ppchangeClassClick;
     FillDelete.OnClick:=nil;
  end
  else
  if code = 'DESC1'      then  begin
     FillAddIfEmpty.Visible := false;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=nil;
     FillAdd.OnClick :=Cdesc1Click;
     FillDelete.OnClick:=Ddesc1Click;
  end
  else
  if code = 'DESC2'      then  begin
     FillAddIfEmpty.Visible := false;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=nil;
     FillAdd.OnClick :=Cdesc2Click;
     FillDelete.OnClick:=Ddesc2Click;
  end
  else
  if code = 'DESC3'      then  begin
     FillAddIfEmpty.Visible := false;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=nil;
     FillAdd.OnClick :=Cdesc3Click;
     FillDelete.OnClick:=Ddesc3Click;
  end
  else
  if code = 'DESC4'      then  begin
     FillAddIfEmpty.Visible := false;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=nil;
     FillAdd.OnClick :=Cdesc4Click;
     FillDelete.OnClick:=Ddesc4Click;
  end
  else
  if code = 'NONE'       then  begin
     FcellLayout.selectFill.Visible := false;
  end
  else
  if code = 'ALL_RES'    then  begin
     FillAddIfEmpty.Visible := true;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=N110Click;
     FillAdd.OnClick :=N23Click;
     FillDelete.OnClick:=Wszystkir1Click;
  end
  else
  if code = '1'    then  begin
     FillAddIfEmpty.Visible := true;
     FillAdd.Visible := true;
     FillDelete.Visible := true;
     FillAddIfEmpty.OnClick:=N110Click;
     FillAdd.OnClick :=N23Click;
     FillDelete.OnClick:=Wszystkir1Click;
  end
  else  begin
     FcellLayout.selectFill.Visible := false;
  end;


end;


procedure TFMain.ColoringChange(Sender: TObject);
begin
  setupFillButton;

  If CanShow Then Begin
   {If Assigned(FLegend) Then
   Case ViewType.ItemIndex of
    0:FLegend.PageControl.ActivePage := FLegend.TabSheetW;
    1:FLegend.PageControl.ActivePage := FLegend.TabSheetG;
    2:FLegend.PageControl.ActivePage := FLegend.TabSheetR;
    3:FLegend.PageControl.ActivePage := FLegend.TabSheetS;
   End; }
   RefreshGrid;
  End;
end;

procedure TFMain.massImportClick(Sender: TObject);
begin
  if not isBlank(confineCalendarId) then begin
    info('Importowanie danych w arkusza Excel zosta³o zablokowane. Skontaktuj siê z Planist¹ lub Administratorem systemu');
    exit;
  end;

  if FMassImport = nil then Application.CreateForm(TFMassImport, FMassImport);
  FMassImport.ShowModal;
end;

procedure TFMain.Rejestracaus1Click(Sender: TObject);
begin
  if FAbolitionTime = nil then Application.CreateForm(TFAbolitionTime, FAbolitionTime);
  FAbolitionTime.Showmodal;
end;

procedure TFMain.BCopyClick(Sender: TObject);
begin
  uutilityParent.copyToClipBoard(
   fprogramsettings.profileObjectNameLs.Text+':' + ConLecturer_value.Text + cr +
   fprogramsettings.profileObjectNameGs.Text+':' + ConGroup_value.Text + cr +
   dmodule.pResCatName0 + conResCat0_value.Text + cr +
   dmodule.pResCatName1 + conResCat1_value.Text + cr +
   fprogramsettings.profileObjectNameC1.Text+':'  + ConSubject_value.Text + cr +
   fprogramsettings.profileObjectNameC2.Text+':'+ ConForm_value.Text + cr +
   FProgramSettings.getClassDescPlural(1)+':' + ''+ cr +
   FProgramSettings.getClassDescPlural(2)+':' + ''+ cr +
   FProgramSettings.getClassDescPlural(3)+':' + ''+ cr +
   FProgramSettings.getClassDescPlural(4)+':' + ''
  );

  With FDetails Do Begin
   CanPaste            := True;
   Clipboard_L1        := ConLecturer.Text;
   Clipboard_G1        := ConGroup.Text;
   Clipboard_ResCat0_1 := conResCat0.Text;
   Clipboard_ResCat1_1 := conResCat1.Text;
   Clipboard_S1        := ConSubject.Text;
   Clipboard_F1        := ConForm.Text;
   Clipboard_Fill1     := '100';
   Clipboard_Colour1   := 0;
   Clipboard_Colour2   := 0;
   Clipboard_L2        := ConLecturer.Text;
   Clipboard_G2        := ConGroup.Text;
   Clipboard_ResCat0_2 := conResCat0.Text;
   Clipboard_ResCat1_2 := conResCat1.Text;
   Clipboard_F2        := ConForm.Text;
   Clipboard_Desc1     := '';
   Clipboard_Desc2     := '';
   Clipboard_Desc3     := '';
   Clipboard_Desc4     := '';
  End;
end;

procedure TFMain.BPasteClick(Sender: TObject);
begin
  With FDetails Do Begin
   If Not CanPaste Then Info('Brak danych do wklejenia')
   Else Begin
    //Do not use getChildsAndParents here
    ConLecturer.Text := Clipboard_L1;
    ConGroup.Text    := Clipboard_G1;
    conResCat0.Text  := Clipboard_ResCat0_1;
    conResCat1.Text  := Clipboard_ResCat1_1;
    ConSubject.Text  := Clipboard_S1;
    ConForm.Text     := Clipboard_F1;
    //FILL1.ItemIndex := (StrToInt(Clipboard_Fill1) div 10)-1;
    //L2.Text := Clipboard_L2;
    //G2.Text := Clipboard_G2;
    //R2.Text := Clipboard_R2;
    //F2.Text := Clipboard_F2;
   End;
  End;
end;

procedure TFMain.BCellResetClick(Sender: TObject);
begin
  gridFont.Font.Name := 'Arial';
  gridFont.Font.Size := 8;
  FcellLayout.ForceCellWidth.Checked := false;
  FcellLayout.ForceCellHeight.Checked := false;
  refreshGrid;
end;

procedure TFMain.BCellFontClick(Sender: TObject);
begin
  if gridFont.Execute then refreshGrid;
end;

procedure TFMain.Osobyfizyczneiprawne1Click(Sender: TObject);
begin
  FIN_PARTIESShowModalAsBrowser('');
end;

procedure TFMain.Partiedokumentw1Click(Sender: TObject);
begin
  FIN_BATCHESShowModalAsBrowser;
end;

procedure TFMain.Fakturyrachunkip1Click(Sender: TObject);
begin
  FIN_DOCSShowModalAsBrowser('','','');
end;

procedure TFMain.Liniedokumentw1Click(Sender: TObject);
begin
  FIN_LINESShowModalAsBrowser('');
end;

procedure TFMain.Konfiguracja1Click(Sender: TObject);
begin
  FIN_LOOKUP_VALUESShowModalAsBrowser;
end;

procedure TFMain.EksportujdoGoogleKalendarz1Click(Sender: TObject);
begin
  GenerateWWW(1);
end;

procedure TFMain.Siatkagodzinowa1Click(Sender: TObject);
begin
  GRIDSShowModalAsBrowser;
  BRefreshClick(nil);
end;


procedure TFMain.BitBtnPERClick(Sender: TObject);
Var KeyValue : ShortString;
    roleId : shortString;
begin
  inherited;
  KeyValue := conPeriod.Text;
  If PERIODSShowModalAsSelect(KeyValue) = mrOK Then Begin
   conPeriod.Text := KeyValue;
   BRefreshClick(nil);
  End else
    if not isBlank (conPeriod.Text) then setPeriod; //nawet jesli nie zmieniono semestru, to mogly zostac zmienione parametry semestru ( np. liczba godzin ). dlatego odswiezam uklad

   if not isBlank (conPeriod.Text) then
   With DModule Do Begin
    Dmodule.SingleValue('SELECT ROL_ID FROM PERIODS WHERE ID='+conPeriod.Text);
    roleId := QWork.Fields[0].AsString;
    if not isBlank(roleId) then begin
     roleId := DModule.SingleValue('SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+' AND ROL_ID = ' +roleId);
     if isBlank(roleID) then info('Nie powiod³o siê aktywowanie autoryzacji, poniewa¿ nie masz uprawnieñ do korzystania z domyœlnej autoryzacji, przydzielonej do wybranego semestru.')
                        else conRole.Text := roleID;
    end;
   end;
end;

procedure TFMain.BitBtnROLEClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := conRole.Text;
  //If FORMSShowModalAsSelect(KeyValue) = mrOK Then F1.Text := KeyValue;
  If LookupWindow(false, DModule.ADOConnection, 'PLANNERS','','NAME','NAZWA','NAME','(TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+'))','',KeyValue) = mrOK Then begin
    conRole.Text := KeyValue;
    setPeriod;
  end;
end;

procedure TFMain.BitBtnSUBClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  inherited;
  KeyValue := ConSubject.Text;
  If SUBJECTSShowModalAsSelect(KeyValue,'') = mrOK Then Begin
   ConSubject.Text := KeyValue;
  End;
end;

procedure TFMain.BitBtnFORMClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := ConForm.Text;
  If FORMSShowModalAsSelect(KeyValue,'') = mrOK Then ConForm.Text := KeyValue;
  //If LookupWindow(DModule.Database, 'FORMS','','NAME','NAZWA','NAME','0=0','',KeyValue) = mrOK Then ConForm.Text := KeyValue;
  // w polu where jest 0=0 (a nie np. (KIND<>''R'' OR KIND IS NULL))
end;

procedure TFMain.BClearSClick(Sender: TObject);
begin
  inherited;
  ConSubject.Text := '';
end;

procedure TFMain.BitBtnCLEARROLEClick(Sender: TObject);
begin
  conRole.Text := '';
  conRoleChange(nil);
  TEdit(Sender).hide;
end;

procedure TFMain.BSelectCombClick(Sender: TObject);
Var KeyValue  : ShortString;
    rescat_id : Integer;
    res_id    : String;
begin
  KeyValue := '';
  If TT_COMBINATIONSShowModalAsSelect(KeyValue) = mrOK Then
   with dmodule do begin
     CanShow := false;
     opensql(
      'select id, res_id, tt_planner.get_rescat_id(res_id) rescat_id from tt_resource_lists where tt_comb_id = '+ KeyValue +cr+
      'order by 1');
     qwork.First;
     conform.Text     := '';
     consubject.Text  := '';
     conlecturer.Text := '';
     congroup.Text    := '';
     conrescat0.Text  := '';
     conrescat1.Text  := '';
     while not qwork.Eof do begin
       rescat_id := qwork.fieldbyname('rescat_id').AsInteger;
       res_id    := qwork.fieldbyname('res_id').AsString;

       case rescat_id of
         g_form      : conform.Text     := merge(conform.Text, res_id, ';');
         g_subject   : consubject.Text  := merge(consubject.Text, res_id, ';');
         g_lecturer  : conlecturer.Text := merge(conlecturer.Text, res_id, ';');
         g_group     : congroup.Text    := merge(congroup.Text, res_id, ';');
         //not valid in this context
         //g_planner   : conpla.Text := merge(conpla.Text, res_id, ';');
         //g_period    : conper.Text := merge(conper.Text, res_id, ';');
         //g_date_hour : forAll.Checked := true
         else
           if rescat_id = strToInt(dmodule.pResCatId0) then conrescat0.Text := merge(conrescat0.Text, res_id, ';') else
           if rescat_id = strToInt(dmodule.pResCatId1) then conrescat1.Text := merge(conrescat1.Text, res_id, ';');
       end;
       qwork.Next;
     end;
     CanShow := true;
     ConLecturerChange(conlecturer);
     ConGroupChange   (congroup);
     conrescat0Change (conrescat0);
     conrescat1Change (conrescat1);
     consubjectChange (consubject);
     conformChange    (conform);
   end;
end;

procedure TFMain.Listazajchistoriazmian1Click(Sender: TObject);
begin
  if not trackHistoryInstalled then begin info('Element "Historia zmian" nie zosta³ zainstalowany'); exit; end;
  AutoCreate.CLASSESShowModalAsBrowser('CLASSES_HISTORY','','','', '','','','',false);
end;

procedure TFMain.BTraceHistoryClick(Sender: TObject);
begin
 logChanges := not logChanges;

 if logChanges then dmodule.sql('begin update planners set log_changes=''+'' where name = user; planner_utils.enable_trial; end;')
               else dmodule.sql('begin update planners set log_changes=''-'' where name = user; planner_utils.disable_trial; end;');
end;

procedure TFMain.setHistoryEnabled;
begin
  try
   trackHistoryInstalled := true;
   logChanges := iif( dmodule.SingleValue('select log_changes from planners where name = user') = '+', true, false);
   if logChanges then begin dmodule.sql('begin planner_utils.enable_trial; end;');  BTraceHistory.Down := true; end
                      else begin dmodule.sql('begin planner_utils.disable_trial; end;'); BTraceHistory.Down := false; end;
  except
    trackHistoryInstalled := false;
  end;
end;


procedure TFMain.Przedmiotyvswykladowcy1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'SvsL';
  FMatrix.ShowModal;
end;

procedure TFMain.Przedmiotyvsgrupy1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'SvsG';
  FMatrix.ShowModal;
end;

procedure TFMain.Przedmiotyvssale1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'SvsR';
  FMatrix.ShowModal;
end;

procedure TFMain.Wykladowcyvsgrupy1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'LvsG';
  FMatrix.ShowModal;
end;

procedure TFMain.Wykladowcyvssale1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'LvsR';
  FMatrix.ShowModal;
end;

procedure TFMain.Grupyvssale1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'LvsG';
  FMatrix.ShowModal;
end;

procedure TFMain.Kadyprzedmiotwoddzielnejtabeli1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'S';
  FMatrix.ShowModal;
end;

procedure TFMain.Jednatabeladlawszystkich1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'Sall';
  FMatrix.ShowModal;
end;

procedure TFMain.Kadywykadowcawoddzielnejtabeli1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'L';
  FMatrix.ShowModal;
end;

procedure TFMain.Jednatabeladlawszystkich2Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'Lall';
  FMatrix.ShowModal;
end;

procedure TFMain.Kadagrupawoddzielnejtabeli1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'G';
  FMatrix.ShowModal;
end;

procedure TFMain.v1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'Gall';
  FMatrix.ShowModal;
end;

procedure TFMain.Kadyzasbwoddzielnejtabeli1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'R';
  FMatrix.ShowModal;
end;

procedure TFMain.Jednatabeladlawszystkich3Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'Rall';
  FMatrix.ShowModal;
end;

procedure TFMain.Kadaformawoddzielnejtabeli1Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'F';
  FMatrix.ShowModal;
end;

procedure TFMain.Jednatabeladlawszystkich4Click(Sender: TObject);
begin
  fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;
  fmatrix.defaultSchema := 'Fall';
  FMatrix.ShowModal;
end;

procedure TFMain.Innatabelaprzestawna1Click(Sender: TObject);
begin
  //fmatrix.Caption := 'Tabela przestawna: ' + treeview1.Selected.Text;

  if assigned(treeview1.Selected) then
      fmatrix.Caption := 'Tabela przestawna: ' + treeview1.Selected.Text
  else
      fmatrix.Caption := 'Tabela przestawna: ' + (sender as tmenuitem).Caption;

  fmatrix.defaultSchema := 'CUSTOM';
  FMatrix.ShowModal;
end;

procedure TFMain.Wskanikiefektywnoci1Click(Sender: TObject);
begin
  FKPI := TFKPI.Create(Application);
  FKPI.ShowModal;
  FKPI.free;
  FKPI := nil;
end;

procedure TFMain.MenuItem2Click(Sender: TObject);
begin
  Listazajchistoriazmian1Click(nil);
end;

procedure TFMain.GoogleMapEasyClick(Sender: TObject);
begin
  FGoogleMap  := TFGoogleMap.Create(Application);
  With FGoogleMap do Begin
    Show;
    BCreateClick(nil);
    BCloseClick(nil);
    free;
  End;
end;

procedure TFMain.GoogleMapAdvClick(Sender: TObject);
begin
  FGoogleMap  := TFGoogleMap.Create(Application);
  With FGoogleMap do Begin
    showmodal;
    free;
  End;
end;

procedure TFMain.CONLECTURER_valueClick(Sender: TObject);
begin
  if (sender as tedit).Text='' then _selectL (false);
end;

procedure TFMain.CONGROUP_valueClick(Sender: TObject);
begin
  if (sender as tedit).Text='' then _selectG (false);
end;

procedure TFMain.conResCat0_valueClick(Sender: TObject);
begin
  if (sender as tedit).Text='' then _selectR (false);
end;

procedure TFMain.conResCat1_valueClick(Sender: TObject);
begin
  if (sender as tedit).Text='' then _selectResCat1 (false);
end;

procedure TFMain.CONSUBJECT_valueClick(Sender: TObject);
begin
  BitBtnSUBClick(nil);
end;

procedure TFMain.CONFORM_VALUEClick(Sender: TObject);
begin
  BitBtnFORMClick(nil);
end;

procedure TFMain.selectlClick(Sender: TObject);
begin
 _selectL (true);
end;

procedure TFMain.selectgClick(Sender: TObject);
begin
  _selectG (true);
end;

procedure TFMain.selectrClick(Sender: TObject);
begin
  _selectR (true);
end;

procedure TFMain.selectResCat1Click(Sender: TObject);
begin
  _selectResCat1 (true);
end;

procedure TFMain.CONPERIOD_VALUEClick(Sender: TObject);
begin
  BitBtnPERClick(nil);
end;

procedure TFMain.CONROLE_VALUEClick(Sender: TObject);
begin
  BitBtnROLEClick(nil);
end;

Procedure CopyMenuToTreeView( aMenu: TMenu; aTreeview: TTreeview);
  //--------------
  Procedure AddItems( anItem: TMenuItem; aParentNode: TTreenode );
  Var
    node: TTreenode;
    i: Integer;
    itemCaption: string;
  Begin
    For i:= 0 To anItem.Count -1 Do Begin
        if anItem.Items[i].Enabled then begin
            itemCaption := StringReplace(anItem.Items[i].Caption, '&', '', []);
            if itemCaption = '-' then itemCaption := '_____';
            node:= aTreeview.Items.AddChild(
                 aParentNode,
                 itemCaption
               );
            node.ImageIndex := -1;
            AddItems( anItem.Items[i], node );
        end;
    End;
  End;
//--------------
Begin
  Assert( Assigned( aTreeview ), 'No treeview' );
  Try
    aTreeview.Items.Clear;
    If Assigned( aMenu ) Then
      AddItems( aMenu.Items, nil );
    aTreeview.FullExpand;
  Finally
    aTreeview.Selected := nil;
  End; { Finally }
End;

Procedure TFMain.addDBItemsItemsToTreeView(aTreeview: TTreeview; aFilter : string);
  Var
    node : TTreenode;
    nodeSEP: TTreenode;
    nodeMORE: TTreenode;
    nodeL: TTreenode;
    nodeG: TTreenode;
    nodeR: TTreenode;
    nodeS: TTreenode;
    nodeP: TTreenode;
    nodeC: TTreenode;
    nodeTT: TTreenode;
    sqlString : string;
    nodeInfo : TNodeInfo;
    procedure addNodeSep;
    begin
      if nodeSEP=nil then
        nodeSEP:= aTreeview.Items.AddChild(nil, 'Baza danych');
    end;
    procedure addNodeL;
    begin
      if nodeL=nil then
        nodeL:= aTreeview.Items.AddChild(nil, fprogramsettings.profileObjectNameLs.Text);
    end;
    procedure addNodeG;
    begin
      if nodeG=nil then
          nodeG:= aTreeview.Items.AddChild(nil, fprogramsettings.profileObjectNameGs.Text);
    end;
    procedure addNodeR;
    begin
      if nodeR=nil then
          nodeR:= aTreeview.Items.AddChild(nil, 'Zasoby');
    end;
    procedure addNodeS;
    begin
      if nodeS=nil then
          nodeS:= aTreeview.Items.AddChild(nil, fprogramsettings.profileObjectNameC1s.Text);
    end;
    procedure addNodeP;
    begin
      if nodeP=nil then
          nodeP:= aTreeview.Items.AddChild(nil, fprogramsettings.profileObjectNamePeriods.Text);
    end;
    procedure addNodeC;
    begin
      if nodeC=nil then
          nodeC:= aTreeview.Items.AddChild(nil, 'Kalendarze szczególne');
    end;
    procedure addNodeTT;
    begin
      if nodeTT=nil then
          nodeTT:= aTreeview.Items.AddChild(nil, 'Rozk³ady zajêæ');
    end;
    function getNode(nodeType : string) : TTreenode;
    begin
        if nodeType='L' then begin addNodeL; result := nodeL; exit; end;
        if nodeType='G' then begin addNodeG; result := nodeG; exit; end;
        if nodeType='R' then begin addNodeR; result := nodeR; exit; end;
        if nodeType='S' then begin addNodeS; result := nodeS; exit; end;
        if nodeType='P' then begin addNodeP; result := nodeP; exit; end;
        if nodeType='C' then begin addNodeC; result := nodeC; exit; end;
        if nodeType='TT' then begin addNodeTT; result := nodeTT; end;
    end;
    function getNodeImage(nodeType : string) : integer;
    begin
        if nodeType='L' then begin result := 15; exit; end;
        if nodeType='G' then begin result := 16; exit; end;
        if nodeType='R' then begin result := 18; exit; end;
        if nodeType='S' then begin result := 17; exit; end;
        if nodeType='P' then begin result := 20; exit; end;
        if nodeType='C' then begin result := 23; exit; end;
        if nodeType='TT' then begin result := 24; end;
    end;
Begin
    aFilter := replacePolishChars(AnsiUppercase(aFilter));
    nodeL := nil;
    nodeG := nil;
    nodeR := nil;
    nodeS := nil;
    nodeP := nil;
    nodeC := nil;
    nodeTT := nil;
    nodeSEP:= nil;

    sqlString := fastQueryString.Lines.Text;
    sqlString := stringreplace(sqlString, '%PERMISSIONS_L', getWhereClause('LECTURERS','m'), []);
    sqlString := stringreplace(sqlString, '%PERMISSIONS_G', getWhereClause('GROUPS','m'), []);
    sqlString := stringreplace(sqlString, '%PERMISSIONS_R', getWhereClause('ROOMS','m'), []);
    sqlString := stringreplace(sqlString, '%PERMISSIONS_S', getWhereClause('SUBJECTS','m'), []);
    if isBlank(confineCalendarId) then
    sqlString := stringreplace(sqlString, '%PERMISSIONS_C', getWhereClause('ROOMS','m'), [])
    else
    //disable calendar in search panel
    sqlString := stringreplace(sqlString, '%PERMISSIONS_C', '0=1', []);
    sqlString := stringreplace(sqlString, '%LIMIT', getSystemParam('FastQueryMaxRecords','10'), []);
    dmodule.openSQL(fastQuery, sqlString ,
     's1='+ aFilter+
     ';s2='+ aFilter+
     ';s3='+ aFilter+
     ';s4='+ aFilter+
     ';s5='+ aFilter+
     ';s6='+ aFilter
     );
    with fastQuery do begin
        first;
        while not fastQuery.Eof do begin
            addNodeSep;
            node:= aTreeview.Items.AddChild(
                getNode( fastQuery.FieldByName('type').AsString  )
              , fastQuery.FieldByName('Name').AsString
            );
            node.ImageIndex := getNodeImage( fastQuery.FieldByName('type').AsString );
            nodeInfo := TNodeInfo.Create;
            nodeInfo.Id := fastQuery.FieldByName('Id').AsString;
            node.Data := nodeInfo;
            next;
        end;
    end;

    sqlString := tt_notes.Lines.Text;
    sqlString := stringreplace(sqlString, '%PERMISSIONS_L', getWhereClause('LECTURERS','m'), []);
    sqlString := stringreplace(sqlString, '%PERMISSIONS_G', getWhereClause('GROUPS','m'), []);
    sqlString := stringreplace(sqlString, '%PERMISSIONS_R', getWhereClause('ROOMS','m'), []);
    sqlString := stringreplace(sqlString, '%LIMIT', getSystemParam('FastQueryMaxRecords','10'), []);
    dmodule.openSQL(sqlString,'s='+afilter);
    with dmodule.QWork do begin
        first;
        while not dmodule.QWork.Eof do begin
            if nodeSEP<>nil then addNodeSep;
            node:= aTreeview.Items.AddChild(
                getNode( 'TT'  )
              , dmodule.QWork.FieldByName('Name').AsString
            );
            node.ImageIndex := getNodeImage( 'TT' );
            nodeInfo := TNodeInfo.Create;
            nodeInfo.Id := dmodule.QWork.FieldByName('per_id').AsString+','+dmodule.QWork.FieldByName('resource_type').AsString+','+dmodule.QWork.FieldByName('res_id').AsString;
            node.Data := nodeInfo;
            next;
        end;
    end;


    if nodeSEP<>nil then begin
    nodeMORE:= aTreeview.Items.AddChild(
                nil
              , 'Wyœwietlaj rekordów'
            );
    //
    node:= aTreeview.Items.AddChild(
                nodeMORE
              , '100 (szybko)'
            );
    nodeInfo := TNodeInfo.Create;
    nodeInfo.Id := '100';
    node.Data := nodeInfo;
    node.ImageIndex := 19;
    //
    node:= aTreeview.Items.AddChild(
                nodeMORE
              , '1000'
            );
    nodeInfo := TNodeInfo.Create;
    nodeInfo.Id := '1000';
    node.Data := nodeInfo;
    node.ImageIndex := 19;
    //
    node:= aTreeview.Items.AddChild(
                nodeMORE
              , '10000 (wolno)'
            );
    nodeInfo := TNodeInfo.Create;
    nodeInfo.Id := '10000';
    node.Data := nodeInfo;
    node.ImageIndex := 19;
    //
    end;

    aTreeview.FullExpand;
End;

procedure clearNotMatchingItems(aTreeview: TTreeview; aFilter : string);
var
  CurItem: TTreeNode;
  NextItem : TTreeNode;
  t : integer;
  canDelete : boolean;
  function trivial ( s : string ) : string;
  begin
      result := replacePolishChars( ansiuppercase(s) );
  end;
begin
  For t := 1 to 5 do begin
    CurItem := aTreeview.Items.GetFirstNode;
    if aFilter <> '' then
    while CurItem <> nil do
    begin
      //form1.Memo1.lines.add(CurItem.Text +'     '+ inttostr(curitem.level+1));
      NextItem := CurItem.GetNext;
      if (not CurItem.HasChildren) and ( Pos( trivial(aFilter), trivial(curItem.text) )=0 ) then begin
        canDelete := true;
        if CurItem.Parent<>nil then begin
          if Pos( trivial(aFilter), trivial(CurItem.Parent.Text) )<> 0 then canDelete := false;

          if CurItem.Parent.Parent<>nil then begin
            if Pos( trivial(aFilter), trivial(CurItem.Parent.Parent.Text) )<> 0 then canDelete := false;
          end;

        end;
        if canDelete then
            CurItem.Delete;
      end;
      CurItem := NextItem;
    end;
  end;
end;

procedure OnMenuItemClick(aMenu: tmenu; aCaption: string);
    procedure searchItems(anItem: TMenuItem);
    var i : integer;
    begin
        For i:= 0 To anItem.Count -1 Do Begin
          if StringReplace(anItem.Items[i].Caption, '&', '', [])=aCaption then
            if  Assigned(anItem.Items[i].OnClick) then begin
              anItem.Items[i].OnClick(anItem.Items[i]);
              //repeated menu caption? Ignore others
              exit;
            end;
          searchItems( anItem.Items[i]);
        End;
    end;
begin
  searchItems(aMenu.Items);
end;

procedure TFMain.SearchMenuChange(Sender: TObject);
var s : string;
begin
  s := iif(searchMenu.Text = 'Szukaj...', '', searchMenu.Text);
  if pos(';',s)<>0 then s :=  searchAndReplace(s,';','');

  TreeView1.Items.BeginUpdate;
  CopyMenuToTreeView(mm, TreeView1);
  clearNotMatchingItems(TreeView1, s);
  if s <> '' then
      addDBItemsItemsToTreeView(TreeView1, s);
  TreeView1.Items.EndUpdate;
  if TreeView1.Items.Count > 0 then
      TreeView1.Selected := TreeView1.Items[0];
end;

procedure TFMain.TreeView1Click(Sender: TObject);
Var perdiodId    : String;
    resourceType : String;
    resourceId   : ShortString;
    tv           : ttreeView;
begin
   tv := (Sender as ttreeview);
   if assigned(tv.Selected) then begin
      if assigned(tv.Selected.data) then begin
        //
        if tv.Selected.ImageIndex=15 then begin
            tv.Visible := false;
            tv.Refresh;
            resourceId := tnodeInfo(tv.Selected.data).id;
            tv.Visible := true;
            FActionTree.showList('L');
            case FActionTree.selectedOption of
             0: begin
                  LECTURERSShowModalAsSingleRecord(aedit,resourceId);
                end;
             1: begin
                  TabViewType.TabIndex := 0;
                  conlecturer.Text := getChildsAndParents(resourceId, '', true, false);
                end;
             2: OpenFGrouping('L',resourceId);
            end;
        end;
        //
        if tv.Selected.ImageIndex=16 then begin
            tv.Visible := false;
            tv.Refresh;
            resourceId := tnodeInfo(tv.Selected.data).id;
            tv.Visible := true;
            FActionTree.showList('G');
            case FActionTree.selectedOption of
             0: GROUPSShowModalAsSingleRecord(aedit,resourceId);
             1: begin
                  TabViewType.TabIndex := 1;
                  congroup.Text := getChildsAndParents(resourceId, '', true, false);
                end;
             2: OpenFGrouping('G',resourceId);
            end;
        end;
        //
        if tv.Selected.ImageIndex=18 then begin
            tv.Visible := false;
            tv.Refresh;
            resourceId := tnodeInfo(tv.Selected.data).id;
            tv.Visible := true;
            FActionTree.showList('R');
            case FActionTree.selectedOption of
             0: ROOMSShowModalAsSingleRecord(aedit,resourceId);
             1: begin
                  TabViewType.TabIndex := 2;
                  conResCat0.Text := getChildsAndParents(resourceId, '', true, false);
                end;
             2: OpenFGrouping('R',resourceId);
            end;
        end;
        //
        if tv.Selected.ImageIndex=23 then begin
            tv.Visible := false;
            tv.Refresh;
            resourceId := tnodeInfo(tv.Selected.data).id;
            tv.Visible := true;
            FActionTree.showList('C');
            case FActionTree.selectedOption of
             0: ROOMSShowModalAsSingleRecord(aedit,resourceId);
             1: begin
                  TabViewType.TabIndex := 5;
                  CALID.Text := resourceId;
             end;
            end;
        end;
        //
        if tv.Selected.ImageIndex=24 then begin
            tv.Visible := false;
            tv.Refresh;

            perdiodId    := extractWord(1,tnodeInfo(tv.Selected.data).id,[',']);
            resourceType := extractWord(2,tnodeInfo(tv.Selected.data).id,[',']);
            resourceId   := extractWord(3,tnodeInfo(tv.Selected.data).id,[',']);

            conperiod.Text := perdiodId;
            TabViewType.TabIndex := StrToInt(resourceType);

            Case TabViewType.TabIndex of
             0: conlecturer.Text := getChildsAndParents(resourceId, '', true, false);
             1: congroup.Text := getChildsAndParents(resourceId, '', true, false);
             2: conResCat0.Text := getChildsAndParents(resourceId, '', true, false);
            End;

            tv.Visible := true;
        end;
        //
        if tv.Selected.ImageIndex=17 then begin
            resourceId := tnodeInfo(tv.Selected.data).id;
            FActionTree.showList('S');
            case FActionTree.selectedOption of
             0: SUBJECTSShowModalAsSingleRecord(aedit,resourceId);
             1: begin CONSUBJECT.Text := resourceId; end;
             2: OpenFGrouping('S',resourceId);
            end;
        end;
        //
        if tv.Selected.ImageIndex=25 then begin
            resourceId := tnodeInfo(tv.Selected.data).id;
            FActionTree.showList('F');
            case FActionTree.selectedOption of
             0: FORMSShowModalAsSingleRecord(aedit,resourceId);
             1: begin CONFORM.Text := resourceId; end;
             2: OpenFGrouping('F',resourceId);
            end;
        end;
        //
        if tv.Selected.ImageIndex=26 then begin
            resourceId := tnodeInfo(tv.Selected.data).id;
            PLANNERSShowModalAsSingleRecord(aedit,resourceId);
        end;
        //
        if tv.Selected.ImageIndex=20 then begin
            tv.Visible := false;
            tv.Refresh;
            resourceId := tnodeInfo(tv.Selected.data).id;
            tv.Visible := true;
            FActionTree.showList('P');
            case FActionTree.selectedOption of
             0: PERIODSShowModalAsSingleRecord(aedit,resourceId);
             1: begin conPeriod.Text := resourceId; end;
             2: OpenFGrouping('P',resourceId);
            end;
        end;
        //
        if tv.Selected.ImageIndex=19 then begin
            setSystemParam('FastQueryMaxRecords', tnodeInfo(tv.Selected.data).id);
            SearchMenuChange(nil);
            exit;
        end;
      end else
        if tv.Name <> 'TreeRecentlyused' then
            OnMenuItemClick(mm,tv.Selected.Text);
   end;
end;

procedure TFMain.SwitchMenuClick(Sender: TObject);
var s : string;
begin
  if SwitchMenu.Down then begin
    SearchPanel.width := 255;
    TreeView1.Visible := false;
    CopyMenuToTreeView(mm, TreeView1);
    s := iif(searchMenu.Text = 'Szukaj...', '', searchMenu.Text);
    clearNotMatchingItems(TreeView1, s );
    if s <> '' then
        addDBItemsItemsToTreeView(TreeView1, s );
    TreeView1.Visible := true;
    //Self.Menu := nil;
  end else begin
    LeftPanel.visible := true;
    SearchPanel.width := 1;
    //Self.Menu := mm;
  end;
end;

procedure TFMain.Penyekran1Click(Sender: TObject);
begin
  BFullScreenClick(nil);
end;

procedure TFMain.BFastSearchNewClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 pSearchMenuadd.Popup(Point.X,Point.Y);
end;

procedure TFMain.Nowywykadowca1Click(Sender: TObject);
var dummy : shortString;
begin
  //LECTURERSShowModalAsBrowser('');
  dummy := '';
  LECTURERSShowModalAsSingleRecord(ainsert,dummy);
  SearchMenuChange(nil);
end;

procedure TFMain.Nowagrupa1Click(Sender: TObject);
var dummy : shortString;
begin
  //GROUPSShowModalAsBrowser('');
  dummy := '';
  GROUPSShowModalAsSingleRecord(ainsert,dummy);
  SearchMenuChange(nil);
end;

procedure TFMain.Nowyprzedmiot1Click(Sender: TObject);
var dummy : shortString;
begin
  //SUBJECTSShowModalAsBrowser('');
  dummy := '';
  SUBJECTSShowModalAsSingleRecord(ainsert,dummy);
  SearchMenuChange(nil);
end;

procedure TFMain.Nowysemestr1Click(Sender: TObject);
var dummy : shortString;
begin
  //PERIODSShowModalAsBrowser;
  dummy := '';
  PERIODSShowModalAsSingleRecord(ainsert,dummy);
  SearchMenuChange(nil);
end;

procedure TFMain.Nowyzasb1Click(Sender: TObject);
begin
  ROOMSShowModalAsBrowser('1','');
end;

procedure TFMain.SpeedButton1Click(Sender: TObject);
begin
 BitBtnPERClick(nil);
end;

procedure TFMain.SpeedButton2Click(Sender: TObject);
begin
  _selectL (false);
end;

procedure TFMain.SpeedButton3Click(Sender: TObject);
begin
 _selectG (false);
end;

procedure TFMain.SpeedButton4Click(Sender: TObject);
begin
  _selectR (false);
end;

procedure TFMain.BCloseAppClick(Sender: TObject);
begin
  Close;
end;

procedure TFMain.Cdesc1Click(Sender: TObject);
begin
  changeDesc(1);
end;

procedure TFMain.Cdesc2Click(Sender: TObject);
begin
  changeDesc(2);
end;

procedure TFMain.Cdesc3Click(Sender: TObject);
begin
  changeDesc(3);
end;

procedure TFMain.Cdesc4Click(Sender: TObject);
begin
  changeDesc(4);
end;

procedure TFMain.Ddesc1Click(Sender: TObject);
begin
  deleteDescFromSelection(1);
end;

procedure TFMain.Ddesc2Click(Sender: TObject);
begin
  deleteDescFromSelection(2);
end;

procedure TFMain.Ddesc3Click(Sender: TObject);
begin
  deleteDescFromSelection(3);

end;

procedure TFMain.Ddesc4Click(Sender: TObject);
begin
  deleteDescFromSelection(4);

end;

procedure TFMain.Listzajzaznaczoneterminy1Click(Sender: TObject);
begin
    FMain.set_tmp_selected_dates;
    showClasses(false,true);
end;

procedure TFMain.abelaprzestawna1Click(Sender: TObject);
begin
  Innatabelaprzestawna1Click(sender);
end;

procedure TFMain.Raportowaniezaawansowane1Click(Sender: TObject);
begin
  FMain.set_tmp_selected_dates;
  FGrouping.ShowModal;
end;

procedure TFMain.Utwrzwitrynwww2Click(Sender: TObject);
begin
 GenerateWWW(0);
end;

procedure TFMain.EksportujdoGoogleKalendarz2Click(Sender: TObject);
begin
EksportujdoGoogleKalendarz1Click(nil);
end;

procedure TFMain.WskanikiefektywnociwykresyGoogle1Click(Sender: TObject);
begin
  Wskanikiefektywnoci1Click(nil);
end;

procedure TFMain.MapaGooglezzasobami3Click(Sender: TObject);
begin
  GoogleMapAdvClick(nil);
end;

function TFMain.getWhereFastFilter(filter, tableName : string) : string;
 begin
  if Filter='' then
    result := '0=0'
  else begin
    result := fastQueryGenericString.Lines.Text;
    result := stringreplace(result, 'var1', replacePolishChars( ansiuppercase(Filter) ), []);
    result := stringreplace(result, 'var2', replacePolishChars( ansiuppercase(Filter) ), []);
    result := stringreplace(result, 'var3', replacePolishChars( ansiuppercase(Filter) ), []);
    result := stringreplace(result, 'var4', replacePolishChars( ansiuppercase(Filter) ), []);
    result := stringreplace(result, 'var5', replacePolishChars( ansiuppercase(Filter) ), []);
    result := stringreplace(result, 'var6', replacePolishChars( ansiuppercase(Filter) ), []);
    result := tablename+'.id in'+result;
  end;
end;


procedure TFMain.FilterChange(Sender: TObject);
begin
  SearchCounter := 3;
  refreshFilter.Enabled := true;
end;

procedure TFMain.CustomPeriodChange(Sender: TObject);
var d1, d2 : integer;
begin
  if CustomPeriod.ItemIndex=0 then dmodule.dateRange:='TODAY:-2:+0';
  if CustomPeriod.ItemIndex=1 then dmodule.dateRange:='TODAY:-1:+0';
  if CustomPeriod.ItemIndex=2 then dmodule.dateRange:='TODAY';
  if CustomPeriod.ItemIndex=3 then dmodule.dateRange:='TODAY:+1:+0';
  if CustomPeriod.ItemIndex=4 then dmodule.dateRange:='TODAY:+2:+0';
  if CustomPeriod.ItemIndex=5 then dmodule.dateRange:='TODAY:-7:+6';
  if CustomPeriod.ItemIndex=6 then dmodule.dateRange:='TODAY:+0:+6';
  if CustomPeriod.ItemIndex=7 then dmodule.dateRange:='TODAY:+7:+6';
  if CustomPeriod.ItemIndex=8 then dmodule.dateRange:='TODAY:-30:+30';
  if CustomPeriod.ItemIndex=9 then dmodule.dateRange:='TODAY:+0:+30';
  if CustomPeriod.ItemIndex=10 then dmodule.dateRange:='TODAY:+30:+30';
  if CustomPeriod.ItemIndex=11 then dmodule.dateRange:='';
  if CustomPeriod.ItemIndex=12 then begin
    if FDatesSelector = nil then Application.CreateForm(TFDatesSelector, FDatesSelector);
    if FDatesSelector.showModal = mrOK then begin
        With FDatesSelector do begin
          d1 := DateUtils.DaysBetween(today(), source_date_from.Datetime) + iif(today()<source_date_from.Datetime,0,1);
          d2 := DateUtils.DaysBetween(source_date_from.Datetime, source_date_to.Datetime);
          dmodule.dateRange:='TODAY:'+iif(today()<source_date_from.Datetime,'+','-')+IntToStr(abs(d1))+':+'+IntToStr(abs(d2));
          SearchCounter := 3;
          refreshFilter.Enabled := true;
        end;
    end else exit;
  end;
  SearchCounter := 3;
  refreshFilter.Enabled := true;
{
0 Przedwczoraj
1 Wczoraj
2 Dzisiaj
3 Jutro
4 Pojutrze
5 Poprzedni tydzieñ
6 Bie¿¹cy tydzieñ
7 Za tydzieñ
8 Poprzedni miesi¹æ
9 Bie¿¹cy miesi¹c
10 Za miesi¹c
11 Bie¿¹cy semestr
}
end;

procedure TFMain.refreshFilterTimer(Sender: TObject);
begin
  If SearchCounter > 0 Then SearchCounter := SearchCounter - 1;
  If SearchCounter = 1 Then Begin
    refreshFilter.Enabled := false;
    BRefreshClick(nil);
  end;
end;

procedure TFMain.Generatorslajdw1Click(Sender: TObject);
begin
 Application.CreateForm(TFSlideshowGenerator, FSlideshowGenerator);
 FSlideshowGenerator.showmodal;
 FSlideshowGenerator.Free;
 FSlideshowGenerator := nil;
end;

procedure TFMain.Preferowaneterminy1Click(Sender: TObject);
begin
  RES_HINTSShowModalAsBrowser;
end;

procedure TFMain.Lista1Click(Sender: TObject);
begin
  RES_HINTSShowModalAsBrowser;
end;

procedure TFMain.DrawSuppressionSClick(Sender: TObject);
begin
  If not CanShow Then exit;
  RefreshGrid;
end;

procedure TFMain.Kalendarze1Click(Sender: TObject);
begin
  ROOMSShowModalAsBrowser( '-9','' );
end;

procedure TFMain.CALID_VALUEClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CALID.Text;
  If AutoCreate.ROOMSShowModalAsSelect('-9','',KeyValue,'0=0','') = mrOK Then CALID.Text := KeyValue;
end;

procedure TFMain.CALIDChange(Sender: TObject);
begin
  if ignoreEvents then exit;
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ROOMS','');
  BRefreshClick(nil);
end;

procedure TFMain.updateLeftPanel;
var parentPanel : Twincontrol;
  procedure setParent (parentPanel : Twincontrol);
  begin
   BClearS.Parent := parentPanel;
   Preview.Parent := parentPanel;
   BCopy.Parent := parentPanel;
   BPaste.Parent := parentPanel;
   lshowAvail.Parent := parentPanel;
   Shape1.Parent := parentPanel;
   BSelectComb.Parent := parentPanel;
   selectl.Parent := parentPanel;
   selectg.Parent := parentPanel;
   selectr.Parent := parentPanel;
   selectResCat1.Parent := parentPanel;
   LprofileObjectNameL.Parent := parentPanel;
   LprofileObjectNameG.Parent := parentPanel;
   BRescat0.Parent := parentPanel;
   BRescat1.Parent := parentPanel;
   LprofileObjectNameC1.Parent := parentPanel;
   LprofileObjectNameC2.Parent := parentPanel;
  end;
begin

 if tabViewType.TabIndex >= 4 then begin
   parentPanel := CalViewPanel;
   CalViewPanel.Visible := true;
   CalViewPanel.Align := alClient;
   CalViewPanel.BringToFront;
   BShowCellLayout.Visible := false;
   setParent(nil);
   Flegend.Hide;
 end else begin
   BShowCellLayout.Visible := true;
   parentPanel := LeftPanel;
   CalViewPanel.Visible := false;
   setParent(parentPanel);
   //Flegend.Show;
 end;

 L4.Visible := tabViewType.TabIndex = 4;
 ReservationType.Visible := tabViewType.TabIndex = 4;
 LabelReservationType.Visible := tabViewType.TabIndex = 4;
 LCal.Visible := tabViewType.TabIndex = 5 ;
 CALID_VALUE.Visible := tabViewType.TabIndex = 5;

 LprofileObjectNamePeriod.Parent := parentPanel;
 CONPERIOD_VALUE.Parent          := parentPanel;
 BitBtnPER.Parent                := parentPanel;
 LCONROLE_VALUE.Parent           := parentPanel;
 CONROLE_VALUE.Parent            := parentPanel;
 BitBtnCLEARROLE.Parent          := parentPanel;
end;

procedure TFMain.TabViewTypeChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  AllowChange := true;
  if (not isBlank(confineCalendarId)) and (NewTab=5) then AllowChange:=false;
end;

procedure TFMain.LeftPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FCellLayout.hideCellLayout(false);
  MouseOverLeftPanel := true;
end;

procedure TFMain.LeftPanelClick(Sender: TObject);
begin
  FCellLayout.hideCellLayout(true) ;
end;

procedure TFMain.GridClick(Sender: TObject);
begin
 FCellLayout.hideCellLayout(true) ;
end;


Procedure TFMain.refreshRecentlyUsed(aFilter : string);
  Var
    node : TTreenode;
    nodeMORE: TTreenode;
    nodeL: TTreenode;
    nodeG: TTreenode;
    nodeR: TTreenode;
    nodeS: TTreenode;
    nodeF: TTreenode;
    nodeP: TTreenode;
    nodeC: TTreenode;
    nodeB: TTreenode;
    sqlString : string;
    nodeInfo : TNodeInfo;
    startDate, endDate, durationInSeconds, lastRefreshTime : tdatetime;
    panelName : string;
    lastRefreshTimeDsp : string;
    procedure addNodeL;
    begin
      if nodeL=nil then
        nodeL:= TreeRecentlyused.Items.AddChild(nil, fprogramsettings.profileObjectNameLs.Text);
    end;
    procedure addNodeG;
    begin
      if nodeG=nil then
          nodeG:= TreeRecentlyused.Items.AddChild(nil, fprogramsettings.profileObjectNameGs.Text);
    end;
    procedure addNodeR;
    begin
      if nodeR=nil then
          nodeR:= TreeRecentlyused.Items.AddChild(nil, 'Zasoby');
    end;
    procedure addNodeS;
    begin
      if nodeS=nil then
          nodeS:= TreeRecentlyused.Items.AddChild(nil, fprogramsettings.profileObjectNameC1s.Text);
    end;
    procedure addNodeF;
    begin
      if nodeF=nil then
          nodeF:= TreeRecentlyused.Items.AddChild(nil, fprogramsettings.profileObjectNameC2s.Text);
    end;
    procedure addNodeP;
    begin
      if nodeP=nil then
          nodeP:= TreeRecentlyused.Items.AddChild(nil, fprogramsettings.profileObjectNamePeriods.Text);
    end;
    procedure addNodeC;
    begin
      if nodeC=nil then
          nodeC:= TreeRecentlyused.Items.AddChild(nil, 'Kalendarze szczególne');
    end;
    procedure addNodeB;
    begin
      if nodeB=nil then
          nodeB:= TreeRecentlyused.Items.AddChild(nil, 'Planiœci');
    end;
    function getNode(nodeType : string) : TTreenode;
    begin
        if nodeType='L' then begin addNodeL; result := nodeL; exit; end;
        if nodeType='G' then begin addNodeG; result := nodeG; exit; end;
        if nodeType='R' then begin addNodeR; result := nodeR; exit; end;
        if nodeType='S' then begin addNodeS; result := nodeS; exit; end;
        if nodeType='F' then begin addNodeF; result := nodeF; exit; end;
        if nodeType='P' then begin addNodeP; result := nodeP; exit; end;
        if nodeType='C' then begin addNodeC; result := nodeC; exit; end;
        if nodeType='B' then begin addNodeB; result := nodeB; exit; end;
    end;
    function getNodeImage(nodeType : string) : integer;
    begin
        if nodeType='L' then begin result := 15; exit; end;
        if nodeType='G' then begin result := 16; exit; end;
        if nodeType='R' then begin result := 18; exit; end;
        if nodeType='S' then begin result := 17; exit; end;
        if nodeType='F' then begin result := 25; exit; end;
        if nodeType='P' then begin result := 20; exit; end;
        if nodeType='C' then begin result := 23; exit; end;
        if nodeType='TT' then begin result := 24;  end;
        if nodeType='B' then begin result := 26;  end;
    end;
Begin
  PanelRecentlyUsed.Visible := elementEnabled('"Ostatnio u¿ywane"','2016.09.12', true);

  panelName := TreeMode.Items[TreeMode.ItemIndex];
  startDate := now;
  //tree is refreshed and panel was not changed
  if (TreeRecentlyused.Items.Count > 1) and (getSystemParam('Tree:LastRefreshPanel','') = panelName) then
    //do not refresh more frequently than 120 seconds
    if getSystemParam('Tree:DelayedRefFlag:'+panelName,'N') = 'Y' then begin
        lastRefreshTimeDsp := getSystemParam('Tree:LastRefreshTime:'+panelName,'');
        lastRefreshTime := strToDateTime (lastRefreshTimeDsp);
        durationInSeconds := (startDate - lastRefreshTime )*60*60*24;
        if (durationInSeconds<120) then exit;
    end;

  TreeRecentlyused.Items.BeginUpdate;
  Try
    TreeRecentlyused.Items.Clear;

    aFilter := replacePolishChars(AnsiUppercase(aFilter));
    nodeL := nil;
    nodeG := nil;
    nodeR := nil;
    nodeS := nil;
    nodeF := nil;
    nodeP := nil;
    nodeC := nil;
    nodeB := nil;

    if TreeMode.ItemIndex = 0 then begin
        sqlString := recentlyUsedQuery.Lines.Text;
        dmodule.openSQL(fastQuery, sqlString ,
         'LIMIT='+ getSystemParam('FastQueryMaxRecords','100')+
         ';PLA_ID='+ getUserOrRoleID
         );
    end;
    if TreeMode.ItemIndex = 1 then begin
        sqlString := mostlyUsedQuery.Lines.Text;
        dmodule.openSQL(fastQuery, sqlString ,
         'LIMIT='+ getSystemParam('FastQueryMaxRecords','100')+
         ';PLA_ID='+ getUserOrRoleID
         );
    end;
    if TreeMode.ItemIndex = 2 then begin
        sqlString := topCntQuery.Lines.Text;
        sqlString := stringreplace(sqlString, '%PERMISSIONS_L', getWhereClause('LECTURERS','LEC_CLA','LEC_ID'), []);
        sqlString := stringreplace(sqlString, '%PERMISSIONS_G', getWhereClause('GROUPS','GRO_CLA','GRO_ID'), []);
        sqlString := stringreplace(sqlString, '%PERMISSIONS_R', getWhereClause('ROOMS','ROM_CLA','ROM_ID'), []);
        sqlString := stringreplace(sqlString, '%PERMISSIONS_S', getWhereClause('SUBJECTS','CLASSES','SUB_ID'), []);
        sqlString := stringreplace(sqlString, '%PERMISSIONS_F', getWhereClause('FORMS','CLASSES','FOR_ID'), []);
        sqlString := stringreplace(sqlString, '%LIMIT', getSystemParam('FastQueryMaxRecords','100'), [rfReplaceAll]);
        dmodule.openSQL(fastQuery, sqlString );
    end;
    if TreeMode.ItemIndex = 3 then begin
        if conPeriod.Text = '' then exit;
        sqlString := topCntPeriodQuery.Lines.Text;
        sqlString := stringreplace(sqlString, '%PERMISSIONS_L', getWhereClause('LECTURERS','LEC_CLA','LEC_ID'), []);
        sqlString := stringreplace(sqlString, '%PERMISSIONS_G', getWhereClause('GROUPS','GRO_CLA','GRO_ID'), []);
        sqlString := stringreplace(sqlString, '%PERMISSIONS_R', getWhereClause('ROOMS','ROM_CLA','ROM_ID'), []);
        sqlString := stringreplace(sqlString, '%PERMISSIONS_S', getWhereClause('SUBJECTS','CLASSES','SUB_ID'), []);
        sqlString := stringreplace(sqlString, '%PERMISSIONS_F', getWhereClause('FORMS','CLASSES','FOR_ID'), []);
        sqlString := stringreplace(sqlString, '%LIMIT', getSystemParam('FastQueryMaxRecords','100'), [rfReplaceAll]);
        sqlString := stringreplace(sqlString, '%PERIOD_CLAUSE',  getWhereClausefromPeriod('ID='+conPeriod.text,'')   , [rfReplaceAll]);
        dmodule.openSQL(fastQuery, sqlString );
        //copytoclipboard(  sqlString); info ('debug');
    end;

    with fastQuery do begin
        first;
        while not fastQuery.Eof do begin
            node:= TreeRecentlyused.Items.AddChild(
                getNode( fastQuery.FieldByName('type').AsString  )
              , fastQuery.FieldByName('Name').AsString
            );
            node.ImageIndex := getNodeImage( fastQuery.FieldByName('type').AsString );
            nodeInfo := TNodeInfo.Create;
            nodeInfo.Id := fastQuery.FieldByName('Id').AsString;
            node.Data := nodeInfo;
            next;
        end;
    end;

    TreeRecentlyused.FullExpand;
  Finally
    TreeRecentlyused.Items.EndUpdate;
    if TreeRecentlyused.Items.Count > 0 then
        TreeRecentlyused.Selected := TreeRecentlyused.Items[0];
  End; { Finally }

  endDate := now;
  durationInSeconds:= (endDate - startDate )*60*60*24;
  //Str(durationInSeconds:1:2,durationDsp);
  //info ( durationDsp );

  if durationInSeconds>2 then begin
      info ('Ostatnie odœwie¿enie danych "'+panelName+'" trwa³o d³u¿ej ni¿ 2 sekundy.'+cr+' W celu zwiêkszenia komfortu pracy odœwie¿anie panelu bêdzie wykonywane nie czêsciej ni¿ co dwie minuty', showMonthly);
      SetSystemParam('Tree:DelayedRefFlag:'+panelName,'Y');
      SetSystemParam('Tree:LastRefreshTime:'+panelName,DateTimeToStr(endDate));
      SetSystemParam('Tree:LastRefreshPanel',panelName);
  end else SetSystemParam('Tree:DelayedRefFlag:'+panelName,'N');
End;

//----------------------------------------------------------------
procedure TFMain.UpsertRecentlyUsed(presId : String; presType : String);
begin
  if presId = '' then exit;
	dmodule.sql(
		  'begin '+
		  '	Upsert_Recently_Used (:pla_id,:res_id,:res_type);'+
		  'end;'
		, 'pla_id='+fmain.getUserOrRoleId+';res_id='+presId+';res_type='+presType
	);
end;

procedure TFMain.TreeModeChange(Sender: TObject);
begin
 refreshRecentlyUsed('');
 TreeModeCleanup.Visible := TreeMode.ItemIndex<=1;
end;

procedure TFMain.SearchMenuClick(Sender: TObject);
begin
 if SearchMenu.Text = 'Szukaj...' then  SearchMenu.Text := '';
end;

procedure TFMain.SearchMenuExit(Sender: TObject);
begin
 if SearchMenu.Text = '' then  SearchMenu.Text := 'Szukaj...';
end;

procedure TFMain.TreeModeCleanupClick(Sender: TObject);
begin
  if question('Czy skasowaæ historiê ostatnio u¿ywanych/najczêœciej u¿ywanych?')<>id_yes then exit;
	dmodule.sql(
		  'begin '+
		  '	delete from Recently_Used where pla_id = :pla_id;'+
		  'end;'
		, 'pla_id='+fmain.getUserOrRoleId
	);
  refreshRecentlyUsed('');
end;

procedure TFMain.BShowCellLayoutClick(Sender: TObject);
begin
  if (FCellLayout.displayFlag) and (FCellLayout.AlphaBlendValue=255) then FCellLayout.hideCellLayout(true) else FCellLayout.displayCellLayout(true);
end;

procedure TFMain.BShowCellLayoutMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  exit; //disabled on user request on 2017.10.28
  if MouseOverLeftPanel then begin
     MouseOverLeftPanel := false;
     FCellLayout.displayCellLayout(false);
  end;
  //FCellLayout.showMe;
end;

procedure TFMain.BAddClassDblClick(Sender: TObject);
begin
  AddClassToGrid(gFirstResourceFlag);
end;

procedure TFMain.OpenFGrouping(resourceType : String; resourceId : String);
begin
  FMain.set_tmp_selected_dates;
  With FGrouping Do begin
    ignoreIni:=true;
    //clear
    CONL.Text := '';
    CONG.Text := '';
    conResCat0.Text := '';
    CONS.Text := '';
    CONF.Text := '';
    CONPERIOD.Text := '';
    //
    CONPERIOD.Text := conPeriod.Text;
    if resourceType = 'L' then CONL.Text := resourceId;
    if resourceType = 'G' then CONG.Text := resourceId;
    if resourceType = 'R' then CONResCat0.Text := resourceId;
    if resourceType = 'S' then CONS.Text := resourceId;
    if resourceType = 'F' then CONF.Text := resourceId;
    if resourceType = 'P' then CONPERIOD.Text := resourceId;
    ShowModal;
    ignoreIni:=false;
  End;
end;

procedure TFMain.ppAddOClick(Sender: TObject);
begin
  if not elementEnabled('"Kilku w³aœcicieli zajêcia"','2017.10.01', false) then exit;
  attachOwner;
end;

procedure TFMain.Przywr1Click(Sender: TObject);
begin
  if not elementEnabled('"Kilku w³aœcicieli zajêcia"','2017.10.01', false) then exit;
  deleteOwnerFromSelection(true);
end;

procedure TFMain.Odczwybranego1Click(Sender: TObject);
begin
  if not elementEnabled('"Kilku w³aœcicieli zajêcia"','2017.10.01', false) then exit;
  deleteOwnerFromSelection(false);
end;

procedure TFMain.Przywrckomunikaty1Click(Sender: TObject);
begin
  SetSystemParam('MESSAGE.SkipCapacityOverflow','-');
  Info('Otrze¿enie o przekroczonej zajêtoœci sal zosta³y przywrócone');
end;

procedure TFMain.recreateDependenciesClick(Sender: TObject);
begin
  recreateDependencies.Checked := not recreateDependencies.Checked;
end;

procedure TFMain.PreviewClick(Sender: TObject);
var ColoringIndex : shortString;
    presId : String; presType : String;
begin
   FLegend.SaveTimeTableNotes;
   dmodule.CommitTrans;
   Fsettings.FormShow(nil);
   Fsettings.BHtmlClick(nil);

   {
   FWWWGenerator := TFWWWGenerator.Create(Application);

   case FMain.TabViewType.TabIndex of
    0: begin presId:=ExtractWord(1,FMain.conlecturer.Text,[';']); presType:='LEC'; end;
    1: begin presId:=ExtractWord(1,FMain.congroup.Text,[';']); presType:='GRO'; end;
    2: begin presId:=ExtractWord(1,FMain.conResCat0.Text,[';']); presType:='ROM'; end;
   end;
   ColoringIndex := getCode(FcellLayout.Coloring);
   fwwwgenerator.CalendarToHTML(conPeriod.Text, presId, presType, getCode(FcellLayout.D1), getCode(FcellLayout.D2), getCode(FcellLayout.D3), getCode(FcellLayout.D4), getCode(FcellLayout.D5),             nil, nil,                  false,      0,          0                         ,ColoringIndex, IntToStr(Grid.DefaultColWidth), IntToStr(Grid.DefaultRowHeight), '10',                  '10', '10', '10', '10', '10',              FALSE, FALSE,FALSE,FALSE,FALSE, uutilityParent.ApplicationDocumentsPath + 'temp.htm', false, false, '-------',0,false,false,true,true,true,false,false,false,false,false);
 //              CalendarToHTML(D1, D2, D3, D4, D5 : ShortString                                           ; Header, Footer : TStrings; ShowLegend, legendMode, addCreationDate : Boolean; Coloring : ShortString;    CellWIDTH,                      CELLHEIGHT,                      CELLSIZE : ShortString; S1,   S2,   S3,   S4,   S5 : ShortString; B1, B2, B3, B4, B5 : Boolean;   FileName : ShortString);

   UUTilityParent.ExecuteFile(uutilityParent.ApplicationDocumentsPath +'temp.htm','','',SW_SHOWMAXIMIZED);
   FWWWGenerator.Free;
   }
end;


initialization
  Randomize;
  PrevCol := 0;
  PrevRow := 0;
end.

