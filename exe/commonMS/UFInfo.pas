unit UFInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFInfoParent, StdCtrls, Buttons, ExtCtrls;

type
  TFInfo = class(TFInfoParent)
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FInfo: TFInfo;

implementation

{$R *.DFM}

end.
