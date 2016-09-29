inherited FFlexNewAttribute: TFFlexNewAttribute
  Left = 389
  Top = 209
  VertScrollBar.Range = 0
  ActiveControl = EfieldCaption
  BorderStyle = bsDialog
  Caption = 'Nowy atrybut'
  ClientHeight = 416
  ClientWidth = 648
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel [0]
    Left = 8
    Top = 40
    Width = 97
    Height = 14
    Alignment = taRightJustify
    Caption = 'Typ pola'
  end
  object Label2: TLabel [1]
    Left = 8
    Top = 16
    Width = 97
    Height = 14
    Alignment = taRightJustify
    Caption = 'Etykieta'
  end
  object EfieldType: TComboBox [2]
    Left = 112
    Top = 32
    Width = 209
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
    Left = 112
    Top = 8
    Width = 209
    Height = 22
    TabOrder = 0
  end
  object ERequired: TCheckBox [4]
    Left = 328
    Top = 8
    Width = 209
    Height = 17
    Hint = 'Czy podanie warto'#347'ci w tym polu b'#281'dzie wymagane ?'
    Caption = 'Wymagane'
    TabOrder = 4
  end
  object ShowMore: TCheckBox [5]
    Left = 8
    Top = 64
    Width = 313
    Height = 17
    Caption = 'Poka'#380' wi'#281'cej funkcji'
    TabOrder = 5
    OnClick = ShowMoreClick
  end
  object Panel1: TPanel [6]
    Left = 0
    Top = 356
    Width = 648
    Height = 41
    Align = alBottom
    TabOrder = 3
    object BCancel: TBitBtn
      Left = 568
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Anuluj'
      TabOrder = 0
      Kind = bkCancel
    end
    object BOk: TBitBtn
      Left = 488
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkOK
    end
  end
  inherited Status: TPanel
    Top = 397
    Width = 648
    TabOrder = 2
  end
  object advanced: TPanel
    Left = 0
    Top = 83
    Width = 648
    Height = 273
    Align = alBottom
    TabOrder = 6
    Visible = False
    object Label3: TLabel
      Left = 30
      Top = 16
      Width = 75
      Height = 14
      Alignment = taRightJustify
      Caption = 'Szeroko'#347#263' pola'
    end
    object Label4: TLabel
      Left = 15
      Top = 40
      Width = 90
      Height = 14
      Alignment = taRightJustify
      Caption = 'Warto'#347#263' domy'#347'lna'
    end
    object LDefaultValueD: TLabel
      Left = 112
      Top = 56
      Width = 54
      Height = 56
      Caption = 'Dobrze:'#13#10'2010.02.20'#13#10'Dzisiaj'#13#10'Dzisiaj - 1'
    end
    object LDefaultValueS: TLabel
      Left = 109
      Top = 56
      Width = 50
      Height = 42
      Caption = 'Przyk'#322'ady:'#13#10'ABCD'#13#10'G'#322#243'wny'
    end
    object LDefaultValueN: TLabel
      Left = 109
      Top = 56
      Width = 51
      Height = 42
      Caption = 'Dobrze:'#13#10'3.1415926'#13#10'15922,22'
    end
    object LDefaultValueD2: TLabel
      Left = 240
      Top = 56
      Width = 68
      Height = 56
      Caption = #377'le:'#13#10'02.20.2010'#13#10'Wczoraj'#13#10'Przedwczoraj'
    end
    object LDefaultValueN2: TLabel
      Left = 245
      Top = 56
      Width = 48
      Height = 28
      Caption = #377'le:'#13#10'15 922,22'
    end
    object Label7: TLabel
      Left = 16
      Top = 216
      Width = 96
      Height = 14
      Caption = 'W'#322'asna nazwa pola'
    end
    object Label8: TLabel
      Left = 288
      Top = 216
      Width = 356
      Height = 42
      Caption = 
        'Mo'#380'esz zostawi'#263' warto'#347#263' domy'#347'ln'#261'.'#13#10'Za pomoc'#261' tej nazwy mo'#380'esz od' +
        'wo'#322'ywa'#263' si'#281' do pola w formu'#322'ach SQL. '#13#10'Nie stosuj polskich znak'#243 +
        'w diakrytycznych, spacji itp. Maks. 30 znak'#243'w.'
    end
    object Label9: TLabel
      Left = 184
      Top = 16
      Width = 57
      Height = 14
      Caption = 'w punktach'
    end
    object ECustomName: TEdit
      Left = 120
      Top = 216
      Width = 161
      Height = 22
      TabOrder = 0
      Visible = False
    end
    object EfieldWidth: TEdit
      Left = 112
      Top = 8
      Width = 65
      Height = 22
      TabOrder = 1
      Text = '100'
    end
    object EDefaultValue: TEdit
      Left = 112
      Top = 32
      Width = 208
      Height = 22
      TabOrder = 2
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 120
      Width = 633
      Height = 89
      Caption = 'Poprawno'#347#263' pola'
      TabOrder = 3
      object Label5: TLabel
        Left = 8
        Top = 19
        Width = 95
        Height = 14
        Caption = 'Komunikat o b'#322#281'dzie'
      end
      object Label6: TLabel
        Left = 8
        Top = 43
        Width = 38
        Height = 14
        Caption = 'Formu'#322'a'
      end
      object Help: TSpeedButton
        Left = 112
        Top = 59
        Width = 129
        Height = 22
        Caption = 'Pom'#243#380
        OnClick = HelpClick
      end
      object sql_check_message: TEdit
        Left = 112
        Top = 11
        Width = 513
        Height = 22
        TabOrder = 0
      end
      object sql_check_procedure: TEdit
        Left = 112
        Top = 35
        Width = 513
        Height = 22
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
