inherited FBrowseTT_COMBINATIONS: TFBrowseTT_COMBINATIONS
  Left = 413
  Top = 198
  Width = 1059
  Height = 717
  Caption = 'Ograniczenia'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 666
    Width = 1051
  end
  inherited MainPage: TPageControl
    Width = 1051
    Height = 666
    inherited Browse: TTabSheet
      object Splitter1: TSplitter [0]
        Left = 710
        Top = 209
        Height = 370
        Align = alRight
      end
      inherited TopPanel: TPanel
        Width = 1043
        object BRecalculateAll: TBitBtn
          Left = 909
          Top = 6
          Width = 129
          Height = 25
          Caption = 'Przelicz wszystkie'
          TabOrder = 11
          OnClick = BRecalculateAllClick
        end
        object BRecalculateAllQuick: TBitBtn
          Left = 909
          Top = 30
          Width = 129
          Height = 25
          Caption = 'Turbo (Beta)'
          TabOrder = 12
          OnClick = BRecalculateAllQuickClick
        end
      end
      inherited Grid: TRxDBGrid
        Top = 209
        Width = 710
        Height = 370
        Columns = <
          item
            Expanded = False
            FieldName = 'RES_DESC_L'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_DESC_G'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_DESC_RESCAT0'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_DESC_RESCAT1'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_DESC_S'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_DESC_F'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_DESC_PER'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RES_DESC_PLA'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ID'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'TYPE_DSP'
            Title.Caption = 'Typ ograniczenia'
            Width = 179
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AVAIL_TYPE'
            Title.Caption = 'Limit'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'AVAIL_TYPE_DSP'
            Title.Caption = 'Limit'
            Width = 37
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AVAIL_ORIG'
            Title.Caption = 'Liczba zaj'#281#263
            Width = 76
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AVAIL_CURR'
            Title.Caption = 'Do zaplanowania'
            Width = 102
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ENABLED'
            Title.Caption = 'Dost'#281'pne'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'ENABLED_DSP'
            Title.Caption = 'Dost'#281'pne'
            Width = 31
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SORT_ORDER'
            Title.Caption = 'Kolejno'#347#263
            Width = 63
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'WEIGHT'
            Title.Caption = 'Waga'
            Visible = False
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
            FieldName = 'CREATION_DATE'
            Title.Caption = 'Utworzono'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'CREATED_BY'
            Title.Caption = 'Utworzy'#322
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATE_DATE'
            Title.Caption = 'Zmodyfikowano'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATED_BY'
            Title.Caption = 'Zmodyfikowa'#322
            Visible = False
          end>
      end
      inherited BottomPanel: TPanel
        Top = 598
        Width = 1043
      end
      inherited Panel: TPanel
        Top = 579
        Width = 1043
        inherited StatusBar: TStatusBar
          Width = 974
        end
      end
      inherited CustomPanel: TPanel
        Width = 1043
        Height = 122
        object lCombType: TLabel
          Left = 804
          Top = 1
          Width = 69
          Height = 14
          Caption = 'Typ kombinacji'
        end
        object group_AVAIL_TYPE: TRadioGroup
          Left = 8
          Top = 3
          Width = 305
          Height = 33
          Caption = 'Liczba rekord'#243'w do zaplanowania'
          Columns = 3
          ItemIndex = 2
          Items.Strings = (
            'Limit'
            'Dowolna'
            'Wszystkie komb.')
          TabOrder = 0
          OnClick = group_AVAIL_TYPEClick
        end
        object group_AVAIL_CURR: TRadioGroup
          Left = 328
          Top = 3
          Width = 465
          Height = 33
          Caption = 'Por'#243'wnanie z rozk'#322'adem'
          Columns = 4
          ItemIndex = 3
          Items.Strings = (
            'Do zaplanowania'
            'Przekroczone'
            'Zaplanowane '
            'Wszystkie')
          TabOrder = 1
          OnClick = group_AVAIL_CURRClick
        end
        object conttt: TEdit
          Left = 792
          Top = 14
          Width = 77
          Height = 22
          ReadOnly = True
          TabOrder = 2
          Visible = False
          OnChange = contttChange
        end
        object conttt_value: TEdit
          Left = 816
          Top = 14
          Width = 169
          Height = 22
          ReadOnly = True
          TabOrder = 3
          OnDblClick = conttt_valueDblClick
        end
        object bSelttt: TBitBtn
          Left = 984
          Top = 12
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = bSeltttClick
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
        object bClearttt: TBitBtn
          Left = 1008
          Top = 12
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = bCleartttClick
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
        object Panel4: TPanel
          Left = 1
          Top = 45
          Width = 1041
          Height = 76
          Align = alBottom
          TabOrder = 6
          inline GenericFilter: TFGenericFilter
            Left = 1
            Top = 1
            Width = 1039
            Height = 80
            Align = alTop
            TabOrder = 8
            inherited bClearS: TSpeedButton
              Left = 216
              Top = 49
              OnClick = GenericFilterbClearSClick
            end
            inherited bClearF: TSpeedButton
              Left = 456
              Top = 49
              OnClick = GenericFilterbClearFClick
            end
            inherited bClearL: TSpeedButton
              Left = 216
              Top = 12
              OnClick = GenericFilterbClearLClick
            end
            inherited bClearG: TSpeedButton
              Left = 456
              Top = 12
              OnClick = GenericFilterbClearGClick
            end
            inherited bClearPeriod: TSpeedButton
              Left = 696
              Top = 49
              OnClick = GenericFilterbClearPeriodClick
            end
            inherited bClearRes0: TSpeedButton
              Left = 696
              Top = 9
              OnClick = GenericFilterbClearRes0Click
            end
            inherited bClearRes1: TSpeedButton
              Left = 936
              Top = 9
              OnClick = GenericFilterbClearRes1Click
            end
            inherited bClearPlanner: TSpeedButton
              Left = 936
              Top = 47
            end
            inherited conl: TEdit
              Left = 16
              Top = 12
              Width = 113
              Height = 22
            end
            inherited conl_value: TEdit
              Left = 24
              Top = 12
              Height = 22
            end
            inherited cong: TEdit
              Left = 256
              Top = 12
              Height = 22
            end
            inherited cong_value: TEdit
              Left = 264
              Top = 12
              Height = 22
            end
            inherited conResCat0: TEdit
              Left = 496
              Top = 12
              Height = 22
            end
            inherited conrescat0_value: TEdit
              Left = 504
              Top = 12
              Height = 22
            end
            inherited conResCat1: TEdit
              Left = 736
              Top = 12
              Height = 22
            end
            inherited conrescat1_value: TEdit
              Left = 744
              Top = 12
              Height = 22
            end
            inherited cons: TEdit
              Left = 16
              Top = 49
              Height = 22
            end
            inherited cons_value: TEdit
              Left = 24
              Top = 49
              Height = 22
            end
            inherited conf: TEdit
              Left = 256
              Top = 49
              Height = 22
            end
            inherited conf_value: TEdit
              Left = 264
              Top = 49
              Height = 22
            end
            inherited conPeriod: TEdit
              Left = 496
              Top = 49
              Height = 22
              OnChange = FGenericFilterconPerChange
            end
            inherited conperiod_value: TEdit
              Left = 504
              Top = 49
              Height = 22
            end
            inherited conPla: TEdit
              Left = 736
              Top = 49
              Height = 22
              OnChange = FGenericFilterconPlaChange
            end
            inherited conPla_value: TEdit
              Left = 744
              Top = 49
              Height = 22
            end
            inherited ShowL: TEdit
              Left = 25
            end
            inherited ShowG: TEdit
              Left = 263
            end
            inherited ShowResCat0: TEdit
              Left = 504
            end
            inherited ShowRESCAT1: TEdit
              Left = 744
            end
            inherited ShowS: TEdit
              Left = 25
              Top = 36
            end
            inherited ShowForm: TEdit
              Left = 265
              Top = 36
            end
            inherited ShowPeriod: TEdit
              Left = 503
              Top = 36
            end
            inherited ShowPlanner: TEdit
              Left = 744
              Top = 36
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
              Left = 512
              Top = 56
              inherited mipe: TMenuItem
                OnClick = GenericFiltermipeClick
              end
              inherited mipa: TMenuItem
                Visible = False
                OnClick = GenericFiltermipaClick
              end
            end
            inherited LPopup: TPopupMenu
              Left = 32
              inherited mile: TMenuItem
                OnClick = FGenericFilterMenuItem5Click
              end
              inherited mila: TMenuItem
                Visible = False
                OnClick = FGenericFilterMenuItem6Click
              end
            end
            inherited GPopup: TPopupMenu
              inherited mige: TMenuItem
                OnClick = GenericFiltermigeClick
              end
              inherited miga: TMenuItem
                Visible = False
                OnClick = GenericFiltermigaClick
              end
            end
            inherited R0Popup: TPopupMenu
              Left = 528
              Top = 8
              inherited mir0e: TMenuItem
                OnClick = GenericFiltermir0eClick
              end
              inherited mir0a: TMenuItem
                Visible = False
                OnClick = GenericFiltermir0aClick
              end
            end
            inherited SPopup: TPopupMenu
              Left = 40
              Top = 48
              inherited mise: TMenuItem
                OnClick = GenericFiltermiseClick
              end
              inherited misa: TMenuItem
                Visible = False
                OnClick = GenericFiltermisaClick
              end
            end
            inherited FPopup: TPopupMenu
              Left = 272
              Top = 48
              inherited mife: TMenuItem
                OnClick = GenericFiltermifeClick
              end
              inherited mifa: TMenuItem
                Visible = False
                OnClick = GenericFiltermifaClick
              end
            end
            inherited R1Popup: TPopupMenu
              Left = 760
              Top = 8
              inherited mir1e: TMenuItem
                OnClick = GenericFiltermir1eClick
              end
              inherited mir1a: TMenuItem
                Visible = False
                OnClick = GenericFiltermir1aClick
              end
            end
          end
          object chbShowL: TCheckBox
            Tag = 67108864
            Left = 8
            Top = 12
            Width = 17
            Height = 22
            Hint = 'Poka'#380' w siatce'
            TabOrder = 0
            OnClick = chbShowLClick
          end
          object chbShowS: TCheckBox
            Tag = 67108864
            Left = 8
            Top = 49
            Width = 17
            Height = 17
            Hint = 'Poka'#380' w siatce'
            TabOrder = 1
            OnClick = chbShowLClick
          end
          object chbShowG: TCheckBox
            Tag = 67108864
            Left = 248
            Top = 12
            Width = 17
            Height = 22
            Hint = 'Poka'#380' w siatce'
            TabOrder = 2
            OnClick = chbShowLClick
          end
          object chbShowF: TCheckBox
            Tag = 67108864
            Left = 248
            Top = 49
            Width = 17
            Height = 17
            Hint = 'Poka'#380' w siatce'
            TabOrder = 3
            OnClick = chbShowLClick
          end
          object chbShowRESCAT0: TCheckBox
            Tag = 67108864
            Left = 488
            Top = 12
            Width = 17
            Height = 22
            Hint = 'Poka'#380' w siatce'
            TabOrder = 4
            OnClick = chbShowLClick
          end
          object chbShowPer: TCheckBox
            Tag = 67108864
            Left = 488
            Top = 49
            Width = 17
            Height = 17
            Hint = 'Poka'#380' w siatce'
            TabOrder = 5
            OnClick = chbShowLClick
          end
          object chbShowResCat1: TCheckBox
            Tag = 67108864
            Left = 728
            Top = 12
            Width = 17
            Height = 22
            Hint = 'Poka'#380' w siatce'
            TabOrder = 6
            OnClick = chbShowLClick
          end
          object chbShowPla: TCheckBox
            Tag = 67108864
            Left = 728
            Top = 49
            Width = 17
            Height = 17
            Hint = 'Poka'#380' w siatce'
            TabOrder = 7
            OnClick = chbShowLClick
          end
        end
        object chbShowttt: TCheckBox
          Tag = 67108864
          Left = 795
          Top = 12
          Width = 17
          Height = 22
          Hint = 'Poka'#380' w siatce'
          TabOrder = 7
          OnClick = chbShowLClick
        end
      end
      inherited SecondRatePanel: TPanel
        Width = 1043
      end
      object DetPanel: TPanel
        Left = 713
        Top = 209
        Width = 330
        Height = 370
        Align = alRight
        TabOrder = 6
        Visible = False
        object Splitter2: TSplitter
          Left = 1
          Top = 201
          Width = 328
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        object DetPanel1: TPanel
          Left = 1
          Top = 1
          Width = 328
          Height = 24
          Align = alTop
          Caption = 'Dozwolone zasoby'
          TabOrder = 0
        end
        object Gridtt_resource_lists: TDBGrid
          Left = 1
          Top = 25
          Width = 328
          Height = 176
          Align = alTop
          DataSource = DStt_resource_lists
          Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 1
          TitleFont.Charset = EASTEUROPE_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
        end
        object DetPanel2: TPanel
          Left = 1
          Top = 204
          Width = 328
          Height = 29
          Align = alTop
          Caption = 'Dodatkowe informacje'
          TabOrder = 2
        end
        object Gridtt_inclusions: TDBGrid
          Left = 1
          Top = 233
          Width = 328
          Height = 136
          Align = alClient
          DataSource = DStt_inclusions
          Options = [dgEditing, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 3
          TitleFont.Charset = EASTEUROPE_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
        end
      end
    end
    inherited Update: TTabSheet
      inherited UpdPanel: TPanel
        Top = 602
        Width = 1043
      end
      inherited FlexPanel: TPanel
        Top = 257
        Width = 1043
        Height = 320
        Align = alTop
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 1043
        Height = 49
        Align = alTop
        TabOrder = 2
        object LabelAVAIL_CURR: TLabel
          Left = 472
          Top = 8
          Width = 84
          Height = 14
          Caption = 'Do zaplanowania'
          FocusControl = AVAIL_CURR
        end
        object LabelSORT_ORDER: TLabel
          Left = 600
          Top = 8
          Width = 47
          Height = 14
          Caption = 'Kolejno'#347#263
          FocusControl = SORT_ORDER
        end
        object LRESCAT_COMB_ID: TLabel
          Left = 22
          Top = 4
          Width = 82
          Height = 14
          Caption = 'Typ ograniczenia'
        end
        object AVAIL_TYPE: TDBCheckBox
          Left = 400
          Top = 8
          Width = 57
          Height = 17
          Caption = 'Limit'
          DataField = 'AVAIL_TYPE'
          DataSource = Source
          TabOrder = 0
          ValueChecked = 'L'
          ValueUnchecked = 'N'
          WordWrap = True
          OnClick = AVAIL_TYPEClick
        end
        object ENABLED: TDBCheckBox
          Left = 680
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Dost'#281'pne'
          DataField = 'ENABLED'
          DataSource = Source
          TabOrder = 4
          ValueChecked = 'Y'
          ValueUnchecked = 'N'
        end
        object AVAIL_ORIG: TDBEdit
          Left = 401
          Top = 24
          Width = 48
          Height = 22
          Hint = 'AVAIL_ORIG'
          DataField = 'AVAIL_ORIG'
          DataSource = Source
          MaxLength = 10
          TabOrder = 1
          OnEnter = AVAIL_ORIGEnter
          OnExit = AVAIL_ORIGExit
        end
        object AVAIL_CURR: TDBEdit
          Left = 473
          Top = 24
          Width = 48
          Height = 22
          Hint = 'AVAIL_CURR'
          Color = clBtnFace
          DataField = 'AVAIL_CURR'
          DataSource = Source
          MaxLength = 10
          ReadOnly = True
          TabOrder = 5
        end
        object SORT_ORDER: TDBEdit
          Left = 601
          Top = 24
          Width = 48
          Height = 22
          Hint = 'SORT_ORDER'
          DataField = 'SORT_ORDER'
          DataSource = Source
          MaxLength = 10
          TabOrder = 3
        end
        object chbRecalculate_AVAIL_CURR: TCheckBox
          Left = 523
          Top = 22
          Width = 70
          Height = 17
          Hint = 
            'Zaznaczenie pola przelicz powoduje ponowne przeliczenie warto'#347'ci' +
            ' w polu "do zaplanowania".'#13#10'Z regu'#322'y pole do zaplanowania posiad' +
            'a prawid'#322'ow'#261' warto'#347#263' i przeliczanie nie jest wymagane.'#13#10#13#10'Przeli' +
            'czenie nale'#380'y wykona'#263' w nast'#281'puj'#261'cych przypadkach:'#13#10'1/ Gdy zmien' +
            'iono warto'#347#263' w polu okre'#347'lona liczba zaj'#281#263' lub zmieniono kominac' +
            'j'#281'.'#13#10'2/ Gdy dodano najpierw zaj'#281'cia, a potem kombinacj'#281'.'#13#10#13#10'Prze' +
            'liczenie warto'#347'ci w polu mo'#380'e zaj'#261#263' troch'#281' czasu.'
          Caption = 'Przelicz'
          TabOrder = 2
        end
        object RESCAT_COMB_ID: TDBEdit
          Left = 9
          Top = 19
          Width = 48
          Height = 22
          DataField = 'RESCAT_COMB_ID'
          DataSource = Source
          MaxLength = 10
          TabOrder = 6
          Visible = False
          OnChange = RESCAT_COMB_IDChange
        end
        object RESCAT_COMB_ID_VALUE: TEdit
          Left = 20
          Top = 19
          Width = 301
          Height = 22
          ReadOnly = True
          TabOrder = 7
          OnDblClick = RESCAT_COMB_ID_VALUEDblClick
        end
        object RESCAT_COMB_IDSel: TBitBtn
          Left = 320
          Top = 19
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
          OnClick = RESCAT_COMB_IDSelClick
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
        object RESCAT_COMB_IDClear: TBitBtn
          Left = 344
          Top = 19
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
          OnClick = RESCAT_COMB_IDClearClick
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
      object Panel3: TPanel
        Left = 0
        Top = 49
        Width = 1043
        Height = 208
        Align = alTop
        TabOrder = 3
        object llec: TLabel
          Left = 8
          Top = 8
          Width = 63
          Height = 14
          Alignment = taRightJustify
          Caption = 'Wyk'#322'adowcy'
        end
        object lgro: TLabel
          Left = 43
          Top = 32
          Width = 30
          Height = 14
          Alignment = taRightJustify
          Caption = 'Grupy'
        end
        object lResCat0: TLabel
          Left = 52
          Top = 56
          Width = 21
          Height = 14
          Alignment = taRightJustify
          Caption = 'Sale'
        end
        object lResCat1: TLabel
          Left = 36
          Top = 80
          Width = 37
          Height = 14
          Alignment = taRightJustify
          Caption = 'Zasoby'
        end
        object lsub: TLabel
          Left = 20
          Top = 104
          Width = 53
          Height = 14
          Alignment = taRightJustify
          Caption = 'Przedmioty'
        end
        object lfor: TLabel
          Left = 14
          Top = 128
          Width = 59
          Height = 14
          Alignment = taRightJustify
          Caption = 'Formy zaj'#281#263
        end
        object lper: TLabel
          Left = 27
          Top = 152
          Width = 46
          Height = 14
          Alignment = taRightJustify
          Caption = 'Semestry'
        end
        object lpla: TLabel
          Left = 37
          Top = 176
          Width = 36
          Height = 14
          Alignment = taRightJustify
          Caption = 'Plani'#347'ci'
        end
        object conlec: TEdit
          Left = 72
          Top = 8
          Width = 73
          Height = 22
          ReadOnly = True
          TabOrder = 0
          Visible = False
          OnChange = conlecChange
        end
        object congro: TEdit
          Left = 72
          Top = 32
          Width = 73
          Height = 22
          ReadOnly = True
          TabOrder = 1
          Visible = False
          OnChange = congroChange
        end
        object conResCat0: TEdit
          Left = 72
          Top = 56
          Width = 73
          Height = 22
          ReadOnly = True
          TabOrder = 2
          Visible = False
          OnChange = conResCat0Change
        end
        object conResCat1: TEdit
          Left = 72
          Top = 80
          Width = 73
          Height = 22
          ReadOnly = True
          TabOrder = 3
          Visible = False
          OnChange = conResCat1Change
        end
        object consub: TEdit
          Left = 72
          Top = 104
          Width = 73
          Height = 22
          ReadOnly = True
          TabOrder = 4
          Visible = False
          OnChange = consubChange
        end
        object confor: TEdit
          Left = 72
          Top = 128
          Width = 73
          Height = 22
          ReadOnly = True
          TabOrder = 5
          Visible = False
          OnChange = conforChange
        end
        object conper: TEdit
          Left = 72
          Top = 152
          Width = 73
          Height = 22
          ReadOnly = True
          TabOrder = 6
          Visible = False
          OnChange = conperChange
        end
        object conpla: TEdit
          Left = 72
          Top = 176
          Width = 73
          Height = 22
          ReadOnly = True
          TabOrder = 7
          Visible = False
          OnChange = conplaChange
        end
        object conlec_value: TEdit
          Left = 80
          Top = 8
          Width = 600
          Height = 22
          TabOrder = 8
          OnExit = conlec_valueExit
        end
        object congro_value: TEdit
          Left = 80
          Top = 32
          Width = 600
          Height = 22
          TabOrder = 9
          OnExit = congro_valueExit
        end
        object conResCat0_value: TEdit
          Left = 80
          Top = 56
          Width = 600
          Height = 22
          TabOrder = 10
          OnExit = conResCat0_valueExit
        end
        object conResCat1_value: TEdit
          Left = 80
          Top = 80
          Width = 600
          Height = 22
          TabOrder = 11
          OnExit = conResCat1_valueExit
        end
        object consub_value: TEdit
          Left = 80
          Top = 104
          Width = 600
          Height = 22
          TabOrder = 12
          OnExit = consub_valueExit
        end
        object confor_value: TEdit
          Left = 80
          Top = 128
          Width = 600
          Height = 22
          TabOrder = 13
          OnExit = confor_valueExit
        end
        object conper_value: TEdit
          Left = 80
          Top = 152
          Width = 600
          Height = 22
          TabOrder = 14
          OnExit = conper_valueExit
        end
        object conpla_value: TEdit
          Left = 80
          Top = 176
          Width = 600
          Height = 22
          TabOrder = 15
          OnExit = conpla_valueExit
        end
        object selectLec: TBitBtn
          Left = 682
          Top = 8
          Width = 25
          Height = 24
          Hint = 'Dodaj nowy z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 16
          OnClick = selectLecClick
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
        object selectGro: TBitBtn
          Left = 682
          Top = 32
          Width = 25
          Height = 24
          Hint = 'Dodaj nowy z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 17
          OnClick = selectGroClick
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
        object selectResCat0: TBitBtn
          Left = 682
          Top = 56
          Width = 25
          Height = 24
          Hint = 'Dodaj nowy z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 18
          OnClick = selectResCat0Click
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
        object selectResCat1: TBitBtn
          Left = 682
          Top = 80
          Width = 25
          Height = 24
          Hint = 'Dodaj nowy z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
          OnClick = selectResCat1Click
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
        object selectSub: TBitBtn
          Left = 682
          Top = 104
          Width = 25
          Height = 24
          Hint = 'Dodaj nowy z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 20
          OnClick = selectSubClick
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
        object selectFor: TBitBtn
          Left = 682
          Top = 128
          Width = 25
          Height = 24
          Hint = 'Dodaj nowy z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 21
          OnClick = selectForClick
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
        object selectPer: TBitBtn
          Left = 682
          Top = 152
          Width = 25
          Height = 24
          Hint = 'Dodaj nowy z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 22
          OnClick = selectPerClick
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
        object selectPla: TBitBtn
          Left = 682
          Top = 176
          Width = 25
          Height = 24
          Hint = 'Dodaj nowy z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 23
          OnClick = selectPlaClick
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
        object clearLec: TBitBtn
          Left = 706
          Top = 8
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 24
          OnClick = clearLecClick
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
        object clearGro: TBitBtn
          Left = 706
          Top = 32
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 25
          OnClick = clearGroClick
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
        object clearResCat0: TBitBtn
          Left = 706
          Top = 56
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 26
          OnClick = clearResCat0Click
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
        object clearResCat1: TBitBtn
          Left = 706
          Top = 80
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 27
          OnClick = clearResCat1Click
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
        object clearSub: TBitBtn
          Left = 706
          Top = 104
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 28
          OnClick = clearSubClick
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
        object clearFor: TBitBtn
          Left = 706
          Top = 128
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 29
          OnClick = clearForClick
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
        object clearPer: TBitBtn
          Left = 706
          Top = 152
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 30
          OnClick = clearPerClick
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
        object clearPla: TBitBtn
          Left = 706
          Top = 176
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 31
          OnClick = clearPlaClick
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
        object lecAll: TCheckBox
          Left = 737
          Top = 8
          Width = 160
          Height = 17
          Caption = 'Wyk'#322'adowcy - wszyscy'
          TabOrder = 32
          OnClick = lecAllClick
        end
        object groAll: TCheckBox
          Left = 737
          Top = 32
          Width = 144
          Height = 17
          Caption = 'Grupy - wszyscy'
          TabOrder = 33
          OnClick = lecAllClick
        end
        object resCat0All: TCheckBox
          Left = 737
          Top = 56
          Width = 136
          Height = 17
          Caption = 'Sale - wszyscy'
          TabOrder = 34
          OnClick = lecAllClick
        end
        object resCat1All: TCheckBox
          Left = 737
          Top = 80
          Width = 144
          Height = 17
          Caption = 'Zasoby - wszyscy'
          TabOrder = 35
          OnClick = lecAllClick
        end
        object subAll: TCheckBox
          Left = 737
          Top = 104
          Width = 152
          Height = 17
          Caption = 'Przedmioty - wszyscy'
          TabOrder = 36
          OnClick = lecAllClick
        end
        object forAll: TCheckBox
          Left = 737
          Top = 128
          Width = 144
          Height = 17
          Caption = 'Formy zaj'#281#263' - wszyscy'
          TabOrder = 37
          OnClick = lecAllClick
        end
        object perAll: TCheckBox
          Left = 737
          Top = 152
          Width = 144
          Height = 17
          Caption = 'Semestry - wszyscy'
          TabOrder = 38
          OnClick = lecAllClick
        end
        object plaAll: TCheckBox
          Left = 737
          Top = 176
          Width = 152
          Height = 17
          Caption = 'Plani'#347'ci - wszyscy'
          TabOrder = 39
          OnClick = lecAllClick
        end
      end
    end
  end
  inherited Source: TDataSource
    Left = 48
    Top = 456
  end
  inherited PMenu: TPopupMenu
    Left = 984
    Top = 72
  end
  inherited HolderSortOrder: TStrHolder
    Capacity = 28
    Top = 408
    StrData = (
      ''
      
        '6c65632e6c6173745f6e616d657c57796bb361646f7763617c43415445474f52' +
        '593a44454641554c54'
      
        '67726f2e616262726576696174696f6e7c47727570617c43415445474f52593a' +
        '44454641554c54'
      '726f6d2e6e616d657c53616c617c43415445474f52593a44454641554c54'
      
        '7265732e6e616d657c527a75746e696b7c43415445474f52593a44454641554c' +
        '54'
      
        '7375622e6e616d657c50727a65646d696f747c43415445474f52593a44454641' +
        '554c54'
      '78666f722e6e616d657c466f726d617c43415445474f52593a44454641554c54'
      
        '7065722e6e616d657c53656d657374727c43415445474f52593a44454641554c' +
        '54'
      
        '706c612e6e616d657c506c616e697374617c43415445474f52593a4445464155' +
        '4c54'
      '49447c49447c43415445474f52593a44454641554c54'
      
        '545950455f4453507c547970206f6772616e69637a656e69617c43415445474f' +
        '52593a44454641554c54'
      
        '415641494c5f545950457c4c696d69747c43415445474f52593a44454641554c' +
        '54'
      
        '415641494c5f545950455f4453507c4c696d69747c43415445474f52593a4445' +
        '4641554c54'
      
        '415641494c5f4f5249477c4c69637a6261207a616aeae67c43415445474f5259' +
        '3a44454641554c54'
      
        '415641494c5f435552527c446f207a61706c616e6f77616e69617c4341544547' +
        '4f52593a44454641554c54'
      
        '454e41424c45447c446f7374ea706e657c43415445474f52593a44454641554c' +
        '54'
      
        '454e41424c45445f4453507c446f7374ea706e657c43415445474f52593a4445' +
        '4641554c54'
      
        '534f52545f4f524445527c4b6f6c656a6e6f9ce67c43415445474f52593a4445' +
        '4641554c54'
      '5745494748547c576167617c43415445474f52593a44454641554c54'
      
        '4352454154494f4e5f444154457c5574776f727a6f6e6f7c43415445474f5259' +
        '3a44454641554c54'
      
        '435245415445445f42597c5574776f727a79b37c43415445474f52593a444546' +
        '41554c54'
      
        '4c4153545f5550444154455f444154457c5a6d6f647966696b6f77616e6f7c43' +
        '415445474f52593a44454641554c54'
      
        '4c4153545f555044415445445f42597c5a6d6f647966696b6f7761b37c434154' +
        '45474f52593a44454641554c54'
      '')
  end
  inherited GridLayout: TStrHolder
    Left = 552
    Top = 272
  end
  inherited Komunikaty: TStrHolder
    Left = 448
    Top = 296
  end
  inherited ConditionsWhereClause: TStrHolder
    Top = 376
  end
  inherited AvailColumnsWhereClause: TStrHolder
    Top = 376
  end
  inherited Others: TStrHolder
    Capacity = 76
    Top = 344
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
      
        '414c4941533a415454524942535f30313d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3031'
      
        '414c4941533a415454524942535f30323d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3032'
      
        '414c4941533a415454524942535f30333d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3033'
      
        '414c4941533a415454524942535f30343d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3034'
      
        '414c4941533a415454524942535f30353d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3035'
      
        '414c4941533a415454524942535f30363d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3036'
      
        '414c4941533a415454524942535f30373d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3037'
      
        '414c4941533a415454524942535f30383d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3038'
      
        '414c4941533a415454524942535f30393d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3039'
      
        '414c4941533a415454524942535f31303d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3130'
      
        '414c4941533a415454524942535f31313d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3131'
      
        '414c4941533a415454524942535f31323d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3132'
      
        '414c4941533a415454524942535f31333d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3133'
      
        '414c4941533a415454524942535f31343d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3134'
      
        '414c4941533a415454524942535f31353d54545f434f4d42494e4154494f4e53' +
        '2e415454524942535f3135'
      
        '414c4941533a415454524942445f30313d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3031'
      
        '414c4941533a415454524942445f30323d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3032'
      
        '414c4941533a415454524942445f30333d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3033'
      
        '414c4941533a415454524942445f30343d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3034'
      
        '414c4941533a415454524942445f30353d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3035'
      
        '414c4941533a415454524942445f30363d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3036'
      
        '414c4941533a415454524942445f30373d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3037'
      
        '414c4941533a415454524942445f30383d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3038'
      
        '414c4941533a415454524942445f30393d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3039'
      
        '414c4941533a415454524942445f31303d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3130'
      
        '414c4941533a415454524942445f31313d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3131'
      
        '414c4941533a415454524942445f31323d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3132'
      
        '414c4941533a415454524942445f31333d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3133'
      
        '414c4941533a415454524942445f31343d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3134'
      
        '414c4941533a415454524942445f31353d54545f434f4d42494e4154494f4e53' +
        '2e415454524942445f3135'
      
        '414c4941533a4154545249424e5f30313d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3031'
      
        '414c4941533a4154545249424e5f30323d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3032'
      
        '414c4941533a4154545249424e5f30333d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3033'
      
        '414c4941533a4154545249424e5f30343d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3034'
      
        '414c4941533a4154545249424e5f30353d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3035'
      
        '414c4941533a4154545249424e5f30363d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3036'
      
        '414c4941533a4154545249424e5f30373d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3037'
      
        '414c4941533a4154545249424e5f30383d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3038'
      
        '414c4941533a4154545249424e5f30393d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3039'
      
        '414c4941533a4154545249424e5f31303d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3130'
      
        '414c4941533a4154545249424e5f31313d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3131'
      
        '414c4941533a4154545249424e5f31323d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3132'
      
        '414c4941533a4154545249424e5f31333d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3133'
      
        '414c4941533a4154545249424e5f31343d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3134'
      
        '414c4941533a4154545249424e5f31353d54545f434f4d42494e4154494f4e53' +
        '2e4154545249424e5f3135'
      '')
  end
  inherited Messages: TStrHolder
    Left = 608
    Top = 296
  end
  inherited SearchTimer: TTimer
    Left = 952
    Top = 72
  end
  inherited flexPopup: TPopupMenu
    Left = 1052
    Top = 68
  end
  inherited ImageList: TImageList
    Left = 20
    Top = 300
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    AfterScroll = QueryAfterScroll
    SQL.Strings = (
      'SELECT  TT_COMBINATIONS.*'
      
        '      , tt_planner.get_resource_cat_names (TT_COMBINATIONS.resca' +
        't_comb_id) TYPE_DSP'
      '      , DECODE(AVAIL_TYPE, '#39'L'#39','#39'Tak'#39','#39'Nie'#39') AVAIL_TYPE_DSP'
      '      , DECODE(ENABLED,'#39'Y'#39','#39'Tak'#39','#39'Nie'#39') ENABLED_DSP'
      '      /*'
      '      2013.02.17 Maciej Szymczak optimalization'
      
        '        remeber to keep coherent changes with Others stringholde' +
        'r.'
      
        '      , tt_planner.get_tt_comb_res_desc (TT_COMBINATIONS.id, %g_' +
        'lecturer) res_desc_l'
      
        '      , tt_planner.get_tt_comb_res_desc (TT_COMBINATIONS.id, %g_' +
        'group   ) res_desc_g'
      
        '      , tt_planner.get_tt_comb_res_desc (TT_COMBINATIONS.id, %pr' +
        'escatid0) res_desc_rescat0'
      
        '      , tt_planner.get_tt_comb_res_desc (TT_COMBINATIONS.id, %pr' +
        'escatid1) res_desc_rescat1'
      
        '      , tt_planner.get_tt_comb_res_desc (TT_COMBINATIONS.id, %g_' +
        'subject ) res_desc_s'
      
        '      , tt_planner.get_tt_comb_res_desc (TT_COMBINATIONS.id, %g_' +
        'form    ) res_desc_f'
      
        '      , tt_planner.get_tt_comb_res_desc (TT_COMBINATIONS.id, %g_' +
        'period  ) res_desc_per'
      
        '      , tt_planner.get_tt_comb_res_desc (TT_COMBINATIONS.id, %g_' +
        'planner ) res_desc_pla'
      '      2022.01.09 Maciej Szymczak optimalization'
      
        '      , (select (select last_name||'#39' '#39'||first_name||'#39', '#39'|| title' +
        ' from lecturers where id =res_id) from tt_resource_lists  x wher' +
        'e tt_comb_id = TT_COMBINATIONS.id and tt_planner.get_rescat_id (' +
        'res_id) = %g_lecturer and rownum = 1) res_desc_l'
      
        '      , (select (select abbreviation                           f' +
        'rom groups    where id =res_id) from tt_resource_lists  x where ' +
        'tt_comb_id = TT_COMBINATIONS.id and tt_planner.get_rescat_id (re' +
        's_id) = %g_group    and rownum = 1) res_desc_g'
      
        '      , (select (select name||'#39' '#39'||substr(attribs_01,1,55)     f' +
        'rom rooms     where id =res_id) from tt_resource_lists  x where ' +
        'tt_comb_id = TT_COMBINATIONS.id and tt_planner.get_rescat_id (re' +
        's_id) = %prescatid0   and rownum = 1) res_desc_rescat0'
      
        '      , (select (select name||'#39' '#39'||substr(attribs_01,1,55)     f' +
        'rom rooms     where id =res_id) from tt_resource_lists  x where ' +
        'tt_comb_id = TT_COMBINATIONS.id and tt_planner.get_rescat_id (re' +
        's_id) = %prescatid1   and rownum = 1) res_desc_rescat1'
      
        '      , (select (select name                                   f' +
        'rom subjects  where id =res_id) from tt_resource_lists  x where ' +
        'tt_comb_id = TT_COMBINATIONS.id and tt_planner.get_rescat_id (re' +
        's_id) = %g_subject    and rownum = 1) res_desc_s'
      
        '      , (select (select name||'#39'('#39'||abbreviation||'#39')'#39'           f' +
        'rom forms     where id =res_id) from tt_resource_lists  x where ' +
        'tt_comb_id = TT_COMBINATIONS.id and tt_planner.get_rescat_id (re' +
        's_id) = %g_form       and rownum = 1) res_desc_f'
      
        '      , (select (select name                                   f' +
        'rom periods   where id =res_id) from tt_resource_lists  x where ' +
        'tt_comb_id = TT_COMBINATIONS.id and tt_planner.get_rescat_id (re' +
        's_id) = %g_period     and rownum = 1) res_desc_per'
      
        '      , (select (select name                                   f' +
        'rom planners  where id =res_id) from tt_resource_lists  x where ' +
        'tt_comb_id = TT_COMBINATIONS.id and tt_planner.get_rescat_id (re' +
        's_id) = %g_planner    and rownum = 1) res_desc_pla'
      '      */'
      
        '      , lec.last_name||'#39' '#39'||lec.first_name||'#39', '#39'|| lec.title   r' +
        'es_desc_l'
      
        '      , gro.abbreviation                                       r' +
        'es_desc_g'
      
        '      , rom.name||'#39' '#39'||substr(rom.attribs_01,1,55)             r' +
        'es_desc_rescat0'
      
        '      , res.name||'#39' '#39'||substr(res.attribs_01,1,55)             r' +
        'es_desc_rescat1'
      
        '      , sub.name                                               r' +
        'es_desc_s'
      
        '      , xfor.name||'#39'('#39'||xfor.abbreviation||'#39')'#39'                 r' +
        'es_desc_f'
      
        '      , per.name                                               r' +
        'es_desc_per'
      
        '      , pla.name                                               r' +
        'es_desc_pla'
      'FROM TT_COMBINATIONS'
      'left join lecturers lec  on lec_id= lec.id'
      'left join groups    gro  on gro_id= gro.id'
      'left join rooms     rom  on rom_id= rom.id'
      'left join rooms     res  on res_id= res.id'
      'left join subjects  sub  on sub_id= sub.id'
      'left join forms     xfor on for_id= xfor.id'
      'left join periods   per  on per_id= per.id'
      'left join planners  pla  on pla_id= pla.id'
      'WHERE %CONDITIONALS AND %CUSTOMCONDITIONALS AND %SEARCH'
      '%SORTORDER')
    Left = 4
    Top = 452
  end
  inherited ppexport: TPopupMenu
    Left = 56
    Top = 296
  end
  object Qtt_resource_lists: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    BeforeOpen = Qtt_resource_listsBeforeOpen
    Parameters = <
      item
        Name = 'tt_comb_id'
        DataType = ftString
        Size = 2
        Value = '-1'
      end>
    SQL.Strings = (
      
        'select tt_planner.get_res_desc ( res_id, tt_planner.get_rescat_i' +
        'd (res_id) ) description'
      '  from tt_resource_lists  '
      '  where tt_comb_id = :tt_comb_id'
      'order by 1')
    Left = 724
    Top = 299
  end
  object Qtt_inclusions: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    BeforeOpen = Qtt_inclusionsBeforeOpen
    Parameters = <
      item
        Name = 'tt_comb_id'
        DataType = ftString
        Size = 2
        Value = '-1'
      end>
    SQL.Strings = (
      
        'select decode(INCLUSION_TYPE,'#39'LIST'#39','#39'Lista: '#39','#39'ALL'#39','#39'WSZYSCY: '#39',' +
        ' INCLUSION_TYPE) ||'#39' '#39'|| tt_planner.get_rescat_desc (rescat_id) ' +
        'description'
      '  from tt_inclusions'
      '  where tt_comb_id = :tt_comb_id and INCLUSION_TYPE <> '#39'LIST'#39
      'order by 1')
    Left = 724
    Top = 467
  end
  object DStt_resource_lists: TDataSource
    DataSet = Qtt_resource_lists
    Left = 764
    Top = 299
  end
  object DStt_inclusions: TDataSource
    DataSet = Qtt_inclusions
    Left = 764
    Top = 467
  end
end
