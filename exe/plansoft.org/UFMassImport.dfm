inherited FMassImport: TFMassImport
  Left = 422
  Top = 251
  Width = 635
  Height = 368
  Caption = 'Pobieranie danych z programu Excel'
  PixelsPerInch = 120
  TextHeight = 16
  inherited Status: TPanel
    Top = 309
    Width = 627
  end
  object importType: TRadioGroup
    Left = 9
    Top = 101
    Width = 288
    Height = 120
    Caption = 'Wybierz jakie dane chcesz pobra'#263
    Items.Strings = (
      'Wyk'#322'adowcy'
      'Grupy'
      'Sale'
      'Przedmioty'
      'Formy / rezerwacje')
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 9
    Top = 9
    Width = 596
    Height = 74
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Za pomoc'#261' tego formularza mo'#380'esz pobra'#263' dane z programu Excel.'
      'Arkusz excel z danymi musi mie'#263' okre'#347'lony format.'
      
        'W pierwszym wierszu musi by'#263' nag'#322#243'wek, w kolejnych wierszach mus' +
        'z'#261' znajdowa'#263' si'#281' dane.'
      'Aby dowiedzie'#263' si'#281' wi'#281'cej zajrzyj do podr'#281'cznika u'#380'ytkownika.')
    ReadOnly = True
    TabOrder = 2
    WordWrap = False
  end
  object chbTest: TCheckBox
    Left = 9
    Top = 229
    Width = 285
    Height = 19
    Caption = 'Uruchomienie testowe ( nie zapisuj danych )'
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 262
    Width = 627
    Height = 47
    Align = alBottom
    TabOrder = 4
    object BitBtn1: TBitBtn
      Left = 421
      Top = 9
      Width = 92
      Height = 29
      Caption = 'Pobierz dane'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 521
      Top = 9
      Width = 86
      Height = 29
      Cancel = True
      Caption = 'Zamknij'
      Default = True
      TabOrder = 1
      OnClick = BitBtn2Click
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.xlsx'
    Filter = 'xls|*.xls|*.*|*.*|xlsx|*.xlsx'
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
