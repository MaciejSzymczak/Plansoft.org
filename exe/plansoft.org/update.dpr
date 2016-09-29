program update;

uses
  Forms,
  UFormConfig in '..\CommonMS\UFormConfig.pas' {FormConfig},
  UFUpdateWindow in 'UFUpdateWindow.pas' {FUpdateWindow},
  UUtilityParent in '..\commonMS\UUtilityParent.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFUpdateWindow, FUpdateWindow);
  Application.CreateForm(TFormConfig, FormConfig);
  Application.Run;
end.
