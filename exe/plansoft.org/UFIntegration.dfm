inherited FIntegration: TFIntegration
  Left = 520
  Top = 229
  Width = 1274
  Height = 682
  Caption = 'Integracja'
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 590
    Width = 1266
  end
  object Panel2: TPanel
    Left = 0
    Top = 610
    Width = 1266
    Height = 41
    Align = alBottom
    TabOrder = 1
    object BZamknij: TBitBtn
      Left = 7
      Top = 5
      Width = 75
      Height = 28
      Hint = 'Zamknij bie'#380#261'ce okno'
      Cancel = True
      Caption = 'Zamknij'
      Default = True
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
        F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
        000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
        338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
        45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
        3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
        F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
        000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
        338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
        4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
        8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
        0000}
      NumGlyphs = 2
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 1266
    Height = 169
    Align = alTop
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 1264
      Height = 167
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Podstawowe'
        object Label1: TLabel
          Left = 16
          Top = 8
          Width = 40
          Height = 14
          Caption = 'Semestr'
        end
        object BConfirmation2: TLabel
          Left = 504
          Top = 48
          Width = 390
          Height = 14
          Caption = 
            'Zlecenie wys'#322'ania rozk'#322'adu zaj'#281#263' zosta'#322'o przyj'#281'te i zostanie wkr' +
            #243'tce wykonane.'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object BConfirmation1: TLabel
          Left = 504
          Top = 24
          Width = 373
          Height = 14
          Caption = 
            'Zlecenie pobrania planu zaj'#281#263' zosta'#322'o przyj'#281'te i zostanie wkr'#243'tc' +
            'e wykonane.'
          Font.Charset = EASTEUROPE_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object INT_PERIOD_NAME: TEdit
          Left = 16
          Top = 24
          Width = 169
          Height = 22
          TabOrder = 0
          Text = 'INT_PERIOD_NAME'
        end
        object BReport: TBitBtn
          Left = 232
          Top = 80
          Width = 265
          Height = 33
          Caption = 'Raport: Zaj'#281'cia bez planu studi'#243'w'
          TabOrder = 1
          Visible = False
          OnClick = BReportClick
        end
        object RunIntFromPlansoft: TBitBtn
          Left = 232
          Top = 48
          Width = 265
          Height = 33
          Caption = 'Wy'#347'lij Rozk'#322'ad'
          TabOrder = 2
          OnClick = RunIntFromPlansoftClick
        end
        object RunIntToPlansoftPlan: TBitBtn
          Left = 232
          Top = 16
          Width = 265
          Height = 33
          Caption = 'Pobierz Plan'
          TabOrder = 3
          OnClick = RunIntToPlansoftPlanClick
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Konfiguracja'
        ImageIndex = 1
        object LRESCAT_COMB_ID: TLabel
          Left = 40
          Top = 12
          Width = 82
          Height = 14
          Caption = 'Typ ograniczenia'
        end
        object INT_RESCAT_COMB_ID_VALUE: TEdit
          Left = 128
          Top = 3
          Width = 301
          Height = 22
          ReadOnly = True
          TabOrder = 0
        end
        object RESCAT_COMB_IDSel: TBitBtn
          Left = 432
          Top = 3
          Width = 25
          Height = 24
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
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
        object INT_RESCAT_COMB_ID: TEdit
          Left = 464
          Top = 0
          Width = 121
          Height = 22
          TabOrder = 2
          Text = 'INT_RESCAT_COMB_ID'
          Visible = False
          OnChange = INT_RESCAT_COMB_IDChange
        end
        object BitBtn2: TBitBtn
          Left = 40
          Top = 32
          Width = 113
          Height = 33
          Caption = 'Pobierz S'#322'owniki'
          TabOrder = 3
          Visible = False
          OnClick = BitBtn2Click
        end
      end
    end
  end
  object PageControl2: TPageControl
    Left = 0
    Top = 169
    Width = 1266
    Height = 421
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 3
    OnChange = PageControl2Change
    object TabSheet3: TTabSheet
      Caption = 'Dziennik zdarze'#324
      object Grid: TRxDBGrid
        Left = 0
        Top = 0
        Width = 1258
        Height = 392
        Align = alClient
        DataSource = Source
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgRowLines, dgAlwaysShowSelection, dgCancelOnExit]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = [fsBold]
        TitleButtons = True
        Columns = <
          item
            Expanded = False
            FieldName = 'CREATED'
            Title.Caption = 'Uruchomiono'
            Width = 171
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MESSAGE'
            Title.Caption = 'Komunikat'
            Width = 3000
            Visible = True
          end>
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Duplikaty'
      ImageIndex = 1
      object GridDuplicates: TRxDBGrid
        Left = 0
        Top = 41
        Width = 1258
        Height = 351
        Align = alClient
        DataSource = DSDuplicates
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgRowLines, dgAlwaysShowSelection, dgCancelOnExit]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = [fsBold]
        TitleButtons = True
        Columns = <
          item
            Expanded = False
            FieldName = 'TYPE'
            Title.Caption = 'Typ'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'Id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ABBREVIATION'
            Title.Caption = 'Skr'#243't'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NAME'
            Title.Caption = 'Nazwa'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INTEGRATION_ID'
            Title.Caption = 'Integration Id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATION_DATE'
            Title.Caption = 'Utworzono dnia'
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
            FieldName = 'last_update_date'
            Title.Caption = 'Zmodyfikowano'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'last_updated_by'
            Title.Caption = 'Zmodyfikowa'#322
            Width = 100
            Visible = True
          end>
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 1258
        Height = 41
        Align = alTop
        TabOrder = 1
        object BitBtn4: TBitBtn
          Left = 4
          Top = 4
          Width = 37
          Height = 33
          Hint = 'Eksportuj do pakietu Office/ html'
          TabOrder = 0
          OnClick = BitBtn4Click
          Glyph.Data = {
            AE060000424DAE06000000000000360000002800000017000000170000000100
            18000000000078060000C40E0000C40E0000000000000000000130640D35650B
            35660B35660B35660C35660C35660C35660C35660C36670D37670E38680E3868
            0F35660C35660C35660C35660C35660C35660C35660C35660B34650F386A0000
            00004273234971214A72224A72224A73234C73244C74264C74234B7321477220
            416E193E6A173B6A1148721F4A73204971224A72234971224A72224A72234971
            214971254C75150000003F701E456E1E477020446F1C406B183C681239650E39
            640C3D69104973205B813C7495568DA6794F762847711C4971214A7222497121
            4A72224A7222497121466F224872100000003E701F456F1C406C17456F1E597F
            347190518DA674B0C09ED0D8C4E7EBE0F9FAF9FFFFFFFDFBFB48722230620536
            640B36650C34630A35640B35640B38660E446D204973110000004072213B6810
            9AB388E5E9E0F6F6F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFDFDFDE5EA
            E17998629EB38A9BB28896AF849BB38A9BB38A9AB2898BA6754A722648711000
            000041732239670CBFCFB2FFFFFFFDFDFDFCFCFCFBFCFBFCFCFBFCFBFCFCFDFC
            FDFDFDFEFEFEE4E9E09AB289DDE2D6D8E1D3F0F2EEDAE2D3D7DFCFE5E9E0FBFC
            F950782D446F0A0000004072213A680EB8C8AAFDFDFDFBFCFBFCFDFCFCFDFBFE
            FEFEFDFCFDFCFDFCFEFEFDFEFEFEF1F4ED426F1C2659003060088FAB7E2C5F00
            225800527A30ECF2EA50782C45700A00000041732239670DB9CAABFFFFFFFBFC
            FBFFFFFFFFFFFFF9FAFAFFFFFFFFFFFFFAFAFAFFFFFFEAEEE7709057849F6988
            A371C1CFB286A36B7F9D649DB38AEFF1EB50782B456F0A0000004173223A680E
            BACAACFFFFFFFEFEFEDBE3D4A4B893FFFFFFBBCCAE87A26EF9FAF8FEFDFEEBEF
            E8668A49718E4F739459B5C7A9709254698D4B8DA475EFF2EC50782B45700A00
            00004173223A680EBACAACFFFFFFFEFEFEE4ECDE3A6912D5DDCB5F823B91A775
            FFFFFFFEFCFDEFF2EB527A30486F1D4E792CA0B892497427406D1A6F8D51EFF4
            EC50772C45700A0000004173223A680EBACAACFFFFFFF9FBF8FFFFFF99AD8254
            7A315E823BEFF3EDFDFCFDFFFEFEE8ECE47F9C6AA5B699A4B897D0D9C6A5B995
            9FB48FB4C4AAEFF1EB50782C45700A0000004173223A680EBACAACFFFFFFFAFB
            F9FEFEFDE4E8DF2D61038CA679FFFFFFFAFAF9FEFFFEF0F3ED4771202E5D0039
            671097B08334620A2A5B00588034EFF3ED50782B45700A0000004173223A680E
            BACAACFFFFFFF9FAF8FFFFFFB5C7A43E6B17698D4AFAFBF9FDFDFDFFFFFFE9ED
            E577975F98AE8098AD82C9D4BE97AF7F91A97BACBD9BEFF2ED50782C45700A00
            00004173223A680EBACAACFFFFFFFCFCFBF6F8F44B7527A7BD975D823BAFBF9B
            FFFFFFFCFCFCEEF0EA598139577F3A5F8542A9BD9E5B813C537A33799762EFF2
            ED50772B45700A0000004172213A680EB9C9ACFFFFFFFEFEFEE0E6D978965CF7
            F8F8A9BD98729058FCFCFCFEFEFDEDF0EA5C8039587D325D823DAABD9C5B8138
            527A2E78995FF0F3EE50782C45700A00000041732239670DB9CAABFFFEFFFBFC
            FBFFFEFFFFFFFFFFFEFFFFFFFFF7FBF6FCFCFCFFFFFFE9ECE576986398B0819A
            B287C9D5C299B08394AC7CADBE9DF0F1EC50782B446F0A0000004072213A680E
            B8C8AAFDFDFCFBFCFBFDFDFDFCFDFCFEFEFEFEFDFEFFFFFFFEFEFEFEFEFEF0F3
            EE416E1A2257002F5F068EA97A295B0020540052772CECF1EA50772C45700A00
            00004172213A660EC1CFB3FFFFFFFDFDFDFDFDFDFBFCFBFBFBFBFCFCFBFCFDFB
            FDFDFDFEFEFEE7EAE28FA877C0CFB2BECCB4E1E8DDBFCEB1BACBADCBD9C4FBFB
            F652792F4570090000004071203C6A1294AE82DEE3D4F0F2ECFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFDFEFDE7EBE278985F9BB28598AF8394AC7D99B082
            9AB08397B18084A16C4A722748730D0000003E701E466F1E406917446D195479
            30698C4883A16BA5BA96C4D2B9E0E5D9F4F5F1FFFFFFF9FAF94B722131610436
            640A36640C35630A36630B36630B38650F456D214973110000003F711F456E1D
            48702047701F426D183C6A1337680E37660D396810446F1A567C326F8F5085A2
            6D4E76264871204971224971224972214A72224A7222487121466F2248721000
            00004173224871214A72224972214A72244B73254C74254D74274C7326497222
            456F1D406B173D6A124871204A72234972224972224972224972224972224871
            214871254C751400000031670E39650D39650E39650D39650E39660E39660E39
            660E39660E3A660F3B66103C67113C67123A660F39650E39660E39660E39650E
            39650E39650E38650D3964113B6900000000}
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Nie wys'#322'ane'
      ImageIndex = 2
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1258
        Height = 41
        Align = alTop
        TabOrder = 0
        object BitBtn1: TBitBtn
          Left = 4
          Top = 4
          Width = 37
          Height = 33
          Hint = 'Eksportuj do pakietu Office/ html'
          TabOrder = 0
          OnClick = BitBtn1Click
          Glyph.Data = {
            AE060000424DAE06000000000000360000002800000017000000170000000100
            18000000000078060000C40E0000C40E0000000000000000000130640D35650B
            35660B35660B35660C35660C35660C35660C35660C36670D37670E38680E3868
            0F35660C35660C35660C35660C35660C35660C35660C35660B34650F386A0000
            00004273234971214A72224A72224A73234C73244C74264C74234B7321477220
            416E193E6A173B6A1148721F4A73204971224A72234971224A72224A72234971
            214971254C75150000003F701E456E1E477020446F1C406B183C681239650E39
            640C3D69104973205B813C7495568DA6794F762847711C4971214A7222497121
            4A72224A7222497121466F224872100000003E701F456F1C406C17456F1E597F
            347190518DA674B0C09ED0D8C4E7EBE0F9FAF9FFFFFFFDFBFB48722230620536
            640B36650C34630A35640B35640B38660E446D204973110000004072213B6810
            9AB388E5E9E0F6F6F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFDFDFDE5EA
            E17998629EB38A9BB28896AF849BB38A9BB38A9AB2898BA6754A722648711000
            000041732239670CBFCFB2FFFFFFFDFDFDFCFCFCFBFCFBFCFCFBFCFBFCFCFDFC
            FDFDFDFEFEFEE4E9E09AB289DDE2D6D8E1D3F0F2EEDAE2D3D7DFCFE5E9E0FBFC
            F950782D446F0A0000004072213A680EB8C8AAFDFDFDFBFCFBFCFDFCFCFDFBFE
            FEFEFDFCFDFCFDFCFEFEFDFEFEFEF1F4ED426F1C2659003060088FAB7E2C5F00
            225800527A30ECF2EA50782C45700A00000041732239670DB9CAABFFFFFFFBFC
            FBFFFFFFFFFFFFF9FAFAFFFFFFFFFFFFFAFAFAFFFFFFEAEEE7709057849F6988
            A371C1CFB286A36B7F9D649DB38AEFF1EB50782B456F0A0000004173223A680E
            BACAACFFFFFFFEFEFEDBE3D4A4B893FFFFFFBBCCAE87A26EF9FAF8FEFDFEEBEF
            E8668A49718E4F739459B5C7A9709254698D4B8DA475EFF2EC50782B45700A00
            00004173223A680EBACAACFFFFFFFEFEFEE4ECDE3A6912D5DDCB5F823B91A775
            FFFFFFFEFCFDEFF2EB527A30486F1D4E792CA0B892497427406D1A6F8D51EFF4
            EC50772C45700A0000004173223A680EBACAACFFFFFFF9FBF8FFFFFF99AD8254
            7A315E823BEFF3EDFDFCFDFFFEFEE8ECE47F9C6AA5B699A4B897D0D9C6A5B995
            9FB48FB4C4AAEFF1EB50782C45700A0000004173223A680EBACAACFFFFFFFAFB
            F9FEFEFDE4E8DF2D61038CA679FFFFFFFAFAF9FEFFFEF0F3ED4771202E5D0039
            671097B08334620A2A5B00588034EFF3ED50782B45700A0000004173223A680E
            BACAACFFFFFFF9FAF8FFFFFFB5C7A43E6B17698D4AFAFBF9FDFDFDFFFFFFE9ED
            E577975F98AE8098AD82C9D4BE97AF7F91A97BACBD9BEFF2ED50782C45700A00
            00004173223A680EBACAACFFFFFFFCFCFBF6F8F44B7527A7BD975D823BAFBF9B
            FFFFFFFCFCFCEEF0EA598139577F3A5F8542A9BD9E5B813C537A33799762EFF2
            ED50772B45700A0000004172213A680EB9C9ACFFFFFFFEFEFEE0E6D978965CF7
            F8F8A9BD98729058FCFCFCFEFEFDEDF0EA5C8039587D325D823DAABD9C5B8138
            527A2E78995FF0F3EE50782C45700A00000041732239670DB9CAABFFFEFFFBFC
            FBFFFEFFFFFFFFFFFEFFFFFFFFF7FBF6FCFCFCFFFFFFE9ECE576986398B0819A
            B287C9D5C299B08394AC7CADBE9DF0F1EC50782B446F0A0000004072213A680E
            B8C8AAFDFDFCFBFCFBFDFDFDFCFDFCFEFEFEFEFDFEFFFFFFFEFEFEFEFEFEF0F3
            EE416E1A2257002F5F068EA97A295B0020540052772CECF1EA50772C45700A00
            00004172213A660EC1CFB3FFFFFFFDFDFDFDFDFDFBFCFBFBFBFBFCFCFBFCFDFB
            FDFDFDFEFEFEE7EAE28FA877C0CFB2BECCB4E1E8DDBFCEB1BACBADCBD9C4FBFB
            F652792F4570090000004071203C6A1294AE82DEE3D4F0F2ECFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFDFEFDE7EBE278985F9BB28598AF8394AC7D99B082
            9AB08397B18084A16C4A722748730D0000003E701E466F1E406917446D195479
            30698C4883A16BA5BA96C4D2B9E0E5D9F4F5F1FFFFFFF9FAF94B722131610436
            640A36640C35630A36630B36630B38650F456D214973110000003F711F456E1D
            48702047701F426D183C6A1337680E37660D396810446F1A567C326F8F5085A2
            6D4E76264871204971224971224972214A72224A7222487121466F2248721000
            00004173224871214A72224972214A72244B73254C74254D74274C7326497222
            456F1D406B173D6A124871204A72234972224972224972224972224972224871
            214871254C751400000031670E39650D39650E39650D39650E39660E39660E39
            660E39660E3A660F3B66103C67113C67123A660F39650E39660E39660E39650E
            39650E39650E38650D3964113B6900000000}
        end
      end
      object GridNotSent: TRxDBGrid
        Left = 0
        Top = 41
        Width = 1258
        Height = 351
        Align = alClient
        DataSource = DSNotSent
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgRowLines, dgAlwaysShowSelection, dgCancelOnExit]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = [fsBold]
        TitleButtons = True
        Columns = <
          item
            Expanded = False
            FieldName = 'ALERT'
            Width = 289
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_FROM'
            Title.Caption = 'Data Od'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_TO'
            Title.Caption = 'Data Do'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SUB_NAME'
            Title.Caption = 'Przedmiot'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FOR_NAME'
            Title.Caption = 'Forma'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LEC_NAME'
            Title.Caption = 'Wyk'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GRO_NAME'
            Title.Caption = 'Gru'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ROM_NAME'
            Title.Caption = 'Sala'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INTEGRATION_ID_SUB'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INTEGRATION_ID_FOR'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INTEGRATION_ID_LEC'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INTEGRATION_ID_GRO'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INTEGRATION_ID_ROM'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SUB_ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FOR_ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALC_LEC_IDS'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALC_GRO_IDS'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALC_ROM_IDS'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLAN_INTEGRATION_ID'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLAN_INTEGRATION_ID2'
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MERGED_ID'
            Width = 400
            Visible = True
          end>
      end
    end
  end
  object Source: TDataSource
    DataSet = QueryLog
    Left = 512
    Top = 80
  end
  object QueryLog: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select message, to_char(created,'#39'yyyy-mm-dd hh24:mi:ss'#39') created' +
        ' from xxmsztools_eventlog where module_name in  ('#39'INT_TO_PLANSOF' +
        'T'#39','#39'INT_FROM_PLANSOFT'#39') order by id desc')
    Left = 476
    Top = 84
  end
  object Refresh: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = RefreshTimer
    Left = 916
    Top = 40
  end
  object QDuplicates: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from ('
      
        'select '#39'LEC_NAME_UI'#39' type, Id, ABBREVIATION, decode(is_active, 0' +
        ', '#39'NIEAKTYWNY '#39', '#39#39')||FIRST_NAME||'#39' '#39'||LAST_NAME||'#39' '#39'||TITLE as ' +
        'name , integration_id, to_char(creation_date,'#39'yyyy-mm-dd'#39') creat' +
        'ion_date, created_by, last_update_date, last_updated_by'
      
        'from LECTURERS where (FIRST_NAME, LAST_NAME, TITLE) in (select F' +
        'IRST_NAME, LAST_NAME, TITLE from LECTURERS group by FIRST_NAME, ' +
        'LAST_NAME, TITLE having count(1)>1)'
      'union all'
      
        'select '#39'LEC_ABBREVIATION_I'#39' type, Id, ABBREVIATION, decode(is_ac' +
        'tive, 0, '#39'NIEAKTYWNY '#39', '#39#39')||FIRST_NAME||'#39' '#39'||LAST_NAME||'#39' '#39'||TI' +
        'TLE as name, integration_id, to_char(creation_date,'#39'yyyy-mm-dd'#39')' +
        ' creation_date, created_by, last_update_date, last_updated_by'
      
        'from LECTURERS where (ABBREVIATION) in (select ABBREVIATION from' +
        ' LECTURERS group by ABBREVIATION having count(1)>1)'
      'union all'
      
        'select '#39'SUB_NAME_I'#39' type, id, abbreviation, decode(is_active, 0,' +
        ' '#39'NIEAKTYWNY '#39', '#39#39')||name, integration_id, to_char(creation_date' +
        ','#39'yyyy-mm-dd'#39') creation_date, created_by, last_update_date, last' +
        '_updated_by'
      
        'from subjects where name in (select name from subjects group by ' +
        'name having count(1)>1)'
      'union all'
      
        'select '#39'GRO_ABBREVIATION_I'#39' type,  Id, ABBREVIATION, decode(is_a' +
        'ctive, 0, '#39'NIEAKTYWNY '#39', '#39#39')||name ||'#39' '#39' || group_type as name, ' +
        'integration_id, to_char(creation_date,'#39'yyyy-mm-dd'#39') creation_dat' +
        'e, created_by, last_update_date, last_updated_by'
      
        'from groups where ABBREVIATION in (select ABBREVIATION from grou' +
        'ps group by ABBREVIATION having count(1)>1)'
      'union all'
      
        'select '#39'SUB_ABBREVIATION_I'#39' type, id, ABBREVIATION, decode(is_ac' +
        'tive, 0, '#39'NIEAKTYWNY '#39', '#39#39')||name, integration_id, to_char(creat' +
        'ion_date,'#39'yyyy-mm-dd'#39') creation_date, created_by, last_update_da' +
        'te, last_updated_by'
      
        'from subjects where (ABBREVIATION) in (select ABBREVIATION from ' +
        'subjects group by ABBREVIATION having count(1)>1)'
      'union all'
      
        'select '#39'ROOM_UK'#39' type, id, '#39#39' as ABBREVIATION, decode(is_active,' +
        ' 0, '#39'NIEAKTYWNY '#39', '#39#39')|| attribs_01 || '#39' '#39' || name as name, inte' +
        'gration_id, to_char(creation_date,'#39'yyyy-mm-dd'#39') creation_date, c' +
        'reated_by, last_update_date, last_updated_by '
      
        'from rooms where (name, attribs_01) in (select name, ATTRIBS_01 ' +
        'from rooms group by name, ATTRIBS_01 having count(1)>1)'
      ') order by type, name, ABBREVIATION'
      ''
      ''
      '')
    Left = 244
    Top = 292
  end
  object DSDuplicates: TDataSource
    DataSet = QDuplicates
    Left = 280
    Top = 296
  end
  object PPDuplicates: TPopupMenu
    Left = 312
    Top = 296
    object ExportEasy: TMenuItem
      Caption = 'Eksportuj do Excela'
      ImageIndex = 16
      OnClick = ExportEasyClick
    end
    object ExportHtml: TMenuItem
      Caption = 'Eksportuj do pliku'
      ImageIndex = 15
      OnClick = ExportHtmlClick
    end
  end
  object QNotSent: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select '
      'case '
      
        ' when length(PLAN_INTEGRATION_ID2)=2 then '#39'Plan studi'#243'w nie istn' +
        'ieje'#39
      
        ' when length(PLAN_INTEGRATION_ID2)<36 then '#39'Plan studi'#243'w wprowad' +
        'zony r'#281'cznie'#39
      
        ' when length(PLAN_INTEGRATION_ID2)>36 then '#39'Plan studi'#243'w: wi'#281'cej' +
        ' ni'#380' jeden rekord'#39
      
        ' when  length(integration_id_ROM)>36 then '#39'Sala: Wi'#281'cej ni'#380' jedn' +
        'a sala'#39
      
        ' when  length(calc_lec_ids)>2 and integration_id_LEC is null the' +
        'n '#39'Wyk'#322'adowca wprowadzony r'#281'cznie'#39
      
        ' when  length(calc_gro_ids)>2 and integration_id_gro is null the' +
        'n '#39'Grupa wprowadzony r'#281'cznie'#39
      
        ' when  length(calc_rom_ids)>2  and integration_id_rom is null th' +
        'en '#39'Sala wprowadzona r'#281'cznie'#39
      
        ' when  sub_id is not null and integration_id_sub is null then '#39'P' +
        'rzedmiot wprowadzony r'#281'cznie'#39
      
        ' when  for_id is not null and integration_id_for is null then '#39'F' +
        'orma wprowadzony r'#281'cznie'#39
      'end alert'
      ',int_classes.* from'
      '('
      'select to_char(day,'#39'yyyy-mm-dd'#39')||'#39' '#39'||hour_from Date_From'
      '   , to_char(day,'#39'yyyy-mm-dd'#39')||'#39' '#39'||hour_to Date_To'
      '   , (select name from subjects where id = sub_id) SUB_NAME'
      '   , (select name from forms where id = for_id) FOR_NAME'
      
        '   , (select LISTAGG(last_name||'#39' '#39'||first_name||'#39', '#39'||title, '#39',' +
        #39') within group (order by integration_id )  from lecturers where' +
        ' id in (select lec_id from lec_cla where cla_id =int_classes.id ' +
        ') ) LEC_NAME'
      
        '   , (select LISTAGG(name, '#39','#39') within group (order by integrati' +
        'on_id )  from groups where id in (select gro_id from gro_cla whe' +
        're cla_id =int_classes.id ) ) GRO_NAME'
      
        '   , (select LISTAGG(name||'#39' '#39'||attribs_01, '#39','#39') within group (o' +
        'rder by integration_id )  from rooms where id in (select rom_id ' +
        'from rom_cla where cla_id =int_classes.id ) ) ROM_NAME'
      '   , integration_id_sub'
      '   , integration_id_for'
      
        '   , (select LISTAGG(integration_id, '#39','#39') within group (order by' +
        ' integration_id )  from lecturers where id in (select lec_id fro' +
        'm lec_cla where cla_id =int_classes.id ) ) integration_id_LEC'
      
        '   , (select LISTAGG(integration_id, '#39','#39') within group (order by' +
        ' integration_id )  from groups where id in (select gro_id from g' +
        'ro_cla where cla_id =int_classes.id ) ) integration_id_GRO'
      
        '   , (select LISTAGG(integration_id, '#39','#39') within group (order by' +
        ' integration_id )  from rooms where id in (select rom_id from ro' +
        'm_cla where cla_id =int_classes.id ) ) integration_id_ROM'
      '   , sub_id'
      '   , for_id'
      '   , calc_lec_ids'
      '   , calc_gro_ids, calc_rom_ids'
      '   , PLAN_INTEGRATION_ID'
      '   , PLAN_INTEGRATION_ID2'
      '   , id'
      '   , merged_id'
      ' from int_classes'
      ' ) int_classes'
      ' where length(PLAN_INTEGRATION_ID2)<>36'
      ' or (length(calc_lec_ids)>2 and integration_id_LEC is null)'
      ' or (length(calc_gro_ids)>2 and integration_id_gro is null)'
      ' or (length(calc_rom_ids)>2 and integration_id_rom is null)'
      ' or (sub_id is not null and integration_id_sub is null)'
      ' or (for_id is not null and integration_id_for is null)'
      ' order by date_from')
    Left = 244
    Top = 348
  end
  object DSNotSent: TDataSource
    DataSet = QNotSent
    Left = 280
    Top = 344
  end
  object PPNotSent: TPopupMenu
    Left = 320
    Top = 352
    object MenuItem1: TMenuItem
      Caption = 'Eksportuj do Excela'
      ImageIndex = 16
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = 'Eksportuj do pliku'
      ImageIndex = 15
      OnClick = MenuItem2Click
    end
  end
end
