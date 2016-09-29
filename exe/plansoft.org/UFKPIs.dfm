object FKPIs: TFKPIs
  Left = 387
  Top = 226
  BorderStyle = bsDialog
  Caption = 'Wska'#378'niki efektywno'#347'ci'
  ClientHeight = 241
  ClientWidth = 518
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
  object BClose: TSpeedButton
    Left = 448
    Top = 216
    Width = 65
    Height = 22
    Caption = 'Zamknij'
    Flat = True
    OnClick = BCloseClick
  end
  object BCreate: TSpeedButton
    Left = 326
    Top = 216
    Width = 111
    Height = 22
    Caption = 'Tw'#243'rz zestawienie'
    Flat = True
    OnClick = BCreateClick
  end
  object Button1: TButton
    Left = 224
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 209
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 264
      Top = 16
      Width = 68
      Height = 13
      Caption = 'Rodzaj okresu'
    end
    object Label2: TLabel
      Left = 256
      Top = 40
      Width = 74
      Height = 13
      Caption = 'Liczba okres'#243'w'
    end
    object Label3: TLabel
      Left = 208
      Top = 64
      Width = 123
      Height = 13
      Caption = 'Tylko pierwszych warto'#347'ci'
    end
    object Label4: TLabel
      Left = 264
      Top = 88
      Width = 65
      Height = 13
      Caption = 'Stan na dzie'#324
    end
    object periodType: TComboBox
      Left = 336
      Top = 8
      Width = 97
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 0
      Text = 'Rok'
      Items.Strings = (
        'Rok'
        'Kwarta'#322
        'Miesi'#261'c'
        'Tydzie'#324)
    end
    object periodCount: TEdit
      Left = 336
      Top = 32
      Width = 49
      Height = 21
      TabOrder = 1
      Text = '3'
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 193
      Height = 193
      Caption = 'Wylicz wska'#378'niki efektywno'#347'ci dla...'
      TabOrder = 2
      object Selector1: TComboBox
        Left = 8
        Top = 20
        Width = 177
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 0
        Text = 'Wyk'#322'adowcy'
        Items.Strings = (
          '<brak>'
          'Plani'#347'ci'
          'Wyk'#322'adowcy'
          'Grupy'
          'Zasoby'
          'Przedmioty'
          'Formy zaje'#263
          'Przedmioty + formy zaje'#263)
      end
      object Selector2: TComboBox
        Left = 8
        Top = 44
        Width = 177
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 3
        TabOrder = 1
        Text = 'Grupy'
        Items.Strings = (
          '<brak>'
          'Plani'#347'ci'
          'Wyk'#322'adowcy'
          'Grupy'
          'Zasoby'
          'Przedmioty'
          'Formy zaje'#263
          'Przedmioty + formy zaje'#263)
      end
      object Selector3: TComboBox
        Left = 8
        Top = 68
        Width = 177
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 4
        TabOrder = 2
        Text = 'Zasoby'
        Items.Strings = (
          '<brak>'
          'Plani'#347'ci'
          'Wyk'#322'adowcy'
          'Grupy'
          'Zasoby'
          'Przedmioty'
          'Formy zaje'#263
          'Przedmioty + formy zaje'#263)
      end
      object Selector4: TComboBox
        Left = 8
        Top = 92
        Width = 177
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 5
        TabOrder = 3
        Text = 'Przedmioty'
        Items.Strings = (
          '<brak>'
          'Plani'#347'ci'
          'Wyk'#322'adowcy'
          'Grupy'
          'Zasoby'
          'Przedmioty'
          'Formy zaje'#263
          'Przedmioty + formy zaje'#263)
      end
      object Selector5: TComboBox
        Left = 8
        Top = 116
        Width = 177
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 6
        TabOrder = 4
        Text = 'Formy zaje'#263
        Items.Strings = (
          '<brak>'
          'Plani'#347'ci'
          'Wyk'#322'adowcy'
          'Grupy'
          'Zasoby'
          'Przedmioty'
          'Formy zaje'#263
          'Przedmioty + formy zaje'#263)
      end
      object Selector6: TComboBox
        Left = 8
        Top = 140
        Width = 177
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 5
        Text = '<brak>'
        Items.Strings = (
          '<brak>'
          'Plani'#347'ci'
          'Wyk'#322'adowcy'
          'Grupy'
          'Zasoby'
          'Przedmioty'
          'Formy zaje'#263
          'Przedmioty + formy zaje'#263)
      end
      object Selector7: TComboBox
        Left = 8
        Top = 164
        Width = 177
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 6
        Text = '<brak>'
        Items.Strings = (
          '<brak>'
          'Plani'#347'ci'
          'Wyk'#322'adowcy'
          'Grupy'
          'Zasoby'
          'Przedmioty'
          'Formy zaje'#263
          'Przedmioty + formy zaje'#263)
      end
    end
    object TopValues: TEdit
      Left = 336
      Top = 56
      Width = 73
      Height = 21
      TabOrder = 3
      Text = '10'
    end
    object map: TMemo
      Left = 480
      Top = 16
      Width = 185
      Height = 89
      Lines.Strings = (
        'Rok=yyyy'
        'Kwarta'#322'=q'
        'Miesi'#261'c=rm'
        'Tydzie'#324'=w'
        '---------------'
        '<brak>='
        'Plani'#347'ci=P'
        'Wyk'#322'adowcy=L'
        'Grupy=G'
        'Zasoby=R'
        'Przedmioty=S'
        'Formy zaje'#263'=F'
        'Przedmioty + formy zaje'#263'=M')
      TabOrder = 4
      Visible = False
    end
    object asOfDate: TDateTimePicker
      Left = 336
      Top = 80
      Width = 97
      Height = 21
      Date = 41489.349999363420000000
      Time = 41489.349999363420000000
      TabOrder = 5
    end
    object showAll: TCheckBox
      Left = 208
      Top = 184
      Width = 321
      Height = 17
      Caption = 'Uwzgl'#281'dniaj wszystkie zaj'#281'cia (ignoruj uprawnienia dost'#281'pu)'
      TabOrder = 6
    end
  end
  object googleChart: TADOQuery
    Connection = DModule.ADOConnection
    Parameters = <>
    Left = 472
    Top = 120
  end
end
