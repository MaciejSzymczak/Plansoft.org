inherited FMassImport: TFMassImport
  Left = 422
  Top = 251
  Width = 489
  Height = 368
  Caption = 'Pobieranie danych z programu Excel'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 317
    Width = 481
  end
  object PC: TPageControl
    Left = 0
    Top = 0
    Width = 481
    Height = 317
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = '1. Co importujemy? '
      object importType: TRadioGroup
        Left = 112
        Top = 19
        Width = 252
        Height = 150
        Caption = 'Jakie dane importujemy?'
        Items.Strings = (
          'Wyk'#322'adowcy'
          'Grupy'
          'Sale'
          'Przedmioty'
          'Formy / rezerwacje'
          '(WKR'#211'TCE!) Plan studi'#243'w')
        TabOrder = 0
        OnClick = importTypeClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = '2. Pobierz szablon'
      ImageIndex = 2
      object BTemplate: TBitBtn
        Left = 8
        Top = 120
        Width = 457
        Height = 105
        Caption = 'Kliknij TUTAJ aby pobra'#263' szablon do wype'#322'nienia'
        TabOrder = 0
        OnClick = BTemplateClick
      end
      object BitBtn1: TBitBtn
        Left = 8
        Top = 8
        Width = 457
        Height = 105
        Caption = 'Mam ju'#380' szablon, kontynuuj'
        TabOrder = 1
        OnClick = BitBtn1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = '3. Importujemy !'
      ImageIndex = 1
      object BitBtn2: TBitBtn
        Left = 8
        Top = 120
        Width = 457
        Height = 105
        Caption = 'Chc'#281' tylko przetestowa'#263' plik >>'
        TabOrder = 0
        OnClick = BitBtn2Click
      end
      object BitBtn3: TBitBtn
        Left = 8
        Top = 8
        Width = 457
        Height = 105
        Caption = 'Chc'#281' zaimportowa'#263' plik >>'
        TabOrder = 1
        OnClick = BitBtn3Click
      end
      object chbTest: TCheckBox
        Left = 8
        Top = 259
        Width = 249
        Height = 17
        Caption = 'Uruchomienie testowe ( nie zapisuj danych )'
        Enabled = False
        TabOrder = 2
        Visible = False
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.*'
    Filter = 'xlsx|*.xlsx|*.*|*.*|xls|*.xls'
    Left = 232
    Top = 96
  end
  object ExcelApplication: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 200
    Top = 96
  end
end
