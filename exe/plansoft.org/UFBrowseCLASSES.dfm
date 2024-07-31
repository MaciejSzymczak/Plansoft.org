inherited FBrowseCLASSES: TFBrowseCLASSES
  Left = 259
  Top = 216
  Width = 1315
  Caption = 'Lista Zaj'#281#263
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Width = 1307
  end
  inherited MainPage: TPageControl
    Width = 1307
    ActivePage = Browse
    inherited Browse: TTabSheet
      inherited TopPanel: TPanel
        Width = 1299
        object Label1: TLabel [5]
          Left = 806
          Top = 8
          Width = 181
          Height = 14
          Caption = 'Czy zaplanowane w dniach wolnych'
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
          TabOrder = 11
          Text = 'Bez znaczenia'
          OnChange = ConflictWithReservationsChange
          Items.Strings = (
            'Bez znaczenia'
            'Tak'
            'Nie')
        end
      end
      inherited Grid: TRxDBGrid
        Top = 273
        Width = 1299
        Height = 228
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgMultiSelect]
        MultiSelect = True
        Columns = <
          item
            Expanded = False
            FieldName = 'DAY'
            Title.Caption = 'Dzie'#324
            Width = 80
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
            FieldName = 'SUB_NAME'
            Title.Caption = 'Przedmiot'
            Width = 300
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
            FieldName = 'CALC_LECTURERS'
            Title.Caption = 'Wyk'#322'adowca'
            Width = 300
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALC_GROUPS'
            Title.Caption = 'Grupy'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALC_ROOMS'
            Title.Caption = 'Zasoby'
            Width = 200
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
            FieldName = 'OUS_NAME'
            Title.Caption = 'Jednostka przedmiotu'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'Id'
            Width = 100
            Visible = True
          end>
      end
      inherited BottomPanel: TPanel
        Width = 1299
        object BMassEdit: TBitBtn
          Left = 88
          Top = 5
          Width = 153
          Height = 28
          Caption = 'Edytuj zestaw zaj'#281#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 10
          OnClick = BMassEditClick
          Glyph.Data = {
            8A050000424D8A05000000000000360400002800000013000000110000000100
            0800000000005401000000000000000000000001000000010000000000008080
            8000000080000080800000800000808000008000000080008000408080004040
            0000FF80000080400000FF00400000408000FFFFFF00C0C0C0000000FF0000FF
            FF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF0000FFFF8000FF80
            80008000FF004080FF0000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000F0F0F0F0F0F
            0F0F0F0F0F0F0F0F0F0F0F0F0F810F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
            0F810F0F0F0F0F0F00000000000000000000000F0F810F0F0F0F0F0E0E0E0E0E
            0E0E0E0E0E0E000F0F810F0F0F0F0F0E0000010E0100000E0E0E000F0F810F0F
            0F0F0F0E0E0E0E00000E010E0E0E000F0F810F0F0F0F0F0E0E0E00031101010E
            0E0E000F0F810F0F0F0F0F0E0E0003110E010E01000E000F0F810F0F0F0F0F0E
            0003110E010E0E0E0E0E000F0F810F0F0F0F0F0003110E010E010000000E000F
            0F810F0F0F0F0003110E010E0E0E0E0E0E0E000F0F810F0F0F0003110E010E01
            00000E0E0E0E000F0F810F0F0003110E010E0E0E0E0E0E000000000F0F810F07
            07000E010E01000000000E0000000F0F0F810F071010010E0E0E0E0E0E0E0E00
            000F0F0F0F810F0110100F0E0E0E0E0E0E0E0E000F0F0F0F0F810F0F0F0F0F0F
            0F0F0F0F0F0F0F0F0F0F0F0F0F81}
        end
      end
      inherited Panel: TPanel
        Width = 1299
        inherited StatusBar: TStatusBar
          Width = 1230
        end
      end
      inherited CustomPanel: TPanel
        Top = 97
        Width = 1299
        Height = 176
        inline GenericFilter: TFGenericFilter
          Left = 1
          Top = 81
          Width = 1297
          Height = 101
          Align = alTop
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
            Height = 22
            OnChange = FGenericFilter1conlChange
          end
          inherited conl_value: TEdit
            Height = 22
          end
          inherited cong: TEdit
            Height = 22
            OnChange = GenericFiltercongChange
          end
          inherited cong_value: TEdit
            Height = 22
          end
          inherited conResCat0: TEdit
            Height = 22
            OnChange = GenericFilterconResCat0Change
          end
          inherited conrescat0_value: TEdit
            Height = 22
          end
          inherited conResCat1: TEdit
            Height = 22
            OnChange = GenericFilterconResCat1Change
          end
          inherited conrescat1_value: TEdit
            Height = 22
          end
          inherited cons: TEdit
            Top = 62
            Height = 22
            OnChange = GenericFilterconsChange
          end
          inherited cons_value: TEdit
            Top = 62
            Height = 22
          end
          inherited conf: TEdit
            Top = 62
            Height = 22
            OnChange = GenericFilterconfChange
          end
          inherited conf_value: TEdit
            Top = 62
            Height = 22
          end
          inherited conPeriod: TEdit
            Top = 62
            Height = 22
            OnChange = GenericFilterconPerChange
          end
          inherited conperiod_value: TEdit
            Top = 62
            Height = 22
          end
          inherited conPla: TEdit
            Top = 62
            Height = 22
            OnChange = GenericFilterconPlaChange
          end
          inherited conPla_value: TEdit
            Top = 62
            Height = 22
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
          inherited PERFilterType: TEdit
            Height = 22
          end
          inherited LFilterType: TEdit
            Height = 22
          end
          inherited GFilterType: TEdit
            Height = 22
          end
          inherited R0FilterType: TEdit
            Height = 22
          end
          inherited SFilterType: TEdit
            Height = 22
          end
          inherited FFilterType: TEdit
            Height = 22
          end
          inherited R1FilterType: TEdit
            Height = 22
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
        object PanelDates: TPanel
          Left = 1
          Top = 42
          Width = 1297
          Height = 39
          Align = alTop
          TabOrder = 0
          object LDAYTO_Label: TLabel
            Left = 171
            Top = 6
            Width = 12
            Height = 14
            Caption = 'do'
          end
          object Label2: TLabel
            Left = 8
            Top = 6
            Width = 33
            Height = 14
            Caption = 'Kiedy: '
          end
          object ChSelectedDates: TCheckBox
            Left = 360
            Top = 6
            Width = 241
            Height = 17
            Caption = 'Terminy zaznaczone w siatce'
            TabOrder = 0
            OnClick = ChSelectedDatesClick
          end
          object FHOUR: TComboBox
            Left = 312
            Top = 3
            Width = 42
            Height = 22
            Style = csOwnerDrawFixed
            DropDownCount = 25
            ItemHeight = 16
            MaxLength = 255
            TabOrder = 1
            OnChange = FDAY_FROMChange
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
          object FDAY_TO: TDateEdit
            Left = 192
            Top = 4
            Width = 121
            Height = 21
            NumGlyphs = 2
            TabOrder = 2
            OnChange = FDAY_FROMChange
          end
          object FDAY_FROM: TDateEdit
            Left = 48
            Top = 4
            Width = 121
            Height = 21
            NumGlyphs = 2
            TabOrder = 3
            OnChange = FDAY_FROMChange
          end
        end
        object PanelHistory: TPanel
          Left = 1
          Top = 1
          Width = 1297
          Height = 41
          Align = alTop
          TabOrder = 2
          object Label3: TLabel
            Left = 427
            Top = 6
            Width = 12
            Height = 14
            Caption = 'do'
          end
          object historyLabel: TLabel
            Left = 8
            Top = 6
            Width = 73
            Height = 14
            Caption = 'Historia zmian: '
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
            TabOrder = 0
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
          object historyFrom: TDateEdit
            Left = 296
            Top = 6
            Width = 121
            Height = 21
            NumGlyphs = 2
            TabOrder = 1
            OnChange = historyFromChange
          end
          object historyTo: TDateEdit
            Left = 448
            Top = 6
            Width = 121
            Height = 21
            NumGlyphs = 2
            TabOrder = 2
            OnChange = historyToChange
          end
        end
      end
      inherited SecondRatePanel: TPanel
        Width = 1299
        Height = 40
      end
      object fastQueryString: TMemo
        Left = 336
        Top = 352
        Width = 185
        Height = 89
        Lines.Strings = (
          '('
          
            '(CLASSES.ID IN (select cla_id from lec_cla where lec_id in (sele' +
            'ct m.id from lecturers m, org_units o where m.ORGUNI_ID = o.id(+' +
            ') and (xxmsz_tools.erasePolishChars(upper(o.name||m.abbreviation' +
            '||m.title||m.first_name||m.last_name||m.email||m.desc1||m.desc2|' +
            '| m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attr' +
            'ibs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||' +
            'm.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attrib' +
            's_14||m.attribs_15||'#39'#'#39'||m.integration_id||'#39'#'#39')) like '#39'%var1%'#39'))' +
            ')) OR'
          
            '(CLASSES.ID IN (select cla_id from gro_cla where gro_id in(selec' +
            't m.id from groups m, org_units o where m.ORGUNI_ID = o.id(+) an' +
            'd (xxmsz_tools.erasePolishChars(upper(o.name||m.name||m.abbrevia' +
            'tion||m.email||m.desc1||m.desc2||m.attribs_01||m.attribs_02||m.a' +
            'ttribs_03||m.attribs_04||m.attribs_05||m.attribs_06||m.attribs_0' +
            '7||m.attribs_08||m.attribs_09||m.attribs_10||m.attribs_11||m.att' +
            'ribs_12||m.attribs_13||m.attribs_14||m.attribs_15||'#39'#'#39'||m.integr' +
            'ation_id||'#39'#'#39')) like '#39'%var2%'#39' )))) OR'
          
            '(CLASSES.ID IN (select cla_id from rom_cla where rom_id in (sele' +
            'ct m.id from rooms m, org_units o where m.ORGUNI_ID = o.id(+) an' +
            'd (xxmsz_tools.erasePolishChars(upper(o.name||m.name||m.desc1||m' +
            '.desc2||m.attribs_01||m.email|| m.attribs_01||m.attribs_02||m.at' +
            'tribs_03||m.attribs_04||m.attribs_05||m.attribs_06||m.attribs_07' +
            '||m.attribs_08||m.attribs_09||m.attribs_10||m.attribs_11||m.attr' +
            'ibs_12||m.attribs_13||m.attribs_14||m.attribs_15||'#39'#'#39'||m.integra' +
            'tion_id||'#39'#'#39')) like '#39'%var3%'#39')))) OR'
          
            '(CLASSES.SUB_ID in (select m.id from subjects m, org_units o whe' +
            're m.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(upper' +
            '(o.name||m.abbreviation||m.desc1||m.desc2||m.name|| m.attribs_01' +
            '||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.attr' +
            'ibs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_10||' +
            'm.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.attrib' +
            's_15||'#39'#'#39'||m.integration_id||'#39'#'#39')) like '#39'%var4%'#39' ))) OR'
          
            '(CLASSES.FOR_ID in (select m.id from forms m where (xxmsz_tools.' +
            'erasePolishChars(upper(m.abbreviation||m.desc1||m.desc2||m.name|' +
            '|m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attri' +
            'bs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m' +
            '.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs' +
            '_14||m.attribs_15||'#39'#'#39'||m.integration_id||'#39'#'#39')) like '#39'%var5%'#39' ))' +
            ') OR'
          
            '(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC1)) like '#39'%var6%' +
            #39') OR'
          
            '(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC2)) like '#39'%var7%' +
            #39') OR'
          
            '(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC3)) like '#39'%var8%' +
            #39') OR'
          
            '(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC4)) like '#39'%var9%' +
            #39') OR'
          '(GRIDS.CAPTION like '#39'%var10%'#39')'
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
        Width = 166
        Height = 14
        Caption = 'Kol. wpr.:........................................'
        FocusControl = _ID
        Visible = False
      end
      object LabelDAY: TLabel [1]
        Left = 8
        Top = 40
        Width = 27
        Height = 14
        Caption = 'Dzie'#324
        FocusControl = DAY
      end
      object LabelHOUR: TLabel [2]
        Left = 8
        Top = 64
        Width = 40
        Height = 14
        Caption = 'Godzina'
        FocusControl = HOUR
      end
      object LabelCALC_LECTURERS: TLabel [3]
        Left = 8
        Top = 88
        Width = 63
        Height = 14
        Caption = 'Wyk'#322'adowcy'
        FocusControl = CALC_LECTURERS
      end
      object LabelCALC_GROUPS: TLabel [4]
        Left = 8
        Top = 112
        Width = 30
        Height = 14
        Caption = 'Grupy'
        FocusControl = CALC_GROUPS
      end
      object LabelCALC_ROOMS: TLabel [5]
        Left = 8
        Top = 136
        Width = 66
        Height = 14
        Caption = 'Sale / zasoby'
        FocusControl = CALC_ROOMS
      end
      object LabelSUB_ID: TLabel [6]
        Left = 8
        Top = 160
        Width = 170
        Height = 14
        Caption = 'Przedmiot:........................................'
        FocusControl = SUB_ID
      end
      object LabelFOR_ID: TLabel [7]
        Left = 8
        Top = 184
        Width = 153
        Height = 14
        Caption = 'Forma:........................................'
        FocusControl = FOR_ID
      end
      object LabelFILL: TLabel [8]
        Left = 8
        Top = 208
        Width = 181
        Height = 14
        Caption = 'Wype'#322'nienie:........................................'
        FocusControl = FILL
      end
      object LabelDESC1: TLabel [9]
        Left = 8
        Top = 232
        Width = 154
        Height = 14
        Caption = 'Opis 1:........................................'
        FocusControl = DESC1
      end
      object LabelDESC2: TLabel [10]
        Left = 8
        Top = 256
        Width = 154
        Height = 14
        Caption = 'Opis 2:........................................'
        FocusControl = DESC2
      end
      inherited UpdPanel: TPanel
        Width = 1299
      end
      inherited FlexPanel: TPanel
        TabOrder = 12
      end
      object _ID: TDBEdit
        Left = 945
        Top = 8
        Width = 150
        Height = 22
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
        Height = 22
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
        Height = 22
        Hint = 'CALC_LECTURERS'
        DataField = 'CALC_LECTURERS'
        DataSource = Source
        TabOrder = 4
      end
      object CALC_GROUPS: TDBEdit
        Left = 121
        Top = 104
        Width = 300
        Height = 22
        Hint = 'CALC_GROUPS'
        DataField = 'CALC_GROUPS'
        DataSource = Source
        TabOrder = 5
      end
      object CALC_ROOMS: TDBEdit
        Left = 121
        Top = 128
        Width = 300
        Height = 22
        Hint = 'CALC_ROOMS'
        DataField = 'CALC_ROOMS'
        DataSource = Source
        TabOrder = 6
      end
      object SUB_ID: TDBEdit
        Left = 121
        Top = 152
        Width = 150
        Height = 22
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
        Height = 22
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
        Height = 22
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
        Height = 22
        Hint = 'DESC1'
        DataField = 'DESC1'
        DataSource = Source
        TabOrder = 10
      end
      object DESC2: TDBEdit
        Left = 121
        Top = 248
        Width = 300
        Height = 22
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
    Left = 688
    Top = 104
  end
  inherited HolderSortOrder: TStrHolder
    Capacity = 28
    Left = 640
    Top = 336
    StrData = (
      ''
      
        '434f4e43415428746f5f63686172284441592c27797979792d6d6d2d64642729' +
        '2c484f55522920444553437c447a6965f1206920476f647a696e61206d616c65' +
        '6ab9636f7c43415445474f52593a44454641554c54'
      
        '5355425f4e414d452c434f4e43415428746f5f63686172284441592c27797979' +
        '792d6d6d2d646427292c484f55522920444553437c50727a65646d696f747c43' +
        '415445474f52593a44454641554c54'
      
        '46524d5f4e414d452c434f4e43415428746f5f63686172284441592c27797979' +
        '792d6d6d2d646427292c484f55522920444553437c466f726d617c4341544547' +
        '4f52593a44454641554c54'
      
        '746f5f6368617228434c41535345532e4441592c27647927292c434f4e434154' +
        '28746f5f63686172284441592c27797979792d6d6d2d646427292c484f555229' +
        '20444553437c447a6965f1207479676f646e69617c43415445474f52593a4445' +
        '4641554c54'
      
        '6c65637475726572732e66756c6c5f6e616d652c434f4e43415428746f5f6368' +
        '6172284441592c27797979792d6d6d2d646427292c484f55522920444553437c' +
        '57796bb361646f7763617c43415445474f52593a44454641554c54'
      
        '43414c435f47524f5550532c434f4e43415428746f5f63686172284441592c27' +
        '797979792d6d6d2d646427292c484f55522920444553437c47727570797c4341' +
        '5445474f52593a44454641554c54'
      
        '43414c435f524f4f4d532c434f4e43415428746f5f63686172284441592c2779' +
        '7979792d6d6d2d646427292c484f55522920444553437c5a61736f62797c4341' +
        '5445474f52593a44454641554c54'
      
        '46494c4c2c434f4e43415428746f5f63686172284441592c27797979792d6d6d' +
        '2d646427292c484f55522920444553437c57797065b36e69656e69657c434154' +
        '45474f52593a44454641554c54'
      
        '44455343312c434f4e43415428746f5f63686172284441592c27797979792d6d' +
        '6d2d646427292c484f55522920444553437c4f706973317c43415445474f5259' +
        '3a44454641554c54'
      
        '44455343322c434f4e43415428746f5f63686172284441592c27797979792d6d' +
        '6d2d646427292c484f55522920444553437c4f706973327c43415445474f5259' +
        '3a44454641554c54'
      
        '44455343332c434f4e43415428746f5f63686172284441592c27797979792d6d' +
        '6d2d646427292c484f55522920444553437c4f706973337c43415445474f5259' +
        '3a44454641554c54'
      
        '44455343342c434f4e43415428746f5f63686172284441592c27797979792d6d' +
        '6d2d646427292c484f55522920444553437c4f706973347c43415445474f5259' +
        '3a44454641554c54'
      '49647c49447c43415445474f52593a44454641554c54')
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
        '41535345532e4546464543544956455f454e445f444154457c667444617465'
      '49647c434c41535345532e49447c6674537472696e67')
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
      '414c4941533a49443d434c41535345532e4944'
      
        '414c4941533a4f5045524154494f4e5f464c41473d6465636f646528434c4153' +
        '5345532e6f7065726174696f6e5f666c61672c2749272c27577374617769656e' +
        '6965272c2755272c275a6d69616e61272c2744272c275573756e69ea63696527' +
        '29'
      
        '414c4941533a4546464543544956455f53544152545f444154453d434c415353' +
        '45532e4546464543544956455f53544152545f44415445'
      
        '414c4941533a4546464543544956455f454e445f444154453d434c4153534553' +
        '2e4546464543544956455f454e445f44415445'
      '414c4941533a4f55535f4e414d453d4f55532e4e414d45'
      '53656172636853514c3d303d30'
      '466f726d43617074696f6e3d')
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
      '     , SUBSTR(lecturers.full_name,1,500) CALC_LECTURERS'
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
      '     , OUS.NAME OUS_NAME'
      'FROM %TABLENAME CLASSES'
      '   , GRIDS'
      '   , SUBJECTS SUB'
      '   , FORMS FRM'
      '   , ORG_UNITS OUS'
      
        ',(select trim('#39';'#39'  from max(v1)||'#39';'#39'||max(v2)||'#39';'#39'||max(v3)||'#39';'#39 +
        '||max(v4)||'#39';'#39'||max(v5)||'#39';'#39'||max(v6)||'#39';'#39'||max(v7)||'#39';'#39'||max(v8' +
        ')||'#39';'#39'||max(v9)||'#39';'#39'||max(v10)||'#39';'#39'||max(v11)||'#39';'#39'||max(v12)||'#39';' +
        #39'||max(v13)||'#39';'#39'||max(v14)||'#39';'#39'||max(v15)||'#39';'#39'||max(v16)||'#39';'#39'||m' +
        'ax(v17)||'#39';'#39'||max(v18)||'#39';'#39'||max(v19)||'#39';'#39'||max(v20)) full_name'
      
        '     , trim('#39';'#39' from max(u1)||'#39';'#39'||max(u2)||'#39';'#39'||max(u3)||'#39';'#39'||m' +
        'ax(u4)||'#39';'#39'||max(u5)||'#39';'#39'||max(u6)||'#39';'#39'||max(u7)||'#39';'#39'||max(u8)||' +
        #39';'#39'||max(u9)||'#39';'#39'||max(u10)||'#39';'#39'||max(u11)||'#39';'#39'||max(u12)||'#39';'#39'||' +
        'max(u13)||'#39';'#39'||max(u14)||'#39';'#39'||max(u15)||'#39';'#39'||max(u16)||'#39';'#39'||max(' +
        'u17)||'#39';'#39'||max(u18)||'#39';'#39'||max(u19)||'#39';'#39'||max(u20)) orguni'
      '     , cla_id Id'
      'from'
      '('
      
        'select case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=1 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v1'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=2 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v2'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=3 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v3'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=4 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v4'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=5 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v5'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=6 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v6'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=7 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v7'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=8 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v8'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=9 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else ' +
        'null end v9'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=10 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v10'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=11 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v11'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=12 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v12'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=13 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v13'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=14 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v14'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=15 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v15'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=16 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v16'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=17 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v17'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=18 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v18'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=19 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v19'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=20 then title ||'#39' '#39'||first_name||'#39' '#39'||last_name else' +
        ' null end v20'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=1 then o.name else null end u1'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=2 then o.name else null end u2'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=3 then o.name else null end u3'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=4 then o.name else null end u4'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=5 then o.name else null end u5'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=6 then o.name else null end u6'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=7 then o.name else null end u7'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=8 then o.name else null end u8'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=9 then o.name else null end u9'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=10 then o.name else null end u10'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=11 then o.name else null end u11'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=12 then o.name else null end u12'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=13 then o.name else null end u13'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=14 then o.name else null end u14'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=15 then o.name else null end u15'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=16 then o.name else null end u16'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=17 then o.name else null end u17'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=18 then o.name else null end u18'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=19 then o.name else null end u19'
      
        '     , case when (row_number() over (partition by cla_id  order ' +
        'by lec_id))=20 then o.name else null end u20'
      '     , cla_id'
      '  from lec_cla'
      '      , lecturers'
      '      , org_units o'
      '  where lec_cla.lec_id = lecturers.id'
      '    and o.id(+) = lecturers.orguni_id'
      '    and %DAY_FILTER1'
      ')'
      'group by cla_id'
      ') lecturers'
      'WHERE lecturers.id(+) = classes.id'
      '  AND SUB.ID (+)= SUB_ID'
      '  AND FRM.ID = FOR_ID'
      '  AND GRIDS.NO = CLASSES.HOUR'
      '  AND SUB.ORGUNI_ID = OUS.ID(+)'
      
        '  AND %CONDITIONALS AND %SEARCH AND %CONPERIOD AND %CONL AND %CO' +
        'NG AND %CONRESCAT0 AND %CONRESCAT1 AND %CONS AND %CONF AND %CONP' +
        'LA'
      
        '  AND %HIST_FILTER  AND %RESERVATIONS_FILTER AND %DAY_FILTER2 AN' +
        'D %HOUR_FILTER AND %SELECTED_DATES'
      '  AND CLASSES.OWNER <> '#39'AUTO'#39
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
  object PPMassEdit: TPopupMenu
    Left = 788
    Top = 380
    object ActionLEC_ADD: TMenuItem
      Caption = 'Przypisz wyk'#322'adowc'#281
      OnClick = ActionLEC_ADDClick
    end
    object ActionLEC_DEL: TMenuItem
      Caption = 'Usu'#324' wybranego wyk'#322'adowc'#281
      OnClick = ActionLEC_DELClick
    end
    object ActionLEC_DEL_ALL: TMenuItem
      Caption = 'Usu'#324' wszystkich wyk'#322'adowc'#243'w'
      OnClick = ActionLEC_DEL_ALLClick
    end
  end
end
