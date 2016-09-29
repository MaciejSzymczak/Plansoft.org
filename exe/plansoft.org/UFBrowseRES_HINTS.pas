unit UFBrowseRES_HINTS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, OleServer, ExcelXP, DB, ADODB, ImgList,
  ExtCtrls, StrHlder, Menus, ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls,
  ComCtrls, Grids, DBGrids, Buttons;

type
  TFBrowseRES_HINTS = class(TFBrowseParent)
  private
    { Private declarations }
  public
   Function  CanEditIntegrity : Boolean;          override;
   Function  CanEditPermission : Boolean;         override;
   Function  CanInsert    : Boolean;              override;
   Function  getSearchFilter : string;  override;
   function  getFindCaption : string;   override;
   Function  canDelete    : Boolean;        override;
  end;

var
  FBrowseRES_HINTS: TFBrowseRES_HINTS;

implementation

{$R *.dfm}

Uses UUtilityParent;

{ TFBrowseRES_HINTS }

function TFBrowseRES_HINTS.canDelete: Boolean;
begin
 Result := isAdmin;
end;

function TFBrowseRES_HINTS.CanEditIntegrity: Boolean;
begin
 Result := False;
end;

function TFBrowseRES_HINTS.CanEditPermission: Boolean;
begin
 Result := False;
end;

function TFBrowseRES_HINTS.CanInsert: Boolean;
begin
 Result := False;
end;

function TFBrowseRES_HINTS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

function TFBrowseRES_HINTS.getSearchFilter: string;
begin
 result := '(xxmsz_tools.erasePolishChars(upper(to_char(res_hints.day,''yyyy-mm-dd'')||grids.caption||res_hints.ratio||resources.name||res_hints.created_by||res_hints.last_updated_by)) like ''%'+replacePolishChars( ansiuppercase(trim(ESearch.Text)) )+'%'')';
end;

end.
