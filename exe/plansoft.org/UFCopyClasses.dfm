inherited FCopyClasses: TFCopyClasses
  Left = 650
  Top = 210
  Width = 697
  Height = 459
  Caption = 'Kopiowanie rozk'#322'adu'
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 16
    Top = 40
    Width = 365
    Height = 14
    Caption = 
      'Skopiowane dane umie'#347#263' w terminie od dnia                       ' +
      '                       do'
  end
  object Label4: TLabel [1]
    Left = 16
    Top = 16
    Width = 365
    Height = 14
    Caption = 
      'Skopiuj wszystkie zaplanowane dane  od dnia                     ' +
      '                      do'
  end
  inherited Status: TPanel
    Top = 408
    Width = 689
  end
  object source_date_from: TDateTimePicker
    Left = 269
    Top = 8
    Width = 89
    Height = 22
    Date = 0.741385451387031900
    Time = 0.741385451387031900
    TabOrder = 1
    OnChange = dest_date_fromChange
  end
  object source_date_to: TDateTimePicker
    Left = 392
    Top = 8
    Width = 89
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    TabOrder = 2
    OnChange = dest_date_fromChange
  end
  object dest_date_from: TDateTimePicker
    Left = 269
    Top = 32
    Width = 89
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    TabOrder = 3
    OnChange = dest_date_fromChange
  end
  object dest_date_to: TDateTimePicker
    Left = 392
    Top = 32
    Width = 89
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    Enabled = False
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 367
    Width = 689
    Height = 41
    Align = alBottom
    Caption = 'Kopiowanie mo'#380'e zaj'#261#263' kilka minut.'
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
    object BitBtn1: TBitBtn
      Left = 16
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Wi'#281'cej funkcji'
      TabOrder = 2
      OnClick = BitBtn1Click
      NumGlyphs = 2
    end
  end
  object OwnClasses: TRadioGroup
    Left = 16
    Top = 224
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
    Visible = False
  end
  object whichSheets: TRadioGroup
    Left = 16
    Top = 64
    Width = 489
    Height = 105
    Caption = 'Kt'#243're arkusze kopiowa'#263
    ItemIndex = 3
    Items.Strings = (
      'Tylko wybrany: %L.'
      'Tylko wybrany: %G.'
      'Tylko wybrany: zas'#243'b'
      'Wszystkie arkusze')
    TabOrder = 7
    OnClick = whichSheetsClick
  end
  object BSelectSheet: TBitBtn
    Left = 192
    Top = 104
    Width = 307
    Height = 25
    Caption = 'Kliknij tu, aby wybra'#263' arkusz do skopiowania'
    TabOrder = 8
    OnClick = BSelectSheetClick
  end
  object BSelectPeriodFrom: TBitBtn
    Left = 488
    Top = 8
    Width = 153
    Height = 25
    Caption = 'Wybierz okres- sk'#261'd'
    TabOrder = 9
    OnClick = BSelectPeriodFromClick
  end
  object BSelectPeriodTo: TBitBtn
    Left = 488
    Top = 32
    Width = 153
    Height = 25
    Caption = 'Wybierz okres- dok'#261'd'
    TabOrder = 10
    OnClick = BSelectPeriodToClick
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 176
    Width = 489
    Height = 41
    Caption = 'Co kopiujemy'
    TabOrder = 11
    object CopyClasses: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Zaj'#281'cia'
      TabOrder = 0
    end
    object CopyReservations: TCheckBox
      Left = 96
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Rezerwacje'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object ConsistencyGroup: TGroupBox
    Left = 16
    Top = 288
    Width = 489
    Height = 73
    Caption = 'Sp'#243'jno'#347#263' danych'
    TabOrder = 12
    Visible = False
    object dest_period_must_be_empty: TCheckBox
      Left = 8
      Top = 16
      Width = 433
      Height = 17
      Caption = 
        'Nie zezwalaj na skopiowanie, je'#380'eli w obszarze docelowym s'#261' jaki' +
        'ekolwiek dane'
      TabOrder = 0
    end
    object OverlapCheck: TCheckBox
      Left = 8
      Top = 32
      Width = 377
      Height = 17
      Caption = 'Zezwalaj na skopiowanie, je'#380'eli obszary dat pokrywaj'#261' si'#281
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object copyAllOrNothing: TCheckBox
      Left = 8
      Top = 48
      Width = 425
      Height = 17
      Caption = 'Kopiuj wszystko albo nic'
      TabOrder = 2
    end
  end
  object ReplaceWith: TBitBtn
    Left = 192
    Top = 136
    Width = 307
    Height = 25
    Caption = 'Kliknij tu, aby wybra'#263' now'#261' grup'#281' (Kopiuj do grupy)'
    TabOrder = 13
    Visible = False
    OnClick = ReplaceWithClick
  end
end
