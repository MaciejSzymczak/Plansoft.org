unit UFDataEnrichment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFDataEnrichment = class(TFormConfig)
    Panel1: TPanel;
    BClose: TBitBtn;
    LecSub: TBitBtn;
    LecSubDesc: TMemo;
    SQLLecSub: TMemo;
    procedure LecSubClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDataEnrichment: TFDataEnrichment;

implementation

uses DM, UFFloatingMessage, UProgress, UCommon, UUtilityParent;

{$R *.dfm}

procedure TFDataEnrichment.LecSubClick(Sender: TObject);
var query : string;
begin
   FProgress.Show;
   FProgress.ProgressBar.Position :=  50;
   FProgress.Refresh;

   query := SQLLecSub.Lines.Text;
   query := searchAndReplace(  query, '%MY_LEC_ONLY1', getWhereClause('LECTURERS'));
   query := searchAndReplace(  query, '%MY_LEC_ONLY2', searchAndReplace(getWhereClause('LECTURERS'),'LECTURERS.ID','LEC_ID') );

   //LecSubDesc.lines.text := query;

   DModule.SQL( query );
   FProgress.Hide;
   FFloatingMessage.showModal('Zrobione!');
   close;
end;

end.
