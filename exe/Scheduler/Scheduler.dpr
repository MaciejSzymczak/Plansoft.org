program Scheduler;

uses
  Forms,
  UFormConfig in '..\CommonMS\UFormConfig.pas' {FormConfig},
  UUtilityParent in '..\CommonMS\UUtilityParent.pas',
  UFMain in 'UFMain.pas' {FMain},
  UFConfiguration in 'UFConfiguration.pas' {FConfiguration},
  UFInfoParent in '..\CommonMS\UFInfoParent.pas' {FInfoParent},
  UFInfo in 'UFInfo.pas' {FInfo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFConfiguration, FConfiguration);
  Application.CreateForm(TFInfo, FInfo);
  Application.Run;
end.
