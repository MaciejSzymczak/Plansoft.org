unit UFFlexNewAttribute;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, Menus;

const maxpopupitems = 12;

type
  TFFlexNewAttribute = class(TFormConfig)
    Label1: TLabel;
    Label2: TLabel;
    EfieldType: TComboBox;
    EfieldCaption: TEdit;
    Panel1: TPanel;
    BCancel: TBitBtn;
    BOk: TBitBtn;
    ERequired: TCheckBox;
    PopupMenu: TPopupMenu;
    dummy1: TMenuItem;
    ShowMore: TCheckBox;
    advanced: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    LDefaultValueD: TLabel;
    LDefaultValueS: TLabel;
    LDefaultValueN: TLabel;
    LDefaultValueD2: TLabel;
    LDefaultValueN2: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ECustomName: TEdit;
    EfieldWidth: TEdit;
    EDefaultValue: TEdit;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Help: TSpeedButton;
    sql_check_message: TEdit;
    sql_check_procedure: TEdit;
    Label9: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EfieldTypeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure dummy1Click(Sender: TObject);
    procedure ShowMoreClick(Sender: TObject);
  private
    popupItems : array[1..maxpopupitems] of record
                     itemtype: shortString;
                     caption : shortString;
                     sql     : shortString;
                     tag     : integer;
                 end;
  public
    function getSqlDefaultValue : string;
  end;

var
  FFlexNewAttribute: TFFlexNewAttribute;

implementation

{$R *.dfm}

uses uutilityParent, DM;


