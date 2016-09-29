inherited FMassImport: TFMassImport
  Left = 422
  Top = 251
  Height = 319
  Caption = 'Pobieranie danych z programu Excel'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 268
  end
  object importType: TRadioGroup
    Left = 8
    Top = 88
    Width = 185
    Height = 105
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
    Left = 8
    Top = 8
    Width = 521
    Height = 65
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
    Left = 8
    Top = 200
    Width = 249
    Height = 17
    Caption = 'Uruchomienie testowe ( nie zapisuj danych )'
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 227
    Width = 532
    Height = 41
    Align = alBottom
    TabOrder = 4
    object BitBtn1: TBitBtn
      Left = 368
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Pobierz dane'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 456
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Zamknij'
      Default = True
      TabOrder = 1
      OnClick = BitBtn2Click
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.xls'
    Filter = 'xls|*.xls|*.*|*.*'
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
