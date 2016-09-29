program MemoryStatus;

uses
  Forms,
  UFMemoryStatus in 'UFMemoryStatus.pas' {FMemoryStatus};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFMemoryStatus, FMemoryStatus);
  Application.Run;
end.
