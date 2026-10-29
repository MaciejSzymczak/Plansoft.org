inherited FSettings: TFSettings
  Left = 379
  Top = 170
  BorderStyle = bsDialog
  Caption = 'Drukuj'
  ClientHeight = 582
  ClientWidth = 934
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 563
    Width = 934
    TabOrder = 2
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 522
    Width = 934
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BSave: TSpeedButton
      Left = 89
      Top = 8
      Width = 74
      Height = 29
      Hint = 'Sortuj malej'#261'co wzgl'#281'dem kategorii kolumn'
      AllowAllUp = True
      Caption = 'Zapisz'
      Glyph.Data = {
        CA020000424DCA02000000000000420000002800000012000000120000000100
        1000030000008802000000000000000000000000000000000000007C0000E003
        00001F0000001B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B
        1B5B1B5B1B5B1B5B1B5B1B5B1B5B000000000000000000000000000000000000
        000000000000000000001B5B1B5B1B5B1042E07F0042E07F0000000000000000
        00000000000000000000E07F004200001B5B1B5B10420042E07F004200000000
        0000000000000000FF7FFF7F00000042E07F00001B5B1B5B1042E07F0042E07F
        000000000000000000000000FF7FFF7F0000E07F004200001B5B1B5B10420042
        E07F0042000000000000000000000000FF7FFF7F00000042E07F00001B5B1B5B
        1042E07F0042E07F000000000000000000000000000000000000E07F00420000
        1B5B1B5B10420042E07F0042E07F0042E07F0042E07F0042E07F0042E07F0042
        E07F00001B5B1B5B1042E07F0042E07F0042E07F0042E07F0042E07F0042E07F
        0042E07F004200001B5B1B5B10420042E07F1042104210421042104210421042
        1042104210420042E07F00001B5B1B5B1042E07F00421042FF7FFF7FFF7FFF7F
        FF7FFF7FFF7FFF7F1042E07F004200001B5B1B5B10420042E07F1042FF7FFF7F
        FF7FFF7FFF7FFF7FFF7FFF7F10420042E07F00001B5B1B5B1042E07F00421042
        FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F1042E07F004200001B5B1B5B10420042
        E07F1042FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F10420042E07F00001B5B1B5B
        1042E07F00421042FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F1042E07F00420000
        1B5B1B5B10420042E07F1042FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F10420042
        00001B5B1B5B1B5B1B5B10421042104210421042104210421042104210421042
        104200001B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B1B5B
        1B5B1B5B1B5B1B5B1B5B1B5B1B5B}
      ParentShowHint = False
      ShowHint = True
      OnClick = BSaveClick
    end
    object Bload: TSpeedButton
      Left = 8
      Top = 8
      Width = 75
      Height = 29
      Hint = 'Sortuj rosn'#261'co wzgl'#281'dem kategorii kolumn'
      AllowAllUp = True
      Caption = 'Otw'#243'rz'
      Glyph.Data = {
        EA020000424DEA02000000000000420000002800000014000000110000000100
        100003000000A802000000000000000000000000000000000000007C0000E003
        00001F0000001863186318631863186318631863186318631863186318631863
        1863186318631863186318631863186318630000000000000000000000000000
        00000000000000000000186318631863186318631863186300421042E07F0042
        E07F0042E07F0042E07F0042E07F0042E07F0000186318631863186318631863
        1042FF7F1042E07F0042E07F0042E07F0042E07F0042E07F0042E07F00001863
        18631863186318631042E07FFF7F1042E07F0042E07F0042E07F0042E07F0042
        E07F0042E07F000018631863186318631042FF7FE07FFF7F1042E07F0042E07F
        0042E07F0042E07F0042E07F0042E07F00001863186318631042E07FFF7FE07F
        FF7F104210421042104210421042104210421042104210421042104218631863
        1042FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F104218631863
        18631863186318631042E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F
        FF7F10421863186318631863186318631042FF7FE07FFF7FE07FFF7FE07FFF7F
        E07FFF7FE07FFF7FE07F10421863186318631863186318631042E07FFF7FE07F
        FF7FE07FE07FE07FE07FE07FE07FE07FFF7F1042186318631863186318631863
        1042FF7FFF7FE07FE07FE07F1042104210421042104210421042186318631863
        1863186318631863186310421042104210421042186318631863186318631863
        1863186300000000000018631863186318631863186318631863186318631863
        1863186318631863186318631863000000001863186318631863186318631863
        1863186318631863186318630000186318631863000018630000186318631863
        1863186318631863186318631863186318631863186300000000000018631863
        1863186318631863186318631863186318631863186318631863186318631863
        1863186318631863186318631863}
      ParentShowHint = False
      ShowHint = True
      OnClick = BloadClick
    end
    object BCloseSettings: TBitBtn
      Left = 801
      Top = 8
      Width = 75
      Height = 29
      Cancel = True
      Caption = 'Zamknij'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = BCloseSettingsClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object BHtml: TBitBtn
      Left = 641
      Top = 8
      Width = 155
      Height = 29
      Caption = 'Wy'#347'wietl rozk'#322'ad'
      TabOrder = 1
      OnClick = BHtmlClick
    end
    object BWord: TBitBtn
      Left = 473
      Top = 8
      Width = 163
      Height = 29
      Caption = 'Edytuj rozk'#322'ad'
      TabOrder = 2
      OnClick = BWordClick
      Glyph.Data = {
        0A050000424D0A05000000000000420000002800000021000000120000000100
        100003000000C804000000000000000000000000000000000000007C0000E003
        00001F0000001863186318631863186318631863186318631863186318631863
        1863186318631863186318631863186318631863186318631863186318631863
        1863186318631863000018631863186318631863186318631863186318631863
        1863186318631863186318631863186318631863186318631863186318631863
        1863186318631863186318630000186318631863186318631863186318631863
        1863186318631863186318631863186318631863186318631863186318631863
        1863186318631863186318631863186300001863186318631863186318631863
        1863186318631863186300000000000000000000186300000000000000001863
        0000000000000000186318631863186318631863000018630000000000000000
        00000000000000000000000000001002100210021002000018630000FF03FF03
        FF0300000000FF03FF03FF030000186318631863186318630000186300001042
        104210421042104210421042104200001002FF03FF0318630000186318630000
        FF03FF03FF0300000000FF03FF03FF0300001863186318631863186300001863
        18630000FF031002100210021002100200001002FF03FF031863000018631863
        18630000FF03FF03FF03FF030000FF03FF03FF03FF0300001863186318631863
        00001863186318630000FF0310021002100200001002FF03FF03186300001002
        0000186318630000FF03FF03FF03FF030000FF03FF03FF03FF03000018631863
        18631863000018631863186318630000FF03100200001002FF03FF0318630000
        000000000000186318630000FF03FF030000FF03FF03FF03FF030000FF03FF03
        0000186318631863000018631863186318631863000000001002FF03FF031863
        00001863186318631863186318630000FF03FF0300000000FF03FF03FF030000
        0000FF03000018631863186300001863186318631863186300001002FF03FF03
        1863000000001863186318631863186318630000FF03FF0300000000FF03FF03
        FF0300000000FF03FF030000186318630000186318631863186300001002FF03
        FF0318630000100210420000186318631863186318630000FF03FF0300001863
        0000FF03FF03000018630000FF03000018631863000018631863186300001002
        FF03FF0318630000FF03100210021042000018631863186318630000FF03FF03
        000018630000FF03FF03000018630000FF03FF03000018630000186318630000
        1002FF03FF031863000018630000FF031002100210420000186318630000FF03
        FF03FF03FF03000018630000FF0300000000FF03FF03FF03FF03000000001863
        0000186318631863186300001863186318630000FF03FF03FF03FF0300001863
        0000000000000000000000001863000000000000186300000000000000000000
        0000186300000000000000000000186318631863186318630000000000000000
        0000186318631863186318631863186318631863186318631863186318631863
        1863186300001863186318631863186318631863186318631863186318631863
        1863186318631863186318631863186318631863186318631863186318631863
        1863186318631863000018631863186318631863186318631863186318631863
        1863186318631863186318631863186318631863186318631863186318631863
        1863186318631863186318630000}
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 41
    Width = 934
    Height = 481
    ActivePage = TabSheetS
    Align = alClient
    TabOrder = 0
    OnChange = lLegendModeClick
    object TabSheetL: TTabSheet
      Caption = 'Wyk'#322'adowca'
      object LcomboSpanlabel: TLabel
        Left = 8
        Top = 414
        Width = 84
        Height = 14
        Caption = 'Scalanie kom'#243'rek'
      end
      object lhelp: TSpeedButton
        Left = 447
        Top = 273
        Width = 23
        Height = 22
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
        OnClick = lhelpClick
      end
      object LHideEmptyRowsB: TSpeedButton
        Left = 142
        Top = 385
        Width = 48
        Height = 15
        Caption = 'Wi'#281'cej'
        Flat = True
        OnClick = LHideEmptyRowsBClick
      end
      object LDescGroup: TGroupBox
        Left = 1
        Top = 40
        Width = 306
        Height = 152
        Caption = 'Opisy'
        TabOrder = 0
        object Label12: TLabel
          Left = 10
          Top = 16
          Width = 244
          Height = 14
          Caption = 
            'Zawarto'#347#263'                                                    Wielk.  Pog' +
            'r.'
        end
        object LD1: TComboBox
          Left = 8
          Top = 30
          Width = 213
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 0
        end
        object LD2: TComboBox
          Left = 8
          Top = 54
          Width = 213
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 1
        end
        object LD3: TComboBox
          Left = 8
          Top = 78
          Width = 213
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 2
        end
        object LD4: TComboBox
          Left = 8
          Top = 102
          Width = 213
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 3
        end
        object LD5: TComboBox
          Left = 8
          Top = 126
          Width = 213
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 4
        end
        object LS1: TEdit
          Left = 223
          Top = 30
          Width = 38
          Height = 22
          TabOrder = 5
          Text = '10'
        end
        object LS2: TEdit
          Left = 223
          Top = 54
          Width = 38
          Height = 22
          TabOrder = 6
          Text = '8'
        end
        object LS3: TEdit
          Left = 223
          Top = 78
          Width = 38
          Height = 22
          TabOrder = 7
          Text = '8'
        end
        object LS4: TEdit
          Left = 223
          Top = 102
          Width = 38
          Height = 22
          TabOrder = 8
          Text = '8'
        end
        object LS5: TEdit
          Left = 223
          Top = 126
          Width = 38
          Height = 22
          TabOrder = 9
          Text = '8'
        end
        object LB1: TCheckBox
          Left = 264
          Top = 32
          Width = 17
          Height = 17
          Checked = True
          State = cbChecked
          TabOrder = 10
        end
        object LB2: TCheckBox
          Left = 264
          Top = 56
          Width = 17
          Height = 17
          TabOrder = 11
        end
        object LB3: TCheckBox
          Left = 264
          Top = 80
          Width = 17
          Height = 17
          TabOrder = 12
        end
        object LB4: TCheckBox
          Left = 264
          Top = 104
          Width = 17
          Height = 17
          TabOrder = 13
        end
        object LB5: TCheckBox
          Left = 264
          Top = 128
          Width = 17
          Height = 17
          TabOrder = 14
        end
        object LLinkLabel: TLabel
          Left = 284
          Top = 16
          Width = 20
          Height = 14
          Caption = 'Link'
        end
        object LLink1: TCheckBox
          Left = 286
          Top = 32
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 15
        end
        object LLink2: TCheckBox
          Left = 286
          Top = 56
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 16
        end
        object LLink3: TCheckBox
          Left = 286
          Top = 80
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 17
        end
        object LLink4: TCheckBox
          Left = 286
          Top = 104
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 18
        end
        object LLink5: TCheckBox
          Left = 286
          Top = 128
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
        end
      end
      object LCellSizes: TGroupBox
        Left = 1
        Top = 192
        Width = 169
        Height = 97
        Caption = 'Kom'#243'rka'
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 24
          Width = 109
          Height = 14
          Caption = 'Szeroko'#347#263':..................'
        end
        object Label2: TLabel
          Left = 8
          Top = 48
          Width = 132
          Height = 14
          Caption = 'Wysoko'#347#263':..........................'
        end
        object Label9: TLabel
          Left = 8
          Top = 75
          Width = 99
          Height = 14
          Caption = 'Rozmiar czcionki:.....'
        end
        object LW: TEdit
          Left = 96
          Top = 16
          Width = 65
          Height = 22
          TabOrder = 0
          Text = '15'
        end
        object LH: TEdit
          Left = 96
          Top = 40
          Width = 65
          Height = 22
          TabOrder = 1
          Text = '10'
        end
        object LCELLSIZE: TEdit
          Left = 96
          Top = 64
          Width = 65
          Height = 22
          TabOrder = 2
          Text = '10'
        end
      end
      object LLShowLegend: TCheckBox
        Tag = 67108864
        Left = 0
        Top = 288
        Width = 120
        Height = 17
        Caption = 'Dodaj legend'#281
        TabOrder = 2
        OnClick = LLShowLegendClick
      end
      object lheadergroup: TGroupBox
        Left = 314
        Top = 0
        Width = 609
        Height = 121
        Caption = 'Wsp'#243'lny nag'#322#243'wek dla wszystkich rozk'#322'ad'#243'w zaj'#281#263
        TabOrder = 3
        object LHEADER: TMemo
          Left = 2
          Top = 16
          Width = 605
          Height = 103
          Align = alClient
          Lines.Strings = (
            '')
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object lfootergroup: TGroupBox
        Left = 314
        Top = 136
        Width = 609
        Height = 137
        Caption = 'Wsp'#243'lna stopka dla wszystkich rozk'#322'ad'#243'w zaj'#281#263
        TabOrder = 4
        object LFOOTER: TMemo
          Left = 2
          Top = 16
          Width = 605
          Height = 119
          Align = alClient
          Lines.Strings = (
            '')
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object LViewTypeGroup: TGroupBox
        Left = 1
        Top = 0
        Width = 256
        Height = 40
        Caption = 'Kolorowanie'
        TabOrder = 5
        object LViewType: TComboBox
          Left = 9
          Top = 14
          Width = 240
          Height = 22
          Hint = 'Kolorowanie ze wzgl'#281'du na'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 0
        end
      end
      object LRepeatMonthNames: TCheckBox
        Tag = 67108864
        Left = 0
        Top = 320
        Width = 169
        Height = 17
        Caption = 'Powtarzaj nazwy miesi'#281'cy'
        TabOrder = 6
      end
      object LWeekPlans: TCheckBox
        Left = 0
        Top = 360
        Width = 190
        Height = 17
        Hint = 'Nad datami grafiku przyciski do plan'#243'w tygodniowych (plany s'#261' tworzone razem z grafikiem)'
        Caption = 'Przejd'#378' do planu tygodnia'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 99
      end
      object LHideEmptyRows: TCheckBox
        Left = 0
        Top = 336
        Width = 148
        Height = 17
        Caption = 'Ukrywaj puste wiersze'
        TabOrder = 7
        OnClick = LHideEmptyRowsClick
      end
      object LcomboSpan: TComboBox
        Left = 7
        Top = 431
        Width = 194
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        MaxLength = 255
        TabOrder = 8
        Items.Strings = (
          'Scalaj '
          'Nie scalaj'
          'Scalaj tylko w poziomie'
          'Scalaj tylko w pionie'
          'Scalaj w poziomie, potem w pionie'
          'Scalaj w pionie, potem w poziomie')
      end
      object lspanEmptyCells: TCheckBox
        Left = 208
        Top = 431
        Width = 150
        Height = 17
        Caption = 'Scalaj puste kom'#243'rki'
        TabOrder = 9
        OnClick = LHideEmptyRowsClick
      end
      object LTransposition: TCheckBox
        Left = 0
        Top = 399
        Width = 129
        Height = 17
        Caption = 'Obr'#243#263
        TabOrder = 10
        OnClick = LHideEmptyRowsClick
      end
      object LVerticalLines: TCheckBox
        Left = 482
        Top = 296
        Width = 201
        Height = 17
        Caption = 'Pogrubione linie mi'#281'dzy miesi'#261'cami'
        TabOrder = 11
        Visible = False
        OnClick = LHideEmptyRowsClick
      end
      object LAddCreationDate: TComboBox
        Left = 481
        Top = 319
        Width = 208
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        ItemIndex = 0
        MaxLength = 255
        TabOrder = 12
        Text = 'Data aktualizacji pod rozk'#322'adem'
        Items.Strings = (
          'Data aktualizacji pod rozk'#322'adem'
          'Data aktualizacji nad rozk'#322'adem'
          'Nie wstawiaj daty aktualizacji')
      end
      object Lnotes_before: TCheckBox
        Left = 314
        Top = 120
        Width = 433
        Height = 17
        Caption = 'Nag'#322#243'wek rozk'#322'adu zaj'#281#263
        TabOrder = 13
      end
      object Lnotes_after: TCheckBox
        Left = 314
        Top = 272
        Width = 129
        Height = 17
        Caption = 'Stopka rozk'#322'adu zaj'#281#263
        TabOrder = 14
      end
      object LPdfPrintOut: TCheckBox
        Left = 695
        Top = 272
        Width = 97
        Height = 17
        Caption = 'Wydruk pdf'
        TabOrder = 15
        OnClick = LPdfPrintOutClick
      end
      object lpdfg: TCheckBox
        Left = 695
        Top = 288
        Width = 162
        Height = 17
        Caption = 'Wydruk czarno-bia'#322'y'
        TabOrder = 16
        OnClick = LPdfPrintOutClick
      end
      object lpdfl: TCheckBox
        Left = 695
        Top = 304
        Width = 97
        Height = 17
        Caption = 'Niska jako'#347#263
        TabOrder = 17
        OnClick = LPdfPrintOutClick
      end
      object lpdfo: TCheckBox
        Left = 695
        Top = 320
        Width = 155
        Height = 17
        Caption = 'Poziomy wyk'#322'ad strony'
        TabOrder = 18
        OnClick = LPdfPrintOutClick
      end
      object lpdfs: TCheckBox
        Left = 695
        Top = 336
        Width = 97
        Height = 17
        Caption = 'Format A3'
        TabOrder = 19
        OnClick = LPdfPrintOutClick
      end
      object llegendMode: TGroupBox
        Left = 314
        Top = 296
        Width = 161
        Height = 136
        Caption = 'Legenda'
        TabOrder = 20
        object llegendColorByLabel: TLabel
          Left = 8
          Top = 88
          Width = 93
          Height = 14
          Caption = 'Kolory w legendzie'
        end
        object llegendAbbr: TCheckBox
          Left = 8
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Skr'#243't wyk'#322'adowcy'
          TabOrder = 0
        end
        object llegendSummary: TCheckBox
          Left = 8
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Forma + liczba zaj'#281#263
          TabOrder = 1
        end
        object llegendECTS: TCheckBox
          Left = 8
          Top = 48
          Width = 137
          Height = 17
          Caption = 'ECTS'
          TabOrder = 2
        end
        object llegendSummaryGroup: TCheckBox
          Left = 8
          Top = 64
          Width = 137
          Height = 17
          Caption = 'Grupy + liczba zaj'#281#263
          TabOrder = 3
        end
        object llegendColorBy: TComboBox
          Left = 8
          Top = 104
          Width = 145
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 0
          TabOrder = 4
          Text = 'Przedmiot'
          Items.Strings = (
            'Przedmiot'
            'Grupa'
            'Wyk'#322'adowca'
            'Forma'
            'Sala')
        end
      end
    end
    object TabSheetG: TTabSheet
      Caption = 'Grupa'
      ImageIndex = 1
      object GcomboSpanlabel: TLabel
        Left = 8
        Top = 414
        Width = 84
        Height = 14
        Caption = 'Scalanie kom'#243'rek'
      end
      object ghelp: TSpeedButton
        Left = 450
        Top = 273
        Width = 23
        Height = 22
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
        OnClick = lhelpClick
      end
      object GHideEmptyRowsB: TSpeedButton
        Left = 142
        Top = 385
        Width = 41
        Height = 15
        Caption = 'Wi'#281'cej'
        Flat = True
        OnClick = GHideEmptyRowsBClick
      end
      object GDescGroup: TGroupBox
        Left = 1
        Top = 40
        Width = 306
        Height = 151
        Caption = 'Opisy'
        TabOrder = 0
        object Label13: TLabel
          Left = 10
          Top = 16
          Width = 241
          Height = 14
          Caption = 
            'Zawarto'#347#263'                                                   Wielk.  Pogr' +
            '.'
        end
        object GD1: TComboBox
          Left = 6
          Top = 30
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 0
        end
        object GD2: TComboBox
          Left = 6
          Top = 54
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 1
        end
        object GD3: TComboBox
          Left = 6
          Top = 78
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 2
        end
        object GD4: TComboBox
          Left = 6
          Top = 102
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 3
        end
        object GD5: TComboBox
          Left = 6
          Top = 126
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 4
        end
        object GS1: TEdit
          Left = 221
          Top = 30
          Width = 38
          Height = 22
          TabOrder = 5
          Text = '10'
        end
        object GS2: TEdit
          Left = 221
          Top = 54
          Width = 38
          Height = 22
          TabOrder = 6
          Text = '8'
        end
        object GS3: TEdit
          Left = 221
          Top = 78
          Width = 38
          Height = 22
          TabOrder = 7
          Text = '8'
        end
        object GS4: TEdit
          Left = 221
          Top = 102
          Width = 38
          Height = 22
          TabOrder = 8
          Text = '8'
        end
        object GS5: TEdit
          Left = 221
          Top = 123
          Width = 38
          Height = 22
          TabOrder = 9
          Text = '8'
        end
        object GB5: TCheckBox
          Left = 262
          Top = 128
          Width = 17
          Height = 17
          TabOrder = 10
        end
        object GB4: TCheckBox
          Left = 262
          Top = 104
          Width = 17
          Height = 17
          TabOrder = 11
        end
        object GB3: TCheckBox
          Left = 262
          Top = 80
          Width = 17
          Height = 17
          TabOrder = 12
        end
        object GB2: TCheckBox
          Left = 262
          Top = 56
          Width = 17
          Height = 17
          TabOrder = 13
        end
        object GB1: TCheckBox
          Left = 262
          Top = 32
          Width = 17
          Height = 17
          Checked = True
          State = cbChecked
          TabOrder = 14
        end
        object GLinkLabel: TLabel
          Left = 282
          Top = 16
          Width = 20
          Height = 14
          Caption = 'Link'
        end
        object GLink1: TCheckBox
          Left = 284
          Top = 32
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 15
        end
        object GLink2: TCheckBox
          Left = 284
          Top = 56
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 16
        end
        object GLink3: TCheckBox
          Left = 284
          Top = 80
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 17
        end
        object GLink4: TCheckBox
          Left = 284
          Top = 104
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 18
        end
        object GLink5: TCheckBox
          Left = 284
          Top = 128
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
        end
      end
      object GCellSizes: TGroupBox
        Left = 1
        Top = 191
        Width = 169
        Height = 98
        Caption = 'Kom'#243'rka'
        TabOrder = 1
        object Label3: TLabel
          Left = 8
          Top = 24
          Width = 109
          Height = 14
          Caption = 'Szeroko'#347#263':..................'
        end
        object Label4: TLabel
          Left = 8
          Top = 48
          Width = 132
          Height = 14
          Caption = 'Wysoko'#347#263':..........................'
        end
        object Label10: TLabel
          Left = 8
          Top = 75
          Width = 99
          Height = 14
          Caption = 'Rozmiar czcionki:.....'
        end
        object GW: TEdit
          Left = 96
          Top = 16
          Width = 65
          Height = 22
          TabOrder = 0
          Text = '15'
        end
        object GH: TEdit
          Left = 96
          Top = 40
          Width = 65
          Height = 22
          TabOrder = 1
          Text = '10'
        end
        object GCELLSIZE: TEdit
          Left = 96
          Top = 64
          Width = 65
          Height = 22
          TabOrder = 2
          Text = '10'
        end
      end
      object gGShowLegend: TCheckBox
        Tag = 67108864
        Left = 0
        Top = 288
        Width = 97
        Height = 17
        Caption = 'Dodaj legend'#281
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = gGShowLegendClick
      end
      object gheadergroup: TGroupBox
        Left = 314
        Top = 0
        Width = 609
        Height = 121
        Caption = 'Wsp'#243'lny nag'#322#243'wek dla wszystkich rozk'#322'ad'#243'w zaj'#281#263
        TabOrder = 3
        object GHEADER: TMemo
          Left = 2
          Top = 16
          Width = 605
          Height = 103
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object gfootergroup: TGroupBox
        Left = 314
        Top = 136
        Width = 609
        Height = 137
        Caption = 'Wsp'#243'lna stopka dla wszystkich rozk'#322'ad'#243'w zaj'#281#263
        TabOrder = 4
        object GFOOTER: TMemo
          Left = 2
          Top = 16
          Width = 605
          Height = 119
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object GViewTypeGroup: TGroupBox
        Left = 1
        Top = 0
        Width = 256
        Height = 40
        Caption = 'Kolorowanie'
        TabOrder = 5
        object GViewType: TComboBox
          Left = 9
          Top = 14
          Width = 240
          Height = 22
          Hint = 'Kolorowanie ze wzgl'#281'du na'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 0
        end
      end
      object GRepeatMonthNames: TCheckBox
        Tag = 67108864
        Left = 0
        Top = 320
        Width = 169
        Height = 17
        Caption = 'Powtarzaj nazwy miesi'#281'cy'
        TabOrder = 6
      end
      object GWeekPlans: TCheckBox
        Left = 0
        Top = 360
        Width = 190
        Height = 17
        Hint = 'Nad datami grafiku przyciski do plan'#243'w tygodniowych (plany s'#261' tworzone razem z grafikiem)'
        Caption = 'Przejd'#378' do planu tygodnia'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 99
      end
      object GHideEmptyRows: TCheckBox
        Left = 0
        Top = 336
        Width = 137
        Height = 17
        Caption = 'Ukrywaj puste wiersze'
        TabOrder = 7
        OnClick = LHideEmptyRowsClick
      end
      object GcomboSpan: TComboBox
        Left = 7
        Top = 431
        Width = 194
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        MaxLength = 255
        TabOrder = 8
        Items.Strings = (
          'Scalaj '
          'Nie scalaj'
          'Scalaj tylko w poziomie'
          'Scalaj tylko w pionie'
          'Scalaj w poziomie, potem w pionie'
          'Scalaj w pionie, potem w poziomie')
      end
      object gspanEmptyCells: TCheckBox
        Left = 208
        Top = 431
        Width = 150
        Height = 17
        Caption = 'Scalaj puste kom'#243'rki'
        TabOrder = 9
        OnClick = LHideEmptyRowsClick
      end
      object GTransposition: TCheckBox
        Left = 0
        Top = 399
        Width = 137
        Height = 17
        Caption = 'Obr'#243#263
        TabOrder = 10
        OnClick = LHideEmptyRowsClick
      end
      object GVerticalLines: TCheckBox
        Left = 482
        Top = 296
        Width = 201
        Height = 17
        Caption = 'Pogrubione linie mi'#281'dzy miesi'#261'cami'
        TabOrder = 11
        Visible = False
        OnClick = LHideEmptyRowsClick
      end
      object GAddCreationDate: TComboBox
        Left = 481
        Top = 319
        Width = 186
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        ItemIndex = 0
        MaxLength = 255
        TabOrder = 12
        Text = 'Data aktualizacji pod rozk'#322'adem'
        Items.Strings = (
          'Data aktualizacji pod rozk'#322'adem'
          'Data aktualizacji nad rozk'#322'adem'
          'Nie wstawiaj daty aktualizacji')
      end
      object Gnotes_before: TCheckBox
        Left = 314
        Top = 120
        Width = 433
        Height = 17
        Caption = 'Nag'#322#243'wek rozk'#322'adu zaj'#281#263
        TabOrder = 13
      end
      object Gnotes_after: TCheckBox
        Left = 314
        Top = 272
        Width = 129
        Height = 17
        Caption = 'Stopka rozk'#322'adu zaj'#281#263
        TabOrder = 14
      end
      object GPdfPrintOut: TCheckBox
        Left = 674
        Top = 272
        Width = 97
        Height = 17
        Caption = 'Wydruk pdf'
        TabOrder = 15
        OnClick = LPdfPrintOutClick
      end
      object gpdfg: TCheckBox
        Left = 674
        Top = 288
        Width = 129
        Height = 17
        Caption = 'Wydruk czarno-bia'#322'y'
        TabOrder = 16
        OnClick = LPdfPrintOutClick
      end
      object gpdfl: TCheckBox
        Left = 674
        Top = 304
        Width = 97
        Height = 17
        Caption = 'Niska jako'#347#263
        TabOrder = 17
        OnClick = LPdfPrintOutClick
      end
      object gpdfo: TCheckBox
        Left = 674
        Top = 320
        Width = 129
        Height = 17
        Caption = 'Poziomy wyk'#322'ad strony'
        TabOrder = 18
        OnClick = LPdfPrintOutClick
      end
      object gpdfs: TCheckBox
        Left = 674
        Top = 336
        Width = 97
        Height = 17
        Caption = 'Format A3'
        TabOrder = 19
        OnClick = LPdfPrintOutClick
      end
      object glegendMode: TGroupBox
        Left = 314
        Top = 296
        Width = 161
        Height = 136
        Caption = 'Legenda'
        TabOrder = 20
        object glegendColorByLabel: TLabel
          Left = 8
          Top = 88
          Width = 93
          Height = 14
          Caption = 'Kolory w legendzie'
        end
        object glegendAbbr: TCheckBox
          Left = 8
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Skr'#243't wyk'#322'adowcy'
          TabOrder = 0
        end
        object glegendSummary: TCheckBox
          Left = 8
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Forma + liczba zaj'#281#263
          TabOrder = 1
        end
        object glegendECTS: TCheckBox
          Left = 8
          Top = 48
          Width = 137
          Height = 17
          Caption = 'ECTS'
          TabOrder = 2
        end
        object glegendSummaryGroup: TCheckBox
          Left = 8
          Top = 64
          Width = 137
          Height = 17
          Caption = 'Grupy + liczba zaj'#281#263
          TabOrder = 3
        end
        object glegendColorBy: TComboBox
          Left = 8
          Top = 104
          Width = 145
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 0
          TabOrder = 4
          Text = 'Przedmiot'
          Items.Strings = (
            'Przedmiot'
            'Grupa'
            'Wyk'#322'adowca'
            'Forma'
            'Sala')
        end
      end
    end
    object TabSheetR: TTabSheet
      Caption = 'Zas'#243'b'
      ImageIndex = 2
      object RcomboSpanlabel: TLabel
        Left = 8
        Top = 414
        Width = 84
        Height = 14
        Caption = 'Scalanie kom'#243'rek'
      end
      object rhelp: TSpeedButton
        Left = 450
        Top = 273
        Width = 23
        Height = 22
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
        OnClick = lhelpClick
      end
      object RHideEmptyRowsB: TSpeedButton
        Left = 142
        Top = 385
        Width = 41
        Height = 15
        Caption = 'Wi'#281'cej'
        Flat = True
        OnClick = RHideEmptyRowsBClick
      end
      object RDescGroup: TGroupBox
        Left = 1
        Top = 40
        Width = 306
        Height = 152
        Caption = 'Opisy'
        TabOrder = 0
        object Label14: TLabel
          Left = 10
          Top = 16
          Width = 241
          Height = 14
          Caption = 
            'Zawarto'#347#263'                                                   Wielk.  Pogr' +
            '.'
        end
        object RD1: TComboBox
          Left = 6
          Top = 30
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 0
        end
        object RD2: TComboBox
          Left = 6
          Top = 54
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 1
        end
        object RD3: TComboBox
          Left = 6
          Top = 78
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 2
        end
        object RD4: TComboBox
          Left = 6
          Top = 102
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 3
          Items.Strings = (
            '')
        end
        object RD5: TComboBox
          Left = 6
          Top = 126
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 4
        end
        object RS1: TEdit
          Left = 221
          Top = 30
          Width = 38
          Height = 22
          TabOrder = 5
          Text = '10'
        end
        object RS2: TEdit
          Left = 221
          Top = 54
          Width = 38
          Height = 22
          TabOrder = 6
          Text = '8'
        end
        object RS3: TEdit
          Left = 221
          Top = 78
          Width = 38
          Height = 22
          TabOrder = 7
          Text = '8'
        end
        object RS4: TEdit
          Left = 221
          Top = 102
          Width = 38
          Height = 22
          TabOrder = 8
          Text = '8'
        end
        object RS5: TEdit
          Left = 221
          Top = 123
          Width = 38
          Height = 22
          TabOrder = 9
          Text = '8'
        end
        object RB5: TCheckBox
          Left = 262
          Top = 128
          Width = 17
          Height = 17
          TabOrder = 10
        end
        object RB4: TCheckBox
          Left = 262
          Top = 104
          Width = 17
          Height = 17
          TabOrder = 11
        end
        object RB3: TCheckBox
          Left = 262
          Top = 80
          Width = 17
          Height = 17
          TabOrder = 12
        end
        object RB2: TCheckBox
          Left = 262
          Top = 56
          Width = 17
          Height = 17
          TabOrder = 13
        end
        object RB1: TCheckBox
          Left = 262
          Top = 32
          Width = 17
          Height = 17
          Checked = True
          State = cbChecked
          TabOrder = 14
        end
        object RLinkLabel: TLabel
          Left = 282
          Top = 16
          Width = 20
          Height = 14
          Caption = 'Link'
        end
        object RLink1: TCheckBox
          Left = 284
          Top = 32
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 15
        end
        object RLink2: TCheckBox
          Left = 284
          Top = 56
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 16
        end
        object RLink3: TCheckBox
          Left = 284
          Top = 80
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 17
        end
        object RLink4: TCheckBox
          Left = 284
          Top = 104
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 18
        end
        object RLink5: TCheckBox
          Left = 284
          Top = 128
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
        end
      end
      object RCellSizes: TGroupBox
        Left = 1
        Top = 191
        Width = 169
        Height = 97
        Caption = 'Kom'#243'rka'
        TabOrder = 1
        object Label5: TLabel
          Left = 8
          Top = 24
          Width = 109
          Height = 14
          Caption = 'Szeroko'#347#263':..................'
        end
        object Label6: TLabel
          Left = 8
          Top = 48
          Width = 132
          Height = 14
          Caption = 'Wysoko'#347#263':..........................'
        end
        object Label11: TLabel
          Left = 8
          Top = 75
          Width = 99
          Height = 14
          Caption = 'Rozmiar czcionki:.....'
        end
        object RW: TEdit
          Left = 96
          Top = 16
          Width = 65
          Height = 22
          TabOrder = 0
          Text = '15'
        end
        object RH: TEdit
          Left = 96
          Top = 40
          Width = 65
          Height = 22
          TabOrder = 1
          Text = '10'
        end
        object RCELLSIZE: TEdit
          Left = 96
          Top = 64
          Width = 65
          Height = 22
          TabOrder = 2
          Text = '10'
        end
      end
      object rRShowLegend: TCheckBox
        Tag = 67108864
        Left = 0
        Top = 288
        Width = 97
        Height = 17
        Caption = 'Dodaj legend'#281
        TabOrder = 2
        OnClick = rRShowLegendClick
      end
      object rheadergroup: TGroupBox
        Left = 314
        Top = 0
        Width = 609
        Height = 121
        Caption = 'Wsp'#243'lny nag'#322#243'wek dla wszystkich rozk'#322'ad'#243'w zaj'#281#263
        TabOrder = 3
        object RHEADER: TMemo
          Left = 2
          Top = 16
          Width = 605
          Height = 103
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object rfootergroup: TGroupBox
        Left = 314
        Top = 136
        Width = 609
        Height = 137
        Caption = 'Wsp'#243'lna stopka dla wszystkich rozk'#322'ad'#243'w zaj'#281#263
        TabOrder = 4
        object RFOOTER: TMemo
          Left = 2
          Top = 16
          Width = 605
          Height = 119
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object RViewTypeGroup: TGroupBox
        Left = 1
        Top = 0
        Width = 256
        Height = 40
        Caption = 'Kolorowanie'
        TabOrder = 5
        object RViewType: TComboBox
          Left = 9
          Top = 14
          Width = 240
          Height = 22
          Hint = 'Kolorowanie ze wzgl'#281'du na'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 0
        end
      end
      object RRepeatMonthNames: TCheckBox
        Tag = 67108864
        Left = 0
        Top = 320
        Width = 169
        Height = 17
        Caption = 'Powtarzaj nazwy miesi'#281'cy'
        TabOrder = 6
      end
      object RWeekPlans: TCheckBox
        Left = 0
        Top = 360
        Width = 190
        Height = 17
        Hint = 'Nad datami grafiku przyciski do plan'#243'w tygodniowych (plany s'#261' tworzone razem z grafikiem)'
        Caption = 'Przejd'#378' do planu tygodnia'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 99
      end
      object RHideEmptyRows: TCheckBox
        Left = 0
        Top = 336
        Width = 137
        Height = 17
        Caption = 'Ukrywaj puste wiersze'
        TabOrder = 7
        OnClick = LHideEmptyRowsClick
      end
      object RcomboSpan: TComboBox
        Left = 7
        Top = 431
        Width = 194
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        MaxLength = 255
        TabOrder = 8
        Items.Strings = (
          'Scalaj '
          'Nie scalaj'
          'Scalaj tylko w poziomie'
          'Scalaj tylko w pionie'
          'Scalaj w poziomie, potem w pionie'
          'Scalaj w pionie, potem w poziomie')
      end
      object rspanEmptyCells: TCheckBox
        Left = 208
        Top = 431
        Width = 157
        Height = 17
        Caption = 'Scalaj puste kom'#243'rki'
        TabOrder = 9
        OnClick = LHideEmptyRowsClick
      end
      object RTransposition: TCheckBox
        Left = 0
        Top = 399
        Width = 129
        Height = 17
        Caption = 'Obr'#243#263
        TabOrder = 10
        OnClick = LHideEmptyRowsClick
      end
      object RVerticalLines: TCheckBox
        Left = 482
        Top = 296
        Width = 201
        Height = 17
        Caption = 'Pogrubione linie mi'#281'dzy miesi'#261'cami'
        TabOrder = 11
        Visible = False
        OnClick = LHideEmptyRowsClick
      end
      object RAddCreationDate: TComboBox
        Left = 481
        Top = 319
        Width = 186
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        ItemIndex = 0
        MaxLength = 255
        TabOrder = 12
        Text = 'Data aktualizacji pod rozk'#322'adem'
        Items.Strings = (
          'Data aktualizacji pod rozk'#322'adem'
          'Data aktualizacji nad rozk'#322'adem'
          'Nie wstawiaj daty aktualizacji')
      end
      object Rnotes_before: TCheckBox
        Left = 314
        Top = 120
        Width = 433
        Height = 17
        Caption = 'Nag'#322#243'wek rozk'#322'adu zaj'#281#263
        TabOrder = 13
      end
      object Rnotes_after: TCheckBox
        Left = 314
        Top = 272
        Width = 129
        Height = 17
        Caption = 'Stopka rozk'#322'adu zaj'#281#263
        TabOrder = 14
      end
      object RPdfPrintOut: TCheckBox
        Left = 674
        Top = 272
        Width = 97
        Height = 17
        Caption = 'Wydruk pdf'
        TabOrder = 15
        OnClick = LPdfPrintOutClick
      end
      object rpdfg: TCheckBox
        Left = 674
        Top = 288
        Width = 129
        Height = 17
        Caption = 'Wydruk czarno-bia'#322'y'
        TabOrder = 16
        OnClick = LPdfPrintOutClick
      end
      object rpdfl: TCheckBox
        Left = 674
        Top = 304
        Width = 97
        Height = 17
        Caption = 'Niska jako'#347#263
        TabOrder = 17
        OnClick = LPdfPrintOutClick
      end
      object rpdfo: TCheckBox
        Left = 674
        Top = 320
        Width = 129
        Height = 17
        Caption = 'Poziomy wyk'#322'ad strony'
        TabOrder = 18
        OnClick = LPdfPrintOutClick
      end
      object rpdfs: TCheckBox
        Left = 674
        Top = 336
        Width = 97
        Height = 17
        Caption = 'Format A3'
        TabOrder = 19
        OnClick = LPdfPrintOutClick
      end
      object rlegendMode: TGroupBox
        Left = 314
        Top = 296
        Width = 161
        Height = 136
        Caption = 'Legenda'
        TabOrder = 20
        object rlegendColorByLabel: TLabel
          Left = 8
          Top = 88
          Width = 93
          Height = 14
          Caption = 'Kolory w legendzie'
        end
        object rlegendAbbr: TCheckBox
          Left = 8
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Skr'#243't wyk'#322'adowcy'
          TabOrder = 0
        end
        object rlegendSummary: TCheckBox
          Left = 8
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Forma + liczba zaj'#281#263
          TabOrder = 1
        end
        object rlegendECTS: TCheckBox
          Left = 8
          Top = 48
          Width = 137
          Height = 17
          Caption = 'ECTS'
          TabOrder = 2
        end
        object rlegendSummaryGroup: TCheckBox
          Left = 8
          Top = 64
          Width = 137
          Height = 17
          Caption = 'Grupy + liczba zaj'#281#263
          TabOrder = 3
        end
        object rlegendColorBy: TComboBox
          Left = 8
          Top = 104
          Width = 145
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 0
          TabOrder = 4
          Text = 'Przedmiot'
          Items.Strings = (
            'Przedmiot'
            'Grupa'
            'Wyk'#322'adowca'
            'Forma'
            'Sala')
        end
      end
    end
    object TabSheetS: TTabSheet
      Caption = 'Przedmiot'
      ImageIndex = 3
      object SHideEmptyRowsB: TSpeedButton
        Left = 142
        Top = 385
        Width = 41
        Height = 15
        Caption = 'Wi'#281'cej'
        Flat = True
        OnClick = SHideEmptyRowsBClick
      end
      object ScomboSpanlabel: TLabel
        Left = 8
        Top = 414
        Width = 84
        Height = 14
        Caption = 'Scalanie kom'#243'rek'
      end
      object Shelp: TSpeedButton
        Left = 450
        Top = 273
        Width = 23
        Height = 22
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
        OnClick = lhelpClick
      end
      object SViewTypeGroup: TGroupBox
        Left = 1
        Top = 0
        Width = 256
        Height = 40
        Caption = 'Kolorowanie'
        TabOrder = 0
        object SViewType: TComboBox
          Left = 9
          Top = 14
          Width = 240
          Height = 22
          Hint = 'Kolorowanie ze wzgl'#281'du na'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 0
        end
      end
      object Sheadergroup: TGroupBox
        Left = 314
        Top = 0
        Width = 609
        Height = 121
        Caption = 'Wsp'#243'lny nag'#322#243'wek dla wszystkich rozk'#322'ad'#243'w zaj'#281#263
        TabOrder = 1
        object SHEADER: TMemo
          Left = 2
          Top = 16
          Width = 605
          Height = 103
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object Snotes_before: TCheckBox
        Left = 314
        Top = 120
        Width = 433
        Height = 17
        Caption = 'Nag'#322#243'wek rozk'#322'adu zaj'#281#263
        TabOrder = 2
      end
      object Sfootergroup: TGroupBox
        Left = 314
        Top = 136
        Width = 609
        Height = 137
        Caption = 'Wsp'#243'lna stopka dla wszystkich rozk'#322'ad'#243'w zaj'#281#263
        TabOrder = 3
        object SFOOTER: TMemo
          Left = 2
          Top = 16
          Width = 605
          Height = 119
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
        end
      end
      object SDescGroup: TGroupBox
        Left = 1
        Top = 40
        Width = 306
        Height = 152
        Caption = 'Opisy'
        TabOrder = 4
        object Label8: TLabel
          Left = 10
          Top = 16
          Width = 241
          Height = 14
          Caption = 
            'Zawarto'#347#263'                                                   Wielk.  Pogr' +
            '.'
        end
        object SD1: TComboBox
          Left = 6
          Top = 30
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 0
        end
        object SD2: TComboBox
          Left = 6
          Top = 54
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 1
        end
        object SD3: TComboBox
          Left = 6
          Top = 78
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 2
        end
        object SD4: TComboBox
          Left = 6
          Top = 102
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 3
          Items.Strings = (
            '')
        end
        object SD5: TComboBox
          Left = 6
          Top = 126
          Width = 215
          Height = 22
          Hint = 'WYPE'#321'NIENIE BLOKU'
          Style = csOwnerDrawFixed
          DropDownCount = 25
          ItemHeight = 16
          MaxLength = 255
          TabOrder = 4
        end
        object SS1: TEdit
          Left = 221
          Top = 30
          Width = 38
          Height = 22
          TabOrder = 5
          Text = '10'
        end
        object SS2: TEdit
          Left = 221
          Top = 54
          Width = 38
          Height = 22
          TabOrder = 6
          Text = '8'
        end
        object SS3: TEdit
          Left = 221
          Top = 78
          Width = 38
          Height = 22
          TabOrder = 7
          Text = '8'
        end
        object SS4: TEdit
          Left = 221
          Top = 102
          Width = 38
          Height = 22
          TabOrder = 8
          Text = '8'
        end
        object SS5: TEdit
          Left = 221
          Top = 123
          Width = 38
          Height = 22
          TabOrder = 9
          Text = '8'
        end
        object SB5: TCheckBox
          Left = 262
          Top = 128
          Width = 17
          Height = 17
          TabOrder = 10
        end
        object SB4: TCheckBox
          Left = 262
          Top = 104
          Width = 17
          Height = 17
          TabOrder = 11
        end
        object SB3: TCheckBox
          Left = 262
          Top = 80
          Width = 17
          Height = 17
          TabOrder = 12
        end
        object SB2: TCheckBox
          Left = 262
          Top = 56
          Width = 17
          Height = 17
          TabOrder = 13
        end
        object SB1: TCheckBox
          Left = 262
          Top = 32
          Width = 17
          Height = 17
          Checked = True
          State = cbChecked
          TabOrder = 14
        end
        object SLinkLabel: TLabel
          Left = 282
          Top = 16
          Width = 20
          Height = 14
          Caption = 'Link'
        end
        object SLink1: TCheckBox
          Left = 284
          Top = 32
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 15
        end
        object SLink2: TCheckBox
          Left = 284
          Top = 56
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 16
        end
        object SLink3: TCheckBox
          Left = 284
          Top = 80
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 17
        end
        object SLink4: TCheckBox
          Left = 284
          Top = 104
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 18
        end
        object SLink5: TCheckBox
          Left = 284
          Top = 128
          Width = 17
          Height = 17
          Hint = 'Nazwa jest linkiem do rozk'#322'adu (wyk'#322'adowcy, grupy, zasobu)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
        end
      end
      object SCellSizes: TGroupBox
        Left = 1
        Top = 191
        Width = 169
        Height = 97
        Caption = 'Kom'#243'rka'
        TabOrder = 5
        object Label15: TLabel
          Left = 8
          Top = 24
          Width = 109
          Height = 14
          Caption = 'Szeroko'#347#263':..................'
        end
        object Label16: TLabel
          Left = 8
          Top = 48
          Width = 132
          Height = 14
          Caption = 'Wysoko'#347#263':..........................'
        end
        object Label17: TLabel
          Left = 8
          Top = 75
          Width = 99
          Height = 14
          Caption = 'Rozmiar czcionki:.....'
        end
        object SW: TEdit
          Left = 96
          Top = 16
          Width = 65
          Height = 22
          TabOrder = 0
          Text = '15'
        end
        object SH: TEdit
          Left = 96
          Top = 40
          Width = 65
          Height = 22
          TabOrder = 1
          Text = '10'
        end
        object SCELLSIZE: TEdit
          Left = 96
          Top = 64
          Width = 65
          Height = 22
          TabOrder = 2
          Text = '10'
        end
      end
      object SRShowLegend: TCheckBox
        Tag = 67108864
        Left = 0
        Top = 288
        Width = 97
        Height = 17
        Caption = 'Dodaj legend'#281
        TabOrder = 6
        OnClick = SShowLegendClick
      end
      object SRepeatMonthNames: TCheckBox
        Tag = 67108864
        Left = 0
        Top = 320
        Width = 169
        Height = 17
        Caption = 'Powtarzaj nazwy miesi'#281'cy'
        TabOrder = 7
      end
      object SWeekPlans: TCheckBox
        Left = 0
        Top = 360
        Width = 190
        Height = 17
        Hint = 'Nad datami grafiku przyciski do plan'#243'w tygodniowych (plany s'#261' tworzone razem z grafikiem)'
        Caption = 'Przejd'#378' do planu tygodnia'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 99
      end
      object SHideEmptyRows: TCheckBox
        Left = 0
        Top = 336
        Width = 137
        Height = 17
        Caption = 'Ukrywaj puste wiersze'
        TabOrder = 8
        OnClick = LHideEmptyRowsClick
      end
      object STransposition: TCheckBox
        Left = 0
        Top = 399
        Width = 129
        Height = 17
        Caption = 'Obr'#243#263
        TabOrder = 9
        OnClick = LHideEmptyRowsClick
      end
      object ScomboSpan: TComboBox
        Left = 7
        Top = 430
        Width = 194
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        MaxLength = 255
        TabOrder = 10
        Items.Strings = (
          'Scalaj '
          'Nie scalaj'
          'Scalaj tylko w poziomie'
          'Scalaj tylko w pionie'
          'Scalaj w poziomie, potem w pionie'
          'Scalaj w pionie, potem w poziomie')
      end
      object SlegendMode: TGroupBox
        Left = 314
        Top = 296
        Width = 161
        Height = 136
        Caption = 'Legenda'
        TabOrder = 11
        object SlegendColorByLabel: TLabel
          Left = 8
          Top = 88
          Width = 93
          Height = 14
          Caption = 'Kolory w legendzie'
        end
        object SlegendAbbr: TCheckBox
          Left = 8
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Skr'#243't wyk'#322'adowcy'
          TabOrder = 0
        end
        object SlegendSummary: TCheckBox
          Left = 8
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Forma + liczba zaj'#281#263
          TabOrder = 1
        end
        object SlegendECTS: TCheckBox
          Left = 8
          Top = 48
          Width = 137
          Height = 17
          Caption = 'ECTS'
          TabOrder = 2
        end
        object SlegendSummaryGroup: TCheckBox
          Left = 8
          Top = 64
          Width = 137
          Height = 17
          Caption = 'Grupy + liczba zaj'#281#263
          TabOrder = 3
        end
        object SlegendColorBy: TComboBox
          Left = 8
          Top = 104
          Width = 145
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          ItemIndex = 0
          TabOrder = 4
          Text = 'Przedmiot'
          Items.Strings = (
            'Przedmiot'
            'Grupa'
            'Wyk'#322'adowca'
            'Forma'
            'Sala')
        end
      end
      object Snotes_after: TCheckBox
        Left = 314
        Top = 272
        Width = 129
        Height = 17
        Caption = 'Stopka rozk'#322'adu zaj'#281#263
        TabOrder = 12
      end
      object SspanEmptyCells: TCheckBox
        Left = 208
        Top = 431
        Width = 157
        Height = 17
        Caption = 'Scalaj puste kom'#243'rki'
        TabOrder = 13
        OnClick = LHideEmptyRowsClick
      end
      object SVerticalLines: TCheckBox
        Left = 482
        Top = 296
        Width = 201
        Height = 17
        Caption = 'Pogrubione linie mi'#281'dzy miesi'#261'cami'
        TabOrder = 14
        Visible = False
        OnClick = LHideEmptyRowsClick
      end
      object SAddCreationDate: TComboBox
        Left = 481
        Top = 319
        Width = 186
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 25
        ItemHeight = 16
        ItemIndex = 0
        MaxLength = 255
        TabOrder = 15
        Text = 'Data aktualizacji pod rozk'#322'adem'
        Items.Strings = (
          'Data aktualizacji pod rozk'#322'adem'
          'Data aktualizacji nad rozk'#322'adem'
          'Nie wstawiaj daty aktualizacji')
      end
      object SPdfPrintOut: TCheckBox
        Left = 674
        Top = 272
        Width = 97
        Height = 17
        Caption = 'Wydruk pdf'
        TabOrder = 16
        OnClick = LPdfPrintOutClick
      end
      object Spdfg: TCheckBox
        Left = 674
        Top = 288
        Width = 129
        Height = 17
        Caption = 'Wydruk czarno-bia'#322'y'
        TabOrder = 17
        OnClick = LPdfPrintOutClick
      end
      object Spdfl: TCheckBox
        Left = 674
        Top = 304
        Width = 97
        Height = 17
        Caption = 'Niska jako'#347#263
        TabOrder = 18
        OnClick = LPdfPrintOutClick
      end
      object Spdfo: TCheckBox
        Left = 674
        Top = 320
        Width = 129
        Height = 17
        Caption = 'Poziomy wyk'#322'ad strony'
        TabOrder = 19
        OnClick = LPdfPrintOutClick
      end
      object Spdfs: TCheckBox
        Left = 674
        Top = 336
        Width = 97
        Height = 17
        Caption = 'Format A3'
        TabOrder = 20
        OnClick = LPdfPrintOutClick
      end
    end
    object tsAdvanced: TTabSheet
      Caption = 'Zaawansowane'
      ImageIndex = 4
      object LMaxLecturersInLegend: TLabel
        Left = 144
        Top = 256
        Width = 349
        Height = 14
        Caption = '<Legenda: maksymalna liczba wyk'#322'adowc'#243'w przy jednym przedmiocie>'
      end
      object LMaxLengthCALC_GROUPS: TLabel
        Left = 144
        Top = 64
        Width = 294
        Height = 14
        Caption = '<Maksymalna d'#322'ugo'#347#263' nazwy grupy w kom'#243'rce w znakach>'
      end
      object LMaxLengthCreated_by: TLabel
        Left = 144
        Top = 208
        Width = 126
        Height = 14
        Caption = 'jw. dla "utworzono przez"'
      end
      object LMaxLengthCALC_ROOMS: TLabel
        Left = 144
        Top = 112
        Width = 82
        Height = 14
        Caption = '<jw. dla zasobu>'
      end
      object LMaxLengthCALC_LECTURERS: TLabel
        Left = 144
        Top = 88
        Width = 109
        Height = 14
        Caption = '<jw. dla wyk'#322'adowcy>'
      end
      object LCellWidthHour: TLabel
        Left = 144
        Top = 40
        Width = 239
        Height = 14
        Caption = 'Szeroko'#347#263' drugiej kolumny (godziny) w pikselach'
      end
      object LCellWidthDay: TLabel
        Left = 144
        Top = 16
        Width = 287
        Height = 14
        Caption = 'Szeroko'#347#263' pierwszej kolumny (dzie'#324' tygodnia) w pikselach'
      end
      object LCellWidthInLegend: TLabel
        Left = 144
        Top = 232
        Width = 293
        Height = 14
        Caption = 'Legenda: Szeroko'#347#263' legendy w pikselach (punktach ekranu)'
      end
      object LMaxLengthSUB_abbreviation: TLabel
        Left = 144
        Top = 136
        Width = 99
        Height = 14
        Caption = '<jw. dla przedmiotu>'
      end
      object LMaxLengthOwner: TLabel
        Left = 145
        Top = 184
        Width = 127
        Height = 14
        Caption = 'jw. dla "w'#322'a'#347'ciciel zaj'#281'cia"'
      end
      object LMaxLengthFOR_abbreviation: TLabel
        Left = 144
        Top = 160
        Width = 103
        Height = 14
        Caption = '<jw. dla formy zaj'#281#263'>'
      end
      object Label20: TLabel
        Left = 144
        Top = 280
        Width = 232
        Height = 14
        Caption = 'Maksymalna d'#322'ugo'#347#263' opis'#243'w 1,2,3,4 w znakach'
      end
      object MaxLecturersInLegend: TEdit
        Left = 8
        Top = 248
        Width = 121
        Height = 22
        TabOrder = 10
        Text = '1000'
      end
      object CellWidthInLegend: TEdit
        Left = 8
        Top = 224
        Width = 121
        Height = 22
        TabOrder = 9
        Text = '1000'
      end
      object MaxLengthSUB_abbreviation: TEdit
        Left = 8
        Top = 128
        Width = 121
        Height = 22
        TabOrder = 5
        Text = '1000'
      end
      object MaxLengthOwner: TEdit
        Left = 8
        Top = 176
        Width = 121
        Height = 22
        TabOrder = 7
        Text = '1000'
      end
      object MaxLengthFOR_abbreviation: TEdit
        Left = 8
        Top = 152
        Width = 121
        Height = 22
        TabOrder = 6
        Text = '1000'
      end
      object MaxLengthCreated_by: TEdit
        Left = 8
        Top = 200
        Width = 121
        Height = 22
        TabOrder = 8
        Text = '1000'
      end
      object MaxLengthCALC_ROOMS: TEdit
        Left = 8
        Top = 104
        Width = 121
        Height = 22
        TabOrder = 4
        Text = '1000'
      end
      object MaxLengthCALC_LECTURERS: TEdit
        Left = 8
        Top = 80
        Width = 121
        Height = 22
        TabOrder = 3
        Text = '1000'
      end
      object MaxLengthCALC_GROUPS: TEdit
        Left = 8
        Top = 56
        Width = 121
        Height = 22
        TabOrder = 2
        Text = '1000'
      end
      object CellWidthHour: TEdit
        Left = 8
        Top = 32
        Width = 121
        Height = 22
        TabOrder = 1
        Text = '1000'
      end
      object CellWidthDay: TEdit
        Left = 8
        Top = 8
        Width = 121
        Height = 22
        TabOrder = 0
        Text = '1000'
      end
      object MaxLengthDesc1: TEdit
        Left = 8
        Top = 272
        Width = 33
        Height = 22
        TabOrder = 11
        Text = '1000'
      end
      object MaxLengthDesc2: TEdit
        Left = 40
        Top = 272
        Width = 33
        Height = 22
        TabOrder = 12
        Text = '1000'
      end
      object MaxLengthDesc3: TEdit
        Left = 72
        Top = 272
        Width = 33
        Height = 22
        TabOrder = 13
        Text = '1000'
      end
      object MaxLengthDesc4: TEdit
        Left = 104
        Top = 272
        Width = 33
        Height = 22
        TabOrder = 14
        Text = '1000'
      end
      object BitBtn1: TBitBtn
        Left = 136
        Top = 304
        Width = 241
        Height = 25
        Caption = 'Uruchom edytor rejestru ( zaawansowane )'
        TabOrder = 16
        OnClick = BitBtn1Click
      end
      object BitBtn2: TBitBtn
        Left = 8
        Top = 304
        Width = 121
        Height = 25
        Caption = 'Zapisz zmiany'
        TabOrder = 15
        OnClick = BitBtn2Click
      end
      object WeeklyView: TCheckBox
        Left = 8
        Top = 336
        Width = 369
        Height = 17
        Caption = 'Uk'#322'ad tygodniowy (bez dat)'
        Enabled = False
        TabOrder = 17
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 934
    Height = 41
    Align = alTop
    TabOrder = 3
    object Label7: TLabel
      Left = 8
      Top = 16
      Width = 86
      Height = 14
      Alignment = taRightJustify
      Caption = 'Zestaw ustawie'#324
    end
    object PaperSize: TComboBox
      Left = 117
      Top = 10
      Width = 90
      Height = 22
      Hint = 'WYPE'#321'NIENIE BLOKU'
      Style = csOwnerDrawFixed
      DropDownCount = 25
      ItemHeight = 16
      MaxLength = 255
      TabOrder = 0
      OnChange = PaperSizeChange
      Items.Strings = (
        'A4'
        'A3')
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'Ini|*.INI'
    Left = 648
    Top = 264
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'INI'
    Filter = 'INI|*.INI'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Left = 616
    Top = 264
  end
end
