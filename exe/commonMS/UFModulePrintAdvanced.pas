unit UFModulePrintAdvanced;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Grids,Dialogs, ExtDlgs, StrHlder;

type
  TFModulePrintAdvanced = class(TForm)
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FModulePrintAdvanced: TFModulePrintAdvanced;
  OK_LP : Boolean=True;
  OK_OPZ : Boolean=False;
  OK_ICO : Boolean=TRUE;
  OK_DATA_ADRES : Boolean=True;
  OK_G_KRESKA : Boolean=True;
  OK_D_KRESKA : Boolean=True;
  ICO_SCIEZKA : string='ki.bmp';
  CENT_N : integer=1;
  CENT_S : integer=1;
implementation

{$R *.DFM}
uses UFModulePrint;
procedure TFModulePrintAdvanced.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
    OK_LP:=True
 else
   OK_LP:=False;

end;
procedure TFModulePrintAdvanced.FormCreate(Sender: TObject);
begin
 if OK_LP then
  CheckBox1.Checked:=True
 else
  CheckBox1.Checked:=False;
 if OK_OPZ then
  CheckBox2.Checked:=True
 else
  CheckBox2.Checked:=False;
 if OK_ICO then
  begin
   CheckBox3.Checked:=True;
   try
    Image1.Picture.LoadFromFile(ICO_SCIEZKA);
   except
    CheckBox3.Checked:=False;
   end;
  end
 else
  CheckBox3.Checked:=False;
 RadioGroup1.ItemIndex:=CENT_S;
 RadioGroup2.ItemIndex:=CENT_N;
 if OK_DATA_ADRES then
  CheckBox6.Checked:=True
 else
  CheckBox6.Checked:=False;
 if OK_G_KRESKA then
  CheckBox4.Checked:=True
 else
  CheckBox4.Checked:=False;
 if OK_D_KRESKa then
  CheckBox5.Checked:=True
 else
  CheckBox5.Checked:=False;
end;

procedure TFModulePrintAdvanced.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
    OK_OPZ:=True
 else
   OK_OPZ:=False;
end;

procedure TFModulePrintAdvanced.Button1Click(Sender: TObject);
begin
 if OpenPictureDialog1.Execute then
  begin
    ICO_SCIEZKA:=OpenPictureDialog1.FileName;
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
end;

procedure TFModulePrintAdvanced.CheckBox3Click(Sender: TObject);
begin
 if CheckBox3.Checked then
  begin
   OK_ICO:=True;
   Button1.Enabled:=True;
  end
 else
  begin
   Button1.Enabled:=False;
   OK_ICO:=False;
  end;
end;

procedure TFModulePrintAdvanced.RadioGroup2Click(Sender: TObject);
begin
 CENT_N:=RadioGroup2.ItemIndex;
end;

procedure TFModulePrintAdvanced.RadioGroup1Click(Sender: TObject);
begin
 CENT_S:=RadioGroup1.ItemIndex;
end;

procedure TFModulePrintAdvanced.CheckBox4Click(Sender: TObject);
begin
 OK_G_KRESKA:=CheckBox4.Checked;
end;

procedure TFModulePrintAdvanced.CheckBox5Click(Sender: TObject);
begin
 OK_D_KRESKA:=CheckBox5.Checked;
end;

procedure TFModulePrintAdvanced.CheckBox6Click(Sender: TObject);
begin
 OK_DATA_ADRES:=CheckBox6.Checked;
end;

end.
