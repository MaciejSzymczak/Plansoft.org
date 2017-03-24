unit UFConfiguration;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, ExtCtrls, StdCtrls, Spin, Buttons, UUtilityParent, AppEvent,
  ComCtrls, Mask, ToolEdit;

type
  TFConfiguration = class(TForm)
    GroupBox1: TGroupBox;
    Pages: TPageControl;
    Mode1: TTabSheet;
    Mode2: TTabSheet;
    Group: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    G2330: TCheckBox;
    G2300: TCheckBox;
    G2230: TCheckBox;
    G2200: TCheckBox;
    G2130: TCheckBox;
    G2100: TCheckBox;
    G2030: TCheckBox;
    G2000: TCheckBox;
    G1900: TCheckBox;
    G1830: TCheckBox;
    G1800: TCheckBox;
    G1730: TCheckBox;
    G1630: TCheckBox;
    G1500: TCheckBox;
    G1530: TCheckBox;
    G1600: TCheckBox;
    G1700: TCheckBox;
    G1430: TCheckBox;
    G1400: TCheckBox;
    G1330: TCheckBox;
    G1300: TCheckBox;
    G1230: TCheckBox;
    G1200: TCheckBox;
    G1100: TCheckBox;
    G1130: TCheckBox;
    G1030: TCheckBox;
    G1000: TCheckBox;
    G0930: TCheckBox;
    G0900: TCheckBox;
    G0800: TCheckBox;
    G0830: TCheckBox;
    G0730: TCheckBox;
    G0700: TCheckBox;
    G0600: TCheckBox;
    G0630: TCheckBox;
    G0300: TCheckBox;
    G0330: TCheckBox;
    G0400: TCheckBox;
    G0430: TCheckBox;
    G0500: TCheckBox;
    G0530: TCheckBox;
    G0230: TCheckBox;
    G0200: TCheckBox;
    G0130: TCheckBox;
    G0100: TCheckBox;
    G0000: TCheckBox;
    G0030: TCheckBox;
    G1930: TCheckBox;
    Interval: TRadioGroup;
    FProgram: TFilenameEdit;
    Panel1: TPanel;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    procedure BApplyClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    { Public declarations }
  end;

var
  FConfiguration: TFConfiguration;

implementation

uses UFMain;

{$R *.DFM}

procedure TFConfiguration.BApplyClick(Sender: TObject);
begin
  inherited;
  Close;
end;


procedure TFConfiguration.BitBtn1Click(Sender: TObject);
begin
  inherited;
    G2330.Checked := True;
    G2300.Checked := True;
    G2230.Checked := True;
    G2200.Checked := True;
    G2130.Checked := True;
    G2100.Checked := True;
    G2030.Checked := True;
    G2000.Checked := True;
    G1900.Checked := True;
    G1830.Checked := True;
    G1800.Checked := True;
    G1730.Checked := True;
    G1630.Checked := True;
    G1500.Checked := True;
    G1530.Checked := True;
    G1600.Checked := True;
    G1700.Checked := True;
    G1430.Checked := True;
    G1400.Checked := True;
    G1330.Checked := True;
    G1300.Checked := True;
    G1230.Checked := True;
    G1200.Checked := True;
    G1100.Checked := True;
    G1130.Checked := True;
    G1030.Checked := True;
    G1000.Checked := True;
    G0930.Checked := True;
    G0900.Checked := True;
    G0800.Checked := True;
    G0830.Checked := True;
    G0730.Checked := True;
    G0700.Checked := True;
    G0600.Checked := True;
    G0630.Checked := True;
    G0300.Checked := True;
    G0330.Checked := True;
    G0400.Checked := True;
    G0430.Checked := True;
    G0500.Checked := True;
    G0530.Checked := True;
    G0230.Checked := True;
    G0200.Checked := True;
    G0130.Checked := True;
    G0100.Checked := True;
    G0000.Checked := True;
    G0030.Checked := True;
    G1930.Checked := True;
end;

procedure TFConfiguration.BitBtn2Click(Sender: TObject);
begin
  inherited;
    G2330.Checked := False;
    G2300.Checked := False;
    G2230.Checked := False;
    G2200.Checked := False;
    G2130.Checked := False;
    G2100.Checked := False;
    G2030.Checked := False;
    G2000.Checked := False;
    G1900.Checked := False;
    G1830.Checked := False;
    G1800.Checked := False;
    G1730.Checked := False;
    G1630.Checked := False;
    G1500.Checked := False;
    G1530.Checked := False;
    G1600.Checked := False;
    G1700.Checked := False;
    G1430.Checked := False;
    G1400.Checked := False;
    G1330.Checked := False;
    G1300.Checked := False;
    G1230.Checked := False;
    G1200.Checked := False;
    G1100.Checked := False;
    G1130.Checked := False;
    G1030.Checked := False;
    G1000.Checked := False;
    G0930.Checked := False;
    G0900.Checked := False;
    G0800.Checked := False;
    G0830.Checked := False;
    G0730.Checked := False;
    G0700.Checked := False;
    G0600.Checked := False;
    G0630.Checked := False;
    G0300.Checked := False;
    G0330.Checked := False;
    G0400.Checked := False;
    G0430.Checked := False;
    G0500.Checked := False;
    G0530.Checked := False;
    G0230.Checked := False;
    G0200.Checked := False;
    G0130.Checked := False;
    G0100.Checked := False;
    G0000.Checked := False;
    G0030.Checked := False;
    G1930.Checked := False;
end;

procedure TFConfiguration.FormShow(Sender: TObject);
begin
  inherited;
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFConfiguration.FormHide(Sender: TObject);
begin
  inherited;
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFConfiguration.BitBtn3Click(Sender: TObject);
begin
 Close;
end;

procedure TFConfiguration.BitBtn4Click(Sender: TObject);
begin
UutilityParent.executeFileAndWait( FConfiguration.FProgram.text );
end;

procedure TFConfiguration.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 With Fconfiguration  do begin
   UUtilityParent.saveToIni(ApplicationDocumentsPath+'Settings.ini','Main',[Pages, FProgram, Interval, G0000,G0030,G0100,G0130,G0200,G0230,G0300,G0330,G0400,G0430,G0500,G0530,G0600,G0630,G0700,G0730,G0800,G0830,G0900,G0930,G1000,G1030,G1100,G1130,G1200,G1230,G1300,G1330,G1400,G1430,G1500,G1530,G1600,G1630,G1700,G1730,G1800,G1830,G1900,G1930,G2000,G2030,G2100,G2130,G2200,G2230,G2300,G2330]);
 end;

end;

end.

