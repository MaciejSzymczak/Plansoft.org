inherited FBrowseLECTURERS: TFBrowseLECTURERS
  Left = 392
  Top = 265
  Width = 1197
  Height = 724
  Caption = 'Wyk'#322'adowcy'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 673
    Width = 1189
  end
  inherited MainPage: TPageControl
    Width = 1189
    Height = 673
    inherited Browse: TTabSheet
      object Splitter1: TSplitter [0]
        Left = 835
        Top = 121
        Width = 8
        Height = 465
        Align = alRight
      end
      inherited TopPanel: TPanel
        Width = 1181
        object AvailableDsp: TLabel [5]
          Left = 344
          Top = 6
          Width = 63
          Height = 14
          Caption = 'AvailableDsp'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
      end
      inherited Grid: TRxDBGrid
        Top = 121
        Width = 835
        Height = 465
        Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgMultiSelect]
        MultiSelect = True
        Columns = <
          item
            Expanded = False
            FieldName = 'ABBREVIATION'
            Title.Caption = 'Skr'#243't'
            Width = 51
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COLOUR'
            Title.Caption = 'Kolor'
            Width = 42
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TITLE'
            Title.Caption = 'Tytu'#322
            Width = 72
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FIRST_NAME'
            Title.Caption = 'Imi'#281
            Width = 119
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_NAME'
            Title.Caption = 'Nazwisko'
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
            FieldName = 'NAME'
            Title.Caption = 'Nazwa jedn. org.'
            Width = 122
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SC'
            Title.Caption = 'Kod struktury jedn.org.'
            Width = 134
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESC1'
            Title.Caption = 'Przedmioty'
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
          end
          item
            Expanded = False
            FieldName = 'DESC2'
            Title.Caption = 'S'#322'owa kluczowe'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INTEGRATION_ID'
            Title.Caption = 'Integration Id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DIFF_NOTIFICATIONS'
            Title.Caption = 'Email o zmianach'
            Width = 105
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'EMAIL'
            Title.Caption = 'Email'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DIFF_MESSAGE'
            Title.Caption = 'B'#322#261'd podczas powiadamiania'
            Width = 800
            Visible = True
          end>
      end
      inherited BottomPanel: TPanel
        Top = 605
        Width = 1181
        object BMassEdit: TBitBtn
          Left = 88
          Top = 5
          Width = 153
          Height = 28
          Caption = 'Edytuj zestaw'
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
        Top = 586
        Width = 1181
        inherited StatusBar: TStatusBar
          Width = 1112
        end
      end
      inherited CustomPanel: TPanel
        Width = 1181
        Height = 34
        object Label5: TLabel
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
        object CON_ORGUNI_ID: TEdit
          Left = 72
          Top = 4
          Width = 121
          Height = 22
          Hint = 'RODZAJ'
          TabOrder = 0
          Visible = False
          OnChange = CON_ORGUNI_IDChange
        end
        object CON_ORGUNI_ID_VALUE: TEdit
          Left = 80
          Top = 4
          Width = 121
          Height = 22
          ReadOnly = True
          TabOrder = 1
          OnClick = CON_ORGUNI_ID_VALUEClick
        end
        object BSelOU: TBitBtn
          Left = 199
          Top = 2
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Visible = False
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
          Top = 2
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
        object BKonsolidate: TBitBtn
          Left = 853
          Top = 4
          Width = 82
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Scalaj'
          TabOrder = 4
          Visible = False
          OnClick = BKonsolidateClick
        end
        object ttEnabled: TCheckBox
          Tag = 67108864
          Left = 535
          Top = 2
          Width = 203
          Height = 17
          Anchors = [akRight, akBottom]
          Caption = 'Tylko dozwolone kombinacje'
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = ttEnabledClick
        end
        object BMassImport: TBitBtn
          Left = 744
          Top = 4
          Width = 104
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Pobierz z Excel'
          TabOrder = 6
          OnClick = BMassImportClick
        end
      end
      inherited SecondRatePanel: TPanel
        Width = 1181
        inherited BChild3: TBitBtn
          Glyph.Data = {
            4E010000424D4E01000000000000760000002800000012000000120000000100
            040000000000D800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF888FFFFF
            FFFFFF000000FFF88888FFFFFFFFFF000000FFF7FFF7FFFFFFFFFF000000FFF8
            8F88FFFFFFFFFF000000FFFF7778FFFFFFFFFF000000FFFF8777788FFFFFFF00
            0000FFFF877777778FFFFF000000FFFF878F88777FFFFF000000FFFF878FFFF7
            77FFFF000000FFFF878FFFF877FFFF000000FFFF878FFFF8778FFF000000FFFF
            878FFFF7887FFF000000FFFF878FFF88FF88FF000000FFFF7778FF87FF78FF00
            0000FFF88FF7FFF8778FFF000000FFF7FFF7FFFFFFFFFF000000FFF87888FFFF
            FFFFFF000000FFFF888FFFFFFFFFFF000000}
        end
      end
      object RightPage: TPageControl
        Left = 843
        Top = 121
        Width = 338
        Height = 465
        ActivePage = Hierarchy
        Align = alRight
        MultiLine = True
        TabOrder = 6
        TabPosition = tpLeft
        OnMouseDown = RightPageMouseDown
        object Hierarchy: TTabSheet
          Caption = 'Wyk'#322'adowcy zale'#380'ni'
          object rightPane: TPanel
            Left = 0
            Top = 0
            Width = 311
            Height = 457
            Align = alClient
            TabOrder = 0
            object Splitter2: TSplitter
              Left = 1
              Top = 186
              Width = 309
              Height = 8
              Cursor = crVSplit
              Align = alTop
            end
            object pparents: TPanel
              Left = 1
              Top = 25
              Width = 309
              Height = 161
              Align = alTop
              Caption = 'pparents'
              TabOrder = 0
              object PanelDetails: TPanel
                Left = 1
                Top = 1
                Width = 307
                Height = 24
                Align = alTop
                Caption = 'Zasoby nadrz'#281'dne'
                TabOrder = 0
              end
              object Panel4: TPanel
                Left = 1
                Top = 119
                Width = 307
                Height = 41
                Align = alBottom
                TabOrder = 1
                object AddParent: TBitBtn
                  Left = 8
                  Top = 8
                  Width = 113
                  Height = 25
                  Caption = 'Dodaj nadrz'#281'dny'
                  TabOrder = 0
                  OnClick = AddParentClick
                  Glyph.Data = {
                    FE040000424DFE04000000000000360000002800000011000000120000000100
                    200000000000C804000000000000000000000000000000000000C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600000000000000000000000000000000000000
                    000000000000000000000000000000000000000000000000000000000000C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600FFFFFF00FFFFFF000000
                    000000000000FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
                    FF0000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF0000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
                    000000000000FFFFFF0000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF0000000000C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFF
                    FF00000000000000000000000000FFFFFF0000000000C6C3C600C6C3C600C6C3
                    C600C6C3C60000FF00008482840084828400FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C3C600C6C3
                    C600C6C3C600C6C3C60000FF000000820000848284000000000000000000FFFF
                    FF0000000000000000000000000000000000FFFFFF00FFFFFF0000000000C6C3
                    C600C6C3C600C6C3C600C6C3C60000FF00000082000084828400FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000C6C3C60000820000848284008482840000FF000000820000848284008482
                    84008482840084828400FFFFFF00FFFFFF00FFFFFF0000000000000000000000
                    000000000000C6C3C60000FF0000008200000082000000820000008200000082
                    0000008200000082000000820000FFFFFF00FFFFFF00FFFFFF0000000000FFFF
                    FF0000000000C6C3C600C6C3C60000FF000000FF000000FF000000FF00000082
                    00000082000000FF000000FF000000FF0000FFFFFF00FFFFFF00FFFFFF000000
                    000000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C60000FF
                    00000082000084828400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF0000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C60000FF00000082000084828400C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C60000FF000000FF000000FF0000C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600}
                end
                object DelParent: TBitBtn
                  Left = 128
                  Top = 8
                  Width = 57
                  Height = 25
                  Caption = 'Usu'#324
                  TabOrder = 1
                  OnClick = DelParentClick
                  Glyph.Data = {
                    DA090000424DDA0D000000000000360800002800000013000000130000000100
                    200000000000A405000000000000000000000001000000000000000000008080
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
                    0000000000000000000000000000000000000000000000000000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C0000000000000000000000000000000000000000000000000000000
                    00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFF
                    FF00FFFFFF000000000000000000FFFFFF000000000000000000000000000000
                    0000FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF000000000000000000FFFFFF00000000000000000000000000FFFF
                    FF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    000000000000FFFFFF00000000000000000000000000FFFFFF0000000000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
                    00000000000000000000FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0
                    C0000000FF000000800000008000C0C0C000FFFFFF00FFFFFF000000FF000000
                    800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000C0C0C000C0C0C000C0C0C000C0C0C0000000FF000000800000008000FFFF
                    FF000000FF000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C0000000FF00000080000000FF000000800000008000FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF0000000000FFFFFF0000000000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C0000000FF000000800000008000FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000080000000
                    FF000000FF000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000000080000000FF000000FF00C0C0C0000000FF000000800000008000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C0000000FF000000FF000000FF00C0C0C000C0C0C000C0C0
                    C0000000FF000000800000008000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000}
                end
              end
              object GParents: TRxDBGrid
                Left = 1
                Top = 25
                Width = 307
                Height = 94
                Align = alClient
                DataSource = DSParents
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
                ParentFont = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = [fsBold]
                Columns = <
                  item
                    Expanded = False
                    FieldName = 'ID'
                    Visible = False
                  end
                  item
                    Expanded = False
                    FieldName = 'LEVEL'
                    Title.Caption = 'Poziom'
                    Width = 0
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'PARENT_DSP'
                    Title.Caption = 'Nazwa'
                    Width = 160
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'EXCLUSIVE_PARENT'
                    Title.Caption = 'Wy'#347'wietlaj zaj'#281'cia (nie odno'#347'nik)'
                    Width = 200
                    Visible = True
                  end>
              end
            end
            object pdetails: TPanel
              Left = 1
              Top = 194
              Width = 309
              Height = 262
              Align = alClient
              Caption = 'pdetails'
              TabOrder = 1
              object PanelORDERS: TPanel
                Left = 1
                Top = 1
                Width = 307
                Height = 16
                Align = alTop
                Caption = 'Zasoby podrz'#281'dne'
                TabOrder = 0
              end
              object Panel3: TPanel
                Left = 1
                Top = 220
                Width = 307
                Height = 41
                Align = alBottom
                TabOrder = 1
                object AddDetail: TBitBtn
                  Left = 8
                  Top = 8
                  Width = 113
                  Height = 25
                  Caption = 'Dodaj podrz'#281'dny'
                  TabOrder = 0
                  OnClick = AddDetailClick
                  Glyph.Data = {
                    FE040000424DFE04000000000000360000002800000011000000120000000100
                    200000000000C804000000000000000000000000000000000000C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600000000000000000000000000000000000000
                    000000000000000000000000000000000000000000000000000000000000C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600FFFFFF00FFFFFF000000
                    000000000000FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
                    FF0000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF0000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
                    000000000000FFFFFF0000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF0000000000C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFF
                    FF00000000000000000000000000FFFFFF0000000000C6C3C600C6C3C600C6C3
                    C600C6C3C60000FF00008482840084828400FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C3C600C6C3
                    C600C6C3C600C6C3C60000FF000000820000848284000000000000000000FFFF
                    FF0000000000000000000000000000000000FFFFFF00FFFFFF0000000000C6C3
                    C600C6C3C600C6C3C600C6C3C60000FF00000082000084828400FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000C6C3C60000820000848284008482840000FF000000820000848284008482
                    84008482840084828400FFFFFF00FFFFFF00FFFFFF0000000000000000000000
                    000000000000C6C3C60000FF0000008200000082000000820000008200000082
                    0000008200000082000000820000FFFFFF00FFFFFF00FFFFFF0000000000FFFF
                    FF0000000000C6C3C600C6C3C60000FF000000FF000000FF000000FF00000082
                    00000082000000FF000000FF000000FF0000FFFFFF00FFFFFF00FFFFFF000000
                    000000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C60000FF
                    00000082000084828400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF0000000000C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C60000FF00000082000084828400C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C60000FF000000FF000000FF0000C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3C600C6C3
                    C600}
                end
                object delDetail: TBitBtn
                  Left = 128
                  Top = 8
                  Width = 65
                  Height = 25
                  Caption = 'Usu'#324
                  TabOrder = 1
                  OnClick = delDetailClick
                  Glyph.Data = {
                    DA090000424DDA0D000000000000360800002800000013000000130000000100
                    200000000000A405000000000000000000000001000000000000000000008080
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
                    0000000000000000000000000000000000000000000000000000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C0000000000000000000000000000000000000000000000000000000
                    00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFF
                    FF00FFFFFF000000000000000000FFFFFF000000000000000000000000000000
                    0000FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF000000000000000000FFFFFF00000000000000000000000000FFFF
                    FF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    000000000000FFFFFF00000000000000000000000000FFFFFF0000000000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
                    00000000000000000000FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0
                    C0000000FF000000800000008000C0C0C000FFFFFF00FFFFFF000000FF000000
                    800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000C0C0C000C0C0C000C0C0C000C0C0C0000000FF000000800000008000FFFF
                    FF000000FF000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
                    0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C0000000FF00000080000000FF000000800000008000FFFFFF00FFFFFF00FFFF
                    FF00FFFFFF00FFFFFF0000000000FFFFFF0000000000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C0000000FF000000800000008000FFFF
                    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000000080000000
                    FF000000FF000000800000008000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
                    FF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000000080000000FF000000FF00C0C0C0000000FF000000800000008000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C0000000FF000000FF000000FF00C0C0C000C0C0C000C0C0
                    C0000000FF000000800000008000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                    C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000}
                end
              end
              object GDetails: TRxDBGrid
                Left = 1
                Top = 17
                Width = 307
                Height = 203
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
                TabOrder = 2
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clWindowText
                TitleFont.Height = -11
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = [fsBold]
                OnTitleClick = GridTitleClick
                Columns = <
                  item
                    Expanded = False
                    FieldName = 'LEVEL'
                    Title.Caption = 'Poziom'
                    Width = 0
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'NAME'
                    Title.Caption = 'Nazwa'
                    Width = 160
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'EXCLUSIVE_PARENT'
                    Title.Caption = 'Wy'#347'wietlaj zaj'#281'cia (nie odno'#347'nik)'
                    Width = 195
                    Visible = True
                  end>
              end
            end
            object Panel5: TPanel
              Left = 1
              Top = 1
              Width = 309
              Height = 24
              Align = alTop
              TabOrder = 2
              object Label6: TLabel
                Left = 8
                Top = 8
                Width = 83
                Height = 14
                Caption = 'Rodzaj hierarchii:'
              end
              object str_name_lov: TComboBox
                Left = 96
                Top = 0
                Width = 145
                Height = 22
                Style = csDropDownList
                ItemHeight = 14
                ItemIndex = 0
                TabOrder = 0
                Text = 'Potok'
                OnChange = str_name_lovChange
                Items.Strings = (
                  'Potok'
                  'Struktura organizacyjna'
                  'Inne')
              end
            end
          end
        end
      end
    end
    inherited Update: TTabSheet
      object LabelID: TLabel [0]
        Left = 88
        Top = 8
        Width = 8
        Height = 14
        Caption = 'Id'
        FocusControl = ID_
        Visible = False
      end
      object LabelTITLE: TLabel [1]
        Left = 91
        Top = 88
        Width = 22
        Height = 14
        Alignment = taRightJustify
        Caption = 'Tytu'#322
        FocusControl = TITLE
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelABBREVIATION: TLabel [2]
        Left = 88
        Top = 40
        Width = 25
        Height = 14
        Alignment = taRightJustify
        Caption = 'Skr'#243't'
        FocusControl = ABBREVIATION
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelFIRST_NAME: TLabel [3]
        Left = 95
        Top = 112
        Width = 18
        Height = 14
        Alignment = taRightJustify
        Caption = 'Imi'#281
        FocusControl = FIRST_NAME
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelLAST_NAME: TLabel [4]
        Left = 65
        Top = 136
        Width = 48
        Height = 14
        Alignment = taRightJustify
        Caption = 'Nazwisko'
        FocusControl = LAST_NAME
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelCOLOUR: TLabel [5]
        Left = 88
        Top = 64
        Width = 25
        Height = 14
        Alignment = taRightJustify
        Caption = 'Kolor'
      end
      object Shape1: TShape [6]
        Left = 120
        Top = 56
        Width = 41
        Height = 21
        OnMouseUp = Shape1MouseUp
      end
      object Label2: TLabel [7]
        Left = 60
        Top = 184
        Width = 53
        Height = 14
        Alignment = taRightJustify
        Caption = 'Przedmioty'
      end
      object Label3: TLabel [8]
        Left = 32
        Top = 208
        Width = 81
        Height = 14
        Alignment = taRightJustify
        Caption = 'S'#322'owa kluczowe'
      end
      object Label4: TLabel [9]
        Left = 424
        Top = 104
        Width = 286
        Height = 14
        Caption = 'TITLE IS REQUIRED BY FUNCTION FDETAILS.VALIDVALUES'
        Visible = False
      end
      object LabelORGUNI_ID: TLabel [10]
        Left = 16
        Top = 163
        Width = 97
        Height = 14
        Alignment = taRightJustify
        Caption = 'Jedn. organizacyjna'
        FocusControl = ORGUNI_ID
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LEmail: TLabel [11]
        Left = 529
        Top = 40
        Width = 24
        Height = 14
        Alignment = taRightJustify
        Caption = 'Email'
        FocusControl = EMAIL
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LabelROL_ID: TLabel [12]
        Left = 526
        Top = 83
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Portal'
        FocusControl = ROL_ID
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object SpeedButton2: TSpeedButton [13]
        Left = 737
        Top = 177
        Width = 24
        Height = 24
        Flat = True
        Glyph.Data = {
          76060000424D7606000000000000360000002800000014000000140000000100
          2000000000004006000000000000000000000000000000000000FFFEFE00FEFE
          FF00FFFEFD00FDFCF900FFFFFF00FDFEFB00EEDBC300E6BB8500DAA56A00D499
          6000D7955D00D19C6500D8A97900E3C1A400E5E2DB00F2F8FA00FEFDFC00FFFF
          FE00FEFEFE00FEFEFE00F8FDFE00FFFEF600F6FAFC00F6FFFF00F0DFC400DE9F
          5600E2883300ED8F3600F59B3E00FAA04300FC9F4600F7A04100F2983C00E188
          4000CE884F00D9B39000DAE6E600F6F9FB00FBFFF900F9FDFE00F8FEFC00F6FB
          F900FFFFFC00E7C68D00D8872A00F79D3500FFAA5300FFAA5900FFAD5700FFAE
          5500FFAF5500FFB05A00FFB25F00FFB36100FCAA5800E0864500C5926A00D4DA
          CD00FCF2F800FEFEFF00FCFCF700F6FFFF00E1BE8900E58A1E00FEAC4C00FDAD
          5600FDA94E00FEAA4F00F7AA5800ECAA5C00F0AB5B00F7AE5E00FCAF6000FEB1
          6200FBB56600FDB96E00F09A3F00CD876200D6D5D700F3FBF400FDFFFF00E7D3
          AA00D7882500FFAE5500FAAC5700FCAB5300FEAE5500FBAA5200ECBB7E00F6ED
          D100F5EDDD00EFCE9200F3AF5F00FFB36700FDB66400F7B56900FCBF7300EA95
          4C00BE936E00E4E5E200F8F5E600E4943000F8A94900FAAD5900FEAD5500FCAE
          5700FAB05D00FAAC5400E6C39200FDFFFF00FBFFFF00F2D6AB00F5AC6400FCB7
          6C00FBB96900FFB56F00F5B57600F9C37500E0884700E1B29C00E0C49800EF92
          2800FDB26200FAAC5D00FEAF5D00FCB05F00FCB36000FDB15E00F3BB7800F7DD
          AE00F4DDB900F7C48B00FEB06A00FBBA6E00F9BB7200FEB97500FABB7500FBC0
          7C00F4AD6600CE8A5F00DEA65800F8A34900FEB16100FDB06100FEB26300FDB3
          6300FDB46400FDB36A00FBB46800F3B06300EEAE6A00F2B46F00FFB97200FCBB
          7100FABB7900FEBB7B00FBBD7B00FBBF7C00FFC28000D1895200EA9E2F00FEB0
          5E00FDB16400FEB36200FEB46700FDB56800FEB86900FAB36600F2CD9D00F9F1
          DF00F9F0E200F3D6AA00F5B37700FBBE7D00FBBD7E00FDBE7F00FDC07F00FDC0
          7F00FEC98900E4975100EC9C3000FEB66100FBB66300FEB36800FEB56900FDB7
          6C00FEBA7000F9B76C00F0C5A000F8FFFF00F6FFFF00F9F4E700E6BE9200FBBC
          7D00FFC28100FBC08300FBC18300FCC28400FECB8F00EAA15800E99C3700FFB8
          6600FBB56C00FEB66E00FEB96D00FEBA7200FDBB7500FCBD7700F6B67800F2DB
          B600FCFFFA00FBFEFF00FBF4E300F2C69700FAC08300FBC38600FBC48800FCC5
          8800FECE9300E9A15B00E59C3B00FEB86800FCB57600FDBA7000FDBB7200FCBC
          7600FBBD7900FCBD7B00FFC27600F5BB7B00F2DABE00FAFDFC00FCFFFF00FAF2
          E100F2C49000FEC58900FDC58D00FCC58C00FED19700E29A5900E8A74D00F7B1
          5F00FEBB7A00FDBE7000FCBE7800FBBF7A00FCC07E00FABB7B00F3C07C00FFC1
          8200F5BA8000F8E9D700F6FEFE00F6FFFC00F2D6AD00FCC48A00FEC99200FDC8
          9100FFCF9800D2905200EAC38300EDA14300FBC28500FCBB7C00FDC17B00FCC2
          7700F1C79800F6DFBF00EDC99B00F3C38B00F3C58E00FAECDA00FAFDFE00F9FE
          FE00F3D8BA00FBC29600F8CD9300FDCDA100F8BF8300CF935C00F3F1DF00DF9A
          3200FFC17100F6C08900FBC08500FEC07C00EECA9C00FBFFFF00FCFCF700F7F2
          E500F6F5ED00FAFEFE00F9FFFF00FCFCF200F4D0A700FBCC9500FCC7A000FFDB
          A200DC954F00E9C5A300F9FFFF00EDCE9400E2973400FCCC8C00FBC28A00FEC0
          8400F4C89400F3EDE200F9F9F700FCFFFE00F9FFFF00FAFBF900FAF5E800F0D8
          B800F8CA9A00FECE9600FEDCAE00E5AE6B00DC9B6B00FEFDF600FCFCFC00FDFF
          FD00DEB97200EA9D3400FFCD8F00FCCB9200FBC39100F5C49300F7CD9E00F9D4
          AC00F9D6B000F7D2AF00F7CC9E00FACB9500FFCEA500FFDCB300EBB36900D292
          5B00F7F2EB00FFFCFF00FFFDFD00FCFCFE00FFFFFB00E4BE7D00D9983B00F8C1
          7000FCD29D00FDD1A100FECD9D00FBCB9E00F9CC9F00FED09F00FCD6AB00FCDA
          B100FCD09B00DDA25700D39D6400FBF2E900F8FFFF00FEFCFC00FEFEFE00FEFE
          FD00FDFDFE00FFFFFF00ECDEB300D4A64E00E29E4900EFB46700F8C67D00FACC
          8D00F5CB9600F6C88D00F2BD7500E4A65800D5994D00E0C29200FBFFF200F3FE
          FF00F6FDFB00FEFEFB00FEFFFE00FEFEFE00FEFEFD00F8FDFA00FCFFFF00FCFB
          FE00EEDDB100E4BD7800DEAE6500DCA85600E4AB5000DAA96200E2B47500EACF
          A200F8F5EB00FFFFFF00FAFCFE00FAFCFD00FFFEFC00FEFEFB00}
        OnClick = SpeedButton2Click
      end
      object SpeedButton3: TSpeedButton [14]
        Left = 737
        Top = 201
        Width = 24
        Height = 24
        Flat = True
        Glyph.Data = {
          76060000424D7606000000000000360000002800000014000000140000000100
          2000000000004006000000000000000000000000000000000000FFFEFE00FEFE
          FF00FFFEFD00FDFCF900FFFFFF00FDFEFB00EEDBC300E6BB8500DAA56A00D499
          6000D7955D00D19C6500D8A97900E3C1A400E5E2DB00F2F8FA00FEFDFC00FFFF
          FE00FEFEFE00FEFEFE00F8FDFE00FFFEF600F6FAFC00F6FFFF00F0DFC400DE9F
          5600E2883300ED8F3600F59B3E00FAA04300FC9F4600F7A04100F2983C00E188
          4000CE884F00D9B39000DAE6E600F6F9FB00FBFFF900F9FDFE00F8FEFC00F6FB
          F900FFFFFC00E7C68D00D8872A00F79D3500FFAA5300FFAA5900FFAD5700FFAE
          5500FFAF5500FFB05A00FFB25F00FFB36100FCAA5800E0864500C5926A00D4DA
          CD00FCF2F800FEFEFF00FCFCF700F6FFFF00E1BE8900E58A1E00FEAC4C00FDAD
          5600FDA94E00FEAA4F00F7AA5800ECAA5C00F0AB5B00F7AE5E00FCAF6000FEB1
          6200FBB56600FDB96E00F09A3F00CD876200D6D5D700F3FBF400FDFFFF00E7D3
          AA00D7882500FFAE5500FAAC5700FCAB5300FEAE5500FBAA5200ECBB7E00F6ED
          D100F5EDDD00EFCE9200F3AF5F00FFB36700FDB66400F7B56900FCBF7300EA95
          4C00BE936E00E4E5E200F8F5E600E4943000F8A94900FAAD5900FEAD5500FCAE
          5700FAB05D00FAAC5400E6C39200FDFFFF00FBFFFF00F2D6AB00F5AC6400FCB7
          6C00FBB96900FFB56F00F5B57600F9C37500E0884700E1B29C00E0C49800EF92
          2800FDB26200FAAC5D00FEAF5D00FCB05F00FCB36000FDB15E00F3BB7800F7DD
          AE00F4DDB900F7C48B00FEB06A00FBBA6E00F9BB7200FEB97500FABB7500FBC0
          7C00F4AD6600CE8A5F00DEA65800F8A34900FEB16100FDB06100FEB26300FDB3
          6300FDB46400FDB36A00FBB46800F3B06300EEAE6A00F2B46F00FFB97200FCBB
          7100FABB7900FEBB7B00FBBD7B00FBBF7C00FFC28000D1895200EA9E2F00FEB0
          5E00FDB16400FEB36200FEB46700FDB56800FEB86900FAB36600F2CD9D00F9F1
          DF00F9F0E200F3D6AA00F5B37700FBBE7D00FBBD7E00FDBE7F00FDC07F00FDC0
          7F00FEC98900E4975100EC9C3000FEB66100FBB66300FEB36800FEB56900FDB7
          6C00FEBA7000F9B76C00F0C5A000F8FFFF00F6FFFF00F9F4E700E6BE9200FBBC
          7D00FFC28100FBC08300FBC18300FCC28400FECB8F00EAA15800E99C3700FFB8
          6600FBB56C00FEB66E00FEB96D00FEBA7200FDBB7500FCBD7700F6B67800F2DB
          B600FCFFFA00FBFEFF00FBF4E300F2C69700FAC08300FBC38600FBC48800FCC5
          8800FECE9300E9A15B00E59C3B00FEB86800FCB57600FDBA7000FDBB7200FCBC
          7600FBBD7900FCBD7B00FFC27600F5BB7B00F2DABE00FAFDFC00FCFFFF00FAF2
          E100F2C49000FEC58900FDC58D00FCC58C00FED19700E29A5900E8A74D00F7B1
          5F00FEBB7A00FDBE7000FCBE7800FBBF7A00FCC07E00FABB7B00F3C07C00FFC1
          8200F5BA8000F8E9D700F6FEFE00F6FFFC00F2D6AD00FCC48A00FEC99200FDC8
          9100FFCF9800D2905200EAC38300EDA14300FBC28500FCBB7C00FDC17B00FCC2
          7700F1C79800F6DFBF00EDC99B00F3C38B00F3C58E00FAECDA00FAFDFE00F9FE
          FE00F3D8BA00FBC29600F8CD9300FDCDA100F8BF8300CF935C00F3F1DF00DF9A
          3200FFC17100F6C08900FBC08500FEC07C00EECA9C00FBFFFF00FCFCF700F7F2
          E500F6F5ED00FAFEFE00F9FFFF00FCFCF200F4D0A700FBCC9500FCC7A000FFDB
          A200DC954F00E9C5A300F9FFFF00EDCE9400E2973400FCCC8C00FBC28A00FEC0
          8400F4C89400F3EDE200F9F9F700FCFFFE00F9FFFF00FAFBF900FAF5E800F0D8
          B800F8CA9A00FECE9600FEDCAE00E5AE6B00DC9B6B00FEFDF600FCFCFC00FDFF
          FD00DEB97200EA9D3400FFCD8F00FCCB9200FBC39100F5C49300F7CD9E00F9D4
          AC00F9D6B000F7D2AF00F7CC9E00FACB9500FFCEA500FFDCB300EBB36900D292
          5B00F7F2EB00FFFCFF00FFFDFD00FCFCFE00FFFFFB00E4BE7D00D9983B00F8C1
          7000FCD29D00FDD1A100FECD9D00FBCB9E00F9CC9F00FED09F00FCD6AB00FCDA
          B100FCD09B00DDA25700D39D6400FBF2E900F8FFFF00FEFCFC00FEFEFE00FEFE
          FD00FDFDFE00FFFFFF00ECDEB300D4A64E00E29E4900EFB46700F8C67D00FACC
          8D00F5CB9600F6C88D00F2BD7500E4A65800D5994D00E0C29200FBFFF200F3FE
          FF00F6FDFB00FEFEFB00FEFFFE00FEFEFE00FEFEFD00F8FDFA00FCFFFF00FCFB
          FE00EEDDB100E4BD7800DEAE6500DCA85600E4AB5000DAA96200E2B47500EACF
          A200F8F5EB00FFFFFF00FAFCFE00FAFCFD00FFFEFC00FEFEFB00}
        OnClick = SpeedButton3Click
      end
      object LINTEGRATION_ID: TLabel [15]
        Left = 864
        Top = 1
        Width = 9
        Height = 14
        Alignment = taRightJustify
        Caption = 'ID'
        FocusControl = EMAIL
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      inherited UpdPanel: TPanel
        Top = 609
        Width = 1181
        TabOrder = 8
        inherited BUpdChild1: TBitBtn
          Left = 88
          Caption = 'Zaj'#281'cia'
          Visible = True
        end
        inherited BUpdChild2: TBitBtn
          Left = 168
          Caption = 'Finanse'
          Visible = True
        end
        inherited BUpdChild3: TBitBtn
          Left = 248
          Caption = 'Dost'#281'p'
          Visible = True
          Glyph.Data = {
            4E010000424D4E01000000000000760000002800000012000000120000000100
            040000000000D800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF888FFFFF
            FFFFFF000000FFF88888FFFFFFFFFF000000FFF7FFF7FFFFFFFFFF000000FFF8
            8F88FFFFFFFFFF000000FFFF7778FFFFFFFFFF000000FFFF8777788FFFFFFF00
            0000FFFF877777778FFFFF000000FFFF878F88777FFFFF000000FFFF878FFFF7
            77FFFF000000FFFF878FFFF877FFFF000000FFFF878FFFF8778FFF000000FFFF
            878FFFF7887FFF000000FFFF878FFF88FF88FF000000FFFF7778FF87FF78FF00
            0000FFF88FF7FFF8778FFF000000FFF7FFF7FFFFFFFFFF000000FFF87888FFFF
            FFFFFF000000FFFF888FFFFFFFFFFF000000}
        end
      end
      object ID_: TDBEdit [17]
        Left = 113
        Top = 0
        Width = 150
        Height = 22
        Hint = 'ID'
        Color = clMenu
        DataField = 'ID'
        DataSource = Source
        MaxLength = 10
        ReadOnly = True
        TabOrder = 9
        Visible = False
      end
      object TITLE: TDBEdit [18]
        Left = 120
        Top = 80
        Width = 300
        Height = 22
        Hint = 'TYTU'#321
        DataField = 'TITLE'
        DataSource = Source
        TabOrder = 2
      end
      object ABBREVIATION: TDBEdit [19]
        Left = 120
        Top = 32
        Width = 300
        Height = 22
        Hint = 'SKR'#211'T'
        DataField = 'ABBREVIATION'
        DataSource = Source
        TabOrder = 0
      end
      object FIRST_NAME: TDBEdit [20]
        Left = 120
        Top = 104
        Width = 300
        Height = 22
        Hint = 'IMI'#280
        DataField = 'FIRST_NAME'
        DataSource = Source
        TabOrder = 3
      end
      object LAST_NAME: TDBEdit [21]
        Left = 120
        Top = 128
        Width = 300
        Height = 22
        Hint = 'NAZWISKO'
        DataField = 'LAST_NAME'
        DataSource = Source
        TabOrder = 4
      end
      object DESC1: TDBEdit [22]
        Left = 120
        Top = 176
        Width = 617
        Height = 22
        DataField = 'DESC1'
        DataSource = Source
        TabOrder = 10
      end
      object DESC2: TDBEdit [23]
        Left = 120
        Top = 200
        Width = 617
        Height = 22
        DataField = 'DESC2'
        DataSource = Source
        TabOrder = 11
      end
      object ORGUNI_ID: TDBEdit [24]
        Left = 113
        Top = 152
        Width = 150
        Height = 22
        Hint = 'JEDNOSTKA ORGANIZACYJNA'
        DataField = 'ORGUNI_ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 5
        Visible = False
        OnChange = ORGUNI_IDChange
      end
      object ORGUNI_ID_VALUE: TEdit [25]
        Left = 120
        Top = 152
        Width = 257
        Height = 22
        Hint = 'JEDNOSTKA ORGANIZACYJNA'
        ReadOnly = True
        TabOrder = 6
        OnClick = ORGUNI_ID_VALUEClick
      end
      object BSelectORGUNI_ID: TBitBtn [26]
        Left = 376
        Top = 152
        Width = 24
        Height = 24
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        Visible = False
        OnClick = BSelectORGUNI_IDClick
        Glyph.Data = {
          42020000424D4202000000000000420000002800000010000000100000000100
          1000030000000002000000000000000000000000000000000000007C0000E003
          00001F0000001863186318631863186318631863104200001863186318631863
          186318631863186318631863186318631863F702F70210420000186318631863
          18631863186318631863186318631863F702F702F702F7021042000018631863
          1863186318631863186318631863F702F702F702F702F702F702104200001863
          186318631863186318631863F702F702F702F702F702F702F702F70210420000
          18631863186318631863F702F702F702F702F702F702F702F702F702F7021042
          0000186318631863F702F702F702F702F702F702F702F702F702F702F702F702
          104200001863FF03FF03FF03FF03FF03FF03F702F702F702F7021042FF03FF03
          FF031042000018631863186318631863FF03F702F702F702F702000018631863
          18631863186318631863186318631863FF03F702F702F702F702000018631863
          18631863186318631863186318631863FF03F702F702F702F702000018631863
          18631863186318631863186318631863FF03F702F702F702F702000018631863
          18631863186318631863186318631863FF03F702F702F702F702000018631863
          18631863186318631863186318631863FF03F702F702F702F702000018631863
          18631863186318631863186318631863FF03F702F702F702F702000018631863
          18631863186318631863186318631863FF03FF03FF03FF03FF03FF0318631863
          186318631863}
      end
      inherited FlexPanel: TPanel
        Left = 4
        Top = 232
        Width = 861
        Height = 305
        TabOrder = 12
      end
      object EMAIL: TDBEdit
        Left = 584
        Top = 40
        Width = 253
        Height = 22
        Hint = 'EMAIL'
        DataField = 'EMAIL'
        DataSource = Source
        TabOrder = 1
      end
      object ROL_ID: TDBEdit
        Left = 577
        Top = 80
        Width = 150
        Height = 22
        Hint = 'DOMY'#346'LNA AUTORYZACJA'
        DataField = 'ROL_ID'
        DataSource = Source
        MaxLength = 10
        TabOrder = 13
        Visible = False
        OnChange = ROL_IDChange
      end
      object ROL_ID_VALUE: TEdit
        Left = 584
        Top = 80
        Width = 249
        Height = 22
        Hint = 'RODZAJ'
        ReadOnly = True
        TabOrder = 14
        Visible = False
      end
      object DIFF_NOTIFICATIONS: TDBCheckBox
        Left = 584
        Top = 64
        Width = 129
        Height = 17
        Hint = 'Wysy'#322'aj do tego wyk'#322'adowcy email o zmianach w rozk'#322'adach zaj'#281#263'. '
        Caption = 'Email o zmianach'
        DataField = 'DIFF_NOTIFICATIONS'
        DataSource = Source
        TabOrder = 15
        ValueChecked = '+'
        ValueUnchecked = '-'
      end
      object INTEGRATION_ID: TDBEdit
        Left = 880
        Top = 1
        Width = 300
        Height = 22
        Hint = 'SKR'#211'T'
        DataField = 'INTEGRATION_ID'
        DataSource = Source
        TabOrder = 16
        Visible = False
      end
    end
  end
  inherited PMenu: TPopupMenu
    Left = 472
    Top = 208
  end
  inherited HolderSortOrder: TStrHolder
    Capacity = 12
    StrData = (
      ''
      '4c45435455524552532e414242524556494154494f4e7c536b72f374'
      '4c45435455524552532e434f4c4f55527c4b6f6c6f72'
      '4c45435455524552532e5449544c457c54797475b3'
      
        '636f6e636174284c45435455524552532e4c4153545f4e414d452c4c45435455' +
        '524552532e46495253545f4e414d45297c4e617a7769736b6f206920696d69ea'
      
        '4c45435455524552532e494420444553437c4f737461746e696f20646f64616e' +
        '69'
      '4f52475f554e4954532e4e414d457c4e617a7761206a65646e2e206f72672e'
      
        '4f52475f554e4954532e5354525543545f434f44457c4b6f6420737472756b74' +
        '757279206a65646e2e6f72672e'
      '4c45435455524552532e454d41494c7c456d61696c'
      '504c414e4e4552532e4e414d457c50727a65676cb96461726b61'
      '')
  end
  inherited GridLayout: TStrHolder
    Left = 608
    Top = 232
  end
  inherited Komunikaty: TStrHolder
    Left = 376
    Top = 288
  end
  inherited AvailColumnsWhereClause: TStrHolder
    Capacity = 28
    Top = 232
    StrData = (
      ''
      '456d61696c7c454d41494c7c6674537472696e67'
      '496d69ea7c46495253545f4e414d457c6674537472696e67'
      
        '4a65646e2e206f72672e3a206b6f6420737472756b747572797c2873656c6563' +
        '74205354525543545f434f44452066726f6d206f72675f756e69747320776865' +
        '7265206f72675f756e6974732e6964203d206f7267756e695f6964297c667453' +
        '7472696e67'
      
        '4a65646e2e206f72672e3a206e617a77617c2873656c656374206e616d652066' +
        '726f6d206f72675f756e697473207768657265206f72675f756e6974732e6964' +
        '203d206f7267756e695f6964297c6674537472696e67'
      
        '4a65646e2e206f72672e3a206f70697320317c2873656c656374206465736331' +
        '2066726f6d206f72675f756e697473207768657265206f72675f756e6974732e' +
        '6964203d206f7267756e695f6964297c6674537472696e67'
      
        '4a65646e2e206f72672e3a206f70697320327c2873656c656374206465736332' +
        '2066726f6d206f72675f756e697473207768657265206f72675f756e6974732e' +
        '6964203d206f7267756e695f6964297c6674537472696e67'
      
        '4a65646e2e206f72672e3a206f737461746e6920637ab36f6e206b6f64757c28' +
        '73656c65637420636f64652066726f6d206f72675f756e697473207768657265' +
        '206f72675f756e6974732e6964203d206f7267756e695f6964297c6674537472' +
        '696e67'
      '4e617a7769736b6f7c4c4153545f4e414d457c6674537472696e67'
      
        '506c616e6f77616e69652070727a657a2070727a65676cb96461726bea7c504c' +
        '414e4e4552532e4e414d457c6674537472696e67'
      '536b72f3747c414242524556494154494f4e7c6674537472696e67'
      '54797475b37c5449544c457c6674537472696e67'
      
        '57796bb361646f7763612d206f70697320317c4c45435455524552532e444553' +
        '43317c6674537472696e67'
      
        '57796bb361646f7763612d206f70697320327c4c45435455524552532e444553' +
        '43327c6674537472696e67')
  end
  inherited Others: TStrHolder
    Capacity = 95
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
      
        '414c4941533a415454524942535f30313d4c45435455524552532e4154545249' +
        '42535f3031'
      
        '414c4941533a415454524942535f30323d4c45435455524552532e4154545249' +
        '42535f3032'
      
        '414c4941533a415454524942535f30333d4c45435455524552532e4154545249' +
        '42535f3033'
      
        '414c4941533a415454524942535f30343d4c45435455524552532e4154545249' +
        '42535f3034'
      
        '414c4941533a415454524942535f30353d4c45435455524552532e4154545249' +
        '42535f3035'
      
        '414c4941533a415454524942535f30363d4c45435455524552532e4154545249' +
        '42535f3036'
      
        '414c4941533a415454524942535f30373d4c45435455524552532e4154545249' +
        '42535f3037'
      
        '414c4941533a415454524942535f30383d4c45435455524552532e4154545249' +
        '42535f3038'
      
        '414c4941533a415454524942535f30393d4c45435455524552532e4154545249' +
        '42535f3039'
      
        '414c4941533a415454524942535f31303d4c45435455524552532e4154545249' +
        '42535f3130'
      
        '414c4941533a415454524942535f31313d4c45435455524552532e4154545249' +
        '42535f3131'
      
        '414c4941533a415454524942535f31323d4c45435455524552532e4154545249' +
        '42535f3132'
      
        '414c4941533a415454524942535f31333d4c45435455524552532e4154545249' +
        '42535f3133'
      
        '414c4941533a415454524942535f31343d4c45435455524552532e4154545249' +
        '42535f3134'
      
        '414c4941533a415454524942535f31353d4c45435455524552532e4154545249' +
        '42535f3135'
      
        '414c4941533a415454524942445f30313d4c45435455524552532e4154545249' +
        '42445f3031'
      
        '414c4941533a415454524942445f30323d4c45435455524552532e4154545249' +
        '42445f3032'
      
        '414c4941533a415454524942445f30333d4c45435455524552532e4154545249' +
        '42445f3033'
      
        '414c4941533a415454524942445f30343d4c45435455524552532e4154545249' +
        '42445f3034'
      
        '414c4941533a415454524942445f30353d4c45435455524552532e4154545249' +
        '42445f3035'
      
        '414c4941533a415454524942445f30363d4c45435455524552532e4154545249' +
        '42445f3036'
      
        '414c4941533a415454524942445f30373d4c45435455524552532e4154545249' +
        '42445f3037'
      
        '414c4941533a415454524942445f30383d4c45435455524552532e4154545249' +
        '42445f3038'
      
        '414c4941533a415454524942445f30393d4c45435455524552532e4154545249' +
        '42445f3039'
      
        '414c4941533a415454524942445f31303d4c45435455524552532e4154545249' +
        '42445f3130'
      
        '414c4941533a415454524942445f31313d4c45435455524552532e4154545249' +
        '42445f3131'
      
        '414c4941533a415454524942445f31323d4c45435455524552532e4154545249' +
        '42445f3132'
      
        '414c4941533a415454524942445f31333d4c45435455524552532e4154545249' +
        '42445f3133'
      
        '414c4941533a415454524942445f31343d4c45435455524552532e4154545249' +
        '42445f3134'
      
        '414c4941533a415454524942445f31353d4c45435455524552532e4154545249' +
        '42445f3135'
      
        '414c4941533a4154545249424e5f30313d4c45435455524552532e4154545249' +
        '424e5f3031'
      
        '414c4941533a4154545249424e5f30323d4c45435455524552532e4154545249' +
        '424e5f3032'
      
        '414c4941533a4154545249424e5f30333d4c45435455524552532e4154545249' +
        '424e5f3033'
      
        '414c4941533a4154545249424e5f30343d4c45435455524552532e4154545249' +
        '424e5f3034'
      
        '414c4941533a4154545249424e5f30353d4c45435455524552532e4154545249' +
        '424e5f3035'
      
        '414c4941533a4154545249424e5f30363d4c45435455524552532e4154545249' +
        '424e5f3036'
      
        '414c4941533a4154545249424e5f30373d4c45435455524552532e4154545249' +
        '424e5f3037'
      
        '414c4941533a4154545249424e5f30383d4c45435455524552532e4154545249' +
        '424e5f3038'
      
        '414c4941533a4154545249424e5f30393d4c45435455524552532e4154545249' +
        '424e5f3039'
      
        '414c4941533a4154545249424e5f31303d4c45435455524552532e4154545249' +
        '424e5f3130'
      
        '414c4941533a4154545249424e5f31313d4c45435455524552532e4154545249' +
        '424e5f3131'
      
        '414c4941533a4154545249424e5f31323d4c45435455524552532e4154545249' +
        '424e5f3132'
      
        '414c4941533a4154545249424e5f31333d4c45435455524552532e4154545249' +
        '424e5f3133'
      
        '414c4941533a4154545249424e5f31343d4c45435455524552532e4154545249' +
        '424e5f3134'
      
        '414c4941533a4154545249424e5f31353d4c45435455524552532e4154545249' +
        '424e5f3135'
      '414c4941533a524f4c455f4e414d453d504c414e4e4552532e4e414d45'
      
        '414c4941533a414242524556494154494f4e3d4c45435455524552532e414242' +
        '524556494154494f4e'
      '414c4941533a434f4c4f55523d4c45435455524552532e434f4c4f5552'
      '414c4941533a5449544c453d4c45435455524552532e5449544c45'
      
        '414c4941533a46495253545f4e414d453d4c45435455524552532e4649525354' +
        '5f4e414d45'
      
        '414c4941533a4c4153545f4e414d453d4c45435455524552532e4c4153545f4e' +
        '414d45'
      '414c4941533a49443d4c45435455524552532e4944'
      '414c4941533a4e414d453d4c45435455524552532e4e414d45'
      
        '414c4941533a5354525543545f434f44453d4c45435455524552532e53545255' +
        '43545f434f4445'
      '414c4941533a454d41494c3d4c45435455524552532e454d41494c'
      ''
      '')
  end
  inherited Messages: TStrHolder
    Left = 288
    Top = 288
  end
  inherited flexPopup: TPopupMenu
    Left = 868
    Top = 156
  end
  object ColorDialog: TColorDialog [14]
    Options = [cdFullOpen, cdPreventFullOpen, cdShowHelp, cdSolidColor, cdAnyColor]
    Left = 836
    Top = 160
  end
  object DSParents: TDataSource [15]
    DataSet = QParents
    Left = 144
    Top = 240
  end
  object TimerDetails: TTimer [16]
    OnTimer = TimerDetailsTimer
    Left = 116
    Top = 222
  end
  object DSDetails: TDataSource [17]
    DataSet = QDetails
    Left = 80
    Top = 256
  end
  inherited Query: TADOQuery
    BeforeEdit = QueryBeforeEdit
    AfterScroll = QueryAfterScroll
    SQL.Strings = (
      'SELECT LECTURERS.*'
      ',      ORG_UNITS.*'
      ',      PLANNERS.NAME ROLE_NAME'
      ',      SUBSTR(ORG_UNITS.STRUCT_CODE, 1, 63) SC'
      '  FROM LECTURERS'
      ',      ORG_UNITS'
      ',      PLANNERS'
      ' WHERE ORGUNI_ID = ORG_UNITS.ID(+)'
      '   AND LECTURERS.ROL_ID = PLANNERS.ID(+)'
      '   AND %CON_ORGUNI_ID'
      '   AND %CONDITIONALS'
      '   AND %SEARCH'
      '   AND %CONPERMISSIONS'
      '   AND %AVAILABLE'
      '   AND %TTENABLED'
      '%SORTORDER')
    Left = 32
    Top = 64
  end
  inherited ExcelApplication1: TExcelApplication
    Left = 48
    Top = 256
  end
  inherited ppexport: TPopupMenu
    Top = 104
  end
  object QParents: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    Parameters = <
      item
        Name = 'STR_NAME_LOV1'
        DataType = ftString
        Size = 1
        Value = '0'
      end
      item
        Name = 'STR_NAME_LOV2'
        DataType = ftString
        Size = 1
        Value = '0'
      end
      item
        Name = 'id'
        DataType = ftString
        Size = 1
        Value = '0'
      end>
    SQL.Strings = (
      'select id,level, parent_dsp,exclusive_parent'
      '  from str_elems_v'
      '  where STR_NAME_LOV=:STR_NAME_LOV1'
      
        '  CONNECT BY PRIOR STR_NAME_LOV=:STR_NAME_LOV2 and prior parent_' +
        'id = child_id   '
      '  start with child_id=:id'
      'order by level desc')
    Left = 100
    Top = 276
  end
  object QDetails: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    Parameters = <
      item
        Name = 'STR_NAME_LOV1'
        DataType = ftString
        Size = 1
        Value = '0'
      end
      item
        Name = 'STR_NAME_LOV2'
        DataType = ftString
        Size = 1
        Value = '0'
      end
      item
        Name = 'ID'
        DataType = ftString
        Size = 1
        Value = '0'
      end>
    SQL.Strings = (
      
        'select id,level, to_char( substr('#39'                    '#39',1,level*' +
        '3) || child_dsp ) name,exclusive_parent'
      '  from str_elems_v'
      '  where STR_NAME_LOV=:STR_NAME_LOV1'
      
        '  CONNECT BY PRIOR STR_NAME_LOV=:STR_NAME_LOV2 and prior child_i' +
        'd = parent_id  '
      '  start with parent_id=:ID')
    Left = 52
    Top = 292
  end
end
