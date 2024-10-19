object FSelectDate: TFSelectDate
  Left = 403
  Top = 201
  BorderStyle = bsDialog
  Caption = 'Wybierz dat'#281
  ClientHeight = 87
  ClientWidth = 268
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
  object SpeedButton2: TSpeedButton
    Left = 216
    Top = 56
    Width = 47
    Height = 22
    Caption = 'Anuluj'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object ButtonOK: TSpeedButton
    Left = 168
    Top = 56
    Width = 47
    Height = 22
    Caption = 'Ok'
    Flat = True
    OnClick = ButtonOKClick
  end
  object date: TDateTimePicker
    Left = 16
    Top = 8
    Width = 89
    Height = 22
    Date = 401769.741385451400000000
    Time = 401769.741385451400000000
    TabOrder = 0
    OnChange = dateChange
  end
  object BitBtn1: TBitBtn
    Left = 109
    Top = 8
    Width = 52
    Height = 22
    Caption = 'Wybierz'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object SelectDates: TPopupMenu
    Left = 88
    Top = 48
    object Przedwczoraj1: TMenuItem
      Caption = 'Przedwczoraj'
      OnClick = Przedwczoraj1Click
    end
    object Wczoraj1: TMenuItem
      Caption = 'Wczoraj'
      OnClick = Wczoraj1Click
    end
    object MenuItem3: TMenuItem
      Caption = 'Dzi'#347
      OnClick = MenuItem3Click
    end
    object Cdesc3: TMenuItem
      Caption = 'Jutro'
      OnClick = Cdesc3Click
    end
    object Cdesc4: TMenuItem
      Caption = 'Pojutrze'
      OnClick = Cdesc4Click
    end
  end
end
