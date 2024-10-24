object FSelectDate: TFSelectDate
  Left = 403
  Top = 201
  BorderStyle = bsDialog
  Caption = 'Wybierz dat'#281
  ClientHeight = 256
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
    Top = 224
    Width = 47
    Height = 22
    Caption = 'Anuluj'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object ButtonOK: TSpeedButton
    Left = 160
    Top = 224
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
  object D1: TBitBtn
    Left = 21
    Top = 48
    Width = 100
    Height = 22
    Caption = 'Poniedzia'#322'ek'
    TabOrder = 2
    OnClick = D1Click
  end
  object D2: TBitBtn
    Left = 21
    Top = 72
    Width = 100
    Height = 22
    Caption = 'Wtorek'
    TabOrder = 3
    OnClick = D2Click
  end
  object D3: TBitBtn
    Left = 21
    Top = 96
    Width = 100
    Height = 22
    Caption = #346'roda'
    TabOrder = 4
    OnClick = D3Click
  end
  object D4: TBitBtn
    Left = 21
    Top = 120
    Width = 100
    Height = 22
    Caption = 'Czwartek'
    TabOrder = 5
    OnClick = D4Click
  end
  object D5: TBitBtn
    Left = 21
    Top = 144
    Width = 100
    Height = 22
    Caption = 'Pi'#261'tek'
    TabOrder = 6
    OnClick = D5Click
  end
  object D6: TBitBtn
    Left = 21
    Top = 168
    Width = 100
    Height = 22
    Caption = 'Sobota'
    TabOrder = 7
    OnClick = D6Click
  end
  object D7: TBitBtn
    Left = 21
    Top = 192
    Width = 100
    Height = 22
    Caption = 'Niedziela'
    TabOrder = 8
    OnClick = D7Click
  end
  object SelectDates: TPopupMenu
    Left = 160
    Top = 8
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
