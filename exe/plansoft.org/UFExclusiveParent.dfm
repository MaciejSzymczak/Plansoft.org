inherited FExclusiveParent: TFExclusiveParent
  Left = 434
  Top = 244
  Width = 679
  Height = 195
  Caption = 'Wybierz rodzaj relacji podrz'#281'dny - nadrz'#281'dny'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 144
    Width = 671
  end
  object exclusive_parent: TBitBtn
    Left = 8
    Top = 8
    Width = 305
    Height = 65
    Caption = 'Jedna grupa nadrz'#281'dna'
    ModalResult = 6
    TabOrder = 1
  end
  object non_exclusive_parent: TBitBtn
    Left = 8
    Top = 80
    Width = 305
    Height = 57
    Caption = 'Wi'#281'cej ni'#380' jedna grupa nadrz'#281'dna'
    ModalResult = 7
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 320
    Top = 8
    Width = 345
    Height = 65
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Przyk'#322'ad:'
      'Grupa '#263'wiczeniowa - grupa rocznikowa.')
    ReadOnly = True
    TabOrder = 3
  end
  object Memo2: TMemo
    Left = 320
    Top = 80
    Width = 337
    Height = 57
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Przyk'#322'ad:'
      'grupa laboratoryjna sk'#322'adaj'#261'ca si'#281' z dw'#243'ch grup '#263'wiczeniowych.')
    ReadOnly = True
    TabOrder = 4
  end
end
