inherited FBrowseGRIDS: TFBrowseGRIDS
  Left = 303
  Top = 122
  Width = 788
  Caption = 'Siatka godzinowa'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Width = 780
  end
  inherited MainPage: TPageControl
    Width = 780
    ActivePage = Update
    inherited Browse: TTabSheet
      inherited TopPanel: TPanel
        Width = 772
      end
      inherited Grid: TRxDBGrid
        Top = 113
        Width = 772
        Height = 388
        Columns = <
          item
            Expanded = False
            FieldName = 'NO'
            Title.Caption = 'Nr'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CAPTION'
            Title.Caption = 'Etykieta'
            Width = 97
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'HOUR_FROM'
            Title.Caption = 'Godz. od'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'HOUR_TO'
            Title.Caption = 'Godz. do'
            Width = 62
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DURATION'
            Title.Caption = 'Trwanie'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'Kol. wpr.'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_01'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_02'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_03'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_04'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_05'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_06'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_07'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_08'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_09'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_10'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_11'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_12'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_13'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_14'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_15'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_01'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_02'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_03'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_04'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_05'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_06'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_07'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_08'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_09'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_10'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_11'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_12'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_13'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_14'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_15'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_01'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_02'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_03'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_04'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_05'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_06'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_07'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_08'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_09'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_10'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_11'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_12'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_13'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_14'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_15'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATED_BY'
            Title.Caption = 'Utworzy'#322
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATION_DATE'
            Title.Caption = 'Utworzono'
            Width = 116
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATE_DATE'
            Title.Caption = 'Zmieniono'
            Width = 97
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATED_BY'
            Title.Caption = 'Zmieni'#322
            Width = 118
            Visible = True
          end>
      end
      inherited BottomPanel: TPanel
        Width = 772
      end
      inherited Panel: TPanel
        Width = 772
        inherited StatusBar: TStatusBar
          Width = 703
        end
      end
      inherited CustomPanel: TPanel
        Width = 772
        Height = 26
        object bdelpopup: TSpeedButton
          Left = 4
          Top = 2
          Width = 144
          Height = 22
          Hint = 'Wi'#281'cej...'
          Caption = 'Utw'#243'rz typow'#261' siatk'#281
          Flat = True
          Glyph.Data = {
            56010000424D560100000000000036000000280000000A000000090000000100
            1800000000002001000000000000000000000000000000000000D8E9ECD8E9EC
            D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000D8E9ECD8E9EC
            D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000D8E9ECD8E9EC
            D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000D8E9ECD8E9EC
            D8E9ECD8E9ECD8E9EC000000D8E9ECD8E9ECD8E9ECD8E9EC0000D8E9ECD8E9EC
            D8E9ECD8E9EC000000000000000000D8E9ECD8E9ECD8E9EC0000D8E9ECD8E9EC
            D8E9EC000000000000000000000000000000D8E9ECD8E9EC0000D8E9ECD8E9EC
            D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000D8E9ECD8E9EC
            D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000D8E9ECD8E9EC
            D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC0000}
          OnClick = bdelpopupClick
        end
      end
      inherited SecondRatePanel: TPanel
        Width = 772
      end
    end
    inherited Update: TTabSheet
      object LabelNO: TLabel [0]
        Left = 46
        Top = 16
        Width = 11
        Height = 14
        Alignment = taRightJustify
        Caption = 'Nr'
        FocusControl = NO
      end
      object LabelCAPTION: TLabel [1]
        Left = 20
        Top = 40
        Width = 37
        Height = 14
        Alignment = taRightJustify
        Caption = 'Etykieta'
        FocusControl = CAPTION
      end
      object LabelHOUR_FROM: TLabel [2]
        Left = 13
        Top = 64
        Width = 44
        Height = 14
        Alignment = taRightJustify
        Caption = 'Godz. od'
        FocusControl = HOUR_FROM
      end
      object LabelHOUR_TO: TLabel [3]
        Left = 13
        Top = 88
        Width = 44
        Height = 14
        Alignment = taRightJustify
        Caption = 'Godz. do'
        FocusControl = HOUR_TO
      end
      object LabelDURATION: TLabel [4]
        Left = 17
        Top = 112
        Width = 40
        Height = 14
        Alignment = taRightJustify
        Caption = 'Trwanie'
        FocusControl = DURATION
      end
      inherited UpdPanel: TPanel
        Width = 772
        TabOrder = 6
      end
      inherited FlexPanel: TPanel
        TabOrder = 5
      end
      object NO: TDBEdit
        Left = 65
        Top = 8
        Width = 150
        Height = 22
        Hint = 'NR'
        DataField = 'NO'
        DataSource = Source
        MaxLength = 10
        TabOrder = 0
      end
      object CAPTION: TDBEdit
        Left = 65
        Top = 32
        Width = 150
        Height = 22
        Hint = 'ETYKIETA'
        DataField = 'CAPTION'
        DataSource = Source
        MaxLength = 50
        TabOrder = 1
      end
      object HOUR_FROM: TDBEdit
        Left = 65
        Top = 56
        Width = 75
        Height = 22
        Hint = 'GODZ. OD'
        DataField = 'HOUR_FROM'
        DataSource = Source
        MaxLength = 5
        TabOrder = 2
      end
      object HOUR_TO: TDBEdit
        Left = 65
        Top = 80
        Width = 75
        Height = 22
        Hint = 'GODZ. DO'
        DataField = 'HOUR_TO'
        DataSource = Source
        MaxLength = 5
        TabOrder = 3
      end
      object DURATION: TDBEdit
        Left = 65
        Top = 104
        Width = 150
        Height = 22
        Hint = 'TRWANIE'
        DataField = 'DURATION'
        DataSource = Source
        MaxLength = 10
        TabOrder = 4
      end
      object Memo2: TMemo
        Left = 224
        Top = 8
        Width = 529
        Height = 129
        BorderStyle = bsNone
        Color = clInfoBk
        Lines.Strings = (
          'Za pomoc'#261' tego okna mo'#380'esz zdefiniowa'#263' spos'#243'b numeracji zaj'#281#263'.'
          'Przyk'#322'adowe sposoby numeracji to:'
          '1, 2, 3, 4, 5, ...'
          '1-2, 3-4, 5-6, ...'
          'A, B, C, ...'
          'I, II, III, ...'
          ''
          
            'Warto'#347'ci z kolumn godz.od, godz.do s'#261' u'#380'ywane podczas eksportu d' +
            'anych do Google Kalendarz')
        ReadOnly = True
        TabOrder = 7
      end
    end
  end
  inherited Source: TDataSource
    Left = 384
    Top = 272
  end
  inherited PMenu: TPopupMenu
    Left = 488
    Top = 288
  end
  inherited GridLayout: TStrHolder
    Left = 592
  end
  inherited Messages: TStrHolder
    Left = 504
    Top = 136
  end
  inherited SearchTimer: TTimer
    Left = 448
    Top = 280
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    SQL.Strings = (
      'SELECT %TOPRECORDS * '
      'FROM GRIDS'
      'WHERE %CONDITIONALS AND %SEARCH'
      '%SORTORDER'
      '')
    Left = 340
    Top = 260
  end
  object CreateGrids: TPopupMenu
    Left = 60
    Top = 232
    object Co15min73021451: TMenuItem
      Caption = '7.30-21.45, co 15min'
      OnClick = Co15min73021451Click
    end
    object N12341: TMenuItem
      Caption = '1, 2, 3, 4 ...'
      OnClick = N12341Click
    end
    object N12342: TMenuItem
      Caption = '1-2, 3-4, ..'
      OnClick = N12342Click
    end
    object Importujpoprzednieustawienia1: TMenuItem
      Caption = 'Importuj poprzednie ustawienia'
      OnClick = Importujpoprzednieustawienia1Click
    end
  end
end
