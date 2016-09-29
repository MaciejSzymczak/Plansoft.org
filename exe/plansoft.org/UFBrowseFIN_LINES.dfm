inherited FBrowseFIN_LINES: TFBrowseFIN_LINES
  Left = 268
  Top = 100
  Width = 830
  Height = 677
  Caption = 'Linie dokumentu'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 626
    Width = 822
  end
  inherited MainPage: TPageControl
    Width = 822
    Height = 626
    ActivePage = Update
    inherited Browse: TTabSheet
      inherited TopPanel: TPanel
        Width = 814
      end
      inherited Grid: TRxDBGrid
        Top = 121
        Width = 814
        Height = 418
        Columns = <
          item
            Expanded = False
            FieldName = 'DESCRIPTION'
            Title.Caption = 'Opis'
            Width = 350
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UNIT_PRICE'
            Title.Caption = 'Cena jedn.'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QTY'
            Title.Caption = 'Ilo'#347#263
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UOM_DSP'
            Title.Caption = 'jm'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TAX_DSP'
            Title.Caption = 'Kod podatku'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NET_AMOUNT'
            Title.Caption = 'Netto'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TAX_AMOUNT'
            Title.Caption = 'Podatek'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GROSS_AMOUNT'
            Title.Caption = 'Brutto'
            Width = 70
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
            FieldName = 'HEADER_DSP'
            Title.Caption = 'Dokument'
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
            Title.Caption = 'Kol. wpr.'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'HEADER_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'TAX_ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'ATTRIBS_01'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UOM_ID'
            Visible = False
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
        Top = 558
        Width = 814
      end
      inherited Panel: TPanel
        Top = 539
        Width = 814
        inherited StatusBar: TStatusBar
          Width = 745
        end
      end
      inherited CustomPanel: TPanel
        Width = 814
        Height = 34
        object Label4: TLabel
          Left = 10
          Top = 12
          Width = 47
          Height = 14
          Alignment = taRightJustify
          Caption = 'Dokument'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object CON_HEADER_ID: TEdit
          Left = 64
          Top = 4
          Width = 121
          Height = 22
          TabOrder = 0
          Visible = False
          OnChange = CON_HEADER_IDChange
        end
        object CON_HEADER_ID_VALUE: TEdit
          Left = 72
          Top = 4
          Width = 249
          Height = 22
          Hint = 'RODZAJ'
          TabOrder = 1
          OnDblClick = CON_HEADER_ID_VALUEDblClick
        end
        object BSelectCON_HEADER_ID: TBitBtn
          Left = 319
          Top = 2
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = BSelectCON_HEADER_IDClick
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
        object BClearCON_HEADER_ID: TBitBtn
          Left = 344
          Top = 2
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = BClearCON_HEADER_IDClick
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
        Width = 814
      end
    end
    inherited Update: TTabSheet
      object LabelID: TLabel [0]
        Left = 557
        Top = 128
        Width = 44
        Height = 14
        Alignment = taRightJustify
        Caption = 'Kol. wpr.'
        FocusControl = ID
      end
      object LabelHEADER_ID: TLabel [1]
        Left = 66
        Top = 8
        Width = 47
        Height = 14
        Alignment = taRightJustify
        Caption = 'Dokument'
        FocusControl = HEADER_ID
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelDESCRIPTION: TLabel [2]
        Left = 91
        Top = 32
        Width = 22
        Height = 14
        Alignment = taRightJustify
        Caption = 'Opis'
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelUNIT_PRICE: TLabel [3]
        Left = 65
        Top = 56
        Width = 48
        Height = 14
        Alignment = taRightJustify
        Caption = 'Cena jedn'
        FocusControl = UNIT_PRICE
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelQTY: TLabel [4]
        Left = 299
        Top = 56
        Width = 22
        Height = 14
        Alignment = taRightJustify
        Caption = 'Ilo'#347#263
        FocusControl = QTY
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelUOM_ID: TLabel [5]
        Left = 511
        Top = 56
        Width = 10
        Height = 14
        Alignment = taRightJustify
        Caption = 'jm'
        FocusControl = UOM_ID
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelTAX_ID: TLabel [6]
        Left = 53
        Top = 80
        Width = 60
        Height = 14
        Alignment = taRightJustify
        Caption = 'Kod podatku'
        FocusControl = TAX_ID
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelNET_AMOUNT: TLabel [7]
        Left = 88
        Top = 104
        Width = 25
        Height = 14
        Alignment = taRightJustify
        Caption = 'Netto'
        FocusControl = NET_AMOUNT
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelTAX_AMOUNT: TLabel [8]
        Left = 283
        Top = 104
        Width = 38
        Height = 14
        Alignment = taRightJustify
        Caption = 'Podatek'
        FocusControl = TAX_AMOUNT
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelGROSS_AMOUNT: TLabel [9]
        Left = 492
        Top = 104
        Width = 29
        Height = 14
        Alignment = taRightJustify
        Caption = 'Brutto'
        FocusControl = GROSS_AMOUNT
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelAUX_DESC1: TLabel [10]
        Left = 82
        Top = 128
        Width = 31
        Height = 14
        Alignment = taRightJustify
        Caption = 'Opis 1'
        FocusControl = AUX_DESC1
      end
      object LabelAUX_DESC2: TLabel [11]
        Left = 82
        Top = 152
        Width = 31
        Height = 14
        Alignment = taRightJustify
        Caption = 'Opis 2'
        FocusControl = AUX_DESC2
      end
      inherited UpdPanel: TPanel
        Top = 562
        Width = 814
        TabOrder = 20
      end
      inherited FlexPanel: TPanel
        Top = 192
        TabOrder = 21
      end
      object ID: TDBEdit
        Left = 609
        Top = 120
        Width = 72
        Height = 22
        Hint = 'KOL. WPR.'
        Color = clBtnFace
        DataField = 'ID'
        DataSource = Source
        MaxLength = 10
        ReadOnly = True
        TabOrder = 22
      end
      object HEADER_ID: TDBEdit
        Left = 113
        Top = 0
        Width = 150
        Height = 22
        Hint = 'DOKUMENT'
        DataField = 'HEADER_ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 0
        Visible = False
        OnChange = HEADER_IDChange
      end
      object UNIT_PRICE: TDBEdit
        Left = 121
        Top = 48
        Width = 150
        Height = 22
        Hint = 'CENA JEDN.'
        DataField = 'UNIT_PRICE'
        DataSource = Source
        MaxLength = 10
        TabOrder = 5
      end
      object QTY: TDBEdit
        Left = 329
        Top = 48
        Width = 150
        Height = 22
        Hint = 'ILO'#346#262
        DataField = 'QTY'
        DataSource = Source
        MaxLength = 10
        TabOrder = 6
        OnExit = QTYExit
      end
      object UOM_ID: TDBEdit
        Left = 521
        Top = 48
        Width = 150
        Height = 22
        Hint = 'JM'
        DataField = 'UOM_ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 7
        Visible = False
        OnChange = UOM_IDChange
      end
      object TAX_ID: TDBEdit
        Left = 113
        Top = 72
        Width = 150
        Height = 22
        Hint = 'KOD PODATKU'
        DataField = 'TAX_ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 11
        Visible = False
        OnChange = TAX_IDChange
      end
      object NET_AMOUNT: TDBEdit
        Left = 121
        Top = 96
        Width = 150
        Height = 22
        Hint = 'NETTO'
        DataField = 'NET_AMOUNT'
        DataSource = Source
        MaxLength = 10
        TabOrder = 15
      end
      object TAX_AMOUNT: TDBEdit
        Left = 329
        Top = 96
        Width = 150
        Height = 22
        Hint = 'PODATEK'
        DataField = 'TAX_AMOUNT'
        DataSource = Source
        MaxLength = 10
        TabOrder = 16
      end
      object GROSS_AMOUNT: TDBEdit
        Left = 529
        Top = 96
        Width = 150
        Height = 22
        Hint = 'BRUTTO'
        DataField = 'GROSS_AMOUNT'
        DataSource = Source
        MaxLength = 10
        TabOrder = 17
      end
      object AUX_DESC1: TDBEdit
        Left = 121
        Top = 120
        Width = 300
        Height = 22
        Hint = 'OPIS 1'
        DataField = 'AUX_DESC1'
        DataSource = Source
        TabOrder = 18
      end
      object AUX_DESC2: TDBEdit
        Left = 121
        Top = 144
        Width = 300
        Height = 22
        Hint = 'OPIS 2'
        DataField = 'AUX_DESC2'
        DataSource = Source
        TabOrder = 19
      end
      object DESCRIPTION: TDBEdit
        Left = 121
        Top = 24
        Width = 560
        Height = 22
        Hint = 'OPIS'
        DataField = 'DESCRIPTION'
        DataSource = Source
        MaxLength = 500
        TabOrder = 4
      end
      object TAX_ID_VALUE: TEdit
        Left = 121
        Top = 72
        Width = 152
        Height = 22
        Hint = 'RODZAJ'
        Enabled = False
        ReadOnly = True
        TabOrder = 12
        OnDblClick = TAX_ID_VALUEDblClick
      end
      object BSelectTAX_ID: TBitBtn
        Left = 274
        Top = 72
        Width = 24
        Height = 24
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        OnClick = BSelectTAX_IDClick
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
      object BClearTAX_ID: TBitBtn
        Left = 298
        Top = 72
        Width = 25
        Height = 24
        ParentShowHint = False
        ShowHint = True
        TabOrder = 14
        OnClick = BClearTAX_IDClick
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
      object UOM_ID_VALUE: TEdit
        Left = 528
        Top = 48
        Width = 153
        Height = 22
        Hint = 'RODZAJ'
        Enabled = False
        ReadOnly = True
        TabOrder = 8
        OnDblClick = UOM_ID_VALUEDblClick
      end
      object BSelectUOM_ID: TBitBtn
        Left = 680
        Top = 48
        Width = 24
        Height = 24
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = BSelectUOM_IDClick
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
      object BClearUOM_ID: TBitBtn
        Left = 704
        Top = 48
        Width = 25
        Height = 24
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnClick = BClearUOM_IDClick
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
      object BClearHEADER_ID: TBitBtn
        Left = 416
        Top = 0
        Width = 25
        Height = 24
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = BClearHEADER_IDClick
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
      object BSelectHEADER_ID: TBitBtn
        Left = 392
        Top = 0
        Width = 24
        Height = 24
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = BSelectHEADER_IDClick
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
      object HEADER_ID_VALUE: TEdit
        Left = 120
        Top = 0
        Width = 273
        Height = 22
        Hint = 'RODZAJ'
        ReadOnly = True
        TabOrder = 1
        OnDblClick = HEADER_ID_VALUEDblClick
      end
    end
  end
  inherited Source: TDataSource
    Left = 368
    Top = 272
  end
  inherited PMenu: TPopupMenu
    Left = 648
    Top = 144
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
      '414c4941533a415454524942535f30313d4c2e415454524942535f3031'
      '414c4941533a415454524942535f30323d4c2e415454524942535f3032'
      '414c4941533a415454524942535f30333d4c2e415454524942535f3033'
      '414c4941533a415454524942535f30343d4c2e415454524942535f3034'
      '414c4941533a415454524942535f30353d4c2e415454524942535f3035'
      '414c4941533a415454524942535f30363d4c2e415454524942535f3036'
      '414c4941533a415454524942535f30373d4c2e415454524942535f3037'
      '414c4941533a415454524942535f30383d4c2e415454524942535f3038'
      '414c4941533a415454524942535f30393d4c2e415454524942535f3039'
      '414c4941533a415454524942535f31303d4c2e415454524942535f3130'
      '414c4941533a415454524942535f31313d4c2e415454524942535f3131'
      '414c4941533a415454524942535f31323d4c2e415454524942535f3132'
      '414c4941533a415454524942535f31333d4c2e415454524942535f3133'
      '414c4941533a415454524942535f31343d4c2e415454524942535f3134'
      '414c4941533a415454524942535f31353d4c2e415454524942535f3135'
      '414c4941533a415454524942445f30313d4c2e415454524942445f3031'
      '414c4941533a415454524942445f30323d4c2e415454524942445f3032'
      '414c4941533a415454524942445f30333d4c2e415454524942445f3033'
      '414c4941533a415454524942445f30343d4c2e415454524942445f3034'
      '414c4941533a415454524942445f30353d4c2e415454524942445f3035'
      '414c4941533a415454524942445f30363d4c2e415454524942445f3036'
      '414c4941533a415454524942445f30373d4c2e415454524942445f3037'
      '414c4941533a415454524942445f30383d4c2e415454524942445f3038'
      '414c4941533a415454524942445f30393d4c2e415454524942445f3039'
      '414c4941533a415454524942445f31303d4c2e415454524942445f3130'
      '414c4941533a415454524942445f31313d4c2e415454524942445f3131'
      '414c4941533a415454524942445f31323d4c2e415454524942445f3132'
      '414c4941533a415454524942445f31333d4c2e415454524942445f3133'
      '414c4941533a415454524942445f31343d4c2e415454524942445f3134'
      '414c4941533a415454524942445f31353d4c2e415454524942445f3135'
      '414c4941533a4154545249424e5f30313d4c2e4154545249424e5f3031'
      '414c4941533a4154545249424e5f30323d4c2e4154545249424e5f3032'
      '414c4941533a4154545249424e5f30333d4c2e4154545249424e5f3033'
      '414c4941533a4154545249424e5f30343d4c2e4154545249424e5f3034'
      '414c4941533a4154545249424e5f30353d4c2e4154545249424e5f3035'
      '414c4941533a4154545249424e5f30363d4c2e4154545249424e5f3036'
      '414c4941533a4154545249424e5f30373d4c2e4154545249424e5f3037'
      '414c4941533a4154545249424e5f30383d4c2e4154545249424e5f3038'
      '414c4941533a4154545249424e5f30393d4c2e4154545249424e5f3039'
      '414c4941533a4154545249424e5f31303d4c2e4154545249424e5f3130'
      '414c4941533a4154545249424e5f31313d4c2e4154545249424e5f3131'
      '414c4941533a4154545249424e5f31323d4c2e4154545249424e5f3132'
      '414c4941533a4154545249424e5f31333d4c2e4154545249424e5f3133'
      '414c4941533a4154545249424e5f31343d4c2e4154545249424e5f3134'
      '414c4941533a4154545249424e5f31353d4c2e4154545249424e5f3135')
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    AfterOpen = QueryAfterOpen
    SQL.Strings = (
      'select id'
      
        '     , (select num || '#39' z dnia '#39' || to_char(doc_date,'#39'YYYY-MM-DD' +
        #39') from fin_docs where id = l.header_id) header_dsp'
      '     , l.header_id'
      '     , l.description'
      '     , unit_price'
      '     , l.qty'
      
        '     , (select description from fin_lookup_values where lookup_t' +
        'ype = '#39'UOM'#39' and id = l.uom_id) uom_dsp'
      '     , l.uom_id'
      '     , l.tax_id'
      
        '     , (select description from fin_lookup_values where lookup_t' +
        'ype = '#39'TAX'#39' and id = l.tax_id) tax_dsp'
      '     , l.net_amount'
      '     , l.tax_amount'
      '     , l.gross_amount'
      '     , l.aux_desc1'
      '     , l.aux_desc2'
      
        '     , l.attribs_01, l.attribs_02, l.attribs_03, l.attribs_04, l' +
        '.attribs_05, l.attribs_06, l.attribs_07, l.attribs_08, l.attribs' +
        '_09, l.attribs_10, l.attribs_11, l.attribs_12, l.attribs_13, l.a' +
        'ttribs_14, l.attribs_15, l.attribd_01, l.attribd_02, l.attribd_0' +
        '3, l.attribd_04, l.attribd_05, l.attribd_06, l.attribd_07, l.att' +
        'ribd_08, l.attribd_09, l.attribd_10, l.attribd_11, l.attribd_12,' +
        ' l.attribd_13, l.attribd_14, l.attribd_15, l.attribn_01, l.attri' +
        'bn_02, l.attribn_03, l.attribn_04, l.attribn_05, l.attribn_06, l' +
        '.attribn_07, l.attribn_08, l.attribn_09, l.attribn_10, l.attribn' +
        '_11, l.attribn_12, l.attribn_13, l.attribn_14, l.attribn_15'
      
        '     , l.creation_date, l.created_by, l.last_update_date, l.last' +
        '_updated_by'
      '  from fin_lines l'
      'WHERE %CONDITIONALS AND %SEARCH'
      'AND %CON_HEADER_ID'
      '%SORTORDER  ')
    Left = 332
    Top = 268
  end
end
