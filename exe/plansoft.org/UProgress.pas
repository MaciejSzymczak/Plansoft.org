unit UProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TFProgress = class(TForm)
    ProgressBar: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProgress: TFProgress;

implementation

{$R *.dfm}

end.
