inherited FBrowseFIN_PARTIES: TFBrowseFIN_PARTIES
  Left = 290
  Top = 18
  Width = 888
  Height = 707
  Caption = 'Osoby fizyczne i prawne'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 656
    Width = 880
  end
  inherited MainPage: TPageControl
    Width = 880
    Height = 656
    ActivePage = Update
    inherited Browse: TTabSheet
      inherited TopPanel: TPanel
        Width = 872
      end
      inherited Grid: TRxDBGrid
        Top = 121
        Width = 872
        Height = 448
        Columns = <
          item
            Expanded = False
            FieldName = 'CUSTOMER_NAME_LINE1'
            Title.Caption = 'Nazwa'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CUSTOMER_NAME_LINE2'
            Title.Caption = 'Nazwa cd.'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TAX_NUM'
            Title.Caption = 'NIP'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'STAT_NUM'
            Title.Caption = 'REGON'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ADDRESS_STREET'
            Title.Caption = 'Ulica'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ADDRESS_STREET_NUM'
            Title.Caption = 'Nr ulicy'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ADDRESS_BUILDING_NUM'
            Title.Caption = 'Nr domu'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ADDRESS_POSTAL_CODE'
            Title.Caption = 'Kod pocztowy'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ADDRES_PLACE'
            Title.Caption = 'Miejscowo'#347#263
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ADDRESS_COUNTRY'
            Title.Caption = 'Pa'#324'stwo'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'STR_KEY'
            Title.Caption = 'Klucz'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BANK_ACCOUNT_NUM'
            Title.Caption = 'Nr konta bankowego'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FEEDER_SYSTEM_REF'
            Title.Caption = 'Referencja'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AUX_DESC1'
            Title.Caption = 'Opis 1'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AUX_DESC2'
            Title.Caption = 'Opis 2'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ID'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_01'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_02'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_03'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_04'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_05'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_06'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_07'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_08'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_09'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_10'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_11'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_12'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_13'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_14'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_15'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_01'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_02'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_03'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_04'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_05'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_06'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_07'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_08'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_09'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_10'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_11'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_12'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_13'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_14'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBD_15'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_01'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_02'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_03'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_04'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_05'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_06'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_07'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_08'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_09'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_10'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_11'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_12'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_13'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_14'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ATTRIBN_15'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATION_DATE'
            Title.Caption = 'Utworzono'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATED_BY'
            Title.Caption = 'Utworzyl'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATE_DATE'
            Title.Caption = 'Zaktualizowano'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATED_BY'
            Title.Caption = 'Zaktualizowal'
            Width = 100
            Visible = True
          end>
      end
      inherited BottomPanel: TPanel
        Top = 588
        Width = 872
      end
      inherited Panel: TPanel
        Top = 569
        Width = 872
        inherited StatusBar: TStatusBar
          Width = 803
        end
      end
      inherited CustomPanel: TPanel
        Width = 872
        Height = 34
        object con_label: TLabel
          Left = 8
          Top = 12
          Width = 56
          Height = 14
          Caption = 'Referencja:'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object CON_FEEDER_SYSTEM_REF: TEdit
          Left = 72
          Top = 4
          Width = 217
          Height = 22
          Hint = 'RODZAJ'
          TabOrder = 0
          OnChange = CON_FEEDER_SYSTEM_REFChange
        end
        object con_clear: TBitBtn
          Left = 291
          Top = 4
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = con_clearClick
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
      end
      inherited SecondRatePanel: TPanel
        Width = 872
      end
    end
    inherited Update: TTabSheet
      object LabelID: TLabel [0]
        Left = 736
        Top = 112
        Width = 44
        Height = 14
        Caption = 'Kol. wpr.'
        FocusControl = ID
      end
      object LabelCUSTOMER_NAME_LINE1: TLabel [1]
        Left = 8
        Top = 8
        Width = 35
        Height = 14
        Caption = 'Nazwa'
        FocusControl = CUSTOMER_NAME_LINE1
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelCUSTOMER_NAME_LINE2: TLabel [2]
        Left = 8
        Top = 32
        Width = 53
        Height = 14
        Caption = 'Nazwa cd.'
        FocusControl = CUSTOMER_NAME_LINE2
      end
      object LabelTAX_NUM: TLabel [3]
        Left = 8
        Top = 56
        Width = 15
        Height = 14
        Caption = 'NIP'
        FocusControl = TAX_NUM
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelSTAT_NUM: TLabel [4]
        Left = 280
        Top = 56
        Width = 36
        Height = 14
        Caption = 'REGON'
        FocusControl = STAT_NUM
      end
      object LabelSTR_KEY: TLabel [5]
        Left = 8
        Top = 128
        Width = 27
        Height = 14
        Caption = 'Klucz'
        FocusControl = STR_KEY
      end
      object LabelBANK_ACCOUNT_NUM: TLabel [6]
        Left = 8
        Top = 80
        Width = 99
        Height = 14
        Caption = 'Nr rach. bankowego'
        FocusControl = BANK_ACCOUNT_NUM
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelFEEDER_SYSTEM_REF: TLabel [7]
        Left = 8
        Top = 104
        Width = 53
        Height = 14
        Caption = 'Referencja'
        FocusControl = FEEDER_SYSTEM_REF
      end
      object LabelAUX_DESC1: TLabel [8]
        Left = 8
        Top = 152
        Width = 31
        Height = 14
        Caption = 'Opis 1'
        FocusControl = AUX_DESC1
      end
      object LabelAUX_DESC2: TLabel [9]
        Left = 8
        Top = 176
        Width = 31
        Height = 14
        Caption = 'Opis 2'
        FocusControl = AUX_DESC2
      end
      inherited UpdPanel: TPanel
        Top = 592
        Width = 872
        TabOrder = 10
        inherited BUpdChild1: TBitBtn
          Caption = 'Nale'#380'no'#347'ci'
          Visible = True
        end
        inherited BUpdChild2: TBitBtn
          Caption = 'Zobowi'#261'zania'
          Visible = True
        end
      end
      inherited FlexPanel: TPanel
        Left = 8
        Top = 200
        TabOrder = 11
      end
      object ID: TDBEdit
        Left = 785
        Top = 104
        Width = 72
        Height = 22
        Color = clBtnFace
        DataField = 'ID'
        DataSource = Source
        MaxLength = 10
        ReadOnly = True
        TabOrder = 12
      end
      object CUSTOMER_NAME_LINE1: TDBEdit
        Left = 121
        Top = 0
        Width = 296
        Height = 22
        Hint = 'Nazwa'
        DataField = 'CUSTOMER_NAME_LINE1'
        DataSource = Source
        TabOrder = 0
      end
      object CUSTOMER_NAME_LINE2: TDBEdit
        Left = 121
        Top = 24
        Width = 296
        Height = 22
        Hint = 'Nazwa cd.'
        DataField = 'CUSTOMER_NAME_LINE2'
        DataSource = Source
        TabOrder = 1
      end
      object TAX_NUM: TDBEdit
        Left = 121
        Top = 48
        Width = 152
        Height = 22
        Hint = 'NIP'
        DataField = 'TAX_NUM'
        DataSource = Source
        TabOrder = 3
      end
      object STAT_NUM: TDBEdit
        Left = 321
        Top = 48
        Width = 96
        Height = 22
        Hint = 'Regon'
        DataField = 'STAT_NUM'
        DataSource = Source
        TabOrder = 4
      end
      object STR_KEY: TDBEdit
        Left = 121
        Top = 120
        Width = 300
        Height = 22
        Hint = 'Klucz'
        DataField = 'STR_KEY'
        DataSource = Source
        TabOrder = 7
      end
      object BANK_ACCOUNT_NUM: TDBEdit
        Left = 121
        Top = 72
        Width = 296
        Height = 22
        Hint = 'Nr rachunku bankowego'
        DataField = 'BANK_ACCOUNT_NUM'
        DataSource = Source
        TabOrder = 5
      end
      object FEEDER_SYSTEM_REF: TDBEdit
        Left = 121
        Top = 96
        Width = 300
        Height = 22
        Hint = 'Referencja'
        DataField = 'FEEDER_SYSTEM_REF'
        DataSource = Source
        TabOrder = 6
      end
      object AUX_DESC1: TDBEdit
        Left = 121
        Top = 144
        Width = 300
        Height = 22
        Hint = 'Opis 1'
        DataField = 'AUX_DESC1'
        DataSource = Source
        TabOrder = 8
      end
      object AUX_DESC2: TDBEdit
        Left = 121
        Top = 168
        Width = 300
        Height = 22
        Hint = 'Opis 2'
        DataField = 'AUX_DESC2'
        DataSource = Source
        TabOrder = 9
      end
      object AddressBox: TGroupBox
        Left = 424
        Top = 0
        Width = 433
        Height = 97
        Caption = 'Adres'
        TabOrder = 2
        object LabelADDRESS_STREET: TLabel
          Left = 8
          Top = 24
          Width = 94
          Height = 14
          Caption = 'Ulica, nr, nr mieszk.'
          FocusControl = ADDRESS_STREET
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object LabelADDRESS_POSTAL_CODE: TLabel
          Left = 8
          Top = 48
          Width = 71
          Height = 14
          Caption = 'Kod pocztowy'
          FocusControl = ADDRESS_POSTAL_CODE
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object LabelADDRES_PLACE: TLabel
          Left = 200
          Top = 48
          Width = 64
          Height = 14
          Caption = 'Miejscowo'#347#263
          FocusControl = ADDRES_PLACE
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object LabelADDRESS_COUNTRY: TLabel
          Left = 8
          Top = 72
          Width = 19
          Height = 14
          Caption = 'Kraj'
          FocusControl = ADDRESS_COUNTRY
        end
        object ADDRESS_STREET: TDBEdit
          Left = 121
          Top = 16
          Width = 200
          Height = 22
          Hint = 'Ulica'
          DataField = 'ADDRESS_STREET'
          DataSource = Source
          TabOrder = 0
        end
        object ADDRESS_STREET_NUM: TDBEdit
          Left = 329
          Top = 16
          Width = 40
          Height = 22
          Hint = 'Nr'
          DataField = 'ADDRESS_STREET_NUM'
          DataSource = Source
          TabOrder = 1
        end
        object ADDRESS_BUILDING_NUM: TDBEdit
          Left = 377
          Top = 16
          Width = 40
          Height = 22
          Hint = 'Nr mieszkania'
          DataField = 'ADDRESS_BUILDING_NUM'
          DataSource = Source
          TabOrder = 2
        end
        object ADDRESS_POSTAL_CODE: TDBEdit
          Left = 121
          Top = 40
          Width = 64
          Height = 22
          Hint = 'Kod'
          DataField = 'ADDRESS_POSTAL_CODE'
          DataSource = Source
          TabOrder = 3
        end
        object ADDRES_PLACE: TDBEdit
          Left = 272
          Top = 40
          Width = 149
          Height = 22
          Hint = 'Miejscowosc'
          DataField = 'ADDRES_PLACE'
          DataSource = Source
          TabOrder = 4
        end
        object ADDRESS_COUNTRY: TDBEdit
          Left = 121
          Top = 64
          Width = 152
          Height = 22
          DataField = 'ADDRESS_COUNTRY'
          DataSource = Source
          ImeName = 'Kraj'
          TabOrder = 5
        end
      end
    end
  end
  inherited Source: TDataSource
    Left = 488
    Top = 48
  end
  inherited PMenu: TPopupMenu
    Left = 608
    Top = 48
  end
  inherited HolderSortOrder: TStrHolder
    Left = 416
    Top = 400
  end
  inherited GridLayout: TStrHolder
    Left = 448
    Top = 312
  end
  inherited Komunikaty: TStrHolder
    Left = 384
    Top = 312
  end
  inherited ConditionsWhereClause: TStrHolder
    Left = 416
    Top = 368
  end
  inherited AvailColumnsWhereClause: TStrHolder
    Left = 384
    Top = 368
  end
  inherited Others: TStrHolder
    Capacity = 76
    Left = 384
    Top = 336
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
      
        '414c4941533a415454524942535f30313d46494e5f504152544945532e415454' +
        '524942535f3031'
      
        '414c4941533a415454524942535f30323d46494e5f504152544945532e415454' +
        '524942535f3032'
      
        '414c4941533a415454524942535f30333d46494e5f504152544945532e415454' +
        '524942535f3033'
      
        '414c4941533a415454524942535f30343d46494e5f504152544945532e415454' +
        '524942535f3034'
      
        '414c4941533a415454524942535f30353d46494e5f504152544945532e415454' +
        '524942535f3035'
      
        '414c4941533a415454524942535f30363d46494e5f504152544945532e415454' +
        '524942535f3036'
      
        '414c4941533a415454524942535f30373d46494e5f504152544945532e415454' +
        '524942535f3037'
      
        '414c4941533a415454524942535f30383d46494e5f504152544945532e415454' +
        '524942535f3038'
      
        '414c4941533a415454524942535f30393d46494e5f504152544945532e415454' +
        '524942535f3039'
      
        '414c4941533a415454524942535f31303d46494e5f504152544945532e415454' +
        '524942535f3130'
      
        '414c4941533a415454524942535f31313d46494e5f504152544945532e415454' +
        '524942535f3131'
      
        '414c4941533a415454524942535f31323d46494e5f504152544945532e415454' +
        '524942535f3132'
      
        '414c4941533a415454524942535f31333d46494e5f504152544945532e415454' +
        '524942535f3133'
      
        '414c4941533a415454524942535f31343d46494e5f504152544945532e415454' +
        '524942535f3134'
      
        '414c4941533a415454524942535f31353d46494e5f504152544945532e415454' +
        '524942535f3135'
      
        '414c4941533a415454524942445f30313d46494e5f504152544945532e415454' +
        '524942445f3031'
      
        '414c4941533a415454524942445f30323d46494e5f504152544945532e415454' +
        '524942445f3032'
      
        '414c4941533a415454524942445f30333d46494e5f504152544945532e415454' +
        '524942445f3033'
      
        '414c4941533a415454524942445f30343d46494e5f504152544945532e415454' +
        '524942445f3034'
      
        '414c4941533a415454524942445f30353d46494e5f504152544945532e415454' +
        '524942445f3035'
      
        '414c4941533a415454524942445f30363d46494e5f504152544945532e415454' +
        '524942445f3036'
      
        '414c4941533a415454524942445f30373d46494e5f504152544945532e415454' +
        '524942445f3037'
      
        '414c4941533a415454524942445f30383d46494e5f504152544945532e415454' +
        '524942445f3038'
      
        '414c4941533a415454524942445f30393d46494e5f504152544945532e415454' +
        '524942445f3039'
      
        '414c4941533a415454524942445f31303d46494e5f504152544945532e415454' +
        '524942445f3130'
      
        '414c4941533a415454524942445f31313d46494e5f504152544945532e415454' +
        '524942445f3131'
      
        '414c4941533a415454524942445f31323d46494e5f504152544945532e415454' +
        '524942445f3132'
      
        '414c4941533a415454524942445f31333d46494e5f504152544945532e415454' +
        '524942445f3133'
      
        '414c4941533a415454524942445f31343d46494e5f504152544945532e415454' +
        '524942445f3134'
      
        '414c4941533a415454524942445f31353d46494e5f504152544945532e415454' +
        '524942445f3135'
      
        '414c4941533a4154545249424e5f30313d46494e5f504152544945532e415454' +
        '5249424e5f3031'
      
        '414c4941533a4154545249424e5f30323d46494e5f504152544945532e415454' +
        '5249424e5f3032'
      
        '414c4941533a4154545249424e5f30333d46494e5f504152544945532e415454' +
        '5249424e5f3033'
      
        '414c4941533a4154545249424e5f30343d46494e5f504152544945532e415454' +
        '5249424e5f3034'
      
        '414c4941533a4154545249424e5f30353d46494e5f504152544945532e415454' +
        '5249424e5f3035'
      
        '414c4941533a4154545249424e5f30363d46494e5f504152544945532e415454' +
        '5249424e5f3036'
      
        '414c4941533a4154545249424e5f30373d46494e5f504152544945532e415454' +
        '5249424e5f3037'
      
        '414c4941533a4154545249424e5f30383d46494e5f504152544945532e415454' +
        '5249424e5f3038'
      
        '414c4941533a4154545249424e5f30393d46494e5f504152544945532e415454' +
        '5249424e5f3039'
      
        '414c4941533a4154545249424e5f31303d46494e5f504152544945532e415454' +
        '5249424e5f3130'
      
        '414c4941533a4154545249424e5f31313d46494e5f504152544945532e415454' +
        '5249424e5f3131'
      
        '414c4941533a4154545249424e5f31323d46494e5f504152544945532e415454' +
        '5249424e5f3132'
      
        '414c4941533a4154545249424e5f31333d46494e5f504152544945532e415454' +
        '5249424e5f3133'
      
        '414c4941533a4154545249424e5f31343d46494e5f504152544945532e415454' +
        '5249424e5f3134'
      
        '414c4941533a4154545249424e5f31353d46494e5f504152544945532e415454' +
        '5249424e5f3135')
  end
  inherited Messages: TStrHolder
    Left = 416
    Top = 312
  end
  inherited SearchTimer: TTimer
    Left = 544
    Top = 48
  end
  inherited flexPopup: TPopupMenu
    Left = 756
    Top = 36
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    SQL.Strings = (
      'SELECT %TOPRECORDS * '
      'FROM FIN_PARTIES'
      'WHERE %CONDITIONALS AND %SEARCH'
      'AND %CON_FEEDER_SYSTEM_REF'
      '%SORTORDER')
    Left = 452
    Top = 52
  end
end
