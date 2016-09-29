unit EditRem;

interface

uses Classes, Controls, Forms, StdCtrls;

type
  TReminderForm = class(TForm)
    MethodCB: TComboBox;
    PeriodCB: TComboBox;
    OKBtn: TButton;
  end;

var
  ReminderForm: TReminderForm;

implementation

{$R *.dfm}

end.
