inherited FBrowseSPL_ITEMS: TFBrowseSPL_ITEMS
  Left = 413
  Top = 198
  Width = 1074
  Height = 717
  Caption = 'Plan studi'#243'w'
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  inherited Status: TPanel
    Top = 667
    Width = 1066
  end
  inherited MainPage: TPageControl
    Width = 1066
    Height = 667
    inherited Browse: TTabSheet
      object DetSplitter: TSplitter [0]
        Left = 725
        Top = 209
        Height = 371
        Align = alRight
      end
      inherited TopPanel: TPanel
        Width = 1058
        object BRecalc: TBitBtn
          Left = 926
          Top = 6
          Width = 129
          Height = 25
          Hint = 'Wyszukuje zaj'#281'cia pasuj'#261'ce do pozycji planu (okres, grupa, przedmiot, forma, wyk'#322'adowca) i oblicza zaplanowan'#261' liczb'#281' godzin'
          Caption = 'Przelicz'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 11
          OnClick = BRecalcClick
        end
      end
      inherited Grid: TRxDBGrid
        Top = 209
        Width = 725
        Height = 371
        Columns = <
          item
            Expanded = False
            FieldName = 'SORT_ORDER'
            Title.Caption = 'Kolejno'#347#263
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PER_NAME'
            Title.Caption = 'Okres'
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GRO_DSP'
            Title.Caption = 'Grupa'
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SUB_DSP'
            Title.Caption = 'Przedmiot'
            Width = 170
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FOR_DSP'
            Title.Caption = 'Forma'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LEC_DSP'
            Title.Caption = 'Wyk'#322'adowca'
            Width = 140
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PLANNED_HOURS'
            Title.Caption = 'Planowane'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SCHEDULED_HOURS'
            Title.Caption = 'Zaplanowane'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TO_SCHEDULE'
            Title.Caption = 'Do zaplanowania'
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESC1'
            Title.Caption = 'Uwagi'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RECALC_DATE'
            Title.Caption = 'Przeliczono'
            Width = 110
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATED_BY'
            Title.Caption = 'Utworzy'#322
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATION_DATE'
            Title.Caption = 'Data utworzenia'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATED_BY'
            Title.Caption = 'Zmieni'#322
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LAST_UPDATE_DATE'
            Title.Caption = 'Data zmiany'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'INTEGRATION_ID'
            Title.Caption = 'ID integracji'
            Width = 90
            Visible = True
          end>
      end
      inherited BottomPanel: TPanel
        Top = 599
        Width = 1058
      end
      inherited Panel: TPanel
        Top = 580
        Width = 1058
        inherited StatusBar: TStatusBar
          Width = 989
        end
      end
      inherited CustomPanel: TPanel
        Width = 1058
        Height = 100
        object LFltLec: TLabel
          Left = 8
          Top = 10
          Width = 70
          Height = 14
          Caption = 'Wyk'#322'adowca'
        end
        object FltLec: TEdit
          Tag = 1
          Left = 88
          Top = 6
          Width = 30
          Height = 22
          TabOrder = 0
          Visible = False
          OnChange = FltChange
        end
        object FltLecValue: TEdit
          Tag = 1
          Left = 88
          Top = 6
          Width = 263
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = BFltSelClick
        end
        object BFltLecClear: TBitBtn
          Tag = 1
          Left = 321
          Top = 6
          Width = 30
          Height = 22
          Hint = 'Wyczy'#347#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = BFltClearClick
          Glyph.Data = {
            9E020000424D9E0200000000000036000000280000000E0000000E0000000100
            18000000000068020000C40E0000C40E00000000000000000000F0F0F0EFEFEE
            F6F6F6E7E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEF
            EEF0F0F00000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99908A978E
            88948B859D958FD5D2D1F6F6F7EFEEEE0000F5F6F6D5D2D0948A84978E889990
            8A99918B99908A99908A99918B99908A978E88948A84D5D2D0F5F6F60000E7E5
            E59D948E978E88978E889D958F998F8999908A99908A998F899D958F978E8897
            8E889D948EE7E5E50000BFBAB7948B8499908A9D958FF3F2F1D4D0CE92888192
            8881D4D0CEF3F2F19D958F99908A948B84BFBAB70000A49D97978E889A918B98
            8F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E88A49D97
            00009A918B99908A99908A99908A928882CDC9C6FFFFFFFFFFFFCDC9C6928882
            99908A99908A99908A9A918B00009A918B99908A99908A99908A928882CDC9C6
            FFFFFFFFFFFFCDC9C692888299908A99908A99908A9A918B0000A49D97978E88
            9A918B988F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E
            88A49D970000BFBAB7948B8499908A9D958FF3F2F1D4D0CE928881928881D4D0
            CEF3F2F19D958F99908A948B84BFBAB70000E7E5E59D948E978E88978E889D95
            8F998F8999908A99908A998F899D958F978E88978E889D948EE7E5E50000F5F6
            F6D5D2D0948A84978E8899908A99918B99908A99908A99918B99908A978E8894
            8A84D5D2D0F5F6F60000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99
            908A978E88948B859D958FD5D2D1F6F6F7EFEEEE0000F0F0F0EFEFEEF6F6F6E7
            E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEFEEF0F0F0
            0000}
        end
        object LFltGro: TLabel
          Left = 8
          Top = 36
          Width = 70
          Height = 14
          Caption = 'Grupa'
        end
        object FltGro: TEdit
          Tag = 2
          Left = 88
          Top = 32
          Width = 30
          Height = 22
          TabOrder = 4
          Visible = False
          OnChange = FltChange
        end
        object FltGroValue: TEdit
          Tag = 2
          Left = 88
          Top = 32
          Width = 263
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = BFltSelClick
        end
        object BFltGroClear: TBitBtn
          Tag = 2
          Left = 321
          Top = 32
          Width = 30
          Height = 22
          Hint = 'Wyczy'#347#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = BFltClearClick
          Glyph.Data = {
            9E020000424D9E0200000000000036000000280000000E0000000E0000000100
            18000000000068020000C40E0000C40E00000000000000000000F0F0F0EFEFEE
            F6F6F6E7E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEF
            EEF0F0F00000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99908A978E
            88948B859D958FD5D2D1F6F6F7EFEEEE0000F5F6F6D5D2D0948A84978E889990
            8A99918B99908A99908A99918B99908A978E88948A84D5D2D0F5F6F60000E7E5
            E59D948E978E88978E889D958F998F8999908A99908A998F899D958F978E8897
            8E889D948EE7E5E50000BFBAB7948B8499908A9D958FF3F2F1D4D0CE92888192
            8881D4D0CEF3F2F19D958F99908A948B84BFBAB70000A49D97978E889A918B98
            8F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E88A49D97
            00009A918B99908A99908A99908A928882CDC9C6FFFFFFFFFFFFCDC9C6928882
            99908A99908A99908A9A918B00009A918B99908A99908A99908A928882CDC9C6
            FFFFFFFFFFFFCDC9C692888299908A99908A99908A9A918B0000A49D97978E88
            9A918B988F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E
            88A49D970000BFBAB7948B8499908A9D958FF3F2F1D4D0CE928881928881D4D0
            CEF3F2F19D958F99908A948B84BFBAB70000E7E5E59D948E978E88978E889D95
            8F998F8999908A99908A998F899D958F978E88978E889D948EE7E5E50000F5F6
            F6D5D2D0948A84978E8899908A99918B99908A99908A99918B99908A978E8894
            8A84D5D2D0F5F6F60000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99
            908A978E88948B859D958FD5D2D1F6F6F7EFEEEE0000F0F0F0EFEFEEF6F6F6E7
            E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEFEEF0F0F0
            0000}
        end
        object LFltRom: TLabel
          Left = 8
          Top = 62
          Width = 70
          Height = 14
          Caption = 'Sala'
        end
        object FltRom: TEdit
          Tag = 3
          Left = 88
          Top = 58
          Width = 30
          Height = 22
          TabOrder = 8
          Visible = False
          OnChange = FltChange
        end
        object FltRomValue: TEdit
          Tag = 3
          Left = 88
          Top = 58
          Width = 263
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
          OnClick = BFltSelClick
        end
        object BFltRomClear: TBitBtn
          Tag = 3
          Left = 321
          Top = 58
          Width = 30
          Height = 22
          Hint = 'Wyczy'#347#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 11
          OnClick = BFltClearClick
          Glyph.Data = {
            9E020000424D9E0200000000000036000000280000000E0000000E0000000100
            18000000000068020000C40E0000C40E00000000000000000000F0F0F0EFEFEE
            F6F6F6E7E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEF
            EEF0F0F00000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99908A978E
            88948B859D958FD5D2D1F6F6F7EFEEEE0000F5F6F6D5D2D0948A84978E889990
            8A99918B99908A99908A99918B99908A978E88948A84D5D2D0F5F6F60000E7E5
            E59D948E978E88978E889D958F998F8999908A99908A998F899D958F978E8897
            8E889D948EE7E5E50000BFBAB7948B8499908A9D958FF3F2F1D4D0CE92888192
            8881D4D0CEF3F2F19D958F99908A948B84BFBAB70000A49D97978E889A918B98
            8F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E88A49D97
            00009A918B99908A99908A99908A928882CDC9C6FFFFFFFFFFFFCDC9C6928882
            99908A99908A99908A9A918B00009A918B99908A99908A99908A928882CDC9C6
            FFFFFFFFFFFFCDC9C692888299908A99908A99908A9A918B0000A49D97978E88
            9A918B988F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E
            88A49D970000BFBAB7948B8499908A9D958FF3F2F1D4D0CE928881928881D4D0
            CEF3F2F19D958F99908A948B84BFBAB70000E7E5E59D948E978E88978E889D95
            8F998F8999908A99908A998F899D958F978E88978E889D948EE7E5E50000F5F6
            F6D5D2D0948A84978E8899908A99918B99908A99908A99918B99908A978E8894
            8A84D5D2D0F5F6F60000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99
            908A978E88948B859D958FD5D2D1F6F6F7EFEEEE0000F0F0F0EFEFEEF6F6F6E7
            E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEFEEF0F0F0
            0000}
        end
        object LFltSub: TLabel
          Left = 368
          Top = 10
          Width = 70
          Height = 14
          Caption = 'Przedmiot'
        end
        object FltSub: TEdit
          Tag = 4
          Left = 448
          Top = 6
          Width = 30
          Height = 22
          TabOrder = 12
          Visible = False
          OnChange = FltChange
        end
        object FltSubValue: TEdit
          Tag = 4
          Left = 448
          Top = 6
          Width = 263
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 13
          OnClick = BFltSelClick
        end
        object BFltSubClear: TBitBtn
          Tag = 4
          Left = 681
          Top = 6
          Width = 30
          Height = 22
          Hint = 'Wyczy'#347#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 15
          OnClick = BFltClearClick
          Glyph.Data = {
            9E020000424D9E0200000000000036000000280000000E0000000E0000000100
            18000000000068020000C40E0000C40E00000000000000000000F0F0F0EFEFEE
            F6F6F6E7E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEF
            EEF0F0F00000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99908A978E
            88948B859D958FD5D2D1F6F6F7EFEEEE0000F5F6F6D5D2D0948A84978E889990
            8A99918B99908A99908A99918B99908A978E88948A84D5D2D0F5F6F60000E7E5
            E59D948E978E88978E889D958F998F8999908A99908A998F899D958F978E8897
            8E889D948EE7E5E50000BFBAB7948B8499908A9D958FF3F2F1D4D0CE92888192
            8881D4D0CEF3F2F19D958F99908A948B84BFBAB70000A49D97978E889A918B98
            8F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E88A49D97
            00009A918B99908A99908A99908A928882CDC9C6FFFFFFFFFFFFCDC9C6928882
            99908A99908A99908A9A918B00009A918B99908A99908A99908A928882CDC9C6
            FFFFFFFFFFFFCDC9C692888299908A99908A99908A9A918B0000A49D97978E88
            9A918B988F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E
            88A49D970000BFBAB7948B8499908A9D958FF3F2F1D4D0CE928881928881D4D0
            CEF3F2F19D958F99908A948B84BFBAB70000E7E5E59D948E978E88978E889D95
            8F998F8999908A99908A998F899D958F978E88978E889D948EE7E5E50000F5F6
            F6D5D2D0948A84978E8899908A99918B99908A99908A99918B99908A978E8894
            8A84D5D2D0F5F6F60000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99
            908A978E88948B859D958FD5D2D1F6F6F7EFEEEE0000F0F0F0EFEFEEF6F6F6E7
            E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEFEEF0F0F0
            0000}
        end
        object LFltFor: TLabel
          Left = 368
          Top = 36
          Width = 70
          Height = 14
          Caption = 'Forma'
        end
        object FltFor: TEdit
          Tag = 5
          Left = 448
          Top = 32
          Width = 30
          Height = 22
          TabOrder = 16
          Visible = False
          OnChange = FltChange
        end
        object FltForValue: TEdit
          Tag = 5
          Left = 448
          Top = 32
          Width = 263
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 17
          OnClick = BFltSelClick
        end
        object BFltForClear: TBitBtn
          Tag = 5
          Left = 681
          Top = 32
          Width = 30
          Height = 22
          Hint = 'Wyczy'#347#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
          OnClick = BFltClearClick
          Glyph.Data = {
            9E020000424D9E0200000000000036000000280000000E0000000E0000000100
            18000000000068020000C40E0000C40E00000000000000000000F0F0F0EFEFEE
            F6F6F6E7E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEF
            EEF0F0F00000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99908A978E
            88948B859D958FD5D2D1F6F6F7EFEEEE0000F5F6F6D5D2D0948A84978E889990
            8A99918B99908A99908A99918B99908A978E88948A84D5D2D0F5F6F60000E7E5
            E59D948E978E88978E889D958F998F8999908A99908A998F899D958F978E8897
            8E889D948EE7E5E50000BFBAB7948B8499908A9D958FF3F2F1D4D0CE92888192
            8881D4D0CEF3F2F19D958F99908A948B84BFBAB70000A49D97978E889A918B98
            8F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E88A49D97
            00009A918B99908A99908A99908A928882CDC9C6FFFFFFFFFFFFCDC9C6928882
            99908A99908A99908A9A918B00009A918B99908A99908A99908A928882CDC9C6
            FFFFFFFFFFFFCDC9C692888299908A99908A99908A9A918B0000A49D97978E88
            9A918B988F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E
            88A49D970000BFBAB7948B8499908A9D958FF3F2F1D4D0CE928881928881D4D0
            CEF3F2F19D958F99908A948B84BFBAB70000E7E5E59D948E978E88978E889D95
            8F998F8999908A99908A998F899D958F978E88978E889D948EE7E5E50000F5F6
            F6D5D2D0948A84978E8899908A99918B99908A99908A99918B99908A978E8894
            8A84D5D2D0F5F6F60000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99
            908A978E88948B859D958FD5D2D1F6F6F7EFEEEE0000F0F0F0EFEFEEF6F6F6E7
            E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEFEEF0F0F0
            0000}
        end
        object LFltPer: TLabel
          Left = 368
          Top = 62
          Width = 70
          Height = 14
          Caption = 'Okres'
        end
        object FltPer: TEdit
          Tag = 6
          Left = 448
          Top = 58
          Width = 30
          Height = 22
          TabOrder = 20
          Visible = False
          OnChange = FltChange
        end
        object FltPerValue: TEdit
          Tag = 6
          Left = 448
          Top = 58
          Width = 263
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 21
          OnClick = BFltSelClick
        end
        object BFltPerClear: TBitBtn
          Tag = 6
          Left = 681
          Top = 58
          Width = 30
          Height = 22
          Hint = 'Wyczy'#347#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 23
          OnClick = BFltClearClick
          Glyph.Data = {
            9E020000424D9E0200000000000036000000280000000E0000000E0000000100
            18000000000068020000C40E0000C40E00000000000000000000F0F0F0EFEFEE
            F6F6F6E7E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEF
            EEF0F0F00000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99908A978E
            88948B859D958FD5D2D1F6F6F7EFEEEE0000F5F6F6D5D2D0948A84978E889990
            8A99918B99908A99908A99918B99908A978E88948A84D5D2D0F5F6F60000E7E5
            E59D948E978E88978E889D958F998F8999908A99908A998F899D958F978E8897
            8E889D948EE7E5E50000BFBAB7948B8499908A9D958FF3F2F1D4D0CE92888192
            8881D4D0CEF3F2F19D958F99908A948B84BFBAB70000A49D97978E889A918B98
            8F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E88A49D97
            00009A918B99908A99908A99908A928882CDC9C6FFFFFFFFFFFFCDC9C6928882
            99908A99908A99908A9A918B00009A918B99908A99908A99908A928882CDC9C6
            FFFFFFFFFFFFCDC9C692888299908A99908A99908A9A918B0000A49D97978E88
            9A918B988F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E
            88A49D970000BFBAB7948B8499908A9D958FF3F2F1D4D0CE928881928881D4D0
            CEF3F2F19D958F99908A948B84BFBAB70000E7E5E59D948E978E88978E889D95
            8F998F8999908A99908A998F899D958F978E88978E889D948EE7E5E50000F5F6
            F6D5D2D0948A84978E8899908A99918B99908A99908A99918B99908A978E8894
            8A84D5D2D0F5F6F60000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99
            908A978E88948B859D958FD5D2D1F6F6F7EFEEEE0000F0F0F0EFEFEEF6F6F6E7
            E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEFEEF0F0F0
            0000}
        end
        object CompareMode: TRadioGroup
          Left = 728
          Top = 2
          Width = 200
          Height = 74
          Caption = 'Por'#243'wnanie z rozk'#322'adem'
          ItemIndex = 0
          Items.Strings = (
            'Wszystkie'
            'Do zaplanowania')
          TabOrder = 24
          OnClick = CompareModeClick
        end
        object BCreatePlan: TBitBtn
          Left = 934
          Top = 6
          Width = 120
          Height = 25
          Hint = 'Tworzy plan grupy na podstawie zaj'#281#263' (okres i grupa: sk'#261'd i dok'#261'd)'
          Caption = 'Utw'#243'rz plan z zaj'#281#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 25
          OnClick = BCreatePlanClick
        end
        object BDeleteShown: TBitBtn
          Left = 934
          Top = 36
          Width = 120
          Height = 25
          Hint = 'Kasuje wszystkie pozycje widoczne na li'#347'cie (zgodne z filtrami i wyszukiwaniem), np. plan wybranej grupy'
          Caption = 'Skasuj wy'#347'wietlane'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 26
          OnClick = BDeleteShownClick
        end
      end
      inherited SecondRatePanel: TPanel
        Width = 1058
      end
      object DetPanel: TPanel
        Left = 728
        Top = 209
        Width = 330
        Height = 371
        Align = alRight
        TabOrder = 6
        object LDetails: TPanel
          Left = 1
          Top = 1
          Width = 328
          Height = 24
          Align = alTop
          Caption = 'Powi'#261'zane zaj'#281'cia'
          TabOrder = 0
        end
        object GridClasses: TDBGrid
          Left = 1
          Top = 25
          Width = 328
          Height = 345
          Align = alClient
          DataSource = DSClasses
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = EASTEUROPE_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'DAY'
              Title.Caption = 'Dzie'#324
              Width = 70
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'HOUR_FROM'
              Title.Caption = 'Od'
              Width = 40
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'HOUR_TO'
              Title.Caption = 'Do'
              Width = 40
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'HOURS'
              Title.Caption = 'Godz.'
              Width = 40
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CALC_LECTURERS'
              Title.Caption = 'Wyk'#322'adowcy'
              Width = 120
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CALC_GROUPS'
              Title.Caption = 'Grupy'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CALC_ROOMS'
              Title.Caption = 'Sale'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESC1'
              Title.Caption = 'Info dla planist'#243'w'
              Width = 120
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESC2'
              Title.Caption = 'Info dla student'#243'w'
              Width = 120
              Visible = True
            end>
        end
      end
    end
    inherited Update: TTabSheet
      inherited UpdPanel: TPanel
        Top = 603
        Width = 1058
      end
      inherited FlexPanel: TPanel
        Top = 220
        Width = 1058
        Height = 320
        Align = alTop
      end
      object EditPanel: TPanel
        Left = 0
        Top = 0
        Width = 1058
        Height = 220
        Align = alTop
        TabOrder = 2
        object LPER: TLabel
          Left = 8
          Top = 12
          Width = 150
          Height = 14
          Caption = 'Okres'
        end
        object PER_ID: TDBEdit
          Tag = 6
          Left = 170
          Top = 8
          Width = 40
          Height = 22
          DataField = 'PER_ID'
          DataSource = Source
          TabOrder = 0
          Visible = False
          OnChange = EditIdChange
        end
        object PER_VALUE: TEdit
          Tag = 6
          Left = 170
          Top = 8
          Width = 381
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = BEditSelClick
        end
        object LGRO: TLabel
          Left = 8
          Top = 40
          Width = 150
          Height = 14
          Caption = 'Grupa'
        end
        object GRO_ID: TDBEdit
          Tag = 2
          Left = 170
          Top = 36
          Width = 40
          Height = 22
          DataField = 'GRO_ID'
          DataSource = Source
          TabOrder = 4
          Visible = False
          OnChange = EditIdChange
        end
        object GRO_VALUE: TEdit
          Tag = 2
          Left = 170
          Top = 36
          Width = 381
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = BEditSelClick
        end
        object LSUB: TLabel
          Left = 8
          Top = 68
          Width = 150
          Height = 14
          Caption = 'Przedmiot'
        end
        object SUB_ID: TDBEdit
          Tag = 4
          Left = 170
          Top = 64
          Width = 40
          Height = 22
          DataField = 'SUB_ID'
          DataSource = Source
          TabOrder = 8
          Visible = False
          OnChange = EditIdChange
        end
        object SUB_VALUE: TEdit
          Tag = 4
          Left = 170
          Top = 64
          Width = 381
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
          OnClick = BEditSelClick
        end
        object LFOR: TLabel
          Left = 8
          Top = 96
          Width = 150
          Height = 14
          Caption = 'Forma'
        end
        object FOR_ID: TDBEdit
          Tag = 5
          Left = 170
          Top = 92
          Width = 40
          Height = 22
          DataField = 'FOR_ID'
          DataSource = Source
          TabOrder = 12
          Visible = False
          OnChange = EditIdChange
        end
        object FOR_VALUE: TEdit
          Tag = 5
          Left = 170
          Top = 92
          Width = 381
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 13
          OnClick = BEditSelClick
        end
        object LLEC: TLabel
          Left = 8
          Top = 124
          Width = 150
          Height = 14
          Caption = 'Wyk'#322'adowca (opcjonalnie)'
        end
        object LEC_ID: TDBEdit
          Tag = 1
          Left = 170
          Top = 120
          Width = 40
          Height = 22
          DataField = 'LEC_ID'
          DataSource = Source
          TabOrder = 16
          Visible = False
          OnChange = EditIdChange
        end
        object LEC_VALUE: TEdit
          Tag = 1
          Left = 170
          Top = 120
          Width = 381
          Height = 22
          Color = clWindow
          ReadOnly = True
          Cursor = crHandPoint
          Hint = 'Kliknij, aby wybra'#263' z listy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 17
          OnClick = BEditSelClick
        end
        object BLECClear: TBitBtn
          Tag = 1
          Left = 553
          Top = 120
          Width = 30
          Height = 22
          Hint = 'Wyczy'#347#263
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
          OnClick = BLecClearClick
          Glyph.Data = {
            9E020000424D9E0200000000000036000000280000000E0000000E0000000100
            18000000000068020000C40E0000C40E00000000000000000000F0F0F0EFEFEE
            F6F6F6E7E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEF
            EEF0F0F00000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99908A978E
            88948B859D958FD5D2D1F6F6F7EFEEEE0000F5F6F6D5D2D0948A84978E889990
            8A99918B99908A99908A99918B99908A978E88948A84D5D2D0F5F6F60000E7E5
            E59D948E978E88978E889D958F998F8999908A99908A998F899D958F978E8897
            8E889D948EE7E5E50000BFBAB7948B8499908A9D958FF3F2F1D4D0CE92888192
            8881D4D0CEF3F2F19D958F99908A948B84BFBAB70000A49D97978E889A918B98
            8F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E88A49D97
            00009A918B99908A99908A99908A928882CDC9C6FFFFFFFFFFFFCDC9C6928882
            99908A99908A99908A9A918B00009A918B99908A99908A99908A928882CDC9C6
            FFFFFFFFFFFFCDC9C692888299908A99908A99908A9A918B0000A49D97978E88
            9A918B988F89D4D0CEFFFFFFCDC9C6CDC9C6FFFFFFD4D0CE988F899A918B978E
            88A49D970000BFBAB7948B8499908A9D958FF3F2F1D4D0CE928881928881D4D0
            CEF3F2F19D958F99908A948B84BFBAB70000E7E5E59D948E978E88978E889D95
            8F998F8999908A99908A998F899D958F978E88978E889D948EE7E5E50000F5F6
            F6D5D2D0948A84978E8899908A99918B99908A99908A99918B99908A978E8894
            8A84D5D2D0F5F6F60000EFEEEEF6F6F7D5D2D19D958F948B85978E8899908A99
            908A978E88948B859D958FD5D2D1F6F6F7EFEEEE0000F0F0F0EFEFEEF6F6F6E7
            E6E5BFBAB7A49C979A918B9A918BA49C97BFBAB7E7E6E5F6F6F6EFEFEEF0F0F0
            0000}
        end
        object LPLANNED_HOURS: TLabel
          Left = 8
          Top = 152
          Width = 150
          Height = 14
          Caption = 'Planowana liczba godzin'
        end
        object PLANNED_HOURS: TDBEdit
          Left = 170
          Top = 148
          Width = 80
          Height = 22
          DataField = 'PLANNED_HOURS'
          DataSource = Source
          TabOrder = 20
        end
        object LSCHEDULED_HOURS: TLabel
          Left = 270
          Top = 152
          Width = 120
          Height = 14
          Caption = 'Zaplanowano godzin'
        end
        object SCHEDULED_HOURS: TDBEdit
          Left = 400
          Top = 148
          Width = 80
          Height = 22
          Color = clBtnFace
          DataField = 'SCHEDULED_HOURS'
          DataSource = Source
          ReadOnly = True
          TabOrder = 21
        end
        object LSORT_ORDER: TLabel
          Left = 500
          Top = 152
          Width = 55
          Height = 14
          Caption = 'Kolejno'#347#263
        end
        object SORT_ORDER: TDBEdit
          Left = 563
          Top = 148
          Width = 60
          Height = 22
          Hint = 'Kolejno'#347#263' pozycji w planie (domy'#347'lny porz'#261'dek sortowania)'
          DataField = 'SORT_ORDER'
          DataSource = Source
          ParentShowHint = False
          ShowHint = True
          TabOrder = 23
        end
        object LDESC1: TLabel
          Left = 8
          Top = 180
          Width = 150
          Height = 14
          Caption = 'Uwagi'
        end
        object DESC1: TDBEdit
          Left = 170
          Top = 176
          Width = 413
          Height = 22
          DataField = 'DESC1'
          DataSource = Source
          TabOrder = 22
        end
        object LINTEGRATION_ID: TLabel
          Left = 600
          Top = 180
          Width = 70
          Height = 14
          Caption = 'ID integracji'
        end
        object INTEGRATION_ID: TDBEdit
          Left = 680
          Top = 176
          Width = 150
          Height = 22
          Hint = 'Identyfikator pozycji w pliku Excel (Pobierz dane z programu Excel | Plan studi'#243'w) lub w innym systemie'
          DataField = 'INTEGRATION_ID'
          DataSource = Source
          ParentShowHint = False
          ShowHint = True
          TabOrder = 24
        end
      end
    end
  end
  inherited HolderSortOrder: TStrHolder
    Capacity = 8
    StrData = (
      ''
      
        '692e736f72745f6f726465722c207065722e6e616d652c2067726f2e61626272' +
        '6576696174696f6e2c207375622e6e616d652c2078666f722e6e616d657c4b6f' +
        '6c656a6e6f9ce67c43415445474f52593a44454641554c54'
      
        '7065722e6e616d652c2067726f2e616262726576696174696f6e2c207375622e' +
        '6e616d652c2078666f722e6e616d657c4f6b7265732c2067727570617c434154' +
        '45474f52593a44454641554c54'
      
        '67726f2e616262726576696174696f6e2c207375622e6e616d652c2078666f72' +
        '2e6e616d657c47727570617c43415445474f52593a44454641554c54'
      
        '7375622e6e616d652c2078666f722e6e616d652c2067726f2e61626272657669' +
        '6174696f6e7c50727a65646d696f747c43415445474f52593a44454641554c54'
      
        '6c65632e6c6173745f6e616d652c206c65632e66697273745f6e616d652c2073' +
        '75622e6e616d657c57796bb361646f7763617c43415445474f52593a44454641' +
        '554c54'
      
        '746f5f7363686564756c6520646573632c207375622e6e616d657c446f207a61' +
        '706c616e6f77616e69617c43415445474f52593a44454641554c54'
      
        '692e696420646573637c4f737461746e696f20646f64616e657c43415445474f' +
        '52593a44454641554c54')
  end
  inherited Query: TADOQuery
    CursorType = ctStatic
    AfterScroll = QueryAfterScroll
    SQL.Strings = (
      'select i.id'
      '     , i.per_id, i.gro_id, i.sub_id, i.for_id, i.lec_id'
      '     , per.name per_name'
      '     , gro.abbreviation gro_dsp'
      '     , sub.name sub_dsp'
      '     , xfor.name for_dsp'
      '     , lec.last_name||'' ''||lec.first_name lec_dsp'
      '     , i.planned_hours'
      '     , i.scheduled_hours'
      '     , greatest(i.planned_hours - i.scheduled_hours, 0) to_schedule'
      '     , i.sort_order'
      '     , i.integration_id'
      '     , i.desc1'
      '     , i.recalc_date'
      '     , i.created_by, i.creation_date, i.last_updated_by, i.last_update_date'
      '  from spl_items i, periods per, groups gro, subjects sub, forms xfor, lecturers lec'
      ' where per.id  = i.per_id'
      '   and gro.id  = i.gro_id'
      '   and sub.id  = i.sub_id'
      '   and xfor.id = i.for_id'
      '   and lec.id(+) = i.lec_id'
      '   and %CUSTOMCONDITIONALS'
      '   and %CONPERMISSIONS'
      '   and %CONDITIONALS AND %SEARCH'
      '%SORTORDER')
  end
  object QClasses: TADOQuery
    Connection = DModule.ADOConnection
    CursorLocation = clUseServer
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'item_id'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select c.cla_id'
      '     , c.hours'
      '     , cla.day'
      '     , grids.hour_from'
      '     , grids.hour_to'
      '     , cla.calc_lecturers'
      '     , cla.calc_groups'
      '     , cla.calc_rooms'
      '     , cla.desc1'
      '     , cla.desc2'
      '  from spl_item_cla c, classes cla, grids'
      ' where cla.id = c.cla_id'
      '   and grids.no = cla.hour'
      '   and c.item_id = :item_id'
      ' order by cla.day, cla.hour')
    Left = 724
    Top = 299
  end
  object DSClasses: TDataSource
    DataSet = QClasses
    Left = 764
    Top = 299
  end
  object TimerDetails: TTimer
    Interval = 300
    OnTimer = TimerDetailsTimer
    Left = 276
    Top = 294
  end
end
