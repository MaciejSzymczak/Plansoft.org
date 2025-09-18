unit UFExclusiveParent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, jpeg;

type
  TFExclusiveParent = class(TFormConfig)
    exclusive_parent: TBitBtn;
    non_exclusive_parent: TBitBtn;
    Memo3: TMemo;
    Image1: TImage;
    Image2: TImage;
    Memo1: TMemo;
    Memo2: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FExclusiveParent: TFExclusiveParent;

implementation

{$R *.dfm}

end.
