inherited FBrowseCLASSES: TFBrowseCLASSES
  Left = 184
  Top = 152
  Width = 1134
  Caption = 'Zaj'#281'cia'
  PixelsPerInch = 120
  TextHeight = 16
  inherited Status: TPanel
    Width = 1126
  end
  inherited MainPage: TPageControl
    Width = 1126
    inherited Browse: TTabSheet
      inherited TopPanel: TPanel
        Width = 1118
        object Label1: TLabel [5]
          Left = 806
          Top = 8
          Width = 222
          Height = 16
          Caption = 'Czy zaplanowane w dniach wolnych'
        end
        object DelOrph: TBitBtn
          Left = 672
          Top = 3
          Width = 121
          Height = 25
          Caption = 'Usu'#324' nie powi'#261'zane'
          TabOrder = 11
          OnClick = DelOrphClick
        end
        object ConflictWithReservations: TComboBox
          Left = 805
          Top = 22
          Width = 188
          Height = 22
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          ItemIndex = 0
          MaxLength = 255
          TabOrder = 12
          Text = 'Bez znaczenia'
          OnChange = ConflictWithReservationsChange
          Items.Strings = (
            'Bez znaczenia'
            'Tak'
            'Nie')
        end
      end
      inherited Grid: TRxDBGrid
        Top = 241
        Width = 1118
        Height = 250
        Columns = <
          item
            Expanded = False
            FieldName = 'OPERATION_FLAG'
            Title.Caption = 'Operacja'
            Width = 97
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EFFECTIVE_START_DATE'
            Title.Caption = 'Data obow. od'
            Width = 114
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EFFECTIVE_END_DATE'
            Title.Caption = 'Data obow. do'
            Width = 111
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SUB_NAME'
            Title.Caption = 'Przedmiot'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FRM_NAME'
            Title.Caption = 'Forma'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DAY'
            Title.Caption = 'Dzie'#324
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DAY_OF_WEEK'
            Title.Caption = 'Dzie'#324' tyg.'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DAY_MONTH'
            Title.Caption = 'Miesi'#261'c'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'HOUR'
            Title.Caption = 'Godzina'
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALC_LECTURERS'
            Title.Caption = 'Wyk'#322'adowcy'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALC_GROUPS'
            Title.Caption = 'Grupy'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALC_ROOMS'
            Title.Caption = 'Zasoby'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FILL'
            Title.Caption = 'Wyp.'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATION_DATE'
            Title.Caption = 'Utworzono'
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATED_BY'
            Title.Caption = 'Utworzy'#322
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OWNER'
            Title.Caption = 'W'#322'a'#347'ciciel'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OUL_NAME'
            Title.Caption = 'Jednostka wyk'#322'adowcy'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OUG_NAME'
            Title.Caption = 'Jednostka grupy'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OUS_NAME'
            Title.Caption = 'Jednostka przedmiotu'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OUR_NAME'
            Title.Caption = 'Jednostka zasobu'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESC1'
            Title.Caption = 'Opis1'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESC2'
            Title.Caption = 'Opis2'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESC3'
            Title.Caption = 'Opis3'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESC4'
            Title.Caption = 'Opis4'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ID'
            Width = 0
            Visible = True
          end>
      end
      inherited BottomPanel: TPanel
        Width = 1118
      end
      inherited Panel: TPanel
        Width = 1118
        inherited StatusBar: TStatusBar
          Width = 1049
        end
      end
      inherited CustomPanel: TPanel
        Top = 97
        Width = 1118
        Height = 144
        inline GenericFilter: TFGenericFilter
          Left = 1
          Top = 42
          Width = 1430
          Height = 103
          TabOrder = 1
          inherited bClearS: TSpeedButton
            Top = 61
            OnClick = GenericFilterbClearSClick
          end
          inherited bClearF: TSpeedButton
            Top = 61
            OnClick = GenericFilterbClearFClick
          end
          inherited bClearL: TSpeedButton
            OnClick = GenericFilterbClearLClick
          end
          inherited bClearG: TSpeedButton
            OnClick = GenericFilterbClearGClick
          end
          inherited bClearPeriod: TSpeedButton
            Top = 61
            OnClick = GenericFilterbClearPeriodClick
          end
          inherited bClearRes0: TSpeedButton
            OnClick = GenericFilterbClearRes0Click
          end
          inherited bClearRes1: TSpeedButton
            OnClick = GenericFilterbClearRes1Click
          end
          inherited bClearPlanner: TSpeedButton
            Top = 61
          end
          inherited conl: TEdit
            OnChange = FGenericFilter1conlChange
          end
          inherited cong: TEdit
            OnChange = GenericFiltercongChange
          end
          inherited conResCat0: TEdit
            OnChange = GenericFilterconResCat0Change
          end
          inherited conResCat1: TEdit
            OnChange = GenericFilterconResCat1Change
          end
          inherited cons: TEdit
            Top = 62
            OnChange = GenericFilterconsChange
          end
          inherited cons_value: TEdit
            Top = 62
          end
          inherited conf: TEdit
            Top = 62
            OnChange = GenericFilterconfChange
          end
          inherited conf_value: TEdit
            Top = 62
          end
          inherited conPeriod: TEdit
            Top = 62
            OnChange = GenericFilterconPerChange
          end
          inherited conperiod_value: TEdit
            Top = 62
          end
          inherited conPla: TEdit
            Top = 62
            OnChange = GenericFilterconPlaChange
          end
          inherited conPla_value: TEdit
            Top = 62
          end
          inherited ShowL: TEdit
            Height = 15
          end
          inherited ShowG: TEdit
            Height = 15
          end
          inherited ShowResCat0: TEdit
            Height = 15
          end
          inherited ShowRESCAT1: TEdit
            Height = 15
          end
          inherited ShowS: TEdit
            Top = 44
            Height = 15
          end
          inherited ShowForm: TEdit
            Top = 44
            Height = 15
          end
          inherited ShowPeriod: TEdit
            Top = 44
            Height = 15
          end
          inherited ShowPlanner: TEdit
            Top = 44
            Height = 15
          end
          inherited PERPopup: TPopupMenu
            Top = 52
            inherited mipe: TMenuItem
              OnClick = GenericFilterFiltrprosty1Click
            end
            inherited mipa: TMenuItem
              OnClick = GenericFilterFiltrzaawansowany1Click
            end
          end
          inherited LPopup: TPopupMenu
            Top = 12
            inherited mile: TMenuItem
              OnClick = GenericFilterMenuItem5Click
            end
            inherited mila: TMenuItem
              OnClick = GenericFilterMenuItem6Click
            end
          end
          inherited GPopup: TPopupMenu
            Top = 12
            inherited mige: TMenuItem
              OnClick = GenericFilterMenuItem7Click
            end
            inherited miga: TMenuItem
              OnClick = GenericFilterMenuItem8Click
            end
          end
          inherited R0Popup: TPopupMenu
            Top = 12
            inherited mir0e: TMenuItem
              OnClick = GenericFiltermir0eClick
            end
            inherited mir0a: TMenuItem
              OnClick = GenericFiltermir0aClick
            end
          end
          inherited SPopup: TPopupMenu
            Top = 52
            inherited mise: TMenuItem
              OnClick = GenericFilterMenuItem11Click
            end
            inherited misa: TMenuItem
              OnClick = GenericFilterMenuItem12Click
            end
          end
          inherited FPopup: TPopupMenu
            inherited mife: TMenuItem
              OnClick = GenericFilterMenuItem13Click
            end
            inherited mifa: TMenuItem
              OnClick = GenericFilterMenuItem14Click
            end
          end
          inherited R1Popup: TPopupMenu
            Top = 12
            inherited mir1e: TMenuItem
              OnClick = GenericFiltermir1eClick
            end
            inherited mir1a: TMenuItem
              OnClick = GenericFiltermir1aClick
            end
          end
        end
        object PanelHistory: TPanel
          Left = 1
          Top = 1
          Width = 1116
          Height = 41
          Align = alTop
          TabOrder = 0
          object historyLabel: TLabel
            Left = 427
            Top = 6
            Width = 16
            Height = 16
            Caption = 'do'
          end
          object Label2: TLabel
            Left = 8
            Top = 6
            Width = 95
            Height = 16
            Caption = 'Historia zmian: '
          end
          object historyFrom: TDateEdit
            Left = 296
            Top = 6
            Width = 121
            Height = 21
            NumGlyphs = 2
            TabOrder = 0
            OnChange = historyFromChange
          end
          object historyTo: TDateEdit
            Left = 448
            Top = 6
            Width = 121
            Height = 21
            NumGlyphs = 2
            TabOrder = 1
            OnChange = historyToChange
          end
          object HistoryMode: TComboBox
            Left = 109
            Top = 6
            Width = 173
            Height = 22
            Style = csOwnerDrawFixed
            DropDownCount = 25
            ItemHeight = 16
            ItemIndex = 0
            MaxLength = 255
            TabOrder = 2
            Text = 'Wszystkie zmiany'
            OnChange = ComboSortOrderChange
            Items.Strings = (
              'Wszystkie zmiany'
              'Stan na dzie'#324
              'Zmiany z dzisiaj'
              'Zmiany z wczoraj'
              'Zmiany z przedwczoraj'
              'Zmiany - ostatnie 3 dni'
              'Zmiany - ostatnich 7 dni'
              'Zmiany - ostatnich 14 dni'
              'Zmiany - ostatnich 30 dni'
              'Zmiany w innym okresie')
          end
        end
        object FDAY: TDateEdit
          Left = 936
          Top = 66
          Width = 121
          Height = 21
          NumGlyphs = 2
          TabOrder = 2
          OnChange = FDAYChange
        end
        object ShowRESCAT1: TEdit
          Left = 936
          Top = 44
          Width = 121
          Height = 15
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          ReadOnly = True
          TabOrder = 3
          Text = 'Dzie'#324' i zaj'#281'cia'
        end
        object FHOUR: TComboBox
          Left = 1056
          Top = 66
          Width = 42
          Height = 22
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 4
          OnChange = FDAYChange
          Items.Strings = (
            ''
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12'
            '13'
            '14'
            '15'
            '16'
            '17'
            '18'
            '19'
            '20'
            '21'
            '22'
            '23'
            '24'
            '25'
            '26'
            '27'
            '28'
            '29'
            '30'
            '31'
            '32'
            '33'
            '34'
            '35'
            '36'
            '37'
            '38'
            '39'
            '40'
            '41'
            '42'
            '43'
            '44'
            '45'
            '46'
            '47'
            '48'
            '49'
            '50'
            '51'
            '52'
            '53'
            '54'
            '55'
            '56'
            '57'
            '58'
            '59'
            '60')
        end
        object ChSelectedDates: TCheckBox
          Left = 936
          Top = 90
          Width = 273
          Height = 17
          Caption = 'Terminy zaznaczone w siatce'
          TabOrder = 5
          OnClick = ChSelectedDatesClick
        end
      end
      inherited SecondRatePanel: TPanel
        Width = 1118
        Height = 40
      end
      object fastQueryString: TMemo
        Left = 336
        Top = 352
        Width = 185
        Height = 89
        Lines.Strings = (
          '('
          
            '(LEC_CLA.LEC_ID in (select m.id from lecturers m, org_units o wh' +
            'ere m.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(uppe' +
            'r(o.name||m.abbreviation||m.title||m.first_name||m.last_name||m.' +
            'email|| m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||' +
            'm.attribs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attrib' +
            's_09||m.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.' +
            'attribs_14||m.attribs_15)) like '#39'%var1%'#39'))) OR'
          
            '(GRO_CLA.GRO_ID in (select m.id from groups m, org_units o where' +
            ' m.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(upper(o' +
            '.name||m.name||m.abbreviation||m.email||m.desc1||m.desc2||m.attr' +
            'ibs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||' +
            'm.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attrib' +
            's_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.' +
            'attribs_15)) like '#39'%var2%'#39' ))) OR'
          
            '(ROM_CLA.ROM_ID in (select m.id from rooms m, org_units o where ' +
            'm.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(upper(o.' +
            'name||m.name||m.desc1||m.desc2||m.attribs_01||m.email|| m.attrib' +
            's_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.' +
            'attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_' +
            '10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.at' +
            'tribs_15)) like '#39'%var3%'#39'))) OR'
          
            '(CLASSES.SUB_ID in (select m.id from subjects m, org_units o whe' +
            're m.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(upper' +
            '(o.name||m.abbreviation||m.desc1||m.desc2||m.name|| m.attribs_01' +
            '||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.attr' +
            'ibs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_10||' +
            'm.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.attrib' +
            's_15)) like '#39'%var4%'#39' ))) OR'
          
            '(CLASSES.FOR_ID in (select m.id from forms m where (xxmsz_tools.' +
            'erasePolishChars(upper(m.abbreviation||m.desc1||m.desc2||m.name|' +
            '|m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attri' +
            'bs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m' +
            '.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs' +
            '_14||m.attribs_15)) like '#39'%var5%'#39' ))) OR'
          
            '(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC1)) like '#39'%var6%' +
            #39') OR'
          
            '(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC2)) like '#39'%var7%' +
            #39') OR'
          
            '(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC3)) like '#39'%var8%' +
            #39') OR'
          
            '(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC4)) like '#39'%var9%' +
            #39')'
          ')'
          '')
        TabOrder = 6
        Visible = False
        WordWrap = False
      end
    end
    inherited Update: TTabSheet
      object LabelID: TLabel [0]
        Left = 832
        Top = 16
        Width = 217
        Height = 16
        Caption = 'Kol. wpr.:........................................'
        FocusControl = _ID
        Visible = False
      end
      object LabelDAY: TLabel [1]
        Left = 8
        Top = 40
        Width = 35
        Height = 16
        Caption = 'Dzie'#324
        FocusControl = DAY
      end
      object LabelHOUR: TLabel [2]
        Left = 8
        Top = 64
        Width = 52
        Height = 16
        Caption = 'Godzina'
        FocusControl = HOUR
      end
      object LabelCALC_LECTURERS: TLabel [3]
        Left = 8
        Top = 88
        Width = 77
        Height = 16
        Caption = 'Wyk'#322'adowcy'
        FocusControl = CALC_LECTURERS
      end
      object LabelCALC_GROUPS: TLabel [4]
        Left = 8
        Top = 112
        Width = 39
        Height = 16
        Caption = 'Grupy'
        FocusControl = CALC_GROUPS
      end
      object LabelCALC_ROOMS: TLabel [5]
        Left = 8
        Top = 136
        Width = 84
        Height = 16
        Caption = 'Sale / zasoby'
        FocusControl = CALC_ROOMS
      end
      object LabelSUB_ID: TLabel [6]
        Left = 8
        Top = 160
        Width = 226
        Height = 16
        Caption = 'Przedmiot:........................................'
        FocusControl = SUB_ID
      end
      object LabelFOR_ID: TLabel [7]
        Left = 8
        Top = 184
        Width = 205
        Height = 16
        Caption = 'Forma:........................................'
        FocusControl = FOR_ID
      end
      object LabelFILL: TLabel [8]
        Left = 8
        Top = 208
        Width = 241
        Height = 16
        Caption = 'Wype'#322'nienie:........................................'
        FocusControl = FILL
      end
      object LabelDESC1: TLabel [9]
        Left = 8
        Top = 232
        Width = 205
        Height = 16
        Caption = 'Opis 1:........................................'
        FocusControl = DESC1
      end
      object LabelDESC2: TLabel [10]
        Left = 8
        Top = 256
        Width = 205
        Height = 16
        Caption = 'Opis 2:........................................'
        FocusControl = DESC2
      end
      inherited UpdPanel: TPanel
        Width = 1118
      end
      inherited FlexPanel: TPanel
        TabOrder = 12
      end
      object _ID: TDBEdit
        Left = 945
        Top = 8
        Width = 150
        Height = 24
        Hint = 'ID'
        DataField = 'ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 1
        Visible = False
      end
      object DAY: TDBDateEdit
        Left = 121
        Top = 32
        Width = 121
        Height = 21
        Hint = 'DAY'
        DataField = 'DAY'
        DataSource = Source
        NumGlyphs = 2
        TabOrder = 2
      end
      object HOUR: TDBEdit
        Left = 121
        Top = 56
        Width = 150
        Height = 24
        Hint = 'HOUR'
        DataField = 'HOUR'
        DataSource = Source
        MaxLength = 10
        TabOrder = 3
      end
      object CALC_LECTURERS: TDBEdit
        Left = 121
        Top = 80
        Width = 300
        Height = 24
        Hint = 'CALC_LECTURERS'
        DataField = 'CALC_LECTURERS'
        DataSource = Source
        TabOrder = 4
      end
      object CALC_GROUPS: TDBEdit
        Left = 121
        Top = 104
        Width = 300
        Height = 24
        Hint = 'CALC_GROUPS'
        DataField = 'CALC_GROUPS'
        DataSource = Source
        TabOrder = 5
      end
      object CALC_ROOMS: TDBEdit
        Left = 121
        Top = 128
        Width = 300
        Height = 24
        Hint = 'CALC_ROOMS'
        DataField = 'CALC_ROOMS'
        DataSource = Source
        TabOrder = 6
      end
      object SUB_ID: TDBEdit
        Left = 121
        Top = 152
        Width = 150
        Height = 24
        Hint = 'SUB_ID'
        DataField = 'SUB_ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 7
      end
      object FOR_ID: TDBEdit
        Left = 121
        Top = 176
        Width = 150
        Height = 24
        Hint = 'FOR_ID'
        DataField = 'FOR_ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 8
      end
      object FILL: TDBEdit
        Left = 121
        Top = 200
        Width = 150
        Height = 24
        Hint = 'FILL'
        DataField = 'FILL'
        DataSource = Source
        MaxLength = 10
        TabOrder = 9
      end
      object DESC1: TDBEdit
        Left = 121
        Top = 224
        Width = 300
        Height = 24
        Hint = 'DESC1'
        DataField = 'DESC1'
        DataSource = Source
        TabOrder = 10
      end
      object DESC2: TDBEdit
        Left = 121
        Top = 248
        Width = 300
        Height = 24
        Hint = 'DESC2'
        DataField = 'DESC2'
        DataSource = Source
        TabOrder = 11
      end
    end
  end
  inherited Source: TDataSource
    Left = 528
    Top = 24
  end
  inherited PMenu: TPopupMenu
    Left = 472
    Top = 104
  end
  inherited HolderSortOrder: TStrHolder
    Capacity = 12
    Left = 640
    Top = 336
    StrData = (
      ''
      
        '5355425f4e414d457c50727a65646d696f747c43415445474f52593a44454641' +
        '554c54'
      '46524d5f4e414d457c466f726d617c43415445474f52593a44454641554c54'
      
        '434f4e43415428746f5f63686172284441592c27797979792d6d6d2d64642729' +
        '2c484f55522920444553437c447a6965f1206920476f647a696e61206d616c65' +
        '6ab9636f7c43415445474f52593a44454641554c54'
      
        '746f5f6368617228434c41535345532e4441592c27647927297c447a6965f120' +
        '7479676f646e69617c43415445474f52593a44454641554c54'
      
        '43414c435f4c45435455524552537c57796bb361646f7763797c43415445474f' +
        '52593a44454641554c54'
      
        '43414c435f47524f5550537c47727570797c43415445474f52593a4445464155' +
        '4c54'
      
        '43414c435f524f4f4d537c5a61736f62797c43415445474f52593a4445464155' +
        '4c54'
      
        '46494c4c7c57797065b36e69656e69657c43415445474f52593a44454641554c' +
        '54'
      '44455343317c4f706973317c43415445474f52593a44454641554c54'
      '44455343327c4f706973327c43415445474f52593a44454641554c54'
      '44455343337c4f706973337c43415445474f52593a44454641554c54'
      '44455343347c4f706973347c43415445474f52593a44454641554c54')
  end
  inherited GridLayout: TStrHolder
    Left = 592
    Top = 336
  end
  inherited Komunikaty: TStrHolder
    Left = 200
    Top = 224
  end
  inherited ConditionsWhereClause: TStrHolder
    Left = 648
    Top = 376
  end
  inherited AvailColumnsWhereClause: TStrHolder
    Capacity = 28
    Sorted = False
    Left = 576
    Top = 376
    StrData = (
      ''
      '447a6965f17c4441597c667444617465'
      
        '447a6965f1207479676f646e69617c746f5f6368617228434c41535345532e44' +
        '41592c27647927297c6674537472696e67'
      '466f726d617c46524d2e4e414d457c6674537472696e67'
      '476f647a696e617c484f55527c6674466c6f6174'
      '50727a65646d696f747c5355422e4e414d457c6674537472696e67'
      '57797065b36e69656e69657c46494c4c7c6674466c6f6174'
      '4f706973317c434c41535345532e44455343317c6674537472696e67'
      '4f706973327c434c41535345532e44455343327c6674537472696e67'
      '4f706973337c434c41535345532e44455343337c6674537472696e67'
      '4f706973347c434c41535345532e44455343347c6674537472696e67'
      
        '486973746f726961207a6d69616e3a204f70657261636a617c434c4153534553' +
        '2e4f5045524154494f4e5f464c41477c6674537472696e67'
      
        '486973746f726961207a6d69616e3a2044617461206f626f772e206f647c434c' +
        '41535345532e4546464543544956455f53544152545f444154457c6674446174' +
        '65'
      
        '486973746f726961207a6d69616e3a2044617461206f626f772e20646f7c434c' +
        '41535345532e4546464543544956455f454e445f444154457c667444617465')
  end
  inherited Others: TStrHolder
    Capacity = 95
    Left = 616
    Top = 384
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
      '4d6178466574636865733d3130303030'
      '53686f77496e666f49664d6178466574636865733d54727565'
      '436f6d626f536f72744f726465724974656d496e6465783d2d31'
      '4f4c454558504f5254434f4c554d4e533d'
      '4d61784e756d65724f665265636f726473496e477269643d32303030'
      '5365636f6e645261746550616e656c446f776e3d54727565'
      '414c4941533a5355425f4e414d453d5355422e4e414d45'
      '414c4941533a46524d5f4e414d453d46524d2e4e414d45'
      '414c4941533a44455343313d434c41535345532e4445534331'
      '414c4941533a44455343323d434c41535345532e4445534332'
      '414c4941533a44455343333d434c41535345532e4445534333'
      '414c4941533a44455343343d434c41535345532e4445534334'
      
        '414c4941533a415454524942535f30313d434c41535345532e41545452494253' +
        '5f3031'
      
        '414c4941533a415454524942535f30323d434c41535345532e41545452494253' +
        '5f3032'
      
        '414c4941533a415454524942535f30333d434c41535345532e41545452494253' +
        '5f3033'
      
        '414c4941533a415454524942535f30343d434c41535345532e41545452494253' +
        '5f3034'
      
        '414c4941533a415454524942535f30353d434c41535345532e41545452494253' +
        '5f3035'
      
        '414c4941533a415454524942535f30363d434c41535345532e41545452494253' +
        '5f3036'
      
        '414c4941533a415454524942535f30373d434c41535345532e41545452494253' +
        '5f3037'
      
        '414c4941533a415454524942535f30383d434c41535345532e41545452494253' +
        '5f3038'
      
        '414c4941533a415454524942535f30393d434c41535345532e41545452494253' +
        '5f3039'
      
        '414c4941533a415454524942535f31303d434c41535345532e41545452494253' +
        '5f3130'
      
        '414c4941533a415454524942535f31313d434c41535345532e41545452494253' +
        '5f3131'
      
        '414c4941533a415454524942535f31323d434c41535345532e41545452494253' +
        '5f3132'
      
        '414c4941533a415454524942535f31333d434c41535345532e41545452494253' +
        '5f3133'
      
        '414c4941533a415454524942535f31343d434c41535345532e41545452494253' +
        '5f3134'
      
        '414c4941533a415454524942535f31353d434c41535345532e41545452494253' +
        '5f3135'
      
        '414c4941533a415454524942445f30313d434c41535345532e41545452494244' +
        '5f3031'
      
        '414c4941533a415454524942445f30323d434c41535345532e41545452494244' +
        '5f3032'
      
        '414c4941533a415454524942445f30333d434c41535345532e41545452494244' +
        '5f3033'
      
        '414c4941533a415454524942445f30343d434c41535345532e41545452494244' +
        '5f3034'
      
        '414c4941533a415454524942445f30353d434c41535345532e41545452494244' +
        '5f3035'
      
        '414c4941533a415454524942445f30363d434c41535345532e41545452494244' +
        '5f3036'
      
        '414c4941533a415454524942445f30373d434c41535345532e41545452494244' +
        '5f3037'
      
        '414c4941533a415454524942445f30383d434c41535345532e41545452494244' +
        '5f3038'
      
        '414c4941533a415454524942445f30393d434c41535345532e41545452494244' +
        '5f3039'
      
        '414c4941533a415454524942445f31303d434c41535345532e41545452494244' +
        '5f3130'
      
        '414c4941533a415454524942445f31313d434c41535345532e41545452494244' +
        '5f3131'
      
        '414c4941533a415454524942445f31323d434c41535345532e41545452494244' +
        '5f3132'
      
        '414c4941533a415454524942445f31333d434c41535345532e41545452494244' +
        '5f3133'
      
        '414c4941533a415454524942445f31343d434c41535345532e41545452494244' +
        '5f3134'
      
        '414c4941533a415454524942445f31353d434c41535345532e41545452494244' +
        '5f3135'
      
        '414c4941533a4154545249424e5f30313d434c41535345532e4154545249424e' +
        '5f3031'
      
        '414c4941533a4154545249424e5f30323d434c41535345532e4154545249424e' +
        '5f3032'
      
        '414c4941533a4154545249424e5f30333d434c41535345532e4154545249424e' +
        '5f3033'
      
        '414c4941533a4154545249424e5f30343d434c41535345532e4154545249424e' +
        '5f3034'
      
        '414c4941533a4154545249424e5f30353d434c41535345532e4154545249424e' +
        '5f3035'
      
        '414c4941533a4154545249424e5f30363d434c41535345532e4154545249424e' +
        '5f3036'
      
        '414c4941533a4154545249424e5f30373d434c41535345532e4154545249424e' +
        '5f3037'
      
        '414c4941533a4154545249424e5f30383d434c41535345532e4154545249424e' +
        '5f3038'
      
        '414c4941533a4154545249424e5f30393d434c41535345532e4154545249424e' +
        '5f3039'
      
        '414c4941533a4154545249424e5f31303d434c41535345532e4154545249424e' +
        '5f3130'
      
        '414c4941533a4154545249424e5f31313d434c41535345532e4154545249424e' +
        '5f3131'
      
        '414c4941533a4154545249424e5f31323d434c41535345532e4154545249424e' +
        '5f3132'
      
        '414c4941533a4154545249424e5f31333d434c41535345532e4154545249424e' +
        '5f3133'
      
        '414c4941533a4154545249424e5f31343d434c41535345532e4154545249424e' +
        '5f3134'
      
        '414c4941533a4154545249424e5f31353d434c41535345532e4154545249424e' +
        '5f3135'
      
        '414c4941533a4f5045524154494f4e5f464c41473d6465636f646528434c4153' +
        '5345532e6f7065726174696f6e5f666c61672c2749272c27577374617769656e' +
        '6965272c2755272c275a6d69616e61272c2744272c275573756e69ea63696527' +
        '29'
      
        '414c4941533a4546464543544956455f53544152545f444154453d434c415353' +
        '45532e4546464543544956455f53544152545f44415445'
      
        '414c4941533a4546464543544956455f454e445f444154453d434c4153534553' +
        '2e4546464543544956455f454e445f44415445'
      '414c4941533a4f554c5f4e414d453d4f554c2e4e414d45'
      '414c4941533a4f55535f4e414d453d4f55532e4e414d45'
      '414c4941533a4f55475f4e414d453d4f55472e4e414d45'
      '414c4941533a4f55525f4e414d453d4f55522e4e414d45'
      '53656172636853514c3d303d30'
      '466f726d43617074696f6e3d'
      '')
  end
  inherited Messages: TStrHolder
    Left = 600
    Top = 120
  end
  inherited SearchTimer: TTimer
    Left = 592
    Top = 24
  end
  inherited flexPopup: TPopupMenu
    Left = 12
    Top = 12
  end
  inherited ImageList: TImageList
    Left = 20
    Top = 348
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    SQL.Strings = (
      'SELECT CLASSES.ID'
      '     , CLASSES.DAY'
      '     , to_char(CLASSES.DAY,'#39'dy'#39') DAY_OF_WEEK'
      '     , to_char(CLASSES.DAY,'#39'YYYY-MM'#39') DAY_MONTH'
      '     , GRIDS.CAPTION HOUR'
      '     , CLASSES.FILL'
      '     , CLASSES.SUB_ID'
      '     , CLASSES.FOR_ID'
      '     , CLASSES.DESC1'
      '     , CLASSES.DESC2'
      '     , CLASSES.DESC3'
      '     , CLASSES.DESC4'
      
        '     , LEC.TITLE||'#39' '#39'||LEC.LAST_NAME||'#39' '#39'||LEC.FIRST_NAME CALC_L' +
        'ECTURERS'
      '     , CLASSES.CALC_GROUPS'
      '     , CLASSES.CALC_ROOMS'
      '     , CLASSES.CALC_LEC_IDS'
      '     , CLASSES.CALC_GRO_IDS'
      '     , CLASSES.CALC_ROM_IDS'
      '     , CLASSES.CREATED_BY'
      '     , CLASSES.OWNER'
      '     , CLASSES.STATUS'
      '     , CLASSES.COLOUR'
      '     , CLASSES.CALC_RESCAT_IDS'
      '     , CLASSES.CREATION_DATE'
      '     , SUB.NAME SUB_NAME'
      '     , FRM.NAME FRM_NAME'
      
        '     , decode(CLASSES.operation_flag,'#39'I'#39','#39'Wstawienie'#39','#39'U'#39','#39'Zmian' +
        'a'#39','#39'D'#39','#39'Usuni'#281'cie'#39') operation_flag'
      '     , CLASSES.effective_start_date'
      '     , CLASSES.effective_end_date'
      '     , OUL.NAME OUL_NAME'
      '     , OUS.NAME OUS_NAME'
      '     , OUG.NAME OUG_NAME'
      '     , OUR.NAME OUR_NAME'
      'FROM %TABLENAME CLASSES'
      '   , GRIDS'
      '   , SUBJECTS SUB'
      '   , FORMS FRM'
      '   , LECTURERS LEC'
      '   , LEC_CLA'
      '   , GRO_CLA'
      '   , ROM_CLA'
      '   , ROOMS ROM'
      '   , GROUPS GRO'
      '   , ORG_UNITS OUL'
      '   , ORG_UNITS OUS'
      '   , ORG_UNITS OUG'
      '   , ORG_UNITS OUR'
      'WHERE SUB.ID (+)= SUB_ID'
      '  AND FRM.ID = FOR_ID'
      '  AND CLASSES.ID  = LEC_CLA.CLA_ID(+)'
      '  AND CLASSES.ID  = GRO_CLA.CLA_ID(+)'
      '  AND CLASSES.ID  = ROM_CLA.CLA_ID(+)'
      '  AND LEC_CLA.LEC_ID = LEC.ID(+)'
      '  AND GRO_CLA.GRO_ID = GRO.ID(+)'
      '  AND ROM_CLA.ROM_ID = ROM.ID(+)'
      '  AND GRIDS.NO = CLASSES.HOUR'
      '  AND LEC.ORGUNI_ID = OUL.ID(+)'
      '  AND SUB.ORGUNI_ID = OUS.ID(+)'
      '  AND GRO.ORGUNI_ID = OUG.ID(+)'
      '  AND ROM.ORGUNI_ID = OUR.ID(+)'
      
        '  AND %CONDITIONALS AND %SEARCH AND %CONPERIOD AND %CONL AND %CO' +
        'NG AND %CONRESCAT0 AND %CONRESCAT1 AND %CONS AND %CONF AND %CONP' +
        'LA'
      
        '  AND %HIST_FILTER  AND %RESERVATIONS_FILTER AND %DAY_FILTER AND' +
        ' %HOUR_FILTER AND %SELECTED_DATES'
      '%SORTORDER')
    Left = 448
    Top = 24
  end
  inherited ExcelApplication1: TExcelApplication
    Left = 56
    Top = 312
  end
  inherited ppexport: TPopupMenu
    Left = 24
    Top = 312
  end
end
