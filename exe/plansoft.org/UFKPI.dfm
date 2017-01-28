inherited FKPI: TFKPI
  Left = 261
  Top = 230
  Width = 624
  Height = 371
  Caption = 'KPI - Wska'#378'niki efektywno'#347'ci'
  PixelsPerInch = 120
  TextHeight = 16
  inherited Status: TPanel
    Top = 312
    Width = 616
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 616
    Height = 265
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 355
      Top = 18
      Width = 90
      Height = 16
      Caption = 'Rodzaj okresu'
    end
    object Label2: TLabel
      Left = 302
      Top = 46
      Width = 141
      Height = 16
      Caption = 'Liczba okres'#243'w wstecz'
    end
    object Label4: TLabel
      Left = 362
      Top = 101
      Width = 86
      Height = 16
      Caption = 'Stan na dzie'#324
    end
    object Label3: TLabel
      Left = 347
      Top = 128
      Width = 98
      Height = 16
      Caption = 'Rodzaj wykresu'
    end
    object Label5: TLabel
      Left = 259
      Top = 155
      Width = 191
      Height = 16
      Caption = 'Szeroko'#347#263' i wysoko'#347#263' wykresu'
    end
    object Label6: TLabel
      Left = 256
      Top = 183
      Width = 203
      Height = 16
      Caption = 'Roz'#322'o'#380'enie wykres'#243'w na ekranie'
    end
    object periodType: TComboBox
      Left = 445
      Top = 9
      Width = 150
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
      Left = 445
      Top = 37
      Width = 56
      Height = 24
      TabOrder = 4
      Text = '1'
    end
    object GroupBox1: TGroupBox
      Left = 9
      Top = 9
      Width = 221
      Height = 221
      Caption = 'Wylicz wska'#378'niki efektywno'#347'ci dla...'
      TabOrder = 1
      object Selector1: TComboBox
        Left = 9
        Top = 23
        Width = 202
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
        Left = 9
        Top = 50
        Width = 202
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
        Left = 9
        Top = 78
        Width = 202
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
        Left = 9
        Top = 105
        Width = 202
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
        Left = 9
        Top = 133
        Width = 202
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
        Left = 9
        Top = 160
        Width = 202
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
        Left = 9
        Top = 187
        Width = 202
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
      Left = 445
      Top = 64
      Width = 83
      Height = 24
      TabOrder = 6
      Text = '20'
    end
    object map: TMemo
      Left = 658
      Top = 9
      Width = 93
      Height = 74
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
      Left = 445
      Top = 91
      Width = 110
      Height = 21
      Date = 41487.349999363420000000
      Time = 41487.349999363420000000
      TabOrder = 7
    end
    object showAll: TCheckBox
      Left = 238
      Top = 210
      Width = 367
      Height = 20
      Caption = 'Uwzgl'#281'dniaj wszystkie zaj'#281'cia (ignoruj uprawnienia dost'#281'pu)'
      TabOrder = 12
    end
    object adv: TCheckBox
      Left = 9
      Top = 232
      Width = 157
      Height = 19
      Caption = 'Tryb zaawansowany'
      TabOrder = 2
      OnClick = advClick
    end
    object rank_rownum: TComboBox
      Left = 239
      Top = 67
      Width = 202
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
      Left = 445
      Top = 119
      Width = 150
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
      Left = 445
      Top = 146
      Width = 56
      Height = 24
      TabOrder = 9
      Text = '800'
    end
    object graph_height: TEdit
      Left = 536
      Top = 146
      Width = 56
      Height = 24
      TabOrder = 10
      Text = '600'
    end
    object matrix_or_column: TComboBox
      Left = 445
      Top = 174
      Width = 150
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
    Top = 265
    Width = 616
    Height = 47
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      616
      47)
    object BCreate: TSpeedButton
      Left = 391
      Top = 13
      Width = 126
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Tw'#243'rz zestawienie'
      Flat = True
      OnClick = BCreateClick
    end
    object BClose: TSpeedButton
      Left = 527
      Top = 13
      Width = 85
      Height = 25
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
