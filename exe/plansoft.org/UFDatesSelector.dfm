inherited FDatesSelector: TFDatesSelector
  Left = 355
  Top = 291
  Width = 292
  Height = 149
  Caption = 'Wyb'#243'r dat'
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 9
    Top = 18
    Width = 16
    Height = 16
    Caption = 'od'
  end
  object Label2: TLabel [1]
    Left = 137
    Top = 18
    Width = 16
    Height = 16
    Caption = 'do'
  end
  inherited Status: TPanel
    Top = 43
    Width = 284
  end
  object source_date_from: TDateTimePicker
    Left = 27
    Top = 9
    Width = 102
    Height = 22
    Date = 0.741385451387031900
    Time = 0.741385451387031900
    TabOrder = 1
    OnChange = source_date_fromChange
  end
  object source_date_to: TDateTimePicker
    Left = 155
    Top = 9
    Width = 102
    Height = 22
    Date = 40194.741385451390000000
    Time = 40194.741385451390000000
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 65
    Width = 284
    Height = 47
    Align = alBottom
    TabOrder = 3
    object Anuluj: TBitBtn
      Left = 174
      Top = 9
      Width = 85
      Height = 29
      Caption = 'Anuluj'
      TabOrder = 0
      Kind = bkCancel
    end
    object BExecute: TBitBtn
      Left = 82
      Top = 9
      Width = 86
      Height = 29
      TabOrder = 1
      Kind = bkOK
    end
  end
end
