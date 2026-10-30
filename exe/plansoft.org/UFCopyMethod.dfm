inherited FCopyMethod: TFCopyMethod
  Left = 400
  Top = 200
  Width = 640
  Height = 470
  BorderIcons = [biSystemMenu]
  Caption = 'Kopiowanie rozk'#322'adu zaj'#281#263
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 420
    Width = 632
  end
  object LHeader: TLabel
    Left = 16
    Top = 12
    Width = 600
    Height = 36
    AutoSize = False
    Caption = 'Wska'#380', w jaki spos'#243'b chcesz wykona'#263' kopiowanie rozk'#322'adu zaj'#281#263'. Masz do wyboru dwie mo'#380'liwo'#347'ci - wybierz metod'#281', kt'#243'ra Ci lepiej odpowiada.'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object GBExcel: TGroupBox
    Left = 16
    Top = 56
    Width = 600
    Height = 180
    Caption = ' Metoda I - przez program Excel '
    TabOrder = 1
    object LExcel: TLabel
      Left = 12
      Top = 22
      Width = 576
      Height = 48
      AutoSize = False
      Caption = 'Wyeksportuj zaj'#281'cia do programu Excel, tam je popraw, np. zmie'#324' daty, a nast'#281'pnie zaimportuj je z powrotem do programu.'
      WordWrap = True
    end
    object LExcelHint: TLabel
      Left = 12
      Top = 120
      Width = 576
      Height = 48
      AutoSize = False
      Caption = 'Przy pobieraniu wybierz poprawiony plik. Zaznacz najpierw "Chc'#281' tylko przetestowa'#263' plik", a dopiero gdy test si'#281' uda - "Chc'#281' zaimportowa'#263' plik".'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object BExport: TBitBtn
      Left = 12
      Top = 76
      Width = 280
      Height = 33
      Caption = '1. Zapisz rozk'#322'ad zaj'#281#263' w Excel'
      TabOrder = 0
      OnClick = BExportClick
    end
    object BImport: TBitBtn
      Left = 308
      Top = 76
      Width = 280
      Height = 33
      Caption = '2. Pobierz dane z programu Excel'
      TabOrder = 1
      OnClick = BImportClick
    end
  end
  object GBApp: TGroupBox
    Left = 16
    Top = 248
    Width = 600
    Height = 120
    Caption = ' Metoda II - bezpo'#347'rednio w aplikacji '
    TabOrder = 2
    object LApp: TLabel
      Left = 12
      Top = 22
      Width = 576
      Height = 36
      AutoSize = False
      Caption = 'U'#380'yj funkcji kopiowania rozk'#322'adu zaj'#281#263' bezpo'#347'rednio w aplikacji.'
      WordWrap = True
    end
    object BCopy: TBitBtn
      Left = 12
      Top = 66
      Width = 280
      Height = 33
      Caption = 'Kopiuj rozk'#322'ad'
      TabOrder = 0
      OnClick = BCopyClick
    end
  end
  object BClose: TBitBtn
    Left = 496
    Top = 380
    Width = 120
    Height = 29
    Cancel = True
    Caption = 'Zamknij'
    ModalResult = 2
    TabOrder = 3
  end
end