function TFFlexNewAttribute.getSqlDefaultValue : string;
begin
     result := '';
     if EDefaultValue.text = '' then exit;
     case eFieldType.itemIndex of
      0: begin
           result := 'select '''+EDefaultValue.text+''' from dual';
         end;
      1: begin
           result := 'select '+searchAndReplace(EDefaultValue.text,',','.')+' from dual';
         end;
      2: begin
           if instr(upperCase(EDefaultValue.text),'DZISIAJ') = 0
             then result := 'select to_date('''+ EDefaultValue.Text + ''',''yyyy.mm.dd'') from dual'
             else result := 'select '+searchAndReplace(upperCase(EDefaultValue.text),'DZISIAJ','sysdate')+' from dual';
         end;
     end;
end;


procedure TFFlexNewAttribute.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
    //-------------------------------
    function validDefaultValue (fieldsqlDefaultValue : string): boolean;
    var dummy : string;
        dummyS : string;
        dummyN : integer;
        dummyD : tdatetime;
    begin
    result :=true;
    try
    if fieldsqlDefaultValue <> '' then begin
      dummy  := dmodule.SingleValue(fieldsqlDefaultValue);
      case FFlexNewAttribute.eFieldType.itemIndex of
        0: dummyS := dmodule.QWork.Fields[0].AsString;
        1: dummyN := dmodule.QWork.Fields[0].AsInteger;
        2: dummyD := dmodule.QWork.Fields[0].AsDateTime;
      end;
    end;
    except
     on E:exception do Begin
       info ('Wprowadzona wartoœæ domyœlna dla pola jest b³êdna. Spróbuj ponownie. Je¿eli nie wiesz co wpisaæ, zostaw pole puste, wartoœæ bêdzie mo¿na póŸniej uzupe³niæ' + cr +cr+cr + e.Message);
       result :=false;
     end;
    end;
    end;
    //-------------------------------
begin
  if modalResult = mrOK then begin
    if EfieldCaption.Text = '' then begin
      info ('WprowadŸ etykietê pola');
      canClose := false;
    end;
    if not validDefaultValue(getSqlDefaultValue) then canClose := false;
  end;
end;

procedure TFFlexNewAttribute.EfieldTypeChange(Sender: TObject);
begin
  inherited;
  sql_check_procedure.Text := '';
  sql_check_message.text := '';
  
  Label3.Visible       := EfieldType.ItemIndex <> 2;
  EfieldWidth.Visible  := EfieldType.ItemIndex <> 2;
  if EfieldType.ItemIndex = 2 then begin
    EfieldWidth.Text := '100';
  end;

  LDefaultValueS.Visible := false;
  LDefaultValueN.Visible := false;
  LDefaultValueD.Visible := false;
  LDefaultValueN2.Visible := false;
  LDefaultValueD2.Visible := false;
  case EfieldType.ItemIndex of
    0:LDefaultValueS.Visible := true;
    1:begin LDefaultValueN.Visible := true; LDefaultValueN2.Visible := true; end;
    2:begin LDefaultValueD.Visible := true; LDefaultValueD2.Visible := true; end;
  end;

end;

procedure TFFlexNewAttribute.FormShow(Sender: TObject);
begin
  EfieldTypeChange(nil);
  activeControl := EfieldCaption;
  ShowMoreClick(nil);
end;

procedure TFFlexNewAttribute.FormCreate(Sender: TObject);
begin
  inherited;
  popupItems[1].itemtype := 'S';
  popupItems[1].caption  := 'Wpisz maks. 100 znaków';
  popupItems[1].sql      := 'select case when Length(nvl(:current,''.'')) <= 100 then null else ''ERROR'' end from dual';
  popupItems[1].tag      := 1;

  popupItems[2].itemtype := 'S';
  popupItems[2].caption  := 'Wpisz od 1 do 100 znaków';
  popupItems[2].sql      := 'select case when Length(nvl(:current,''.'')) between 1 and 100 then null else ''ERROR'' end from dual';
  popupItems[2].tag      := 2;

  popupItems[3].itemtype := 'S';
  popupItems[3].caption  := 'Pole mo¿e zawieraæ tylko wielkie litery';
  popupItems[3].sql      := 'select case when upper(nvl(:current,''.''))=nvl(:current,''.'') then null else ''ERROR'' end from dual';
  popupItems[3].tag      := 3;

  popupItems[4].itemtype := 'S';
  popupItems[4].caption  := 'Pole mo¿e zawieraæ tylko ma³e litery';
  popupItems[4].sql      := 'select case when lower(nvl(:current,''.''))=nvl(:current,''.'') then null else ''ERROR'' end from dual';
  popupItems[4].tag      := 4;

  popupItems[5].itemtype := 'N';
  popupItems[5].caption  := 'Liczba musi zawieraæ siê w zakresie od 1 do 4';
  popupItems[5].sql      := 'select case when nvl(:current,-1) between 1 and 4 then null else ''ERROR'' end from dual';
  popupItems[5].tag      := 5;

  popupItems[6].itemtype := 'N';
  popupItems[6].caption  := 'Liczba musi byæ podzielna przez 4';
  popupItems[6].sql      := 'select case when mod(:current,4) = 0  then null else ''ERROR'' end from dual';
  popupItems[6].tag      := 6;

  popupItems[7].itemtype := 'D';
  popupItems[7].caption  := 'Data musi nale¿eæ do roku 2010';
  popupItems[7].sql      := 'select case when :current between date''2010-01-01'' and date''2010-12-31'' then null else ''ERROR'' end from dual';
  popupItems[7].tag      := 7;

  popupItems[8].itemtype := 'D';
  popupItems[8].caption  := 'Data musi byæ pierwszym dniem tygodnia';
  popupItems[8].sql      := 'select case when :current = TRUNC(date'':current'',''d'') then null else ''ERROR'' end from dual';
  popupItems[8].tag      := 8;

  popupItems[9].itemtype := 'D';
  popupItems[9].caption  := 'Data musi byæ pierwszym dniem miesi¹ca';
  popupItems[9].sql      := 'select case when :current = TRUNC(date'':current'',''mm'') then null else ''ERROR'' end from dual';
  popupItems[9].tag      := 9;

  popupItems[10].itemtype := 'D';
  popupItems[10].caption  := 'Data musi byæ pierwszym dniem kwarta³u';
  popupItems[10].sql      := 'select case when :current = TRUNC(date'':current'',''q'') then null else ''ERROR'' end from dual';
  popupItems[10].tag      := 10;

  popupItems[11].itemtype := 'D';
  popupItems[11].caption  := 'Data musi byæ pierwszym dniem roku';
  popupItems[11].sql      := 'select case when :current = TRUNC(date'':current'',''yyyy'') then null else ''ERROR'' end from dual';
  popupItems[11].tag      := 11;

  popupItems[12].itemtype := 'D';
  popupItems[12].caption  := 'Data nie mo¿e byæ wczeœniejsza od daty dzisiejszej';
  popupItems[12].sql      := 'select case when trunc(:current) < trunc(sysdate) then null else ''ERROR'' end from dual';
  popupItems[12].tag      := 11;
end;

procedure TFFlexNewAttribute.HelpClick(Sender: TObject);
var point : tpoint;
    btn   : tspeedbutton;
    t     : integer;
    itemtype : shortString;
    menuitem : tmenuitem;
begin
 case EfieldType.ItemIndex of
  0:itemtype := 'S';
  1:itemtype := 'N';
  2:itemtype := 'D';
 end;
 PopupMenu.Items.Clear;
 for t := 1 to maxpopupitems do begin
   if popupItems[t].itemtype = itemtype then
   begin
     menuitem := tmenuItem.Create(self);
     menuitem.Caption := popupItems[t].caption;
     menuitem.tag := popupItems[t].tag;
     menuitem.OnClick := dummy1Click;
     PopupMenu.Items.Add(menuitem);
   end;
 end;

 btn := sender as tspeedbutton;
 Point.x:= 0;
 Point.y:= btn.Height;
 Point:=btn.ClientToScreen(Point);
 PopupMenu.Popup(Point.X,Point.Y);
end;

procedure TFFlexNewAttribute.dummy1Click(Sender: TObject);
begin
  sql_check_procedure.text := popupItems[ (sender as TComponent).tag ].sql;
  sql_check_message.text := popupItems[ (sender as TComponent).tag ].caption;
end;

procedure TFFlexNewAttribute.ShowMoreClick(Sender: TObject);
begin
  inherited;
 if not showmore.Checked then begin
   self.height := 180;
   advanced.Visible := false;
 end
 else begin
   self.height := 450;
   advanced.Visible := true;
 end
end;

end.
