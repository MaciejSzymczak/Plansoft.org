inherited FExclusiveParent: TFExclusiveParent
  Left = 434
  Top = 244
  Width = 803
  Height = 195
  Caption = 'Wybierz rodzaj relacji podrz'#281'dny - nadrz'#281'dny'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 144
    Width = 795
  end
  object exclusive_parent: TBitBtn
    Left = 8
    Top = 8
    Width = 305
    Height = 65
    Caption = 'Dwa poziomy'
    ModalResult = 6
    TabOrder = 1
  end
  object non_exclusive_parent: TBitBtn
    Left = 8
    Top = 80
    Width = 305
    Height = 57
    Caption = 'Dowolna liczba poziom'#243'w'
    ModalResult = 7
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 320
    Top = 8
    Width = 465
    Height = 65
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Przyk'#322'ad:'
      'Poziom 1: Kierunek'
      'Poziom 2: Wiele grup '#263'wiczeniowych'
      'Brak grup laboratoryjnych')
    ReadOnly = True
    TabOrder = 3
  end
  object Memo2: TMemo
    Left = 320
    Top = 80
    Width = 457
    Height = 57
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Przyk'#322'ad:'
      'Poziom 1: Kierunek'
      'Poziom 2: Wiele grup '#263'wiczeniowych'
      
        'Poziom 3: Wiele grup lab z'#322'o'#380'onych ze student'#243'w z r'#243#380'nych grup '#263 +
        'wiczeniowych')
    ReadOnly = True
    TabOrder = 4
  end
end
