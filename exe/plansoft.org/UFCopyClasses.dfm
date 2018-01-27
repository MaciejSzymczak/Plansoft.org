inherited FCopyClasses: TFCopyClasses
  Left = 377
  Top = 204
  Width = 599
  Height = 422
  Caption = 'Kopiowanie rozk'#322'adu'
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 18
    Top = 46
    Width = 414
    Height = 16
    Caption = 
      'Skopiowane dane umie'#347#263' w terminie od dnia                       ' +
      '       do'
  end
  object Label4: TLabel [1]
    Left = 18
    Top = 18
    Width = 413
    Height = 16
    Caption = 
      'Skopiuj wszystkie zaplanowane dane  od dnia                     ' +
      '       do'
  end
  inherited Status: TPanel
    Top = 363
    Width = 591
  end
  object source_date_from: TDateTimePicker
    Left = 307
    Top = 9
    Width = 102
    Height = 22
    Date = 0.741385451387031900
    Time = 0.741385451387031900
    TabOrder = 1
    OnChange = dest_date_fromChange
  end
  object source_date_to: TDateTimePicker
    Left = 448
    Top = 9
    Width = 102
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    TabOrder = 2
    OnChange = dest_date_fromChange
  end
  object dest_date_from: TDateTimePicker
    Left = 307
    Top = 37
    Width = 102
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    TabOrder = 3
    OnChange = dest_date_fromChange
  end
  object dest_date_to: TDateTimePicker
    Left = 448
    Top = 37
    Width = 102
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    Enabled = False
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 317
    Width = 591
    Height = 46
    Align = alBottom
    TabOrder = 5
    object Anuluj: TBitBtn
      Left = 494
      Top = 9
      Width = 85
      Height = 29
      Caption = 'Anuluj'
      TabOrder = 0
      OnClick = AnulujClick
      Kind = bkCancel
    end
    object BExecute: TBitBtn
      Left = 402
      Top = 9
      Width = 86
      Height = 29
      TabOrder = 1
      OnClick = BExecuteClick
      Kind = bkOK
    end
  end
  object OwnClasses: TRadioGroup
    Left = 18
    Top = 82
    Width = 559
    Height = 65
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
    Left = 18
    Top = 155
    Width = 559
    Height = 20
    Caption = 
      'Nie zezwalaj na skopiowanie, je'#380'eli w obszarze docelowym s'#261' jaki' +
      'ekolwiek dane'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object whichSheets: TRadioGroup
    Left = 18
    Top = 183
    Width = 559
    Height = 120
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
    Left = 219
    Top = 265
    Width = 351
    Height = 29
    Caption = 'Kliknij tu, aby wybra'#263' arkusz do skopiowania'
    TabOrder = 9
    OnClick = BSelectSheetClick
  end
end
