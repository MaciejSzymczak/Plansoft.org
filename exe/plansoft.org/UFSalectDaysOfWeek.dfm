object FSelectDaysOfWeek: TFSelectDaysOfWeek
  Left = 754
  Top = 299
  BorderStyle = bsDialog
  Caption = 'Wyb'#243'r dni tygodnia'
  ClientHeight = 154
  ClientWidth = 183
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
  object SpeedButton1: TSpeedButton
    Left = 72
    Top = 128
    Width = 47
    Height = 22
    Caption = 'Ok'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 128
    Top = 128
    Width = 47
    Height = 22
    Caption = 'Anuluj'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object c2: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Poniedzia'#322'ek'
    TabOrder = 0
  end
  object c3: TCheckBox
    Left = 8
    Top = 24
    Width = 97
    Height = 17
    Caption = 'Wtorek'
    TabOrder = 1
  end
  object c4: TCheckBox
    Left = 8
    Top = 40
    Width = 97
    Height = 17
    Caption = #346'roda'
    TabOrder = 2
  end
  object c5: TCheckBox
    Left = 8
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Czwartek'
    TabOrder = 3
  end
  object c6: TCheckBox
    Left = 8
    Top = 72
    Width = 97
    Height = 17
    Caption = 'Pi'#261'tek'
    TabOrder = 4
  end
  object c7: TCheckBox
    Left = 8
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Sobota'
    TabOrder = 5
  end
  object c1: TCheckBox
    Left = 8
    Top = 104
    Width = 97
    Height = 17
    Caption = 'Niedziela'
    TabOrder = 6
  end
end
