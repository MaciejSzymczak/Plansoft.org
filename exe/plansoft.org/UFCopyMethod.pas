unit UFCopyMethod;

// Edycja | Kopiuj rozk³ad zajêæ
// Ekran wyboru metody kopiowania rozk³adu zajêæ:
//   Metoda I  - zapisanie zajêæ w pliku Excel, poprawienie ich tam (np. dat) i pobranie z powrotem (U³o¿ony rozk³ad zajêæ)
//   Metoda II - tradycyjny formularz kopiowania rozk³adu w aplikacji (UFCopyClasses)

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
    LExcelHint: TLabel;
    GBApp: TGroupBox;
    LApp: TLabel;
    BCopy: TBitBtn;
    BClose: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BExportClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
    procedure BCopyClick(Sender: TObject);
  end;

var
  FCopyMethod: TFCopyMethod;

implementation

uses UFMain;

{$R *.DFM}

procedure TFCopyMethod.FormShow(Sender: TObject);
begin
  inherited;
  // eksport i import z Excela s¹ dostêpne tylko tam, gdzie s¹ dostêpne w menu Dane | Zarz¹dzanie danymi
  BExport.Enabled := FMain.exportTimetable.Visible;
  BImport.Enabled := FMain.massImport.Visible;
end;

procedure TFCopyMethod.BExportClick(Sender: TObject);
begin
  FMain.exportTimetableClick(nil);
end;

procedure TFCopyMethod.BImportClick(Sender: TObject);
begin
  FMain.RunMassImport(6); // U³o¿ony rozk³ad zajêæ
end;

procedure TFCopyMethod.BCopyClick(Sender: TObject);
begin
  FMain.Kopiowaniegrupowe1Click(nil);
end;

end.
