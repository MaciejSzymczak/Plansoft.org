program GContDemo;

uses
  Forms,
  MainCont in 'MainCont.pas' {MainFormCont},
  EditCont in 'EditCont.pas' {EditContForm},
  EditGroup in 'EditGroup.pas' {EditGroupForm},
  SelGroup in 'SelGroup.pas' {SelGroupForm},
  EditUserField in 'EditUserField.pas' {EditUserFieldFrm},
  EditContactEvent in 'EditContactEvent.pas' {EditContactEventFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainFormCont, MainFormCont);
  Application.CreateForm(TEditContForm, EditContForm);
  Application.CreateForm(TEditGroupForm, EditGroupForm);
  Application.CreateForm(TSelGroupForm, SelGroupForm);
  Application.CreateForm(TEditUserFieldFrm, EditUserFieldFrm);
  Application.CreateForm(TEditContactEventFrm, EditContactEventFrm);
  Application.Run;
end.
