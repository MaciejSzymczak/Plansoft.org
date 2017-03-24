inherited FActionTree: TFActionTree
  Left = 312
  Top = 209
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Co chcesz zrobi'#263'?'
  ClientHeight = 147
  ClientWidth = 198
  Position = poDesigned
  PixelsPerInch = 120
  TextHeight = 16
  object frame: TShape [0]
    Left = 0
    Top = 0
    Width = 175
    Height = 105
    Pen.Mode = pmMask
    Shape = stRoundRect
  end
  object Oprion2: TSpeedButton [1]
    Left = 2
    Top = 29
    Width = 169
    Height = 24
    Caption = 'Edytuj'
    Flat = True
    OnClick = Oprion2Click
  end
  object Option1: TSpeedButton [2]
    Left = 5
    Top = 5
    Width = 166
    Height = 24
    Caption = 'Przejd'#378' do rozk'#322'adu'
    Flat = True
    OnClick = Option1Click
  end
  object Option3: TSpeedButton [3]
    Left = 5
    Top = 53
    Width = 166
    Height = 24
    Caption = 'Podsumowanie'
    Flat = True
    OnClick = Option3Click
  end
  object SpeedButton1: TSpeedButton [4]
    Left = 5
    Top = 77
    Width = 166
    Height = 24
    Caption = 'Anuluj'
    Flat = True
    OnClick = SpeedButton1Click
  end
  inherited Status: TPanel
    Top = 125
    Width = 198
  end
end
