unit UFBrowseEVENTLOG;

// Narzêdzia administracyjne | Dziennik zdarzeñ systemowych
// Podgl¹d tabeli XXMSZTOOLS_EVENTLOG (m.in. logowania i wylogowania z programu: MODULE_NAME = 'PLANOWANIE.SESSION',
// MESSAGE_TYPE = LOGON / LOGOFF). Tylko do odczytu - bez dodawania, edycji i kasowania zdarzeñ.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, OleServer, ExcelXP, DB, ADODB, ImgList,
  ExtCtrls, StrHlder, Menus, ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls,
  ComCtrls, Grids, DBGrids, Buttons;

type
  TFBrowseEVENTLOG = class(TFBrowseParent)
  public
   Function  CanEditIntegrity : Boolean;          override;
   Function  CanEditPermission : Boolean;         override;
   Function  CanInsert    : Boolean;              override;
   Function  canDelete    : Boolean;              override;
   Function  CanDeleteRecord : Boolean;           override;
   Procedure GetTableName;                        override;
   Procedure editClick;                           override;
   Procedure deleteClick;                         override;
   Function  getSearchFilter : string;  override;
   function  getFindCaption : string;   override;
  end;

var
  FBrowseEVENTLOG: TFBrowseEVENTLOG;

implementation

{$R *.dfm}

Uses UUtilityParent, DM;

const sql_EVENTLOG_SEARCH = '(xxmsz_tools.erasePolishChars(upper(e.message||'' ''||e.module_name||'' ''||e.message_type||'' ''||e.created_dsp)) like ''%%%s%%'')';

{ TFBrowseEVENTLOG }

function TFBrowseEVENTLOG.CanEditIntegrity: Boolean;
begin
 Result := False;
end;

function TFBrowseEVENTLOG.CanEditPermission: Boolean;
begin
 Result := False;
end;

function TFBrowseEVENTLOG.CanInsert: Boolean;
begin
 Result := False;
end;

function TFBrowseEVENTLOG.canDelete: Boolean;
begin
 Result := False;
end;

function TFBrowseEVENTLOG.CanDeleteRecord: Boolean;
begin
 Result := False;
end;

// zapytanie jest podzapytaniem (najnowsze zdarzenia na górze, tak¿e przy limicie liczby wierszy w siatce)
Procedure TFBrowseEVENTLOG.GetTableName;
Begin
  Self.TableName := 'XXMSZTOOLS_EVENTLOG';
End;

// zdarzeñ nie mo¿na edytowaæ ani kasowaæ
procedure TFBrowseEVENTLOG.editClick;
begin
end;

procedure TFBrowseEVENTLOG.deleteClick;
begin
end;

function TFBrowseEVENTLOG.getFindCaption: string;
begin
 Result := 'Komunikat, modu³, rodzaj';
end;

function TFBrowseEVENTLOG.getSearchFilter: string;
begin
 result := buildFilter(sql_EVENTLOG_SEARCH, ESearch.Text);
end;

end.
