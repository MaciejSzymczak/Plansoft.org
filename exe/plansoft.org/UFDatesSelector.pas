unit UFDatesSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TFDatesSelector = class(TFormConfig)
    source_date_from: TDateTimePicker;
    source_date_to: TDateTimePicker;
    Panel1: TPanel;
    Anuluj: TBitBtn;
    BExecute: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure source_date_fromChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDatesSelector: TFDatesSelector;

implementation

{$R *.dfm}

procedure TFDatesSelector.FormCreate(Sender: TObject);
begin
  source_date_from.DateTime := now();
  source_date_to.DateTime := now();
end;

procedure TFDatesSelector.source_date_fromChange(Sender: TObject);
begin
  //source_date_to.DateTime := source_date_from.DateTime;
end;

end.
