inherited FFlexNewAttribute: TFFlexNewAttribute
  Left = 389
  Top = 209
  ActiveControl = EfieldCaption
  BorderStyle = bsDialog
  Caption = 'Nowy atrybut'
  ClientHeight = 475
  ClientWidth = 822
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 66
    Top = 46
    Width = 54
    Height = 16
    Alignment = taRightJustify
    Caption = 'Typ pola'
  end
  object Label2: TLabel [1]
    Left = 70
    Top = 18
    Width = 50
    Height = 16
    Alignment = taRightJustify
    Caption = 'Etykieta'
  end
  object EfieldType: TComboBox [2]
    Left = 128
    Top = 37
    Width = 239
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 1
    Text = 'Znaki'
    OnChange = EfieldTypeChange
    Items.Strings = (
      'Znaki'
      'Liczba'
      'Data')
  end
  object EfieldCaption: TEdit [3]
    Left = 128
    Top = 9
    Width = 239
    Height = 24
    TabOrder = 0
  end
  object ERequired: TCheckBox [4]
    Left = 375
    Top = 9
    Width = 239
    Height = 20
    Hint = 'Czy podanie warto'#347'ci w tym polu b'#281'dzie wymagane ?'
    Caption = 'Wymagane'
    TabOrder = 4
  end
  object ShowMore: TCheckBox [5]
    Left = 9
    Top = 73
    Width = 358
    Height = 20
    Caption = 'Poka'#380' wi'#281'cej funkcji'
    TabOrder = 5
    OnClick = ShowMoreClick
  end
  object Panel1: TPanel [6]
    Left = 0
    Top = 406
    Width = 822
    Height = 47
    Align = alBottom
    TabOrder = 3
    object BCancel: TBitBtn
      Left = 721
      Top = 9
      Width = 86
      Height = 29
      Caption = 'Anuluj'
      TabOrder = 0
      Kind = bkCancel
    end
    object BOk: TBitBtn
      Left = 630
      Top = 9
      Width = 85
      Height = 29
      TabOrder = 1
      Kind = bkOK
    end
  end
  inherited Status: TPanel
    Top = 453
    Width = 822
    TabOrder = 2
  end
  object advanced: TPanel
    Left = 0
    Top = 94
    Width = 822
    Height = 312
    Align = alBottom
    TabOrder = 6
    Visible = False
    object Label3: TLabel
      Left = 24
      Top = 18
      Width = 96
      Height = 16
      Alignment = taRightJustify
      Caption = 'Szeroko'#347#263' pola'
    end
    object Label4: TLabel
      Left = 5
      Top = 46
      Width = 115
      Height = 16
      Alignment = taRightJustify
      Caption = 'Warto'#347#263' domy'#347'lna'
    end
    object LDefaultValueD: TLabel
      Left = 128
      Top = 64
      Width = 72
      Height = 64
      Caption = 'Dobrze:'#13#10'2010.02.20'#13#10'Dzisiaj'#13#10'Dzisiaj - 1'
    end
    object LDefaultValueS: TLabel
      Left = 125
      Top = 64
      Width = 64
      Height = 48
      Caption = 'Przyk'#322'ady:'#13#10'ABCD'#13#10'G'#322#243'wny'
    end
    object LDefaultValueN: TLabel
      Left = 125
      Top = 64
      Width = 68
      Height = 48
      Caption = 'Dobrze:'#13#10'3.1415926'#13#10'15922,22'
    end
    object LDefaultValueD2: TLabel
      Left = 274
      Top = 64
      Width = 82
      Height = 64
      Caption = #377'le:'#13#10'02.20.2010'#13#10'Wczoraj'#13#10'Przedwczoraj'
    end
    object LDefaultValueN2: TLabel
      Left = 280
      Top = 64
      Width = 64
      Height = 32
      Caption = #377'le:'#13#10'15 922,22'
    end
    object Label7: TLabel
      Left = 18
      Top = 247
      Width = 121
      Height = 16
      Caption = 'W'#322'asna nazwa pola'
    end
    object Label8: TLabel
      Left = 337
      Top = 247
      Width = 444
      Height = 48
      Caption = 
        'Mo'#380'esz zostawi'#263' warto'#347#263' domy'#347'ln'#261'.'#13#10'Za pomoc'#261' tej nazwy mo'#380'esz od' +
        'wo'#322'ywa'#263' si'#281' do pola w formu'#322'ach SQL. '#13#10'Nie stosuj polskich znak'#243 +
        'w diakrytycznych, spacji itp. Maks. 30 znak'#243'w.'
    end
    object Label9: TLabel
      Left = 210
      Top = 18
      Width = 71
      Height = 16
      Caption = 'w punktach'
    end
    object ECustomName: TEdit
      Left = 153
      Top = 247
      Width = 168
      Height = 24
      TabOrder = 0
      Visible = False
    end
    object EfieldWidth: TEdit
      Left = 128
      Top = 9
      Width = 74
      Height = 24
      TabOrder = 1
      Text = '100'
    end
    object EDefaultValue: TEdit
      Left = 128
      Top = 37
      Width = 238
      Height = 24
      TabOrder = 2
    end
    object GroupBox1: TGroupBox
      Left = 9
      Top = 137
      Width = 768
      Height = 102
      Caption = 'Poprawno'#347#263' pola'
      TabOrder = 3
      object Label5: TLabel
        Left = 9
        Top = 22
        Width = 126
        Height = 16
        Caption = 'Komunikat o b'#322#281'dzie'
      end
      object Label6: TLabel
        Left = 9
        Top = 49
        Width = 52
        Height = 16
        Caption = 'Formu'#322'a'
      end
      object Help: TSpeedButton
        Left = 128
        Top = 67
        Width = 147
        Height = 26
        Caption = 'Pom'#243#380
        OnClick = HelpClick
      end
      object sql_check_message: TEdit
        Left = 168
        Top = 13
        Width = 586
        Height = 24
        TabOrder = 0
      end
      object sql_check_procedure: TEdit
        Left = 168
        Top = 40
        Width = 586
        Height = 24
        TabOrder = 1
      end
    end
  end
  object PopupMenu: TPopupMenu
    Left = 448
    Top = 8
    object dummy1: TMenuItem
      Caption = 'Dummy'
      OnClick = dummy1Click
    end
  end
end
