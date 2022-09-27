inherited FDatesSelector: TFDatesSelector
  Left = 355
  Top = 291
  Width = 292
  Height = 149
  Caption = 'Wyb'#243'r dat'
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 8
    Top = 16
    Width = 12
    Height = 14
    Caption = 'od'
  end
  object Label2: TLabel [1]
    Left = 120
    Top = 16
    Width = 12
    Height = 14
    Caption = 'do'
  end
  inherited Status: TPanel
    Top = 57
    Width = 284
  end
  object source_date_from: TDateTimePicker
    Left = 24
    Top = 8
    Width = 89
    Height = 22
    Date = 36526.741385451390000000
    Time = 36526.741385451390000000
    TabOrder = 1
    OnChange = source_date_fromChange
  end
  object source_date_to: TDateTimePicker
    Left = 136
    Top = 8
    Width = 89
    Height = 22
    Date = 401769.741385451400000000
    Time = 401769.741385451400000000
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 77
    Width = 284
    Height = 41
    Align = alBottom
    TabOrder = 3
    object Anuluj: TBitBtn
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Anuluj'
      TabOrder = 0
      Kind = bkCancel
    end
    object BExecute: TBitBtn
      Left = 72
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkOK
    end
  end
end
