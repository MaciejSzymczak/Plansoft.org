inherited FExclusiveParent: TFExclusiveParent
  Left = 434
  Top = 244
  Width = 804
  Height = 238
  Caption = 'Wybierz rodzaj relacji podrz'#281'dny - nadrz'#281'dny'
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 8
    Top = 168
    Width = 531
    Height = 14
    Caption = 
      'Pamietaj, aby relacje utworzy'#263' przed planowaniem zaj'#281#263' i stara'#263' ' +
      'si'#281' nie zmienia'#263' relacji w trakcie planowania'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  inherited Status: TPanel
    Top = 187
    Width = 796
  end
  object exclusive_parent: TBitBtn
    Left = 8
    Top = 8
    Width = 305
    Height = 65
    Caption = 'ZAJ'#280'CIE   (Jedna grupa nadrz'#281'dna)'
    ModalResult = 6
    TabOrder = 1
  end
  object non_exclusive_parent: TBitBtn
    Left = 8
    Top = 80
    Width = 305
    Height = 57
    Caption = 'ODNO'#346'NIK    (Wi'#281'cej ni'#380' jedna grupa nadrz'#281'dna)'
    ModalResult = 7
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 144
    Width = 473
    Height = 17
    Caption = 
      'Nie zezwalaj na konflikty pomiedzy obiektem nadrzednym i podrzed' +
      'nym'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 3
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
      'Grupa '#263'wiczeniowa - grupa rocznikowa.')
    ReadOnly = True
    TabOrder = 4
  end
  object Memo2: TMemo
    Left = 320
    Top = 80
    Width = 465
    Height = 57
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Przyk'#322'ad:'
      'grupa laboratoryjna sk'#322'adaj'#261'ca si'#281' z dw'#243'ch grup '#263'wiczeniowych.')
    ReadOnly = True
    TabOrder = 5
  end
end
