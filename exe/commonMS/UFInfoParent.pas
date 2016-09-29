unit UFInfoParent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFInfoParent = class(TFormConfig)
    Image1: TImage;
    BOK: TBitBtn;
    Memo1: TMemo;
    MLICENCJA: TMemo;
    LTekst: TLabel;
    LProgram: TLabel;
    LAutorzy: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FInfoParent: TFInfoParent;

implementation

{$R *.DFM}

end.
