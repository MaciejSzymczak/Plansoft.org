unit UFTransfer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, DB, ADODB;

type
  TFTransfer = class(TFormConfig)
    GroupBox1: TGroupBox;
    chlec: TCheckBox;
    chgro: TCheckBox;
    chrom: TCheckBox;
    chsub: TCheckBox;
    chfor: TCheckBox;
    chclasses: TCheckBox;
    ufrom_value: TEdit;
    ufrom: TEdit;
    BitBtnROLE: TSpeedButton;
    Label7: TLabel;
    uto_value: TEdit;
    uto: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    topPanel: TPanel;
    BCreate: TSpeedButton;
    BClose: TSpeedButton;
    chrol: TCheckBox;
    chPer: TCheckBox;
    procedure ufromChange(Sender: TObject);
    procedure utoChange(Sender: TObject);
    procedure BitBtnROLEClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BCreateClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTransfer: TFTransfer;

Procedure ShowModal;

implementation

uses DM, autocreate, uutilityparent;

{$R *.dfm}

Procedure ShowModal;
Begin
 If Not Assigned(FTransfer) Then FTransfer := TFTransfer.Create(Application);
 FTransfer.ShowModal;
 If Assigned(FTransfer) Then FTransfer.Free;
 FTransfer := Nil;
End;

procedure TFTransfer.ufromChange(Sender: TObject);
begin
   DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PLANNERS','');
end;

procedure TFTransfer.utoChange(Sender: TObject);
begin
   DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PLANNERS','');
end;

procedure TFTransfer.BitBtnROLEClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := ufrom.Text;
  If PLANNERSShowModalAsSelect(KeyValue) = mrOK Then ufrom.Text := KeyValue;
end;

procedure TFTransfer.SpeedButton1Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := uto.Text;
  If PLANNERSShowModalAsSelect(KeyValue) = mrOK Then uto.Text := KeyValue;
end;

procedure TFTransfer.BCreateClick(Sender: TObject);
begin
  if isBlank(ufrom.Text) then begin info('WprowadŸ wartoœæ w polu "Od planisty lub autoryzacji"'); exit; end;
  if isBlank(uto.Text) then begin info('WprowadŸ wartoœæ w polu "Do planisty lub autoryzacji"'); exit; end;
  if ufrom.Text=uto.Text then begin info('WprowadŸ dwie ró¿ne nazwy planistów'); exit; end;
  if question('Czy na pewno wykonaæ transfer?')=id_yes then begin
      try
        with dmodule.QWork do begin
          SQL.Clear;
          SQL.Add('begin copy_permissions(:pfrom_pla_id,:pto_pla_id,:plec,:pgro,:prom,:prol,:psub,:pfor,:pper,:pclasses); end;');
          parameters.ParamByName('pfrom_pla_id').value := ufrom.Text;
          parameters.ParamByName('pto_pla_id').value   := uto.Text;
          parameters.ParamByName('plec').value         := iif(chlec.Checked,'Y','N');
          parameters.ParamByName('pgro').value         := iif(chgro.Checked,'Y','N');
          parameters.ParamByName('prom').value         := iif(chrom.Checked,'Y','N');
          parameters.ParamByName('prol').value         := iif(chrol.Checked,'Y','N');
          parameters.ParamByName('psub').value         := iif(chsub.Checked,'Y','N');
          parameters.ParamByName('pfor').value         := iif(chfor.Checked,'Y','N');
          parameters.ParamByName('pper').value         := iif(chper.Checked,'Y','N');
          parameters.ParamByName('pclasses').value     := iif(chclasses.Checked,'Y','N');
          logSQLStart('insert_classes', dmodule.QWork.SQL.CommaText);
          execSQL;
          logSQLStop;
        end;
      except
        on E:exception do Begin
          Dmodule.RollbackTrans;
          info('Ups.. Coœ posz³o nie tak, powiedz o tym administatorowi.'+cr+'Je¿eli posiadasz aktywn¹ umowê serwisow¹ firma Software Factory pomo¿e w rozwi¹zaniu problemu, zadzwoñ pod numer +48 604224658'+cr+cr+
                  'Komunikat, który zwróci³a baza danych jest nastêpuj¹cy: ' + cr+ e.message);
        end;
      end;
  end;
  info('Zrobione. Uruchom ponownie Aplikacjê, ¿eby zobaczyæ zmiany');
  Close;
end;

procedure TFTransfer.BCloseClick(Sender: TObject);
begin
  Close;
end;

end.
