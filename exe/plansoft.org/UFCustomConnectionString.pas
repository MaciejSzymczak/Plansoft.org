unit UFCustomConnectionString;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, UUtilityParent;

type
  TFCustomConnectionString = class(TFormConfig)
    BLogin: TBitBtn;
    Panel1: TPanel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    connectionString: TEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCustomConnectionString: TFCustomConnectionString;

implementation

{$R *.dfm}

procedure TFCustomConnectionString.BitBtn2Click(Sender: TObject);
begin
 connectionString.Visible := not connectionString.Visible;
end;

procedure TFCustomConnectionString.FormCreate(Sender: TObject);
begin
  inherited;
  self.Caption := 'Plansoft.org                (wersja '+UutilityParent.VersionOfApplication+')';
end;

end.
