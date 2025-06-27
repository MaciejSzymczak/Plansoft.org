inherited FCopyClasses: TFCopyClasses
  Left = 585
  Top = 279
  Width = 697
  Height = 390
  Caption = 'Kopiowanie rozk'#322'adu'
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 16
    Top = 64
    Width = 365
    Height = 14
    Caption = 
      'Skopiowane dane umie'#347#263' w terminie od dnia                       ' +
      '                       do'
  end
  object Label4: TLabel [1]
    Left = 16
    Top = 40
    Width = 365
    Height = 14
    Caption = 
      'Skopiuj wszystkie zaplanowane dane  od dnia                     ' +
      '                      do'
  end
  object Label2: TLabel [2]
    Left = 16
    Top = 8
    Width = 665
    Height = 14
    Caption = 
      'Zaleca si'#281' kopiowanie okresu o d'#322'ugo'#347'ci 7dni. D'#322'u'#380'sze okresy r'#243'w' +
      'nie'#380' mog'#261' by'#263' kopiowanie, ale zajmie to wi'#281'cej czasu.'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited Status: TPanel
    Top = 339
    Width = 689
  end
  object source_date_from: TDateTimePicker
    Left = 269
    Top = 32
    Width = 89
    Height = 22
    Date = 0.741385451387031900
    Time = 0.741385451387031900
    TabOrder = 1
    OnChange = dest_date_fromChange
  end
  object source_date_to: TDateTimePicker
    Left = 392
    Top = 32
    Width = 89
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    TabOrder = 2
    OnChange = dest_date_fromChange
  end
  object dest_date_from: TDateTimePicker
    Left = 269
    Top = 56
    Width = 89
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    TabOrder = 3
    OnChange = dest_date_fromChange
  end
  object dest_date_to: TDateTimePicker
    Left = 392
    Top = 56
    Width = 89
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    Enabled = False
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 298
    Width = 689
    Height = 41
    Align = alBottom
    TabOrder = 5
    object Anuluj: TBitBtn
      Left = 608
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Anuluj'
      TabOrder = 0
      OnClick = AnulujClick
      Kind = bkCancel
    end
    object BExecute: TBitBtn
      Left = 528
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      OnClick = BExecuteClick
      Kind = bkOK
    end
  end
  object OwnClasses: TRadioGroup
    Left = 16
    Top = 96
    Width = 489
    Height = 57
    Caption = 
      'Kto ma by'#263' w'#322'a'#347'cicielem skopiowanych danych ( w'#322'a'#347'ciciel mo'#380'e je' +
      ' modyfikowa'#263' )'
    ItemIndex = 0
    Items.Strings = (
      'Chc'#281' zosta'#263' w'#322'a'#347'cicielem skopiowanych danych'
      
        'Chc'#281', aby w'#322'a'#347'cicielami skopiowanych danych byli w'#322'a'#347'ciciele '#378'r'#243 +
        'd'#322'owi')
    TabOrder = 6
  end
  object dest_period_must_be_empty: TCheckBox
    Left = 16
    Top = 160
    Width = 489
    Height = 17
    Caption = 
      'Nie zezwalaj na skopiowanie, je'#380'eli w obszarze docelowym s'#261' jaki' +
      'ekolwiek dane'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object whichSheets: TRadioGroup
    Left = 16
    Top = 184
    Width = 489
    Height = 105
    Caption = 'Kt'#243're arkusze kopiowa'#263
    ItemIndex = 3
    Items.Strings = (
      'Tylko wybrany: %L.'
      'Tylko wybrany: %G.'
      'Tylko wybrany: zas'#243'b'
      'Wszystkie arkusze')
    TabOrder = 8
    OnClick = whichSheetsClick
  end
  object BSelectSheet: TBitBtn
    Left = 192
    Top = 256
    Width = 307
    Height = 25
    Caption = 'Kliknij tu, aby wybra'#263' arkusz do skopiowania'
    TabOrder = 9
    OnClick = BSelectSheetClick
  end
  object BSelectPeriodFrom: TBitBtn
    Left = 488
    Top = 32
    Width = 153
    Height = 25
    Caption = 'Wybierz okres- sk'#261'd'
    TabOrder = 10
    OnClick = BSelectPeriodFromClick
  end
  object BSelectPeriodTo: TBitBtn
    Left = 488
    Top = 56
    Width = 153
    Height = 25
    Caption = 'Wybierz okres- dok'#261'd'
    TabOrder = 11
    OnClick = BSelectPeriodToClick
  end
end
