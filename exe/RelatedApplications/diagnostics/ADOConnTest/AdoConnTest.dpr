program AdoConnTest;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
