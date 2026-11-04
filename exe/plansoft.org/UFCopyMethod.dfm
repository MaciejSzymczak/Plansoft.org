inherited FCopyMethod: TFCopyMethod
  Left = 400
  Top = 160
  Width = 848
  Height = 600
  BorderIcons = [biSystemMenu]
  Caption = 'Kopiowanie rozk'#322'adu zaj'#281#263
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 550
    Width = 840
  end
  object LHeader: TLabel
    Left = 16
    Top = 12
    Width = 800
    Height = 36
    AutoSize = False
    Caption = 'Wska'#380', w jaki spos'#243'b chcesz wykona'#263' kopiowanie rozk'#322'adu zaj'#281#263'. Masz do wyboru trzy mo'#380'liwo'#347'ci - wybierz metod'#281', kt'#243'ra Ci lepiej odpowiada.'
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
    Width = 800
    Height = 196
    Caption = ' Metoda I - przez program Excel '
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object LExcel: TLabel
      Left = 12
      Top = 22
      Width = 776
      Height = 48
      AutoSize = False
      Caption = 'Wyeksportuj zaj'#281'cia do programu Excel, tam je popraw, np. zmie'#324' daty, a nast'#281'pnie zaimportuj je z powrotem do programu. Przycisk "3. Usu'#324' rozk'#322'ad" usuwa z rozk'#322'adu zaj'#281'cia zapisane w pliku - tak mo'#380'esz przenie'#347#263' zaj'#281'cia w nowe miejsce zamiast je kopiowa'#263'.'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object LExcelHint: TLabel
      Left = 12
      Top = 120
      Width = 776
      Height = 64
      AutoSize = False
      Caption = 'Przy pobieraniu wybierz poprawiony plik. Zaznacz najpierw "Chc'#281' tylko przetestowa'#263' plik", a dopiero gdy test si'#281' uda - "Chc'#281' zaimportowa'#263' plik". Przenoszenie zaj'#281#263': zapisz rozk'#322'ad (1), zr'#243'b kopi'#281' pliku i popraw w niej daty, pobierz kopi'#281' (2), a potem usu'#324' zaj'#281'cia wed'#322'ug pierwotnego pliku (3).'
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
      Width = 250
      Height = 33
      Caption = '1. Zapisz rozk'#322'ad zaj'#281#263' w Excel'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BExportClick
    end
    object BImport: TBitBtn
      Left = 275
      Top = 76
      Width = 250
      Height = 33
      Caption = '2. Pobierz dane z programu Excel'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = BImportClick
    end
    object BDelete: TPanel
      Left = 538
      Top = 76
      Width = 250
      Height = 33
      Cursor = crHandPoint
      Hint = 'Usuwa z rozk'#322'adu zaj'#281'cia zapisane w wybranym pliku (w formacie przycisku 1)'
      Caption = '3. Usu'#324' rozk'#322'ad zaj'#281#263' wed'#322'ug pliku'
      Color = 2105536
      ParentBackground = False
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = BDeleteClick
    end
  end
  object GBApp: TGroupBox
    Left = 16
    Top = 264
    Width = 800
    Height = 112
    Caption = ' Metoda II - bezpo'#347'rednio w aplikacji '
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object LApp: TLabel
      Left = 12
      Top = 22
      Width = 776
      Height = 36
      AutoSize = False
      Caption = 'U'#380'yj funkcji kopiowania rozk'#322'adu zaj'#281#263' bezpo'#347'rednio w aplikacji.'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object BCopy: TBitBtn
      Left = 12
      Top = 62
      Width = 250
      Height = 33
      Caption = 'Kopiuj rozk'#322'ad'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BCopyClick
    end
  end
  object GBMove: TGroupBox
    Left = 16
    Top = 388
    Width = 800
    Height = 112
    Caption = ' Metoda III - przesu'#324' rozk'#322'ad '
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object LMove: TLabel
      Left = 12
      Top = 22
      Width = 776
      Height = 36
      AutoSize = False
      Caption = 'Przesu'#324' zaj'#281'cia z wybranego okresu na nowe daty (np. ca'#322'y kurs o tydzie'#324' p'#243#378'niej) - bez kopiowania. Wybierz wyk'#322'adowc'#243'w, grupy i sale, kt'#243'rych zaj'#281'cia maj'#261' zosta'#263' przesuni'#281'te.'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object BMove: TBitBtn
      Left = 12
      Top = 62
      Width = 250
      Height = 33
      Caption = 'Przesu'#324' rozk'#322'ad'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BMoveClick
    end
  end
  object BClose: TBitBtn
    Left = 696
    Top = 512
    Width = 120
    Height = 29
    Cancel = True
    Caption = 'Zamknij'
    ModalResult = 2
    TabOrder = 4
  end
end
