inherited FBrowseVALUE_SETS: TFBrowseVALUE_SETS
  Left = 248
  Top = 114
  Width = 876
  Height = 638
  Caption = 'Zestawy warto'#347'ci'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 587
    Width = 868
  end
  inherited MainPage: TPageControl
    Width = 868
    Height = 587
    inherited Browse: TTabSheet
      object Splitter1: TSplitter [0]
        Left = 459
        Top = 95
        Height = 405
        Align = alRight
      end
      inherited TopPanel: TPanel
        Width = 860
      end
      inherited Grid: TRxDBGrid
        Width = 459
        Height = 405
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = 'Nazwa'
            Width = 222
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCRIPTION'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'SET_TYPE'
            Title.Caption = 'Typ  zestawu'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SQL_STATEMENT'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'CHECK_PROCEDURE'
            Title.Caption = 'Walidacja'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MIN_LENGTH'
            Title.Caption = 'Min.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MAX_LENGTH'
            Title.Caption = 'Maks.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'WHO_CREATION_DATE'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'WHO_LAST_UPDATE_DATE'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'WHO_CREATED_BY'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'WHO_LAST_UPDATED_BY'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'WHO_LAST_UPDATE_LOGIN'
            Visible = False
          end>
      end
      inherited BottomPanel: TPanel
        Top = 519
        Width = 860
      end
      inherited Panel: TPanel
        Top = 500
        Width = 860
        inherited StatusBar: TStatusBar
          Width = 791
        end
      end
      inherited CustomPanel: TPanel
        Width = 860
      end
      inherited SecondRatePanel: TPanel
        Width = 860
      end
      object PanelDetailsBackground: TPanel
        Left = 462
        Top = 95
        Width = 398
        Height = 405
        Align = alRight
        Caption = 'PanelDetailsBackground'
        TabOrder = 6
        object PanelDetails: TPanel
          Left = 1
          Top = 1
          Width = 396
          Height = 16
          Align = alTop
          Caption = '.'
          TabOrder = 0
        end
        object GridDetails: TRxDBGrid
          Left = 1
          Top = 17
          Width = 396
          Height = 387
          Align = alClient
          DataSource = DSDetails
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = [fsBold]
          OnDblClick = GridDetailsDblClick
          Columns = <
            item
              Expanded = False
              FieldName = 'CODE'
              Title.Caption = 'Kod'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MEANING'
              Title.Caption = 'Znaczenie'
              Width = 212
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ENABLED'
              Title.Caption = 'W'#322#261'czony'
              Visible = True
            end>
        end
      end
    end
    inherited Update: TTabSheet
      object LabelID: TLabel [0]
        Left = 664
        Top = 16
        Width = 170
        Height = 13
        Caption = 'Kol. wprowadzenia:..........................'
        FocusControl = ID
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object LabelNAME: TLabel [1]
        Left = 38
        Top = 40
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa zestawu'
        FocusControl = NAME
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LabelDESCRIPTION: TLabel [2]
        Left = 91
        Top = 64
        Width = 22
        Height = 14
        Alignment = taRightJustify
        Caption = 'Opis'
        FocusControl = DESCRIPTION
      end
      object LabelSET_TYPE: TLabel [3]
        Left = 53
        Top = 108
        Width = 60
        Height = 13
        Alignment = taRightJustify
        Caption = 'Typ zestawu'
        FocusControl = SET_TYPE
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LabelSQL_STATEMENT: TLabel [4]
        Left = 43
        Top = 132
        Width = 70
        Height = 14
        Alignment = taRightJustify
        Caption = 'Polecenie SQL'
        FocusControl = SQL_STATEMENT
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelCHECK_PROCEDURE: TLabel [5]
        Left = 8
        Top = 272
        Width = 104
        Height = 14
        Alignment = taRightJustify
        Caption = 'Dodatkowa walidacja'
        FocusControl = CHECK_PROCEDURE
      end
      object LabelMIN_LENGTH: TLabel [6]
        Left = 21
        Top = 296
        Width = 92
        Height = 14
        Alignment = taRightJustify
        Caption = 'Min.-maks. d'#322'ugo'#347#263
        FocusControl = MIN_LENGTH
      end
      object LabelWHO_CREATION_DATE: TLabel [7]
        Left = 33
        Top = 320
        Width = 80
        Height = 14
        Alignment = taRightJustify
        Caption = 'Data utworzenia'
        FocusControl = WHO_CREATION_DATE
      end
      object LabelWHO_LAST_UPDATE_DATE: TLabel [8]
        Left = 280
        Top = 320
        Width = 212
        Height = 14
        Caption = 'Data ostat. zmiany:........................................'
        FocusControl = WHO_LAST_UPDATE_DATE
      end
      object LabelWHO_CREATED_BY: TLabel [9]
        Left = 69
        Top = 344
        Width = 44
        Height = 14
        Alignment = taRightJustify
        Caption = 'Utworzy'#322
        FocusControl = WHO_CREATED_BY
      end
      object LabelWHO_LAST_UPDATED_BY: TLabel [10]
        Left = 280
        Top = 344
        Width = 232
        Height = 14
        Caption = 'Ostatnio zaktualizowa'#322':........................................'
        FocusControl = WHO_LAST_UPDATED_BY
      end
      object LabelWHO_LAST_UPDATE_LOGIN: TLabel [11]
        Left = 79
        Top = 368
        Width = 34
        Height = 14
        Alignment = taRightJustify
        Caption = 'ID sesji'
        FocusControl = WHO_LAST_UPDATE_LOGIN
      end
      object Label2: TLabel [12]
        Left = 424
        Top = 272
        Width = 306
        Height = 14
        Caption = 'Funkcja PL/SQL ( function NAME ( s varchar2 ) return varchar2'
      end
      object Label3: TLabel [13]
        Left = 424
        Top = 32
        Width = 188
        Height = 14
        Caption = 'Zaleca si'#281' u'#380'ywanie nazw angielskich'
      end
      inherited UpdPanel: TPanel
        Top = 523
        Width = 860
        TabOrder = 13
        inherited BUpdChild1: TBitBtn
          Caption = 'Warto'#347'ci'
          Visible = True
        end
      end
      inherited FlexPanel: TPanel
        Left = 728
        Top = 128
        TabOrder = 22
      end
      object ID: TDBEdit
        Left = 777
        Top = 8
        Width = 80
        Height = 24
        Hint = 'ID'
        Color = cl3DLight
        DataField = 'ID'
        DataSource = Source
        MaxLength = 10
        ReadOnly = True
        TabOrder = 0
        Visible = False
      end
      object NAME: TDBEdit
        Left = 121
        Top = 32
        Width = 300
        Height = 24
        Hint = 'NAZWA ZESTAWU'
        DataField = 'NAME'
        DataSource = Source
        TabOrder = 1
      end
      object DESCRIPTION: TDBMemo
        Left = 121
        Top = 56
        Width = 300
        Height = 41
        Hint = 'OPIS'
        DataField = 'DESCRIPTION'
        DataSource = Source
        TabOrder = 2
      end
      object SET_TYPE: TDBEdit
        Left = 121
        Top = 100
        Width = 88
        Height = 24
        Hint = 'TYP ZESTAWU'
        Color = cl3DLight
        DataField = 'SET_TYPE'
        DataSource = Source
        ReadOnly = True
        TabOrder = 3
        OnChange = SET_TYPEChange
      end
      object SQL_STATEMENT: TDBMemo
        Left = 121
        Top = 124
        Width = 300
        Height = 117
        Hint = 'POLECENIE SQL'
        DataField = 'SQL_STATEMENT'
        DataSource = Source
        TabOrder = 4
      end
      object CHECK_PROCEDURE: TDBEdit
        Left = 121
        Top = 264
        Width = 300
        Height = 24
        Hint = 'DODATKOWA WALIDACJA'
        DataField = 'CHECK_PROCEDURE'
        DataSource = Source
        TabOrder = 5
      end
      object MIN_LENGTH: TDBEdit
        Left = 121
        Top = 288
        Width = 150
        Height = 24
        Hint = 'MIN_LENGTH'
        DataField = 'MIN_LENGTH'
        DataSource = Source
        MaxLength = 10
        TabOrder = 6
      end
      object MAX_LENGTH: TDBEdit
        Left = 273
        Top = 288
        Width = 150
        Height = 24
        Hint = 'MAX_LENGTH'
        DataField = 'MAX_LENGTH'
        DataSource = Source
        MaxLength = 10
        TabOrder = 7
      end
      object WHO_CREATION_DATE: TDBDateEdit
        Left = 121
        Top = 312
        Width = 121
        Height = 21
        Hint = 'WHO_CREATION_DATE'
        DataField = 'WHO_CREATION_DATE'
        DataSource = Source
        ReadOnly = True
        Color = cl3DLight
        NumGlyphs = 2
        TabOrder = 8
      end
      object WHO_LAST_UPDATE_DATE: TDBDateEdit
        Left = 393
        Top = 312
        Width = 121
        Height = 21
        Hint = 'WHO_LAST_UPDATE_DATE'
        DataField = 'WHO_LAST_UPDATE_DATE'
        DataSource = Source
        ReadOnly = True
        Color = cl3DLight
        NumGlyphs = 2
        TabOrder = 9
      end
      object WHO_CREATED_BY: TDBEdit
        Left = 121
        Top = 336
        Width = 152
        Height = 24
        Hint = 'WHO_CREATED_BY'
        Color = cl3DLight
        DataField = 'WHO_CREATED_BY'
        DataSource = Source
        ReadOnly = True
        TabOrder = 10
      end
      object WHO_LAST_UPDATED_BY: TDBEdit
        Left = 393
        Top = 336
        Width = 152
        Height = 24
        Hint = 'WHO_LAST_UPDATED_BY'
        Color = cl3DLight
        DataField = 'WHO_LAST_UPDATED_BY'
        DataSource = Source
        ReadOnly = True
        TabOrder = 11
      end
      object WHO_LAST_UPDATE_LOGIN: TDBEdit
        Left = 121
        Top = 360
        Width = 150
        Height = 24
        Hint = 'WHO_LAST_UPDATE_LOGIN'
        Color = cl3DLight
        DataField = 'WHO_LAST_UPDATE_LOGIN'
        DataSource = Source
        MaxLength = 10
        ReadOnly = True
        TabOrder = 12
      end
      object BCHAR: TBitBtn
        Left = 224
        Top = 100
        Width = 75
        Height = 25
        Caption = 'CHAR'
        TabOrder = 14
        OnClick = BCHARClick
      end
      object BNUMBER: TBitBtn
        Left = 298
        Top = 100
        Width = 75
        Height = 25
        Caption = 'NUMBER'
        TabOrder = 15
        OnClick = BNUMBERClick
      end
      object BDATE: TBitBtn
        Left = 372
        Top = 100
        Width = 75
        Height = 25
        Caption = 'DATE'
        TabOrder = 16
        OnClick = BDATEClick
      end
      object BLOOKUP: TBitBtn
        Left = 446
        Top = 100
        Width = 75
        Height = 25
        Caption = 'LOOKUP'
        TabOrder = 17
        OnClick = BLOOKUPClick
      end
      object BSQL: TBitBtn
        Left = 520
        Top = 100
        Width = 75
        Height = 25
        Caption = 'SQL'
        TabOrder = 18
        OnClick = BSQLClick
      end
      object SQL_STATEMENT_INFO: TMemo
        Left = 424
        Top = 128
        Width = 289
        Height = 137
        Color = clInfoBk
        Lines.Strings = (
          'Wpisz zapytanie SQL w postaci:'
          ''
          'SELECT CODE,MEANING,DESCRIPTION FROM TABLE '
          '[WHERE :PARAMETER...]'
          '[ORDER BY ...]'
          ''
          'CODE - kod warto'#347'ci ( mo'#380'e by'#263'  znakowy lub numeryczny )'
          'MEANING - znaczenie - pole znakowe'
          'DESCRIPTION - opis - pole znakowe')
        ReadOnly = True
        TabOrder = 19
        WordWrap = False
      end
      object BitBtn1: TBitBtn
        Left = 594
        Top = 100
        Width = 75
        Height = 25
        Caption = 'TIME'
        TabOrder = 20
        OnClick = BitBtn1Click
      end
      object BcheckSyntax: TBitBtn
        Left = 306
        Top = 240
        Width = 115
        Height = 25
        Caption = 'Sprawd'#378' sk'#322'adni'#281
        TabOrder = 21
        OnClick = BcheckSyntaxClick
      end
    end
  end
  inherited Others: TStrHolder
    Capacity = 76
    StrData = (
      ''
      '4d494e5f4845494748543d2d31'
      '4d494e5f57494454483d2d31'
      '4c4546543d2d31'
      '544f503d2d31'
      '44656c657465486f744b65793d3436'
      '45646974486f744b65793d3133'
      '496e73657274486f744b65793d3435'
      '4368616e676546696c746572486f744b65793d313139'
      '436c656172536561726368486f744b65793d3332'
      '5570726177446f776e3d46616c7365'
      '50616e656c446f776e3d54727565'
      '53656172636853514c3d303d30'
      '466f726d43617074696f6e3d'
      '4558504f52545f44656661756c744578743d20747874'
      
        '4558504f52545f46696c7465723d506c696b692074656b73746f776520282a2e' +
        '747874297c2a2e5458547c57737a7973746b696520706c696b6920282a2e2a29' +
        '7c2a2e2a'
      '475249445f464f4e545f434841525345543d31'
      '475249445f464f4e545f434f4c4f523d30'
      '475249445f464f4e545f4845494748543d2d3131'
      '475249445f464f4e545f4e414d453d4d532053616e73205365726966'
      '475249445f464f4e545f50495443483d667044656661756c74'
      '475249445f464f4e545f53495a453d38'
      '475249445f464f4e545f5354594c453d30'
      '4b45594649454c443d4944'
      '4d6178466574636865733d3230303030'
      '53686f77496e666f49664d6178466574636865733d54727565'
      '436f6d626f536f72744f726465724974656d496e6465783d2d31'
      '4f4c454558504f5254434f4c554d4e533d'
      '4d61784e756d65724f665265636f726473496e477269643d32303030'
      '5365636f6e645261746550616e656c446f776e3d54727565'
      
        '414c4941533a415454524942535f30313d56414c55455f534554532e41545452' +
        '4942535f3031'
      
        '414c4941533a415454524942535f30323d56414c55455f534554532e41545452' +
        '4942535f3032'
      
        '414c4941533a415454524942535f30333d56414c55455f534554532e41545452' +
        '4942535f3033'
      
        '414c4941533a415454524942535f30343d56414c55455f534554532e41545452' +
        '4942535f3034'
      
        '414c4941533a415454524942535f30353d56414c55455f534554532e41545452' +
        '4942535f3035'
      
        '414c4941533a415454524942535f30363d56414c55455f534554532e41545452' +
        '4942535f3036'
      
        '414c4941533a415454524942535f30373d56414c55455f534554532e41545452' +
        '4942535f3037'
      
        '414c4941533a415454524942535f30383d56414c55455f534554532e41545452' +
        '4942535f3038'
      
        '414c4941533a415454524942535f30393d56414c55455f534554532e41545452' +
        '4942535f3039'
      
        '414c4941533a415454524942535f31303d56414c55455f534554532e41545452' +
        '4942535f3130'
      
        '414c4941533a415454524942535f31313d56414c55455f534554532e41545452' +
        '4942535f3131'
      
        '414c4941533a415454524942535f31323d56414c55455f534554532e41545452' +
        '4942535f3132'
      
        '414c4941533a415454524942535f31333d56414c55455f534554532e41545452' +
        '4942535f3133'
      
        '414c4941533a415454524942535f31343d56414c55455f534554532e41545452' +
        '4942535f3134'
      
        '414c4941533a415454524942535f31353d56414c55455f534554532e41545452' +
        '4942535f3135'
      
        '414c4941533a415454524942445f30313d56414c55455f534554532e41545452' +
        '4942445f3031'
      
        '414c4941533a415454524942445f30323d56414c55455f534554532e41545452' +
        '4942445f3032'
      
        '414c4941533a415454524942445f30333d56414c55455f534554532e41545452' +
        '4942445f3033'
      
        '414c4941533a415454524942445f30343d56414c55455f534554532e41545452' +
        '4942445f3034'
      
        '414c4941533a415454524942445f30353d56414c55455f534554532e41545452' +
        '4942445f3035'
      
        '414c4941533a415454524942445f30363d56414c55455f534554532e41545452' +
        '4942445f3036'
      
        '414c4941533a415454524942445f30373d56414c55455f534554532e41545452' +
        '4942445f3037'
      
        '414c4941533a415454524942445f30383d56414c55455f534554532e41545452' +
        '4942445f3038'
      
        '414c4941533a415454524942445f30393d56414c55455f534554532e41545452' +
        '4942445f3039'
      
        '414c4941533a415454524942445f31303d56414c55455f534554532e41545452' +
        '4942445f3130'
      
        '414c4941533a415454524942445f31313d56414c55455f534554532e41545452' +
        '4942445f3131'
      
        '414c4941533a415454524942445f31323d56414c55455f534554532e41545452' +
        '4942445f3132'
      
        '414c4941533a415454524942445f31333d56414c55455f534554532e41545452' +
        '4942445f3133'
      
        '414c4941533a415454524942445f31343d56414c55455f534554532e41545452' +
        '4942445f3134'
      
        '414c4941533a415454524942445f31353d56414c55455f534554532e41545452' +
        '4942445f3135'
      
        '414c4941533a4154545249424e5f30313d56414c55455f534554532e41545452' +
        '49424e5f3031'
      
        '414c4941533a4154545249424e5f30323d56414c55455f534554532e41545452' +
        '49424e5f3032'
      
        '414c4941533a4154545249424e5f30333d56414c55455f534554532e41545452' +
        '49424e5f3033'
      
        '414c4941533a4154545249424e5f30343d56414c55455f534554532e41545452' +
        '49424e5f3034'
      
        '414c4941533a4154545249424e5f30353d56414c55455f534554532e41545452' +
        '49424e5f3035'
      
        '414c4941533a4154545249424e5f30363d56414c55455f534554532e41545452' +
        '49424e5f3036'
      
        '414c4941533a4154545249424e5f30373d56414c55455f534554532e41545452' +
        '49424e5f3037'
      
        '414c4941533a4154545249424e5f30383d56414c55455f534554532e41545452' +
        '49424e5f3038'
      
        '414c4941533a4154545249424e5f30393d56414c55455f534554532e41545452' +
        '49424e5f3039'
      
        '414c4941533a4154545249424e5f31303d56414c55455f534554532e41545452' +
        '49424e5f3130'
      
        '414c4941533a4154545249424e5f31313d56414c55455f534554532e41545452' +
        '49424e5f3131'
      
        '414c4941533a4154545249424e5f31323d56414c55455f534554532e41545452' +
        '49424e5f3132'
      
        '414c4941533a4154545249424e5f31333d56414c55455f534554532e41545452' +
        '49424e5f3133'
      
        '414c4941533a4154545249424e5f31343d56414c55455f534554532e41545452' +
        '49424e5f3134'
      
        '414c4941533a4154545249424e5f31353d56414c55455f534554532e41545452' +
        '49424e5f313520')
  end
  inherited Query: TADOQuery
    AfterScroll = QueryAfterScroll
    SQL.Strings = (
      'SELECT %TOPRECORDS'
      ' ID     '
      ',NAME     '
      ',substr(DESCRIPTION,1,200)  DESCRIPTION'
      ',SET_TYPE           '
      ',substr(SQL_STATEMENT,1,200)  SQL_STATEMENT'
      ',CHECK_PROCEDURE     '
      ',MIN_LENGTH           '
      ',MAX_LENGTH          '
      ',who_creation_date   '
      ',who_last_update_date  '
      ',who_created_by    '
      ',who_last_updated_by  '
      ',who_last_update_login '
      'FROM VALUE_SETS'
      'WHERE %CONDITIONALS AND %SEARCH'
      '%SORTORDER')
    Top = 128
  end
  object DSDetails: TDataSource
    DataSet = QueryDetails
    Left = 744
    Top = 400
  end
  object TimerDetails: TTimer
    OnTimer = TimerDetailsTimer
    Left = 708
    Top = 398
  end
  object QueryDetails: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    Parameters = <
      item
        Name = 'value_set_id'
        DataType = ftString
        Size = 1
        Value = '0'
      end>
    SQL.Strings = (
      'select CODE,MEANING,DESCRIPTION,ENABLED '
      'from lookups '
      'where value_set_id= :value_set_id')
    Left = 666
    Top = 323
  end
end
