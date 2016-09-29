inherited FKPI: TFKPI
  Left = 261
  Top = 230
  Width = 214
  Height = 319
  Caption = 'KPI - Wska'#378'niki efektywno'#347'ci'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 266
    Width = 206
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 206
    Height = 225
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 311
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Rodzaj okresu'
    end
    object Label2: TLabel
      Left = 264
      Top = 40
      Width = 118
      Height = 14
      Caption = 'Liczba okres'#243'w wstecz'
    end
    object Label4: TLabel
      Left = 317
      Top = 88
      Width = 66
      Height = 14
      Caption = 'Stan na dzie'#324
    end
    object Label3: TLabel
      Left = 304
      Top = 112
      Width = 79
      Height = 14
      Caption = 'Rodzaj wykresu'
    end
    object Label5: TLabel
      Left = 227
      Top = 136
      Width = 157
      Height = 14
      Caption = 'Szeroko'#347#263' i wysoko'#347#263' wykresu'
    end
    object Label6: TLabel
      Left = 224
      Top = 160
      Width = 162
      Height = 14
      Caption = 'Roz'#322'o'#380'enie wykres'#243'w na ekranie'
    end
    object periodType: TComboBox
      Left = 389
      Top = 8
      Width = 132
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 3
      Text = 'Rok'
      Items.Strings = (
        'Rok'
        'Kwarta'#322
        'Miesi'#261'c'
        'Tydzie'#324)
    end
    object periodCount: TEdit
      Left = 389
      Top = 32
      Width = 49
      Height = 22
      TabOrder = 4
      Text = '1'
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 193
      Height = 193
      Caption = 'Wylicz wska'#378'niki efektywno'#347'ci dla...'
      TabOrder = 1
      object Selector1: TComboBox
        Left = 8
        Top = 20
        Width = 177
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        ItemIndex = 4
        TabOrder = 0
        Text = 'Zasoby'
        OnChange = Selector1Change
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
        ItemIndex = 0
        TabOrder = 1
        Text = '<brak>'
        OnChange = Selector1Change
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
        ItemIndex = 0
        TabOrder = 2
        Text = '<brak>'
        OnChange = Selector1Change
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
        ItemIndex = 0
        TabOrder = 3
        Text = '<brak>'
        OnChange = Selector1Change
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
        ItemIndex = 0
        TabOrder = 4
        Text = '<brak>'
        OnChange = Selector1Change
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
        OnChange = Selector1Change
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
        OnChange = Selector1Change
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
      Left = 389
      Top = 56
      Width = 73
      Height = 22
      TabOrder = 6
      Text = '20'
    end
    object map: TMemo
      Left = 576
      Top = 8
      Width = 81
      Height = 65
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
      TabOrder = 0
      Visible = False
      WordWrap = False
    end
    object asOfDate: TDateTimePicker
      Left = 389
      Top = 80
      Width = 97
      Height = 21
      Date = 41487.349999363420000000
      Time = 41487.349999363420000000
      TabOrder = 7
    end
    object showAll: TCheckBox
      Left = 208
      Top = 184
      Width = 321
      Height = 17
      Caption = 'Uwzgl'#281'dniaj wszystkie zaj'#281'cia (ignoruj uprawnienia dost'#281'pu)'
      TabOrder = 12
    end
    object adv: TCheckBox
      Left = 8
      Top = 203
      Width = 137
      Height = 17
      Caption = 'Tryb zaawansowany'
      TabOrder = 2
      OnClick = advClick
    end
    object rank_rownum: TComboBox
      Left = 209
      Top = 59
      Width = 177
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 5
      Text = 'Pierwszych warto'#347'ci- ranking'
      Items.Strings = (
        'Nie wi'#281'cej warto'#347'ci ni'#380
        'Pierwszych warto'#347'ci- ranking')
    end
    object pie_or_column: TComboBox
      Left = 389
      Top = 104
      Width = 132
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 8
      Text = 'Wykres kolumnowy'
      Items.Strings = (
        'Wykres ko'#322'owy'
        'Wykres kolumnowy')
    end
    object graph_width: TEdit
      Left = 389
      Top = 128
      Width = 49
      Height = 22
      TabOrder = 9
      Text = '800'
    end
    object graph_height: TEdit
      Left = 469
      Top = 128
      Width = 49
      Height = 22
      TabOrder = 10
      Text = '600'
    end
    object matrix_or_column: TComboBox
      Left = 389
      Top = 152
      Width = 132
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 11
      Text = 'Pionowo'
      Items.Strings = (
        'Poziomo'
        'Pionowo')
    end
  end
  object topPanel: TPanel
    Left = 0
    Top = 225
    Width = 206
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      206
      41)
    object BCreate: TSpeedButton
      Left = 4
      Top = 11
      Width = 111
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Tw'#243'rz zestawienie'
      Flat = True
      OnClick = BCreateClick
    end
    object BClose: TSpeedButton
      Left = 123
      Top = 11
      Width = 75
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Zamknij'
      Flat = True
      OnClick = BCloseClick
    end
  end
  object googleChart: TADOQuery
    AutoCalcFields = False
    Connection = DModule.ADOConnection
    CommandTimeout = 1000
    Parameters = <>
    Left = 576
    Top = 88
  end
end
