unit UFCopyMethod;

// Edycja | Kopiuj rozk³ad zajêæ
// Ekran wyboru metody kopiowania rozk³adu zajêæ:
//   Metoda I   - zapisanie zajêæ w pliku Excel, poprawienie ich tam (np. dat) i pobranie z powrotem (U³o¿ony rozk³ad zajêæ);
//                usuniêcie zajêæ zapisanych w pliku (razem z pobraniem - przeniesienie zajêæ w nowe miejsce)
//   Metoda II  - tradycyjny formularz kopiowania rozk³adu w aplikacji (UFCopyClasses)
//   Metoda III - przesuniêcie zajêæ z wybranego okresu na nowe daty (UFMoveClasses)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFCopyMethod = class(TFormConfig)
    LHeader: TLabel;
    GBExcel: TGroupBox;
    LExcel: TLabel;
    BExport: TBitBtn;
    BImport: TBitBtn;
    BDelete: TPanel;
    LExcelHint: TLabel;
    GBApp: TGroupBox;
    LApp: TLabel;
    BCopy: TBitBtn;
    GBMove: TGroupBox;
    LMove: TLabel;
    BMove: TBitBtn;
    BClose: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BExportClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure BCopyClick(Sender: TObject);
    procedure BMoveClick(Sender: TObject);
  end;

var
  FCopyMethod: TFCopyMethod;

implementation

uses UFMain, UFMassImport, UFMoveClasses;

{$R *.DFM}

procedure TFCopyMethod.FormShow(Sender: TObject);
begin
  inherited;
  // eksport i import z Excela s¹ dostêpne tylko tam, gdzie s¹ dostêpne w menu Dane | Zarz¹dzanie danymi
  BExport.Enabled := FMain.exportTimetable.Visible;
  BImport.Enabled := FMain.massImport.Visible;
  // przycisk w kolorze czerwonym (niebezpieczna akcja) - TPanel, bo TBitBtn nie ma koloru t³a
  BDelete.Enabled := FMain.massImport.Visible;
  if not BDelete.Enabled then begin
    BDelete.Color      := clBtnFace;
    BDelete.Font.Color := clGrayText;
    BDelete.Cursor     := crDefault;
  end;
end;

procedure TFCopyMethod.BExportClick(Sender: TObject);
begin
  FMain.exportTimetableClick(nil);
end;

procedure TFCopyMethod.BImportClick(Sender: TObject);
begin
  FMain.RunMassImport(6); // U³o¿ony rozk³ad zajêæ
end;

procedure TFCopyMethod.BDeleteClick(Sender: TObject);
begin
  if FMassImport = nil then Application.CreateForm(TFMassImport, FMassImport);
  FMassImport.DeleteTimetable;
end;

procedure TFCopyMethod.BCopyClick(Sender: TObject);
begin
  FMain.Kopiowaniegrupowe1Click(nil);
end;

procedure TFCopyMethod.BMoveClick(Sender: TObject);
begin
  FMoveClasses := TFMoveClasses.Create(Application);
  try
    FMoveClasses.ShowModal;
  finally
    FreeAndNil(FMoveClasses);
  end;
end;

end.
