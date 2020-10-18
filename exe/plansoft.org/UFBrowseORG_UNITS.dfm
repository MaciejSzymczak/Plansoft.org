inherited FBrowseORG_UNITS: TFBrowseORG_UNITS
  Left = 359
  Top = 128
  Width = 954
  Height = 745
  Caption = 'Jednostki organizacyjne'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 694
    Width = 946
  end
  inherited MainPage: TPageControl
    Width = 946
    Height = 694
    inherited Browse: TTabSheet
      inherited TopPanel: TPanel
        Width = 938
      end
      inherited Grid: TRxDBGrid
        Top = 121
        Width = 938
        Height = 486
        Columns = <
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = 'Nazwa'
            Width = 217
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CODE'
            Title.Caption = 'Kod'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PARENT_ORG'
            Title.Caption = 'Nadrz'#281'dna'
            Width = 233
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'STRUCT_CODE'
            Title.Caption = '...'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'STR_CODE'
            Title.Caption = 'Kod struktury'
            Width = 200
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
            FieldName = 'PARENT_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'UNIT_TYPE'
            Title.Caption = 'Typ jednostki'
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESC1'
            Title.Caption = 'Opis 1'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESC2'
            Title.Caption = 'Opis 2'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_01'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_02'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_03'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_04'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_05'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_06'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_07'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_08'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_09'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_10'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_11'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_12'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_13'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_14'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_15'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_01'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_02'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_03'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_04'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_05'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_06'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_07'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_08'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_09'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_10'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_11'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_12'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_13'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_14'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_15'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_01'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_02'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_03'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_04'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_05'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_06'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_07'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_08'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_09'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_10'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_11'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_12'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_13'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_14'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_15'
            Visible = True
          end>
      end
      inherited BottomPanel: TPanel
        Top = 626
        Width = 938
      end
      inherited Panel: TPanel
        Top = 607
        Width = 938
        inherited StatusBar: TStatusBar
          Width = 869
        end
      end
      inherited CustomPanel: TPanel
        Width = 938
        Height = 34
        object Label4: TLabel
          Left = 8
          Top = 12
          Width = 48
          Height = 14
          Caption = 'Jedn. org.'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object CON_PARENT_ID: TEdit
          Left = 72
          Top = 4
          Width = 121
          Height = 22
          Hint = 'RODZAJ'
          TabOrder = 0
          Visible = False
          OnChange = CON_PARENT_IDChange
        end
        object CON_PARENT_ID_VALUE: TEdit
          Left = 80
          Top = 4
          Width = 121
          Height = 22
          Hint = 'RODZAJ'
          TabOrder = 1
          OnDblClick = CON_PARENT_ID_VALUEDblClick
        end
        object BSelOU: TBitBtn
          Left = 199
          Top = 3
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = BSelOUClick
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FF018B8A7AC385827DA26B6B6B3F00000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000FF01094FFF974392F6FFEEE9DFFF86827FA700000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            FF020D51FF9B439AFFFF6ADAFFFF5DADF5FF998F7ED900000000000000000000
            00000000000000000000000000000000000000000000000000006B7E690F0041
            FC9F469FFFFF6FDAFFFF50ACFFFF1357FFB9002AFF0A00000000000000000000
            000000000000000000006164682E515459524C4E523F1617180698928B9E7091
            B2FF61D3FFFF4EAAFFFF1657FFB4001FFF070000000000000000000000000000
            000076777A257B7E80C8B3A081FED2B588FDC3AA83FD83817AE566686CEAFFF7
            F0FF6B93BDFF084AFEAF0028FF06000000000000000000000000000000007B7D
            7F188D8A82E6F5CB84FEF5CB84FFF1C885FFF5CE8EFFFCD08CFFAE9E85FE7071
            75F3A9A193BB3956B20A0000000000000000000000000000000000000000767A
            7F95ECCB8EFFF3D192FFEECE92FFEDCC8EFFECC784FFEDC687FFFDD28FFF8783
            7CDB000000010000000000000000000000000000000000000000000000009894
            8BE1FEDFA1FFF2DAA5FFF2DBA7FFF1D79FFFEFD097FFECC886FFF6D298FFC1A9
            87FF5254592A000000000000000000000000000000000000000000000000A7A1
            91F4FFEBB9FFF8ECC6FFF7EBC0FFF5E3B2FFF2DAA3FFEECF94FFF4D093FFCFB6
            8DFF5153583D0000000000000000000000000000000000000000000000009996
            92D0FFF7CBFFFDFAE6FFFDF9E7FFF8EDC5FFF4E0B0FFF0D49BFFFAD594FFAF9F
            85FE6264671A000000000000000000000000000000000000000000000000A0A1
            A56FD5CCB1FFFFFFF2FFFFFFF2FFFBF3D2FFF6E2B4FFF7D99EFFF6D393FF7D7D
            81B800000000000000000000000000000000000000000000000000000000D9D9
            DA04A1A1A2B8D6CFB6FFFFFFDCFFFFF6CAFFFFEBB1FFEDD49CFE8C8983E47677
            7A20000000000000000000000000000000000000000000000000000000000000
            0000EBECED059C9CA07B979893E0A8A397FE97948CF07679809E7C7D7F1A0000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000}
        end
        object BitBtn6: TBitBtn
          Left = 200
          Top = 4
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = BitBtn6Click
          Glyph.Data = {
            DE030000424DDE03000000000000420000002800000015000000150000000100
            1000030000009C03000000000000000000000000000000000000007C0000E003
            00001F0000001863186318631863186318631863186318631863186318631863
            1863186318631863186318631863186300001863007C007C007C007C007C007C
            007C007C007C007C007C007C007C007C007C007C007C007C1863186300001863
            1863186318631863186318631863186318631863186318631863186318631863
            186318631863186300001863007C007C007C007C007C007C007C007C007C007C
            007C007C007C007C007C18631863186318631863000018631863186318631863
            1863186318631863186318631863186318631863186318631863186318631863
            00001863186318631863007C007C007C007C007C007C007C007C007C007C007C
            007C007C007C007C186318630000186318631863186318631863186300000000
            1042186318631863186318631863186318631863186318630000186318631863
            18631863186300001F0018630000104218631863186318631863186318631863
            1863186300001863186318631863186300001F0018631F001863000010421863
            186318631863186318631863186318630000186318631863186300001F001863
            1F00186318631863000010421863186318631863186318631863186300001863
            186318631863000018631F001863186318630000FF7F00001042186318631863
            18631863186318630000186318631863186318630000FF7F186318630000FF7F
            0000000010421863186318631863186318631863000018631863186318631863
            18630000FF7F0000FF7F00001042000010421863186318631863186318631863
            000018631863186318631863186318630000FF7F000010421042000010421863
            1863186318631863186318630000186318631863186318631863186318630000
            0000000000001042000010421863186318631863186318630000186318631863
            1863186318631863186318631863186318630000104200001042186318631863
            1863186300001863186318631863186318631863186318631863186318631863
            0000104200001042186318631863186300001863186318631863186318631863
            1863186318631863186318631863000010420000104218631863186300001863
            1863186318631863186318631863186318631863186318631863186300000000
            1863186318631863000018631863186318631863186318631863186318631863
            1863186318631863186318631863186318631863000018631863186318631863
            1863186318631863186318631863186318631863186318631863186318631863
            0000}
        end
        object BOrgChart: TButton
          Left = 232
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Diagram'
          TabOrder = 4
          OnClick = BOrgChartClick
        end
      end
      inherited SecondRatePanel: TPanel
        Width = 938
      end
    end
    inherited Update: TTabSheet
      object LabelID: TLabel [0]
        Left = 744
        Top = 8
        Width = 8
        Height = 14
        Caption = 'Id'
        FocusControl = ID
        Visible = False
      end
      object LabelNAME: TLabel [1]
        Left = 78
        Top = 40
        Width = 35
        Height = 14
        Alignment = taRightJustify
        Caption = 'Nazwa'
        FocusControl = NAME
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelCODE: TLabel [2]
        Left = 94
        Top = 64
        Width = 19
        Height = 14
        Alignment = taRightJustify
        Caption = 'Kod'
        FocusControl = CODE
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelPARENT_ID: TLabel [3]
        Left = 32
        Top = 88
        Width = 81
        Height = 14
        Alignment = taRightJustify
        Caption = 'Jedn. nadrz'#281'dna'
        FocusControl = PARENT_ID
      end
      object LabelSTRUCT_CODE: TLabel [4]
        Left = 48
        Top = 112
        Width = 65
        Height = 14
        Alignment = taRightJustify
        Caption = 'Kod struktury'
        FocusControl = STRUCT_CODE
      end
      object Label3: TLabel [5]
        Left = 26
        Top = 164
        Width = 87
        Height = 14
        Alignment = taRightJustify
        Caption = 'Dodatkowy opis 2'
      end
      object Label2: TLabel [6]
        Left = 26
        Top = 140
        Width = 87
        Height = 14
        Alignment = taRightJustify
        Caption = 'Dodatkowy opis 1'
      end
      object Label1: TLabel [7]
        Left = 451
        Top = 32
        Width = 62
        Height = 14
        Alignment = taRightJustify
        Caption = 'Typ jednostki'
        FocusControl = CODE
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      inherited UpdPanel: TPanel
        Top = 630
        Width = 938
        TabOrder = 8
        inherited BUpdChild1: TBitBtn
          Caption = 'Wyk'#322'adowcy'
          Visible = True
        end
        inherited BUpdChild2: TBitBtn
          Caption = 'Finanse'
          Visible = True
        end
        inherited BUpdChild3: TBitBtn
          Caption = 'Przedmioty'
          Visible = True
        end
        inherited BUpdChild4: TBitBtn
          Caption = 'Grupy'
          Visible = True
        end
        inherited BUpdChild5: TBitBtn
          Caption = 'Zasoby'
          Visible = True
        end
      end
      inherited FlexPanel: TPanel
        Left = 32
        Top = 184
        TabOrder = 10
      end
      object ID: TDBEdit
        Left = 760
        Top = 0
        Width = 79
        Height = 22
        Hint = 'ID'
        Color = clBtnFace
        DataField = 'ID'
        DataSource = Source
        MaxLength = 10
        ReadOnly = True
        TabOrder = 9
        Visible = False
      end
      object NAME: TDBEdit
        Left = 121
        Top = 32
        Width = 300
        Height = 22
        Hint = 'NAZWA'
        DataField = 'NAME'
        DataSource = Source
        TabOrder = 0
      end
      object CODE: TDBEdit
        Left = 121
        Top = 56
        Width = 75
        Height = 22
        Hint = 'KOD'
        DataField = 'CODE'
        DataSource = Source
        TabOrder = 1
      end
      object PARENT_ID: TDBEdit
        Left = 113
        Top = 80
        Width = 150
        Height = 22
        Hint = 'PARENT_ID'
        DataField = 'PARENT_ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 2
        Visible = False
        OnChange = PARENT_IDChange
      end
      object STRUCT_CODE: TDBMemo
        Left = 121
        Top = 104
        Width = 300
        Height = 25
        Hint = 'STRUCT_CODE'
        Color = clBtnFace
        DataField = 'STRUCT_CODE'
        DataSource = Source
        ReadOnly = True
        TabOrder = 5
      end
      object DESC1: TDBEdit
        Left = 120
        Top = 132
        Width = 617
        Height = 22
        DataField = 'DESC1'
        DataSource = Source
        TabOrder = 6
      end
      object DESC2: TDBEdit
        Left = 120
        Top = 156
        Width = 617
        Height = 22
        DataField = 'DESC2'
        DataSource = Source
        TabOrder = 7
      end
      object PARENT_ID_VALUE: TEdit
        Left = 120
        Top = 80
        Width = 281
        Height = 22
        Hint = 'NADRZ'#280'DNA JEDNOSTKA ORGANIZACYJNA'
        ReadOnly = True
        TabOrder = 3
        OnClick = PARENT_ID_VALUEClick
      end
      object BClearPARENT_ID: TBitBtn
        Left = 400
        Top = 80
        Width = 25
        Height = 24
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = BClearPARENT_IDClick
        Glyph.Data = {
          DE030000424DDE03000000000000420000002800000015000000150000000100
          1000030000009C03000000000000000000000000000000000000007C0000E003
          00001F0000001863186318631863186318631863186318631863186318631863
          1863186318631863186318631863186300001863007C007C007C007C007C007C
          007C007C007C007C007C007C007C007C007C007C007C007C1863186300001863
          1863186318631863186318631863186318631863186318631863186318631863
          186318631863186300001863007C007C007C007C007C007C007C007C007C007C
          007C007C007C007C007C18631863186318631863000018631863186318631863
          1863186318631863186318631863186318631863186318631863186318631863
          00001863186318631863007C007C007C007C007C007C007C007C007C007C007C
          007C007C007C007C186318630000186318631863186318631863186300000000
          1042186318631863186318631863186318631863186318630000186318631863
          18631863186300001F0018630000104218631863186318631863186318631863
          1863186300001863186318631863186300001F0018631F001863000010421863
          186318631863186318631863186318630000186318631863186300001F001863
          1F00186318631863000010421863186318631863186318631863186300001863
          186318631863000018631F001863186318630000FF7F00001042186318631863
          18631863186318630000186318631863186318630000FF7F186318630000FF7F
          0000000010421863186318631863186318631863000018631863186318631863
          18630000FF7F0000FF7F00001042000010421863186318631863186318631863
          000018631863186318631863186318630000FF7F000010421042000010421863
          1863186318631863186318630000186318631863186318631863186318630000
          0000000000001042000010421863186318631863186318630000186318631863
          1863186318631863186318631863186318630000104200001042186318631863
          1863186300001863186318631863186318631863186318631863186318631863
          0000104200001042186318631863186300001863186318631863186318631863
          1863186318631863186318631863000010420000104218631863186300001863
          1863186318631863186318631863186318631863186318631863186300000000
          1863186318631863000018631863186318631863186318631863186318631863
          1863186318631863186318631863186318631863000018631863186318631863
          1863186318631863186318631863186318631863186318631863186318631863
          0000}
      end
      object UNIT_TYPE: TDBEdit
        Left = 521
        Top = 32
        Width = 120
        Height = 22
        Hint = 'KOD'
        DataField = 'UNIT_TYPE'
        DataSource = Source
        TabOrder = 11
      end
      object CheckDB: TMemo
        Left = 656
        Top = 48
        Width = 185
        Height = 89
        Lines.Strings = (
          'begin'
          'insert into helper2 (id, desc2)'
          '  select id,struct_code_C  from ('
          
            '  select level, id, name, code, struct_code, substr(sys_connect_' +
            'by_path(code, '#39'.'#39'),2,6500) struct_code_C'
          '  from org_units'
          '  start  with parent_id is null'
          '  connect by prior id=parent_id  '
          '  )'
          '  where struct_code_C <> struct_code;'
          'for rec in (select * from helper2) loop'
          
            '    update org_units set struct_code = rec.desc2 where id = rec.' +
            'id;'
          'end loop;'
          'commit;'
          'end;')
        TabOrder = 12
        Visible = False
        WordWrap = False
      end
    end
  end
  inherited Source: TDataSource
    Left = 384
    Top = 208
  end
  inherited PMenu: TPopupMenu
    Top = 184
  end
  inherited HolderSortOrder: TStrHolder
    Capacity = 4
    StrData = (
      ''
      '5354525f434f44457c4b6f6420737472756b74757279'
      '554e49545f545950457c547970206a65646e6f73746b69'
      '4e414d457c4e617a7761')
  end
  inherited GridLayout: TStrHolder
    Top = 312
  end
  inherited Komunikaty: TStrHolder
    Top = 224
  end
  inherited AvailColumnsWhereClause: TStrHolder
    Top = 280
  end
  inherited Others: TStrHolder
    Capacity = 95
    Top = 248
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
      
        '414c4941533a415454524942535f30313d4f52475f554e4954532e4154545249' +
        '42535f3031'
      
        '414c4941533a415454524942535f30323d4f52475f554e4954532e4154545249' +
        '42535f3032'
      
        '414c4941533a415454524942535f30333d4f52475f554e4954532e4154545249' +
        '42535f3033'
      
        '414c4941533a415454524942535f30343d4f52475f554e4954532e4154545249' +
        '42535f3034'
      
        '414c4941533a415454524942535f30353d4f52475f554e4954532e4154545249' +
        '42535f3035'
      
        '414c4941533a415454524942535f30363d4f52475f554e4954532e4154545249' +
        '42535f3036'
      
        '414c4941533a415454524942535f30373d4f52475f554e4954532e4154545249' +
        '42535f3037'
      
        '414c4941533a415454524942535f30383d4f52475f554e4954532e4154545249' +
        '42535f3038'
      
        '414c4941533a415454524942535f30393d4f52475f554e4954532e4154545249' +
        '42535f3039'
      
        '414c4941533a415454524942535f31303d4f52475f554e4954532e4154545249' +
        '42535f3130'
      
        '414c4941533a415454524942535f31313d4f52475f554e4954532e4154545249' +
        '42535f3131'
      
        '414c4941533a415454524942535f31323d4f52475f554e4954532e4154545249' +
        '42535f3132'
      
        '414c4941533a415454524942535f31333d4f52475f554e4954532e4154545249' +
        '42535f3133'
      
        '414c4941533a415454524942535f31343d4f52475f554e4954532e4154545249' +
        '42535f3134'
      
        '414c4941533a415454524942535f31353d4f52475f554e4954532e4154545249' +
        '42535f3135'
      
        '414c4941533a415454524942445f30313d4f52475f554e4954532e4154545249' +
        '42445f3031'
      
        '414c4941533a415454524942445f30323d4f52475f554e4954532e4154545249' +
        '42445f3032'
      
        '414c4941533a415454524942445f30333d4f52475f554e4954532e4154545249' +
        '42445f3033'
      
        '414c4941533a415454524942445f30343d4f52475f554e4954532e4154545249' +
        '42445f3034'
      
        '414c4941533a415454524942445f30353d4f52475f554e4954532e4154545249' +
        '42445f3035'
      
        '414c4941533a415454524942445f30363d4f52475f554e4954532e4154545249' +
        '42445f3036'
      
        '414c4941533a415454524942445f30373d4f52475f554e4954532e4154545249' +
        '42445f3037'
      
        '414c4941533a415454524942445f30383d4f52475f554e4954532e4154545249' +
        '42445f3038'
      
        '414c4941533a415454524942445f30393d4f52475f554e4954532e4154545249' +
        '42445f3039'
      
        '414c4941533a415454524942445f31303d4f52475f554e4954532e4154545249' +
        '42445f3130'
      
        '414c4941533a415454524942445f31313d4f52475f554e4954532e4154545249' +
        '42445f3131'
      
        '414c4941533a415454524942445f31323d4f52475f554e4954532e4154545249' +
        '42445f3132'
      
        '414c4941533a415454524942445f31333d4f52475f554e4954532e4154545249' +
        '42445f3133'
      
        '414c4941533a415454524942445f31343d4f52475f554e4954532e4154545249' +
        '42445f3134'
      
        '414c4941533a415454524942445f31353d4f52475f554e4954532e4154545249' +
        '42445f3135'
      
        '414c4941533a4154545249424e5f30313d4f52475f554e4954532e4154545249' +
        '424e5f3031'
      
        '414c4941533a4154545249424e5f30323d4f52475f554e4954532e4154545249' +
        '424e5f3032'
      
        '414c4941533a4154545249424e5f30333d4f52475f554e4954532e4154545249' +
        '424e5f3033'
      
        '414c4941533a4154545249424e5f30343d4f52475f554e4954532e4154545249' +
        '424e5f3034'
      
        '414c4941533a4154545249424e5f30353d4f52475f554e4954532e4154545249' +
        '424e5f3035'
      
        '414c4941533a4154545249424e5f30363d4f52475f554e4954532e4154545249' +
        '424e5f3036'
      
        '414c4941533a4154545249424e5f30373d4f52475f554e4954532e4154545249' +
        '424e5f3037'
      
        '414c4941533a4154545249424e5f30383d4f52475f554e4954532e4154545249' +
        '424e5f3038'
      
        '414c4941533a4154545249424e5f30393d4f52475f554e4954532e4154545249' +
        '424e5f3039'
      
        '414c4941533a4154545249424e5f31303d4f52475f554e4954532e4154545249' +
        '424e5f3130'
      
        '414c4941533a4154545249424e5f31313d4f52475f554e4954532e4154545249' +
        '424e5f3131'
      
        '414c4941533a4154545249424e5f31323d4f52475f554e4954532e4154545249' +
        '424e5f3132'
      
        '414c4941533a4154545249424e5f31333d4f52475f554e4954532e4154545249' +
        '424e5f3133'
      
        '414c4941533a4154545249424e5f31343d4f52475f554e4954532e4154545249' +
        '424e5f3134'
      
        '414c4941533a4154545249424e5f31353d4f52475f554e4954532e4154545249' +
        '424e5f313520'
      '414c4941533a4e414d453d4f52475f554e4954532e4e414d45'
      '414c4941533a434f44453d4f52475f554e4954532e434f4445'
      
        '414c4941533a5354525f434f44453d4f52475f554e4954532e5354525543545f' +
        '434f4445'
      '414c4941533a504152454e545f4f52473d504152454e542e4e414d45'
      '414c4941533a44455343313d504152454e542e4445534331'
      '414c4941533a44455343323d504152454e542e4445534332'
      
        '414c4941533a554e49545f545950453d4f52475f554e4954532e554e49545f54' +
        '595045'
      '')
  end
  inherited Messages: TStrHolder
    Capacity = 4
    Top = 312
    StrData = (
      ''
      
        '4a65646e6f73746b61206f7267616e697a6163796a6e61206e6965206d6fbf65' +
        '206279e62073616d6120646c6120736965626965206a65646e6f73746bb9206e' +
        '6164727aea646eb9')
  end
  inherited SearchTimer: TTimer
    Left = 432
    Top = 184
  end
  inherited flexPopup: TPopupMenu
    Top = 4
  end
  inherited Query: TADOQuery
    BeforePost = QueryBeforePost
    SQL.Strings = (
      'SELECT %TOPRECORDS ORG_UNITS.*'
      '     , PARENT.NAME PARENT_ORG'
      '     , SUBSTR(ORG_UNITS.STRUCT_CODE, 1, 63) STR_CODE'
      '  FROM ORG_UNITS'
      '  ,    ORG_UNITS PARENT'
      
        ' WHERE %CON_PARENT_ID AND %CONDITIONALS AND %SEARCH AND ORG_UNIT' +
        'S.PARENT_ID = PARENT.ID (+)'
      '%SORTORDER'
      '')
    Top = 192
  end
  object googleChart: TADOQuery
    AutoCalcFields = False
    Connection = DModule.ADOConnection
    CommandTimeout = 1000
    Parameters = <>
    SQL.Strings = (
      'select 1 from dual')
    Left = 576
    Top = 88
  end
  object PPOrgChart: TPopupMenu
    Left = 308
    Top = 92
    object Wywietl1: TMenuItem
      Caption = 'Wy'#347'wietl'
      OnClick = Wywietl1Click
    end
    object Wicejopcji1: TMenuItem
      Caption = 'Wi'#281'cej opcji'
      OnClick = Wicejopcji1Click
    end
  end
end
