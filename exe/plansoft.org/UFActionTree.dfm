inherited FActionTree: TFActionTree
  Left = 312
  Top = 209
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Co chcesz zrobi'#263'?'
  ClientHeight = 129
  ClientWidth = 173
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 14
  object frame: TShape [0]
    Left = 0
    Top = 0
    Width = 153
    Height = 92
    Pen.Mode = pmMask
    Shape = stRoundRect
  end
  object Oprion2: TSpeedButton [1]
    Left = 2
    Top = 25
    Width = 148
    Height = 21
    Caption = 'Edytuj'
    Flat = True
    OnClick = Oprion2Click
  end
  object Option1: TSpeedButton [2]
    Left = 4
    Top = 4
    Width = 146
    Height = 21
    Caption = 'Przejd'#378' do rozk'#322'adu'
    Flat = True
    OnClick = Option1Click
  end
  object Option3: TSpeedButton [3]
    Left = 4
    Top = 46
    Width = 146
    Height = 21
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = Option3Click
  end
  object SpeedButton1: TSpeedButton [4]
    Left = 4
    Top = 67
    Width = 146
    Height = 21
    Caption = 'Anuluj'
    Flat = True
    OnClick = SpeedButton1Click
  end
  inherited Status: TPanel
    Top = 110
    Width = 173
  end
end
