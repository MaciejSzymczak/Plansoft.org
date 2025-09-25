unit UFDataDiagram;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, jpeg, dm;

type
  TFDataDiagram = class(TFormConfig)
    Image1: TImage;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDataDiagram: TFDataDiagram;

implementation

uses UFMain, autocreate, UFPlannerPermissions, uutilityParent;

{$R *.dfm}

procedure TFDataDiagram.BitBtn1Click(Sender: TObject);
begin
  ORG_UNITSShowModalAsBrowser;
end;

procedure TFDataDiagram.BitBtn2Click(Sender: TObject);
begin
  //FORM_FORMULASShowModalAsBrowser;
end;

procedure TFDataDiagram.BitBtn6Click(Sender: TObject);
begin
  LECTURERSShowModalAsBrowser('');
end;

procedure TFDataDiagram.BitBtn7Click(Sender: TObject);
begin
  GROUPSShowModalAsBrowser('');
end;

procedure TFDataDiagram.BitBtn5Click(Sender: TObject);
begin
  SUBJECTSShowModalAsBrowser('');
end;

procedure TFDataDiagram.BitBtn3Click(Sender: TObject);
begin
  FORMSShowModalAsBrowser('');
end;

procedure TFDataDiagram.BitBtn14Click(Sender: TObject);
begin
  PERIODSShowModalAsBrowser;
end;

procedure TFDataDiagram.BitBtn10Click(Sender: TObject);
begin
  UFPlannerPermissions.ShowModal;
end;

procedure TFDataDiagram.BitBtn11Click(Sender: TObject);
begin
  UFPlannerPermissions.ShowModal;
end;

procedure TFDataDiagram.BitBtn12Click(Sender: TObject);
begin
  UFPlannerPermissions.ShowModal;
end;

procedure TFDataDiagram.BitBtn13Click(Sender: TObject);
begin
  UFPlannerPermissions.ShowModal;
end;

procedure TFDataDiagram.BitBtn9Click(Sender: TObject);
begin
  PLANNERSShowModalAsBrowser;
end;

procedure TFDataDiagram.BitBtn15Click(Sender: TObject);
begin
  RESOURCE_CATEGORIESShowModalAsBrowser;
end;

procedure TFDataDiagram.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fmain.buildMenu;
  FMain.BuildCalendar('NA');
end;

procedure TFDataDiagram.BitBtn4Click(Sender: TObject);
begin
  AutoCreate.CLASSESShowModalAsBrowser('','','', '','','','',false, true);
end;

procedure TFDataDiagram.BitBtn8Click(Sender: TObject);
begin
  ROOMSShowModalAsBrowser( '','' );
end;

procedure TFDataDiagram.BitBtn17Click(Sender: TObject);
begin
  Close;
end;

end.
