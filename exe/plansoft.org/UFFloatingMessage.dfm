object FFloatingMessage: TFFloatingMessage
  Left = 513
  Top = 236
  BorderStyle = bsNone
  Caption = 'FFloatingMessage'
  ClientHeight = 99
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object message: TRichEdit
    Left = 0
    Top = 0
    Width = 818
    Height = 99
    Align = alClient
    Alignment = taCenter
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clMoneyGreen
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'message')
    ParentFont = False
    TabOrder = 0
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 1044
    Top = 272
  end
end
