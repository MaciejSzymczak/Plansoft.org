inherited FMassImport: TFMassImport
  Left = 599
  Top = 264
  Width = 489
  Height = 400
  Caption = 'Pobieranie danych z programu Excel'
  KeyPreview = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 349
    Width = 481
  end
  object PC: TPageControl
    Left = 0
    Top = 0
    Width = 481
    Height = 349
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = '1. Co importujemy? '
      object importType: TRadioGroup
        Left = 112
        Top = 19
        Width = 252
        Height = 170
        Caption = 'Jakie dane importujemy?'
        Items.Strings = (
          'Wyk'#322'adowcy'
          'Grupy'
          'Sale'
          'Przedmioty'
          'Formy / rezerwacje'
          'Plan studi'#243'w'
          'U'#322'o'#380'ony rozk'#322'ad zaj'#281#263)
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
      object DeletePlan: TCheckBox
        Left = 8
        Top = 240
        Width = 417
        Height = 17
        Caption = 'Skasuj istniej'#261'ce linie w planie studi'#243'w, nale'#380#261'ce do mnie'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object DeleteAllData: TCheckBox
        Left = 8
        Top = 240
        Width = 217
        Height = 17
        Caption = 'Skasuj ca'#322#261' zawarto'#347#263' bazy danych'
        TabOrder = 4
        Visible = False
        OnClick = DeleteAllDataClick
      end
      object BDeleteAllData: TBitBtn
        Left = 232
        Top = 235
        Width = 233
        Height = 25
        Caption = 'Skasuj ca'#322#261' zawarto'#347#263' bazy danych'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        Visible = False
        OnClick = BDeleteAllDataClick
      end
      object LDangerZone: TLabel
        Left = 8
        Top = 262
        Width = 457
        Height = 48
        AutoSize = False
        Caption = 'STREFA NIEBEZPIECZNA! ZOSTANIE SKASOWANA CA'#321'A ZAWARTO'#346#262' BAZY DANYCH. NIE URUCHAMIAJ TEJ FUNKCJI W '#346'RODOWISKU PRODUKCYJNYM.'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
        WordWrap = True
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
  object report: TADOQuery
    AutoCalcFields = False
    Connection = DModule.ADOConnection
    CommandTimeout = 1000
    Parameters = <>
    Left = 272
    Top = 96
  end
end
